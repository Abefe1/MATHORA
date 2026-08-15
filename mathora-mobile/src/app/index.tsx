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

export default function MathoraHomeScreen() {
  const router = useRouter();

  return (
    <SafeAreaView style={styles.container}>
      <StatusBar barStyle="light-content" backgroundColor="#030712" />
      <ScrollView contentContainerStyle={styles.scrollContent} showsVerticalScrollIndicator={false}>
        {/* Top Student Header Bar */}
        <View style={styles.profileHeader}>
          <View style={styles.profileLeft}>
            <View style={styles.avatarGlowRing}>
              <Text style={styles.avatarEmoji}>🎓</Text>
            </View>
            <View>
              <Text style={styles.greetingText}>Chidiebere Okafor</Text>
              <View style={styles.levelRow}>
                <Text style={styles.levelBadgeText}>SS2 MATHEMATICS</Text>
                <Text style={styles.dotSeparator}>•</Text>
                <Text style={styles.examTargetText}>WAEC 2026</Text>
              </View>
            </View>
          </View>

          <View style={styles.profileRight}>
            <View style={styles.xpPill}>
              <Text style={styles.xpText}>⚡ 1,240 XP</Text>
            </View>
            <View style={styles.streakPill}>
              <Text style={styles.streakText}>🔥 5 Days</Text>
            </View>
          </View>
        </View>

        {/* Metric Cards Row */}
        <View style={styles.metricsGrid}>
          <View style={[styles.metricCard, styles.metricGold]}>
            <Text style={styles.metricValGold}>65%</Text>
            <Text style={styles.metricLbl}>SS2 Mastery</Text>
          </View>
          <View style={[styles.metricCard, styles.metricCyan]}>
            <Text style={styles.metricValCyan}>#1</Text>
            <Text style={styles.metricLbl}>Squad Rank</Text>
          </View>
          <View style={[styles.metricCard, styles.metricGreen]}>
            <Text style={styles.metricValGreen}>4</Text>
            <Text style={styles.metricLbl}>Reviews Due</Text>
          </View>
        </View>

        {/* Featured Hero Card: Resume Practice & Rescue Mode */}
        <View style={styles.sectionHeader}>
          <Text style={styles.sectionTitle}>Active Learning Target</Text>
        </View>

        <TouchableOpacity
          style={styles.featuredCard}
          onPress={() => router.push('/practice')}
          activeOpacity={0.88}
        >
          <View style={styles.featuredTopRow}>
            <View style={styles.rescueTagPill}>
              <Text style={styles.rescueTagText}>⚡ RESUME PRACTICE & RESCUE MODE</Text>
            </View>
            <View style={styles.waecBadge}>
              <Text style={styles.waecBadgeText}>WAEC SS2</Text>
            </View>
          </View>

          <Text style={styles.featuredTopicTitle}>Quadratic Equations & Rescue Methods</Text>
          <Text style={styles.featuredTopicDesc}>
            Master decomposition, factorization, completing the square & WAEC exam traps.
          </Text>

          {/* Progress Bar */}
          <View style={styles.progressContainer}>
            <View style={styles.progressHeaderRow}>
              <Text style={styles.progressLabel}>Topic Mastery Progress</Text>
              <Text style={styles.progressPercent}>65%</Text>
            </View>
            <View style={styles.progressBarTrack}>
              <View style={[styles.progressBarFill, { width: '65%' }]} />
            </View>
          </View>

          <View style={styles.launchBtnRow}>
            <Text style={styles.launchBtnText}>Tap to Resume Session →</Text>
          </View>
        </TouchableOpacity>

        {/* Core Learning Hub Features */}
        <View style={styles.sectionHeader}>
          <Text style={styles.sectionTitle}>Exam & Learning Hub</Text>
        </View>

        <View style={styles.hubGrid}>
          {/* Curriculum Explorer */}
          <TouchableOpacity
            style={styles.hubCardCyan}
            onPress={() => router.push('/explore')}
            activeOpacity={0.85}
          >
            <View style={styles.hubIconBgCyan}>
              <Text style={styles.hubIcon}>📚</Text>
            </View>
            <Text style={styles.hubTagCyan}>NERDC CURRICULUM</Text>
            <Text style={styles.hubTitle}>Curriculum Explorer</Text>
            <Text style={styles.hubSub}>Lessons, worked examples & exam shortcuts</Text>
          </TouchableOpacity>

          {/* Timed Mock Exam */}
          <TouchableOpacity
            style={styles.hubCardGold}
            onPress={() => router.push('/mock-exam')}
            activeOpacity={0.85}
          >
            <View style={styles.hubIconBgGold}>
              <Text style={styles.hubIcon}>⏱️</Text>
            </View>
            <Text style={styles.hubTagGold}>TIMED SIMULATOR</Text>
            <Text style={styles.hubTitle}>WAEC Mock Exam</Text>
            <Text style={styles.hubSub}>30-min SSCE Paper 1 test runner</Text>
          </TouchableOpacity>

          {/* WAEC Study Squads */}
          <TouchableOpacity
            style={styles.hubCardGreen}
            onPress={() => router.push('/squads')}
            activeOpacity={0.85}
          >
            <View style={styles.hubIconBgGreen}>
              <Text style={styles.hubIcon}>👥</Text>
            </View>
            <Text style={styles.hubTagGreen}>STUDY SQUADS</Text>
            <Text style={styles.hubTitle}>WAEC Warriors Squad</Text>
            <Text style={styles.hubSub}>Group goals, leaderboards & squad chat</Text>
          </TouchableOpacity>

          {/* AI Misconception Analysis */}
          <TouchableOpacity
            style={styles.hubCardRed}
            onPress={() => router.push('/struggling-analysis')}
            activeOpacity={0.85}
          >
            <View style={styles.hubIconBgRed}>
              <Text style={styles.hubIcon}>⚠️</Text>
            </View>
            <Text style={styles.hubTagRed}>MISCONCEPTION ANALYSIS</Text>
            <Text style={styles.hubTitle}>Targeted Remediation</Text>
            <Text style={styles.hubSub}>2 active error patterns diagnosed</Text>
          </TouchableOpacity>
        </View>

        {/* Quick Utilities */}
        <View style={styles.subGridRow}>
          <TouchableOpacity
            style={styles.subCard}
            onPress={() => router.push('/diagnostic')}
            activeOpacity={0.85}
          >
            <Text style={styles.subTagGold}>BASELINE</Text>
            <Text style={styles.subTitle}>Diagnostic Test</Text>
            <Text style={styles.subSub}>Placement Test</Text>
          </TouchableOpacity>

          <TouchableOpacity
            style={styles.subCard}
            onPress={() => router.push('/revision')}
            activeOpacity={0.85}
          >
            <Text style={styles.subTagCyan}>SCHEDULER</Text>
            <Text style={styles.subTitle}>Spaced Practice</Text>
            <Text style={styles.subSub}>4 Due Today</Text>
          </TouchableOpacity>
        </View>

        {/* Role Access Portals */}
        <View style={styles.sectionHeader}>
          <Text style={styles.sectionTitle}>Role Portals</Text>
        </View>

        <View style={styles.roleRow}>
          <TouchableOpacity
            style={styles.roleBoxStudent}
            onPress={() => router.push('/practice')}
            activeOpacity={0.85}
          >
            <Text style={styles.roleBadgeStudent}>STUDENT</Text>
            <Text style={styles.roleText}>Practice</Text>
          </TouchableOpacity>

          <TouchableOpacity
            style={styles.roleBoxTeacher}
            onPress={() => router.push('/teacher')}
            activeOpacity={0.85}
          >
            <Text style={styles.roleBadgeTeacher}>TEACHER</Text>
            <Text style={styles.roleText}>Ledger</Text>
          </TouchableOpacity>

          <TouchableOpacity
            style={styles.roleBoxParent}
            onPress={() => router.push('/parent')}
            activeOpacity={0.85}
          >
            <Text style={styles.roleBadgeParent}>PARENT</Text>
            <Text style={styles.roleText}>Report</Text>
          </TouchableOpacity>
        </View>
      </ScrollView>
    </SafeAreaView>
  );
}

const styles = StyleSheet.create({
  container: {
    flex: 1,
    backgroundColor: '#030712',
  },
  scrollContent: {
    padding: 16,
    paddingBottom: 40,
  },
  profileHeader: {
    backgroundColor: '#0F172A',
    borderColor: '#1E293B',
    borderWidth: 1,
    borderRadius: 20,
    padding: 16,
    flexDirection: 'row',
    justifyContent: 'space-between',
    alignItems: 'center',
    marginBottom: 16,
  },
  profileLeft: {
    flexDirection: 'row',
    alignItems: 'center',
    gap: 12,
  },
  avatarGlowRing: {
    width: 44,
    height: 44,
    borderRadius: 22,
    backgroundColor: '#1E1B4B',
    justifyContent: 'center',
    alignItems: 'center',
    borderColor: '#4338CA',
    borderWidth: 1.5,
  },
  avatarEmoji: { fontSize: 22 },
  greetingText: { color: '#FFFFFF', fontSize: 16, fontWeight: '800' },
  levelRow: { flexDirection: 'row', alignItems: 'center', gap: 6, marginTop: 2 },
  levelBadgeText: { color: '#F59E0B', fontSize: 10, fontWeight: 'bold' },
  dotSeparator: { color: '#64748B', fontSize: 10 },
  examTargetText: { color: '#94A3B8', fontSize: 10, fontWeight: '600' },
  profileRight: { gap: 4, alignItems: 'flex-end' },
  xpPill: { backgroundColor: '#1E1B4B', borderColor: '#4338CA', borderWidth: 1, paddingHorizontal: 8, paddingVertical: 2, borderRadius: 10 },
  xpText: { color: '#38BDF8', fontSize: 10, fontWeight: 'bold' },
  streakPill: { backgroundColor: '#064E3B', borderColor: '#059669', borderWidth: 1, paddingHorizontal: 8, paddingVertical: 2, borderRadius: 10 },
  streakText: { color: '#34D399', fontSize: 10, fontWeight: 'bold' },
  metricsGrid: { flexDirection: 'row', gap: 10, marginBottom: 20 },
  metricCard: { flex: 1, backgroundColor: '#0F172A', borderColor: '#1E293B', borderWidth: 1, borderRadius: 16, padding: 14, alignItems: 'center' },
  metricGold: { borderColor: '#F59E0B44' },
  metricCyan: { borderColor: '#06B6D444' },
  metricGreen: { borderColor: '#10B98144' },
  metricValGold: { color: '#F59E0B', fontSize: 24, fontWeight: '800' },
  metricValCyan: { color: '#38BDF8', fontSize: 24, fontWeight: '800' },
  metricValGreen: { color: '#10B981', fontSize: 24, fontWeight: '800' },
  metricLbl: { color: '#64748B', fontSize: 10, fontWeight: '600', marginTop: 2 },
  sectionHeader: { marginBottom: 10, marginTop: 4 },
  sectionTitle: { color: '#F8FAFC', fontSize: 18, fontWeight: '800' },
  featuredCard: {
    backgroundColor: '#0F172A',
    borderColor: '#F59E0B',
    borderWidth: 1.5,
    borderRadius: 22,
    padding: 18,
    marginBottom: 20,
    shadowColor: '#F59E0B',
    shadowOffset: { width: 0, height: 6 },
    shadowOpacity: 0.2,
    shadowRadius: 12,
  },
  featuredTopRow: { flexDirection: 'row', justifyContent: 'space-between', alignItems: 'center', marginBottom: 10 },
  rescueTagPill: { backgroundColor: '#78350F', paddingHorizontal: 8, paddingVertical: 3, borderRadius: 6 },
  rescueTagText: { color: '#FDE68A', fontSize: 9, fontWeight: 'bold', letterSpacing: 0.5 },
  waecBadge: { backgroundColor: '#1E1B4B', borderColor: '#4338CA', borderWidth: 1, paddingHorizontal: 8, paddingVertical: 2, borderRadius: 6 },
  waecBadgeText: { color: '#38BDF8', fontSize: 10, fontWeight: 'bold' },
  featuredTopicTitle: { color: '#FFFFFF', fontSize: 18, fontWeight: '800' },
  featuredTopicDesc: { color: '#94A3B8', fontSize: 12, marginTop: 4, lineHeight: 18 },
  progressContainer: { marginTop: 14 },
  progressHeaderRow: { flexDirection: 'row', justifyContent: 'space-between', marginBottom: 4 },
  progressLabel: { color: '#64748B', fontSize: 11 },
  progressPercent: { color: '#F59E0B', fontSize: 11, fontWeight: 'bold' },
  progressBarTrack: { height: 8, backgroundColor: '#1E293B', borderRadius: 4, overflow: 'hidden' },
  progressBarFill: { height: '100%', backgroundColor: '#F59E0B', borderRadius: 4 },
  launchBtnRow: { marginTop: 14, paddingTop: 12, borderTopWidth: 1, borderColor: '#1E293B', alignItems: 'flex-end' },
  launchBtnText: { color: '#F59E0B', fontSize: 13, fontWeight: 'bold' },
  hubGrid: { gap: 12, marginBottom: 20 },
  hubCardCyan: { backgroundColor: '#0F172A', borderColor: '#06B6D466', borderWidth: 1.5, borderRadius: 18, padding: 16 },
  hubIconBgCyan: { width: 36, height: 36, borderRadius: 10, backgroundColor: '#083344', justifyContent: 'center', alignItems: 'center', marginBottom: 8 },
  hubTagCyan: { color: '#06B6D4', fontSize: 9, fontWeight: 'bold', letterSpacing: 1 },
  hubTitle: { color: '#FFFFFF', fontSize: 16, fontWeight: 'bold', marginTop: 2 },
  hubSub: { color: '#94A3B8', fontSize: 12, marginTop: 2 },
  hubCardGold: { backgroundColor: '#0F172A', borderColor: '#F59E0B66', borderWidth: 1.5, borderRadius: 18, padding: 16 },
  hubIconBgGold: { width: 36, height: 36, borderRadius: 10, backgroundColor: '#451A03', justifyContent: 'center', alignItems: 'center', marginBottom: 8 },
  hubTagGold: { color: '#F59E0B', fontSize: 9, fontWeight: 'bold', letterSpacing: 1 },
  hubCardGreen: { backgroundColor: '#0F172A', borderColor: '#10B98166', borderWidth: 1.5, borderRadius: 18, padding: 16 },
  hubIconBgGreen: { width: 36, height: 36, borderRadius: 10, backgroundColor: '#064E3B', justifyContent: 'center', alignItems: 'center', marginBottom: 8 },
  hubTagGreen: { color: '#10B981', fontSize: 9, fontWeight: 'bold', letterSpacing: 1 },
  hubCardRed: { backgroundColor: '#7F1D1D22', borderColor: '#F43F5E88', borderWidth: 1.5, borderRadius: 18, padding: 16 },
  hubIconBgRed: { width: 36, height: 36, borderRadius: 10, backgroundColor: '#881337', justifyContent: 'center', alignItems: 'center', marginBottom: 8 },
  hubTagRed: { color: '#F43F5E', fontSize: 9, fontWeight: 'bold', letterSpacing: 1 },
  hubIcon: { fontSize: 18 },
  subGridRow: { flexDirection: 'row', gap: 10, marginBottom: 20 },
  subCard: { flex: 1, backgroundColor: '#0F172A', borderColor: '#1E293B', borderWidth: 1, borderRadius: 16, padding: 14 },
  subTagGold: { color: '#F59E0B', fontSize: 9, fontWeight: 'bold', letterSpacing: 1 },
  subTagCyan: { color: '#38BDF8', fontSize: 9, fontWeight: 'bold', letterSpacing: 1 },
  subTitle: { color: '#FFFFFF', fontSize: 14, fontWeight: 'bold', marginTop: 4 },
  subSub: { color: '#94A3B8', fontSize: 11, marginTop: 2 },
  roleRow: { flexDirection: 'row', gap: 8 },
  roleBoxStudent: { flex: 1, backgroundColor: '#1E1B4B', borderColor: '#4338CA', borderWidth: 1, borderRadius: 14, padding: 12, alignItems: 'center' },
  roleBadgeStudent: { color: '#C7D2FE', fontSize: 9, fontWeight: 'bold' },
  roleBoxTeacher: { flex: 1, backgroundColor: '#064E3B', borderColor: '#059669', borderWidth: 1, borderRadius: 14, padding: 12, alignItems: 'center' },
  roleBadgeTeacher: { color: '#A7F3D0', fontSize: 9, fontWeight: 'bold' },
  roleBoxParent: { flex: 1, backgroundColor: '#78350F', borderColor: '#D97706', borderWidth: 1, borderRadius: 14, padding: 12, alignItems: 'center' },
  roleBadgeParent: { color: '#FDE68A', fontSize: 9, fontWeight: 'bold' },
  roleText: { color: '#FFFFFF', fontSize: 13, fontWeight: 'bold', marginTop: 4 },
});
