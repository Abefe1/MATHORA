'use client';

import React, { useEffect, useState } from 'react';
import Link from 'next/link';
import Navbar from '@/components/Navbar';
import { Card, Badge } from '@/components/ui/Primitives';
import ProgressRing from '@/components/ui/ProgressRing';
import { ArrowLeft, Flame, Target, CheckCircle2, TrendingUp } from 'lucide-react';
import {
  fetchMyStudentProfileId, fetchAnalysisStats, type AnalysisStats,
  fetchTopicScores, fetchTermSummaries, type TopicScore, type TermSummary,
} from '@/lib/supabase';
import { useAuth } from '@/lib/authContext';

const WEEKDAYS = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];

export default function StudentAnalysisPage() {
  const { user } = useAuth();
  const [stats, setStats] = useState<AnalysisStats | null>(null);
  const [topicScores, setTopicScores] = useState<TopicScore[]>([]);
  const [termSummaries, setTermSummaries] = useState<TermSummary[]>([]);
  const [loading, setLoading] = useState(true);
  const [selectedTerm, setSelectedTerm] = useState<1 | 2 | 3 | 'all'>('all');

  useEffect(() => {
    // Standard "load on mount" effect, same justified suppression used
    // for this pattern elsewhere (see admin/page.tsx, useOfflineFlush.ts).
    if (!user?.id) {
      // eslint-disable-next-line react-hooks/set-state-in-effect
      setLoading(false);
      return;
    }
    fetchMyStudentProfileId(user.id).then(async (profileId) => {
      if (!profileId) {
        setLoading(false);
        return;
      }
      const [data, topics, terms] = await Promise.all([
        fetchAnalysisStats(profileId),
        fetchTopicScores(profileId),
        fetchTermSummaries(profileId),
      ]);
      setStats(data);
      setTopicScores(topics);
      setTermSummaries(terms);
      setLoading(false);
    });
  }, [user?.id]);

  const s = stats ?? {
    totalAttempted: 0, totalCorrect: 0, currentStreakDays: 0, weeklyPracticedDays: 0,
    practicedWeekdayFlags: [false, false, false, false, false, false, false], overallMasteryPercentage: 0,
  };
  const incorrect = Math.max(0, s.totalAttempted - s.totalCorrect);
  const accuracyPct = s.totalAttempted > 0 ? Math.round((s.totalCorrect / s.totalAttempted) * 100) : 0;
  const visibleTopicScores = selectedTerm === 'all' ? topicScores : topicScores.filter((t) => t.term === selectedTerm);

  return (
    <div className="min-h-screen bg-slate-50 dark:bg-slate-950 text-slate-900 dark:text-slate-100 flex flex-col font-sans">
      <Navbar currentRole="student" userName="Chidiebere Okafor" />

      <main className="max-w-5xl mx-auto px-4 sm:px-6 lg:px-8 py-8 w-full">
        <Link href="/student" className="inline-flex items-center gap-1.5 text-xs font-mono font-bold text-amber-600 dark:text-amber-400 hover:underline mb-4">
          <ArrowLeft className="w-3.5 h-3.5" /> Return to Dashboard
        </Link>

        <div className="flex items-center justify-between gap-4 mb-8">
          <div>
            <Badge variant="mastered">Your Analysis</Badge>
            <h1 className="text-2xl sm:text-3xl font-display font-extrabold text-slate-900 dark:text-white mt-1">
              Practice &amp; Progress
            </h1>
          </div>
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

        {loading ? (
          <p className="text-sm text-slate-500 dark:text-slate-400">Loading your analysis...</p>
        ) : (
          <>
            <div className="grid grid-cols-1 md:grid-cols-2 gap-6 mb-6">
              {/* Weekly practice ring */}
              <Card variant="paper" className="p-6 flex flex-col items-center text-center">
                <h2 className="text-sm font-display font-bold text-slate-900 dark:text-white self-start mb-4">
                  This Week&apos;s Practice
                </h2>
                <ProgressRing
                  segments={[{ value: s.weeklyPracticedDays, color: 'accent' }]}
                  total={7}
                  centerLabel={`${s.weeklyPracticedDays}/7`}
                  centerSubLabel="days practiced"
                />
                <div className="grid grid-cols-2 gap-4 mt-6 w-full font-mono text-center">
                  <div>
                    <p className="text-[11px] text-slate-500 dark:text-slate-400">Current Streak</p>
                    <p className="text-lg font-extrabold text-amber-600 dark:text-amber-400 flex items-center justify-center gap-1">
                      <Flame className="w-4 h-4" /> {s.currentStreakDays} {s.currentStreakDays === 1 ? 'day' : 'days'}
                    </p>
                  </div>
                  <div>
                    <p className="text-[11px] text-slate-500 dark:text-slate-400">Overall Mastery</p>
                    <p className="text-lg font-extrabold text-slate-900 dark:text-white">{s.overallMasteryPercentage}%</p>
                  </div>
                </div>
              </Card>

              {/* Performance ring */}
              <Card variant="paper" className="p-6 flex flex-col items-center text-center">
                <h2 className="text-sm font-display font-bold text-slate-900 dark:text-white self-start mb-4">
                  Question Performance
                </h2>
                <ProgressRing
                  segments={[
                    { value: s.totalCorrect, color: 'correct' },
                    { value: incorrect, color: 'incorrect' },
                  ]}
                  centerLabel={s.totalAttempted > 0 ? `${accuracyPct}%` : '—'}
                  centerSubLabel="accuracy"
                />
                <div className="flex items-center justify-center gap-4 mt-6 font-mono text-[11px]">
                  <span className="flex items-center gap-1.5 text-slate-600 dark:text-slate-300">
                    <span className="w-2.5 h-2.5 rounded-full bg-emerald-500 inline-block" /> Correct
                  </span>
                  <span className="flex items-center gap-1.5 text-slate-600 dark:text-slate-300">
                    <span className="w-2.5 h-2.5 rounded-full bg-rose-500 inline-block" /> Incorrect
                  </span>
                </div>
              </Card>
            </div>

            {/* Stat tiles */}
            <div className="grid grid-cols-2 sm:grid-cols-4 gap-4">
              <Card variant="paper" className="p-4 text-center">
                <Target className="w-4 h-4 text-amber-600 dark:text-amber-400 mx-auto mb-1.5" />
                <p className="text-xl font-extrabold text-slate-900 dark:text-white">{s.totalAttempted}</p>
                <p className="text-[10px] font-mono text-slate-500 dark:text-slate-400 uppercase">Attempted</p>
              </Card>
              <Card variant="paper" className="p-4 text-center">
                <CheckCircle2 className="w-4 h-4 text-emerald-600 dark:text-emerald-400 mx-auto mb-1.5" />
                <p className="text-xl font-extrabold text-slate-900 dark:text-white">{s.totalCorrect}</p>
                <p className="text-[10px] font-mono text-slate-500 dark:text-slate-400 uppercase">Correct</p>
              </Card>
              <Card variant="paper" className="p-4 text-center">
                <Flame className="w-4 h-4 text-amber-600 dark:text-amber-400 mx-auto mb-1.5" />
                <p className="text-xl font-extrabold text-slate-900 dark:text-white">{s.currentStreakDays}</p>
                <p className="text-[10px] font-mono text-slate-500 dark:text-slate-400 uppercase">Streak (days)</p>
              </Card>
              <Card variant="paper" className="p-4 text-center">
                <TrendingUp className="w-4 h-4 text-indigo-600 dark:text-indigo-400 mx-auto mb-1.5" />
                <p className="text-xl font-extrabold text-slate-900 dark:text-white">{s.overallMasteryPercentage}%</p>
                <p className="text-[10px] font-mono text-slate-500 dark:text-slate-400 uppercase">Mastery</p>
              </Card>
            </div>

            {/* Weekday reference strip — purely a legend for "this week", not
                a 7-color rainbow: one accent color, dim for un-practiced days. */}
            <Card variant="paper" className="p-4 mt-6">
              <p className="text-[10px] font-mono font-bold uppercase text-slate-500 dark:text-slate-400 mb-3">This Week</p>
              <div className="flex justify-between gap-2 font-mono">
                {WEEKDAYS.map((day, i) => (
                  <div key={day} className="flex flex-col items-center gap-1.5 flex-1">
                    <span className="text-[10px] text-slate-500 dark:text-slate-400">{day}</span>
                    <span
                      className={`w-full aspect-square rounded-lg ${
                        s.practicedWeekdayFlags[i]
                          ? 'bg-amber-500'
                          : 'bg-slate-200 dark:bg-slate-800'
                      }`}
                    />
                  </div>
                ))}
              </div>
            </Card>

            {/* Cumulative per term */}
            {termSummaries.length > 0 && (
              <Card variant="paper" className="p-4 sm:p-6 mt-6">
                <p className="text-[10px] font-mono font-bold uppercase text-slate-500 dark:text-slate-400 mb-3">Cumulative by Term</p>
                <div className="grid grid-cols-1 sm:grid-cols-3 gap-3">
                  {termSummaries.map((t) => {
                    const termAccuracy = t.total_attempted > 0 ? Math.round((t.total_correct / t.total_attempted) * 100) : 0;
                    return (
                      <button
                        key={t.term}
                        type="button"
                        onClick={() => setSelectedTerm((prev) => (prev === t.term ? 'all' : (t.term as 1 | 2 | 3)))}
                        className={`text-left rounded-xl border p-4 transition-colors ${
                          selectedTerm === t.term
                            ? 'border-indigo-500 ring-1 ring-indigo-500'
                            : 'border-slate-200 dark:border-slate-800'
                        }`}
                      >
                        <p className="text-xs font-display font-bold text-slate-900 dark:text-white">Term {t.term}</p>
                        <p className="text-2xl font-extrabold text-indigo-600 dark:text-indigo-400 mt-1">{t.average_mastery_percentage}%</p>
                        <p className="text-[10px] font-mono text-slate-500 dark:text-slate-400 uppercase">avg. mastery</p>
                        <div className="flex justify-between text-[11px] font-mono text-slate-600 dark:text-slate-300 mt-3 pt-3 border-t border-slate-100 dark:border-slate-800">
                          <span>{t.topics_started} topics started</span>
                          <span>{termAccuracy}% accuracy</span>
                        </div>
                      </button>
                    );
                  })}
                </div>
              </Card>
            )}

            {/* Score per exercise/topic, in syllabus order */}
            {topicScores.length > 0 && (
              <Card variant="paper" className="p-4 sm:p-6 mt-6">
                <p className="text-[10px] font-mono font-bold uppercase text-slate-500 dark:text-slate-400 mb-3">
                  Score by Exercise{selectedTerm !== 'all' ? ` — Term ${selectedTerm}` : ''}
                </p>
                {visibleTopicScores.length === 0 && (
                  <p className="text-xs text-slate-500 dark:text-slate-400">No exercises for this term yet.</p>
                )}
                <div className="space-y-2 max-h-105 overflow-y-auto pr-1">
                  {visibleTopicScores.map((t) => {
                    const acc = t.total_attempted > 0 ? Math.round((t.total_correct / t.total_attempted) * 100) : 0;
                    return (
                      <div
                        key={t.topic_id}
                        className="flex items-center justify-between gap-3 rounded-lg px-3 py-2.5 bg-slate-50 dark:bg-slate-900/60"
                      >
                        <div className="min-w-0">
                          <p className="text-xs sm:text-sm font-semibold text-slate-900 dark:text-white truncate">{t.topic_title}</p>
                          <p className="text-[10px] font-mono text-slate-500 dark:text-slate-400">
                            {t.class_level}{t.term ? ` · Term ${t.term}` : ''} · {t.total_correct}/{t.total_attempted} correct
                          </p>
                        </div>
                        <span
                          className={`shrink-0 text-xs font-mono font-bold px-2 py-1 rounded-md ${
                            acc >= 70
                              ? 'bg-emerald-50 dark:bg-emerald-950/50 text-emerald-700 dark:text-emerald-300'
                              : acc >= 40
                              ? 'bg-amber-50 dark:bg-amber-950/50 text-amber-700 dark:text-amber-300'
                              : 'bg-rose-50 dark:bg-rose-950/50 text-rose-700 dark:text-rose-300'
                          }`}
                        >
                          {acc}%
                        </span>
                      </div>
                    );
                  })}
                </div>
              </Card>
            )}
          </>
        )}
      </main>
    </div>
  );
}
