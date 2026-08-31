'use client';

import React from 'react';
import { motion } from 'framer-motion';

// Fixed, deliberately small palette — every ring in the app draws from
// this set only. Matches diagrams/PieChart.tsx's convention of leaving
// mid-saturation segment colors unpaired between light/dark (they read
// fine on both); only the track (unfilled portion) needs a dark: pair.
export const RING_COLORS = {
  correct: 'stroke-emerald-500',
  incorrect: 'stroke-rose-500',
  accent: 'stroke-amber-500',
  neutral: 'stroke-indigo-500',
} as const;

export type RingColor = keyof typeof RING_COLORS;

export interface RingSegment {
  value: number;
  color: RingColor;
}

interface ProgressRingProps {
  segments: RingSegment[];
  /** Denominator segments are measured against — defaults to the sum of
   * segment values, but pass this explicitly when the ring should show
   * "3 of 7 days" rather than "3 of 3 (100%) with the other 4 implicit". */
  total?: number;
  size?: number;
  strokeWidth?: number;
  centerLabel: string;
  centerSubLabel?: string;
  className?: string;
}

export default function ProgressRing({
  segments,
  total,
  size = 160,
  strokeWidth = 14,
  centerLabel,
  centerSubLabel,
  className = '',
}: ProgressRingProps) {
  const r = (size - strokeWidth) / 2;
  const cx = size / 2;
  const cy = size / 2;
  const circumference = 2 * Math.PI * r;
  const denominator = total ?? (segments.reduce((sum, s) => sum + s.value, 0) || 1);

  // Running start offset per segment, same "reduce over the array
  // before mapping" approach as PieChart.tsx's startAngles.
  const offsets = segments.reduce<number[]>((acc, seg, i) => {
    const prevEnd = i === 0 ? 0 : acc[i - 1] + (segments[i - 1].value / denominator) * circumference;
    acc.push(prevEnd);
    return acc;
  }, []);

  return (
    <div className={`relative inline-flex items-center justify-center ${className}`} style={{ width: size, height: size }}>
      <svg width={size} height={size} viewBox={`0 0 ${size} ${size}`} role="img" aria-label={centerLabel}>
        <g transform={`rotate(-90 ${cx} ${cy})`}>
          {/* Track — the unfilled remainder, drawn first so segments sit on top */}
          <circle
            cx={cx}
            cy={cy}
            r={r}
            fill="none"
            strokeWidth={strokeWidth}
            className="stroke-slate-200 dark:stroke-slate-800"
          />
          {segments.map((seg, i) => {
            const length = (seg.value / denominator) * circumference;
            return (
              <motion.circle
                key={i}
                cx={cx}
                cy={cy}
                r={r}
                fill="none"
                strokeWidth={strokeWidth}
                strokeLinecap="round"
                className={RING_COLORS[seg.color]}
                strokeDasharray={circumference}
                initial={{ strokeDashoffset: circumference - 0 }}
                animate={{ strokeDashoffset: circumference - length }}
                transition={{ delay: i * 0.15, duration: 0.6, ease: 'easeOut' }}
                style={{ transform: `rotate(${(offsets[i] / circumference) * 360}deg)`, transformOrigin: `${cx}px ${cy}px` }}
              />
            );
          })}
        </g>
      </svg>
      <div className="absolute inset-0 flex flex-col items-center justify-center">
        <span className="text-xl font-display font-extrabold text-slate-900 dark:text-white">{centerLabel}</span>
        {centerSubLabel && (
          <span className="text-[10px] font-mono text-slate-500 dark:text-slate-400 mt-0.5">{centerSubLabel}</span>
        )}
      </div>
    </div>
  );
}
