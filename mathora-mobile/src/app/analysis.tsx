import React, { useEffect, useMemo, useState } from 'react';
import { StyleSheet, Text, View, ScrollView, TouchableOpacity, SafeAreaView } from 'react-native';
import { useRouter } from 'expo-router';
import { useAuth } from '@/lib/authContext';
import { useTheme } from '@/hooks/use-theme';
import ProgressRing from '@/components/ProgressRing';
import { fetchMyStudentProfileId, fetchAnalysisStats, AnalysisStats } from '@/services/supabaseService';

const WEEKDAYS = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];

const EMPTY_STATS: AnalysisStats = {
  totalAttempted: 0,
  totalCorrect: 0,
  currentStreakDays: 0,
  weeklyPracticedDays: 0,
  practicedWeekdayFlags: [false, false, false, false, false, false, false],
  overallMasteryPercentage: 0,
};

export default function AnalysisScreen() {
  const router = useRouter();
  const { user } = useAuth();
  const colors = useTheme();
  const styles = useMemo(() => createStyles(colors), [colors]);
  const [stats, setStats] = useState<AnalysisStats | null>(null);
  const [loading, setLoading] = useState(true);

  useEffect(() => {
    if (!user?.id) {
      // eslint-disable-next-line react-hooks/set-state-in-effect
      setLoading(false);
      return;
    }
    fetchMyStudentProfileId(user.id).then(async (profileId) => {
      if (!profileId) {
        setLoading(false);
        return;
      }
      const data = await fetchAnalysisStats(profileId);
      setStats(data);
      setLoading(false);
    });
  }, [user?.id]);

  const s = stats ?? EMPTY_STATS;
  const incorrect = Math.max(0, s.totalAttempted - s.totalCorrect);
  const accuracyPct = s.totalAttempted > 0 ? Math.round((s.totalCorrect / s.totalAttempted) * 100) : 0;

  return (
    <SafeAreaView style={styles.container}>
      <ScrollView contentContainerStyle={styles.scrollContent}>
        <TouchableOpacity style={styles.backBtn} onPress={() => router.back()}>
          <Text style={styles.backText}>← Back to Dashboard</Text>
        </TouchableOpacity>

        <Text style={styles.badge}>YOUR ANALYSIS</Text>
        <Text style={styles.title}>Practice &amp; Progress</Text>

        {loading ? (
          <Text style={styles.mutedText}>Loading your analysis...</Text>
        ) : (
          <>
            <View style={styles.ringRow}>
              <View style={styles.ringCard}>
                <Text style={styles.cardTitle}>This Week&apos;s Practice</Text>
                <ProgressRing
                  segments={[{ value: s.weeklyPracticedDays, color: 'accent' }]}
                  total={7}
                  trackColor={colors.surfaceSecondary}
                  textColor={colors.text}
                  subTextColor={colors.textMuted}
                  centerLabel={`${s.weeklyPracticedDays}/7`}
                  centerSubLabel="days"
                />
                <View style={styles.miniStatRow}>
                  <Text style={styles.miniStatLbl}>🔥 Streak</Text>
                  <Text style={styles.miniStatVal}>{s.currentStreakDays}d</Text>
                </View>
              </View>

              <View style={styles.ringCard}>
                <Text style={styles.cardTitle}>Performance</Text>
                <ProgressRing
                  segments={[
                    { value: s.totalCorrect, color: 'correct' },
                    { value: incorrect, color: 'incorrect' },
                  ]}
                  trackColor={colors.surfaceSecondary}
                  textColor={colors.text}
                  subTextColor={colors.textMuted}
                  centerLabel={s.totalAttempted > 0 ? `${accuracyPct}%` : '—'}
                  centerSubLabel="accuracy"
                />
                <View style={styles.legendRow}>
                  <Text style={styles.legendItem}>🟢 Correct</Text>
                  <Text style={styles.legendItem}>🔴 Incorrect</Text>
                </View>
              </View>
            </View>

            <View style={styles.statGrid}>
              <View style={styles.statTile}>
                <Text style={styles.statVal}>{s.totalAttempted}</Text>
                <Text style={styles.statLbl}>Attempted</Text>
              </View>
              <View style={styles.statTile}>
                <Text style={styles.statVal}>{s.totalCorrect}</Text>
                <Text style={styles.statLbl}>Correct</Text>
              </View>
              <View style={styles.statTile}>
                <Text style={styles.statVal}>{s.currentStreakDays}</Text>
                <Text style={styles.statLbl}>Streak</Text>
              </View>
              <View style={styles.statTile}>
                <Text style={styles.statVal}>{s.overallMasteryPercentage}%</Text>
                <Text style={styles.statLbl}>Mastery</Text>
              </View>
            </View>

            <View style={styles.weekCard}>
              <Text style={styles.cardTitle}>This Week</Text>
              <View style={styles.weekRow}>
                {WEEKDAYS.map((day, i) => (
                  <View key={day} style={styles.dayCol}>
                    <Text style={styles.dayLabel}>{day}</Text>
                    <View style={[styles.daySquare, s.practicedWeekdayFlags[i] && styles.daySquareActive]} />
                  </View>
                ))}
              </View>
            </View>
          </>
        )}
      </ScrollView>
    </SafeAreaView>
  );
}

function createStyles(colors: ReturnType<typeof useTheme>) {
  return StyleSheet.create({
    container: { flex: 1, backgroundColor: colors.background },
    scrollContent: { padding: 16, paddingBottom: 40 },
    backBtn: { marginBottom: 12 },
    backText: { color: colors.primary, fontSize: 14, fontWeight: 'bold' },
    badge: { color: colors.primary, fontSize: 10, fontWeight: 'bold', letterSpacing: 1 },
    title: { color: colors.text, fontSize: 24, fontWeight: 'bold', marginTop: 4, marginBottom: 16 },
    mutedText: { color: colors.textMuted, fontSize: 13 },
    ringRow: { flexDirection: 'row', gap: 12, marginBottom: 16 },
    ringCard: {
      flex: 1,
      backgroundColor: colors.surface,
      borderColor: colors.border,
      borderWidth: 1,
      borderRadius: 16,
      padding: 16,
      alignItems: 'center',
    },
    cardTitle: { color: colors.text, fontSize: 13, fontWeight: 'bold', marginBottom: 12, alignSelf: 'flex-start' },
    miniStatRow: { flexDirection: 'row', justifyContent: 'space-between', width: '100%', marginTop: 12 },
    miniStatLbl: { color: colors.textMuted, fontSize: 11 },
    miniStatVal: { color: colors.primary, fontSize: 12, fontWeight: 'bold' },
    legendRow: { flexDirection: 'row', gap: 10, marginTop: 12 },
    legendItem: { color: colors.textMuted, fontSize: 10, fontWeight: '600' },
    statGrid: { flexDirection: 'row', flexWrap: 'wrap', gap: 10, marginBottom: 16 },
    statTile: {
      flexBasis: '47%',
      flexGrow: 1,
      backgroundColor: colors.surface,
      borderColor: colors.border,
      borderWidth: 1,
      borderRadius: 12,
      padding: 14,
      alignItems: 'center',
    },
    statVal: { color: colors.text, fontSize: 20, fontWeight: '800' },
    statLbl: { color: colors.textMuted, fontSize: 10, fontWeight: '700', marginTop: 2, textTransform: 'uppercase' },
    weekCard: {
      backgroundColor: colors.surface,
      borderColor: colors.border,
      borderWidth: 1,
      borderRadius: 16,
      padding: 16,
    },
    weekRow: { flexDirection: 'row', justifyContent: 'space-between', gap: 6 },
    dayCol: { alignItems: 'center', gap: 6, flex: 1 },
    dayLabel: { color: colors.textMuted, fontSize: 10 },
    daySquare: { width: '100%', aspectRatio: 1, borderRadius: 8, backgroundColor: colors.surfaceSecondary },
    daySquareActive: { backgroundColor: '#F59E0B' },
  });
}
