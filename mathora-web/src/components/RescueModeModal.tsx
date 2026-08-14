'use client';

import React from 'react';
import MathRenderer from './MathRenderer';
import { Question, WorkedExample } from '@/lib/types';
import { AlertCircle, HelpCircle, CheckCircle2, ArrowRight, Lightbulb, ShieldAlert, Sparkles, X } from 'lucide-react';

interface RescueModeModalProps {
  isOpen: boolean;
  question: Question;
  selectedOptionLetter: string;
  onClose: () => void;
  onRetry: () => void;
}

export default function RescueModeModal({
  isOpen,
  question,
  selectedOptionLetter,
  onClose,
  onRetry
}: RescueModeModalProps) {
  if (!isOpen) return null;

  const correctOption = question.options.find(o => o.is_correct);

  return (
    <div className="fixed inset-0 z-50 flex items-center justify-center p-4 bg-slate-900/70 backdrop-blur-sm animate-fade-in">
      <div className="bg-white dark:bg-slate-900 rounded-2xl max-w-2xl w-full max-h-[90vh] overflow-y-auto shadow-2xl border border-indigo-100 dark:border-indigo-900/40 p-6 relative">
        {/* Close Button */}
        <button
          onClick={onClose}
          className="absolute top-4 right-4 p-2 text-slate-400 hover:text-slate-600 dark:hover:text-slate-200 rounded-full hover:bg-slate-100 dark:hover:bg-slate-800 transition-colors"
        >
          <X className="w-5 h-5" />
        </button>

        {/* Modal Header */}
        <div className="flex items-center gap-3 mb-6">
          <div className="w-12 h-12 rounded-2xl bg-amber-500/10 border border-amber-500/20 text-amber-600 flex items-center justify-center flex-shrink-0">
            <Lightbulb className="w-6 h-6 animate-pulse" />
          </div>
          <div>
            <div className="flex items-center gap-2">
              <span className="text-xs font-bold uppercase tracking-wider text-amber-600 dark:text-amber-400 bg-amber-50 dark:bg-amber-950 px-2 py-0.5 rounded border border-amber-200 dark:border-amber-800">
                Rescue Mode Activated
              </span>
              <span className="text-xs font-semibold text-slate-400">Step-by-step Remediation</span>
            </div>
            <h2 className="text-xl font-bold text-slate-900 dark:text-slate-100 mt-1">
              Let&apos;s Fix This Misunderstanding
            </h2>
          </div>
        </div>

        {/* Mistake Analysis Box */}
        <div className="bg-red-50 dark:bg-red-950/30 border border-red-200 dark:border-red-900/50 rounded-xl p-4 mb-6">
          <div className="flex items-start gap-2.5">
            <AlertCircle className="w-5 h-5 text-red-600 dark:text-red-400 flex-shrink-0 mt-0.5" />
            <div>
              <p className="text-xs font-bold text-red-700 dark:text-red-300 uppercase tracking-wide">
                Selected Answer: Option {selectedOptionLetter} (Incorrect)
              </p>
              <p className="text-sm text-red-900 dark:text-red-200 mt-1">
                Don&apos;t worry! Making mistakes is how real math mastery happens. Here is why the answer broke down and how to solve it correctly.
              </p>
            </div>
          </div>
        </div>

        {/* Simple Re-Explanation & Solution */}
        <div className="bg-indigo-50/50 dark:bg-indigo-950/20 border border-indigo-100 dark:border-indigo-900/40 rounded-xl p-5 mb-6">
          <h3 className="text-sm font-bold uppercase tracking-wide text-indigo-700 dark:text-indigo-300 flex items-center gap-2 mb-3">
            <CheckCircle2 className="w-4 h-4 text-emerald-500" /> Worked Solution & Explanation
          </h3>
          <MathRenderer content={question.explanation} className="text-sm text-slate-800 dark:text-slate-200" />

          {question.exam_shortcut && (
            <div className="mt-4 pt-4 border-t border-indigo-200/60 dark:border-indigo-800/60 flex items-start gap-2.5">
              <Sparkles className="w-5 h-5 text-cyan-500 flex-shrink-0 mt-0.5" />
              <div>
                <span className="text-xs font-bold text-cyan-700 dark:text-cyan-300 uppercase">WAEC Exam Technique / Shortcut:</span>
                <MathRenderer content={question.exam_shortcut} className="text-xs text-slate-700 dark:text-slate-300 mt-0.5" />
              </div>
            </div>
          )}
        </div>

        {/* Action Buttons */}
        <div className="flex items-center justify-end gap-3 pt-2">
          <button
            onClick={onClose}
            className="px-4 py-2.5 text-sm font-medium text-slate-600 dark:text-slate-300 hover:bg-slate-100 dark:hover:bg-slate-800 rounded-xl transition-colors"
          >
            Review Lesson
          </button>
          <button
            onClick={onRetry}
            className="px-5 py-2.5 text-sm font-semibold text-white bg-gradient-to-r from-indigo-600 to-cyan-600 hover:from-indigo-500 hover:to-cyan-500 rounded-xl shadow-md shadow-indigo-500/20 flex items-center gap-2 transition-all transform hover:-translate-y-0.5"
          >
            Retry Problem <ArrowRight className="w-4 h-4" />
          </button>
        </div>
      </div>
    </div>
  );
}
