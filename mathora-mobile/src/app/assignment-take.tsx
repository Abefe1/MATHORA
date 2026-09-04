import React, { useCallback, useEffect, useRef, useState } from 'react';
import { StyleSheet, Text, View, ScrollView, TouchableOpacity, SafeAreaView, ActivityIndicator } from 'react-native';
import { useRouter, useLocalSearchParams } from 'expo-router';
import { useTheme } from '@/hooks/use-theme';
import { useAuth } from '@/lib/authContext';
import { useCountdown } from '@/hooks/useCountdown';
import { useAppStateFocusGuard } from '@/hooks/useAppStateFocusGuard';
import { useBlockScreenCapture } from '@/hooks/useBlockScreenCapture';
import { MathView } from '@/components/math-view';
import {
  fetchAssignmentForTaking,
  startAssignmentAttempt,
  submitAssignmentAnswer,
  completeAssignmentSubmission,
  logFocusLossEvent,
  MobileQuestion,
} from '@/services/supabaseService';

type LoadState =
  | { phase: 'loading' }
  | { phase: 'blocked'; reason: string }
  | { phase: 'ready'; assignment: { id: string; title: string; due_date: string; duration_minutes: number | null }; questions: MobileQuestion[] }
  | { phase: 'error' };

const FOCUS_LOSS_DEBOUNCE_MS = 10_000;

export default function AssignmentTakeScreen() {
  const router = useRouter();
  const params = useLocalSearchParams<{ assignmentId: string }>();
  const colors = useTheme();
  const { user } = useAuth();

  const [state, setState] = useState<LoadState>({ phase: 'loading' });
  const [questionIndex, setQuestionIndex] = useState(0);
  const [selectedLetter, setSelectedLetter] = useState<string | null>(null);
  const [isAnswerSubmitted, setIsAnswerSubmitted] = useState(false);
  const [correctCount, setCorrectCount] = useState(0);
  const [completed, setCompleted] = useState(false);
  const [finalScore, setFinalScore] = useState<number | null>(null);
  const [totalSeconds, setTotalSeconds] = useState<number | null>(null);

  const lastFocusLossLoggedAt = useRef(0);

  // Same anti-leak measure the mock-exam screen already uses — this is
  // the stronger, genuinely-preventive control on Android (FLAG_SECURE);
  // no NoCopyGuard equivalent is needed here, that's a web-only concern
  // (browser text selection/copy).
  useBlockScreenCapture();

  useEffect(() => {
    if (!params.assignmentId || !user?.id) return;
    let cancelled = false;
    (async () => {
      const data = await fetchAssignmentForTaking(params.assignmentId);
      if (cancelled) return;
      if (!data) {
        setState({ phase: 'error' });
        return;
      }

      const pastDue = new Date(data.assignment.due_date).getTime() < Date.now();
      const attempt = await startAssignmentAttempt(params.assignmentId, user.id);
      if (cancelled) return;

      if (!attempt) {
        setState(
          pastDue
            ? { phase: 'blocked', reason: 'This assignment is past due and can no longer be started.' }
            : { phase: 'error' }
        );
        return;
      }

      if (data.assignment.duration_minutes != null) {
        const elapsed = Math.floor((Date.now() - new Date(attempt.started_at).getTime()) / 1000);
        setTotalSeconds(Math.max(0, data.assignment.duration_minutes * 60 - elapsed));
      }
      setState({ phase: 'ready', assignment: data.assignment, questions: data.questions });
    })();
    return () => {
      cancelled = true;
    };
  }, [params.assignmentId, user?.id]);

  const finishAssignment = useCallback(async () => {
    if (!user || !params.assignmentId) return;
    setCompleted(true);
    const result = await completeAssignmentSubmission({ assignmentId: params.assignmentId });
    if (result.success && result.score != null) {
      setFinalScore(result.score);
      if (result.correct != null) setCorrectCount(result.correct);
    }
  }, [params.assignmentId, user]);

  const handleExpire = useCallback(() => {
    if (state.phase !== 'ready' || completed) return;
    finishAssignment();
  }, [state, completed, finishAssignment]);

  const { secondsLeft, formatted } = useCountdown({
    totalSeconds,
    onExpire: handleExpire,
    active: state.phase === 'ready' && !completed,
  });

  useAppStateFocusGuard({
    enabled: state.phase === 'ready' && !completed,
    onFocusLoss: () => {
      const now = Date.now();
      if (now - lastFocusLossLoggedAt.current < FOCUS_LOSS_DEBOUNCE_MS) return;
      lastFocusLossLoggedAt.current = now;
      logFocusLossEvent(params.assignmentId);
    },
  });

  const styles = createStyles(colors);

  if (state.phase === 'loading') {
    return (
      <SafeAreaView style={[styles.container, styles.center]}>
        <ActivityIndicator color={colors.primary} />
      </SafeAreaView>
    );
  }

  if (state.phase === 'blocked' || state.phase === 'error') {
    return (
      <SafeAreaView style={styles.container}>
        <View style={styles.scrollContent}>
          <TouchableOpacity style={styles.backBtn} onPress={() => router.back()}>
            <Text style={styles.backText}>← Back</Text>
          </TouchableOpacity>
          <Text style={styles.errorText}>
            {state.phase === 'blocked' ? state.reason : 'Could not load this assignment.'}
          </Text>
        </View>
      </SafeAreaView>
    );
  }

  const { assignment, questions } = state;

  if (completed) {
    return (
      <SafeAreaView style={styles.container}>
        <View style={[styles.scrollContent, styles.center]}>
          <Text style={styles.resultTitle}>Assignment Complete</Text>
          <Text style={styles.resultScore}>{finalScore}%</Text>
          <Text style={styles.resultMeta}>{correctCount} of {questions.length} correct</Text>
          <TouchableOpacity onPress={() => router.replace('/assignments')}>
            <Text style={styles.linkText}>Back to Assignments</Text>
          </TouchableOpacity>
        </View>
      </SafeAreaView>
    );
  }

  if (questions.length === 0) {
    return (
      <SafeAreaView style={styles.container}>
        <View style={styles.scrollContent}>
          <Text style={styles.errorText}>This assignment has no questions yet.</Text>
        </View>
      </SafeAreaView>
    );
  }

  const currentQuestion = questions[questionIndex];
  const isLastQuestion = questionIndex >= questions.length - 1;

  const handleSubmitAnswer = async () => {
    if (!selectedLetter || !user?.id) return;
    setIsAnswerSubmitted(true);
    const opt = currentQuestion.options.find((o) => o.letter === selectedLetter);
    const isCorrect = opt?.is_correct ?? false; // instant UI feedback only — the DB recomputes is_correct itself, never trusts this
    setCorrectCount((prev) => prev + (isCorrect ? 1 : 0));

    const payload = {
      student_id: user.id,
      assignment_id: assignment.id,
      question_id: currentQuestion.id,
      selected_option: selectedLetter,
      is_correct: isCorrect,
    };

    if (isLastQuestion) {
      // Awaited, not fire-and-forget — completeAssignmentSubmission
      // derives score from whatever assignment_answers rows exist at
      // that moment, so this one must land first.
      await submitAssignmentAnswer(payload);
      finishAssignment();
    } else {
      submitAssignmentAnswer(payload);
    }
  };

  const handleNext = () => {
    if (!isLastQuestion) {
      setQuestionIndex((prev) => prev + 1);
      setSelectedLetter(null);
      setIsAnswerSubmitted(false);
    }
  };

  return (
    <SafeAreaView style={styles.container}>
      <ScrollView contentContainerStyle={styles.scrollContent}>
        <View style={styles.headerRow}>
          <Text style={styles.title} numberOfLines={1}>{assignment.title}</Text>
          {secondsLeft != null && (
            <View style={[styles.timerBadge, secondsLeft <= 60 && styles.timerBadgeUrgent]}>
              <Text style={[styles.timerText, secondsLeft <= 60 && styles.timerTextUrgent]}>{formatted}</Text>
            </View>
          )}
        </View>

        <Text style={styles.progressText}>Question {questionIndex + 1} of {questions.length}</Text>
        <View style={styles.progressBar}>
          <View style={[styles.progressFill, { width: `${((questionIndex + 1) / questions.length) * 100}%` }]} />
        </View>

        <View style={styles.questionCard}>
          <MathView expression={currentQuestion.question_text} size="md" />

          <View style={{ marginTop: 14, gap: 10 }}>
            {currentQuestion.options.map((opt) => {
              const isSelected = selectedLetter === opt.letter;
              let bg: string = colors.surface;
              let border: string = colors.border;
              if (isSelected && !isAnswerSubmitted) border = colors.primary;
              if (isAnswerSubmitted) {
                if (opt.is_correct) {
                  bg = colors.successSurface;
                  border = colors.successBorder;
                } else if (isSelected) {
                  bg = colors.dangerSurface;
                  border = colors.dangerBorder;
                }
              }
              return (
                <TouchableOpacity
                  key={opt.letter}
                  disabled={isAnswerSubmitted}
                  onPress={() => setSelectedLetter(opt.letter)}
                  style={[styles.optionBtn, { backgroundColor: bg, borderColor: border }]}
                >
                  <View style={styles.optionLetterCircle}>
                    <Text style={styles.optionLetterCircleText}>{opt.letter}</Text>
                  </View>
                  <MathView expression={opt.text} size="sm" style={{ flex: 1 }} />
                </TouchableOpacity>
              );
            })}
          </View>

          <View style={styles.footerRow}>
            {!isAnswerSubmitted ? (
              <TouchableOpacity
                style={[styles.primaryBtn, !selectedLetter && styles.btnDisabled]}
                disabled={!selectedLetter}
                onPress={handleSubmitAnswer}
              >
                <Text style={styles.primaryBtnText}>Submit Answer</Text>
              </TouchableOpacity>
            ) : !isLastQuestion ? (
              <TouchableOpacity style={styles.primaryBtn} onPress={handleNext}>
                <Text style={styles.primaryBtnText}>Next Question →</Text>
              </TouchableOpacity>
            ) : (
              <Text style={styles.mutedText}>Finishing up…</Text>
            )}
          </View>
        </View>
      </ScrollView>
    </SafeAreaView>
  );
}

function createStyles(colors: ReturnType<typeof useTheme>) {
  return StyleSheet.create({
    container: { flex: 1, backgroundColor: colors.background },
    center: { alignItems: 'center', justifyContent: 'center' },
    scrollContent: { padding: 16, flexGrow: 1 },
    backBtn: { marginBottom: 12 },
    backText: { color: colors.primary, fontSize: 14, fontWeight: 'bold' },
    errorText: { color: colors.dangerText, fontSize: 13 },
    title: { color: colors.text, fontSize: 17, fontWeight: 'bold', flex: 1 },
    headerRow: { flexDirection: 'row', alignItems: 'center', gap: 10, marginBottom: 12 },
    timerBadge: { backgroundColor: colors.surfaceSecondary, borderRadius: 10, paddingHorizontal: 12, paddingVertical: 6 },
    timerBadgeUrgent: { backgroundColor: colors.dangerSurface },
    timerText: { color: colors.text, fontSize: 15, fontWeight: 'bold' },
    timerTextUrgent: { color: colors.dangerText },
    progressText: { color: colors.textMuted, fontSize: 11, marginBottom: 6 },
    progressBar: { height: 6, backgroundColor: colors.surfaceSecondary, borderRadius: 3, overflow: 'hidden', marginBottom: 16 },
    progressFill: { height: '100%', backgroundColor: colors.primary },
    questionCard: { backgroundColor: colors.surface, borderColor: colors.border, borderWidth: 1, borderRadius: 16, padding: 16 },
    optionBtn: { flexDirection: 'row', alignItems: 'center', gap: 10, borderWidth: 2, borderRadius: 12, padding: 12 },
    optionLetterCircle: { width: 26, height: 26, borderRadius: 8, borderWidth: 1, borderColor: colors.border, alignItems: 'center', justifyContent: 'center' },
    optionLetterCircleText: { color: colors.text, fontSize: 11, fontWeight: 'bold' },
    footerRow: { marginTop: 16, alignItems: 'flex-end' },
    primaryBtn: { backgroundColor: colors.primary, borderRadius: 10, paddingHorizontal: 20, paddingVertical: 12 },
    primaryBtnText: { color: '#FFFFFF', fontSize: 13, fontWeight: 'bold' },
    btnDisabled: { opacity: 0.4 },
    mutedText: { color: colors.textMuted, fontSize: 12 },
    resultTitle: { color: colors.text, fontSize: 20, fontWeight: 'bold' },
    resultScore: { color: colors.primary, fontSize: 44, fontWeight: 'bold', marginVertical: 12 },
    resultMeta: { color: colors.textMuted, fontSize: 13, marginBottom: 20 },
    linkText: { color: colors.primary, fontSize: 13, fontWeight: 'bold' },
  });
}
