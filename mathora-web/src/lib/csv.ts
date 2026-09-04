import Papa from 'papaparse';

// Triggers a browser download of `rows` as a CSV file. Uses papaparse's
// unparse (already a dependency here for the roster bulk-upload parser,
// see app/teacher/class/[classId]/roster/page.tsx) rather than adding a
// second CSV library just for the reverse direction.
export function downloadCsv(filename: string, rows: Record<string, string | number>[]) {
  if (rows.length === 0) return;
  const csv = Papa.unparse(rows);
  const blob = new Blob([csv], { type: 'text/csv;charset=utf-8;' });
  const url = URL.createObjectURL(blob);
  const link = document.createElement('a');
  link.href = url;
  link.download = filename;
  document.body.appendChild(link);
  link.click();
  document.body.removeChild(link);
  URL.revokeObjectURL(url);
}
