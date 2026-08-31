'use client';

import React, { useCallback, useEffect, useState } from 'react';
import Link from 'next/link';
import { useParams } from 'next/navigation';
import Navbar from '@/components/Navbar';
import { Card, Badge } from '@/components/ui/Primitives';
import { ArrowLeft, Users, Trophy, TrendingUp, Target } from 'lucide-react';

import { fetchClassScoreSummary, type ClassScoreSummary } from '@/lib/supabase';

function masteryTone(pct: number) {
  if (pct >= 70) return 'bg-emerald-50 dark:bg-emerald-950/50 text-emerald-700 dark:text-emerald-300 border-emerald-200 dark:border-emerald-900/50';
  if (pct >= 40) return 'bg-amber-50 dark:bg-amber-950/50 text-amber-700 dark:text-amber-300 border-amber-200 dark:border-amber-900/50';
  return 'bg-rose-50 dark:bg-rose-950/50 text-rose-700 dark:text-rose-300 border-rose-200 dark:border-rose-900/50';
}

export default function ClassScoresPage() {
  const params = useParams();
  const classId = params.classId as string;

  const [summary, setSummary] = useState<ClassScoreSummary | null>(null);
  const [loading, setLoading] = useState(true);

  const load = useCallback(async () => {
    if (!classId) return;
    setLoading(true);
    const data = await fetchClassScoreSummary(classId);
    setSummary(data);
    setLoading(false);
  }, [classId]);

  useEffect(() => {
    load();
  }, [load]);

  const s = summary ?? { students: [], class_average_mastery_percentage: 0, class_total_attempted: 0, class_total_correct: 0 };
  const classAccuracy = s.class_total_attempted > 0 ? Math.round((s.class_total_correct / s.class_total_attempted) * 100) : 0;
  const ranked = [...s.students].sort((a, b) => b.average_mastery_percentage - a.average_mastery_percentage);

  return (
    <div className="min-h-screen bg-slate-50 dark:bg-slate-950 text-slate-900 dark:text-slate-100 flex flex-col font-sans selection:bg-amber-500 selection:text-slate-950">
      <Navbar currentRole="teacher" userName="Mr. Olanrewaju Bello" />

      <main className="max-w-5xl mx-auto px-4 sm:px-6 lg:px-8 py-8 w-full">
        <Link
          href={`/teacher/class/${classId}/roster`}
          className="inline-flex items-center gap-1.5 text-xs font-mono text-amber-600 dark:text-amber-400 hover:underline mb-4"
        >
          <ArrowLeft className="w-3.5 h-3.5" /> Back to Roster
        </Link>

        <div className="mb-6">
          <Badge variant="mastered">Class Dashboard</Badge>
          <h1 className="text-2xl sm:text-3xl font-display font-extrabold text-slate-900 dark:text-white mt-1">
            Cumulative Class Scores
          </h1>
          <p className="text-sm text-slate-600 dark:text-slate-400 mt-1">
            Every student&apos;s mastery and question performance for this class, in one place.
          </p>
        </div>

        {loading ? (
          <p className="text-sm text-slate-500 dark:text-slate-400">Loading class scores...</p>
        ) : s.students.length === 0 ? (
          <Card variant="paper" className="p-6 text-center">
            <p className="text-sm text-slate-600 dark:text-slate-400">
              No students have joined this class yet, or none have attempted a question.
            </p>
          </Card>
        ) : (
          <>
            {/* Class-wide summary tiles */}
            <div className="grid grid-cols-2 sm:grid-cols-4 gap-4 mb-6">
              <Card variant="paper" className="p-4 text-center">
                <Users className="w-4 h-4 text-indigo-600 dark:text-indigo-400 mx-auto mb-1.5" />
                <p className="text-xl font-extrabold text-slate-900 dark:text-white">{s.students.length}</p>
                <p className="text-[10px] font-mono text-slate-500 dark:text-slate-400 uppercase">Students</p>
              </Card>
              <Card variant="paper" className="p-4 text-center">
                <Target className="w-4 h-4 text-amber-600 dark:text-amber-400 mx-auto mb-1.5" />
                <p className="text-xl font-extrabold text-slate-900 dark:text-white">{s.class_total_attempted}</p>
                <p className="text-[10px] font-mono text-slate-500 dark:text-slate-400 uppercase">Attempted</p>
              </Card>
              <Card variant="paper" className="p-4 text-center">
                <TrendingUp className="w-4 h-4 text-emerald-600 dark:text-emerald-400 mx-auto mb-1.5" />
                <p className="text-xl font-extrabold text-slate-900 dark:text-white">{classAccuracy}%</p>
                <p className="text-[10px] font-mono text-slate-500 dark:text-slate-400 uppercase">Class Accuracy</p>
              </Card>
              <Card variant="paper" className="p-4 text-center">
                <Trophy className="w-4 h-4 text-amber-600 dark:text-amber-400 mx-auto mb-1.5" />
                <p className="text-xl font-extrabold text-slate-900 dark:text-white">{s.class_average_mastery_percentage}%</p>
                <p className="text-[10px] font-mono text-slate-500 dark:text-slate-400 uppercase">Avg. Mastery</p>
              </Card>
            </div>

            {/* Per-student ranked list, ranked by mastery so the class
                picture (who's ahead, who's struggling) reads at a glance
                without needing a separate sort control. */}
            <Card variant="paper" className="p-4 sm:p-6">
              <p className="text-[10px] font-mono font-bold uppercase text-slate-500 dark:text-slate-400 mb-3">
                Students, Ranked by Mastery
              </p>
              <div className="space-y-2">
                {ranked.map((student, i) => (
                  <div
                    key={student.student_id}
                    className="flex items-center gap-3 rounded-xl px-3 py-3 bg-slate-50 dark:bg-slate-900/60"
                  >
                    <span className="w-7 h-7 rounded-lg bg-slate-200 dark:bg-slate-800 text-slate-700 dark:text-slate-300 font-mono font-bold text-xs flex items-center justify-center flex-none">
                      {i + 1}
                    </span>
                    <div className="min-w-0 flex-1">
                      <p className="text-sm font-semibold text-slate-900 dark:text-white truncate">{student.full_name}</p>
                      <p className="text-[11px] font-mono text-slate-500 dark:text-slate-400">
                        {student.total_correct}/{student.total_attempted} correct
                        {student.total_attempted === 0 ? ' (not started)' : ''}
                      </p>
                    </div>
                    <span className={`flex-none text-xs font-mono font-bold px-2.5 py-1 rounded-md border ${masteryTone(student.average_mastery_percentage)}`}>
                      {student.average_mastery_percentage}%
                    </span>
                  </div>
                ))}
              </div>
            </Card>
          </>
        )}
      </main>
    </div>
  );
}
