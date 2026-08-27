'use client';

import React from 'react';
import { motion } from 'framer-motion';
import type { ImageDiagramData } from '@/lib/diagramTypes';

/**
 * Renders a figure actually extracted from the source document
 * (a scanned diagram/photo Docling pulled out as a picture rather
 * than text) instead of a hand-built vector diagram — used when the
 * real figure is available and worth preserving as-is. Still
 * animated (fade + scale entrance), just not hand-drawn/step-revealed
 * the way the vector diagram types are, since it's a flat image.
 */
export default function ImageDiagram({ data }: { data: ImageDiagramData }) {
  const { imageUrl, caption } = data;

  return (
    <motion.figure
      className="max-w-md mx-auto"
      initial={{ opacity: 0, scale: 0.94 }}
      animate={{ opacity: 1, scale: 1 }}
      transition={{ duration: 0.5, ease: 'easeOut' }}
    >
      {/* eslint-disable-next-line @next/next/no-img-element -- source
          images come from Supabase Storage at arbitrary dimensions;
          not worth the next/image remote-pattern config for
          admin-review-gated content that's already size-capped at
          upload time (see MAX_FILE_BYTES in api/content/ingest). */}
      <img
        src={imageUrl}
        alt={caption ?? 'Diagram from source document'}
        className="w-full rounded-xl border border-slate-200 dark:border-slate-800"
      />
      {caption && (
        <figcaption className="text-xs text-slate-500 dark:text-slate-400 text-center mt-2 italic">{caption}</figcaption>
      )}
    </motion.figure>
  );
}
