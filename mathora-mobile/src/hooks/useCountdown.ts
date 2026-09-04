import { useEffect, useRef, useState } from 'react';

/**
 * Direct port of mathora-web/src/lib/useCountdown.ts — plain
 * setInterval-based countdown, no DOM dependency on either side so this
 * ports as-is. `totalSeconds: null` makes the hook a no-op (untimed
 * assignment). `active` pauses ticking without resetting it.
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

  useEffect(() => {
    expiredRef.current = false;
    // Seeding the timer from a prop change is the point of this effect,
    // not an avoidable side effect.
    // eslint-disable-next-line react-hooks/set-state-in-effect
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
