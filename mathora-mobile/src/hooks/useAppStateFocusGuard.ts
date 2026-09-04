import { useEffect, useRef } from 'react';
import { AppState, AppStateStatus } from 'react-native';

/**
 * Mobile's counterpart of web's useVisibilityGuard.ts — detects when the
 * app is backgrounded (home button, app switcher, notification shade,
 * an incoming call) while a timed assignment is in progress, and reports
 * it. Same honesty framing as useBlockScreenCapture.ts's doc comment:
 * this is a deterrent and teacher-visibility tool, NOT a technical
 * block. There is no API on either platform that can prevent the user
 * from leaving the app — AppState can only ever tell you it happened,
 * after the fact. Does not pause any timer and does not block continued
 * work — see the assignment take-flow's onFocusLoss handler, which only
 * logs + notifies the teacher (scope decision mirrors web: never
 * interrupt the student).
 */
export function useAppStateFocusGuard(options: { enabled: boolean; onFocusLoss?: () => void }) {
  const onFocusLossRef = useRef(options.onFocusLoss);
  useEffect(() => {
    onFocusLossRef.current = options.onFocusLoss;
  }, [options.onFocusLoss]);

  useEffect(() => {
    if (!options.enabled) return;
    const handler = (state: AppStateStatus) => {
      if (state !== 'active') onFocusLossRef.current?.();
    };
    const subscription = AppState.addEventListener('change', handler);
    return () => subscription.remove();
  }, [options.enabled]);
}
