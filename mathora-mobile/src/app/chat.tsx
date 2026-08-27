import React, { useState } from 'react';
import { StyleSheet, Text, View, ScrollView, TextInput, TouchableOpacity, SafeAreaView, KeyboardAvoidingView, Platform } from 'react-native';
import { useRouter } from 'expo-router';

interface Message {
  id: string;
  sender: string;
  role: 'student' | 'teacher';
  text: string;
  time: string;
}

export default function MobileChatScreen() {
  const router = useRouter();
  const [messages, setMessages] = useState<Message[]>([
    { id: '1', sender: 'Chidiebere Okafor', role: 'student', text: 'Has anyone solved Q4 from the 2024 WAEC mock?', time: '10:14 AM' },
    { id: '2', sender: 'Mr. Bello (Teacher)', role: 'teacher', text: 'Check if b^2 - 4ac > 0 before factoring!', time: '10:16 AM' },
    { id: '3', sender: 'Aminat Yusuf', role: 'student', text: 'Got it! x = 2 and x = 3.', time: '10:18 AM' },
  ]);
  const [inputText, setInputText] = useState('');

  const handleSend = () => {
    if (!inputText.trim()) return;
    const newMsg: Message = {
      id: Date.now().toString(),
      sender: 'You (Chidiebere)',
      role: 'student',
      text: inputText,
      time: new Date().toLocaleTimeString([], { hour: '2-digit', minute: '2-digit' }),
    };
    setMessages((prev) => [...prev, newMsg]);
    setInputText('');
  };

  return (
    <SafeAreaView style={styles.container}>
      <KeyboardAvoidingView behavior={Platform.OS === 'ios' ? 'padding' : 'height'} style={{ flex: 1 }}>
        <View style={styles.header}>
          <TouchableOpacity onPress={() => router.back()}>
            <Text style={styles.backText}>← Back</Text>
          </TouchableOpacity>
          <View style={{ alignItems: 'center' }}>
            <Text style={styles.headerTitle}>SS2 Math Squad Chat</Text>
            <Text style={styles.headerSub}>🟢 12 Students &amp; Teachers Active</Text>
          </View>
          <View style={{ width: 40 }} />
        </View>

        <ScrollView contentContainerStyle={styles.feed} showsVerticalScrollIndicator={false}>
          {messages.map((m) => (
            <View key={m.id} style={[styles.msgBubble, m.role === 'teacher' && styles.teacherBubble]}>
              <View style={styles.msgHeader}>
                <Text style={styles.senderName}>{m.sender}</Text>
                <Text style={styles.timeText}>{m.time}</Text>
              </View>
              <Text style={styles.msgText}>{m.text}</Text>
            </View>
          ))}
        </ScrollView>

        <View style={styles.inputRow}>
          <TextInput
            style={styles.textInput}
            value={inputText}
            onChangeText={setInputText}
            placeholder="Type a math question or hint..."
            placeholderTextColor="#64748B"
          />
          <TouchableOpacity style={styles.sendBtn} onPress={handleSend}>
            <Text style={styles.sendBtnText}>Send</Text>
          </TouchableOpacity>
        </View>
      </KeyboardAvoidingView>
    </SafeAreaView>
  );
}

const styles = StyleSheet.create({
  container: { flex: 1, backgroundColor: '#090D16' },
  header: {
    padding: 16,
    flexDirection: 'row',
    alignItems: 'center',
    justifyContent: 'space-between',
    borderBottomWidth: 1,
    borderColor: '#1E293B',
  },
  backText: { color: '#F59E0B', fontSize: 14, fontWeight: 'bold' },
  headerTitle: { color: '#FFFFFF', fontSize: 16, fontWeight: 'bold' },
  headerSub: { color: '#10B981', fontSize: 10, marginTop: 2 },
  feed: { padding: 16, gap: 12 },
  msgBubble: {
    backgroundColor: '#1E293B',
    borderRadius: 14,
    padding: 12,
    borderColor: '#334155',
    borderWidth: 1,
  },
  teacherBubble: {
    backgroundColor: '#064E3B22',
    borderColor: '#10B981',
  },
  msgHeader: { flexDirection: 'row', justifyContent: 'space-between', marginBottom: 4 },
  senderName: { color: '#F59E0B', fontSize: 12, fontWeight: 'bold' },
  timeText: { color: '#64748B', fontSize: 10 },
  msgText: { color: '#F8FAFC', fontSize: 13, lineHeight: 18 },
  inputRow: {
    flexDirection: 'row',
    padding: 12,
    gap: 8,
    borderTopWidth: 1,
    borderColor: '#1E293B',
    backgroundColor: '#0F172A',
  },
  textInput: {
    flex: 1,
    backgroundColor: '#1E293B',
    borderRadius: 10,
    paddingHorizontal: 14,
    paddingVertical: 10,
    color: '#FFFFFF',
    fontSize: 13,
  },
  sendBtn: {
    backgroundColor: '#F59E0B',
    borderRadius: 10,
    paddingHorizontal: 16,
    justifyContent: 'center',
  },
  sendBtnText: { color: '#090D16', fontSize: 13, fontWeight: 'bold' },
});
