'use client';

import React, { useState } from 'react';
import Navbar from '@/components/Navbar';
import { Card, Button, Badge, MathMotif } from '@/components/ui/Primitives';
import { GraduationCap, Plus, Users, BarChart2 } from 'lucide-react';

export default function TeacherDashboard() {
  const [showClassModal, setShowClassModal] = useState(false);
  const [newClassName, setNewClassName] = useState('');
  const [classList, setClassList] = useState([
    { id: 'c1', name: 'SS2 Mathematics A', code: 'MATH-SS2A', studentsCount: 42, avgMastery: 74 },
    { id: 'c2', name: 'SS2 Further Maths', code: 'FM-SS2B', studentsCount: 28, avgMastery: 81 }
  ]);

  const handleCreateClass = (e: React.FormEvent) => {
    e.preventDefault();
    if (!newClassName.trim()) return;
    const newClass = {
      id: `c-${Date.now()}`,
      name: newClassName,
      code: `MATH-${Math.floor(1000 + Math.random() * 9000)}`,
      studentsCount: 0,
      avgMastery: 0
    };
    setClassList((prev) => [...prev, newClass]);
    setNewClassName('');
    setShowClassModal(false);
  };

  return (
    <div className="min-h-screen bg-slate-950 text-slate-100 flex flex-col font-sans">
      <Navbar currentRole="teacher" userName="Mr. Olanrewaju Bello" />

      <main className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 py-8 w-full">
        {/* Header */}
        <div className="flex flex-col sm:flex-row sm:items-center justify-between gap-4 mb-8">
          <div>
            <Badge variant="mastered">Verified Teacher Portal</Badge>
            <h1 className="text-2xl sm:text-3xl font-display font-extrabold text-white mt-1">
              Teacher Academic Ledger & Roster
            </h1>
          </div>

          <Button variant="chalk" size="md" onClick={() => setShowClassModal(true)} className="font-display">
            <Plus className="w-4 h-4" /> Create New Class
          </Button>
        </div>

        {/* Classes Grid */}
        <div className="grid grid-cols-1 md:grid-cols-2 gap-6 mb-8">
          {classList.map((cls) => (
            <Card key={cls.id} variant="ledger" className="hover:border-emerald-500/60 transition-all">
              <div className="flex items-start justify-between">
                <div>
                  <h2 className="text-lg font-display font-bold text-white">{cls.name}</h2>
                  <span className="inline-block mt-1 text-xs font-mono font-bold px-2 py-0.5 rounded bg-slate-900 text-amber-400 border border-slate-800">
                    Join Code: {cls.code}
                  </span>
                </div>
                <div className="w-10 h-10 rounded-lg bg-emerald-950/80 text-emerald-400 font-extrabold flex items-center justify-center border border-emerald-800">
                  <Users className="w-5 h-5" />
                </div>
              </div>

              <div className="grid grid-cols-2 gap-4 mt-6 pt-4 border-t border-slate-800 font-mono">
                <div>
                  <p className="text-xs text-slate-400 font-medium">Enrolled Students</p>
                  <p className="text-xl font-extrabold text-white">{cls.studentsCount}</p>
                </div>
                <div>
                  <p className="text-xs text-slate-400 font-medium">Avg Topic Mastery</p>
                  <p className="text-xl font-extrabold text-emerald-400">{cls.avgMastery}%</p>
                </div>
              </div>
            </Card>
          ))}
        </div>

        {/* Class Performance Ledger Table */}
        <Card variant="paper">
          <h2 className="text-lg font-display font-bold text-white mb-4 flex items-center gap-2">
            <BarChart2 className="w-5 h-5 text-emerald-400" /> Student Performance Ledger (SS2)
          </h2>

          <div className="overflow-x-auto">
            <table className="w-full text-left text-sm font-mono">
              <thead className="bg-slate-900 text-slate-400 text-xs uppercase border-b border-slate-800">
                <tr>
                  <th className="px-4 py-3 rounded-l-lg">Student Name</th>
                  <th className="px-4 py-3">Class</th>
                  <th className="px-4 py-3">Quadratic Equations</th>
                  <th className="px-4 py-3">Trigonometry</th>
                  <th className="px-4 py-3 rounded-r-lg">Rescue Mode Triggers</th>
                </tr>
              </thead>
              <tbody className="divide-y divide-slate-800 text-slate-200">
                <tr className="hover:bg-slate-900/50">
                  <td className="px-4 py-3.5 font-bold font-sans">Chidiebere Okafor</td>
                  <td className="px-4 py-3 text-xs">SS2 Maths A</td>
                  <td className="px-4 py-3 text-emerald-400 font-bold">65%</td>
                  <td className="px-4 py-3 text-amber-400 font-bold">40%</td>
                  <td className="px-4 py-3 text-xs text-slate-400">2 Resolved</td>
                </tr>
                <tr className="hover:bg-slate-900/50">
                  <td className="px-4 py-3.5 font-bold font-sans">Amina Yusuf</td>
                  <td className="px-4 py-3 text-xs">SS2 Maths A</td>
                  <td className="px-4 py-3 text-emerald-400 font-bold">88%</td>
                  <td className="px-4 py-3 text-emerald-400 font-bold">75%</td>
                  <td className="px-4 py-3 text-xs text-slate-400">0 Active</td>
                </tr>
                <tr className="hover:bg-slate-900/50">
                  <td className="px-4 py-3.5 font-bold font-sans">Tunde Folorunsho</td>
                  <td className="px-4 py-3 text-xs">SS2 Maths A</td>
                  <td className="px-4 py-3 text-rose-400 font-bold">30%</td>
                  <td className="px-4 py-3 text-amber-400 font-bold">45%</td>
                  <td className="px-4 py-3 text-xs text-rose-400 font-bold">3 Pending Review</td>
                </tr>
              </tbody>
            </table>
          </div>
        </Card>

        {/* Modal: Create Class */}
        {showClassModal && (
          <div className="fixed inset-0 z-50 flex items-center justify-center p-4 bg-slate-950/80 backdrop-blur-sm">
            <form onSubmit={handleCreateClass} className="bg-slate-900 rounded-2xl max-w-md w-full p-6 shadow-2xl border border-slate-800">
              <h3 className="text-lg font-display font-bold text-white mb-4">Create New Class</h3>
              <div className="mb-4">
                <label className="block text-xs font-mono font-bold uppercase text-slate-400 mb-1">Class Name</label>
                <input
                  type="text"
                  placeholder="e.g. SS2 Mathematics B"
                  value={newClassName}
                  onChange={(e) => setNewClassName(e.target.value)}
                  className="w-full px-4 py-2.5 rounded-xl border border-slate-700 bg-slate-950 text-sm focus:outline-none focus:ring-2 focus:ring-emerald-500 text-white font-mono"
                  required
                />
              </div>
              <div className="flex items-center justify-end gap-3 pt-2">
                <button
                  type="button"
                  onClick={() => setShowClassModal(false)}
                  className="px-4 py-2 text-xs font-semibold text-slate-400 hover:text-slate-200"
                >
                  Cancel
                </button>
                <Button type="submit" variant="chalk" size="sm">
                  Create Class
                </Button>
              </div>
            </form>
          </div>
        )}
      </main>
    </div>
  );
}
