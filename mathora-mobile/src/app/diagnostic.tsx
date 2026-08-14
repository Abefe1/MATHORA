import React from 'react';
import { StyleSheet, Text, View, ScrollView, TouchableOpacity, SafeAreaView } from 'react-native';
import { useRouter } from 'expo-router';

export default function DiagnosticScreen() {
  const router = useRouter();

  const topics = [
    { title: 'Algebraic Processes & Expansions', status: 'Mastered', percentage: 90, color: '#10B981' },
    { title: 'Quadratic Equations & Roots', status: 'Needs Review', percentage: 65, color: '#F59E0B' },
    { title: 'Trigonometric Ratios & Angles', status: 'Needs Diagnostic', percentage: 0, color: '#EF4444' },
    { title: 'Logarithms & Indices', status: 'Mastered', percentage: 85, color: '#10B981' },
  ];

  return (
    <SafeAreaView style={styles.container}>
      <ScrollView contentContainerStyle={styles.scrollContent}>
        <TouchableOpacity style={styles.backBtn} onPress={() => router.back()}>
          <Text style={styles.backText}>← Back to Dashboard</Text>
        </TouchableOpacity>

        <View style={styles.header}>
          <Text style={styles.badge}>PLACEMENT ASSESSMENT</Text>
          <Text style={styles.title}>Baseline Diagnostic Test</Text>
          <Text style={styles.subtitle}>
            10 multi-choice questions to map your exact strengths and target weak topics automatically.
          </Text>
        </View>

        <View style={styles.bannerCard}>
          <Text style={styles.bannerTitle}>Current Baseline Placement: SS2 Mathematics</Text>
          <Text style={styles.bannerSub}>Overall Estimated WAEC Readiness Score: 78%</Text>
        </View>

        <Text style={styles.sectionHeader}>Topic Placement Map</Text>

        {topics.map((item, idx) => (
          <View key={idx} style={styles.topicCard}>
            <View style={styles.topicHeaderRow}>
              <Text style={styles.topicTitle}>{item.title}</Text>
              <Text style={[styles.statusBadge, { color: item.color }]}>{item.status}</Text>
            </View>
            <View style={styles.progressBg}>
              <View style={[styles.progressFill, { width: `${item.percentage}%`, backgroundColor: item.color }]} />
            </View>
            <Text style={styles.percentageText}>{item.percentage}% Placement Score</Text>
          </View>
        ))}

        <TouchableOpacity style={styles.startBtn} onPress={() => router.push('/practice')}>
          <Text style={styles.startBtnText}>Start Full 10-Question Diagnostic</Text>
        </TouchableOpacity>
      </ScrollView>
    </SafeAreaView>
  );
}

const styles = StyleSheet.create({
  container: { flex: 1, backgroundColor: '#090D16' },
  scrollContent: { padding: 16 },
  backBtn: { marginBottom: 12 },
  backText: { color: '#38BDF8', fontSize: 14, fontWeight: 'bold' },
  header: { marginBottom: 16 },
  badge: { color: '#38BDF8', fontSize: 10, fontWeight: 'bold', letterSpacing: 1 },
  title: { color: '#FFFFFF', fontSize: 24, fontWeight: 'bold', marginTop: 2 },
  subtitle: { color: '#94A3B8', fontSize: 13, marginTop: 4, lineHeight: 18 },
  bannerCard: {
    backgroundColor: '#1E1B4B',
    borderColor: '#4338CA',
    borderWidth: 1,
    borderRadius: 16,
    padding: 16,
    marginBottom: 20,
  },
  bannerTitle: { color: '#FFFFFF', fontSize: 15, fontWeight: 'bold' },
  bannerSub: { color: '#F59E0B', fontSize: 13, fontWeight: 'bold', marginTop: 4 },
  sectionHeader: { color: '#F8FAFC', fontSize: 16, fontWeight: 'bold', marginBottom: 12 },
  topicCard: {
    backgroundColor: '#0F172A',
    borderColor: '#1E293B',
    borderWidth: 1,
    borderRadius: 12,
    padding: 14,
    marginBottom: 10,
  },
  topicHeaderRow: { flexDirection: 'row', justifyContent: 'space-between', alignItems: 'center' },
  topicTitle: { color: '#FFFFFF', fontSize: 14, fontWeight: '600', flex: 1 },
  statusBadge: { fontSize: 11, fontWeight: 'bold' },
  progressBg: { height: 6, backgroundColor: '#1E293B', borderRadius: 3, marginTop: 10, overflow: 'hidden' },
  progressFill: { height: '100%', borderRadius: 3 },
  percentageText: { color: '#64748B', fontSize: 11, fontWeight: 'bold', marginTop: 4, textAlign: 'right' },
  startBtn: { backgroundColor: '#38BDF8', borderRadius: 12, padding: 16, alignItems: 'center', marginTop: 14 },
  startBtnText: { color: '#090D16', fontSize: 16, fontWeight: 'bold' },
});
