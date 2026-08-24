'use client';

import React, { useState } from 'react';
import { AnimatePresence, motion } from 'framer-motion';
import MathRenderer from './MathRenderer';
import { ChevronLeft, ChevronRight, CheckCircle2 } from 'lucide-react';

/**
 * Reveals worked-example solution_steps one at a time rather than
 * dumping the whole solution on screen at once — the animated,
 * paced walkthrough requested for Stage 2 content. Falls back
 * gracefully: a single-step example just shows Next/Prev disabled
 * appropriately rather than needing special-casing.
 */
export default function StepByStepSolution({ steps }: { steps: string[] }) {
  const [index, setIndex] = useState(0);

  if (steps.length === 0) return null;

  return (
    <div>
      <div className="flex items-center justify-between mb-3">
        <span className="text-xs font-bold text-slate-500 uppercase tracking-wide">
          Step-by-Step Solution ({index + 1} of {steps.length})
        </span>
        <div className="flex items-center gap-1">
          {steps.map((_, i) => (
            <button
              key={i}
              onClick={() => setIndex(i)}
              aria-label={`Go to step ${i + 1}`}
              className={`w-1.5 h-1.5 rounded-full transition-all ${
                i === index ? 'bg-indigo-600 w-4' : i < index ? 'bg-indigo-300 dark:bg-indigo-800' : 'bg-slate-200 dark:bg-slate-700'
              }`}
            />
          ))}
        </div>
      </div>

      <div className="min-h-[64px] relative">
        <AnimatePresence mode="wait">
          <motion.div
            key={index}
            initial={{ opacity: 0, x: 16 }}
            animate={{ opacity: 1, x: 0 }}
            exit={{ opacity: 0, x: -16 }}
            transition={{ duration: 0.3 }}
            className="flex items-start gap-2.5 bg-white dark:bg-slate-900 rounded-xl p-3.5 border border-slate-200 dark:border-slate-800"
          >
            <CheckCircle2 className="w-4 h-4 text-emerald-500 flex-shrink-0 mt-0.5" />
            <MathRenderer content={steps[index]} className="text-sm text-slate-700 dark:text-slate-300" />
          </motion.div>
        </AnimatePresence>
      </div>

      <div className="flex items-center justify-between mt-3">
        <button
          onClick={() => setIndex((i) => Math.max(0, i - 1))}
          disabled={index === 0}
          className="flex items-center gap-1 text-xs font-bold text-slate-500 hover:text-indigo-600 disabled:opacity-30 disabled:hover:text-slate-500"
        >
          <ChevronLeft className="w-4 h-4" /> Previous
        </button>
        <button
          onClick={() => setIndex((i) => Math.min(steps.length - 1, i + 1))}
          disabled={index === steps.length - 1}
          className="flex items-center gap-1 text-xs font-bold text-indigo-600 hover:text-indigo-700 disabled:opacity-30 disabled:hover:text-indigo-600"
        >
          Next Step <ChevronRight className="w-4 h-4" />
        </button>
      </div>
    </div>
  );
}
