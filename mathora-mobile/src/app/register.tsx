import React, { useMemo, useState } from 'react';
import {
  StyleSheet,
  Text,
  View,
  TextInput,
  TouchableOpacity,
  SafeAreaView,
  StatusBar,
  KeyboardAvoidingView,
  Platform,
  ActivityIndicator,
  useColorScheme,
} from 'react-native';
import { useRouter } from 'expo-router';
import { useTheme } from '@/hooks/use-theme';
import { supabase } from '@/services/supabaseService';

// Self-serve signup is intentionally limited to these three roles —
// same allow-list as mathora-web/src/app/register/page.tsx, enforced
// again server-side by handle_new_user() regardless of what a client
// sends (see mathora_schema_auth_patch.sql).
const ROLES = [
  { value: 'student', label: 'Student' },
  { value: 'teacher', label: 'Teacher' },
  { value: 'parent', label: 'Parent' },
] as const;

export default function RegisterScreen() {
  const router = useRouter();
  const colors = useTheme();
  const scheme = useColorScheme();
  const styles = useMemo(() => createStyles(colors), [colors]);
  const [fullName, setFullName] = useState('');
  const [email, setEmail] = useState('');
  const [password, setPassword] = useState('');
  const [role, setRole] = useState<(typeof ROLES)[number]['value']>('student');
  const [error, setError] = useState<string | null>(null);
  const [needsConfirmation, setNeedsConfirmation] = useState(false);
  const [loading, setLoading] = useState(false);

  const handleSignUp = async () => {
    setError(null);
    if (!supabase) {
      setError('Sign-up isn’t configured yet — Supabase environment variables are missing.');
      return;
    }

    setLoading(true);
    const { data, error: signUpError } = await supabase.auth.signUp({
      email,
      password,
      options: { data: { full_name: fullName, role } },
    });
    setLoading(false);

    if (signUpError) {
      setError(signUpError.message);
      return;
    }

    if (!data.session) {
      setNeedsConfirmation(true);
      return;
    }

    router.replace('/');
  };

  if (needsConfirmation) {
    return (
      <SafeAreaView style={styles.container}>
        <View style={styles.content}>
          <Text style={styles.title}>Check your inbox</Text>
          <Text style={styles.subtitle}>
            We sent a confirmation link to {email}. Confirm your email to finish creating your account, then come
            back and sign in.
          </Text>
          <TouchableOpacity style={styles.primaryBtn} onPress={() => router.replace('/login')} activeOpacity={0.85}>
            <Text style={styles.primaryBtnText}>Back to Sign In</Text>
          </TouchableOpacity>
        </View>
      </SafeAreaView>
    );
  }

  return (
    <SafeAreaView style={styles.container}>
      <StatusBar barStyle={scheme === 'dark' ? 'light-content' : 'dark-content'} backgroundColor={colors.background} />
      <KeyboardAvoidingView behavior={Platform.OS === 'ios' ? 'padding' : undefined} style={styles.flex}>
        <View style={styles.content}>
          <Text style={styles.logo}>Mathora</Text>
          <Text style={styles.title}>Create your account</Text>
          <Text style={styles.subtitle}>Join Mathora as a student, teacher, or parent.</Text>

          <Text style={styles.label}>Full Name</Text>
          <TextInput
            style={styles.input}
            value={fullName}
            onChangeText={setFullName}
            placeholder="Chidinma Okafor"
            placeholderTextColor={colors.textMuted}
            autoComplete="name"
          />

          <Text style={styles.label}>Email</Text>
          <TextInput
            style={styles.input}
            value={email}
            onChangeText={setEmail}
            placeholder="you@school.edu.ng"
            placeholderTextColor={colors.textMuted}
            autoCapitalize="none"
            keyboardType="email-address"
            autoComplete="email"
          />

          <Text style={styles.label}>Password</Text>
          <TextInput
            style={styles.input}
            value={password}
            onChangeText={setPassword}
            placeholder="At least 8 characters"
            placeholderTextColor={colors.textMuted}
            secureTextEntry
            autoComplete="password-new"
          />

          <Text style={styles.label}>I am a…</Text>
          <View style={styles.roleRow}>
            {ROLES.map((r) => (
              <TouchableOpacity
                key={r.value}
                onPress={() => setRole(r.value)}
                style={[styles.roleChip, role === r.value && styles.roleChipActive]}
                activeOpacity={0.85}
              >
                <Text style={[styles.roleChipText, role === r.value && styles.roleChipTextActive]}>{r.label}</Text>
              </TouchableOpacity>
            ))}
          </View>

          {error && <Text style={styles.errorText}>{error}</Text>}

          <TouchableOpacity style={styles.primaryBtn} onPress={handleSignUp} disabled={loading} activeOpacity={0.85}>
            {loading ? <ActivityIndicator color="#090D16" /> : <Text style={styles.primaryBtnText}>Create Account</Text>}
          </TouchableOpacity>

          <TouchableOpacity onPress={() => router.push('/login')} style={styles.linkRow}>
            <Text style={styles.linkText}>
              Already have an account? <Text style={styles.linkTextBold}>Sign in</Text>
            </Text>
          </TouchableOpacity>
        </View>
      </KeyboardAvoidingView>
    </SafeAreaView>
  );
}

function createStyles(colors: ReturnType<typeof useTheme>) {
  return StyleSheet.create({
    container: { flex: 1, backgroundColor: colors.background },
    flex: { flex: 1 },
    content: { flex: 1, justifyContent: 'center', paddingHorizontal: 24 },
    logo: { fontSize: 20, fontWeight: '800', color: colors.primary, textAlign: 'center', marginBottom: 24 },
    title: { fontSize: 24, fontWeight: '800', color: colors.text, marginBottom: 4 },
    subtitle: { fontSize: 13, color: colors.textMuted, marginBottom: 24, lineHeight: 19 },
    label: { fontSize: 11, fontWeight: '700', color: colors.textMuted, textTransform: 'uppercase', marginBottom: 6, marginTop: 12 },
    input: {
      borderWidth: 1,
      borderColor: colors.border,
      backgroundColor: colors.surface,
      borderRadius: 12,
      paddingHorizontal: 14,
      paddingVertical: 12,
      fontSize: 14,
      color: colors.text,
    },
    roleRow: { flexDirection: 'row', gap: 8 },
    roleChip: {
      flex: 1,
      borderWidth: 1,
      borderColor: colors.border,
      backgroundColor: colors.surface,
      borderRadius: 12,
      paddingVertical: 10,
      alignItems: 'center',
    },
    roleChipActive: { backgroundColor: '#F59E0B', borderColor: '#F59E0B' },
    roleChipText: { fontSize: 12, fontWeight: '700', color: colors.textMuted },
    roleChipTextActive: { color: '#090D16' },
    errorText: { color: colors.dangerText, fontSize: 12, marginTop: 12 },
    primaryBtn: {
      backgroundColor: '#F59E0B',
      borderRadius: 14,
      paddingVertical: 15,
      alignItems: 'center',
      marginTop: 24,
    },
    primaryBtnText: { color: '#090D16', fontSize: 14, fontWeight: '800' },
    linkRow: { marginTop: 20, alignItems: 'center' },
    linkText: { fontSize: 13, color: colors.textMuted },
    linkTextBold: { color: colors.primary, fontWeight: '700' },
  });
}
