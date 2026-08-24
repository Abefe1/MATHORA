// Shared shape contract between generated content (mathora_schema_diagrams_patch.sql's
// diagram_type enum + diagram_data jsonb) and the renderer components in
// src/components/diagrams/. content-worker's generator.py prompt embeds
// this exact shape per type — keep the two in sync if either changes.

export type DiagramType =
  | 'none'
  | 'number_line'
  | 'venn_diagram'
  | 'coordinate_plane'
  | 'triangle'
  | 'circle'
  | 'unit_circle'
  | 'bar_chart'
  | 'pie_chart'
  | 'image';

export interface NumberLineData {
  min: number;
  max: number;
  step?: number;
  points?: { value: number; label: string }[];
  highlightRange?: [number, number];
}

export interface VennDiagramData {
  setA: { label: string; items?: string[] };
  setB: { label: string; items?: string[] };
  setC?: { label: string; items?: string[] };
  universalLabel?: string;
}

export interface CoordinatePlaneData {
  xRange: [number, number];
  yRange: [number, number];
  points?: { x: number; y: number; label?: string }[];
  lines?: { from: { x: number; y: number }; to: { x: number; y: number }; label?: string; color?: string }[];
}

export interface TriangleData {
  vertices: [
    { label: string; x: number; y: number },
    { label: string; x: number; y: number },
    { label: string; x: number; y: number },
  ];
  sideLabels?: { from: string; to: string; label: string }[];
  angleLabels?: { vertex: string; label: string }[];
  rightAngleAt?: string;
}

export interface CircleData {
  radiusLabel?: string;
  centerLabel?: string;
  points?: { label: string; angleDegrees: number }[];
  highlightSector?: { startAngle: number; endAngle: number; label?: string };
  chord?: { fromAngle: number; toAngle: number; label?: string };
}

export interface UnitCircleData {
  angleDegrees: number;
  showSine?: boolean;
  showCosine?: boolean;
  showTangent?: boolean;
}

export interface BarChartData {
  categories: string[];
  values: number[];
  yLabel?: string;
}

export interface PieChartData {
  slices: { label: string; value: number }[];
}

// A figure the source document actually contained (a scanned diagram,
// photo, or graph Docling extracted as a picture rather than text) —
// see content-worker/app/parser.py and db.py's upload_extracted_image.
// Used instead of a hand-built vector diagram when the real figure is
// available and worth preserving as-is, rather than re-drawing it.
export interface ImageDiagramData {
  imageUrl: string;
  caption?: string;
}

export type DiagramData =
  | NumberLineData
  | VennDiagramData
  | CoordinatePlaneData
  | TriangleData
  | CircleData
  | UnitCircleData
  | BarChartData
  | PieChartData
  | ImageDiagramData
  | Record<string, never>;
