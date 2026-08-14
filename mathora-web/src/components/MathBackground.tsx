'use client';

import React, { useEffect, useRef } from 'react';

export default function MathBackground() {
  const canvasRef = useRef<HTMLCanvasElement | null>(null);

  useEffect(() => {
    const canvas = canvasRef.current;
    if (!canvas) return;
    const ctx = canvas.getContext('2d');
    if (!ctx) return;

    let animationFrameId: number;
    let width = 0;
    let height = 0;
    let time = 0;

    // Check prefers-reduced-motion
    const reducedMotionQuery = window.matchMedia('(prefers-reduced-motion: reduce)');
    const prefersReducedMotion = reducedMotionQuery.matches;

    // Resize Handler
    const handleResize = () => {
      if (!canvas) return;
      width = canvas.width = canvas.parentElement?.clientWidth || window.innerWidth;
      height = canvas.height = canvas.parentElement?.clientHeight || window.innerHeight;
    };

    handleResize();
    window.addEventListener('resize', handleResize);

    // Particle Constellation Data (~35 items max for 60fps)
    const SYMBOLS = ['π', '∑', '∫', '√x', '∞', 'θ', 'Δ', 'λ', 'f(x)'];
    const particles = Array.from({ length: 35 }, () => ({
      x: Math.random() * (width || 1200),
      y: Math.random() * (height || 800),
      vx: (Math.random() - 0.5) * 0.4,
      vy: (Math.random() - 0.5) * 0.4,
      symbol: SYMBOLS[Math.floor(Math.random() * SYMBOLS.length)],
      opacity: Math.random() * 0.25 + 0.1,
    }));

    // Main Draw Function
    const draw = () => {
      ctx.clearRect(0, 0, width, height);

      time += 0.015;

      // 1. Faint Drifting Graph Paper Grid Pattern
      ctx.save();
      ctx.strokeStyle = 'rgba(99, 102, 241, 0.04)';
      ctx.lineWidth = 1;
      const gridSize = 40;
      const gridShiftX = (time * 5) % gridSize;
      const gridShiftY = (time * 3) % gridSize;

      for (let x = gridShiftX; x < width; x += gridSize) {
        ctx.beginPath();
        ctx.moveTo(x, 0);
        ctx.lineTo(x, height);
        ctx.stroke();
      }

      for (let y = gridShiftY; y < height; y += gridSize) {
        ctx.beginPath();
        ctx.moveTo(0, y);
        ctx.lineTo(width, y);
        ctx.stroke();
      }
      ctx.restore();

      // 2. Continuous Parametric Function Curves
      ctx.save();
      // Wave 1: Sine Wave (Cyan)
      ctx.beginPath();
      ctx.strokeStyle = 'rgba(6, 182, 212, 0.18)';
      ctx.lineWidth = 2;
      const waveY = height * 0.45;
      const amplitude = 35;
      const frequency = 0.008;

      for (let x = 0; x < width; x += 5) {
        const y = waveY + Math.sin(x * frequency + time * 1.2) * amplitude + Math.cos(x * 0.004 + time * 0.8) * 15;
        if (x === 0) ctx.moveTo(x, y);
        else ctx.lineTo(x, y);
      }
      ctx.stroke();

      // Wave 2: Damped Cosine Curve (Indigo)
      ctx.beginPath();
      ctx.strokeStyle = 'rgba(99, 102, 241, 0.15)';
      ctx.lineWidth = 1.5;
      const waveY2 = height * 0.65;

      for (let x = 0; x < width; x += 5) {
        const y = waveY2 + Math.cos(x * 0.006 - time * 1.5) * 45;
        if (x === 0) ctx.moveTo(x, y);
        else ctx.lineTo(x, y);
      }
      ctx.stroke();
      ctx.restore();

      // 3. Rotating Unit Circle with Angle Marker (Trig Indicator)
      ctx.save();
      const circleX = width * 0.85;
      const circleY = height * 0.35;
      const radius = 60;

      // Circle Outline
      ctx.beginPath();
      ctx.arc(circleX, circleY, radius, 0, Math.PI * 2);
      ctx.strokeStyle = 'rgba(168, 85, 247, 0.15)';
      ctx.lineWidth = 1.5;
      ctx.setLineDash([4, 4]);
      ctx.stroke();
      ctx.setLineDash([]);

      // Axes
      ctx.beginPath();
      ctx.moveTo(circleX - radius - 15, circleY);
      ctx.lineTo(circleX + radius + 15, circleY);
      ctx.moveTo(circleX, circleY - radius - 15);
      ctx.lineTo(circleX, circleY + radius + 15);
      ctx.strokeStyle = 'rgba(168, 85, 247, 0.1)';
      ctx.stroke();

      // Rotating Angle Ray (θ)
      const angle = time * 0.8;
      const rayX = circleX + Math.cos(angle) * radius;
      const rayY = circleY - Math.sin(angle) * radius;

      ctx.beginPath();
      ctx.moveTo(circleX, circleY);
      ctx.lineTo(rayX, rayY);
      ctx.strokeStyle = 'rgba(6, 182, 212, 0.4)';
      ctx.lineWidth = 2;
      ctx.stroke();

      // Angle Arc
      ctx.beginPath();
      ctx.arc(circleX, circleY, 20, 0, -angle, true);
      ctx.strokeStyle = 'rgba(245, 158, 11, 0.3)';
      ctx.stroke();
      ctx.restore();

      // 4. Constellation Particles & Connecting Lines
      ctx.save();
      ctx.font = '12px system-ui, sans-serif';
      ctx.textAlign = 'center';
      ctx.textBaseline = 'middle';

      // Update & Draw Particles
      for (let i = 0; i < particles.length; i++) {
        const p = particles[i];

        if (!prefersReducedMotion) {
          p.x += p.vx;
          p.y += p.vy;

          if (p.x < 0) p.x = width;
          if (p.x > width) p.x = 0;
          if (p.y < 0) p.y = height;
          if (p.y > height) p.y = 0;
        }

        // Draw Math Symbol / Particle Dot
        ctx.fillStyle = `rgba(224, 231, 255, ${p.opacity})`;
        ctx.fillText(p.symbol, p.x, p.y);

        // Draw Proximity Connections
        for (let j = i + 1; j < particles.length; j++) {
          const p2 = particles[j];
          const dx = p.x - p2.x;
          const dy = p.y - p2.y;
          const dist = Math.sqrt(dx * dx + dy * dy);

          if (dist < 110) {
            const lineOpacity = (1 - dist / 110) * 0.08;
            ctx.beginPath();
            ctx.moveTo(p.x, p.y);
            ctx.lineTo(p2.x, p2.y);
            ctx.strokeStyle = `rgba(99, 102, 241, ${lineOpacity})`;
            ctx.lineWidth = 1;
            ctx.stroke();
          }
        }
      }
      ctx.restore();

      if (!prefersReducedMotion) {
        animationFrameId = requestAnimationFrame(draw);
      }
    };

    draw();

    // Cleanup RAF and Window Resize Listener
    return () => {
      window.removeEventListener('resize', handleResize);
      if (animationFrameId) {
        cancelAnimationFrame(animationFrameId);
      }
    };
  }, []);

  return (
    <canvas
      ref={canvasRef}
      className="absolute inset-0 w-full h-full pointer-events-none z-0 overflow-hidden"
    />
  );
}
