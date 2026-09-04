import React, { useCallback, useEffect, useMemo, useState } from 'react';
import { StyleSheet, Text, View, ScrollView, TouchableOpacity, SafeAreaView } from 'react-native';
import { useRouter, useLocalSearchParams } from 'expo-router';
import { useTheme } from '@/hooks/use-theme';
import {
  supabase,
  fetchClassScoreSummary,
  fetchClassTopics,
  ClassStudentScore,
  ClassLessonRow,
  ClassLevel,
} from '@/services/supabaseService';

const TERMS: (1 | 2 | 3 | 'all')[] = ['all', 1, 2, 3];

// Mobile's counterpart of mathora-web's teacher dashboard's class+term
// selector — term-scoped lessons list + score ledger for one class.
// fetchClassScoreSummary was already ported here (with term support);
// fetchClassTopics is new, mirroring web's exactly.
export default function ClassScoresScreen() {
  const router = useRouter();
  const params = useLocalSearchParams<{ classId: string; className: string }>();
  const colors = useTheme();
  const styles = useMemo(() => createStyles(colors), [colors]);

  const [term, setTerm] = useState<1 | 2 | 3 | 'all'>('all');
  const [classLevel, setClassLevel] = useState<ClassLevel | null>(null);
  const [lessons, setLessons] = useState<ClassLessonRow[]>([]);
  const [students, setStudents] = useState<ClassStudentScore[]>([]);
  const [loading, setLoading] = useState(true);

  // The class's class_level isn't in the route params — resolved with
  // one lookup, same as mathora-web's builder screen does before
  // calling fetchClassTopics.
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

  const load = useCallback(async () => {
    if (!params.classId) return;
    setLoading(true);
    const t = term === 'all' ? undefined : term;
    const [summary, lessonRows] = await Promise.all([
      fetchClassScoreSummary(params.classId, t),
      classLevel ? fetchClassTopics(classLevel, t) : Promise.resolve([]),
    ]);
    setStudents(summary.students);
    setLessons(lessonRows);
    setLoading(false);
  }, [params.classId, term, classLevel]);

  useEffect(() => {
    // Load-on-mount — same justified suppression already used elsewhere
    // (see analysis.tsx).
    // eslint-disable-next-line react-hooks/set-state-in-effect
    load();
  }, [load]);

  return (
    <SafeAreaView style={styles.container}>
      <ScrollView contentContainerStyle={styles.scrollContent}>
        <TouchableOpacity style={styles.backBtn} onPress={() => router.back()}>
          <Text style={styles.backText}>← Back</Text>
        </TouchableOpacity>

        <Text style={styles.title}>{params.className ?? 'Class'} — Scores</Text>

        <View style={styles.termRow}>
          {TERMS.map((t) => (
            <TouchableOpacity
              key={String(t)}
              style={[styles.termChip, term === t && styles.termChipActive]}
              onPress={() => setTerm(t)}
            >
              <Text style={[styles.termChipText, term === t && styles.termChipTextActive]}>
                {t === 'all' ? 'All Terms' : `Term ${t}`}
              </Text>
            </TouchableOpacity>
          ))}
        </View>

        <Text style={styles.sectionHeader}>
          Lessons{term !== 'all' ? ` — Term ${term}` : ''}
        </Text>
        {loading && <Text style={styles.mutedText}>Loading…</Text>}
        {!loading && lessons.length === 0 && <Text style={styles.mutedText}>No lessons match this term.</Text>}
        {lessons.map((l, idx) => (
          <View key={l.topic_id} style={styles.lessonRow}>
            <Text style={styles.lessonIndex}>{idx + 1}.</Text>
            <Text style={styles.lessonTitle} numberOfLines={1}>{l.title}</Text>
            {l.week != null && <Text style={styles.weekBadge}>Wk {l.week}</Text>}
          </View>
        ))}

        <Text style={[styles.sectionHeader, { marginTop: 20 }]}>Student Ledger</Text>
        {!loading && students.length === 0 && <Text style={styles.mutedText}>No student activity yet.</Text>}
        {students.map((s) => (
          <View key={s.student_id} style={styles.studentRow}>
            <Text style={styles.studentName} numberOfLines={1}>{s.full_name}</Text>
            <Text style={styles.studentStat}>{s.total_correct}/{s.total_attempted}</Text>
            <Text style={styles.studentMastery}>{s.average_mastery_percentage}%</Text>
          </View>
        ))}
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
    title: { color: colors.text, fontSize: 20, fontWeight: 'bold', marginBottom: 14 },
    termRow: { flexDirection: 'row', flexWrap: 'wrap', gap: 8, marginBottom: 18 },
    termChip: { borderColor: colors.border, borderWidth: 1, borderRadius: 999, paddingHorizontal: 12, paddingVertical: 6 },
    termChipActive: { backgroundColor: colors.primary, borderColor: colors.primary },
    termChipText: { color: colors.textMuted, fontSize: 11, fontWeight: 'bold' },
    termChipTextActive: { color: '#FFFFFF' },
    sectionHeader: { color: colors.text, fontSize: 14, fontWeight: 'bold', marginBottom: 10 },
    mutedText: { color: colors.textMuted, fontSize: 12, marginBottom: 8 },
    lessonRow: {
      flexDirection: 'row',
      alignItems: 'center',
      gap: 8,
      paddingVertical: 8,
      borderBottomWidth: 1,
      borderBottomColor: colors.border,
    },
    lessonIndex: { color: colors.textMuted, fontSize: 11, width: 20 },
    lessonTitle: { color: colors.text, fontSize: 13, flex: 1 },
    weekBadge: {
      backgroundColor: colors.warningSurface,
      color: colors.warningText,
      fontSize: 10,
      fontWeight: 'bold',
      paddingHorizontal: 6,
      paddingVertical: 2,
      borderRadius: 6,
    },
    studentRow: {
      flexDirection: 'row',
      alignItems: 'center',
      backgroundColor: colors.surface,
      borderColor: colors.border,
      borderWidth: 1,
      borderRadius: 10,
      padding: 10,
      marginBottom: 8,
      gap: 8,
    },
    studentName: { color: colors.text, fontSize: 13, fontWeight: '600', flex: 1 },
    studentStat: { color: colors.textMuted, fontSize: 12 },
    studentMastery: { color: '#10B981', fontSize: 13, fontWeight: 'bold' },
  });
}
