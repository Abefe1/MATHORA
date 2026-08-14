import React, { useState } from 'react';
import { StyleSheet, Text, View, ScrollView, TouchableOpacity, SafeAreaView, Modal } from 'react-native';
import { useRouter } from 'expo-router';

export default function PracticeScreen() {
  const router = useRouter();
  const [selectedOption, setSelectedOption] = useState<string | null>(null);
  const [isSubmitted, setIsSubmitted] = useState(false);
  const [showRescueModal, setShowRescueModal] = useState(false);

  const question = {
    title: 'Quadratic Factorization',
    text: 'Solve for x: 3x² - 7x + 2 = 0',
    latexText: 'Identify linear factors (ax + b)(cx + d) = 0 where ac = 6 and sum = -7.',
    options: [
      { letter: 'A', text: 'x = 1/3  or  x = 2', isCorrect: true },
      { letter: 'B', text: 'x = -1/3  or  x = -2', isCorrect: false },
      { letter: 'C', text: 'x = 3  or  x = 1/2', isCorrect: false },
      { letter: 'D', text: 'x = -3  or  x = 2', isCorrect: false },
    ],
    shortcut: 'WAEC MCQ Tip: Product of roots = c/a = 2/3. Product of (1/3) × 2 = 2/3 instantly verifies Option A!',
  };

  const handleSelect = (letter: string) => {
    if (isSubmitted) return;
    setSelectedOption(letter);
  };

  const handleSubmit = () => {
    if (!selectedOption) return;
    setIsSubmitted(true);
    const chosen = question.options.find((o) => o.letter === selectedOption);
    if (!chosen?.isCorrect) {
      setShowRescueModal(true);
    }
  };

  return (
    <SafeAreaView style={styles.container}>
      <ScrollView contentContainerStyle={styles.scrollContent}>
        {/* Top Header */}
        <TouchableOpacity style={styles.backBtn} onPress={() => router.back()}>
          <Text style={styles.backText}>← Back to Dashboard</Text>
        </TouchableOpacity>

        <View style={styles.topicHeader}>
          <Text style={styles.topicTag}>PRACTICE SESSION</Text>
          <Text style={styles.topicTitle}>{question.title}</Text>
        </View>

        {/* Question Card */}
        <View style={styles.questionCard}>
          <Text style={styles.questionText}>{question.text}</Text>
          <View style={styles.latexBox}>
            <Text style={styles.latexContent}>{question.latexText}</Text>
          </View>
        </View>

        {/* Options */}
        <Text style={styles.sectionSubtitle}>Select Answer Choice:</Text>
        {question.options.map((opt) => {
          const isSelected = selectedOption === opt.letter;
          return (
            <TouchableOpacity
              key={opt.letter}
              style={[
                styles.optionCard,
                isSelected && styles.optionSelected,
                isSubmitted && opt.isCorrect && styles.optionCorrect,
                isSubmitted && isSelected && !opt.isCorrect && styles.optionIncorrect,
              ]}
              onPress={() => handleSelect(opt.letter)}
              activeOpacity={0.8}
            >
              <Text style={styles.optionLetter}>{opt.letter}</Text>
              <Text style={styles.optionText}>{opt.text}</Text>
            </TouchableOpacity>
          );
        })}

        {/* Submit Button */}
        {!isSubmitted ? (
          <TouchableOpacity style={styles.submitBtn} onPress={handleSubmit} activeOpacity={0.8}>
            <Text style={styles.submitBtnText}>Submit Answer</Text>
          </TouchableOpacity>
        ) : (
          <View style={styles.shortcutBox}>
            <Text style={styles.shortcutTitle}>⚡ WAEC EXAM SHORTCUT</Text>
            <Text style={styles.shortcutText}>{question.shortcut}</Text>
          </View>
        )}
      </ScrollView>

      {/* Rescue Mode Remediation Modal */}
      <Modal visible={showRescueModal} animationType="slide" transparent>
        <View style={styles.modalOverlay}>
          <View style={styles.modalContent}>
            <Text style={styles.rescueBadge}>RESCUE MODE ACTIVATED</Text>
            <Text style={styles.modalTitle}>Step-by-step Remediation</Text>

            <View style={styles.mistakeBox}>
              <Text style={styles.mistakeTitle}>Diagnosed Error Pattern:</Text>
              <Text style={styles.mistakeText}>
                When expanding -6x - x, remember: (-6) × (-1) = +6. Pay close attention to negative signs!
              </Text>
            </View>

            <View style={styles.solutionBox}>
              <Text style={styles.solutionTitle}>Worked Solution:</Text>
              <Text style={styles.solutionText}>
                1. 3x² - 6x - x + 2 = 0{'\n'}
                2. 3x(x - 2) - 1(x - 2) = 0{'\n'}
                3. (3x - 1)(x - 2) = 0{'\n'}
                4. x = 1/3 or x = 2
              </Text>
            </View>

            <TouchableOpacity style={styles.closeModalBtn} onPress={() => setShowRescueModal(false)}>
              <Text style={styles.closeModalText}>I Understand Now — Retry</Text>
            </TouchableOpacity>
          </View>
        </View>
      </Modal>
    </SafeAreaView>
  );
}

const styles = StyleSheet.create({
  container: { flex: 1, backgroundColor: '#090D16' },
  scrollContent: { padding: 16 },
  backBtn: { marginBottom: 12 },
  backText: { color: '#38BDF8', fontSize: 14, fontWeight: 'bold' },
  topicHeader: { marginBottom: 16 },
  topicTag: { color: '#F59E0B', fontSize: 10, fontWeight: 'bold', letterSpacing: 1 },
  topicTitle: { color: '#FFFFFF', fontSize: 22, fontWeight: 'bold', marginTop: 2 },
  questionCard: {
    backgroundColor: '#0F172A',
    borderColor: '#1E293B',
    borderWidth: 1,
    borderRadius: 16,
    padding: 16,
    marginBottom: 20,
  },
  questionText: { color: '#FFFFFF', fontSize: 18, fontWeight: 'bold' },
  latexBox: { backgroundColor: '#1E1B4B', padding: 12, borderRadius: 8, marginTop: 10 },
  latexContent: { color: '#C7D2FE', fontSize: 13, fontFamily: 'monospace' },
  sectionSubtitle: { color: '#94A3B8', fontSize: 12, fontWeight: 'bold', marginBottom: 10 },
  optionCard: {
    backgroundColor: '#0F172A',
    borderColor: '#1E293B',
    borderWidth: 1,
    borderRadius: 12,
    padding: 16,
    flexDirection: 'row',
    alignItems: 'center',
    marginBottom: 10,
  },
  optionSelected: { borderColor: '#F59E0B', backgroundColor: '#78350F22' },
  optionCorrect: { borderColor: '#10B981', backgroundColor: '#064E3B44' },
  optionIncorrect: { borderColor: '#EF4444', backgroundColor: '#7F1D1D44' },
  optionLetter: { color: '#F59E0B', fontSize: 16, fontWeight: 'bold', width: 28 },
  optionText: { color: '#FFFFFF', fontSize: 15, fontWeight: '500' },
  submitBtn: {
    backgroundColor: '#F59E0B',
    borderRadius: 12,
    padding: 16,
    alignItems: 'center',
    marginTop: 10,
  },
  submitBtnText: { color: '#090D16', fontSize: 16, fontWeight: 'bold' },
  shortcutBox: {
    backgroundColor: '#064E3B33',
    borderColor: '#059669',
    borderWidth: 1,
    borderRadius: 12,
    padding: 14,
    marginTop: 10,
  },
  shortcutTitle: { color: '#34D399', fontSize: 11, fontWeight: 'bold' },
  shortcutText: { color: '#ECFDF5', fontSize: 13, marginTop: 4 },
  modalOverlay: { flex: 1, backgroundColor: '#000000AA', justifyContent: 'flex-end' },
  modalContent: {
    backgroundColor: '#0F172A',
    borderTopLeftRadius: 24,
    borderTopRightRadius: 24,
    padding: 24,
    borderColor: '#EF4444',
    borderTopWidth: 2,
  },
  rescueBadge: { color: '#EF4444', fontSize: 10, fontWeight: 'bold', letterSpacing: 1 },
  modalTitle: { color: '#FFFFFF', fontSize: 20, fontWeight: 'bold', marginTop: 4, marginBottom: 16 },
  mistakeBox: { backgroundColor: '#7F1D1D33', padding: 12, borderRadius: 12, marginBottom: 12 },
  mistakeTitle: { color: '#FCA5A5', fontSize: 12, fontWeight: 'bold' },
  mistakeText: { color: '#FEE2E2', fontSize: 13, marginTop: 2 },
  solutionBox: { backgroundColor: '#1E1B4B', padding: 12, borderRadius: 12, marginBottom: 20 },
  solutionTitle: { color: '#C7D2FE', fontSize: 12, fontWeight: 'bold' },
  solutionText: { color: '#FFFFFF', fontSize: 13, marginTop: 4, lineHeight: 20, fontFamily: 'monospace' },
  closeModalBtn: { backgroundColor: '#10B981', borderRadius: 12, padding: 14, alignItems: 'center' },
  closeModalText: { color: '#FFFFFF', fontSize: 15, fontWeight: 'bold' },
});
