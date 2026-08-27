'use client';

import React, { useState } from 'react';
import Link from 'next/link';
import Navbar from '@/components/Navbar';
import { Card, Badge, Button } from '@/components/ui/Primitives';
import {
  Search,
  School as SchoolIcon,
  User,
  BookOpen,
  CheckCircle2,
  Clock,
  ArrowRight,
  ArrowLeft,
  MapPin,
} from 'lucide-react';

import { searchSchools, fetchTeachersAtSchool, fetchClassDirectory, findOrRequestClassJoin } from '@/lib/supabase';
import type { School, ClassDirectoryEntry } from '@/lib/types';
import type { TeacherDirectoryEntry } from '@/lib/supabase';

type Step = 1 | 2 | 3 | 4 | 5;

export default function StudentJoinClassPage() {
  const [step, setStep] = useState<Step>(1);
  const [isBusy, setIsBusy] = useState(false);

  // Step 1: school
  const [schoolQuery, setSchoolQuery] = useState('');
  const [schoolResults, setSchoolResults] = useState<School[]>([]);
  const [selectedSchool, setSelectedSchool] = useState<School | null>(null);

  // Step 2: teacher
  const [teachers, setTeachers] = useState<TeacherDirectoryEntry[]>([]);
  const [selectedTeacher, setSelectedTeacher] = useState<TeacherDirectoryEntry | null>(null);

  // Step 3: class
  const [classes, setClasses] = useState<ClassDirectoryEntry[]>([]);
  const [selectedClass, setSelectedClass] = useState<ClassDirectoryEntry | null>(null);

  // Step 4: verification + result
  const [verificationValue, setVerificationValue] = useState('');
  const [outcome, setOutcome] = useState<'joined' | 'already_member' | 'pending' | null>(null);

  const handleSchoolSearch = async (e: React.FormEvent) => {
    e.preventDefault();
    if (!schoolQuery.trim()) return;
    setIsBusy(true);
    setSchoolResults(await searchSchools(schoolQuery.trim()));
    setIsBusy(false);
  };

  const pickSchool = async (school: School) => {
    setSelectedSchool(school);
    setIsBusy(true);
    setTeachers(await fetchTeachersAtSchool(school.id));
    setIsBusy(false);
    setStep(2);
  };

  const pickTeacher = async (teacher: TeacherDirectoryEntry) => {
    setSelectedTeacher(teacher);
    setIsBusy(true);
    setClasses(await fetchClassDirectory(teacher.id));
    setIsBusy(false);
    setStep(3);
  };

  const pickClass = (cls: ClassDirectoryEntry) => {
    setSelectedClass(cls);
    setStep(4);
  };

  const handleJoinSubmit = async (e: React.FormEvent) => {
    e.preventDefault();
    if (!selectedClass) return;
    setIsBusy(true);
    const result = await findOrRequestClassJoin(selectedClass.id, verificationValue.trim() || undefined);
    setIsBusy(false);
    setOutcome(result?.status ?? null);
    setStep(5);
  };

  return (
    <div className="min-h-screen bg-slate-950 text-slate-100 flex flex-col font-sans selection:bg-amber-500 selection:text-slate-950">
      <Navbar currentRole="student" userName="Chidiebere Okafor" />

      <main className="max-w-3xl mx-auto px-4 sm:px-6 lg:px-8 py-12 w-full flex-grow">
        <div className="text-center mb-8">
          <Link href="/student" className="inline-flex items-center gap-1.5 text-xs font-mono text-amber-400 hover:underline mb-4">
            <ArrowLeft className="w-3.5 h-3.5" /> Return to Dashboard
          </Link>
          <div className="flex justify-center mb-3">
            <Badge variant="bece">Find Your Class</Badge>
          </div>
          <h1 className="text-3xl font-display font-extrabold text-white">Join a Class</h1>
          <p className="text-slate-400 text-xs font-mono mt-1">
            Search for your school, teacher, and class — no invite link needed
          </p>
        </div>

        {/* Stepper */}
        <div className="flex items-center justify-between mb-8 font-mono max-w-md mx-auto">
          {[1, 2, 3, 4].map((s) => (
            <div key={s} className="flex items-center gap-2">
              <div
                className={`w-8 h-8 rounded-full flex items-center justify-center text-xs font-bold transition-all ${
                  step >= s
                    ? 'bg-amber-500 text-slate-950 shadow-md shadow-amber-500/20'
                    : 'bg-slate-900 border border-slate-800 text-slate-500'
                }`}
              >
                {step > s ? <CheckCircle2 className="w-4 h-4" /> : s}
              </div>
              {s < 4 && <div className={`w-8 sm:w-12 h-0.5 ${step > s ? 'bg-amber-500' : 'bg-slate-800'}`} />}
            </div>
          ))}
        </div>

        {/* STEP 1: School */}
        {step === 1 && (
          <Card variant="paper" className="p-8">
            <div className="flex items-center gap-3 mb-6 pb-4 border-b border-slate-800">
              <div className="p-2.5 rounded-xl bg-amber-500/10 border border-amber-500/30 text-amber-400">
                <SchoolIcon className="w-5 h-5" />
              </div>
              <div>
                <h2 className="text-lg font-display font-bold text-white">Step 1: Find your school</h2>
                <p className="text-xs font-mono text-slate-400">Search by name</p>
              </div>
            </div>
            <form onSubmit={handleSchoolSearch} className="space-y-4 font-mono">
              <div className="relative">
                <Search className="w-4 h-4 text-slate-500 absolute left-3.5 top-3.5" />
                <input
                  type="text"
                  value={schoolQuery}
                  onChange={(e) => setSchoolQuery(e.target.value)}
                  placeholder="e.g. Maryland Comprehensive High School"
                  className="w-full bg-slate-900 border border-slate-800 rounded-xl pl-10 pr-4 py-3 text-xs text-white placeholder-slate-500 focus:outline-none focus:border-amber-500 transition-colors"
                />
              </div>
              <Button variant="primary" size="lg" type="submit" className="w-full justify-center">
                {isBusy ? 'Searching...' : 'Search'} <ArrowRight className="w-4 h-4" />
              </Button>
            </form>
            <div className="mt-6 space-y-2 font-mono">
              {schoolResults.map((s) => (
                <button
                  key={s.id}
                  onClick={() => pickSchool(s)}
                  className="w-full flex items-center justify-between p-3.5 rounded-xl bg-slate-900 border border-slate-800 hover:border-amber-500/50 transition-colors text-left"
                >
                  <div>
                    <p className="text-sm font-bold text-white font-sans">{s.name}</p>
                    <p className="text-xs text-slate-400 flex items-center gap-1 mt-0.5">
                      <MapPin className="w-3 h-3" /> {s.state}
                    </p>
                  </div>
                  <ArrowRight className="w-4 h-4 text-slate-500" />
                </button>
              ))}
            </div>
          </Card>
        )}

        {/* STEP 2: Teacher */}
        {step === 2 && (
          <Card variant="paper" className="p-8">
            <div className="flex items-center gap-3 mb-6 pb-4 border-b border-slate-800">
              <div className="p-2.5 rounded-xl bg-indigo-500/10 border border-indigo-500/30 text-indigo-400">
                <User className="w-5 h-5" />
              </div>
              <div>
                <h2 className="text-lg font-display font-bold text-white">Step 2: Find your teacher</h2>
                <p className="text-xs font-mono text-slate-400">at {selectedSchool?.name}</p>
              </div>
            </div>
            {isBusy && <p className="text-xs text-slate-400 font-mono">Loading...</p>}
            {!isBusy && teachers.length === 0 && (
              <p className="text-xs text-slate-400 font-mono">No teachers found at this school yet.</p>
            )}
            <div className="space-y-2 font-mono">
              {teachers.map((t) => (
                <button
                  key={t.id}
                  onClick={() => pickTeacher(t)}
                  className="w-full flex items-center justify-between p-3.5 rounded-xl bg-slate-900 border border-slate-800 hover:border-amber-500/50 transition-colors text-left"
                >
                  <span className="text-sm font-bold text-white font-sans">{t.full_name}</span>
                  <ArrowRight className="w-4 h-4 text-slate-500" />
                </button>
              ))}
            </div>
            <Button variant="outline" size="lg" onClick={() => setStep(1)} className="w-full justify-center mt-6">
              Back
            </Button>
          </Card>
        )}

        {/* STEP 3: Class */}
        {step === 3 && (
          <Card variant="paper" className="p-8">
            <div className="flex items-center gap-3 mb-6 pb-4 border-b border-slate-800">
              <div className="p-2.5 rounded-xl bg-emerald-500/10 border border-emerald-500/30 text-emerald-400">
                <BookOpen className="w-5 h-5" />
              </div>
              <div>
                <h2 className="text-lg font-display font-bold text-white">Step 3: Find your class</h2>
                <p className="text-xs font-mono text-slate-400">taught by {selectedTeacher?.full_name}</p>
              </div>
            </div>
            {isBusy && <p className="text-xs text-slate-400 font-mono">Loading...</p>}
            {!isBusy && classes.length === 0 && (
              <p className="text-xs text-slate-400 font-mono">No classes found for this teacher yet.</p>
            )}
            <div className="space-y-2 font-mono">
              {classes.map((c) => (
                <button
                  key={c.id}
                  onClick={() => pickClass(c)}
                  className="w-full flex items-center justify-between p-3.5 rounded-xl bg-slate-900 border border-slate-800 hover:border-amber-500/50 transition-colors text-left"
                >
                  <div>
                    <p className="text-sm font-bold text-white font-sans">{c.name}</p>
                    <p className="text-xs text-amber-400">{c.class_level}</p>
                  </div>
                  <ArrowRight className="w-4 h-4 text-slate-500" />
                </button>
              ))}
            </div>
            <Button variant="outline" size="lg" onClick={() => setStep(2)} className="w-full justify-center mt-6">
              Back
            </Button>
          </Card>
        )}

        {/* STEP 4: Verification + submit */}
        {step === 4 && (
          <Card variant="paper" className="p-8">
            <div className="flex items-center gap-3 mb-6 pb-4 border-b border-slate-800">
              <div className="p-2.5 rounded-xl bg-amber-500/10 border border-amber-500/30 text-amber-400">
                <CheckCircle2 className="w-5 h-5" />
              </div>
              <div>
                <h2 className="text-lg font-display font-bold text-white">Step 4: Confirm & join</h2>
                <p className="text-xs font-mono text-slate-400">{selectedClass?.name}</p>
              </div>
            </div>
            <form onSubmit={handleJoinSubmit} className="space-y-4 font-mono">
              <div>
                <label className="text-xs font-bold text-slate-300 block mb-2">
                  Phone or admission number (if your teacher gave you one)
                </label>
                <input
                  type="text"
                  value={verificationValue}
                  onChange={(e) => setVerificationValue(e.target.value)}
                  placeholder="Optional"
                  className="w-full bg-slate-900 border border-slate-800 rounded-xl px-4 py-3 text-xs text-white placeholder-slate-500 focus:outline-none focus:border-amber-500 transition-colors"
                />
              </div>
              <div className="flex gap-3">
                <Button variant="outline" size="lg" type="button" onClick={() => setStep(3)} className="flex-1 justify-center">
                  Back
                </Button>
                <Button variant="primary" size="lg" type="submit" className="flex-1 justify-center">
                  {isBusy ? 'Submitting...' : 'Join Class'}
                </Button>
              </div>
            </form>
          </Card>
        )}

        {/* STEP 5: Outcome */}
        {step === 5 && (
          <Card variant="paper" className="p-8 text-center">
            {(outcome === 'joined' || outcome === 'already_member') && (
              <>
                <div className="w-16 h-16 rounded-full bg-emerald-500/20 border border-emerald-500/40 text-emerald-400 flex items-center justify-center mx-auto mb-4">
                  <CheckCircle2 className="w-10 h-10" />
                </div>
                <h2 className="text-2xl font-display font-extrabold text-white">
                  {outcome === 'joined' ? "You're in!" : "You're already a member"}
                </h2>
                <p className="text-slate-300 text-xs font-mono mt-2 max-w-md mx-auto">
                  You&apos;ve joined <strong className="text-amber-400">{selectedClass?.name}</strong>.
                </p>
              </>
            )}
            {outcome === 'pending' && (
              <>
                <div className="w-16 h-16 rounded-full bg-amber-500/20 border border-amber-500/40 text-amber-400 flex items-center justify-center mx-auto mb-4">
                  <Clock className="w-10 h-10" />
                </div>
                <h2 className="text-2xl font-display font-extrabold text-white">Request sent</h2>
                <p className="text-slate-300 text-xs font-mono mt-2 max-w-md mx-auto">
                  Your teacher needs to approve your request to join <strong className="text-amber-400">{selectedClass?.name}</strong>. You&apos;ll be added once they do.
                </p>
              </>
            )}
            {outcome === null && (
              <>
                <h2 className="text-xl font-display font-bold text-white">Something went wrong</h2>
                <p className="text-slate-300 text-xs font-mono mt-2">Please try again.</p>
              </>
            )}
            <div className="mt-8 flex justify-center font-mono">
              <Link href="/student">
                <Button variant="primary" size="lg">
                  Back to Dashboard <ArrowRight className="w-4 h-4" />
                </Button>
              </Link>
            </div>
          </Card>
        )}
      </main>
    </div>
  );
}
