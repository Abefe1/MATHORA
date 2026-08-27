import React, { useState } from 'react';
import { StyleSheet, Text, View, ScrollView, TouchableOpacity, SafeAreaView, Alert } from 'react-native';
import { useRouter } from 'expo-router';

export default function ParentScreen() {
  const router = useRouter();
  const [selectedChild, setSelectedChild] = useState<'chidiebere' | 'nneka'>('chidiebere');

  const shareReportViaWhatsApp = () => {
    Alert.alert(
      'DCOMPANION WhatsApp Share',
      `Summary report for ${selectedChild === 'chidiebere' ? 'Chidiebere Okafor' : 'Nneka Okafor'} copied to clipboard for WhatsApp parent groups.`,
      [{ text: 'OK' }]
    );
  };

  return (
    <SafeAreaView style={styles.container}>
      <ScrollView contentContainerStyle={styles.scrollContent}>
        <TouchableOpacity style={styles.backBtn} onPress={() => router.back()}>
          <Text style={styles.backText}>← Back to Dashboard</Text>
        </TouchableOpacity>

        {/* Header */}
        <View style={styles.header}>
          <View style={styles.badgeRow}>
            <Text style={styles.badge}>DCOMPANION PARENT PORTAL</Text>
            <Text style={styles.lockBadge}>🔒 Parent Lock Active</Text>
          </View>
          <Text style={styles.title}>Child Progress &amp; Oversight</Text>
          <Text style={styles.subText}>Track WAEC &amp; BECE syllabus mastery in real time</Text>
        </View>

        {/* Child Switcher */}
        <View style={styles.childSwitcher}>
          <TouchableOpacity
            style={[styles.childChip, selectedChild === 'chidiebere' && styles.childChipActive]}
            onPress={() => setSelectedChild('chidiebere')}
          >
            <Text style={[styles.childChipText, selectedChild === 'chidiebere' && styles.childChipTextActive]}>
              Chidiebere (SS2)
            </Text>
          </TouchableOpacity>

          <TouchableOpacity
            style={[styles.childChip, selectedChild === 'nneka' && styles.childChipActive]}
            onPress={() => setSelectedChild('nneka')}
          >
            <Text style={[styles.childChipText, selectedChild === 'nneka' && styles.childChipTextActive]}>
              Nneka (JSS3)
            </Text>
          </TouchableOpacity>
        </View>

        {/* Weekly Stats Summary */}
        <View style={styles.summaryCard}>
          <Text style={styles.summaryTitle}>
            {selectedChild === 'chidiebere' ? 'Chidiebere Okafor' : 'Nneka Okafor'} — Performance
          </Text>
          <View style={styles.statGrid}>
            <View style={styles.statBox}>
              <Text style={styles.statVal}>
                {selectedChild === 'chidiebere' ? '4.5 hrs' : '5.2 hrs'}
              </Text>
              <Text style={styles.statLbl}>Study Time (This Week)</Text>
            </View>
            <View style={styles.statBox}>
              <Text style={styles.statValGold}>
                {selectedChild === 'chidiebere' ? '72.4%' : '88.0%'}
              </Text>
              <Text style={styles.statLbl}>Overall Mastery</Text>
            </View>
          </View>

          <View style={styles.readinessBox}>
            <Text style={styles.readinessLbl}>WAEC/BECE Exam Readiness Index</Text>
            <Text style={styles.readinessVal}>
              {selectedChild === 'chidiebere' ? '81 / 100 (Grade A1 Track)' : '94 / 100 (Top 5%)'}
            </Text>
          </View>
        </View>

        {/* Teacher Note Card */}
        <View style={styles.noteCard}>
          <Text style={styles.noteTag}>VERIFIED TEACHER REMARK</Text>
          <Text style={styles.noteText}>
            {selectedChild === 'chidiebere'
              ? '“Chidiebere has improved greatly in Quadratic Factorization this week! Recommend continuing Rescue Mode practice on Trigonometry.”'
              : '“Nneka is showing top-tier speed in BECE Algebra practice! Keep encouraging her daily streak.”'}
          </Text>
          <Text style={styles.teacherSign}>
            {selectedChild === 'chidiebere' ? '— Mr. Olanrewaju Bello (Math HOD)' : '— Mrs. Cynthia Agbo (Teacher)'}
          </Text>
        </View>

        {/* Attention Needed Card */}
        <View style={styles.alertCard}>
          <Text style={styles.alertTag}>ATTENTION RECOMMENDED</Text>
          <Text style={styles.alertTitle}>
            {selectedChild === 'chidiebere' ? 'Trigonometric Ratios (40% Mastery)' : 'Plane Geometry & Angle Proofs (62%)'}
          </Text>
          <Text style={styles.alertSub}>
            {selectedChild === 'chidiebere'
              ? '2 triggered Rescue Mode sessions on Sine & Cosine rules.'
              : '1 triggered Rescue session on Angles in a Circle.'}
          </Text>
        </View>

        {/* Action Buttons */}
        <TouchableOpacity style={styles.whatsappBtn} onPress={shareReportViaWhatsApp}>
          <Text style={styles.whatsappBtnText}>📲 Share Summary Report via WhatsApp</Text>
        </TouchableOpacity>
      </ScrollView>
    </SafeAreaView>
  );
}

const styles = StyleSheet.create({
  container: { flex: 1, backgroundColor: '#090D16' },
  scrollContent: { padding: 16, paddingBottom: 40 },
  backBtn: { marginBottom: 12 },
  backText: { color: '#F59E0B', fontSize: 14, fontWeight: 'bold' },
  header: { marginBottom: 16 },
  badgeRow: { flexDirection: 'row', alignItems: 'center', justifyContent: 'space-between', gap: 8 },
  badge: { color: '#F59E0B', fontSize: 10, fontWeight: 'bold', letterSpacing: 1 },
  lockBadge: { color: '#10B981', fontSize: 10, fontWeight: 'bold' },
  title: { color: '#FFFFFF', fontSize: 24, fontWeight: 'bold', marginTop: 4 },
  subText: { color: '#94A3B8', fontSize: 12, marginTop: 2 },
  childSwitcher: { flexDirection: 'row', gap: 8, marginBottom: 16 },
  childChip: {
    paddingHorizontal: 14,
    paddingVertical: 8,
    borderRadius: 10,
    backgroundColor: '#1E293B',
    borderWidth: 1,
    borderColor: '#334155',
  },
  childChipActive: { backgroundColor: '#F59E0B', borderColor: '#D97706' },
  childChipText: { color: '#94A3B8', fontSize: 12, fontWeight: 'bold' },
  childChipTextActive: { color: '#090D16' },
  summaryCard: {
    backgroundColor: '#1E1B4B',
    borderColor: '#4338CA',
    borderWidth: 1,
    borderRadius: 16,
    padding: 16,
    marginBottom: 16,
  },
  summaryTitle: { color: '#FFFFFF', fontSize: 15, fontWeight: 'bold', marginBottom: 12 },
  statGrid: { flexDirection: 'row', gap: 10 },
  statBox: { flex: 1, backgroundColor: '#0F172A', borderRadius: 10, padding: 12, alignItems: 'center' },
  statVal: { color: '#38BDF8', fontSize: 20, fontWeight: 'bold' },
  statValGold: { color: '#F59E0B', fontSize: 20, fontWeight: 'bold' },
  statLbl: { color: '#94A3B8', fontSize: 10, marginTop: 2, textAlign: 'center' },
  readinessBox: {
    marginTop: 12,
    backgroundColor: '#0F172A',
    borderRadius: 10,
    padding: 10,
    alignItems: 'center',
  },
  readinessLbl: { color: '#94A3B8', fontSize: 10 },
  readinessVal: { color: '#10B981', fontSize: 13, fontWeight: 'bold', marginTop: 2 },
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
    marginBottom: 16,
  },
  alertTag: { color: '#EF4444', fontSize: 10, fontWeight: 'bold', letterSpacing: 1 },
  alertTitle: { color: '#FFFFFF', fontSize: 14, fontWeight: 'bold', marginTop: 4 },
  alertSub: { color: '#FCA5A5', fontSize: 12, marginTop: 2, lineHeight: 16 },
  whatsappBtn: {
    backgroundColor: '#059669',
    borderRadius: 12,
    paddingVertical: 14,
    alignItems: 'center',
  },
  whatsappBtnText: { color: '#FFFFFF', fontSize: 14, fontWeight: 'bold' },
});
