import React, { useState } from 'react';
import {
  StyleSheet,
  Text,
  View,
  ScrollView,
  TouchableOpacity,
  SafeAreaView,
  StatusBar,
  Modal,
} from 'react-native';
import { useRouter } from 'expo-router';
import { useBlockScreenCapture } from '@/hooks/useBlockScreenCapture';
import { reportScreenshotAttempt } from '@/services/screenSecurity';

export default function PracticeScreen() {
  const router = useRouter();
  useBlockScreenCapture({ onScreenshotDetected: () => reportScreenshotAttempt('practice') });

  const [selectedOption, setSelectedOption] = useState<string | null>(null);
  const [isSubmitted, setIsSubmitted] = useState(false);
  const [showMistakeModal, setShowMistakeModal] = useState(false);

  const question = {
    title: 'Quadratic Equations',
    index: 4,
    total: 10,
    equation: 'x² - 5x + 6 = 0',
    options: [
      { id: 'opt-a', letter: 'A', text: 'x = 2 or x = 3', isCorrect: true },
      { id: 'opt-b', letter: 'B', text: 'x = -2 or x = -3', isCorrect: false },
      { id: 'opt-c', letter: 'C', text: 'x = 1 or x = 6', isCorrect: false },
      { id: 'opt-d', letter: 'D', text: 'x = -1 or x = -6', isCorrect: false },
    ],
  };

  const handleCheckAnswer = () => {
    if (!selectedOption) return;
    setIsSubmitted(true);
    const chosen = question.options.find((o) => o.id === selectedOption);
    if (!chosen?.isCorrect) {
      setShowMistakeModal(true);
    }
  };

  return (
    <SafeAreaView style={styles.container}>
      <StatusBar barStyle="dark-content" backgroundColor="#F8FAFC" />
      <ScrollView contentContainerStyle={styles.scrollContent}>
        {/* Top Header */}
        <TouchableOpacity style={styles.backBtn} onPress={() => router.back()}>
          <Text style={styles.backText}>← {question.title}</Text>
        </TouchableOpacity>

        {/* Progress Counter */}
        <Text style={styles.questionIndexText}>Question {question.index} of {question.total}</Text>

        {/* Question Area with Generous Whitespace & Crisp Typography */}
        <View style={styles.questionContainer}>
          <Text style={styles.solveLabelText}>Solve:</Text>
          <View style={styles.equationCard}>
            <Text style={styles.equationText}>{question.equation}</Text>
          </View>
        </View>

        {/* Radio Option Choices */}
        <View style={styles.optionsList}>
          {question.options.map((opt) => {
            const isSelected = selectedOption === opt.id;
            const isCorrect = opt.isCorrect;

            return (
              <TouchableOpacity
                key={opt.id}
                style={[
                  styles.optionCard,
                  isSelected && styles.optionCardSelected,
                  isSubmitted && isSelected && isCorrect && styles.optionCardCorrect,
                  isSubmitted && isSelected && !isCorrect && styles.optionCardIncorrect,
                ]}
                onPress={() => {
                  if (!isSubmitted) setSelectedOption(opt.id);
                }}
                activeOpacity={0.85}
              >
                <View style={[styles.radioCircle, isSelected && styles.radioCircleSelected]}>
                  {isSelected && <View style={styles.radioInnerDot} />}
                </View>
                <Text style={styles.optionText}>{opt.text}</Text>
              </TouchableOpacity>
            );
          })}
        </View>

        {/* Check Answer Primary Action Button */}
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
              onPress={() => {
                setSelectedOption(null);
                setIsSubmitted(false);
              }}
            >
              <Text style={styles.nextQuestionBtnText}>Next Question →</Text>
            </TouchableOpacity>
          </View>
        )}
      </ScrollView>

      {/* Mistake Analysis Modal: "Let's find the mistake." */}
      <Modal visible={showMistakeModal} animationType="slide" transparent>
        <View style={styles.modalOverlay}>
          <View style={styles.modalContent}>
            <Text style={styles.mistakeHeaderTag}>MISTAKE ANALYSIS</Text>
            <Text style={styles.mistakeTitle}>Not quite.</Text>
            <Text style={styles.userAnswerText}>Your answer: x = -2, -3</Text>
            <Text style={styles.issueText}>The issue is the signs.</Text>

            {/* Explanation Breakdown */}
            <View style={styles.breakdownCard}>
              <Text style={styles.breakdownStep}>Remember:</Text>
              <Text style={styles.breakdownMath}>x² - 5x + 6 = (x - 2)(x - 3)</Text>
              <Text style={styles.breakdownStep}>So:</Text>
              <Text style={styles.breakdownMathBold}>x = 2  or  x = 3</Text>
            </View>

            {/* 💡 Remember Callout Box */}
            <View style={styles.rememberCallout}>
              <Text style={styles.rememberTitle}>💡 Remember</Text>
              <Text style={styles.rememberBody}>
                When multiplying two negative numbers, the result is positive. (-2) × (-3) = +6 while (-2) + (-3) = -5.
              </Text>
            </View>

            <TouchableOpacity
              style={styles.trySimilarBtn}
              onPress={() => {
                setShowMistakeModal(false);
                setSelectedOption(null);
                setIsSubmitted(false);
              }}
            >
              <Text style={styles.trySimilarBtnText}>Try a similar question</Text>
            </TouchableOpacity>
          </View>
        </View>
      </Modal>
    </SafeAreaView>
  );
}

const styles = StyleSheet.create({
  container: {
    flex: 1,
    backgroundColor: '#F8FAFC',
  },
  scrollContent: {
    padding: 20,
    paddingBottom: 40,
  },
  backBtn: {
    marginBottom: 16,
  },
  backText: {
    color: '#2563EB',
    fontSize: 15,
    fontWeight: '700',
  },
  questionIndexText: {
    color: '#64748B',
    fontSize: 13,
    fontWeight: '600',
    marginBottom: 16,
  },
  questionContainer: {
    marginBottom: 24,
  },
  solveLabelText: {
    color: '#64748B',
    fontSize: 14,
    fontWeight: '600',
    marginBottom: 8,
  },
  equationCard: {
    backgroundColor: '#FFFFFF',
    borderColor: '#E2E8F0',
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
    color: '#0F172A',
    fontSize: 26,
    fontWeight: '800',
    fontFamily: 'monospace',
    letterSpacing: 1,
  },
  optionsList: {
    gap: 12,
    marginBottom: 28,
  },
  optionCard: {
    backgroundColor: '#FFFFFF',
    borderColor: '#E2E8F0',
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
    borderColor: '#2563EB',
    backgroundColor: '#EFF6FF',
  },
  optionCardCorrect: {
    borderColor: '#10B981',
    backgroundColor: '#ECFDF5',
  },
  optionCardIncorrect: {
    borderColor: '#EF4444',
    backgroundColor: '#FEF2F2',
  },
  radioCircle: {
    width: 20,
    height: 20,
    borderRadius: 10,
    borderWidth: 2,
    borderColor: '#94A3B8',
    justifyContent: 'center',
    alignItems: 'center',
  },
  radioCircleSelected: {
    borderColor: '#2563EB',
  },
  radioInnerDot: {
    width: 10,
    height: 10,
    borderRadius: 5,
    backgroundColor: '#2563EB',
  },
  optionText: {
    color: '#0F172A',
    fontSize: 16,
    fontWeight: '600',
  },
  checkBtn: {
    backgroundColor: '#2563EB',
    borderRadius: 10,
    paddingVertical: 16,
    alignItems: 'center',
  },
  checkBtnDisabled: {
    backgroundColor: '#94A3B8',
    opacity: 0.6,
  },
  checkBtnText: {
    color: '#FFFFFF',
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
    backgroundColor: '#FFFFFF',
    borderTopLeftRadius: 24,
    borderTopRightRadius: 24,
    padding: 24,
    borderTopWidth: 3,
    borderColor: '#EF4444',
  },
  mistakeHeaderTag: {
    color: '#EF4444',
    fontSize: 10,
    fontWeight: '800',
    letterSpacing: 1,
  },
  mistakeTitle: {
    color: '#0F172A',
    fontSize: 24,
    fontWeight: '800',
    marginTop: 4,
  },
  userAnswerText: {
    color: '#EF4444',
    fontSize: 14,
    fontWeight: '600',
    marginTop: 4,
  },
  issueText: {
    color: '#64748B',
    fontSize: 14,
    marginTop: 2,
    marginBottom: 16,
  },
  breakdownCard: {
    backgroundColor: '#F8FAFC',
    borderColor: '#E2E8F0',
    borderWidth: 1,
    borderRadius: 12,
    padding: 14,
    marginBottom: 16,
  },
  breakdownStep: {
    color: '#64748B',
    fontSize: 12,
    marginVertical: 2,
  },
  breakdownMath: {
    color: '#0F172A',
    fontSize: 15,
    fontFamily: 'monospace',
    fontWeight: '600',
    marginVertical: 2,
  },
  breakdownMathBold: {
    color: '#10B981',
    fontSize: 15,
    fontFamily: 'monospace',
    fontWeight: '800',
    marginVertical: 2,
  },
  rememberCallout: {
    backgroundColor: '#EFF6FF',
    borderColor: '#BFDBFE',
    borderWidth: 1,
    borderRadius: 12,
    padding: 14,
    marginBottom: 20,
  },
  rememberTitle: {
    color: '#1D4ED8',
    fontSize: 13,
    fontWeight: '700',
    marginBottom: 4,
  },
  rememberBody: {
    color: '#1E40AF',
    fontSize: 13,
    lineHeight: 18,
  },
  trySimilarBtn: {
    backgroundColor: '#2563EB',
    borderRadius: 10,
    paddingVertical: 14,
    alignItems: 'center',
  },
  trySimilarBtnText: {
    color: '#FFFFFF',
    fontSize: 15,
    fontWeight: '700',
  },
});
