import React, { useCallback, useEffect, useMemo, useState } from 'react';
import { StyleSheet, Text, View, ScrollView, TouchableOpacity, SafeAreaView } from 'react-native';
import { useRouter, useLocalSearchParams } from 'expo-router';
import { useTheme } from '@/hooks/use-theme';
import { fetchAssignmentSubmissions, AssignmentSubmissionRow } from '@/services/supabaseService';

function statusOf(row: AssignmentSubmissionRow): { label: string; tone: 'success' | 'warning' | 'muted' } {
  if (row.completed) return { label: 'Completed', tone: 'success' };
  if (row.started_at) return { label: 'In progress', tone: 'warning' };
  return { label: 'Not started', tone: 'muted' };
}

export default function TeacherAssignmentDetailScreen() {
  const router = useRouter();
  const params = useLocalSearchParams<{ assignmentId: string; classId: string; className: string }>();
  const colors = useTheme();
  const styles = useMemo(() => createStyles(colors), [colors]);

  const [rows, setRows] = useState<AssignmentSubmissionRow[]>([]);
  const [loading, setLoading] = useState(true);

  const load = useCallback(async () => {
    if (!params.assignmentId || !params.classId) return;
    setLoading(true);
    const data = await fetchAssignmentSubmissions(params.assignmentId, params.classId);
    setRows(data);
    setLoading(false);
  }, [params.assignmentId, params.classId]);

  useEffect(() => {
    // Load-on-mount — same justified suppression already used elsewhere
    // (see analysis.tsx).
    // eslint-disable-next-line react-hooks/set-state-in-effect
    load();
  }, [load]);

  const completed = rows.filter((r) => r.completed);
  const avgScore = completed.length ? Math.round(completed.reduce((s, r) => s + (r.score ?? 0), 0) / completed.length) : 0;
  const totalFlags = rows.reduce((s, r) => s + r.focus_loss_count, 0);

  return (
    <SafeAreaView style={styles.container}>
      <ScrollView contentContainerStyle={styles.scrollContent}>
        <TouchableOpacity style={styles.backBtn} onPress={() => router.back()}>
          <Text style={styles.backText}>← Back</Text>
        </TouchableOpacity>

        <Text style={styles.title}>Submissions</Text>

        <View style={styles.statsRow}>
          <View style={styles.statCard}>
            <Text style={styles.statValue}>{rows.length}</Text>
            <Text style={styles.statLabel}>Students</Text>
          </View>
          <View style={styles.statCard}>
            <Text style={styles.statValue}>{avgScore}%</Text>
            <Text style={styles.statLabel}>Avg Score ({completed.length} done)</Text>
          </View>
          <View style={styles.statCard}>
            <Text style={[styles.statValue, totalFlags > 0 && { color: '#F43F5E' }]}>{totalFlags}</Text>
            <Text style={styles.statLabel}>Focus-Loss Flags</Text>
          </View>
        </View>

        {loading && <Text style={styles.mutedText}>Loading…</Text>}
        {!loading && rows.length === 0 && <Text style={styles.mutedText}>No students in this class yet.</Text>}

        {rows.map((r) => {
          const status = statusOf(r);
          return (
            <View key={r.student_id} style={styles.studentRow}>
              <View style={{ flex: 1 }}>
                <Text style={styles.studentName} numberOfLines={1}>{r.full_name}</Text>
                {r.submitted_at && <Text style={styles.submittedAt}>Submitted {new Date(r.submitted_at).toLocaleString()}</Text>}
              </View>
              {r.focus_loss_count > 0 && (
                <View style={styles.flagBadge}>
                  <Text style={styles.flagBadgeText}>⚠ {r.focus_loss_count}</Text>
                </View>
              )}
              <View
                style={[
                  styles.statusBadge,
                  status.tone === 'success' && styles.statusSuccess,
                  status.tone === 'warning' && styles.statusWarning,
                ]}
              >
                <Text
                  style={[
                    styles.statusBadgeText,
                    status.tone === 'success' && { color: colors.successText },
                    status.tone === 'warning' && { color: colors.warningText },
                  ]}
                >
                  {status.label}
                </Text>
              </View>
              {r.completed && <Text style={styles.scoreText}>{r.score}%</Text>}
            </View>
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
    statsRow: { flexDirection: 'row', gap: 8, marginBottom: 18 },
    statCard: { flex: 1, backgroundColor: colors.surface, borderColor: colors.border, borderWidth: 1, borderRadius: 12, padding: 12, alignItems: 'center' },
    statValue: { color: colors.text, fontSize: 18, fontWeight: 'bold' },
    statLabel: { color: colors.textMuted, fontSize: 9, fontWeight: 'bold', textTransform: 'uppercase', marginTop: 4, textAlign: 'center' },
    mutedText: { color: colors.textMuted, fontSize: 12 },
    studentRow: {
      flexDirection: 'row',
      alignItems: 'center',
      gap: 8,
      backgroundColor: colors.surface,
      borderColor: colors.border,
      borderWidth: 1,
      borderRadius: 10,
      padding: 12,
      marginBottom: 8,
    },
    studentName: { color: colors.text, fontSize: 13, fontWeight: '600' },
    submittedAt: { color: colors.textMuted, fontSize: 10, marginTop: 2 },
    flagBadge: { backgroundColor: '#FEF2F2', borderColor: '#FCA5A5', borderWidth: 1, borderRadius: 6, paddingHorizontal: 6, paddingVertical: 2 },
    flagBadgeText: { color: '#DC2626', fontSize: 10, fontWeight: 'bold' },
    statusBadge: { backgroundColor: colors.surfaceSecondary, borderRadius: 6, paddingHorizontal: 8, paddingVertical: 4 },
    statusSuccess: { backgroundColor: colors.successSurface },
    statusWarning: { backgroundColor: colors.warningSurface },
    statusBadgeText: { fontSize: 10, fontWeight: 'bold', color: colors.textMuted },
    scoreText: { color: colors.primary, fontSize: 13, fontWeight: 'bold' },
  });
}
