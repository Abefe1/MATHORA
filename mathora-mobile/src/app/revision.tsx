import React from 'react';
import { StyleSheet, Text, View, ScrollView, TouchableOpacity, SafeAreaView } from 'react-native';
import { useRouter } from 'expo-router';

export default function RevisionScreen() {
  const router = useRouter();

  const reviewsDue = [
    { topic: 'Quadratic Discriminant & Real Roots', interval: 'Due Today (Day 3)', count: 2, urgent: true },
    { topic: 'Logarithmic Laws & Simplification', interval: 'Due Tomorrow (Day 7)', count: 3, urgent: false },
    { topic: 'Trigonometric Sine & Cosine Rules', interval: 'Due in 3 Days (Day 14)', count: 4, urgent: false },
  ];

  return (
    <SafeAreaView style={styles.container}>
      <ScrollView contentContainerStyle={styles.scrollContent}>
        <TouchableOpacity style={styles.backBtn} onPress={() => router.back()}>
          <Text style={styles.backText}>← Back to Dashboard</Text>
        </TouchableOpacity>

        <View style={styles.header}>
          <Text style={styles.badge}>SPACED MEMORY REVISION</Text>
          <Text style={styles.title}>Spaced Practice Scheduler</Text>
          <Text style={styles.subtitle}>
            Algorithms schedule target practice intervals (1d, 3d, 7d, 30d) so mathematical concepts transition into permanent long-term memory.
          </Text>
        </View>

        <View style={styles.metricRow}>
          <View style={styles.metricBox}>
            <Text style={styles.metricVal}>4</Text>
            <Text style={styles.metricLbl}>Reviews Due Today</Text>
          </View>
          <View style={styles.metricBox}>
            <Text style={styles.metricValGreen}>92%</Text>
            <Text style={styles.metricLbl}>Retention Index</Text>
          </View>
        </View>

        <Text style={styles.sectionHeader}>Revision Queue</Text>

        {reviewsDue.map((item, idx) => (
          <View key={idx} style={[styles.queueCard, item.urgent && styles.queueCardUrgent]}>
            <View style={styles.queueHeaderRow}>
              <Text style={styles.queueTopic}>{item.topic}</Text>
              <Text style={[styles.queueBadge, item.urgent ? styles.badgeUrgent : styles.badgeNormal]}>
                {item.interval}
              </Text>
            </View>
            <Text style={styles.queueSub}>{item.count} targeted questions pending review</Text>
            <TouchableOpacity style={styles.reviewBtn} onPress={() => router.push('/practice')}>
              <Text style={styles.reviewBtnText}>Start Revision ({item.count} items)</Text>
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
  header: { marginBottom: 16 },
  badge: { color: '#F59E0B', fontSize: 10, fontWeight: 'bold', letterSpacing: 1 },
  title: { color: '#FFFFFF', fontSize: 24, fontWeight: 'bold', marginTop: 2 },
  subtitle: { color: '#94A3B8', fontSize: 13, marginTop: 4, lineHeight: 18 },
  metricRow: { flexDirection: 'row', gap: 10, marginBottom: 20 },
  metricBox: { flex: 1, backgroundColor: '#1E1B4B', borderRadius: 12, padding: 14, alignItems: 'center' },
  metricVal: { color: '#F59E0B', fontSize: 24, fontWeight: 'bold' },
  metricValGreen: { color: '#10B981', fontSize: 24, fontWeight: 'bold' },
  metricLbl: { color: '#C7D2FE', fontSize: 11, fontWeight: '600', marginTop: 2 },
  sectionHeader: { color: '#F8FAFC', fontSize: 16, fontWeight: 'bold', marginBottom: 12 },
  queueCard: {
    backgroundColor: '#0F172A',
    borderColor: '#1E293B',
    borderWidth: 1,
    borderRadius: 14,
    padding: 14,
    marginBottom: 12,
  },
  queueCardUrgent: { borderColor: '#F59E0B', backgroundColor: '#78350F22' },
  queueHeaderRow: { flexDirection: 'row', justifyContent: 'space-between', alignItems: 'flex-start', gap: 8 },
  queueTopic: { color: '#FFFFFF', fontSize: 15, fontWeight: 'bold', flex: 1 },
  queueBadge: { fontSize: 10, fontWeight: 'bold', paddingHorizontal: 8, paddingVertical: 2, borderRadius: 4 },
  badgeUrgent: { backgroundColor: '#78350F', color: '#FDE68A' },
  badgeNormal: { backgroundColor: '#1E293B', color: '#94A3B8' },
  queueSub: { color: '#94A3B8', fontSize: 12, marginTop: 4, marginBottom: 12 },
  reviewBtn: { backgroundColor: '#F59E0B', borderRadius: 8, paddingVertical: 10, alignItems: 'center' },
  reviewBtnText: { color: '#090D16', fontSize: 13, fontWeight: 'bold' },
});
