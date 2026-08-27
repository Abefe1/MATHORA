'use client';

import React from 'react';
import type { DiagramType, DiagramData } from '@/lib/diagramTypes';
import NumberLine from './NumberLine';
import VennDiagram from './VennDiagram';
import CoordinatePlane from './CoordinatePlane';
import TriangleDiagram from './TriangleDiagram';
import CircleDiagram from './CircleDiagram';
import UnitCircle from './UnitCircle';
import BarChart from './BarChart';
import PieChart from './PieChart';
import ImageDiagram from './ImageDiagram';

/**
 * Single entry point for rendering a generated diagram_type/diagram_data
 * pair (see mathora_schema_diagrams_patch.sql and lib/diagramTypes.ts —
 * content-worker's generator.py prompt is written against this exact
 * contract). Returns null for 'none' or an unrecognized type rather
 * than throwing, so a malformed/older row degrades to "no diagram"
 * instead of breaking the page.
 */
export default function DiagramRenderer({ type, data }: { type?: DiagramType; data?: DiagramData }) {
  if (!type || type === 'none' || !data) return null;

  const wrapperClass = 'my-4 p-4 rounded-2xl bg-white dark:bg-slate-900 border border-slate-200 dark:border-slate-800';

  switch (type) {
    case 'number_line':
      return <div className={wrapperClass}><NumberLine data={data as never} /></div>;
    case 'venn_diagram':
      return <div className={wrapperClass}><VennDiagram data={data as never} /></div>;
    case 'coordinate_plane':
      return <div className={wrapperClass}><CoordinatePlane data={data as never} /></div>;
    case 'triangle':
      return <div className={wrapperClass}><TriangleDiagram data={data as never} /></div>;
    case 'circle':
      return <div className={wrapperClass}><CircleDiagram data={data as never} /></div>;
    case 'unit_circle':
      return <div className={wrapperClass}><UnitCircle data={data as never} /></div>;
    case 'bar_chart':
      return <div className={wrapperClass}><BarChart data={data as never} /></div>;
    case 'pie_chart':
      return <div className={wrapperClass}><PieChart data={data as never} /></div>;
    case 'image':
      return <div className={wrapperClass}><ImageDiagram data={data as never} /></div>;
    default:
      return null;
  }
}
