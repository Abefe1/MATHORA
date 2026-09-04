import React, { useCallback, useEffect, useMemo, useState } from 'react';
import { StyleSheet, Text, View, ScrollView, TouchableOpacity, SafeAreaView } from 'react-native';
import { useRouter, useLocalSearchParams } from 'expo-router';
import { useTheme } from '@/hooks/use-theme';
import { supabase } from '@/services/supabaseService';

type AssignmentListRow = {
  id: string;
  title: string;
  due_date: string;
  duration_minutes: number | null;
  question_count: number;
  topic_title: string;
};

export default function TeacherAssignmentsScreen() {
  const router = useRouter();
  const params = useLocalSearchParams<{ classId: string; className: string }>();
  const colors = useTheme();
  const styles = useMemo(() => createStyles(colors), [colors]);

  const [assignments, setAssignments] = useState<AssignmentListRow[]>([]);
  const [loading, setLoading] = useState(true);

  const load = useCallback(async () => {
    if (!params.classId || !supabase) {
      setLoading(false);
      return;
    }
    setLoading(true);
    const { data } = await supabase
      .from('assignments')
      .select('id, title, due_date, duration_minutes, question_count, topics(title)')
      .eq('class_id', params.classId)
      .order('due_date', { ascending: false });

    setAssignments(
      (data ?? []).map((a: any) => ({
        id: a.id,
        title: a.title,
        due_date: a.due_date,
        duration_minutes: a.duration_minutes ?? null,
        question_count: a.question_count ?? 0,
        topic_title: a.topics?.title ?? '',
      }))
    );
    setLoading(false);
  }, [params.classId]);

  useEffect(() => {
    // eslint-disable-next-line react-hooks/set-state-in-effect
    load();
  }, [load]);

  return (
    <SafeAreaView style={styles.container}>
      <ScrollView contentContainerStyle={styles.scrollContent}>
        <TouchableOpacity style={styles.backBtn} onPress={() => router.back()}>
          <Text style={styles.backText}>← Back</Text>
        </TouchableOpacity>

        <View style={styles.headerRow}>
          <Text style={styles.title}>{params.className ?? 'Class'} — Assignments</Text>
          <TouchableOpacity
            style={styles.newBtn}
            onPress={() => router.push({ pathname: '/teacher-assignment-new', params })}
          >
            <Text style={styles.newBtnText}>+ New</Text>
          </TouchableOpacity>
        </View>

        {loading && <Text style={styles.mutedText}>Loading…</Text>}
        {!loading && assignments.length === 0 && (
          <Text style={styles.mutedText}>No assignments yet — create one to give this class scored, timed work.</Text>
        )}

        {assignments.map((a) => (
          <TouchableOpacity
            key={a.id}
            style={styles.card}
            onPress={() =>
              router.push({
                pathname: '/teacher-assignment-detail',
                params: { assignmentId: a.id, classId: params.classId, className: params.className },
              })
            }
          >
            <Text style={styles.cardTitle} numberOfLines={1}>{a.title}</Text>
            <Text style={styles.cardMeta}>
              {a.topic_title} · {a.question_count} question{a.question_count === 1 ? '' : 's'}
            </Text>
            <View style={styles.cardFooter}>
              <Text style={styles.cardFooterText}>Due {new Date(a.due_date).toLocaleString()}</Text>
              <Text style={styles.cardFooterText}>{a.duration_minutes ? `${a.duration_minutes} min` : 'Untimed'}</Text>
            </View>
          </TouchableOpacity>
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
    headerRow: { flexDirection: 'row', justifyContent: 'space-between', alignItems: 'center', marginBottom: 16 },
    title: { color: colors.text, fontSize: 18, fontWeight: 'bold', flex: 1 },
    newBtn: { backgroundColor: colors.primary, borderRadius: 8, paddingHorizontal: 14, paddingVertical: 8 },
    newBtnText: { color: '#FFFFFF', fontSize: 12, fontWeight: 'bold' },
    mutedText: { color: colors.textMuted, fontSize: 12 },
    card: {
      backgroundColor: colors.surface,
      borderColor: colors.border,
      borderWidth: 1,
      borderRadius: 12,
      padding: 14,
      marginBottom: 10,
    },
    cardTitle: { color: colors.text, fontSize: 14, fontWeight: 'bold' },
    cardMeta: { color: colors.textMuted, fontSize: 11, marginTop: 2 },
    cardFooter: { flexDirection: 'row', justifyContent: 'space-between', marginTop: 10 },
    cardFooterText: { color: colors.textMuted, fontSize: 11 },
  });
}
