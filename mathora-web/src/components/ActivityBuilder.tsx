'use client';

import React, { useState } from 'react';
import { Plus, Trash2, X } from 'lucide-react';
import { Button } from './ui/Primitives';
import { createActivity } from '@/lib/supabase';
import { useAuth } from '@/lib/authContext';
import type { ActivityType, ActivityData } from '@/lib/types';

// Teacher/admin-facing form for creating one Activity
// (mathora_schema_activities_patch.sql) scoped to a single topic.
// Only builds the two highest-value types for now — 'ordering' and
// 'matching' — matching what ActivityPlayer.tsx can actually render.
export default function ActivityBuilder({
  topicId,
  topicTitle,
  onClose,
  onCreated,
}: {
  topicId: string;
  topicTitle: string;
  onClose: () => void;
  onCreated: () => void;
}) {
  const { user } = useAuth();
  const [activityType, setActivityType] = useState<ActivityType>('ordering');
  const [title, setTitle] = useState('');
  const [instructions, setInstructions] = useState('');
  const [orderingItems, setOrderingItems] = useState<string[]>(['', '']);
  const [pairs, setPairs] = useState<{ left: string; right: string }[]>([
    { left: '', right: '' },
    { left: '', right: '' },
  ]);
  const [saving, setSaving] = useState(false);
  const [error, setError] = useState<string | null>(null);

  const canSave =
    title.trim().length > 0 &&
    (activityType === 'ordering'
      ? orderingItems.filter((s) => s.trim()).length >= 2
      : pairs.filter((p) => p.left.trim() && p.right.trim()).length >= 2);

  const handleSubmit = async (e: React.FormEvent) => {
    e.preventDefault();
    if (!user || !canSave || saving) return;
    setSaving(true);
    setError(null);

    const activity_data: ActivityData =
      activityType === 'ordering'
        ? {
            activity_type: 'ordering',
            items: orderingItems.filter((s) => s.trim()),
            correct_order: orderingItems.filter((s) => s.trim()).map((_, i) => i),
          }
        : {
            activity_type: 'matching',
            pairs: pairs.filter((p) => p.left.trim() && p.right.trim()),
          };

    const result = await createActivity({
      topic_id: topicId,
      activity_type: activityType,
      title: title.trim(),
      instructions: instructions.trim() || undefined,
      activity_data,
      createdByAuthUserId: user.id,
    });

    setSaving(false);
    if (!result) {
      setError('Could not save the activity. Please try again.');
      return;
    }
    onCreated();
  };

  return (
    <div className="fixed inset-0 bg-black/50 flex items-center justify-center z-50 p-4">
      <div className="bg-white dark:bg-slate-900 rounded-2xl p-6 w-full max-w-lg border border-slate-200 dark:border-slate-800 shadow-2xl max-h-[90vh] overflow-y-auto">
        <div className="flex items-center justify-between mb-4">
          <h3 className="text-lg font-display font-bold text-slate-900 dark:text-white">New Activity — {topicTitle}</h3>
          <button onClick={onClose} className="text-slate-400 hover:text-slate-600 dark:hover:text-slate-300">
            <X className="w-5 h-5" />
          </button>
        </div>

        <form onSubmit={handleSubmit} className="space-y-4">
          <div className="flex gap-2">
            {(['ordering', 'matching'] as const).map((t) => (
              <button
                key={t}
                type="button"
                onClick={() => setActivityType(t)}
                className={`flex-1 px-3 py-2 rounded-xl text-xs font-bold capitalize transition-all ${
                  activityType === t
                    ? 'bg-indigo-600 text-white'
                    : 'bg-slate-100 dark:bg-slate-800 text-slate-600 dark:text-slate-400 border border-slate-200 dark:border-slate-700'
                }`}
              >
                {t}
              </button>
            ))}
          </div>

          <div>
            <label className="block text-xs font-bold text-slate-500 dark:text-slate-400 mb-1">Title</label>
            <input
              value={title}
              onChange={(e) => setTitle(e.target.value)}
              placeholder={activityType === 'ordering' ? 'Arrange the steps to solve...' : 'Match each term to its meaning'}
              className="w-full px-3 py-2 rounded-xl border border-slate-200 dark:border-slate-700 bg-white dark:bg-slate-950 text-sm text-slate-900 dark:text-slate-100"
              required
            />
          </div>

          <div>
            <label className="block text-xs font-bold text-slate-500 dark:text-slate-400 mb-1">Instructions (optional)</label>
            <input
              value={instructions}
              onChange={(e) => setInstructions(e.target.value)}
              className="w-full px-3 py-2 rounded-xl border border-slate-200 dark:border-slate-700 bg-white dark:bg-slate-950 text-sm text-slate-900 dark:text-slate-100"
            />
          </div>

          {activityType === 'ordering' ? (
            <div>
              <label className="block text-xs font-bold text-slate-500 dark:text-slate-400 mb-1">
                Steps, in the correct order
              </label>
              <div className="space-y-2">
                {orderingItems.map((item, i) => (
                  <div key={i} className="flex items-center gap-2">
                    <span className="w-5 text-xs font-bold text-slate-400">{i + 1}.</span>
                    <input
                      value={item}
                      onChange={(e) =>
                        setOrderingItems((prev) => prev.map((v, idx) => (idx === i ? e.target.value : v)))
                      }
                      className="flex-1 px-3 py-2 rounded-xl border border-slate-200 dark:border-slate-700 bg-white dark:bg-slate-950 text-sm text-slate-900 dark:text-slate-100"
                    />
                    <button
                      type="button"
                      onClick={() => setOrderingItems((prev) => prev.filter((_, idx) => idx !== i))}
                      disabled={orderingItems.length <= 2}
                      className="text-slate-400 hover:text-red-500 disabled:opacity-30"
                    >
                      <Trash2 className="w-4 h-4" />
                    </button>
                  </div>
                ))}
              </div>
              <button
                type="button"
                onClick={() => setOrderingItems((prev) => [...prev, ''])}
                className="mt-2 text-xs font-bold text-indigo-600 dark:text-indigo-400 flex items-center gap-1"
              >
                <Plus className="w-3.5 h-3.5" /> Add step
              </button>
            </div>
          ) : (
            <div>
              <label className="block text-xs font-bold text-slate-500 dark:text-slate-400 mb-1">Pairs</label>
              <div className="space-y-2">
                {pairs.map((pair, i) => (
                  <div key={i} className="flex items-center gap-2">
                    <input
                      value={pair.left}
                      onChange={(e) =>
                        setPairs((prev) => prev.map((p, idx) => (idx === i ? { ...p, left: e.target.value } : p)))
                      }
                      placeholder="Term"
                      className="flex-1 px-3 py-2 rounded-xl border border-slate-200 dark:border-slate-700 bg-white dark:bg-slate-950 text-sm text-slate-900 dark:text-slate-100"
                    />
                    <input
                      value={pair.right}
                      onChange={(e) =>
                        setPairs((prev) => prev.map((p, idx) => (idx === i ? { ...p, right: e.target.value } : p)))
                      }
                      placeholder="Match"
                      className="flex-1 px-3 py-2 rounded-xl border border-slate-200 dark:border-slate-700 bg-white dark:bg-slate-950 text-sm text-slate-900 dark:text-slate-100"
                    />
                    <button
                      type="button"
                      onClick={() => setPairs((prev) => prev.filter((_, idx) => idx !== i))}
                      disabled={pairs.length <= 2}
                      className="text-slate-400 hover:text-red-500 disabled:opacity-30"
                    >
                      <Trash2 className="w-4 h-4" />
                    </button>
                  </div>
                ))}
              </div>
              <button
                type="button"
                onClick={() => setPairs((prev) => [...prev, { left: '', right: '' }])}
                className="mt-2 text-xs font-bold text-indigo-600 dark:text-indigo-400 flex items-center gap-1"
              >
                <Plus className="w-3.5 h-3.5" /> Add pair
              </button>
            </div>
          )}

          {error && <p className="text-xs text-red-500 font-semibold">{error}</p>}

          <div className="flex justify-end gap-2 pt-2">
            <Button type="button" variant="outline" size="sm" onClick={onClose}>
              Cancel
            </Button>
            <Button type="submit" variant="chalk" size="sm" disabled={!canSave || saving}>
              {saving ? 'Saving…' : 'Publish Activity'}
            </Button>
          </div>
        </form>
      </div>
    </div>
  );
}
