import React, { useState } from 'react';
import {
  StyleSheet,
  Text,
  View,
  ScrollView,
  TouchableOpacity,
  SafeAreaView,
  Switch,
  StatusBar,
} from 'react-native';
import { useRouter } from 'expo-router';

export default function SettingsScreen() {
  const router = useRouter();

  const [selectedClass, setSelectedClass] = useState('SS2');
  const [offlineSyncEnabled, setOfflineSyncEnabled] = useState(true);
  const [examShortcutsEnabled, setExamShortcutsEnabled] = useState(true);
  const [activeRole, setActiveRole] = useState<'Student' | 'Teacher' | 'Parent'>('Student');

  return (
    <SafeAreaView style={styles.container}>
      <StatusBar barStyle="light-content" backgroundColor="#090D16" />
      <ScrollView contentContainerStyle={styles.scrollContent}>
        <TouchableOpacity style={styles.backBtn} onPress={() => router.back()}>
          <Text style={styles.backText}>← Back to Dashboard</Text>
        </TouchableOpacity>

        {/* Header */}
        <View style={styles.header}>
          <Text style={styles.badgeText}>PREFERENCES & ACCOUNT</Text>
          <Text style={styles.title}>App Settings</Text>
          <Text style={styles.subtitle}>
            Manage your active class, curriculum target, offline content sync, and role access.
          </Text>
        </View>

        {/* Profile Card */}
        <View style={styles.profileCard}>
          <View style={styles.avatarCircle}>
            <Text style={styles.avatarText}>🎓</Text>
          </View>
          <View style={{ flex: 1 }}>
            <Text style={styles.userName}>Chidiebere Okafor</Text>
            <Text style={styles.userRole}>Active Level: {selectedClass} Mathematics (WAEC 2026)</Text>
            <Text style={styles.userSchool}>Government Secondary School, Ikeja</Text>
          </View>
        </View>

        {/* Role Switcher */}
        <Text style={styles.sectionTitle}>Active Role Portal</Text>
        <View style={styles.roleGrid}>
          {(['Student', 'Teacher', 'Parent'] as const).map((role) => {
            const isSelected = activeRole === role;
            return (
              <TouchableOpacity
                key={role}
                style={[styles.roleChip, isSelected && styles.roleChipActive]}
                onPress={() => {
                  setActiveRole(role);
                  if (role === 'Teacher') router.push('/teacher');
                  if (role === 'Parent') router.push('/parent');
                }}
              >
                <Text style={[styles.roleChipText, isSelected && styles.roleChipTextActive]}>
                  {role} Portal
                </Text>
              </TouchableOpacity>
            );
          })}
        </View>

        {/* Class Selector */}
        <Text style={styles.sectionTitle}>Curriculum Level</Text>
        <View style={styles.card}>
          <Text style={styles.cardTitle}>Selected Target Class</Text>
          <View style={styles.classRow}>
            {['JSS3', 'SS1', 'SS2', 'SS3'].map((cls) => {
              const isSel = selectedClass === cls;
              return (
                <TouchableOpacity
                  key={cls}
                  style={[styles.classChip, isSel && styles.classChipActive]}
                  onPress={() => setSelectedClass(cls)}
                >
                  <Text style={[styles.classChipText, isSel && styles.classChipTextActive]}>
                    {cls}
                  </Text>
                </TouchableOpacity>
              );
            })}
          </View>
        </View>

        {/* Preferences & Toggles */}
        <Text style={styles.sectionTitle}>Learning Preferences & Sync</Text>

        <View style={styles.card}>
          <View style={styles.toggleRow}>
            <View style={{ flex: 1, paddingRight: 10 }}>
              <Text style={styles.toggleTitle}>Offline Content Cache</Text>
              <Text style={styles.toggleSub}>
                Download questions and theory for study without active internet.
              </Text>
            </View>
            <Switch
              value={offlineSyncEnabled}
              onValueChange={setOfflineSyncEnabled}
              trackColor={{ false: '#1E293B', true: '#10B981' }}
              thumbColor={offlineSyncEnabled ? '#FFFFFF' : '#94A3B8'}
            />
          </View>

          <View style={styles.divider} />

          <View style={styles.toggleRow}>
            <View style={{ flex: 1, paddingRight: 10 }}>
              <Text style={styles.toggleTitle}>WAEC MCQ Exam Shortcuts</Text>
              <Text style={styles.toggleSub}>
                Show speed-solving tips automatically after completing questions.
              </Text>
            </View>
            <Switch
              value={examShortcutsEnabled}
              onValueChange={setExamShortcutsEnabled}
              trackColor={{ false: '#1E293B', true: '#F59E0B' }}
              thumbColor={examShortcutsEnabled ? '#FFFFFF' : '#94A3B8'}
            />
          </View>
        </View>

        {/* Offline Sync Status */}
        <View style={styles.syncStatusCard}>
          <Text style={styles.syncTag}>OFFLINE SYNC STATUS</Text>
          <Text style={styles.syncTitle}>Local Cache: 42 Topics & 150 Questions</Text>
          <Text style={styles.syncSub}>Last synchronized: Just now • Ready for offline learning</Text>
        </View>

        {/* App Info Footer */}
        <View style={styles.appInfoBox}>
          <Text style={styles.appInfoTitle}>Mathora Mobile v1.0.0</Text>
          <Text style={styles.appInfoSub}>Built from a Concerned Teacher's Experience</Text>
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
  header: {
    backgroundColor: '#1E1B4B',
    borderColor: '#4338CA',
    borderWidth: 1,
    borderRadius: 20,
    padding: 20,
    marginBottom: 16,
  },
  badgeText: { color: '#38BDF8', fontSize: 10, fontWeight: 'bold', letterSpacing: 1 },
  title: { color: '#FFFFFF', fontSize: 26, fontWeight: 'bold', marginTop: 4 },
  subtitle: { color: '#94A3B8', fontSize: 13, marginTop: 4, lineHeight: 18 },
  profileCard: {
    backgroundColor: '#0F172A',
    borderColor: '#1E293B',
    borderWidth: 1,
    borderRadius: 16,
    padding: 16,
    flexDirection: 'row',
    alignItems: 'center',
    gap: 14,
    marginBottom: 18,
  },
  avatarCircle: {
    width: 50,
    height: 50,
    borderRadius: 25,
    backgroundColor: '#1E1B4B',
    justifyContent: 'center',
    alignItems: 'center',
    borderColor: '#4338CA',
    borderWidth: 1,
  },
  avatarText: { fontSize: 24 },
  userName: { color: '#FFFFFF', fontSize: 17, fontWeight: 'bold' },
  userRole: { color: '#F59E0B', fontSize: 12, fontWeight: '600', marginTop: 2 },
  userSchool: { color: '#94A3B8', fontSize: 11, marginTop: 2 },
  sectionTitle: { color: '#F8FAFC', fontSize: 16, fontWeight: 'bold', marginBottom: 10 },
  roleGrid: { flexDirection: 'row', gap: 8, marginBottom: 18 },
  roleChip: { flex: 1, backgroundColor: '#0F172A', borderColor: '#1E293B', borderWidth: 1, borderRadius: 12, padding: 12, alignItems: 'center' },
  roleChipActive: { backgroundColor: '#1E1B4B', borderColor: '#38BDF8' },
  roleChipText: { color: '#94A3B8', fontSize: 12, fontWeight: '600' },
  roleChipTextActive: { color: '#38BDF8', fontWeight: 'bold' },
  card: { backgroundColor: '#0F172A', borderColor: '#1E293B', borderWidth: 1, borderRadius: 16, padding: 16, marginBottom: 18 },
  cardTitle: { color: '#FFFFFF', fontSize: 14, fontWeight: 'bold', marginBottom: 12 },
  classRow: { flexDirection: 'row', gap: 10 },
  classChip: { flex: 1, backgroundColor: '#1E1B4B33', borderColor: '#312E81', borderWidth: 1, borderRadius: 10, padding: 12, alignItems: 'center' },
  classChipActive: { backgroundColor: '#78350F', borderColor: '#F59E0B' },
  classChipText: { color: '#94A3B8', fontSize: 13, fontWeight: 'bold' },
  classChipTextActive: { color: '#FDE68A' },
  toggleRow: { flexDirection: 'row', justifyContent: 'space-between', alignItems: 'center' },
  toggleTitle: { color: '#FFFFFF', fontSize: 14, fontWeight: 'bold' },
  toggleSub: { color: '#94A3B8', fontSize: 11, marginTop: 2, lineHeight: 16 },
  divider: { height: 1, backgroundColor: '#1E293B', marginVertical: 14 },
  syncStatusCard: { backgroundColor: '#064E3B22', borderColor: '#059669', borderWidth: 1, borderRadius: 14, padding: 14, marginBottom: 20 },
  syncTag: { color: '#34D399', fontSize: 10, fontWeight: 'bold', letterSpacing: 1 },
  syncTitle: { color: '#FFFFFF', fontSize: 14, fontWeight: 'bold', marginTop: 4 },
  syncSub: { color: '#A7F3D0', fontSize: 12, marginTop: 2 },
  appInfoBox: { alignItems: 'center', marginTop: 10, paddingBottom: 20 },
  appInfoTitle: { color: '#64748B', fontSize: 13, fontWeight: 'bold' },
  appInfoSub: { color: '#475569', fontSize: 11, marginTop: 2 },
});
