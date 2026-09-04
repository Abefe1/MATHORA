import React, { useEffect, useMemo, useState } from 'react';
import {
  StyleSheet,
  Text,
  View,
  ScrollView,
  TouchableOpacity,
  SafeAreaView,
  StatusBar,
  Modal,
  TextInput,
  useColorScheme,
} from 'react-native';
import { useRouter } from 'expo-router';
import { useTheme } from '@/hooks/use-theme';
import { StudySquad } from '@/services/dataService';
import { getMobileStudySquads } from '@/services/supabaseService';

export default function ProgressScreen() {
  const router = useRouter();
  const colors = useTheme();
  const scheme = useColorScheme();
  const styles = useMemo(() => createStyles(colors), [colors]);
  // getMobileStudySquads() reads study_groups_with_stats (a real view,
  // mathora_schema_study_groups_patch.sql) and falls back to the mock
  // list itself if unreachable — no separate mock/live branch needed
  // here. "Join Squad" stays a stub: join_study_group_with_code exists
  // as a real RPC, but nothing on either platform calls it yet — that's
  // net-new feature work, not a mobile-behind-web porting gap.
  const [squads, setSquads] = useState<StudySquad[]>([]);
  const [showJoinModal, setShowJoinModal] = useState(false);
  const [joinCode, setJoinCode] = useState('');

  useEffect(() => {
    getMobileStudySquads().then(setSquads);
  }, []);

  return (
    <SafeAreaView style={styles.container}>
      <StatusBar barStyle={scheme === 'dark' ? 'light-content' : 'dark-content'} backgroundColor={colors.background} />
      <ScrollView contentContainerStyle={styles.scrollContent} showsVerticalScrollIndicator={false}>
        {/* Top Header */}
        <View style={styles.header}>
          <Text style={styles.pageTitle}>Your Mathematics</Text>
          <Text style={styles.pageSub}>Mastery Index & Squad Leaderboard</Text>
        </View>

        {/* Hero Mastery Metric Card */}
        <View style={styles.masteryCard}>
          <Text style={styles.masteryLabel}>Overall Mastery</Text>
          <View style={styles.masteryScoreRow}>
            <Text style={styles.masteryPercent}>76%</Text>
            <View style={styles.growthBadge}>
              <Text style={styles.growthBadgeText}>↑ +8% this week</Text>
            </View>
          </View>
          <View style={styles.masteryBarTrack}>
            <View style={[styles.masteryBarFill, { width: '76%' }]} />
          </View>
        </View>

        {/* Strong Areas vs Needs Practice Grid */}
        <View style={styles.masteryBreakdownGrid}>
          {/* Strong Areas */}
          <View style={styles.breakdownBoxMint}>
            <Text style={styles.breakdownHeaderMint}>Strong areas</Text>
            <View style={styles.itemList}>
              <Text style={styles.itemTextMint}>✓ Number</Text>
              <Text style={styles.itemTextMint}>✓ Algebra</Text>
              <Text style={styles.itemTextMint}>✓ Statistics</Text>
            </View>
          </View>

          {/* Needs Practice */}
          <View style={styles.breakdownBoxAmber}>
            <Text style={styles.breakdownHeaderAmber}>Needs practice</Text>
            <View style={styles.itemList}>
              <Text style={styles.itemTextAmber}>⚠ Geometry</Text>
              <Text style={styles.itemTextAmber}>⚠ Trigonometry</Text>
            </View>
          </View>
        </View>

        {/* Recommended Next Card */}
        <Text style={styles.sectionTitle}>Recommended next</Text>
        <View style={styles.recommendedCard}>
          <View style={styles.recommendedHeader}>
            <Text style={styles.recommendedTitle}>Completing the square</Text>
            <Text style={styles.recommendedPrereq}>Prerequisite: Algebra</Text>
          </View>

          <TouchableOpacity
            style={styles.practiseBtn}
            onPress={() => router.push('/practice')}
            activeOpacity={0.88}
          >
            <Text style={styles.practiseBtnText}>Practise</Text>
          </TouchableOpacity>
        </View>

        {/* Study Squads & Leaderboard Section */}
        <View style={styles.squadHeaderRow}>
          <Text style={styles.sectionTitle}>WAEC Study Squads</Text>
          <TouchableOpacity onPress={() => setShowJoinModal(true)}>
            <Text style={styles.joinLinkText}>+ Join Squad</Text>
          </TouchableOpacity>
        </View>

        {squads.map((squad) => (
          <View key={squad.id} style={styles.squadCard}>
            <View style={styles.squadTopRow}>
              <View>
                <Text style={styles.squadFocus}>{squad.exam_focus}</Text>
                <Text style={styles.squadName}>{squad.name}</Text>
              </View>
              <View style={styles.rankBadge}>
                <Text style={styles.rankText}>RANK #{squad.rank_position}</Text>
              </View>
            </View>

            {/* Leaderboard */}
            <View style={styles.leaderboardBox}>
              <Text style={styles.leaderboardTitle}>Squad Contributor Rankings</Text>
              {squad.top_members.map((m, idx) => (
                <View key={idx} style={styles.memberRow}>
                  <Text style={styles.memberAvatar}>{m.avatar}</Text>
                  <Text style={styles.memberName}>{m.name}</Text>
                  <Text style={styles.memberScore}>{m.score} Qs</Text>
                </View>
              ))}
            </View>
          </View>
        ))}
      </ScrollView>

      {/* Join Squad Modal */}
      <Modal visible={showJoinModal} animationType="slide" transparent>
        <View style={styles.modalOverlay}>
          <View style={styles.modalContent}>
            <Text style={styles.modalTitle}>Join Study Squad</Text>
            <TextInput
              style={styles.input}
              placeholder="e.g. WARRIOR-2026"
              placeholderTextColor={colors.textMuted}
              value={joinCode}
              onChangeText={setJoinCode}
            />
            <TouchableOpacity
              style={styles.modalSubmitBtn}
              onPress={() => setShowJoinModal(false)}
            >
              <Text style={styles.modalSubmitBtnText}>Join Squad</Text>
            </TouchableOpacity>
          </View>
        </View>
      </Modal>
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
    header: {
      marginBottom: 20,
    },
    pageTitle: {
      color: colors.text,
      fontSize: 24,
      fontWeight: '800',
    },
    pageSub: {
      color: colors.textMuted,
      fontSize: 13,
      marginTop: 2,
    },
    masteryCard: {
      backgroundColor: colors.surface,
      borderColor: colors.border,
      borderWidth: 1,
      borderRadius: 16,
      padding: 20,
      marginBottom: 16,
      shadowColor: '#0F172A',
      shadowOffset: { width: 0, height: 2 },
      shadowOpacity: 0.04,
      shadowRadius: 8,
    },
    masteryLabel: {
      color: colors.textMuted,
      fontSize: 13,
      fontWeight: '600',
    },
    masteryScoreRow: {
      flexDirection: 'row',
      alignItems: 'baseline',
      gap: 12,
      marginVertical: 8,
    },
    masteryPercent: {
      color: colors.text,
      fontSize: 36,
      fontWeight: '800',
    },
    growthBadge: {
      backgroundColor: colors.successSurface,
      paddingHorizontal: 8,
      paddingVertical: 2,
      borderRadius: 999,
    },
    growthBadgeText: {
      color: colors.successText,
      fontSize: 12,
      fontWeight: '700',
    },
    masteryBarTrack: {
      height: 8,
      backgroundColor: colors.surfaceSecondary,
      borderRadius: 999,
      overflow: 'hidden',
    },
    masteryBarFill: {
      height: '100%',
      backgroundColor: '#10B981',
      borderRadius: 999,
    },
    masteryBreakdownGrid: {
      flexDirection: 'row',
      gap: 12,
      marginBottom: 24,
    },
    breakdownBoxMint: {
      flex: 1,
      backgroundColor: colors.surface,
      borderColor: colors.successBorder,
      borderWidth: 1,
      borderRadius: 16,
      padding: 16,
    },
    breakdownHeaderMint: {
      color: '#10B981',
      fontSize: 14,
      fontWeight: '700',
      marginBottom: 8,
    },
    breakdownBoxAmber: {
      flex: 1,
      backgroundColor: colors.surface,
      borderColor: colors.warningBorder,
      borderWidth: 1,
      borderRadius: 16,
      padding: 16,
    },
    breakdownHeaderAmber: {
      color: '#F59E0B',
      fontSize: 14,
      fontWeight: '700',
      marginBottom: 8,
    },
    itemList: {
      gap: 6,
    },
    itemTextMint: {
      color: colors.text,
      fontSize: 13,
      fontWeight: '600',
    },
    itemTextAmber: {
      color: colors.text,
      fontSize: 13,
      fontWeight: '600',
    },
    sectionTitle: {
      color: colors.text,
      fontSize: 16,
      fontWeight: '700',
      marginBottom: 12,
    },
    recommendedCard: {
      backgroundColor: colors.surface,
      borderColor: colors.border,
      borderWidth: 1,
      borderRadius: 16,
      padding: 18,
      flexDirection: 'row',
      alignItems: 'center',
      justifyContent: 'space-between',
      marginBottom: 24,
      shadowColor: '#0F172A',
      shadowOffset: { width: 0, height: 2 },
      shadowOpacity: 0.04,
      shadowRadius: 6,
    },
    recommendedHeader: {
      flex: 1,
      paddingRight: 12,
    },
    recommendedTitle: {
      color: colors.text,
      fontSize: 16,
      fontWeight: '700',
    },
    recommendedPrereq: {
      color: colors.textMuted,
      fontSize: 12,
      marginTop: 2,
    },
    practiseBtn: {
      backgroundColor: '#F59E0B',
      borderRadius: 10,
      paddingHorizontal: 20,
      paddingVertical: 10,
    },
    practiseBtnText: {
      color: '#090D16',
      fontSize: 14,
      fontWeight: '700',
    },
    squadHeaderRow: {
      flexDirection: 'row',
      justifyContent: 'space-between',
      alignItems: 'center',
      marginBottom: 12,
    },
    joinLinkText: {
      color: colors.primary,
      fontSize: 13,
      fontWeight: '700',
    },
    squadCard: {
      backgroundColor: colors.surface,
      borderColor: colors.border,
      borderWidth: 1,
      borderRadius: 16,
      padding: 16,
      marginBottom: 16,
    },
    squadTopRow: {
      flexDirection: 'row',
      justifyContent: 'space-between',
      alignItems: 'flex-start',
      marginBottom: 12,
    },
    squadFocus: {
      color: colors.primary,
      fontSize: 11,
      fontWeight: '700',
    },
    squadName: {
      color: colors.text,
      fontSize: 16,
      fontWeight: '800',
    },
    rankBadge: {
      backgroundColor: colors.warningSurface,
      paddingHorizontal: 8,
      paddingVertical: 2,
      borderRadius: 6,
    },
    rankText: {
      color: colors.warningText,
      fontSize: 10,
      fontWeight: '700',
    },
    leaderboardBox: {
      backgroundColor: colors.background,
      borderRadius: 10,
      padding: 12,
    },
    leaderboardTitle: {
      color: colors.textMuted,
      fontSize: 12,
      fontWeight: '700',
      marginBottom: 8,
    },
    memberRow: {
      flexDirection: 'row',
      alignItems: 'center',
      paddingVertical: 4,
    },
    memberAvatar: { fontSize: 14, marginRight: 8 },
    memberName: { color: colors.text, fontSize: 13, flex: 1, fontWeight: '600' },
    memberScore: { color: colors.primary, fontSize: 12, fontWeight: '700' },
    modalOverlay: { flex: 1, backgroundColor: '#00000088', justifyContent: 'flex-end' },
    modalContent: { backgroundColor: colors.surface, borderTopLeftRadius: 20, borderTopRightRadius: 20, padding: 24 },
    modalTitle: { color: colors.text, fontSize: 18, fontWeight: '700', marginBottom: 16 },
    input: { backgroundColor: colors.background, borderColor: colors.border, borderWidth: 1, borderRadius: 10, padding: 14, fontSize: 15, marginBottom: 16, color: colors.text },
    modalSubmitBtn: { backgroundColor: '#F59E0B', borderRadius: 10, paddingVertical: 14, alignItems: 'center' },
    modalSubmitBtnText: { color: '#090D16', fontSize: 15, fontWeight: '700' },
  });
}
