'use client';

import React, { useState } from 'react';
import Navbar from '@/components/Navbar';
import MathRenderer from '@/components/MathRenderer';
import StepByStepSolution from '@/components/StepByStepSolution';
import DiagramRenderer from '@/components/diagrams/DiagramRenderer';
import { INITIAL_TOPICS } from '@/lib/mockData';
import { BookOpen, Sparkles, ChevronRight, AlertTriangle, Lightbulb, Play, MapPin } from 'lucide-react';
import Link from 'next/link';

export default function LearnPage() {
  const [selectedTopic, setSelectedTopic] = useState(INITIAL_TOPICS[0]);
  const activeLesson = selectedTopic.lessons[0];

  return (
    <div className="min-h-screen bg-slate-50 dark:bg-slate-950 text-slate-900 dark:text-slate-100 flex flex-col">
      <Navbar currentRole="student" userName="Chidiebere Okafor" />

      <main className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 py-8 w-full">
        {/* Page Header */}
        <div className="mb-6">
          <span className="text-xs font-bold uppercase tracking-wider text-indigo-600 dark:text-indigo-400 bg-indigo-50 dark:bg-indigo-950 px-2.5 py-1 rounded-md">
            Nigerian SS2 Curriculum
          </span>
          <h1 className="text-2xl sm:text-3xl font-extrabold text-slate-900 dark:text-white mt-2">
            Curriculum Lessons & Worked Examples
          </h1>
          <p className="text-sm text-slate-600 dark:text-slate-400">
            Simplified explanations, step-by-step worked solutions, and exam shortcuts.
          </p>
        </div>

        <div className="grid grid-cols-1 lg:grid-cols-4 gap-8">
          {/* Topic Sidebar */}
          <div className="lg:col-span-1 space-y-3">
            <h2 className="text-xs font-bold uppercase tracking-wider text-slate-500 mb-2">Select Topic</h2>
            {INITIAL_TOPICS.map((topic) => {
              const isSelected = topic.id === selectedTopic.id;
              return (
                <button
                  key={topic.id}
                  onClick={() => setSelectedTopic(topic)}
                  className={`w-full text-left p-4 rounded-2xl border transition-all ${
                    isSelected
                      ? 'bg-gradient-to-r from-indigo-600 to-indigo-700 text-white border-indigo-600 shadow-md shadow-indigo-500/20'
                      : 'glass-card border-slate-200 dark:border-slate-800 text-slate-800 dark:text-slate-200 hover:border-indigo-300'
                  }`}
                >
                  <span className={`text-[10px] font-bold uppercase px-2 py-0.5 rounded ${
                    isSelected ? 'bg-white/20 text-white' : 'bg-indigo-50 dark:bg-indigo-950 text-indigo-600'
                  }`}>
                    {topic.class_level}
                  </span>
                  <h3 className="font-bold text-sm mt-1.5 leading-snug">{topic.title}</h3>
                </button>
              );
            })}
          </div>

          {/* Lesson Body & Worked Examples */}
          <div className="lg:col-span-3 space-y-6">
            {activeLesson && (
              <div className="glass-card rounded-3xl p-6 sm:p-8 border border-slate-200 dark:border-slate-800">
                <div className="flex items-center justify-between gap-4 mb-4 pb-4 border-b border-slate-200 dark:border-slate-800">
                  <div>
                    <h2 className="text-2xl font-extrabold text-slate-900 dark:text-white">
                      {activeLesson.title}
                    </h2>
                    <p className="text-xs text-indigo-600 dark:text-indigo-400 font-medium mt-0.5">
                      {activeLesson.summary}
                    </p>
                  </div>

                  <Link
                    href={`/student/practice?topic=${selectedTopic.id}`}
                    className="px-5 py-2.5 rounded-xl bg-gradient-to-r from-indigo-600 to-cyan-600 hover:from-indigo-500 hover:to-cyan-500 text-white font-bold text-xs shadow-md flex items-center gap-1.5 flex-shrink-0"
                  >
                    Start Topic Practice <Play className="w-3.5 h-3.5 fill-current" />
                  </Link>
                </div>

                {/* Markdown + LaTeX Body */}
                <div className="prose prose-indigo max-w-none mb-8">
                  <MathRenderer content={activeLesson.content_body} />
                </div>

                {/* Worked Examples */}
                {activeLesson.worked_examples.map((ex, idx) => (
                  <div
                    key={idx}
                    className="bg-indigo-50/60 dark:bg-indigo-950/20 border border-indigo-100 dark:border-indigo-900/40 rounded-2xl p-5 mb-6"
                  >
                    <div className="flex items-center gap-2 mb-3">
                      <span className="w-6 h-6 rounded-lg bg-indigo-600 text-white text-xs font-extrabold flex items-center justify-center">
                        {idx + 1}
                      </span>
                      <h4 className="font-bold text-slate-900 dark:text-white text-base">
                        {ex.title}
                      </h4>
                    </div>

                    <div className="bg-white dark:bg-slate-900 rounded-xl p-4 border border-slate-200 dark:border-slate-800 mb-4">
                      <span className="text-xs font-bold text-indigo-600 uppercase tracking-wide">Problem:</span>
                      <MathRenderer content={ex.problem_statement} className="text-sm font-semibold text-slate-800 dark:text-slate-100 mt-1" />
                    </div>

    {/* Diagram (animated shape/graph, or an extracted source image when the
                    original document had one — see content-worker's parser.py) */}
                    <DiagramRenderer type={ex.diagram_type} data={ex.diagram_data} />

                    {/* Real-Life Application, when the generator found one worth including */}
                    {ex.real_life_context && (
                      <div className="bg-emerald-50 dark:bg-emerald-950/30 border border-emerald-200 dark:border-emerald-900/50 rounded-xl p-3 flex items-start gap-2 text-xs text-emerald-900 dark:text-emerald-200 mb-4">
                        <MapPin className="w-4 h-4 text-emerald-600 flex-shrink-0 mt-0.5" />
                        <div>
                          <strong className="font-bold uppercase tracking-wider">Real-Life Application:</strong>
                          <MathRenderer content={ex.real_life_context} className="mt-0.5" />
                        </div>
                      </div>
                    )}

                    {/* Step-by-Step Solution — revealed one step at a time */}
                    <div className="mb-4">
                      <StepByStepSolution steps={ex.solution_steps} />
                    </div>

                    {/* Shortcut & Warnings */}
                    {ex.exam_shortcut && (
                      <div className="bg-cyan-50 dark:bg-cyan-950/30 border border-cyan-200 dark:border-cyan-900/50 rounded-xl p-3 flex items-start gap-2 text-xs text-cyan-900 dark:text-cyan-200 mb-2">
                        <Sparkles className="w-4 h-4 text-cyan-600 flex-shrink-0 mt-0.5" />
                        <div>
                          <strong className="font-bold uppercase tracking-wider">Exam Shortcut:</strong>
                          <MathRenderer content={ex.exam_shortcut} className="mt-0.5" />
                        </div>
                      </div>
                    )}

                    {ex.common_trap_warning && (
                      <div className="bg-amber-50 dark:bg-amber-950/30 border border-amber-200 dark:border-amber-900/50 rounded-xl p-3 flex items-start gap-2 text-xs text-amber-900 dark:text-amber-200">
                        <AlertTriangle className="w-4 h-4 text-amber-600 flex-shrink-0 mt-0.5" />
                        <div>
                          <strong className="font-bold uppercase tracking-wider">Common Trap Warning:</strong>
                          <MathRenderer content={ex.common_trap_warning} className="mt-0.5" />
                        </div>
                      </div>
                    )}
                  </div>
                ))}
              </div>
            )}
          </div>
        </div>
      </main>
    </div>
  );
}
