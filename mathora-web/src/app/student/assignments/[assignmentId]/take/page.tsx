'use client';

import React, { useCallback, useEffect, useRef, useState } from 'react';
import Link from 'next/link';
import { useParams } from 'next/navigation';
import Navbar from '@/components/Navbar';
import MathRenderer from '@/components/MathRenderer';
import NoCopyGuard from '@/components/NoCopyGuard';
import { Card, Badge } from '@/components/ui/Primitives';
import { ArrowLeft, Clock, CheckCircle2, XCircle, ArrowRight, Award, AlertTriangle } from 'lucide-react';

import {
  fetchAssignmentForTaking,
  startAssignmentAttempt,
  submitAssignmentAnswer,
  completeAssignmentSubmission,
  logFocusLossEvent,
} from '@/lib/supabase';
import type { Question, QuestionOption } from '@/lib/types';
import { useAuth } from '@/lib/authContext';
import { useCountdown } from '@/lib/useCountdown';
import { useVisibilityGuard } from '@/lib/useVisibilityGuard';

type LoadState =
  | { phase: 'loading' }
  | { phase: 'blocked'; reason: string }
  | {
      phase: 'ready';
      assignment: { id: string; title: string; due_date: string; duration_minutes: number | null };
      questions: Question[];
    }
  | { phase: 'error' };

// A focus-loss event is logged, at most, once per this window — rapid
// alt-tabbing shouldn't spam the teacher's notification queue. This is
// purely a client-side debounce; the DB trigger fires once per row this
// page actually inserts.
const FOCUS_LOSS_DEBOUNCE_MS = 10_000;

export default function TakeAssignmentPage() {
  const params = useParams();
  const assignmentId = params.assignmentId as string;
  const { user } = useAuth();

  const [state, setState] = useState<LoadState>({ phase: 'loading' });

  const [questionIndex, setQuestionIndex] = useState(0);
  const [selectedOption, setSelectedOption] = useState<QuestionOption | null>(null);
  const [isAnswerSubmitted, setIsAnswerSubmitted] = useState(false);
  const [correctCount, setCorrectCount] = useState(0);
  const [completed, setCompleted] = useState(false);
  const [finalScore, setFinalScore] = useState<number | null>(null);
  // Seeded ONCE when the attempt resolves (start time minus elapsed
  // since started_at) — never recomputed from Date.now() on a later
  // render, or useCountdown's effect (keyed on this value) would reset
  // the clock on every render instead of just ticking it down.
  const [totalSeconds, setTotalSeconds] = useState<number | null>(null);

  const lastFocusLossLoggedAt = useRef(0);

  useEffect(() => {
    if (!assignmentId || !user?.id) return;

    let cancelled = false;
    (async () => {
      const data = await fetchAssignmentForTaking(assignmentId);
      if (cancelled) return;
      if (!data) {
        setState({ phase: 'error' });
        return;
      }

      const pastDue = new Date(data.assignment.due_date).getTime() < Date.now();
      const attempt = await startAssignmentAttempt(assignmentId, user.id);
      if (cancelled) return;

      if (!attempt) {
        if (pastDue) {
          setState({ phase: 'blocked', reason: 'This assignment is past due and can no longer be started.' });
        } else {
          setState({ phase: 'error' });
        }
        return;
      }

      if (data.assignment.duration_minutes != null) {
        const elapsed = Math.floor((Date.now() - new Date(attempt.started_at).getTime()) / 1000);
        setTotalSeconds(Math.max(0, data.assignment.duration_minutes * 60 - elapsed));
      }
      setState({ phase: 'ready', assignment: data.assignment, questions: data.questions });
    })();

    return () => {
      cancelled = true;
    };
  }, [assignmentId, user?.id]);

  // Marks the attempt complete and asks the server for the authoritative
  // score (derived from assignment_answers, not from anything computed
  // here) — the client's own correctCount is shown as immediate
  // feedback the moment finalScore resolves, but never sent anywhere.
  const finishAssignment = useCallback(async () => {
    if (!user) return;
    setCompleted(true);
    const result = await completeAssignmentSubmission({ assignmentId });
    if (result.success && result.score != null) {
      setFinalScore(result.score);
      if (result.correct != null) setCorrectCount(result.correct);
    }
  }, [assignmentId, user]);

  const handleExpire = useCallback(() => {
    if (state.phase !== 'ready' || completed) return;
    // Time's up — unanswered questions count as incorrect (the server
    // derives score from however many assignment_answers rows actually
    // exist, so unanswered questions simply aren't among them). Fires
    // even while the tab is unfocused (setInterval keeps running
    // regardless of visibility), per the "never pause on focus loss" rule.
    finishAssignment();
  }, [state, completed, finishAssignment]);

  const { secondsLeft, formatted } = useCountdown({
    totalSeconds,
    onExpire: handleExpire,
    active: state.phase === 'ready' && !completed,
  });

  useVisibilityGuard({
    enabled: state.phase === 'ready' && !completed,
    onFocusLoss: () => {
      const now = Date.now();
      if (now - lastFocusLossLoggedAt.current < FOCUS_LOSS_DEBOUNCE_MS) return;
      lastFocusLossLoggedAt.current = now;
      logFocusLossEvent(assignmentId);
    },
  });

  if (state.phase === 'loading') {
    return (
      <div className="min-h-screen bg-slate-50 dark:bg-slate-950 flex items-center justify-center">
        <p className="text-sm text-slate-500 dark:text-slate-400">Loading assignment...</p>
      </div>
    );
  }

  if (state.phase === 'blocked' || state.phase === 'error') {
    return (
      <div className="min-h-screen bg-slate-50 dark:bg-slate-950 text-slate-900 dark:text-slate-100 flex flex-col font-sans">
        <Navbar currentRole="student" userName="Chidiebere Okafor" />
        <main className="max-w-2xl mx-auto px-4 sm:px-6 lg:px-8 py-8 w-full">
          <Link href="/student/assignments" className="inline-flex items-center gap-1.5 text-xs font-mono font-bold text-amber-600 dark:text-amber-400 hover:underline mb-4">
            <ArrowLeft className="w-3.5 h-3.5" /> Back to Assignments
          </Link>
          <Card variant="paper" className="p-6 text-center">
            <AlertTriangle className="w-6 h-6 text-rose-500 mx-auto mb-2" />
            <p className="text-sm text-slate-600 dark:text-slate-400">
              {state.phase === 'blocked' ? state.reason : 'Could not load this assignment.'}
            </p>
          </Card>
        </main>
      </div>
    );
  }

  const { assignment, questions } = state;
  const currentQuestion = questions[questionIndex];

  if (completed) {
    return (
      <div className="min-h-screen bg-slate-50 dark:bg-slate-950 text-slate-900 dark:text-slate-100 flex flex-col font-sans">
        <Navbar currentRole="student" userName="Chidiebere Okafor" />
        <main className="max-w-2xl mx-auto px-4 sm:px-6 lg:px-8 py-8 w-full">
          <Card variant="paper" className="p-8 text-center">
            <Award className="w-10 h-10 text-amber-500 mx-auto mb-3" />
            <h1 className="text-2xl font-display font-extrabold text-slate-900 dark:text-white mb-1">Assignment Complete</h1>
            <p className="text-4xl font-extrabold text-indigo-600 dark:text-indigo-400 my-4">{finalScore}%</p>
            <p className="text-sm text-slate-500 dark:text-slate-400 mb-6">
              {correctCount} of {questions.length} correct
            </p>
            <Link
              href="/student/assignments"
              className="inline-flex items-center gap-1.5 text-xs font-mono font-bold text-amber-600 dark:text-amber-400 hover:underline"
            >
              Back to Assignments
            </Link>
          </Card>
        </main>
      </div>
    );
  }

  if (questions.length === 0) {
    return (
      <div className="min-h-screen bg-slate-50 dark:bg-slate-950 text-slate-900 dark:text-slate-100 flex flex-col font-sans">
        <Navbar currentRole="student" userName="Chidiebere Okafor" />
        <main className="max-w-2xl mx-auto px-4 sm:px-6 lg:px-8 py-8 w-full">
          <Card variant="paper" className="p-6 text-center">
            <p className="text-sm text-slate-600 dark:text-slate-400">This assignment has no questions yet.</p>
          </Card>
        </main>
      </div>
    );
  }

  const handleSelectOption = (opt: QuestionOption) => {
    if (isAnswerSubmitted) return;
    setSelectedOption(opt);
  };

  const handleSubmitAnswer = async () => {
    if (!selectedOption || !currentQuestion || !user?.id) return;
    setIsAnswerSubmitted(true);
    const isCorrect = selectedOption.is_correct; // client-side, for instant option highlighting only — the DB recomputes is_correct itself on insert, never trusts this value
    setCorrectCount((prev) => prev + (isCorrect ? 1 : 0));

    const isLastQuestion = questionIndex >= questions.length - 1;

    // Awaited (not fire-and-forget) on the last question specifically —
    // completeAssignmentSubmission's score derives from whatever
    // assignment_answers rows exist at that moment, so this one must
    // land before finishAssignment asks the server to grade.
    if (isLastQuestion) {
      await submitAssignmentAnswer({
        student_id: user.id,
        assignment_id: assignment.id,
        question_id: currentQuestion.id,
        selected_option: selectedOption.letter,
        is_correct: isCorrect,
      });
      finishAssignment();
    } else {
      submitAssignmentAnswer({
        student_id: user.id,
        assignment_id: assignment.id,
        question_id: currentQuestion.id,
        selected_option: selectedOption.letter,
        is_correct: isCorrect,
      });
    }
  };

  const handleNext = () => {
    if (questionIndex < questions.length - 1) {
      setQuestionIndex((prev) => prev + 1);
      setSelectedOption(null);
      setIsAnswerSubmitted(false);
    }
  };

  return (
    <div className="min-h-screen bg-slate-50 dark:bg-slate-950 text-slate-900 dark:text-slate-100 flex flex-col font-sans">
      <Navbar currentRole="student" userName="Chidiebere Okafor" />

      <main className="max-w-3xl mx-auto px-4 sm:px-6 lg:px-8 py-8 w-full">
        <div className="flex items-center justify-between mb-4">
          <div>
            <Badge variant="mastered">Assignment</Badge>
            <h1 className="text-xl sm:text-2xl font-display font-extrabold text-slate-900 dark:text-white mt-1">{assignment.title}</h1>
          </div>
          {secondsLeft != null && (
            <span
              className={`flex items-center gap-1.5 font-mono font-bold text-lg px-3 py-1.5 rounded-xl ${
                secondsLeft <= 60 ? 'bg-rose-50 dark:bg-rose-950/50 text-rose-600 dark:text-rose-400' : 'bg-slate-100 dark:bg-slate-900 text-slate-700 dark:text-slate-300'
              }`}
            >
              <Clock className="w-4 h-4" /> {formatted}
            </span>
          )}
        </div>

        {/* Progress bar */}
        <div className="glass-card rounded-2xl p-4 mb-6 border border-slate-200 dark:border-slate-800">
          <div className="flex items-center justify-between text-xs font-semibold text-slate-600 dark:text-slate-400 mb-2">
            <span>Question {questionIndex + 1} of {questions.length}</span>
          </div>
          <div className="w-full h-2 rounded-full bg-slate-100 dark:bg-slate-800 overflow-hidden">
            <div
              className="h-full bg-indigo-600 rounded-full transition-all duration-300"
              style={{ width: `${((questionIndex + 1) / questions.length) * 100}%` }}
            />
          </div>
        </div>

        {/* Question card */}
        <div className="glass-card rounded-3xl p-6 sm:p-8 border border-indigo-100 dark:border-indigo-900/40 shadow-lg">
          <NoCopyGuard>
            <MathRenderer content={currentQuestion.question_text} className="text-lg font-bold text-slate-900 dark:text-slate-100 mb-6" />

            <div className="grid grid-cols-1 gap-3 mb-6">
              {currentQuestion.options.map((opt) => {
                const isSelected = selectedOption?.letter === opt.letter;
                let optionStyle = 'border-slate-200 dark:border-slate-800 bg-white dark:bg-slate-900 text-slate-800 dark:text-slate-200 hover:border-indigo-400';

                if (isSelected && !isAnswerSubmitted) {
                  optionStyle = 'border-indigo-600 bg-indigo-50 dark:bg-indigo-950/60 text-indigo-900 dark:text-indigo-200 ring-2 ring-indigo-500/20';
                }
                if (isAnswerSubmitted) {
                  if (opt.is_correct) {
                    optionStyle = 'border-emerald-500 bg-emerald-50 dark:bg-emerald-950/50 text-emerald-900 dark:text-emerald-200 font-bold';
                  } else if (isSelected && !opt.is_correct) {
                    optionStyle = 'border-red-500 bg-red-50 dark:bg-red-950/50 text-red-900 dark:text-red-200';
                  }
                }

                return (
                  <button
                    key={opt.letter}
                    onClick={() => handleSelectOption(opt)}
                    disabled={isAnswerSubmitted}
                    className={`w-full text-left p-4 rounded-2xl border-2 transition-all flex items-center justify-between ${optionStyle}`}
                  >
                    <div className="flex items-center gap-3">
                      <span className="w-7 h-7 rounded-lg border border-current font-bold text-xs flex items-center justify-center flex-shrink-0">
                        {opt.letter}
                      </span>
                      <MathRenderer content={opt.text} className="text-sm font-semibold" />
                    </div>
                    {isAnswerSubmitted && opt.is_correct && <CheckCircle2 className="w-5 h-5 text-emerald-600 flex-shrink-0" />}
                    {isAnswerSubmitted && isSelected && !opt.is_correct && <XCircle className="w-5 h-5 text-red-600 flex-shrink-0" />}
                  </button>
                );
              })}
            </div>
          </NoCopyGuard>

          <div className="flex items-center justify-end pt-4 border-t border-slate-100 dark:border-slate-800">
            {!isAnswerSubmitted ? (
              <button
                onClick={handleSubmitAnswer}
                disabled={!selectedOption}
                className={`px-6 py-3 rounded-2xl font-bold text-sm transition-all ${
                  selectedOption
                    ? 'bg-gradient-to-r from-indigo-600 to-cyan-600 text-white shadow-md shadow-indigo-500/20 hover:from-indigo-500 hover:to-cyan-500'
                    : 'bg-slate-200 dark:bg-slate-800 text-slate-400 cursor-not-allowed'
                }`}
              >
                Submit Answer
              </button>
            ) : questionIndex < questions.length - 1 ? (
              <button
                onClick={handleNext}
                className="px-6 py-3 rounded-2xl bg-indigo-600 hover:bg-indigo-500 text-white font-bold text-sm shadow-md flex items-center gap-2 transition-all"
              >
                Next Question <ArrowRight className="w-4 h-4" />
              </button>
            ) : (
              <span className="text-xs text-slate-500 dark:text-slate-400 flex items-center gap-1.5">
                <Award className="w-4 h-4" /> Finishing up...
              </span>
            )}
          </div>
        </div>
      </main>
    </div>
  );
}
