'use client';

import React from 'react';
import { motion } from 'framer-motion';

// --- Signature DCOMPANION Brand Mark ---
export function DCompanionMark({ className = 'w-6 h-6', color = 'currentColor' }: { className?: string; color?: string }) {
  return (
    <svg viewBox="0 0 32 32" fill="none" xmlns="http://www.w3.org/2000/svg" className={className}>
      {/* Outer Hex/Rounded Square Glass Container */}
      <rect x="2" y="2" width="28" height="28" rx="8" stroke={color} strokeWidth="2.2" strokeOpacity="0.9" fill="url(#dcompanion-gradient)" fillOpacity="0.15" />
      {/* Bold 'D' Arc Motif */}
      <path d="M9 7H16C21 7 24 10.5 24 16C24 21.5 21 25 16 25H9V7Z" stroke="#F59E0B" strokeWidth="2.5" strokeLinecap="round" strokeLinejoin="round" />
      {/* Internal Math Square Root + Function Curve inside D */}
      <path d="M12 16L14 18.5L16.5 13.5H20" stroke="#06B6D4" strokeWidth="2" strokeLinecap="round" strokeLinejoin="round" />
      <defs>
        <linearGradient id="dcompanion-gradient" x1="0" y1="0" x2="32" y2="32" gradientUnits="userSpaceOnUse">
          <stop stopColor="#F59E0B" />
          <stop offset="1" stopColor="#6366F1" />
        </linearGradient>
      </defs>
    </svg>
  );
}

export const MathoraMark = DCompanionMark;

// --- Bespoke Math SVG Motifs (Replaces generic rounded icon boxes) ---
export function MathMotif({ type, className = 'w-5 h-5' }: { type: 'function' | 'angle' | 'checkmark' | 'delta' | 'integral'; className?: string }) {
  switch (type) {
    case 'function':
      return (
        <svg viewBox="0 0 24 24" fill="none" className={className} stroke="currentColor" strokeWidth="2">
          <path d="M3 18C6 18 8 6 12 6C16 6 18 18 21 18" strokeLinecap="round" />
          <line x1="3" y1="12" x2="21" y2="12" strokeDasharray="2 2" strokeOpacity="0.4" />
        </svg>
      );
    case 'angle':
      return (
        <svg viewBox="0 0 24 24" fill="none" className={className} stroke="currentColor" strokeWidth="2">
          <path d="M4 20L20 20M4 20L16 4" strokeLinecap="round" strokeLinejoin="round" />
          <path d="M9 20C9 17.5 11 15.5 13.5 15.5" stroke="#F59E0B" strokeLinecap="round" />
        </svg>
      );
    case 'checkmark':
      return (
        <svg viewBox="0 0 24 24" fill="none" className={className}>
          <path d="M4 13L9 18L20 6" stroke="#10B981" strokeWidth="2.8" strokeLinecap="round" strokeLinejoin="round" />
          <circle cx="12" cy="12" r="10" stroke="#10B981" strokeWidth="1.5" strokeOpacity="0.3" />
        </svg>
      );
    case 'delta':
      return (
        <svg viewBox="0 0 24 24" fill="none" className={className} stroke="currentColor" strokeWidth="2">
          <path d="M12 4L4 20H20L12 4Z" strokeLinejoin="round" />
        </svg>
      );
    case 'integral':
      return (
        <svg viewBox="0 0 24 24" fill="none" className={className} stroke="currentColor" strokeWidth="2">
          <path d="M14 4C11 4 10 7 10 12C10 17 9 20 6 20" strokeLinecap="round" />
        </svg>
      );
    default:
      return null;
  }
}

// --- Card Primitive ---
interface CardProps extends React.HTMLAttributes<HTMLDivElement> {
  variant?: 'paper' | 'notebook' | 'ledger' | 'exam' | 'report';
  children: React.ReactNode;
}

export function Card({ variant = 'paper', className = '', children, ...props }: CardProps) {
  let baseStyle = 'rounded-2xl p-6 transition-all border';

  switch (variant) {
    case 'notebook':
      baseStyle += ' student-notebook-surface notebook-margin shadow-lg';
      break;
    case 'ledger':
      baseStyle += ' teacher-ledger-surface rounded-xl border-emerald-900/60 shadow-md';
      break;
    case 'report':
      baseStyle += ' parent-report-surface rounded-2xl border-amber-900/40 shadow-md';
      break;
    case 'exam':
      baseStyle += ' bg-slate-900/90 rounded-xl border-slate-700 exam-double-rule shadow-xl';
      break;
    default:
      baseStyle += ' paper-card rounded-2xl border-slate-800 shadow-lg';
      break;
  }

  return (
    <div className={`${baseStyle} ${className}`} {...props}>
      {children}
    </div>
  );
}

// --- Button Primitive ---
type HTMLButtonProps = Omit<React.ButtonHTMLAttributes<HTMLButtonElement>, 'onDrag' | 'onDragStart' | 'onDragEnd' | 'onAnimationStart'>;

interface ButtonProps extends HTMLButtonProps {
  variant?: 'primary' | 'secondary' | 'chalk' | 'outline' | 'danger';
  size?: 'sm' | 'md' | 'lg';
  children: React.ReactNode;
}

export function Button({ variant = 'primary', size = 'md', className = '', children, ...props }: ButtonProps) {
  let sizeStyle = 'px-4 py-2 text-xs font-bold';
  if (size === 'sm') sizeStyle = 'px-3 py-1.5 text-[11px] font-bold';
  if (size === 'lg') sizeStyle = 'px-7 py-3.5 text-sm font-extrabold';

  let variantStyle = 'bg-amber-500 text-slate-950 hover:bg-amber-400 shadow-md shadow-amber-500/20';

  switch (variant) {
    case 'secondary':
      variantStyle = 'bg-slate-800 text-slate-100 hover:bg-slate-700 border border-slate-700';
      break;
    case 'chalk':
      variantStyle = 'bg-indigo-600 text-white hover:bg-indigo-500 shadow-md shadow-indigo-500/20';
      break;
    case 'outline':
      variantStyle = 'bg-transparent text-slate-200 hover:bg-slate-800/80 border border-slate-700';
      break;
    case 'danger':
      variantStyle = 'bg-rose-600 text-white hover:bg-rose-500';
      break;
  }

  return (
    <motion.button
      whileHover={{ scale: 1.02 }}
      whileTap={{ scale: 0.98 }}
      className={`rounded-xl transition-all inline-flex items-center justify-center gap-2 ${sizeStyle} ${variantStyle} ${className}`}
      {...props}
    >
      {children}
    </motion.button>
  );
}

// --- Badge Primitive ---
export function Badge({
  variant = 'waec',
  children,
}: {
  variant?: 'waec' | 'bece' | 'mastered' | 'struggling' | 'verified' | 'rescue';
  children: React.ReactNode;
}) {
  let badgeStyle = 'px-2.5 py-0.5 rounded-md text-[10px] font-mono font-bold uppercase tracking-wider border';

  switch (variant) {
    case 'waec':
      badgeStyle += ' bg-amber-950/80 text-amber-300 border-amber-800/80';
      break;
    case 'bece':
      badgeStyle += ' bg-indigo-950/80 text-indigo-300 border-indigo-800/80';
      break;
    case 'mastered':
      badgeStyle += ' bg-emerald-950/80 text-emerald-300 border-emerald-800/80';
      break;
    case 'struggling':
      badgeStyle += ' bg-rose-950/80 text-rose-300 border-rose-800/80';
      break;
    case 'verified':
      badgeStyle += ' bg-cyan-950/80 text-cyan-300 border-cyan-800/80';
      break;
    case 'rescue':
      badgeStyle += ' bg-purple-950/80 text-purple-300 border-purple-800/80';
      break;
  }

  return <span className={badgeStyle}>{children}</span>;
}
