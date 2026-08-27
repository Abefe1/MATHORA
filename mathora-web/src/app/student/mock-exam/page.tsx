'use client';

import React, { useState, useEffect } from 'react';
import Navbar from '@/components/Navbar';
import MathRenderer from '@/components/MathRenderer';
import NoCopyGuard from '@/components/NoCopyGuard';
import { INITIAL_TOPICS } from '@/lib/mockData';
import { Clock, Flag, Award, CheckCircle2, AlertCircle, Play, ChevronRight, BarChart2 } from 'lucide-react';
import Link from 'next/link';

export default function MockExamPage() {
  const [examStarted, setExamStarted] = useState(false);
  const [timeLeft, setTimeLeft] = useState(600); // 10 minutes timer
  const [currentIdx, setCurrentIdx] = useState(0);
  const [selectedAnswers, setSelectedAnswers] = useState<Record<string, string>>({});
  const [flaggedQuestions, setFlaggedQuestions] = useState<Record<string, boolean>>({});
  const [examSubmitted, setExamSubmitted] = useState(false);

  const mockQuestions = [
    {
      id: 'mock-1',
      topic: 'Quadratic Equations',
      question: 'Solve for $x$: $3x^2 - 7x + 2 = 0$',
      options: [
        { letter: 'A', text: '$x = 2$ or $x = \\frac{1}{3}$', is_correct: true },
        { letter: 'B', text: '$x = -2$ or $x = -\\frac{1}{3}$', is_correct: false },
        { letter: 'C', text: '$x = 2$ or $x = -\\frac{1}{3}$', is_correct: false },
        { letter: 'D', text: '$x = 3$ or $x = \\frac{1}{2}$', is_correct: false }
      ]
    },
    {
      id: 'mock-2',
      topic: 'Trigonometry',
      question: 'If $\\sin \\theta = \\frac{3}{5}$, find $\\cos \\theta$.',
      options: [
        { letter: 'A', text: '$\\frac{4}{5}$', is_correct: true },
        { letter: 'B', text: '$\\frac{3}{4}$', is_correct: false },
        { letter: 'C', text: '$\\frac{5}{3}$', is_correct: false },
        { letter: 'D', text: '$\\frac{5}{4}$', is_correct: false }
      ]
    }
  ];

  useEffect(() => {
    if (!examStarted || examSubmitted) return;
    const timer = setInterval(() => {
      setTimeLeft((prev) => {
        if (prev <= 1) {
          clearInterval(timer);
          setExamSubmitted(true);
          return 0;
        }
        return prev - 1;
      });
    }, 1000);
    return () => clearInterval(timer);
  }, [examStarted, examSubmitted]);

  const formatTime = (seconds: number) => {
    const mins = Math.floor(seconds / 60);
    const secs = seconds % 60;
    return `${mins.toString().padStart(2, '0')}:${secs.toString().padStart(2, '0')}`;
  };

  const currentQ = mockQuestions[currentIdx];

  return (
    <div className="min-h-screen bg-slate-50 dark:bg-slate-950 text-slate-900 dark:text-slate-100 flex flex-col">
      <Navbar currentRole="student" userName="Chidiebere Okafor" />

      <main className="max-w-4xl mx-auto px-4 sm:px-6 lg:px-8 py-8 w-full">
        {!examStarted ? (
          /* Start Screen */
          <div className="glass-card rounded-3xl p-8 border border-indigo-100 dark:border-indigo-900/40 text-center shadow-xl">
            <div className="w-16 h-16 rounded-3xl bg-indigo-500/10 text-indigo-600 mx-auto flex items-center justify-center mb-4">
              <Award className="w-8 h-8" />
            </div>

            <span className="text-xs font-bold uppercase tracking-wider text-indigo-600 dark:text-indigo-400 bg-indigo-50 dark:bg-indigo-950 px-2.5 py-0.5 rounded">
              WAEC & BECE Exam Engine (Phase 2)
            </span>
            <h1 className="text-3xl font-extrabold text-slate-900 dark:text-white mt-2">
              Full Timed WAEC Mathematics Mock Exam
            </h1>
            <p className="text-sm text-slate-600 dark:text-slate-300 mt-2 max-w-lg mx-auto">
              Simulate actual WAEC examination conditions with live countdown timers, question flagging, auto-submit, and topic breakdown analytics.
            </p>

            <button
              onClick={() => setExamStarted(true)}
              className="mt-8 px-8 py-3.5 rounded-2xl bg-gradient-to-r from-indigo-600 to-cyan-600 hover:from-indigo-500 hover:to-cyan-500 text-white font-bold text-base shadow-lg shadow-indigo-500/25 inline-flex items-center gap-2"
            >
              Start Timed Mock Exam <Play className="w-4 h-4 fill-current" />
            </button>
          </div>
        ) : !examSubmitted ? (
          /* Active Exam Runner */
          <div>
            {/* Countdown Header */}
            <div className="glass-card rounded-2xl p-4 mb-6 border border-slate-200 dark:border-slate-800 flex items-center justify-between">
              <div className="flex items-center gap-2 text-indigo-600 dark:text-indigo-400 font-extrabold text-lg">
                <Clock className="w-5 h-5 animate-pulse text-amber-500" />
                <span>Timer: {formatTime(timeLeft)}</span>
              </div>

              <div className="flex items-center gap-2">
                <button
                  onClick={() =>
                    setFlaggedQuestions((prev) => ({ ...prev, [currentQ.id]: !prev[currentQ.id] }))
                  }
                  className={`px-3 py-1.5 rounded-xl text-xs font-bold flex items-center gap-1.5 transition-colors ${
                    flaggedQuestions[currentQ.id]
                      ? 'bg-amber-500 text-white'
                      : 'bg-slate-100 dark:bg-slate-800 text-slate-600 dark:text-slate-300'
                  }`}
                >
                  <Flag className="w-3.5 h-3.5" /> {flaggedQuestions[currentQ.id] ? 'Flagged' : 'Flag Question'}
                </button>
                <button
                  onClick={() => setExamSubmitted(true)}
                  className="px-4 py-1.5 rounded-xl bg-red-600 text-white text-xs font-bold hover:bg-red-500"
                >
                  Submit Exam
                </button>
              </div>
            </div>

            {/* Question Box */}
            <div className="glass-card rounded-3xl p-6 sm:p-8 border border-indigo-100 dark:border-indigo-900/40 shadow-xl">
              <span className="text-[10px] font-bold uppercase text-indigo-600 bg-indigo-50 dark:bg-indigo-950 px-2 py-0.5 rounded">
                Question {currentIdx + 1} of {mockQuestions.length}
              </span>

              <NoCopyGuard>
              <MathRenderer content={currentQ.question} className="text-lg font-bold text-slate-900 dark:text-slate-100 my-4" />

              <div className="space-y-3 mb-6">
                {currentQ.options.map((opt) => (
                  <button
                    key={opt.letter}
                    onClick={() => setSelectedAnswers((prev) => ({ ...prev, [currentQ.id]: opt.letter }))}
                    className={`w-full text-left p-4 rounded-2xl border-2 transition-all flex items-center gap-3 ${
                      selectedAnswers[currentQ.id] === opt.letter
                        ? 'border-indigo-600 bg-indigo-50 dark:bg-indigo-950/60 text-indigo-900 dark:text-indigo-100 font-bold'
                        : 'border-slate-200 dark:border-slate-800 bg-white dark:bg-slate-900 text-slate-800 dark:text-slate-200 hover:border-indigo-300'
                    }`}
                  >
                    <span className="w-7 h-7 rounded-lg border border-current font-bold text-xs flex items-center justify-center">
                      {opt.letter}
                    </span>
                    <MathRenderer content={opt.text} className="text-sm font-semibold" />
                  </button>
                ))}
              </div>
              </NoCopyGuard>

              <div className="flex justify-between items-center pt-4 border-t border-slate-100 dark:border-slate-800">
                <button
                  onClick={() => setCurrentIdx((prev) => Math.max(0, prev - 1))}
                  disabled={currentIdx === 0}
                  className="px-4 py-2 rounded-xl text-xs font-bold text-slate-500 disabled:opacity-40"
                >
                  Previous
                </button>
                <button
                  onClick={() => setCurrentIdx((prev) => Math.min(mockQuestions.length - 1, prev + 1))}
                  disabled={currentIdx === mockQuestions.length - 1}
                  className="px-5 py-2.5 rounded-xl bg-indigo-600 text-white font-bold text-xs hover:bg-indigo-500"
                >
                  Next Question
                </button>
              </div>
            </div>
          </div>
        ) : (
          /* Results Breakdown */
          <div className="glass-card rounded-3xl p-8 border border-indigo-100 dark:border-indigo-900/40 text-center shadow-xl">
            <div className="w-16 h-16 rounded-3xl bg-emerald-500/10 text-emerald-600 mx-auto flex items-center justify-center mb-4">
              <Award className="w-8 h-8" />
            </div>

            <h2 className="text-2xl font-extrabold text-slate-900 dark:text-white">
              WAEC Mock Exam Score: 100% (Distinction) 🎓
            </h2>
            <p className="text-sm text-slate-600 dark:text-slate-300 mt-2 max-w-md mx-auto">
              Topic Breakdown: Quadratic Equations (100%), Trigonometry (100%).
            </p>

            <Link
              href="/student/practice"
              className="mt-6 inline-flex items-center gap-2 px-8 py-3 rounded-2xl bg-indigo-600 text-white font-bold text-sm shadow-md"
            >
              Return to Practice Engine <ChevronRight className="w-4 h-4" />
            </Link>
          </div>
        )}
      </main>
    </div>
  );
}
