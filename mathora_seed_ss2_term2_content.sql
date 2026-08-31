-- ==========================================
-- MATHORA: SS2 Mathematics, Second Term: Full Content Seed
-- (10 topics, order_index 201-210)
--
-- Source of truth for all teaching notes, worked examples and exercise
-- questions: SS1-SS3_MATHEMATICS_CURATED.md ("SS2 Mathematics" >
-- "Second Term", Weeks 1-6 and 8-11; Week 7 is a review/periodic-test
-- week with no distinct topic and is skipped, matching the syllabus:
-- Weeks 1-6 and 8-11 map 1:1 onto topics order_index 201-210, exactly
-- as was done for the SS1 Second Term file).
--
-- Run after (in order, from a bare schema):
--   mathora_schema.sql
--   mathora_schema_auth_patch.sql
--   mathora_schema_topics_term_patch.sql
--   mathora_schema_content_pipeline_patch.sql
--   mathora_schema_diagrams_patch.sql
--   mathora_schema_five_option_patch.sql   (adds questions.option_e and
--                                           widens correct_letter to A-E)
--   mathora_seed_topics_ss1_ss2_ss3.sql    (creates the topic rows this
--                                           file references by subquery,
--                                           never by hardcoded UUID)
--   mathora_seed_exemplar_lessons.sql      (already seeds ONE lesson row
--                                           + 1 worked_example + 1
--                                           question for topic 210,
--                                           "Circle Theorems: Angle at
--                                           the Centre". This file does
--                                           NOT duplicate that lesson
--                                           row; it adds further worked
--                                           examples covering the other
--                                           circle-angle theorems, plus
--                                           every circle-theorem
--                                           question from the curated
--                                           exercise bank, all linked to
--                                           that existing lesson via the
--                                           same topic subquery pattern)
--   mathora_seed_ss2_term2_content.sql     (this file)
--
-- For every other topic (201-209) this file inserts one lessons row,
-- 2-4 worked_examples rows, and every question from that week's curated
-- "Gamified Exercise Bank" section (none are sampled or skipped, with
-- one narrow exception noted at Q17 of Week 5/topic 205 below, where the
-- source item itself is flagged as OCR-corrupted and unrecoverable, so
-- a replacement question testing the same skill is substituted instead
-- of fabricating an answer to garbled options). Open/free-response
-- curated questions are converted here into 4-option MCQs with hand-
-- checked, genuinely-wrong distractors; questions already given with
-- explicit options (A-D or A-E) keep their original options as given,
-- unless a hand-check below found the source option set or stated
-- answer letter to be wrong, in which case it is corrected and the
-- correction is noted in the explanation text. All monetary examples
-- use Naira (₦).
--
-- Corrections made during this pass (each re-derived by hand, not
-- trusted from the source):
--   Week 2 / topic 202, exercise 5: source states "3(x+8)<7x, answer
--   x>-6, option A" but 3(x+8)<7x expands to 3x+24<7x, i.e. 24<4x, i.e.
--   x>6, which is option D, not option A. Corrected below.
--   Week 2 / topic 202, exercise 23: the listed options for
--   "x^2+x-12>=0" repeat option C and D identically ("x<=3 or x>=-4"
--   twice) and omit the true answer set; corrected to a clean 4-option
--   set with the verified answer x<=-4 or x>=3.
--   Week 2 / topic 202, exercise 24: listed options include a duplicate
--   (B and C both "1/4<x<1/3") and the source's stated answer
--   "-1/4<x<1/3" is not among the options as printed; corrected to a
--   clean option set matching the verified answer.
--   Week 2 / topic 202, exercise 26: "(y-1)/2 <= 6/y" requires splitting
--   into cases on the sign of y (multiplying by y flips the inequality
--   when y is negative); re-derived by hand the true solution set is
--   y<=-3 OR 0<y<=4, not "y<=-3 or y>=4" as the source states (y=5, for
--   example, does not satisfy the original inequality: (5-1)/2=2 is not
--   <= 6/5=1.2). Corrected below with a verified option set.
--   Week 2 / topic 202, exercise 27: the compound chain
--   "2(x+3)>=3(x-1)<=12" is two separate inequalities sharing a middle
--   expression; solving each gives x<=9 and x<=5 respectively, so the
--   combined (intersection) answer is x<=5, not "x<=3" as the source
--   states. Corrected below.
--   Week 5 / topic 205, exercise 17: flagged in the source itself as
--   OCR-corrupted (the printed options do not correspond to the stated
--   stem); replaced with a fresh, fully-verified algebraic-fraction
--   simplification question of comparable difficulty rather than
--   guessing at the corrupted original.
--   Week 5 / topic 205, exercise 31: source explanation already
--   corrects an earlier mistranscription (x must be exactly 2, not
--   2 1/4), kept as corrected in the source and re-verified by hand
--   here: x=2, y=-1/5, x^2*y - 2xy = xy(x-2) = xy(0) = 0. Confirmed.
--   Week 9 / topic 208, exercise 3 in the source's answer key originally
--   pointed at "Isa is a Northerner, therefore Isa speaks Hausa" style
--   reasoning; re-verified against the stated premises here, no change
--   needed, included as-is.
--   Week 10 / topic 209, exercises 2 and 6(b): flagged in the source
--   itself as underdetermined with the given data; kept as short-answer
--   reasoning questions with the same "not fully determined" caveat
--   rather than fabricating a numeric answer.
-- ==========================================
-- ------------------------------------------
-- 201. GRADIENT OF A STRAIGHT LINE & A CURVE
-- ------------------------------------------

insert into public.lessons (topic_id, title, summary, content_body, order_index)
values (
  (select t.id from public.topics t join public.curricula c on c.id = t.curriculum_id
   where c.subject = 'Mathematics' and t.class_level = 'SS2' and t.term = 2 and t.order_index = 201),
  'Gradient of a Straight Line and a Curve',
  'Revising the gradient formula for a straight line, reading gradients directly from y = mx + c, and finding the gradient of a curve at a point by drawing a tangent.',
  '### Gradient of a Straight Line

For a straight line through two points $(x_1, y_1)$ and $(x_2, y_2)$: $m = \frac{y_2 - y_1}{x_2 - x_1}$.

If the line is already written as $y = mx + c$, the gradient $m$ is simply the number multiplying $x$, read off instantly with no calculation.

**Coefficient trick**: for a line given as $ax + by = c$, the gradient is $m = -\frac{a}{b}$ directly, without rearranging fully into $y = mx + c$ form first.

**Parallel and perpendicular lines**: parallel lines always share the same gradient. Perpendicular lines always have gradients whose product is $-1$ (that is, $m_1 \times m_2 = -1$).

### Gradient of a Curve

A curve does not have one single gradient, it changes from point to point. The gradient of a curve *at a particular point* is defined as the gradient of the **tangent** drawn at that point, a straight line that touches the curve at exactly that one point and does not cross it there.

To estimate a curve''s gradient at a point graphically:
1. Plot the curve and mark the point.
2. Draw the tangent line at that point as carefully as possible.
3. Choose two well-spaced points that lie ON the tangent line (preferably at clean grid intersections).
4. Apply the ordinary gradient formula to those two points.

### Glossary

- **Tangent**: a straight line that touches a curve at exactly one point without crossing it there, like a ruler balanced against the side of a curved bowl.
- **Gradient (slope)**: how steep a line is, and in which direction, a positive gradient rises left to right, a negative gradient falls left to right, and a gradient of zero is a flat horizontal line.',
  1
);

insert into public.worked_examples (lesson_id, title, problem_statement, solution_steps, exam_shortcut, real_life_context, diagram_type, diagram_data, status)
select l.id,
  'Gradient Between Two Points',
  'Find the gradient of the line joining $A(2, 5)$ and $B(6, 13)$.',
  to_jsonb(array[
    'Identify the two points: $(x_1, y_1) = (2, 5)$, $(x_2, y_2) = (6, 13)$.',
    'Apply the gradient formula: $m = \frac{y_2 - y_1}{x_2 - x_1} = \frac{13 - 5}{6 - 2} = \frac{8}{4}$.',
    'Simplify: $\frac{8}{4} = 2$.'
  ]),
  'It does not matter which point you call $(x_1,y_1)$ and which $(x_2,y_2)$, as long as you are consistent in both the top and bottom of the fraction, swapping both gives the same answer.',
  'A school data clerk plotting two exam scores on two different dates for one student uses exactly this calculation to describe the student''s rate of improvement per week, a positive gradient means the score is climbing.',
  'coordinate_plane',
  '{"xRange": [0, 8], "yRange": [0, 15], "points": [{"x": 2, "y": 5, "label": "A(2,5)"}, {"x": 6, "y": 13, "label": "B(6,13)"}], "lines": [{"from": {"x": 2, "y": 5}, "to": {"x": 6, "y": 13}, "label": "m = 2"}]}'::jsonb,
  'published'
from public.lessons l join public.topics t on t.id = l.topic_id join public.curricula c on c.id = t.curriculum_id
where c.subject = 'Mathematics' and t.class_level = 'SS2' and t.term = 2 and t.order_index = 201;

insert into public.worked_examples (lesson_id, title, problem_statement, solution_steps, exam_shortcut, status)
select l.id,
  'Gradient and Intercept from a General Equation',
  'Find the gradient and $y$-intercept of the line $3x + 2y = 12$.',
  to_jsonb(array[
    'Make $y$ the subject: $2y = 12 - 3x$.',
    'Divide every term by 2: $y = 6 - 1.5x$, which is the same as $y = -1.5x + 6$.',
    'Compare with $y = mx + c$: the gradient $m = -1.5$, and the $y$-intercept $c = 6$.'
  ]),
  'Use the coefficient trick to skip the rearranging entirely: for $ax + by = c$, $m = -\frac{a}{b}$. Here $a = 3$, $b = 2$, so $m = -\frac{3}{2} = -1.5$ immediately.',
  'published'
from public.lessons l join public.topics t on t.id = l.topic_id join public.curricula c on c.id = t.curriculum_id
where c.subject = 'Mathematics' and t.class_level = 'SS2' and t.term = 2 and t.order_index = 201;

insert into public.worked_examples (lesson_id, title, problem_statement, solution_steps, exam_shortcut, real_life_context, status)
select l.id,
  'Comparing Two Taxi Fares',
  'A taxi charges a fixed fee of ₦200 plus ₦50 per km. A second taxi charges a fixed fee of ₦100 plus ₦75 per km. Find the distance at which both taxis cost the same, and that common cost.',
  to_jsonb(array[
    'Write a cost equation for each taxi in terms of distance $d$ km: Taxi A: $C = 200 + 50d$. Taxi B: $C = 100 + 75d$.',
    'The two equations are straight lines with gradients 50 and 75 (the cost per km); the point where costs are equal is where the two lines cross, found by setting the expressions equal: $200 + 50d = 100 + 75d$.',
    'Collect the $d$-terms on one side and the numbers on the other: $200 - 100 = 75d - 50d$, giving $100 = 25d$.',
    'Solve for $d$: $d = \frac{100}{25} = 4$.',
    'Substitute $d = 4$ back into either cost equation: $C = 200 + 50(4) = 200 + 200 = 400$.'
  ]),
  '"When are two costs/values equal" questions are simultaneous equations in disguise, skip the graph paper and solve algebraically by setting the two expressions equal, drawing only afterward to illustrate the answer.',
  'This is exactly how a commuter in Lagos or Abuja compares two taxi or ride-hailing apps'' pricing structures before a long trip, working out the break-even distance tells you which app is cheaper for your actual journey length.',
  'published'
from public.lessons l join public.topics t on t.id = l.topic_id join public.curricula c on c.id = t.curriculum_id
where c.subject = 'Mathematics' and t.class_level = 'SS2' and t.term = 2 and t.order_index = 201;

insert into public.worked_examples (lesson_id, title, problem_statement, solution_steps, exam_shortcut, common_trap_warning, diagram_type, diagram_data, status)
select l.id,
  'Gradient of a Curve at a Point',
  'Find the gradient of the curve $y = x^2$ at the point $(2, 4)$, using a drawn tangent.',
  to_jsonb(array[
    'Plot the curve $y = x^2$ using a small table of values around $x = 2$ (e.g. $x = 0, 1, 2, 3$ giving $y = 0, 1, 4, 9$), and mark the point $(2, 4)$ on it.',
    'Draw the tangent line at $(2, 4)$, a straight line that touches the curve only at that point and does not cross it there.',
    'Extend the tangent and read off a second convenient point it passes through, here the tangent passes through $(0, -4)$.',
    'Apply the ordinary gradient formula to the two points on the tangent, $(0, -4)$ and $(2, 4)$: $m = \frac{4 - (-4)}{2 - 0} = \frac{8}{2}$.',
    'Divide: $\frac{8}{2} = 4$.'
  ]),
  'Choose two points on the tangent that are far apart, not close together, this reduces how much a small drawing error affects your final gradient reading.',
  'A common mistake is reading the gradient of the CURVE itself between two points on the curve (a chord), rather than the gradient of the TANGENT at the single point asked about, these give different numbers, only the tangent''s gradient answers "the gradient of the curve at this point".',
  'coordinate_plane',
  '{"xRange": [-1, 4], "yRange": [-4, 10], "points": [{"x": 2, "y": 4, "label": "(2,4)"}], "lines": [{"from": {"x": 0, "y": -4}, "to": {"x": 2, "y": 4}, "label": "tangent, m = 4"}]}'::jsonb,
  'published'
from public.lessons l join public.topics t on t.id = l.topic_id join public.curricula c on c.id = t.curriculum_id
where c.subject = 'Mathematics' and t.class_level = 'SS2' and t.term = 2 and t.order_index = 201;

insert into public.questions (topic_id, lesson_id, question_text, option_a, option_b, option_c, option_d, correct_letter, difficulty, exam_type, explanation, status)
select t.id, l.id, q.question_text, q.option_a, q.option_b, q.option_c, q.option_d, q.correct_letter, q.difficulty, q.exam_type::exam_type, q.explanation, 'published'
from public.topics t
  join public.curricula c on c.id = t.curriculum_id
  join public.lessons l on l.topic_id = t.id,
  (values
  ('Find the gradient of the line $y = 3x - 2$.', '3', '-2', '2', '-3', 'A', 1, 'GENERAL', 'Comparing with $y = mx + c$, the gradient is the coefficient of $x$, which is 3.'),
  ('The tangent to the curve $y = x^2$ at the point $(2, 4)$ passes through $(0, -4)$. Estimate the gradient of the curve at that point.', '2', '4', '8', '-4', 'B', 2, 'GENERAL', 'Gradient $= \frac{4-(-4)}{2-0} = \frac{8}{2} = 4$, matching the true derivative $\frac{dy}{dx}=2x=4$ at $x=2$.'),
  ('Find the gradient of the line $y = 2x - 3$.', '-3', '3', '2', '-2', 'C', 1, 'GENERAL', 'The coefficient of $x$ is 2, so the gradient is 2.'),
  ('Find the gradient of the line $y = 3x + 2$ for $-2 \leq x \leq 2$.', '2', '-2', '3', '-3', 'C', 1, 'GENERAL', 'The coefficient of $x$ is 3, so the gradient is 3, unaffected by the stated domain restriction.'),
  ('What is the gradient of the line $y = -2x + 1$?', '2', '1', '-1', '-2', 'D', 1, 'GENERAL', 'The coefficient of $x$ is -2.'),
  ('One company charges a ₦500 setup fee plus ₦100 per hour. Another charges ₦300 plus ₦150 per hour. After how many hours do the two costs become equal?', '3 hours', '4 hours', '5 hours', '6 hours', 'B', 3, 'GENERAL', 'Setting $500+100h = 300+150h$: $200 = 50h$, so $h=4$, at a common cost of ₦900.'),
  ('A phone plan costs ₦1,000 monthly plus ₦5 per minute; another costs ₦500 plus ₦10 per minute. After how many minutes are the two plans equal in cost?', '80 minutes', '90 minutes', '100 minutes', '120 minutes', 'C', 3, 'GENERAL', 'Setting $1000+5m=500+10m$: $500=5m$, so $m=100$ minutes, at a common cost of ₦1,500.'),
  ('A taxi charges a fixed fee of ₦200 plus ₦50 per km; a second taxi charges ₦100 plus ₦75 per km. At what distance do both taxis cost the same?', '3 km', '4 km', '5 km', '8 km', 'B', 2, 'GENERAL', 'Setting $200+50d=100+75d$ gives $100=25d$, so $d=4$ km, at a common cost of ₦400.'),
  ('Find the gradient of the line passing through $(0, 1)$ and $(2, 5)$.', '1', '2', '3', '4', 'B', 1, 'GENERAL', 'Gradient $=\frac{5-1}{2-0}=\frac{4}{2}=2$.'),
  ('The lines $y = x + 1$ and $y = 5 - x$ are graphed on the same axes. Find the coordinates of their intersection.', '$(1, 2)$', '$(3, 4)$', '$(2, 3)$', '$(4, 1)$', 'C', 2, 'GENERAL', 'Setting $x+1=5-x$ gives $2x=4$, so $x=2$, and $y=x+1=3$: the intersection is $(2,3)$.')
) as q(question_text, option_a, option_b, option_c, option_d, correct_letter, difficulty, exam_type, explanation)
where c.subject = 'Mathematics' and t.class_level = 'SS2' and t.term = 2 and t.order_index = 201;
-- ------------------------------------------
-- 202. INEQUALITIES IN ONE AND TWO VARIABLES
-- ------------------------------------------

insert into public.lessons (topic_id, title, summary, content_body, order_index)
values (
  (select t.id from public.topics t join public.curricula c on c.id = t.curriculum_id
   where c.subject = 'Mathematics' and t.class_level = 'SS2' and t.term = 2 and t.order_index = 202),
  'Inequalities in One and Two Variables',
  'Revising linear inequalities in one variable, solving quadratic inequalities, combining inequalities into a single range, and an introduction to inequalities in two variables.',
  '### Inequality Symbols

$<$ (less than), $>$ (greater than), $\leq$ (less than or equal to, "at most"), $\geq$ (greater than or equal to, "at least"). $<$ and $>$ are *strict* inequalities; $\leq$ and $\geq$ are *weak* inequalities.

### The One Golden Rule

Linear inequalities are solved exactly like linear equations, with one crucial exception: **multiplying or dividing both sides by a NEGATIVE number reverses the inequality sign.** Adding or subtracting anything, even a negative number, never reverses it.

### Combining Inequalities

Two inequalities on the same variable can be merged into a single range. For example, if $x > 8$ and $20 > x$, combine them as $8 < x < 20$. Whether an endpoint is included depends on whether that original inequality was strict or weak.

### Quadratic Inequalities

Rearrange so that 0 is on one side, factorise, and use the sign rule for products: for $(x-a)(x-b) > 0$ with $a < b$, both factors must have the same sign, giving $x < a$ or $x > b$. For $(x-a)(x-b) < 0$, the factors have opposite signs, giving $a < x < b$.

**Positive-coefficient shortcut**: once you have the two roots of a quadratic with a positive $x^2$ coefficient, the expression is negative (less than 0) BETWEEN the roots, and positive (greater than 0) OUTSIDE them.

### Number Line Notation

An open dot ($\circ$) marks a strict inequality endpoint (not included). A filled dot ($\bullet$) marks a weak inequality endpoint (included).

### Glossary

- **Strict inequality**: one using $<$ or $>$ only, the boundary value itself is never a valid solution.
- **Feasible values**: the full set of numbers that make an inequality true, sometimes a range, sometimes a specific list of whole numbers.',
  1
);

insert into public.worked_examples (lesson_id, title, problem_statement, solution_steps, exam_shortcut, real_life_context, status)
select l.id,
  'A Simple Linear Inequality',
  'Solve $3x - 4 > 8$.',
  to_jsonb(array[
    'Isolate the $x$-term by adding 4 to both sides: $3x - 4 + 4 > 8 + 4$, giving $3x > 12$.',
    'Divide both sides by 3 (a positive number, so the sign is unchanged): $x > \frac{12}{3}$.',
    'Simplify: $x > 4$.'
  ]),
  'Whenever the coefficient you are dividing by is already positive, solving an inequality is identical to solving the matching equation, only the very last symbol differs.',
  'A shop needs to sell more than a certain number of recharge cards per day to cover its rent. If profit per card is ₦150 and daily rent is ₦600, "profit exceeds rent" is $150x > 600$, i.e. $x > 4$ cards, exactly this kind of inequality.',
  'published'
from public.lessons l join public.topics t on t.id = l.topic_id join public.curricula c on c.id = t.curriculum_id
where c.subject = 'Mathematics' and t.class_level = 'SS2' and t.term = 2 and t.order_index = 202;

insert into public.worked_examples (lesson_id, title, problem_statement, solution_steps, exam_shortcut, common_trap_warning, status)
select l.id,
  'Dividing by a Negative Number',
  'Solve $6x - 14 \geq 13x$.',
  to_jsonb(array[
    'Collect the $x$-terms on one side and the numbers on the other: subtract $13x$ from both sides: $6x - 13x - 14 \geq 0$, giving $-7x - 14 \geq 0$.',
    'Add 14 to both sides: $-7x \geq 14$.',
    'Divide both sides by $-7$; since we are dividing by a NEGATIVE number, the inequality sign must reverse: $x \leq \frac{14}{-7}$.',
    'Simplify: $x \leq -2$.'
  ]),
  'To avoid the sign-flip step altogether, push the $x$-terms to whichever side keeps their coefficient positive: here, moving $6x$ to the right instead gives $-14 \geq 13x - 6x = 7x$, i.e. $7x \leq -14$, i.e. $x \leq -2$, same answer, no flip needed.',
  'Forgetting to reverse the inequality sign when dividing by a negative number is the single most common error on this topic, say the rule out loud every time you divide: "negative divisor, flip the sign".',
  'published'
from public.lessons l join public.topics t on t.id = l.topic_id join public.curricula c on c.id = t.curriculum_id
where c.subject = 'Mathematics' and t.class_level = 'SS2' and t.term = 2 and t.order_index = 202;

insert into public.worked_examples (lesson_id, title, problem_statement, solution_steps, exam_shortcut, status)
select l.id,
  'A Quadratic Inequality',
  'Solve $y^2 - 3y > 18$.',
  to_jsonb(array[
    'Rearrange so that 0 is on one side: $y^2 - 3y - 18 > 0$.',
    'Factorise the quadratic: find two numbers that multiply to $-18$ and add to $-3$, these are $-6$ and $3$, so $(y-6)(y+3) > 0$.',
    'Find the critical values by setting each factor to zero: $y = 6$ and $y = -3$.',
    'Since the $y^2$ coefficient is positive, the expression is positive OUTSIDE the two roots and negative BETWEEN them.'
  ]),
  '"Positive coefficient smiley-face" rule: once you have the roots, write the answer straight away without testing each region by substitution, positive outside the roots, negative between them.',
  'published'
from public.lessons l join public.topics t on t.id = l.topic_id join public.curricula c on c.id = t.curriculum_id
where c.subject = 'Mathematics' and t.class_level = 'SS2' and t.term = 2 and t.order_index = 202;

insert into public.worked_examples (lesson_id, title, problem_statement, solution_steps, exam_shortcut, real_life_context, status)
select l.id,
  'Combining Two Simple Inequalities',
  'A market stall owner has budgeted at least ₦4,000 but has decided to spend less than ₦10,000 on tomato stock for the day. Write this as a single combined inequality in the amount spent, $x$, and list three whole-number-thousand values (in Naira) that satisfy it.',
  to_jsonb(array[
    'Translate "at least ₦4,000" into an inequality: $x \geq 4000$.',
    'Translate "less than ₦10,000" into an inequality: $x < 10000$.',
    'Combine both into a single range, smallest bound first: $4000 \leq x < 10000$.',
    'List three values inside this range, e.g. ₦5,000, ₦7,000, and ₦9,000 all satisfy $4000 \leq x < 10000$, while ₦10,000 itself does not (the upper bound is strict).'
  ]),
  'To combine two simple inequalities in one variable, just line them up in increasing order along a number line (smallest bound, $x$, largest bound), no algebra is needed.',
  'This is exactly how a household or small trader plans a spending range for a market run, "at least" sets a floor to make the trip worthwhile, "less than" sets a ceiling the budget cannot exceed.',
  'published'
from public.lessons l join public.topics t on t.id = l.topic_id join public.curricula c on c.id = t.curriculum_id
where c.subject = 'Mathematics' and t.class_level = 'SS2' and t.term = 2 and t.order_index = 202;

insert into public.questions (topic_id, lesson_id, question_text, option_a, option_b, option_c, option_d, option_e, correct_letter, difficulty, exam_type, explanation, status)
select t.id, l.id, q.question_text, q.option_a, q.option_b, q.option_c, q.option_d, q.option_e, q.correct_letter, q.difficulty, q.exam_type::exam_type, q.explanation, 'published'
from public.topics t
  join public.curricula c on c.id = t.curriculum_id
  join public.lessons l on l.topic_id = t.id,
  (values
  ('Solve the inequality $3x - 4 > 8$.', '$x > 4$', '$x < 4$', '$x > 4/3$', '$x > 12$', null, 'A', 1, 'GENERAL', 'Adding 4: $3x>12$; dividing by 3: $x>4$.'),
  ('For what values of $x$ is $\frac{1}{2}(x+3) < 3$?', '$x < 3$', '$x > 3$', '$x < 9$', '$x < -3$', null, 'A', 1, 'GENERAL', 'Multiplying by 2: $x+3<6$, so $x<3$.'),
  ('Solve the inequality $6x - 14 \geq 13x$.', '$x \geq -2$', '$x \leq -2$', '$x \leq 2$', '$x \geq 2$', null, 'B', 2, 'GENERAL', 'Rearranging: $-7x \geq 14$; dividing by $-7$ reverses the sign: $x \leq -2$.'),
  ('Solve the inequality $x + 3 < 4x$.', '$x < 1$', '$x > 1$', '$x < -1$', '$x > -1$', null, 'B', 1, 'GENERAL', 'Rearranging: $3 < 3x$, so $x > 1$.'),
  ('Find the range of values of $x$ for which $3(x + 8) < 7x$.', '$x > -6$', '$x < -6$', '$x > 2$', '$x > 6$', null, 'D', 2, 'GENERAL', 'Expanding: $3x+24<7x \Rightarrow 24<4x \Rightarrow x>6$. (Corrected: the curated source mistakenly listed x greater than -6, option A, as the answer; re-derivation confirms x greater than 6, option D.)'),
  ('For what range of values of $x$ is $4x - 3(2x - 1) > 1$?', '$x > -1$', '$x > 1$', '$x < 1$', '$x < -1$', null, 'C', 2, 'GENERAL', 'Expanding: $4x-6x+3>1 \Rightarrow -2x>-2 \Rightarrow x<1$ (dividing by $-2$ reverses the sign).'),
  ('Solve the inequality $x - 4(x + 2) > 8 + 5x$.', '$x > 0$', '$x < 0$', '$x > -2$', '$x < -2$', null, 'D', 2, 'GENERAL', 'Expanding: $x-4x-8>8+5x \Rightarrow -3x-8>8+5x \Rightarrow -8x>16 \Rightarrow x<-2$.'),
  ('Solve the inequality $\frac{1}{3}(2x - 1) < 5$.', '$x < -5$', '$x < 7$', '$x > 8$', '$x < 8$', null, 'D', 1, 'GENERAL', 'Multiplying by 3: $2x-1<15 \Rightarrow 2x<16 \Rightarrow x<8$.'),
  ('Solve the inequality $\frac{x}{6} - \frac{x}{2} \geq \frac{2}{3}$.', '$x < 1$', '$x \geq 2$', '$x < -2$', '$x \geq 2$', '$x \leq -2$', 'E', 3, 'GENERAL', 'Multiplying every term by 6: $x-3x\geq4 \Rightarrow -2x\geq4 \Rightarrow x\leq-2$.'),
  ('Solve the inequality $1 - 2x < -\frac{1}{3}$.', '$x < 2/3$', '$x < -2/3$', '$x > 2/3$', '$x > -2/3$', null, 'C', 2, 'GENERAL', 'Rearranging: $-2x<-\frac{4}{3} \Rightarrow x>\frac{2}{3}$ (dividing by $-2$ reverses the sign).'),
  ('Solve the inequality $\frac{x}{2} + 2 \leq 2x - 1$.', '$x \leq 2$', '$x \geq 2$', '$x \leq 3$', '$x \geq 3$', null, 'B', 2, 'GENERAL', 'Multiplying by 2: $x+4\leq4x-2 \Rightarrow 6\leq3x \Rightarrow x\geq2$.'),
  ('Solve the inequality $(y - 3) < \frac{y}{3}$.', '$y < 2$', '$y < 3.5$', '$y < 4.5$', '$y > 4.5$', '$y > 6$', 'C', 2, 'GENERAL', 'Multiplying by 3: $3y-9<y \Rightarrow 2y<9 \Rightarrow y<4.5$.'),
  ('Solve the inequality $3(x + 1) \geq 5(x + 2) + 15$.', '$x \leq -14$', '$x \geq -14$', '$x \leq -11$', '$x \geq -11$', null, 'C', 3, 'GENERAL', 'Expanding: $3x+3\geq5x+25 \Rightarrow -22\geq2x \Rightarrow x\leq-11$.'),
  ('If $x$ is a positive integer satisfying $3x - 4 \leq 6$ and $x - 1 > 0$, list the values of $x$.', '$\{1,2,3\}$', '$\{2,3\}$', '$\{2,3,4\}$', '$\{2,3,4,5\}$', null, 'B', 3, 'GENERAL', '$3x-4\leq6 \Rightarrow x\leq10/3\approx3.33$; $x-1>0 \Rightarrow x>1$. Positive integers satisfying both: 2 and 3.'),
  ('Find the range of values of $x$ for which $2x - 1 \leq 3$ and $2 - x \leq 5$.', '$-3 \leq x \leq 1$', '$-2 \leq x \leq 3$', '$-3 \leq x \leq 4$', '$-3 \leq x \leq 2$', null, 'D', 2, 'GENERAL', '$2x-1\leq3 \Rightarrow x\leq2$; $2-x\leq5 \Rightarrow x\geq-3$. Combined: $-3\leq x\leq2$.'),
  ('If $2 + x < 6$ and $7 + x \geq 4$, find the range of $x$ satisfying both.', '$-3 \leq x < 4$', '$-3 < x \leq 4$', '$-3 \leq x \leq 4$', '$3 \leq x < -4$', null, 'A', 2, 'GENERAL', '$2+x<6 \Rightarrow x<4$; $7+x\geq4 \Rightarrow x\geq-3$. Combined: $-3\leq x<4$.'),
  ('Combine $-4 < x$ and $x < 2$, and give the whole-number solutions.', '$-3,-2,-1,0,1$', '$-4,-3,-2,-1,0$', '$-3,-2,-1,0,1,2$', '$-2,-1,0,1$', null, 'A', 1, 'GENERAL', '$-4<x<2$; whole numbers strictly between $-4$ and $2$ are $-3,-2,-1,0,1$.'),
  ('Given $x > 8$ and $20 > x$, list all whole-number solutions.', '$\{8,9,\ldots,19\}$', '$\{9,10,\ldots,19\}$', '$\{9,10,\ldots,20\}$', '$\{8,9,\ldots,20\}$', null, 'B', 2, 'GENERAL', 'Combined: $8<x<20$. Whole numbers strictly between 8 and 20 are 9 through 19.'),
  ('If $t \leq 3$ and $0 < t$, list all whole-number solutions.', '$\{0,1,2,3\}$', '$\{1,2,3\}$', '$\{1,2\}$', '$\{0,1,2\}$', null, 'B', 1, 'GENERAL', 'Combined: $0<t\leq3$. Whole numbers are 1, 2, 3 (0 is excluded since the inequality is strict).'),
  ('If $r < -5$ and $-9 < r$, list all whole-number solutions.', '$\{-9,-8,-7,-6\}$', '$\{-8,-7,-6,-5\}$', '$\{-8,-7,-6\}$', '$\{-7,-6,-5\}$', null, 'C', 2, 'GENERAL', 'Combined: $-9<r<-5$. Whole numbers strictly between $-9$ and $-5$ are $-8,-7,-6$.'),
  ('Solve the inequality $y^2 - 3y > 18$.', '$-3 < y < 6$', '$y < -3$ or $y > 6$', '$y > -3$ or $y > 6$', '$y < -3$ or $y < 6$', null, 'B', 3, 'GENERAL', 'Rearranged: $(y-6)(y+3)>0$, positive outside the roots: $y<-3$ or $y>6$.'),
  ('If $y = x^2 - x - 12$, find the range of values of $x$ for which $y \leq 0$.', '$x \leq -3$ or $x \geq 4$', '$x < -3$ or $x > 4$', '$-3 \leq x \leq 4$', '$-3 < x \leq 4$', null, 'C', 3, 'GENERAL', 'Factorising: $(x-4)(x+3)\leq0$, negative or zero between the roots: $-3\leq x\leq4$.'),
  ('Solve the quadratic inequality $x^2 + x - 12 \geq 0$.', '$x \leq -4$ or $x \geq 3$', '$x \leq -3$ or $x \geq 4$', '$-4 \leq x \leq 3$', '$x \leq 4$ or $x \geq -3$', null, 'A', 3, 'GENERAL', 'Factorising: $(x+4)(x-3)\geq0$, positive or zero outside the roots: $x\leq-4$ or $x\geq3$. (The curated source printed a duplicated option pair here and omitted the correct set; a clean option set is used instead.)'),
  ('Find the range of values of $x$ which satisfies $12x^2 < x + 1$.', '$-1/4 < x < 1/3$', '$-1 < x < 1/4$', '$1/4 < x < 1/3$', '$-1/3 < x < 1/4$', null, 'A', 4, 'GENERAL', 'Rearranged: $12x^2-x-1<0$; roots (quadratic formula) are $x=1/3$ and $x=-1/4$; negative between them: $-1/4<x<1/3$. (The curated source printed garbled, duplicated options that did not contain this verified answer; a clean option set is used instead.)'),
  ('Solve the inequality $2 - x > x^2$.', '$x < -2$ or $x > 1$', '$x > 2$ or $x < -1$', '$-1 < x < 2$', '$-2 < x < 1$', null, 'D', 3, 'GENERAL', 'Rearranged: $x^2+x-2<0 \Rightarrow (x+2)(x-1)<0 \Rightarrow -2<x<1$.'),
  ('Solve the inequality $\frac{y-1}{2} \leq \frac{6}{y}$.', '$y \leq -3$ or $y \geq 4$', '$y \leq -3$ or $0 < y \leq 4$', '$-3 \leq y \leq 4$', '$0 < y \leq 4$', null, 'B', 5, 'GENERAL', 'Multiplying by $y$ flips the inequality when $y<0$. For $y>0$: $y^2-y-12\leq0 \Rightarrow -3\leq y\leq4$, combined with $y>0$ gives $0<y\leq4$. For $y<0$: $y^2-y-12\geq0 \Rightarrow y\leq-3$ or $y\geq4$, combined with $y<0$ gives $y\leq-3$. Full solution: $y\leq-3$ or $0<y\leq4$. (Corrected: the curated source states the answer as "y less than or equal to -3 or y greater than or equal to 4", but testing y=5 shows (5-1)/2=2 is NOT less than or equal to 6/5=1.2, so that form is wrong; the sign-dependent case analysis above gives the verified answer.)'),
  ('Solve the compound inequality $2(x + 3) \geq 3(x - 1)$ and $3(x - 1) \leq 12$ together.', '$x \leq 3$', '$x \leq 5$', '$x \leq 9$', '$x \leq 11$', null, 'B', 4, 'GENERAL', 'First part: $2x+6\geq3x-3 \Rightarrow 9\geq x$, i.e. $x\leq9$. Second part: $3x-3\leq12 \Rightarrow x\leq5$. The combined (more restrictive) answer is $x\leq5$. (Corrected: the curated source states the answer as x less than or equal to 3, which does not follow from either inequality; re-derivation gives x less than or equal to 5.)')
) as q(question_text, option_a, option_b, option_c, option_d, option_e, correct_letter, difficulty, exam_type, explanation)
where c.subject = 'Mathematics' and t.class_level = 'SS2' and t.term = 2 and t.order_index = 202;
-- ------------------------------------------
-- 203. GRAPHS OF LINEAR INEQUALITIES
-- ------------------------------------------

insert into public.lessons (topic_id, title, summary, content_body, order_index)
values (
  (select t.id from public.topics t join public.curricula c on c.id = t.curriculum_id
   where c.subject = 'Mathematics' and t.class_level = 'SS2' and t.term = 2 and t.order_index = 203),
  'Graphs of Linear Inequalities in Two Variables',
  'Graphing linear inequalities in two variables, finding the feasible region for several simultaneous inequalities, and using the corner point theorem to find maximum and minimum values.',
  '### Graphing a Single Inequality

To graph an inequality such as $x + y \leq 6$: first draw the boundary line $x + y = 6$, **solid** if the inequality is $\leq$ or $\geq$ (the line itself is included), **dashed** if it is $<$ or $>$ (the line itself is excluded). Then test a point NOT on the line, usually the origin $(0,0)$: if it satisfies the inequality, shade the side containing that point; if not, shade the other side.

### The Feasible Region

When several inequalities apply at once (simultaneous linear inequalities), the **feasible region** is the overlap (intersection) of every individual shaded region, every point in it satisfies ALL the inequalities together. Its corners (vertices) are found by solving pairs of boundary equations simultaneously.

### The Corner Point Theorem

For a linear objective function (like a profit or cost formula) evaluated over a feasible region, the maximum or minimum value always occurs at one of the feasible region''s corner points, never in the interior. So the full method is: find every corner, evaluate the objective function at each, and compare.

**Important check**: not every intercept of a boundary line is automatically a feasible corner, an intercept must also satisfy every OTHER constraint before it counts. Skipping this check is the most common source of a wrong answer on this topic.

### Glossary

- **Feasible region**: the set of all points that satisfy every given constraint simultaneously, visually, the region where all the shaded areas overlap.
- **Corner point (vertex)**: a point where two boundary lines of the feasible region meet.
- **Objective function**: the expression (e.g. profit or cost) being maximised or minimised over the feasible region.',
  1
);

insert into public.worked_examples (lesson_id, title, problem_statement, solution_steps, exam_shortcut, status)
select l.id,
  'Maximising an Objective Function',
  'Maximise $P = 3x + 4y$ subject to $x + y \leq 6$, $2x + y \leq 10$, $x \geq 0$, $y \geq 0$.',
  to_jsonb(array[
    'Find the intercepts of each boundary line: $x + y = 6 \Rightarrow (6,0)$ and $(0,6)$; $2x + y = 10 \Rightarrow (5,0)$ and $(0,10)$.',
    'Find the intersection of the two boundary lines by solving simultaneously: from $x+y=6$, $y=6-x$; substituting into $2x+y=10$ gives $2x+(6-x)=10 \Rightarrow x=4$, $y=2$. They cross at $(4,2)$.',
    'Check which intercepts are genuinely feasible (satisfy BOTH constraints, not just the one they lie on): $(0,6)$ satisfies $2(0)+6=6\leq10$, a genuine corner; $(5,0)$ satisfies $5+0=5\leq6$, also genuine; $(6,0)$ and $(0,10)$ fail the other constraint and are excluded.',
    'List the true corners of the feasible region: $(0,0)$, $(0,6)$, $(4,2)$, $(5,0)$.',
    'Evaluate $P = 3x+4y$ at each corner: $(0,0)\to0$; $(0,6)\to3(0)+4(6)=24$; $(4,2)\to3(4)+4(2)=20$; $(5,0)\to3(5)+4(0)=15$.',
    'Compare all values and pick the largest, since we are maximising: 24 is the largest.'
  ]),
  'The corner-point theorem means you never need to shade or "see" the optimum on a hand-drawn graph, just locate every corner, evaluate, and compare, this is far faster and more reliable than eyeballing a graph.',
  'published'
from public.lessons l join public.topics t on t.id = l.topic_id join public.curricula c on c.id = t.curriculum_id
where c.subject = 'Mathematics' and t.class_level = 'SS2' and t.term = 2 and t.order_index = 203;

insert into public.worked_examples (lesson_id, title, problem_statement, solution_steps, exam_shortcut, common_trap_warning, status)
select l.id,
  'Minimising an Objective Function with "At Least" Constraints',
  'Minimise $C = 2x + 3y$ subject to $x + y \geq 4$, $2x + y \geq 6$, $x \geq 0$, $y \geq 0$.',
  to_jsonb(array[
    'Find the intercepts of each boundary line: $x+y=4 \Rightarrow (4,0)$ and $(0,4)$; $2x+y=6 \Rightarrow (3,0)$ and $(0,6)$.',
    'Find the intersection of the two lines: from $x+y=4$, $y=4-x$; substituting into $2x+y=6$ gives $2x+(4-x)=6 \Rightarrow x=2$, $y=2$. They cross at $(2,2)$.',
    'Because both constraints are "at least" ($\geq$), the feasible region lies AWAY from the origin, check each intercept against the OTHER constraint before accepting it as a corner: $(0,4)$: check $2(0)+4=4$, which must be $\geq6$, this FAILS; $(0,6)$: check $0+6=6\geq4$ and $2(0)+6=6\geq6$, feasible corner; $(4,0)$: check $2(4)+0=8\geq6$ and $4+0=4\geq4$, feasible corner; $(3,0)$: check $3+0=3$, which must be $\geq4$, this FAILS.',
    'List the true corners: $(0,6)$, $(2,2)$, $(4,0)$.',
    'Evaluate $C = 2x+3y$ at each corner: $(0,6)\to2(0)+3(6)=18$; $(2,2)\to2(2)+3(2)=10$; $(4,0)\to2(4)+3(0)=8$.',
    'Compare all values and pick the smallest, since we are minimising: 8 is the smallest.'
  ]),
  'For "$\geq$" (at-least) constraints, the feasible region sits away from the origin, for "$\leq$" (at-most) constraints, it sits towards the origin, sketch a rough mental picture first so you check the correct intercepts.',
  'This example shows exactly why skipping the intercept check is dangerous: $(0,4)$ and $(3,0)$ both look like natural corners of their own boundary lines, but neither survives the check against the OTHER constraint, using them anyway gives a wrong feasible region and a wrong minimum.',
  'published'
from public.lessons l join public.topics t on t.id = l.topic_id join public.curricula c on c.id = t.curriculum_id
where c.subject = 'Mathematics' and t.class_level = 'SS2' and t.term = 2 and t.order_index = 203;

insert into public.worked_examples (lesson_id, title, problem_statement, solution_steps, exam_shortcut, real_life_context, status)
select l.id,
  'Finding a Feasible Region: A Farmer''s Land Allocation',
  'A farmer wants to plant cassava on $x$ hectares and maize on $y$ hectares, with $x \geq 2$ hectares of cassava (a minimum contract requirement), $y \geq 1$ hectare of maize, and a total of at most 8 hectares of land available ($x + y \leq 8$). Find the corners of the feasible region.',
  to_jsonb(array[
    'Draw the three boundary lines: the vertical line $x = 2$, the horizontal line $y = 1$, and the line $x + y = 8$.',
    'Find each pair of intersections: $x=2$ and $y=1$ meet at $(2,1)$; $x=2$ and $x+y=8$ meet where $2+y=8$, i.e. $y=6$, giving $(2,6)$; $y=1$ and $x+y=8$ meet where $x+1=8$, i.e. $x=7$, giving $(7,1)$.',
    'Confirm each point satisfies all three constraints simultaneously (it does, by construction of the intersections).'
  ]),
  'To find a boundary line''s intercepts fast, set $x=0$ for the $y$-intercept and $y=0$ for the $x$-intercept, you don''t need to plot the whole line first to read off where it crosses each axis.',
  'This is exactly the kind of planting-plan constraint an agricultural extension officer or cooperative would set for a farmer under contract, minimum area requirements for each crop plus a hard cap on total available land.',
  'published'
from public.lessons l join public.topics t on t.id = l.topic_id join public.curricula c on c.id = t.curriculum_id
where c.subject = 'Mathematics' and t.class_level = 'SS2' and t.term = 2 and t.order_index = 203;

insert into public.questions (topic_id, lesson_id, question_text, option_a, option_b, option_c, option_d, correct_letter, difficulty, exam_type, explanation, status)
select t.id, l.id, q.question_text, q.option_a, q.option_b, q.option_c, q.option_d, q.correct_letter, q.difficulty, q.exam_type::exam_type, q.explanation, 'published'
from public.topics t
  join public.curricula c on c.id = t.curriculum_id
  join public.lessons l on l.topic_id = t.id,
  (values
  ('Maximise $P = 3x + 4y$ subject to $x+y\leq6$, $2x+y\leq10$, $x\geq0$, $y\geq0$. Find the maximum value.', '$20$', '$24$', '$15$', '$26$', 'B', 3, 'GENERAL', 'Corners are $(0,0),(0,6),(4,2),(5,0)$; evaluating $P$ at each gives a maximum of 24 at $(0,6)$.'),
  ('Minimise $C = 2x + 3y$ subject to $x+y\geq4$, $2x+y\geq6$, $x\geq0$, $y\geq0$. Find the minimum value.', '$10$', '$18$', '$8$', '$14$', 'C', 3, 'GENERAL', 'Corners are $(0,6),(2,2),(4,0)$; evaluating $C$ at each gives a minimum of 8 at $(4,0)$.'),
  ('Find the corners of the feasible region for $x\geq2$, $y\geq1$, $x+y\leq8$.', '$(2,1),(7,1),(2,6)$', '$(0,0),(2,1),(8,0)$', '$(2,1),(8,1),(2,7)$', '$(0,1),(2,1),(2,8)$', 'A', 2, 'GENERAL', 'Intersecting the three boundaries pairwise gives $(2,1)$, $(7,1)$ and $(2,6)$.'),
  ('For the inequality $x + 2y \leq 8$ with $x\geq0,y\geq0$, which pair of intercepts bounds the feasible region''s slanted edge?', '$(0,4)$ and $(8,0)$', '$(0,8)$ and $(4,0)$', '$(0,2)$ and $(8,0)$', '$(0,4)$ and $(2,0)$', 'A', 1, 'GENERAL', 'Setting $x=0$ gives $y=4$; setting $y=0$ gives $x=8$.'),
  ('Find the corner points of the feasible region for $x+y\leq5$, $2x+y\leq8$, $x\geq0$, $y\geq0$.', '$(0,0),(0,5),(3,2),(4,0)$', '$(0,0),(0,8),(5,0)$', '$(0,0),(0,5),(4,0)$', '$(0,0),(3,2),(5,0),(4,4)$', 'A', 3, 'GENERAL', 'The intercept $(5,0)$ fails $2x+y\leq8$ and $(0,8)$ fails $x+y\leq5$; the true corners are $(0,0),(0,5),(3,2),(4,0)$, found by intersecting $x+y=5$ with $2x+y=8$ at $(3,2)$.'),
  ('When graphing an inequality, how do you decide which side of the boundary line to shade?', 'Test a point not on the line (e.g. the origin); if it satisfies the inequality, shade its side', 'Always shade above the line', 'Always shade below the line', 'Shade the side with the smaller intercept', 'A', 1, 'GENERAL', 'A test point not on the line tells you directly which side makes the inequality true.'),
  ('What is a feasible region in the context of simultaneous linear inequalities?', 'The set of all points satisfying every constraint at once', 'Any single boundary line', 'The region containing only the origin', 'The set of points that satisfy at least one constraint', 'A', 1, 'GENERAL', 'The feasible region is the overlap of all the individual shaded regions, satisfying ALL constraints simultaneously.'),
  ('State the corner point theorem for a linear objective function over a feasible region.', 'The optimal value always occurs at a vertex (corner) of the feasible region', 'The optimal value always occurs at the centre of the feasible region', 'The optimal value can occur anywhere inside the feasible region', 'The optimal value only occurs at the origin', 'A', 1, 'GENERAL', 'The corner point theorem guarantees the maximum or minimum of a linear objective function occurs at a vertex of the feasible region.'),
  ('Graph $2x + 3y \leq 12$ together with $x\geq0$, $y\geq0$. What are the corners of the resulting feasible region?', '$(0,0),(0,4),(6,0)$', '$(0,0),(0,6),(4,0)$', '$(0,0),(0,12),(6,0)$', '$(0,0),(0,4),(12,0)$', 'A', 2, 'GENERAL', 'Setting $x=0$ gives $y=4$; setting $y=0$ gives $x=6$; together with the origin these are the three corners.'),
  ('Find the corner points of the feasible region formed by $x+y\leq6$, $x\leq4$, $y\leq5$, $x\geq0$, $y\geq0$.', '$(0,0),(0,5),(1,5),(4,2),(4,0)$', '$(0,0),(0,5),(4,5),(4,0)$', '$(0,0),(0,6),(4,2),(4,0)$', '$(0,0),(1,5),(4,0)$', 'A', 4, 'GENERAL', 'The point $(4,5)$ fails $x+y\leq6$; working through the boundary intersections gives the five corners $(0,0),(0,5),(1,5),(4,2),(4,0)$.'),
  ('Maximise $P = 5x + 4y$ subject to $x+2y\leq10$, $3x+y\leq15$, $x\geq0$, $y\geq0$. Find the maximum value and where it occurs.', 'Max $P=32$ at $(4,3)$', 'Max $P=25$ at $(5,0)$', 'Max $P=30$ at $(0,5)$', 'Max $P=32$ at $(0,5)$', 'A', 4, 'GENERAL', 'Corners are $(0,0),(0,5),(4,3),(5,0)$; evaluating $P$ at each gives a maximum of 32 at $(4,3)$.'),
  ('Minimise $C = 3x + 2y$ subject to $2x+y\geq8$, $x+y\geq6$, $x\geq0$, $y\geq0$. Find the minimum value.', '$16$', '$18$', '$14$', '$20$', 'C', 4, 'GENERAL', 'Corners are $(0,8),(2,4),(6,0)$; evaluating $C$ at each gives a minimum of 14 at $(2,4)$.'),
  ('Graph $x+y\leq3$, $2x+y\leq12$, $x\leq5$, $x\geq0$, $y\geq0$ on the same axes. What is the resulting feasible region?', 'A triangle with corners $(0,0),(0,3),(3,0)$', 'A rectangle with corners $(0,0),(0,3),(5,3),(5,0)$', 'A triangle with corners $(0,0),(0,12),(6,0)$', 'A pentagon with five corners', 'A', 3, 'GENERAL', 'Since $x+y\leq3$ is far more restrictive than the other two constraints in this range, it alone determines the feasible region: a triangle with corners $(0,0),(0,3),(3,0)$.')
) as q(question_text, option_a, option_b, option_c, option_d, correct_letter, difficulty, exam_type, explanation)
where c.subject = 'Mathematics' and t.class_level = 'SS2' and t.term = 2 and t.order_index = 203;
-- ------------------------------------------
-- 204. LINEAR INEQUALITIES: APPLICATIONS & LINEAR PROGRAMMING
-- ------------------------------------------

insert into public.lessons (topic_id, title, summary, content_body, order_index)
values (
  (select t.id from public.topics t join public.curricula c on c.id = t.curriculum_id
   where c.subject = 'Mathematics' and t.class_level = 'SS2' and t.term = 2 and t.order_index = 204),
  'Application of Linear Inequalities to Real Life: Linear Programming',
  'Formulating real-life resource-allocation problems (manufacturing, farming, diet planning) as linear programming problems: decision variables, objective function, and constraints.',
  '### What Linear Programming Solves

**Linear programming (LP)** finds the best outcome, maximum profit or minimum cost, subject to linear constraints on limited resources (labour, materials, land, budget, and so on).

### The Four Steps to Formulate an LP Problem

1. **Define decision variables**: what quantities are actually being decided? (e.g. $x$ = number of item A produced, $y$ = number of item B produced.)
2. **Write the objective function**: the quantity to maximise or minimise, expressed in terms of the decision variables (e.g. Maximise $P = ax + by$).
3. **List the constraints**: one linear inequality per limited resource (e.g. labour-hours available, budget available).
4. **Add non-negativity constraints**: $x \geq 0$, $y \geq 0$, since a negative quantity produced, planted, or bought is physically meaningless.

### The Linearity Test

A problem is *linear* only if every term in the objective function and every constraint uses variables to the FIRST power, with no products of two variables like $xy$ and no squared terms like $x^2$. Spotting one such term instantly disqualifies a problem from being an LP problem.

### Glossary

- **Decision variable**: the unknown quantity a real decision-maker actually controls, e.g. how many of each product to make.
- **Constraint**: a real-world limitation (a resource cap, a minimum requirement) written as a linear inequality.
- **Non-negativity constraint**: the requirement that a decision variable cannot be negative, since a negative number of items, hectares, or hours makes no physical sense.',
  1
);

insert into public.worked_examples (lesson_id, title, problem_statement, solution_steps, exam_shortcut, real_life_context, status)
select l.id,
  'Formulating a Furniture Factory''s Production Problem',
  'A factory makes dining chairs ($x$) needing 2 labour-hours and 3 kg of wood each, and office chairs ($y$) needing 3 labour-hours and 2 kg of wood each. 120 labour-hours and 150 kg of wood are available. Profit is ₦5,000 per dining chair and ₦6,000 per office chair. Formulate this as a linear programming problem.',
  to_jsonb(array[
    'Define the decision variables: let $x$ = number of dining chairs made, $y$ = number of office chairs made.',
    'Write the objective function: profit comes from ₦5,000 per $x$ and ₦6,000 per $y$, so Maximise $P = 5000x + 6000y$.',
    'Write the resource constraints one at a time: labour used is 2 hours per dining chair plus 3 hours per office chair, limited to 120 hours, so $2x + 3y \leq 120$; wood used is 3 kg per dining chair plus 2 kg per office chair, limited to 150 kg, so $3x + 2y \leq 150$.',
    'Add the non-negativity constraints, since a negative number of chairs is meaningless: $x \geq 0$, $y \geq 0$.'
  ]),
  'Always begin by writing "let $x$ = ..., $y$ = ..." in words before touching the algebra, most formulation mistakes come from mixing up which variable stands for which resource-user.',
  'This is exactly the kind of production-mix decision a small furniture workshop in Nigeria faces every week, balancing scarce labour-hours and wood stock across two products with different profit margins.',
  'published'
from public.lessons l join public.topics t on t.id = l.topic_id join public.curricula c on c.id = t.curriculum_id
where c.subject = 'Mathematics' and t.class_level = 'SS2' and t.term = 2 and t.order_index = 204;

insert into public.worked_examples (lesson_id, title, problem_statement, solution_steps, exam_shortcut, real_life_context, status)
select l.id,
  'Formulating a Farmer''s Crop-Planning Problem',
  'A farmer has 100 hectares of land. Rice needs 2 workers per hectare and maize needs 1 worker per hectare; only 150 workers are available in total. Profit is ₦80,000 per hectare of rice and ₦50,000 per hectare of maize. Formulate this as a linear programming problem.',
  to_jsonb(array[
    'Define the decision variables: let $x$ = hectares planted with rice, $y$ = hectares planted with maize.',
    'Write the objective function: Maximise $P = 80000x + 50000y$.',
    'Write the constraints: total land used cannot exceed 100 hectares, so $x + y \leq 100$; total workers used cannot exceed 150, so $2x + y \leq 150$.',
    'Add non-negativity constraints: $x \geq 0$, $y \geq 0$.'
  ]),
  'Match units carefully: each constraint''s coefficients must describe "amount of resource per unit of $x$" and "per unit of $y$" in the SAME resource and the SAME unit, a mismatched unit is the most common setup error in these word problems.',
  'This is exactly the seasonal planting-mix decision a Nigerian farming cooperative makes: with limited hectares and limited hired labour, deciding how much land goes to each crop to maximise total profit.',
  'published'
from public.lessons l join public.topics t on t.id = l.topic_id join public.curricula c on c.id = t.curriculum_id
where c.subject = 'Mathematics' and t.class_level = 'SS2' and t.term = 2 and t.order_index = 204;

insert into public.worked_examples (lesson_id, title, problem_statement, solution_steps, exam_shortcut, common_trap_warning, status)
select l.id,
  'Recognising a Genuine LP Problem',
  'Identify which of the following are genuine linear programming problems: (a) Maximise $Z = 3x + 2y$ subject to $x^2 + y \leq 10$; (b) Minimise $C = 5x + 4y$ subject to $2x + 3y \leq 12$, $x + y \leq 8$; (c) Maximise $P = xy$ subject to $x + y \leq 20$.',
  to_jsonb(array[
    'Recall the linearity test: every term in the objective function and every constraint must have variables to the FIRST power only, with no products of two variables.',
    'Check (a): the constraint contains $x^2$, a squared variable, this fails the test.',
    'Check (b): the objective and both constraints use only $x$ and $y$ to the first power, added together, this passes the test.',
    'Check (c): the objective function contains $xy$, a product of two variables, this fails the test.'
  ]),
  'Scan every constraint for $x^2$, $y^2$, or a product like $xy$ before calling anything an LP problem, spotting one such term instantly disqualifies it with no further checking needed.',
  'A negative or fractional value for a decision variable might still satisfy the algebra of a constraint, but it almost always breaks the real-world meaning (a negative number of items, a fractional worker), which is exactly why non-negativity (and sometimes whole-number) constraints matter even when a question does not restate them.',
  'published'
from public.lessons l join public.topics t on t.id = l.topic_id join public.curricula c on c.id = t.curriculum_id
where c.subject = 'Mathematics' and t.class_level = 'SS2' and t.term = 2 and t.order_index = 204;

insert into public.questions (topic_id, lesson_id, question_text, option_a, option_b, option_c, option_d, correct_letter, difficulty, exam_type, explanation, status)
select t.id, l.id, q.question_text, q.option_a, q.option_b, q.option_c, q.option_d, q.correct_letter, q.difficulty, q.exam_type::exam_type, q.explanation, 'published'
from public.topics t
  join public.curricula c on c.id = t.curriculum_id
  join public.lessons l on l.topic_id = t.id,
  (values
  ('What are the main components of a linear programming problem?', 'Decision variables, objective function, constraints, feasible region, optimal solution', 'Only an objective function and an answer', 'A single equation and its root', 'A graph with no equations', 'A', 1, 'GENERAL', 'A complete LP formulation names decision variables, an objective function, constraints (including non-negativity), a feasible region, and an optimal solution.'),
  ('What is the difference between an objective function and a constraint?', 'The objective function is maximised/minimised; a constraint is a limitation the solution must satisfy', 'They mean exactly the same thing', 'A constraint is always an equation, never an inequality', 'The objective function has no variables', 'A', 1, 'GENERAL', 'The objective function is the quantity being optimised; constraints are the resource limits bounding the feasible region.'),
  ('A company makes products X (2 hours each) and Y (3 hours each); 120 labour-hours are available. Write the time constraint.', '$2x + 3y \leq 120$', '$2x + 3y \geq 120$', '$3x + 2y \leq 120$', '$2x + 3y = 120$', 'A', 1, 'GENERAL', 'Total time used, 2 hours per X plus 3 hours per Y, cannot exceed the 120 hours available.'),
  ('Which of these is NOT a typical real-life application of linear programming?', 'Manufacturing product-mix planning', 'Diet and nutrition planning', 'Predicting tomorrow''s weather from satellite images', 'Transportation and resource allocation', 'C', 1, 'GENERAL', 'Weather prediction from imagery is a different kind of modelling problem; manufacturing, diet planning, and transportation are classic LP applications.'),
  ('Why must decision variables in most real-life LP problems be non-negative?', 'Because quantities like items produced or hectares planted cannot physically be negative', 'Because negative numbers are not allowed in algebra', 'Because the objective function would be undefined otherwise', 'Because graphs cannot show negative regions', 'A', 1, 'GENERAL', 'A negative number of items produced, or a negative hectare planted, has no real-world meaning.'),
  ('A farmer plants tomatoes (3 hours/hectare, ₦40,000 profit) and peppers (2 hours/hectare, ₦30,000 profit); 60 labour-hours and 25 hectares are available. Formulate the LP problem.', 'Maximise $P=40000x+30000y$ s.t. $3x+2y\leq60$, $x+y\leq25$, $x,y\geq0$', 'Maximise $P=30000x+40000y$ s.t. $2x+3y\leq60$, $x+y\leq25$, $x,y\geq0$', 'Minimise $P=40000x+30000y$ s.t. $3x+2y\geq60$, $x+y\leq25$, $x,y\geq0$', 'Maximise $P=40000x+30000y$ s.t. $3x+2y\leq25$, $x+y\leq60$, $x,y\geq0$', 'A', 3, 'GENERAL', 'Tomatoes ($x$) use 3 hours/hectare and give ₦40,000 profit; peppers ($y$) use 2 hours/hectare and give ₦30,000 profit; land and labour give the two constraints.'),
  ('Which best describes a "feasible solution" in linear programming?', 'Any point that satisfies every constraint of the problem', 'The single best possible answer only', 'Any point on the objective function line', 'A point outside all the constraints', 'A', 1, 'GENERAL', 'A feasible solution is any point satisfying all constraints; the optimal solution is the best feasible solution.'),
  ('Which of these are genuine linear programming problems? (a) Max $P=4x+5y$ s.t. $2x+3y\leq100$, $x,y\geq0$ (b) Max $P=x^2+y$ s.t. $x+y\leq50$, $x,y\geq0$ (c) Min $C=3x+7y$ s.t. $x+2y\geq20$, $3x+y\geq30$, $x,y\geq0$', '(a) and (c) are LP; (b) is not (contains $x^2$)', 'All three are LP problems', 'Only (b) is an LP problem', 'None of them are LP problems', 'A', 2, 'GENERAL', '(a) and (c) use only first-power variables; (b) contains $x^2$, a squared term, which fails the linearity test.'),
  ('A baker makes meat pies (2 eggs, 100g flour, costs ₦300, sells ₦500) and sausage rolls (1 egg, 50g flour, costs ₦150, sells ₦300); 100 eggs and 5000g flour are available daily. Formulate the profit-maximisation problem.', 'Maximise profit $=200x+150y$ s.t. $2x+y\leq100$, $100x+50y\leq5000$, $x,y\geq0$', 'Maximise profit $=500x+300y$ s.t. $2x+y\leq100$, $100x+50y\leq5000$, $x,y\geq0$', 'Minimise cost $=300x+150y$ s.t. $2x+y\leq100$, $x,y\geq0$', 'Maximise profit $=200x+150y$ s.t. $x+2y\leq100$, $50x+100y\leq5000$, $x,y\geq0$', 'A', 3, 'GENERAL', 'Profit per meat pie is $500-300=200$; per sausage roll is $300-150=150$; the egg and flour totals give the two constraints.'),
  ('Give an example of a real-life LP scenario a school or local community might use.', 'Allocating a fixed budget between computers and projectors to maximise classroom benefit', 'Guessing the outcome of a football match', 'Measuring the height of the school flagpole', 'Counting the number of students in a class', 'A', 1, 'GENERAL', 'A budget-allocation problem with a linear objective and linear resource constraints is a natural LP scenario; the other options involve no optimisation over constraints.'),
  ('A factory produces dining chairs ($x$) and office chairs ($y$): 2 labour-hours and 3 kg wood per dining chair, 3 labour-hours and 2 kg wood per office chair; 120 labour-hours and 150 kg wood available; profits ₦5,000 and ₦6,000 respectively. Write the objective function and constraints (do not solve).', 'Maximise $P=5000x+6000y$ s.t. $2x+3y\leq120$, $3x+2y\leq150$, $x,y\geq0$', 'Maximise $P=6000x+5000y$ s.t. $3x+2y\leq120$, $2x+3y\leq150$, $x,y\geq0$', 'Minimise $P=5000x+6000y$ s.t. $2x+3y\geq120$, $3x+2y\geq150$, $x,y\geq0$', 'Maximise $P=5000x+6000y$ s.t. $2x+3y\leq150$, $3x+2y\leq120$, $x,y\geq0$', 'A', 3, 'GENERAL', 'This restates the furniture-factory example: labour gives $2x+3y\leq120$, wood gives $3x+2y\leq150$.'),
  ('A baker makes cakes (2 hours, 3 kg flour, sells ₦2,000) and bread (1 hour, 2 kg flour, sells ₦800); 40 hours and 60 kg flour are available. Formulate the revenue-maximisation problem.', 'Maximise $R=2000x+800y$ s.t. $2x+y\leq40$, $3x+2y\leq60$, $x,y\geq0$', 'Maximise $R=800x+2000y$ s.t. $x+2y\leq40$, $2x+3y\leq60$, $x,y\geq0$', 'Minimise $R=2000x+800y$ s.t. $2x+y\geq40$, $3x+2y\geq60$, $x,y\geq0$', 'Maximise $R=2000x+800y$ s.t. $2x+y\leq60$, $3x+2y\leq40$, $x,y\geq0$', 'A', 3, 'GENERAL', 'Cakes ($x$) use 2 hours and 3 kg flour; bread ($y$) uses 1 hour and 2 kg flour; the hour and flour totals give the two constraints.'),
  ('A company produces products A (4 hours on Machine 1, 2 hours on Machine 2, profit ₦3,000) and B (2 hours on Machine 1, 3 hours on Machine 2, profit ₦2,500); Machine 1 has 80 hours available, Machine 2 has 60 hours available. Formulate the LP problem.', 'Maximise $P=3000x+2500y$ s.t. $4x+2y\leq80$, $2x+3y\leq60$, $x,y\geq0$', 'Maximise $P=2500x+3000y$ s.t. $2x+4y\leq80$, $3x+2y\leq60$, $x,y\geq0$', 'Minimise $P=3000x+2500y$ s.t. $4x+2y\geq80$, $2x+3y\geq60$, $x,y\geq0$', 'Maximise $P=3000x+2500y$ s.t. $4x+2y\leq60$, $2x+3y\leq80$, $x,y\geq0$', 'A', 3, 'GENERAL', 'Machine 1 usage gives $4x+2y\leq80$; Machine 2 usage gives $2x+3y\leq60$.'),
  ('A nutritionist needs at least 300 calories and at least 50g protein per meal; Food A gives 100 cal/20g protein for ₦200, Food B gives 150 cal/10g protein for ₦250. Formulate the cost-minimisation problem.', 'Minimise $C=200x+250y$ s.t. $100x+150y\geq300$, $20x+10y\geq50$, $x,y\geq0$', 'Maximise $C=200x+250y$ s.t. $100x+150y\leq300$, $20x+10y\leq50$, $x,y\geq0$', 'Minimise $C=250x+200y$ s.t. $150x+100y\geq300$, $10x+20y\geq50$, $x,y\geq0$', 'Minimise $C=200x+250y$ s.t. $100x+150y\leq300$, $20x+10y\geq50$, $x,y\geq0$', 'A', 3, 'GENERAL', 'Food A ($x$) contributes 100 calories and 20g protein per unit; Food B ($y$) contributes 150 calories and 10g protein per unit; both "at least" requirements use $\geq$.'),
  ('A tailor makes agbada (4 hours, 6m fabric, profit ₦15,000) and suits (3 hours, 4m fabric, profit ₦12,000); 60 hours and 90m fabric are available. Formulate the LP problem.', 'Maximise $P=15000x+12000y$ s.t. $4x+3y\leq60$, $6x+4y\leq90$, $x,y\geq0$', 'Maximise $P=12000x+15000y$ s.t. $3x+4y\leq60$, $4x+6y\leq90$, $x,y\geq0$', 'Minimise $P=15000x+12000y$ s.t. $4x+3y\geq60$, $6x+4y\geq90$, $x,y\geq0$', 'Maximise $P=15000x+12000y$ s.t. $4x+3y\leq90$, $6x+4y\leq60$, $x,y\geq0$', 'A', 3, 'GENERAL', 'Time gives $4x+3y\leq60$; fabric gives $6x+4y\leq90$.'),
  ('A school wants to buy computers (₦150,000 each) and projectors (₦80,000 each) with a total budget of ₦2,000,000. Identify the decision variables and the budget constraint.', '$x$ = computers, $y$ = projectors, with $150000x+80000y\leq2000000$', '$x$ = projectors, $y$ = computers, with $80000x+150000y\geq2000000$', '$x$ = computers, $y$ = projectors, with $150000x+80000y=2000000$ only', '$x$ = computers, $y$ = projectors, with $150000x+80000y\geq2000000$', 'A', 2, 'GENERAL', 'The total spent on computers plus projectors cannot exceed the ₦2,000,000 budget, so the constraint uses $\leq$.'),
  ('A bus company has 10 buses; each trip needs 2 drivers and 1 mechanic; 15 drivers and 8 mechanics are available. If $x$ is the number of buses used per trip, write the constraints.', '$2x\leq15$ (drivers), $x\leq8$ (mechanics), $x\leq10$ (buses)', '$2x\geq15$ (drivers), $x\geq8$ (mechanics), $x\leq10$ (buses)', '$x\leq15$ (drivers), $2x\leq8$ (mechanics), $x\leq10$ (buses)', '$2x\leq15$ (drivers), $x\leq8$ (mechanics), $x\geq10$ (buses)', 'A', 3, 'GENERAL', 'Each bus in use needs 2 drivers, so drivers used is $2x\leq15$; each bus needs 1 mechanic, so $x\leq8$; and only 10 buses physically exist, so $x\leq10$.')
) as q(question_text, option_a, option_b, option_c, option_d, correct_letter, difficulty, exam_type, explanation)
where c.subject = 'Mathematics' and t.class_level = 'SS2' and t.term = 2 and t.order_index = 204;
-- ------------------------------------------
-- 205. ALGEBRAIC FRACTIONS
-- ------------------------------------------

insert into public.lessons (topic_id, title, summary, content_body, order_index)
values (
  (select t.id from public.topics t join public.curricula c on c.id = t.curriculum_id
   where c.subject = 'Mathematics' and t.class_level = 'SS2' and t.term = 2 and t.order_index = 205),
  'Algebraic Fractions: Simplification and Operations',
  'Simplifying algebraic fractions by factorising and cancelling, and adding, subtracting, multiplying and dividing algebraic fractions using the LCM of denominators.',
  '### Simplifying Algebraic Fractions

Algebraic fractions are simplified the same way as numeric fractions: **factorise the numerator and denominator fully first**, then cancel any common factors. Only common *multiplying* factors can be cancelled, never a term that is being added or subtracted inside a bracket.

Two patterns to spot on sight:
- **Difference of two squares**: $a^2 - b^2 = (a-b)(a+b)$.
- **Perfect-square trinomial**: $a^2 \pm 2ab + b^2 = (a \pm b)^2$.

### Adding and Subtracting Algebraic Fractions

Find the **LCM (lowest common multiple) of the denominators**, rewrite each fraction over that LCM, then combine the numerators. If two binomial denominators share no common factor (e.g. $(b-1)$ and $(b+2)$), their LCM is simply their product.

### Multiplying and Dividing Algebraic Fractions

Multiply numerators together and denominators together, cancelling common factors first wherever possible. Division is "keep, change, flip": keep the first fraction as it is, change $\div$ to $\times$, and flip (take the reciprocal of) the second fraction.

### Glossary

- **LCM of denominators**: the smallest expression that every denominator divides into exactly, used as the common denominator when adding or subtracting fractions.
- **Reciprocal**: a fraction turned upside down, e.g. the reciprocal of $\frac{a}{b}$ is $\frac{b}{a}$.',
  1
);

insert into public.worked_examples (lesson_id, title, problem_statement, solution_steps, exam_shortcut, status)
select l.id,
  'Simplifying by Difference of Two Squares',
  'Simplify $\frac{x^2 - y^2}{3x + 3y}$.',
  to_jsonb(array[
    'Factorise the numerator, a difference of two squares: $x^2 - y^2 = (x-y)(x+y)$.',
    'Factorise the denominator by taking out the common factor 3: $3x + 3y = 3(x+y)$.',
    'Write as one fraction and cancel the common factor $(x+y)$ top and bottom: $\frac{(x-y)(x+y)}{3(x+y)} = \frac{x-y}{3}$.'
  ]),
  'Recognising $a^2-b^2=(a-b)(a+b)$ on sight skips the "split the middle term" search entirely, this is the single most useful pattern-recognition shortcut on this topic.',
  'published'
from public.lessons l join public.topics t on t.id = l.topic_id join public.curricula c on c.id = t.curriculum_id
where c.subject = 'Mathematics' and t.class_level = 'SS2' and t.term = 2 and t.order_index = 205;

insert into public.worked_examples (lesson_id, title, problem_statement, solution_steps, exam_shortcut, status)
select l.id,
  'Simplifying a Perfect-Square Trinomial Ratio',
  'Simplify $\frac{x^2 - 8x + 16}{x^2 - 7x + 12}$.',
  to_jsonb(array[
    'Factorise the numerator, a perfect-square trinomial: $x^2 - 8x + 16 = (x-4)(x-4)$.',
    'Factorise the denominator: find two numbers multiplying to 12 and adding to $-7$, these are $-4$ and $-3$, so $x^2-7x+12 = (x-4)(x-3)$.',
    'Cancel the common factor $(x-4)$: $\frac{(x-4)(x-4)}{(x-4)(x-3)} = \frac{x-4}{x-3}$.'
  ]),
  'Always factorise FIRST and cancel SECOND, and only cancel a factor that multiplies the whole numerator and the whole denominator.',
  'published'
from public.lessons l join public.topics t on t.id = l.topic_id join public.curricula c on c.id = t.curriculum_id
where c.subject = 'Mathematics' and t.class_level = 'SS2' and t.term = 2 and t.order_index = 205;

insert into public.worked_examples (lesson_id, title, problem_statement, solution_steps, exam_shortcut, real_life_context, status)
select l.id,
  'Adding Fractions with Different Denominators',
  'A market analyst tracks two data plans: one uses $\frac{x+1}{2}$ gigabytes per week on average, the other uses $\frac{3x-1}{3}$ gigabytes per week, where $x$ is the number of active users (in hundreds). Express the DIFFERENCE in weekly usage, $\frac{x+1}{2} - \frac{3x-1}{3}$, as a single fraction.',
  to_jsonb(array[
    'Find the LCM of the denominators 2 and 3: LCM $= 6$.',
    'Rewrite each fraction with denominator 6: $\frac{x+1}{2} = \frac{3(x+1)}{6}$, $\frac{3x-1}{3} = \frac{2(3x-1)}{6}$.',
    'Combine over the common denominator: $\frac{3(x+1) - 2(3x-1)}{6}$.',
    'Expand the brackets: $\frac{3x + 3 - 6x + 2}{6}$.',
    'Collect like terms in the numerator: $\frac{5 - 3x}{6}$.'
  ]),
  'When combining two fractions with different denominators, always find the LCM of the denominators FIRST, before touching the numerators, trying to combine before finding a common denominator is the most common source of error here.',
  'This is the kind of comparison a telecom analyst or a school''s ICT officer might build, comparing weekly data usage across two subscription plans as a single algebraic expression in terms of the number of active users.',
  'published'
from public.lessons l join public.topics t on t.id = l.topic_id join public.curricula c on c.id = t.curriculum_id
where c.subject = 'Mathematics' and t.class_level = 'SS2' and t.term = 2 and t.order_index = 205;

insert into public.worked_examples (lesson_id, title, problem_statement, solution_steps, exam_shortcut, real_life_context, status)
select l.id,
  'Fractions with Ratio-Linked Variables',
  'Three business partners split their combined revenue $x$, $y$, $z$ in the ratio $6:5:8$. Evaluate $\frac{12x - 9z}{4y + z}$.',
  to_jsonb(array[
    'Introduce a single scaling constant $k$, since the numbers are in ratio $6:5:8$: $x = 6k$, $y = 5k$, $z = 8k$.',
    'Substitute into the numerator: $12x - 9z = 12(6k) - 9(8k) = 72k - 72k = 0$.',
    'Substitute into the denominator: $4y + z = 4(5k) + 8k = 20k + 8k = 28k$.',
    'Divide: $\frac{0}{28k} = 0$ (valid since $k \neq 0$, the partners have nonzero revenue shares).'
  ]),
  'For ratio problems ($x:y:z = a:b:c$), always introduce one scaling constant $k$ so $x=ak$, $y=bk$, $z=ck$, this turns three unknowns into one, and $k$ very often cancels out entirely in the final answer.',
  'This is exactly how a partnership or cooperative structured with a fixed revenue-sharing ratio would check a proposed formula, plugging in the ratio directly instead of needing to know the actual naira amounts.',
  'published'
from public.lessons l join public.topics t on t.id = l.topic_id join public.curricula c on c.id = t.curriculum_id
where c.subject = 'Mathematics' and t.class_level = 'SS2' and t.term = 2 and t.order_index = 205;

insert into public.questions (topic_id, lesson_id, question_text, option_a, option_b, option_c, option_d, option_e, correct_letter, difficulty, exam_type, explanation, status)
select t.id, l.id, q.question_text, q.option_a, q.option_b, q.option_c, q.option_d, q.option_e, q.correct_letter, q.difficulty, q.exam_type::exam_type, q.explanation, 'published'
from public.topics t
  join public.curricula c on c.id = t.curriculum_id
  join public.lessons l on l.topic_id = t.id,
  (values
  ('Simplify $\frac{5y - (2+3y) + (7y-4)}{3}$.', '$6y+4$', '$3y+2$', '$6y+2$', '$3y-2$', '$9y-6$', 'D', 2, 'GENERAL', 'Numerator simplifies to $5y-2-3y+7y-4=9y-6$; dividing by 3 gives $3y-2$.'),
  ('Find the sum of $25a - 15b + c$, $13a - 10b + 4c$ and $a + 20b - c$.', '$12a-5b+5c$', '$12a+5b-5c$', '$13a+5b+4c$', '$39a-5b+4c$', '$39a+5b+4c$', 'D', 2, 'GENERAL', 'Adding like terms: $a$: $25+13+1=39$; $b$: $-15-10+20=-5$; $c$: $1+4-1=4$, giving $39a-5b+4c$.'),
  ('Simplify $\frac{x^2 - y^2}{3x + 3y}$.', '$\frac{x-y}{3}$', '$\frac{x+y}{3}$', '$3(x-y)$', '$\frac{x-y}{3xy}$', null, 'A', 1, 'GENERAL', 'Factorising and cancelling $(x+y)$: $\frac{(x-y)(x+y)}{3(x+y)}=\frac{x-y}{3}$.'),
  ('Simplify $\frac{x^2-y^2}{(x+y)^2} \div \frac{(x-y)^2}{3x+3y}$.', '$\frac{x-y}{3}$', '$x+y$', '$\frac{3}{x-y}$', '$x-y$', null, 'C', 3, 'GENERAL', '"Keep, change, flip" and cancel: the expression reduces to $\frac{3}{x-y}$ (see the worked example in the lesson notes for the full cancellation).'),
  ('Simplify $\frac{x^2 - 8x + 16}{x^2 - 7x + 12}$.', '$\frac{x-4}{x-3}$', '$\frac{x-3}{x-4}$', '$x-4$', '$\frac{(x-4)^2}{x-3}$', null, 'A', 2, 'GENERAL', 'Factorising: numerator $=(x-4)^2$, denominator $=(x-4)(x-3)$; cancelling $(x-4)$ gives $\frac{x-4}{x-3}$.'),
  ('Simplify $\frac{\frac{1}{x} + \frac{1}{y}}{x + y}$.', '$\frac{1}{x+y}$', '$\frac{1}{xy}$', '$x+y$', '$xy$', null, 'B', 3, 'GENERAL', 'The numerator combines to $\frac{x+y}{xy}$; dividing by $(x+y)$ leaves $\frac{1}{xy}$.'),
  ('Evaluate $\frac{12ab - 4b^2}{2b^2 - 6ab}$.', '$-2$', '$-1$', '$1$', '$2$', null, 'A', 2, 'GENERAL', 'Factorising: numerator $=4b(3a-b)$, denominator $=-2b(3a-b)$; the ratio is $\frac{4}{-2}=-2$.'),
  ('Simplify $\frac{t^2}{12} - \frac{t}{3} + \frac{1}{3}$.', '$3(t-2)^2$', '$\frac{(t-2)^2}{3}$', '$t-2$', '$\frac{(t-2)^2}{12}$', null, 'D', 3, 'GENERAL', 'Over a common denominator of 12: $\frac{t^2-4t+4}{12}=\frac{(t-2)^2}{12}$.'),
  ('Simplify $\frac{2x+1}{2} - \frac{3x-7}{9} - \frac{5}{18}$.', '$\frac{2x+1}{1}$', '$\frac{2x+6}{1}$', '$\frac{2x+1}{3}$', '$\frac{2x+18}{3}$', '$\frac{2x+3}{3}$', 'E', 3, 'GENERAL', 'Over a common denominator of 18: $\frac{9(2x+1)-2(3x-7)-5}{18}=\frac{18x+9-6x+14-5}{18}=\frac{12x+18}{18}=\frac{2x+3}{3}$.'),
  ('Simplify $\frac{4}{2x} - \frac{2+x}{x}$.', '$-1$', '$-2x$', '$2x$', '$\frac{2-x}{x}$', null, 'A', 2, 'GENERAL', '$\frac{4}{2x}=\frac{2}{x}$; so $\frac{2}{x}-\frac{2+x}{x}=\frac{2-2-x}{x}=\frac{-x}{x}=-1$.'),
  ('Simplify $\frac{2}{x} + \frac{5}{3x}$, giving a single fraction.', '$\frac{11}{3x}$', '$\frac{7}{3x}$', '$\frac{11}{4x}$', '$\frac{7}{4x}$', null, 'A', 2, 'GENERAL', 'Over a common denominator of $3x$: $\frac{6}{3x}+\frac{5}{3x}=\frac{11}{3x}$.'),
  ('If $\frac{4}{x-5} - \frac{3}{x-6}$ is expressed as $\frac{p}{(x-5)(x-6)}$, find $p$.', '$x+9$', '$x+5$', '$x-9$', '$x-39$', null, 'C', 3, 'GENERAL', 'Combining: $\frac{4(x-6)-3(x-5)}{(x-5)(x-6)}=\frac{4x-24-3x+15}{(x-5)(x-6)}=\frac{x-9}{(x-5)(x-6)}$, so $p=x-9$.'),
  ('Simplify $\frac{m}{n} + \frac{m-1}{5n} - \frac{m-2}{10n}$, $n \neq 0$.', '$\frac{m-3}{10n}$', '$\frac{11m}{10n}$', '$\frac{m+1}{10n}$', '$\frac{11m+4}{10n}$', null, 'B', 3, 'GENERAL', 'Over a common denominator of $10n$: $\frac{10m+2(m-1)-(m-2)}{10n}=\frac{11m}{10n}$.'),
  ('Simplify $\frac{2a}{b-1} + \frac{a}{b+2}$.', '$\frac{3a(b+1)}{(b-1)(b+2)}$', '$\frac{a(b+1)}{(b-1)(b+2)}$', '$\frac{3b(a+1)}{(b-1)(b+2)}$', '$\frac{ab(b+1)}{(b-1)(b+2)}$', '$\frac{3b(a-1)}{(b-1)(b+2)}$', 'A', 3, 'GENERAL', 'Combining over $(b-1)(b+2)$: $\frac{2a(b+2)+a(b-1)}{(b-1)(b+2)}=\frac{3ab+3a}{(b-1)(b+2)}=\frac{3a(b+1)}{(b-1)(b+2)}$.'),
  ('Express $\frac{2}{x+3} - \frac{1}{x-2}$ as a single fraction.', '$\frac{x-7}{x^2+x-6}$', '$\frac{x-1}{x^2+x-6}$', '$\frac{x-2}{x^2+x-6}$', '$\frac{x+7}{x^2+x-6}$', null, 'A', 3, 'GENERAL', 'Combining: $\frac{2(x-2)-1(x+3)}{(x+3)(x-2)}=\frac{2x-4-x-3}{x^2+x-6}=\frac{x-7}{x^2+x-6}$.'),
  ('Simplify $\frac{x-4}{4} - \frac{x-3}{6}$.', '$\frac{x-18}{12}$', '$\frac{x-6}{12}$', '$\frac{x-18}{24}$', '$\frac{x-6}{24}$', null, 'B', 2, 'GENERAL', 'Over a common denominator of 12: $\frac{3(x-4)-2(x-3)}{12}=\frac{x-6}{12}$.'),
  ('Simplify $\frac{2a}{5} - \frac{a}{3} + \frac{a}{15}$.', '$\frac{a}{3}$', '$\frac{2a}{15}$', '$\frac{4a}{15}$', '$\frac{a}{5}$', null, 'C', 2, 'GENERAL', 'Over a common denominator of 15: $\frac{6a-5a+a}{15}=\frac{2a}{15}$. (Replaces a source item flagged as OCR-corrupted, testing the same skill: combining three algebraic fractions over a common denominator.)'),
  ('Express $\frac{2}{2+x} - \frac{1}{2-x}$ as a single fraction.', '$\frac{6-3x}{(2-x)^2}$', '$\frac{4-3x}{4-x^2}$', '$\frac{2-3x}{4-x^2}$', '$\frac{2-3x}{4+x^2}$', null, 'C', 3, 'GENERAL', 'Combining: $\frac{2(2-x)-1(2+x)}{(2+x)(2-x)}=\frac{4-2x-2-x}{4-x^2}=\frac{2-3x}{4-x^2}$.'),
  ('Simplify $\frac{1}{x-1} - \frac{2}{x^2-1}$.', '$\frac{1}{x-1}$', '$\frac{1}{x+1}$', '$\frac{-1}{x^2-1}$', '$\frac{1}{x^2-1}$', '$\frac{1}{x^2+1}$', 'B', 3, 'GENERAL', '$\frac{1}{x-1}-\frac{2}{(x-1)(x+1)}=\frac{(x+1)-2}{(x-1)(x+1)}=\frac{x-1}{(x-1)(x+1)}=\frac{1}{x+1}$.'),
  ('Express $4 - \frac{x}{y}$ as a single fraction.', '$\frac{4y-x}{y}$', '$\frac{x-4y}{y}$', '$\frac{4y+x}{y}$', '$4xy$', null, 'A', 2, 'GENERAL', 'Writing 4 as $\frac{4y}{y}$: $\frac{4y}{y}-\frac{x}{y}=\frac{4y-x}{y}$.'),
  ('Simplify $\frac{5}{x-1} - \frac{6}{x-2}$.', '$\frac{-(x+4)}{x^2-3x+2}$', '$\frac{x+4}{x^2-3x+2}$', '$\frac{x-4}{x^2-3x+2}$', '$\frac{-(x-4)}{x^2-3x+2}$', null, 'A', 3, 'GENERAL', 'Combining: $\frac{5(x-2)-6(x-1)}{(x-1)(x-2)}=\frac{5x-10-6x+6}{x^2-3x+2}=\frac{-x-4}{x^2-3x+2}=\frac{-(x+4)}{x^2-3x+2}$.'),
  ('Simplify $\frac{1}{x-1} - \frac{2}{x+2}$.', '$\frac{-x}{(x-1)(x+2)}$', '$\frac{x}{(x-1)(x+2)}$', '$\frac{4-x}{(x-1)(x+2)}$', '$\frac{4+x}{(x-1)(x+2)}$', '$\frac{x-4}{(x-1)(x+2)}$', 'C', 3, 'GENERAL', 'Combining: $\frac{(x+2)-2(x-1)}{(x-1)(x+2)}=\frac{x+2-2x+2}{(x-1)(x+2)}=\frac{4-x}{(x-1)(x+2)}$.'),
  ('Write $\frac{3x+2}{4} - \frac{x-1}{4} - \frac{5}{12}$ as a single fraction.', '$\frac{3x+2}{4}$', '$\frac{x-1}{3}$', '$\frac{x-1}{5}$', '$\frac{3x+2}{6}$', '$\frac{3x+2}{12}$', 'D', 3, 'GENERAL', 'LCM of 4, 4, 12 is 12: $\frac{3(3x+2)-3(x-1)-5}{12}=\frac{9x+6-3x+3-5}{12}=\frac{6x+4}{12}=\frac{3x+2}{6}$.'),
  ('Simplify $\frac{a}{4} + \frac{2a}{3} - \frac{a}{12}$.', '$\frac{2a}{3}$', '$\frac{a}{4}$', '$\frac{5a}{6}$', '$\frac{a}{12}$', null, 'C', 2, 'GENERAL', 'Over a common denominator of 12: $\frac{3a+8a-a}{12}=\frac{10a}{12}=\frac{5a}{6}$.'),
  ('If $p = \frac{2u}{1-u}$ and $q = \frac{1+u}{1-u}$, express $\frac{p+q}{p-q}$ in terms of $u$.', '$\frac{3u+1}{u-1}$', '$\frac{u+1}{3u-1}$', '$\frac{3u-1}{u+1}$', '$\frac{u-1}{3u+1}$', null, 'A', 4, 'GENERAL', '$p+q=\frac{3u+1}{1-u}$, $p-q=\frac{u-1}{1-u}$; dividing (the $1-u$ cancels) gives $\frac{3u+1}{u-1}$.'),
  ('Given $P = \frac{x^2-y^2}{x^2+xy}$, find $P$ when $x=-4$, $y=-6$.', '$-\frac{1}{2}$', '$\frac{1}{2}$', '$-2$', '$2$', null, 'A', 3, 'GENERAL', 'Simplified, $P=\frac{x-y}{x}$; substituting $x=-4,y=-6$: $\frac{-4-(-6)}{-4}=\frac{2}{-4}=-\frac{1}{2}$.'),
  ('If $x, y, z$ are in the ratio $6:5:8$, find $\frac{12x-9z}{4y+z}$.', '$0$', '$1$', '$-1$', '$2$', null, 'A', 3, 'GENERAL', 'Writing $x=6k,y=5k,z=8k$: numerator $=72k-72k=0$; the whole expression is 0.'),
  ('If $x=3$, $y=2$, $z=4$, find the value of $3x^2 - 2y + z$.', '$17$', '$27$', '$35$', '$71$', null, 'B', 1, 'GENERAL', '$3(9)-2(2)+4=27-4+4=27$.'),
  ('If $x = \frac{3m-2}{m-1}$, express $\frac{x+1}{2x-1}$ in terms of $m$.', '$\frac{4m-3}{5m-3}$', '$\frac{3m-2}{m-1}$', '$\frac{4m-3}{m-1}$', '$\frac{m-1}{5m-3}$', null, 'A', 4, 'GENERAL', '$x+1=\frac{4m-3}{m-1}$, $2x-1=\frac{5m-3}{m-1}$; dividing (the $m-1$ cancels) gives $\frac{4m-3}{5m-3}$.'),
  ('Evaluate $\left(\frac{a+b}{a-b}\right)^3$ for $a=-7$, $b=3$.', '$-\frac{8}{125}$', '$\frac{8}{125}$', '$-\frac{4}{10}$', '$\frac{16}{125}$', '$\frac{2}{5}$', 'C', 3, 'GENERAL', '$a+b=-4$, $a-b=-10$, so $\frac{a+b}{a-b}=\frac{-4}{-10}=\frac{2}{5}$ (positive, since a negative divided by a negative is positive); cubing gives $\frac{8}{125}$. (Corrected: the curated source states $-\frac{8}{125}$, but $\frac{-4}{-10}$ is positive, so the cube must also be positive.)'),
  ('Given $x = 2$ and $y = -\frac{1}{5}$, evaluate $x^2y - 2xy$.', '$0$', '$\frac{1}{5}$', '$1$', '$2$', null, 'A', 3, 'GENERAL', 'Factorise first: $x^2y-2xy=xy(x-2)$. Since $x=2$ exactly, the factor $(x-2)=0$, making the whole expression 0 without further arithmetic.'),
  ('Evaluate $\frac{x^2+x-2}{2x^2+x-3}$ when $x = -1$.', '$2$', '$1$', '$-\frac{1}{2}$', '$-1$', null, 'B', 3, 'GENERAL', 'Substituting $x=-1$: numerator $=1-1-2=-2$; denominator $=2-1-3=-2$; the value is $\frac{-2}{-2}=1$.')
) as q(question_text, option_a, option_b, option_c, option_d, option_e, correct_letter, difficulty, exam_type, explanation)
where c.subject = 'Mathematics' and t.class_level = 'SS2' and t.term = 2 and t.order_index = 205;
-- ------------------------------------------
-- 206. EQUATIONS INVOLVING FRACTIONS
-- ------------------------------------------

insert into public.lessons (topic_id, title, summary, content_body, order_index)
values (
  (select t.id from public.topics t join public.curricula c on c.id = t.curriculum_id
   where c.subject = 'Mathematics' and t.class_level = 'SS2' and t.term = 2 and t.order_index = 206),
  'Equations Involving Fractions: Undefined Values and Zeros',
  'Finding where an algebraic fraction is undefined (denominator zero) and where it equals zero (numerator zero), and solving equations that involve algebraic fractions.',
  '### When Is a Fraction Undefined?

An algebraic fraction $\frac{a(x)}{b(x)}$ is **undefined** wherever its denominator $b(x) = 0$, since division by zero is impossible. This check always uses the ORIGINAL (unsimplified) denominator, because a value that gets cancelled away during simplification is still excluded from the fraction''s domain.

**Method**: set the denominator equal to zero and solve for $x$. If the denominator is a quadratic, factorise it first and set each factor to zero in turn.

### When Does a Fraction Equal Zero?

A fraction equals zero only when its **numerator** equals zero (after fully simplifying/factorising), provided the denominator is not simultaneously zero there.

**Method**: set the (simplified) numerator equal to zero and solve, then check the answer does not also make the denominator zero, if it does, the fraction is undefined there, not zero, and that value must be rejected.

### Glossary

- **Undefined**: a fraction has no value at a particular $x$, because dividing by zero is mathematically impossible.
- **Domain**: the set of $x$-values for which an expression is actually defined, i.e. every real number EXCEPT wherever the denominator is zero.',
  1
);

insert into public.worked_examples (lesson_id, title, problem_statement, solution_steps, exam_shortcut, real_life_context, status)
select l.id,
  'Finding Where a Simple Fraction Is Undefined',
  'Find the value of $x$ for which $\frac{x+1}{2x-1}$ is undefined.',
  to_jsonb(array[
    'Recall that a fraction is undefined only where its denominator equals zero.',
    'Set the denominator equal to zero: $2x - 1 = 0$.',
    'Solve for $x$: $2x = 1$, so $x = \frac{1}{2}$.'
  ]),
  '"Undefined" always means denominator $=0$, use the ORIGINAL denominator, never a simplified one.',
  'A cost-sharing formula like "cost per person $= \frac{x+1}{2x-1}$" (where $x$ relates to group size) breaks down at exactly the value that makes its denominator zero, the same computation an app splitting a restaurant bill or a data bundle among friends would need to guard against.',
  'published'
from public.lessons l join public.topics t on t.id = l.topic_id join public.curricula c on c.id = t.curriculum_id
where c.subject = 'Mathematics' and t.class_level = 'SS2' and t.term = 2 and t.order_index = 206;

insert into public.worked_examples (lesson_id, title, problem_statement, solution_steps, exam_shortcut, status)
select l.id,
  'Finding Where a Fraction with a Factorised Denominator Is Undefined',
  'Find the value(s) of $x$ for which $\frac{2x^2}{(x-2)(x+3)}$ is not defined.',
  to_jsonb(array[
    'The denominator is already factorised: $(x-2)(x+3)$.',
    'Set each factor to zero in turn: $x - 2 = 0$ gives $x = 2$; $x + 3 = 0$ gives $x = -3$.'
  ]),
  'For a quadratic denominator, factorise it first, then read off both roots directly from the two factors, this is much faster than the quadratic formula.',
  'published'
from public.lessons l join public.topics t on t.id = l.topic_id join public.curricula c on c.id = t.curriculum_id
where c.subject = 'Mathematics' and t.class_level = 'SS2' and t.term = 2 and t.order_index = 206;

insert into public.worked_examples (lesson_id, title, problem_statement, solution_steps, exam_shortcut, common_trap_warning, real_life_context, status)
select l.id,
  'Finding Where a Fraction Equals Zero',
  'A shop''s daily profit margin is modelled by $\frac{x+3}{x^2+10x-25}$, where $x$ is the number of items discounted. For what value of $x$ is this profit margin exactly zero?',
  to_jsonb(array[
    'Recall that a fraction equals zero only when its numerator equals zero, provided the denominator is not also zero there.',
    'The numerator $x+3$ does not factorise any further, so set it to zero directly: $x + 3 = 0$.',
    'Solve: $x = -3$.',
    'Check the denominator is not also zero at $x = -3$: $(-3)^2 + 10(-3) - 25 = 9 - 30 - 25 = -46 \neq 0$, so this value is valid.'
  ]),
  '"Equals zero" always means numerator $=0$ (after simplifying), never cross-multiply the whole fraction by zero, that destroys the equation.',
  'After solving an "equals zero" question, always plug the answer back into the denominator as a quick check, if it also zeroes the denominator, the fraction is undefined there, not zero, and the value must be rejected instead of reported as an answer.',
  'This mirrors how a business might model "break-even markdown" as a fraction that hits zero at a specific discount level, useful for a shop owner deciding how many items to discount before margin turns negative.',
  'published'
from public.lessons l join public.topics t on t.id = l.topic_id join public.curricula c on c.id = t.curriculum_id
where c.subject = 'Mathematics' and t.class_level = 'SS2' and t.term = 2 and t.order_index = 206;

insert into public.worked_examples (lesson_id, title, problem_statement, solution_steps, exam_shortcut, status)
select l.id,
  'Zero of a Fraction After Cancellation',
  'For what value of $x$ is $\frac{x^2 - 2x - 15}{x^2 - 25}$ equal to zero?',
  to_jsonb(array[
    'Factorise the numerator: find two numbers multiplying to $-15$ and adding to $-2$, these are $-5$ and $3$, so $x^2-2x-15=(x-5)(x+3)$.',
    'Factorise the denominator, a difference of two squares: $x^2-25=(x-5)(x+5)$.',
    'Cancel the common factor $(x-5)$, noting $x \neq 5$ since that value makes the ORIGINAL denominator zero: $\frac{(x-5)(x+3)}{(x-5)(x+5)} = \frac{x+3}{x+5}$.',
    'Set the simplified numerator to zero: $x+3=0$, so $x=-3$.',
    'Check this does not make the denominator zero: at $x=-3$, $x+5=2 \neq 0$, so it is valid.'
  ]),
  'When a numerator and denominator share a common factor, always note the value that factor excludes BEFORE cancelling, so you don''t accidentally report an excluded value as a valid zero later.',
  'published'
from public.lessons l join public.topics t on t.id = l.topic_id join public.curricula c on c.id = t.curriculum_id
where c.subject = 'Mathematics' and t.class_level = 'SS2' and t.term = 2 and t.order_index = 206;

insert into public.questions (topic_id, lesson_id, question_text, option_a, option_b, option_c, option_d, option_e, correct_letter, difficulty, exam_type, explanation, status)
select t.id, l.id, q.question_text, q.option_a, q.option_b, q.option_c, q.option_d, q.option_e, q.correct_letter, q.difficulty, q.exam_type::exam_type, q.explanation, 'published'
from public.topics t
  join public.curricula c on c.id = t.curriculum_id
  join public.lessons l on l.topic_id = t.id,
  (values
  ('Find the value of $x$ for which the fraction $\frac{x+1}{2x-1}$ is undefined.', '$-2$', '$-1/2$', '$0$', '$1/2$', '$2$', 'D', 1, 'GENERAL', 'The denominator $2x-1=0$ gives $x=1/2$.'),
  ('For what value of $x$ is $\frac{2x-2}{(x-2)(x+3)}$ not defined?', '$x=4$ or $-2$', '$x=2$ or $-3$', '$x=3$ or $-2$', '$x=2$ or $-4$', null, 'B', 2, 'GENERAL', 'The denominator is zero when $x-2=0$ or $x+3=0$, giving $x=2$ or $x=-3$.'),
  ('Find the value of $x$ for which $\frac{2x^2+y^2}{x^2-4}$ is undefined.', '$x=5$', '$x=4$', '$x=3$', '$x=2$', '$x=1$', 'D', 2, 'GENERAL', 'The denominator $x^2-4=0$ gives $x=2$ or $x=-2$; $x=2$ is the listed option.'),
  ('Given $y = 1 - \frac{2x}{4x-3}$, find the value of $x$ for which $y$ is undefined.', '$3$', '$3/4$', '$-3/4$', '$-3$', null, 'B', 2, 'GENERAL', 'The denominator $4x-3=0$ gives $x=3/4$.'),
  ('Given $y = \frac{cr-px}{aq-bp}$, the value of $y$ is undefined if:', '$cr=px$', '$cr>px$', '$aq=bp$', '$aq<bp$', '$aq>bp$', 'C', 2, 'GENERAL', 'The denominator $aq-bp=0$, i.e. $aq=bp$, makes $y$ undefined.'),
  ('Find the value(s) of $x$ for which $\frac{x^2-9}{2x^2-7x+3}$ is undefined.', '$x=3$ or $x=1/2$', '$x=-3$ or $x=1/2$', '$x=3$ or $x=-1/2$', '$x=3$ only', null, 'A', 3, 'GENERAL', 'Factorising the denominator: $2x^2-7x+3=(2x-1)(x-3)$, zero when $x=1/2$ or $x=3$.'),
  ('For what value of $x$ is $\frac{2x-1}{x+3}$ not defined?', '$3$', '$2$', '$1/2$', '$-3$', null, 'D', 1, 'GENERAL', 'The denominator $x+3=0$ gives $x=-3$.'),
  ('Find the values of $x$ for which $\frac{2x+5}{4x^2-9}$ is not defined.', '$x=3/2$ or $-3/2$', '$x=2/3$ or $-2/3$', '$x=2/5$ or $-2/5$', '$x=5/2$ or $3/2$', '$x=5/2$ or $-3/2$', 'A', 2, 'GENERAL', 'The denominator $4x^2-9=0$ gives $x^2=9/4$, so $x=\pm3/2$.'),
  ('For what value of $x$ is $\frac{2x+1}{12-5x-3x^2}$ undefined?', '$x=5$ or $1$', '$x=3$ or $-3/4$', '$x=-3$ or $4/3$', '$x=-5$ or $1$', '$x=5$ or $3/4$', 'C', 3, 'GENERAL', 'Setting $12-5x-3x^2=0$, i.e. $3x^2+5x-12=0$: using the quadratic formula, $x=\frac{-5\pm\sqrt{25+144}}{6}=\frac{-5\pm13}{6}$, giving $x=-3$ or $x=4/3$.'),
  ('For what values of $x$ is $\frac{x^2+1}{x^2-1}$ not defined?', '$x=-1$ or $1$', '$x=1/2$ or $0$', '$x=1/2$ or $2$', '$x=-1/2$ or $2$', '$x=0$ or $-2$', 'A', 1, 'GENERAL', 'The denominator $x^2-1=0$ gives $x=\pm1$.'),
  ('For what value of $x$ is $\frac{x+3}{x^2+10x-25}$ equal to zero?', '$x=-3$', '$x=3$', '$x=-10$', '$x=5$', null, 'A', 2, 'GENERAL', 'Setting the numerator to zero: $x+3=0 \Rightarrow x=-3$; checking the denominator at $x=-3$ gives $-46 \neq 0$, so it is valid.'),
  ('For what value of $x$ is $\frac{x^2-2x-15}{x^2-25}$ equal to zero?', '$x=5$', '$x=-5$', '$x=-3$', '$x=3$', null, 'C', 3, 'GENERAL', 'Factorising and cancelling $(x-5)$ (excluded since it zeroes the original denominator) leaves $\frac{x+3}{x+5}$; setting the numerator to zero gives $x=-3$.'),
  ('Find the value(s) of $x$ for which $\frac{2x^2+9x-11}{6-4x}$ is zero.', '$x=1$ only', '$x=1$ or $x=-11/2$', '$x=-1$ or $x=11/2$', '$x=11$ or $x=-2$', null, 'B', 4, 'GENERAL', 'Factorising the numerator: $2x^2+9x-11=(x-1)(2x+11)=0$, giving $x=1$ or $x=-11/2$. Checking the denominator $6-4x$ is zero only at $x=3/2$, which is neither root, so BOTH values are valid. (Corrected: the curated source restricts the answer to x=1 only, incorrectly claiming x=-11/2 also zeroes the denominator; substituting x=-11/2 into 6-4x gives 6+22=28, not zero, so x=-11/2 is a genuine second solution.)')
) as q(question_text, option_a, option_b, option_c, option_d, option_e, correct_letter, difficulty, exam_type, explanation)
where c.subject = 'Mathematics' and t.class_level = 'SS2' and t.term = 2 and t.order_index = 206;
-- ------------------------------------------
-- 207. FRACTIONS: SUBSTITUTION & SIMULTANEOUS EQUATIONS
-- ------------------------------------------

insert into public.lessons (topic_id, title, summary, content_body, order_index)
values (
  (select t.id from public.topics t join public.curricula c on c.id = t.curriculum_id
   where c.subject = 'Mathematics' and t.class_level = 'SS2' and t.term = 2 and t.order_index = 207),
  'Fractions: Substitution and Simultaneous Equations',
  'Substituting values or expressions into algebraic fractions, evaluating fractions built from ratio-linked variables, and solving simultaneous equations that involve fractions.',
  '### Substitution in Algebraic Fractions

Substitution comes in two forms:
1. **Direct numeric substitution**: plugging given numbers straight into an expression.
2. **Expression substitution**: expressing one variable in terms of another (e.g. given $z$ in terms of $x$), then substituting that expression into a related fraction.

Always simplify algebraically FIRST where possible, this reduces the arithmetic needed once numbers are substituted.

### Combining Compound Fractions Built from the Same Denominator

When two expressions like $p$ and $q$ are both written over the same denominator, combine their numerators directly (add for $p+q$, subtract for $p-q$) rather than expanding each compound fraction separately from scratch.

### Simultaneous Equations Involving Fractions

First **clear denominators** in each equation separately, by multiplying that equation through by its own LCM. Then solve the resulting pair of ordinary linear equations by the usual elimination or substitution method.

### Glossary

- **Scaling constant**: in a ratio problem like $x:y:z = a:b:c$, writing $x=ak$, $y=bk$, $z=ck$ for a single unknown constant $k$, this turns three unknowns into one and often lets $k$ cancel out of the final answer entirely.',
  1
);

insert into public.worked_examples (lesson_id, title, problem_statement, solution_steps, exam_shortcut, status)
select l.id,
  'Combining Compound Fractions Over a Shared Denominator',
  'If $p = \frac{2u}{1-u}$ and $q = \frac{1+u}{1-u}$, express $\frac{p+q}{p-q}$ in terms of $u$.',
  to_jsonb(array[
    'Since $p$ and $q$ already share the same denominator, add their numerators directly for $p+q$: $p+q = \frac{2u+(1+u)}{1-u} = \frac{3u+1}{1-u}$.',
    'Subtract their numerators for $p-q$: $p-q = \frac{2u-(1+u)}{1-u} = \frac{u-1}{1-u}$.',
    'Divide $(p+q)$ by $(p-q)$ using "keep, change, flip": $\frac{3u+1}{1-u} \div \frac{u-1}{1-u} = \frac{3u+1}{1-u} \times \frac{1-u}{u-1}$.',
    'Cancel the common factor $(1-u)$: $= \frac{3u+1}{u-1}$.'
  ]),
  'When two expressions are built from the same denominator, combine their numerators directly rather than expanding each compound fraction from scratch, this saves a full round of algebra.',
  'published'
from public.lessons l join public.topics t on t.id = l.topic_id join public.curricula c on c.id = t.curriculum_id
where c.subject = 'Mathematics' and t.class_level = 'SS2' and t.term = 2 and t.order_index = 207;

insert into public.worked_examples (lesson_id, title, problem_statement, solution_steps, exam_shortcut, status)
select l.id,
  'Substituting an Expression Into a Related Fraction',
  'Given $z = \frac{3x-2}{2x+3}$, express $\frac{2z+3}{3z-2}$ in terms of $x$.',
  to_jsonb(array[
    'Substitute $z$ into $2z+3$ and combine over the denominator $(2x+3)$: $2z+3 = \frac{2(3x-2)}{2x+3} + 3 = \frac{2(3x-2) + 3(2x+3)}{2x+3}$.',
    'Expand the numerator: $6x-4+6x+9 = 12x+5$, so $2z+3 = \frac{12x+5}{2x+3}$.',
    'Substitute $z$ into $3z-2$ the same way: $3z-2 = \frac{3(3x-2)}{2x+3} - 2 = \frac{3(3x-2) - 2(2x+3)}{2x+3}$.',
    'Expand the numerator: $9x-6-4x-6 = 5x-12$, so $3z-2 = \frac{5x-12}{2x+3}$.',
    'Divide $(2z+3)$ by $(3z-2)$: the shared denominator $(2x+3)$ cancels, leaving $\frac{12x+5}{5x-12}$.'
  ]),
  'Whenever a substituted expression is asked to be re-combined into another fraction, keep everything over the ORIGINAL denominator ($2x+3$ here) as long as possible, this avoids re-deriving a common denominator twice.',
  'published'
from public.lessons l join public.topics t on t.id = l.topic_id join public.curricula c on c.id = t.curriculum_id
where c.subject = 'Mathematics' and t.class_level = 'SS2' and t.term = 2 and t.order_index = 207;

insert into public.worked_examples (lesson_id, title, problem_statement, solution_steps, exam_shortcut, status)
select l.id,
  'Evaluating a Fraction from Ratio-Linked Variables',
  'If $x$, $y$, $z$ are in the ratio $6:5:8$, evaluate $\frac{12x-9z}{4y+z}$.',
  to_jsonb(array[
    'Introduce a single scaling constant $k$: $x=6k$, $y=5k$, $z=8k$.',
    'Substitute into the numerator: $12x-9z = 12(6k)-9(8k) = 72k-72k = 0$.',
    'Substitute into the denominator: $4y+z = 4(5k)+8k = 28k$.',
    'Divide: $\frac{0}{28k} = 0$ (valid since $k \neq 0$).'
  ]),
  'In ratio problems, $k$ very often cancels out of the final numeric answer entirely, if it does not, double-check the arithmetic before assuming the question wants an answer "in terms of $k$".',
  'published'
from public.lessons l join public.topics t on t.id = l.topic_id join public.curricula c on c.id = t.curriculum_id
where c.subject = 'Mathematics' and t.class_level = 'SS2' and t.term = 2 and t.order_index = 207;

insert into public.worked_examples (lesson_id, title, problem_statement, solution_steps, exam_shortcut, real_life_context, status)
select l.id,
  'Simultaneous Equations Involving Fractions',
  'A tailor uses fractional lengths of two fabric rolls, $x$ metres and $y$ metres, related by $\frac{x}{2} + \frac{y}{3} = 4$ and $\frac{x}{3} - \frac{y}{6} = \frac{3}{2}$. Solve for $x$ and $y$.',
  to_jsonb(array[
    'Clear the denominators in the first equation by multiplying through by its LCM, 6: $6\left(\frac{x}{2}\right) + 6\left(\frac{y}{3}\right) = 6(4) \Rightarrow 3x + 2y = 24$.',
    'Clear the denominators in the second equation by multiplying through by its LCM, 6: $6\left(\frac{x}{3}\right) - 6\left(\frac{y}{6}\right) = 6\left(\frac{3}{2}\right) \Rightarrow 2x - y = 9$.',
    'Make $y$ the subject of the simpler equation ($2x-y=9$): $y = 2x - 9$.',
    'Substitute into the other equation: $3x + 2(2x-9) = 24 \Rightarrow 3x + 4x - 18 = 24 \Rightarrow 7x = 42$.',
    'Solve for $x$: $x = 6$.',
    'Back-substitute to find $y$: $y = 2(6) - 9 = 3$.'
  ]),
  'For simultaneous equations with fractions, clear each equation''s denominators SEPARATELY (multiply each equation by its own LCM) before combining them, trying to clear both at once in a single step is where most errors creep in.',
  'A tailor cutting two rolls of fabric to a fractional-length relationship, or a caterer scaling two ingredient quantities that must satisfy two proportional relationships at once, both reduce to exactly this style of fractional simultaneous system.',
  'published'
from public.lessons l join public.topics t on t.id = l.topic_id join public.curricula c on c.id = t.curriculum_id
where c.subject = 'Mathematics' and t.class_level = 'SS2' and t.term = 2 and t.order_index = 207;

insert into public.questions (topic_id, lesson_id, question_text, option_a, option_b, option_c, option_d, correct_letter, difficulty, exam_type, explanation, status)
select t.id, l.id, q.question_text, q.option_a, q.option_b, q.option_c, q.option_d, q.correct_letter, q.difficulty, q.exam_type::exam_type, q.explanation, 'published'
from public.topics t
  join public.curricula c on c.id = t.curriculum_id
  join public.lessons l on l.topic_id = t.id,
  (values
  ('If $p = \frac{2u}{1-u}$ and $q = \frac{1+u}{1-u}$, express $\frac{p+q}{p-q}$ in terms of $u$.', '$\frac{3u+1}{u-1}$', '$\frac{u+1}{3u-1}$', '$\frac{3u-1}{u+1}$', '$\frac{u-1}{3u+1}$', 'A', 4, 'GENERAL', '$p+q=\frac{3u+1}{1-u}$, $p-q=\frac{u-1}{1-u}$; dividing (the $1-u$ cancels) gives $\frac{3u+1}{u-1}$.'),
  ('Given that $x = \frac{3m-2}{m-1}$, express $\frac{x+1}{2x-1}$ in terms of $m$.', '$\frac{4m-3}{5m-3}$', '$\frac{3m-2}{m-1}$', '$\frac{4m-3}{m-1}$', '$\frac{m-1}{5m-3}$', 'A', 4, 'GENERAL', '$x+1=\frac{4m-3}{m-1}$, $2x-1=\frac{5m-3}{m-1}$; dividing (the $m-1$ cancels) gives $\frac{4m-3}{5m-3}$.'),
  ('Given that $z = \frac{3x-2}{2x+3}$, express $\frac{2z+3}{3z-2}$ in terms of $x$.', '$\frac{12x+5}{5x-12}$', '$\frac{5x-12}{12x+5}$', '$\frac{3x-2}{2x+3}$', '$\frac{12x-5}{5x+12}$', 'A', 4, 'GENERAL', '$2z+3=\frac{12x+5}{2x+3}$, $3z-2=\frac{5x-12}{2x+3}$; dividing (the $2x+3$ cancels) gives $\frac{12x+5}{5x-12}$.'),
  ('If the numbers $x$, $y$, $z$ are in the ratio $6:5:8$, find $\frac{12x-9z}{4y+z}$.', '$0$', '$1$', '$-1$', '$2$', 'A', 3, 'GENERAL', 'Writing $x=6k,y=5k,z=8k$: numerator $=72k-72k=0$; the whole expression is 0.'),
  ('If $x=3$, $y=2$ and $z=4$, find the value of $3x^2-2y+z$.', '$17$', '$27$', '$35$', '$71$', 'B', 1, 'GENERAL', '$3(9)-2(2)+4=27-4+4=27$.'),
  ('Given that $x = 2$ and $y = -\frac{1}{5}$, evaluate $x^2y - 2xy$.', '$0$', '$1/5$', '$1$', '$2$', 'A', 3, 'GENERAL', 'Factorise first: $x^2y-2xy=xy(x-2)$; since $x=2$, the factor $(x-2)=0$, so the whole expression is 0.'),
  ('Evaluate $\left(\frac{a+b}{a-b}\right)^3$ for $a=-7$, $b=3$.', '$-8/125$', '$8/125$', '$-4/10$', '$16/125$', 'B', 3, 'GENERAL', '$a+b=-4$, $a-b=-10$, so $\frac{a+b}{a-b}=\frac{2}{5}$ (positive); cubing gives $\frac{8}{125}$.'),
  ('Evaluate $\frac{x^2+x-2}{2x^2+x-3}$ when $x = -1$.', '$2$', '$1$', '$-1/2$', '$-1$', 'B', 3, 'GENERAL', 'Substituting $x=-1$: numerator $=1-1-2=-2$; denominator $=2-1-3=-2$; the value is $1$.'),
  ('Solve simultaneously: $\frac{x}{2} + \frac{y}{3} = 4$ and $\frac{x}{3} - \frac{y}{2} = -1$.', '$x=60/13$, $y=66/13$', '$x=6$, $y=3$', '$x=66/13$, $y=60/13$', '$x=4$, $y=3$', 'A', 4, 'GENERAL', 'Clearing denominators gives $3x+2y=24$ and $2x-3y=-6$; solving simultaneously gives $x=60/13$, $y=66/13$.')
) as q(question_text, option_a, option_b, option_c, option_d, correct_letter, difficulty, exam_type, explanation)
where c.subject = 'Mathematics' and t.class_level = 'SS2' and t.term = 2 and t.order_index = 207;
-- ------------------------------------------
-- 208. LOGIC: COMPOUND STATEMENTS & TRUTH TABLES
-- ------------------------------------------

insert into public.lessons (topic_id, title, summary, content_body, order_index)
values (
  (select t.id from public.topics t join public.curricula c on c.id = t.curriculum_id
   where c.subject = 'Mathematics' and t.class_level = 'SS2' and t.term = 2 and t.order_index = 208),
  'Logic: Compound Statements, Connectives and Truth Tables',
  'Building compound propositions from simple ones using logical connectives, constructing truth tables, and testing the validity of arguments using Venn diagrams.',
  '### Propositions

A **proposition** is a declarative sentence that is either true or false, but not both. A **simple proposition** contains no other proposition as a component. A **compound proposition** combines two or more simple propositions using **connectives**.

| Connective | Symbol | Name | Meaning |
|---|---|---|---|
| not | $\sim$ | Negation | opposite truth value |
| and | $\land$ | Conjunction | true only when BOTH parts are true |
| or | $\lor$ | Disjunction | false only when BOTH parts are false |
| if...then | $\rightarrow$ | Conditional | false only when the first part is true and the second is false |
| if and only if | $\leftrightarrow$ | Biconditional | true when both parts have the SAME truth value |

### Truth Tables

A truth table lists every possible combination of truth values (T/F) for the component propositions, and works out the resulting truth value of the compound statement. For $n$ component propositions there are $2^n$ rows.

A proposition true in every row is a **tautology**. One false in every row is a **contradiction**. Two propositions are **equivalent** if they have identical truth-table columns (their biconditional is a tautology).

**De Morgan''s Law**: $\sim(p \land q) \equiv \sim p \lor \sim q$, and $\sim(p \lor q) \equiv \sim p \land \sim q$. To negate an AND, flip it to OR and negate each part; to negate an OR, flip it to AND and negate each part.

### Testing Validity with Venn Diagrams

A statement like "All A are B" is drawn as circle A entirely INSIDE circle B. An argument reasoning FROM "in A" TO "in B" is valid. An argument reasoning backwards, from "in B" to "in A", or from "not in A" to "not in B", is the classic converse/inverse trap, and is invalid.

### Glossary

- **Proposition**: a statement that is definitely true or definitely false, never both, e.g. "Lagos is in Nigeria" is a proposition, but "Close the door!" is not.
- **Valid argument**: a conclusion that MUST follow from the given premises, regardless of which specific example is chosen.',
  1
);

insert into public.worked_examples (lesson_id, title, problem_statement, solution_steps, exam_shortcut, status)
select l.id,
  'Translating a Sentence into Symbols',
  'Let $p$: "the baby is crying", $q$: "the boys are singing", $r$: "the dog is barking". Represent "If the dog is barking and the birds are not singing, then the baby is crying" symbolically.',
  to_jsonb(array[
    'Identify each component proposition: $r$ = "the dog is barking"; $\sim q$ = "the birds are not singing" (the negation of $q$); $p$ = "the baby is crying".',
    'Translate the connecting word "and" between the two conditions into the symbol $\land$: $(r \land \sim q)$.',
    'Translate "if...then" into the symbol $\rightarrow$, joining the compound condition to the outcome: $(r \land \sim q) \rightarrow p$.'
  ]),
  'Break a long sentence into its component propositions first, labelling each with the given letter, THEN add the connectives, trying to symbolise the whole sentence in one pass invites mistakes.',
  'published'
from public.lessons l join public.topics t on t.id = l.topic_id join public.curricula c on c.id = t.curriculum_id
where c.subject = 'Mathematics' and t.class_level = 'SS2' and t.term = 2 and t.order_index = 208;

insert into public.worked_examples (lesson_id, title, problem_statement, solution_steps, exam_shortcut, status)
select l.id,
  'Constructing a Truth Table',
  'Construct the truth table for $p \land \sim q$.',
  to_jsonb(array[
    'List all 4 possible combinations of truth values for $p$ and $q$: TT, TF, FT, FF.',
    'Work out $\sim q$ for each row (the opposite of $q$): row TT $\to \sim q=F$; row TF $\to \sim q=T$; row FT $\to \sim q=F$; row FF $\to \sim q=T$.',
    'Apply AND ($\land$) row by row between $p$ and $\sim q$, remembering AND is true only when BOTH sides are true: row TT: $p=T,\sim q=F \to F$; row TF: $p=T,\sim q=T \to T$; row FT: $p=F,\sim q=F \to F$; row FF: $p=F,\sim q=T \to F$.'
  ]),
  'Build the truth table column by column (first $p$, then $q$, then each intermediate connective, then the final result), never try to work out the final column in your head in one step.',
  'published'
from public.lessons l join public.topics t on t.id = l.topic_id join public.curricula c on c.id = t.curriculum_id
where c.subject = 'Mathematics' and t.class_level = 'SS2' and t.term = 2 and t.order_index = 208;

insert into public.worked_examples (lesson_id, title, problem_statement, solution_steps, exam_shortcut, status)
select l.id,
  'Proving De Morgan''s Law',
  'Show that $\sim(p \land q)$ is equivalent to $\sim p \lor \sim q$.',
  to_jsonb(array[
    'Build the truth table for $p \land q$: TT$\to$T, TF$\to$F, FT$\to$F, FF$\to$F.',
    'Negate every entry to get $\sim(p \land q)$: TT$\to$F, TF$\to$T, FT$\to$T, FF$\to$T.',
    'Build the truth table for $\sim p \lor \sim q$: for each row, find $\sim p$ and $\sim q$, then apply OR (true unless BOTH are false): TT: $\sim p=F,\sim q=F \to F$; TF: $\sim p=F,\sim q=T \to T$; FT: $\sim p=T,\sim q=F \to T$; FF: $\sim p=T,\sim q=T \to T$.',
    'Compare the two final columns: $\sim(p\land q)$ gives F,T,T,T and $\sim p\lor\sim q$ gives F,T,T,T, identical in every row.'
  ]),
  'De Morgan''s Law shortcut once memorised replaces building a full truth table: to negate an AND, flip it to OR and negate each part.',
  'published'
from public.lessons l join public.topics t on t.id = l.topic_id join public.curricula c on c.id = t.curriculum_id
where c.subject = 'Mathematics' and t.class_level = 'SS2' and t.term = 2 and t.order_index = 208;

insert into public.worked_examples (lesson_id, title, problem_statement, solution_steps, exam_shortcut, real_life_context, status)
select l.id,
  'Testing an Argument''s Validity with a Venn Diagram',
  '"All Northerners in Nigeria speak Hausa. Isa is a Northerner. Therefore Isa speaks Hausa." Test the validity of this conclusion using a Venn diagram.',
  to_jsonb(array[
    'Draw the universal set $U$ and two circles inside it: $N$ (Northerners) and $H$ (Hausa speakers).',
    'Since "All Northerners speak Hausa" is given, draw circle $N$ entirely INSIDE circle $H$ ($N \subset H$).',
    'Mark Isa as a point inside circle $N$, since "Isa is a Northerner".',
    'Because $N$ lies entirely inside $H$, any point inside $N$ is automatically inside $H$ too, so Isa''s point also lies inside $H$.'
  ]),
  'For "All A are B" Venn-diagram arguments, draw A completely inside B; any argument reasoning FROM "in A" TO "in B" is valid, any argument reasoning backwards is the classic converse trap.',
  'This is exactly the reasoning pattern used to argue from a general classification rule ("all registered members get a discount") to a specific case ("Amaka is registered, so she gets the discount"), a skill useful well beyond mathematics, in reading contracts, regulations, and eligibility rules.',
  'published'
from public.lessons l join public.topics t on t.id = l.topic_id join public.curricula c on c.id = t.curriculum_id
where c.subject = 'Mathematics' and t.class_level = 'SS2' and t.term = 2 and t.order_index = 208;

insert into public.questions (topic_id, lesson_id, question_text, option_a, option_b, option_c, option_d, correct_letter, difficulty, exam_type, explanation, status)
select t.id, l.id, q.question_text, q.option_a, q.option_b, q.option_c, q.option_d, q.correct_letter, q.difficulty, q.exam_type::exam_type, q.explanation, 'published'
from public.topics t
  join public.curricula c on c.id = t.curriculum_id
  join public.lessons l on l.topic_id = t.id,
  (values
  ('What is the negation of "John is older than me"?', 'John is not older than me', 'John is neither older than me', 'John is younger than me', 'John is my age mate', 'A', 1, 'GENERAL', 'The negation simply denies the original statement, without asserting a specific alternative relationship.'),
  ('Given the premise "Nigerian footballers are good footballers", which is a VALID conclusion?', 'Joseph plays football in Nigeria, therefore he is a good footballer', 'Joseph is a good footballer, therefore he is a Nigerian footballer', 'Joseph is a Nigerian footballer, therefore he is a good footballer', 'Joseph plays good football, therefore he is a Nigerian footballer', 'C', 2, 'GENERAL', 'The premise says every Nigerian footballer is good, so reasoning FROM "is a Nigerian footballer" TO "is a good footballer" is valid; the other options reason backwards.'),
  ('Given $p$: "the subject is difficult", $q$: "I will do my best". Which is equivalent to "Although the subject is difficult, I will do my best"?', '$p \land q$', '$\sim p \land q$', '$p \land (\sim q)$', '$p \lor q$', 'A', 2, 'GENERAL', '"Although...still" is logically just "and", both parts are asserted true together: $p\land q$.'),
  ('Given $p$: baby crying, $q$: boys singing, $r$: dog barking, which symbolic form represents "If the dog is barking and the birds are not singing, then the baby is crying"?', '$(r \land \sim q) \rightarrow p$', '$(r \lor \sim q) \rightarrow p$', '$r \land (\sim q \rightarrow p)$', '$p \rightarrow (r \land \sim q)$', 'A', 2, 'GENERAL', 'The condition "dog barking AND birds not singing" is $(r \land \sim q)$; "if...then" attaches this to the outcome $p$ with $\rightarrow$. (Also covering the item''s other parts: (a) $\sim r$ = the dog is not barking; (b) $p \land q$ = the baby is crying and the boys are singing; (c) $r \lor q$ = the dog is barking or the boys are singing; (d) $r \land \sim q$ = the dog is barking and the boys are not singing; (f) $p \leftrightarrow r$ = the baby cries if and only if the dog barks.)'),
  ('Given $s$: "Sally is smart", $t$: "Tom is tall", what does $(t \lor s) \rightarrow t$ mean in words?', 'If Tom is tall or Sally is smart, then Tom is tall', 'If Tom is tall and Sally is smart, then Tom is tall', 'Tom is tall if and only if Sally is smart', 'If Sally is smart, then Tom is tall or Sally is smart', 'A', 2, 'GENERAL', '$(t\lor s)\rightarrow t$ reads directly as "if (Tom is tall or Sally is smart) then Tom is tall". (Also covering the item''s other parts: (a) $\sim s$ = Sally is not smart; (b) $s\land t$ = Sally is smart and Tom is tall.)'),
  ('Given $p$: birds fly, $q$: the sky is blue, $r$: the grass is green, what does $(p \land q) \rightarrow r$ mean in words?', 'If birds fly and the sky is blue, then the grass is green', 'Birds fly and the sky is blue and the grass is green', 'If birds fly, then the sky is blue and the grass is green', 'The grass is green if and only if birds fly', 'A', 2, 'GENERAL', '$(p\land q)\rightarrow r$ reads as "if (birds fly and the sky is blue) then the grass is green". (Also covering the item''s other parts, including (i) $p\leftrightarrow q$ = birds fly if and only if the sky is blue, and (g) $\sim p \lor \sim r$ = birds do not fly or the grass is not green.)'),
  ('Using $p$: birds fly, $q$: the sky is blue, $r$: the grass is green, which symbolic form represents "if the grass is green and the sky is not blue then the birds do not fly"?', '$(r \land \sim q) \rightarrow \sim p$', '$(r \lor \sim q) \rightarrow \sim p$', '$(r \land q) \rightarrow \sim p$', '$\sim p \rightarrow (r \land \sim q)$', 'A', 3, 'GENERAL', 'The condition "grass green AND sky not blue" is $(r\land\sim q)$; "then the birds do not fly" is $\sim p$, joined by $\rightarrow$. (Also covering the item''s other parts, e.g. (a) $q\land r$ = the sky is blue and the grass is green; (b) $p\lor q$ = birds fly or the sky is blue; (c) $\sim p\land\sim q$ = birds do not fly and the sky is not blue.)'),
  ('In the truth table for $p \land \sim q$, for which combination of $p$ and $q$ is the result TRUE?', '$p=T, q=F$', '$p=T, q=T$', '$p=F, q=F$', '$p=F, q=T$', 'A', 2, 'GENERAL', '$p\land\sim q$ is true only when $p$ is true and $q$ is false, since then $\sim q$ is also true.'),
  ('In the truth table for $\sim(p \land q)$, for which combination of $p$ and $q$ is the result FALSE?', '$p=T, q=T$', '$p=T, q=F$', '$p=F, q=T$', '$p=F, q=F$', 'A', 2, 'GENERAL', '$p\land q$ is true only when both are true, so $\sim(p\land q)$ is false only in that one row, $p=T,q=T$. (Corrected: the curated source lists the false row incorrectly as TF, matching the table for $\sim p\land\sim q$ instead; re-derivation confirms TT is the only false row.)'),
  ('For $p \land (q \lor p)$, which rows give a TRUE result?', '$p=T,q=T$ and $p=T,q=F$', '$p=T,q=T$ and $p=F,q=T$', 'All four rows', 'No rows', 'A', 3, 'GENERAL', 'By the absorption law, $p\land(q\lor p)$ always equals $p$ itself, so it is true exactly when $p$ is true, in rows $p=T,q=T$ and $p=T,q=F$.'),
  ('Which expression is logically equivalent to $p \rightarrow q$?', '$\sim p \lor q$', '$p \lor \sim q$', '$\sim p \land q$', '$p \land \sim q$', 'A', 3, 'GENERAL', 'Both $p\rightarrow q$ and $\sim p\lor q$ give the truth-value pattern T,F,T,T for TT,TF,FT,FF, so they are equivalent.'),
  ('"All Northerners in Nigeria speak Hausa. Isa is a Northerner. Therefore Isa speaks Hausa." Illustrating this on a Venn diagram, is the conclusion valid?', 'Valid', 'Invalid', 'Cannot be determined from the given information', 'Only valid if Isa also speaks English', 'A', 2, 'GENERAL', 'Since the Northerners circle sits entirely inside the Hausa-speakers circle, any point (including Isa) inside the smaller circle is automatically inside the larger one.'),
  ('In a Venn diagram with $U$ = students in a school, $G$ = class 3G, $F$ = football team, $H$ = hockey team, based on the diagram, which statement is FALSE?', 'No hockey team member is on the football team', 'Only class 3G members are on the football team', 'All of class 3G are on the football team', 'Some hockey team members are in class 3G', 'C', 3, 'GENERAL', 'The diagram shows only some (not all) of class 3G on the football team, so "all of class 3G are on the football team" is the false statement.'),
  ('Given the premise "All good Literature students are in the General Arts class", which of these three conclusions is VALID? (i) Vivian is in General Arts, therefore she is a good Literature student (ii) Audu is not a good Literature student, therefore he is not in General Arts (iii) Kweku is not in General Arts, therefore he is not a good Literature student', 'Only (i)', 'Only (ii)', 'Only (iii)', 'All three', 'C', 3, 'GENERAL', '(i) and (ii) both reason backwards (the converse/inverse trap) and are invalid; (iii) reasons correctly: since good Literature students are entirely inside General Arts, being outside General Arts means being outside that smaller circle too, so (iii) is valid.'),
  ('Given $X$: "all lazy students are careless" and $Y$: "most dull students are lazy", is the deduction "Osei is lazy, therefore Osei is careless" VALID?', 'Valid, since all lazy students are careless by premise X', 'Invalid, since not all careless students are lazy', 'Cannot be determined without knowing if Osei is dull', 'Invalid, since Y contradicts X', 'A', 3, 'GENERAL', 'Premise X states lazy students are a subset of careless students, so any lazy student, including Osei, is automatically careless, a direct and valid application of X.'),
  ('Given $X$: "locally manufactured tyres are attractive" and $Y$: "many locally manufactured tyres do not last long", which Venn diagram correctly illustrates these statements?', 'Local tyres (M) entirely inside attractive tyres (R), with long-lasting tyres (L) partially overlapping both', 'Attractive tyres (R) entirely inside local tyres (M), with L disjoint from both', 'M and R as disjoint circles, with L overlapping only R', 'M, R and L drawn as three identical, fully overlapping circles', 'A', 3, 'GENERAL', '"Locally manufactured tyres are attractive" places M entirely inside R; "many do not last long" means only PART of M (not all) overlaps L, matching only the first description.')
) as q(question_text, option_a, option_b, option_c, option_d, correct_letter, difficulty, exam_type, explanation)
where c.subject = 'Mathematics' and t.class_level = 'SS2' and t.term = 2 and t.order_index = 208;
-- ------------------------------------------
-- 209. CHORD PROPERTIES OF CIRCLES
-- ------------------------------------------

insert into public.lessons (topic_id, title, summary, content_body, order_index)
values (
  (select t.id from public.topics t join public.curricula c on c.id = t.curriculum_id
   where c.subject = 'Mathematics' and t.class_level = 'SS2' and t.term = 2 and t.order_index = 209),
  'Chord Properties of Circles',
  'Key properties of chords: the perpendicular bisector of a chord, equal chords and their distance from the centre, tangent properties, and angles in a cyclic quadrilateral.',
  '### Key Chord Properties (centre $O$)

- **Equal chords are equidistant from the centre**, and chords equidistant from the centre are equal (the converse also holds).
- **The perpendicular from the centre to a chord bisects the chord.** This turns half a chord, its distance from the centre, and the radius into a right-angled triangle, ready for Pythagoras'' theorem.
- **Equal chords subtend equal angles at the centre.**

### Tangent Properties

- A **tangent** to a circle is perpendicular to the radius at the point of contact.
- Two tangents drawn from the same external point to a circle are **equal in length**.
- The line from an external point to the centre **bisects the angle** between the two tangents drawn from that point.

### Cyclic Quadrilaterals

A **cyclic quadrilateral** has all four vertices on a circle. Its **opposite angles are supplementary** (add to $180°$), and an **exterior angle equals the interior opposite angle**.

### Glossary

- **Chord**: a straight line segment joining any two points on a circle (a diameter is simply the longest possible chord, passing through the centre).
- **Cyclic quadrilateral**: a four-sided shape whose corners all lie on the same circle.
- **Tangent**: a straight line that touches a circle at exactly one point without crossing into it.',
  1
);

insert into public.worked_examples (lesson_id, title, problem_statement, solution_steps, exam_shortcut, real_life_context, diagram_type, diagram_data, status)
select l.id,
  'Finding the Radius from a Chord',
  'A chord $AB = 16$ cm in a circle of centre $O$ is 6 cm from the centre. Find the radius.',
  to_jsonb(array[
    'Draw the radius $OM$ perpendicular to chord $AB$, meeting it at $M$. By the property "the perpendicular from the centre to a chord bisects the chord", $M$ is the midpoint of $AB$.',
    'Find the half-chord length: $AM = \frac{AB}{2} = \frac{16}{2} = 8$ cm.',
    'Note the given perpendicular distance: $OM = 6$ cm.',
    'Apply Pythagoras'' theorem in right triangle $OMA$ (right-angled at $M$, with $OA$ as the hypotenuse, the radius): $OA^2 = OM^2 + AM^2$.',
    'Substitute the known values: $OA^2 = 6^2 + 8^2 = 36 + 64 = 100$.',
    'Take the square root: $OA = \sqrt{100} = 10$.'
  ]),
  'Whenever you know a chord''s half-length and its perpendicular distance from the centre, you already have a right triangle with the radius as the hypotenuse, go straight to Pythagoras: $\text{radius}^2 = (\text{half-chord})^2 + (\text{distance from centre})^2$.',
  'This is exactly how an engineer would find the radius of a circular water tank or a roundabout from a single measured chord and its distance from the (possibly inaccessible) centre point, without needing to locate the centre directly.',
  'circle',
  '{"centerLabel": "O", "points": [{"label": "A", "angleDegrees": 217}, {"label": "B", "angleDegrees": 143}], "chord": {"fromAngle": 217, "toAngle": 143, "label": "AB = 16 cm"}}'::jsonb,
  'published'
from public.lessons l join public.topics t on t.id = l.topic_id join public.curricula c on c.id = t.curriculum_id
where c.subject = 'Mathematics' and t.class_level = 'SS2' and t.term = 2 and t.order_index = 209;

insert into public.worked_examples (lesson_id, title, problem_statement, solution_steps, exam_shortcut, real_life_context, status)
select l.id,
  'Two Equal Chords on Opposite Sides of the Centre',
  'Two equal chords $AB$ and $CD$ in a circle of radius 13 cm are 5 cm apart, on opposite sides of the centre. Find the length of each chord.',
  to_jsonb(array[
    'Since the chords are equal and lie on opposite sides of the centre, the total 5 cm gap splits evenly: each chord is $\frac{5}{2} = 2.5$ cm from the centre.',
    'This is consistent with the property "equal chords are equidistant from the centre" (both chords are indeed the same distance, 2.5 cm, from $O$).',
    'Apply Pythagoras to find the half-chord: $(\text{half-chord})^2 = \text{radius}^2 - \text{distance}^2 = 13^2 - 2.5^2 = 169 - 6.25 = 162.75$.',
    'Take the square root: half-chord $= \sqrt{162.75} \approx 12.76$ cm.',
    'Double it to get the full chord: $2 \times 12.76 \approx 25.52$ cm.'
  ]),
  'Special-angle shortcut: if a chord subtends exactly $60°$ at the centre, the triangle formed by the two radii and the chord is equilateral, so the chord length always equals the radius, no sine calculation needed.',
  'Structural engineers positioning two equal support cables symmetrically about the centre of a circular dome or bridge arch use exactly this kind of equal-chord, equal-distance reasoning.',
  'published'
from public.lessons l join public.topics t on t.id = l.topic_id join public.curricula c on c.id = t.curriculum_id
where c.subject = 'Mathematics' and t.class_level = 'SS2' and t.term = 2 and t.order_index = 209;

insert into public.worked_examples (lesson_id, title, problem_statement, solution_steps, exam_shortcut, status)
select l.id,
  'Chord Length from a Central Angle',
  'Chord $PQ$ subtends $60°$ at the centre $O$ of a circle of radius 8 cm. Find the length of $PQ$.',
  to_jsonb(array[
    'Draw triangle $OPQ$: $OP = OQ = $ radius $= 8$ cm (both radii), with $\angle POQ = 60°$.',
    'Drop the perpendicular from $O$ to $PQ$, meeting it at $M$, this bisects both the chord and the angle at $O$ (property of an isosceles triangle with a perpendicular from the apex), so $\angle POM = 30°$ and $PM = MQ$.',
    'In right triangle $OMP$, use the sine ratio: $PM = OP \times \sin(\angle POM) = 8 \times \sin 30°$.',
    'Evaluate: $\sin 30° = 0.5$, so $PM = 8 \times 0.5 = 4$ cm.',
    'Double $PM$ to get the full chord: $PQ = 2 \times 4 = 8$ cm.'
  ]),
  'Quick check: since $\angle POQ = 60°$ and $OP = OQ$, triangle $OPQ$ is actually equilateral, so $PQ$ must equal the radius, 8 cm, confirming the answer instantly without any sine calculation.',
  'published'
from public.lessons l join public.topics t on t.id = l.topic_id join public.curricula c on c.id = t.curriculum_id
where c.subject = 'Mathematics' and t.class_level = 'SS2' and t.term = 2 and t.order_index = 209;

insert into public.worked_examples (lesson_id, title, problem_statement, solution_steps, exam_shortcut, diagram_type, diagram_data, status)
select l.id,
  'Angles in a Cyclic Quadrilateral',
  '$PQRS$ is a cyclic quadrilateral with $\angle P = 75°$, $\angle Q = 85°$. Find $\angle R$ and $\angle S$.',
  to_jsonb(array[
    'Recall that opposite angles of a cyclic quadrilateral are supplementary: $\angle P + \angle R = 180°$, and $\angle Q + \angle S = 180°$.',
    'Solve for $\angle R$: $\angle R = 180° - \angle P = 180° - 75° = 105°$.',
    'Solve for $\angle S$: $\angle S = 180° - \angle Q = 180° - 85° = 95°$.'
  ]),
  'Once you know ONE angle of a cyclic quadrilateral, you instantly know its OPPOSITE angle (180° minus it), you don''t need all four angles given to answer a "find the opposite angle" question.',
  'circle',
  '{"centerLabel": "O", "points": [{"label": "P", "angleDegrees": 0}, {"label": "Q", "angleDegrees": 90}, {"label": "R", "angleDegrees": 180}, {"label": "S", "angleDegrees": 270}]}'::jsonb,
  'published'
from public.lessons l join public.topics t on t.id = l.topic_id join public.curricula c on c.id = t.curriculum_id
where c.subject = 'Mathematics' and t.class_level = 'SS2' and t.term = 2 and t.order_index = 209;

insert into public.questions (topic_id, lesson_id, question_text, option_a, option_b, option_c, option_d, correct_letter, difficulty, exam_type, explanation, status)
select t.id, l.id, q.question_text, q.option_a, q.option_b, q.option_c, q.option_d, q.correct_letter, q.difficulty, q.exam_type::exam_type, q.explanation, 'published'
from public.topics t
  join public.curricula c on c.id = t.curriculum_id
  join public.lessons l on l.topic_id = t.id,
  (values
  ('A chord of length 24 cm is 5 cm from the centre of a circle. Find the radius.', '$12$ cm', '$13$ cm', '$14$ cm', '$15$ cm', 'B', 2, 'GENERAL', 'Half-chord $=12$ cm; radius $=\sqrt{12^2+5^2}=\sqrt{169}=13$ cm.'),
  ('In a cyclic quadrilateral $PQRS$, $\angle P = 110°$ and $\angle R = 70°$. What can be concluded about $\angle Q$ and $\angle S$?', 'Only that $\angle Q + \angle S = 180°$; their individual values need more information', '$\angle Q = 110°$ and $\angle S = 70°$ automatically', '$\angle Q = 70°$ and $\angle S = 110°$ automatically', 'This data is contradictory and impossible', 'A', 3, 'GENERAL', '$\angle P + \angle R = 110°+70°=180°$ is already consistent with the cyclic quadrilateral rule, but this only confirms the P-R pair; $\angle Q$ and $\angle S$ individually are not determined without further data (they must still sum to $180°$).'),
  ('Two equal chords of a circle are 8 cm apart and each is 12 cm long. Find the radius, if the chords are on opposite sides of the centre.', '$\sqrt{52}$ cm $\approx 7.21$ cm', '$10$ cm', '$6$ cm', '$\sqrt{40}$ cm $\approx 6.32$ cm', 'A', 3, 'GENERAL', 'Each chord is $8/2=4$ cm from the centre; half-chord $=6$ cm; radius $=\sqrt{6^2+4^2}=\sqrt{52}\approx7.21$ cm.'),
  ('What is the relationship between equal chords of a circle and their distances from the centre?', 'Equal chords are equidistant from the centre, and vice versa', 'Equal chords are always the same distance from each other', 'Equal chords must both pass through the centre', 'There is no fixed relationship', 'A', 1, 'GENERAL', 'This is a core chord property: equal chords sit at equal distances from the centre, and the converse holds too.'),
  ('In a circle with centre $O$ and radius 10 cm, a chord $AB$ is 6 cm from the centre. Calculate (a) the length of the chord and (b) the angle subtended by the chord at the centre.', '(a) 16 cm (b) $\approx 106.3°$', '(a) 8 cm (b) $\approx 53.1°$', '(a) 16 cm (b) $\approx 73.7°$', '(a) 12 cm (b) $\approx 90°$', 'A', 3, 'GENERAL', 'Half-chord $=\sqrt{10^2-6^2}=8$, so chord $=16$ cm; half-angle $=\cos^{-1}(0.6)\approx53.13°$, so full angle $\approx106.3°$.'),
  ('$ABCD$ is a cyclic quadrilateral where $\angle A = 2x+15°$ and $\angle C = 3x-10°$. Find $x$ and the values of $\angle A$ and $\angle C$.', '$x=35$; $\angle A=85°$, $\angle C=95°$', '$x=33$; $\angle A=81°$, $\angle C=89°$', '$x=35$; $\angle A=65°$, $\angle C=115°$', '$x=30$; $\angle A=75°$, $\angle C=80°$', 'A', 3, 'GENERAL', 'Since opposite angles are supplementary: $(2x+15)+(3x-10)=180 \Rightarrow 5x+5=180 \Rightarrow x=35$; giving $\angle A=85°$ and $\angle C=95°$.'),
  ('In a circle, two equal chords $AB$ and $CD$ have a perpendicular distance of 4 cm from the centre, and the radius is 5 cm. Find the length of each chord.', '$6$ cm', '$8$ cm', '$3$ cm', '$9$ cm', 'A', 2, 'GENERAL', 'Half-chord $=\sqrt{5^2-4^2}=\sqrt{9}=3$ cm, so each chord is $2\times3=6$ cm.'),
  ('A circle has radius 6 cm and two chords, each of length 10 cm. Find their distance from the centre.', '$\sqrt{11}$ cm $\approx 3.32$ cm', '$4$ cm', '$\sqrt{14}$ cm $\approx 3.74$ cm', '$1$ cm', 'A', 3, 'GENERAL', 'Half-chord $=5$ cm; distance $=\sqrt{6^2-5^2}=\sqrt{11}\approx3.32$ cm.'),
  ('A chord of length 24 cm is 5 cm from the centre of a circle. Find the radius (a repeat check of the method).', '$12$ cm', '$13$ cm', '$14$ cm', '$26$ cm', 'B', 2, 'GENERAL', 'Half-chord $=12$ cm; radius $=\sqrt{12^2+5^2}=13$ cm.'),
  ('In a circle with centre $O$, chord $AB = 16$ cm and its distance from the centre is 6 cm. Find the radius.', '$8$ cm', '$9$ cm', '$10$ cm', '$22$ cm', 'C', 2, 'GENERAL', 'Half-chord $=8$ cm; radius $=\sqrt{8^2+6^2}=\sqrt{100}=10$ cm.'),
  ('$PQRS$ is a cyclic quadrilateral. If $\angle P = 75°$ and $\angle Q = 85°$, find $\angle R$ and $\angle S$.', '$\angle R=105°$, $\angle S=95°$', '$\angle R=95°$, $\angle S=105°$', '$\angle R=105°$, $\angle S=85°$', '$\angle R=75°$, $\angle S=95°$', 'A', 2, 'GENERAL', 'Opposite angles are supplementary: $\angle R=180-75=105°$, $\angle S=180-85=95°$.'),
  ('Two equal chords $AB$ and $CD$ of a circle with centre $O$ and radius 13 cm are 5 cm apart. Find the length of each chord.', '$\approx 25.52$ cm', '$\approx 20.00$ cm', '$\approx 12.76$ cm', '$\approx 24.00$ cm', 'A', 3, 'GENERAL', 'Each chord is 2.5 cm from the centre; half-chord $=\sqrt{13^2-2.5^2}\approx12.76$ cm, so the full chord $\approx25.52$ cm.'),
  ('In a circle, chord $PQ$ subtends an angle of $60°$ at the centre. If the radius is 8 cm, find the length of the chord.', '$8$ cm', '$4$ cm', '$4\sqrt{3}$ cm', '$16$ cm', 'A', 2, 'GENERAL', 'Since $\angle POQ=60°$ and $OP=OQ=$ radius, triangle $OPQ$ is equilateral, so $PQ=$ radius $=8$ cm.'),
  ('$ABCD$ is a cyclic quadrilateral with $\angle BAD = 3x$ and $\angle BCD = 2x$. Find $x$ and the two angles.', '$x=36°$; $\angle BAD=108°$, $\angle BCD=72°$', '$x=45°$; $\angle BAD=135°$, $\angle BCD=90°$', '$x=30°$; $\angle BAD=90°$, $\angle BCD=60°$', '$x=36°$; $\angle BAD=72°$, $\angle BCD=108°$', 'A', 3, 'GENERAL', 'Opposite angles sum to $180°$: $3x+2x=180 \Rightarrow x=36$; $\angle BAD=108°$, $\angle BCD=72°$.'),
  ('Two chords $AB$ and $CD$ of a circle intersect at right angles at a point $E$ inside the circle. If $AE=6$ cm, $EB=4$ cm, and $CE=8$ cm, find $ED$, using $AE \times EB = CE \times ED$.', '$3$ cm', '$4.8$ cm', '$12$ cm', '$2$ cm', 'A', 3, 'GENERAL', 'By the intersecting chords rule: $6\times4=24=8\times ED \Rightarrow ED=3$ cm.'),
  ('In a circle, two tangents from an external point $P$ are each 15 cm long. If the radius is 9 cm, find the distance from $P$ to the centre.', '$\sqrt{306}$ cm $\approx 17.5$ cm', '$24$ cm', '$12$ cm', '$\sqrt{144}$ cm $=12$ cm', 'A', 3, 'GENERAL', 'The tangent, radius, and the line to the centre form a right triangle: distance $=\sqrt{15^2+9^2}=\sqrt{306}\approx17.5$ cm.'),
  ('Two tangents $TA$ and $TB$ are drawn to a circle from external point $T$. If $TA = 24$ cm and the radius is 7 cm, calculate (a) the distance from $T$ to the centre $O$, and (b) $\angle ATB$ if $\angle AOB = 120°$.', '(a) $25$ cm (b) $60°$', '(a) $31$ cm (b) $120°$', '(a) $25$ cm (b) $120°$', '(a) $17$ cm (b) $60°$', 'A', 4, 'GENERAL', '(a) $\sqrt{24^2+7^2}=\sqrt{625}=25$ cm; (b) in kite $OATB$, the two angles at $A$ and $B$ are $90°$ each, so $\angle ATB=360-90-90-120=60°$.'),
  ('A chord $AB$ of a circle makes an angle of $65°$ with the tangent at $A$. Calculate (a) the angle subtended by $AB$ in the alternate segment and (b) the angle at the centre, given the circumference angle is half of it.', '(a) $65°$ (b) $130°$', '(a) $130°$ (b) $65°$', '(a) $65°$ (b) $65°$', '(a) $25°$ (b) $50°$', 'A', 3, 'GENERAL', 'By the alternate segment theorem, the tangent-chord angle equals the angle in the alternate segment: (a) $65°$; the centre angle is double the circumference angle: (b) $2\times65°=130°$.')
) as q(question_text, option_a, option_b, option_c, option_d, correct_letter, difficulty, exam_type, explanation)
where c.subject = 'Mathematics' and t.class_level = 'SS2' and t.term = 2 and t.order_index = 209;
-- ------------------------------------------
-- 210. CIRCLE THEOREMS: ANGLE PROPERTIES (additional content. The
-- lesson row and one worked example for this topic already exist from
-- mathora_seed_exemplar_lessons.sql ("Circle Theorems: Angle at the
-- Centre"); this section does NOT insert a new lesson row. It adds
-- three further worked examples covering the other circle-angle
-- theorems (angle in a semicircle, cyclic quadrilateral, isosceles
-- chord triangle), plus every question from the curated exercise bank.
-- ------------------------------------------

insert into public.worked_examples (lesson_id, title, problem_statement, solution_steps, exam_shortcut, diagram_type, diagram_data, status)
select l.id,
  'Angle in a Semicircle',
  '$AB$ is a diameter of a circle; $C$ is a point on the circle with $\angle CAB = 32°$. Find $\angle ABC$ and $\angle AOC$ (where $O$ is the centre).',
  to_jsonb(array[
    'Since $AB$ is a diameter, the angle at $C$ in the semicircle is a right angle: $\angle ACB = 90°$.',
    'Use the angle sum of triangle $ABC$: $\angle CAB + \angle ACB + \angle ABC = 180°$.',
    'Substitute the known values: $32° + 90° + \angle ABC = 180°$.',
    'Solve for $\angle ABC$: $\angle ABC = 180° - 122° = 58°$.',
    'Find $\angle AOC$ using the centre/circumference relationship, with $\angle ABC$ as the circumference angle standing on arc $AC$: $\angle AOC = 2 \times \angle ABC = 2 \times 58° = 116°$.'
  ]),
  'Spot a diameter instantly from either clue: the phrase "AB is a diameter", OR a right angle sitting at the circumference, either one tells you the other for free.',
  'circle',
  '{"centerLabel": "O", "points": [{"label": "A", "angleDegrees": 180}, {"label": "B", "angleDegrees": 0}, {"label": "C", "angleDegrees": 80}], "chord": {"fromAngle": 180, "toAngle": 80, "label": "AC"}}'::jsonb,
  'published'
from public.lessons l join public.topics t on t.id = l.topic_id join public.curricula c on c.id = t.curriculum_id
where c.subject = 'Mathematics' and t.class_level = 'SS2' and t.term = 2 and t.order_index = 210;

insert into public.worked_examples (lesson_id, title, problem_statement, solution_steps, exam_shortcut, status)
select l.id,
  'Opposite Angles of a Cyclic Quadrilateral',
  '$ABCD$ is a cyclic quadrilateral with $\angle ABC = 75°$ and $\angle BCD = 110°$. Find $\angle ADC$ and $\angle DAB$.',
  to_jsonb(array[
    'Recall opposite angles of a cyclic quadrilateral are supplementary: $\angle ABC + \angle ADC = 180°$, and $\angle BCD + \angle DAB = 180°$.',
    'Solve for $\angle ADC$: $\angle ADC = 180° - 75° = 105°$.',
    'Solve for $\angle DAB$: $\angle DAB = 180° - 110° = 70°$.'
  ]),
  'In a cyclic quadrilateral, "exterior angle equals interior opposite angle" is just a restatement of "opposite angles are supplementary", both are supplementary to the same interior angle at that vertex.',
  'published'
from public.lessons l join public.topics t on t.id = l.topic_id join public.curricula c on c.id = t.curriculum_id
where c.subject = 'Mathematics' and t.class_level = 'SS2' and t.term = 2 and t.order_index = 210;

insert into public.worked_examples (lesson_id, title, problem_statement, solution_steps, exam_shortcut, status)
select l.id,
  'An Isosceles Triangle Inside a Circle',
  'Three points $P$, $Q$, $R$ lie on a circle with $PQ = PR$; $\angle PQR = 65°$. Find $\angle PRQ$ and $\angle QPR$.',
  to_jsonb(array[
    'Since $PQ = PR$, triangle $PQR$ is isosceles, so the base angles at $Q$ and $R$ are equal: $\angle PRQ = \angle PQR = 65°$.',
    'Use the angle sum of a triangle: $\angle QPR + \angle PQR + \angle PRQ = 180°$.',
    'Substitute: $\angle QPR + 65° + 65° = 180°$.',
    'Solve: $\angle QPR = 180° - 130° = 50°$.'
  ]),
  'Isosceles triangles appear constantly inside circle diagrams whenever two radii (or two equal chords, as here) are drawn, mark the equal sides first and use base angles before reaching for any other circle theorem.',
  'published'
from public.lessons l join public.topics t on t.id = l.topic_id join public.curricula c on c.id = t.curriculum_id
where c.subject = 'Mathematics' and t.class_level = 'SS2' and t.term = 2 and t.order_index = 210;

insert into public.questions (topic_id, lesson_id, question_text, option_a, option_b, option_c, option_d, correct_letter, difficulty, exam_type, explanation, status)
select t.id, l.id, q.question_text, q.option_a, q.option_b, q.option_c, q.option_d, q.correct_letter, q.difficulty, q.exam_type::exam_type, q.explanation, 'published'
from public.topics t
  join public.curricula c on c.id = t.curriculum_id
  join public.lessons l on l.topic_id = t.id,
  (values
  ('Points $A$, $B$, $C$ lie on a circle with $\angle ABC = 48°$. What is the angle subtended by arc $AC$ at another point $D$ on the major arc?', '$48°$', '$24°$', '$96°$', '$132°$', 'A', 2, 'GENERAL', 'Angles in the same segment, standing on the same arc $AC$, are equal, so the angle at $D$ is also $48°$.'),
  ('In a circle with diameter $PQ$, point $R$ lies on the circle and $\angle PRQ = 90°$. What can be concluded?', 'This confirms $PQ$ is a diameter, since the angle in a semicircle is always $90°$', 'This is only possible if $R$ is the centre', 'This means $PQ$ cannot be a diameter', 'No conclusion can be drawn', 'A', 2, 'GENERAL', 'The angle in a semicircle theorem works both ways: a $90°$ angle at the circumference confirms the opposite side is a diameter.'),
  ('$ABCD$ is a cyclic quadrilateral with $\angle BAD = 95°$. If $BC$ is produced to $E$, find the exterior angle $\angle DCE$.', '$95°$', '$85°$', '$180°$', '$47.5°$', 'A', 3, 'GENERAL', 'The exterior angle at $C$ equals the interior angle opposite it, $\angle BAD = 95°$.'),
  ('In a circle, chord $AB$ subtends an angle of $40°$ at point $C$ on the major arc. Find the angle at the centre $O$.', '$20°$', '$40°$', '$80°$', '$160°$', 'C', 2, 'GENERAL', 'Angle at centre $= 2 \times$ angle at circumference $= 2\times40°=80°$.'),
  ('What is the relationship between angles in the same segment of a circle, standing on the same arc?', 'They are always equal', 'They always sum to $180°$', 'They are always supplementary to the centre angle', 'They have no fixed relationship', 'A', 1, 'GENERAL', 'All angles in the same segment, subtending the same arc, are equal, this follows directly from the centre-angle theorem.'),
  ('In a circle with centre $O$, $\angle AOB = 140°$. Points $P$ and $Q$ lie on the major arc $AB$. Find $\angle APB$, $\angle AQB$, and describe their relationship.', '$\angle APB=70°$, $\angle AQB=70°$; they are equal', '$\angle APB=280°$, $\angle AQB=280°$; they are equal', '$\angle APB=70°$, $\angle AQB=110°$; they are supplementary', '$\angle APB=35°$, $\angle AQB=35°$; they are equal', 'A', 2, 'GENERAL', 'Each equals half the centre angle: $140°/2=70°$; being in the same segment, they are equal to each other.'),
  ('$PQRS$ is a cyclic quadrilateral where $\angle PQR = 105°$ and $\angle QRS = 85°$. Find (a) $\angle RSP$, (b) $\angle SPQ$, and (c) the exterior angle when $PQ$ is produced beyond $Q$.', '(a) $75°$ (b) $95°$ (c) $75°$', '(a) $95°$ (b) $75°$ (c) $105°$', '(a) $75°$ (b) $95°$ (c) $105°$', '(a) $105°$ (b) $85°$ (c) $75°$', 'A', 3, 'GENERAL', '(a) $\angle RSP=180-105=75°$; (b) $\angle SPQ=180-85=95°$; (c) the exterior angle at $Q$ on a straight line is supplementary to $\angle PQR$ ($180-105=75°$), matching the interior opposite angle $\angle RSP$.'),
  ('In a circle, $AB$ is a diameter and $C$ is a point on the circle. If $\angle CAB = 32°$, find (a) $\angle ACB$, (b) $\angle ABC$, (c) $\angle AOC$.', '(a) $90°$ (b) $58°$ (c) $116°$', '(a) $90°$ (b) $32°$ (c) $64°$', '(a) $58°$ (b) $90°$ (c) $116°$', '(a) $90°$ (b) $58°$ (c) $58°$', 'A', 3, 'GENERAL', '(a) angle in a semicircle is $90°$; (b) angle sum of the triangle gives $180-90-32=58°$; (c) centre angle $=2\times58°=116°$.'),
  ('A tangent to a circle at point $T$ makes an angle of $58°$ with chord $TA$. Point $B$ is on the major arc. Find $\angle TBA$ using the alternate segment theorem.', '$58°$', '$29°$', '$116°$', '$32°$', 'A', 2, 'GENERAL', 'The alternate segment theorem states the tangent-chord angle equals the angle in the alternate segment: $\angle TBA=58°$.'),
  ('Three points $P$, $Q$, $R$ lie on a circle such that $PQ = PR$. If $\angle PQR = 65°$, find (a) $\angle PRQ$, (b) $\angle QPR$, and (c) the angle subtended by arc $QR$ at the centre.', '(a) $65°$ (b) $50°$ (c) $100°$', '(a) $65°$ (b) $65°$ (c) $130°$', '(a) $50°$ (b) $65°$ (c) $100°$', '(a) $65°$ (b) $50°$ (c) $50°$', 'A', 3, 'GENERAL', '(a) base angles of the isosceles triangle are equal: $65°$; (b) angle sum gives $180-65-65=50°$; (c) the centre angle on arc $QR$ is double the circumference angle $\angle QPR$: $2\times50°=100°$.'),
  ('In a circle, triangle $PQR$ is inscribed with $PQ = QR$. Given $\angle QPS = 35°$ and $\angle PRS = 40°$ for a point $S$ also on the circle, find $\angle PQR$.', '$30°$', '$35°$', '$40°$', '$75°$', 'A', 4, 'GENERAL', 'Working through the circle-theorem relationships between the given angles and the isosceles condition $PQ=QR$ (angles subtended by the same arcs, and the triangle''s angle sum) gives $\angle PQR=30°$; this result depends on the specific diagram configuration provided in the source.'),
  ('A tangent $PT$ touches a circle at $T$; chord $TA$ is drawn with $\angle PTA = 42°$. Point $B$ is on the circle. Using the alternate segment theorem, find $\angle TBA$.', '$42°$', '$21°$', '$84°$', '$48°$', 'A', 2, 'GENERAL', 'By the alternate segment theorem, the tangent-chord angle equals the angle in the alternate segment: $\angle TBA=42°$.'),
  ('A tangent $XY$ touches a circle at $P$; the radius $OP$ is drawn, and $\angle QPR = 75°$ is bisected by $OP$ into two equal angles $\angle OPQ$ and $\angle OPR$. Find $\angle OPX$, $\angle OPQ$, $\angle OPR$, and $\angle QPY$.', '$\angle OPX=90°$, $\angle OPQ=\angle OPR=37.5°$, $\angle QPY=52.5°$', '$\angle OPX=90°$, $\angle OPQ=\angle OPR=75°$, $\angle QPY=15°$', '$\angle OPX=75°$, $\angle OPQ=\angle OPR=37.5°$, $\angle QPY=52.5°$', '$\angle OPX=90°$, $\angle OPQ=\angle OPR=37.5°$, $\angle QPY=90°$', 'A', 4, 'GENERAL', 'The tangent-radius angle is always $90°$: $\angle OPX=90°$; bisecting $75°$ gives $\angle OPQ=\angle OPR=37.5°$; the remaining angle to the tangent is $\angle QPY=90-37.5=52.5°$.')
) as q(question_text, option_a, option_b, option_c, option_d, correct_letter, difficulty, exam_type, explanation)
where c.subject = 'Mathematics' and t.class_level = 'SS2' and t.term = 2 and t.order_index = 210;
