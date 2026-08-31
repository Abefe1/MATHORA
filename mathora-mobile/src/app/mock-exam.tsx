import React, { useState, useEffect, useMemo } from 'react';
import {
  StyleSheet,
  Text,
  View,
  ScrollView,
  TouchableOpacity,
  SafeAreaView,
  StatusBar,
  useColorScheme,
} from 'react-native';
import { useRouter } from 'expo-router';
import { useTheme } from '@/hooks/use-theme';
import { MOCK_EXAMS_DATA, Question } from '@/services/dataService';
import { useBlockScreenCapture } from '@/hooks/useBlockScreenCapture';
import { reportScreenshotAttempt } from '@/services/screenSecurity';

export default function MockExamScreen() {
  const router = useRouter();
  const colors = useTheme();
  const scheme = useColorScheme();
  const styles = useMemo(() => createStyles(colors), [colors]);
  useBlockScreenCapture({ onScreenshotDetected: () => reportScreenshotAttempt('mock_exam') });
  const exam = MOCK_EXAMS_DATA[0];

  const [examStarted, setExamStarted] = useState(false);
  const [currentIdx, setCurrentIdx] = useState(0);
  const [selectedAnswers, setSelectedAnswers] = useState<Record<string, string>>({});
  const [timeLeft, setTimeLeft] = useState(exam.duration_minutes * 60);
  const [isCompleted, setIsCompleted] = useState(false);

  // Live Timer
  useEffect(() => {
    if (!examStarted || isCompleted) return;
    const timer = setInterval(() => {
      setTimeLeft((prev) => {
        if (prev <= 1) {
          clearInterval(timer);
          setIsCompleted(true);
          return 0;
        }
        return prev - 1;
      });
    }, 1000);
    return () => clearInterval(timer);
  }, [examStarted, isCompleted]);

  const formatTime = (seconds: number) => {
    const mins = Math.floor(seconds / 60);
    const secs = seconds % 60;
    return `${mins.toString().padStart(2, '0')}:${secs.toString().padStart(2, '0')}`;
  };

  const currentQ: Question = exam.questions[currentIdx];

  const handleSelectOption = (letter: string) => {
    if (isCompleted) return;
    setSelectedAnswers((prev) => ({
      ...prev,
      [currentQ.id]: letter,
    }));
  };

  const calculateScore = () => {
    let score = 0;
    exam.questions.forEach((q) => {
      const chosen = selectedAnswers[q.id];
      const correctOpt = q.options.find((o) => o.is_correct);
      if (chosen && correctOpt && chosen === correctOpt.letter) {
        score += 1;
      }
    });
    return score;
  };

  const scoreCount = calculateScore();
  const scorePercent = Math.round((scoreCount / exam.questions.length) * 100);

  const getWAECGrade = (pct: number) => {
    if (pct >= 75) return { grade: 'A1', label: 'EXCELLENT', color: '#10B981' };
    if (pct >= 65) return { grade: 'B2', label: 'VERY GOOD', color: '#06B6D4' };
    if (pct >= 50) return { grade: 'C4', label: 'CREDIT', color: '#F59E0B' };
    return { grade: 'F9', label: 'REMEDIAL NEEDED', color: '#EF4444' };
  };

  const gradeInfo = getWAECGrade(scorePercent);

  return (
    <SafeAreaView style={styles.container}>
      <StatusBar barStyle={scheme === 'dark' ? 'light-content' : 'dark-content'} backgroundColor={colors.background} />
      <ScrollView contentContainerStyle={styles.scrollContent}>
        <TouchableOpacity style={styles.backBtn} onPress={() => router.back()}>
          <Text style={styles.backText}>← Back to Dashboard</Text>
        </TouchableOpacity>

        {/* Not Started View */}
        {!examStarted && !isCompleted && (
          <View style={styles.startCard}>
            <Text style={styles.badgeText}>OFFICIAL TIMED SIMULATOR</Text>
            <Text style={styles.title}>{exam.title}</Text>
            <Text style={styles.subtitle}>{exam.description}</Text>

            <View style={styles.infoGrid}>
              <View style={styles.infoBox}>
                <Text style={styles.infoVal}>{exam.duration_minutes} Mins</Text>
                <Text style={styles.infoLbl}>Time Limit</Text>
              </View>
              <View style={styles.infoBox}>
                <Text style={styles.infoVal}>{exam.total_questions}</Text>
                <Text style={styles.infoLbl}>Questions</Text>
              </View>
              <View style={styles.infoBox}>
                <Text style={styles.infoValGold}>WAEC</Text>
                <Text style={styles.infoLbl}>Standard</Text>
              </View>
            </View>

            <TouchableOpacity
              style={styles.startExamBtn}
              onPress={() => setExamStarted(true)}
              activeOpacity={0.8}
            >
              <Text style={styles.startExamBtnText}>🚀 Start Timed Mock Exam</Text>
            </TouchableOpacity>
          </View>
        )}

        {/* Active Exam Mode */}
        {examStarted && !isCompleted && (
          <View>
            {/* Timer Banner */}
            <View style={styles.timerRow}>
              <View>
                <Text style={styles.questionIndexText}>
                  Question {currentIdx + 1} of {exam.questions.length}
                </Text>
                <Text style={styles.examTag}>{exam.exam_type} SSCE SIMULATOR</Text>
              </View>

              <View style={[styles.timerBadge, timeLeft < 300 && styles.timerBadgeWarning]}>
                <Text style={styles.timerText}>⏳ {formatTime(timeLeft)}</Text>
              </View>
            </View>

            {/* Question Navigator Palette */}
            <View style={styles.paletteRow}>
              {exam.questions.map((q, idx) => {
                const isAnswered = !!selectedAnswers[q.id];
                const isCurrent = idx === currentIdx;
                return (
                  <TouchableOpacity
                    key={q.id}
                    style={[
                      styles.paletteChip,
                      isAnswered && styles.paletteAnswered,
                      isCurrent && styles.paletteCurrent,
                    ]}
                    onPress={() => setCurrentIdx(idx)}
                  >
                    <Text
                      style={[
                        styles.paletteText,
                        isAnswered && styles.paletteTextAnswered,
                        isCurrent && styles.paletteTextCurrent,
                      ]}
                    >
                      {idx + 1}
                    </Text>
                  </TouchableOpacity>
                );
              })}
            </View>

            {/* Question Card */}
            <View style={styles.questionCard}>
              <Text style={styles.questionText}>{currentQ.question_text}</Text>
            </View>

            {/* Options */}
            {currentQ.options.map((opt) => {
              const isSelected = selectedAnswers[currentQ.id] === opt.letter;
              return (
                <TouchableOpacity
                  key={opt.letter}
                  style={[styles.optionCard, isSelected && styles.optionSelected]}
                  onPress={() => handleSelectOption(opt.letter)}
                  activeOpacity={0.8}
                >
                  <Text style={[styles.optionLetter, isSelected && styles.optionLetterSelected]}>
                    {opt.letter}
                  </Text>
                  <Text style={styles.optionText}>{opt.text}</Text>
                </TouchableOpacity>
              );
            })}

            {/* Navigation Buttons */}
            <View style={styles.navBtnRow}>
              {currentIdx > 0 && (
                <TouchableOpacity
                  style={styles.prevBtn}
                  onPress={() => setCurrentIdx((prev) => prev - 1)}
                >
                  <Text style={styles.prevBtnText}>← Previous</Text>
                </TouchableOpacity>
              )}

              {currentIdx < exam.questions.length - 1 ? (
                <TouchableOpacity
                  style={styles.nextBtn}
                  onPress={() => setCurrentIdx((prev) => prev + 1)}
                >
                  <Text style={styles.nextBtnText}>Next Question →</Text>
                </TouchableOpacity>
              ) : (
                <TouchableOpacity
                  style={styles.finishBtn}
                  onPress={() => setIsCompleted(true)}
                >
                  <Text style={styles.finishBtnText}>Submit Exam</Text>
                </TouchableOpacity>
              )}
            </View>
          </View>
        )}

        {/* Results Screen */}
        {isCompleted && (
          <View style={styles.resultCard}>
            <Text style={styles.resultHeader}>EXAM RESULT REPORT</Text>
            <Text style={styles.resultTitle}>{exam.title}</Text>

            <View style={styles.gradeCircle}>
              <Text style={[styles.gradeText, { color: gradeInfo.color }]}>{gradeInfo.grade}</Text>
              <Text style={styles.gradeLabel}>{gradeInfo.label}</Text>
            </View>

            <View style={styles.scoreSummaryGrid}>
              <View style={styles.summaryBox}>
                <Text style={styles.summaryVal}>{scorePercent}%</Text>
                <Text style={styles.summaryLbl}>Final Score</Text>
              </View>
              <View style={styles.summaryBox}>
                <Text style={styles.summaryVal}>
                  {scoreCount} / {exam.questions.length}
                </Text>
                <Text style={styles.summaryLbl}>Correct Answers</Text>
              </View>
            </View>

            <TouchableOpacity
              style={styles.retryBtn}
              onPress={() => {
                setExamStarted(false);
                setIsCompleted(false);
                setCurrentIdx(0);
                setSelectedAnswers({});
                setTimeLeft(exam.duration_minutes * 60);
              }}
            >
              <Text style={styles.retryBtnText}>Retake Mock Exam</Text>
            </TouchableOpacity>

            <TouchableOpacity
              style={styles.analysisBtn}
              onPress={() => router.push('/struggling-analysis')}
            >
              <Text style={styles.analysisBtnText}>View Misconception Analysis →</Text>
            </TouchableOpacity>
          </View>
        )}
      </ScrollView>
    </SafeAreaView>
  );
}

function createStyles(colors: ReturnType<typeof useTheme>) {
  return StyleSheet.create({
    container: { flex: 1, backgroundColor: colors.background },
    scrollContent: { padding: 16 },
    backBtn: { marginBottom: 12 },
    backText: { color: colors.primary, fontSize: 14, fontWeight: 'bold' },
    startCard: {
      // Fixed navy highlight card — see index.tsx's parentBanner note.
      backgroundColor: '#1E1B4B',
      borderColor: '#4338CA',
      borderWidth: 1,
      borderRadius: 20,
      padding: 20,
    },
    badgeText: { color: '#F59E0B', fontSize: 10, fontWeight: 'bold', letterSpacing: 1 },
    title: { color: '#FFFFFF', fontSize: 24, fontWeight: 'bold', marginTop: 4 },
    subtitle: { color: '#C7D2FE', fontSize: 13, marginTop: 4, lineHeight: 18 },
    infoGrid: { flexDirection: 'row', gap: 10, marginVertical: 18 },
    infoBox: { flex: 1, backgroundColor: '#0F172A', borderRadius: 12, padding: 12, alignItems: 'center' },
    infoVal: { color: '#06B6D4', fontSize: 16, fontWeight: 'bold' },
    infoValGold: { color: '#F59E0B', fontSize: 16, fontWeight: 'bold' },
    infoLbl: { color: '#94A3B8', fontSize: 11, marginTop: 2 },
    startExamBtn: { backgroundColor: '#F59E0B', borderRadius: 12, padding: 16, alignItems: 'center' },
    startExamBtnText: { color: '#090D16', fontSize: 16, fontWeight: 'bold' },
    timerRow: { flexDirection: 'row', justifyContent: 'space-between', alignItems: 'center', marginBottom: 14 },
    questionIndexText: { color: colors.text, fontSize: 16, fontWeight: 'bold' },
    examTag: { color: '#06B6D4', fontSize: 10, fontWeight: 'bold' },
    timerBadge: { backgroundColor: '#1E1B4B', borderColor: '#4338CA', borderWidth: 1, paddingHorizontal: 12, paddingVertical: 6, borderRadius: 10 },
    timerBadgeWarning: { backgroundColor: '#7F1D1D', borderColor: '#EF4444' },
    timerText: { color: '#FFFFFF', fontSize: 14, fontWeight: 'bold' },
    paletteRow: { flexDirection: 'row', gap: 6, marginBottom: 16, flexWrap: 'wrap' },
    paletteChip: { width: 32, height: 32, borderRadius: 16, backgroundColor: colors.surface, justifyContent: 'center', alignItems: 'center', borderColor: colors.border, borderWidth: 1 },
    paletteAnswered: { backgroundColor: '#1E1B4B', borderColor: '#4338CA' },
    paletteCurrent: { borderColor: '#F59E0B', borderWidth: 2 },
    paletteText: { color: colors.textMuted, fontSize: 12, fontWeight: 'bold' },
    paletteTextAnswered: { color: '#06B6D4' },
    paletteTextCurrent: { color: '#F59E0B' },
    questionCard: { backgroundColor: colors.surface, borderColor: colors.border, borderWidth: 1, borderRadius: 16, padding: 18, marginBottom: 16 },
    questionText: { color: colors.text, fontSize: 17, fontWeight: 'bold', lineHeight: 24 },
    optionCard: { backgroundColor: colors.surface, borderColor: colors.border, borderWidth: 1, borderRadius: 12, padding: 16, flexDirection: 'row', alignItems: 'center', marginBottom: 10 },
    optionSelected: { borderColor: '#F59E0B', backgroundColor: colors.warningSurface },
    optionLetter: { color: '#F59E0B', fontSize: 16, fontWeight: 'bold', width: 28 },
    optionLetterSelected: { color: '#F59E0B' },
    optionText: { color: colors.text, fontSize: 15, fontWeight: '500' },
    navBtnRow: { flexDirection: 'row', justifyContent: 'space-between', gap: 10, marginTop: 14 },
    prevBtn: { flex: 1, backgroundColor: colors.surfaceSecondary, borderRadius: 12, padding: 14, alignItems: 'center' },
    prevBtnText: { color: colors.textMuted, fontSize: 14, fontWeight: 'bold' },
    nextBtn: { flex: 1, backgroundColor: '#06B6D4', borderRadius: 12, padding: 14, alignItems: 'center' },
    nextBtnText: { color: '#090D16', fontSize: 14, fontWeight: 'bold' },
    finishBtn: { flex: 1, backgroundColor: '#10B981', borderRadius: 12, padding: 14, alignItems: 'center' },
    finishBtnText: { color: '#FFFFFF', fontSize: 14, fontWeight: 'bold' },
    resultCard: { backgroundColor: colors.surface, borderColor: colors.border, borderWidth: 1, borderRadius: 20, padding: 20, alignItems: 'center' },
    resultHeader: { color: '#F59E0B', fontSize: 10, fontWeight: 'bold', letterSpacing: 1 },
    resultTitle: { color: colors.text, fontSize: 20, fontWeight: 'bold', marginTop: 4, textAlign: 'center' },
    gradeCircle: { width: 100, height: 100, borderRadius: 50, backgroundColor: '#1E1B4B', justifyContent: 'center', alignItems: 'center', marginVertical: 18, borderColor: '#4338CA', borderWidth: 2 },
    gradeText: { fontSize: 32, fontWeight: 'bold' },
    gradeLabel: { color: '#94A3B8', fontSize: 9, fontWeight: 'bold', marginTop: 2 },
    scoreSummaryGrid: { flexDirection: 'row', gap: 12, width: '100%', marginBottom: 18 },
    summaryBox: { flex: 1, backgroundColor: colors.surfaceSecondary, borderRadius: 12, padding: 14, alignItems: 'center' },
    summaryVal: { color: '#F59E0B', fontSize: 20, fontWeight: 'bold' },
    summaryLbl: { color: colors.textMuted, fontSize: 11, marginTop: 2 },
    retryBtn: { backgroundColor: '#06B6D4', borderRadius: 12, padding: 14, width: '100%', alignItems: 'center', marginBottom: 10 },
    retryBtnText: { color: '#090D16', fontSize: 15, fontWeight: 'bold' },
    analysisBtn: { backgroundColor: '#1E1B4B', borderColor: '#4338CA', borderWidth: 1, borderRadius: 12, padding: 14, width: '100%', alignItems: 'center' },
    analysisBtnText: { color: '#C7D2FE', fontSize: 14, fontWeight: 'bold' },
  });
}
