'use client';

import React from 'react';
import { motion } from 'framer-motion';
import type { CircleData } from '@/lib/diagramTypes';

const toRad = (deg: number) => (deg * Math.PI) / 180;

export default function CircleDiagram({ data }: { data: CircleData }) {
  const { radiusLabel, centerLabel, points = [], highlightSector, chord } = data;
  const size = 300;
  const cx = size / 2;
  const cy = size / 2;
  const r = 100;

  const onCircle = (angleDeg: number) => ({
    x: cx + r * Math.cos(toRad(angleDeg - 90)),
    y: cy + r * Math.sin(toRad(angleDeg - 90)),
  });

  const sectorPath = (start: number, end: number) => {
    const p1 = onCircle(start);
    const p2 = onCircle(end);
    const largeArc = end - start > 180 ? 1 : 0;
    return `M ${cx} ${cy} L ${p1.x} ${p1.y} A ${r} ${r} 0 ${largeArc} 1 ${p2.x} ${p2.y} Z`;
  };

  return (
    <svg viewBox={`0 0 ${size} ${size}`} className="w-full max-w-xs mx-auto" role="img" aria-label="Circle diagram">
      {highlightSector && (
        <motion.path
          d={sectorPath(highlightSector.startAngle, highlightSector.endAngle)}
          className="fill-amber-300/50 dark:fill-amber-500/30"
          initial={{ opacity: 0 }} animate={{ opacity: 1 }} transition={{ delay: 0.6, duration: 0.5 }}
        />
      )}

      <motion.circle
        cx={cx} cy={cy} r={r}
        className="fill-none stroke-indigo-600 dark:stroke-indigo-400" strokeWidth={2.5}
        initial={{ pathLength: 0 }} animate={{ pathLength: 1 }} transition={{ duration: 0.8, ease: 'easeInOut' }}
      />

      <motion.circle cx={cx} cy={cy} r={2.5} className="fill-slate-600 dark:fill-slate-300" initial={{ opacity: 0 }} animate={{ opacity: 1 }} transition={{ delay: 0.5 }} />
      {centerLabel && (
        <motion.text x={cx + 8} y={cy - 6} className="fill-slate-600 dark:fill-slate-300 text-[11px] font-bold" initial={{ opacity: 0 }} animate={{ opacity: 1 }} transition={{ delay: 0.6 }}>{centerLabel}</motion.text>
      )}
      {radiusLabel && (
        <motion.g initial={{ opacity: 0 }} animate={{ opacity: 1 }} transition={{ delay: 0.9 }}>
          <line x1={cx} y1={cy} x2={onCircle(0).x} y2={onCircle(0).y} className="stroke-slate-400 dark:stroke-slate-500" strokeWidth={1.5} strokeDasharray="3 3" />
          <text x={cx + 6} y={cy - r / 2} className="fill-slate-500 dark:fill-slate-400 text-[11px] font-mono">{radiusLabel}</text>
        </motion.g>
      )}

      {chord && (
        <motion.line
          x1={onCircle(chord.fromAngle).x} y1={onCircle(chord.fromAngle).y}
          x2={onCircle(chord.toAngle).x} y2={onCircle(chord.toAngle).y}
          className="stroke-cyan-600 dark:stroke-cyan-400" strokeWidth={2.5}
          initial={{ pathLength: 0 }} animate={{ pathLength: 1 }} transition={{ delay: 1, duration: 0.5 }}
        />
      )}

      {points.map((p, i) => {
        const pos = onCircle(p.angleDegrees);
        return (
          <motion.g key={i} initial={{ opacity: 0, scale: 0 }} animate={{ opacity: 1, scale: 1 }} transition={{ delay: 1.1 + i * 0.15 }} style={{ transformOrigin: `${pos.x}px ${pos.y}px` }}>
            <circle cx={pos.x} cy={pos.y} r={4} className="fill-emerald-500 stroke-white dark:stroke-slate-900" strokeWidth={1.5} />
            <text x={pos.x + (pos.x > cx ? 10 : -10)} y={pos.y} textAnchor={pos.x > cx ? 'start' : 'end'} className="fill-emerald-700 dark:fill-emerald-300 text-xs font-bold">{p.label}</text>
          </motion.g>
        );
      })}
    </svg>
  );
}
