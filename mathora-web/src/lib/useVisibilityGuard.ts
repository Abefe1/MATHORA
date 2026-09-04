'use client';

import { useEffect, useRef } from 'react';

/**
 * Detects when the browser tab showing a timed assignment loses focus
 * (switched away, minimized, or backgrounded) and reports it — this is
 * a deterrent and visibility tool for the teacher, same spirit as
 * mobile's useBlockScreenCapture.ts (mathora-mobile/src/hooks), NOT a
 * technical block. There is no web API that can prevent a tab switch or
 * window minimize; `document.visibilitychange` and `window.blur` can
 * only ever detect it after the fact. This hook does not pause any
 * timer and does not block continued work — see the assignment
 * take-flow's onFocusLoss handler, which only logs + notifies the
 * teacher (scope decision: never interrupt the student).
 */
export function useVisibilityGuard(options: { enabled: boolean; onFocusLoss?: () => void }) {
  const onFocusLossRef = useRef(options.onFocusLoss);
  useEffect(() => {
    onFocusLossRef.current = options.onFocusLoss;
  }, [options.onFocusLoss]);

  useEffect(() => {
    if (!options.enabled) return;
    const handler = () => {
      if (document.hidden) onFocusLossRef.current?.();
    };
    document.addEventListener('visibilitychange', handler);
    window.addEventListener('blur', handler);
    return () => {
      document.removeEventListener('visibilitychange', handler);
      window.removeEventListener('blur', handler);
    };
  }, [options.enabled]);
}
