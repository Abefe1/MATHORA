'use client';

import React, { useState } from 'react';
import { motion } from 'framer-motion';
import { CheckCircle2, RotateCcw, ArrowRight, GripVertical, Link2 } from 'lucide-react';
import { Card, Button } from './ui/Primitives';
import MathRenderer from './MathRenderer';
import type { Activity, OrderingActivityData, MatchingActivityData } from '@/lib/types';

// Renders one Activity (mathora_schema_activities_patch.sql) and reports
// a 0-100 score back via onComplete when the student finishes it.
//
// Tap-to-select rather than drag-and-drop for both activity_types
// below — matches student/practice/page.tsx's mobile-first,
// no-drag-required interaction model instead of adding a DnD library.
//
// fill_blank/classify aren't built yet (see the schema patch's
// activity_data comment for their intended shape) — this renders a
// "not yet supported" placeholder for those rather than crashing, so
// a topic can mix activity types before every player exists.
export default function ActivityPlayer({
  activity,
  onComplete,
}: {
  activity: Activity;
  onComplete: (result: { score: number; time_taken_seconds: number }) => void;
}) {
  const [startedAt] = useState(() => Date.now());

  const finish = (score: number) => {
    onComplete({ score, time_taken_seconds: Math.round((Date.now() - startedAt) / 1000) });
  };

  switch (activity.activity_data.activity_type) {
    case 'ordering':
      return <OrderingPlayer key={activity.id} data={activity.activity_data} title={activity.title} instructions={activity.instructions} onFinish={finish} />;
    case 'matching':
      return <MatchingPlayer key={activity.id} data={activity.activity_data} title={activity.title} instructions={activity.instructions} onFinish={finish} />;
    default:
      return (
        <Card className="text-center">
          <p className="text-sm text-slate-500 dark:text-slate-400">
            This activity type isn&apos;t supported in the app yet.
          </p>
        </Card>
      );
  }
}

function ActivityHeader({ title, instructions }: { title: string; instructions?: string | null }) {
  return (
    <div className="mb-6">
      <h2 className="text-lg font-extrabold text-slate-900 dark:text-white">{title}</h2>
      {instructions && (
        <p className="text-sm text-slate-600 dark:text-slate-400 mt-1">{instructions}</p>
      )}
    </div>
  );
}

// --- Ordering: tap items in the order you think is correct ---
function OrderingPlayer({
  data,
  title,
  instructions,
  onFinish,
}: {
  data: OrderingActivityData;
  title: string;
  instructions?: string | null;
  onFinish: (score: number) => void;
}) {
  // `picked` holds indices into data.items, in the order the student tapped them
  const [picked, setPicked] = useState<number[]>([]);
  const [submitted, setSubmitted] = useState(false);

  const remaining = data.items.map((_, i) => i).filter((i) => !picked.includes(i));
  const isComplete = picked.length === data.items.length;
  const correctCount = submitted
    ? picked.filter((idx, pos) => idx === data.correct_order[pos]).length
    : 0;

  const handlePick = (idx: number) => {
    if (submitted) return;
    setPicked((prev) => [...prev, idx]);
  };

  const handleReset = () => {
    setPicked([]);
    setSubmitted(false);
  };

  const handleSubmit = () => {
    setSubmitted(true);
  };

  const handleContinue = () => {
    const score = Math.round((picked.filter((idx, pos) => idx === data.correct_order[pos]).length / data.items.length) * 100);
    onFinish(score);
  };

  return (
    <Card>
      <ActivityHeader title={title} instructions={instructions ?? 'Tap the steps in the correct order.'} />

      {/* Your sequence so far */}
      <div className="flex flex-col gap-2 mb-4 min-h-[2.5rem]">
        {picked.map((idx, pos) => {
          const isRight = submitted && idx === data.correct_order[pos];
          const isWrong = submitted && idx !== data.correct_order[pos];
          return (
            <motion.div
              layout
              key={idx}
              className={`flex items-center gap-3 p-3 rounded-xl border-2 text-sm font-semibold ${
                isRight
                  ? 'border-emerald-500 bg-emerald-50 dark:bg-emerald-950/50 text-emerald-900 dark:text-emerald-200'
                  : isWrong
                  ? 'border-red-500 bg-red-50 dark:bg-red-950/50 text-red-900 dark:text-red-200'
                  : 'border-indigo-300 bg-indigo-50 dark:bg-indigo-950/40 text-indigo-900 dark:text-indigo-200'
              }`}
            >
              <span className="w-6 h-6 rounded-lg bg-white/70 dark:bg-black/20 font-extrabold text-xs flex items-center justify-center flex-shrink-0">
                {pos + 1}
              </span>
              <MathRenderer content={data.items[idx]} className="flex-1" />
              {isRight && <CheckCircle2 className="w-4 h-4 flex-shrink-0" />}
            </motion.div>
          );
        })}
      </div>

      {/* Remaining items to pick from */}
      {!isComplete && (
        <div className="flex flex-col gap-2 mb-6">
          {remaining.map((idx) => (
            <button
              key={idx}
              onClick={() => handlePick(idx)}
              className="flex items-center gap-3 p-3 rounded-xl border-2 border-slate-200 dark:border-slate-800 bg-white dark:bg-slate-900 hover:border-indigo-400 text-left text-sm font-semibold text-slate-800 dark:text-slate-200 transition-all"
            >
              <GripVertical className="w-4 h-4 text-slate-400 flex-shrink-0" />
              <MathRenderer content={data.items[idx]} />
            </button>
          ))}
        </div>
      )}

      <div className="flex items-center justify-between pt-4 border-t border-slate-100 dark:border-slate-800">
        <button
          onClick={handleReset}
          disabled={picked.length === 0}
          className="text-xs font-bold text-slate-500 hover:text-slate-700 dark:hover:text-slate-300 flex items-center gap-1.5 disabled:opacity-40"
        >
          <RotateCcw className="w-3.5 h-3.5" /> Reset
        </button>

        {!submitted ? (
          <Button variant="chalk" disabled={!isComplete} onClick={handleSubmit}>
            Check Order
          </Button>
        ) : (
          <Button variant="chalk" onClick={handleContinue}>
            {correctCount === data.items.length ? 'Perfect! Continue' : 'Continue'} <ArrowRight className="w-4 h-4" />
          </Button>
        )}
      </div>
    </Card>
  );
}

// --- Matching: tap one item from each column to pair them ---
function MatchingPlayer({
  data,
  title,
  instructions,
  onFinish,
}: {
  data: MatchingActivityData;
  title: string;
  instructions?: string | null;
  onFinish: (score: number) => void;
}) {
  // Shuffle the right column once per activity so it isn't a trivial
  // top-to-bottom match.
  const [shuffledRight] = useState(() => data.pairs.map((_, i) => i).sort(() => Math.random() - 0.5));

  const [selectedLeft, setSelectedLeft] = useState<number | null>(null);
  const [matches, setMatches] = useState<Record<number, number>>({}); // left index -> right index
  const matchedRightIndices = new Set(Object.values(matches));
  const isComplete = Object.keys(matches).length === data.pairs.length;
  const [submitted, setSubmitted] = useState(false);

  const handleSelectLeft = (leftIdx: number) => {
    if (submitted || matches[leftIdx] !== undefined) return;
    setSelectedLeft(leftIdx);
  };

  const handleSelectRight = (rightIdx: number) => {
    if (submitted || selectedLeft === null || matchedRightIndices.has(rightIdx)) return;
    setMatches((prev) => ({ ...prev, [selectedLeft]: rightIdx }));
    setSelectedLeft(null);
  };

  const handleReset = () => {
    setMatches({});
    setSelectedLeft(null);
    setSubmitted(false);
  };

  const correctCount = Object.entries(matches).filter(([left, right]) => Number(left) === right).length;

  const handleSubmit = () => setSubmitted(true);
  const handleContinue = () => onFinish(Math.round((correctCount / data.pairs.length) * 100));

  return (
    <Card>
      <ActivityHeader title={title} instructions={instructions ?? 'Tap a term, then tap its match.'} />

      <div className="grid grid-cols-2 gap-3 mb-6">
        <div className="flex flex-col gap-2">
          {data.pairs.map((pair, leftIdx) => {
            const matchedTo = matches[leftIdx];
            const isRight = submitted && matchedTo === leftIdx;
            const isWrong = submitted && matchedTo !== undefined && matchedTo !== leftIdx;
            return (
              <button
                key={leftIdx}
                onClick={() => handleSelectLeft(leftIdx)}
                disabled={submitted || matchedTo !== undefined}
                className={`p-3 rounded-xl border-2 text-left text-xs sm:text-sm font-semibold transition-all ${
                  isRight
                    ? 'border-emerald-500 bg-emerald-50 dark:bg-emerald-950/50 text-emerald-900 dark:text-emerald-200'
                    : isWrong
                    ? 'border-red-500 bg-red-50 dark:bg-red-950/50 text-red-900 dark:text-red-200'
                    : selectedLeft === leftIdx
                    ? 'border-indigo-600 bg-indigo-50 dark:bg-indigo-950/60 ring-2 ring-indigo-500/20'
                    : matchedTo !== undefined
                    ? 'border-indigo-300 bg-indigo-50/50 dark:bg-indigo-950/30 text-slate-600 dark:text-slate-400'
                    : 'border-slate-200 dark:border-slate-800 bg-white dark:bg-slate-900 hover:border-indigo-400'
                }`}
              >
                <MathRenderer content={pair.left} />
              </button>
            );
          })}
        </div>

        <div className="flex flex-col gap-2">
          {shuffledRight.map((rightIdx) => {
            const isMatched = matchedRightIndices.has(rightIdx);
            const matchedLeftEntry = Object.entries(matches).find(([, r]) => r === rightIdx);
            const matchedLeft = matchedLeftEntry ? Number(matchedLeftEntry[0]) : null;
            const isRight = submitted && matchedLeft === rightIdx;
            const isWrong = submitted && isMatched && matchedLeft !== rightIdx;
            return (
              <button
                key={rightIdx}
                onClick={() => handleSelectRight(rightIdx)}
                disabled={submitted || isMatched || selectedLeft === null}
                className={`p-3 rounded-xl border-2 text-left text-xs sm:text-sm font-semibold transition-all flex items-center gap-2 ${
                  isRight
                    ? 'border-emerald-500 bg-emerald-50 dark:bg-emerald-950/50 text-emerald-900 dark:text-emerald-200'
                    : isWrong
                    ? 'border-red-500 bg-red-50 dark:bg-red-950/50 text-red-900 dark:text-red-200'
                    : isMatched
                    ? 'border-indigo-300 bg-indigo-50/50 dark:bg-indigo-950/30 text-slate-600 dark:text-slate-400'
                    : selectedLeft !== null
                    ? 'border-slate-200 dark:border-slate-800 bg-white dark:bg-slate-900 hover:border-indigo-400'
                    : 'border-slate-200 dark:border-slate-800 bg-white dark:bg-slate-900 opacity-60'
                }`}
              >
                {isMatched && <Link2 className="w-3.5 h-3.5 flex-shrink-0" />}
                <MathRenderer content={data.pairs[rightIdx].right} />
              </button>
            );
          })}
        </div>
      </div>

      <div className="flex items-center justify-between pt-4 border-t border-slate-100 dark:border-slate-800">
        <button
          onClick={handleReset}
          disabled={Object.keys(matches).length === 0}
          className="text-xs font-bold text-slate-500 hover:text-slate-700 dark:hover:text-slate-300 flex items-center gap-1.5 disabled:opacity-40"
        >
          <RotateCcw className="w-3.5 h-3.5" /> Reset
        </button>

        {!submitted ? (
          <Button variant="chalk" disabled={!isComplete} onClick={handleSubmit}>
            Check Matches
          </Button>
        ) : (
          <Button variant="chalk" onClick={handleContinue}>
            {correctCount === data.pairs.length ? 'Perfect! Continue' : 'Continue'} <ArrowRight className="w-4 h-4" />
          </Button>
        )}
      </div>
    </Card>
  );
}
