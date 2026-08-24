'use client';

import React from 'react';
import { motion } from 'framer-motion';
import type { PieChartData } from '@/lib/diagramTypes';

const COLORS = ['fill-indigo-500', 'fill-cyan-500', 'fill-amber-500', 'fill-emerald-500', 'fill-rose-500', 'fill-purple-500'];

export default function PieChart({ data }: { data: PieChartData }) {
  const { slices } = data;
  const size = 260;
  const cx = size / 2;
  const cy = size / 2;
  const r = 100;
  const total = slices.reduce((s, x) => s + x.value, 0) || 1;

  // Precompute each slice's start angle from the running total of the
  // slices before it, rather than mutating a shared variable while
  // mapping (React's stricter immutability-during-render rule flags
  // that even though it's harmless here — this reads the same either way).
  const startAngles = slices.reduce<number[]>((acc, slice, i) => {
    const prevEnd = i === 0 ? -90 : acc[i - 1] + (slices[i - 1].value / total) * 360;
    acc.push(prevEnd);
    return acc;
  }, []);

  const arcs = slices.map((slice, i) => {
    const angle = (slice.value / total) * 360;
    const startAngle = startAngles[i];
    const endAngle = startAngle + angle;

    const toRad = (deg: number) => (deg * Math.PI) / 180;
    const start = { x: cx + r * Math.cos(toRad(startAngle)), y: cy + r * Math.sin(toRad(startAngle)) };
    const end = { x: cx + r * Math.cos(toRad(endAngle)), y: cy + r * Math.sin(toRad(endAngle)) };
    const largeArc = angle > 180 ? 1 : 0;
    const path = `M ${cx} ${cy} L ${start.x} ${start.y} A ${r} ${r} 0 ${largeArc} 1 ${end.x} ${end.y} Z`;

    const midAngle = toRad((startAngle + endAngle) / 2);
    const labelX = cx + (r + 20) * Math.cos(midAngle);
    const labelY = cy + (r + 20) * Math.sin(midAngle);

    return { path, color: COLORS[i % COLORS.length], label: slice.label, value: slice.value, labelX, labelY, i };
  });

  return (
    <svg viewBox={`0 0 ${size + 40} ${size}`} className="w-full max-w-xs mx-auto" role="img" aria-label="Pie chart diagram">
      {arcs.map((a) => (
        <motion.path
          key={a.i}
          d={a.path}
          className={`${a.color} stroke-white dark:stroke-slate-900`}
          strokeWidth={2}
          initial={{ opacity: 0, scale: 0.7 }}
          animate={{ opacity: 1, scale: 1 }}
          transition={{ delay: a.i * 0.15, duration: 0.4, ease: 'easeOut' }}
          style={{ transformOrigin: `${cx}px ${cy}px` }}
        />
      ))}
      {arcs.map((a) => (
        <motion.text
          key={`label-${a.i}`}
          x={a.labelX} y={a.labelY}
          textAnchor="middle"
          className="fill-slate-600 dark:fill-slate-300 text-[10px] font-bold"
          initial={{ opacity: 0 }} animate={{ opacity: 1 }} transition={{ delay: 0.6 + a.i * 0.15 }}
        >
          {a.label} ({a.value})
        </motion.text>
      ))}
    </svg>
  );
}
