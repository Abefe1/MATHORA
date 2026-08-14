export interface WorkedExample {
  title: string;
  problem_statement: string;
  solution_steps: string[];
  exam_shortcut?: string;
  common_trap_warning?: string;
}

export interface Lesson {
  id: string;
  topic_id: string;
  title: string;
  summary: string;
  content_body: string;
  order_index: number;
  worked_examples: WorkedExample[];
}

export interface QuestionOption {
  letter: string;
  text: string;
  is_correct: boolean;
}

export interface Question {
  id: string;
  topic_id: string;
  question_text: string;
  difficulty: number; // 1: Easy, 2: Medium, 3: Hard
  exam_type: 'WAEC' | 'BECE' | 'JAMB';
  explanation: string;
  exam_shortcut: string;
  misconception_warning?: string;
  options: QuestionOption[];
}

export interface Topic {
  id: string;
  title: string;
  class_level: 'SS1' | 'SS2' | 'SS3' | 'JSS3';
  description: string;
  order_index: number;
  icon: string;
  mastery_percentage: number;
  status: 'Mastered' | 'In Progress' | 'Needs Review' | 'Not Started';
  lessons: Lesson[];
  questions: Question[];
}

export interface StudySquad {
  id: string;
  name: string;
  code: string;
  exam_focus: string;
  member_count: number;
  weekly_goal_questions: number;
  weekly_progress_questions: number;
  rank_position: number;
  leader_name: string;
  top_members: { name: string; score: number; avatar: string }[];
  recent_announcement: string;
}

export interface MockExam {
  id: string;
  title: string;
  exam_type: 'WAEC' | 'BECE';
  duration_minutes: number;
  total_questions: number;
  description: string;
  questions: Question[];
}

export interface MisconceptionAnalysis {
  id: string;
  topic_title: string;
  misconception_title: string;
  error_pattern: string;
  correct_rule: string;
  prerequisite_gap: string;
  triggered_count: number;
  recommended_lesson_id: string;
}

// Global static dataset for Mathora Mobile
export const TOPICS_DATA: Topic[] = [
  {
    id: 't-quadratics',
    title: 'Quadratic Equations & Rescue Methods',
    class_level: 'SS2',
    description: 'Decomposition, factorization, completing the square, quadratic formula & WAEC traps.',
    order_index: 1,
    icon: 'calculator',
    mastery_percentage: 65,
    status: 'In Progress',
    lessons: [
      {
        id: 'l-quad-1',
        topic_id: 't-quadratics',
        title: 'Solving Quadratic Equations by Factorization',
        summary: 'Mastering the decomposition method and identifying factors of ac that sum to b.',
        content_body: `### Understanding Quadratic Equations

A quadratic equation is of the form:
ax² + bx + c = 0 (where a ≠ 0)

#### Step-by-Step Factorization Method:
1. Multiply a and c to get ac.
2. Find two factors p and q such that p × q = ac and p + q = b.
3. Rewrite the middle term bx as px + qx.
4. Factor by grouping terms in pairs.

#### Worked Example:
Solve 3x² - 7x + 2 = 0.
• ac = 3 × 2 = 6
• Factors of 6 summing to -7 are -6 and -1.
• 3x² - 6x - x + 2 = 0 ⟹ 3x(x - 2) - 1(x - 2) = 0 ⟹ (3x - 1)(x - 2) = 0.
• x = 1/3 or x = 2.`,
        order_index: 1,
        worked_examples: [
          {
            title: 'WAEC 2023 Standard Quadratic Question',
            problem_statement: 'Solve for x: 2x² + 5x - 3 = 0',
            solution_steps: [
              'Find factors of ac = 2 × (-3) = -6 that sum to b = 5. The factors are +6 and -1.',
              'Rewrite equation: 2x² + 6x - x - 3 = 0',
              'Factor by grouping: 2x(x + 3) - 1(x + 3) = 0',
              'Combined factors: (2x - 1)(x + 3) = 0',
              'Solve for roots: x = 1/2 or x = -3'
            ],
            exam_shortcut: 'WAEC MCQ Shortcut: For ax² + bx + c = 0, sum of roots = -b/a = -5/2, product = c/a = -3/2. Test options rapidly!',
            common_trap_warning: 'Watch your signs! (+6) + (-1) = 5, but (-6) + 1 = -5. Do not swap signs.'
          }
        ]
      },
      {
        id: 'l-quad-2',
        topic_id: 't-quadratics',
        title: 'Completing the Square & Discriminant',
        summary: 'Deriving quadratic roots and using b² - 4ac to check root nature.',
        content_body: `### The Discriminant Δ = b² - 4ac
• If Δ > 0: Two distinct real roots
• If Δ = 0: Two equal real roots (perfect square)
• If Δ < 0: Complex / no real roots`,
        order_index: 2,
        worked_examples: [
          {
            title: 'WAEC Discriminant Condition',
            problem_statement: 'Find the value of k if 4x² + kx + 9 = 0 has equal roots.',
            solution_steps: [
              'For equal roots, Discriminant b² - 4ac = 0',
              'Here a = 4, b = k, c = 9',
              'k² - 4(4)(9) = 0 ⟹ k² - 144 = 0',
              'k² = 144 ⟹ k = ±12'
            ],
            exam_shortcut: 'Remember k can be positive OR negative! k = ±12.',
            common_trap_warning: 'Forgetting the negative square root option (e.g. choosing only +12).'
          }
        ]
      }
    ],
    questions: [
      {
        id: 'q-quad-1',
        topic_id: 't-quadratics',
        question_text: 'Solve for x: 3x² - 7x + 2 = 0',
        difficulty: 2,
        exam_type: 'WAEC',
        explanation: 'Factor 3x² - 7x + 2 into (3x - 1)(x - 2) = 0. Roots are x = 1/3 or x = 2.',
        exam_shortcut: 'Product of roots = c/a = 2/3. Test option values: (1/3) × 2 = 2/3!',
        misconception_warning: 'Check negative signs when grouping: (-6x - x = -7x).',
        options: [
          { letter: 'A', text: 'x = 1/3 or x = 2', is_correct: true },
          { letter: 'B', text: 'x = -1/3 or x = -2', is_correct: false },
          { letter: 'C', text: 'x = 3 or x = 1/2', is_correct: false },
          { letter: 'D', text: 'x = -3 or x = 2', is_correct: false }
        ]
      },
      {
        id: 'q-quad-2',
        topic_id: 't-quadratics',
        question_text: 'Find the roots of x² - 9x + 20 = 0',
        difficulty: 1,
        exam_type: 'BECE',
        explanation: 'Factors of 20 summing to -9 are -4 and -5. (x - 4)(x - 5) = 0 ⟹ x = 4 or x = 5.',
        exam_shortcut: 'Both constant and middle signs indicate two positive roots (+4, +5).',
        options: [
          { letter: 'A', text: 'x = -4 or x = -5', is_correct: false },
          { letter: 'B', text: 'x = 4 or x = 5', is_correct: true },
          { letter: 'C', text: 'x = 2 or x = 10', is_correct: false },
          { letter: 'D', text: 'x = 1 or x = 20', is_correct: false }
        ]
      }
    ]
  },
  {
    id: 't-trigonometry',
    title: 'Trigonometric Ratios & Elevation/Depression',
    class_level: 'SS2',
    description: 'SOH CAH TOA, special angles (30°, 45°, 60°), and heights/distances.',
    order_index: 2,
    icon: 'triangle',
    mastery_percentage: 40,
    status: 'Needs Review',
    lessons: [
      {
        id: 'l-trig-1',
        topic_id: 't-trigonometry',
        title: 'Right-Angled Triangle Ratios (SOH CAH TOA)',
        summary: 'Defining sine, cosine, and tangent ratios in right triangles.',
        content_body: `### Basic Ratios
• sin θ = Opposite / Hypotenuse
• cos θ = Adjacent / Hypotenuse
• tan θ = Opposite / Adjacent

#### Special Exact Angles:
• sin 30° = 1/2, cos 30° = √3/2, tan 30° = 1/√3
• sin 45° = 1/√2, cos 45° = 1/√2, tan 45° = 1
• sin 60° = √3/2, cos 60° = 1/2, tan 60° = √3`,
        order_index: 1,
        worked_examples: [
          {
            title: 'WAEC Elevation Problem',
            problem_statement: 'A man standing 20 m from a vertical pole observes the top at an angle of elevation of 30°. Find the height.',
            solution_steps: [
              'Adjacent side = 20 m, Angle θ = 30°',
              'tan 30° = Height / 20',
              '1/√3 = Height / 20 ⟹ Height = 20 / √3 = (20√3)/3 ≈ 11.55 m'
            ],
            exam_shortcut: 'Memorize exact ratios: tan 30° = 1/√3, tan 45° = 1, tan 60° = √3.',
            common_trap_warning: 'Angle of elevation is always measured UP from horizontal, never vertical!'
          }
        ]
      }
    ],
    questions: [
      {
        id: 'q-trig-1',
        topic_id: 't-trigonometry',
        question_text: 'If tan θ = 3/4 in a right triangle, what is sin θ?',
        difficulty: 2,
        exam_type: 'WAEC',
        explanation: 'Opposite = 3, Adjacent = 4. By Pythagoras, Hypotenuse = √(3² + 4²) = 5. sin θ = Opp/Hyp = 3/5.',
        exam_shortcut: 'Classic 3-4-5 Pythagorean triple! Opposite=3, Hypotenuse=5, so sin θ = 3/5 immediately.',
        options: [
          { letter: 'A', text: '3/5', is_correct: true },
          { letter: 'B', text: '4/5', is_correct: false },
          { letter: 'C', text: '5/3', is_correct: false },
          { letter: 'D', text: '3/4', is_correct: false }
        ]
      }
    ]
  },
  {
    id: 't-logarithms',
    title: 'Logarithms & Indices Laws',
    class_level: 'SS1',
    description: 'Laws of indices, log expansion, change of base, and WAEC exam problems.',
    order_index: 3,
    icon: 'book-open',
    mastery_percentage: 85,
    status: 'Mastered',
    lessons: [
      {
        id: 'l-log-1',
        topic_id: 't-logarithms',
        title: 'Core Laws of Logarithms & Indices',
        summary: 'Product law, quotient law, power law, and change of base.',
        content_body: `### Core Logarithm Laws:
1. log_b(x × y) = log_b(x) + log_b(y)
2. log_b(x / y) = log_b(x) - log_b(y)
3. log_b(x^k) = k × log_b(x)
4. log_b(1) = 0, log_b(b) = 1`,
        order_index: 1,
        worked_examples: [
          {
            title: 'WAEC 2022 Logarithmic Simplification',
            problem_statement: 'Simplify log₁₀ 25 + log₁₀ 4 - log₁₀ 2',
            solution_steps: [
              'Combine addition: log₁₀ (25 × 4) = log₁₀ 100',
              'Subtract log: log₁₀ (100 / 2) = log₁₀ 50',
              'Or: log₁₀ 100 - log₁₀ 2 = 2 - 0.3010 = 1.699'
            ],
            exam_shortcut: 'log₁₀ 25 + log₁₀ 4 = log₁₀ (25 × 4) = log₁₀ 100 = 2 instantly!',
            common_trap_warning: 'Do not confuse log(x + y) with log(x) + log(y).'
          }
        ]
      }
    ],
    questions: [
      {
        id: 'q-log-1',
        topic_id: 't-logarithms',
        question_text: 'Evaluate log₂ 32',
        difficulty: 1,
        exam_type: 'BECE',
        explanation: '32 = 2⁵. Thus log₂ (2⁵) = 5 × log₂ 2 = 5.',
        exam_shortcut: 'Count powers of 2: 2, 4, 8, 16, 32 (5th power). Answer is 5.',
        options: [
          { letter: 'A', text: '4', is_correct: false },
          { letter: 'B', text: '5', is_correct: true },
          { letter: 'C', text: '16', is_correct: false },
          { letter: 'D', text: '32', is_correct: false }
        ]
      }
    ]
  },
  {
    id: 't-algebra-exp',
    title: 'Algebraic Expansions & Factorization',
    class_level: 'SS1',
    description: 'Expanding brackets, difference of two squares, and algebraic fractions.',
    order_index: 4,
    icon: 'layers',
    mastery_percentage: 92,
    status: 'Mastered',
    lessons: [],
    questions: []
  }
];

export const STUDY_SQUADS_DATA: StudySquad[] = [
  {
    id: 'squad-1',
    name: 'WAEC SS3 Excellence Warriors',
    code: 'WARRIOR-2026',
    exam_focus: 'WAEC SSCE 2026',
    member_count: 18,
    weekly_goal_questions: 500,
    weekly_progress_questions: 385,
    rank_position: 1,
    leader_name: 'Chidiebere O.',
    top_members: [
      { name: 'Chidiebere O.', score: 142, avatar: '🥇' },
      { name: 'Amina Y.', score: 118, avatar: '🥈' },
      { name: 'Emeka K.', score: 95, avatar: '🥉' }
    ],
    recent_announcement: '🔥 Friday Quiz Marathon starts 6 PM! Target: 100% mastery on Quadratic Shortcuts.'
  },
  {
    id: 'squad-2',
    name: 'Ikeja Math Masters',
    code: 'IKEJA-MATH',
    exam_focus: 'WAEC & JAMB UTME',
    member_count: 12,
    weekly_goal_questions: 350,
    weekly_progress_questions: 210,
    rank_position: 2,
    leader_name: 'Folake B.',
    top_members: [
      { name: 'Folake B.', score: 98, avatar: '🥇' },
      { name: 'Tunde A.', score: 84, avatar: '🥈' },
      { name: 'Blessing M.', score: 76, avatar: '🥉' }
    ],
    recent_announcement: 'Reviewing Trigonometry Elevation & Depression past questions this weekend.'
  }
];

export const MOCK_EXAMS_DATA: MockExam[] = [
  {
    id: 'mock-waec-1',
    title: 'WAEC SSCE Mathematics Paper 1 (MCQ)',
    exam_type: 'WAEC',
    duration_minutes: 30,
    total_questions: 10,
    description: 'Comprehensive 10-question timed WAEC simulation covering Quadratics, Trig, Logarithms & Algebra.',
    questions: [
      {
        id: 'mq-1',
        topic_id: 't-quadratics',
        question_text: 'Solve 3x² - 7x + 2 = 0',
        difficulty: 2,
        exam_type: 'WAEC',
        explanation: 'Roots are x = 1/3 or x = 2.',
        exam_shortcut: 'Product of roots = 2/3.',
        options: [
          { letter: 'A', text: 'x = 1/3 or x = 2', is_correct: true },
          { letter: 'B', text: 'x = -1/3 or x = -2', is_correct: false },
          { letter: 'C', text: 'x = 3 or x = 1/2', is_correct: false },
          { letter: 'D', text: 'x = -3 or x = 2', is_correct: false }
        ]
      },
      {
        id: 'mq-2',
        topic_id: 't-trigonometry',
        question_text: 'If tan θ = 3/4, find sin θ.',
        difficulty: 2,
        exam_type: 'WAEC',
        explanation: '3-4-5 right triangle. Opp = 3, Hyp = 5, sin θ = 3/5.',
        exam_shortcut: '3-4-5 Pythagorean triple.',
        options: [
          { letter: 'A', text: '3/5', is_correct: true },
          { letter: 'B', text: '4/5', is_correct: false },
          { letter: 'C', text: '5/3', is_correct: false },
          { letter: 'D', text: '3/4', is_correct: false }
        ]
      },
      {
        id: 'mq-3',
        topic_id: 't-logarithms',
        question_text: 'Evaluate log₂ 32',
        difficulty: 1,
        exam_type: 'WAEC',
        explanation: '32 = 2⁵. log₂ 2⁵ = 5.',
        exam_shortcut: '2⁵ = 32.',
        options: [
          { letter: 'A', text: '4', is_correct: false },
          { letter: 'B', text: '5', is_correct: true },
          { letter: 'C', text: '16', is_correct: false },
          { letter: 'D', text: '32', is_correct: false }
        ]
      }
    ]
  }
];

export const MISCONCEPTIONS_DATA: MisconceptionAnalysis[] = [
  {
    id: 'misc-1',
    topic_title: 'Quadratic Factorization',
    misconception_title: 'Negative Sign Distribution Error',
    error_pattern: 'Expanding -6x - x as -6x + x or getting sign errors in factor pairs.',
    correct_rule: 'Remember (-6) × (-1) = +6 while (-6) + (-1) = -7. Keep negative factors intact.',
    prerequisite_gap: 'Directed Numbers & Negative Integer Multiplication (JSS3)',
    triggered_count: 3,
    recommended_lesson_id: 'l-quad-1'
  },
  {
    id: 'misc-2',
    topic_title: 'Trigonometric Elevation',
    misconception_title: 'Angle Reference Baseline Trap',
    error_pattern: 'Measuring angle of elevation from vertical wall instead of horizontal ground line.',
    correct_rule: 'Angle of elevation is always measured UP from the horizontal line of sight.',
    prerequisite_gap: 'Parallel Lines & Alternate Angles (SS1)',
    triggered_count: 2,
    recommended_lesson_id: 'l-trig-1'
  }
];
