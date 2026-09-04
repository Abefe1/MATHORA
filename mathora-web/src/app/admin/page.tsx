'use client';

import React, { useState, useEffect, useCallback } from 'react';
import Navbar from '@/components/Navbar';
import MathRenderer from '@/components/MathRenderer';
import { INITIAL_TOPICS } from '@/lib/mockData';
import { createClient } from '@/lib/supabase/client';
import type { Topic, ExamType } from '@/lib/types';
import { ShieldCheck, Plus, BookOpen, Layers, CheckCircle2, AlertCircle, BarChart, Database, Upload, FileText, Loader2, Check, X } from 'lucide-react';

type ContentUpload = {
  id: string;
  original_filename: string;
  status: string;
  error_message: string | null;
  generated_question_ids: string[];
  generated_worked_example_ids: string[];
  created_at: string;
};

// Matches the DB row shape directly (option_a..option_d, correct_letter)
// rather than the app's runtime Question type (options: QuestionOption[])
// — this is draft content straight from content_uploads, not yet
// reshaped for the student-facing practice UI.
type DraftQuestion = {
  id: string;
  question_text: string;
  option_a: string;
  option_b: string;
  option_c: string;
  option_d: string;
  correct_letter: string;
  explanation: string;
  exam_shortcut: string | null;
};

export default function AdminCMS() {
  // Seeded from mock data so the page renders something immediately;
  // replaced by loadAuthoredContent() below with the real topics/
  // questions.select('*') result the moment Supabase answers (or left
  // as-is if Supabase isn't configured — see createClient()).
  const [topics, setTopics] = useState<Topic[]>(INITIAL_TOPICS);
  const [topicsLoading, setTopicsLoading] = useState(true);
  const [showQuestionModal, setShowQuestionModal] = useState(false);
  const [newQuestionText, setNewQuestionText] = useState('');
  const [newExplanation, setNewExplanation] = useState('');
  const [newShortcut, setNewShortcut] = useState('');
  const [newTopicId, setNewTopicId] = useState('');
  const [newOptionA, setNewOptionA] = useState('');
  const [newOptionB, setNewOptionB] = useState('');
  const [newOptionC, setNewOptionC] = useState('');
  const [newOptionD, setNewOptionD] = useState('');
  const [newCorrectLetter, setNewCorrectLetter] = useState<'A' | 'B' | 'C' | 'D'>('A');
  const [savingQuestion, setSavingQuestion] = useState(false);
  const [saveQuestionError, setSaveQuestionError] = useState<string | null>(null);

  const [activeTab, setActiveTab] = useState<'authored' | 'upload' | 'review'>('authored');

  // --- Upload & Generate ---
  const [uploadTopicId, setUploadTopicId] = useState(INITIAL_TOPICS[0]?.id ?? '');
  const [uploadQuestionCount, setUploadQuestionCount] = useState(10);
  const [uploadFile, setUploadFile] = useState<File | null>(null);
  const [uploading, setUploading] = useState(false);
  const [uploadMessage, setUploadMessage] = useState<{ type: 'success' | 'error'; text: string } | null>(null);

  // Real topics + their published questions, replacing the INITIAL_TOPICS
  // placeholder this page shipped with. questions.select('*') here (not
  // fetchQuestions() from lib/supabase.ts, which runs on a separate,
  // unauthenticated client) so RLS sees this admin's session and — for
  // an admin role — the questions_read_published_or_own_draft policy's
  // "or you're an admin" clause would apply too; explicitly filtering
  // to 'published' keeps this tab showing only what students actually
  // see, matching its hardcoded "Published" badge.
  const loadAuthoredContent = useCallback(async () => {
    const supabase = createClient();
    if (!supabase) {
      setTopicsLoading(false);
      return;
    }
    setTopicsLoading(true);
    const [{ data: topicRows }, { data: questionRows }] = await Promise.all([
      supabase.from('topics').select('id, title, class_level, description, order_index, icon').order('order_index'),
      supabase
        .from('questions')
        .select('id, topic_id, question_text, explanation, exam_type, exam_shortcut, difficulty')
        .eq('status', 'published'),
    ]);
    setTopicsLoading(false);
    if (!topicRows) return;

    const questionsByTopic = new Map<string, Topic['questions']>();
    for (const q of questionRows ?? []) {
      const list = questionsByTopic.get(q.topic_id) ?? [];
      list.push({
        id: q.id,
        topic_id: q.topic_id,
        question_text: q.question_text,
        difficulty: q.difficulty ?? 2,
        exam_type: (q.exam_type ?? 'GENERAL') as ExamType,
        explanation: q.explanation ?? '',
        exam_shortcut: q.exam_shortcut ?? undefined,
        options: [],
      });
      questionsByTopic.set(q.topic_id, list);
    }

    const merged: Topic[] = topicRows.map((t) => ({
      id: t.id,
      title: t.title,
      class_level: t.class_level,
      description: t.description ?? '',
      order_index: t.order_index ?? 1,
      icon: t.icon ?? 'Calculator',
      lessons: [],
      questions: questionsByTopic.get(t.id) ?? [],
    }));

    setTopics(merged);
    setUploadTopicId((prev) => (merged.some((t) => t.id === prev) ? prev : (merged[0]?.id ?? '')));
    setNewTopicId((prev) => (merged.some((t) => t.id === prev) ? prev : (merged[0]?.id ?? '')));
  }, []);

  useEffect(() => {
    // Load-on-mount effect — same justified suppression as the
    // Pending Review tab's load-on-visible effect below.
    // eslint-disable-next-line react-hooks/set-state-in-effect
    loadAuthoredContent();
  }, [loadAuthoredContent]);

  const handleUploadSubmit = async (e: React.FormEvent) => {
    e.preventDefault();
    if (!uploadFile) return;

    setUploading(true);
    setUploadMessage(null);

    const formData = new FormData();
    formData.append('file', uploadFile);
    formData.append('topic_id', uploadTopicId);
    formData.append('question_count', String(uploadQuestionCount));

    try {
      const res = await fetch('/api/content/ingest', { method: 'POST', body: formData });
      const json = await res.json();
      if (!res.ok) {
        setUploadMessage({ type: 'error', text: json.error ?? 'Upload failed' });
      } else {
        setUploadMessage({
          type: 'success',
          text: json.warning ?? 'Uploaded — parsing and generating in the background. Check the Pending Review tab shortly.',
        });
        setUploadFile(null);
      }
    } catch {
      setUploadMessage({ type: 'error', text: 'Network error while uploading' });
    } finally {
      setUploading(false);
    }
  };

  // --- Pending Review ---
  const [pendingUploads, setPendingUploads] = useState<ContentUpload[]>([]);
  const [loadingUploads, setLoadingUploads] = useState(false);
  const [selectedUpload, setSelectedUpload] = useState<ContentUpload | null>(null);
  const [draftQuestions, setDraftQuestions] = useState<DraftQuestion[]>([]);

  const loadPendingUploads = useCallback(async () => {
    const supabase = createClient();
    if (!supabase) return;
    setLoadingUploads(true);
    const { data } = await supabase
      .from('content_uploads')
      .select('id, original_filename, status, error_message, generated_question_ids, generated_worked_example_ids, created_at')
      .in('status', ['pending', 'parsing', 'generating', 'ready_for_review', 'failed'])
      .order('created_at', { ascending: false });
    setPendingUploads(data ?? []);
    setLoadingUploads(false);
  }, []);

  useEffect(() => {
    // Re-fetch when the tab is switched to — the standard "load on
    // becoming visible" effect pattern; see useOfflineFlush.ts for the
    // same justified suppression on this rule.
    // eslint-disable-next-line react-hooks/set-state-in-effect
    if (activeTab === 'review') loadPendingUploads();
  }, [activeTab, loadPendingUploads]);

  const openUploadForReview = async (upload: ContentUpload) => {
    setSelectedUpload(upload);
    setDraftQuestions([]);
    if (upload.generated_question_ids.length === 0) return;

    const supabase = createClient();
    if (!supabase) return;
    const { data } = await supabase
      .from('questions')
      .select('id, question_text, option_a, option_b, option_c, option_d, correct_letter, explanation, exam_shortcut')
      .in('id', upload.generated_question_ids);
    setDraftQuestions(data ?? []);
  };

  const reviewQuestion = async (id: string, decision: 'published' | 'rejected') => {
    const supabase = createClient();
    if (!supabase) return;
    await supabase.from('questions').update({ status: decision }).eq('id', id);
    setDraftQuestions((prev) => prev.filter((q) => q.id !== id));
    // A newly-published question should show up under Authored Content
    // without waiting for the next tab switch/reload.
    if (decision === 'published') loadAuthoredContent();
  };

  const handleAddQuestion = async (e: React.FormEvent) => {
    e.preventDefault();
    if (!newQuestionText.trim() || !newTopicId) return;

    const supabase = createClient();
    if (!supabase) {
      setSaveQuestionError('Not connected to Supabase.');
      return;
    }

    setSavingQuestion(true);
    setSaveQuestionError(null);

    const { data, error } = await supabase
      .from('questions')
      .insert({
        topic_id: newTopicId,
        question_text: newQuestionText,
        option_a: newOptionA,
        option_b: newOptionB,
        option_c: newOptionC,
        option_d: newOptionD,
        correct_letter: newCorrectLetter,
        explanation: newExplanation,
        exam_shortcut: newShortcut || null,
        exam_type: 'WAEC',
        status: 'published',
      })
      .select('id, topic_id, question_text, explanation, exam_type, exam_shortcut, difficulty')
      .single();

    setSavingQuestion(false);

    if (error || !data) {
      setSaveQuestionError(error?.message ?? 'Failed to save question.');
      return;
    }

    setTopics((prev) =>
      prev.map((t) =>
        t.id === data.topic_id
          ? {
              ...t,
              questions: [
                ...t.questions,
                {
                  id: data.id,
                  topic_id: data.topic_id,
                  question_text: data.question_text,
                  difficulty: data.difficulty ?? 2,
                  exam_type: (data.exam_type ?? 'WAEC') as ExamType,
                  explanation: data.explanation ?? '',
                  exam_shortcut: data.exam_shortcut ?? undefined,
                  options: [],
                },
              ],
            }
          : t
      )
    );

    setNewQuestionText('');
    setNewExplanation('');
    setNewShortcut('');
    setNewOptionA('');
    setNewOptionB('');
    setNewOptionC('');
    setNewOptionD('');
    setNewCorrectLetter('A');
    setShowQuestionModal(false);
  };

  return (
    <div className="min-h-screen bg-slate-50 dark:bg-slate-950 text-slate-900 dark:text-slate-100 flex flex-col">
      <Navbar currentRole="super_admin" userName="Dr. Adebayo Admin" />

      <main className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 py-8 w-full">
        {/* Header */}
        <div className="flex flex-col sm:flex-row sm:items-center justify-between gap-4 mb-8">
          <div>
            <div className="inline-flex items-center gap-1.5 px-3 py-1 rounded-full bg-indigo-50 dark:bg-indigo-950 text-indigo-600 dark:text-indigo-400 text-xs font-semibold">
              <ShieldCheck className="w-3.5 h-3.5" /> Content Admin & Curriculum Control
            </div>
            <h1 className="text-2xl sm:text-3xl font-extrabold text-slate-900 dark:text-white mt-1">
              Curriculum & Question Bank Engine
            </h1>
          </div>

          {activeTab === 'authored' && (
            <button
              onClick={() => setShowQuestionModal(true)}
              className="px-5 py-2.5 rounded-2xl bg-gradient-to-r from-indigo-600 to-cyan-600 hover:from-indigo-500 hover:to-cyan-500 text-white font-bold text-xs shadow-md flex items-center gap-2 transition-all transform hover:-translate-y-0.5"
            >
              <Plus className="w-4 h-4" /> Add WAEC Question
            </button>
          )}
        </div>

        {/* Tabs */}
        <div className="flex items-center gap-2 mb-8 border-b border-slate-200 dark:border-slate-800">
          {([
            { key: 'authored', label: 'Authored Content' },
            { key: 'upload', label: 'Upload & AI-Generate' },
            { key: 'review', label: 'Pending Review' },
          ] as const).map((tab) => (
            <button
              key={tab.key}
              onClick={() => setActiveTab(tab.key)}
              className={`px-4 py-2.5 text-xs font-bold border-b-2 transition-colors ${
                activeTab === tab.key
                  ? 'border-indigo-600 text-indigo-600 dark:text-indigo-400'
                  : 'border-transparent text-slate-500 hover:text-slate-700 dark:hover:text-slate-300'
              }`}
            >
              {tab.label}
            </button>
          ))}
        </div>

        {/* Upload & AI-Generate Tab */}
        {activeTab === 'upload' && (
          <div className="max-w-xl">
            <div className="glass-card rounded-3xl p-6 border border-slate-200 dark:border-slate-800">
              <div className="flex items-center gap-3 mb-4">
                <Upload className="w-5 h-5 text-indigo-500" />
                <h2 className="text-lg font-bold text-slate-900 dark:text-white">Upload PDF/DOCX to Generate Content</h2>
              </div>
              <p className="text-xs text-slate-500 mb-5">
                Parsed with Docling, then sent to an LLM to draft questions and worked examples. Nothing generated
                here reaches students until you approve it in Pending Review.
              </p>

              <form onSubmit={handleUploadSubmit} className="space-y-4">
                <div>
                  <label className="block text-xs font-bold uppercase text-slate-500 mb-1">Topic</label>
                  <select
                    value={uploadTopicId}
                    onChange={(e) => setUploadTopicId(e.target.value)}
                    className="w-full px-4 py-2.5 rounded-xl border border-slate-300 dark:border-slate-700 bg-slate-50 dark:bg-slate-800 text-sm"
                  >
                    {topics.map((t) => (
                      <option key={t.id} value={t.id}>
                        {t.title}
                      </option>
                    ))}
                  </select>
                </div>

                <div>
                  <label className="block text-xs font-bold uppercase text-slate-500 mb-1">Number of Questions</label>
                  <input
                    type="number"
                    min={1}
                    max={50}
                    value={uploadQuestionCount}
                    onChange={(e) => setUploadQuestionCount(Number(e.target.value))}
                    className="w-full px-4 py-2.5 rounded-xl border border-slate-300 dark:border-slate-700 bg-slate-50 dark:bg-slate-800 text-sm"
                  />
                </div>

                <div>
                  <label className="block text-xs font-bold uppercase text-slate-500 mb-1">File (PDF or DOCX, max 25MB)</label>
                  <input
                    type="file"
                    accept=".pdf,.docx,application/pdf,application/vnd.openxmlformats-officedocument.wordprocessingml.document"
                    onChange={(e) => setUploadFile(e.target.files?.[0] ?? null)}
                    className="w-full text-sm text-slate-600 dark:text-slate-400 file:mr-4 file:py-2 file:px-4 file:rounded-xl file:border-0 file:text-xs file:font-bold file:bg-indigo-50 dark:file:bg-indigo-950 file:text-indigo-600"
                  />
                </div>

                {uploadMessage && (
                  <div
                    className={`flex items-start gap-2 rounded-xl px-3 py-2.5 text-xs ${
                      uploadMessage.type === 'success'
                        ? 'bg-emerald-50 dark:bg-emerald-950/60 text-emerald-700 dark:text-emerald-300'
                        : 'bg-rose-50 dark:bg-rose-950/60 text-rose-700 dark:text-rose-300'
                    }`}
                  >
                    {uploadMessage.type === 'success' ? (
                      <CheckCircle2 className="w-4 h-4 flex-shrink-0 mt-0.5" />
                    ) : (
                      <AlertCircle className="w-4 h-4 flex-shrink-0 mt-0.5" />
                    )}
                    <span>{uploadMessage.text}</span>
                  </div>
                )}

                <button
                  type="submit"
                  disabled={!uploadFile || uploading}
                  className="w-full px-5 py-3 rounded-xl bg-indigo-600 text-white font-bold text-sm hover:bg-indigo-500 disabled:opacity-50 flex items-center justify-center gap-2"
                >
                  {uploading ? (
                    <>
                      <Loader2 className="w-4 h-4 animate-spin" /> Uploading…
                    </>
                  ) : (
                    'Upload & Generate'
                  )}
                </button>
              </form>
            </div>
          </div>
        )}

        {/* Pending Review Tab */}
        {activeTab === 'review' && (
          <div className="grid grid-cols-1 lg:grid-cols-3 gap-6">
            <div className="lg:col-span-1 space-y-3">
              {loadingUploads && <Loader2 className="w-5 h-5 text-slate-500 dark:text-slate-400 animate-spin" />}
              {!loadingUploads && pendingUploads.length === 0 && (
                <p className="text-xs text-slate-500">No uploads yet.</p>
              )}
              {pendingUploads.map((upload) => (
                <button
                  key={upload.id}
                  onClick={() => openUploadForReview(upload)}
                  className={`w-full text-left p-4 rounded-2xl border transition-colors ${
                    selectedUpload?.id === upload.id
                      ? 'border-indigo-500 bg-indigo-50 dark:bg-indigo-950/40'
                      : 'border-slate-200 dark:border-slate-800 bg-white dark:bg-slate-900 hover:border-indigo-300'
                  }`}
                >
                  <div className="flex items-center gap-2 mb-1">
                    <FileText className="w-4 h-4 text-slate-500 dark:text-slate-400 flex-shrink-0" />
                    <span className="text-sm font-bold text-slate-800 dark:text-slate-200 truncate">{upload.original_filename}</span>
                  </div>
                  <span
                    className={`text-[10px] font-bold uppercase px-2 py-0.5 rounded ${
                      upload.status === 'ready_for_review'
                        ? 'bg-amber-100 dark:bg-amber-950 text-amber-700 dark:text-amber-400'
                        : upload.status === 'failed'
                          ? 'bg-rose-100 dark:bg-rose-950 text-rose-700 dark:text-rose-400'
                          : 'bg-slate-100 dark:bg-slate-800 text-slate-500'
                    }`}
                  >
                    {upload.status.replace(/_/g, ' ')}
                  </span>
                  {upload.error_message && <p className="text-[11px] text-rose-500 mt-1">{upload.error_message}</p>}
                </button>
              ))}
            </div>

            <div className="lg:col-span-2 space-y-4">
              {!selectedUpload && <p className="text-xs text-slate-500">Select an upload to review its generated questions.</p>}
              {selectedUpload && draftQuestions.length === 0 && selectedUpload.generated_question_ids.length > 0 && (
                <Loader2 className="w-5 h-5 text-slate-500 dark:text-slate-400 animate-spin" />
              )}
              {selectedUpload && selectedUpload.generated_question_ids.length === 0 && (
                <p className="text-xs text-slate-500">This upload hasn&apos;t generated any questions yet (still processing, or it failed).</p>
              )}
              {draftQuestions.map((q) => (
                <div key={q.id} className="bg-white dark:bg-slate-900 rounded-2xl p-4 border border-slate-200 dark:border-slate-800">
                  <MathRenderer content={q.question_text} className="text-sm font-semibold text-slate-800 dark:text-slate-100 mb-3" />
                  <div className="grid grid-cols-1 sm:grid-cols-2 gap-2 mb-3">
                    {(['A', 'B', 'C', 'D'] as const).map((letter) => {
                      const text = { A: q.option_a, B: q.option_b, C: q.option_c, D: q.option_d }[letter];
                      const isCorrect = q.correct_letter === letter;
                      return (
                        <div
                          key={letter}
                          className={`text-xs rounded-lg px-3 py-2 border ${
                            isCorrect
                              ? 'border-emerald-400 bg-emerald-50 dark:bg-emerald-950/40 text-emerald-700 dark:text-emerald-300 font-bold'
                              : 'border-slate-200 dark:border-slate-800 text-slate-600 dark:text-slate-400'
                          }`}
                        >
                          <span className="font-bold mr-1">{letter}.</span>
                          <MathRenderer content={text} className="inline" />
                        </div>
                      );
                    })}
                  </div>
                  <div className="text-xs text-slate-500 bg-slate-50 dark:bg-slate-950 p-3 rounded-xl border border-slate-100 dark:border-slate-800 mb-3">
                    <strong className="text-indigo-600">Explanation: </strong>
                    <MathRenderer content={q.explanation} className="inline" />
                  </div>
                  <div className="flex items-center justify-end gap-2">
                    <button
                      onClick={() => reviewQuestion(q.id, 'rejected')}
                      className="px-3 py-1.5 rounded-lg bg-rose-50 dark:bg-rose-950/60 text-rose-600 dark:text-rose-400 text-xs font-bold flex items-center gap-1 hover:bg-rose-100"
                    >
                      <X className="w-3.5 h-3.5" /> Reject
                    </button>
                    <button
                      onClick={() => reviewQuestion(q.id, 'published')}
                      className="px-3 py-1.5 rounded-lg bg-emerald-600 text-white text-xs font-bold flex items-center gap-1 hover:bg-emerald-500"
                    >
                      <Check className="w-3.5 h-3.5" /> Approve & Publish
                    </button>
                  </div>
                </div>
              ))}
            </div>
          </div>
        )}

        {/* Content Management Cards */}
        {activeTab === 'authored' && (
        <div className="space-y-6">
          {topicsLoading && <Loader2 className="w-5 h-5 text-slate-500 dark:text-slate-400 animate-spin" />}
          {!topicsLoading && topics.length === 0 && (
            <p className="text-xs text-slate-500">No topics yet — add one in Supabase&apos;s `topics` table first.</p>
          )}
          {topics.map((topic) => (
            <div key={topic.id} className="glass-card rounded-3xl p-6 border border-slate-200 dark:border-slate-800">
              <div className="flex items-center justify-between gap-4 mb-4 pb-4 border-b border-slate-100 dark:border-slate-800">
                <div>
                  <span className="text-[10px] font-bold uppercase tracking-wider px-2 py-0.5 rounded bg-indigo-50 dark:bg-indigo-950 text-indigo-600">
                    {topic.class_level}
                  </span>
                  <h2 className="text-xl font-bold text-slate-900 dark:text-white mt-1">
                    {topic.title}
                  </h2>
                </div>
                <span className="text-xs font-semibold px-3 py-1 rounded-full bg-slate-100 dark:bg-slate-800 text-slate-600 dark:text-slate-400">
                  {topic.questions.length} Authored Questions
                </span>
              </div>

              {/* Questions List */}
              <div className="space-y-4">
                {topic.questions.map((q, qIdx) => (
                  <div key={q.id} className="bg-white dark:bg-slate-900 rounded-2xl p-4 border border-slate-200 dark:border-slate-800">
                    <div className="flex items-start justify-between gap-2 mb-2">
                      <div className="flex items-center gap-2">
                        <span className="text-xs font-bold text-indigo-600 bg-indigo-50 dark:bg-indigo-950 px-2 py-0.5 rounded">
                          Q{qIdx + 1}
                        </span>
                        <span className="text-xs font-bold text-slate-500 uppercase">{q.exam_type}</span>
                      </div>
                      <span className="text-[10px] font-semibold text-emerald-600 bg-emerald-50 dark:bg-emerald-950 px-2 py-0.5 rounded">
                        Published
                      </span>
                    </div>

                    <MathRenderer content={q.question_text} className="text-sm font-semibold text-slate-800 dark:text-slate-100 mb-2" />

                    <div className="text-xs text-slate-500 bg-slate-50 dark:bg-slate-950 p-3 rounded-xl border border-slate-100 dark:border-slate-800">
                      <strong className="text-indigo-600">Explanation: </strong>
                      <MathRenderer content={q.explanation} className="inline" />
                    </div>
                  </div>
                ))}
              </div>
            </div>
          ))}
        </div>
        )}

        {/* Modal: Add Question */}
        {showQuestionModal && (
          <div className="fixed inset-0 z-50 flex items-center justify-center p-4 bg-slate-900/60 backdrop-blur-sm">
            <form onSubmit={handleAddQuestion} className="bg-white dark:bg-slate-900 rounded-2xl max-w-lg w-full p-6 shadow-2xl border border-slate-200 dark:border-slate-800">
              <h3 className="text-lg font-bold text-slate-900 dark:text-white mb-4">Author New WAEC Question</h3>

              <div className="space-y-4 max-h-[65vh] overflow-y-auto pr-1">
                <div>
                  <label className="block text-xs font-bold uppercase text-slate-500 mb-1">Topic</label>
                  <select
                    value={newTopicId}
                    onChange={(e) => setNewTopicId(e.target.value)}
                    className="w-full px-4 py-2.5 rounded-xl border border-slate-300 dark:border-slate-700 bg-slate-50 dark:bg-slate-800 text-sm"
                    required
                  >
                    <option value="" disabled>Select a topic…</option>
                    {topics.map((t) => (
                      <option key={t.id} value={t.id}>{t.title}</option>
                    ))}
                  </select>
                </div>

                <div>
                  <label className="block text-xs font-bold uppercase text-slate-500 mb-1">
                    Question Text (Markdown + LaTeX: $...$)
                  </label>
                  <textarea
                    rows={3}
                    placeholder="e.g. Solve for $x$: $x^2 - 5x + 6 = 0$"
                    value={newQuestionText}
                    onChange={(e) => setNewQuestionText(e.target.value)}
                    className="w-full px-4 py-2.5 rounded-xl border border-slate-300 dark:border-slate-700 bg-slate-50 dark:bg-slate-800 text-sm focus:outline-none focus:ring-2 focus:ring-indigo-500"
                    required
                  />
                </div>

                <div>
                  <label className="block text-xs font-bold uppercase text-slate-500 mb-1">Options — pick the correct one</label>
                  <div className="space-y-2">
                    {([
                      ['A', newOptionA, setNewOptionA],
                      ['B', newOptionB, setNewOptionB],
                      ['C', newOptionC, setNewOptionC],
                      ['D', newOptionD, setNewOptionD],
                    ] as const).map(([letter, value, setValue]) => (
                      <div key={letter} className="flex items-center gap-2">
                        <button
                          type="button"
                          onClick={() => setNewCorrectLetter(letter)}
                          title={`Mark ${letter} as the correct option`}
                          className={`flex-shrink-0 w-7 h-7 rounded-lg text-xs font-bold border-2 flex items-center justify-center transition-colors ${
                            newCorrectLetter === letter
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
                          className="flex-1 px-4 py-2 rounded-xl border border-slate-300 dark:border-slate-700 bg-slate-50 dark:bg-slate-800 text-sm focus:outline-none focus:ring-2 focus:ring-indigo-500"
                          required
                        />
                      </div>
                    ))}
                  </div>
                </div>

                <div>
                  <label className="block text-xs font-bold uppercase text-slate-500 mb-1">
                    Step-by-Step Explanation
                  </label>
                  <textarea
                    rows={2}
                    placeholder="Factor into $(x-2)(x-3) = 0$..."
                    value={newExplanation}
                    onChange={(e) => setNewExplanation(e.target.value)}
                    className="w-full px-4 py-2.5 rounded-xl border border-slate-300 dark:border-slate-700 bg-slate-50 dark:bg-slate-800 text-sm focus:outline-none focus:ring-2 focus:ring-indigo-500"
                    required
                  />
                </div>

                <div>
                  <label className="block text-xs font-bold uppercase text-slate-500 mb-1">
                    WAEC Exam Shortcut / Technique
                  </label>
                  <input
                    type="text"
                    placeholder="Product of roots is 6..."
                    value={newShortcut}
                    onChange={(e) => setNewShortcut(e.target.value)}
                    className="w-full px-4 py-2.5 rounded-xl border border-slate-300 dark:border-slate-700 bg-slate-50 dark:bg-slate-800 text-sm focus:outline-none focus:ring-2 focus:ring-indigo-500"
                  />
                </div>

                {saveQuestionError && (
                  <div className="flex items-start gap-2 rounded-xl px-3 py-2.5 text-xs bg-rose-50 dark:bg-rose-950/60 text-rose-700 dark:text-rose-300">
                    <AlertCircle className="w-4 h-4 flex-shrink-0 mt-0.5" />
                    <span>{saveQuestionError}</span>
                  </div>
                )}
              </div>

              <div className="flex items-center justify-end gap-3 pt-6">
                <button
                  type="button"
                  onClick={() => setShowQuestionModal(false)}
                  className="px-4 py-2 text-xs font-semibold text-slate-500 hover:text-slate-700"
                >
                  Cancel
                </button>
                <button
                  type="submit"
                  disabled={savingQuestion || !newTopicId}
                  className="px-5 py-2.5 rounded-xl bg-indigo-600 text-white font-bold text-xs hover:bg-indigo-500 disabled:opacity-50 shadow-md flex items-center gap-2"
                >
                  {savingQuestion && <Loader2 className="w-3.5 h-3.5 animate-spin" />}
                  Save to Question Bank
                </button>
              </div>
            </form>
          </div>
        )}
      </main>
    </div>
  );
}
