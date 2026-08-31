import React, { useMemo, useState } from 'react';
import { StyleSheet, Text, View, ScrollView, TouchableOpacity, SafeAreaView, TextInput } from 'react-native';
import { useRouter } from 'expo-router';
import { useAuth } from '@/lib/authContext';
import { useTheme } from '@/hooks/use-theme';
import { searchSchools, createOrSuggestSchool, joinSchool, School } from '@/services/supabaseService';

const NIGERIAN_STATES = ['Lagos', 'Ogun', 'Oyo', 'Rivers', 'Kano', 'Kaduna', 'FCT', 'Enugu', 'Anambra', 'Delta', 'Edo', 'Other'];

export default function SchoolSearchScreen() {
  const router = useRouter();
  const { user } = useAuth();
  const colors = useTheme();
  const styles = useMemo(() => createStyles(colors), [colors]);
  const [step, setStep] = useState<1 | 2 | 3>(1);
  const [query, setQuery] = useState('');
  const [results, setResults] = useState<School[]>([]);
  const [searched, setSearched] = useState(false);
  const [busy, setBusy] = useState(false);
  const [error, setError] = useState<string | null>(null);

  const [newName, setNewName] = useState('');
  const [newState, setNewState] = useState('Lagos');

  const [outcome, setOutcome] = useState<School | null>(null);

  const handleSearch = async () => {
    if (!query.trim()) return;
    setBusy(true);
    setResults(await searchSchools(query.trim()));
    setSearched(true);
    setBusy(false);
  };

  const handleJoin = async (school: School) => {
    if (!user?.id) return;
    setBusy(true);
    const ok = await joinSchool(school.id);
    setBusy(false);
    if (ok) {
      setOutcome(school);
      setStep(3);
    } else {
      setError('Could not join that school — try again.');
    }
  };

  const handleCreate = async () => {
    if (!newName.trim() || !user?.id) return;
    setBusy(true);
    setError(null);
    try {
      const school = await createOrSuggestSchool(newName.trim(), newState);
      if (school.status === 'active') await joinSchool(school.id);
      setOutcome(school);
      setStep(3);
    } catch (err) {
      setError(err instanceof Error ? err.message : 'Could not create that school.');
    } finally {
      setBusy(false);
    }
  };

  return (
    <SafeAreaView style={styles.container}>
      <ScrollView contentContainerStyle={styles.scrollContent}>
        <TouchableOpacity style={styles.backBtn} onPress={() => router.back()}>
          <Text style={styles.backText}>← Back to Dashboard</Text>
        </TouchableOpacity>

        <Text style={styles.badge}>FIND OR ADD YOUR SCHOOL</Text>
        <Text style={styles.title}>Join Your School</Text>
        <Text style={styles.subtitle}>Linking your school lets students find and request to join your classes</Text>

        {step === 1 && (
          <View style={styles.card}>
            <Text style={styles.cardTitle}>Search for your school</Text>
            <TextInput
              style={styles.input}
              placeholder="e.g. Maryland Comprehensive High School"
              placeholderTextColor={colors.textMuted}
              value={query}
              onChangeText={setQuery}
            />
            <TouchableOpacity style={styles.primaryBtn} onPress={handleSearch}>
              <Text style={styles.primaryBtnText}>{busy ? 'Searching...' : 'Search'}</Text>
            </TouchableOpacity>

            {searched && (
              <View style={{ marginTop: 16 }}>
                {results.length === 0 && <Text style={styles.mutedText}>No matching school found.</Text>}
                {results.map((s) => (
                  <View key={s.id} style={styles.resultRow}>
                    <View style={{ flex: 1 }}>
                      <Text style={styles.resultName}>{s.name}{s.verified ? '  ✓' : ''}</Text>
                      <Text style={styles.resultState}>{s.state}</Text>
                    </View>
                    <TouchableOpacity style={styles.outlineBtn} onPress={() => handleJoin(s)}>
                      <Text style={styles.outlineBtnText}>Join</Text>
                    </TouchableOpacity>
                  </View>
                ))}
                <TouchableOpacity onPress={() => setStep(2)} style={{ marginTop: 12 }}>
                  <Text style={styles.linkText}>Can&apos;t find it? Add your school instead</Text>
                </TouchableOpacity>
              </View>
            )}
          </View>
        )}

        {step === 2 && (
          <View style={styles.card}>
            <Text style={styles.cardTitle}>Add your school</Text>
            <Text style={styles.mutedText}>
              If self-serve creation is currently off, this is submitted for admin review instead of going live immediately.
            </Text>
            <TextInput
              style={styles.input}
              placeholder="School name"
              placeholderTextColor={colors.textMuted}
              value={newName}
              onChangeText={setNewName}
            />
            <View style={styles.stateRow}>
              {NIGERIAN_STATES.map((st) => (
                <TouchableOpacity
                  key={st}
                  style={[styles.stateChip, newState === st && styles.stateChipActive]}
                  onPress={() => setNewState(st)}
                >
                  <Text style={[styles.stateChipText, newState === st && styles.stateChipTextActive]}>{st}</Text>
                </TouchableOpacity>
              ))}
            </View>
            {error && <Text style={styles.errorText}>{error}</Text>}
            <TouchableOpacity style={styles.primaryBtn} onPress={handleCreate}>
              <Text style={styles.primaryBtnText}>{busy ? 'Submitting...' : 'Add School'}</Text>
            </TouchableOpacity>
            <TouchableOpacity onPress={() => setStep(1)} style={{ marginTop: 10, alignItems: 'center' }}>
              <Text style={styles.linkText}>Back</Text>
            </TouchableOpacity>
          </View>
        )}

        {step === 3 && outcome && (
          <View style={styles.card}>
            <Text style={styles.emoji}>{outcome.status === 'active' ? '✅' : '⏳'}</Text>
            <Text style={styles.outcomeTitle}>
              {outcome.status === 'active' ? `You're linked to ${outcome.name}` : 'Suggestion submitted'}
            </Text>
            <Text style={styles.mutedText}>
              {outcome.status === 'active'
                ? 'Classes you create will now be discoverable by students searching for this school.'
                : `${outcome.name} is awaiting admin review. You'll be able to join it automatically once approved.`}
            </Text>
            <TouchableOpacity style={styles.primaryBtn} onPress={() => router.replace('/teacher')}>
              <Text style={styles.primaryBtnText}>Back to Dashboard</Text>
            </TouchableOpacity>
          </View>
        )}
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
    badge: { color: '#F59E0B', fontSize: 10, fontWeight: 'bold', letterSpacing: 1 },
    title: { color: colors.text, fontSize: 24, fontWeight: 'bold', marginTop: 4 },
    subtitle: { color: colors.textMuted, fontSize: 12, marginTop: 4, marginBottom: 20 },
    card: { backgroundColor: colors.surface, borderColor: colors.border, borderWidth: 1, borderRadius: 16, padding: 16 },
    cardTitle: { color: colors.text, fontSize: 15, fontWeight: 'bold', marginBottom: 10 },
    input: {
      backgroundColor: colors.background, borderColor: colors.border, borderWidth: 1, borderRadius: 8,
      padding: 12, color: colors.text, fontSize: 14, marginBottom: 12,
    },
    primaryBtn: { backgroundColor: '#F59E0B', borderRadius: 8, padding: 12, alignItems: 'center' },
    primaryBtnText: { color: '#090D16', fontSize: 14, fontWeight: 'bold' },
    outlineBtn: { borderColor: '#F59E0B', borderWidth: 1, borderRadius: 8, paddingHorizontal: 14, paddingVertical: 8 },
    outlineBtnText: { color: '#F59E0B', fontSize: 12, fontWeight: 'bold' },
    resultRow: {
      flexDirection: 'row', alignItems: 'center', justifyContent: 'space-between',
      backgroundColor: colors.background, borderColor: colors.border, borderWidth: 1, borderRadius: 12,
      padding: 12, marginBottom: 8,
    },
    resultName: { color: colors.text, fontSize: 13, fontWeight: 'bold' },
    resultState: { color: colors.textMuted, fontSize: 11, marginTop: 2 },
    mutedText: { color: colors.textMuted, fontSize: 11, marginBottom: 10 },
    linkText: { color: '#F59E0B', fontSize: 12, fontWeight: 'bold', textAlign: 'center' },
    stateRow: { flexDirection: 'row', flexWrap: 'wrap', gap: 8, marginBottom: 12 },
    stateChip: { borderColor: colors.border, borderWidth: 1, borderRadius: 999, paddingHorizontal: 12, paddingVertical: 6 },
    stateChipActive: { backgroundColor: '#F59E0B', borderColor: '#F59E0B' },
    stateChipText: { color: colors.textMuted, fontSize: 11, fontWeight: 'bold' },
    stateChipTextActive: { color: '#090D16' },
    errorText: { color: colors.dangerText, fontSize: 12, marginBottom: 10 },
    emoji: { fontSize: 40, textAlign: 'center', marginBottom: 8 },
    outcomeTitle: { color: colors.text, fontSize: 17, fontWeight: 'bold', textAlign: 'center', marginBottom: 8 },
  });
}
