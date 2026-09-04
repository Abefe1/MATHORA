import React, { useEffect, useState } from 'react';
import { Animated, StyleSheet, Text, TouchableOpacity, View } from 'react-native';
import { useTheme } from '@/hooks/use-theme';
import { useToastContext, type ToastVariant } from '@/lib/toastContext';

// Native counterpart of mathora-web/src/components/ui/Toaster.tsx.
// Mounted once at the root layout (see app/_layout.tsx), alongside
// AuthProvider/ThemeProvider — individual screens just call useToast()
// and never render anything themselves.
export default function Toaster() {
  const colors = useTheme();
  const { toasts, dismissToast } = useToastContext();

  if (toasts.length === 0) return null;

  return (
    <View style={styles.container} pointerEvents="box-none">
      {toasts.map((t) => (
        <ToastRow key={t.id} variant={t.variant} message={t.message} onDismiss={() => dismissToast(t.id)} colors={colors} />
      ))}
    </View>
  );
}

const VARIANT_STYLE: Record<ToastVariant, { bg: (c: ReturnType<typeof useTheme>) => string; border: (c: ReturnType<typeof useTheme>) => string; text: (c: ReturnType<typeof useTheme>) => string; icon: string }> = {
  success: { bg: (c) => c.successSurface, border: (c) => c.successBorder, text: (c) => c.successText, icon: '✓' },
  error: { bg: (c) => c.dangerSurface, border: (c) => c.dangerBorder, text: (c) => c.dangerText, icon: '✕' },
  info: { bg: (c) => c.surfaceSecondary, border: (c) => c.border, text: (c) => c.text, icon: 'ℹ' },
};

function ToastRow({
  variant,
  message,
  onDismiss,
  colors,
}: {
  variant: ToastVariant;
  message: string;
  onDismiss: () => void;
  colors: ReturnType<typeof useTheme>;
}) {
  // useState (not useRef) — accessing a ref's .current during render is
  // disallowed; a lazy useState initializer gives the same "create once"
  // mutable Animated.Value without touching a ref at render time.
  const [opacity] = useState(() => new Animated.Value(0));
  const { bg, border, text, icon } = VARIANT_STYLE[variant];

  useEffect(() => {
    Animated.timing(opacity, { toValue: 1, duration: 180, useNativeDriver: true }).start();
  }, [opacity]);

  return (
    <Animated.View
      style={[
        styles.row,
        { backgroundColor: bg(colors), borderColor: border(colors), opacity },
      ]}
    >
      <Text style={[styles.icon, { color: text(colors) }]}>{icon}</Text>
      <Text style={[styles.message, { color: text(colors) }]}>{message}</Text>
      <TouchableOpacity onPress={onDismiss} hitSlop={8}>
        <Text style={[styles.dismiss, { color: text(colors) }]}>✕</Text>
      </TouchableOpacity>
    </Animated.View>
  );
}

const styles = StyleSheet.create({
  container: {
    position: 'absolute',
    bottom: 24,
    left: 16,
    right: 16,
    gap: 8,
    zIndex: 100,
  },
  row: {
    flexDirection: 'row',
    alignItems: 'center',
    gap: 8,
    borderWidth: 1,
    borderRadius: 12,
    paddingHorizontal: 14,
    paddingVertical: 12,
    shadowColor: '#000',
    shadowOpacity: 0.15,
    shadowOffset: { width: 0, height: 4 },
    shadowRadius: 8,
    elevation: 4,
  },
  icon: { fontSize: 13, fontWeight: 'bold' },
  message: { flex: 1, fontSize: 13, fontWeight: '600' },
  dismiss: { fontSize: 12, opacity: 0.6 },
});
