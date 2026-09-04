'use client';

import React, { useCallback, useEffect, useState } from 'react';
import Link from 'next/link';
import { useParams } from 'next/navigation';
import Navbar from '@/components/Navbar';
import { Card, Badge, Button } from '@/components/ui/Primitives';
import { ArrowLeft, ClipboardList, Plus, Clock, CalendarClock } from 'lucide-react';

import { createClient } from '@/lib/supabase/client';

type AssignmentListRow = {
  id: string;
  title: string;
  due_date: string;
  duration_minutes: number | null;
  question_count: number;
  topic_title: string;
};

export default function ClassAssignmentsPage() {
  const params = useParams();
  const classId = params.classId as string;

  const [assignments, setAssignments] = useState<AssignmentListRow[]>([]);
  const [loading, setLoading] = useState(true);

  const load = useCallback(async () => {
    if (!classId) return;
    const supabase = createClient();
    if (!supabase) {
      setLoading(false);
      return;
    }
    setLoading(true);
    const { data } = await supabase
      .from('assignments')
      .select('id, title, due_date, duration_minutes, question_count, topics(title)')
      .eq('class_id', classId)
      .order('due_date', { ascending: false });

    setAssignments(
      // eslint-disable-next-line @typescript-eslint/no-explicit-any
      (data ?? []).map((a: any) => ({
        id: a.id,
        title: a.title,
        due_date: a.due_date,
        duration_minutes: a.duration_minutes ?? null,
        question_count: a.question_count ?? 0,
        topic_title: a.topics?.title ?? '',
      }))
    );
    setLoading(false);
  }, [classId]);

  useEffect(() => {
    // Load-on-mount — same justified suppression as admin/page.tsx's
    // loadAuthoredContent.
    // eslint-disable-next-line react-hooks/set-state-in-effect
    load();
  }, [load]);

  return (
    <div className="min-h-screen bg-slate-50 dark:bg-slate-950 text-slate-900 dark:text-slate-100 flex flex-col font-sans">
      <Navbar currentRole="teacher" userName="Mr. Olanrewaju Bello" />

      <main className="max-w-5xl mx-auto px-4 sm:px-6 lg:px-8 py-8 w-full">
        <Link
          href="/teacher"
          className="inline-flex items-center gap-1.5 text-xs font-mono text-amber-600 dark:text-amber-400 hover:underline mb-4"
        >
          <ArrowLeft className="w-3.5 h-3.5" /> Back to Dashboard
        </Link>

        <div className="flex items-center justify-between gap-4 mb-6">
          <div>
            <Badge variant="mastered">Assignments</Badge>
            <h1 className="text-2xl sm:text-3xl font-display font-extrabold text-slate-900 dark:text-white mt-1">
              Class Assignments
            </h1>
          </div>
          <Link href={`/teacher/class/${classId}/assignments/new`}>
            <Button variant="chalk" size="md" className="font-display">
              <Plus className="w-4 h-4" /> New Assignment
            </Button>
          </Link>
        </div>

        {loading && <p className="text-sm text-slate-500 dark:text-slate-400">Loading assignments...</p>}
        {!loading && assignments.length === 0 && (
          <Card variant="paper" className="p-6 text-center">
            <p className="text-sm text-slate-600 dark:text-slate-400">
              No assignments yet — create one to give this class scored, timed work.
            </p>
          </Card>
        )}

        <div className="space-y-3">
          {assignments.map((a) => (
            <Link key={a.id} href={`/teacher/class/${classId}/assignments/${a.id}`}>
              <Card variant="paper" className="p-4 sm:p-5 hover:border-emerald-500/60 transition-all">
                <div className="flex items-start justify-between gap-4">
                  <div className="min-w-0">
                    <h2 className="text-sm font-display font-bold text-slate-900 dark:text-white truncate">{a.title}</h2>
                    <p className="text-xs text-slate-500 dark:text-slate-400 mt-0.5">
                      {a.topic_title} · {a.question_count} question{a.question_count === 1 ? '' : 's'}
                    </p>
                  </div>
                  <div className="flex flex-col items-end gap-1 flex-none font-mono text-[11px] text-slate-500 dark:text-slate-400">
                    <span className="flex items-center gap-1">
                      <CalendarClock className="w-3.5 h-3.5" /> Due {new Date(a.due_date).toLocaleString()}
                    </span>
                    <span className="flex items-center gap-1">
                      <Clock className="w-3.5 h-3.5" />
                      {a.duration_minutes ? `${a.duration_minutes} min` : 'Untimed'}
                    </span>
                  </div>
                </div>
              </Card>
            </Link>
          ))}
        </div>

        {assignments.length > 0 && (
          <p className="text-[11px] text-slate-400 dark:text-slate-500 mt-4 flex items-center gap-1.5">
            <ClipboardList className="w-3.5 h-3.5" /> Click an assignment to see submissions and focus-loss flags.
          </p>
        )}
      </main>
    </div>
  );
}
