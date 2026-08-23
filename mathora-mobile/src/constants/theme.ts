import { Platform } from 'react-native';

export const ThemeTokens = {
  // Brand Tokens
  brandNavy: '#172554',
  brandBlue: '#2563EB',
  brandLight: '#EFF6FF',
  sky: '#38BDF8',

  // Learning State & Semantic Tokens
  mint: '#10B981',        // Mastered / Success
  amber: '#F59E0B',       // XP / Attention / Needs Practice
  coral: '#F97316',       // Challenges / Streak
  red: '#EF4444',         // Error / Mistake

  // Light Mode Defaults
  light: {
    background: '#F8FAFC',
    surface: '#FFFFFF',
    surfaceSecondary: '#F1F5F9',
    border: '#E2E8F0',
    text: '#0F172A',
    textMuted: '#64748B',
    primary: '#2563EB',
    headerBg: '#172554',
  },

  // Dark Mode Defaults
  dark: {
    background: '#0B1120',
    surface: '#111827',
    surfaceSecondary: '#1E293B',
    border: '#334155',
    text: '#F8FAFC',
    textMuted: '#94A3B8',
    primary: '#3B82F6',
    headerBg: '#0F172A',
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
