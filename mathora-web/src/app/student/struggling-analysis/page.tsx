'use client';

import React from 'react';
import Navbar from '@/components/Navbar';
import MathRenderer from '@/components/MathRenderer';
import { HelpCircle, AlertTriangle, Lightbulb, CheckCircle2, ArrowRight, Sparkles } from 'lucide-react';
import Link from 'next/link';

export default function StrugglingAnalysisPage() {
  const recurringMistakes = [
    {
      id: 'err-1',
      title: 'Sign Errors when Expanding Bracket Factors',
      frequency: '3 of last 5 attempts',
      topic: 'Quadratic Equations',
      description: 'You correctly identify factors $(-6)$ and $(-1)$, but when expanding $-6x - x$, you mistakenly change the constant sign $+2$ to $-2$.',
      remedialTip: 'Always check: $(-6) \\times (-1) = +6$. Multiplying two negative factors yields a POSITIVE constant!'
    },
    {
      id: 'err-2',
      title: 'Measuring Angle of Elevation from Vertical Line',
      frequency: '2 of last 4 attempts',
      topic: 'Trigonometry',
      description: 'You drew the angle $\\theta = 30^\\circ$ from the vertical pole rather than the horizontal line of sight.',
      remedialTip: 'Angle of elevation is ALWAYS measured UP from the horizontal line of sight. Draw your horizontal baseline first!'
    }
  ];

  return (
    <div className="min-h-screen bg-slate-50 dark:bg-slate-950 text-slate-900 dark:text-slate-100 flex flex-col">
      <Navbar currentRole="student" userName="Chidiebere Okafor" />

      <main className="max-w-4xl mx-auto px-4 sm:px-6 lg:px-8 py-8 w-full">
        {/* Header */}
        <div className="mb-8">
          <div className="inline-flex items-center gap-1.5 px-3.5 py-1 rounded-full bg-purple-50 dark:bg-purple-950 text-purple-600 dark:text-purple-400 text-xs font-semibold mb-2">
            <Sparkles className="w-3.5 h-3.5 text-cyan-500" /> Signature Feature: &quot;Why Am I Struggling?&quot;
          </div>
          <h1 className="text-2xl sm:text-3xl font-extrabold text-slate-900 dark:text-white">
            Automated Mistake & Error Pattern Diagnosis
          </h1>
          <p className="text-sm text-slate-600 dark:text-slate-400 mt-1">
            Mathora analyzes your last 10 practice attempts to pinpoint the exact recurring calculation error rather than just naming the topic.
          </p>
        </div>

        {/* Error Cards */}
        <div className="space-y-6">
          {recurringMistakes.map((err) => (
            <div key={err.id} className="glass-card rounded-3xl p-6 sm:p-8 border border-purple-100 dark:border-purple-900/40 shadow-lg">
              <div className="flex items-start justify-between gap-4 mb-3">
                <div className="flex items-center gap-2">
                  <span className="w-8 h-8 rounded-xl bg-purple-500/10 text-purple-600 font-extrabold text-sm flex items-center justify-center flex-shrink-0">
                    <AlertTriangle className="w-4 h-4 text-amber-500" />
                  </span>
                  <div>
                    <span className="text-[10px] font-bold uppercase tracking-wider text-purple-600 bg-purple-50 dark:bg-purple-950 px-2 py-0.5 rounded">
                      {err.topic} · {err.frequency}
                    </span>
                    <h3 className="text-lg font-bold text-slate-900 dark:text-white mt-1">
                      {err.title}
                    </h3>
                  </div>
                </div>
              </div>

              <div className="bg-slate-50 dark:bg-slate-900 rounded-2xl p-4 border border-slate-200 dark:border-slate-800 text-xs text-slate-700 dark:text-slate-300 mb-4">
                <strong className="text-purple-600 dark:text-purple-400 block mb-1">Diagnosed Error Pattern:</strong>
                <MathRenderer content={err.description} />
              </div>

              <div className="bg-emerald-50 dark:bg-emerald-950/30 border border-emerald-200 dark:border-emerald-900/50 rounded-2xl p-4 flex items-start gap-2.5 text-xs text-emerald-900 dark:text-emerald-200">
                <Lightbulb className="w-4 h-4 text-emerald-600 flex-shrink-0 mt-0.5" />
                <div>
                  <strong className="font-bold uppercase tracking-wide text-emerald-700 dark:text-emerald-300">Remedial Rule:</strong>
                  <MathRenderer content={err.remedialTip} className="mt-0.5" />
                </div>
              </div>
            </div>
          ))}
        </div>
      </main>
    </div>
  );
}
