import React, { useMemo, useState } from 'react';
import {
  StyleSheet,
  Text,
  View,
  ScrollView,
  TouchableOpacity,
  SafeAreaView,
  TextInput,
  StatusBar,
  useColorScheme,
} from 'react-native';
import { useRouter } from 'expo-router';
import { useTheme } from '@/hooks/use-theme';
import { TOPICS_DATA, Topic, Lesson } from '@/services/dataService';

export default function LearnScreen() {
  const router = useRouter();
  const colors = useTheme();
  const scheme = useColorScheme();
  const styles = useMemo(() => createStyles(colors), [colors]);
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
      <StatusBar barStyle={scheme === 'dark' ? 'light-content' : 'dark-content'} backgroundColor={colors.background} />
      <ScrollView contentContainerStyle={styles.scrollContent} showsVerticalScrollIndicator={false}>
        {/* Top Header */}
        <View style={styles.header}>
          <Text style={styles.title}>Mathematics Curriculum</Text>
          <Text style={styles.subtitle}>
            Simplified explanations, step-by-step worked examples & WAEC shortcuts.
          </Text>
        </View>

        {/* Search Input */}
        <View style={styles.searchContainer}>
          <TextInput
            style={styles.searchInput}
            placeholder="Search topics (e.g. Quadratics, Sine rule...)"
            placeholderTextColor={colors.textMuted}
            value={searchQuery}
            onChangeText={setSearchQuery}
          />
        </View>

        {/* Filter Chips */}
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
        <Text style={styles.sectionHeaderTitle}>Curriculum Topics ({filteredTopics.length})</Text>

        {filteredTopics.map((topic: Topic) => {
          const isExpanded = expandedTopicId === topic.id;
          return (
            <View key={topic.id} style={styles.topicCard}>
              <TouchableOpacity
                style={styles.topicHeaderRow}
                onPress={() => setExpandedTopicId(isExpanded ? null : topic.id)}
                activeOpacity={0.85}
              >
                <View style={styles.topicHeaderLeft}>
                  <View style={styles.classLevelBadge}>
                    <Text style={styles.classLevelText}>{topic.class_level}</Text>
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

              {/* Progress Track */}
              <View style={styles.progressTrack}>
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
                          : '#F43F5E',
                    },
                  ]}
                />
              </View>

              {/* Expanded Lesson Theory */}
              {isExpanded && (
                <View style={styles.expandedContent}>
                  <Text style={styles.lessonsSectionTitle}>Lessons & Worked Examples</Text>

                  {topic.lessons.length === 0 ? (
                    <Text style={styles.emptyLessonsText}>Lessons coming soon for this topic.</Text>
                  ) : (
                    topic.lessons.map((lesson) => {
                      const isLessonActive = activeLesson?.id === lesson.id;
                      return (
                        <View key={lesson.id} style={styles.lessonItemCard}>
                          <TouchableOpacity
                            style={styles.lessonHeaderRow}
                            onPress={() => setActiveLesson(isLessonActive ? null : lesson)}
                          >
                            <Text style={styles.lessonTitleText}>
                              {lesson.order_index}. {lesson.title}
                            </Text>
                            <Text style={styles.lessonToggleText}>
                              {isLessonActive ? '▲ Collapse' : '▼ Read Lesson'}
                            </Text>
                          </TouchableOpacity>

                          {isLessonActive && (
                            <View style={styles.lessonBodyArea}>
                              <Text style={styles.lessonSummaryText}>{lesson.summary}</Text>

                              {/* Worked Examples */}
                              {lesson.worked_examples.map((ex, idx) => (
                                <View key={idx} style={styles.workedExampleCard}>
                                  <Text style={styles.workedExampleTitle}>💡 {ex.title}</Text>
                                  <Text style={styles.problemStatementText}>
                                    Problem: {ex.problem_statement}
                                  </Text>

                                  <Text style={styles.solutionStepsTitle}>Step-by-Step Solution:</Text>
                                  {ex.solution_steps.map((step, sIdx) => (
                                    <Text key={sIdx} style={styles.stepText}>
                                      {sIdx + 1}. {step}
                                    </Text>
                                  ))}

                                  {ex.exam_shortcut && (
                                    <View style={styles.shortcutBox}>
                                      <Text style={styles.shortcutTitle}>⚡ WAEC EXAM SHORTCUT</Text>
                                      <Text style={styles.shortcutBody}>{ex.exam_shortcut}</Text>
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

                  {/* Practice Topic Launcher Button */}
                  <TouchableOpacity
                    style={styles.topicPracticeBtn}
                    onPress={() => router.push('/practice')}
                  >
                    <Text style={styles.topicPracticeBtnText}>Practise {topic.title} →</Text>
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

function createStyles(colors: ReturnType<typeof useTheme>) {
  return StyleSheet.create({
    container: { flex: 1, backgroundColor: colors.background },
    scrollContent: { padding: 20, paddingBottom: 40 },
    header: { marginBottom: 20 },
    title: { color: colors.text, fontSize: 24, fontWeight: '800' },
    subtitle: { color: colors.textMuted, fontSize: 13, marginTop: 4, lineHeight: 18 },
    searchContainer: { marginBottom: 14 },
    searchInput: {
      backgroundColor: colors.surface,
      borderColor: colors.border,
      borderWidth: 1,
      borderRadius: 10,
      padding: 14,
      color: colors.text,
      fontSize: 14,
    },
    filterRow: { flexDirection: 'row', gap: 8, marginBottom: 20 },
    filterChip: {
      backgroundColor: colors.surface,
      borderColor: colors.border,
      borderWidth: 1,
      borderRadius: 999,
      paddingHorizontal: 14,
      paddingVertical: 6,
    },
    filterChipActive: { backgroundColor: colors.warningSurface, borderColor: colors.primary },
    filterChipText: { color: colors.textMuted, fontSize: 12, fontWeight: '600' },
    filterChipTextActive: { color: colors.primary, fontWeight: '700' },
    sectionHeaderTitle: { color: colors.text, fontSize: 16, fontWeight: '700', marginBottom: 12 },
    topicCard: {
      backgroundColor: colors.surface,
      borderColor: colors.border,
      borderWidth: 1,
      borderRadius: 16,
      padding: 18,
      marginBottom: 14,
      shadowColor: '#0F172A',
      shadowOffset: { width: 0, height: 2 },
      shadowOpacity: 0.04,
      shadowRadius: 6,
    },
    topicHeaderRow: { flexDirection: 'row', justifyContent: 'space-between', alignItems: 'flex-start' },
    topicHeaderLeft: { flexDirection: 'row', flex: 1, gap: 12, alignItems: 'flex-start', paddingRight: 8 },
    classLevelBadge: { backgroundColor: colors.surfaceSecondary, paddingHorizontal: 8, paddingVertical: 3, borderRadius: 6 },
    classLevelText: { color: colors.primary, fontSize: 10, fontWeight: '700' },
    topicTitle: { color: colors.text, fontSize: 16, fontWeight: '800' },
    topicDesc: { color: colors.textMuted, fontSize: 12, marginTop: 2, lineHeight: 16 },
    masteryCol: { alignItems: 'flex-end' },
    masteryVal: { color: colors.primary, fontSize: 18, fontWeight: '800' },
    masteryLbl: { color: colors.textMuted, fontSize: 10 },
    progressTrack: { height: 6, backgroundColor: colors.surfaceSecondary, borderRadius: 3, marginTop: 12, overflow: 'hidden' },
    progressFill: { height: '100%', borderRadius: 3 },
    expandedContent: { marginTop: 16, borderTopWidth: 1, borderColor: colors.surfaceSecondary, paddingTop: 14 },
    lessonsSectionTitle: { color: colors.text, fontSize: 13, fontWeight: '700', marginBottom: 10 },
    emptyLessonsText: { color: colors.textMuted, fontSize: 12, fontStyle: 'italic' },
    lessonItemCard: { backgroundColor: colors.background, borderColor: colors.border, borderWidth: 1, borderRadius: 12, padding: 12, marginBottom: 10 },
    lessonHeaderRow: { flexDirection: 'row', justifyContent: 'space-between', alignItems: 'center' },
    lessonTitleText: { color: colors.text, fontSize: 14, fontWeight: '700', flex: 1 },
    lessonToggleText: { color: colors.primary, fontSize: 11, fontWeight: '700' },
    lessonBodyArea: { marginTop: 10 },
    lessonSummaryText: { color: colors.textMuted, fontSize: 12, marginBottom: 8 },
    workedExampleCard: { backgroundColor: colors.surface, borderColor: colors.border, borderWidth: 1, borderRadius: 10, padding: 12, marginTop: 8 },
    workedExampleTitle: { color: colors.text, fontSize: 13, fontWeight: '700', marginBottom: 4 },
    problemStatementText: { color: colors.text, fontSize: 13, fontWeight: '600', marginBottom: 6 },
    solutionStepsTitle: { color: colors.textMuted, fontSize: 11, fontWeight: '700', marginBottom: 4 },
    stepText: { color: colors.text, fontSize: 12, lineHeight: 18, marginBottom: 2 },
    shortcutBox: { backgroundColor: colors.successSurface, borderColor: colors.successBorder, borderWidth: 1, borderRadius: 8, padding: 10, marginTop: 8 },
    shortcutTitle: { color: '#10B981', fontSize: 10, fontWeight: '700' },
    shortcutBody: { color: colors.successText, fontSize: 12, marginTop: 2 },
    topicPracticeBtn: { backgroundColor: '#F59E0B', borderRadius: 10, paddingVertical: 12, alignItems: 'center', marginTop: 12 },
    topicPracticeBtnText: { color: '#090D16', fontSize: 14, fontWeight: '700' },
  });
}
