'use client';

import { useEffect, useRef, useState } from 'react';

/**
 * A single countdown timer, extracted from student/mock-exam/page.tsx's
 * inline `useState(600)` + `setInterval` (which mathora-mobile's
 * mock-exam screen also duplicates independently) so the timed
 * assignment take-flow doesn't need a third copy of the same ticking
 * logic.
 *
 * `totalSeconds: null` makes the hook a no-op (untimed assignment) —
 * `secondsLeft` stays null and `onExpire` never fires. `active` pauses
 * the ticking without resetting it (e.g. while a submit request is in
 * flight); it does not itself represent "has the countdown started",
 * that's implied by totalSeconds being non-null.
 */
export function useCountdown(options: {
  totalSeconds: number | null;
  onExpire: () => void;
  active: boolean;
}): { secondsLeft: number | null; formatted: string } {
  const { totalSeconds, onExpire, active } = options;
  const [secondsLeft, setSecondsLeft] = useState<number | null>(
    totalSeconds != null ? Math.max(0, Math.round(totalSeconds)) : null
  );
  const expiredRef = useRef(false);
  const onExpireRef = useRef(onExpire);
  useEffect(() => {
    onExpireRef.current = onExpire;
  }, [onExpire]);

  // Reset when the seed value itself changes (e.g. the take-flow
  // recomputes totalSeconds once after resolving started_at) — not on
  // every render, since active/onExpire changing shouldn't restart the
  // clock.
  useEffect(() => {
    expiredRef.current = false;
    // eslint-disable-next-line react-hooks/set-state-in-effect -- seeding the timer from a prop change is the point of this effect, not an avoidable side effect.
    setSecondsLeft(totalSeconds != null ? Math.max(0, Math.round(totalSeconds)) : null);
  }, [totalSeconds]);

  useEffect(() => {
    if (totalSeconds == null || !active) return;
    const timer = setInterval(() => {
      setSecondsLeft((prev) => {
        if (prev === null) return prev;
        if (prev <= 1) {
          clearInterval(timer);
          if (!expiredRef.current) {
            expiredRef.current = true;
            onExpireRef.current();
          }
          return 0;
        }
        return prev - 1;
      });
    }, 1000);
    return () => clearInterval(timer);
  }, [totalSeconds, active]);

  const formatted =
    secondsLeft == null
      ? '--:--'
      : `${Math.floor(secondsLeft / 60)
          .toString()
          .padStart(2, '0')}:${(secondsLeft % 60).toString().padStart(2, '0')}`;

  return { secondsLeft, formatted };
}
