'use client';

import React, { useCallback, useEffect, useState } from 'react';
import Link from 'next/link';
import { useParams, useRouter } from 'next/navigation';
import Navbar from '@/components/Navbar';
import MathRenderer from '@/components/MathRenderer';
import { Card, Badge, Button } from '@/components/ui/Primitives';
import { ArrowLeft, Plus, Loader2, AlertCircle, CheckCircle2 } from 'lucide-react';

import { createClient } from '@/lib/supabase/client';
import {
  fetchClassTopics,
  fetchQuestionBankForClass,
  createTeacherQuestion,
  createAssignmentWithQuestions,
  type ClassLessonRow,
  type QuestionBankRow,
} from '@/lib/supabase';
import { useAuth } from '@/lib/authContext';
import type { ClassLevel } from '@/lib/types';

export default function NewAssignmentPage() {
  const params = useParams();
  const router = useRouter();
  const { user } = useAuth();
  const classId = params.classId as string;

  const [classLevel, setClassLevel] = useState<ClassLevel | null>(null);
  const [topics, setTopics] = useState<ClassLessonRow[]>([]);
  const [topicId, setTopicId] = useState('');
  const [bank, setBank] = useState<QuestionBankRow[]>([]);
  const [bankLoading, setBankLoading] = useState(false);
  const [selectedIds, setSelectedIds] = useState<string[]>([]);

  const [title, setTitle] = useState('');
  const [dueDate, setDueDate] = useState('');
  const [untimed, setUntimed] = useState(true);
  const [durationMinutes, setDurationMinutes] = useState(20);

  const [showCustomForm, setShowCustomForm] = useState(false);
  const [customText, setCustomText] = useState('');
  const [customA, setCustomA] = useState('');
  const [customB, setCustomB] = useState('');
  const [customC, setCustomC] = useState('');
  const [customD, setCustomD] = useState('');
  const [customCorrect, setCustomCorrect] = useState<'A' | 'B' | 'C' | 'D'>('A');
  const [customExplanation, setCustomExplanation] = useState('');
  const [savingCustom, setSavingCustom] = useState(false);
  const [customError, setCustomError] = useState<string | null>(null);

  const [submitting, setSubmitting] = useState(false);
  const [submitError, setSubmitError] = useState<string | null>(null);

  // Resolve the class's class_level once, up front — needed by both the
  // topic picker (fetchClassTopics) and the bank picker
  // (fetchQuestionBankForClass), neither of which take a classId.
  useEffect(() => {
    if (!classId) return;
    const supabase = createClient();
    if (!supabase) return;
    supabase
      .from('classes')
      .select('class_level')
      .eq('id', classId)
      .single()
      .then(({ data }) => {
        if (data) setClassLevel(data.class_level as ClassLevel);
      });
  }, [classId]);

  useEffect(() => {
    if (!classLevel) return;
    fetchClassTopics(classLevel).then((rows) => {
      setTopics(rows);
      setTopicId((prev) => (prev || rows[0]?.topic_id) ?? '');
    });
  }, [classLevel]);

  const loadBank = useCallback(async () => {
    if (!classLevel || !topicId) return;
    setBankLoading(true);
    const rows = await fetchQuestionBankForClass(classLevel, topicId);
    setBank(rows);
    setBankLoading(false);
  }, [classLevel, topicId]);

  useEffect(() => {
    // Load-on-topic-change — same justified suppression as
    // admin/page.tsx's loadAuthoredContent.
    // eslint-disable-next-line react-hooks/set-state-in-effect
    loadBank();
  }, [loadBank]);

  const toggleSelected = (id: string) => {
    setSelectedIds((prev) => (prev.includes(id) ? prev.filter((x) => x !== id) : [...prev, id]));
  };

  const handleAddCustomQuestion = async (e: React.FormEvent) => {
    e.preventDefault();
    if (!user?.id || !topicId) return;
    if (!customText.trim() || !customA.trim() || !customB.trim() || !customC.trim() || !customD.trim() || !customExplanation.trim()) return;

    setSavingCustom(true);
    setCustomError(null);
    const result = await createTeacherQuestion({
      authUserId: user.id,
      topicId,
      questionText: customText,
      optionA: customA,
      optionB: customB,
      optionC: customC,
      optionD: customD,
      correctLetter: customCorrect,
      explanation: customExplanation,
    });
    setSavingCustom(false);

    if (!result.success || !result.question) {
      setCustomError(result.error ?? 'Failed to save question.');
      return;
    }

    // Immediately usable, no refetch: appears in the visible bank list
    // and gets pre-selected into this assignment.
    setBank((prev) => [result.question!, ...prev]);
    setSelectedIds((prev) => [...prev, result.question!.id]);

    setCustomText('');
    setCustomA('');
    setCustomB('');
    setCustomC('');
    setCustomD('');
    setCustomCorrect('A');
    setCustomExplanation('');
    setShowCustomForm(false);
  };

  // Deliberately no "due date is in the future" check here — Date.now()
  // is an impure read and this expression runs during render (it drives
  // the submit button's disabled state). That check happens once, at
  // actual submit time, in handleCreate below instead.
  const canSubmit = title.trim().length > 0 && dueDate.length > 0 && selectedIds.length > 0 && topicId.length > 0;

  const handleCreate = async (e: React.FormEvent) => {
    e.preventDefault();
    if (!canSubmit) return;
    if (new Date(dueDate).getTime() <= Date.now()) {
      setSubmitError('Due date must be in the future.');
      return;
    }

    setSubmitting(true);
    setSubmitError(null);
    const result = await createAssignmentWithQuestions({
      classId,
      topicId,
      title,
      dueDate: new Date(dueDate).toISOString(),
      durationMinutes: untimed ? null : durationMinutes,
      questionIds: selectedIds,
    });
    setSubmitting(false);

    if (!result.success || !result.assignmentId) {
      setSubmitError(result.error ?? 'Failed to create assignment.');
      return;
    }

    router.push(`/teacher/class/${classId}/assignments/${result.assignmentId}`);
  };

  return (
    <div className="min-h-screen bg-slate-50 dark:bg-slate-950 text-slate-900 dark:text-slate-100 flex flex-col font-sans">
      <Navbar currentRole="teacher" userName="Mr. Olanrewaju Bello" />

      <main className="max-w-3xl mx-auto px-4 sm:px-6 lg:px-8 py-8 w-full">
        <Link
          href={`/teacher/class/${classId}/assignments`}
          className="inline-flex items-center gap-1.5 text-xs font-mono text-amber-600 dark:text-amber-400 hover:underline mb-4"
        >
          <ArrowLeft className="w-3.5 h-3.5" /> Back to Assignments
        </Link>

        <div className="mb-6">
          <Badge variant="mastered">New Assignment</Badge>
          <h1 className="text-2xl sm:text-3xl font-display font-extrabold text-slate-900 dark:text-white mt-1">
            Build an Assignment
          </h1>
        </div>

        <form onSubmit={handleCreate} className="space-y-6">
          {/* Topic */}
          <Card variant="paper" className="p-5">
            <label className="block text-xs font-mono font-bold uppercase text-slate-500 dark:text-slate-400 mb-2">Topic</label>
            <select
              value={topicId}
              onChange={(e) => {
                setTopicId(e.target.value);
                setSelectedIds([]);
              }}
              className="w-full px-4 py-2.5 rounded-xl border border-slate-300 dark:border-slate-700 bg-slate-50 dark:bg-slate-900 text-sm font-mono text-slate-900 dark:text-white"
            >
              {topics.length === 0 && <option value="">No topics for this class level</option>}
              {topics.map((t) => (
                <option key={t.topic_id} value={t.topic_id}>
                  {t.title}
                  {t.term != null ? ` · Term ${t.term}` : ''}
                </option>
              ))}
            </select>
          </Card>

          {/* Question bank picker */}
          <Card variant="paper" className="p-5">
            <div className="flex items-center justify-between mb-3">
              <label className="text-xs font-mono font-bold uppercase text-slate-500 dark:text-slate-400">
                Question Bank — {selectedIds.length} selected
              </label>
              <button
                type="button"
                onClick={() => setShowCustomForm((v) => !v)}
                className="text-xs font-mono font-bold text-emerald-600 dark:text-emerald-400 flex items-center gap-1 hover:underline"
              >
                <Plus className="w-3.5 h-3.5" /> Add custom question
              </button>
            </div>

            {showCustomForm && (
              <div className="mb-4 p-4 rounded-xl border border-slate-200 dark:border-slate-800 bg-slate-50 dark:bg-slate-900/60 space-y-3">
                <textarea
                  rows={2}
                  placeholder="Question text (Markdown + LaTeX: $...$)"
                  value={customText}
                  onChange={(e) => setCustomText(e.target.value)}
                  className="w-full px-3 py-2 rounded-lg border border-slate-300 dark:border-slate-700 bg-white dark:bg-slate-950 text-sm"
                />
                <div className="space-y-2">
                  {([
                    ['A', customA, setCustomA],
                    ['B', customB, setCustomB],
                    ['C', customC, setCustomC],
                    ['D', customD, setCustomD],
                  ] as const).map(([letter, value, setValue]) => (
                    <div key={letter} className="flex items-center gap-2">
                      <button
                        type="button"
                        onClick={() => setCustomCorrect(letter)}
                        className={`flex-shrink-0 w-7 h-7 rounded-lg text-xs font-bold border-2 flex items-center justify-center transition-colors ${
                          customCorrect === letter
                            ? 'border-emerald-500 bg-emerald-50 dark:bg-emerald-950/60 text-emerald-600 dark:text-emerald-400'
                            : 'border-slate-300 dark:border-slate-700 text-slate-500'
                        }`}
                      >
                        {letter}
                      </button>
                      <input
                        type="text"
                        placeholder={`Option ${letter}`}
                        value={value}
                        onChange={(e) => setValue(e.target.value)}
                        className="flex-1 px-3 py-1.5 rounded-lg border border-slate-300 dark:border-slate-700 bg-white dark:bg-slate-950 text-sm"
                      />
                    </div>
                  ))}
                </div>
                <textarea
                  rows={2}
                  placeholder="Explanation"
                  value={customExplanation}
                  onChange={(e) => setCustomExplanation(e.target.value)}
                  className="w-full px-3 py-2 rounded-lg border border-slate-300 dark:border-slate-700 bg-white dark:bg-slate-950 text-sm"
                />
                {customError && (
                  <div className="flex items-start gap-2 rounded-lg px-3 py-2 text-xs bg-rose-50 dark:bg-rose-950/60 text-rose-700 dark:text-rose-300">
                    <AlertCircle className="w-4 h-4 flex-shrink-0 mt-0.5" />
                    <span>{customError}</span>
                  </div>
                )}
                <button
                  type="button"
                  onClick={handleAddCustomQuestion}
                  disabled={savingCustom}
                  className="px-4 py-2 rounded-lg bg-emerald-600 text-white text-xs font-bold hover:bg-emerald-500 disabled:opacity-50 flex items-center gap-2"
                >
                  {savingCustom && <Loader2 className="w-3.5 h-3.5 animate-spin" />}
                  Save &amp; Add to Assignment
                </button>
              </div>
            )}

            {bankLoading && <p className="text-xs text-slate-500 dark:text-slate-400">Loading question bank...</p>}
            {!bankLoading && bank.length === 0 && (
              <p className="text-xs text-slate-500 dark:text-slate-400">No published questions for this topic yet — add a custom one above.</p>
            )}
            <div className="space-y-2 max-h-96 overflow-y-auto pr-1">
              {bank.map((q) => (
                <label
                  key={q.id}
                  className={`flex items-start gap-3 p-3 rounded-xl border cursor-pointer transition-colors ${
                    selectedIds.includes(q.id)
                      ? 'border-emerald-500 bg-emerald-50 dark:bg-emerald-950/40'
                      : 'border-slate-200 dark:border-slate-800 hover:border-emerald-300'
                  }`}
                >
                  <input
                    type="checkbox"
                    checked={selectedIds.includes(q.id)}
                    onChange={() => toggleSelected(q.id)}
                    className="mt-1"
                  />
                  <div className="min-w-0 flex-1">
                    <MathRenderer content={q.question_text} className="text-sm text-slate-800 dark:text-slate-100" />
                    <div className="flex items-center gap-2 mt-1">
                      <span className="text-[10px] font-bold text-slate-400 uppercase">{q.exam_type}</span>
                      {q.created_by_teacher_id && (
                        <span className="text-[10px] font-bold text-amber-600 dark:text-amber-400 uppercase">Your question</span>
                      )}
                    </div>
                  </div>
                </label>
              ))}
            </div>
          </Card>

          {/* Title, due date, duration */}
          <Card variant="paper" className="p-5 space-y-4">
            <div>
              <label className="block text-xs font-mono font-bold uppercase text-slate-500 dark:text-slate-400 mb-1">Title</label>
              <input
                type="text"
                placeholder="e.g. Week 6 Quiz — Quadratic Equations"
                value={title}
                onChange={(e) => setTitle(e.target.value)}
                className="w-full px-4 py-2.5 rounded-xl border border-slate-300 dark:border-slate-700 bg-slate-50 dark:bg-slate-900 text-sm"
                required
              />
            </div>
            <div>
              <label className="block text-xs font-mono font-bold uppercase text-slate-500 dark:text-slate-400 mb-1">Due Date</label>
              <input
                type="datetime-local"
                value={dueDate}
                onChange={(e) => setDueDate(e.target.value)}
                className="w-full px-4 py-2.5 rounded-xl border border-slate-300 dark:border-slate-700 bg-slate-50 dark:bg-slate-900 text-sm font-mono"
                required
              />
            </div>
            <div>
              <div className="flex items-center justify-between mb-1">
                <label className="text-xs font-mono font-bold uppercase text-slate-500 dark:text-slate-400">Duration</label>
                <label className="flex items-center gap-1.5 text-xs text-slate-500 dark:text-slate-400">
                  <input type="checkbox" checked={untimed} onChange={(e) => setUntimed(e.target.checked)} />
                  Untimed
                </label>
              </div>
              {!untimed && (
                <input
                  type="number"
                  min={1}
                  value={durationMinutes}
                  onChange={(e) => setDurationMinutes(Number(e.target.value))}
                  className="w-full px-4 py-2.5 rounded-xl border border-slate-300 dark:border-slate-700 bg-slate-50 dark:bg-slate-900 text-sm font-mono"
                />
              )}
            </div>
          </Card>

          {submitError && (
            <div className="flex items-start gap-2 rounded-xl px-3 py-2.5 text-xs bg-rose-50 dark:bg-rose-950/60 text-rose-700 dark:text-rose-300">
              <AlertCircle className="w-4 h-4 flex-shrink-0 mt-0.5" />
              <span>{submitError}</span>
            </div>
          )}

          <Button type="submit" variant="chalk" size="md" disabled={!canSubmit || submitting} className="font-display w-full justify-center">
            {submitting ? <Loader2 className="w-4 h-4 animate-spin" /> : <CheckCircle2 className="w-4 h-4" />}
            Create Assignment
          </Button>
        </form>
      </main>
    </div>
  );
}
