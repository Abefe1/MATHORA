import React, { useEffect, useMemo, useState } from 'react';
import {
  StyleSheet,
  Text,
  View,
  ScrollView,
  TouchableOpacity,
  SafeAreaView,
  StatusBar,
  Modal,
  useColorScheme,
} from 'react-native';
import { useRouter, useLocalSearchParams } from 'expo-router';
import { useTheme } from '@/hooks/use-theme';
import { MathView } from '@/components/math-view';
import { useBlockScreenCapture } from '@/hooks/useBlockScreenCapture';
import { reportScreenshotAttempt } from '@/services/screenSecurity';
import { useAuth } from '@/lib/authContext';
import {
  getMobileTopics,
  fetchMobileQuestions,
  recordMobileAttempt,
  type MobileQuestion,
} from '@/services/supabaseService';
import type { Topic } from '@/services/dataService';

type MobileQuestionOption = MobileQuestion['options'][number];

// Real, Supabase-wired practice screen — this used to be entirely
// hardcoded mock UI (one fixed question, fake options). Mirrors
// mathora-web/src/app/student/practice/page.tsx's flow: pick a topic
// (via ?topicId= param, or default to the first topic), fetch its
// real questions, answer/submit/next, record each attempt.
export default function PracticeScreen() {
  const router = useRouter();
  const colors = useTheme();
  const scheme = useColorScheme();
  const styles = useMemo(() => createStyles(colors), [colors]);
  const { user } = useAuth();
  const { topicId: topicIdParam } = useLocalSearchParams<{ topicId?: string }>();
  useBlockScreenCapture({ onScreenshotDetected: () => reportScreenshotAttempt('practice') });

  const [currentTopic, setCurrentTopic] = useState<Topic | null>(null);
  const [questions, setQuestions] = useState<MobileQuestion[]>([]);
  const [loading, setLoading] = useState(true);
  const [questionIndex, setQuestionIndex] = useState(0);

  const [selectedOption, setSelectedOption] = useState<MobileQuestionOption | null>(null);
  const [isSubmitted, setIsSubmitted] = useState(false);
  const [showMistakeModal, setShowMistakeModal] = useState(false);

  useEffect(() => {
    getMobileTopics().then((data) => {
      const target = topicIdParam ? data.find((t) => t.id === topicIdParam) : data[0];
      const found = target ?? data[0] ?? null;
      setCurrentTopic(found);
      if (!found) setLoading(false); // no topics at all — nothing to fetch questions for
    });
  }, [topicIdParam]);

  useEffect(() => {
    if (!currentTopic) return;
    // Standard "load on selection change" effect — same justified
    // suppression used for this pattern elsewhere in the app (see
    // roster.tsx / activities.tsx).
    // eslint-disable-next-line react-hooks/set-state-in-effect
    setLoading(true);
    fetchMobileQuestions(currentTopic.id).then((data) => {
      setQuestions(data);
      setQuestionIndex(0);
      setSelectedOption(null);
      setIsSubmitted(false);
      setLoading(false);
    });
  }, [currentTopic]);

  const question = questions[questionIndex];

  const handleCheckAnswer = () => {
    if (!selectedOption || !question) return;
    setIsSubmitted(true);
    const isCorrect = selectedOption.is_correct;
    if (!isCorrect) setShowMistakeModal(true);

    if (user) {
      recordMobileAttempt({
        student_id: user.id,
        question_id: question.id,
        topic_id: question.topic_id,
        selected_option: selectedOption.letter,
        is_correct: isCorrect,
        time_taken_seconds: 30,
        rescue_mode_triggered: !isCorrect,
      });
    }
  };

  const handleNextQuestion = () => {
    setSelectedOption(null);
    setIsSubmitted(false);
    setShowMistakeModal(false);
    setQuestionIndex((prev) => Math.min(prev + 1, questions.length - 1));
  };

  return (
    <SafeAreaView style={styles.container}>
      <StatusBar barStyle={scheme === 'dark' ? 'light-content' : 'dark-content'} backgroundColor={colors.background} />
      <ScrollView contentContainerStyle={styles.scrollContent}>
        {/* Top Header */}
        <TouchableOpacity style={styles.backBtn} onPress={() => router.back()}>
          <Text style={styles.backText}>← {currentTopic?.title ?? 'Practice'}</Text>
        </TouchableOpacity>

        {loading ? (
          <Text style={styles.mutedText}>Loading practice questions…</Text>
        ) : !question ? (
          <View style={styles.emptyCard}>
            <Text style={styles.mutedText}>No published questions for this topic yet.</Text>
          </View>
        ) : (
          <>
            {/* Progress Counter */}
            <Text style={styles.questionIndexText}>
              Question {questionIndex + 1} of {questions.length}
            </Text>

            {/* Question */}
            <View style={styles.questionContainer}>
              <Text style={styles.solveLabelText}>Solve:</Text>
              <View style={styles.equationCard}>
                <MathView expression={question.question_text} size="md" textStyle={styles.equationText} />
              </View>
            </View>

            {/* Options */}
            <View style={styles.optionsList}>
              {question.options.map((opt) => {
                const isSelected = selectedOption?.letter === opt.letter;
                const isCorrect = opt.is_correct;

                return (
                  <TouchableOpacity
                    key={opt.letter}
                    style={[
                      styles.optionCard,
                      isSelected && !isSubmitted && styles.optionCardSelected,
                      isSubmitted && isSelected && isCorrect && styles.optionCardCorrect,
                      isSubmitted && isSelected && !isCorrect && styles.optionCardIncorrect,
                      isSubmitted && !isSelected && isCorrect && styles.optionCardCorrect,
                    ]}
                    onPress={() => {
                      if (!isSubmitted) setSelectedOption(opt);
                    }}
                    activeOpacity={0.85}
                    disabled={isSubmitted}
                  >
                    <View style={[styles.radioCircle, isSelected && styles.radioCircleSelected]}>
                      {isSelected && <View style={styles.radioInnerDot} />}
                    </View>
                    <MathView expression={opt.text} size="sm" style={{ flex: 1 }} textStyle={styles.optionText} />
                  </TouchableOpacity>
                );
              })}
            </View>

            {/* Action */}
            {!isSubmitted ? (
              <TouchableOpacity
                style={[styles.checkBtn, !selectedOption && styles.checkBtnDisabled]}
                onPress={handleCheckAnswer}
                disabled={!selectedOption}
                activeOpacity={0.85}
              >
                <Text style={styles.checkBtnText}>Check answer</Text>
              </TouchableOpacity>
            ) : (
              <View style={styles.submittedBox}>
                <TouchableOpacity
                  style={styles.nextQuestionBtn}
                  onPress={handleNextQuestion}
                  disabled={questionIndex >= questions.length - 1}
                >
                  <Text style={styles.nextQuestionBtnText}>
                    {questionIndex < questions.length - 1 ? 'Next Question →' : 'Topic Complete 🎉'}
                  </Text>
                </TouchableOpacity>
              </View>
            )}
          </>
        )}
      </ScrollView>

      {/* Mistake Analysis Modal */}
      <Modal visible={showMistakeModal} animationType="slide" transparent>
        <View style={styles.modalOverlay}>
          <View style={styles.modalContent}>
            <Text style={styles.mistakeHeaderTag}>MISTAKE ANALYSIS</Text>
            <Text style={styles.mistakeTitle}>Not quite.</Text>
            <Text style={styles.userAnswerText}>Your answer: {selectedOption?.text}</Text>

            <View style={styles.breakdownCard}>
              <Text style={styles.breakdownMath}>{question?.explanation}</Text>
            </View>

            {question?.exam_shortcut ? (
              <View style={styles.rememberCallout}>
                <Text style={styles.rememberTitle}>💡 Exam Shortcut</Text>
                <Text style={styles.rememberBody}>{question.exam_shortcut}</Text>
              </View>
            ) : null}

            <TouchableOpacity style={styles.trySimilarBtn} onPress={() => setShowMistakeModal(false)}>
              <Text style={styles.trySimilarBtnText}>Continue</Text>
            </TouchableOpacity>
          </View>
        </View>
      </Modal>
    </SafeAreaView>
  );
}

function createStyles(colors: ReturnType<typeof useTheme>) {
  return StyleSheet.create({
    container: {
      flex: 1,
      backgroundColor: colors.background,
    },
    scrollContent: {
      padding: 20,
      paddingBottom: 40,
    },
    backBtn: {
      marginBottom: 16,
    },
    backText: {
      color: colors.primary,
      fontSize: 15,
      fontWeight: '700',
    },
    mutedText: {
      color: colors.textMuted,
      fontSize: 13,
    },
    emptyCard: {
      backgroundColor: colors.surface,
      borderColor: colors.border,
      borderWidth: 1,
      borderRadius: 16,
      padding: 20,
      alignItems: 'center',
    },
    questionIndexText: {
      color: colors.textMuted,
      fontSize: 13,
      fontWeight: '600',
      marginBottom: 16,
    },
    questionContainer: {
      marginBottom: 24,
    },
    solveLabelText: {
      color: colors.textMuted,
      fontSize: 14,
      fontWeight: '600',
      marginBottom: 8,
    },
    equationCard: {
      backgroundColor: colors.surface,
      borderColor: colors.border,
      borderWidth: 1,
      borderRadius: 16,
      padding: 24,
      alignItems: 'center',
      shadowColor: '#0F172A',
      shadowOffset: { width: 0, height: 2 },
      shadowOpacity: 0.04,
      shadowRadius: 8,
    },
    equationText: {
      color: colors.text,
      fontSize: 20,
      fontWeight: '800',
      fontFamily: 'monospace',
      letterSpacing: 0.5,
      textAlign: 'center',
    },
    optionsList: {
      gap: 12,
      marginBottom: 28,
    },
    optionCard: {
      backgroundColor: colors.surface,
      borderColor: colors.border,
      borderWidth: 1,
      borderRadius: 12,
      padding: 16,
      flexDirection: 'row',
      alignItems: 'center',
      gap: 14,
      shadowColor: '#0F172A',
      shadowOffset: { width: 0, height: 1 },
      shadowOpacity: 0.03,
      shadowRadius: 4,
    },
    optionCardSelected: {
      borderColor: colors.primary,
      backgroundColor: colors.warningSurface,
    },
    optionCardCorrect: {
      borderColor: colors.successBorder,
      backgroundColor: colors.successSurface,
    },
    optionCardIncorrect: {
      borderColor: colors.dangerBorder,
      backgroundColor: colors.dangerSurface,
    },
    radioCircle: {
      width: 20,
      height: 20,
      borderRadius: 10,
      borderWidth: 2,
      borderColor: colors.textMuted,
      justifyContent: 'center',
      alignItems: 'center',
    },
    radioCircleSelected: {
      borderColor: colors.primary,
    },
    radioInnerDot: {
      width: 10,
      height: 10,
      borderRadius: 5,
      backgroundColor: '#F59E0B',
    },
    optionText: {
      color: colors.text,
      fontSize: 15,
      fontWeight: '600',
      flex: 1,
    },
    checkBtn: {
      backgroundColor: '#F59E0B',
      borderRadius: 10,
      paddingVertical: 16,
      alignItems: 'center',
    },
    checkBtnDisabled: {
      backgroundColor: colors.textMuted,
      opacity: 0.6,
    },
    checkBtnText: {
      color: '#090D16',
      fontSize: 16,
      fontWeight: '700',
    },
    submittedBox: {
      alignItems: 'center',
    },
    nextQuestionBtn: {
      backgroundColor: '#10B981',
      borderRadius: 10,
      paddingVertical: 16,
      paddingHorizontal: 24,
      alignItems: 'center',
      width: '100%',
    },
    nextQuestionBtnText: {
      color: '#FFFFFF',
      fontSize: 16,
      fontWeight: '700',
    },
    modalOverlay: {
      flex: 1,
      backgroundColor: '#00000088',
      justifyContent: 'flex-end',
    },
    modalContent: {
      backgroundColor: colors.surface,
      borderTopLeftRadius: 24,
      borderTopRightRadius: 24,
      padding: 24,
      borderTopWidth: 3,
      borderColor: colors.dangerBorder,
    },
    mistakeHeaderTag: {
      color: colors.dangerText,
      fontSize: 10,
      fontWeight: '800',
      letterSpacing: 1,
    },
    mistakeTitle: {
      color: colors.text,
      fontSize: 24,
      fontWeight: '800',
      marginTop: 4,
    },
    userAnswerText: {
      color: colors.dangerText,
      fontSize: 14,
      fontWeight: '600',
      marginTop: 4,
      marginBottom: 12,
    },
    breakdownCard: {
      backgroundColor: colors.background,
      borderColor: colors.border,
      borderWidth: 1,
      borderRadius: 12,
      padding: 14,
      marginBottom: 16,
    },
    breakdownMath: {
      color: colors.text,
      fontSize: 14,
      fontWeight: '600',
      lineHeight: 20,
    },
    rememberCallout: {
      backgroundColor: colors.warningSurface,
      borderColor: colors.warningBorder,
      borderWidth: 1,
      borderRadius: 12,
      padding: 14,
      marginBottom: 20,
    },
    rememberTitle: {
      color: colors.warningText,
      fontSize: 13,
      fontWeight: '700',
      marginBottom: 4,
    },
    rememberBody: {
      color: colors.warningText,
      fontSize: 13,
      lineHeight: 18,
    },
    trySimilarBtn: {
      backgroundColor: '#F59E0B',
      borderRadius: 10,
      paddingVertical: 14,
      alignItems: 'center',
    },
    trySimilarBtnText: {
      color: '#090D16',
      fontSize: 15,
      fontWeight: '700',
    },
  });
}
