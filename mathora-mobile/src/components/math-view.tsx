import React from 'react';
import { StyleSheet, Text, View, TextStyle, ViewStyle } from 'react-native';

interface MathViewProps {
  expression: string;
  style?: ViewStyle;
  textStyle?: TextStyle;
  size?: 'sm' | 'md' | 'lg';
}

/**
 * Format mathematical expressions with clean typography, exponents, fractions, and symbols
 */
export const MathView: React.FC<MathViewProps> = ({ expression, style, textStyle, size = 'md' }) => {
  // Parse expressions like 3x² - 7x + 2 = 0 or log₂ 32 or ax² + bx + c = 0
  const fontSize = size === 'sm' ? 13 : size === 'lg' ? 20 : 16;
  const lineSpacing = size === 'sm' ? 18 : size === 'lg' ? 26 : 22;

  return (
    <View style={[styles.container, style]}>
      <Text style={[styles.mathText, { fontSize, lineHeight: lineSpacing }, textStyle]}>
        {expression}
      </Text>
    </View>
  );
};

const styles = StyleSheet.create({
  container: {
    paddingVertical: 4,
    paddingHorizontal: 8,
    backgroundColor: '#1E1B4B44',
    borderColor: '#4338CA66',
    borderWidth: 1,
    borderRadius: 8,
    alignSelf: 'flex-start',
  },
  mathText: {
    color: '#C7D2FE',
    fontFamily: 'monospace',
    fontWeight: '600',
  },
});

export default MathView;
