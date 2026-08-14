'use client';

import React from 'react';
import Navbar from '@/components/Navbar';
import { INITIAL_TOPICS } from '@/lib/mockData';
import { Clock, Calendar, CheckCircle2, RotateCcw, ArrowRight, Sparkles } from 'lucide-react';
import Link from 'next/link';

export default function SpacedRevisionPage() {
  const scheduledRevisions = [
    {
      id: 'rev-1',
      topic: 'Quadratic Equations',
      intervalDay: 3,
      dueDate: 'Today',
      status: 'due',
      questionCount: 4
    },
    {
      id: 'rev-2',
      topic: 'Trigonometric Ratios',
      intervalDay: 7,
      dueDate: 'In 2 days',
      status: 'upcoming',
      questionCount: 3
    }
  ];

  return (
    <div className="min-h-screen bg-slate-50 dark:bg-slate-950 text-slate-900 dark:text-slate-100 flex flex-col">
      <Navbar currentRole="student" userName="Chidiebere Okafor" />

      <main className="max-w-4xl mx-auto px-4 sm:px-6 lg:px-8 py-8 w-full">
        {/* Header */}
        <div className="mb-8">
          <div className="inline-flex items-center gap-1.5 px-3 py-1 rounded-full bg-cyan-50 dark:bg-cyan-950 text-cyan-600 dark:text-cyan-400 text-xs font-semibold mb-2">
            <Clock className="w-3.5 h-3.5" /> Spaced Repetition Memory Engine (1d → 3d → 7d → 14d → 30d)
          </div>
          <h1 className="text-2xl sm:text-3xl font-extrabold text-slate-900 dark:text-white">
            Scheduled Topic Revision
          </h1>
          <p className="text-sm text-slate-600 dark:text-slate-400 mt-1">
            Science-backed spaced repetition intervals to move mathematical concepts into permanent memory before exams.
          </p>
        </div>

        {/* Revision Schedule Cards */}
        <div className="space-y-4">
          {scheduledRevisions.map((item) => (
            <div
              key={item.id}
              className={`glass-card rounded-2xl p-6 border transition-all flex flex-col sm:flex-row sm:items-center justify-between gap-4 ${
                item.status === 'due'
                  ? 'border-indigo-300 dark:border-indigo-700 bg-indigo-50/40 dark:bg-indigo-950/20'
                  : 'border-slate-200 dark:border-slate-800'
              }`}
            >
              <div>
                <div className="flex items-center gap-2">
                  <span className={`text-[10px] font-bold uppercase px-2 py-0.5 rounded ${
                    item.status === 'due'
                      ? 'bg-indigo-600 text-white'
                      : 'bg-slate-200 dark:bg-slate-800 text-slate-600 dark:text-slate-300'
                  }`}>
                    {item.status === 'due' ? 'Revision Due Now' : item.dueDate}
                  </span>
                  <span className="text-xs text-slate-500 font-semibold">
                    Interval: Day {item.intervalDay} Check
                  </span>
                </div>
                <h3 className="text-lg font-bold text-slate-900 dark:text-white mt-1">
                  {item.topic}
                </h3>
                <p className="text-xs text-slate-600 dark:text-slate-400 mt-0.5">
                  {item.questionCount} review questions to test long-term retention.
                </p>
              </div>

              <Link
                href="/student/practice"
                className={`px-5 py-2.5 rounded-xl font-bold text-xs flex items-center justify-center gap-1.5 flex-shrink-0 transition-all ${
                  item.status === 'due'
                    ? 'bg-indigo-600 hover:bg-indigo-500 text-white shadow-md shadow-indigo-500/20'
                    : 'bg-slate-100 dark:bg-slate-800 text-slate-600 dark:text-slate-300 hover:bg-indigo-600 hover:text-white'
                }`}
              >
                Start Revision <RotateCcw className="w-3.5 h-3.5" />
              </Link>
            </div>
          ))}
        </div>
      </main>
    </div>
  );
}
