'use client';

import React, { useState, useEffect } from 'react';
import Link from 'next/link';
import { motion, AnimatePresence, useMotionValue, useTransform } from 'framer-motion';
import Navbar from '@/components/Navbar';
import MathRenderer from '@/components/MathRenderer';
import MathBackground from '@/components/MathBackground';
import EquationReveal from '@/components/EquationReveal';
import AutoSolveDemo from '@/components/AutoSolveDemo';
import { MathoraMark, MathMotif, Card, Button, Badge } from '@/components/ui/Primitives';
import { Sparkles, Target, ChevronRight, Play, Lightbulb, GraduationCap, Users } from 'lucide-react';

export default function LandingPage() {
  // Live Quadratic Solver State
  const [a, setA] = useState(1);
  const [b, setB] = useState(-5);
  const [c, setC] = useState(6);
  const [activeStep, setActiveStep] = useState(1);

  // Mouse Parallax Motion
  const mouseX = useMotionValue(0);
  const mouseY = useMotionValue(0);

  const parallaxX = useTransform(mouseX, [-600, 600], [-12, 12]);
  const parallaxY = useTransform(mouseY, [-400, 400], [-12, 12]);

  useEffect(() => {
    const handleMouseMove = (e: MouseEvent) => {
      const { innerWidth, innerHeight } = window;
      mouseX.set(e.clientX - innerWidth / 2);
      mouseY.set(e.clientY - innerHeight / 2);
    };

    window.addEventListener('mousemove', handleMouseMove);
    return () => window.removeEventListener('mousemove', handleMouseMove);
  }, [mouseX, mouseY]);

  // Discriminant & Roots
  const discriminant = b * b - 4 * a * c;
  const sqrtDisc = Math.sqrt(Math.abs(discriminant));
  const root1 = discriminant >= 0 ? ((-b + sqrtDisc) / (2 * a)).toFixed(2) : null;
  const root2 = discriminant >= 0 ? ((-b - sqrtDisc) / (2 * a)).toFixed(2) : null;

  return (
    <div className="min-h-screen bg-slate-50 dark:bg-slate-950 text-slate-900 dark:text-slate-100 flex flex-col overflow-x-hidden selection:bg-amber-500 selection:text-slate-950 relative font-sans">
      <Navbar />

      {/* Hero Section with Graph Paper Texture & Canvas Scene */}
      <section className="relative pt-12 pb-24 md:pt-20 md:pb-32 overflow-hidden bg-graph-paper">
        <MathBackground />

        {/* Floating Mouse-Parallax Formula Chips */}
        <motion.div
          style={{ x: parallaxX, y: parallaxY }}
          initial={{ opacity: 0, scale: 0.9 }}
          animate={{ opacity: 1, scale: 1 }}
          transition={{ duration: 0.7, delay: 0.2 }}
          className="absolute top-16 left-[5%] paper-card px-4 py-2.5 rounded-xl border border-slate-300 dark:border-slate-700 shadow-2xl animate-math-drift hidden lg:block z-10 font-mono"
        >
          <EquationReveal content="$x = \frac{-b \pm \sqrt{b^2 - 4ac}}{2a}$" className="text-xs font-semibold text-amber-700 dark:text-amber-300" duration={1.4} delay={0.6} />
        </motion.div>

        <motion.div
          style={{ x: parallaxX, y: parallaxY }}
          initial={{ opacity: 0, scale: 0.9 }}
          animate={{ opacity: 1, scale: 1 }}
          transition={{ duration: 0.7, delay: 0.4 }}
          className="absolute top-44 right-[6%] paper-card px-4 py-2.5 rounded-xl border border-slate-300 dark:border-slate-700 shadow-2xl animate-math-drift-delayed hidden lg:block z-10 font-mono"
        >
          <EquationReveal content="$\sin^2 \theta + \cos^2 \theta = 1$" className="text-xs font-semibold text-cyan-700 dark:text-cyan-300" duration={1.2} delay={0.9} />
        </motion.div>

        {/* Main Hero Content */}
        <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 text-center relative z-10">
          {/* Badge */}
          <motion.div
            initial={{ opacity: 0, y: 15 }}
            animate={{ opacity: 1, y: 0 }}
            transition={{ duration: 0.5 }}
            className="inline-flex items-center gap-2 px-4 py-1.5 rounded-md bg-amber-50 dark:bg-amber-950/80 border border-amber-200/80 dark:border-amber-800/80 text-amber-700 dark:text-amber-300 text-xs font-mono font-bold mb-6 shadow-lg"
          >
            <Sparkles className="w-4 h-4 text-amber-600 dark:text-amber-400" />
            <span>Built from a concerned Teacher&apos;s Experience</span>
          </motion.div>

          {/* Display Headline */}
          <motion.h1
            initial={{ opacity: 0, y: 20 }}
            animate={{ opacity: 1, y: 0 }}
            transition={{ duration: 0.6, delay: 0.1 }}
            className="font-display text-4xl sm:text-6xl md:text-7xl font-extrabold text-slate-900 dark:text-white tracking-tight max-w-5xl mx-auto leading-[1.1]"
          >
            Understand. Solve.{' '}
            <span className="text-amber-600 dark:text-amber-400 block mt-1 underline decoration-amber-500/50 underline-offset-8">
              Master WAEC Mathematics.
            </span>
          </motion.h1>

          <motion.p
            initial={{ opacity: 0, y: 20 }}
            animate={{ opacity: 1, y: 0 }}
            transition={{ duration: 0.6, delay: 0.2 }}
            className="mt-6 text-lg sm:text-xl text-slate-600 dark:text-slate-300 max-w-3xl mx-auto font-normal leading-relaxed"
          >
            The Nigerian Mathematics & Further Mathematics platform built around a 3-step pedagogical engine: <strong className="text-amber-600 dark:text-amber-400">Deconstruct</strong>, <strong className="text-cyan-600 dark:text-cyan-400">Rescue Mistakes</strong>, and <strong className="text-emerald-600 dark:text-emerald-400">Ace WAEC/BECE Exams</strong>.
          </motion.p>

          {/* Action CTAs */}
          <motion.div
            initial={{ opacity: 0, y: 20 }}
            animate={{ opacity: 1, y: 0 }}
            transition={{ duration: 0.6, delay: 0.3 }}
            className="mt-10 flex flex-col sm:flex-row items-center justify-center gap-4"
          >
            <Link href="/student/practice">
              <Button variant="primary" size="lg" className="w-full sm:w-auto font-display">
                Launch Interactive Practice <Play className="w-5 h-5 fill-current" />
              </Button>
            </Link>

            <Link href="/parent">
              <Button variant="chalk" size="lg" className="w-full sm:w-auto font-display bg-amber-600 hover:bg-amber-500 shadow-amber-600/20">
                Parent Corner <Users className="w-5 h-5 text-amber-900 dark:text-amber-100" />
              </Button>
            </Link>

            <Link href="/student/diagnostic">
              <Button variant="outline" size="lg" className="w-full sm:w-auto font-display">
                Diagnostic Test <Target className="w-5 h-5 text-cyan-600 dark:text-cyan-400" />
              </Button>
            </Link>
          </motion.div>

          {/* Live Quadratic Formula Solver Playground */}
          <motion.div
            initial={{ opacity: 0, y: 30 }}
            animate={{ opacity: 1, y: 0 }}
            transition={{ duration: 0.7, delay: 0.4 }}
            className="mt-16 max-w-3xl mx-auto paper-card rounded-2xl p-6 sm:p-8 border border-slate-200 dark:border-slate-800 shadow-2xl text-left relative"
          >
            <div className="flex items-center justify-between gap-4 mb-4 pb-4 border-b border-slate-200 dark:border-slate-800">
              <div className="flex items-center gap-3">
                <MathMotif type="function" className="w-6 h-6 text-amber-600 dark:text-amber-400" />
                <div>
                  <h3 className="font-display font-bold text-sm text-slate-900 dark:text-white">Live Quadratic Equation Playground</h3>
                  <p className="text-[11px] font-mono text-slate-500 dark:text-slate-400">Interactive formula typesetting and discriminant engine</p>
                </div>
              </div>
              <Badge variant="waec">KaTeX Engine</Badge>
            </div>

            {/* Dynamic Formula Display */}
            <div className="bg-white dark:bg-slate-900 rounded-xl p-5 border border-slate-200 dark:border-slate-800 text-center mb-6">
              <span className="text-xs font-mono font-bold text-amber-600 dark:text-amber-400 uppercase tracking-wider block mb-2">Equation Form</span>
              <MathRenderer
                content={`$$${a === 1 ? '' : a === -1 ? '-' : a}x^2 ${b >= 0 ? '+ ' + b : '- ' + Math.abs(b)}x ${c >= 0 ? '+ ' + c : '- ' + Math.abs(c)} = 0$$`}
                className="text-xl sm:text-2xl font-bold text-slate-900 dark:text-white font-mono"
              />
            </div>

            {/* Controls */}
            <div className="grid grid-cols-3 gap-4 mb-6 font-mono">
              <div>
                <label className="block text-xs font-bold uppercase text-slate-500 dark:text-slate-400 mb-1">Coefficient $a$</label>
                <div className="flex items-center gap-2">
                  <button onClick={() => setA((prev) => (prev > 1 ? prev - 1 : 1))} className="px-3 py-1 rounded bg-slate-100 dark:bg-slate-800 text-xs font-bold text-slate-800 dark:text-slate-200 hover:bg-slate-700">-</button>
                  <span className="text-sm font-bold text-slate-900 dark:text-white flex-1 text-center">{a}</span>
                  <button onClick={() => setA((prev) => prev + 1)} className="px-3 py-1 rounded bg-slate-100 dark:bg-slate-800 text-xs font-bold text-slate-800 dark:text-slate-200 hover:bg-slate-700">+</button>
                </div>
              </div>

              <div>
                <label className="block text-xs font-bold uppercase text-slate-500 dark:text-slate-400 mb-1">Coefficient $b$</label>
                <div className="flex items-center gap-2">
                  <button onClick={() => setB((prev) => prev - 1)} className="px-3 py-1 rounded bg-slate-100 dark:bg-slate-800 text-xs font-bold text-slate-800 dark:text-slate-200 hover:bg-slate-700">-</button>
                  <span className="text-sm font-bold text-slate-900 dark:text-white flex-1 text-center">{b}</span>
                  <button onClick={() => setB((prev) => prev + 1)} className="px-3 py-1 rounded bg-slate-100 dark:bg-slate-800 text-xs font-bold text-slate-800 dark:text-slate-200 hover:bg-slate-700">+</button>
                </div>
              </div>

              <div>
                <label className="block text-xs font-bold uppercase text-slate-500 dark:text-slate-400 mb-1">Coefficient $c$</label>
                <div className="flex items-center gap-2">
                  <button onClick={() => setC((prev) => prev - 1)} className="px-3 py-1 rounded bg-slate-100 dark:bg-slate-800 text-xs font-bold text-slate-800 dark:text-slate-200 hover:bg-slate-700">-</button>
                  <span className="text-sm font-bold text-slate-900 dark:text-white flex-1 text-center">{c}</span>
                  <button onClick={() => setC((prev) => prev + 1)} className="px-3 py-1 rounded bg-slate-100 dark:bg-slate-800 text-xs font-bold text-slate-800 dark:text-slate-200 hover:bg-slate-700">+</button>
                </div>
              </div>
            </div>

            {/* Calculated Solution Output */}
            <div className="bg-slate-900/90 border border-slate-200 dark:border-slate-800 rounded-xl p-4 flex flex-col sm:flex-row items-center justify-between gap-4">
              <div>
                <span className="text-xs font-mono font-bold text-amber-700 dark:text-amber-300 uppercase tracking-wide">Discriminant: $\Delta = b^2 - 4ac = {discriminant}$</span>
                <p className="text-xs text-slate-500 dark:text-slate-400 mt-0.5 font-sans">
                  {discriminant > 0 ? 'Two distinct real roots' : discriminant === 0 ? 'One repeated real root' : 'Complex roots'}
                </p>
              </div>

              {discriminant >= 0 ? (
                <div className="flex items-center gap-3 font-mono">
                  <div className="px-3 py-1.5 rounded-lg bg-slate-100 dark:bg-slate-800 border border-slate-300 dark:border-slate-700 text-center">
                    <span className="text-[10px] text-slate-500 dark:text-slate-400 font-bold block">ROOT $x_1$</span>
                    <MathRenderer content={`$${root1}$`} className="text-sm font-bold text-cyan-700 dark:text-cyan-300" />
                  </div>
                  <div className="px-3 py-1.5 rounded-lg bg-slate-100 dark:bg-slate-800 border border-slate-300 dark:border-slate-700 text-center">
                    <span className="text-[10px] text-slate-500 dark:text-slate-400 font-bold block">ROOT $x_2$</span>
                    <MathRenderer content={`$${root2}$`} className="text-sm font-bold text-cyan-700 dark:text-cyan-300" />
                  </div>
                </div>
              ) : (
                <div className="text-xs font-mono font-bold text-amber-600 dark:text-amber-400 bg-amber-50 dark:bg-amber-950/60 px-3 py-1.5 rounded-lg border border-amber-200 dark:border-amber-800 flex items-center gap-1">
                  <MathRenderer content="$\Delta < 0$ (Complex Roots)" />
                </div>
              )}
            </div>
          </motion.div>

          {/* Auto-Solving Live Demo */}
          <motion.div
            initial={{ opacity: 0, y: 30 }}
            whileInView={{ opacity: 1, y: 0 }}
            viewport={{ once: true, amount: 0.3 }}
            transition={{ duration: 0.7, delay: 0.1 }}
            className="mt-6 max-w-3xl mx-auto"
          >
            <AutoSolveDemo />
          </motion.div>
        </div>
      </section>

      {/* 3-Step Remediation Simulator Section */}
      <section className="py-20 bg-slate-900/80 border-y border-slate-200 dark:border-slate-800 relative z-10">
        <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
          <motion.div
            initial={{ opacity: 0, y: 24 }}
            whileInView={{ opacity: 1, y: 0 }}
            viewport={{ once: true, amount: 0.4 }}
            transition={{ duration: 0.6 }}
            className="text-center max-w-3xl mx-auto mb-14"
          >
            <Badge variant="waec">The Mathora Learning Engine</Badge>
            <h2 className="text-3xl sm:text-4xl font-display font-extrabold text-slate-900 dark:text-white mt-3">
              How Students Master Complex Topics
            </h2>
            <p className="text-slate-500 dark:text-slate-400 text-sm mt-3">
              Click through the three steps to experience Rescue Mode remediation when a student makes a mistake.
            </p>
          </motion.div>

          {/* Switcher */}
          <motion.div
            initial={{ opacity: 0, y: 20 }}
            whileInView={{ opacity: 1, y: 0 }}
            viewport={{ once: true, amount: 0.4 }}
            transition={{ duration: 0.6, delay: 0.1 }}
            className="flex justify-center gap-3 mb-10 max-w-xl mx-auto font-mono"
          >
            <motion.button
              whileHover={{ scale: 1.03 }}
              whileTap={{ scale: 0.97 }}
              onClick={() => setActiveStep(1)}
              className={`flex-1 py-3 px-4 rounded-xl text-xs font-bold transition-colors border ${
                activeStep === 1
                  ? 'bg-amber-500 text-slate-950 border-amber-400 shadow-lg shadow-amber-500/20'
                  : 'bg-white dark:bg-slate-900 border-slate-200 dark:border-slate-800 text-slate-500 dark:text-slate-400 hover:text-slate-900 dark:hover:text-white'
              }`}
            >
              01. Understand
            </motion.button>
            <motion.button
              whileHover={{ scale: 1.03 }}
              whileTap={{ scale: 0.97 }}
              onClick={() => setActiveStep(2)}
              className={`flex-1 py-3 px-4 rounded-xl text-xs font-bold transition-colors border ${
                activeStep === 2
                  ? 'bg-purple-600 text-white border-purple-500 shadow-lg shadow-purple-500/20'
                  : 'bg-white dark:bg-slate-900 border-slate-200 dark:border-slate-800 text-slate-500 dark:text-slate-400 hover:text-slate-900 dark:hover:text-white'
              }`}
            >
              02. Rescue Mode
            </motion.button>
            <motion.button
              whileHover={{ scale: 1.03 }}
              whileTap={{ scale: 0.97 }}
              onClick={() => setActiveStep(3)}
              className={`flex-1 py-3 px-4 rounded-xl text-xs font-bold transition-colors border ${
                activeStep === 3
                  ? 'bg-emerald-600 text-white border-emerald-500 shadow-lg shadow-emerald-500/20'
                  : 'bg-white dark:bg-slate-900 border-slate-200 dark:border-slate-800 text-slate-500 dark:text-slate-400 hover:text-slate-900 dark:hover:text-white'
              }`}
            >
              03. WAEC Shortcut
            </motion.button>
          </motion.div>

          {/* Active Step Card */}
          <motion.div
            initial={{ opacity: 0, y: 24 }}
            whileInView={{ opacity: 1, y: 0 }}
            viewport={{ once: true, amount: 0.3 }}
            transition={{ duration: 0.6, delay: 0.15 }}
            className="max-w-3xl mx-auto"
          >
            <Card variant="notebook" className="shadow-2xl relative overflow-hidden">
              <AnimatePresence mode="wait">
                {activeStep === 1 && (
                  <motion.div
                    key="step-1"
                    initial={{ opacity: 0, x: 24 }}
                    animate={{ opacity: 1, x: 0 }}
                    exit={{ opacity: 0, x: -24 }}
                    transition={{ duration: 0.3 }}
                    className="space-y-4"
                  >
                    <div className="flex items-center gap-3">
                      <MathMotif type="function" className="w-6 h-6 text-amber-600 dark:text-amber-400" />
                      <div>
                        <h3 className="text-xl font-display font-bold text-slate-900 dark:text-white">1. Deconstruction & Understanding</h3>
                        <p className="text-xs font-mono text-amber-700 dark:text-amber-300">Clear Markdown & KaTeX equation typesetting</p>
                      </div>
                    </div>
                    <p className="text-sm text-slate-600 dark:text-slate-300 leading-relaxed">
                      Instead of plain textbook text, every mathematical formula is deconstructed into readable step-by-step components:
                    </p>
                    <div className="bg-white dark:bg-slate-900 rounded-xl p-4 border border-slate-200 dark:border-slate-800 font-mono">
                      <EquationReveal content="Solve $3x^2 - 7x + 2 = 0$ by identifying factors of $ac = 3 \times 2 = 6$ that sum to $-7$." className="text-sm text-slate-900 dark:text-white font-semibold" duration={1.3} showCaret={false} />
                    </div>
                  </motion.div>
                )}

                {activeStep === 2 && (
                  <motion.div
                    key="step-2"
                    initial={{ opacity: 0, x: 24 }}
                    animate={{ opacity: 1, x: 0 }}
                    exit={{ opacity: 0, x: -24 }}
                    transition={{ duration: 0.3 }}
                    className="space-y-4"
                  >
                    <div className="flex items-center gap-3">
                      <MathMotif type="delta" className="w-6 h-6 text-purple-600 dark:text-purple-400" />
                      <div>
                        <h3 className="text-xl font-display font-bold text-slate-900 dark:text-white">2. Automatic Rescue Remediation</h3>
                        <p className="text-xs font-mono text-purple-700 dark:text-purple-300">Triggers immediately on incorrect quiz selection</p>
                      </div>
                    </div>
                    <motion.div
                      initial={{ opacity: 0, scale: 0.96 }}
                      animate={{ opacity: 1, scale: 1 }}
                      transition={{ duration: 0.35, delay: 0.1 }}
                      className="bg-purple-50 dark:bg-purple-950/40 border border-purple-300/60 dark:border-purple-900/60 rounded-xl p-4 flex items-start gap-3"
                    >
                      <Lightbulb className="w-5 h-5 text-purple-600 dark:text-purple-400 flex-shrink-0 mt-0.5 animate-pulse" />
                      <div>
                        <span className="text-xs font-mono font-bold text-purple-700 dark:text-purple-300 uppercase">Diagnosed Sign Misunderstanding:</span>
                        <EquationReveal content="When expanding $-6x - x$, pay attention to factor multiplication: $(-6) \times (-1) = +6$. Don't swap positive constants!" className="text-xs text-slate-800 dark:text-slate-200 mt-1" duration={1.3} delay={0.15} showCaret={false} />
                      </div>
                    </motion.div>
                  </motion.div>
                )}

                {activeStep === 3 && (
                  <motion.div
                    key="step-3"
                    initial={{ opacity: 0, x: 24 }}
                    animate={{ opacity: 1, x: 0 }}
                    exit={{ opacity: 0, x: -24 }}
                    transition={{ duration: 0.3 }}
                    className="space-y-4"
                  >
                    <div className="flex items-center gap-3">
                      <MathMotif type="angle" className="w-6 h-6 text-emerald-600 dark:text-emerald-400" />
                      <div>
                        <h3 className="text-xl font-display font-bold text-slate-900 dark:text-white">3. WAEC & BECE Exam Shortcut Layer</h3>
                        <p className="text-xs font-mono text-emerald-700 dark:text-emerald-300">Rapid multiple-choice examination techniques</p>
                      </div>
                    </div>
                    <motion.div
                      initial={{ opacity: 0, scale: 0.96 }}
                      animate={{ opacity: 1, scale: 1 }}
                      transition={{ duration: 0.35, delay: 0.1 }}
                      className="bg-emerald-50 dark:bg-emerald-950/40 border border-emerald-300/60 dark:border-emerald-900/60 rounded-xl p-4 flex items-start gap-3"
                    >
                      <Sparkles className="w-5 h-5 text-emerald-600 dark:text-emerald-400 flex-shrink-0 mt-0.5" />
                      <div>
                        <span className="text-xs font-mono font-bold text-emerald-700 dark:text-emerald-300 uppercase">WAEC MCQ Technique:</span>
                        <EquationReveal content="For $ax^2 + bx + c = 0$, sum of roots is $-\frac{b}{a} = \frac{7}{3}$ and product is $\frac{c}{a} = \frac{2}{3}$. Test options instantly using root products!" className="text-xs text-slate-800 dark:text-slate-200 mt-1" duration={1.3} delay={0.15} showCaret={false} />
                      </div>
                    </motion.div>
                  </motion.div>
                )}
              </AnimatePresence>
            </Card>
          </motion.div>
        </div>
      </section>

      {/* Role Navigation Portals Section */}
      <section className="py-20 relative z-10">
        <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
          <motion.div
            initial={{ opacity: 0, y: 20 }}
            whileInView={{ opacity: 1, y: 0 }}
            viewport={{ once: true, amount: 0.4 }}
            transition={{ duration: 0.6 }}
            className="text-center mb-12"
          >
            <h2 className="text-3xl font-display font-extrabold text-slate-900 dark:text-white">Mathora Role Portals</h2>
            <p className="text-sm text-slate-500 dark:text-slate-400 mt-2">Distinct environments tailored to students, teachers, and parents.</p>
          </motion.div>

          <div className="grid grid-cols-1 md:grid-cols-3 gap-8">
            {/* Student Notebook Card */}
            <motion.div
              initial={{ opacity: 0, y: 30 }}
              whileInView={{ opacity: 1, y: 0 }}
              viewport={{ once: true, amount: 0.3 }}
              transition={{ duration: 0.55 }}
              whileHover={{ y: -8 }}
            >
              <Card variant="notebook" className="hover:border-amber-500/60 group cursor-pointer h-full">
                <div className="flex items-center justify-between mb-4">
                  <Badge variant="waec">Student Portal</Badge>
                  <MathMotif type="function" className="w-6 h-6 text-amber-600 dark:text-amber-400" />
                </div>
                <h3 className="text-lg font-display font-bold text-slate-900 dark:text-white">Student Practice Notebook</h3>
                <p className="text-xs text-slate-600 dark:text-slate-300 mt-2 leading-relaxed">
                  Interactive SS2 topic browser, step-by-step worked examples, Rescue Mode practice, and timed WAEC mock exams.
                </p>
                <Link href="/student/practice" className="mt-4 flex items-center gap-1 text-xs font-mono font-bold text-amber-600 dark:text-amber-400 group-hover:translate-x-1 transition-transform">
                  Launch Practice <ChevronRight className="w-4 h-4" />
                </Link>
              </Card>
            </motion.div>

            {/* Teacher Ledger Card */}
            <motion.div
              initial={{ opacity: 0, y: 30 }}
              whileInView={{ opacity: 1, y: 0 }}
              viewport={{ once: true, amount: 0.3 }}
              transition={{ duration: 0.55, delay: 0.12 }}
              whileHover={{ y: -8 }}
            >
              <Card variant="ledger" className="hover:border-emerald-500/60 group cursor-pointer h-full">
                <div className="flex items-center justify-between mb-4">
                  <Badge variant="mastered">Teacher Portal</Badge>
                  <GraduationCap className="w-6 h-6 text-emerald-600 dark:text-emerald-400" />
                </div>
                <h3 className="text-lg font-display font-bold text-slate-900 dark:text-white">Teacher Academic Ledger</h3>
                <p className="text-xs text-slate-600 dark:text-slate-300 mt-2 leading-relaxed">
                  Create verified teacher classes, generate join codes, assign topic sets, and view real-time student mastery performance.
                </p>
                <Link href="/teacher" className="mt-4 flex items-center gap-1 text-xs font-mono font-bold text-emerald-600 dark:text-emerald-400 group-hover:translate-x-1 transition-transform">
                  Open Teacher Dashboard <ChevronRight className="w-4 h-4" />
                </Link>
              </Card>
            </motion.div>

            {/* Parent Report Card */}
            <motion.div
              initial={{ opacity: 0, y: 30 }}
              whileInView={{ opacity: 1, y: 0 }}
              viewport={{ once: true, amount: 0.3 }}
              transition={{ duration: 0.55, delay: 0.24 }}
              whileHover={{ y: -8 }}
            >
              <Card variant="report" className="hover:border-amber-600/60 group cursor-pointer h-full">
                <div className="flex items-center justify-between mb-4">
                  <Badge variant="bece">Parent Dashboard</Badge>
                  <Users className="w-6 h-6 text-amber-600 dark:text-amber-400" />
                </div>
                <h3 className="text-lg font-display font-bold text-slate-900 dark:text-white">Parent Progress Report</h3>
                <p className="text-xs text-slate-600 dark:text-slate-300 mt-2 leading-relaxed">
                  Calm, non-gamified child progress overview, weekly study hours, teacher notes, and attention-needed topic alerts.
                </p>
                <Link href="/parent" className="mt-4 flex items-center gap-1 text-xs font-mono font-bold text-amber-600 dark:text-amber-400 group-hover:translate-x-1 transition-transform">
                  Track Child Progress <ChevronRight className="w-4 h-4" />
                </Link>
              </Card>
            </motion.div>
          </div>
        </div>
      </section>

      {/* Footer */}
      <footer className="mt-auto py-8 bg-white dark:bg-slate-900 border-t border-slate-200 dark:border-slate-800 text-center text-xs font-mono text-slate-500 dark:text-slate-400 relative z-10">
        <div className="max-w-7xl mx-auto px-4 flex flex-col sm:flex-row items-center justify-between gap-4">
          <motion.div
            initial={{ opacity: 0, y: 10 }}
            whileInView={{ opacity: 1, y: 0 }}
            viewport={{ once: true, amount: 0.8 }}
            transition={{ duration: 0.5 }}
            className="flex items-center gap-2"
          >
            <motion.div
              animate={{ rotate: [0, 6, -6, 0] }}
              transition={{ duration: 5, repeat: Infinity, ease: 'easeInOut' }}
            >
              <MathoraMark className="w-5 h-5 text-amber-500" />
            </motion.div>
            <span className="font-display font-bold text-slate-900 dark:text-white">Mathora WAEC Learning System</span>
          </motion.div>
          <p>© 2026 Mathora. Built for Nigerian Secondary School Mathematics & Further Mathematics Mastery.</p>
        </div>
      </footer>
    </div>
  );
}
