import React, { useMemo } from 'react';
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
import { MISCONCEPTIONS_DATA, MisconceptionAnalysis } from '@/services/dataService';

export default function StrugglingAnalysisScreen() {
  const router = useRouter();
  const colors = useTheme();
  const scheme = useColorScheme();
  const styles = useMemo(() => createStyles(colors), [colors]);

  return (
    <SafeAreaView style={styles.container}>
      <StatusBar barStyle={scheme === 'dark' ? 'light-content' : 'dark-content'} backgroundColor={colors.background} />
      <ScrollView contentContainerStyle={styles.scrollContent}>
        <TouchableOpacity style={styles.backBtn} onPress={() => router.back()}>
          <Text style={styles.backText}>← Back to Dashboard</Text>
        </TouchableOpacity>

        {/* Header */}
        <View style={styles.header}>
          <Text style={styles.badgeText}>AI MISCONCEPTION & GAP ANALYSIS</Text>
          <Text style={styles.title}>Targeted Remediation</Text>
          <Text style={styles.subtitle}>
            Mathora pinpoints exact mathematical misunderstandings and prerequisite gaps before exam day.
          </Text>
        </View>

        {/* Summary Card */}
        <View style={styles.summaryCard}>
          <Text style={styles.summaryTitle}>Misconception Intelligence Overview</Text>
          <View style={styles.metricGrid}>
            <View style={styles.metricBox}>
              <Text style={styles.metricValRed}>{MISCONCEPTIONS_DATA.length}</Text>
              <Text style={styles.metricLbl}>Active Trap Patterns</Text>
            </View>
            <View style={styles.metricBox}>
              <Text style={styles.metricValGreen}>5</Text>
              <Text style={styles.metricLbl}>Remediated Gaps</Text>
            </View>
          </View>
        </View>

        <Text style={styles.sectionTitle}>Detected Misconceptions ({MISCONCEPTIONS_DATA.length})</Text>

        {MISCONCEPTIONS_DATA.map((item: MisconceptionAnalysis) => (
          <View key={item.id} style={styles.miscCard}>
            <View style={styles.cardHeaderRow}>
              <Text style={styles.topicBadge}>{item.topic_title.toUpperCase()}</Text>
              <Text style={styles.triggerBadge}>TRIGGERED {item.triggered_count}x</Text>
            </View>

            <Text style={styles.miscTitle}>{item.misconception_title}</Text>

            {/* Error Pattern Box */}
            <View style={styles.errorBox}>
              <Text style={styles.boxTagRed}>DIAGNOSED MISTAKE PATTERN:</Text>
              <Text style={styles.errorText}>{item.error_pattern}</Text>
            </View>

            {/* Correct Rule Box */}
            <View style={styles.correctBox}>
              <Text style={styles.boxTagGreen}>CORRECT MATHEMATICAL RULE:</Text>
              <Text style={styles.correctText}>{item.correct_rule}</Text>
            </View>

            {/* Prerequisite Gap Tag */}
            <View style={styles.gapBox}>
              <Text style={styles.gapLabel}>Identified Prerequisite Gap:</Text>
              <Text style={styles.gapText}>⚠️ {item.prerequisite_gap}</Text>
            </View>

            <TouchableOpacity
              style={styles.remediateBtn}
              onPress={() => router.push('/explore')}
              activeOpacity={0.8}
            >
              <Text style={styles.remediateBtnText}>⚡ Remediate Misconception Now</Text>
            </TouchableOpacity>
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
    header: {
      // Fixed navy highlight card — see index.tsx's parentBanner note.
      backgroundColor: '#1E1B4B',
      borderColor: '#4338CA',
      borderWidth: 1,
      borderRadius: 20,
      padding: 20,
      marginBottom: 16,
    },
    badgeText: { color: '#EF4444', fontSize: 10, fontWeight: 'bold', letterSpacing: 1 },
    title: { color: '#FFFFFF', fontSize: 26, fontWeight: 'bold', marginTop: 4 },
    subtitle: { color: '#C7D2FE', fontSize: 13, marginTop: 4, lineHeight: 18 },
    summaryCard: {
      backgroundColor: colors.surface,
      borderColor: colors.border,
      borderWidth: 1,
      borderRadius: 16,
      padding: 16,
      marginBottom: 16,
    },
    summaryTitle: { color: colors.text, fontSize: 14, fontWeight: 'bold', marginBottom: 12 },
    metricGrid: { flexDirection: 'row', gap: 10 },
    metricBox: { flex: 1, backgroundColor: colors.surfaceSecondary, borderRadius: 12, padding: 12, alignItems: 'center' },
    metricValRed: { color: '#EF4444', fontSize: 22, fontWeight: 'bold' },
    metricValGreen: { color: '#10B981', fontSize: 22, fontWeight: 'bold' },
    metricLbl: { color: colors.textMuted, fontSize: 11, marginTop: 2 },
    sectionTitle: { color: colors.text, fontSize: 18, fontWeight: 'bold', marginBottom: 12 },
    miscCard: {
      backgroundColor: colors.surface,
      borderColor: '#EF4444',
      borderWidth: 1,
      borderRadius: 16,
      padding: 16,
      marginBottom: 16,
    },
    cardHeaderRow: { flexDirection: 'row', justifyContent: 'space-between', alignItems: 'center' },
    topicBadge: { color: '#F59E0B', fontSize: 10, fontWeight: 'bold', letterSpacing: 1 },
    triggerBadge: { backgroundColor: '#7F1D1D', color: '#FCA5A5', fontSize: 9, fontWeight: 'bold', paddingHorizontal: 8, paddingVertical: 2, borderRadius: 4 },
    miscTitle: { color: colors.text, fontSize: 17, fontWeight: 'bold', marginTop: 4, marginBottom: 12 },
    errorBox: { backgroundColor: colors.dangerSurface, borderColor: colors.dangerBorder, borderWidth: 1, borderRadius: 10, padding: 12, marginBottom: 10 },
    boxTagRed: { color: colors.dangerText, fontSize: 10, fontWeight: 'bold' },
    errorText: { color: colors.text, fontSize: 13, marginTop: 4, lineHeight: 18 },
    correctBox: { backgroundColor: colors.successSurface, borderColor: colors.successBorder, borderWidth: 1, borderRadius: 10, padding: 12, marginBottom: 10 },
    boxTagGreen: { color: colors.successText, fontSize: 10, fontWeight: 'bold' },
    correctText: { color: colors.text, fontSize: 13, marginTop: 4, lineHeight: 18 },
    gapBox: { backgroundColor: '#1E1B4B', borderRadius: 10, padding: 10, marginBottom: 14 },
    gapLabel: { color: '#C7D2FE', fontSize: 11, fontWeight: 'bold' },
    gapText: { color: '#FDE68A', fontSize: 12, fontWeight: '600', marginTop: 2 },
    remediateBtn: { backgroundColor: '#EF4444', borderRadius: 12, padding: 14, alignItems: 'center' },
    remediateBtnText: { color: '#FFFFFF', fontSize: 14, fontWeight: 'bold' },
  });
}
