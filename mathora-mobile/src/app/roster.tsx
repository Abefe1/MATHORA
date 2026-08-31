import React, { useCallback, useEffect, useMemo, useState } from 'react';
import { StyleSheet, Text, View, ScrollView, TouchableOpacity, SafeAreaView, TextInput, Alert } from 'react-native';
import { useRouter, useLocalSearchParams } from 'expo-router';
import * as DocumentPicker from 'expo-document-picker';
import { File } from 'expo-file-system';
import Papa from 'papaparse';
import { useTheme } from '@/hooks/use-theme';
import {
  bulkAddRosterEntries,
  fetchClassRoster,
  fetchPendingJoinRequests,
  decideJoinRequest,
  ClassRosterEntry,
  ClassJoinRequest,
} from '@/services/supabaseService';

type ParsedRow = { full_name: string; verification_value?: string };

const NAME_HEADERS = ['full_name', 'name', 'student name', 'student_name'];
const VERIFICATION_HEADERS = ['verification_value', 'phone', 'phone number', 'admission_no', 'admission no', 'admission number', 'id'];

function normalizeRows(rows: Record<string, unknown>[]): ParsedRow[] {
  return rows
    .map((row) => {
      const keys = Object.keys(row);
      const nameKey = keys.find((k) => NAME_HEADERS.includes(k.trim().toLowerCase()));
      const verifyKey = keys.find((k) => VERIFICATION_HEADERS.includes(k.trim().toLowerCase()));
      const full_name = nameKey ? String(row[nameKey] ?? '').trim() : '';
      const verification_value = verifyKey ? String(row[verifyKey] ?? '').trim() : '';
      return { full_name, verification_value: verification_value || undefined };
    })
    .filter((r) => r.full_name.length > 0);
}

export default function RosterScreen() {
  const router = useRouter();
  const colors = useTheme();
  const styles = useMemo(() => createStyles(colors), [colors]);
  const { classId, className } = useLocalSearchParams<{ classId: string; className?: string }>();

  const [roster, setRoster] = useState<ClassRosterEntry[]>([]);
  const [requests, setRequests] = useState<ClassJoinRequest[]>([]);
  const [loading, setLoading] = useState(false);
  const [busy, setBusy] = useState(false);

  const [manualName, setManualName] = useState('');
  const [manualVerify, setManualVerify] = useState('');

  const [filePreview, setFilePreview] = useState<ParsedRow[]>([]);

  const load = useCallback(async () => {
    if (!classId) return;
    setLoading(true);
    const [rosterData, requestData] = await Promise.all([
      fetchClassRoster(classId),
      fetchPendingJoinRequests(classId),
    ]);
    setRoster(rosterData);
    setRequests(requestData);
    setLoading(false);
  }, [classId]);

  useEffect(() => {
    // Standard "load on mount/param change" effect — same justified
    // suppression used for this pattern elsewhere in the app (see
    // mathora-web's useOfflineFlush.ts / admin/page.tsx).
    // eslint-disable-next-line react-hooks/set-state-in-effect
    load();
  }, [load]);

  const handleManualAdd = async () => {
    if (!manualName.trim() || !classId) return;
    setBusy(true);
    await bulkAddRosterEntries(classId, [{ full_name: manualName.trim(), verification_value: manualVerify.trim() || undefined }]);
    setManualName('');
    setManualVerify('');
    setBusy(false);
    load();
  };

  const handlePickFile = async () => {
    const result = await DocumentPicker.getDocumentAsync({
      type: ['text/csv', 'text/comma-separated-values', 'application/vnd.ms-excel', 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet'],
      copyToCacheDirectory: true,
    });
    if (result.canceled || !result.assets?.[0]) return;

    const asset = result.assets[0];
    try {
      const buffer = await new File(asset.uri).arrayBuffer();
      const isCsv = asset.name.toLowerCase().endsWith('.csv');

      if (isCsv) {
        const text = new TextDecoder().decode(buffer);
        const parsed = Papa.parse(text, { header: true, skipEmptyLines: true });
        const rows = normalizeRows(parsed.data as Record<string, unknown>[]);
        if (rows.length === 0) {
          Alert.alert('No valid rows', 'Make sure a name column is present.');
          return;
        }
        setFilePreview(rows);
      } else {
        const XLSX = await import('xlsx');
        const workbook = XLSX.read(buffer, { type: 'array' });
        const firstSheet = workbook.Sheets[workbook.SheetNames[0]];
        const rows = normalizeRows(XLSX.utils.sheet_to_json(firstSheet) as Record<string, unknown>[]);
        if (rows.length === 0) {
          Alert.alert('No valid rows', 'Make sure a name column is present.');
          return;
        }
        setFilePreview(rows);
      }
    } catch {
      Alert.alert('Could not read file', 'Please check the file and try again.');
    }
  };

  const confirmFileImport = async () => {
    if (filePreview.length === 0 || !classId) return;
    setBusy(true);
    await bulkAddRosterEntries(classId, filePreview);
    setFilePreview([]);
    setBusy(false);
    load();
  };

  const handleDecide = async (requestId: string, approve: boolean) => {
    setBusy(true);
    await decideJoinRequest(requestId, approve);
    setBusy(false);
    load();
  };

  return (
    <SafeAreaView style={styles.container}>
      <ScrollView contentContainerStyle={styles.scrollContent}>
        <TouchableOpacity style={styles.backBtn} onPress={() => router.back()}>
          <Text style={styles.backText}>← Back to Dashboard</Text>
        </TouchableOpacity>

        <Text style={styles.badge}>ROSTER MANAGEMENT</Text>
        <Text style={styles.title}>{className ?? 'Class Roster'}</Text>

        {requests.length > 0 && (
          <View style={styles.card}>
            <Text style={styles.cardTitle}>Pending Join Requests ({requests.length})</Text>
            {requests.map((r) => (
              <View key={r.id} style={styles.requestRow}>
                <View style={{ flex: 1 }}>
                  <Text style={styles.requestText}>Student: {r.student_id}</Text>
                  {r.verification_value && <Text style={styles.mutedText}>Supplied: {r.verification_value}</Text>}
                </View>
                <View style={{ flexDirection: 'row', gap: 8 }}>
                  <TouchableOpacity style={styles.approveBtn} onPress={() => handleDecide(r.id, true)} disabled={busy}>
                    <Text style={styles.approveBtnText}>✓</Text>
                  </TouchableOpacity>
                  <TouchableOpacity style={styles.rejectBtn} onPress={() => handleDecide(r.id, false)} disabled={busy}>
                    <Text style={styles.rejectBtnText}>✕</Text>
                  </TouchableOpacity>
                </View>
              </View>
            ))}
          </View>
        )}

        <View style={styles.card}>
          <Text style={styles.cardTitle}>Add One Student</Text>
          <TextInput
            style={styles.input}
            placeholder="Full name"
            placeholderTextColor={colors.textMuted}
            value={manualName}
            onChangeText={setManualName}
          />
          <TextInput
            style={styles.input}
            placeholder="Phone or admission no. (optional)"
            placeholderTextColor={colors.textMuted}
            value={manualVerify}
            onChangeText={setManualVerify}
          />
          <TouchableOpacity style={styles.primaryBtn} onPress={handleManualAdd} disabled={busy}>
            <Text style={styles.primaryBtnText}>Add to Roster</Text>
          </TouchableOpacity>
        </View>

        <View style={styles.card}>
          <Text style={styles.cardTitle}>Bulk Upload (CSV or Excel)</Text>
          <Text style={styles.mutedText}>
            Needs a name column. A phone or admission-number column is optional but recommended for identity verification.
          </Text>
          <TouchableOpacity style={styles.outlineBtn} onPress={handlePickFile}>
            <Text style={styles.outlineBtnText}>Pick File</Text>
          </TouchableOpacity>
          {filePreview.length > 0 && (
            <>
              <Text style={styles.successText}>{filePreview.length} row(s) ready to import</Text>
              <TouchableOpacity style={styles.primaryBtn} onPress={confirmFileImport} disabled={busy}>
                <Text style={styles.primaryBtnText}>Confirm Import</Text>
              </TouchableOpacity>
            </>
          )}
        </View>

        <View style={styles.card}>
          <Text style={styles.cardTitle}>Roster ({roster.length})</Text>
          {loading && <Text style={styles.mutedText}>Loading...</Text>}
          {!loading && roster.length === 0 && <Text style={styles.mutedText}>No students added yet.</Text>}
          {roster.map((entry) => (
            <View key={entry.id} style={styles.rosterRow}>
              <Text style={styles.rosterName}>{entry.full_name}</Text>
              <Text style={[styles.rosterStatus, entry.claimed_by_student_id ? styles.claimed : styles.unclaimed]}>
                {entry.claimed_by_student_id ? 'Claimed' : 'Unclaimed'}
              </Text>
            </View>
          ))}
        </View>
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
    title: { color: colors.text, fontSize: 22, fontWeight: 'bold', marginTop: 4, marginBottom: 16 },
    card: { backgroundColor: colors.surface, borderColor: colors.border, borderWidth: 1, borderRadius: 16, padding: 16, marginBottom: 16 },
    cardTitle: { color: colors.text, fontSize: 14, fontWeight: 'bold', marginBottom: 10 },
    input: {
      backgroundColor: colors.background, borderColor: colors.border, borderWidth: 1, borderRadius: 8,
      padding: 12, color: colors.text, fontSize: 14, marginBottom: 10,
    },
    primaryBtn: { backgroundColor: '#F59E0B', borderRadius: 8, padding: 12, alignItems: 'center', marginTop: 4 },
    primaryBtnText: { color: '#090D16', fontSize: 13, fontWeight: 'bold' },
    outlineBtn: { borderColor: '#F59E0B', borderWidth: 1, borderRadius: 8, padding: 12, alignItems: 'center' },
    outlineBtnText: { color: '#F59E0B', fontSize: 13, fontWeight: 'bold' },
    mutedText: { color: colors.textMuted, fontSize: 11, marginBottom: 6 },
    successText: { color: colors.successText, fontSize: 12, marginTop: 10, marginBottom: 6 },
    requestRow: {
      flexDirection: 'row', alignItems: 'center', justifyContent: 'space-between',
      backgroundColor: colors.background, borderColor: colors.border, borderWidth: 1, borderRadius: 10, padding: 10, marginBottom: 8,
    },
    requestText: { color: colors.text, fontSize: 12 },
    approveBtn: { backgroundColor: '#10B981', borderRadius: 6, paddingHorizontal: 12, paddingVertical: 6 },
    approveBtnText: { color: '#FFFFFF', fontWeight: 'bold' },
    rejectBtn: { backgroundColor: '#EF4444', borderRadius: 6, paddingHorizontal: 12, paddingVertical: 6 },
    rejectBtnText: { color: '#FFFFFF', fontWeight: 'bold' },
    rosterRow: { flexDirection: 'row', justifyContent: 'space-between', alignItems: 'center', paddingVertical: 8, borderBottomColor: colors.border, borderBottomWidth: 1 },
    rosterName: { color: colors.text, fontSize: 13 },
    rosterStatus: { fontSize: 10, fontWeight: 'bold', paddingHorizontal: 8, paddingVertical: 2, borderRadius: 999, overflow: 'hidden' },
    claimed: { backgroundColor: colors.successSurface, color: colors.successText },
    unclaimed: { backgroundColor: colors.surfaceSecondary, color: colors.textMuted },
  });
}
