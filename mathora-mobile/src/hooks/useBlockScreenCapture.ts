import { useEffect } from 'react';
import { Platform, Alert } from 'react-native';
import * as ScreenCapture from 'expo-screen-capture';

/**
 * Blocks screenshots/screen recording of the screen this hook is
 * mounted on, so exam/practice question content can't be captured and
 * fed to an external solver.
 *
 * Platform reality check (there is no way around this — it's an OS
 * limitation, not an Expo one):
 *  - Android: preventScreenCaptureAsync() sets FLAG_SECURE on the
 *    window. This genuinely blocks both screenshots (the capture
 *    comes back black) and screen recording, and also blacks out the
 *    app's thumbnail in the Recent Apps switcher.
 *  - iOS: there is no public API that blocks a screenshot from being
 *    taken — Apple doesn't expose one to any app. preventScreenCaptureAsync()
 *    on iOS only blanks the output while actively screen *recording*
 *    (mirroring/broadcast). For screenshots we can only detect after
 *    the fact via addScreenshotListener and react (warn the student,
 *    optionally report it) — not prevent it.
 *
 * Call this from any screen showing exam/practice question content;
 * it cleans up (re-allows capture) on unmount so it doesn't leak into
 * unrelated screens.
 */
export function useBlockScreenCapture(options?: { onScreenshotDetected?: () => void }) {
  useEffect(() => {
    ScreenCapture.preventScreenCaptureAsync();

    let subscription: { remove: () => void } | undefined;
    if (Platform.OS === 'ios') {
      subscription = ScreenCapture.addScreenshotListener(() => {
        options?.onScreenshotDetected?.();
        Alert.alert(
          'Screenshots aren’t permitted',
          'Question content can’t be captured during practice or exams. Please close any screenshot and continue.'
        );
      });
    }

    return () => {
      ScreenCapture.allowScreenCaptureAsync();
      subscription?.remove();
    };
    // eslint-disable-next-line react-hooks/exhaustive-deps -- onScreenshotDetected is expected to be stable per screen; re-subscribing on every render would be wrong here.
  }, []);
}
