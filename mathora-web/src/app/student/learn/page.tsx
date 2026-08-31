'use client';

import React, { useEffect, useMemo, useState } from 'react';
import Navbar from '@/components/Navbar';
import MathRenderer from '@/components/MathRenderer';
import StepByStepSolution from '@/components/StepByStepSolution';
import DiagramRenderer from '@/components/diagrams/DiagramRenderer';
import { fetchTopics, fetchWorkedExamples } from '@/lib/supabase';
import type { Topic, WorkedExample, ClassLevel } from '@/lib/types';
import { BookOpen, Sparkles, ChevronRight, AlertTriangle, Lightbulb, Play, MapPin } from 'lucide-react';
import Link from 'next/link';

// The live `topics` table doesn't carry nested lessons (fetchTopics is a
// plain `select *`, unlike the mock INITIAL_TOPICS fixture), so worked
// examples are fetched per-topic on demand instead of expecting them
// pre-attached. content_body still needs its own home; until lessons
// carry a fetchable-by-topic accessor of their own, the topic's own
// description stands in as the lesson summary shown here.
//
// TODO: default class level is hardcoded to SS1 (the level currently
// being populated with real content, mathora_seed_ss1_term*_content.sql)
// until the student's own current_level is threaded through authContext.
const DEFAULT_LEVEL: ClassLevel = 'SS1';
const TERM_LABELS: Record<number, string> = { 1: 'First Term', 2: 'Second Term', 3: 'Third Term' };

export default function LearnPage() {
  const [topics, setTopics] = useState<Topic[]>([]);
  const [loading, setLoading] = useState(true);
  const [selectedTopicId, setSelectedTopicId] = useState<string | null>(null);
  const [activeTerm, setActiveTerm] = useState<number>(1);
  const [workedExamples, setWorkedExamples] = useState<WorkedExample[]>([]);
  const [examplesLoading, setExamplesLoading] = useState(false);

  useEffect(() => {
    fetchTopics().then((data) => {
      const levelTopics = data
        .filter((t) => t.class_level === DEFAULT_LEVEL)
        .sort((a, b) => a.order_index - b.order_index);
      setTopics(levelTopics.length > 0 ? levelTopics : data);
      const first = (levelTopics.length > 0 ? levelTopics : data)[0];
      if (first) {
        setSelectedTopicId(first.id);
        setActiveTerm(termOf(first));
      }
      setLoading(false);
    });
  }, []);

  const selectedTopic = useMemo(() => topics.find((t) => t.id === selectedTopicId) ?? null, [topics, selectedTopicId]);

  useEffect(() => {
    if (!selectedTopicId) return;
    setExamplesLoading(true);
    fetchWorkedExamples(selectedTopicId).then((examples) => {
      setWorkedExamples(examples);
      setExamplesLoading(false);
    });
  }, [selectedTopicId]);

  // Group by term (order_index encodes it as a hundreds digit, 1xx/2xx/3xx,
  // matching mathora_seed_topics_ss1_ss2_ss3.sql's convention) so a
  // 33-topic level renders as three manageable weekly lists instead of one
  // long flat sidebar.
  const termGroups = useMemo(() => {
    const groups = new Map<number, Topic[]>();
    for (const t of topics) {
      const term = termOf(t);
      if (!groups.has(term)) groups.set(term, []);
      groups.get(term)!.push(t);
    }
    return groups;
  }, [topics]);

  const topicsInActiveTerm = termGroups.get(activeTerm) ?? [];

  return (
    <div className="min-h-screen bg-slate-50 dark:bg-slate-950 text-slate-900 dark:text-slate-100 flex flex-col">
      <Navbar currentRole="student" userName="Chidiebere Okafor" />

      <main className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 py-8 w-full">
        {/* Page Header */}
        <div className="mb-6">
          <span className="text-xs font-bold uppercase tracking-wider text-indigo-600 dark:text-indigo-400 bg-indigo-50 dark:bg-indigo-950 px-2.5 py-1 rounded-md">
            Nigerian {DEFAULT_LEVEL} Curriculum
          </span>
          <h1 className="text-2xl sm:text-3xl font-extrabold text-slate-900 dark:text-white mt-2">
            Curriculum Lessons &amp; Worked Examples
          </h1>
          <p className="text-sm text-slate-600 dark:text-slate-400">
            Simplified explanations, step-by-step worked solutions, and exam shortcuts, week by week.
          </p>
        </div>

        {/* Term tabs, horizontally scrollable on mobile rather than wrapping
            into a cramped multi-row block */}
        <div className="flex gap-2 mb-5 overflow-x-auto pb-1 -mx-1 px-1">
          {[1, 2, 3].map((term) => (
            <button
              key={term}
              onClick={() => setActiveTerm(term)}
              className={`flex-shrink-0 px-4 py-2 rounded-xl text-xs font-bold transition-all ${
                activeTerm === term
                  ? 'bg-indigo-600 text-white shadow-md shadow-indigo-500/20'
                  : 'bg-white dark:bg-slate-900 text-slate-600 dark:text-slate-400 border border-slate-200 dark:border-slate-800 hover:border-indigo-300'
              }`}
            >
              {TERM_LABELS[term] ?? `Term ${term}`}
              <span className="ml-1.5 opacity-70">({(termGroups.get(term) ?? []).length})</span>
            </button>
          ))}
        </div>

        {loading ? (
          <p className="text-sm text-slate-500 dark:text-slate-400">Loading curriculum...</p>
        ) : (
          <div className="grid grid-cols-1 lg:grid-cols-4 gap-8">
            {/* Topic Sidebar — a horizontally scrollable strip on mobile,
                a vertical list from lg: up. */}
            <div className="lg:col-span-1">
              <h2 className="text-xs font-bold uppercase tracking-wider text-slate-500 mb-2">
                {TERM_LABELS[activeTerm] ?? `Term ${activeTerm}`} &middot; Select a Week
              </h2>
              <div className="flex lg:flex-col gap-3 overflow-x-auto lg:overflow-visible pb-2 lg:pb-0 -mx-1 px-1 lg:mx-0 lg:px-0">
                {topicsInActiveTerm.map((topic, i) => {
                  const isSelected = topic.id === selectedTopicId;
                  return (
                    <button
                      key={topic.id}
                      onClick={() => setSelectedTopicId(topic.id)}
                      className={`flex-shrink-0 w-64 lg:w-auto text-left p-4 rounded-2xl border transition-all ${
                        isSelected
                          ? 'bg-gradient-to-r from-indigo-600 to-indigo-700 text-white border-indigo-600 shadow-md shadow-indigo-500/20'
                          : 'glass-card border-slate-200 dark:border-slate-800 text-slate-800 dark:text-slate-200 hover:border-indigo-300'
                      }`}
                    >
                      <span className={`text-[10px] font-bold uppercase px-2 py-0.5 rounded ${
                        isSelected ? 'bg-white/20 text-white' : 'bg-indigo-50 dark:bg-indigo-950 text-indigo-600'
                      }`}>
                        Week {i + 1}
                      </span>
                      <h3 className="font-bold text-sm mt-1.5 leading-snug">{topic.title}</h3>
                    </button>
                  );
                })}
              </div>
            </div>

            {/* Lesson Body & Worked Examples */}
            <div className="lg:col-span-3 space-y-6">
              {selectedTopic && (
                <div className="glass-card rounded-3xl p-6 sm:p-8 border border-slate-200 dark:border-slate-800">
                  <div className="flex flex-col sm:flex-row sm:items-center justify-between gap-4 mb-4 pb-4 border-b border-slate-200 dark:border-slate-800">
                    <div>
                      <h2 className="text-2xl font-extrabold text-slate-900 dark:text-white">
                        {selectedTopic.title}
                      </h2>
                      <p className="text-xs text-indigo-600 dark:text-indigo-400 font-medium mt-0.5">
                        {selectedTopic.description}
                      </p>
                    </div>

                    <Link
                      href={`/student/practice?topic=${selectedTopic.id}`}
                      className="px-5 py-2.5 rounded-xl bg-gradient-to-r from-indigo-600 to-cyan-600 hover:from-indigo-500 hover:to-cyan-500 text-white font-bold text-xs shadow-md flex items-center gap-1.5 flex-shrink-0 self-start sm:self-auto"
                    >
                      Start Topic Practice <Play className="w-3.5 h-3.5 fill-current" />
                    </Link>
                  </div>

                  {examplesLoading ? (
                    <p className="text-sm text-slate-500 dark:text-slate-400">Loading worked examples...</p>
                  ) : workedExamples.length === 0 ? (
                    <p className="text-sm text-slate-500 dark:text-slate-400 flex items-center gap-2">
                      <BookOpen className="w-4 h-4" /> No worked examples published for this week yet.
                    </p>
                  ) : (
                    workedExamples.map((ex, idx) => (
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
                            original document had one, see content-worker's parser.py) */}
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

                        {/* Step-by-Step Solution, revealed one step at a time */}
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
                    ))
                  )}
                </div>
              )}
            </div>
          </div>
        )}
      </main>
    </div>
  );
}

function termOf(topic: Topic): number {
  // order_index is seeded as a 3-digit "T followed by 2-digit week"
  // (101..109 = term 1, 201..210 = term 2, 301..314 = term 3), see
  // mathora_seed_topics_ss1_ss2_ss3.sql. Falls back to term 1 for any
  // fixture/mock topic whose order_index doesn't follow that convention.
  const term = Math.floor(topic.order_index / 100);
  return term >= 1 && term <= 3 ? term : 1;
}
