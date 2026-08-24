'use client';

import React from 'react';
import { motion } from 'framer-motion';
import type { BarChartData } from '@/lib/diagramTypes';

export default function BarChart({ data }: { data: BarChartData }) {
  const { categories, values, yLabel } = data;
  const width = 420;
  const height = 280;
  const pad = 40;
  const max = Math.max(...values, 1);
  const barWidth = (width - pad * 2) / values.length / 1.6;
  const gap = (width - pad * 2) / values.length;

  return (
    <svg viewBox={`0 0 ${width} ${height}`} className="w-full max-w-md mx-auto" role="img" aria-label="Bar chart diagram">
      <line x1={pad} y1={height - pad} x2={width - pad} y2={height - pad} className="stroke-slate-400 dark:stroke-slate-600" strokeWidth={1.5} />
      {yLabel && (
        <text x={pad - 8} y={pad - 12} className="fill-slate-400 dark:fill-slate-500 text-[10px]">{yLabel}</text>
      )}

      {values.map((v, i) => {
        const barHeight = ((height - pad * 2) * v) / max;
        const x = pad + i * gap + (gap - barWidth) / 2;
        return (
          <g key={i}>
            <motion.rect
              x={x}
              width={barWidth}
              className="fill-indigo-500 dark:fill-indigo-400"
              rx={3}
              initial={{ y: height - pad, height: 0 }}
              animate={{ y: height - pad - barHeight, height: barHeight }}
              transition={{ delay: i * 0.15, duration: 0.6, ease: 'easeOut' }}
            />
            <motion.text
              x={x + barWidth / 2}
              y={height - pad - barHeight - 6}
              textAnchor="middle"
              className="fill-slate-700 dark:fill-slate-200 text-[11px] font-bold"
              initial={{ opacity: 0 }} animate={{ opacity: 1 }} transition={{ delay: i * 0.15 + 0.5 }}
            >
              {v}
            </motion.text>
            <text x={x + barWidth / 2} y={height - pad + 16} textAnchor="middle" className="fill-slate-500 dark:fill-slate-400 text-[10px]">
              {categories[i]}
            </text>
          </g>
        );
      })}
    </svg>
  );
}
