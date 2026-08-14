'use client';

import React, { useState } from 'react';
import Navbar from '@/components/Navbar';
import { Users, Plus, Award, CheckCircle2, ShieldCheck, Trophy, Sparkles } from 'lucide-react';

export default function StudentGroupsPage() {
  const [showCreateModal, setShowCreateModal] = useState(false);
  const [groupName, setGroupName] = useState('');
  const [groups, setGroups] = useState([
    {
      id: 'g-1',
      name: 'Lagos WAEC 2026 Math Champions',
      admin: 'Chidiebere (You)',
      membersCount: 6,
      targetGoal: 'Complete 50 Quadratic & Trig Questions',
      progressPercent: 78
    },
    {
      id: 'g-2',
      name: 'SS2 Further Maths Rescue Squad',
      admin: 'Amina Yusuf',
      membersCount: 4,
      targetGoal: 'Master Integration by Parts',
      progressPercent: 45
    }
  ]);

  const handleCreateGroup = (e: React.FormEvent) => {
    e.preventDefault();
    if (!groupName.trim()) return;
    setGroups((prev) => [
      ...prev,
      {
        id: `g-${Date.now()}`,
        name: groupName,
        admin: 'Chidiebere (You)',
        membersCount: 1,
        targetGoal: 'Weekly WAEC Practice Challenge',
        progressPercent: 0
      }
    ]);
    setGroupName('');
    setShowCreateModal(false);
  };

  return (
    <div className="min-h-screen bg-slate-50 dark:bg-slate-950 text-slate-900 dark:text-slate-100 flex flex-col">
      <Navbar currentRole="student" userName="Chidiebere Okafor" />

      <main className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 py-8 w-full">
        {/* Header */}
        <div className="flex flex-col sm:flex-row sm:items-center justify-between gap-4 mb-8">
          <div>
            <span className="text-xs font-bold uppercase tracking-wider text-indigo-600 dark:text-indigo-400 bg-indigo-50 dark:bg-indigo-950 px-2.5 py-0.5 rounded">
              Student Accountability Squads (Phase 2)
            </span>
            <h1 className="text-2xl sm:text-3xl font-extrabold text-slate-900 dark:text-white mt-1">
              Peer Study Groups & WAEC Challenges
            </h1>
            <p className="text-sm text-slate-600 dark:text-slate-400 mt-0.5">
              Separate from teacher-owned classes — create study squads with friends for WAEC & BECE motivation.
            </p>
          </div>

          <button
            onClick={() => setShowCreateModal(true)}
            className="px-5 py-2.5 rounded-2xl bg-gradient-to-r from-indigo-600 to-cyan-600 hover:from-indigo-500 hover:to-cyan-500 text-white font-bold text-xs shadow-md flex items-center gap-2 transition-all transform hover:-translate-y-0.5"
          >
            <Plus className="w-4 h-4" /> Create Study Squad
          </button>
        </div>

        {/* Squad Grid */}
        <div className="grid grid-cols-1 md:grid-cols-2 gap-6">
          {groups.map((g) => (
            <div key={g.id} className="glass-card rounded-2xl p-6 border border-indigo-100 dark:border-indigo-900/40 shadow-sm">
              <div className="flex items-start justify-between">
                <div>
                  <span className="text-[10px] font-bold uppercase tracking-wider px-2 py-0.5 rounded bg-indigo-50 dark:bg-indigo-950 text-indigo-600">
                    Group Admin: {g.admin}
                  </span>
                  <h3 className="text-lg font-bold text-slate-900 dark:text-white mt-1.5">{g.name}</h3>
                  <p className="text-xs text-slate-500 mt-1">Challenge: {g.targetGoal}</p>
                </div>
                <div className="w-10 h-10 rounded-xl bg-indigo-500/10 text-indigo-600 font-extrabold flex items-center justify-center">
                  <Users className="w-5 h-5" />
                </div>
              </div>

              {/* Progress */}
              <div className="mt-6 pt-4 border-t border-slate-100 dark:border-slate-800">
                <div className="flex items-center justify-between text-xs mb-1.5 font-semibold">
                  <span className="text-slate-500">Squad Target Progress</span>
                  <span className="text-indigo-600 font-bold">{g.progressPercent}%</span>
                </div>
                <div className="w-full h-2 rounded-full bg-slate-100 dark:bg-slate-800 overflow-hidden">
                  <div className="h-full bg-gradient-to-r from-indigo-500 to-cyan-400 rounded-full" style={{ width: `${g.progressPercent}%` }} />
                </div>
              </div>
            </div>
          ))}
        </div>

        {/* Modal: Create Squad */}
        {showCreateModal && (
          <div className="fixed inset-0 z-50 flex items-center justify-center p-4 bg-slate-900/60 backdrop-blur-sm">
            <form onSubmit={handleCreateGroup} className="bg-white dark:bg-slate-900 rounded-2xl max-w-md w-full p-6 shadow-2xl border border-slate-200 dark:border-slate-800">
              <h3 className="text-lg font-bold text-slate-900 dark:text-white mb-4">Create Study Squad</h3>
              <div className="mb-4">
                <label className="block text-xs font-bold uppercase text-slate-500 mb-1">Squad Name</label>
                <input
                  type="text"
                  placeholder="e.g. WAEC 2026 Math Heroes"
                  value={groupName}
                  onChange={(e) => setGroupName(e.target.value)}
                  className="w-full px-4 py-2.5 rounded-xl border border-slate-300 dark:border-slate-700 bg-slate-50 dark:bg-slate-800 text-sm focus:outline-none focus:ring-2 focus:ring-indigo-500"
                  required
                />
              </div>
              <div className="flex items-center justify-end gap-3 pt-2">
                <button
                  type="button"
                  onClick={() => setShowCreateModal(false)}
                  className="px-4 py-2 text-xs font-semibold text-slate-500 hover:text-slate-700"
                >
                  Cancel
                </button>
                <button
                  type="submit"
                  className="px-5 py-2.5 rounded-xl bg-indigo-600 text-white font-bold text-xs hover:bg-indigo-500 shadow-md"
                >
                  Create Squad
                </button>
              </div>
            </form>
          </div>
        )}
      </main>
    </div>
  );
}
