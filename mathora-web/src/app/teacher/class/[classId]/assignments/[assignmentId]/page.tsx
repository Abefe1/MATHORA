'use client';

import React, { useCallback, useEffect, useState } from 'react';
import Link from 'next/link';
import { useParams } from 'next/navigation';
import Navbar from '@/components/Navbar';
import { Card, Badge } from '@/components/ui/Primitives';
import { ArrowLeft, Users, Trophy, AlertTriangle } from 'lucide-react';

import { fetchAssignmentSubmissions, type AssignmentSubmissionRow } from '@/lib/supabase';

function statusOf(row: AssignmentSubmissionRow): { label: string; tone: string } {
  if (row.completed) return { label: 'Completed', tone: 'bg-emerald-50 dark:bg-emerald-950/50 text-emerald-700 dark:text-emerald-300 border-emerald-200 dark:border-emerald-900/50' };
  if (row.started_at) return { label: 'In progress', tone: 'bg-amber-50 dark:bg-amber-950/50 text-amber-700 dark:text-amber-300 border-amber-200 dark:border-amber-900/50' };
  return { label: 'Not started', tone: 'bg-slate-100 dark:bg-slate-800 text-slate-500 border-slate-200 dark:border-slate-800' };
}

export default function AssignmentDetailPage() {
  const params = useParams();
  const classId = params.classId as string;
  const assignmentId = params.assignmentId as string;

  const [rows, setRows] = useState<AssignmentSubmissionRow[]>([]);
  const [loading, setLoading] = useState(true);

  const load = useCallback(async () => {
    if (!assignmentId || !classId) return;
    setLoading(true);
    const data = await fetchAssignmentSubmissions(assignmentId, classId);
    setRows(data);
    setLoading(false);
  }, [assignmentId, classId]);

  useEffect(() => {
    // Load-on-mount — same justified suppression as admin/page.tsx's
    // loadAuthoredContent.
    // eslint-disable-next-line react-hooks/set-state-in-effect
    load();
  }, [load]);

  const completed = rows.filter((r) => r.completed);
  const avgScore = completed.length ? Math.round(completed.reduce((s, r) => s + (r.score ?? 0), 0) / completed.length) : 0;
  const totalFlags = rows.reduce((s, r) => s + r.focus_loss_count, 0);

  return (
    <div className="min-h-screen bg-slate-50 dark:bg-slate-950 text-slate-900 dark:text-slate-100 flex flex-col font-sans">
      <Navbar currentRole="teacher" userName="Mr. Olanrewaju Bello" />

      <main className="max-w-4xl mx-auto px-4 sm:px-6 lg:px-8 py-8 w-full">
        <Link
          href={`/teacher/class/${classId}/assignments`}
          className="inline-flex items-center gap-1.5 text-xs font-mono text-amber-600 dark:text-amber-400 hover:underline mb-4"
        >
          <ArrowLeft className="w-3.5 h-3.5" /> Back to Assignments
        </Link>

        <div className="mb-6">
          <Badge variant="mastered">Submissions</Badge>
          <h1 className="text-2xl sm:text-3xl font-display font-extrabold text-slate-900 dark:text-white mt-1">
            Assignment Dashboard
          </h1>
        </div>

        <div className="grid grid-cols-3 gap-4 mb-6">
          <Card variant="paper" className="p-4 text-center">
            <Users className="w-4 h-4 text-indigo-600 dark:text-indigo-400 mx-auto mb-1.5" />
            <p className="text-xl font-extrabold text-slate-900 dark:text-white">{rows.length}</p>
            <p className="text-[10px] font-mono text-slate-500 dark:text-slate-400 uppercase">Students</p>
          </Card>
          <Card variant="paper" className="p-4 text-center">
            <Trophy className="w-4 h-4 text-amber-600 dark:text-amber-400 mx-auto mb-1.5" />
            <p className="text-xl font-extrabold text-slate-900 dark:text-white">{avgScore}%</p>
            <p className="text-[10px] font-mono text-slate-500 dark:text-slate-400 uppercase">Avg. Score ({completed.length} done)</p>
          </Card>
          <Card variant="paper" className="p-4 text-center">
            <AlertTriangle className={`w-4 h-4 mx-auto mb-1.5 ${totalFlags > 0 ? 'text-rose-600 dark:text-rose-400' : 'text-slate-400'}`} />
            <p className="text-xl font-extrabold text-slate-900 dark:text-white">{totalFlags}</p>
            <p className="text-[10px] font-mono text-slate-500 dark:text-slate-400 uppercase">Focus-Loss Flags</p>
          </Card>
        </div>

        <Card variant="paper" className="p-4 sm:p-6">
          {loading && <p className="text-sm text-slate-500 dark:text-slate-400">Loading submissions...</p>}
          {!loading && rows.length === 0 && (
            <p className="text-sm text-slate-500 dark:text-slate-400">No students in this class yet.</p>
          )}
          <div className="space-y-2">
            {rows.map((r) => {
              const status = statusOf(r);
              return (
                <div key={r.student_id} className="flex items-center gap-3 rounded-xl px-3 py-3 bg-slate-50 dark:bg-slate-900/60">
                  <div className="min-w-0 flex-1">
                    <p className="text-sm font-semibold text-slate-900 dark:text-white truncate">{r.full_name}</p>
                    {r.submitted_at && (
                      <p className="text-[11px] font-mono text-slate-500 dark:text-slate-400">
                        Submitted {new Date(r.submitted_at).toLocaleString()}
                      </p>
                    )}
                  </div>
                  {r.focus_loss_count > 0 && (
                    <span className="flex-none text-[10px] font-mono font-bold px-2 py-1 rounded-md bg-rose-50 dark:bg-rose-950/50 text-rose-700 dark:text-rose-300 border border-rose-200 dark:border-rose-900/50 flex items-center gap-1">
                      <AlertTriangle className="w-3 h-3" /> {r.focus_loss_count}
                    </span>
                  )}
                  <span className={`flex-none text-xs font-mono font-bold px-2.5 py-1 rounded-md border ${status.tone}`}>
                    {status.label}
                  </span>
                  {r.completed && (
                    <span className="flex-none text-xs font-mono font-bold px-2.5 py-1 rounded-md bg-indigo-50 dark:bg-indigo-950/50 text-indigo-700 dark:text-indigo-300">
                      {r.score}%
                    </span>
                  )}
                </div>
              );
            })}
          </div>
        </Card>
      </main>
    </div>
  );
}
