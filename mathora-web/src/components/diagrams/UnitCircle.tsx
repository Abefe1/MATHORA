'use client';

import React from 'react';
import { motion } from 'framer-motion';
import type { UnitCircleData } from '@/lib/diagramTypes';

export default function UnitCircle({ data }: { data: UnitCircleData }) {
  const { angleDegrees, showSine = true, showCosine = true, showTangent = false } = data;
  const size = 300;
  const cx = size / 2;
  const cy = size / 2;
  const r = 100;
  const rad = (angleDegrees * Math.PI) / 180;
  const px = cx + r * Math.cos(-rad);
  const py = cy + r * Math.sin(-rad);

  return (
    <svg viewBox={`0 0 ${size} ${size}`} className="w-full max-w-xs mx-auto" role="img" aria-label="Unit circle diagram">
      <line x1={0} y1={cy} x2={size} y2={cy} className="stroke-slate-300 dark:stroke-slate-700" strokeWidth={1} />
      <line x1={cx} y1={0} x2={cx} y2={size} className="stroke-slate-300 dark:stroke-slate-700" strokeWidth={1} />

      <motion.circle
        cx={cx} cy={cy} r={r}
        className="fill-none stroke-slate-400 dark:stroke-slate-600" strokeWidth={2}
        initial={{ pathLength: 0 }} animate={{ pathLength: 1 }} transition={{ duration: 0.8 }}
      />

      {showCosine && (
        <motion.line
          x1={cx} y1={cy} x2={px} y2={cy}
          className="stroke-cyan-600 dark:stroke-cyan-400" strokeWidth={3}
          initial={{ pathLength: 0 }} animate={{ pathLength: 1 }} transition={{ delay: 0.6, duration: 0.5 }}
        />
      )}
      {showSine && (
        <motion.line
          x1={px} y1={cy} x2={px} y2={py}
          className="stroke-amber-600 dark:stroke-amber-400" strokeWidth={3}
          initial={{ pathLength: 0 }} animate={{ pathLength: 1 }} transition={{ delay: 0.9, duration: 0.5 }}
        />
      )}
      {showTangent && angleDegrees % 180 !== 90 && (
        <motion.line
          x1={cx + r} y1={cy} x2={cx + r} y2={cy - r * Math.tan(rad)}
          className="stroke-emerald-600 dark:stroke-emerald-400" strokeWidth={2.5} strokeDasharray="4 3"
          initial={{ pathLength: 0 }} animate={{ pathLength: 1 }} transition={{ delay: 1.2, duration: 0.5 }}
        />
      )}

      <motion.line
        x1={cx} y1={cy} x2={px} y2={py}
        className="stroke-indigo-600 dark:stroke-indigo-400" strokeWidth={3}
        initial={{ pathLength: 0 }} animate={{ pathLength: 1 }} transition={{ duration: 0.6 }}
      />
      <motion.circle cx={px} cy={py} r={5} className="fill-indigo-600 dark:fill-indigo-400 stroke-white dark:stroke-slate-900" strokeWidth={2} initial={{ scale: 0 }} animate={{ scale: 1 }} transition={{ delay: 0.5 }} />

      <motion.text x={cx + 10} y={cy - 10} className="fill-indigo-700 dark:fill-indigo-300 text-xs font-bold" initial={{ opacity: 0 }} animate={{ opacity: 1 }} transition={{ delay: 1.4 }}>
        θ = {angleDegrees}°
      </motion.text>
    </svg>
  );
}
