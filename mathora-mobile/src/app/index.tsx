import React from 'react';
import { StyleSheet, Text, View, ScrollView, TouchableOpacity, SafeAreaView, StatusBar } from 'react-native';

export default function MathoraHomeScreen() {
  return (
    <SafeAreaView style={styles.container}>
      <StatusBar barStyle="light-content" backgroundColor="#4338CA" />
      <ScrollView contentContainerStyle={styles.scrollContent}>
        {/* Header Banner */}
        <View style={styles.headerBanner}>
          <Text style={styles.badgeText}>BUILT FROM A CONCERNED TEACHER'S EXPERIENCE</Text>
          <Text style={styles.brandTitle}>Mathora Mobile</Text>
          <Text style={styles.tagline}>Understand. Solve. Master.</Text>
          <Text style={styles.subtext}>Nigerian Secondary School Mathematics Platform (SS1 - SS3)</Text>
        </View>

        {/* Action Buttons Grid */}
        <View style={styles.sectionHeader}>
          <Text style={styles.sectionTitle}>Student Practice & Remediation</Text>
        </View>

        <TouchableOpacity style={styles.actionCardPrimary}>
          <Text style={styles.cardTag}>RESUME PRACTICE</Text>
          <Text style={styles.cardTitle}>Quadratic Equations & Rescue Mode</Text>
          <Text style={styles.cardSub}>Decomposition, Factorization & WAEC Shortcuts</Text>
          <View style={styles.progressBarBg}>
            <View style={[styles.progressBarFill, { width: '65%' }]} />
          </View>
          <Text style={styles.progressText}>Mastery: 65%</Text>
        </TouchableOpacity>

        <TouchableOpacity style={styles.actionCardSecondary}>
          <Text style={styles.cardTagSecondary}>DIAGNOSTIC TEST</Text>
          <Text style={styles.cardTitleDark}>Skill Baseline Placement Assessment</Text>
          <Text style={styles.cardSubDark}>Auto-generate your baseline learning sequence</Text>
        </TouchableOpacity>

        <TouchableOpacity style={styles.actionCardSecondary}>
          <Text style={styles.cardTagCyan}>SPACED REVISION</Text>
          <Text style={styles.cardTitleDark}>Spaced Memory Scheduler (1d - 30d)</Text>
          <Text style={styles.cardSubDark}>Review 4 scheduled questions due today</Text>
        </TouchableOpacity>

        {/* Roles Navigation */}
        <View style={styles.sectionHeader}>
          <Text style={styles.sectionTitle}>Select Role Portal</Text>
        </View>

        <View style={styles.rolesRow}>
          <View style={styles.roleBox}>
            <Text style={styles.roleTitle}>Student</Text>
            <Text style={styles.roleSub}>SS2 Math</Text>
          </View>
          <View style={styles.roleBoxTeacher}>
            <Text style={styles.roleTitleTeacher}>Teacher</Text>
            <Text style={styles.roleSub}>Class Manager</Text>
          </View>
          <View style={styles.roleBoxParent}>
            <Text style={styles.roleTitleParent}>Parent</Text>
            <Text style={styles.roleSub}>Progress Monitor</Text>
          </View>
        </View>
      </ScrollView>
    </SafeAreaView>
  );
}

const styles = StyleSheet.create({
  container: {
    flex: 1,
    backgroundColor: '#0F172A',
  },
  scrollContent: {
    padding: 16,
  },
  headerBanner: {
    backgroundColor: '#4338CA',
    borderRadius: 20,
    padding: 20,
    marginBottom: 20,
  },
  badgeText: {
    color: '#A5B4FC',
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
    fontSize: 16,
    fontWeight: '600',
    marginTop: 2,
  },
  subtext: {
    color: '#E0E7FF',
    fontSize: 12,
    marginTop: 8,
  },
  sectionHeader: {
    marginTop: 8,
    marginBottom: 12,
  },
  sectionTitle: {
    color: '#F8FAFC',
    fontSize: 18,
    fontWeight: 'bold',
  },
  actionCardPrimary: {
    backgroundColor: '#1E1B4B',
    borderColor: '#4338CA',
    borderWidth: 1.5,
    borderRadius: 16,
    padding: 16,
    marginBottom: 12,
  },
  cardTag: {
    color: '#38BDF8',
    fontSize: 10,
    fontWeight: 'bold',
    letterSpacing: 1,
  },
  cardTitle: {
    color: '#FFFFFF',
    fontSize: 16,
    fontWeight: 'bold',
    marginTop: 4,
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
    marginTop: 12,
    overflow: 'hidden',
  },
  progressBarFill: {
    height: '100%',
    backgroundColor: '#38BDF8',
    borderRadius: 3,
  },
  progressText: {
    color: '#818CF8',
    fontSize: 11,
    fontWeight: 'bold',
    marginTop: 4,
    textAlign: 'right',
  },
  actionCardSecondary: {
    backgroundColor: '#1E293B',
    borderColor: '#334155',
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
    color: '#67E8F9',
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
  rolesRow: {
    flexDirection: 'row',
    justifyContent: 'space-between',
    gap: 8,
    marginTop: 4,
  },
  roleBox: {
    flex: 1,
    backgroundColor: '#312E81',
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
