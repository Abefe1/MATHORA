'use client';

import React, { useState } from 'react';
import Navbar from '@/components/Navbar';
import MathRenderer from '@/components/MathRenderer';
import { INITIAL_TOPICS } from '@/lib/mockData';
import { ShieldCheck, Plus, BookOpen, Layers, CheckCircle2, AlertCircle, BarChart, Database } from 'lucide-react';

export default function AdminCMS() {
  const [topics, setTopics] = useState(INITIAL_TOPICS);
  const [showQuestionModal, setShowQuestionModal] = useState(false);
  const [newQuestionText, setNewQuestionText] = useState('');
  const [newExplanation, setNewExplanation] = useState('');
  const [newShortcut, setNewShortcut] = useState('');

  const handleAddQuestion = (e: React.FormEvent) => {
    e.preventDefault();
    if (!newQuestionText.trim()) return;

    const newQ = {
      id: `q-custom-${Date.now()}`,
      topic_id: 't-quadratics',
      question_text: newQuestionText,
      difficulty: 2,
      exam_type: 'WAEC' as const,
      explanation: newExplanation,
      exam_shortcut: newShortcut,
      options: [
        { letter: 'A' as const, text: '$x = 1$', is_correct: true },
        { letter: 'B' as const, text: '$x = 2$', is_correct: false },
        { letter: 'C' as const, text: '$x = 3$', is_correct: false },
        { letter: 'D' as const, text: '$x = 4$', is_correct: false }
      ]
    };

    setTopics((prev) => {
      const updated = [...prev];
      updated[0].questions.push(newQ);
      return updated;
    });

    setNewQuestionText('');
    setNewExplanation('');
    setNewShortcut('');
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

          <button
            onClick={() => setShowQuestionModal(true)}
            className="px-5 py-2.5 rounded-2xl bg-gradient-to-r from-indigo-600 to-cyan-600 hover:from-indigo-500 hover:to-cyan-500 text-white font-bold text-xs shadow-md flex items-center gap-2 transition-all transform hover:-translate-y-0.5"
          >
            <Plus className="w-4 h-4" /> Add WAEC Question
          </button>
        </div>

        {/* Content Management Cards */}
        <div className="space-y-6">
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

        {/* Modal: Add Question */}
        {showQuestionModal && (
          <div className="fixed inset-0 z-50 flex items-center justify-center p-4 bg-slate-900/60 backdrop-blur-sm">
            <form onSubmit={handleAddQuestion} className="bg-white dark:bg-slate-900 rounded-2xl max-w-lg w-full p-6 shadow-2xl border border-slate-200 dark:border-slate-800">
              <h3 className="text-lg font-bold text-slate-900 dark:text-white mb-4">Author New WAEC Question</h3>

              <div className="space-y-4">
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
                  className="px-5 py-2.5 rounded-xl bg-indigo-600 text-white font-bold text-xs hover:bg-indigo-500 shadow-md"
                >
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
