'use client';

import React, { Suspense, useState } from 'react';
import { useRouter, useSearchParams } from 'next/navigation';
import Link from 'next/link';
import { motion } from 'framer-motion';
import { createClient } from '@/lib/supabase/client';
import { MathoraMark, Card, Button } from '@/components/ui/Primitives';
import { LogIn, AlertCircle } from 'lucide-react';

export default function LoginPage() {
  return (
    <Suspense fallback={null}>
      <LoginForm />
    </Suspense>
  );
}

function LoginForm() {
  const router = useRouter();
  const searchParams = useSearchParams();
  const [email, setEmail] = useState('');
  const [password, setPassword] = useState('');
  const [error, setError] = useState<string | null>(null);
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
    const { error: signInError } = await supabase.auth.signInWithPassword({ email, password });
    setLoading(false);

    if (signInError) {
      setError(signInError.message);
      return;
    }

    const next = searchParams.get('next') || '/student';
    router.push(next);
    router.refresh();
  }

  return (
    <div className="min-h-screen bg-slate-950 text-slate-100 flex items-center justify-center px-4 font-sans bg-graph-paper">
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
          <h1 className="font-display text-xl font-bold text-white mb-1">Welcome back</h1>
          <p className="text-xs text-slate-400 mb-6">Sign in to continue your practice.</p>

          <form onSubmit={handleSubmit} className="space-y-4">
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
                autoComplete="current-password"
                value={password}
                onChange={(e) => setPassword(e.target.value)}
                className="w-full rounded-lg bg-slate-900 border border-slate-700 px-3 py-2.5 text-sm text-white placeholder:text-slate-500 focus:outline-none focus:ring-2 focus:ring-amber-500/50 focus:border-amber-500"
                placeholder="••••••••"
              />
            </div>

            {error && (
              <div className="flex items-start gap-2 rounded-lg bg-rose-950/60 border border-rose-900 px-3 py-2.5 text-xs text-rose-300">
                <AlertCircle className="w-4 h-4 flex-shrink-0 mt-0.5" />
                <span>{error}</span>
              </div>
            )}

            <Button type="submit" variant="primary" size="lg" disabled={loading} className="w-full font-display">
              {loading ? 'Signing in…' : 'Sign In'} <LogIn className="w-4 h-4" />
            </Button>
          </form>

          <p className="text-center text-xs text-slate-400 mt-6">
            New to Mathora?{' '}
            <Link href="/register" className="font-bold text-amber-400 hover:text-amber-300">
              Create an account
            </Link>
          </p>
        </Card>
      </motion.div>
    </div>
  );
}
