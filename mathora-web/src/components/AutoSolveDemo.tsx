'use client';

import React, { useEffect, useRef, useState } from 'react';
import { useInView } from 'framer-motion';
import EquationReveal from './EquationReveal';

const STEPS = [
  { label: 'Original Equation', latex: '$$3x^2 - 7x + 2 = 0$$' },
  { label: 'Split the Middle Term', latex: '$$3x^2 - 6x - x + 2 = 0$$' },
  { label: 'Factor by Grouping', latex: '$$3x(x - 2) - 1(x - 2) = 0$$' },
  { label: 'Common Factor', latex: '$$(3x - 1)(x - 2) = 0$$' },
  { label: 'Solve Each Factor', latex: '$$x = \\tfrac{1}{3} \\ \\text{or} \\ x = 2$$' },
];

const STEP_DELAY_MS = 1900;
const HOLD_DELAY_MS = 3200;
const RESET_DELAY_MS = 700;

/**
 * A self-playing "watch Mathora solve" demo: builds up a full worked
 * solution line by line, each line writing itself in via EquationReveal,
 * then clears and loops. Starts/pauses based on scroll visibility.
 */
export default function AutoSolveDemo() {
  const containerRef = useRef<HTMLDivElement>(null);
  const inView = useInView(containerRef, { once: false, amount: 0.4 });
  const [step, setStep] = useState(-1);

  useEffect(() => {
    if (!inView) return;

    const prefersReducedMotion = window.matchMedia('(prefers-reduced-motion: reduce)').matches;

    let cancelled = false;
    let timer: ReturnType<typeof setTimeout>;

    if (prefersReducedMotion) {
      timer = setTimeout(() => {
        if (!cancelled) setStep(STEPS.length - 1);
      }, 0);
      return () => {
        cancelled = true;
        clearTimeout(timer);
      };
    }

    const run = (i: number) => {
      if (cancelled) return;
      setStep(i);
      const isLast = i >= STEPS.length - 1;
      timer = setTimeout(() => {
        if (cancelled) return;
        if (isLast) {
          setStep(-1);
          timer = setTimeout(() => run(0), RESET_DELAY_MS);
        } else {
          run(i + 1);
        }
      }, isLast ? HOLD_DELAY_MS : STEP_DELAY_MS);
    };

    run(0);
    return () => {
      cancelled = true;
      clearTimeout(timer);
    };
  }, [inView]);

  return (
    <div ref={containerRef} className="paper-card rounded-2xl p-6 border border-slate-800 shadow-xl text-left">
      <div className="flex items-center gap-2 mb-5">
        <span className="relative flex h-2 w-2">
          <span className="animate-ping absolute inline-flex h-full w-full rounded-full bg-emerald-400 opacity-75" />
          <span className="relative inline-flex rounded-full h-2 w-2 bg-emerald-400" />
        </span>
        <span className="text-xs font-mono font-bold text-emerald-300 uppercase tracking-wider">
          Watch Mathora Solve — Live
        </span>
      </div>

      <div className="space-y-3 min-h-[9rem]">
        {STEPS.slice(0, step + 1).map((s, idx) => (
          <div key={idx} className="flex items-baseline gap-3">
            <span className="text-[10px] font-mono text-slate-500 w-5 flex-shrink-0">{idx + 1}.</span>
            <div>
              <EquationReveal
                content={s.latex}
                className="text-base sm:text-lg font-bold text-white font-mono"
                duration={0.85}
              />
              <p className="text-[10px] font-mono text-slate-500 mt-0.5">{s.label}</p>
            </div>
          </div>
        ))}
      </div>
    </div>
  );
}
