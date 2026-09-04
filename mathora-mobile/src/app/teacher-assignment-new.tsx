import React, { useCallback, useEffect, useMemo, useState } from 'react';
import { StyleSheet, Text, View, ScrollView, TouchableOpacity, SafeAreaView, TextInput, Switch, ActivityIndicator } from 'react-native';
import { useRouter, useLocalSearchParams } from 'expo-router';
import { useTheme } from '@/hooks/use-theme';
import { useAuth } from '@/lib/authContext';
import { useToast } from '@/lib/toastContext';
import { MathView } from '@/components/math-view';
import {
  supabase,
  fetchClassTopics,
  fetchQuestionBankForClass,
  createTeacherQuestion,
  createAssignmentWithQuestions,
  ClassLevel,
  ClassLessonRow,
  QuestionBankRow,
} from '@/services/supabaseService';

// Same 3-step flow as mathora-web's assignment builder (Details ->
// Questions -> Review), laid out as three Views gated by a step state
// instead of three route pushes — same underlying state machine, no
// date/time-picker library added (see plan notes): due date is a
// "due in N days, at HH:mm" pair of plain inputs rather than a native
// calendar control, avoiding a new native dependency this pass.
export default function TeacherAssignmentNewScreen() {
  const router = useRouter();
  const params = useLocalSearchParams<{ classId: string; className: string }>();
  const colors = useTheme();
  const { user } = useAuth();
  const showToast = useToast();
  const styles = useMemo(() => createStyles(colors), [colors]);

  const [classLevel, setClassLevel] = useState<ClassLevel | null>(null);
  const [topics, setTopics] = useState<ClassLessonRow[]>([]);
  const [topicId, setTopicId] = useState('');
  const [bank, setBank] = useState<QuestionBankRow[]>([]);
  const [bankLoading, setBankLoading] = useState(false);
  const [selectedIds, setSelectedIds] = useState<string[]>([]);

  const [title, setTitle] = useState('');
  const [dueInDays, setDueInDays] = useState('7');
  const [dueTime, setDueTime] = useState('23:59');
  const [untimed, setUntimed] = useState(true);
  const [durationMinutes, setDurationMinutes] = useState('20');

  const [showCustomForm, setShowCustomForm] = useState(false);
  const [customText, setCustomText] = useState('');
  const [customA, setCustomA] = useState('');
  const [customB, setCustomB] = useState('');
  const [customC, setCustomC] = useState('');
  const [customD, setCustomD] = useState('');
  const [customCorrect, setCustomCorrect] = useState<'A' | 'B' | 'C' | 'D'>('A');
  const [customExplanation, setCustomExplanation] = useState('');
  const [savingCustom, setSavingCustom] = useState(false);

  const [submitting, setSubmitting] = useState(false);
  const [step, setStep] = useState<1 | 2 | 3>(1);

  useEffect(() => {
    if (!params.classId || !supabase) return;
    supabase
      .from('classes')
      .select('class_level')
      .eq('id', params.classId)
      .single()
      .then(({ data }) => {
        if (data) setClassLevel(data.class_level as ClassLevel);
      });
  }, [params.classId]);

  useEffect(() => {
    if (!classLevel) return;
    fetchClassTopics(classLevel).then((rows) => {
      setTopics(rows);
      setTopicId((prev) => (prev || rows[0]?.topic_id) ?? '');
    });
  }, [classLevel]);

  const loadBank = useCallback(async () => {
    if (!classLevel || !topicId) return;
    setBankLoading(true);
    const rows = await fetchQuestionBankForClass(classLevel, topicId);
    setBank(rows);
    setBankLoading(false);
  }, [classLevel, topicId]);

  useEffect(() => {
    // eslint-disable-next-line react-hooks/set-state-in-effect
    loadBank();
  }, [loadBank]);

  const toggleSelected = (id: string) => {
    setSelectedIds((prev) => (prev.includes(id) ? prev.filter((x) => x !== id) : [...prev, id]));
  };

  const handleAddCustomQuestion = async () => {
    if (!user?.id || !topicId) return;
    if (!customText.trim() || !customA.trim() || !customB.trim() || !customC.trim() || !customD.trim() || !customExplanation.trim()) {
      showToast('Fill in the question text, all four options, and an explanation.', 'error');
      return;
    }

    setSavingCustom(true);
    const result = await createTeacherQuestion({
      authUserId: user.id,
      topicId,
      questionText: customText,
      optionA: customA,
      optionB: customB,
      optionC: customC,
      optionD: customD,
      correctLetter: customCorrect,
      explanation: customExplanation,
    });
    setSavingCustom(false);

    if (!result.success || !result.question) {
      showToast(result.error ?? 'Failed to save question.', 'error');
      return;
    }

    setBank((prev) => [result.question!, ...prev]);
    setSelectedIds((prev) => [...prev, result.question!.id]);
    showToast('Question added to the bank and selected.', 'success');

    setCustomText('');
    setCustomA('');
    setCustomB('');
    setCustomC('');
    setCustomD('');
    setCustomCorrect('A');
    setCustomExplanation('');
    setShowCustomForm(false);
  };

  const computeDueDate = (): Date | null => {
    const days = Number(dueInDays);
    const match = /^(\d{1,2}):(\d{2})$/.exec(dueTime.trim());
    if (!Number.isFinite(days) || days < 0 || !match) return null;
    const hours = Number(match[1]);
    const minutes = Number(match[2]);
    if (hours > 23 || minutes > 59) return null;
    const due = new Date();
    due.setDate(due.getDate() + days);
    due.setHours(hours, minutes, 0, 0);
    return due;
  };

  const detailsComplete = title.trim().length > 0 && topicId.length > 0 && computeDueDate() != null;

  const handleCreate = async () => {
    const dueDate = computeDueDate();
    if (!dueDate || selectedIds.length === 0) return;
    if (dueDate.getTime() <= Date.now()) {
      showToast('Due date must be in the future.', 'error');
      return;
    }

    setSubmitting(true);
    const result = await createAssignmentWithQuestions({
      classId: params.classId,
      topicId,
      title,
      dueDate: dueDate.toISOString(),
      durationMinutes: untimed ? null : Number(durationMinutes) || null,
      questionIds: selectedIds,
    });
    setSubmitting(false);

    if (!result.success || !result.assignmentId) {
      showToast(result.error ?? 'Failed to create assignment.', 'error');
      return;
    }

    showToast('Assignment created.', 'success');
    router.replace({
      pathname: '/teacher-assignment-detail',
      params: { assignmentId: result.assignmentId, classId: params.classId, className: params.className },
    });
  };

  return (
    <SafeAreaView style={styles.container}>
      <ScrollView contentContainerStyle={styles.scrollContent}>
        <TouchableOpacity style={styles.backBtn} onPress={() => router.back()}>
          <Text style={styles.backText}>← Back</Text>
        </TouchableOpacity>

        <Text style={styles.title}>Build an Assignment</Text>

        <View style={styles.stepRow}>
          {([[1, 'Details'], [2, 'Questions'], [3, 'Review']] as const).map(([n, label]) => (
            <TouchableOpacity
              key={n}
              disabled={n >= step}
              onPress={() => n < step && setStep(n)}
              style={[styles.stepChip, step === n && styles.stepChipActive]}
            >
              <Text style={[styles.stepChipText, step === n && styles.stepChipTextActive, step > n && { color: colors.primary }]}>
                {n}. {label}
              </Text>
            </TouchableOpacity>
          ))}
        </View>

        {step === 1 && (
          <>
            <Text style={styles.label}>Topic</Text>
            <View style={styles.pickerRow}>
              {topics.map((t) => (
                <TouchableOpacity
                  key={t.topic_id}
                  style={[styles.pickerChip, topicId === t.topic_id && styles.pickerChipActive]}
                  onPress={() => {
                    setTopicId(t.topic_id);
                    setSelectedIds([]);
                  }}
                >
                  <Text style={[styles.pickerChipText, topicId === t.topic_id && styles.pickerChipTextActive]} numberOfLines={1}>
                    {t.title}{t.term != null ? ` · T${t.term}` : ''}
                  </Text>
                </TouchableOpacity>
              ))}
              {topics.length === 0 && <Text style={styles.mutedText}>No topics for this class level.</Text>}
            </View>

            <Text style={styles.label}>Title</Text>
            <TextInput
              style={styles.input}
              placeholder="e.g. Week 6 Quiz — Quadratic Equations"
              placeholderTextColor={colors.textMuted}
              value={title}
              onChangeText={setTitle}
            />

            <Text style={styles.label}>Due In (days)</Text>
            <TextInput
              style={styles.input}
              keyboardType="number-pad"
              value={dueInDays}
              onChangeText={setDueInDays}
            />

            <Text style={styles.label}>Due Time (24h, HH:MM)</Text>
            <TextInput style={styles.input} placeholder="23:59" placeholderTextColor={colors.textMuted} value={dueTime} onChangeText={setDueTime} />

            <View style={styles.switchRow}>
              <Text style={styles.label}>Untimed</Text>
              <Switch value={untimed} onValueChange={setUntimed} />
            </View>
            {!untimed && (
              <>
                <Text style={styles.label}>Duration (minutes)</Text>
                <TextInput style={styles.input} keyboardType="number-pad" value={durationMinutes} onChangeText={setDurationMinutes} />
              </>
            )}

            <TouchableOpacity
              style={[styles.primaryBtn, !detailsComplete && styles.btnDisabled]}
              disabled={!detailsComplete}
              onPress={() => setStep(2)}
            >
              <Text style={styles.primaryBtnText}>Next: Questions →</Text>
            </TouchableOpacity>
          </>
        )}

        {step === 2 && (
          <>
            <View style={styles.headerRow}>
              <Text style={styles.label}>Question Bank — {selectedIds.length} selected</Text>
              <TouchableOpacity onPress={() => setShowCustomForm((v) => !v)}>
                <Text style={styles.linkText}>+ Add custom</Text>
              </TouchableOpacity>
            </View>

            {showCustomForm && (
              <View style={styles.customCard}>
                <TextInput
                  style={styles.input}
                  placeholder="Question text"
                  placeholderTextColor={colors.textMuted}
                  value={customText}
                  onChangeText={setCustomText}
                  multiline
                />
                {([['A', customA, setCustomA], ['B', customB, setCustomB], ['C', customC, setCustomC], ['D', customD, setCustomD]] as const).map(
                  ([letter, value, setValue]) => (
                    <View key={letter} style={styles.optionRow}>
                      <TouchableOpacity
                        style={[styles.optionLetter, customCorrect === letter && styles.optionLetterActive]}
                        onPress={() => setCustomCorrect(letter)}
                      >
                        <Text style={[styles.optionLetterText, customCorrect === letter && styles.optionLetterTextActive]}>{letter}</Text>
                      </TouchableOpacity>
                      <TextInput
                        style={[styles.input, { flex: 1, marginBottom: 0 }]}
                        placeholder={`Option ${letter}`}
                        placeholderTextColor={colors.textMuted}
                        value={value}
                        onChangeText={setValue}
                      />
                    </View>
                  )
                )}
                <TextInput
                  style={styles.input}
                  placeholder="Explanation"
                  placeholderTextColor={colors.textMuted}
                  value={customExplanation}
                  onChangeText={setCustomExplanation}
                  multiline
                />
                <TouchableOpacity style={styles.secondaryBtn} onPress={handleAddCustomQuestion} disabled={savingCustom}>
                  {savingCustom ? <ActivityIndicator size="small" color="#FFFFFF" /> : <Text style={styles.secondaryBtnText}>Save & Add</Text>}
                </TouchableOpacity>
              </View>
            )}

            {bankLoading && <Text style={styles.mutedText}>Loading question bank…</Text>}
            {!bankLoading && bank.length === 0 && <Text style={styles.mutedText}>No published questions for this topic yet.</Text>}
            {bank.map((q) => {
              const selected = selectedIds.includes(q.id);
              return (
                <TouchableOpacity key={q.id} style={[styles.questionRow, selected && styles.questionRowActive]} onPress={() => toggleSelected(q.id)}>
                  <View style={[styles.checkbox, selected && styles.checkboxActive]}>{selected && <Text style={styles.checkmark}>✓</Text>}</View>
                  <View style={{ flex: 1 }}>
                    <MathView expression={q.question_text} size="sm" />
                    {q.created_by_teacher_id && <Text style={styles.yourQuestionTag}>Your question</Text>}
                  </View>
                </TouchableOpacity>
              );
            })}

            <View style={styles.navRow}>
              <TouchableOpacity onPress={() => setStep(1)}>
                <Text style={styles.linkText}>← Back</Text>
              </TouchableOpacity>
              <TouchableOpacity
                style={[styles.primaryBtn, { flex: 1 }, selectedIds.length === 0 && styles.btnDisabled]}
                disabled={selectedIds.length === 0}
                onPress={() => setStep(3)}
              >
                <Text style={styles.primaryBtnText}>Next: Review →</Text>
              </TouchableOpacity>
            </View>
          </>
        )}

        {step === 3 && (
          <>
            <View style={styles.reviewCard}>
              <ReviewRow colors={colors} label="Title" value={title} />
              <ReviewRow colors={colors} label="Topic" value={topics.find((t) => t.topic_id === topicId)?.title ?? '—'} />
              <ReviewRow colors={colors} label="Due" value={computeDueDate()?.toLocaleString() ?? '—'} />
              <ReviewRow colors={colors} label="Duration" value={untimed ? 'Untimed' : `${durationMinutes} min`} />
              <ReviewRow colors={colors} label="Questions" value={`${selectedIds.length} selected`} />
            </View>

            <View style={styles.navRow}>
              <TouchableOpacity onPress={() => setStep(2)}>
                <Text style={styles.linkText}>← Back</Text>
              </TouchableOpacity>
              <TouchableOpacity style={[styles.primaryBtn, { flex: 1 }]} onPress={handleCreate} disabled={submitting}>
                {submitting ? <ActivityIndicator size="small" color="#FFFFFF" /> : <Text style={styles.primaryBtnText}>Create Assignment</Text>}
              </TouchableOpacity>
            </View>
          </>
        )}
      </ScrollView>
    </SafeAreaView>
  );
}

function ReviewRow({ colors, label, value }: { colors: ReturnType<typeof useTheme>; label: string; value: string }) {
  return (
    <View style={{ flexDirection: 'row', justifyContent: 'space-between', paddingVertical: 6 }}>
      <Text style={{ color: colors.textMuted, fontSize: 12 }}>{label}</Text>
      <Text style={{ color: colors.text, fontSize: 12, fontWeight: '600', flexShrink: 1, textAlign: 'right' }}>{value}</Text>
    </View>
  );
}

function createStyles(colors: ReturnType<typeof useTheme>) {
  return StyleSheet.create({
    container: { flex: 1, backgroundColor: colors.background },
    scrollContent: { padding: 16, paddingBottom: 40 },
    backBtn: { marginBottom: 12 },
    backText: { color: colors.primary, fontSize: 14, fontWeight: 'bold' },
    title: { color: colors.text, fontSize: 20, fontWeight: 'bold', marginBottom: 14 },
    stepRow: { flexDirection: 'row', gap: 8, marginBottom: 18 },
    stepChip: { borderRadius: 999, paddingHorizontal: 10, paddingVertical: 6 },
    stepChipActive: { backgroundColor: colors.primary },
    stepChipText: { fontSize: 11, fontWeight: 'bold', color: colors.textMuted },
    stepChipTextActive: { color: '#FFFFFF' },
    label: { color: colors.textMuted, fontSize: 11, fontWeight: 'bold', textTransform: 'uppercase', marginBottom: 6, marginTop: 12 },
    input: {
      backgroundColor: colors.surface,
      borderColor: colors.border,
      borderWidth: 1,
      borderRadius: 8,
      padding: 12,
      color: colors.text,
      fontSize: 14,
      marginBottom: 10,
    },
    pickerRow: { flexDirection: 'row', flexWrap: 'wrap', gap: 8 },
    pickerChip: { borderColor: colors.border, borderWidth: 1, borderRadius: 999, paddingHorizontal: 12, paddingVertical: 6, maxWidth: 220 },
    pickerChipActive: { backgroundColor: colors.primary, borderColor: colors.primary },
    pickerChipText: { color: colors.textMuted, fontSize: 11, fontWeight: 'bold' },
    pickerChipTextActive: { color: '#FFFFFF' },
    mutedText: { color: colors.textMuted, fontSize: 12 },
    switchRow: { flexDirection: 'row', alignItems: 'center', justifyContent: 'space-between', marginTop: 10 },
    primaryBtn: { backgroundColor: colors.primary, borderRadius: 10, padding: 14, alignItems: 'center', marginTop: 20 },
    primaryBtnText: { color: '#FFFFFF', fontSize: 13, fontWeight: 'bold' },
    btnDisabled: { opacity: 0.4 },
    headerRow: { flexDirection: 'row', justifyContent: 'space-between', alignItems: 'center' },
    linkText: { color: colors.primary, fontSize: 12, fontWeight: 'bold' },
    customCard: { backgroundColor: colors.surfaceSecondary, borderRadius: 12, padding: 12, marginTop: 10, marginBottom: 12 },
    optionRow: { flexDirection: 'row', alignItems: 'center', gap: 8, marginBottom: 8 },
    optionLetter: { width: 28, height: 28, borderRadius: 8, borderWidth: 2, borderColor: colors.border, alignItems: 'center', justifyContent: 'center' },
    optionLetterActive: { borderColor: '#10B981', backgroundColor: colors.successSurface },
    optionLetterText: { fontSize: 11, fontWeight: 'bold', color: colors.textMuted },
    optionLetterTextActive: { color: colors.successText },
    secondaryBtn: { backgroundColor: '#10B981', borderRadius: 8, padding: 12, alignItems: 'center', marginTop: 4 },
    secondaryBtnText: { color: '#FFFFFF', fontSize: 12, fontWeight: 'bold' },
    questionRow: {
      flexDirection: 'row',
      gap: 10,
      alignItems: 'flex-start',
      borderColor: colors.border,
      borderWidth: 1,
      borderRadius: 10,
      padding: 10,
      marginTop: 8,
    },
    questionRowActive: { borderColor: '#10B981', backgroundColor: colors.successSurface },
    checkbox: { width: 20, height: 20, borderRadius: 6, borderWidth: 2, borderColor: colors.border, alignItems: 'center', justifyContent: 'center', marginTop: 2 },
    checkboxActive: { borderColor: '#10B981', backgroundColor: '#10B981' },
    checkmark: { color: '#FFFFFF', fontSize: 12, fontWeight: 'bold' },
    yourQuestionTag: { color: colors.warningText, fontSize: 10, fontWeight: 'bold', marginTop: 4 },
    navRow: { flexDirection: 'row', alignItems: 'center', gap: 16, marginTop: 20 },
    reviewCard: { backgroundColor: colors.surface, borderColor: colors.border, borderWidth: 1, borderRadius: 12, padding: 14 },
  });
}
