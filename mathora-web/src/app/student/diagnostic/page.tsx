'use client';

import React, { useState } from 'react';
import Navbar from '@/components/Navbar';
import MathRenderer from '@/components/MathRenderer';
import { INITIAL_TOPICS } from '@/lib/mockData';
import { Target, Sparkles, CheckCircle2, ArrowRight, Award, BarChart2, ShieldAlert } from 'lucide-react';
import Link from 'next/link';

export default function DiagnosticTestPage() {
  const [currentStep, setCurrentStep] = useState(0);
  const [answers, setAnswers] = useState<Record<string, string>>({});
  const [isCompleted, setIsCompleted] = useState(false);

  const diagnosticQuestions = [
    {
      id: 'diag-1',
      topic: 'Quadratic Equations',
      question: 'What are the roots of $x^2 - 5x + 6 = 0$?',
      options: [
        { letter: 'A', text: '$x = 2$ or $x = 3$', is_correct: true },
        { letter: 'B', text: '$x = -2$ or $x = -3$', is_correct: false },
        { letter: 'C', text: '$x = 1$ or $x = 6$', is_correct: false },
        { letter: 'D', text: '$x = 5$ or $x = 6$', is_correct: false }
      ]
    },
    {
      id: 'diag-2',
      topic: 'Trigonometry',
      question: 'Evaluate $\\sin 30^\\circ + \\cos 60^\\circ$',
      options: [
        { letter: 'A', text: '1', is_correct: true },
        { letter: 'B', text: '$\\frac{1}{2}$', is_correct: false },
        { letter: 'C', text: '$\\sqrt{3}$', is_correct: false },
        { letter: 'D', text: '0', is_correct: false }
      ]
    }
  ];

  const handleSelectOption = (qId: string, letter: string) => {
    setAnswers((prev) => ({ ...prev, [qId]: letter }));
  };

  const handleNext = () => {
    if (currentStep < diagnosticQuestions.length - 1) {
      setCurrentStep((prev) => prev + 1);
    } else {
      setIsCompleted(true);
    }
  };

  const currentQ = diagnosticQuestions[currentStep];

  return (
    <div className="min-h-screen bg-slate-50 dark:bg-slate-950 text-slate-900 dark:text-slate-100 flex flex-col">
      <Navbar currentRole="student" userName="Chidiebere Okafor" />

      <main className="max-w-3xl mx-auto px-4 sm:px-6 lg:px-8 py-10 w-full">
        {!isCompleted ? (
          <div>
            {/* Header */}
            <div className="mb-6 text-center">
              <div className="inline-flex items-center gap-1.5 px-3.5 py-1 rounded-full bg-indigo-50 dark:bg-indigo-950 text-indigo-600 dark:text-indigo-400 text-xs font-semibold mb-2">
                <Target className="w-3.5 h-3.5 text-cyan-500" /> Mathora Diagnostic Placement Assessment
              </div>
              <h1 className="text-2xl sm:text-3xl font-extrabold text-slate-900 dark:text-white">
                Initial Mathematics Skill Baseline
              </h1>
              <p className="text-xs text-slate-600 dark:text-slate-400 mt-1">
                Answer these diagnostic questions so Mathora can auto-generate your personalized learning path.
              </p>
            </div>

            {/* Progress */}
            <div className="glass-card rounded-2xl p-4 mb-6 border border-slate-200 dark:border-slate-800">
              <div className="flex items-center justify-between text-xs font-semibold text-slate-500 mb-2">
                <span>Diagnostic Question {currentStep + 1} of {diagnosticQuestions.length}</span>
                <span className="text-indigo-600 font-bold">Topic: {currentQ.topic}</span>
              </div>
              <div className="w-full h-2 rounded-full bg-slate-100 dark:bg-slate-800 overflow-hidden">
                <div
                  className="h-full bg-indigo-600 rounded-full transition-all duration-300"
                  style={{ width: `${((currentStep + 1) / diagnosticQuestions.length) * 100}%` }}
                />
              </div>
            </div>

            {/* Question Card */}
            <div className="glass-card rounded-3xl p-6 sm:p-8 border border-indigo-100 dark:border-indigo-900/40 shadow-xl">
              <MathRenderer content={currentQ.question} className="text-lg font-bold text-slate-900 dark:text-slate-100 mb-6" />

              <div className="space-y-3 mb-6">
                {currentQ.options.map((opt) => {
                  const isSelected = answers[currentQ.id] === opt.letter;
                  return (
                    <button
                      key={opt.letter}
                      onClick={() => handleSelectOption(currentQ.id, opt.letter)}
                      className={`w-full text-left p-4 rounded-2xl border-2 transition-all flex items-center gap-3 ${
                        isSelected
                          ? 'border-indigo-600 bg-indigo-50 dark:bg-indigo-950/60 text-indigo-900 dark:text-indigo-100 font-bold'
                          : 'border-slate-200 dark:border-slate-800 bg-white dark:bg-slate-900 text-slate-800 dark:text-slate-200 hover:border-indigo-300'
                      }`}
                    >
                      <span className="w-7 h-7 rounded-lg border border-current font-bold text-xs flex items-center justify-center">
                        {opt.letter}
                      </span>
                      <MathRenderer content={opt.text} className="text-sm font-semibold" />
                    </button>
                  );
                })}
              </div>

              <div className="flex justify-end">
                <button
                  onClick={handleNext}
                  disabled={!answers[currentQ.id]}
                  className={`px-6 py-3 rounded-2xl font-bold text-sm shadow-md flex items-center gap-2 transition-all ${
                    answers[currentQ.id]
                      ? 'bg-gradient-to-r from-indigo-600 to-cyan-600 text-white hover:from-indigo-500 hover:to-cyan-500'
                      : 'bg-slate-200 dark:bg-slate-800 text-slate-400 cursor-not-allowed'
                  }`}
                >
                  {currentStep < diagnosticQuestions.length - 1 ? 'Next Question' : 'Complete Assessment'} <ArrowRight className="w-4 h-4" />
                </button>
              </div>
            </div>
          </div>
        ) : (
          /* Results & Path Generation */
          <div className="glass-card rounded-3xl p-8 border border-indigo-100 dark:border-indigo-900/40 shadow-xl text-center">
            <div className="w-16 h-16 rounded-3xl bg-indigo-500/10 text-indigo-600 mx-auto flex items-center justify-center mb-4">
              <Award className="w-8 h-8" />
            </div>

            <h2 className="text-2xl font-extrabold text-slate-900 dark:text-white">
              Diagnostic Assessment Complete! 🎉
            </h2>
            <p className="text-sm text-slate-600 dark:text-slate-300 mt-2 max-w-md mx-auto">
              Mathora has generated your baseline mastery profile and customized learning sequence.
            </p>

            <div className="grid grid-cols-2 gap-4 max-w-md mx-auto my-6 text-left">
              <div className="p-4 rounded-2xl bg-emerald-50 dark:bg-emerald-950/40 border border-emerald-200 dark:border-emerald-900">
                <span className="text-[10px] font-bold uppercase text-emerald-700 dark:text-emerald-300">Strong Foundation</span>
                <p className="font-bold text-sm text-slate-900 dark:text-white mt-1">Quadratic Factorization</p>
              </div>
              <div className="p-4 rounded-2xl bg-amber-50 dark:bg-amber-950/40 border border-amber-200 dark:border-amber-900">
                <span className="text-[10px] font-bold uppercase text-amber-700 dark:text-amber-300">Needs Rescue Remediation</span>
                <p className="font-bold text-sm text-slate-900 dark:text-white mt-1">Trigonometric Identities</p>
              </div>
            </div>

            <Link
              href="/student/practice"
              className="inline-flex items-center gap-2 px-8 py-3.5 rounded-2xl bg-gradient-to-r from-indigo-600 to-cyan-600 text-white font-bold text-sm shadow-lg shadow-indigo-500/25"
            >
              Start Personalized Practice Path <ArrowRight className="w-4 h-4" />
            </Link>
          </div>
        )}
      </main>
    </div>
  );
}
