import React, { useState } from 'react';
import {
  StyleSheet,
  Text,
  View,
  ScrollView,
  TouchableOpacity,
  SafeAreaView,
  Modal,
  TextInput,
  StatusBar,
} from 'react-native';
import { useRouter } from 'expo-router';
import { STUDY_SQUADS_DATA, StudySquad } from '@/services/dataService';

export default function SquadsScreen() {
  const router = useRouter();
  const [squads, setSquads] = useState<StudySquad[]>(STUDY_SQUADS_DATA);
  const [showJoinModal, setShowJoinModal] = useState(false);
  const [joinCode, setJoinCode] = useState('');
  const [joinedSuccess, setJoinedSuccess] = useState<string | null>(null);

  const handleJoinSquad = () => {
    if (!joinCode.trim()) return;
    setJoinedSuccess(`Successfully joined squad with code: ${joinCode.toUpperCase()}`);
    setTimeout(() => {
      setShowJoinModal(false);
      setJoinCode('');
      setJoinedSuccess(null);
    }, 1500);
  };

  return (
    <SafeAreaView style={styles.container}>
      <StatusBar barStyle="light-content" backgroundColor="#090D16" />
      <ScrollView contentContainerStyle={styles.scrollContent}>
        <TouchableOpacity style={styles.backBtn} onPress={() => router.back()}>
          <Text style={styles.backText}>← Back to Dashboard</Text>
        </TouchableOpacity>

        {/* Header */}
        <View style={styles.header}>
          <Text style={styles.badgeText}>STUDENT ACCOUNTABILITY SQUADS</Text>
          <Text style={styles.title}>WAEC Study Squads</Text>
          <Text style={styles.subtitle}>
            Self-organized student study groups, weekly question targets, and global rank leaderboards.
          </Text>
        </View>

        {/* Quick Actions Row */}
        <View style={styles.actionRow}>
          <TouchableOpacity
            style={styles.joinBtn}
            onPress={() => setShowJoinModal(true)}
            activeOpacity={0.8}
          >
            <Text style={styles.joinBtnText}>+ Join Squad with Code</Text>
          </TouchableOpacity>
        </View>

        <Text style={styles.sectionTitle}>Your Active Squads ({squads.length})</Text>

        {squads.map((squad) => {
          const progressPercent = Math.min(
            100,
            Math.round((squad.weekly_progress_questions / squad.weekly_goal_questions) * 100)
          );

          return (
            <View key={squad.id} style={styles.squadCard}>
              <View style={styles.squadHeaderRow}>
                <View style={{ flex: 1 }}>
                  <Text style={styles.squadFocusBadge}>{squad.exam_focus}</Text>
                  <Text style={styles.squadName}>{squad.name}</Text>
                </View>
                <View style={styles.rankBadge}>
                  <Text style={styles.rankText}>RANK #{squad.rank_position}</Text>
                </View>
              </View>

              {/* Weekly Goal Progress */}
              <View style={styles.goalBox}>
                <View style={styles.goalHeaderRow}>
                  <Text style={styles.goalLabel}>Weekly Squad Target:</Text>
                  <Text style={styles.goalValue}>
                    {squad.weekly_progress_questions} / {squad.weekly_goal_questions} Questions
                  </Text>
                </View>
                <View style={styles.progressBg}>
                  <View style={[styles.progressFill, { width: `${progressPercent}%` }]} />
                </View>
              </View>

              {/* Announcement Feed */}
              {squad.recent_announcement && (
                <View style={styles.announcementCard}>
                  <Text style={styles.announcementTag}>SQUAD ANNOUNCEMENT</Text>
                  <Text style={styles.announcementText}>{squad.recent_announcement}</Text>
                </View>
              )}

              {/* Leaderboard */}
              <Text style={styles.leaderboardTitle}>🏆 Top Squad Contributors This Week</Text>
              <View style={styles.leaderboardContainer}>
                {squad.top_members.map((member, idx) => (
                  <View key={idx} style={styles.memberRow}>
                    <Text style={styles.avatarText}>{member.avatar}</Text>
                    <Text style={styles.memberName}>{member.name}</Text>
                    <Text style={styles.memberScore}>{member.score} Qs</Text>
                  </View>
                ))}
              </View>

              <TouchableOpacity
                style={styles.squadActionBtn}
                onPress={() => router.push('/practice')}
              >
                <Text style={styles.squadActionBtnText}>⚡ Solve Questions for Squad (+10 XP)</Text>
              </TouchableOpacity>
            </View>
          );
        })}
      </ScrollView>

      {/* Join Squad Modal */}
      <Modal visible={showJoinModal} animationType="slide" transparent>
        <View style={styles.modalOverlay}>
          <View style={styles.modalContent}>
            <Text style={styles.modalBadge}>ENTER SQUAD CODE</Text>
            <Text style={styles.modalTitle}>Join Study Squad</Text>

            {joinedSuccess ? (
              <View style={styles.successBox}>
                <Text style={styles.successText}>{joinedSuccess}</Text>
              </View>
            ) : (
              <>
                <TextInput
                  style={styles.input}
                  placeholder="e.g. WARRIOR-2026"
                  placeholderTextColor="#64748B"
                  value={joinCode}
                  onChangeText={setJoinCode}
                  autoCapitalize="characters"
                />

                <TouchableOpacity style={styles.submitModalBtn} onPress={handleJoinSquad}>
                  <Text style={styles.submitModalText}>Confirm & Join Squad</Text>
                </TouchableOpacity>

                <TouchableOpacity style={styles.cancelModalBtn} onPress={() => setShowJoinModal(false)}>
                  <Text style={styles.cancelModalText}>Cancel</Text>
                </TouchableOpacity>
              </>
            )}
          </View>
        </View>
      </Modal>
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
  badgeText: { color: '#F59E0B', fontSize: 10, fontWeight: 'bold', letterSpacing: 1 },
  title: { color: '#FFFFFF', fontSize: 26, fontWeight: 'bold', marginTop: 4 },
  subtitle: { color: '#94A3B8', fontSize: 13, marginTop: 4, lineHeight: 18 },
  actionRow: { marginBottom: 16 },
  joinBtn: {
    backgroundColor: '#F59E0B',
    borderRadius: 12,
    padding: 14,
    alignItems: 'center',
  },
  joinBtnText: { color: '#090D16', fontSize: 15, fontWeight: 'bold' },
  sectionTitle: { color: '#F8FAFC', fontSize: 18, fontWeight: 'bold', marginBottom: 12 },
  squadCard: {
    backgroundColor: '#0F172A',
    borderColor: '#1E293B',
    borderWidth: 1,
    borderRadius: 18,
    padding: 16,
    marginBottom: 16,
  },
  squadHeaderRow: { flexDirection: 'row', justifyContent: 'space-between', alignItems: 'flex-start' },
  squadFocusBadge: { color: '#38BDF8', fontSize: 10, fontWeight: 'bold', letterSpacing: 1 },
  squadName: { color: '#FFFFFF', fontSize: 18, fontWeight: 'bold', marginTop: 2 },
  rankBadge: { backgroundColor: '#78350F', paddingHorizontal: 10, paddingVertical: 4, borderRadius: 8 },
  rankText: { color: '#FDE68A', fontSize: 10, fontWeight: 'bold' },
  goalBox: { marginTop: 14, backgroundColor: '#1E1B4B44', borderRadius: 10, padding: 12 },
  goalHeaderRow: { flexDirection: 'row', justifyContent: 'space-between', marginBottom: 6 },
  goalLabel: { color: '#94A3B8', fontSize: 12 },
  goalValue: { color: '#F59E0B', fontSize: 12, fontWeight: 'bold' },
  progressBg: { height: 6, backgroundColor: '#1E293B', borderRadius: 3, overflow: 'hidden' },
  progressFill: { height: '100%', backgroundColor: '#F59E0B', borderRadius: 3 },
  announcementCard: {
    backgroundColor: '#064E3B22',
    borderColor: '#059669',
    borderWidth: 1,
    borderRadius: 10,
    padding: 12,
    marginTop: 12,
  },
  announcementTag: { color: '#34D399', fontSize: 10, fontWeight: 'bold' },
  announcementText: { color: '#ECFDF5', fontSize: 12, marginTop: 4, lineHeight: 16 },
  leaderboardTitle: { color: '#C7D2FE', fontSize: 13, fontWeight: 'bold', marginTop: 14, marginBottom: 8 },
  leaderboardContainer: { backgroundColor: '#1E1B4B33', borderRadius: 10, padding: 10 },
  memberRow: { flexDirection: 'row', alignItems: 'center', paddingVertical: 6, borderBottomWidth: 1, borderColor: '#1E293B' },
  avatarText: { fontSize: 16, marginRight: 8 },
  memberName: { color: '#FFFFFF', fontSize: 13, flex: 1, fontWeight: '600' },
  memberScore: { color: '#F59E0B', fontSize: 12, fontWeight: 'bold' },
  squadActionBtn: {
    backgroundColor: '#1E1B4B',
    borderColor: '#4338CA',
    borderWidth: 1,
    borderRadius: 12,
    padding: 12,
    alignItems: 'center',
    marginTop: 14,
  },
  squadActionBtnText: { color: '#38BDF8', fontSize: 13, fontWeight: 'bold' },
  modalOverlay: { flex: 1, backgroundColor: '#000000AA', justifyContent: 'flex-end' },
  modalContent: {
    backgroundColor: '#0F172A',
    borderTopLeftRadius: 24,
    borderTopRightRadius: 24,
    padding: 24,
    borderColor: '#F59E0B',
    borderTopWidth: 2,
  },
  modalBadge: { color: '#F59E0B', fontSize: 10, fontWeight: 'bold', letterSpacing: 1 },
  modalTitle: { color: '#FFFFFF', fontSize: 20, fontWeight: 'bold', marginTop: 4, marginBottom: 16 },
  input: {
    backgroundColor: '#1E1B4B',
    borderColor: '#4338CA',
    borderWidth: 1,
    borderRadius: 10,
    padding: 14,
    color: '#FFFFFF',
    fontSize: 16,
    fontWeight: 'bold',
    marginBottom: 16,
  },
  submitModalBtn: { backgroundColor: '#F59E0B', borderRadius: 12, padding: 14, alignItems: 'center' },
  submitModalText: { color: '#090D16', fontSize: 15, fontWeight: 'bold' },
  cancelModalBtn: { marginTop: 10, padding: 12, alignItems: 'center' },
  cancelModalText: { color: '#94A3B8', fontSize: 14 },
  successBox: { backgroundColor: '#064E3B44', padding: 16, borderRadius: 12, alignItems: 'center' },
  successText: { color: '#34D399', fontSize: 14, fontWeight: 'bold' },
});
