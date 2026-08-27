import React, { useState } from 'react';
import { StyleSheet, Text, View, ScrollView, TouchableOpacity, SafeAreaView, TextInput } from 'react-native';
import { useRouter } from 'expo-router';
import {
  searchSchools,
  fetchTeachersAtSchool,
  fetchClassDirectory,
  findOrRequestClassJoin,
  School,
  ClassDirectoryEntry,
  TeacherDirectoryEntry,
} from '@/services/supabaseService';

type Step = 1 | 2 | 3 | 4 | 5;

export default function FindClassScreen() {
  const router = useRouter();
  const [step, setStep] = useState<Step>(1);
  const [busy, setBusy] = useState(false);

  const [schoolQuery, setSchoolQuery] = useState('');
  const [schoolResults, setSchoolResults] = useState<School[]>([]);
  const [selectedSchool, setSelectedSchool] = useState<School | null>(null);

  const [teachers, setTeachers] = useState<TeacherDirectoryEntry[]>([]);
  const [selectedTeacher, setSelectedTeacher] = useState<TeacherDirectoryEntry | null>(null);

  const [classes, setClasses] = useState<ClassDirectoryEntry[]>([]);
  const [selectedClass, setSelectedClass] = useState<ClassDirectoryEntry | null>(null);

  const [verificationValue, setVerificationValue] = useState('');
  const [outcome, setOutcome] = useState<'joined' | 'already_member' | 'pending' | null>(null);

  const handleSchoolSearch = async () => {
    if (!schoolQuery.trim()) return;
    setBusy(true);
    setSchoolResults(await searchSchools(schoolQuery.trim()));
    setBusy(false);
  };

  const pickSchool = async (school: School) => {
    setSelectedSchool(school);
    setBusy(true);
    setTeachers(await fetchTeachersAtSchool(school.id));
    setBusy(false);
    setStep(2);
  };

  const pickTeacher = async (teacher: TeacherDirectoryEntry) => {
    setSelectedTeacher(teacher);
    setBusy(true);
    setClasses(await fetchClassDirectory(teacher.id));
    setBusy(false);
    setStep(3);
  };

  const pickClass = (cls: ClassDirectoryEntry) => {
    setSelectedClass(cls);
    setStep(4);
  };

  const handleJoinSubmit = async () => {
    if (!selectedClass) return;
    setBusy(true);
    const result = await findOrRequestClassJoin(selectedClass.id, verificationValue.trim() || undefined);
    setBusy(false);
    setOutcome(result?.status ?? null);
    setStep(5);
  };

  return (
    <SafeAreaView style={styles.container}>
      <ScrollView contentContainerStyle={styles.scrollContent}>
        <TouchableOpacity style={styles.backBtn} onPress={() => router.back()}>
          <Text style={styles.backText}>← Back to Dashboard</Text>
        </TouchableOpacity>

        <Text style={styles.badge}>FIND YOUR CLASS</Text>
        <Text style={styles.title}>Join a Class</Text>
        <Text style={styles.subtitle}>Search for your school, teacher, and class — no invite link needed</Text>

        {step === 1 && (
          <View style={styles.card}>
            <Text style={styles.cardTitle}>Step 1: Find your school</Text>
            <TextInput
              style={styles.input}
              placeholder="e.g. Maryland Comprehensive High School"
              placeholderTextColor="#64748B"
              value={schoolQuery}
              onChangeText={setSchoolQuery}
            />
            <TouchableOpacity style={styles.primaryBtn} onPress={handleSchoolSearch}>
              <Text style={styles.primaryBtnText}>{busy ? 'Searching...' : 'Search'}</Text>
            </TouchableOpacity>
            {schoolResults.map((s) => (
              <TouchableOpacity key={s.id} style={styles.resultRow} onPress={() => pickSchool(s)}>
                <View style={{ flex: 1 }}>
                  <Text style={styles.resultName}>{s.name}</Text>
                  <Text style={styles.mutedText}>{s.state}</Text>
                </View>
                <Text style={styles.arrow}>→</Text>
              </TouchableOpacity>
            ))}
          </View>
        )}

        {step === 2 && (
          <View style={styles.card}>
            <Text style={styles.cardTitle}>Step 2: Find your teacher</Text>
            <Text style={styles.mutedText}>at {selectedSchool?.name}</Text>
            {busy && <Text style={styles.mutedText}>Loading...</Text>}
            {!busy && teachers.length === 0 && <Text style={styles.mutedText}>No teachers found yet.</Text>}
            {teachers.map((t) => (
              <TouchableOpacity key={t.id} style={styles.resultRow} onPress={() => pickTeacher(t)}>
                <Text style={styles.resultName}>{t.full_name}</Text>
                <Text style={styles.arrow}>→</Text>
              </TouchableOpacity>
            ))}
            <TouchableOpacity onPress={() => setStep(1)} style={{ marginTop: 10 }}>
              <Text style={styles.linkText}>Back</Text>
            </TouchableOpacity>
          </View>
        )}

        {step === 3 && (
          <View style={styles.card}>
            <Text style={styles.cardTitle}>Step 3: Find your class</Text>
            <Text style={styles.mutedText}>taught by {selectedTeacher?.full_name}</Text>
            {busy && <Text style={styles.mutedText}>Loading...</Text>}
            {!busy && classes.length === 0 && <Text style={styles.mutedText}>No classes found yet.</Text>}
            {classes.map((c) => (
              <TouchableOpacity key={c.id} style={styles.resultRow} onPress={() => pickClass(c)}>
                <View style={{ flex: 1 }}>
                  <Text style={styles.resultName}>{c.name}</Text>
                  <Text style={styles.mutedText}>{c.class_level}</Text>
                </View>
                <Text style={styles.arrow}>→</Text>
              </TouchableOpacity>
            ))}
            <TouchableOpacity onPress={() => setStep(2)} style={{ marginTop: 10 }}>
              <Text style={styles.linkText}>Back</Text>
            </TouchableOpacity>
          </View>
        )}

        {step === 4 && (
          <View style={styles.card}>
            <Text style={styles.cardTitle}>Step 4: Confirm & join</Text>
            <Text style={styles.mutedText}>{selectedClass?.name}</Text>
            <TextInput
              style={styles.input}
              placeholder="Phone or admission no. (optional)"
              placeholderTextColor="#64748B"
              value={verificationValue}
              onChangeText={setVerificationValue}
            />
            <TouchableOpacity style={styles.primaryBtn} onPress={handleJoinSubmit}>
              <Text style={styles.primaryBtnText}>{busy ? 'Submitting...' : 'Join Class'}</Text>
            </TouchableOpacity>
            <TouchableOpacity onPress={() => setStep(3)} style={{ marginTop: 10 }}>
              <Text style={styles.linkText}>Back</Text>
            </TouchableOpacity>
          </View>
        )}

        {step === 5 && (
          <View style={styles.card}>
            {(outcome === 'joined' || outcome === 'already_member') && (
              <>
                <Text style={styles.emoji}>✅</Text>
                <Text style={styles.outcomeTitle}>{outcome === 'joined' ? "You're in!" : "You're already a member"}</Text>
                <Text style={styles.mutedText}>You&apos;ve joined {selectedClass?.name}.</Text>
              </>
            )}
            {outcome === 'pending' && (
              <>
                <Text style={styles.emoji}>⏳</Text>
                <Text style={styles.outcomeTitle}>Request sent</Text>
                <Text style={styles.mutedText}>
                  Your teacher needs to approve your request to join {selectedClass?.name}. You&apos;ll be added once they do.
                </Text>
              </>
            )}
            {outcome === null && (
              <>
                <Text style={styles.outcomeTitle}>Something went wrong</Text>
                <Text style={styles.mutedText}>Please try again.</Text>
              </>
            )}
            <TouchableOpacity style={styles.primaryBtn} onPress={() => router.replace('/')}>
              <Text style={styles.primaryBtnText}>Back to Dashboard</Text>
            </TouchableOpacity>
          </View>
        )}
      </ScrollView>
    </SafeAreaView>
  );
}

const styles = StyleSheet.create({
  container: { flex: 1, backgroundColor: '#090D16' },
  scrollContent: { padding: 16 },
  backBtn: { marginBottom: 12 },
  backText: { color: '#38BDF8', fontSize: 14, fontWeight: 'bold' },
  badge: { color: '#F59E0B', fontSize: 10, fontWeight: 'bold', letterSpacing: 1 },
  title: { color: '#FFFFFF', fontSize: 24, fontWeight: 'bold', marginTop: 4 },
  subtitle: { color: '#94A3B8', fontSize: 12, marginTop: 4, marginBottom: 20 },
  card: { backgroundColor: '#0F172A', borderColor: '#1E293B', borderWidth: 1, borderRadius: 16, padding: 16 },
  cardTitle: { color: '#FFFFFF', fontSize: 15, fontWeight: 'bold', marginBottom: 6 },
  input: {
    backgroundColor: '#090D16', borderColor: '#1E293B', borderWidth: 1, borderRadius: 8,
    padding: 12, color: '#FFFFFF', fontSize: 14, marginTop: 10, marginBottom: 12,
  },
  primaryBtn: { backgroundColor: '#F59E0B', borderRadius: 8, padding: 12, alignItems: 'center' },
  primaryBtnText: { color: '#090D16', fontSize: 14, fontWeight: 'bold' },
  resultRow: {
    flexDirection: 'row', alignItems: 'center', justifyContent: 'space-between',
    backgroundColor: '#090D16', borderColor: '#1E293B', borderWidth: 1, borderRadius: 12,
    padding: 12, marginTop: 10,
  },
  resultName: { color: '#FFFFFF', fontSize: 13, fontWeight: 'bold' },
  arrow: { color: '#64748B', fontSize: 16 },
  mutedText: { color: '#94A3B8', fontSize: 11, marginTop: 4 },
  linkText: { color: '#F59E0B', fontSize: 12, fontWeight: 'bold', textAlign: 'center' },
  emoji: { fontSize: 40, textAlign: 'center', marginBottom: 8 },
  outcomeTitle: { color: '#FFFFFF', fontSize: 17, fontWeight: 'bold', textAlign: 'center', marginBottom: 6 },
});
