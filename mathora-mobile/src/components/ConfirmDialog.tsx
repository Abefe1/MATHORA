import React from 'react';
import { ActivityIndicator, Modal, StyleSheet, Text, TouchableOpacity, View } from 'react-native';
import { useTheme } from '@/hooks/use-theme';

interface ConfirmDialogProps {
  isOpen: boolean;
  title: string;
  message: string;
  confirmLabel?: string;
  cancelLabel?: string;
  variant?: 'danger' | 'default';
  busy?: boolean;
  onConfirm: () => void;
  onCancel: () => void;
}

// Native counterpart of mathora-web/src/components/ui/ConfirmDialog.tsx —
// mobile has no equivalent (destructive actions here fall back to RN's
// native Alert.alert), so this is net new rather than a port. RN
// Modal-based, styled via the shared ThemeTokens color object the same
// way Toaster.tsx is, for a matching card/button feel.
export default function ConfirmDialog({
  isOpen,
  title,
  message,
  confirmLabel = 'Confirm',
  cancelLabel = 'Cancel',
  variant = 'default',
  busy = false,
  onConfirm,
  onCancel,
}: ConfirmDialogProps) {
  const colors = useTheme();

  return (
    <Modal visible={isOpen} transparent animationType="fade" onRequestClose={onCancel}>
      <View style={styles.backdrop}>
        <View style={[styles.card, { backgroundColor: colors.surface, borderColor: colors.border }]}>
          <Text style={[styles.title, { color: colors.text }]}>{title}</Text>
          <Text style={[styles.message, { color: colors.textMuted }]}>{message}</Text>

          <View style={styles.actions}>
            <TouchableOpacity onPress={onCancel} disabled={busy} style={styles.cancelBtn}>
              <Text style={[styles.cancelText, { color: colors.textMuted }]}>{cancelLabel}</Text>
            </TouchableOpacity>
            <TouchableOpacity
              onPress={onConfirm}
              disabled={busy}
              style={[
                styles.confirmBtn,
                { backgroundColor: variant === 'danger' ? '#F43F5E' : colors.primary },
              ]}
            >
              {busy ? (
                <ActivityIndicator size="small" color="#FFFFFF" />
              ) : (
                <Text style={styles.confirmText}>{confirmLabel}</Text>
              )}
            </TouchableOpacity>
          </View>
        </View>
      </View>
    </Modal>
  );
}

const styles = StyleSheet.create({
  backdrop: {
    flex: 1,
    backgroundColor: 'rgba(2, 6, 23, 0.6)',
    alignItems: 'center',
    justifyContent: 'center',
    padding: 20,
  },
  card: {
    width: '100%',
    maxWidth: 340,
    borderRadius: 16,
    borderWidth: 1,
    padding: 20,
  },
  title: { fontSize: 15, fontWeight: 'bold', marginBottom: 6 },
  message: { fontSize: 13, lineHeight: 19 },
  actions: { flexDirection: 'row', justifyContent: 'flex-end', gap: 12, marginTop: 20 },
  cancelBtn: { paddingVertical: 10, paddingHorizontal: 12 },
  cancelText: { fontSize: 13, fontWeight: '600' },
  confirmBtn: { paddingVertical: 10, paddingHorizontal: 18, borderRadius: 10, minWidth: 88, alignItems: 'center' },
  confirmText: { color: '#FFFFFF', fontSize: 13, fontWeight: 'bold' },
});
