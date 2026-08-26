'use client';

import React, { useState } from 'react';
import Link from 'next/link';
import Navbar from '@/components/Navbar';
import { Card, Badge, Button, DCompanionMark } from '@/components/ui/Primitives';
import { 
  ShieldCheck, 
  TrendingUp, 
  Clock, 
  AlertTriangle, 
  MessageSquare, 
  Share2, 
  Lock, 
  CheckCircle2, 
  Award, 
  BookOpen, 
  Send,
  Zap,
  Smartphone,
  Check
} from 'lucide-react';

interface ChildProfile {
  id: string;
  name: string;
  class: string;
  school: string;
  examTarget: string;
  overallMastery: number;
  weeklyHours: number;
  targetHours: number;
  weeklyChange: string;
  readinessScore: number;
  weakTopic: string;
  weakMastery: number;
  teacherNote: string;
  teacherName: string;
  topics: { name: string; category: string; mastery: number; status: 'mastered' | 'progress' | 'struggling' }[];
  rescueSessions: { topic: string; date: string; errorsSolved: number }[];
}

const mockChildren: ChildProfile[] = [
  {
    id: 'ch-1',
    name: 'Chidiebere Okafor',
    class: 'SS2 Science A',
    school: 'Maryland Comprehensive High School, Lagos',
    examTarget: 'WAEC 2027 Mathematics',
    overallMastery: 72.4,
    weeklyHours: 4.5,
    targetHours: 4.0,
    weeklyChange: '+8.2%',
    readinessScore: 81,
    weakTopic: 'Trigonometric Ratios & Elevation',
    weakMastery: 40,
    teacherNote: 'Chidiebere has improved greatly in Quadratic Factorization this week! Recommend continuing Rescue Mode practice on Trigonometry.',
    teacherName: 'Mr. Olanrewaju Bello (Mathematics HOD)',
    topics: [
      { name: 'Quadratic Equations & Factorization', category: 'Algebra', mastery: 85, status: 'mastered' },
      { name: 'Trigonometric Ratios & Elevation', category: 'Trigonometry', mastery: 40, status: 'struggling' },
      { name: 'Logarithms & Indices', category: 'Algebra', mastery: 78, status: 'progress' },
      { name: 'Statistics & Frequency Polygons', category: 'Statistics', mastery: 90, status: 'mastered' },
      { name: 'Simultaneous Linear Equations', category: 'Algebra', mastery: 68, status: 'progress' },
    ],
    rescueSessions: [
      { topic: 'Sine & Cosine Rules', date: 'Yesterday, 4:15 PM', errorsSolved: 6 },
      { topic: 'Quadratic Curves Roots', date: '24 Aug, 6:30 PM', errorsSolved: 9 },
    ],
  },
  {
    id: 'ch-2',
    name: 'Nneka Okafor',
    class: 'JSS3 Blue',
    school: 'Maryland Comprehensive High School, Lagos',
    examTarget: 'BECE 2026 Mathematics',
    overallMastery: 88.0,
    weeklyHours: 5.2,
    targetHours: 3.5,
    weeklyChange: '+12.5%',
    readinessScore: 94,
    weakTopic: 'Plane Geometry & Angle Proofs',
    weakMastery: 62,
    teacherNote: 'Nneka is showing top-tier speed in BECE Algebra practice! Keep encouraging her daily streak.',
    teacherName: 'Mrs. Cynthia Agbo (Basic Math Teacher)',
    topics: [
      { name: 'Basic Algebra & Expansion', category: 'Algebra', mastery: 95, status: 'mastered' },
      { name: 'Fractions, Decimals & Percentages', category: 'Number Base', mastery: 92, status: 'mastered' },
      { name: 'Plane Geometry & Angle Proofs', category: 'Geometry', mastery: 62, status: 'struggling' },
      { name: 'Construction & Loci', category: 'Geometry', mastery: 84, status: 'mastered' },
    ],
    rescueSessions: [
      { topic: 'Angles in a Circle', date: 'Today, 2:10 PM', errorsSolved: 4 },
    ],
  },
];

export default function ParentDashboard() {
  const [selectedChildId, setSelectedChildId] = useState<string>('ch-1');
  const [activeTab, setActiveTab] = useState<'overview' | 'weakness' | 'teacher' | 'controls'>('overview');
  const [encouragementText, setEncouragementText] = useState('');
  const [sentNotice, setSentNotice] = useState(false);
  const [copiedReport, setCopiedReport] = useState(false);
  const [dailyLimit, setDailyLimit] = useState(60);
  const [pinLockEnabled, setPinLockEnabled] = useState(true);

  const child = mockChildren.find((c) => c.id === selectedChildId) || mockChildren[0];

  const handleSendEncouragement = (e: React.FormEvent) => {
    e.preventDefault();
    if (!encouragementText.trim()) return;
    setSentNotice(true);
    setTimeout(() => {
      setSentNotice(false);
      setEncouragementText('');
    }, 3000);
  };

  const generateWhatsAppReport = () => {
    const text = `📊 *DCOMPANION Parent Progress Summary*\n` +
      `👤 *Student:* ${child.name} (${child.class})\n` +
      `🎯 *Exam Target:* ${child.examTarget}\n` +
      `⭐ *Overall Mastery:* ${child.overallMastery}%\n` +
      `📈 *WAEC/BECE Readiness:* ${child.readinessScore}/100\n` +
      `⏱️ *Weekly Study Time:* ${child.weeklyHours} hrs (Target: ${child.targetHours} hrs)\n` +
      `⚠️ *Needs Attention:* ${child.weakTopic} (${child.weakMastery}%)\n` +
      `📝 *Teacher Note:* "${child.teacherNote}"\n\n` +
      `Sent via DCOMPANION (D-Math Companion) Parent Corner.`;

    navigator.clipboard.writeText(text);
    setCopiedReport(true);
    setTimeout(() => setCopiedReport(false), 3000);
  };

  return (
    <div className="min-h-screen bg-slate-950 text-slate-100 flex flex-col font-sans selection:bg-amber-500 selection:text-slate-950">
      <Navbar currentRole="parent" userName="Mrs. Folake Okafor" />

      <main className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 py-8 w-full flex-grow">
        {/* Top Header & Child Switcher Bar */}
        <div className="flex flex-col md:flex-row md:items-center justify-between gap-4 mb-8 bg-slate-900/80 p-6 rounded-3xl border border-slate-800 backdrop-blur-md shadow-2xl">
          <div className="flex items-center gap-4">
            <div className="w-14 h-14 rounded-2xl bg-amber-500/10 border border-amber-500/30 flex items-center justify-center text-amber-400 font-display font-extrabold text-2xl shadow-inner">
              <DCompanionMark className="w-9 h-9 text-amber-400" />
            </div>
            <div>
              <div className="flex items-center gap-2">
                <Badge variant="bece">Parent Corner Portal</Badge>
                <span className="text-[11px] font-mono text-emerald-400 flex items-center gap-1">
                  <ShieldCheck className="w-3.5 h-3.5" /> Direct Parent Lock Active
                </span>
              </div>
              <h1 className="text-2xl sm:text-3xl font-display font-extrabold text-white mt-1">
                Parent &amp; Guardian Portal
              </h1>
              <p className="text-slate-400 text-xs font-mono mt-0.5">
                Real-time WAEC/BECE syllabus mastery &amp; study time oversight
              </p>
            </div>
          </div>

          {/* Child Selector Tabs */}
          <div className="flex flex-wrap items-center gap-2 bg-slate-950 p-1.5 rounded-2xl border border-slate-800 font-mono">
            {mockChildren.map((ch) => (
              <button
                key={ch.id}
                onClick={() => setSelectedChildId(ch.id)}
                className={`px-4 py-2 rounded-xl text-xs font-bold transition-all flex items-center gap-2 ${
                  selectedChildId === ch.id
                    ? 'bg-amber-500 text-slate-950 shadow-md shadow-amber-500/20 scale-[1.02]'
                    : 'text-slate-400 hover:text-white hover:bg-slate-900'
                }`}
              >
                <BookOpen className="w-3.5 h-3.5" />
                {ch.name}
              </button>
            ))}

            <Link href="/parent/link-child">
              <span className="px-3 py-2 rounded-xl text-xs font-bold bg-indigo-600/20 border border-indigo-500/40 text-indigo-300 hover:bg-indigo-600/30 transition-all inline-flex items-center gap-1.5 cursor-pointer">
                + Link Student Account
              </span>
            </Link>
          </div>
        </div>

        {/* Selected Child Banner Card */}
        <Card variant="report" className="mb-8 border-amber-900/40 bg-gradient-to-r from-amber-950/30 via-slate-900 to-indigo-950/20">
          <div className="flex flex-col lg:flex-row items-start lg:items-center justify-between gap-6">
            <div>
              <div className="flex items-center gap-3">
                <span className="text-xs font-mono font-bold text-amber-400 bg-amber-950/80 px-2.5 py-1 rounded-md border border-amber-800/80">
                  {child.class}
                </span>
                <span className="text-xs font-mono text-slate-400">
                  {child.school}
                </span>
              </div>
              <h2 className="text-2xl font-display font-extrabold text-white mt-2 flex items-center gap-3">
                {child.name}
                <span className="text-xs font-mono font-normal text-emerald-400 bg-emerald-950/80 px-2.5 py-1 rounded-full border border-emerald-800/80 flex items-center gap-1">
                  <CheckCircle2 className="w-3.5 h-3.5" /> Enrolled in {child.examTarget}
                </span>
              </h2>
            </div>

            <div className="flex items-center gap-4 w-full lg:w-auto">
              <div className="flex-1 lg:flex-none bg-slate-900/90 px-5 py-3.5 rounded-2xl border border-slate-800 font-mono text-center sm:text-right">
                <span className="text-[11px] text-slate-400 font-medium block">Curriculum Mastery</span>
                <p className="text-3xl font-extrabold text-emerald-400 mt-0.5">{child.overallMastery}%</p>
              </div>

              <div className="flex-1 lg:flex-none bg-slate-900/90 px-5 py-3.5 rounded-2xl border border-slate-800 font-mono text-center sm:text-right">
                <span className="text-[11px] text-slate-400 font-medium block">Exam Readiness</span>
                <p className="text-3xl font-extrabold text-amber-400 mt-0.5">{child.readinessScore}<span className="text-xs text-slate-500 font-normal">/100</span></p>
              </div>

              <Button 
                variant="chalk" 
                size="md" 
                onClick={generateWhatsAppReport}
                className="hidden sm:inline-flex bg-emerald-600 hover:bg-emerald-500 text-white shadow-emerald-600/20"
              >
                {copiedReport ? <Check className="w-4 h-4 text-white" /> : <Share2 className="w-4 h-4" />}
                {copiedReport ? 'Report Copied!' : 'WhatsApp Share'}
              </Button>
            </div>
          </div>
        </Card>

        {/* Navigation Tabs */}
        <div className="flex items-center gap-2 border-b border-slate-800 mb-8 overflow-x-auto pb-1 scrollbar-none font-mono">
          <button
            onClick={() => setActiveTab('overview')}
            className={`px-5 py-3 text-xs font-bold rounded-t-xl transition-all flex items-center gap-2 border-b-2 whitespace-nowrap ${
              activeTab === 'overview'
                ? 'border-amber-400 text-amber-400 bg-amber-500/10'
                : 'border-transparent text-slate-400 hover:text-slate-200 hover:bg-slate-900'
            }`}
          >
            <TrendingUp className="w-4 h-4" /> Mastery &amp; Progress Overview
          </button>

          <button
            onClick={() => setActiveTab('weakness')}
            className={`px-5 py-3 text-xs font-bold rounded-t-xl transition-all flex items-center gap-2 border-b-2 whitespace-nowrap ${
              activeTab === 'weakness'
                ? 'border-amber-400 text-amber-400 bg-amber-500/10'
                : 'border-transparent text-slate-400 hover:text-slate-200 hover:bg-slate-900'
            }`}
          >
            <AlertTriangle className="w-4 h-4 text-amber-400" /> Weak Topics &amp; Rescue Alerts
          </button>

          <button
            onClick={() => setActiveTab('teacher')}
            className={`px-5 py-3 text-xs font-bold rounded-t-xl transition-all flex items-center gap-2 border-b-2 whitespace-nowrap ${
              activeTab === 'teacher'
                ? 'border-amber-400 text-amber-400 bg-amber-500/10'
                : 'border-transparent text-slate-400 hover:text-slate-200 hover:bg-slate-900'
            }`}
          >
            <MessageSquare className="w-4 h-4" /> Teacher Feed &amp; Encouragement
          </button>

          <button
            onClick={() => setActiveTab('controls')}
            className={`px-5 py-3 text-xs font-bold rounded-t-xl transition-all flex items-center gap-2 border-b-2 whitespace-nowrap ${
              activeTab === 'controls'
                ? 'border-amber-400 text-amber-400 bg-amber-500/10'
                : 'border-transparent text-slate-400 hover:text-slate-200 hover:bg-slate-900'
            }`}
          >
            <Lock className="w-4 h-4" /> Parent Controls &amp; PIN Lock
          </button>
        </div>

        {/* TAB 1: OVERVIEW */}
        {activeTab === 'overview' && (
          <div className="space-y-8">
            {/* Quick Metrics Grid */}
            <div className="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-4 gap-6 font-mono">
              <Card variant="paper" className="relative overflow-hidden">
                <span className="text-xs font-semibold text-slate-400 flex items-center gap-1.5">
                  <TrendingUp className="w-4 h-4 text-emerald-400" /> Weekly Growth
                </span>
                <p className="text-3xl font-extrabold text-emerald-400 mt-2">{child.weeklyChange}</p>
                <p className="text-[11px] text-slate-400 mt-1">Syllabus topics mastered vs last week</p>
              </Card>

              <Card variant="paper">
                <span className="text-xs font-semibold text-slate-400 flex items-center gap-1.5">
                  <Clock className="w-4 h-4 text-amber-400" /> Weekly Study Time
                </span>
                <p className="text-3xl font-extrabold text-amber-400 mt-2">{child.weeklyHours} hrs</p>
                <p className="text-[11px] text-slate-400 mt-1">Parent Target: {child.targetHours} hrs/week</p>
              </Card>

              <Card variant="paper" className="border-amber-800/80 bg-amber-950/20">
                <span className="text-xs font-bold text-amber-300 flex items-center gap-1.5">
                  <AlertTriangle className="w-4 h-4 text-amber-400" /> Topic Needing Attention
                </span>
                <p className="text-lg font-bold text-white mt-2 font-sans truncate">{child.weakTopic}</p>
                <p className="text-[11px] text-amber-300 mt-1">{child.weakMastery}% current accuracy (Rescue active)</p>
              </Card>

              <Card variant="paper">
                <span className="text-xs font-semibold text-slate-400 flex items-center gap-1.5">
                  <Award className="w-4 h-4 text-cyan-400" /> Exam Readiness
                </span>
                <p className="text-3xl font-extrabold text-cyan-400 mt-2">Grade A1 Track</p>
                <p className="text-[11px] text-slate-400 mt-1">Based on WAEC standard difficulty</p>
              </Card>
            </div>

            {/* Detailed Topic Mastery Breakdown */}
            <Card variant="paper">
              <div className="flex items-center justify-between mb-6">
                <div>
                  <h3 className="text-lg font-display font-bold text-white">Curriculum Mastery Breakdown</h3>
                  <p className="text-xs font-mono text-slate-400">Aligned with NERDC &amp; WAEC Syllabus Standards</p>
                </div>
                <span className="text-xs font-mono text-amber-400 bg-amber-950/80 px-3 py-1 rounded-lg border border-amber-800/80">
                  {child.topics.length} Key Topics Tracked
                </span>
              </div>

              <div className="space-y-4 font-mono">
                {child.topics.map((t, idx) => (
                  <div key={idx} className="p-4 rounded-xl bg-slate-900/90 border border-slate-800 hover:border-slate-700 transition-colors">
                    <div className="flex flex-col sm:flex-row sm:items-center justify-between gap-2 mb-2">
                      <div className="flex items-center gap-3">
                        <span className="text-[10px] font-bold uppercase tracking-wider px-2 py-0.5 rounded bg-slate-800 text-slate-300">
                          {t.category}
                        </span>
                        <span className="font-bold text-sm text-slate-100 font-sans">{t.name}</span>
                      </div>
                      <div className="flex items-center gap-3">
                        <span className={`text-xs font-bold ${
                          t.status === 'mastered' ? 'text-emerald-400' : t.status === 'progress' ? 'text-cyan-400' : 'text-amber-400'
                        }`}>
                          {t.mastery}% Mastery
                        </span>
                        <Badge variant={t.status === 'mastered' ? 'mastered' : t.status === 'progress' ? 'waec' : 'struggling'}>
                          {t.status === 'mastered' ? 'Mastered' : t.status === 'progress' ? 'In Progress' : 'Needs Practice'}
                        </Badge>
                      </div>
                    </div>

                    <div className="w-full h-2.5 rounded-full bg-slate-950 border border-slate-800 overflow-hidden">
                      <div
                        className={`h-full rounded-full transition-all duration-500 ${
                          t.status === 'mastered' ? 'bg-emerald-500' : t.status === 'progress' ? 'bg-cyan-500' : 'bg-amber-500'
                        }`}
                        style={{ width: `${t.mastery}%` }}
                      />
                    </div>
                  </div>
                ))}
              </div>
            </Card>
          </div>
        )}

        {/* TAB 2: WEAKNESS & RESCUE ALERTS */}
        {activeTab === 'weakness' && (
          <div className="space-y-8">
            <Card variant="paper" className="border-amber-800/80 bg-amber-950/20">
              <div className="flex items-start gap-4">
                <div className="p-3 bg-amber-500/20 rounded-2xl border border-amber-500/40 text-amber-400">
                  <AlertTriangle className="w-7 h-7" />
                </div>
                <div>
                  <h3 className="text-xl font-display font-bold text-white">Topic Requiring Parent Attention</h3>
                  <p className="text-slate-300 text-sm mt-1 font-sans">
                    DCOMPANION automatic diagnostic detected struggle patterns in <strong className="text-amber-400">{child.weakTopic}</strong>.
                  </p>
                  <div className="mt-4 flex flex-wrap items-center gap-3 font-mono text-xs">
                    <span className="px-3 py-1 rounded-lg bg-amber-900/60 border border-amber-700/60 text-amber-200">
                      Current Mastery: {child.weakMastery}%
                    </span>
                    <span className="px-3 py-1 rounded-lg bg-slate-900 border border-slate-800 text-slate-300">
                      Recommended Action: 20 mins targeted Rescue Mode session
                    </span>
                  </div>
                </div>
              </div>
            </Card>

            <Card variant="paper">
              <h3 className="text-lg font-display font-bold text-white mb-4">Recent Automatic Rescue Practice Sessions</h3>
              <div className="space-y-3 font-mono">
                {child.rescueSessions.map((session, idx) => (
                  <div key={idx} className="p-4 rounded-xl bg-slate-900 border border-slate-800 flex items-center justify-between">
                    <div className="flex items-center gap-3">
                      <div className="w-8 h-8 rounded-lg bg-purple-950/80 border border-purple-800 flex items-center justify-center text-purple-300">
                        <Zap className="w-4 h-4" />
                      </div>
                      <div>
                        <h4 className="font-bold text-sm text-slate-200 font-sans">{session.topic}</h4>
                        <span className="text-[11px] text-slate-400">{session.date}</span>
                      </div>
                    </div>
                    <span className="text-xs font-bold text-emerald-400 bg-emerald-950 px-3 py-1 rounded-lg border border-emerald-800">
                      +{session.errorsSolved} Mistakes Corrected
                    </span>
                  </div>
                ))}
              </div>
            </Card>
          </div>
        )}

        {/* TAB 3: TEACHER FEED & ENCOURAGEMENT */}
        {activeTab === 'teacher' && (
          <div className="grid grid-cols-1 lg:grid-cols-2 gap-8">
            <Card variant="paper">
              <span className="text-xs font-mono font-bold text-cyan-400 uppercase tracking-wider block mb-2">
                VERIFIED TEACHER REMARK
              </span>
              <div className="p-5 rounded-2xl bg-indigo-950/30 border border-indigo-800/50">
                <p className="text-slate-100 text-sm font-medium italic leading-relaxed font-sans">
                  &ldquo;{child.teacherNote}&rdquo;
                </p>
                <div className="mt-4 pt-3 border-t border-indigo-900/60 flex items-center justify-between text-xs font-mono text-indigo-300">
                  <span>{child.teacherName}</span>
                  <Badge variant="verified">Verified Teacher</Badge>
                </div>
              </div>
            </Card>

            <Card variant="paper">
              <h3 className="text-lg font-display font-bold text-white mb-2">Send Encouragement Note to Student</h3>
              <p className="text-xs font-mono text-slate-400 mb-4">
                This note will display at the top of {child.name}&apos;s DCOMPANION student dashboard upon sign-in.
              </p>

              <form onSubmit={handleSendEncouragement} className="space-y-4 font-mono">
                <textarea
                  rows={3}
                  value={encouragementText}
                  onChange={(e) => setEncouragementText(e.target.value)}
                  placeholder="e.g. Keep up the good work on Quadratic Equations! Proud of your effort."
                  className="w-full bg-slate-900 border border-slate-800 rounded-xl p-3 text-xs text-white placeholder-slate-500 focus:outline-none focus:border-amber-500 transition-colors"
                />

                <div className="flex items-center justify-between">
                  {sentNotice ? (
                    <span className="text-xs text-emerald-400 font-bold flex items-center gap-1">
                      <CheckCircle2 className="w-4 h-4" /> Message sent to {child.name}!
                    </span>
                  ) : (
                    <span className="text-[11px] text-slate-400">Direct Parent-Child Connection</span>
                  )}

                  <Button variant="primary" size="sm" type="submit">
                    Send Note <Send className="w-3.5 h-3.5" />
                  </Button>
                </div>
              </form>
            </Card>
          </div>
        )}

        {/* TAB 4: PARENT CONTROLS */}
        {activeTab === 'controls' && (
          <div className="grid grid-cols-1 lg:grid-cols-2 gap-8 font-mono">
            <Card variant="paper">
              <h3 className="text-lg font-display font-bold text-white mb-1">Daily Study Allocation &amp; Time Limits</h3>
              <p className="text-xs text-slate-400 mb-6">Manage how long {child.name} practices daily on DCOMPANION.</p>

              <div className="space-y-6">
                <div>
                  <div className="flex items-center justify-between mb-2">
                    <span className="text-xs font-bold text-slate-200">Daily Recommended Practice Limit</span>
                    <span className="text-xs font-bold text-amber-400">{dailyLimit} Minutes / Day</span>
                  </div>
                  <input
                    type="range"
                    min={20}
                    max={180}
                    step={10}
                    value={dailyLimit}
                    onChange={(e) => setDailyLimit(Number(e.target.value))}
                    className="w-full accent-amber-500 cursor-pointer"
                  />
                  <div className="flex justify-between text-[10px] text-slate-500 mt-1">
                    <span>20 mins</span>
                    <span>60 mins</span>
                    <span>180 mins</span>
                  </div>
                </div>

                <div className="p-4 rounded-xl bg-slate-900 border border-slate-800 flex items-center justify-between">
                  <div>
                    <h4 className="text-xs font-bold text-white">Parent Lock PIN Code</h4>
                    <p className="text-[11px] text-slate-400">Requires 4-digit PIN to leave Parent Corner</p>
                  </div>
                  <button
                    onClick={() => setPinLockEnabled(!pinLockEnabled)}
                    className={`px-3 py-1.5 rounded-lg text-xs font-bold transition-colors ${
                      pinLockEnabled
                        ? 'bg-emerald-950 text-emerald-300 border border-emerald-800'
                        : 'bg-slate-800 text-slate-400 border border-slate-700'
                    }`}
                  >
                    {pinLockEnabled ? 'PIN Lock Enabled' : 'PIN Lock Disabled'}
                  </button>
                </div>
              </div>
            </Card>

            <Card variant="paper">
              <h3 className="text-lg font-display font-bold text-white mb-1">Instant Share &amp; Export</h3>
              <p className="text-xs text-slate-400 mb-6">Export reports for PTA meetings or home lesson tutors.</p>

              <div className="space-y-4">
                <Button 
                  variant="chalk" 
                  size="md" 
                  onClick={generateWhatsAppReport}
                  className="w-full justify-center bg-emerald-600 hover:bg-emerald-500 text-white shadow-emerald-600/20"
                >
                  <Smartphone className="w-4 h-4" /> Share Summary Report via WhatsApp
                </Button>

                <Button 
                  variant="outline" 
                  size="md" 
                  onClick={() => alert("Report downloaded as text digest.")}
                  className="w-full justify-center"
                >
                  <Share2 className="w-4 h-4 text-cyan-400" /> Export Printable Syllabus Digest
                </Button>
              </div>
            </Card>
          </div>
        )}
      </main>
    </div>
  );
}
