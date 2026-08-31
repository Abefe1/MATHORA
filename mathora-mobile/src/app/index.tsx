import React, { useMemo } from 'react';
import {
  StyleSheet,
  Text,
  View,
  ScrollView,
  TouchableOpacity,
  SafeAreaView,
  StatusBar,
  useColorScheme,
} from 'react-native';
import { useRouter } from 'expo-router';
import { useTheme } from '@/hooks/use-theme';

export default function MathoraHomeScreen() {
  const router = useRouter();
  const colors = useTheme();
  const scheme = useColorScheme();
  const styles = useMemo(() => createStyles(colors), [colors]);

  return (
    <SafeAreaView style={styles.container}>
      <StatusBar barStyle={scheme === 'dark' ? 'light-content' : 'dark-content'} backgroundColor={colors.background} />
      <ScrollView contentContainerStyle={styles.scrollContent} showsVerticalScrollIndicator={false}>
        {/* Friendly Top Header */}
        <View style={styles.topHeader}>
          <View>
            <Text style={styles.greetingText}>Good afternoon, Ahmed 👋</Text>
            <Text style={styles.subGreetingText}>SS2 Mathematics • WAEC 2026</Text>
          </View>

          <View style={styles.streakBadge}>
            <Text style={styles.streakText}>🔥 5-day streak · 120 XP</Text>
          </View>
        </View>

        {/* 1. Continue Learning Hero Card */}
        <Text style={styles.sectionHeaderTitle}>Continue learning</Text>
        <TouchableOpacity
          style={styles.continueCard}
          onPress={() => router.push('/practice')}
          activeOpacity={0.9}
        >
          <View style={styles.continueCardHeader}>
            <Text style={styles.topicName}>Quadratic Equations</Text>
            <Text style={styles.subtopicName}>Factorisation</Text>
          </View>

          <View style={styles.progressRow}>
            <View style={styles.progressBarTrack}>
              <View style={[styles.progressBarFill, { width: '72%' }]} />
            </View>
            <Text style={styles.progressPercentageText}>72%</Text>
          </View>

          <View style={styles.continueBtnRow}>
            <Text style={styles.continueBtnText}>Continue →</Text>
          </View>
        </TouchableOpacity>

        {/* 2. Your Focus Today Grid */}
        <Text style={styles.sectionHeaderTitle}>Your focus today</Text>
        <View style={styles.focusGrid}>
          <TouchableOpacity
            style={styles.focusCard}
            onPress={() => router.push('/explore')}
            activeOpacity={0.9}
          >
            <Text style={styles.focusTopicTitle}>Algebra</Text>
            <Text style={styles.focusScoreMint}>82%</Text>
            <View style={styles.badgeMint}>
              <Text style={styles.badgeMintText}>Strong</Text>
            </View>
          </TouchableOpacity>

          <TouchableOpacity
            style={styles.focusCard}
            onPress={() => router.push('/explore')}
            activeOpacity={0.9}
          >
            <Text style={styles.focusTopicTitle}>Geometry</Text>
            <Text style={styles.focusScoreAmber}>64%</Text>
            <View style={styles.badgeAmber}>
              <Text style={styles.badgeAmberText}>Improve</Text>
            </View>
          </TouchableOpacity>
        </View>

        {/* 3. Today's Practice Card */}
        <Text style={styles.sectionHeaderTitle}>Today&apos;s practice</Text>
        <View style={styles.practiceCard}>
          <View style={styles.practiceInfoRow}>
            <Text style={styles.practiceMetaText}>5 questions · ~8 min</Text>
            <Text style={styles.practiceTargetText}>WAEC SSCE Standard</Text>
          </View>

          <TouchableOpacity
            style={styles.startPracticeBtn}
            onPress={() => router.push('/practice')}
            activeOpacity={0.9}
          >
            <Text style={styles.startPracticeBtnText}>Start Practice</Text>
          </TouchableOpacity>
        </View>

        {/* Quick Launch Shortcuts */}
        <View style={styles.quickLinksRow}>
          <TouchableOpacity
            style={styles.linkCard}
            onPress={() => router.push('/mock-exam')}
          >
            <Text style={styles.linkTitle}>⏱️ Timed Mock Exam</Text>
            <Text style={styles.linkSub}>WAEC Paper 1 Simulator</Text>
          </TouchableOpacity>

          <TouchableOpacity
            style={styles.linkCard}
            onPress={() => router.push('/struggling-analysis')}
          >
            <Text style={styles.linkTitleRed}>⚠ Mistake Analysis</Text>
            <Text style={styles.linkSub}>2 Gaps Diagnosed</Text>
          </TouchableOpacity>

          <TouchableOpacity
            style={styles.linkCard}
            onPress={() => router.push('/find-class')}
          >
            <Text style={styles.linkTitle}>🏫 Find My Class</Text>
            <Text style={styles.linkSub}>Search school & teacher</Text>
          </TouchableOpacity>

          <TouchableOpacity
            style={styles.linkCard}
            onPress={() => router.push('/analysis')}
          >
            <Text style={styles.linkTitle}>📊 Full Analysis</Text>
            <Text style={styles.linkSub}>Practice streak & accuracy</Text>
          </TouchableOpacity>
        </View>

        {/* Parent Corner Highlight Banner */}
        <TouchableOpacity
          style={styles.parentBanner}
          onPress={() => router.push('/parent')}
          activeOpacity={0.9}
        >
          <View style={styles.parentBannerIconBox}>
            <Text style={{ fontSize: 20 }}>👨‍👩‍👧</Text>
          </View>
          <View style={{ flex: 1 }}>
            <Text style={styles.parentBannerTitle}>DCOMPANION Parent Corner</Text>
            <Text style={styles.parentBannerSub}>View child weekly mastery, teacher remarks & study limits</Text>
          </View>
          <Text style={styles.parentBannerArrow}>→</Text>
        </TouchableOpacity>
      </ScrollView>
    </SafeAreaView>
  );
}

function createStyles(colors: ReturnType<typeof useTheme>) {
  return StyleSheet.create({
    container: {
      flex: 1,
      backgroundColor: colors.background,
    },
    scrollContent: {
      padding: 20,
      paddingBottom: 40,
    },
    topHeader: {
      flexDirection: 'row',
      justifyContent: 'space-between',
      alignItems: 'flex-start',
      marginBottom: 24,
    },
    greetingText: {
      color: colors.text,
      fontSize: 22,
      fontWeight: '800',
      letterSpacing: -0.3,
    },
    subGreetingText: {
      color: colors.textMuted,
      fontSize: 13,
      fontWeight: '500',
      marginTop: 2,
    },
    streakBadge: {
      backgroundColor: colors.warningSurface,
      borderColor: colors.warningBorder,
      borderWidth: 1,
      paddingHorizontal: 10,
      paddingVertical: 4,
      borderRadius: 999,
    },
    streakText: {
      color: '#F97316',
      fontSize: 11,
      fontWeight: '700',
    },
    sectionHeaderTitle: {
      color: colors.text,
      fontSize: 16,
      fontWeight: '700',
      marginBottom: 12,
      marginTop: 4,
    },
    continueCard: {
      backgroundColor: colors.surface,
      borderColor: colors.border,
      borderWidth: 1,
      borderRadius: 16,
      padding: 20,
      marginBottom: 24,
      shadowColor: '#0F172A',
      shadowOffset: { width: 0, height: 2 },
      shadowOpacity: 0.04,
      shadowRadius: 8,
    },
    continueCardHeader: {
      marginBottom: 16,
    },
    topicName: {
      color: colors.text,
      fontSize: 18,
      fontWeight: '800',
    },
    subtopicName: {
      color: colors.textMuted,
      fontSize: 14,
      fontWeight: '500',
      marginTop: 2,
    },
    progressRow: {
      flexDirection: 'row',
      alignItems: 'center',
      gap: 12,
      marginBottom: 16,
    },
    progressBarTrack: {
      flex: 1,
      height: 8,
      backgroundColor: colors.surfaceSecondary,
      borderRadius: 999,
      overflow: 'hidden',
    },
    progressBarFill: {
      height: '100%',
      backgroundColor: '#F59E0B',
      borderRadius: 999,
    },
    progressPercentageText: {
      color: colors.text,
      fontSize: 13,
      fontWeight: '700',
    },
    continueBtnRow: {
      alignItems: 'flex-end',
      borderTopWidth: 1,
      borderColor: colors.surfaceSecondary,
      paddingTop: 12,
    },
    continueBtnText: {
      color: colors.primary,
      fontSize: 14,
      fontWeight: '700',
    },
    focusGrid: {
      flexDirection: 'row',
      gap: 12,
      marginBottom: 24,
    },
    focusCard: {
      flex: 1,
      backgroundColor: colors.surface,
      borderColor: colors.border,
      borderWidth: 1,
      borderRadius: 16,
      padding: 16,
      shadowColor: '#0F172A',
      shadowOffset: { width: 0, height: 2 },
      shadowOpacity: 0.04,
      shadowRadius: 6,
    },
    focusTopicTitle: {
      color: colors.text,
      fontSize: 15,
      fontWeight: '700',
    },
    focusScoreMint: {
      color: '#10B981',
      fontSize: 24,
      fontWeight: '800',
      marginVertical: 4,
    },
    focusScoreAmber: {
      color: '#F59E0B',
      fontSize: 24,
      fontWeight: '800',
      marginVertical: 4,
    },
    badgeMint: {
      backgroundColor: colors.successSurface,
      alignSelf: 'flex-start',
      paddingHorizontal: 8,
      paddingVertical: 2,
      borderRadius: 999,
    },
    badgeMintText: {
      color: '#10B981',
      fontSize: 11,
      fontWeight: '700',
    },
    badgeAmber: {
      backgroundColor: colors.warningSurface,
      alignSelf: 'flex-start',
      paddingHorizontal: 8,
      paddingVertical: 2,
      borderRadius: 999,
    },
    badgeAmberText: {
      color: '#F59E0B',
      fontSize: 11,
      fontWeight: '700',
    },
    practiceCard: {
      backgroundColor: colors.surface,
      borderColor: colors.border,
      borderWidth: 1,
      borderRadius: 16,
      padding: 20,
      marginBottom: 24,
      shadowColor: '#0F172A',
      shadowOffset: { width: 0, height: 2 },
      shadowOpacity: 0.04,
      shadowRadius: 8,
    },
    practiceInfoRow: {
      flexDirection: 'row',
      justifyContent: 'space-between',
      alignItems: 'center',
      marginBottom: 16,
    },
    practiceMetaText: {
      color: colors.text,
      fontSize: 15,
      fontWeight: '700',
    },
    practiceTargetText: {
      color: colors.textMuted,
      fontSize: 12,
      fontWeight: '500',
    },
    startPracticeBtn: {
      backgroundColor: '#F59E0B',
      borderRadius: 10,
      paddingVertical: 14,
      alignItems: 'center',
    },
    startPracticeBtnText: {
      color: '#090D16',
      fontSize: 15,
      fontWeight: '700',
    },
    quickLinksRow: {
      flexDirection: 'row',
      gap: 12,
    },
    linkCard: {
      flex: 1,
      backgroundColor: colors.surfaceSecondary,
      borderRadius: 12,
      padding: 14,
    },
    linkTitle: {
      color: colors.text,
      fontSize: 13,
      fontWeight: '700',
    },
    linkTitleRed: {
      color: '#EF4444',
      fontSize: 13,
      fontWeight: '700',
    },
    linkSub: {
      color: colors.textMuted,
      fontSize: 11,
      marginTop: 2,
    },
    parentBanner: {
      // Deliberately a fixed navy highlight card, not theme-swapped —
      // reads as a distinct "special" callout in both modes, the same
      // way a promotional banner stays its own color regardless of
      // the surrounding page theme.
      marginTop: 16,
      backgroundColor: '#1E1B4B',
      borderColor: '#4338CA',
      borderWidth: 1,
      borderRadius: 16,
      padding: 14,
      flexDirection: 'row',
      alignItems: 'center',
      gap: 12,
    },
    parentBannerIconBox: {
      width: 40,
      height: 40,
      borderRadius: 12,
      backgroundColor: '#312E81',
      alignItems: 'center',
      justifyContent: 'center',
    },
    parentBannerTitle: {
      color: '#FFFFFF',
      fontSize: 14,
      fontWeight: '800',
    },
    parentBannerSub: {
      color: '#C7D2FE',
      fontSize: 11,
      marginTop: 2,
    },
    parentBannerArrow: {
      color: '#818CF8',
      fontSize: 18,
      fontWeight: 'bold',
    },
  });
}
