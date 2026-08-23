import React from 'react';
import { StyleSheet, Text, View, ScrollView, TouchableOpacity, SafeAreaView } from 'react-native';
import { useRouter } from 'expo-router';

export default function ParentScreen() {
  const router = useRouter();

  return (
    <SafeAreaView style={styles.container}>
      <ScrollView contentContainerStyle={styles.scrollContent}>
        <TouchableOpacity style={styles.backBtn} onPress={() => router.back()}>
          <Text style={styles.backText}>← Back to Dashboard</Text>
        </TouchableOpacity>

        <View style={styles.header}>
          <Text style={styles.badge}>PARENT REPORT PORTAL</Text>
          <Text style={styles.title}>Child Progress Overview</Text>
          <Text style={styles.studentName}>Student: Chidiebere Okafor (SS2 Mathematics)</Text>
        </View>

        {/* Weekly Stats Summary */}
        <View style={styles.summaryCard}>
          <Text style={styles.summaryTitle}>Weekly Activity Summary</Text>
          <View style={styles.statGrid}>
            <View style={styles.statBox}>
              <Text style={styles.statVal}>4.5 hrs</Text>
              <Text style={styles.statLbl}>Study Time</Text>
            </View>
            <View style={styles.statBox}>
              <Text style={styles.statValGold}>78%</Text>
              <Text style={styles.statLbl}>Overall Mastery</Text>
            </View>
          </View>
        </View>

        {/* Teacher Note Card */}
        <View style={styles.noteCard}>
          <Text style={styles.noteTag}>VERIFIED TEACHER NOTE</Text>
          <Text style={styles.noteText}>
            &ldquo;Chidiebere has improved greatly in Quadratic Factorization this week! Recommend continuing Rescue Mode practice on Trigonometry.&rdquo;
          </Text>
          <Text style={styles.teacherSign}>— Mr. Olanrewaju Bello (Subject Teacher)</Text>
        </View>

        {/* Attention Needed Card */}
        <View style={styles.alertCard}>
          <Text style={styles.alertTag}>ATTENTION RECOMMENDED</Text>
          <Text style={styles.alertTitle}>Trigonometric Ratios (35% Mastery)</Text>
          <Text style={styles.alertSub}>
            Student spent 12 minutes on Sine/Cosine rules with 2 triggered Rescue Mode sessions.
          </Text>
        </View>
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
  studentName: { color: '#94A3B8', fontSize: 13, marginTop: 4 },
  summaryCard: {
    backgroundColor: '#1E1B4B',
    borderColor: '#4338CA',
    borderWidth: 1,
    borderRadius: 16,
    padding: 16,
    marginBottom: 16,
  },
  summaryTitle: { color: '#FFFFFF', fontSize: 14, fontWeight: 'bold', marginBottom: 12 },
  statGrid: { flexDirection: 'row', gap: 10 },
  statBox: { flex: 1, backgroundColor: '#0F172A', borderRadius: 10, padding: 12, alignItems: 'center' },
  statVal: { color: '#38BDF8', fontSize: 20, fontWeight: 'bold' },
  statValGold: { color: '#F59E0B', fontSize: 20, fontWeight: 'bold' },
  statLbl: { color: '#94A3B8', fontSize: 11, marginTop: 2 },
  noteCard: {
    backgroundColor: '#78350F22',
    borderColor: '#D97706',
    borderWidth: 1,
    borderRadius: 16,
    padding: 16,
    marginBottom: 16,
  },
  noteTag: { color: '#F59E0B', fontSize: 10, fontWeight: 'bold', letterSpacing: 1 },
  noteText: { color: '#FEF3C7', fontSize: 13, fontStyle: 'italic', marginTop: 6, lineHeight: 18 },
  teacherSign: { color: '#FDE68A', fontSize: 11, fontWeight: 'bold', marginTop: 8, textAlign: 'right' },
  alertCard: {
    backgroundColor: '#7F1D1D22',
    borderColor: '#EF4444',
    borderWidth: 1,
    borderRadius: 16,
    padding: 16,
  },
  alertTag: { color: '#EF4444', fontSize: 10, fontWeight: 'bold', letterSpacing: 1 },
  alertTitle: { color: '#FFFFFF', fontSize: 14, fontWeight: 'bold', marginTop: 4 },
  alertSub: { color: '#FCA5A5', fontSize: 12, marginTop: 2, lineHeight: 16 },
});
