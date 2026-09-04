import React, { useEffect, useMemo, useState } from 'react';
import { StyleSheet, Text, View, ScrollView, TouchableOpacity, SafeAreaView } from 'react-native';
import { useRouter } from 'expo-router';
import { useTheme } from '@/hooks/use-theme';
import { fetchMyAssignments, StudentAssignmentRow } from '@/services/supabaseService';

const STATUS_META: Record<StudentAssignmentRow['status'], { label: string; tone: 'muted' | 'warning' | 'success' | 'danger' }> = {
  not_started: { label: 'Not started', tone: 'muted' },
  in_progress: { label: 'In progress', tone: 'warning' },
  completed: { label: 'Completed', tone: 'success' },
  missed: { label: 'Missed', tone: 'danger' },
};

export default function StudentAssignmentsScreen() {
  const router = useRouter();
  const colors = useTheme();
  const styles = useMemo(() => createStyles(colors), [colors]);

  const [assignments, setAssignments] = useState<StudentAssignmentRow[]>([]);
  const [loading, setLoading] = useState(true);

  useEffect(() => {
    fetchMyAssignments().then((rows) => {
      setAssignments(rows);
      setLoading(false);
    });
  }, []);

  return (
    <SafeAreaView style={styles.container}>
      <ScrollView contentContainerStyle={styles.scrollContent}>
        <TouchableOpacity style={styles.backBtn} onPress={() => router.back()}>
          <Text style={styles.backText}>← Back</Text>
        </TouchableOpacity>

        <Text style={styles.title}>Your Assignments</Text>

        {loading && <Text style={styles.mutedText}>Loading…</Text>}
        {!loading && assignments.length === 0 && <Text style={styles.mutedText}>No assignments yet.</Text>}

        {assignments.map((a) => {
          const meta = STATUS_META[a.status];
          const actionable = a.status === 'not_started' || a.status === 'in_progress';
          return (
            <TouchableOpacity
              key={a.id}
              disabled={!actionable}
              style={styles.card}
              onPress={() => router.push({ pathname: '/assignment-take', params: { assignmentId: a.id } })}
            >
              <View style={styles.cardHeader}>
                <Text style={styles.cardTitle} numberOfLines={1}>{a.title}</Text>
                <View
                  style={[
                    styles.statusBadge,
                    meta.tone === 'success' && { backgroundColor: colors.successSurface },
                    meta.tone === 'warning' && { backgroundColor: colors.warningSurface },
                    meta.tone === 'danger' && { backgroundColor: colors.dangerSurface },
                  ]}
                >
                  <Text
                    style={[
                      styles.statusBadgeText,
                      meta.tone === 'success' && { color: colors.successText },
                      meta.tone === 'warning' && { color: colors.warningText },
                      meta.tone === 'danger' && { color: colors.dangerText },
                    ]}
                  >
                    {meta.label}
                  </Text>
                </View>
              </View>
              <Text style={styles.cardMeta}>
                {a.class_name} · {a.topic_title} · {a.question_count} question{a.question_count === 1 ? '' : 's'}
              </Text>
              <View style={styles.cardFooter}>
                <Text style={styles.cardFooterText}>Due {new Date(a.due_date).toLocaleString()}</Text>
                <Text style={styles.cardFooterText}>{a.duration_minutes ? `${a.duration_minutes} min` : 'Untimed'}</Text>
              </View>
            </TouchableOpacity>
          );
        })}
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
    mutedText: { color: colors.textMuted, fontSize: 12 },
    card: { backgroundColor: colors.surface, borderColor: colors.border, borderWidth: 1, borderRadius: 12, padding: 14, marginBottom: 10 },
    cardHeader: { flexDirection: 'row', justifyContent: 'space-between', alignItems: 'center', gap: 8 },
    cardTitle: { color: colors.text, fontSize: 14, fontWeight: 'bold', flex: 1 },
    statusBadge: { backgroundColor: colors.surfaceSecondary, borderRadius: 6, paddingHorizontal: 8, paddingVertical: 4 },
    statusBadgeText: { fontSize: 10, fontWeight: 'bold', color: colors.textMuted },
    cardMeta: { color: colors.textMuted, fontSize: 11, marginTop: 4 },
    cardFooter: { flexDirection: 'row', justifyContent: 'space-between', marginTop: 10 },
    cardFooterText: { color: colors.textMuted, fontSize: 11 },
  });
}
