'use client';

import React from 'react';
import Navbar from '@/components/Navbar';
import { Card, Badge } from '@/components/ui/Primitives';

export default function ParentDashboard() {
  return (
    <div className="min-h-screen bg-slate-950 text-slate-100 flex flex-col font-sans">
      <Navbar currentRole="parent" userName="Mrs. Folake Okafor" />

      <main className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 py-8 w-full">
        {/* Parent Report Header */}
        <Card variant="report" className="mb-8">
          <div className="flex flex-col sm:flex-row items-start sm:items-center justify-between gap-4">
            <div>
              <Badge variant="bece">Parent Progress Report (Calm Mode)</Badge>
              <h1 className="text-2xl sm:text-3xl font-display font-extrabold text-white mt-2">
                Child Performance: Chidiebere Okafor
              </h1>
              <p className="text-slate-400 text-xs font-mono mt-1">
                Class: SS2 Science A · School: Maryland Comprehensive High School, Lagos
              </p>
            </div>

            <div className="bg-slate-900 px-5 py-3 rounded-xl border border-slate-800 text-right font-mono">
              <span className="text-xs text-slate-400 font-medium block">Overall Math Mastery</span>
              <p className="text-2xl font-extrabold text-emerald-400">65.4%</p>
            </div>
          </div>
        </Card>

        {/* Parent Summary Cards */}
        <div className="grid grid-cols-1 md:grid-cols-4 gap-6 mb-8 font-mono">
          <Card variant="paper">
            <span className="text-xs font-semibold text-slate-400">Weekly Change</span>
            <p className="text-2xl font-extrabold text-emerald-400 mt-1">+8.2% 📈</p>
            <p className="text-[11px] text-slate-400 mt-0.5">Compared to last week</p>
          </Card>

          <Card variant="paper">
            <span className="text-xs font-semibold text-slate-400">Weekly Study Time</span>
            <p className="text-2xl font-extrabold text-amber-400 mt-1">4.5 Hours</p>
            <p className="text-[11px] text-slate-400 mt-0.5">Target: 4.0 hrs/week</p>
          </Card>

          <Card variant="paper" className="border-amber-800/80 bg-amber-950/20">
            <span className="text-xs font-bold text-amber-300">Needs Attention Topic</span>
            <p className="text-base font-bold text-white mt-1 font-sans">Trigonometry (40%)</p>
            <p className="text-[11px] text-amber-300 mt-0.5">Needs 2 rescue practice sessions</p>
          </Card>

          <Card variant="paper">
            <span className="text-xs font-semibold text-slate-400">Teacher Note</span>
            <p className="text-xs font-medium text-slate-300 mt-1 font-sans">
              &quot;Chidiebere has improved greatly in Quadratic Factorization this week!&quot; — Mr. Bello
            </p>
          </Card>
        </div>

        {/* Detailed Topic Breakdown */}
        <Card variant="paper">
          <h2 className="text-lg font-display font-bold text-white mb-4">
            Curriculum Mastery Breakdown
          </h2>

          <div className="space-y-4 font-mono">
            <div className="p-4 rounded-xl bg-slate-900 border border-slate-800">
              <div className="flex items-center justify-between mb-2">
                <span className="font-bold text-sm text-slate-200 font-sans">Quadratic Equations & Factorization</span>
                <span className="font-bold text-sm text-emerald-400">65% Mastery (On Track)</span>
              </div>
              <div className="w-full h-2 rounded-full bg-slate-950 border border-slate-800">
                <div className="h-full bg-emerald-500 rounded-full" style={{ width: '65%' }} />
              </div>
            </div>

            <div className="p-4 rounded-xl bg-slate-900 border border-slate-800">
              <div className="flex items-center justify-between mb-2">
                <span className="font-bold text-sm text-slate-200 font-sans">Trigonometric Ratios & Elevation</span>
                <span className="font-bold text-sm text-amber-400">40% Mastery (Attention Recommended)</span>
              </div>
              <div className="w-full h-2 rounded-full bg-slate-950 border border-slate-800">
                <div className="h-full bg-amber-500 rounded-full" style={{ width: '40%' }} />
              </div>
            </div>
          </div>
        </Card>
      </main>
    </div>
  );
}
