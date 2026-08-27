'use client';

import React, { useState } from 'react';
import { useRouter } from 'next/navigation';
import Link from 'next/link';
import { motion } from 'framer-motion';
import { createClient } from '@/lib/supabase/client';
import { MathoraMark, Card, Button } from '@/components/ui/Primitives';
import { UserPlus, AlertCircle, CheckCircle2 } from 'lucide-react';

// Self-serve signup is intentionally limited to these three roles.
// Admin roles (content_admin, academic_admin, ...) are never
// selectable here — see mathora_schema_auth_patch.sql's
// handle_new_user() trigger, which enforces the same allow-list
// server-side regardless of what a client sends.
const ROLES = [
  { value: 'student', label: 'Student' },
  { value: 'teacher', label: 'Teacher' },
  { value: 'parent', label: 'Parent' },
] as const;

export default function RegisterPage() {
  const router = useRouter();
  const [fullName, setFullName] = useState('');
  const [email, setEmail] = useState('');
  const [password, setPassword] = useState('');
  const [role, setRole] = useState<(typeof ROLES)[number]['value']>('student');
  const [error, setError] = useState<string | null>(null);
  const [needsConfirmation, setNeedsConfirmation] = useState(false);
  const [loading, setLoading] = useState(false);

  async function handleSubmit(e: React.FormEvent) {
    e.preventDefault();
    setError(null);

    const supabase = createClient();
    if (!supabase) {
      setError('Authentication isn’t configured yet — Supabase environment variables are missing.');
      return;
    }

    setLoading(true);
    const { data, error: signUpError } = await supabase.auth.signUp({
      email,
      password,
      options: { data: { full_name: fullName, role } },
    });
    setLoading(false);

    if (signUpError) {
      setError(signUpError.message);
      return;
    }

    if (!data.session) {
      // Email confirmation is required before a session is issued.
      setNeedsConfirmation(true);
      return;
    }

    router.push(`/${role}`);
    router.refresh();
  }

  return (
    <div className="min-h-screen bg-slate-950 text-slate-100 flex items-center justify-center px-4 py-12 font-sans bg-graph-paper">
      <motion.div
        initial={{ opacity: 0, y: 16 }}
        animate={{ opacity: 1, y: 0 }}
        transition={{ duration: 0.4 }}
        className="w-full max-w-sm"
      >
        <div className="flex items-center justify-center gap-2 mb-8">
          <MathoraMark className="w-7 h-7 text-amber-500" />
          <span className="font-display font-bold text-lg text-white">Mathora</span>
        </div>

        <Card variant="notebook" className="shadow-2xl">
          {needsConfirmation ? (
            <div className="text-center py-4">
              <CheckCircle2 className="w-10 h-10 text-emerald-400 mx-auto mb-3" />
              <h1 className="font-display text-lg font-bold text-white mb-1">Check your inbox</h1>
              <p className="text-xs text-slate-400">
                We sent a confirmation link to <span className="text-slate-200">{email}</span>. Confirm your
                email to finish creating your account.
              </p>
            </div>
          ) : (
            <>
              <h1 className="font-display text-xl font-bold text-white mb-1">Create your account</h1>
              <p className="text-xs text-slate-400 mb-6">Join Mathora as a student, teacher, or parent.</p>

              <form onSubmit={handleSubmit} className="space-y-4">
                <div>
                  <label htmlFor="fullName" className="block text-xs font-bold uppercase text-slate-400 mb-1.5">
                    Full Name
                  </label>
                  <input
                    id="fullName"
                    type="text"
                    required
                    autoComplete="name"
                    value={fullName}
                    onChange={(e) => setFullName(e.target.value)}
                    className="w-full rounded-lg bg-slate-900 border border-slate-700 px-3 py-2.5 text-sm text-white placeholder:text-slate-500 focus:outline-none focus:ring-2 focus:ring-amber-500/50 focus:border-amber-500"
                    placeholder="Chidinma Okafor"
                  />
                </div>

                <div>
                  <label htmlFor="email" className="block text-xs font-bold uppercase text-slate-400 mb-1.5">
                    Email
                  </label>
                  <input
                    id="email"
                    type="email"
                    required
                    autoComplete="email"
                    value={email}
                    onChange={(e) => setEmail(e.target.value)}
                    className="w-full rounded-lg bg-slate-900 border border-slate-700 px-3 py-2.5 text-sm text-white placeholder:text-slate-500 focus:outline-none focus:ring-2 focus:ring-amber-500/50 focus:border-amber-500"
                    placeholder="you@school.edu.ng"
                  />
                </div>

                <div>
                  <label htmlFor="password" className="block text-xs font-bold uppercase text-slate-400 mb-1.5">
                    Password
                  </label>
                  <input
                    id="password"
                    type="password"
                    required
                    minLength={8}
                    autoComplete="new-password"
                    value={password}
                    onChange={(e) => setPassword(e.target.value)}
                    className="w-full rounded-lg bg-slate-900 border border-slate-700 px-3 py-2.5 text-sm text-white placeholder:text-slate-500 focus:outline-none focus:ring-2 focus:ring-amber-500/50 focus:border-amber-500"
                    placeholder="At least 8 characters"
                  />
                </div>

                <div>
                  <span className="block text-xs font-bold uppercase text-slate-400 mb-1.5">I am a…</span>
                  <div className="grid grid-cols-3 gap-2">
                    {ROLES.map((r) => (
                      <button
                        key={r.value}
                        type="button"
                        onClick={() => setRole(r.value)}
                        className={`rounded-lg border px-2 py-2 text-xs font-bold transition-colors ${
                          role === r.value
                            ? 'bg-amber-500 text-slate-950 border-amber-400'
                            : 'bg-slate-900 border-slate-700 text-slate-300 hover:text-white'
                        }`}
                      >
                        {r.label}
                      </button>
                    ))}
                  </div>
                </div>

                {error && (
                  <div className="flex items-start gap-2 rounded-lg bg-rose-950/60 border border-rose-900 px-3 py-2.5 text-xs text-rose-300">
                    <AlertCircle className="w-4 h-4 flex-shrink-0 mt-0.5" />
                    <span>{error}</span>
                  </div>
                )}

                <Button type="submit" variant="primary" size="lg" disabled={loading} className="w-full font-display">
                  {loading ? 'Creating account…' : 'Create Account'} <UserPlus className="w-4 h-4" />
                </Button>
              </form>

              <p className="text-center text-xs text-slate-400 mt-6">
                Already have an account?{' '}
                <Link href="/login" className="font-bold text-amber-400 hover:text-amber-300">
                  Sign in
                </Link>
              </p>
            </>
          )}
        </Card>
      </motion.div>
    </div>
  );
}
