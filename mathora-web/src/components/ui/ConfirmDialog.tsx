'use client';

import React from 'react';
import { AlertTriangle, Loader2 } from 'lucide-react';
import { Button } from '@/components/ui/Primitives';

interface ConfirmDialogProps {
  isOpen: boolean;
  title: string;
  message: string;
  confirmLabel?: string;
  cancelLabel?: string;
  variant?: 'danger' | 'default';
  busy?: boolean;
  onConfirm: () => void;
  onCancel: () => void;
}

// Shared confirmation gate for destructive/hard-to-undo actions (delete
// a school, reject a submission, remove a roster entry) — matches the
// existing modal shell pattern already used by admin's Add Question
// modal and the teacher's Create Class modal (fixed inset-0 backdrop +
// centered card), so it reads as the same app rather than a bolted-on
// dialog library.
export default function ConfirmDialog({
  isOpen,
  title,
  message,
  confirmLabel = 'Confirm',
  cancelLabel = 'Cancel',
  variant = 'default',
  busy = false,
  onConfirm,
  onCancel,
}: ConfirmDialogProps) {
  if (!isOpen) return null;

  return (
    <div className="fixed inset-0 z-50 flex items-center justify-center p-4 bg-slate-900/60 backdrop-blur-sm">
      <div className="bg-white dark:bg-slate-900 rounded-2xl max-w-sm w-full p-6 shadow-2xl border border-slate-200 dark:border-slate-800">
        <div className="flex items-start gap-3 mb-4">
          {variant === 'danger' && (
            <div className="w-9 h-9 rounded-xl bg-rose-50 dark:bg-rose-950/60 text-rose-600 dark:text-rose-400 flex items-center justify-center flex-shrink-0">
              <AlertTriangle className="w-4.5 h-4.5" />
            </div>
          )}
          <div>
            <h3 className="text-sm font-bold text-slate-900 dark:text-white">{title}</h3>
            <p className="text-xs text-slate-500 dark:text-slate-400 mt-1">{message}</p>
          </div>
        </div>

        <div className="flex items-center justify-end gap-3 pt-2">
          <button
            type="button"
            onClick={onCancel}
            disabled={busy}
            className="px-4 py-2 text-xs font-semibold text-slate-500 hover:text-slate-700 dark:hover:text-slate-300 disabled:opacity-50"
          >
            {cancelLabel}
          </button>
          <Button variant={variant === 'danger' ? 'danger' : 'chalk'} size="sm" onClick={onConfirm} disabled={busy}>
            {busy && <Loader2 className="w-3.5 h-3.5 animate-spin" />}
            {confirmLabel}
          </Button>
        </div>
      </div>
    </div>
  );
}
