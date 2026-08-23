'use client';

import React from 'react';

/**
 * Wraps exam/practice question content to discourage casual copying
 * out to an external solver: blocks text selection, copy/cut, the
 * right-click context menu, and image/element dragging, and blanks
 * itself out under @media print (so "print to PDF" doesn't work
 * either).
 *
 * Read this as a deterrent, not a lock: nothing running in a browser
 * tab can stop the OS-level screenshot tools (PrintScreen, the Snipping
 * Tool, a phone camera pointed at the monitor) or a user with devtools
 * open. That's a real, unavoidable limit of the web platform — there
 * is no web API that blocks screenshots the way expo-screen-capture's
 * FLAG_SECURE genuinely can on Android (see mathora-mobile's
 * useBlockScreenCapture.ts, which is why the native app is the
 * stronger guarantee for this).
 */
export default function NoCopyGuard({ children, className = '' }: { children: React.ReactNode; className?: string }) {
  const block = (e: React.SyntheticEvent) => e.preventDefault();

  return (
    <div
      className={`select-none print:invisible ${className}`}
      onCopy={block}
      onCut={block}
      onContextMenu={block}
      onDragStart={block}
    >
      {children}
    </div>
  );
}
