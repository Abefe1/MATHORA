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

export default function ProfileScreen() {
  const router = useRouter();
  const [offlineSync, setOfflineSync] = useState(true);
  const [darkTheme, setDarkTheme] = useState(false);
  const [selectedRole, setSelectedRole] = useState<'Student' | 'Teacher' | 'Parent'>('Student');

  return (
    <SafeAreaView style={styles.container}>
      <StatusBar barStyle="dark-content" backgroundColor="#F8FAFC" />
      <ScrollView contentContainerStyle={styles.scrollContent} showsVerticalScrollIndicator={false}>
        {/* Top Header */}
        <View style={styles.header}>
          <Text style={styles.title}>Student Profile</Text>
          <Text style={styles.subtitle}>Account Preferences & Role Portals</Text>
        </View>

        {/* Profile Card */}
        <View style={styles.profileCard}>
          <View style={styles.avatarCircle}>
            <Text style={styles.avatarEmoji}>🎓</Text>
          </View>
          <Text style={styles.profileName}>Ahmed Okafor</Text>
          <Text style={styles.profileLevel}>SS2 Mathematics • WAEC 2026</Text>
          <Text style={styles.profileSchool}>Federal Government College, Lagos</Text>
        </View>

        {/* Role Portal Switcher */}
        <Text style={styles.sectionTitle}>Active Role Portal</Text>
        <View style={styles.roleGrid}>
          {(['Student', 'Teacher', 'Parent'] as const).map((role) => {
            const isSelected = selectedRole === role;
            return (
              <TouchableOpacity
                key={role}
                style={[styles.roleCard, isSelected && styles.roleCardActive]}
                onPress={() => {
                  setSelectedRole(role);
                  if (role === 'Teacher') router.push('/teacher');
                  if (role === 'Parent') router.push('/parent');
                }}
              >
                <Text style={[styles.roleText, isSelected && styles.roleTextActive]}>{role}</Text>
              </TouchableOpacity>
            );
          })}
        </View>

        {/* Preferences List */}
        <Text style={styles.sectionTitle}>App Settings</Text>

        <View style={styles.settingsGroup}>
          <View style={styles.settingRow}>
            <View>
              <Text style={styles.settingLabel}>Offline Data Cache</Text>
              <Text style={styles.settingSub}>Keep questions available without internet</Text>
            </View>
            <Switch
              value={offlineSync}
              onValueChange={setOfflineSync}
              trackColor={{ false: '#CBD5E1', true: '#2563EB' }}
            />
          </View>

          <View style={styles.settingRow}>
            <View>
              <Text style={styles.settingLabel}>Dark Theme</Text>
              <Text style={styles.settingSub}>High-contrast math typesetting</Text>
            </View>
            <Switch
              value={darkTheme}
              onValueChange={setDarkTheme}
              trackColor={{ false: '#CBD5E1', true: '#2563EB' }}
            />
          </View>
        </View>

        {/* System Info */}
        <View style={styles.systemCard}>
          <Text style={styles.systemText}>Mathora Mobile v2.1.0 • NERDC Aligned</Text>
          <Text style={styles.systemSub}>Synced with Supabase Backend</Text>
        </View>
      </ScrollView>
    </SafeAreaView>
  );
}

const styles = StyleSheet.create({
  container: { flex: 1, backgroundColor: '#F8FAFC' },
  scrollContent: { padding: 20, paddingBottom: 40 },
  header: { marginBottom: 20 },
  title: { color: '#0F172A', fontSize: 24, fontWeight: '800' },
  subtitle: { color: '#64748B', fontSize: 13, marginTop: 2 },
  profileCard: {
    backgroundColor: '#FFFFFF',
    borderColor: '#E2E8F0',
    borderWidth: 1,
    borderRadius: 16,
    padding: 20,
    alignItems: 'center',
    marginBottom: 24,
    shadowColor: '#0F172A',
    shadowOffset: { width: 0, height: 2 },
    shadowOpacity: 0.04,
    shadowRadius: 6,
  },
  avatarCircle: {
    width: 60,
    height: 60,
    borderRadius: 30,
    backgroundColor: '#EFF6FF',
    justifyContent: 'center',
    alignItems: 'center',
    marginBottom: 12,
  },
  avatarEmoji: { fontSize: 28 },
  profileName: { color: '#0F172A', fontSize: 18, fontWeight: '800' },
  profileLevel: { color: '#2563EB', fontSize: 13, fontWeight: '700', marginTop: 2 },
  profileSchool: { color: '#64748B', fontSize: 12, marginTop: 4 },
  sectionTitle: { color: '#0F172A', fontSize: 16, fontWeight: '700', marginBottom: 12 },
  roleGrid: { flexDirection: 'row', gap: 10, marginBottom: 24 },
  roleCard: {
    flex: 1,
    backgroundColor: '#FFFFFF',
    borderColor: '#E2E8F0',
    borderWidth: 1,
    borderRadius: 12,
    paddingVertical: 12,
    alignItems: 'center',
  },
  roleCardActive: { backgroundColor: '#EFF6FF', borderColor: '#2563EB' },
  roleText: { color: '#64748B', fontSize: 13, fontWeight: '600' },
  roleTextActive: { color: '#2563EB', fontWeight: '700' },
  settingsGroup: {
    backgroundColor: '#FFFFFF',
    borderColor: '#E2E8F0',
    borderWidth: 1,
    borderRadius: 16,
    padding: 16,
    marginBottom: 24,
  },
  settingRow: {
    flexDirection: 'row',
    justifyContent: 'space-between',
    alignItems: 'center',
    paddingVertical: 10,
    borderBottomWidth: 1,
    borderColor: '#F1F5F9',
  },
  settingLabel: { color: '#0F172A', fontSize: 14, fontWeight: '700' },
  settingSub: { color: '#64748B', fontSize: 12, marginTop: 2 },
  systemCard: { alignItems: 'center', marginTop: 12 },
  systemText: { color: '#94A3B8', fontSize: 12, fontWeight: '600' },
  systemSub: { color: '#CBD5E1', fontSize: 11, marginTop: 2 },
});
