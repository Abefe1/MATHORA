import React from 'react';
import { StyleSheet, Text, View, ScrollView, TouchableOpacity, SafeAreaView, StatusBar } from 'react-native';
import { useRouter } from 'expo-router';

export default function MathoraHomeScreen() {
  const router = useRouter();

  return (
    <SafeAreaView style={styles.container}>
      <StatusBar barStyle="light-content" backgroundColor="#090D16" />
      <ScrollView contentContainerStyle={styles.scrollContent}>
        {/* Header Banner */}
        <View style={styles.headerBanner}>
          <Text style={styles.badgeText}>BUILT FROM A CONCERNED TEACHER'S EXPERIENCE</Text>
          <Text style={styles.brandTitle}>Mathora Mobile</Text>
          <Text style={styles.tagline}>Understand. Solve. Master.</Text>
          <Text style={styles.subtext}>Nigerian WAEC & BECE Mathematics Platform (SS1 - SS3)</Text>
        </View>

        {/* Learning Stats Bar */}
        <View style={styles.statsRow}>
          <View style={styles.statBox}>
            <Text style={styles.statValGold}>65%</Text>
            <Text style={styles.statLbl}>SS2 Mastery</Text>
          </View>
          <View style={styles.statBox}>
            <Text style={styles.statValCyan}>#1</Text>
            <Text style={styles.statLbl}>Squad Rank</Text>
          </View>
          <View style={styles.statBox}>
            <Text style={styles.statValGreen}>4</Text>
            <Text style={styles.statLbl}>Reviews Due</Text>
          </View>
        </View>

        {/* Core Learning Loop Quick Actions */}
        <View style={styles.sectionHeader}>
          <Text style={styles.sectionTitle}>Student Core Learning Loop</Text>
        </View>

        {/* Resume Practice Card */}
        <TouchableOpacity
          style={styles.actionCardPrimary}
          onPress={() => router.push('/practice')}
          activeOpacity={0.8}
        >
          <View style={styles.cardHeaderRow}>
            <Text style={styles.cardTag}>RESUME PRACTICE & RESCUE MODE</Text>
            <Text style={styles.badgeSmall}>WAEC SS2</Text>
          </View>
          <Text style={styles.cardTitle}>Quadratic Equations & Rescue Methods</Text>
          <Text style={styles.cardSub}>Decomposition, Factorization & WAEC Shortcuts</Text>
          <View style={styles.progressBarBg}>
            <View style={[styles.progressBarFill, { width: '65%' }]} />
          </View>
          <Text style={styles.progressText}>Topic Mastery: 65%</Text>
        </TouchableOpacity>

        {/* Curriculum Explorer Launcher */}
        <TouchableOpacity
          style={styles.actionCardSecondary}
          onPress={() => router.push('/explore')}
          activeOpacity={0.8}
        >
          <Text style={styles.cardTagCyan}>CURRICULUM EXPLORER</Text>
          <Text style={styles.cardTitleDark}>Browse SS1 - SS3 Lessons & Worked Examples</Text>
          <Text style={styles.cardSubDark}>Step-by-step theory, WAEC shortcuts & trap warnings</Text>
        </TouchableOpacity>

        {/* Timed Mock Exam Launcher */}
        <TouchableOpacity
          style={styles.actionCardSecondary}
          onPress={() => router.push('/mock-exam')}
          activeOpacity={0.8}
        >
          <Text style={styles.cardTagGold}>OFFICIAL TIMED SIMULATOR</Text>
          <Text style={styles.cardTitleDark}>WAEC SSCE Mathematics Paper 1 Mock</Text>
          <Text style={styles.cardSubDark}>30-minute timed exam runner with auto-grading</Text>
        </TouchableOpacity>

        {/* WAEC Study Squads Launcher */}
        <TouchableOpacity
          style={styles.actionCardSecondary}
          onPress={() => router.push('/squads')}
          activeOpacity={0.8}
        >
          <Text style={styles.cardTagGreen}>ACCOUNTABILITY SQUADS</Text>
          <Text style={styles.cardTitleDark}>WAEC SS3 Excellence Warriors (#1 Rank)</Text>
          <Text style={styles.cardSubDark}>Collaborative study targets, leaderboards & squad chat</Text>
        </TouchableOpacity>

        {/* Grid for Diagnostic, Revision & Misconceptions */}
        <View style={styles.gridRow}>
          <TouchableOpacity
            style={styles.gridCard}
            onPress={() => router.push('/diagnostic')}
            activeOpacity={0.8}
          >
            <Text style={styles.gridTag}>BASELINE</Text>
            <Text style={styles.gridTitle}>Diagnostic Test</Text>
            <Text style={styles.gridSub}>Placement Test</Text>
          </TouchableOpacity>

          <TouchableOpacity
            style={styles.gridCard}
            onPress={() => router.push('/revision')}
            activeOpacity={0.8}
          >
            <Text style={styles.gridTagCyan}>SCHEDULER</Text>
            <Text style={styles.gridTitle}>Spaced Practice</Text>
            <Text style={styles.gridSub}>4 Due Today</Text>
          </TouchableOpacity>
        </View>

        {/* AI Misconception Analysis Launcher */}
        <TouchableOpacity
          style={styles.actionCardRed}
          onPress={() => router.push('/struggling-analysis')}
          activeOpacity={0.8}
        >
          <Text style={styles.cardTagRed}>AI MISCONCEPTION BREAKDOWN</Text>
          <Text style={styles.cardTitleDark}>2 Active Trap Patterns Detected</Text>
          <Text style={styles.cardSubRed}>Pinpoint prerequisite gaps in negative sign expansions</Text>
        </TouchableOpacity>

        {/* Roles Navigation */}
        <View style={styles.sectionHeader}>
          <Text style={styles.sectionTitle}>Role Portals</Text>
        </View>

        <View style={styles.rolesRow}>
          <TouchableOpacity
            style={styles.roleBoxStudent}
            onPress={() => router.push('/practice')}
            activeOpacity={0.8}
          >
            <Text style={styles.roleTitle}>Student</Text>
            <Text style={styles.roleSub}>Practice</Text>
          </TouchableOpacity>

          <TouchableOpacity
            style={styles.roleBoxTeacher}
            onPress={() => router.push('/teacher')}
            activeOpacity={0.8}
          >
            <Text style={styles.roleTitleTeacher}>Teacher</Text>
            <Text style={styles.roleSub}>Ledger</Text>
          </TouchableOpacity>

          <TouchableOpacity
            style={styles.roleBoxParent}
            onPress={() => router.push('/parent')}
            activeOpacity={0.8}
          >
            <Text style={styles.roleTitleParent}>Parent</Text>
            <Text style={styles.roleSub}>Report</Text>
          </TouchableOpacity>
        </View>
      </ScrollView>
    </SafeAreaView>
  );
}

const styles = StyleSheet.create({
  container: {
    flex: 1,
    backgroundColor: '#090D16',
  },
  scrollContent: {
    padding: 16,
  },
  headerBanner: {
    backgroundColor: '#1E1B4B',
    borderColor: '#4338CA',
    borderWidth: 1,
    borderRadius: 20,
    padding: 20,
    marginBottom: 16,
  },
  badgeText: {
    color: '#F59E0B',
    fontSize: 10,
    fontWeight: 'bold',
    letterSpacing: 1,
    marginBottom: 6,
  },
  brandTitle: {
    color: '#FFFFFF',
    fontSize: 28,
    fontWeight: 'bold',
  },
  tagline: {
    color: '#38BDF8',
    fontSize: 15,
    fontWeight: '600',
    marginTop: 2,
  },
  subtext: {
    color: '#94A3B8',
    fontSize: 12,
    marginTop: 8,
  },
  statsRow: {
    flexDirection: 'row',
    gap: 10,
    marginBottom: 18,
  },
  statBox: {
    flex: 1,
    backgroundColor: '#0F172A',
    borderColor: '#1E293B',
    borderWidth: 1,
    borderRadius: 12,
    padding: 12,
    alignItems: 'center',
  },
  statValGold: { color: '#F59E0B', fontSize: 20, fontWeight: 'bold' },
  statValCyan: { color: '#38BDF8', fontSize: 20, fontWeight: 'bold' },
  statValGreen: { color: '#10B981', fontSize: 20, fontWeight: 'bold' },
  statLbl: { color: '#64748B', fontSize: 10, fontWeight: '600', marginTop: 2 },
  sectionHeader: {
    marginTop: 4,
    marginBottom: 12,
  },
  sectionTitle: {
    color: '#F8FAFC',
    fontSize: 18,
    fontWeight: 'bold',
  },
  actionCardPrimary: {
    backgroundColor: '#1E1B4B',
    borderColor: '#F59E0B',
    borderWidth: 1.5,
    borderRadius: 16,
    padding: 16,
    marginBottom: 12,
  },
  cardHeaderRow: {
    flexDirection: 'row',
    justifyContent: 'space-between',
    alignItems: 'center',
  },
  cardTag: {
    color: '#F59E0B',
    fontSize: 10,
    fontWeight: 'bold',
    letterSpacing: 1,
  },
  badgeSmall: {
    backgroundColor: '#78350F',
    color: '#FDE68A',
    fontSize: 10,
    fontWeight: 'bold',
    paddingHorizontal: 8,
    paddingVertical: 2,
    borderRadius: 4,
  },
  cardTitle: {
    color: '#FFFFFF',
    fontSize: 16,
    fontWeight: 'bold',
    marginTop: 6,
  },
  cardSub: {
    color: '#94A3B8',
    fontSize: 12,
    marginTop: 2,
  },
  progressBarBg: {
    height: 6,
    backgroundColor: '#312E81',
    borderRadius: 3,
    marginTop: 14,
    overflow: 'hidden',
  },
  progressBarFill: {
    height: '100%',
    backgroundColor: '#F59E0B',
    borderRadius: 3,
  },
  progressText: {
    color: '#F59E0B',
    fontSize: 11,
    fontWeight: 'bold',
    marginTop: 4,
    textAlign: 'right',
  },
  actionCardSecondary: {
    backgroundColor: '#0F172A',
    borderColor: '#1E293B',
    borderWidth: 1,
    borderRadius: 16,
    padding: 16,
    marginBottom: 12,
  },
  actionCardRed: {
    backgroundColor: '#7F1D1D22',
    borderColor: '#EF4444',
    borderWidth: 1,
    borderRadius: 16,
    padding: 16,
    marginBottom: 12,
  },
  cardTagSecondary: {
    color: '#A7F3D0',
    fontSize: 10,
    fontWeight: 'bold',
    letterSpacing: 1,
  },
  cardTagCyan: {
    color: '#38BDF8',
    fontSize: 10,
    fontWeight: 'bold',
    letterSpacing: 1,
  },
  cardTagGold: {
    color: '#F59E0B',
    fontSize: 10,
    fontWeight: 'bold',
    letterSpacing: 1,
  },
  cardTagGreen: {
    color: '#34D399',
    fontSize: 10,
    fontWeight: 'bold',
    letterSpacing: 1,
  },
  cardTagRed: {
    color: '#EF4444',
    fontSize: 10,
    fontWeight: 'bold',
    letterSpacing: 1,
  },
  cardTitleDark: {
    color: '#F8FAFC',
    fontSize: 15,
    fontWeight: 'bold',
    marginTop: 4,
  },
  cardSubDark: {
    color: '#94A3B8',
    fontSize: 12,
    marginTop: 2,
  },
  cardSubRed: {
    color: '#FCA5A5',
    fontSize: 12,
    marginTop: 2,
  },
  gridRow: {
    flexDirection: 'row',
    gap: 10,
    marginBottom: 12,
  },
  gridCard: {
    flex: 1,
    backgroundColor: '#0F172A',
    borderColor: '#1E293B',
    borderWidth: 1,
    borderRadius: 14,
    padding: 14,
  },
  gridTag: { color: '#F59E0B', fontSize: 9, fontWeight: 'bold', letterSpacing: 1 },
  gridTagCyan: { color: '#38BDF8', fontSize: 9, fontWeight: 'bold', letterSpacing: 1 },
  gridTitle: { color: '#FFFFFF', fontSize: 14, fontWeight: 'bold', marginTop: 4 },
  gridSub: { color: '#94A3B8', fontSize: 11, marginTop: 2 },
  rolesRow: {
    flexDirection: 'row',
    justifyContent: 'space-between',
    gap: 8,
    marginTop: 4,
    marginBottom: 20,
  },
  roleBoxStudent: {
    flex: 1,
    backgroundColor: '#1E1B4B',
    borderColor: '#4338CA',
    borderWidth: 1,
    borderRadius: 12,
    padding: 12,
    alignItems: 'center',
  },
  roleTitle: {
    color: '#FFFFFF',
    fontSize: 14,
    fontWeight: 'bold',
  },
  roleSub: {
    color: '#C7D2FE',
    fontSize: 10,
    marginTop: 2,
  },
  roleBoxTeacher: {
    flex: 1,
    backgroundColor: '#064E3B',
    borderColor: '#059669',
    borderWidth: 1,
    borderRadius: 12,
    padding: 12,
    alignItems: 'center',
  },
  roleTitleTeacher: {
    color: '#FFFFFF',
    fontSize: 14,
    fontWeight: 'bold',
  },
  roleBoxParent: {
    flex: 1,
    backgroundColor: '#78350F',
    borderColor: '#D97706',
    borderWidth: 1,
    borderRadius: 12,
    padding: 12,
    alignItems: 'center',
  },
  roleTitleParent: {
    color: '#FFFFFF',
    fontSize: 14,
    fontWeight: 'bold',
  },
});
