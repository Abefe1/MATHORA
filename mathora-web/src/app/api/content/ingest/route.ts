import { NextResponse } from 'next/server';
import { createClient } from '@/lib/supabase/server';

export const dynamic = 'force-dynamic';

const ADMIN_ROLES = ['teacher', 'content_admin', 'academic_admin', 'super_admin'];
const MAX_FILE_BYTES = 25 * 1024 * 1024; // 25MB — generous for a scanned worksheet PDF, not a whole textbook

/**
 * Uploads a teacher/admin's PDF or DOCX to Supabase Storage, creates
 * the content_uploads row, and triggers content-worker/ to start
 * parsing + generating. This route does the identity/role check and
 * the Storage write (both need the caller's own session so RLS
 * applies normally — see the storage policies in
 * mathora_schema_content_pipeline_patch.sql, which require the file
 * to land under the uploader's own auth.uid() folder); it does not
 * do the parsing itself.
 */
export async function POST(request: Request) {
  const supabase = await createClient();
  if (!supabase) {
    return NextResponse.json({ error: 'Supabase is not configured' }, { status: 500 });
  }

  const {
    data: { user },
  } = await supabase.auth.getUser();
  if (!user) {
    return NextResponse.json({ error: 'unauthorized' }, { status: 401 });
  }

  const { data: profile } = await supabase.from('users').select('role').eq('id', user.id).single();
  if (!profile || !ADMIN_ROLES.includes(profile.role)) {
    return NextResponse.json({ error: 'forbidden' }, { status: 403 });
  }

  const formData = await request.formData();
  const file = formData.get('file');
  const topicId = formData.get('topic_id');
  const questionCountRaw = formData.get('question_count');

  if (!(file instanceof File) || typeof topicId !== 'string' || !topicId) {
    return NextResponse.json({ error: 'file and topic_id are required' }, { status: 400 });
  }
  if (file.size > MAX_FILE_BYTES) {
    return NextResponse.json({ error: 'File exceeds the 25MB limit' }, { status: 400 });
  }
  const allowedTypes = ['application/pdf', 'application/vnd.openxmlformats-officedocument.wordprocessingml.document'];
  if (!allowedTypes.includes(file.type)) {
    return NextResponse.json({ error: 'Only PDF and DOCX files are accepted' }, { status: 400 });
  }

  const questionCount = Math.min(50, Math.max(1, Number(questionCountRaw) || 10));
  const storagePath = `${user.id}/${Date.now()}-${file.name}`;

  const { error: uploadError } = await supabase.storage
    .from('content-uploads')
    .upload(storagePath, file, { contentType: file.type });

  if (uploadError) {
    return NextResponse.json({ error: `Storage upload failed: ${uploadError.message}` }, { status: 500 });
  }

  const { data: uploadRow, error: insertError } = await supabase
    .from('content_uploads')
    .insert({
      uploaded_by: user.id,
      topic_id: topicId,
      original_filename: file.name,
      storage_path: storagePath,
      requested_question_count: questionCount,
      status: 'pending',
    })
    .select()
    .single();

  if (insertError || !uploadRow) {
    return NextResponse.json({ error: insertError?.message ?? 'Failed to create upload record' }, { status: 500 });
  }

  const workerUrl = process.env.CONTENT_WORKER_URL;
  const workerSecret = process.env.WORKER_SHARED_SECRET;

  if (!workerUrl || !workerSecret) {
    // The upload and DB row are saved either way — this just means
    // nothing will pick it up yet. Surfaced clearly rather than
    // silently leaving it stuck at 'pending' with no explanation.
    return NextResponse.json({
      upload: uploadRow,
      warning: 'CONTENT_WORKER_URL/WORKER_SHARED_SECRET not configured — upload saved but not yet queued for processing.',
    });
  }

  try {
    await fetch(`${workerUrl}/process/${uploadRow.id}`, {
      method: 'POST',
      headers: { 'x-worker-secret': workerSecret },
    });
  } catch {
    // The worker being unreachable shouldn't fail the upload itself —
    // content_uploads.status stays 'pending' and can be retried.
  }

  return NextResponse.json({ upload: uploadRow });
}
