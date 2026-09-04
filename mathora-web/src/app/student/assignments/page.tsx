'use client';

import React, { useEffect, useState } from 'react';
import Link from 'next/link';
import Navbar from '@/components/Navbar';
import { Card, Badge } from '@/components/ui/Primitives';
import { ArrowLeft, Clock, CalendarClock, CheckCircle2, PlayCircle, AlertCircle } from 'lucide-react';

import { fetchMyAssignments, type StudentAssignmentRow } from '@/lib/supabase';

const STATUS_META: Record<StudentAssignmentRow['status'], { label: string; tone: string; icon: React.ReactNode }> = {
  not_started: {
    label: 'Not started',
    tone: 'bg-slate-100 dark:bg-slate-800 text-slate-500',
    icon: <PlayCircle className="w-3.5 h-3.5" />,
  },
  in_progress: {
    label: 'In progress',
    tone: 'bg-amber-50 dark:bg-amber-950/50 text-amber-700 dark:text-amber-300',
    icon: <Clock className="w-3.5 h-3.5" />,
  },
  completed: {
    label: 'Completed',
    tone: 'bg-emerald-50 dark:bg-emerald-950/50 text-emerald-700 dark:text-emerald-300',
    icon: <CheckCircle2 className="w-3.5 h-3.5" />,
  },
  missed: {
    label: 'Missed',
    tone: 'bg-rose-50 dark:bg-rose-950/50 text-rose-700 dark:text-rose-300',
    icon: <AlertCircle className="w-3.5 h-3.5" />,
  },
};

export default function StudentAssignmentsPage() {
  const [assignments, setAssignments] = useState<StudentAssignmentRow[]>([]);
  const [loading, setLoading] = useState(true);

  useEffect(() => {
    fetchMyAssignments().then((rows) => {
      setAssignments(rows);
      setLoading(false);
    });
  }, []);

  return (
    <div className="min-h-screen bg-slate-50 dark:bg-slate-950 text-slate-900 dark:text-slate-100 flex flex-col font-sans">
      <Navbar currentRole="student" userName="Chidiebere Okafor" />

      <main className="max-w-4xl mx-auto px-4 sm:px-6 lg:px-8 py-8 w-full">
        <Link href="/student" className="inline-flex items-center gap-1.5 text-xs font-mono font-bold text-amber-600 dark:text-amber-400 hover:underline mb-4">
          <ArrowLeft className="w-3.5 h-3.5" /> Return to Dashboard
        </Link>

        <div className="mb-6">
          <Badge variant="mastered">Assignments</Badge>
          <h1 className="text-2xl sm:text-3xl font-display font-extrabold text-slate-900 dark:text-white mt-1">
            Your Assignments
          </h1>
        </div>

        {loading && <p className="text-sm text-slate-500 dark:text-slate-400">Loading assignments...</p>}
        {!loading && assignments.length === 0 && (
          <Card variant="paper" className="p-6 text-center">
            <p className="text-sm text-slate-600 dark:text-slate-400">No assignments yet.</p>
          </Card>
        )}

        <div className="space-y-3">
          {assignments.map((a) => {
            const meta = STATUS_META[a.status];
            const actionable = a.status === 'not_started' || a.status === 'in_progress';
            const content = (
              <Card variant="paper" className={`p-4 sm:p-5 ${actionable ? 'hover:border-indigo-400 transition-all' : ''}`}>
                <div className="flex items-start justify-between gap-4">
                  <div className="min-w-0">
                    <h2 className="text-sm font-bold text-slate-900 dark:text-white truncate">{a.title}</h2>
                    <p className="text-xs text-slate-500 dark:text-slate-400 mt-0.5">
                      {a.class_name} · {a.topic_title} · {a.question_count} question{a.question_count === 1 ? '' : 's'}
                    </p>
                    <div className="flex items-center gap-3 mt-2 text-[11px] font-mono text-slate-500 dark:text-slate-400">
                      <span className="flex items-center gap-1">
                        <CalendarClock className="w-3.5 h-3.5" /> Due {new Date(a.due_date).toLocaleString()}
                      </span>
                      <span className="flex items-center gap-1">
                        <Clock className="w-3.5 h-3.5" /> {a.duration_minutes ? `${a.duration_minutes} min` : 'Untimed'}
                      </span>
                    </div>
                  </div>
                  <span className={`flex-none flex items-center gap-1 text-[11px] font-bold px-2.5 py-1 rounded-md ${meta.tone}`}>
                    {meta.icon} {meta.label}
                  </span>
                </div>
              </Card>
            );
            return actionable ? (
              <Link key={a.id} href={`/student/assignments/${a.id}/take`}>
                {content}
              </Link>
            ) : (
              <div key={a.id}>{content}</div>
            );
          })}
        </div>
      </main>
    </div>
  );
}
