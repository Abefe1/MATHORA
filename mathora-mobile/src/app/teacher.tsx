import React, { useEffect, useMemo, useState } from 'react';
import { StyleSheet, Text, View, ScrollView, TouchableOpacity, SafeAreaView, TextInput } from 'react-native';
import { useRouter } from 'expo-router';
import { useAuth } from '@/lib/authContext';
import { useTheme } from '@/hooks/use-theme';
import { createTeacherClass, fetchMyTeacherSchoolId, ClassLevel } from '@/services/supabaseService';

const CLASS_LEVELS: ClassLevel[] = ['JSS1', 'JSS2', 'JSS3', 'SS1', 'SS2', 'SS3'];

export default function TeacherScreen() {
  const router = useRouter();
  const { user } = useAuth();
  const colors = useTheme();
  const styles = useMemo(() => createStyles(colors), [colors]);
  const [newClassName, setNewClassName] = useState('');
  const [newClassLevel, setNewClassLevel] = useState<ClassLevel>('SS2');
  const [classList, setClassList] = useState([
    { id: 'c1', name: 'SS2 Mathematics A', code: 'MATH-SS2A', count: 42, avg: 74 },
    { id: 'c2', name: 'SS2 Further Maths', code: 'FM-SS2B', count: 28, avg: 81 },
  ]);

  const [schoolId, setSchoolId] = useState<string | null>(null);
  const [schoolChecked, setSchoolChecked] = useState(false);

  useEffect(() => {
    if (!user?.id) return;
    fetchMyTeacherSchoolId(user.id).then((id) => {
      setSchoolId(id);
      setSchoolChecked(true);
    });
  }, [user?.id]);

  const handleCreate = async () => {
    if (!newClassName.trim()) return;

    // Server-side create_class RPC generates a collision-checked
    // join_code and stamps school_id — same reasoning as
    // mathora-web/src/lib/supabase.ts's createTeacherClassInSupabase.
    const created = user?.id ? await createTeacherClass(newClassName, newClassLevel) : null;

    if (created) {
      setClassList((prev) => [...prev, { id: created.id, name: created.name, code: created.code, count: 0, avg: 0 }]);
    } else {
      // Offline/unauthenticated fallback — local-only optimistic class.
      setClassList((prev) => [
        ...prev,
        {
          id: `c-${Date.now()}`,
          name: newClassName,
          code: `MATH-${Math.floor(1000 + Math.random() * 9000)}`,
          count: 0,
          avg: 0,
        },
      ]);
    }
    setNewClassName('');
  };

  return (
    <SafeAreaView style={styles.container}>
      <ScrollView contentContainerStyle={styles.scrollContent}>
        <TouchableOpacity style={styles.backBtn} onPress={() => router.back()}>
          <Text style={styles.backText}>← Back to Dashboard</Text>
        </TouchableOpacity>

        <View style={styles.header}>
          <Text style={styles.badge}>VERIFIED TEACHER PORTAL</Text>
          <Text style={styles.title}>Academic Ledger & Classes</Text>
          <Text style={styles.teacherName}>Mr. Olanrewaju Bello — Government Secondary School, Ikeja</Text>
        </View>

        {schoolChecked && !schoolId && (
          <TouchableOpacity style={styles.schoolPrompt} onPress={() => router.push('/school-search')}>
            <View style={{ flex: 1 }}>
              <Text style={styles.schoolPromptTitle}>Join or create your school</Text>
              <Text style={styles.schoolPromptBody}>
                Your classes aren&apos;t linked to a school yet — students can&apos;t find them by search until you do.
              </Text>
            </View>
            <Text style={styles.schoolPromptArrow}>→</Text>
          </TouchableOpacity>
        )}

        {/* Create Class Form */}
        <View style={styles.createCard}>
          <Text style={styles.cardHeaderTitle}>Create New Verified Class</Text>
          <TextInput
            style={styles.input}
            placeholder="Class Name (e.g. SS3 Mathematics A)"
            placeholderTextColor={colors.textMuted}
            value={newClassName}
            onChangeText={setNewClassName}
          />
          <View style={styles.levelRow}>
            {CLASS_LEVELS.map((lvl) => (
              <TouchableOpacity
                key={lvl}
                style={[styles.levelChip, newClassLevel === lvl && styles.levelChipActive]}
                onPress={() => setNewClassLevel(lvl)}
              >
                <Text style={[styles.levelChipText, newClassLevel === lvl && styles.levelChipTextActive]}>{lvl}</Text>
              </TouchableOpacity>
            ))}
          </View>
          <TouchableOpacity style={styles.createBtn} onPress={handleCreate}>
            <Text style={styles.createBtnText}>+ Generate Class & Join Code</Text>
          </TouchableOpacity>
        </View>

        <Text style={styles.sectionHeader}>Active Classes ({classList.length})</Text>

        {classList.map((item) => (
          <TouchableOpacity
            key={item.id}
            style={styles.classCard}
            onPress={() => router.push({ pathname: '/roster', params: { classId: item.id, className: item.name } })}
          >
            <View style={styles.classRow}>
              <Text style={styles.className}>{item.name}</Text>
              <Text style={styles.codeBadge}>JOIN CODE: {item.code}</Text>
            </View>
            <View style={styles.statsRow}>
              <Text style={styles.statText}>Students: {item.count}</Text>
              <Text style={styles.statTextMastery}>Avg Mastery: {item.avg}%</Text>
            </View>
            <Text style={styles.rosterLink}>Manage Roster & Join Requests →</Text>
          </TouchableOpacity>
        ))}
      </ScrollView>
    </SafeAreaView>
  );
}

function createStyles(colors: ReturnType<typeof useTheme>) {
  return StyleSheet.create({
    container: { flex: 1, backgroundColor: colors.background },
    scrollContent: { padding: 16 },
    backBtn: { marginBottom: 12 },
    backText: { color: colors.primary, fontSize: 14, fontWeight: 'bold' },
    header: { marginBottom: 16 },
    badge: { color: '#10B981', fontSize: 10, fontWeight: 'bold', letterSpacing: 1 },
    title: { color: colors.text, fontSize: 24, fontWeight: 'bold', marginTop: 2 },
    teacherName: { color: colors.textMuted, fontSize: 12, marginTop: 4 },
    schoolPrompt: {
      flexDirection: 'row',
      alignItems: 'center',
      backgroundColor: colors.warningSurface,
      borderColor: colors.warningBorder,
      borderWidth: 1,
      borderRadius: 14,
      padding: 14,
      marginBottom: 16,
    },
    schoolPromptTitle: { color: colors.warningText, fontSize: 13, fontWeight: 'bold' },
    schoolPromptBody: { color: colors.textMuted, fontSize: 11, marginTop: 2 },
    schoolPromptArrow: { color: colors.warningText, fontSize: 18, marginLeft: 10 },
    createCard: {
      backgroundColor: colors.successSurface,
      borderColor: colors.successBorder,
      borderWidth: 1,
      borderRadius: 16,
      padding: 16,
      marginBottom: 20,
    },
    cardHeaderTitle: { color: colors.successText, fontSize: 14, fontWeight: 'bold', marginBottom: 10 },
    input: {
      backgroundColor: colors.surface,
      borderColor: colors.border,
      borderWidth: 1,
      borderRadius: 8,
      padding: 12,
      color: colors.text,
      fontSize: 14,
      marginBottom: 12,
    },
    levelRow: { flexDirection: 'row', flexWrap: 'wrap', gap: 8, marginBottom: 12 },
    levelChip: {
      borderColor: colors.border,
      borderWidth: 1,
      borderRadius: 999,
      paddingHorizontal: 12,
      paddingVertical: 6,
    },
    levelChipActive: { backgroundColor: '#10B981', borderColor: '#10B981' },
    levelChipText: { color: colors.textMuted, fontSize: 11, fontWeight: 'bold' },
    levelChipTextActive: { color: '#052E1D' },
    createBtn: { backgroundColor: '#10B981', borderRadius: 8, padding: 12, alignItems: 'center' },
    createBtnText: { color: '#FFFFFF', fontSize: 14, fontWeight: 'bold' },
    sectionHeader: { color: colors.text, fontSize: 16, fontWeight: 'bold', marginBottom: 12 },
    classCard: {
      backgroundColor: colors.surface,
      borderColor: colors.border,
      borderWidth: 1,
      borderRadius: 12,
      padding: 14,
      marginBottom: 10,
    },
    classRow: { flexDirection: 'row', justifyContent: 'space-between', alignItems: 'center' },
    className: { color: colors.text, fontSize: 15, fontWeight: 'bold' },
    codeBadge: { backgroundColor: colors.surfaceSecondary, color: '#10B981', fontSize: 10, fontWeight: 'bold', paddingHorizontal: 8, paddingVertical: 2, borderRadius: 4 },
    statsRow: { flexDirection: 'row', justifyContent: 'space-between', marginTop: 10 },
    statText: { color: colors.textMuted, fontSize: 12 },
    statTextMastery: { color: '#10B981', fontSize: 12, fontWeight: 'bold' },
    rosterLink: { color: colors.warningText, fontSize: 11, fontWeight: 'bold', marginTop: 10 },
  });
}
