'use client';

import React, { useState } from 'react';
import Link from 'next/link';
import Navbar from '@/components/Navbar';
import { Card, Badge, Button } from '@/components/ui/Primitives';
import { 
  Phone, 
  KeyRound, 
  UserCheck, 
  CheckCircle2, 
  ArrowRight, 
  ArrowLeft,
  Smartphone
} from 'lucide-react';

export default function LinkChildPage() {
  const [step, setStep] = useState<1 | 2 | 3 | 4>(1);
  const [phoneOrId, setPhoneOrId] = useState('08031234567');
  const [pinCode, setPinCode] = useState('');
  const [isVerifying, setIsVerifying] = useState(false);

  const mockFoundStudent = {
    name: 'Chidiebere Okafor',
    class: 'SS2 Science A',
    school: 'Maryland Comprehensive High School, Lagos',
    examTarget: 'WAEC 2027',
  };

  const handleStep1Submit = (e: React.FormEvent) => {
    e.preventDefault();
    if (!phoneOrId.trim()) return;
    setIsVerifying(true);
    setTimeout(() => {
      setIsVerifying(false);
      setStep(2);
    }, 800);
  };

  const handleStep2Submit = (e: React.FormEvent) => {
    e.preventDefault();
    if (pinCode.length < 4) return;
    setIsVerifying(true);
    setTimeout(() => {
      setIsVerifying(false);
      setStep(3);
    }, 800);
  };

  const handleConfirmLink = () => {
    setIsVerifying(true);
    setTimeout(() => {
      setIsVerifying(false);
      setStep(4);
    }, 1000);
  };

  return (
    <div className="min-h-screen bg-slate-950 text-slate-100 flex flex-col font-sans selection:bg-amber-500 selection:text-slate-950">
      <Navbar currentRole="parent" userName="Mrs. Folake Okafor" />

      <main className="max-w-3xl mx-auto px-4 sm:px-6 lg:px-8 py-12 w-full flex-grow">
        {/* Header */}
        <div className="text-center mb-8">
          <Link href="/parent" className="inline-flex items-center gap-1.5 text-xs font-mono text-amber-400 hover:underline mb-4">
            <ArrowLeft className="w-3.5 h-3.5" /> Return to Parent Corner
          </Link>
          <div className="flex justify-center mb-3">
            <Badge variant="bece">4-Step Verification Wizard</Badge>
          </div>
          <h1 className="text-3xl font-display font-extrabold text-white">
            Link Student Account
          </h1>
          <p className="text-slate-400 text-xs font-mono mt-1">
            Securely link your child&apos;s DCOMPANION student profile to receive progress reports
          </p>
        </div>

        {/* Stepper Progress Bar */}
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

        {/* STEP 1: Phone / Student ID */}
        {step === 1 && (
          <Card variant="paper" className="p-8">
            <div className="flex items-center gap-3 mb-6 pb-4 border-b border-slate-800">
              <div className="p-2.5 rounded-xl bg-amber-500/10 border border-amber-500/30 text-amber-400">
                <Phone className="w-5 h-5" />
              </div>
              <div>
                <h2 className="text-lg font-display font-bold text-white">Step 1: Student Phone or ID</h2>
                <p className="text-xs font-mono text-slate-400">Enter your child&apos;s registered phone number</p>
              </div>
            </div>

            <form onSubmit={handleStep1Submit} className="space-y-6 font-mono">
              <div>
                <label className="text-xs font-bold text-slate-300 block mb-2">Student Registered Phone Number</label>
                <div className="relative">
                  <Smartphone className="w-4 h-4 text-slate-500 absolute left-3.5 top-3.5" />
                  <input
                    type="text"
                    value={phoneOrId}
                    onChange={(e) => setPhoneOrId(e.target.value)}
                    placeholder="e.g. 08031234567"
                    className="w-full bg-slate-900 border border-slate-800 rounded-xl pl-10 pr-4 py-3 text-xs text-white placeholder-slate-500 focus:outline-none focus:border-amber-500 transition-colors"
                  />
                </div>
              </div>

              <Button variant="primary" size="lg" type="submit" className="w-full justify-center">
                {isVerifying ? 'Searching Account...' : 'Continue to Verification PIN'} <ArrowRight className="w-4 h-4" />
              </Button>
            </form>
          </Card>
        )}

        {/* STEP 2: Verification PIN */}
        {step === 2 && (
          <Card variant="paper" className="p-8">
            <div className="flex items-center gap-3 mb-6 pb-4 border-b border-slate-800">
              <div className="p-2.5 rounded-xl bg-indigo-500/10 border border-indigo-500/30 text-indigo-400">
                <KeyRound className="w-5 h-5" />
              </div>
              <div>
                <h2 className="text-lg font-display font-bold text-white">Step 2: Enter Student PIN</h2>
                <p className="text-xs font-mono text-slate-400">Enter the 4-digit code shown on your child&apos;s app settings</p>
              </div>
            </div>

            <form onSubmit={handleStep2Submit} className="space-y-6 font-mono">
              <div>
                <label className="text-xs font-bold text-slate-300 block mb-2">4-Digit Security PIN</label>
                <input
                  type="password"
                  maxLength={4}
                  value={pinCode}
                  onChange={(e) => setPinCode(e.target.value)}
                  placeholder="• • • •"
                  className="w-full bg-slate-900 border border-slate-800 rounded-xl px-4 py-3 text-center text-lg tracking-widest text-amber-400 placeholder-slate-600 focus:outline-none focus:border-amber-500 transition-colors"
                />
              </div>

              <div className="flex gap-3">
                <Button variant="outline" size="lg" type="button" onClick={() => setStep(1)} className="flex-1 justify-center">
                  Back
                </Button>
                <Button variant="primary" size="lg" type="submit" className="flex-1 justify-center">
                  {isVerifying ? 'Verifying PIN...' : 'Verify Student Profile'}
                </Button>
              </div>
            </form>
          </Card>
        )}

        {/* STEP 3: Confirm Profile */}
        {step === 3 && (
          <Card variant="paper" className="p-8">
            <div className="flex items-center gap-3 mb-6 pb-4 border-b border-slate-800">
              <div className="p-2.5 rounded-xl bg-emerald-500/10 border border-emerald-500/30 text-emerald-400">
                <UserCheck className="w-5 h-5" />
              </div>
              <div>
                <h2 className="text-lg font-display font-bold text-white">Step 3: Confirm Student Profile</h2>
                <p className="text-xs font-mono text-slate-400">Confirm student details before linking</p>
              </div>
            </div>

            <div className="p-5 rounded-2xl bg-slate-900 border border-slate-800 font-mono space-y-3 mb-6">
              <div className="flex items-center justify-between border-b border-slate-800/80 pb-2">
                <span className="text-xs text-slate-400">Student Name</span>
                <span className="text-sm font-bold text-white font-sans">{mockFoundStudent.name}</span>
              </div>
              <div className="flex items-center justify-between border-b border-slate-800/80 pb-2">
                <span className="text-xs text-slate-400">Class Grade</span>
                <span className="text-xs font-bold text-amber-400">{mockFoundStudent.class}</span>
              </div>
              <div className="flex items-center justify-between">
                <span className="text-xs text-slate-400">School</span>
                <span className="text-xs text-slate-300">{mockFoundStudent.school}</span>
              </div>
            </div>

            <div className="flex gap-3 font-mono">
              <Button variant="outline" size="lg" onClick={() => setStep(2)} className="flex-1 justify-center">
                Back
              </Button>
              <Button variant="chalk" size="lg" onClick={handleConfirmLink} className="flex-1 justify-center bg-emerald-600 hover:bg-emerald-500 text-white">
                {isVerifying ? 'Linking Account...' : 'Confirm & Link Student'}
              </Button>
            </div>
          </Card>
        )}

        {/* STEP 4: Success */}
        {step === 4 && (
          <Card variant="paper" className="p-8 text-center">
            <div className="w-16 h-16 rounded-full bg-emerald-500/20 border border-emerald-500/40 text-emerald-400 flex items-center justify-center mx-auto mb-4">
              <CheckCircle2 className="w-10 h-10" />
            </div>
            <h2 className="text-2xl font-display font-extrabold text-white">Account Linked Successfully!</h2>
            <p className="text-slate-300 text-xs font-mono mt-2 max-w-md mx-auto">
              You are now connected to <strong className="text-amber-400">{mockFoundStudent.name}</strong>. Weekly progress summaries and teacher notes will automatically update in your Parent Corner.
            </p>

            <div className="mt-8 flex justify-center font-mono">
              <Link href="/parent">
                <Button variant="primary" size="lg">
                  Go to Parent Corner Dashboard <ArrowRight className="w-4 h-4" />
                </Button>
              </Link>
            </div>
          </Card>
        )}
      </main>
    </div>
  );
}
