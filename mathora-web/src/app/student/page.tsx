'use client';

import React from 'react';
import Link from 'next/link';
import Navbar from '@/components/Navbar';
import MathRenderer from '@/components/MathRenderer';
import { Card, Button, Badge, MathMotif } from '@/components/ui/Primitives';
import { INITIAL_TOPICS, INITIAL_MASTERY } from '@/lib/mockData';
import { Sparkles, ArrowRight, Play, AlertTriangle, BarChart2 } from 'lucide-react';

export default function StudentDashboard() {
  return (
    <div className="min-h-screen bg-slate-50 dark:bg-slate-950 text-slate-900 dark:text-slate-100 flex flex-col font-sans">
      <Navbar currentRole="student" userName="Chidiebere Okafor" />

      <main className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 py-8 w-full">
        {/* Student Notebook Header Banner */}
        <div className="paper-card student-notebook-surface rounded-2xl p-6 sm:p-8 text-slate-900 dark:text-white mb-8 shadow-xl relative overflow-hidden notebook-margin">
          <div className="relative z-10 flex flex-col sm:flex-row items-start sm:items-center justify-between gap-6">
            <div>
              <div className="inline-flex items-center gap-2 px-3 py-1 rounded bg-amber-50 dark:bg-amber-950/80 border border-amber-200 dark:border-amber-800 text-amber-700 dark:text-amber-300 text-xs font-mono font-bold mb-3">
                <Sparkles className="w-3.5 h-3.5 text-amber-600 dark:text-amber-400" /> SS2 Mathematics Mastery Notebook
              </div>
              <h1 className="text-2xl sm:text-3xl font-display font-extrabold tracking-tight">
                Welcome back, Chidiebere! 📐
              </h1>
              <p className="text-slate-600 dark:text-slate-300 text-sm mt-1 max-w-xl">
                Target this week: Complete <strong className="text-amber-600 dark:text-amber-400">Quadratic Equations Rescue Mode</strong> for WAEC readiness.
              </p>
            </div>

            <Link href="/student/practice">
              <Button variant="primary" size="md" className="font-display">
                Resume Practice <ArrowRight className="w-4 h-4" />
              </Button>
            </Link>
          </div>
        </div>

        {/* Dashboard Grid */}
        <div className="grid grid-cols-1 lg:grid-cols-3 gap-8">
          {/* Active SS2 Topics */}
          <div className="lg:col-span-2 space-y-6">
            <div className="flex items-center justify-between">
              <h2 className="text-xl font-display font-bold text-slate-900 dark:text-white flex items-center gap-2">
                <MathMotif type="function" className="w-5 h-5 text-amber-600 dark:text-amber-400" /> Active SS2 Topics
              </h2>
              <Link href="/student/learn" className="text-xs font-mono font-bold text-amber-600 dark:text-amber-400 hover:underline">
                View All Topics →
              </Link>
            </div>

            {/* Topic Cards */}
            <div className="space-y-4">
              {INITIAL_TOPICS.map((topic) => {
                const mastery = INITIAL_MASTERY[topic.id] || { mastery_percentage: 0 };
                return (
                  <Card key={topic.id} variant="notebook" className="hover:border-amber-500/50 transition-all">
                    <div className="flex items-start justify-between gap-4">
                      <div>
                        <Badge variant="waec">{topic.class_level}</Badge>
                        <h3 className="text-lg font-display font-bold text-slate-900 dark:text-white mt-1">
                          {topic.title}
                        </h3>
                        <p className="text-xs text-slate-600 dark:text-slate-300 mt-1">
                          {topic.description}
                        </p>
                      </div>

                      <Link href={`/student/practice?topic=${topic.id}`}>
                        <Button variant="chalk" size="sm">
                          Practice <Play className="w-3 h-3 fill-current" />
                        </Button>
                      </Link>
                    </div>

                    {/* Mastery Indicator */}
                    <div className="mt-4 pt-3 border-t border-slate-200 dark:border-slate-800 font-mono">
                      <div className="flex items-center justify-between text-xs mb-1.5">
                        <span className="font-semibold text-slate-500 dark:text-slate-400">Mastery Level</span>
                        <span className="font-bold text-amber-600 dark:text-amber-400">
                          {mastery.mastery_percentage}%
                        </span>
                      </div>
                      <div className="w-full h-2 rounded-full bg-white dark:bg-slate-900 overflow-hidden border border-slate-200 dark:border-slate-800">
                        <div
                          className="h-full bg-gradient-to-r from-amber-500 to-cyan-400 rounded-full transition-all duration-500"
                          style={{ width: `${mastery.mastery_percentage}%` }}
                        />
                      </div>
                    </div>
                  </Card>
                );
              })}
            </div>
          </div>

          {/* Teacher Assignments & Learning Stats */}
          <div className="space-y-6">
            {/* Join a Class */}
            <Card variant="paper">
              <h3 className="text-sm font-display font-bold text-slate-900 dark:text-white flex items-center gap-2 mb-2">
                <Sparkles className="w-4 h-4 text-amber-600 dark:text-amber-400" /> Not in a class yet?
              </h3>
              <p className="text-xs text-slate-500 dark:text-slate-400 mb-3">
                Search for your school and teacher to request to join their class.
              </p>
              <Link href="/student/join-class">
                <Button variant="outline" size="sm" className="w-full justify-center">
                  Find My Class
                </Button>
              </Link>
            </Card>

            {/* Teacher Assignments */}
            <Card variant="exam">
              <h3 className="text-sm font-display font-bold text-slate-900 dark:text-white flex items-center gap-2 mb-3">
                <AlertTriangle className="w-4 h-4 text-amber-600 dark:text-amber-400" /> Pending Teacher Assignments
              </h3>

              <div className="space-y-3">
                <div className="p-3.5 rounded-xl bg-white dark:bg-slate-900 border border-slate-200 dark:border-slate-800">
                  <div className="flex items-center justify-between">
                    <span className="text-xs font-bold text-slate-800 dark:text-slate-200">
                      Quadratic Practice Set #1
                    </span>
                    <Badge variant="struggling">Due Tomorrow</Badge>
                  </div>
                  <p className="text-xs text-slate-500 dark:text-slate-400 mt-1 font-mono">Class: SS2 Science A (Mr. Bello)</p>
                  <Link
                    href="/student/practice"
                    className="mt-2.5 inline-flex items-center gap-1 text-xs font-mono font-bold text-amber-600 dark:text-amber-400 hover:underline"
                  >
                    Start Assignment <ArrowRight className="w-3 h-3" />
                  </Link>
                </div>
              </div>
            </Card>

            {/* Learning Stats */}
            <Card variant="paper">
              <h3 className="text-sm font-display font-bold text-slate-900 dark:text-white flex items-center gap-2 mb-4">
                <BarChart2 className="w-4 h-4 text-cyan-600 dark:text-cyan-400" /> Personal Learning Stats
              </h3>

              <div className="grid grid-cols-2 gap-4 text-center font-mono">
                <div className="p-3 rounded-xl bg-white dark:bg-slate-900 border border-slate-200 dark:border-slate-800">
                  <p className="text-2xl font-extrabold text-amber-600 dark:text-amber-400">15</p>
                  <p className="text-[11px] text-slate-500 dark:text-slate-400 font-medium">Questions Solved</p>
                </div>
                <div className="p-3 rounded-xl bg-white dark:bg-slate-900 border border-slate-200 dark:border-slate-800">
                  <p className="text-2xl font-extrabold text-emerald-600 dark:text-emerald-400">80%</p>
                  <p className="text-[11px] text-slate-500 dark:text-slate-400 font-medium">Accuracy Score</p>
                </div>
              </div>

              <Link
                href="/student/analysis"
                className="mt-4 flex items-center justify-center gap-1.5 text-xs font-mono font-bold text-amber-600 dark:text-amber-400 hover:underline"
              >
                View Full Analysis <ArrowRight className="w-3.5 h-3.5" />
              </Link>
            </Card>
          </div>
        </div>
      </main>
    </div>
  );
}
