import React, { useEffect, useMemo, useState } from 'react';
import { StyleSheet, Text, View, ScrollView, TouchableOpacity, SafeAreaView } from 'react-native';
import { useRouter } from 'expo-router';
import { useTheme } from '@/hooks/use-theme';
import { useAuth } from '@/lib/authContext';
import ActivityPlayer from '@/components/ActivityPlayer';
import {
  getMobileTopics,
  fetchActivities,
  submitActivityAttempt,
  type Activity,
} from '@/services/supabaseService';
import type { Topic } from '@/services/dataService';

// Real counterpart of mathora-web's student practice page's "Activities"
// tab, as its own screen rather than folded into practice.tsx — that
// screen is still hardcoded mock UI (no topicId param, no Supabase
// wiring at all), so bolting a real Supabase-backed mode onto it would
// mean half the screen is real and half is a fixed prop. This screen is
// fully wired: pick a topic, then play through its published activities.
export default function ActivitiesScreen() {
  const router = useRouter();
  const { user } = useAuth();
  const colors = useTheme();
  const styles = useMemo(() => createStyles(colors), [colors]);

  const [topics, setTopics] = useState<Topic[]>([]);
  const [topicsLoading, setTopicsLoading] = useState(true);
  const [selectedTopic, setSelectedTopic] = useState<Topic | null>(null);

  const [activities, setActivities] = useState<Activity[]>([]);
  const [activitiesLoading, setActivitiesLoading] = useState(false);
  const [activityIndex, setActivityIndex] = useState(0);
  const [lastResult, setLastResult] = useState<{ score: number } | null>(null);

  useEffect(() => {
    getMobileTopics().then((data) => {
      setTopics(data);
      setTopicsLoading(false);
    });
  }, []);

  useEffect(() => {
    if (!selectedTopic) return;
    // Standard "load on selection change" effect — same justified
    // suppression used for this pattern elsewhere in the app (see
    // roster.tsx / mathora-web's useOfflineFlush.ts).
    // eslint-disable-next-line react-hooks/set-state-in-effect
    setActivitiesLoading(true);
    setActivityIndex(0);
    setLastResult(null);
    fetchActivities(selectedTopic.id).then((data) => {
      setActivities(data);
      setActivitiesLoading(false);
    });
  }, [selectedTopic]);

  const currentActivity = activities[activityIndex];

  const handleComplete = ({ score, time_taken_seconds }: { score: number; time_taken_seconds: number }) => {
    setLastResult({ score });
    if (user) {
      submitActivityAttempt({
        studentAuthUserId: user.id,
        activity_id: currentActivity.id,
        score,
        time_taken_seconds,
      });
    }
  };

  const handleNext = () => {
    setLastResult(null);
    setActivityIndex((prev) => prev + 1);
  };

  return (
    <SafeAreaView style={styles.container}>
      <ScrollView contentContainerStyle={styles.scrollContent}>
        <TouchableOpacity
          style={styles.backBtn}
          onPress={() => (selectedTopic ? setSelectedTopic(null) : router.back())}
        >
          <Text style={styles.backText}>
            {selectedTopic ? `← ${selectedTopic.title}` : '← Back to Dashboard'}
          </Text>
        </TouchableOpacity>

        <Text style={styles.badge}>INTERACTIVE ACTIVITIES</Text>
        <Text style={styles.title}>{selectedTopic ? 'Play Activities' : 'Choose a Topic'}</Text>

        {!selectedTopic ? (
          <>
            {topicsLoading && <Text style={styles.mutedText}>Loading topics…</Text>}
            {!topicsLoading && topics.length === 0 && (
              <Text style={styles.mutedText}>No topics available yet.</Text>
            )}
            <View style={{ gap: 10, marginTop: 8 }}>
              {topics.map((t) => (
                <TouchableOpacity key={t.id} style={styles.topicRow} onPress={() => setSelectedTopic(t)}>
                  <Text style={styles.topicTitle}>{t.title}</Text>
                  <Text style={styles.topicMeta}>{t.class_level}</Text>
                </TouchableOpacity>
              ))}
            </View>
          </>
        ) : activitiesLoading ? (
          <Text style={styles.mutedText}>Loading activities…</Text>
        ) : activities.length === 0 ? (
          <View style={styles.emptyCard}>
            <Text style={styles.mutedText}>No activities for this topic yet.</Text>
          </View>
        ) : !currentActivity ? (
          <View style={styles.emptyCard}>
            <Text style={styles.mutedText}>You&apos;ve completed every activity for this topic!</Text>
          </View>
        ) : (
          <>
            <Text style={styles.progressText}>
              Activity {activityIndex + 1} of {activities.length}
            </Text>
            <ActivityPlayer
              key={currentActivity.id}
              activity={currentActivity}
              onComplete={handleComplete}
            />
            {lastResult && (
              <TouchableOpacity style={styles.nextBtn} onPress={handleNext}>
                <Text style={styles.nextBtnText}>
                  Scored {lastResult.score}% — {activityIndex < activities.length - 1 ? 'Next Activity →' : 'Finish'}
                </Text>
              </TouchableOpacity>
            )}
          </>
        )}
      </ScrollView>
    </SafeAreaView>
  );
}

function createStyles(colors: ReturnType<typeof useTheme>) {
  return StyleSheet.create({
    container: { flex: 1, backgroundColor: colors.background },
    scrollContent: { padding: 16, paddingBottom: 40 },
    backBtn: { marginBottom: 12 },
    backText: { color: colors.primary, fontSize: 14, fontWeight: 'bold' },
    badge: { color: '#6366F1', fontSize: 10, fontWeight: 'bold', letterSpacing: 1 },
    title: { color: colors.text, fontSize: 22, fontWeight: 'bold', marginTop: 4, marginBottom: 16 },
    mutedText: { color: colors.textMuted, fontSize: 12 },
    progressText: { color: colors.textMuted, fontSize: 12, fontWeight: '600', marginBottom: 8 },
    topicRow: {
      flexDirection: 'row', alignItems: 'center', justifyContent: 'space-between',
      backgroundColor: colors.surface, borderColor: colors.border, borderWidth: 1, borderRadius: 12, padding: 14,
    },
    topicTitle: { color: colors.text, fontSize: 14, fontWeight: '600', flex: 1 },
    topicMeta: {
      color: colors.textMuted, fontSize: 10, fontWeight: 'bold',
      backgroundColor: colors.surfaceSecondary, borderRadius: 6, paddingHorizontal: 8, paddingVertical: 3,
    },
    emptyCard: {
      backgroundColor: colors.surface, borderColor: colors.border, borderWidth: 1,
      borderRadius: 16, padding: 20, alignItems: 'center',
    },
    nextBtn: { backgroundColor: '#10B981', borderRadius: 10, paddingVertical: 14, alignItems: 'center', marginTop: 12 },
    nextBtnText: { color: '#FFFFFF', fontSize: 14, fontWeight: 'bold' },
  });
}
