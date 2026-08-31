import React, { useMemo, useState } from 'react';
import {
  StyleSheet,
  Text,
  View,
  ScrollView,
  TouchableOpacity,
  SafeAreaView,
  Switch,
  StatusBar,
  useColorScheme,
} from 'react-native';
import { useRouter } from 'expo-router';
import { useAuth } from '@/lib/authContext';
import { useTheme } from '@/hooks/use-theme';

export default function ProfileScreen() {
  const router = useRouter();
  const { user, signOut } = useAuth();
  const colors = useTheme();
  const scheme = useColorScheme();
  const styles = useMemo(() => createStyles(colors), [colors]);
  const [offlineSync, setOfflineSync] = useState(true);
  const [selectedRole, setSelectedRole] = useState<'Student' | 'Teacher' | 'Parent'>('Student');

  const displayName = (user?.user_metadata?.full_name as string | undefined) || user?.email || 'Signed in';

  return (
    <SafeAreaView style={styles.container}>
      <StatusBar barStyle={scheme === 'dark' ? 'light-content' : 'dark-content'} backgroundColor={colors.background} />
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
          <Text style={styles.profileName}>{displayName}</Text>
          <Text style={styles.profileLevel}>SS2 Mathematics • WAEC 2026</Text>
          <Text style={styles.profileSchool}>{user?.email ?? 'Not signed in'}</Text>
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
              trackColor={{ false: colors.border, true: '#F59E0B' }}
            />
          </View>

          <View style={[styles.settingRow, styles.settingRowLast]}>
            <View>
              <Text style={styles.settingLabel}>Theme</Text>
              <Text style={styles.settingSub}>Follows your device&apos;s light/dark setting</Text>
            </View>
            <Text style={styles.settingValue}>{scheme === 'dark' ? 'Dark' : 'Light'}</Text>
          </View>
        </View>

        <TouchableOpacity style={styles.signOutBtn} onPress={signOut} activeOpacity={0.85}>
          <Text style={styles.signOutText}>Sign Out</Text>
        </TouchableOpacity>

        {/* System Info */}
        <View style={styles.systemCard}>
          <Text style={styles.systemText}>Mathora Mobile v2.1.0 • NERDC Aligned</Text>
          <Text style={styles.systemSub}>Synced with Supabase Backend</Text>
        </View>
      </ScrollView>
    </SafeAreaView>
  );
}

function createStyles(colors: ReturnType<typeof useTheme>) {
  return StyleSheet.create({
    container: { flex: 1, backgroundColor: colors.background },
    scrollContent: { padding: 20, paddingBottom: 40 },
    header: { marginBottom: 20 },
    title: { color: colors.text, fontSize: 24, fontWeight: '800' },
    subtitle: { color: colors.textMuted, fontSize: 13, marginTop: 2 },
    profileCard: {
      backgroundColor: colors.surface,
      borderColor: colors.border,
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
      backgroundColor: colors.surfaceSecondary,
      justifyContent: 'center',
      alignItems: 'center',
      marginBottom: 12,
    },
    avatarEmoji: { fontSize: 28 },
    profileName: { color: colors.text, fontSize: 18, fontWeight: '800' },
    profileLevel: { color: colors.primary, fontSize: 13, fontWeight: '700', marginTop: 2 },
    profileSchool: { color: colors.textMuted, fontSize: 12, marginTop: 4 },
    sectionTitle: { color: colors.text, fontSize: 16, fontWeight: '700', marginBottom: 12 },
    roleGrid: { flexDirection: 'row', gap: 10, marginBottom: 24 },
    roleCard: {
      flex: 1,
      backgroundColor: colors.surface,
      borderColor: colors.border,
      borderWidth: 1,
      borderRadius: 12,
      paddingVertical: 12,
      alignItems: 'center',
    },
    roleCardActive: { backgroundColor: colors.warningSurface, borderColor: colors.primary },
    roleText: { color: colors.textMuted, fontSize: 13, fontWeight: '600' },
    roleTextActive: { color: colors.primary, fontWeight: '700' },
    settingsGroup: {
      backgroundColor: colors.surface,
      borderColor: colors.border,
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
      borderColor: colors.surfaceSecondary,
    },
    settingRowLast: { borderBottomWidth: 0 },
    settingLabel: { color: colors.text, fontSize: 14, fontWeight: '700' },
    settingSub: { color: colors.textMuted, fontSize: 12, marginTop: 2 },
    settingValue: { color: colors.textMuted, fontSize: 13, fontWeight: '700' },
    signOutBtn: {
      borderWidth: 1,
      borderColor: colors.dangerBorder,
      backgroundColor: colors.dangerSurface,
      borderRadius: 12,
      paddingVertical: 12,
      alignItems: 'center',
      marginBottom: 8,
    },
    signOutText: { color: colors.dangerText, fontSize: 13, fontWeight: '700' },
    systemCard: { alignItems: 'center', marginTop: 12 },
    systemText: { color: colors.textMuted, fontSize: 12, fontWeight: '600' },
    systemSub: { color: colors.border, fontSize: 11, marginTop: 2 },
  });
}
