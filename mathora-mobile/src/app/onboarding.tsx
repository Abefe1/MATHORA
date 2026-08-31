import React, { useMemo, useState } from 'react';
import { StyleSheet, Text, View, SafeAreaView, TouchableOpacity } from 'react-native';
import { useRouter } from 'expo-router';
import { useTheme } from '@/hooks/use-theme';

const slides = [
  {
    id: 1,
    title: 'Welcome to DCOMPANION',
    badge: 'D-MATH COMPANION',
    desc: 'The curriculum-aligned Mathematics mastery engine for Nigerian secondary school students (JSS1–SS3).',
    emoji: '📐',
  },
  {
    id: 2,
    title: 'WAEC & BECE Diagnostic',
    badge: 'DIAGNOSTIC PLACEMENT',
    desc: 'Pinpoint exact syllabus weak points with AI diagnostic placement before taking your final exams.',
    emoji: '🎯',
  },
  {
    id: 3,
    title: 'Automatic Rescue Mode',
    badge: 'MISTAKE RECOVERY',
    desc: 'When you get stuck, Rescue Mode steps in to break down complex problems step-by-step.',
    emoji: '⚡',
  },
  {
    id: 4,
    title: 'Parent Corner Oversight',
    badge: 'REAL-TIME REPORTING',
    desc: 'Connect parents and teachers with live progress tracking, weekly study limits, and remarks.',
    emoji: '👨‍👩‍👧',
  },
];

export default function MobileOnboardingScreen() {
  const router = useRouter();
  const colors = useTheme();
  const styles = useMemo(() => createStyles(colors), [colors]);
  const [currentSlide, setCurrentSlide] = useState(0);

  const handleNext = () => {
    if (currentSlide < slides.length - 1) {
      setCurrentSlide((prev) => prev + 1);
    } else {
      router.replace('/');
    }
  };

  const slide = slides[currentSlide];

  return (
    <SafeAreaView style={styles.container}>
      <View style={styles.header}>
        <TouchableOpacity onPress={() => router.replace('/')}>
          <Text style={styles.skipText}>Skip</Text>
        </TouchableOpacity>
      </View>

      <View style={styles.content}>
        <View style={styles.iconCircle}>
          <Text style={{ fontSize: 56 }}>{slide.emoji}</Text>
        </View>

        <Text style={styles.badge}>{slide.badge}</Text>
        <Text style={styles.title}>{slide.title}</Text>
        <Text style={styles.desc}>{slide.desc}</Text>

        {/* Indicators */}
        <View style={styles.dotsRow}>
          {slides.map((_, idx) => (
            <View
              key={idx}
              style={[styles.dot, currentSlide === idx && styles.activeDot]}
            />
          ))}
        </View>
      </View>

      <View style={styles.footer}>
        <TouchableOpacity style={styles.nextBtn} onPress={handleNext}>
          <Text style={styles.nextBtnText}>
            {currentSlide === slides.length - 1 ? 'Get Started →' : 'Continue →'}
          </Text>
        </TouchableOpacity>
      </View>
    </SafeAreaView>
  );
}

function createStyles(colors: ReturnType<typeof useTheme>) {
  return StyleSheet.create({
    container: { flex: 1, backgroundColor: colors.background },
    header: { padding: 20, alignItems: 'flex-end' },
    skipText: { color: colors.textMuted, fontSize: 14, fontWeight: 'bold' },
    content: { flex: 1, alignItems: 'center', justifyContent: 'center', paddingHorizontal: 32 },
    iconCircle: {
      width: 120,
      height: 120,
      borderRadius: 60,
      backgroundColor: '#1E1B4B',
      borderColor: '#4338CA',
      borderWidth: 2,
      alignItems: 'center',
      justifyContent: 'center',
      marginBottom: 24,
    },
    badge: { color: '#F59E0B', fontSize: 11, fontWeight: 'bold', letterSpacing: 1, marginBottom: 8 },
    title: { color: colors.text, fontSize: 26, fontWeight: 'bold', textAlign: 'center', marginBottom: 12 },
    desc: { color: colors.textMuted, fontSize: 14, textAlign: 'center', lineHeight: 22, marginBottom: 32 },
    dotsRow: { flexDirection: 'row', gap: 8 },
    dot: { width: 8, height: 8, borderRadius: 4, backgroundColor: colors.surfaceSecondary },
    activeDot: { width: 24, backgroundColor: '#F59E0B' },
    footer: { padding: 24 },
    nextBtn: {
      backgroundColor: '#F59E0B',
      borderRadius: 14,
      paddingVertical: 16,
      alignItems: 'center',
    },
    nextBtnText: { color: '#090D16', fontSize: 16, fontWeight: 'bold' },
  });
}
