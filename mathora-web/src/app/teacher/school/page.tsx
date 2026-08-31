'use client';

import React, { useState } from 'react';
import Link from 'next/link';
import Navbar from '@/components/Navbar';
import { Card, Badge, Button } from '@/components/ui/Primitives';
import {
  Search,
  Plus,
  CheckCircle2,
  Clock,
  ArrowRight,
  ArrowLeft,
  MapPin,
} from 'lucide-react';

import { searchSchools, createOrSuggestSchool, joinSchool } from '@/lib/supabase';
import { useAuth } from '@/lib/authContext';
import type { School } from '@/lib/types';

const NIGERIAN_STATES = [
  'Lagos', 'Ogun', 'Oyo', 'Rivers', 'Kano', 'Kaduna', 'FCT', 'Enugu', 'Anambra', 'Delta', 'Edo', 'Other',
];

type Step = 1 | 2 | 3;

export default function TeacherSchoolPage() {
  const { user } = useAuth();
  const [step, setStep] = useState<Step>(1);
  const [query, setQuery] = useState('');
  const [results, setResults] = useState<School[]>([]);
  const [searched, setSearched] = useState(false);
  const [isBusy, setIsBusy] = useState(false);
  const [error, setError] = useState<string | null>(null);

  const [newName, setNewName] = useState('');
  const [newState, setNewState] = useState('Lagos');
  const [newAddress, setNewAddress] = useState('');

  const [outcomeSchool, setOutcomeSchool] = useState<School | null>(null);

  const handleSearch = async (e: React.FormEvent) => {
    e.preventDefault();
    if (!query.trim()) return;
    setIsBusy(true);
    const found = await searchSchools(query.trim());
    setResults(found);
    setSearched(true);
    setIsBusy(false);
  };

  const handleJoin = async (school: School) => {
    if (!user?.id) return;
    setIsBusy(true);
    const ok = await joinSchool(school.id);
    setIsBusy(false);
    if (ok) {
      setOutcomeSchool(school);
      setStep(3);
    } else {
      setError('Could not join that school — try again.');
    }
  };

  const handleCreate = async (e: React.FormEvent) => {
    e.preventDefault();
    if (!newName.trim() || !user?.id) return;
    setIsBusy(true);
    setError(null);
    try {
      const school = await createOrSuggestSchool(newName.trim(), newState, newAddress.trim() || undefined);
      // A pending suggestion can't be joined yet (only status='active'
      // schools are joinable) — only join immediately if it went live.
      if (school.status === 'active') {
        await joinSchool(school.id);
      }
      setOutcomeSchool(school);
      setStep(3);
    } catch (err) {
      setError(err instanceof Error ? err.message : 'Could not create that school — try again.');
    } finally {
      setIsBusy(false);
    }
  };

  return (
    <div className="min-h-screen bg-slate-50 dark:bg-slate-950 text-slate-900 dark:text-slate-100 flex flex-col font-sans selection:bg-amber-500 selection:text-slate-950">
      <Navbar currentRole="teacher" userName="Mr. Olanrewaju Bello" />

      <main className="max-w-3xl mx-auto px-4 sm:px-6 lg:px-8 py-12 w-full flex-grow">
        <div className="text-center mb-8">
          <Link href="/teacher" className="inline-flex items-center gap-1.5 text-xs font-mono text-amber-600 dark:text-amber-400 hover:underline mb-4">
            <ArrowLeft className="w-3.5 h-3.5" /> Return to Teacher Dashboard
          </Link>
          <div className="flex justify-center mb-3">
            <Badge variant="bece">Find or Add Your School</Badge>
          </div>
          <h1 className="text-3xl font-display font-extrabold text-slate-900 dark:text-white">Join Your School</h1>
          <p className="text-slate-500 dark:text-slate-400 text-xs font-mono mt-1">
            Linking your school lets students find and request to join your classes
          </p>
        </div>

        {/* STEP 1: Search */}
        {step === 1 && (
          <Card variant="paper" className="p-8">
            <div className="flex items-center gap-3 mb-6 pb-4 border-b border-slate-200 dark:border-slate-800">
              <div className="p-2.5 rounded-xl bg-amber-500/10 border border-amber-500/30 text-amber-600 dark:text-amber-400">
                <Search className="w-5 h-5" />
              </div>
              <div>
                <h2 className="text-lg font-display font-bold text-slate-900 dark:text-white">Search for your school</h2>
                <p className="text-xs font-mono text-slate-500 dark:text-slate-400">Search first — creating a duplicate is blocked, so check here before adding a new one</p>
              </div>
            </div>

            <form onSubmit={handleSearch} className="space-y-4 font-mono">
              <div className="relative">
                <Search className="w-4 h-4 text-slate-500 absolute left-3.5 top-3.5" />
                <input
                  type="text"
                  value={query}
                  onChange={(e) => setQuery(e.target.value)}
                  placeholder="e.g. Maryland Comprehensive High School"
                  className="w-full bg-white dark:bg-slate-900 border border-slate-200 dark:border-slate-800 rounded-xl pl-10 pr-4 py-3 text-xs text-slate-900 dark:text-white placeholder-slate-500 focus:outline-none focus:border-amber-500 transition-colors"
                />
              </div>
              <Button variant="primary" size="lg" type="submit" className="w-full justify-center">
                {isBusy ? 'Searching...' : 'Search'} <ArrowRight className="w-4 h-4" />
              </Button>
            </form>

            {searched && (
              <div className="mt-6 space-y-2 font-mono">
                {results.length === 0 && (
                  <p className="text-xs text-slate-500 dark:text-slate-400 mb-3">No matching school found.</p>
                )}
                {results.map((s) => (
                  <div key={s.id} className="flex items-center justify-between p-3.5 rounded-xl bg-white dark:bg-slate-900 border border-slate-200 dark:border-slate-800">
                    <div>
                      <p className="text-sm font-bold text-slate-900 dark:text-white font-sans flex items-center gap-1.5">
                        {s.name}
                        {s.verified && <Badge variant="verified">Verified</Badge>}
                      </p>
                      <p className="text-xs text-slate-500 dark:text-slate-400 flex items-center gap-1 mt-0.5">
                        <MapPin className="w-3 h-3" /> {s.state}
                      </p>
                    </div>
                    <Button variant="outline" size="sm" onClick={() => handleJoin(s)} disabled={isBusy}>
                      Join
                    </Button>
                  </div>
                ))}
                <button
                  type="button"
                  onClick={() => setStep(2)}
                  className="w-full text-center text-xs font-mono text-amber-600 dark:text-amber-400 hover:underline pt-3"
                >
                  Can&apos;t find it? Add your school instead
                </button>
              </div>
            )}
          </Card>
        )}

        {/* STEP 2: Create / Suggest */}
        {step === 2 && (
          <Card variant="paper" className="p-8">
            <div className="flex items-center gap-3 mb-6 pb-4 border-b border-slate-200 dark:border-slate-800">
              <div className="p-2.5 rounded-xl bg-indigo-500/10 border border-indigo-500/30 text-indigo-600 dark:text-indigo-400">
                <Plus className="w-5 h-5" />
              </div>
              <div>
                <h2 className="text-lg font-display font-bold text-slate-900 dark:text-white">Add your school</h2>
                <p className="text-xs font-mono text-slate-500 dark:text-slate-400">
                  If self-serve creation is currently off, this is submitted for admin review instead of going live immediately
                </p>
              </div>
            </div>

            <form onSubmit={handleCreate} className="space-y-4 font-mono">
              <div>
                <label className="text-xs font-bold text-slate-600 dark:text-slate-300 block mb-2">School Name</label>
                <input
                  type="text"
                  value={newName}
                  onChange={(e) => setNewName(e.target.value)}
                  placeholder="e.g. Maryland Comprehensive High School"
                  className="w-full bg-white dark:bg-slate-900 border border-slate-200 dark:border-slate-800 rounded-xl px-4 py-3 text-xs text-slate-900 dark:text-white placeholder-slate-500 focus:outline-none focus:border-amber-500 transition-colors"
                  required
                />
              </div>
              <div>
                <label className="text-xs font-bold text-slate-600 dark:text-slate-300 block mb-2">State</label>
                <select
                  value={newState}
                  onChange={(e) => setNewState(e.target.value)}
                  className="w-full bg-white dark:bg-slate-900 border border-slate-200 dark:border-slate-800 rounded-xl px-4 py-3 text-xs text-slate-900 dark:text-white focus:outline-none focus:border-amber-500"
                >
                  {NIGERIAN_STATES.map((st) => (
                    <option key={st} value={st}>{st}</option>
                  ))}
                </select>
              </div>
              <div>
                <label className="text-xs font-bold text-slate-600 dark:text-slate-300 block mb-2">Address (optional)</label>
                <input
                  type="text"
                  value={newAddress}
                  onChange={(e) => setNewAddress(e.target.value)}
                  placeholder="Street, area"
                  className="w-full bg-white dark:bg-slate-900 border border-slate-200 dark:border-slate-800 rounded-xl px-4 py-3 text-xs text-slate-900 dark:text-white placeholder-slate-500 focus:outline-none focus:border-amber-500 transition-colors"
                />
              </div>

              {error && <p className="text-xs text-rose-600 dark:text-rose-400">{error}</p>}

              <div className="flex gap-3">
                <Button variant="outline" size="lg" type="button" onClick={() => setStep(1)} className="flex-1 justify-center">
                  Back
                </Button>
                <Button variant="primary" size="lg" type="submit" className="flex-1 justify-center">
                  {isBusy ? 'Submitting...' : 'Add School'}
                </Button>
              </div>
            </form>
          </Card>
        )}

        {/* STEP 3: Outcome */}
        {step === 3 && outcomeSchool && (
          <Card variant="paper" className="p-8 text-center">
            {outcomeSchool.status === 'active' ? (
              <>
                <div className="w-16 h-16 rounded-full bg-emerald-500/20 border border-emerald-500/40 text-emerald-600 dark:text-emerald-400 flex items-center justify-center mx-auto mb-4">
                  <CheckCircle2 className="w-10 h-10" />
                </div>
                <h2 className="text-2xl font-display font-extrabold text-slate-900 dark:text-white">You&apos;re linked to {outcomeSchool.name}</h2>
                <p className="text-slate-600 dark:text-slate-300 text-xs font-mono mt-2 max-w-md mx-auto">
                  Classes you create will now be discoverable by students searching for this school.
                </p>
              </>
            ) : (
              <>
                <div className="w-16 h-16 rounded-full bg-amber-500/20 border border-amber-500/40 text-amber-600 dark:text-amber-400 flex items-center justify-center mx-auto mb-4">
                  <Clock className="w-10 h-10" />
                </div>
                <h2 className="text-2xl font-display font-extrabold text-slate-900 dark:text-white">Suggestion submitted</h2>
                <p className="text-slate-600 dark:text-slate-300 text-xs font-mono mt-2 max-w-md mx-auto">
                  <strong className="text-amber-600 dark:text-amber-400">{outcomeSchool.name}</strong> is awaiting admin review. You&apos;ll be able to join it automatically once approved.
                </p>
              </>
            )}

            <div className="mt-8 flex justify-center font-mono">
              <Link href="/teacher">
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
