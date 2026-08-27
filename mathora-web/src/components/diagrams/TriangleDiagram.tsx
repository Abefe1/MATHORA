'use client';

import React from 'react';
import { motion } from 'framer-motion';
import type { TriangleData } from '@/lib/diagramTypes';

export default function TriangleDiagram({ data }: { data: TriangleData }) {
  const { vertices, sideLabels = [], angleLabels = [], rightAngleAt } = data;
  const width = 360;
  const height = 300;

  // vertices come in an abstract coordinate space; normalize+flip Y to SVG space with padding.
  const xs = vertices.map((v) => v.x);
  const ys = vertices.map((v) => v.y);
  const minX = Math.min(...xs), maxX = Math.max(...xs);
  const minY = Math.min(...ys), maxY = Math.max(...ys);
  const pad = 40;
  const sx = (maxX - minX) || 1;
  const sy = (maxY - minY) || 1;
  const scale = Math.min((width - pad * 2) / sx, (height - pad * 2) / sy);
  const toX = (x: number) => pad + (x - minX) * scale;
  const toY = (y: number) => height - pad - (y - minY) * scale; // flip so +y is up

  const pts = vertices.map((v) => ({ ...v, px: toX(v.x), py: toY(v.y) }));
  const pathD = `M ${pts[0].px} ${pts[0].py} L ${pts[1].px} ${pts[1].py} L ${pts[2].px} ${pts[2].py} Z`;

  const findVertex = (label: string) => pts.find((p) => p.label === label);
  const midpoint = (aLabel: string, bLabel: string) => {
    const a = findVertex(aLabel), b = findVertex(bLabel);
    if (!a || !b) return null;
    return { x: (a.px + b.px) / 2, y: (a.py + b.py) / 2 };
  };

  return (
    <svg viewBox={`0 0 ${width} ${height}`} className="w-full max-w-sm mx-auto" role="img" aria-label="Triangle diagram">
      <motion.path
        d={pathD}
        className="fill-indigo-50 dark:fill-indigo-950/40 stroke-indigo-600 dark:stroke-indigo-400"
        strokeWidth={2.5}
        strokeLinejoin="round"
        initial={{ pathLength: 0, opacity: 0 }}
        animate={{ pathLength: 1, opacity: 1 }}
        transition={{ duration: 0.9, ease: 'easeInOut' }}
      />

      {pts.map((p, i) => (
        <motion.g key={i} initial={{ opacity: 0 }} animate={{ opacity: 1 }} transition={{ delay: 0.6 + i * 0.15 }}>
          <circle cx={p.px} cy={p.py} r={3.5} className="fill-indigo-600 dark:fill-indigo-400" />
          <text
            x={p.px}
            y={p.py + (p.py > height / 2 ? 18 : -10)}
            textAnchor="middle"
            className="fill-slate-700 dark:fill-slate-200 text-sm font-bold"
          >
            {p.label}
          </text>
        </motion.g>
      ))}

      {sideLabels.map((s, i) => {
        const m = midpoint(s.from, s.to);
        if (!m) return null;
        return (
          <motion.text
            key={i}
            x={m.x} y={m.y}
            textAnchor="middle"
            className="fill-cyan-700 dark:fill-cyan-300 text-xs font-bold"
            initial={{ opacity: 0 }}
            animate={{ opacity: 1 }}
            transition={{ delay: 1 + i * 0.15 }}
          >
            {s.label}
          </motion.text>
        );
      })}

      {angleLabels.map((a, i) => {
        const v = findVertex(a.vertex);
        if (!v) return null;
        return (
          <motion.text
            key={i}
            x={v.px + (v.px < width / 2 ? 14 : -14)}
            y={v.py + (v.py > height / 2 ? -8 : 14)}
            textAnchor="middle"
            className="fill-amber-600 dark:fill-amber-400 text-xs font-bold"
            initial={{ opacity: 0 }}
            animate={{ opacity: 1 }}
            transition={{ delay: 1.2 + i * 0.15 }}
          >
            {a.label}
          </motion.text>
        );
      })}

      {rightAngleAt && (() => {
        const v = findVertex(rightAngleAt);
        if (!v) return null;
        return (
          <motion.rect
            x={v.px - (v.px < width / 2 ? -6 : 14)}
            y={v.py - (v.py > height / 2 ? 14 : -6)}
            width={8} height={8}
            className="fill-none stroke-slate-500 dark:stroke-slate-400"
            strokeWidth={1.5}
            initial={{ opacity: 0 }} animate={{ opacity: 1 }} transition={{ delay: 1.4 }}
          />
        );
      })()}
    </svg>
  );
}
