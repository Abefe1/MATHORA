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
        {/* Hero Header Banner with Gradient Styling */}
        <View style={styles.heroBanner}>
          <View style={styles.heroTopRow}>
            <View style={styles.badgePill}>
              <Text style={styles.badgePillText}>NIGERIAN WAEC & BECE</Text>
            </View>
            <View style={styles.streakPill}>
              <Text style={styles.streakText}>🔥 5 Day Streak</Text>
            </View>
          </View>

          <Text style={styles.brandTitle}>Mathora Mobile</Text>
          <Text style={styles.tagline}>Understand. Solve. Master.</Text>
          <Text style={styles.subtext}>
            Built from a concerned teacher's experience to guarantee SS1 - SS3 exam mastery.
          </Text>

          <View style={styles.userProfileRow}>
            <View style={styles.avatarGlow}>
              <Text style={styles.avatarEmoji}>🎓</Text>
            </View>
            <View>
              <Text style={styles.welcomeText}>Welcome back, Chidiebere!</Text>
              <Text style={styles.levelText}>Target: WAEC SSCE 2026 • SS2 Mathematics</Text>
            </View>
          </View>
        </View>

        {/* Quick Stats Metric Grid */}
        <View style={styles.statsGrid}>
          <View style={[styles.statCard, styles.statCardGold]}>
            <Text style={styles.statNumberGold}>65%</Text>
            <Text style={styles.statLabel}>Topic Mastery</Text>
          </View>
          <View style={[styles.statCard, styles.statCardCyan]}>
            <Text style={styles.statNumberCyan}>#1</Text>
            <Text style={styles.statLabel}>Squad Rank</Text>
          </View>
          <View style={[styles.statCard, styles.statCardGreen]}>
            <Text style={styles.statNumberGreen}>4</Text>
            <Text style={styles.statLabel}>Reviews Due</Text>
          </View>
        </View>

        {/* Featured Core Action Card: Resume Practice */}
        <View style={styles.sectionHeaderRow}>
          <Text style={styles.sectionTitle}>Current Practice Session</Text>
          <Text style={styles.sectionSubLink}>SS2 Core</Text>
        </View>

        <TouchableOpacity
          style={styles.featuredCard}
          onPress={() => router.push('/practice')}
          activeOpacity={0.88}
        >
          <View style={styles.featuredHeader}>
            <View style={styles.featuredTagPill}>
              <Text style={styles.featuredTagText}>⚡ RESUME PRACTICE & RESCUE MODE</Text>
            </View>
            <View style={styles.classBadge}>
              <Text style={styles.classBadgeText}>WAEC SS2</Text>
            </View>
          </View>

          <Text style={styles.featuredTitle}>Quadratic Equations & Rescue Methods</Text>
          <Text style={styles.featuredDesc}>
            Factorization, decomposition, quadratic formula & WAEC exam shortcuts.
          </Text>

          <View style={styles.progressContainer}>
            <View style={styles.progressHeader}>
              <Text style={styles.progressLbl}>Topic Completion</Text>
              <Text style={styles.progressVal}>65%</Text>
            </View>
            <View style={styles.progressBarBg}>
              <View style={[styles.progressBarFill, { width: '65%' }]} />
            </View>
          </View>

          <View style={styles.actionBtnRow}>
            <Text style={styles.actionBtnText}>Continue Practice Session →</Text>
          </View>
        </TouchableOpacity>

        {/* Primary Learning Features Grid */}
        <View style={styles.sectionHeaderRow}>
          <Text style={styles.sectionTitle}>Learning & Exam Hub</Text>
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
            <Text style={styles.hubCardTagCyan}>NERDC CURRICULUM</Text>
            <Text style={styles.hubCardTitle}>Curriculum Explorer</Text>
            <Text style={styles.hubCardSub}>Lessons, worked examples & WAEC shortcuts</Text>
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
            <Text style={styles.hubCardTagGold}>OFFICIAL SIMULATOR</Text>
            <Text style={styles.hubCardTitle}>Timed Mock Exam</Text>
            <Text style={styles.hubCardSub}>30-min WAEC SSCE Paper 1 test runner</Text>
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
            <Text style={styles.hubCardTagGreen}>ACCOUNTABILITY</Text>
            <Text style={styles.hubCardTitle}>WAEC Study Squads</Text>
            <Text style={styles.hubCardSub}>Group targets, member leaderboards & chat</Text>
          </TouchableOpacity>

          {/* AI Misconception Breakdown */}
          <TouchableOpacity
            style={styles.hubCardRed}
            onPress={() => router.push('/struggling-analysis')}
            activeOpacity={0.85}
          >
            <View style={styles.hubIconBgRed}>
              <Text style={styles.hubIcon}>⚠️</Text>
            </View>
            <Text style={styles.hubCardTagRed}>AI MISCONCEPTION</Text>
            <Text style={styles.hubCardTitle}>Targeted Remediation</Text>
            <Text style={styles.hubCardSub}>2 active trap patterns detected</Text>
          </TouchableOpacity>
        </View>

        {/* Secondary Utilities Row */}
        <View style={styles.subGridRow}>
          <TouchableOpacity
            style={styles.subCard}
            onPress={() => router.push('/diagnostic')}
            activeOpacity={0.85}
          >
            <Text style={styles.subTag}>BASELINE</Text>
            <Text style={styles.subTitle}>Diagnostic Test</Text>
            <Text style={styles.subDesc}>Placement Assessment</Text>
          </TouchableOpacity>

          <TouchableOpacity
            style={styles.subCard}
            onPress={() => router.push('/revision')}
            activeOpacity={0.85}
          >
            <Text style={styles.subTagCyan}>SCHEDULER</Text>
            <Text style={styles.subTitle}>Spaced Revision</Text>
            <Text style={styles.subDesc}>4 Questions Due Today</Text>
          </TouchableOpacity>
        </View>

        {/* Role Access Portals */}
        <View style={styles.sectionHeaderRow}>
          <Text style={styles.sectionTitle}>Multi-Role Portals</Text>
        </View>

        <View style={styles.roleGrid}>
          <TouchableOpacity
            style={styles.roleBoxStudent}
            onPress={() => router.push('/practice')}
            activeOpacity={0.85}
          >
            <Text style={styles.roleBadgeStudent}>STUDENT</Text>
            <Text style={styles.roleTitle}>Practice Hub</Text>
          </TouchableOpacity>

          <TouchableOpacity
            style={styles.roleBoxTeacher}
            onPress={() => router.push('/teacher')}
            activeOpacity={0.85}
          >
            <Text style={styles.roleBadgeTeacher}>TEACHER</Text>
            <Text style={styles.roleTitle}>Class Ledger</Text>
          </TouchableOpacity>

          <TouchableOpacity
            style={styles.roleBoxParent}
            onPress={() => router.push('/parent')}
            activeOpacity={0.85}
          >
            <Text style={styles.roleBadgeParent}>PARENT</Text>
            <Text style={styles.roleTitle}>Progress Report</Text>
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
  heroBanner: {
    backgroundColor: '#1E1B4B',
    borderColor: '#4338CA',
    borderWidth: 1.5,
    borderRadius: 24,
    padding: 20,
    marginBottom: 16,
    shadowColor: '#4338CA',
    shadowOffset: { width: 0, height: 8 },
    shadowOpacity: 0.3,
    shadowRadius: 16,
  },
  heroTopRow: {
    flexDirection: 'row',
    justifyContent: 'space-between',
    alignItems: 'center',
    marginBottom: 10,
  },
  badgePill: {
    backgroundColor: '#78350F',
    borderColor: '#D97706',
    borderWidth: 1,
    paddingHorizontal: 10,
    paddingVertical: 3,
    borderRadius: 12,
  },
  badgePillText: {
    color: '#FDE68A',
    fontSize: 9,
    fontWeight: 'bold',
    letterSpacing: 1,
  },
  streakPill: {
    backgroundColor: '#064E3B',
    borderColor: '#059669',
    borderWidth: 1,
    paddingHorizontal: 10,
    paddingVertical: 3,
    borderRadius: 12,
  },
  streakText: {
    color: '#34D399',
    fontSize: 10,
    fontWeight: 'bold',
  },
  brandTitle: {
    color: '#FFFFFF',
    fontSize: 28,
    fontWeight: '800',
    letterSpacing: -0.5,
  },
  tagline: {
    color: '#38BDF8',
    fontSize: 15,
    fontWeight: '700',
    marginTop: 2,
  },
  subtext: {
    color: '#94A3B8',
    fontSize: 12,
    marginTop: 6,
    lineHeight: 18,
  },
  userProfileRow: {
    flexDirection: 'row',
    alignItems: 'center',
    gap: 12,
    marginTop: 16,
    paddingTop: 14,
    borderTopWidth: 1,
    borderColor: '#312E81',
  },
  avatarGlow: {
    width: 42,
    height: 42,
    borderRadius: 21,
    backgroundColor: '#312E81',
    justifyContent: 'center',
    alignItems: 'center',
    borderColor: '#6366F1',
    borderWidth: 1.5,
  },
  avatarEmoji: {
    fontSize: 20,
  },
  welcomeText: {
    color: '#FFFFFF',
    fontSize: 14,
    fontWeight: 'bold',
  },
  levelText: {
    color: '#F59E0B',
    fontSize: 11,
    fontWeight: '600',
    marginTop: 1,
  },
  statsGrid: {
    flexDirection: 'row',
    gap: 10,
    marginBottom: 20,
  },
  statCard: {
    flex: 1,
    backgroundColor: '#0F172A',
    borderColor: '#1E293B',
    borderWidth: 1,
    borderRadius: 16,
    padding: 14,
    alignItems: 'center',
  },
  statCardGold: { borderColor: '#F59E0B44' },
  statCardCyan: { borderColor: '#06B6D444' },
  statCardGreen: { borderColor: '#10B98144' },
  statNumberGold: { color: '#F59E0B', fontSize: 24, fontWeight: '800' },
  statNumberCyan: { color: '#38BDF8', fontSize: 24, fontWeight: '800' },
  statNumberGreen: { color: '#10B981', fontSize: 24, fontWeight: '800' },
  statLabel: { color: '#64748B', fontSize: 10, fontWeight: '600', marginTop: 2 },
  sectionHeaderRow: {
    flexDirection: 'row',
    justifyContent: 'space-between',
    alignItems: 'center',
    marginBottom: 12,
    marginTop: 4,
  },
  sectionTitle: {
    color: '#F8FAFC',
    fontSize: 18,
    fontWeight: '800',
  },
  sectionSubLink: {
    color: '#38BDF8',
    fontSize: 12,
    fontWeight: '600',
  },
  featuredCard: {
    backgroundColor: '#0F172A',
    borderColor: '#F59E0B',
    borderWidth: 1.5,
    borderRadius: 20,
    padding: 18,
    marginBottom: 20,
    shadowColor: '#F59E0B',
    shadowOffset: { width: 0, height: 6 },
    shadowOpacity: 0.2,
    shadowRadius: 12,
  },
  featuredHeader: {
    flexDirection: 'row',
    justifyContent: 'space-between',
    alignItems: 'center',
    marginBottom: 10,
  },
  featuredTagPill: {
    backgroundColor: '#78350F',
    paddingHorizontal: 8,
    paddingVertical: 3,
    borderRadius: 6,
  },
  featuredTagText: {
    color: '#FDE68A',
    fontSize: 9,
    fontWeight: 'bold',
    letterSpacing: 0.5,
  },
  classBadge: {
    backgroundColor: '#1E1B4B',
    borderColor: '#4338CA',
    borderWidth: 1,
    paddingHorizontal: 8,
    paddingVertical: 2,
    borderRadius: 6,
  },
  classBadgeText: {
    color: '#38BDF8',
    fontSize: 10,
    fontWeight: 'bold',
  },
  featuredTitle: {
    color: '#FFFFFF',
    fontSize: 18,
    fontWeight: '800',
  },
  featuredDesc: {
    color: '#94A3B8',
    fontSize: 12,
    marginTop: 4,
    lineHeight: 18,
  },
  progressContainer: {
    marginTop: 14,
  },
  progressHeader: {
    flexDirection: 'row',
    justifyContent: 'space-between',
    marginBottom: 4,
  },
  progressLbl: { color: '#64748B', fontSize: 11 },
  progressVal: { color: '#F59E0B', fontSize: 11, fontWeight: 'bold' },
  progressBarBg: {
    height: 8,
    backgroundColor: '#1E293B',
    borderRadius: 4,
    overflow: 'hidden',
  },
  progressBarFill: {
    height: '100%',
    backgroundColor: '#F59E0B',
    borderRadius: 4,
  },
  actionBtnRow: {
    marginTop: 14,
    paddingTop: 12,
    borderTopWidth: 1,
    borderColor: '#1E293B',
    alignItems: 'flex-end',
  },
  actionBtnText: {
    color: '#F59E0B',
    fontSize: 13,
    fontWeight: 'bold',
  },
  hubGrid: {
    gap: 12,
    marginBottom: 20,
  },
  hubCardCyan: {
    backgroundColor: '#0F172A',
    borderColor: '#06B6D466',
    borderWidth: 1.5,
    borderRadius: 18,
    padding: 16,
    position: 'relative',
  },
  hubIconBgCyan: {
    width: 36,
    height: 36,
    borderRadius: 10,
    backgroundColor: '#083344',
    justifyContent: 'center',
    alignItems: 'center',
    marginBottom: 8,
  },
  hubCardTagCyan: { color: '#06B6D4', fontSize: 9, fontWeight: 'bold', letterSpacing: 1 },
  hubCardTitle: { color: '#FFFFFF', fontSize: 16, fontWeight: 'bold', marginTop: 2 },
  hubCardSub: { color: '#94A3B8', fontSize: 12, marginTop: 2 },

  hubCardGold: {
    backgroundColor: '#0F172A',
    borderColor: '#F59E0B66',
    borderWidth: 1.5,
    borderRadius: 18,
    padding: 16,
  },
  hubIconBgGold: {
    width: 36,
    height: 36,
    borderRadius: 10,
    backgroundColor: '#451A03',
    justifyContent: 'center',
    alignItems: 'center',
    marginBottom: 8,
  },
  hubCardTagGold: { color: '#F59E0B', fontSize: 9, fontWeight: 'bold', letterSpacing: 1 },

  hubCardGreen: {
    backgroundColor: '#0F172A',
    borderColor: '#10B98166',
    borderWidth: 1.5,
    borderRadius: 18,
    padding: 16,
  },
  hubIconBgGreen: {
    width: 36,
    height: 36,
    borderRadius: 10,
    backgroundColor: '#064E3B',
    justifyContent: 'center',
    alignItems: 'center',
    marginBottom: 8,
  },
  hubCardTagGreen: { color: '#10B981', fontSize: 9, fontWeight: 'bold', letterSpacing: 1 },

  hubCardRed: {
    backgroundColor: '#7F1D1D22',
    borderColor: '#F43F5E88',
    borderWidth: 1.5,
    borderRadius: 18,
    padding: 16,
  },
  hubIconBgRed: {
    width: 36,
    height: 36,
    borderRadius: 10,
    backgroundColor: '#881337',
    justifyContent: 'center',
    alignItems: 'center',
    marginBottom: 8,
  },
  hubCardTagRed: { color: '#F43F5E', fontSize: 9, fontWeight: 'bold', letterSpacing: 1 },
  hubIcon: { fontSize: 18 },

  subGridRow: {
    flexDirection: 'row',
    gap: 10,
    marginBottom: 20,
  },
  subCard: {
    flex: 1,
    backgroundColor: '#0F172A',
    borderColor: '#1E293B',
    borderWidth: 1,
    borderRadius: 16,
    padding: 14,
  },
  subTag: { color: '#F59E0B', fontSize: 9, fontWeight: 'bold', letterSpacing: 1 },
  subTagCyan: { color: '#38BDF8', fontSize: 9, fontWeight: 'bold', letterSpacing: 1 },
  subTitle: { color: '#FFFFFF', fontSize: 14, fontWeight: 'bold', marginTop: 4 },
  subDesc: { color: '#94A3B8', fontSize: 11, marginTop: 2 },

  roleGrid: {
    flexDirection: 'row',
    gap: 8,
  },
  roleBoxStudent: {
    flex: 1,
    backgroundColor: '#1E1B4B',
    borderColor: '#4338CA',
    borderWidth: 1,
    borderRadius: 14,
    padding: 12,
    alignItems: 'center',
  },
  roleBadgeStudent: { color: '#C7D2FE', fontSize: 9, fontWeight: 'bold' },
  roleBoxTeacher: {
    flex: 1,
    backgroundColor: '#064E3B',
    borderColor: '#059669',
    borderWidth: 1,
    borderRadius: 14,
    padding: 12,
    alignItems: 'center',
  },
  roleBadgeTeacher: { color: '#A7F3D0', fontSize: 9, fontWeight: 'bold' },
  roleBoxParent: {
    flex: 1,
    backgroundColor: '#78350F',
    borderColor: '#D97706',
    borderWidth: 1,
    borderRadius: 14,
    padding: 12,
    alignItems: 'center',
  },
  roleBadgeParent: { color: '#FDE68A', fontSize: 9, fontWeight: 'bold' },
  roleTitle: { color: '#FFFFFF', fontSize: 13, fontWeight: 'bold', marginTop: 4 },
});
