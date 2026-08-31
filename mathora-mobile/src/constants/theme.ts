import { Platform } from 'react-native';

// Mirrors mathora-web's actual theme (globals.css / Primitives.tsx / the
// admin pages' bg-slate-50 dark:bg-slate-950 pairing) — this used to hold
// a different navy/blue/mint/coral palette that zero screens ever
// adopted; the values below are canonicalized from the hex literals the
// mobile screens already hardcode (teacher.tsx, roster.tsx, etc.) so both
// platforms speak one color language instead of two unrelated ones.
export const ThemeTokens = {
  // Brand / role accents — same amber-primary, emerald-secondary,
  // indigo-tertiary, rose-danger roles used throughout mathora-web.
  amber: '#F59E0B',    // primary accent, student surfaces, WAEC/streak
  emerald: '#10B981',  // teacher surfaces, success, mastered
  indigo: '#6366F1',   // admin/"chalk" accent
  cyan: '#06B6D4',     // verified badge
  rose: '#F43F5E',     // danger, struggling, incorrect
  purple: '#A855F7',   // rescue mode

  // Light Mode Defaults — Tailwind slate-50/white/slate-200/slate-900,
  // matching layout.tsx's bg-slate-50 dark:bg-slate-950 pairing on web.
  light: {
    background: '#F8FAFC',
    surface: '#FFFFFF',
    surfaceSecondary: '#F1F5F9',
    border: '#E2E8F0',
    text: '#0F172A',
    textMuted: '#64748B',
    primary: '#D97706',   // amber-600 — same shift web's Navbar/Badge use for light-mode contrast
    headerBg: '#FFFFFF',
    // Tinted alert/status surfaces — mirrors web's Badge component's
    // bg-amber-50/bg-emerald-50/bg-rose-50 (+ matching border) pairing.
    warningSurface: '#FEF3C7', warningBorder: '#FDE68A', warningText: '#B45309',
    successSurface: '#ECFDF5', successBorder: '#A7F3D0', successText: '#059669',
    dangerSurface: '#FEF2F2', dangerBorder: '#FCA5A5', dangerText: '#DC2626',
  },

  // Dark Mode Defaults — the exact hex values already hardcoded across
  // teacher.tsx/roster.tsx/school-search.tsx/find-class.tsx this session.
  dark: {
    background: '#090D16',
    surface: '#0F172A',
    surfaceSecondary: '#1E293B',
    border: '#1E293B',
    text: '#FFFFFF',
    textMuted: '#94A3B8',
    primary: '#F59E0B',   // amber-500 — matches web's dark-mode primary
    headerBg: '#090D16',
    warningSurface: '#78350F22', warningBorder: '#B45309', warningText: '#FBBF24',
    successSurface: '#064E3B22', successBorder: '#059669', successText: '#34D399',
    dangerSurface: '#7F1D1D22', dangerBorder: '#EF4444', dangerText: '#F87171',
  },
} as const;

export const Radius = {
  card: 16,
  button: 10,
  input: 10,
  hero: 20,
  pill: 999,
} as const;

export const Typography = {
  display: { fontSize: 36, fontWeight: '800' as const, lineHeight: 44 },
  h1: { fontSize: 28, fontWeight: '800' as const, lineHeight: 36 },
  h2: { fontSize: 22, fontWeight: '700' as const, lineHeight: 30 },
  h3: { fontSize: 18, fontWeight: '700' as const, lineHeight: 26 },
  body: { fontSize: 15, fontWeight: '400' as const, lineHeight: 22 },
  bodyBold: { fontSize: 15, fontWeight: '600' as const, lineHeight: 22 },
  small: { fontSize: 13, fontWeight: '500' as const, lineHeight: 18 },
  caption: { fontSize: 11, fontWeight: '600' as const, lineHeight: 16 },
} as const;

export const Colors = ThemeTokens;
export const Spacing = {
  half: 2,
  one: 4,
  two: 8,
  three: 16,
  four: 24,
  five: 32,
  six: 64,
} as const;

export const BottomTabInset = Platform.select({ ios: 50, android: 80 }) ?? 0;
export const MaxContentWidth = 800;

// Keys of the light/dark palette (background, surface, text, primary, ...).
// Used by ThemedText/ThemedView to type-check `themeColor`/`type` props
// against an actual token instead of an arbitrary string.
export type ThemeColor = keyof typeof ThemeTokens.light;

// System font stack, following Expo's standard theme.ts convention
// (ios gets the native ui-* families; everything else falls back to
// the platform default). The app doesn't currently load a custom
// font via expo-font, so this intentionally stays system-only.
export const Fonts = Platform.select({
  ios: {
    sans: 'system-ui',
    serif: 'ui-serif',
    rounded: 'ui-rounded',
    mono: 'ui-monospace',
  },
  default: {
    sans: 'normal',
    serif: 'serif',
    rounded: 'normal',
    mono: 'monospace',
  },
});
