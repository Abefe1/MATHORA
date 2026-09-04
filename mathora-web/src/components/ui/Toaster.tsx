'use client';

import React from 'react';
import { AnimatePresence, motion } from 'framer-motion';
import { CheckCircle2, XCircle, Info, X } from 'lucide-react';
import { useToastContext, type ToastVariant } from '@/lib/toastContext';

const VARIANT_STYLE: Record<ToastVariant, { tone: string; icon: React.ReactNode }> = {
  success: {
    tone: 'bg-emerald-50 dark:bg-emerald-950/90 text-emerald-800 dark:text-emerald-200 border-emerald-200 dark:border-emerald-800',
    icon: <CheckCircle2 className="w-4 h-4 flex-shrink-0" />,
  },
  error: {
    tone: 'bg-rose-50 dark:bg-rose-950/90 text-rose-800 dark:text-rose-200 border-rose-200 dark:border-rose-800',
    icon: <XCircle className="w-4 h-4 flex-shrink-0" />,
  },
  info: {
    tone: 'bg-slate-100 dark:bg-slate-800/90 text-slate-800 dark:text-slate-200 border-slate-200 dark:border-slate-700',
    icon: <Info className="w-4 h-4 flex-shrink-0" />,
  },
};

// Mounted once at the root layout, alongside ThemeProvider/AuthProvider —
// individual pages just call useToast() and never render anything
// themselves.
export default function Toaster() {
  const { toasts, dismissToast } = useToastContext();

  return (
    <div className="fixed bottom-4 right-4 z-[100] flex flex-col gap-2 w-full max-w-sm pointer-events-none">
      <AnimatePresence>
        {toasts.map((t) => {
          const { tone, icon } = VARIANT_STYLE[t.variant];
          return (
            <motion.div
              key={t.id}
              initial={{ opacity: 0, y: 12, scale: 0.96 }}
              animate={{ opacity: 1, y: 0, scale: 1 }}
              exit={{ opacity: 0, x: 24 }}
              className={`pointer-events-auto flex items-start gap-2 rounded-xl border px-4 py-3 text-sm font-semibold shadow-lg ${tone}`}
            >
              {icon}
              <span className="flex-1">{t.message}</span>
              <button
                onClick={() => dismissToast(t.id)}
                className="flex-shrink-0 opacity-60 hover:opacity-100 transition-opacity"
                aria-label="Dismiss"
              >
                <X className="w-3.5 h-3.5" />
              </button>
            </motion.div>
          );
        })}
      </AnimatePresence>
    </div>
  );
}
