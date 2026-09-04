'use client';

import React, { useCallback, useEffect, useState } from 'react';
import Link from 'next/link';
import Navbar from '@/components/Navbar';
import { Card, Button, Badge, MathMotif } from '@/components/ui/Primitives';
import { GraduationCap, Plus, Users, BarChart2, School as SchoolIcon, BookOpen, Gamepad2 } from 'lucide-react';
import ActivityBuilder from '@/components/ActivityBuilder';

import {
  createTeacherClassInSupabase,
  fetchMyTeacherSchoolId,
  fetchMyClassesWithStats,
  fetchClassScoreSummary,
  fetchClassTopics,
  type TeacherClassSummary,
  type ClassStudentScore,
  type ClassLessonRow,
} from '@/lib/supabase';
import { useAuth } from '@/lib/authContext';
import type { ClassLevel } from '@/lib/types';

const CLASS_LEVELS: ClassLevel[] = ['JSS1', 'JSS2', 'JSS3', 'SS1', 'SS2', 'SS3'];

export default function TeacherDashboard() {
  const { user } = useAuth();
  const [showClassModal, setShowClassModal] = useState(false);
  const [newClassName, setNewClassName] = useState('');
  const [newClassLevel, setNewClassLevel] = useState<ClassLevel>('SS2');
  const [classList, setClassList] = useState<TeacherClassSummary[]>([]);
  const [classListLoading, setClassListLoading] = useState(true);

  // Ledger + lessons are scoped to one selected class (+ optional term)
  // rather than flattened across every class — a class selector and term
  // selector drive both below.
  const [selectedClassId, setSelectedClassId] = useState<string | null>(null);
  const [selectedTerm, setSelectedTerm] = useState<1 | 2 | 3 | 'all'>('all');
  const [ledgerRows, setLedgerRows] = useState<ClassStudentScore[]>([]);
  const [ledgerLoading, setLedgerLoading] = useState(true);
  const [lessons, setLessons] = useState<ClassLessonRow[]>([]);
  const [lessonsLoading, setLessonsLoading] = useState(true);
  const [activityBuilderTopic, setActivityBuilderTopic] = useState<ClassLessonRow | null>(null);

  const loadClasses = useCallback(async () => {
    setClassListLoading(true);
    const classes = await fetchMyClassesWithStats();
    setClassList(classes);
    setClassListLoading(false);
    setSelectedClassId((prev) => (prev && classes.some((c) => c.id === prev) ? prev : (classes[0]?.id ?? null)));
  }, []);

  useEffect(() => {
    // Load-on-mount — see admin/page.tsx's loadAuthoredContent for the
    // same justified suppression.
    // eslint-disable-next-line react-hooks/set-state-in-effect
    loadClasses();
  }, [loadClasses]);

  const selectedClass = classList.find((c) => c.id === selectedClassId) ?? null;

  useEffect(() => {
    if (!selectedClass) {
      // No class selected (e.g. teacher has none yet) — same justified
      // suppression as loadClasses above.
      /* eslint-disable react-hooks/set-state-in-effect */
      setLedgerRows([]);
      setLessons([]);
      setLedgerLoading(false);
      setLessonsLoading(false);
      /* eslint-enable react-hooks/set-state-in-effect */
      return;
    }
    const term = selectedTerm === 'all' ? undefined : selectedTerm;

    let cancelled = false;
    setLedgerLoading(true);
    fetchClassScoreSummary(selectedClass.id, term).then((summary) => {
      if (!cancelled) {
        setLedgerRows(summary.students);
        setLedgerLoading(false);
      }
    });

    setLessonsLoading(true);
    fetchClassTopics(selectedClass.class_level, term).then((rows) => {
      if (!cancelled) {
        setLessons(rows);
        setLessonsLoading(false);
      }
    });

    return () => {
      cancelled = true;
    };
  }, [selectedClass, selectedTerm]);

  // null = not checked yet, '' = checked and no school joined, else a
  // real school_id — only show the "join a school" prompt once we
  // actually know it's missing, not on every render before the check.
  const [schoolId, setSchoolId] = useState<string | null>(null);
  const [schoolChecked, setSchoolChecked] = useState(false);

  useEffect(() => {
    if (!user?.id) return;
    fetchMyTeacherSchoolId(user.id).then((id) => {
      setSchoolId(id);
      setSchoolChecked(true);
    });
  }, [user?.id]);

  const handleCreateClass = async (e: React.FormEvent) => {
    e.preventDefault();
    if (!newClassName.trim()) return;

    const createdClass = await createTeacherClassInSupabase(newClassName, newClassLevel, user?.id);
    setClassList((prev) => [...prev, { ...createdClass, class_level: newClassLevel }]);
    setNewClassName('');
    setShowClassModal(false);
  };

  return (
    <div className="min-h-screen bg-slate-50 dark:bg-slate-950 text-slate-900 dark:text-slate-100 flex flex-col font-sans">
      <Navbar currentRole="teacher" userName="Mr. Olanrewaju Bello" />

      <main className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 py-8 w-full">
        {/* Header */}
        <div className="flex flex-col sm:flex-row sm:items-center justify-between gap-4 mb-8">
          <div>
            <Badge variant="mastered">Verified Teacher Portal</Badge>
            <h1 className="text-2xl sm:text-3xl font-display font-extrabold text-slate-900 dark:text-white mt-1">
              Teacher Academic Ledger & Roster
            </h1>
          </div>

          <Button variant="chalk" size="md" onClick={() => setShowClassModal(true)} className="font-display">
            <Plus className="w-4 h-4" /> Create New Class
          </Button>
        </div>

        {/* No-school prompt */}
        {schoolChecked && !schoolId && (
          <Card variant="paper" className="mb-8 flex flex-col sm:flex-row items-start sm:items-center justify-between gap-4">
            <div className="flex items-center gap-3">
              <div className="w-10 h-10 rounded-lg bg-amber-50 dark:bg-amber-950/80 text-amber-600 dark:text-amber-400 flex items-center justify-center border border-amber-200 dark:border-amber-800 shrink-0">
                <SchoolIcon className="w-5 h-5" />
              </div>
              <div>
                <h3 className="text-sm font-display font-bold text-slate-900 dark:text-white">Join or create your school</h3>
                <p className="text-xs text-slate-500 dark:text-slate-400 mt-0.5">
                  Your classes aren&apos;t linked to a school yet — students won&apos;t be able to find them by search until you do.
                </p>
              </div>
            </div>
            <Link href="/teacher/school">
              <Button variant="chalk" size="sm">Find My School</Button>
            </Link>
          </Card>
        )}

        {/* Classes Grid */}
        <div className="grid grid-cols-1 md:grid-cols-2 gap-6 mb-8">
          {classListLoading && <p className="text-xs text-slate-500 dark:text-slate-400">Loading your classes…</p>}
          {!classListLoading && classList.length === 0 && (
            <p className="text-xs text-slate-500 dark:text-slate-400">No classes yet — create one to get started.</p>
          )}
          {classList.map((cls) => (
            <Card key={cls.id} variant="ledger" className="hover:border-emerald-500/60 transition-all">
              <div className="flex items-start justify-between">
                <div>
                  <h2 className="text-lg font-display font-bold text-slate-900 dark:text-white">{cls.name}</h2>
                  <span className="inline-block mt-1 text-xs font-mono font-bold px-2 py-0.5 rounded bg-white dark:bg-slate-900 text-amber-600 dark:text-amber-400 border border-slate-200 dark:border-slate-800">
                    Join Code: {cls.code}
                  </span>
                </div>
                <div className="w-10 h-10 rounded-lg bg-emerald-50 dark:bg-emerald-950/80 text-emerald-600 dark:text-emerald-400 font-extrabold flex items-center justify-center border border-emerald-200 dark:border-emerald-800">
                  <Users className="w-5 h-5" />
                </div>
              </div>

              <div className="grid grid-cols-2 gap-4 mt-6 pt-4 border-t border-slate-200 dark:border-slate-800 font-mono">
                <div>
                  <p className="text-xs text-slate-500 dark:text-slate-400 font-medium">Enrolled Students</p>
                  <p className="text-xl font-extrabold text-slate-900 dark:text-white">{cls.studentsCount}</p>
                </div>
                <div>
                  <p className="text-xs text-slate-500 dark:text-slate-400 font-medium">Avg Topic Mastery</p>
                  <p className="text-xl font-extrabold text-emerald-600 dark:text-emerald-400">{cls.avgMastery}%</p>
                </div>
              </div>

              <div className="mt-4 flex items-center gap-4">
                <Link
                  href={`/teacher/class/${cls.id}/roster`}
                  className="inline-flex items-center gap-1.5 text-xs font-mono font-bold text-amber-600 dark:text-amber-400 hover:underline"
                >
                  Manage Roster &amp; Join Requests
                </Link>
                <Link
                  href={`/teacher/class/${cls.id}/assignments`}
                  className="inline-flex items-center gap-1.5 text-xs font-mono font-bold text-emerald-600 dark:text-emerald-400 hover:underline"
                >
                  Assignments
                </Link>
              </div>
            </Card>
          ))}
        </div>

        {/* Class + term filter */}
        {classList.length > 0 && (
          <div className="flex flex-wrap items-center gap-3 mb-6">
            <select
              value={selectedClassId ?? ''}
              onChange={(e) => setSelectedClassId(e.target.value)}
              className="px-4 py-2.5 rounded-xl border border-slate-300 dark:border-slate-700 bg-slate-50 dark:bg-slate-900 text-sm font-mono text-slate-900 dark:text-white"
            >
              {classList.map((c) => (
                <option key={c.id} value={c.id}>{c.name}</option>
              ))}
            </select>
            <select
              value={selectedTerm}
              onChange={(e) => setSelectedTerm(e.target.value === 'all' ? 'all' : (Number(e.target.value) as 1 | 2 | 3))}
              className="px-4 py-2.5 rounded-xl border border-slate-300 dark:border-slate-700 bg-slate-50 dark:bg-slate-900 text-sm font-mono text-slate-900 dark:text-white"
            >
              <option value="all">All Terms</option>
              <option value={1}>Term 1</option>
              <option value={2}>Term 2</option>
              <option value={3}>Term 3</option>
            </select>
          </div>
        )}

        {/* Lessons this term */}
        <Card variant="paper" className="mb-8">
          <h2 className="text-lg font-display font-bold text-slate-900 dark:text-white mb-4 flex items-center gap-2">
            <BookOpen className="w-5 h-5 text-emerald-600 dark:text-emerald-400" />
            Lessons{selectedTerm !== 'all' ? ` — Term ${selectedTerm}` : ''}
            {selectedClass ? ` (${selectedClass.name})` : ''}
          </h2>
          {lessonsLoading && <p className="text-xs text-slate-500 dark:text-slate-400">Loading…</p>}
          {!lessonsLoading && lessons.length === 0 && (
            <p className="text-xs text-slate-500 dark:text-slate-400">No lessons match this class/term.</p>
          )}
          {!lessonsLoading && lessons.length > 0 && (
            <ul className="divide-y divide-slate-200 dark:divide-slate-800 text-sm font-mono">
              {lessons.map((l, idx) => (
                <li key={l.topic_id} className="py-2.5 flex items-center gap-3 text-slate-800 dark:text-slate-200">
                  <span className="text-xs text-slate-400 dark:text-slate-500 w-6">{idx + 1}.</span>
                  <span className="flex-1">{l.title}</span>
                  {l.term != null && (
                    <span className="text-[10px] font-bold uppercase px-2 py-0.5 rounded bg-emerald-50 dark:bg-emerald-950 text-emerald-600 dark:text-emerald-400">
                      Term {l.term}
                    </span>
                  )}
                  {l.week != null && (
                    <span className="text-[10px] font-bold uppercase px-2 py-0.5 rounded bg-amber-50 dark:bg-amber-950 text-amber-600 dark:text-amber-400">
                      Week {l.week}
                    </span>
                  )}
                  <button
                    onClick={() => setActivityBuilderTopic(l)}
                    title="Add an interactive activity for this topic"
                    className="text-[10px] font-bold uppercase px-2 py-0.5 rounded bg-indigo-50 dark:bg-indigo-950 text-indigo-600 dark:text-indigo-400 flex items-center gap-1 hover:bg-indigo-100 dark:hover:bg-indigo-900"
                  >
                    <Gamepad2 className="w-3 h-3" /> Activity
                  </button>
                </li>
              ))}
            </ul>
          )}
        </Card>

        {/* Class Performance Ledger Table */}
        <Card variant="paper">
          <h2 className="text-lg font-display font-bold text-slate-900 dark:text-white mb-4 flex items-center gap-2">
            <BarChart2 className="w-5 h-5 text-emerald-600 dark:text-emerald-400" /> Student Performance Ledger
            {selectedClass ? ` — ${selectedClass.name}` : ''}
          </h2>

          <div className="overflow-x-auto">
            <table className="w-full text-left text-sm font-mono">
              <thead className="bg-white dark:bg-slate-900 text-slate-500 dark:text-slate-400 text-xs uppercase border-b border-slate-200 dark:border-slate-800">
                <tr>
                  <th className="px-4 py-3 rounded-l-lg">Student Name</th>
                  <th className="px-4 py-3">Questions Attempted</th>
                  <th className="px-4 py-3">Correct</th>
                  <th className="px-4 py-3 rounded-r-lg">Avg Mastery</th>
                </tr>
              </thead>
              <tbody className="divide-y divide-slate-200 dark:divide-slate-800 text-slate-800 dark:text-slate-200">
                {ledgerLoading && (
                  <tr>
                    <td className="px-4 py-3.5 text-xs text-slate-500 dark:text-slate-400" colSpan={4}>Loading…</td>
                  </tr>
                )}
                {!ledgerLoading && ledgerRows.length === 0 && (
                  <tr>
                    <td className="px-4 py-3.5 text-xs text-slate-500 dark:text-slate-400" colSpan={4}>
                      No student activity yet.
                    </td>
                  </tr>
                )}
                {ledgerRows.map((row) => (
                  <tr key={row.student_id} className="hover:bg-slate-100/50 dark:hover:bg-slate-900/50">
                    <td className="px-4 py-3.5 font-bold font-sans">{row.full_name}</td>
                    <td className="px-4 py-3">{row.total_attempted}</td>
                    <td className="px-4 py-3">{row.total_correct}</td>
                    <td
                      className={`px-4 py-3 font-bold ${
                        row.average_mastery_percentage >= 70
                          ? 'text-emerald-600 dark:text-emerald-400'
                          : row.average_mastery_percentage >= 40
                            ? 'text-amber-600 dark:text-amber-400'
                            : 'text-rose-600 dark:text-rose-400'
                      }`}
                    >
                      {row.average_mastery_percentage}%
                    </td>
                  </tr>
                ))}
              </tbody>
            </table>
          </div>
        </Card>

        {/* Modal: Create Class */}
        {showClassModal && (
          <div className="fixed inset-0 z-50 flex items-center justify-center p-4 bg-slate-950/80 backdrop-blur-sm">
            <form onSubmit={handleCreateClass} className="bg-white dark:bg-slate-900 rounded-2xl max-w-md w-full p-6 shadow-2xl border border-slate-200 dark:border-slate-800">
              <h3 className="text-lg font-display font-bold text-slate-900 dark:text-white mb-4">Create New Class</h3>
              <div className="mb-4">
                <label className="block text-xs font-mono font-bold uppercase text-slate-500 dark:text-slate-400 mb-1">Class Name</label>
                <input
                  type="text"
                  placeholder="e.g. SS2 Mathematics B"
                  value={newClassName}
                  onChange={(e) => setNewClassName(e.target.value)}
                  className="w-full px-4 py-2.5 rounded-xl border border-slate-300 dark:border-slate-700 bg-slate-50 dark:bg-slate-950 text-sm focus:outline-none focus:ring-2 focus:ring-emerald-500 text-slate-900 dark:text-white font-mono"
                  required
                />
              </div>
              <div className="mb-4">
                <label className="block text-xs font-mono font-bold uppercase text-slate-500 dark:text-slate-400 mb-1">Grade / Class Level</label>
                <select
                  value={newClassLevel}
                  onChange={(e) => setNewClassLevel(e.target.value as ClassLevel)}
                  className="w-full px-4 py-2.5 rounded-xl border border-slate-300 dark:border-slate-700 bg-slate-50 dark:bg-slate-950 text-sm focus:outline-none focus:ring-2 focus:ring-emerald-500 text-slate-900 dark:text-white font-mono"
                >
                  {CLASS_LEVELS.map((lvl) => (
                    <option key={lvl} value={lvl}>{lvl}</option>
                  ))}
                </select>
              </div>
              <div className="flex items-center justify-end gap-3 pt-2">
                <button
                  type="button"
                  onClick={() => setShowClassModal(false)}
                  className="px-4 py-2 text-xs font-semibold text-slate-500 dark:text-slate-400 hover:text-slate-900 dark:hover:text-slate-200"
                >
                  Cancel
                </button>
                <Button type="submit" variant="chalk" size="sm">
                  Create Class
                </Button>
              </div>
            </form>
          </div>
        )}

        {/* Modal: Create Activity — scoped to whichever lesson row's
            "Activity" button was clicked. */}
        {activityBuilderTopic && (
          <ActivityBuilder
            topicId={activityBuilderTopic.topic_id}
            topicTitle={activityBuilderTopic.title}
            onClose={() => setActivityBuilderTopic(null)}
            onCreated={() => setActivityBuilderTopic(null)}
          />
        )}
      </main>
    </div>
  );
}
