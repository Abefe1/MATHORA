'use client';

import React, { useCallback, useEffect, useState } from 'react';
import Link from 'next/link';
import { useParams } from 'next/navigation';
import Papa from 'papaparse';
import Navbar from '@/components/Navbar';
import { Card, Badge, Button } from '@/components/ui/Primitives';
import { ArrowLeft, UserPlus, Upload, Users, Inbox, Check, X } from 'lucide-react';

import { bulkAddRosterEntries, fetchClassRoster, fetchPendingJoinRequests, decideJoinRequest } from '@/lib/supabase';
import type { ClassRosterEntry, ClassJoinRequest } from '@/lib/types';

type ParsedRow = { full_name: string; verification_value?: string };

// Accepts a loose set of header spellings for both columns so a
// teacher's own CSV export (whatever their SIS/spreadsheet calls the
// columns) is more likely to just work without a strict template.
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

export default function ClassRosterPage() {
  const params = useParams();
  const classId = params.classId as string;

  const [roster, setRoster] = useState<ClassRosterEntry[]>([]);
  const [requests, setRequests] = useState<ClassJoinRequest[]>([]);
  const [loading, setLoading] = useState(false);

  const [manualName, setManualName] = useState('');
  const [manualVerify, setManualVerify] = useState('');
  const [busy, setBusy] = useState(false);

  const [filePreview, setFilePreview] = useState<ParsedRow[]>([]);
  const [fileError, setFileError] = useState<string | null>(null);

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
    // eslint-disable-next-line react-hooks/set-state-in-effect
    load();
  }, [load]);

  const handleManualAdd = async (e: React.FormEvent) => {
    e.preventDefault();
    if (!manualName.trim()) return;
    setBusy(true);
    await bulkAddRosterEntries(classId, [{ full_name: manualName.trim(), verification_value: manualVerify.trim() || undefined }]);
    setManualName('');
    setManualVerify('');
    setBusy(false);
    load();
  };

  const handleFile = (e: React.ChangeEvent<HTMLInputElement>) => {
    const file = e.target.files?.[0];
    setFileError(null);
    setFilePreview([]);
    if (!file) return;

    const isCsv = file.name.toLowerCase().endsWith('.csv');

    if (isCsv) {
      Papa.parse(file, {
        header: true,
        skipEmptyLines: true,
        complete: (results) => {
          const rows = normalizeRows(results.data as Record<string, unknown>[]);
          if (rows.length === 0) setFileError('No valid rows found — make sure a name column is present.');
          setFilePreview(rows);
        },
        error: () => setFileError('Could not read that CSV file.'),
      });
      return;
    }

    // .xlsx / .xls — parsed with the SheetJS build installed from
    // cdn.sheetjs.com (NOT the npm registry's "xlsx" package, which
    // carries an unpatched high-severity vulnerability).
    file.arrayBuffer().then(async (buf) => {
      try {
        const XLSX = await import('xlsx');
        const workbook = XLSX.read(buf, { type: 'array' });
        const firstSheet = workbook.Sheets[workbook.SheetNames[0]];
        const rows = normalizeRows(XLSX.utils.sheet_to_json(firstSheet) as Record<string, unknown>[]);
        if (rows.length === 0) setFileError('No valid rows found — make sure a name column is present.');
        setFilePreview(rows);
      } catch {
        setFileError('Could not read that spreadsheet file.');
      }
    });
  };

  const confirmFileImport = async () => {
    if (filePreview.length === 0) return;
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
    <div className="min-h-screen bg-slate-50 dark:bg-slate-950 text-slate-900 dark:text-slate-100 flex flex-col font-sans selection:bg-amber-500 selection:text-slate-950">
      <Navbar currentRole="teacher" userName="Mr. Olanrewaju Bello" />

      <main className="max-w-4xl mx-auto px-4 sm:px-6 lg:px-8 py-8 w-full flex-grow">
        <Link href="/teacher" className="inline-flex items-center gap-1.5 text-xs font-mono text-amber-600 dark:text-amber-400 hover:underline mb-4">
          <ArrowLeft className="w-3.5 h-3.5" /> Return to Teacher Dashboard
        </Link>
        <div className="flex items-center justify-between gap-4 mb-8 flex-wrap">
          <div>
            <div className="flex justify-center mb-2 sm:justify-start">
              <Badge variant="bece">Roster Management</Badge>
            </div>
            <h1 className="text-2xl sm:text-3xl font-display font-extrabold text-slate-900 dark:text-white">
              Class Roster
            </h1>
          </div>
          <Link
            href={`/teacher/class/${classId}/scores`}
            className="px-4 py-2 rounded-xl bg-indigo-600 hover:bg-indigo-500 text-white font-bold text-xs shadow-md transition-colors"
          >
            View Class Scores
          </Link>
        </div>

        {/* Pending join requests */}
        {requests.length > 0 && (
          <Card variant="paper" className="p-6 mb-6">
            <h2 className="text-sm font-display font-bold text-slate-900 dark:text-white mb-4 flex items-center gap-2">
              <Inbox className="w-4 h-4 text-amber-600 dark:text-amber-400" /> Pending Join Requests ({requests.length})
            </h2>
            <div className="space-y-2 font-mono">
              {requests.map((r) => (
                <div key={r.id} className="flex items-center justify-between p-3 rounded-xl bg-white dark:bg-slate-900 border border-slate-200 dark:border-slate-800">
                  <div>
                    <p className="text-xs text-slate-600 dark:text-slate-300">Student ID: {r.student_id}</p>
                    {r.verification_value && (
                      <p className="text-[11px] text-slate-500">Supplied: {r.verification_value}</p>
                    )}
                  </div>
                  <div className="flex gap-2">
                    <button
                      onClick={() => handleDecide(r.id, true)}
                      disabled={busy}
                      className="p-2 rounded-lg bg-emerald-600 hover:bg-emerald-500 text-white"
                      title="Approve"
                    >
                      <Check className="w-4 h-4" />
                    </button>
                    <button
                      onClick={() => handleDecide(r.id, false)}
                      disabled={busy}
                      className="p-2 rounded-lg bg-rose-600 hover:bg-rose-500 text-white"
                      title="Reject"
                    >
                      <X className="w-4 h-4" />
                    </button>
                  </div>
                </div>
              ))}
            </div>
          </Card>
        )}

        {/* Manual add + bulk upload */}
        <div className="grid grid-cols-1 md:grid-cols-2 gap-6 mb-6">
          <Card variant="paper" className="p-6">
            <h2 className="text-sm font-display font-bold text-slate-900 dark:text-white mb-4 flex items-center gap-2">
              <UserPlus className="w-4 h-4 text-amber-600 dark:text-amber-400" /> Add One Student
            </h2>
            <form onSubmit={handleManualAdd} className="space-y-3 font-mono">
              <input
                type="text"
                placeholder="Full name"
                value={manualName}
                onChange={(e) => setManualName(e.target.value)}
                className="w-full bg-white dark:bg-slate-900 border border-slate-200 dark:border-slate-800 rounded-xl px-4 py-2.5 text-xs text-slate-900 dark:text-white placeholder-slate-500 focus:outline-none focus:border-amber-500"
                required
              />
              <input
                type="text"
                placeholder="Phone or admission no. (optional)"
                value={manualVerify}
                onChange={(e) => setManualVerify(e.target.value)}
                className="w-full bg-white dark:bg-slate-900 border border-slate-200 dark:border-slate-800 rounded-xl px-4 py-2.5 text-xs text-slate-900 dark:text-white placeholder-slate-500 focus:outline-none focus:border-amber-500"
              />
              <Button variant="primary" size="sm" type="submit" disabled={busy} className="w-full justify-center">
                Add to Roster
              </Button>
            </form>
          </Card>

          <Card variant="paper" className="p-6">
            <h2 className="text-sm font-display font-bold text-slate-900 dark:text-white mb-4 flex items-center gap-2">
              <Upload className="w-4 h-4 text-amber-600 dark:text-amber-400" /> Bulk Upload (CSV or Excel)
            </h2>
            <p className="text-[11px] text-slate-500 mb-3 font-mono">
              Needs a name column (e.g. &quot;Full Name&quot;). A phone or admission-number column is optional but recommended — it lets students verify their identity when claiming their row.
            </p>
            <input
              type="file"
              accept=".csv,.xlsx,.xls"
              onChange={handleFile}
              className="w-full text-xs text-slate-600 dark:text-slate-300 font-mono file:mr-3 file:py-2 file:px-3 file:rounded-lg file:border-0 file:bg-amber-500 file:text-slate-950 file:text-xs file:font-bold"
            />
            {fileError && <p className="text-xs text-rose-600 dark:text-rose-400 mt-2">{fileError}</p>}
            {filePreview.length > 0 && (
              <div className="mt-3">
                <p className="text-xs text-emerald-600 dark:text-emerald-400 font-mono mb-2">{filePreview.length} row(s) ready to import</p>
                <Button variant="chalk" size="sm" onClick={confirmFileImport} disabled={busy} className="w-full justify-center">
                  Confirm Import
                </Button>
              </div>
            )}
          </Card>
        </div>

        {/* Current roster */}
        <Card variant="paper" className="p-6">
          <h2 className="text-sm font-display font-bold text-slate-900 dark:text-white mb-4 flex items-center gap-2">
            <Users className="w-4 h-4 text-amber-600 dark:text-amber-400" /> Roster ({roster.length})
          </h2>
          {loading && <p className="text-xs text-slate-500 dark:text-slate-400">Loading...</p>}
          {!loading && roster.length === 0 && <p className="text-xs text-slate-500 dark:text-slate-400">No students added yet.</p>}
          <div className="divide-y divide-slate-200 dark:divide-slate-800 font-mono">
            {roster.map((entry) => (
              <div key={entry.id} className="flex items-center justify-between py-2.5">
                <span className="text-xs text-slate-800 dark:text-slate-200 font-sans">{entry.full_name}</span>
                <span className={`text-[10px] font-bold px-2 py-0.5 rounded-full ${
                  entry.claimed_by_student_id
                    ? 'bg-emerald-50 dark:bg-emerald-950 text-emerald-600 dark:text-emerald-400 border border-emerald-200 dark:border-emerald-800'
                    : 'bg-white dark:bg-slate-900 text-slate-500 dark:text-slate-400 border border-slate-200 dark:border-slate-800'
                }`}>
                  {entry.claimed_by_student_id ? 'Claimed' : 'Unclaimed'}
                </span>
              </div>
            ))}
          </div>
        </Card>
      </main>
    </div>
  );
}
