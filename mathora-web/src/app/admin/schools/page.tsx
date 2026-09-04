'use client';

import React, { useCallback, useEffect, useState } from 'react';
import Navbar from '@/components/Navbar';
import ConfirmDialog from '@/components/ui/ConfirmDialog';
import { ShieldCheck, School as SchoolIcon, Check, X, Trash2, BadgeCheck, Power } from 'lucide-react';

import {
  fetchSchoolsForAdmin,
  updateSchoolStatus,
  toggleSchoolVerified,
  deleteSchool,
  fetchPlatformSelfServeEnabled,
  updatePlatformSelfServeEnabled,
} from '@/lib/supabase';
import type { School, SchoolStatus } from '@/lib/types';
import { useToast } from '@/lib/toastContext';

export default function AdminSchoolsPage() {
  const showToast = useToast();
  const [activeTab, setActiveTab] = useState<SchoolStatus>('pending');
  const [schools, setSchools] = useState<School[]>([]);
  const [loading, setLoading] = useState(false);
  const [selfServeEnabled, setSelfServeEnabled] = useState(true);
  const [togglingSwitch, setTogglingSwitch] = useState(false);
  const [deleteTarget, setDeleteTarget] = useState<School | null>(null);
  const [deleting, setDeleting] = useState(false);

  const load = useCallback(async () => {
    setLoading(true);
    const [data, enabled] = await Promise.all([
      fetchSchoolsForAdmin(activeTab),
      fetchPlatformSelfServeEnabled(),
    ]);
    setSchools(data);
    setSelfServeEnabled(enabled);
    setLoading(false);
  }, [activeTab]);

  useEffect(() => {
    // eslint-disable-next-line react-hooks/set-state-in-effect
    load();
  }, [load]);

  const handleApprove = async (id: string) => {
    if (await updateSchoolStatus(id, 'active')) {
      load();
      showToast('School approved.', 'success');
    } else {
      showToast('Failed to approve school.', 'error');
    }
  };

  const handleReject = async (id: string) => {
    if (await updateSchoolStatus(id, 'rejected')) {
      load();
      showToast('School rejected.', 'success');
    } else {
      showToast('Failed to reject school.', 'error');
    }
  };

  const handleToggleVerified = async (school: School) => {
    if (await toggleSchoolVerified(school.id, !school.verified)) {
      load();
      showToast(school.verified ? 'Verification removed.' : 'School verified.', 'success');
    } else {
      showToast('Failed to update verification.', 'error');
    }
  };

  const confirmDelete = async () => {
    if (!deleteTarget) return;
    setDeleting(true);
    const ok = await deleteSchool(deleteTarget.id);
    setDeleting(false);
    setDeleteTarget(null);
    if (ok) {
      load();
      showToast('School deleted.', 'success');
    } else {
      showToast('Failed to delete school.', 'error');
    }
  };

  const handleToggleSwitch = async () => {
    setTogglingSwitch(true);
    const ok = await updatePlatformSelfServeEnabled(!selfServeEnabled);
    if (ok) setSelfServeEnabled((prev) => !prev);
    setTogglingSwitch(false);
    showToast(
      ok ? `Self-serve creation turned ${!selfServeEnabled ? 'ON' : 'OFF'}.` : 'Failed to update self-serve setting.',
      ok ? 'success' : 'error'
    );
  };

  return (
    <div className="min-h-screen bg-slate-50 dark:bg-slate-950 text-slate-900 dark:text-slate-100 flex flex-col">
      <Navbar currentRole="super_admin" userName="Dr. Adebayo Admin" />

      <main className="max-w-6xl mx-auto px-4 sm:px-6 lg:px-8 py-8 w-full">
        {/* Header */}
        <div className="flex flex-col sm:flex-row sm:items-center justify-between gap-4 mb-8">
          <div>
            <div className="inline-flex items-center gap-1.5 px-3 py-1 rounded-full bg-indigo-50 dark:bg-indigo-950 text-indigo-600 dark:text-indigo-400 text-xs font-semibold">
              <ShieldCheck className="w-3.5 h-3.5" /> School Moderation
            </div>
            <h1 className="text-2xl sm:text-3xl font-extrabold text-slate-900 dark:text-white mt-1">
              Schools Directory
            </h1>
          </div>

          {/* Site-wide kill switch */}
          <button
            onClick={handleToggleSwitch}
            disabled={togglingSwitch}
            className={`px-5 py-2.5 rounded-2xl font-bold text-xs shadow-md flex items-center gap-2 transition-all ${
              selfServeEnabled
                ? 'bg-emerald-600 hover:bg-emerald-500 text-white'
                : 'bg-slate-700 hover:bg-slate-600 text-white'
            }`}
          >
            <Power className="w-4 h-4" />
            Self-Serve Creation: {selfServeEnabled ? 'ON' : 'OFF'}
          </button>
        </div>

        {/* Tabs */}
        <div className="flex items-center gap-2 mb-8 border-b border-slate-200 dark:border-slate-800">
          {([
            { key: 'pending', label: 'Pending Review' },
            { key: 'active', label: 'Active' },
            { key: 'rejected', label: 'Rejected' },
          ] as const).map((tab) => (
            <button
              key={tab.key}
              onClick={() => setActiveTab(tab.key)}
              className={`px-4 py-2.5 text-xs font-bold border-b-2 transition-colors ${
                activeTab === tab.key
                  ? 'border-indigo-600 text-indigo-600 dark:text-indigo-400'
                  : 'border-transparent text-slate-500 hover:text-slate-700 dark:hover:text-slate-300'
              }`}
            >
              {tab.label}
            </button>
          ))}
        </div>

        {loading && <p className="text-xs text-slate-500 dark:text-slate-400">Loading...</p>}

        {!loading && schools.length === 0 && (
          <p className="text-xs text-slate-500 dark:text-slate-400">No schools in this state.</p>
        )}

        <div className="space-y-3">
          {schools.map((s) => (
            <div
              key={s.id}
              className="glass-card rounded-2xl p-4 border border-slate-200 dark:border-slate-800 flex items-center justify-between gap-4"
            >
              <div className="flex items-center gap-3">
                <div className="w-10 h-10 rounded-lg bg-indigo-50 dark:bg-indigo-950 text-indigo-500 flex items-center justify-center shrink-0">
                  <SchoolIcon className="w-5 h-5" />
                </div>
                <div>
                  <p className="text-sm font-bold flex items-center gap-1.5">
                    {s.name}
                    {s.verified && (
                      <span className="inline-flex items-center gap-1 text-[10px] font-bold text-emerald-500">
                        <BadgeCheck className="w-3.5 h-3.5" /> Verified
                      </span>
                    )}
                  </p>
                  <p className="text-xs text-slate-500">{s.state}{s.address ? ` — ${s.address}` : ''}</p>
                </div>
              </div>

              <div className="flex items-center gap-2 shrink-0">
                {activeTab === 'pending' && (
                  <>
                    <button
                      onClick={() => handleApprove(s.id)}
                      className="p-2 rounded-lg bg-emerald-600 hover:bg-emerald-500 text-white"
                      title="Approve"
                    >
                      <Check className="w-4 h-4" />
                    </button>
                    <button
                      onClick={() => handleReject(s.id)}
                      className="p-2 rounded-lg bg-rose-600 hover:bg-rose-500 text-white"
                      title="Reject"
                    >
                      <X className="w-4 h-4" />
                    </button>
                  </>
                )}
                {activeTab === 'active' && (
                  <button
                    onClick={() => handleToggleVerified(s)}
                    className={`px-3 py-2 rounded-lg text-xs font-bold ${
                      s.verified
                        ? 'bg-slate-200 dark:bg-slate-800 text-slate-600 dark:text-slate-300'
                        : 'bg-emerald-600 hover:bg-emerald-500 text-white'
                    }`}
                  >
                    {s.verified ? 'Unverify' : 'Verify'}
                  </button>
                )}
                <button
                  onClick={() => setDeleteTarget(s)}
                  className="p-2 rounded-lg bg-slate-200 dark:bg-slate-800 hover:bg-rose-600 hover:text-white text-slate-500 dark:text-slate-400 transition-colors"
                  title="Delete permanently"
                >
                  <Trash2 className="w-4 h-4" />
                </button>
              </div>
            </div>
          ))}
        </div>
      </main>

      <ConfirmDialog
        isOpen={deleteTarget !== null}
        title="Delete this school?"
        message={`"${deleteTarget?.name}" will be permanently removed. This cannot be undone.`}
        confirmLabel="Delete"
        variant="danger"
        busy={deleting}
        onConfirm={confirmDelete}
        onCancel={() => setDeleteTarget(null)}
      />
    </div>
  );
}
