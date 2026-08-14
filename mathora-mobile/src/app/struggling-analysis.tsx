import React from 'react';
import {
  StyleSheet,
  Text,
  View,
  ScrollView,
  TouchableOpacity,
  SafeAreaView,
  StatusBar,
} from 'react-native';
import { useRouter } from 'expo-router';
import { MISCONCEPTIONS_DATA, MisconceptionAnalysis } from '@/services/dataService';

export default function StrugglingAnalysisScreen() {
  const router = useRouter();

  return (
    <SafeAreaView style={styles.container}>
      <StatusBar barStyle="light-content" backgroundColor="#090D16" />
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

const styles = StyleSheet.create({
  container: { flex: 1, backgroundColor: '#090D16' },
  scrollContent: { padding: 16 },
  backBtn: { marginBottom: 12 },
  backText: { color: '#38BDF8', fontSize: 14, fontWeight: 'bold' },
  header: {
    backgroundColor: '#1E1B4B',
    borderColor: '#4338CA',
    borderWidth: 1,
    borderRadius: 20,
    padding: 20,
    marginBottom: 16,
  },
  badgeText: { color: '#EF4444', fontSize: 10, fontWeight: 'bold', letterSpacing: 1 },
  title: { color: '#FFFFFF', fontSize: 26, fontWeight: 'bold', marginTop: 4 },
  subtitle: { color: '#94A3B8', fontSize: 13, marginTop: 4, lineHeight: 18 },
  summaryCard: {
    backgroundColor: '#0F172A',
    borderColor: '#1E293B',
    borderWidth: 1,
    borderRadius: 16,
    padding: 16,
    marginBottom: 16,
  },
  summaryTitle: { color: '#FFFFFF', fontSize: 14, fontWeight: 'bold', marginBottom: 12 },
  metricGrid: { flexDirection: 'row', gap: 10 },
  metricBox: { flex: 1, backgroundColor: '#1E1B4B33', borderRadius: 12, padding: 12, alignItems: 'center' },
  metricValRed: { color: '#EF4444', fontSize: 22, fontWeight: 'bold' },
  metricValGreen: { color: '#10B981', fontSize: 22, fontWeight: 'bold' },
  metricLbl: { color: '#94A3B8', fontSize: 11, marginTop: 2 },
  sectionTitle: { color: '#F8FAFC', fontSize: 18, fontWeight: 'bold', marginBottom: 12 },
  miscCard: {
    backgroundColor: '#0F172A',
    borderColor: '#EF4444',
    borderWidth: 1,
    borderRadius: 16,
    padding: 16,
    marginBottom: 16,
  },
  cardHeaderRow: { flexDirection: 'row', justifyContent: 'space-between', alignItems: 'center' },
  topicBadge: { color: '#F59E0B', fontSize: 10, fontWeight: 'bold', letterSpacing: 1 },
  triggerBadge: { backgroundColor: '#7F1D1D', color: '#FCA5A5', fontSize: 9, fontWeight: 'bold', paddingHorizontal: 8, paddingVertical: 2, borderRadius: 4 },
  miscTitle: { color: '#FFFFFF', fontSize: 17, fontWeight: 'bold', marginTop: 4, marginBottom: 12 },
  errorBox: { backgroundColor: '#7F1D1D22', borderColor: '#EF4444', borderWidth: 1, borderRadius: 10, padding: 12, marginBottom: 10 },
  boxTagRed: { color: '#FCA5A5', fontSize: 10, fontWeight: 'bold' },
  errorText: { color: '#FEE2E2', fontSize: 13, marginTop: 4, lineHeight: 18 },
  correctBox: { backgroundColor: '#064E3B22', borderColor: '#059669', borderWidth: 1, borderRadius: 10, padding: 12, marginBottom: 10 },
  boxTagGreen: { color: '#34D399', fontSize: 10, fontWeight: 'bold' },
  correctText: { color: '#ECFDF5', fontSize: 13, marginTop: 4, lineHeight: 18 },
  gapBox: { backgroundColor: '#1E1B4B', borderRadius: 10, padding: 10, marginBottom: 14 },
  gapLabel: { color: '#C7D2FE', fontSize: 11, fontWeight: 'bold' },
  gapText: { color: '#FDE68A', fontSize: 12, fontWeight: '600', marginTop: 2 },
  remediateBtn: { backgroundColor: '#EF4444', borderRadius: 12, padding: 14, alignItems: 'center' },
  remediateBtnText: { color: '#FFFFFF', fontSize: 14, fontWeight: 'bold' },
});
