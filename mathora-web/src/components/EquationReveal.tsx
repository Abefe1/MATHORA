'use client';

import React, { useRef } from 'react';
import { motion, useInView } from 'framer-motion';
import MathRenderer from './MathRenderer';

interface EquationRevealProps {
  content: string;
  className?: string;
  delay?: number;
  duration?: number;
  once?: boolean;
  showCaret?: boolean;
}

/**
 * Wraps MathRenderer with a left-to-right "handwriting" reveal: the
 * equation is clipped away and unclips as it scrolls into view, with a
 * glowing caret sweeping across it like a pen tracing the formula.
 */
export default function EquationReveal({
  content,
  className = '',
  delay = 0,
  duration = 1.1,
  once = true,
  showCaret = true,
}: EquationRevealProps) {
  const ref = useRef<HTMLSpanElement>(null);
  const inView = useInView(ref, { once, amount: 0.5 });

  return (
    <span ref={ref} className="relative inline-block max-w-full">
      <motion.span
        initial={{ clipPath: 'inset(0 100% 0 0)' }}
        animate={inView ? { clipPath: 'inset(0 0% 0 0)' } : { clipPath: 'inset(0 100% 0 0)' }}
        transition={{ duration, delay, ease: [0.65, 0, 0.35, 1] }}
        className="inline-block"
      >
        <MathRenderer content={content} className={className} />
      </motion.span>

      {showCaret && (
        <motion.span
          aria-hidden
          initial={{ left: '0%', opacity: 0 }}
          animate={
            inView
              ? { left: ['0%', '100%'], opacity: [0, 1, 1, 0] }
              : { left: '0%', opacity: 0 }
          }
          transition={{ duration, delay, ease: [0.65, 0, 0.35, 1] }}
          className="absolute top-0 bottom-0 w-[2px] bg-amber-400 shadow-[0_0_8px_rgba(245,158,11,0.8)] pointer-events-none"
        />
      )}
    </span>
  );
}
