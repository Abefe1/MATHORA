'use client';

import React from 'react';
import { motion } from 'framer-motion';
import type { NumberLineData } from '@/lib/diagramTypes';

export default function NumberLine({ data }: { data: NumberLineData }) {
  const { min, max, step = 1, points = [], highlightRange } = data;
  const width = 480;
  const height = 120;
  const pad = 40;
  const scale = (width - pad * 2) / (max - min);
  const toX = (v: number) => pad + (v - min) * scale;
  const ticks: number[] = [];
  for (let v = min; v <= max; v += step) ticks.push(Math.round(v * 1000) / 1000);

  return (
    <svg viewBox={`0 0 ${width} ${height}`} className="w-full max-w-lg mx-auto" role="img" aria-label="Number line diagram">
      {highlightRange && (
        <motion.rect
          x={toX(highlightRange[0])}
          y={height / 2 - 6}
          width={toX(highlightRange[1]) - toX(highlightRange[0])}
          height={12}
          className="fill-indigo-200 dark:fill-indigo-900/60"
          initial={{ opacity: 0, scaleX: 0 }}
          animate={{ opacity: 1, scaleX: 1 }}
          transition={{ duration: 0.6 }}
          style={{ transformOrigin: `${toX(highlightRange[0])}px center` }}
        />
      )}

      <motion.line
        x1={pad} y1={height / 2} x2={width - pad} y2={height / 2}
        className="stroke-slate-400 dark:stroke-slate-600" strokeWidth={2}
        initial={{ pathLength: 0 }} animate={{ pathLength: 1 }} transition={{ duration: 0.5 }}
      />

      {ticks.map((t) => (
        <g key={t}>
          <line x1={toX(t)} y1={height / 2 - 6} x2={toX(t)} y2={height / 2 + 6} className="stroke-slate-400 dark:stroke-slate-600" strokeWidth={2} />
          <text x={toX(t)} y={height / 2 + 24} textAnchor="middle" className="fill-slate-500 dark:fill-slate-400 text-[11px] font-mono">{t}</text>
        </g>
      ))}

      {points.map((p, i) => (
        <motion.g
          key={i}
          initial={{ opacity: 0, y: -8 }}
          animate={{ opacity: 1, y: 0 }}
          transition={{ delay: 0.5 + i * 0.25, duration: 0.4 }}
        >
          <circle cx={toX(p.value)} cy={height / 2} r={6} className="fill-indigo-600 dark:fill-indigo-400 stroke-white dark:stroke-slate-900" strokeWidth={2} />
          <text x={toX(p.value)} y={height / 2 - 16} textAnchor="middle" className="fill-indigo-700 dark:fill-indigo-300 text-xs font-bold">{p.label}</text>
        </motion.g>
      ))}
    </svg>
  );
}
