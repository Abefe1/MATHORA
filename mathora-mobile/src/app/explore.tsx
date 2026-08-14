import React, { useState } from 'react';
import {
  StyleSheet,
  Text,
  View,
  ScrollView,
  TouchableOpacity,
  SafeAreaView,
  TextInput,
  StatusBar,
} from 'react-native';
import { useRouter } from 'expo-router';
import { TOPICS_DATA, Topic, Lesson } from '@/services/dataService';
import MathView from '@/components/math-view';

export default function CurriculumExploreScreen() {
  const router = useRouter();
  const [selectedClass, setSelectedClass] = useState<'ALL' | 'SS1' | 'SS2' | 'SS3'>('ALL');
  const [searchQuery, setSearchQuery] = useState('');
  const [expandedTopicId, setExpandedTopicId] = useState<string | null>('t-quadratics');
  const [activeLesson, setActiveLesson] = useState<Lesson | null>(TOPICS_DATA[0].lessons[0] || null);

  const filteredTopics = TOPICS_DATA.filter((topic) => {
    const matchesClass = selectedClass === 'ALL' || topic.class_level === selectedClass;
    const matchesSearch =
      topic.title.toLowerCase().includes(searchQuery.toLowerCase()) ||
      topic.description.toLowerCase().includes(searchQuery.toLowerCase());
    return matchesClass && matchesSearch;
  });

  return (
    <SafeAreaView style={styles.container}>
      <StatusBar barStyle="light-content" backgroundColor="#090D16" />
      <ScrollView contentContainerStyle={styles.scrollContent}>
        {/* Top Header Banner */}
        <View style={styles.header}>
          <Text style={styles.badgeText}>NERDC & WAEC ALIGNED CURRICULUM</Text>
          <Text style={styles.title}>Mathematics Explorer</Text>
          <Text style={styles.subtitle}>
            Browse lessons, step-by-step worked examples, WAEC exam shortcuts, and trap warnings.
          </Text>
        </View>

        {/* Search Bar */}
        <View style={styles.searchBox}>
          <TextInput
            style={styles.searchInput}
            placeholder="Search topics (e.g. Quadratics, Sine rule...)"
            placeholderTextColor="#64748B"
            value={searchQuery}
            onChangeText={setSearchQuery}
          />
        </View>

        {/* Class Filter Tabs */}
        <View style={styles.filterRow}>
          {(['ALL', 'SS1', 'SS2', 'SS3'] as const).map((cls) => {
            const isSelected = selectedClass === cls;
            return (
              <TouchableOpacity
                key={cls}
                style={[styles.filterChip, isSelected && styles.filterChipActive]}
                onPress={() => setSelectedClass(cls)}
              >
                <Text style={[styles.filterChipText, isSelected && styles.filterChipTextActive]}>
                  {cls === 'ALL' ? 'All Classes' : cls}
                </Text>
              </TouchableOpacity>
            );
          })}
        </View>

        {/* Topics List */}
        <Text style={styles.sectionTitle}>Curriculum Topics ({filteredTopics.length})</Text>

        {filteredTopics.map((topic: Topic) => {
          const isExpanded = expandedTopicId === topic.id;
          return (
            <View key={topic.id} style={styles.topicCard}>
              <TouchableOpacity
                style={styles.topicHeader}
                onPress={() => setExpandedTopicId(isExpanded ? null : topic.id)}
                activeOpacity={0.8}
              >
                <View style={styles.topicHeaderLeft}>
                  <View style={styles.classBadgeContainer}>
                    <Text style={styles.classBadge}>{topic.class_level}</Text>
                  </View>
                  <View style={{ flex: 1 }}>
                    <Text style={styles.topicTitle}>{topic.title}</Text>
                    <Text style={styles.topicDesc} numberOfLines={2}>
                      {topic.description}
                    </Text>
                  </View>
                </View>

                <View style={styles.masteryCol}>
                  <Text style={styles.masteryVal}>{topic.mastery_percentage}%</Text>
                  <Text style={styles.masteryLbl}>Mastery</Text>
                </View>
              </TouchableOpacity>

              {/* Progress Bar */}
              <View style={styles.progressBg}>
                <View
                  style={[
                    styles.progressFill,
                    {
                      width: `${topic.mastery_percentage}%`,
                      backgroundColor:
                        topic.mastery_percentage >= 80
                          ? '#10B981'
                          : topic.mastery_percentage >= 50
                          ? '#F59E0B'
                          : '#EF4444',
                    },
                  ]}
                />
              </View>

              {/* Expanded Lesson Drawer */}
              {isExpanded && (
                <View style={styles.expandedContent}>
                  <Text style={styles.subHeader}>Lessons & Worked Examples</Text>

                  {topic.lessons.length === 0 ? (
                    <Text style={styles.emptyText}>Lessons coming soon for this topic.</Text>
                  ) : (
                    topic.lessons.map((lesson) => {
                      const isLessonActive = activeLesson?.id === lesson.id;
                      return (
                        <View key={lesson.id} style={styles.lessonBox}>
                          <TouchableOpacity
                            style={styles.lessonTitleRow}
                            onPress={() => setActiveLesson(isLessonActive ? null : lesson)}
                          >
                            <Text style={styles.lessonTitle}>
                              {lesson.order_index}. {lesson.title}
                            </Text>
                            <Text style={styles.lessonToggleText}>
                              {isLessonActive ? '▲ Collapse' : '▼ Read Lesson'}
                            </Text>
                          </TouchableOpacity>

                          {isLessonActive && (
                            <View style={styles.lessonBodyContainer}>
                              <Text style={styles.lessonSummary}>{lesson.summary}</Text>
                              
                              <MathView expression={lesson.content_body} size="sm" style={styles.mathBox} />

                              {/* Worked Examples */}
                              {lesson.worked_examples.map((ex, idx) => (
                                <View key={idx} style={styles.exampleCard}>
                                  <Text style={styles.exampleTitle}>💡 {ex.title}</Text>
                                  <Text style={styles.problemText}>Problem: {ex.problem_statement}</Text>
                                  
                                  <Text style={styles.stepsHeader}>Step-by-Step Solution:</Text>
                                  {ex.solution_steps.map((step, sIdx) => (
                                    <Text key={sIdx} style={styles.stepItem}>
                                      {sIdx + 1}. {step}
                                    </Text>
                                  ))}

                                  {ex.exam_shortcut && (
                                    <View style={styles.shortcutCard}>
                                      <Text style={styles.shortcutTitle}>⚡ WAEC EXAM SHORTCUT</Text>
                                      <Text style={styles.shortcutText}>{ex.exam_shortcut}</Text>
                                    </View>
                                  )}

                                  {ex.common_trap_warning && (
                                    <View style={styles.trapCard}>
                                      <Text style={styles.trapTitle}>⚠️ COMMON TRAP WARNING</Text>
                                      <Text style={styles.trapText}>{ex.common_trap_warning}</Text>
                                    </View>
                                  )}
                                </View>
                              ))}
                            </View>
                          )}
                        </View>
                      );
                    })
                  )}

                  {/* Topic Practice Launcher Button */}
                  <TouchableOpacity
                    style={styles.practiceLauncherBtn}
                    onPress={() => router.push('/practice')}
                  >
                    <Text style={styles.practiceLauncherText}>⚡ Practice {topic.title} Questions</Text>
                  </TouchableOpacity>
                </View>
              )}
            </View>
          );
        })}
      </ScrollView>
    </SafeAreaView>
  );
}

const styles = StyleSheet.create({
  container: { flex: 1, backgroundColor: '#090D16' },
  scrollContent: { padding: 16 },
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
  searchBox: { marginBottom: 14 },
  searchInput: {
    backgroundColor: '#0F172A',
    borderColor: '#1E293B',
    borderWidth: 1,
    borderRadius: 12,
    padding: 14,
    color: '#FFFFFF',
    fontSize: 14,
  },
  filterRow: { flexDirection: 'row', gap: 8, marginBottom: 16 },
  filterChip: {
    backgroundColor: '#0F172A',
    borderColor: '#1E293B',
    borderWidth: 1,
    borderRadius: 20,
    paddingHorizontal: 16,
    paddingVertical: 8,
  },
  filterChipActive: { backgroundColor: '#1E1B4B', borderColor: '#4338CA' },
  filterChipText: { color: '#94A3B8', fontSize: 12, fontWeight: '600' },
  filterChipTextActive: { color: '#38BDF8', fontWeight: 'bold' },
  sectionTitle: { color: '#F8FAFC', fontSize: 18, fontWeight: 'bold', marginBottom: 12 },
  topicCard: {
    backgroundColor: '#0F172A',
    borderColor: '#1E293B',
    borderWidth: 1,
    borderRadius: 16,
    padding: 16,
    marginBottom: 14,
  },
  topicHeader: { flexDirection: 'row', justifyContent: 'space-between', alignItems: 'center' },
  topicHeaderLeft: { flexDirection: 'row', flex: 1, gap: 12, alignItems: 'flex-start', paddingRight: 8 },
  classBadgeContainer: { backgroundColor: '#1E293B', paddingHorizontal: 8, paddingVertical: 4, borderRadius: 6 },
  classBadge: { color: '#F59E0B', fontSize: 10, fontWeight: 'bold' },
  topicTitle: { color: '#FFFFFF', fontSize: 16, fontWeight: 'bold' },
  topicDesc: { color: '#94A3B8', fontSize: 12, marginTop: 2 },
  masteryCol: { alignItems: 'flex-end' },
  masteryVal: { color: '#F59E0B', fontSize: 16, fontWeight: 'bold' },
  masteryLbl: { color: '#64748B', fontSize: 10 },
  progressBg: { height: 6, backgroundColor: '#1E293B', borderRadius: 3, marginTop: 12, overflow: 'hidden' },
  progressFill: { height: '100%', borderRadius: 3 },
  expandedContent: { marginTop: 16, borderTopWidth: 1, borderColor: '#1E293B', paddingTop: 14 },
  subHeader: { color: '#C7D2FE', fontSize: 13, fontWeight: 'bold', marginBottom: 10 },
  emptyText: { color: '#64748B', fontSize: 12, fontStyle: 'italic' },
  lessonBox: { backgroundColor: '#1E1B4B33', borderColor: '#312E81', borderWidth: 1, borderRadius: 12, padding: 12, marginBottom: 10 },
  lessonTitleRow: { flexDirection: 'row', justifyContent: 'space-between', alignItems: 'center' },
  lessonTitle: { color: '#FFFFFF', fontSize: 14, fontWeight: 'bold', flex: 1 },
  lessonToggleText: { color: '#38BDF8', fontSize: 11, fontWeight: 'bold' },
  lessonBodyContainer: { marginTop: 10 },
  lessonSummary: { color: '#94A3B8', fontSize: 12, marginBottom: 8 },
  mathBox: { marginVertical: 6 },
  exampleCard: { backgroundColor: '#0F172A', borderColor: '#334155', borderWidth: 1, borderRadius: 10, padding: 12, marginTop: 10 },
  exampleTitle: { color: '#FDE68A', fontSize: 13, fontWeight: 'bold', marginBottom: 4 },
  problemText: { color: '#FFFFFF', fontSize: 13, fontWeight: 'bold', marginBottom: 8 },
  stepsHeader: { color: '#C7D2FE', fontSize: 11, fontWeight: 'bold', marginBottom: 4 },
  stepItem: { color: '#CBD5E1', fontSize: 12, lineHeight: 18, marginBottom: 2 },
  shortcutCard: { backgroundColor: '#064E3B33', borderColor: '#059669', borderWidth: 1, borderRadius: 8, padding: 10, marginTop: 8 },
  shortcutTitle: { color: '#34D399', fontSize: 10, fontWeight: 'bold' },
  shortcutText: { color: '#ECFDF5', fontSize: 12, marginTop: 2 },
  trapCard: { backgroundColor: '#7F1D1D33', borderColor: '#DC2626', borderWidth: 1, borderRadius: 8, padding: 10, marginTop: 8 },
  trapTitle: { color: '#FCA5A5', fontSize: 10, fontWeight: 'bold' },
  trapText: { color: '#FEE2E2', fontSize: 12, marginTop: 2 },
  practiceLauncherBtn: { backgroundColor: '#F59E0B', borderRadius: 10, padding: 14, alignItems: 'center', marginTop: 12 },
  practiceLauncherText: { color: '#090D16', fontSize: 14, fontWeight: 'bold' },
});
