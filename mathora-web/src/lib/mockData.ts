import { Topic, TopicMastery } from './types';

export const INITIAL_TOPICS: Topic[] = [
  {
    id: 't-quadratics',
    title: 'Quadratic Equations & Rescue Methods',
    class_level: 'SS2',
    description: 'Decomposition, factorization, completing the square, quadratic formula & WAEC traps.',
    order_index: 1,
    icon: 'Calculator',
    lessons: [
      {
        id: 'l-quad-1',
        topic_id: 't-quadratics',
        title: 'Solving Quadratic Equations by Factorization',
        summary: 'Mastering the decomposition method and identifying factors of ac that sum to b.',
        content_body: `### Understanding Quadratic Equations

A quadratic equation is an equation of the form:

$$a x^2 + b x + c = 0$$

where $a \\neq 0$.

#### Step-by-Step Factorization Method:
1. Multiply $a$ and $c$ to find $ac$.
2. Find two factors $p$ and $q$ such that $p \\times q = ac$ and $p + q = b$.
3. Rewrite the middle term $bx$ as $px + qx$.
4. Factor by grouping terms in pairs.

#### Example:
Solve $3x^2 - 7x + 2 = 0$.
- $ac = 3 \\times 2 = 6$
- Factors of $6$ that sum to $-7$ are $-6$ and $-1$.
- $3x^2 - 6x - x + 2 = 0 \\implies 3x(x - 2) - 1(x - 2) = 0 \\implies (3x - 1)(x - 2) = 0$.
- $x = \\frac{1}{3}$ or $x = 2$.`,
        order_index: 1,
        worked_examples: [
          {
            title: 'WAEC 2023 Standard Quadratic Question',
            problem_statement: 'Solve for $x$: $2x^2 + 5x - 3 = 0$',
            solution_steps: [
              'Find factors of $ac = 2 \\times (-3) = -6$ that sum to $b = 5$. The factors are $6$ and $-1$.',
              'Rewrite equation: $2x^2 + 6x - x - 3 = 0$',
              'Factor by grouping: $2x(x + 3) - 1(x + 3) = 0$',
              'Combined factors: $(2x - 1)(x + 3) = 0$',
              'Solve for roots: $x = \\frac{1}{2}$ or $x = -3$'
            ],
            exam_shortcut: 'WAEC MCQ Shortcut: For $ax^2 + bx + c = 0$, the sum of roots is $-\\frac{b}{a} = -\\frac{5}{2}$ and product is $\\frac{c}{a} = -\\frac{3}{2}$. Test option values rapidly!',
            common_trap_warning: 'Watch your signs! Adding $6 + (-1) = 5$, but $(-6) + 1 = -5$. Don\'t swap signs.'
          }
        ]
      }
    ],
    questions: [
      {
        id: 'q-quad-1',
        topic_id: 't-quadratics',
        question_text: 'Solve for $x$: $3x^2 - 7x + 2 = 0$',
        difficulty: 2,
        exam_type: 'WAEC',
        explanation: 'Factor $3x^2 - 7x + 2 = 0$ into $(3x - 1)(x - 2) = 0$. Roots are $x = \\frac{1}{3}$ or $x = 2$.',
        exam_shortcut: 'Sum of roots is $\\frac{7}{3}$, product is $\\frac{2}{3}$. Test options using product of roots.',
        options: [
          { letter: 'A', text: '$x = 2$ or $x = \\frac{1}{3}$', is_correct: true },
          { letter: 'B', text: '$x = -2$ or $x = -\\frac{1}{3}$', is_correct: false },
          { letter: 'C', text: '$x = 2$ or $x = -\\frac{1}{3}$', is_correct: false },
          { letter: 'D', text: '$x = 3$ or $x = \\frac{1}{2}$', is_correct: false }
        ]
      },
      {
        id: 'q-quad-2',
        topic_id: 't-quadratics',
        question_text: 'Find the roots of the equation $x^2 - 9x + 20 = 0$',
        difficulty: 1,
        exam_type: 'BECE',
        explanation: 'Find two numbers whose product is 20 and sum is -9: $-4$ and $-5$. Thus $(x - 4)(x - 5) = 0 \\implies x = 4$ or $x = 5$.',
        exam_shortcut: 'Both signs in factors are negative, so both roots must be positive (+4, +5).',
        options: [
          { letter: 'A', text: '$x = -4$ or $x = -5$', is_correct: false },
          { letter: 'B', text: '$x = 4$ or $x = 5$', is_correct: true },
          { letter: 'C', text: '$x = 2$ or $x = 10$', is_correct: false },
          { letter: 'D', text: '$x = 1$ or $x = 20$', is_correct: false }
        ]
      }
    ]
  },
  {
    id: 't-trigonometry',
    title: 'Trigonometric Ratios & Elevation/Depression',
    class_level: 'SS2',
    description: 'SOH CAH TOA, special angles ($30^\\circ, 45^\\circ, 60^\\circ$), and heights/distances.',
    order_index: 2,
    icon: 'Triangle',
    lessons: [
      {
        id: 'l-trig-1',
        topic_id: 't-trigonometry',
        title: 'Right-Angled Triangle Ratios (SOH CAH TOA)',
        summary: 'Defining sine, cosine, and tangent ratios in right triangles.',
        content_body: `### Basic Trigonometric Ratios

For a right-angled triangle with angle $\\theta$:

- **Sine**: $\\sin \\theta = \\frac{\\text{Opposite}}{\\text{Hypotenuse}}$
- **Cosine**: $\\cos \\theta = \\frac{\\text{Adjacent}}{\\text{Hypotenuse}}$
- **Tangent**: $\\tan \\theta = \\frac{\\text{Opposite}}{\\text{Adjacent}}$

#### Pythagorean Identity:
$$\\sin^2 \\theta + \\cos^2 \\theta = 1$$`,
        order_index: 1,
        worked_examples: [
          {
            title: 'WAEC Angle of Elevation Problem',
            problem_statement: 'A man standing $20\\text{ m}$ from the base of a vertical pole observes the top at an angle of elevation of $30^\\circ$. Find the height of the pole.',
            solution_steps: [
              'Identify given values: Adjacent side = $20\\text{ m}$, Angle $\\theta = 30^\\circ$',
              'Formulate ratio: $\\tan 30^\\circ = \\frac{\\text{Height}}{20}$',
              'Substitute exact value: $\\tan 30^\\circ = \\frac{1}{\\sqrt{3}}$',
              'Height $= 20 \\times \\frac{1}{\\sqrt{3}} = \\frac{20\\sqrt{3}}{3} \\approx 11.55\\text{ m}$'
            ],
            exam_shortcut: 'Memorize exact values: $\\tan 30^\\circ = \\frac{1}{\\sqrt{3}}$, $\\tan 45^\\circ = 1$, $\\tan 60^\\circ = \\sqrt{3}$.',
            common_trap_warning: 'Angle of elevation is measured UP from the horizontal line of sight!'
          }
        ]
      }
    ],
    questions: [
      {
        id: 'q-trig-1',
        topic_id: 't-trigonometry',
        question_text: 'If $\\sin \\theta = \\frac{3}{5}$ for an acute angle $\\theta$, calculate $\\cos \\theta$.',
        difficulty: 2,
        exam_type: 'WAEC',
        explanation: 'Using Pythagoras: $\\cos \\theta = \\sqrt{1 - \\sin^2 \\theta} = \\sqrt{1 - \\frac{9}{25}} = \\sqrt{\\frac{16}{25}} = \\frac{4}{5}$.',
        exam_shortcut: '3-4-5 Pythagorean triple! Opposite=3, Hypotenuse=5 -> Adjacent=4 -> cos theta = 4/5.',
        options: [
          { letter: 'A', text: '$\\frac{4}{5}$', is_correct: true },
          { letter: 'B', text: '$\\frac{3}{4}$', is_correct: false },
          { letter: 'C', text: '$\\frac{5}{3}$', is_correct: false },
          { letter: 'D', text: '$\\frac{5}{4}$', is_correct: false }
        ]
      }
    ]
  }
];

export const INITIAL_MASTERY: Record<string, TopicMastery> = {
  't-quadratics': {
    topic_id: 't-quadratics',
    mastery_percentage: 65,
    total_attempted: 10,
    total_correct: 7
  },
  't-trigonometry': {
    topic_id: 't-trigonometry',
    mastery_percentage: 40,
    total_attempted: 5,
    total_correct: 2
  }
};
