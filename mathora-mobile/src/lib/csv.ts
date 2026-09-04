import Papa from 'papaparse';
import { File, Paths } from 'expo-file-system';
import * as Sharing from 'expo-sharing';

// Native counterpart of mathora-web/src/lib/csv.ts. There's no browser
// `<a download>` here, so the CSV is written to the cache directory and
// handed to the native share sheet (Sharing.shareAsync) instead — the
// user picks Save to Files / Drive / email / etc. themselves. Falls
// back to a no-op (rather than throwing) if sharing isn't available on
// the device, same fail-soft contract as the rest of this app's
// Supabase calls.
export async function downloadCsv(filename: string, rows: Record<string, string | number>[]): Promise<void> {
  if (rows.length === 0) return;
  const csv = Papa.unparse(rows);

  const file = new File(Paths.cache, filename);
  if (file.exists) file.delete();
  file.create();
  file.write(csv);

  if (await Sharing.isAvailableAsync()) {
    await Sharing.shareAsync(file.uri, { mimeType: 'text/csv', dialogTitle: filename });
  }
}
