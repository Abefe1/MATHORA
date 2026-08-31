import React from 'react';
import { View, Text, StyleSheet } from 'react-native';
import Svg, { Circle, G } from 'react-native-svg';

// Mirrors mathora-web/src/components/ui/ProgressRing.tsx's API and
// fixed, deliberately small color palette — every ring in the app
// draws from this set only (see that file's comment for the reasoning:
// matches diagrams/PieChart.tsx's convention of leaving mid-saturation
// segment colors unpaired between light/dark, since they read fine on
// both; only the track needs a light/dark pair, passed in via `colors`).
export const RING_COLORS = {
  correct: '#10B981',
  incorrect: '#F43F5E',
  accent: '#F59E0B',
  neutral: '#6366F1',
} as const;

export type RingColor = keyof typeof RING_COLORS;

export interface RingSegment {
  value: number;
  color: RingColor;
}

interface ProgressRingProps {
  segments: RingSegment[];
  total?: number;
  size?: number;
  strokeWidth?: number;
  trackColor: string;
  textColor: string;
  subTextColor?: string;
  centerLabel: string;
  centerSubLabel?: string;
}

export default function ProgressRing({
  segments,
  total,
  size = 140,
  strokeWidth = 14,
  trackColor,
  textColor,
  subTextColor,
  centerLabel,
  centerSubLabel,
}: ProgressRingProps) {
  const r = (size - strokeWidth) / 2;
  const cx = size / 2;
  const cy = size / 2;
  const circumference = 2 * Math.PI * r;
  const denominator = total ?? (segments.reduce((sum, s) => sum + s.value, 0) || 1);

  const offsets = segments.reduce<number[]>((acc, seg, i) => {
    const prevEnd = i === 0 ? 0 : acc[i - 1] + (segments[i - 1].value / denominator) * circumference;
    acc.push(prevEnd);
    return acc;
  }, []);

  return (
    <View style={{ width: size, height: size, alignItems: 'center', justifyContent: 'center' }}>
      <Svg width={size} height={size}>
        <G rotation={-90} origin={`${cx}, ${cy}`}>
          <Circle cx={cx} cy={cy} r={r} stroke={trackColor} strokeWidth={strokeWidth} fill="none" />
          {segments.map((seg, i) => {
            const length = (seg.value / denominator) * circumference;
            return (
              <Circle
                key={i}
                cx={cx}
                cy={cy}
                r={r}
                stroke={RING_COLORS[seg.color]}
                strokeWidth={strokeWidth}
                strokeLinecap="round"
                fill="none"
                strokeDasharray={circumference}
                strokeDashoffset={circumference - length}
                rotation={(offsets[i] / circumference) * 360}
                origin={`${cx}, ${cy}`}
              />
            );
          })}
        </G>
      </Svg>
      <View style={StyleSheet.absoluteFill}>
        <View style={{ flex: 1, alignItems: 'center', justifyContent: 'center' }}>
          <Text style={{ fontSize: 20, fontWeight: '800', color: textColor }}>{centerLabel}</Text>
          {centerSubLabel && (
            <Text style={{ fontSize: 10, color: subTextColor ?? textColor, marginTop: 2 }}>{centerSubLabel}</Text>
          )}
        </View>
      </View>
    </View>
  );
}
