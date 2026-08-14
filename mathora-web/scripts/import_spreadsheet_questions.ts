import fs from 'fs';
import path from 'path';
import { createClient } from '@supabase/supabase-js';

/**
 * MATHORA SPREADSHEET QUESTION IMPORTER
 * Converts Google Sheets / CSV content exports into Supabase Relational Database entries.
 *
 * Schema expected in CSV:
 * topic_title, class_level, question_text, option_a, option_b, option_c, option_d, correct_letter, explanation, difficulty, exam_type, exam_shortcut
 */

interface CSVRow {
  topic_title: string;
  class_level: string;
  question_text: string;
  option_a: string;
  option_b: string;
  option_c: string;
  option_d: string;
  correct_letter: 'A' | 'B' | 'C' | 'D';
  explanation: string;
  difficulty: number;
  exam_type: 'WAEC' | 'BECE' | 'JAMB' | 'NECO' | 'GENERAL';
  exam_shortcut?: string;
}

export function parseCSV(csvContent: string): CSVRow[] {
  const lines = csvContent.split(/\r?\n/).filter((l) => l.trim().length > 0);
  if (lines.length < 2) return [];

  const headers = lines[0].split(',').map((h) => h.trim().toLowerCase());
  const rows: CSVRow[] = [];

  for (let i = 1; i < lines.length; i++) {
    const values = lines[i].split(',').map((v) => v.trim().replace(/^"(.*)"$/, '$1'));
    if (values.length < 9) continue;

    rows.push({
      topic_title: values[0] || 'Quadratic Equations',
      class_level: values[1] || 'SS2',
      question_text: values[2],
      option_a: values[3],
      option_b: values[4],
      option_c: values[5],
      option_d: values[6],
      correct_letter: (values[7]?.toUpperCase() as unknown as 'A' | 'B' | 'C' | 'D') || 'A',
      explanation: values[8],
      difficulty: parseInt(values[9] || '2', 10),
      exam_type: (values[10]?.toUpperCase() as unknown as 'WAEC' | 'BECE' | 'JAMB' | 'NECO' | 'GENERAL') || 'WAEC',
      exam_shortcut: values[11] || ''
    });
  }

  return rows;
}

console.log('Mathora Spreadsheet Importer Utility Ready.');
