'use client';

import React, { useEffect, useMemo, useState } from 'react';
import Navbar from '@/components/Navbar';
import MathRenderer from '@/components/MathRenderer';
import RescueModeModal from '@/components/RescueModeModal';
import NoCopyGuard from '@/components/NoCopyGuard';
import { Question, QuestionOption, Topic, ClassLevel, Activity } from '@/lib/types';
import { Sparkles, CheckCircle2, XCircle, ArrowRight, RotateCcw, Lightbulb, Award, Gamepad2 } from 'lucide-react';
import Link from 'next/link';

import { fetchTopics, fetchQuestions, fetchActivities, submitQuestionAttempt, submitActivityAttempt } from '@/lib/supabase';
import { useAuth } from '@/lib/authContext';
import ActivityPlayer from '@/components/ActivityPlayer';

// See student/learn/page.tsx for the same term-grouping convention and the
// same TODO on making the level dynamic off the student's own profile.
const DEFAULT_LEVEL: ClassLevel = 'SS1';

function termOf(topic: Topic): number {
  const term = Math.floor(topic.order_index / 100);
  return term >= 1 && term <= 3 ? term : 1;
}

export default function PracticePage() {
  const { user } = useAuth();
  const [topics, setTopics] = useState<Topic[]>([]);
  const [activeTerm, setActiveTerm] = useState(1);
  const [currentTopic, setCurrentTopic] = useState<Topic | null>(null);
  const [questions, setQuestions] = useState<Question[]>([]);
  const [loading, setLoading] = useState(true);
  const [questionIndex, setQuestionIndex] = useState(0);
  const [selectedOption, setSelectedOption] = useState<QuestionOption | null>(null);
  const [isAnswerSubmitted, setIsAnswerSubmitted] = useState(false);
  const [showRescueModal, setShowRescueModal] = useState(false);
  const [score, setScore] = useState(0);

  // 'questions' is the original MCQ mode; 'activities' is the new
  // Educaplay-style ordering/matching mode (mathora_schema_activities_patch.sql).
  // Only shown as a tab when the current topic actually has any.
  const [practiceMode, setPracticeMode] = useState<'questions' | 'activities'>('questions');
  const [activities, setActivities] = useState<Activity[]>([]);
  const [activityIndex, setActivityIndex] = useState(0);

  useEffect(() => {
    fetchTopics().then((data) => {
      const levelTopics = data
        .filter((t) => t.class_level === DEFAULT_LEVEL)
        .sort((a, b) => a.order_index - b.order_index);
      const list = levelTopics.length > 0 ? levelTopics : data;
      setTopics(list);
      if (list[0]) {
        setCurrentTopic(list[0]);
        setActiveTerm(termOf(list[0]));
      }
      setLoading(false);
    });
  }, []);

  useEffect(() => {
    if (!currentTopic) return;
    fetchQuestions(currentTopic.id).then(setQuestions);
    fetchActivities(currentTopic.id).then((data) => {
      setActivities(data);
      setActivityIndex(0);
      setPracticeMode((prev) => (data.length === 0 ? 'questions' : prev));
    });
  }, [currentTopic]);

  const currentActivity: Activity | undefined = activities[activityIndex];

  const handleActivityComplete = ({ score: activityScore, time_taken_seconds }: { score: number; time_taken_seconds: number }) => {
    if (user && currentActivity) {
      submitActivityAttempt({
        studentAuthUserId: user.id,
        activity_id: currentActivity.id,
        score: activityScore,
        time_taken_seconds,
      });
    }
    setActivityIndex((prev) => prev + 1);
  };

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

  const currentQuestion: Question | undefined = questions[questionIndex];

  const handleSelectOption = (opt: QuestionOption) => {
    if (isAnswerSubmitted) return;
    setSelectedOption(opt);
  };

  const handleSubmitAnswer = () => {
    if (!selectedOption || !currentQuestion || !currentTopic) return;
    setIsAnswerSubmitted(true);
    const isCorrect = selectedOption.is_correct;

    if (isCorrect) {
      setScore((prev) => prev + 1);
    } else {
      setShowRescueModal(true);
    }

    if (!user) return; // proxy.ts already guards this route, but guard defensively too

    submitQuestionAttempt({
      student_id: user.id,
      question_id: currentQuestion.id,
      topic_id: currentTopic.id,
      selected_option: selectedOption.letter,
      is_correct: isCorrect,
      time_taken_seconds: 30,
      rescue_mode_triggered: !isCorrect,
    });
  };

  const handleNextQuestion = () => {
    if (questionIndex < questions.length - 1) {
      setQuestionIndex((prev) => prev + 1);
      setSelectedOption(null);
      setIsAnswerSubmitted(false);
    }
  };

  const handleResetQuiz = () => {
    setQuestionIndex(0);
    setSelectedOption(null);
    setIsAnswerSubmitted(false);
    setShowRescueModal(false);
    setScore(0);
  };

  return (
    <div className="min-h-screen bg-slate-50 dark:bg-slate-950 text-slate-900 dark:text-slate-100 flex flex-col">
      <Navbar currentRole="student" userName="Chidiebere Okafor" />

      <main className="max-w-4xl mx-auto px-4 sm:px-6 lg:px-8 py-8 w-full">
        {/* Topic Selector Header */}
        <div className="mb-4">
          <span className="text-xs font-bold uppercase tracking-wider text-indigo-600 dark:text-indigo-400 bg-indigo-50 dark:bg-indigo-950 px-2.5 py-1 rounded-md">
            {DEFAULT_LEVEL} Practice &amp; Remediation Engine
          </span>
          <h1 className="text-2xl font-extrabold text-slate-900 dark:text-white mt-1">
            {currentTopic?.title ?? (loading ? 'Loading...' : 'No topic selected')}
          </h1>
        </div>

        {/* Term tabs, then the weeks within that term, both horizontally
            scrollable on mobile so 33 topics never force a layout squeeze. */}
        <div className="flex gap-2 mb-2 overflow-x-auto pb-1 -mx-1 px-1">
          {[1, 2, 3].map((term) => (
            <button
              key={term}
              onClick={() => setActiveTerm(term)}
              className={`flex-shrink-0 px-3 py-1.5 rounded-xl text-xs font-bold transition-all ${
                activeTerm === term
                  ? 'bg-indigo-600 text-white'
                  : 'bg-white dark:bg-slate-900 text-slate-600 dark:text-slate-400 hover:text-indigo-600 border border-slate-200 dark:border-slate-800'
              }`}
            >
              Term {term}
            </button>
          ))}
        </div>
        <div className="flex items-center gap-2 mb-6 overflow-x-auto pb-1 -mx-1 px-1">
          {topicsInActiveTerm.map((t, i) => (
            <button
              key={t.id}
              onClick={() => {
                setCurrentTopic(t);
                handleResetQuiz();
              }}
              className={`flex-shrink-0 px-3 py-1.5 rounded-xl text-xs font-bold transition-all ${
                t.id === currentTopic?.id
                  ? 'bg-indigo-600 text-white'
                  : 'bg-white dark:bg-slate-900 text-slate-600 dark:text-slate-400 hover:text-indigo-600 border border-slate-200 dark:border-slate-800'
              }`}
            >
              Wk {i + 1}
            </button>
          ))}
        </div>

        {/* Practice mode toggle — only shown once a topic actually has
            interactive activities to switch to. */}
        {activities.length > 0 && (
          <div className="flex gap-2 mb-6">
            <button
              onClick={() => setPracticeMode('questions')}
              className={`px-3 py-1.5 rounded-xl text-xs font-bold transition-all flex items-center gap-1.5 ${
                practiceMode === 'questions'
                  ? 'bg-indigo-600 text-white'
                  : 'bg-white dark:bg-slate-900 text-slate-600 dark:text-slate-400 hover:text-indigo-600 border border-slate-200 dark:border-slate-800'
              }`}
            >
              <Sparkles className="w-3.5 h-3.5" /> Questions
            </button>
            <button
              onClick={() => setPracticeMode('activities')}
              className={`px-3 py-1.5 rounded-xl text-xs font-bold transition-all flex items-center gap-1.5 ${
                practiceMode === 'activities'
                  ? 'bg-indigo-600 text-white'
                  : 'bg-white dark:bg-slate-900 text-slate-600 dark:text-slate-400 hover:text-indigo-600 border border-slate-200 dark:border-slate-800'
              }`}
            >
              <Gamepad2 className="w-3.5 h-3.5" /> Activities
            </button>
          </div>
        )}

        {practiceMode === 'activities' ? (
          currentActivity ? (
            <>
              <div className="text-xs font-semibold text-slate-500 dark:text-slate-400 mb-2">
                Activity {activityIndex + 1} of {activities.length}
              </div>
              <ActivityPlayer key={currentActivity.id} activity={currentActivity} onComplete={handleActivityComplete} />
            </>
          ) : (
            <div className="glass-card rounded-2xl p-6 text-center border border-slate-200 dark:border-slate-800">
              <p className="text-sm text-slate-600 dark:text-slate-400">
                {activities.length === 0 ? 'No activities for this week yet.' : "You've completed every activity for this week!"}
              </p>
            </div>
          )
        ) : loading ? (
          <p className="text-sm text-slate-500 dark:text-slate-400">Loading practice questions...</p>
        ) : questions.length === 0 ? (
          <div className="glass-card rounded-2xl p-6 text-center border border-slate-200 dark:border-slate-800">
            <p className="text-sm text-slate-600 dark:text-slate-400">
              No published questions for this week yet.
            </p>
          </div>
        ) : (
        <>
        {/* Progress Bar */}
        <div className="glass-card rounded-2xl p-4 mb-6 border border-slate-200 dark:border-slate-800">
          <div className="flex items-center justify-between text-xs font-semibold text-slate-600 dark:text-slate-400 mb-2">
            <span>Question {questionIndex + 1} of {questions.length}</span>
            <span className="text-indigo-600 dark:text-indigo-400 font-bold">Exam Type: {currentQuestion?.exam_type}</span>
          </div>
          <div className="w-full h-2 rounded-full bg-slate-100 dark:bg-slate-800 overflow-hidden">
            <div
              className="h-full bg-indigo-600 rounded-full transition-all duration-300"
              style={{ width: `${((questionIndex + 1) / questions.length) * 100}%` }}
            />
          </div>
        </div>

        {/* Question Card */}
        {currentQuestion && (
          <div className="glass-card rounded-3xl p-6 sm:p-8 border border-indigo-100 dark:border-indigo-900/40 shadow-lg relative">
            <NoCopyGuard>
            <div className="flex items-start gap-3 mb-6">
              <span className="w-8 h-8 rounded-xl bg-indigo-600 text-white font-extrabold text-sm flex items-center justify-center flex-shrink-0">
                {questionIndex + 1}
              </span>
              <div className="flex-1">
                <div className="flex items-center gap-2 mb-2">
                  <span className="text-[10px] font-bold uppercase tracking-wider px-2 py-0.5 rounded bg-indigo-50 dark:bg-indigo-950 text-indigo-600">
                    Difficulty Level {currentQuestion.difficulty}/5
                  </span>
                </div>
                <MathRenderer content={currentQuestion.question_text} className="text-lg font-bold text-slate-900 dark:text-slate-100" />
              </div>
            </div>

            {/* Options Grid */}
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

                    {isAnswerSubmitted && opt.is_correct && (
                      <CheckCircle2 className="w-5 h-5 text-emerald-600 flex-shrink-0" />
                    )}
                    {isAnswerSubmitted && isSelected && !opt.is_correct && (
                      <XCircle className="w-5 h-5 text-red-600 flex-shrink-0" />
                    )}
                  </button>
                );
              })}
            </div>
            </NoCopyGuard>

            {/* Action Footer */}
            <div className="flex items-center justify-between pt-4 border-t border-slate-100 dark:border-slate-800">
              {isAnswerSubmitted && !selectedOption?.is_correct && (
                <button
                  onClick={() => setShowRescueModal(true)}
                  className="px-4 py-2 rounded-xl bg-amber-500/10 text-amber-700 dark:text-amber-300 hover:bg-amber-500/20 text-xs font-bold flex items-center gap-1.5 transition-colors"
                >
                  <Lightbulb className="w-4 h-4 text-amber-500" /> Open Rescue Mode
                </button>
              )}

              {!isAnswerSubmitted ? (
                <button
                  onClick={handleSubmitAnswer}
                  disabled={!selectedOption}
                  className={`ml-auto px-6 py-3 rounded-2xl font-bold text-sm transition-all ${
                    selectedOption
                      ? 'bg-gradient-to-r from-indigo-600 to-cyan-600 text-white shadow-md shadow-indigo-500/20 hover:from-indigo-500 hover:to-cyan-500'
                      : 'bg-slate-200 dark:bg-slate-800 text-slate-400 cursor-not-allowed'
                  }`}
                >
                  Submit Answer
                </button>
              ) : (
                <button
                  onClick={handleNextQuestion}
                  className="ml-auto px-6 py-3 rounded-2xl bg-indigo-600 hover:bg-indigo-500 text-white font-bold text-sm shadow-md flex items-center gap-2 transition-all"
                >
                  {questionIndex < questions.length - 1 ? (
                    <>Next Question <ArrowRight className="w-4 h-4" /></>
                  ) : (
                    <>Finish Topic Practice <Award className="w-4 h-4" /></>
                  )}
                </button>
              )}
            </div>
          </div>
        )}

        {/* Rescue Mode Remediation Modal */}
        {currentQuestion && selectedOption && (
          <RescueModeModal
            isOpen={showRescueModal}
            question={currentQuestion}
            selectedOptionLetter={selectedOption.letter}
            onClose={() => setShowRescueModal(false)}
            onRetry={() => {
              setShowRescueModal(false);
              setIsAnswerSubmitted(false);
              setSelectedOption(null);
            }}
          />
        )}
        </>
        )}
      </main>
    </div>
  );
}
