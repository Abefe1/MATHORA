'use client';

import React from 'react';
import { motion } from 'framer-motion';
import type { VennDiagramData } from '@/lib/diagramTypes';

export default function VennDiagram({ data }: { data: VennDiagramData }) {
  const { setA, setB, setC, universalLabel } = data;
  const width = 420;
  const height = 300;
  const r = 90;

  const circles = setC
    ? [
        { cx: 180, cy: 130, set: setA, color: 'fill-indigo-400/40 dark:fill-indigo-500/30 stroke-indigo-500' },
        { cx: 240, cy: 130, set: setB, color: 'fill-cyan-400/40 dark:fill-cyan-500/30 stroke-cyan-500' },
        { cx: 210, cy: 190, set: setC, color: 'fill-amber-400/40 dark:fill-amber-500/30 stroke-amber-500' },
      ]
    : [
        { cx: 165, cy: 150, set: setA, color: 'fill-indigo-400/40 dark:fill-indigo-500/30 stroke-indigo-500' },
        { cx: 255, cy: 150, set: setB, color: 'fill-cyan-400/40 dark:fill-cyan-500/30 stroke-cyan-500' },
      ];

  return (
    <svg viewBox={`0 0 ${width} ${height}`} className="w-full max-w-md mx-auto" role="img" aria-label="Venn diagram">
      <motion.rect
        x={10} y={10} width={width - 20} height={height - 20} rx={12}
        className="fill-none stroke-slate-300 dark:stroke-slate-700" strokeWidth={1.5} strokeDasharray="4 4"
        initial={{ opacity: 0 }} animate={{ opacity: 1 }} transition={{ duration: 0.4 }}
      />
      {universalLabel && (
        <text x={22} y={30} className="fill-slate-400 dark:fill-slate-500 text-[11px] font-mono italic">{universalLabel}</text>
      )}

      {circles.map((c, i) => (
        <motion.circle
          key={i}
          cx={c.cx} cy={c.cy} r={r}
          className={c.color}
          strokeWidth={2}
          initial={{ opacity: 0, scale: 0.7 }}
          animate={{ opacity: 1, scale: 1 }}
          transition={{ delay: i * 0.25, duration: 0.5, ease: 'easeOut' }}
          style={{ transformOrigin: `${c.cx}px ${c.cy}px` }}
        />
      ))}

      {circles.map((c, i) => (
        <motion.text
          key={`label-${i}`}
          x={c.cx}
          y={circles.length === 3 ? (i === 2 ? c.cy + r + 16 : c.cy - r - 10) : c.cy - r - 10}
          textAnchor="middle"
          className="fill-slate-700 dark:fill-slate-200 text-xs font-bold"
          initial={{ opacity: 0 }}
          animate={{ opacity: 1 }}
          transition={{ delay: 0.6 + i * 0.15 }}
        >
          {c.set.label}
        </motion.text>
      ))}
    </svg>
  );
}
