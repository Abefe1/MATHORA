'use client';

import React from 'react';
import { motion } from 'framer-motion';
import type { CoordinatePlaneData } from '@/lib/diagramTypes';

export default function CoordinatePlane({ data }: { data: CoordinatePlaneData }) {
  const { xRange, yRange, points = [], lines = [] } = data;
  const width = 420;
  const height = 380;
  const pad = 32;

  const toPx = (x: number) => pad + ((x - xRange[0]) / (xRange[1] - xRange[0])) * (width - pad * 2);
  const toPy = (y: number) => height - pad - ((y - yRange[0]) / (yRange[1] - yRange[0])) * (height - pad * 2);

  const xTicks: number[] = [];
  for (let x = Math.ceil(xRange[0]); x <= xRange[1]; x++) xTicks.push(x);
  const yTicks: number[] = [];
  for (let y = Math.ceil(yRange[0]); y <= yRange[1]; y++) yTicks.push(y);

  return (
    <svg viewBox={`0 0 ${width} ${height}`} className="w-full max-w-sm mx-auto" role="img" aria-label="Coordinate plane diagram">
      {xTicks.map((x) => (
        <line key={`gx${x}`} x1={toPx(x)} y1={pad} x2={toPx(x)} y2={height - pad} className="stroke-slate-100 dark:stroke-slate-800" strokeWidth={1} />
      ))}
      {yTicks.map((y) => (
        <line key={`gy${y}`} x1={pad} y1={toPy(y)} x2={width - pad} y2={toPy(y)} className="stroke-slate-100 dark:stroke-slate-800" strokeWidth={1} />
      ))}

      <line x1={pad} y1={toPy(0)} x2={width - pad} y2={toPy(0)} className="stroke-slate-400 dark:stroke-slate-600" strokeWidth={1.5} />
      <line x1={toPx(0)} y1={pad} x2={toPx(0)} y2={height - pad} className="stroke-slate-400 dark:stroke-slate-600" strokeWidth={1.5} />
      <text x={width - pad + 4} y={toPy(0) + 4} className="fill-slate-400 text-[10px]">x</text>
      <text x={toPx(0) - 12} y={pad - 4} className="fill-slate-400 text-[10px]">y</text>

      {lines.map((l, i) => (
        <motion.line
          key={i}
          x1={toPx(l.from.x)} y1={toPy(l.from.y)} x2={toPx(l.to.x)} y2={toPy(l.to.y)}
          className={l.color ?? 'stroke-indigo-600 dark:stroke-indigo-400'}
          strokeWidth={2.5}
          initial={{ pathLength: 0 }}
          animate={{ pathLength: 1 }}
          transition={{ duration: 0.7, delay: i * 0.2 }}
        />
      ))}

      {points.map((p, i) => (
        <motion.g
          key={i}
          initial={{ opacity: 0, scale: 0 }}
          animate={{ opacity: 1, scale: 1 }}
          transition={{ delay: 0.5 + i * 0.2, type: 'spring', stiffness: 300, damping: 20 }}
          style={{ transformOrigin: `${toPx(p.x)}px ${toPy(p.y)}px` }}
        >
          <circle cx={toPx(p.x)} cy={toPy(p.y)} r={5} className="fill-cyan-500 stroke-white dark:stroke-slate-900" strokeWidth={2} />
          {p.label && (
            <text x={toPx(p.x) + 8} y={toPy(p.y) - 8} className="fill-cyan-700 dark:fill-cyan-300 text-xs font-bold">
              {p.label} ({p.x}, {p.y})
            </text>
          )}
        </motion.g>
      ))}
    </svg>
  );
}
