import React, { useMemo, useState } from 'react';
import { StyleSheet, Text, View, TouchableOpacity } from 'react-native';
import { useTheme } from '@/hooks/use-theme';
import type {
  Activity,
  OrderingActivityData,
  MatchingActivityData,
} from '@/services/supabaseService';

// Native counterpart of mathora-web/src/components/ActivityPlayer.tsx —
// same tap-to-select interaction (no drag-and-drop library here either),
// same two supported types (ordering/matching), same "not yet supported"
// fallback for fill_blank/classify. Renders one Activity and reports a
// 0-100 score back via onComplete.
export default function ActivityPlayer({
  activity,
  onComplete,
}: {
  activity: Activity;
  onComplete: (result: { score: number; time_taken_seconds: number }) => void;
}) {
  const [startedAt] = useState(() => Date.now());

  const finish = (score: number) => {
    onComplete({ score, time_taken_seconds: Math.round((Date.now() - startedAt) / 1000) });
  };

  switch (activity.activity_data.activity_type) {
    case 'ordering':
      return (
        <OrderingPlayer
          data={activity.activity_data}
          title={activity.title}
          instructions={activity.instructions}
          onFinish={finish}
        />
      );
    case 'matching':
      return (
        <MatchingPlayer
          data={activity.activity_data}
          title={activity.title}
          instructions={activity.instructions}
          onFinish={finish}
        />
      );
    default:
      // Plain inline style rather than useTheme()/createStyles() —
      // hooks can't be called conditionally inside a switch branch
      // that might not run.
      return (
        <View style={{ padding: 16, alignItems: 'center' }}>
          <Text style={{ color: '#94A3B8', fontSize: 12 }}>
            This activity type isn&apos;t supported in the app yet.
          </Text>
        </View>
      );
  }
}

function OrderingPlayer({
  data,
  title,
  instructions,
  onFinish,
}: {
  data: OrderingActivityData;
  title: string;
  instructions?: string | null;
  onFinish: (score: number) => void;
}) {
  const colors = useTheme();
  const styles = useMemo(() => createStyles(colors), [colors]);

  const [picked, setPicked] = useState<number[]>([]);
  const [submitted, setSubmitted] = useState(false);

  const remaining = data.items.map((_, i) => i).filter((i) => !picked.includes(i));
  const isComplete = picked.length === data.items.length;
  const correctCount = picked.filter((idx, pos) => idx === data.correct_order[pos]).length;

  const handlePick = (idx: number) => {
    if (submitted) return;
    setPicked((prev) => [...prev, idx]);
  };

  const handleReset = () => {
    setPicked([]);
    setSubmitted(false);
  };

  return (
    <View style={styles.card}>
      <Text style={styles.title}>{title}</Text>
      <Text style={styles.mutedText}>{instructions ?? 'Tap the steps in the correct order.'}</Text>

      <View style={{ marginTop: 12, gap: 8 }}>
        {picked.map((idx, pos) => {
          const isRight = submitted && idx === data.correct_order[pos];
          const isWrong = submitted && idx !== data.correct_order[pos];
          return (
            <View
              key={idx}
              style={[
                styles.pickedRow,
                isRight && styles.rightRow,
                isWrong && styles.wrongRow,
              ]}
            >
              <View style={styles.stepBadge}>
                <Text style={styles.stepBadgeText}>{pos + 1}</Text>
              </View>
              <Text style={styles.rowText}>{data.items[idx]}</Text>
            </View>
          );
        })}
      </View>

      {!isComplete && (
        <View style={{ marginTop: 8, gap: 8 }}>
          {remaining.map((idx) => (
            <TouchableOpacity key={idx} style={styles.optionRow} onPress={() => handlePick(idx)}>
              <Text style={styles.rowText}>{data.items[idx]}</Text>
            </TouchableOpacity>
          ))}
        </View>
      )}

      <View style={styles.footer}>
        <TouchableOpacity onPress={handleReset} disabled={picked.length === 0}>
          <Text style={[styles.resetText, picked.length === 0 && styles.disabledText]}>Reset</Text>
        </TouchableOpacity>

        {!submitted ? (
          <TouchableOpacity
            style={[styles.primaryBtn, !isComplete && styles.disabledBtn]}
            onPress={() => setSubmitted(true)}
            disabled={!isComplete}
          >
            <Text style={styles.primaryBtnText}>Check Order</Text>
          </TouchableOpacity>
        ) : (
          <TouchableOpacity style={styles.primaryBtn} onPress={() => onFinish(Math.round((correctCount / data.items.length) * 100))}>
            <Text style={styles.primaryBtnText}>
              {correctCount === data.items.length ? 'Perfect! Continue' : 'Continue'}
            </Text>
          </TouchableOpacity>
        )}
      </View>
    </View>
  );
}

function MatchingPlayer({
  data,
  title,
  instructions,
  onFinish,
}: {
  data: MatchingActivityData;
  title: string;
  instructions?: string | null;
  onFinish: (score: number) => void;
}) {
  const colors = useTheme();
  const styles = useMemo(() => createStyles(colors), [colors]);

  const [shuffledRight] = useState(() => data.pairs.map((_, i) => i).sort(() => Math.random() - 0.5));
  const [selectedLeft, setSelectedLeft] = useState<number | null>(null);
  const [matches, setMatches] = useState<Record<number, number>>({});
  const matchedRightIndices = new Set(Object.values(matches));
  const isComplete = Object.keys(matches).length === data.pairs.length;
  const [submitted, setSubmitted] = useState(false);

  const handleSelectLeft = (leftIdx: number) => {
    if (submitted || matches[leftIdx] !== undefined) return;
    setSelectedLeft(leftIdx);
  };

  const handleSelectRight = (rightIdx: number) => {
    if (submitted || selectedLeft === null || matchedRightIndices.has(rightIdx)) return;
    setMatches((prev) => ({ ...prev, [selectedLeft]: rightIdx }));
    setSelectedLeft(null);
  };

  const handleReset = () => {
    setMatches({});
    setSelectedLeft(null);
    setSubmitted(false);
  };

  const correctCount = Object.entries(matches).filter(([left, right]) => Number(left) === right).length;

  return (
    <View style={styles.card}>
      <Text style={styles.title}>{title}</Text>
      <Text style={styles.mutedText}>{instructions ?? 'Tap a term, then tap its match.'}</Text>

      <View style={{ flexDirection: 'row', gap: 8, marginTop: 12 }}>
        <View style={{ flex: 1, gap: 8 }}>
          {data.pairs.map((pair, leftIdx) => {
            const matchedTo = matches[leftIdx];
            const isRight = submitted && matchedTo === leftIdx;
            const isWrong = submitted && matchedTo !== undefined && matchedTo !== leftIdx;
            return (
              <TouchableOpacity
                key={leftIdx}
                style={[
                  styles.matchCell,
                  selectedLeft === leftIdx && styles.selectedCell,
                  matchedTo !== undefined && styles.matchedCell,
                  isRight && styles.rightRow,
                  isWrong && styles.wrongRow,
                ]}
                onPress={() => handleSelectLeft(leftIdx)}
                disabled={submitted || matchedTo !== undefined}
              >
                <Text style={styles.rowText}>{pair.left}</Text>
              </TouchableOpacity>
            );
          })}
        </View>

        <View style={{ flex: 1, gap: 8 }}>
          {shuffledRight.map((rightIdx) => {
            const isMatched = matchedRightIndices.has(rightIdx);
            const matchedLeftEntry = Object.entries(matches).find(([, r]) => r === rightIdx);
            const matchedLeft = matchedLeftEntry ? Number(matchedLeftEntry[0]) : null;
            const isRight = submitted && matchedLeft === rightIdx;
            const isWrong = submitted && isMatched && matchedLeft !== rightIdx;
            return (
              <TouchableOpacity
                key={rightIdx}
                style={[
                  styles.matchCell,
                  isMatched && styles.matchedCell,
                  isRight && styles.rightRow,
                  isWrong && styles.wrongRow,
                ]}
                onPress={() => handleSelectRight(rightIdx)}
                disabled={submitted || isMatched || selectedLeft === null}
              >
                <Text style={styles.rowText}>{data.pairs[rightIdx].right}</Text>
              </TouchableOpacity>
            );
          })}
        </View>
      </View>

      <View style={styles.footer}>
        <TouchableOpacity onPress={handleReset} disabled={Object.keys(matches).length === 0}>
          <Text style={[styles.resetText, Object.keys(matches).length === 0 && styles.disabledText]}>Reset</Text>
        </TouchableOpacity>

        {!submitted ? (
          <TouchableOpacity
            style={[styles.primaryBtn, !isComplete && styles.disabledBtn]}
            onPress={() => setSubmitted(true)}
            disabled={!isComplete}
          >
            <Text style={styles.primaryBtnText}>Check Matches</Text>
          </TouchableOpacity>
        ) : (
          <TouchableOpacity style={styles.primaryBtn} onPress={() => onFinish(Math.round((correctCount / data.pairs.length) * 100))}>
            <Text style={styles.primaryBtnText}>
              {correctCount === data.pairs.length ? 'Perfect! Continue' : 'Continue'}
            </Text>
          </TouchableOpacity>
        )}
      </View>
    </View>
  );
}

function createStyles(colors: ReturnType<typeof useTheme>) {
  return StyleSheet.create({
    card: { backgroundColor: colors.surface, borderColor: colors.border, borderWidth: 1, borderRadius: 16, padding: 16 },
    title: { color: colors.text, fontSize: 15, fontWeight: 'bold', marginBottom: 4 },
    mutedText: { color: colors.textMuted, fontSize: 12 },
    rowText: { color: colors.text, fontSize: 13, fontWeight: '600', flex: 1 },
    optionRow: {
      flexDirection: 'row', alignItems: 'center', backgroundColor: colors.background,
      borderColor: colors.border, borderWidth: 1, borderRadius: 10, padding: 12,
    },
    pickedRow: {
      flexDirection: 'row', alignItems: 'center', backgroundColor: colors.surfaceSecondary,
      borderColor: '#6366F1', borderWidth: 1.5, borderRadius: 10, padding: 12, gap: 10,
    },
    matchCell: {
      backgroundColor: colors.background, borderColor: colors.border, borderWidth: 1, borderRadius: 10, padding: 10,
    },
    selectedCell: { borderColor: '#6366F1', borderWidth: 1.5, backgroundColor: colors.surfaceSecondary },
    matchedCell: { opacity: 0.6 },
    rightRow: { borderColor: colors.successBorder, backgroundColor: colors.successSurface },
    wrongRow: { borderColor: colors.dangerBorder, backgroundColor: colors.dangerSurface },
    stepBadge: {
      width: 22, height: 22, borderRadius: 6, backgroundColor: colors.surface,
      alignItems: 'center', justifyContent: 'center',
    },
    stepBadgeText: { color: colors.text, fontSize: 11, fontWeight: 'bold' },
    footer: {
      flexDirection: 'row', alignItems: 'center', justifyContent: 'space-between',
      marginTop: 16, paddingTop: 12, borderTopColor: colors.border, borderTopWidth: 1,
    },
    resetText: { color: colors.textMuted, fontSize: 12, fontWeight: 'bold' },
    disabledText: { opacity: 0.4 },
    primaryBtn: { backgroundColor: '#6366F1', borderRadius: 10, paddingHorizontal: 16, paddingVertical: 10 },
    disabledBtn: { opacity: 0.4 },
    primaryBtnText: { color: '#FFFFFF', fontSize: 13, fontWeight: 'bold' },
  });
}
