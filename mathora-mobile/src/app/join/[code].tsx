// Deep-link handler for invite links: dcompanion://join/<CODE> (and the
// matching universal link once one is configured). expo-router auto-
// routes this file since app.json already registers the "dcompanion"
// scheme — no extra native config needed.
//
// Known limitation: AuthGate (app/_layout.tsx) redirects a signed-out
// user straight to /login on any non-public route, which drops this
// deep link's target. A signed-out student tapping an invite link
// today has to re-open it manually after logging in; carrying the
// pending code through login is a follow-up, not solved here.
import React, { useEffect, useState } from 'react';
import { StyleSheet, Text, View, SafeAreaView, ActivityIndicator, TouchableOpacity } from 'react-native';
import { useLocalSearchParams, useRouter } from 'expo-router';
import { joinClassWithCode } from '@/services/supabaseService';

export default function JoinByCodeScreen() {
  const { code } = useLocalSearchParams<{ code: string }>();
  const router = useRouter();
  const [status, setStatus] = useState<'joining' | 'joined' | 'failed'>('joining');
  const [className, setClassName] = useState('');

  useEffect(() => {
    if (!code) return;
    joinClassWithCode(code).then((result) => {
      if (result) {
        setClassName(result.name);
        setStatus('joined');
      } else {
        setStatus('failed');
      }
    });
  }, [code]);

  return (
    <SafeAreaView style={styles.container}>
      <View style={styles.content}>
        {status === 'joining' && (
          <>
            <ActivityIndicator color="#10B981" size="large" />
            <Text style={styles.text}>Joining class...</Text>
          </>
        )}
        {status === 'joined' && (
          <>
            <Text style={styles.emoji}>✅</Text>
            <Text style={styles.title}>You&apos;re in!</Text>
            <Text style={styles.text}>You&apos;ve joined {className}.</Text>
          </>
        )}
        {status === 'failed' && (
          <>
            <Text style={styles.emoji}>⚠️</Text>
            <Text style={styles.title}>Couldn&apos;t join</Text>
            <Text style={styles.text}>That invite code may be invalid or expired.</Text>
          </>
        )}
        <TouchableOpacity style={styles.btn} onPress={() => router.replace('/')}>
          <Text style={styles.btnText}>Go to Dashboard</Text>
        </TouchableOpacity>
      </View>
    </SafeAreaView>
  );
}

const styles = StyleSheet.create({
  container: { flex: 1, backgroundColor: '#090D16' },
  content: { flex: 1, alignItems: 'center', justifyContent: 'center', padding: 24 },
  emoji: { fontSize: 48, marginBottom: 12 },
  title: { color: '#FFFFFF', fontSize: 20, fontWeight: 'bold', marginTop: 12 },
  text: { color: '#94A3B8', fontSize: 13, marginTop: 8, textAlign: 'center' },
  btn: { backgroundColor: '#10B981', borderRadius: 8, paddingVertical: 12, paddingHorizontal: 24, marginTop: 24 },
  btnText: { color: '#FFFFFF', fontSize: 14, fontWeight: 'bold' },
});
