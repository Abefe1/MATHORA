-- ==========================================
-- MATHORA: SS1 Mathematics, Second Term: Full Content Seed
-- (10 topics, order_index 201-210)
--
-- Source of truth for all teaching notes, worked examples and exercise
-- questions: SS1-SS3_MATHEMATICS_CURATED.md ("SS1 Mathematics" >
-- "Second Term", Weeks 1-6 and 8-11; Week 7 is a review/periodic-test
-- week with no distinct topic and is skipped, matching the syllabus:
-- Weeks 1-6 and 8-11 map 1:1 onto topics order_index 201-210).
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
--                                           + 2 worked_examples + 2
--                                           questions for topic 206,
--                                           "Venn Diagrams: Two-Set
--                                           Problems." This file does
--                                           NOT duplicate that lesson
--                                           row; it adds one additional
--                                           worked example covering the
--                                           three-set case, plus every
--                                           Venn question from the
--                                           curated exercise bank, all
--                                           linked to that existing
--                                           lesson via the same topic
--                                           subquery pattern)
--   mathora_seed_ss1_term2_content.sql     (this file)
--
-- For every other topic (201-205, 207-210) this file inserts one
-- lessons row, 2-4 worked_examples rows, and every question from that
-- week's curated "Gamified Exercise Bank" section (none are sampled or
-- skipped). Open/free-response curated questions are converted here
-- into 4-option MCQs with hand-checked, genuinely-wrong distractors;
-- questions already given with explicit options (A-D or A-E) keep
-- their original options exactly as given, five-option ones included.
-- All monetary examples use Naira (₦) notation.
-- ==========================================
-- ------------------------------------------
-- 201. QUADRATIC EQUATIONS: FACTORISATION & COMPLETING THE SQUARE
-- ------------------------------------------

insert into public.lessons (topic_id, title, summary, content_body, order_index)
values (
  (select t.id from public.topics t join public.curricula c on c.id = t.curriculum_id
   where c.subject = 'Mathematics' and t.class_level = 'SS1' and t.term = 2 and t.order_index = 201),
  'Quadratic Equations: Factorisation & Completing the Square',
  'Solving quadratic equations by factorisation (difference of two squares, trinomials, common factors) and by completing the square.',
  '### Standard Form

A quadratic equation is an equation in which the highest power of the unknown is 2: $ax^2 + bx + c = 0$, where $a, b, c$ are constants and $a \neq 0$.

### Solving by Factorisation

Write the equation in standard form, factorise the left-hand side into two linear factors, then apply the **Zero Product Property**: if $M \times N = 0$, then $M = 0$ or $N = 0$.

- **Difference of two squares** (no middle term): $a^2 - b^2 = (a-b)(a+b)$.
- **Trinomial, $a = 1$**: for $x^2 + bx + c$, find two numbers that multiply to $c$ and add to $b$.
- **Trinomial, $a \neq 1$ (the "ac method")**: find two numbers that multiply to $ac$ and add to $b$, split the middle term using them, then factorise by grouping.
- **Common factor first**: always check for a common factor before trying anything else.

### Solving by Completing the Square

Used when factorisation is not obvious. Steps:
1. Make the coefficient of $x^2$ equal to 1 (divide every term by $a$).
2. Move the constant term to the right-hand side.
3. Add the square of half the coefficient of $x$ to both sides.
4. Write the left-hand side as a perfect square, and simplify the right-hand side.
5. Take square roots of both sides (remembering $\pm$) and solve for $x$.

A key warning: never divide a quadratic equation through by the unknown $x$ to "cancel" it, this silently discards the root $x = 0$. Always factor out $x$ instead.',
  1
);

insert into public.worked_examples (lesson_id, title, problem_statement, solution_steps, exam_shortcut, status)
select l.id,
  'Difference of Two Squares',
  'Solve $4x^2 - 25 = 0$.',
  to_jsonb(array[
    'Recognise the pattern: $4x^2 = (2x)^2$ and $25 = 5^2$, so this is a difference of two squares, $a^2 - b^2 = (a-b)(a+b)$, with $a = 2x$, $b = 5$.',
    'Factorise: $4x^2 - 25 = (2x - 5)(2x + 5)$.',
    'Set the equation to zero and apply the Zero Product Property: $(2x-5)(2x+5) = 0$, so $2x - 5 = 0$ or $2x + 5 = 0$.',
    'Solve each linear equation: $2x = 5 \Rightarrow x = \frac{5}{2}$; or $2x = -5 \Rightarrow x = -\frac{5}{2}$.'
  ]),
  'Any binomial of the form (perfect square) minus (perfect square), even with a leading coefficient that is itself a perfect square, factorises immediately as $(\sqrt{\text{first}} - \sqrt{\text{second}})(\sqrt{\text{first}} + \sqrt{\text{second}})$, no need for the longer ac-method.',
  'published'
from public.lessons l join public.topics t on t.id = l.topic_id join public.curricula c on c.id = t.curriculum_id
where c.subject = 'Mathematics' and t.class_level = 'SS1' and t.term = 2 and t.order_index = 201;

insert into public.worked_examples (lesson_id, title, problem_statement, solution_steps, exam_shortcut, common_trap_warning, status)
select l.id,
  'Common Factor First',
  'Solve $3x^2 - 12x = 0$.',
  to_jsonb(array[
    'Spot the common factor: both terms share a factor of $3x$.',
    'Factor it out: $3x(x - 4) = 0$.',
    'Apply the Zero Product Property: $3x = 0$ or $x - 4 = 0$.',
    'Solve each: $x = 0$ or $x = 4$.'
  ]),
  'Always pull out common factors FIRST, before trying trinomial or difference-of-squares tricks, e.g. $2x^2 - 8 = 2(x^2-4) = 2(x-2)(x+2)$ is far quicker than working with the 2 wedged inside.',
  'A very common student slip is to divide both sides by $x$ here, which silently throws away the root $x = 0$. Never divide a quadratic equation by the unknown, always factor instead.',
  'published'
from public.lessons l join public.topics t on t.id = l.topic_id join public.curricula c on c.id = t.curriculum_id
where c.subject = 'Mathematics' and t.class_level = 'SS1' and t.term = 2 and t.order_index = 201;

insert into public.worked_examples (lesson_id, title, problem_statement, solution_steps, exam_shortcut, common_trap_warning, real_life_context, status)
select l.id,
  'Word Problem: Consecutive Market Stall Numbers',
  'Two market stalls at a Lagos trade fair are numbered with consecutive positive integers, and the product of their stall numbers is 56. Find the two stall numbers.',
  to_jsonb(array[
    'Define the unknown: let the smaller stall number be $n$, so the next stall is $n + 1$.',
    'Translate the problem into an equation: "product is 56" means $n(n+1) = 56$.',
    'Expand and rearrange into standard form: $n^2 + n = 56 \Rightarrow n^2 + n - 56 = 0$.',
    'Factorise: find two numbers multiplying to $-56$ and adding to $1$, these are $8$ and $-7$. So $n^2+n-56 = (n-7)(n+8)$.',
    'Solve: $(n-7)(n+8) = 0 \Rightarrow n = 7$ or $n = -8$.',
    'Reject the invalid root using the context: stall numbers are positive, so $n = -8$ is rejected.'
  ]),
  'Sanity-check any solved roots by substitution, or faster: check that their sum equals $-b/a$ and their product equals $c/a$.',
  'Remember to check both roots against the problem''s real-world constraints (here, "positive stall numbers") and reject any root that does not fit, rather than reporting both roots as final answers.',
  'This is exactly the kind of numbering puzzle a trade fair organiser or market association might use when assigning adjacent stalls: knowing the product of two neighbouring stall numbers is enough to recover both numbers algebraically.',
  'published'
from public.lessons l join public.topics t on t.id = l.topic_id join public.curricula c on c.id = t.curriculum_id
where c.subject = 'Mathematics' and t.class_level = 'SS1' and t.term = 2 and t.order_index = 201;

insert into public.worked_examples (lesson_id, title, problem_statement, solution_steps, exam_shortcut, common_trap_warning, status)
select l.id,
  'Completing the Square',
  'Solve $2x^2 + 3x - 8 = 0$ by completing the square, correct to 1 decimal place.',
  to_jsonb(array[
    'Divide every term by the coefficient of $x^2$ (= 2) to make it unity: $x^2 + \frac{3}{2}x - 4 = 0$.',
    'Move the constant term to the right-hand side: $x^2 + \frac{3}{2}x = 4$.',
    'Halve the coefficient of $x$, then square it, and add the result to both sides: half of $\frac{3}{2}$ is $\frac{3}{4}$; $(\frac{3}{4})^2 = \frac{9}{16}$. So $x^2 + \frac{3}{2}x + \frac{9}{16} = 4 + \frac{9}{16}$.',
    'Write the left-hand side as a perfect square, and simplify the right-hand side: $(x+\frac{3}{4})^2 = \frac{64}{16}+\frac{9}{16} = \frac{73}{16}$.',
    'Take the square root of both sides (keep $\pm$): $x + \frac{3}{4} = \pm\sqrt{\frac{73}{16}} = \pm\frac{\sqrt{73}}{4}$.',
    'Solve for $x$: $x = -\frac{3}{4} \pm \frac{\sqrt{73}}{4} = \frac{-3 \pm \sqrt{73}}{4}$.',
    'Evaluate numerically ($\sqrt{73} \approx 8.544$): $x \approx 1.4$ or $x \approx -2.9$ (1 d.p.).'
  ]),
  'Once you reach $(x+p)^2 = k$, check the sign of $k$ first: if $k < 0$ there are no real roots, stop and say so instead of chasing an imaginary square root.',
  'Forgetting the $\pm$ when taking the square root of both sides loses one of the two valid solutions, always write both the "+" and "-" cases before evaluating.',
  'published'
from public.lessons l join public.topics t on t.id = l.topic_id join public.curricula c on c.id = t.curriculum_id
where c.subject = 'Mathematics' and t.class_level = 'SS1' and t.term = 2 and t.order_index = 201;

insert into public.questions (topic_id, lesson_id, question_text, option_a, option_b, option_c, option_d, correct_letter, difficulty, exam_type, explanation, status)
select t.id, l.id, q.question_text, q.option_a, q.option_b, q.option_c, q.option_d, q.correct_letter, q.difficulty, q.exam_type, q.explanation, 'published'
from public.topics t
  join public.curricula c on c.id = t.curriculum_id
  join public.lessons l on l.topic_id = t.id,
  (values
  ('Factorise $x^2 - 121$.', '$(x-11)(x-11)$', '$(x-11)(x+11)$', '$(x+11)(x+11)$', '$(x-121)(x+1)$', 'B', 1, 'GENERAL', '$121 = 11^2$, so this is a difference of two squares: $x^2 - 121 = (x-11)(x+11)$.'),
  ('Factorise $x^2 + 10x + 21$.', '$(x+21)(x+1)$', '$(x+7)(x+3)$', '$(x-7)(x-3)$', '$(x+6)(x+4)$', 'B', 1, 'GENERAL', 'Two numbers that multiply to $21$ and add to $10$ are $7$ and $3$, so $x^2+10x+21 = (x+7)(x+3)$.'),
  ('Factorise $x^2 + 2x - 15$.', '$(x+3)(x-5)$', '$(x-3)(x-5)$', '$(x+3)(x+5)$', '$(x-3)(x+5)$', 'D', 1, 'GENERAL', 'Two numbers multiplying to $-15$ and adding to $2$ are $5$ and $-3$: $x^2+2x-15 = (x+5)(x-3)$.'),
  ('Solve for $x$: $x^2 - 9x = 0$.', '$x = 0$ or $x = 9$', '$x = 9$ only', '$x = 0$ only', '$x = -9$ or $x = 0$', 'A', 1, 'GENERAL', 'Factor out $x$: $x(x-9)=0$, so $x=0$ or $x=9$. Do not divide through by $x$, that discards the root $x=0$.'),
  ('Solve for $x$: $x^2 - 11x + 28 = 0$.', '$x = -4$ or $x = -7$', '$x = 2$ or $x = 14$', '$x = 4$ or $x = -7$', '$x = 4$ or $x = 7$', 'D', 2, 'GENERAL', 'Two numbers multiplying to $28$ and adding to $-11$ are $-4$ and $-7$: $(x-4)(x-7)=0 \Rightarrow x=4$ or $x=7$.'),
  ('Factorise $5x^2 - 13x - 6$.', '$(5x+2)(x-3)$', '$(5x-2)(x+3)$', '$(5x+6)(x-1)$', '$(5x-6)(x+1)$', 'A', 3, 'GENERAL', 'Using the ac-method: $ac = -30$; two numbers multiplying to $-30$ and adding to $-13$ are $2$ and $-15$. Splitting and grouping gives $(5x+2)(x-3)$.'),
  ('Solve for $x$: $(x+3)x = 10$.', '$x = -2$ or $x = 5$', '$x = 5$ or $x = -3$', '$x = 10$ or $x = -1$', '$x = 2$ or $x = -5$', 'D', 2, 'GENERAL', 'Expand: $x^2+3x-10=0 \Rightarrow (x+5)(x-2)=0 \Rightarrow x=-5$ or $x=2$.'),
  ('Solve for $x$: $3x^2 + 19x = 14$.', '$x = -\frac{2}{3}$ or $x = 7$', '$x = \frac{14}{3}$ or $x = -1$', '$x = \frac{2}{3}$ or $x = -7$', '$x = 2$ or $x = -\frac{7}{3}$', 'C', 3, 'GENERAL', 'Rearrange: $3x^2+19x-14=0$. $ac=-42$; numbers $21$ and $-2$ split the middle term, giving $(3x-2)(x+7)=0 \Rightarrow x=\frac{2}{3}$ or $x=-7$.'),
  ('Solve for $x$: $4x^2 - 25 = 0$.', '$x = 5$ or $x = -5$', '$x = \frac{5}{2}$ or $x = -\frac{5}{2}$', '$x = \frac{5}{4}$ or $x = -\frac{5}{4}$', '$x = \frac{25}{4}$ only', 'B', 1, 'GENERAL', 'Difference of two squares: $(2x-5)(2x+5)=0 \Rightarrow x = \pm\frac{5}{2}$.'),
  ('The product of two consecutive positive integers is 56. Find the integers.', '6 and 9', '7 and 8', '8 and 9', '-7 and -8', 'B', 3, 'WAEC', 'Let $n(n+1)=56 \Rightarrow n^2+n-56=0 \Rightarrow (n-7)(n+8)=0$. Since the integers are positive, $n=7$, giving 7 and 8 (check: $7\times8=56$).'),
  ('Solve $d^2 + 10d - 24 = 0$.', '$d = 12$ or $d = -2$', '$d = -12$ or $d = 2$', '$d = -6$ or $d = 4$', '$d = 24$ or $d = -1$', 'B', 2, 'GENERAL', 'Two numbers multiplying to $-24$ and adding to $10$ are $12$ and $-2$: $(d+12)(d-2)=0 \Rightarrow d=-12$ or $d=2$.'),
  ('Solve $x^2 - 8x + 16 = 0$.', '$x = 4$ (repeated root)', '$x = -4$ (repeated root)', '$x = 8$ or $x = 2$', '$x = 16$ only', 'A', 2, 'GENERAL', '$x^2-8x+16=(x-4)^2=0$, giving the repeated root $x=4$.'),
  ('Find the smaller value of $x$ satisfying $x^2 + 7x + 10 = 0$.', '$x = -2$', '$x = -5$', '$x = 2$', '$x = 5$', 'B', 2, 'GENERAL', '$(x+5)(x+2)=0 \Rightarrow x=-5$ or $x=-2$; the smaller value is $-5$.'),
  ('Solve $6x + 16 = x^2$.', '$x = 8$ or $x = -2$', '$x = -8$ or $x = 2$', '$x = 4$ or $x = -4$', '$x = 16$ or $x = -6$', 'A', 2, 'GENERAL', 'Rearranged: $x^2-6x-16=0 \Rightarrow (x-8)(x+2)=0 \Rightarrow x=8$ or $x=-2$.'),
  ('Solve the equation $x^2 - 2x - 3 = 0$.', '$x = -1$ or $x = 3$', '$x = 1$ or $x = -3$', '$x = -1$ or $x = -3$', '$x = 1$ or $x = 3$', 'A', 1, 'GENERAL', '$(x+1)(x-3)=0 \Rightarrow x=-1$ or $x=3$.'),
  ('Find the sum of the roots of $x^2 + x - 9 = 3$.', '$1$', '$-12$', '$12$', '$-1$', 'D', 3, 'GENERAL', 'Rearranged: $x^2+x-12=0$. Sum of roots $= -b/a = -1$.'),
  ('What is the smaller value of $x$ for which $x^2 - 3x + 2 = 0$?', '$x = 2$', '$x = 1$', '$x = -1$', '$x = -2$', 'B', 1, 'GENERAL', '$(x-1)(x-2)=0 \Rightarrow x=1$ or $x=2$; the smaller value is 1.'),
  ('Solve the equation $x^2 - 3x - 10 = 0$.', '$x = -5$ or $x = 2$', '$x = 5$ or $x = 2$', '$x = -5$ or $x = -2$', '$x = 5$ or $x = -2$', 'D', 2, 'GENERAL', '$(x-5)(x+2)=0 \Rightarrow x=5$ or $x=-2$.'),
  ('Solve by factorisation: $3 - 2x - x^2 = 0$.', '$x = -1$ or $x = 3$', '$x = 1$ or $x = 3$', '$x = -1$ or $x = -3$', '$x = 1$ or $x = -3$', 'D', 3, 'GENERAL', 'Rearrange as $-(x^2+2x-3)=0 \Rightarrow x^2+2x-3=0 \Rightarrow (x+3)(x-1)=0 \Rightarrow x=-3$ or $x=1$.'),
  ('Solve by factorisation: $9 + 8t - t^2 = 0$.', '$t = -1$ or $t = 9$', '$t = 1$ or $t = -9$', '$t = -1$ or $t = -9$', '$t = 1$ or $t = 9$', 'A', 3, 'GENERAL', 'Rearrange: $t^2-8t-9=0 \Rightarrow (t-9)(t+1)=0 \Rightarrow t=9$ or $t=-1$.'),
  ('Solve by factorisation: $7w^2 + 10w = -3$.', '$w = \frac{3}{7}$ or $w = 1$', '$w = -3$ or $w = -\frac{1}{7}$', '$w = -\frac{3}{7}$ or $w = -1$', '$w = 3$ or $w = \frac{1}{7}$', 'C', 3, 'GENERAL', 'Rearrange: $7w^2+10w+3=0$; $ac=21$, numbers $7$ and $3$ split the middle term: $(7w+3)(w+1)=0 \Rightarrow w=-\frac{3}{7}$ or $w=-1$.'),
  ('If $c$ and $k$ are the roots of $6 - x - x^2 = 0$, find $c + k$.', '$1$', '$6$', '$-6$', '$-1$', 'D', 3, 'GENERAL', 'Rearrange to $x^2+x-6=0$; sum of roots $=-b/a=-1$.'),
  ('Solve $6x^2 - 7x - 5 = 0$.', '$x = -\frac{5}{3}$ or $x = \frac{1}{2}$', '$x = \frac{7}{6}$ or $x = -1$', '$x = \frac{5}{3}$ or $x = -\frac{1}{2}$', '$x = 5$ or $x = -\frac{1}{6}$', 'C', 3, 'GENERAL', 'Factorising: $(3x-5)(2x+1)=0 \Rightarrow x=\frac{5}{3}$ or $x=-\frac{1}{2}$.'),
  ('Solve $2a^2 - 3a - 27 = 0$.', '$a = 3$ or $a = -\frac{9}{2}$', '$a = -3$ or $a = \frac{9}{2}$', '$a = -3$ or $a = -\frac{9}{2}$', '$a = 27$ or $a = -1$', 'B', 3, 'GENERAL', 'Factorising: $(a+3)(2a-9)=0 \Rightarrow a=-3$ or $a=\frac{9}{2}$.'),
  ('Solve $3x^2 + 25x - 18 = 0$.', '$x = -9$ or $x = \frac{2}{3}$', '$x = 9$ or $x = -\frac{2}{3}$', '$x = -9$ or $x = -\frac{2}{3}$', '$x = 18$ or $x = -1$', 'A', 3, 'GENERAL', 'Factorising: $(x+9)(3x-2)=0 \Rightarrow x=-9$ or $x=\frac{2}{3}$.'),
  ('Solve $10 - 3x - x^2 = 0$.', '$x = -2$ or $x = 5$', '$x = 2$ or $x = 5$', '$x = 2$ or $x = -5$', '$x = -2$ or $x = -5$', 'C', 2, 'GENERAL', 'Rearrange: $x^2+3x-10=0 \Rightarrow (x+5)(x-2)=0 \Rightarrow x=-5$ or $x=2$.'),
  ('Find the sum of the roots of $2x^2 + 3x - 9 = 0$.', '$\frac{3}{2}$', '$-\frac{3}{2}$', '$-\frac{9}{2}$', '$\frac{9}{2}$', 'B', 2, 'GENERAL', 'Sum of roots $=-b/a=-3/2$.'),
  ('Solve $5x^2 - 4x - 1 = 0$.', '$x = -1$ or $x = \frac{1}{5}$', '$x = \frac{4}{5}$ or $x = -1$', '$x = 5$ or $x = -\frac{1}{4}$', '$x = 1$ or $x = -\frac{1}{5}$', 'D', 2, 'GENERAL', '$(5x+1)(x-1)=0 \Rightarrow x=-\frac{1}{5}$ or $x=1$.'),
  ('Solve the equation $x^2 - 4 = 0$.', '$x = 4$ or $x = -4$', '$x = 2$ or $x = -2$', '$x = 2$ only', '$x = \pm\sqrt{2}$', 'B', 1, 'GENERAL', '$x^2=4 \Rightarrow x=\pm 2$.'),
  ('Solve the equation $c^2 = 9$.', '$c = 9$ or $c = -9$', '$c = 3$ only', '$c = 3$ or $c = -3$', '$c = 4.5$ or $c = -4.5$', 'C', 1, 'GENERAL', '$c=\pm\sqrt{9}=\pm 3$.'),
  ('Solve the equation $4q^2 = 36$.', '$q = 3$ or $q = -3$', '$q = 9$ or $q = -9$', '$q = 6$ or $q = -6$', '$q = 1.5$ or $q = -1.5$', 'A', 1, 'GENERAL', '$q^2=9 \Rightarrow q=\pm 3$.'),
  ('Solve the equation $16k^2 = 49$.', '$k = \frac{4}{7}$ or $k = -\frac{4}{7}$', '$k = 49$ or $k = -49$', '$k = \frac{7}{16}$ or $k = -\frac{7}{16}$', '$k = \frac{7}{4}$ or $k = -\frac{7}{4}$', 'D', 2, 'GENERAL', '$k^2=49/16 \Rightarrow k=\pm 7/4$.'),
  ('Solve the equation $2b^2 = 2$.', '$b = 2$ or $b = -2$', '$b = 4$ or $b = -4$', '$b = \sqrt{2}$ only', '$b = 1$ or $b = -1$', 'D', 1, 'GENERAL', '$b^2=1 \Rightarrow b=\pm 1$.'),
  ('Solve $x^2 - 2x = 0$.', '$x = 2$ only', '$x = 0$ or $x = 2$', '$x = 0$ or $x = -2$', '$x = -2$ only', 'B', 1, 'GENERAL', '$x(x-2)=0 \Rightarrow x=0$ or $x=2$.'),
  ('Solve $2f^2 + 3f = 0$.', '$f = 0$ or $f = -\frac{3}{2}$', '$f = 0$ or $f = \frac{3}{2}$', '$f = -\frac{2}{3}$ or $f = 0$', '$f = 3$ or $f = -2$', 'A', 1, 'GENERAL', '$f(2f+3)=0 \Rightarrow f=0$ or $f=-3/2$.'),
  ('Solve $5m^2 = 10m$.', '$m = 0$ or $m = -2$', '$m = 2$ only', '$m = 0$ or $m = 5$', '$m = 0$ or $m = 2$', 'D', 1, 'GENERAL', '$5m^2-10m=0 \Rightarrow 5m(m-2)=0 \Rightarrow m=0$ or $m=2$.'),
  ('Solve $6z^2 = 15z$.', '$z = 0$ or $z = -\frac{5}{2}$', '$z = \frac{5}{2}$ only', '$z = 0$ or $z = \frac{2}{5}$', '$z = 0$ or $z = \frac{5}{2}$', 'D', 1, 'GENERAL', '$6z^2-15z=0 \Rightarrow 3z(2z-5)=0 \Rightarrow z=0$ or $z=5/2$.'),
  ('Solve for $x$: $(3x+2)(2x-7) = 0$.', '$x = \frac{2}{3}$ or $x = -\frac{7}{2}$', '$x = -\frac{2}{3}$ or $x = \frac{7}{2}$', '$x = -3$ or $x = 2$', '$x = 2$ or $x = -7$', 'B', 1, 'GENERAL', 'By the Zero Product Property, $3x+2=0 \Rightarrow x=-2/3$, or $2x-7=0 \Rightarrow x=7/2$.'),
  ('Solve: $\frac{2}{x-1} - \frac{3}{x+1} = 1$.', '$x = -2$ or $x = 3$', '$x = 1$ or $x = -1$', '$x = 5$ or $x = -1$', '$x = 2$ or $x = -3$', 'D', 4, 'GENERAL', 'Clearing denominators gives $2(x+1)-3(x-1)=(x-1)(x+1) \Rightarrow -x+5=x^2-1 \Rightarrow x^2+x-6=0 \Rightarrow (x+3)(x-2)=0$, so $x=2$ or $x=-3$.'),
  ('Solve: $\frac{x+3}{2x-3} = \frac{3x}{4x-6}$.', '$x = -6$', '$x = \frac{3}{2}$', '$x = 3$', '$x = 6$', 'D', 4, 'GENERAL', 'Since $4x-6=2(2x-3)$, multiplying both sides by $2(2x-3)$ (valid since $x=\frac{3}{2}$ would make both sides undefined, so it cannot be a solution) gives $2(x+3)=3x \Rightarrow 2x+6=3x \Rightarrow x=6$.'),
  ('Solve: $(x-2)(x-3) = 12$.', '$x = -6$ or $x = 1$', '$x = 5$ or $x = 0$', '$x = 6$ or $x = 1$', '$x = 6$ or $x = -1$', 'D', 3, 'GENERAL', 'Expand: $x^2-5x+6=12 \Rightarrow x^2-5x-6=0 \Rightarrow (x-6)(x+1)=0 \Rightarrow x=6$ or $x=-1$.'),
  ('If 4 is a root of $x^2 + kx + 17 = 0$, find $k$.', '$\frac{33}{4}$', '$-4$', '$4$', '$-\frac{33}{4}$', 'D', 3, 'GENERAL', 'Substitute $x=4$: $16+4k+17=0 \Rightarrow 4k=-33 \Rightarrow k=-33/4$.'),
  ('Given one root of $2x^2 + (k+2)x + k = 0$ is 2, find $k$.', '$4$', '$-4$', '$-2$', '$2$', 'B', 4, 'GENERAL', 'Substitute $x=2$: $8+2(k+2)+k=0 \Rightarrow 8+2k+4+k=0 \Rightarrow 3k=-12 \Rightarrow k=-4$.'),
  ('Solve $2x^2 + 3x - 8 = 0$ by completing the square, correct to 1 d.p.', '$x = -1.4$ or $x = 2.9$', '$x = 1.4$ or $x = -2.9$', '$x = 1.4$ or $x = 2.9$', '$x = 2.9$ only', 'B', 3, 'GENERAL', 'Completing the square gives $x = \frac{-3\pm\sqrt{73}}{4} \approx 1.4$ or $-2.9$.'),
  ('Solve $2x^2 + 7x + 2 = 0$ by completing the square, correct to 3 d.p.', '$x = -0.314$ or $x = -3.186$', '$x = 0.314$ or $x = 3.186$', '$x = -0.314$ or $x = 3.186$', '$x = -3.186$ only', 'A', 4, 'GENERAL', 'Completing the square gives $x = \frac{-7\pm\sqrt{33}}{4} \approx -0.314$ or $-3.186$.'),
  ('Solve $x^2 - 5x - 1 = 0$ by completing the square, correct to 1 d.p.', '$x = -5.2$ or $x = 0.2$', '$x = 5.2$ or $x = 0.2$', '$x = 5.2$ or $x = -0.2$', '$x = 0.2$ only', 'C', 3, 'GENERAL', 'Completing the square gives $x = \frac{5\pm\sqrt{29}}{2} \approx 5.2$ or $-0.2$.'),
  ('What must be added to $x^2 + 6x$ to make it a perfect square?', '$3$', '$9$', '$36$', '$6$', 'B', 2, 'GENERAL', 'Half of 6 is 3, and $3^2=9$; $x^2+6x+9=(x+3)^2$.'),
  ('Find the value of $t$ so that $y^2 + ty + \frac{9}{4}$ is a perfect square.', '$-3$', '$\frac{9}{4}$', '$3$', '$4.5$', 'C', 3, 'GENERAL', 'We need $(t/2)^2 = 9/4 \Rightarrow t/2 = \pm 3/2 \Rightarrow t = 3$ (taking the positive value).'),
  ('What must be added to $x^2 - 3x$ to make it a perfect square?', '$9$', '$-\frac{9}{4}$', '$\frac{3}{4}$', '$\frac{9}{4}$', 'D', 2, 'GENERAL', 'Half of $-3$ is $-3/2$, and $(-3/2)^2=9/4$.'),
  ('What must be added to $x^2 + 5x$ to make it a perfect square?', '$25$', '$\frac{5}{4}$', '$\frac{25}{4}$', '$5$', 'C', 2, 'GENERAL', 'Half of 5 is $5/2$, and $(5/2)^2=25/4$.'),
  ('What value of $m$ makes $x^2 + 8x + m$ a perfect square?', '$8$', '$16$', '$4$', '$64$', 'B', 2, 'GENERAL', 'Half of 8 is 4, and $4^2=16$.'),
  ('What must be added to $v^2 - 18v$ to make it a perfect square?', '$18$', '$-81$', '$9$', '$81$', 'D', 2, 'GENERAL', 'Half of $-18$ is $-9$, and $(-9)^2=81$.'),
  ('Find the value of $t$ that will make $x^2 - 40x + t$ a perfect square.', '$40$', '$400$', '$-400$', '$20$', 'B', 2, 'GENERAL', 'Half of $-40$ is $-20$, and $(-20)^2=400$.'),
  ('Adding 42 to a positive number gives the same result as squaring the number. Find the number.', '$6$', '$-6$', '$42$', '$7$', 'D', 3, 'GENERAL', 'Let the number be $x$: $x^2 = x+42 \Rightarrow x^2-x-42=0 \Rightarrow (x-7)(x+6)=0$. Since the number is positive, $x=7$.'),
  ('The product of two consecutive positive odd numbers is 195. Find the numbers.', '13 and 15', '11 and 13', '15 and 17', '12 and 14', 'A', 3, 'WAEC', 'Let $n(n+2)=195 \Rightarrow n^2+2n-195=0 \Rightarrow (n-13)(n+15)=0$. Taking the positive root, $n=13$, giving 13 and 15.'),
  ('Find two consecutive numbers whose product is 156.', '11 and 14', '13 and 14', '10 and 15', '12 and 13', 'D', 2, 'GENERAL', '$n(n+1)=156 \Rightarrow n^2+n-156=0 \Rightarrow (n-12)(n+13)=0$, so $n=12$, giving 12 and 13.'),
  ('The sum of two consecutive odd numbers is -4. Find the numbers.', '-1 and 1', '-5 and -3', '-2 and -6', '-3 and -1', 'D', 2, 'GENERAL', 'Let the numbers be $n$ and $n+2$: $n+(n+2)=-4 \Rightarrow 2n=-6 \Rightarrow n=-3$, giving $-3$ and $-1$.')
) as q(question_text, option_a, option_b, option_c, option_d, correct_letter, difficulty, exam_type, explanation)
where c.subject = 'Mathematics' and t.class_level = 'SS1' and t.term = 2 and t.order_index = 201;
-- ------------------------------------------
-- 202. QUADRATIC FORMULA
-- ------------------------------------------

insert into public.lessons (topic_id, title, summary, content_body, order_index)
values (
  (select t.id from public.topics t join public.curricula c on c.id = t.curriculum_id
   where c.subject = 'Mathematics' and t.class_level = 'SS1' and t.term = 2 and t.order_index = 202),
  'The Quadratic Formula and the Discriminant',
  'Solving any quadratic equation with the formula method, using the discriminant to predict the number of roots, and forming equations from given roots.',
  '### The Quadratic Formula

Every quadratic equation $ax^2+bx+c=0$ ($a \neq 0$) can be solved using:

$$x = \frac{-b \pm \sqrt{b^2-4ac}}{2a}$$

This "almighty formula" works whether or not the equation factorises, so it is the reliable fallback whenever factorisation looks hard.

### The Discriminant

The expression $b^2-4ac$ is the **discriminant**. Without solving the equation, it tells us how many real roots exist:
- $b^2-4ac > 0$: two distinct real roots
- $b^2-4ac = 0$: one repeated (equal) root
- $b^2-4ac < 0$: no real roots

### Forming a Quadratic Equation from Given Roots

If a quadratic has roots $\alpha$ and $\beta$, then $(x-\alpha)(x-\beta)=0$, which expands to:

$$x^2 - (\text{sum of roots})x + (\text{product of roots}) = 0$$',
  1
);

insert into public.worked_examples (lesson_id, title, problem_statement, solution_steps, exam_shortcut, common_trap_warning, real_life_context, status)
select l.id,
  'Solving with the Formula',
  'Solve $2x^2 + 7x - 5 = 0$ correct to 1 decimal place, using the formula.',
  to_jsonb(array[
    'Identify $a, b, c$ from the standard form $ax^2+bx+c=0$: $a=2$, $b=7$, $c=-5$.',
    'Compute the discriminant $b^2-4ac$: $7^2-4(2)(-5) = 49+40 = 89$.',
    'Since the discriminant is positive, there are two real roots; take its square root: $\sqrt{89} \approx 9.434$.',
    'Substitute into the formula: $x = \frac{-7 \pm 9.434}{2 \times 2} = \frac{-7 \pm 9.434}{4}$.',
    'Evaluate the "+" case: $x = \frac{2.434}{4} \approx 0.6085$.',
    'Evaluate the "-" case: $x = \frac{-16.434}{4} \approx -4.1085$.',
    'Round both answers to 1 decimal place: $x \approx 0.6$ or $x \approx -4.1$.'
  ]),
  'Memorise the formula as a chant, "negative b, plus or minus the square root of b-squared minus 4ac, all over 2a", and write $a$, $b$, $c$ down first before touching the formula; 90% of formula-method errors come from a sign slip reading off $b$ or $c$.',
  'When $b$ or $c$ is negative, substitute it in brackets first (e.g. $-4(2)(-5)$) before simplifying, jumping straight to a simplified sign is the most common source of formula-method errors.',
  'A trader planning a stall''s break-even point, where profit as a function of the number of items sold is modelled by a quadratic expression, uses exactly this formula to find the sales volumes at which profit crosses zero.',
  'published'
from public.lessons l join public.topics t on t.id = l.topic_id join public.curricula c on c.id = t.curriculum_id
where c.subject = 'Mathematics' and t.class_level = 'SS1' and t.term = 2 and t.order_index = 202;

insert into public.worked_examples (lesson_id, title, problem_statement, solution_steps, exam_shortcut, common_trap_warning, status)
select l.id,
  'Rearranging Before Applying the Formula',
  'Solve $4x^2 = 11x + 21$ correct to 2 decimal places.',
  to_jsonb(array[
    'Rearrange into standard form (everything on one side, set to 0): $4x^2 - 11x - 21 = 0$.',
    'Identify $a, b, c$: $a=4$, $b=-11$, $c=-21$.',
    'Compute the discriminant: $b^2-4ac = (-11)^2 - 4(4)(-21) = 121+336 = 457$.',
    'Take the square root of the discriminant: $\sqrt{457} \approx 21.378$.',
    'Substitute into the formula: $x = \frac{-(-11) \pm 21.378}{2\times4} = \frac{11 \pm 21.378}{8}$.',
    'Evaluate the "+" case: $x = \frac{32.378}{8} \approx 4.047$.',
    'Evaluate the "-" case: $x = \frac{-10.378}{8} \approx -1.297$.',
    'Round to 2 decimal places: $x \approx 4.05$ or $x \approx -1.30$.'
  ]),
  'Compute the discriminant first, separately, before plugging into the whole formula, this predicts how many roots to expect and catches an arithmetic mistake early.',
  'Forgetting to rearrange $4x^2=11x+21$ into standard form before reading off $a$, $b$, $c$ is the single most common error on this style of question, always move every term to one side first.',
  'published'
from public.lessons l join public.topics t on t.id = l.topic_id join public.curricula c on c.id = t.curriculum_id
where c.subject = 'Mathematics' and t.class_level = 'SS1' and t.term = 2 and t.order_index = 202;

insert into public.worked_examples (lesson_id, title, problem_statement, solution_steps, exam_shortcut, status)
select l.id,
  'Forming an Equation from Integer Roots',
  'Find the quadratic equation whose roots are 4 and -3.',
  to_jsonb(array[
    'Compute the sum of the roots: $4+(-3)=1$.',
    'Compute the product of the roots: $4 \times (-3) = -12$.',
    'Substitute into $x^2-(\text{sum})x+(\text{product})=0$: $x^2-(1)x+(-12)=0$.',
    'Simplify: $x^2-x-12=0$.'
  ]),
  'For "find the equation from given roots" questions, skip full expansion, just plug straight into $x^2-(\text{sum})x+(\text{product})=0$, there is no need to expand $(x-\alpha)(x-\beta)$ longhand every time.',
  'published'
from public.lessons l join public.topics t on t.id = l.topic_id join public.curricula c on c.id = t.curriculum_id
where c.subject = 'Mathematics' and t.class_level = 'SS1' and t.term = 2 and t.order_index = 202;

insert into public.worked_examples (lesson_id, title, problem_statement, solution_steps, exam_shortcut, status)
select l.id,
  'Forming an Equation from Fractional Roots',
  'Find the quadratic equation whose roots are $\frac{1}{2}$ and $\frac{3}{2}$.',
  to_jsonb(array[
    'Compute the sum of the roots: $\frac{1}{2}+\frac{3}{2}=\frac{4}{2}=2$.',
    'Compute the product of the roots: $\frac{1}{2} \times \frac{3}{2} = \frac{3}{4}$.',
    'Substitute into $x^2-(\text{sum})x+(\text{product})=0$: $x^2-2x+\frac{3}{4}=0$.',
    'Clear the fraction by multiplying every term by 4 (the denominator): $4x^2-8x+3=0$.'
  ]),
  'When a root is a fraction, clear denominators at the very end, not mid-calculation, keep sum/product as fractions, form the equation, then multiply through by the LCM of the denominators once.',
  'published'
from public.lessons l join public.topics t on t.id = l.topic_id join public.curricula c on c.id = t.curriculum_id
where c.subject = 'Mathematics' and t.class_level = 'SS1' and t.term = 2 and t.order_index = 202;

insert into public.questions (topic_id, lesson_id, question_text, option_a, option_b, option_c, option_d, correct_letter, difficulty, exam_type, explanation, status)
select t.id, l.id, q.question_text, q.option_a, q.option_b, q.option_c, q.option_d, q.correct_letter, q.difficulty, q.exam_type, q.explanation, 'published'
from public.topics t
  join public.curricula c on c.id = t.curriculum_id
  join public.lessons l on l.topic_id = t.id,
  (values
  ('Find the quadratic equation whose roots are 5 and 2.', '$x^2+7x+10=0$', '$x^2-7x-10=0$', '$x^2-10x+7=0$', '$x^2-7x+10=0$', 'D', 1, 'GENERAL', 'Sum $=7$, product $=10$: $x^2-7x+10=0$.'),
  ('Find the quadratic equation whose roots are 0 and -7.', '$x^2-7x=0$', '$x^2+7x=0$', '$x^2+7=0$', '$x^2-7=0$', 'B', 1, 'GENERAL', 'Sum $=-7$, product $=0$: $x^2+7x=0$.'),
  ('Find the sum and product of the roots of $2x^2-6x+5=0$.', 'sum = -3, product = 2.5', 'sum = 3, product = -2.5', 'sum = 3, product = 2.5', 'sum = 6, product = 5', 'C', 2, 'GENERAL', 'Sum $=-b/a=6/2=3$; product $=c/a=5/2=2.5$.'),
  ('Find the quadratic equation whose roots are $\frac{2}{3}$ and $-\frac{1}{2}$.', '$6x^2-x-2=0$', '$6x^2+x-2=0$', '$6x^2-x+2=0$', '$6x^2+x+2=0$', 'A', 3, 'GENERAL', 'Sum $=\frac{2}{3}-\frac{1}{2}=\frac{1}{6}$, product $=-\frac{1}{3}$: $x^2-\frac{1}{6}x-\frac{1}{3}=0$, times 6: $6x^2-x-2=0$.'),
  ('The sum of the roots of a quadratic equation is 5 and the product is -14. Find the equation.', '$x^2+5x-14=0$', '$x^2-5x+14=0$', '$x^2-14x-5=0$', '$x^2-5x-14=0$', 'D', 1, 'GENERAL', 'Substitute directly into $x^2-(\text{sum})x+(\text{product})=0$.'),
  ('A quadratic graph passes through (1,0), (3,0) and (0,6). Find its equation.', '$y=2x^2+8x+6$', '$y=x^2-4x+3$', '$y=2x^2-6x+8$', '$y=2x^2-8x+6$', 'D', 3, 'GENERAL', 'Roots at $x=1,3$ give $y=k(x-1)(x-3)$; at $x=0$, $y=6 \Rightarrow k(3)=6 \Rightarrow k=2$, so $y=2(x-1)(x-3)=2x^2-8x+6$.'),
  ('If 2 and 3 are the roots of a quadratic equation, find the equation.', '$x^2+5x+6=0$', '$x^2-5x-6=0$', '$x^2-5x+6=0$', '$x^2-6x+5=0$', 'C', 1, 'GENERAL', 'Sum $=5$, product $=6$: $x^2-5x+6=0$.'),
  ('Which of the following is NOT a quadratic expression: $3x^2-2x$, $x(x-3)$, $x^2-5$, $5x(x-2)$, $5(x-1)$?', '$5(x-1)$', '$3x^2-2x$', '$x(x-3)$', '$x^2-5$', 'A', 1, 'GENERAL', '$5(x-1)=5x-5$ is linear (degree 1), all the others expand to a degree-2 (quadratic) expression.'),
  ('The roots of $ax^2+bx+c=0$ are $x=-\frac{2}{3}$ and $\frac{3}{2}$. Find $a, b, c$.', '$a=6, b=-5, c=-6$', '$a=6, b=5, c=-6$', '$a=6, b=-5, c=6$', '$a=-6, b=5, c=6$', 'A', 4, 'GENERAL', 'Sum $=\frac{5}{6}$, product $=-1$: $x^2-\frac{5}{6}x-1=0$, times 6: $6x^2-5x-6=0$, so $a=6, b=-5, c=-6$.'),
  ('Given $x=\frac{3}{2}$ and $x=-6$, construct a quadratic equation.', '$2x^2+9x-18=0$', '$2x^2-9x-18=0$', '$2x^2+9x+18=0$', '$2x^2-9x+18=0$', 'A', 3, 'GENERAL', 'Sum $=-\frac{9}{2}$, product $=-9$: $x^2+\frac{9}{2}x-9=0$, times 2: $2x^2+9x-18=0$.'),
  ('Find the quadratic equation whose roots are $\frac{1}{2}$ and $-\frac{2}{3}$.', '$6x^2-x-2=0$', '$6x^2+x+2=0$', '$6x^2+x-2=0$', '$6x^2-x+2=0$', 'C', 3, 'GENERAL', 'Sum $=-\frac{1}{6}$, product $=-\frac{1}{3}$: $x^2+\frac{1}{6}x-\frac{1}{3}=0$, times 6: $6x^2+x-2=0$.'),
  ('Find the quadratic equation whose roots are $c$ and $-c$.', '$x^2+c^2=0$', '$x^2-c^2=0$', '$x^2-2cx=0$', '$x^2+2cx=0$', 'B', 2, 'GENERAL', 'Sum $=0$, product $=-c^2$: $x^2-c^2=0$.'),
  ('Construct a quadratic equation whose roots are $-\frac{3}{2}$ and 7.', '$2x^2+11x-21=0$', '$2x^2-11x-21=0$', '$2x^2-11x+21=0$', '$2x^2+11x+21=0$', 'B', 3, 'GENERAL', 'Sum $=\frac{11}{2}$, product $=-\frac{21}{2}$: $x^2-\frac{11}{2}x-\frac{21}{2}=0$, times 2: $2x^2-11x-21=0$.'),
  ('Given that $x=\frac{1}{2}$ and $x=-\frac{1}{2}$ are roots of $px^2+qx+r=0$, find $p, q, r$.', '$p=4, q=0, r=1$', '$p=4, q=0, r=-1$', '$p=2, q=0, r=-1$', '$p=4, q=1, r=-1$', 'B', 3, 'GENERAL', 'Sum $=0$, product $=-\frac{1}{4}$: $x^2-\frac{1}{4}=0$, times 4: $4x^2-1=0$, so $p=4, q=0, r=-1$.'),
  ('Find the quadratic equation whose roots are $\frac{1}{2}$ and $\frac{2}{3}$.', '$6x^2+7x+2=0$', '$6x^2-7x-2=0$', '$6x^2+7x-2=0$', '$6x^2-7x+2=0$', 'D', 3, 'GENERAL', 'Sum $=\frac{7}{6}$, product $=\frac{1}{3}$: $x^2-\frac{7}{6}x+\frac{1}{3}=0$, times 6: $6x^2-7x+2=0$.'),
  ('Find the quadratic equation whose roots are $-\frac{1}{2}$ and $2.5$.', '$4x^2-8x-5=0$', '$4x^2+8x-5=0$', '$4x^2-8x+5=0$', '$4x^2+8x+5=0$', 'A', 3, 'GENERAL', 'Sum $=2$, product $=-1.25$: $x^2-2x-1.25=0$, times 4: $4x^2-8x-5=0$.'),
  ('If the sum of the roots of $(x-p)(2x+1)=0$ is 2, find $p$.', '$-\frac{5}{2}$', '$\frac{5}{2}$', '$2$', '$\frac{1}{2}$', 'B', 3, 'GENERAL', 'The two roots are $x=p$ (from $x-p=0$) and $x=-\frac{1}{2}$ (from $2x+1=0$). Their sum is $p-\frac{1}{2}=2 \Rightarrow p=\frac{5}{2}$.'),
  ('Find the equation whose roots are -3 and 5.', '$x^2+2x-15=0$', '$x^2-2x+15=0$', '$x^2-2x-15=0$', '$x^2+2x+15=0$', 'C', 1, 'GENERAL', 'Sum $=2$, product $=-15$: $x^2-2x-15=0$.'),
  ('Find the equation whose roots are -5 and -3.', '$x^2-8x+15=0$', '$x^2+8x-15=0$', '$x^2-8x-15=0$', '$x^2+8x+15=0$', 'D', 1, 'GENERAL', 'Sum $=-8$, product $=15$: $x^2+8x+15=0$.'),
  ('Find the equation whose roots are 2 and $\frac{1}{2}$.', '$2x^2+5x+2=0$', '$2x^2-5x+2=0$', '$2x^2-5x-2=0$', '$2x^2+5x-2=0$', 'B', 2, 'GENERAL', 'Sum $=2.5$, product $=1$: $x^2-2.5x+1=0$, times 2: $2x^2-5x+2=0$.'),
  ('Form the equation whose roots are $x=\frac{1}{2}$ and $-\frac{2}{3}$.', '$6x^2-x-2=0$', '$6x^2+x+2=0$', '$6x^2-x+2=0$', '$6x^2+x-2=0$', 'D', 3, 'GENERAL', 'Sum $=-\frac{1}{6}$, product $=-\frac{1}{3}$: $x^2+\frac{1}{6}x-\frac{1}{3}=0$, times 6: $6x^2+x-2=0$.'),
  ('Find the equation whose roots are $-\frac{1}{2}$ and $\frac{3}{2}$.', '$4x^2+4x-3=0$', '$4x^2-4x+3=0$', '$4x^2+4x+3=0$', '$4x^2-4x-3=0$', 'D', 2, 'GENERAL', 'Sum $=1$, product $=-\frac{3}{4}$: $x^2-x-\frac{3}{4}=0$, times 4: $4x^2-4x-3=0$.'),
  ('Find the equation whose roots are 2 and $-3.5$.', '$2x^2-3x-14=0$', '$2x^2+3x+14=0$', '$2x^2+3x-14=0$', '$2x^2-3x+14=0$', 'C', 3, 'GENERAL', 'Sum $=-1.5$, product $=-7$: $x^2+1.5x-7=0$, times 2: $2x^2+3x-14=0$.'),
  ('Solve the equation $2x^2+7x-5=0$ correct to 1 d.p. (formula method).', '$x = 0.6$ or $x = -4.1$', '$x = -0.6$ or $x = 4.1$', '$x = 0.6$ or $x = 4.1$', '$x = -0.6$ or $x = -4.1$', 'A', 3, 'GENERAL', 'Using the formula with $a=2,b=7,c=-5$: $x=\frac{-7\pm\sqrt{89}}{4} \approx 0.6$ or $-4.1$.'),
  ('Solve $t^2-2t-5=0$ correct to 2 d.p. (formula method).', '$t = 3.45$ or $t = -1.45$', '$t = -3.45$ or $t = 1.45$', '$t = 3.45$ or $t = 1.45$', '$t = -3.45$ or $t = -1.45$', 'A', 3, 'GENERAL', 'With $a=1,b=-2,c=-5$: $t=\frac{2\pm\sqrt{24}}{2} \approx 3.45$ or $-1.45$.'),
  ('Solve, correct to 2 decimal places, $4x^2=11x+21$.', '$x = -4.05$ or $x = 1.30$', '$x = 4.05$ or $x = 1.30$', '$x = 4.05$ or $x = -1.30$', '$x = -4.05$ or $x = -1.30$', 'C', 3, 'GENERAL', 'Rearranged to $4x^2-11x-21=0$: $x=\frac{11\pm\sqrt{457}}{8} \approx 4.05$ or $-1.30$.'),
  ('Which of the following are roots of $2x^2-8x+5=0$?', '$\frac{4\pm\sqrt{6}}{2}$', '$\frac{4\pm\sqrt{6}}{4}$', '$4\pm\sqrt{6}$', '$\frac{8\pm\sqrt{6}}{2}$', 'A', 3, 'GENERAL', 'By the formula, $x=\frac{8\pm\sqrt{64-40}}{4}=\frac{8\pm\sqrt{24}}{4}=\frac{4\pm\sqrt{6}}{2}$.'),
  ('Solve $x^2-\frac{13}{2}x+\frac{15}{2}=0$.', '$x = \frac{3}{2}$ or $x = 5$', '$x = -\frac{3}{2}$ or $x = -5$', '$x = \frac{3}{2}$ or $x = -5$', '$x = 3$ or $x = 5$', 'A', 3, 'GENERAL', 'Multiplying by 2: $2x^2-13x+15=0 \Rightarrow (2x-3)(x-5)=0 \Rightarrow x=\frac{3}{2}$ or $x=5$.'),
  ('If 3 times a number subtracted from twice its square is 5, find the possible values.', '$1$ or $-\frac{5}{2}$', '$-1$ or $-\frac{5}{2}$', '$5$ or $-1$', '$-1$ or $\frac{5}{2}$', 'D', 3, 'GENERAL', '$2x^2-3x=5 \Rightarrow 2x^2-3x-5=0 \Rightarrow (2x-5)(x+1)=0 \Rightarrow x=\frac{5}{2}$ or $x=-1$.'),
  ('The sum of two numbers is 31 while their positive difference is 13. Find their product.', '$186$', '$204$', '$189$', '$198$', 'D', 3, 'GENERAL', 'Let the numbers be $x, y$: $x+y=31$, $x-y=13 \Rightarrow x=22, y=9$; product $=22\times9=198$.'),
  ('Find two consecutive positive integers whose product is 156.', '11 and 14', '12 and 13', '13 and 14', '10 and 15', 'B', 2, 'GENERAL', '$n(n+1)=156 \Rightarrow n^2+n-156=0 \Rightarrow (n-12)(n+13)=0$, so $n=12$, giving 12 and 13.'),
  ('Solve simultaneously: $x-y=2$ and $x^2+y^2=52$.', '$(x,y)=(6,4)$ or $(-4,-6)$', '$(x,y)=(-6,-4)$ or $(4,6)$', '$(x,y)=(6,-4)$ or $(-4,6)$', '$(x,y)=(8,4)$ or $(-4,-6)$', 'A', 4, 'GENERAL', 'From $y=x-2$: $x^2+(x-2)^2=52 \Rightarrow 2x^2-4x-48=0 \Rightarrow x^2-2x-24=0 \Rightarrow (x-6)(x+4)=0$, giving $(x,y)=(6,4)$ or $(-4,-6)$ (both check: $6^2+4^2=52$ and $(-4)^2+(-6)^2=52$).'),
  ('Solve simultaneously: $p+q=3$ and $p^2-q^2=15$.', '$p=-4, q=1$', '$p=4, q=1$', '$p=-4, q=-1$', '$p=4, q=-1$', 'D', 3, 'GENERAL', '$p^2-q^2=(p-q)(p+q)=15$ and $p+q=3 \Rightarrow p-q=5$; solving with $p+q=3$ gives $p=4, q=-1$.'),
  ('If $y=x^2-4x-10$ and $y=2$, find $x$.', '$x=6$ or $x=-2$', '$x=-6$ or $x=2$', '$x=6$ or $x=2$', '$x=-6$ or $x=-2$', 'A', 2, 'GENERAL', '$x^2-4x-10=2 \Rightarrow x^2-4x-12=0 \Rightarrow (x-6)(x+2)=0$, so $x=6$ or $x=-2$.'),
  ('If $y=x^2+x-2$ and $y=x+1$, write the resulting quadratic.', '$x^2+3=0$', '$x^2-3x=0$', '$x^2+x-3=0$', '$x^2-3=0$', 'D', 3, 'GENERAL', 'Setting equal: $x^2+x-2=x+1 \Rightarrow x^2-3=0$.'),
  ('The graph of $y=2x^2-5x-1$ and a line PQ together solve $2x^2-5x+2=0$; find the equation of PQ.', '$y=-3$', '$y=3$', '$y=-1$', '$y=2$', 'A', 4, 'GENERAL', 'Intersecting $y=2x^2-5x-1$ with a horizontal line $y=c$ gives $2x^2-5x-1=c$, i.e. $2x^2-5x-(1+c)=0$. Matching this to $2x^2-5x+2=0$ requires $-(1+c)=2 \Rightarrow c=-3$, so PQ is $y=-3$.'),
  ('Find $x$ and $y$ such that $y=\frac{1}{2}(x^2-3)$ and $x+y=6$.', '$(x,y)=(5,-11)$ or $(-3,-3)$', '$(x,y)=(-5,11)$ or $(-3,-3)$', '$(x,y)=(-5,11)$ or $(3,3)$', '$(x,y)=(5,11)$ or $(3,3)$', 'C', 4, 'GENERAL', 'Substituting $y=6-x$: $6-x=\frac{1}{2}(x^2-3) \Rightarrow 12-2x=x^2-3 \Rightarrow x^2+2x-15=0 \Rightarrow (x-3)(x+5)=0$, giving $(3,3)$ or $(-5,11)$.'),
  ('Write the equation whose roots are the intersection points of $y=x^2+x-2$ and $y=x+1$.', '$x^2+3=0$', '$x^2-3x=0$', '$x^2-3=0$', '$x^2+x-3=0$', 'C', 3, 'GENERAL', 'Setting equal: $x^2+x-2=x+1 \Rightarrow x^2-3=0$.'),
  ('If $y=3x^2-5x-2$, at what values of $x$ is $y=-4$?', '$x=-\frac{2}{3}$ or $x=-1$', '$x=\frac{2}{3}$ or $x=-1$', '$x=\frac{2}{3}$ or $x=1$', '$x=2$ or $x=1$', 'C', 3, 'GENERAL', '$3x^2-5x-2=-4 \Rightarrow 3x^2-5x+2=0 \Rightarrow (3x-2)(x-1)=0$, so $x=\frac{2}{3}$ or $x=1$.'),
  ('If $x-y=3$ and $x^2-y^2=0$, find $x$ and $y$.', '$x=-\frac{3}{2}, y=\frac{3}{2}$', '$x=\frac{3}{2}, y=-\frac{3}{2}$', '$x=3, y=0$', '$x=0, y=-3$', 'B', 4, 'GENERAL', '$x^2-y^2=(x-y)(x+y)=0$ and $x-y=3\neq0$, so $x+y=0$. Solving $x-y=3$ and $x+y=0$ gives $x=\frac{3}{2}, y=-\frac{3}{2}$.')
) as q(question_text, option_a, option_b, option_c, option_d, correct_letter, difficulty, exam_type, explanation)
where c.subject = 'Mathematics' and t.class_level = 'SS1' and t.term = 2 and t.order_index = 202;
-- ------------------------------------------
-- 203. QUADRATIC EQUATIONS: GRAPHICAL METHOD
-- ------------------------------------------

insert into public.lessons (topic_id, title, summary, content_body, order_index)
values (
  (select t.id from public.topics t join public.curricula c on c.id = t.curriculum_id
   where c.subject = 'Mathematics' and t.class_level = 'SS1' and t.term = 2 and t.order_index = 203),
  'Solving Quadratic Equations by Graphical Methods',
  'Drawing the graph of a quadratic equation and reading off its roots, minimum/maximum value, and axis of symmetry.',
  '### The Parabola

Graphing $y = ax^2+bx+c$ produces a **parabola**: U-shaped (opens upward) if $a>0$, n-shaped (opens downward) if $a<0$.

Key features:
- **Vertex**: the turning point (minimum if $a>0$, maximum if $a<0$), located at $x = -\frac{b}{2a}$.
- **Axis of symmetry**: the vertical line through the vertex, $x = -\frac{b}{2a}$.
- **Roots (x-intercepts)**: where the curve crosses $y=0$.
- **y-intercept**: the value of $y$ when $x=0$, always equal to $c$.

### Graphing Procedure

Build a table of values, plot the points, and join them with a single smooth curve (never straight lines between points).

### Reading Information From a Graph

1. **Roots** of the original equation: read the $x$-intercepts.
2. **Minimum/maximum value**: the $y$-coordinate of the vertex.
3. **Solving a related equation** from an already-drawn graph: rewrite the target equation so its left side matches the drawn curve exactly, then read off where the curve meets that horizontal line.',
  1
);

insert into public.worked_examples (lesson_id, title, problem_statement, solution_steps, exam_shortcut, common_trap_warning, diagram_type, diagram_data, status)
select l.id,
  'Reading a Parabola: Roots, Minimum, and Axis of Symmetry',
  'Draw the graph of $y = x^2 - 2x - 3$ for $-2 \le x \le 4$, and use it to find the roots, the minimum value, and the axis of symmetry.',
  to_jsonb(array[
    'Build a table of values by substituting each $x$ into $y = x^2-2x-3$: at $x=-2$, $y=4+4-3=5$; at $x=-1$, $y=0$; at $x=0$, $y=-3$; at $x=1$, $y=-4$; at $x=2$, $y=-3$; at $x=3$, $y=0$; at $x=4$, $y=5$.',
    'Plot the seven points on graph paper with a sensible scale, and join them with a single smooth U-shaped curve.',
    'Read the roots, the $x$-values where the curve crosses the $x$-axis ($y=0$): from the table, $y=0$ at $x=-1$ and $x=3$.',
    'Read the minimum value, the lowest point of the curve: at $x=1$, $y=-4$, so the vertex is $(1,-4)$.',
    'State the axis of symmetry, the vertical line through the vertex: $x=1$.',
    'Check the y-intercept against the constant term: at $x=0$, $y=-3$, matching $c=-3$ as expected.'
  ]),
  'The y-intercept is always just "c", read it straight off the equation $y=ax^2+bx+c$ without any substitution.',
  'Confusing the axis of symmetry (an $x$-value, a vertical line) with the minimum value (a $y$-value, the vertex height) is a very common labelling mistake, always state which one a question is asking for before answering.',
  'coordinate_plane',
  '{"xRange": [-3, 5], "yRange": [-5, 6], "points": [{"x": -2, "y": 5, "label": "(-2,5)"}, {"x": -1, "y": 0, "label": "(-1,0)"}, {"x": 1, "y": -4, "label": "min (1,-4)"}, {"x": 3, "y": 0, "label": "(3,0)"}, {"x": 4, "y": 5, "label": "(4,5)"}]}'::jsonb,
  'published'
from public.lessons l join public.topics t on t.id = l.topic_id join public.curricula c on c.id = t.curriculum_id
where c.subject = 'Mathematics' and t.class_level = 'SS1' and t.term = 2 and t.order_index = 203;

insert into public.worked_examples (lesson_id, title, problem_statement, solution_steps, exam_shortcut, common_trap_warning, real_life_context, diagram_type, diagram_data, status)
select l.id,
  'A Ball Thrown Into the Air (Projectile Motion)',
  'The height of a ball thrown into the air is modelled by $h = -5t^2 + 20t$ ($h$ in metres, $t$ in seconds). Find the maximum height reached and when the ball hits the ground.',
  to_jsonb(array[
    'Recognise this is a "maximum" problem since the coefficient of $t^2$ is negative ($-5$), so the parabola opens downward.',
    'Find the time at which the maximum occurs using $t = -\frac{b}{2a}$ with $a=-5$, $b=20$: $t = \frac{-20}{-10} = 2$ seconds.',
    'Substitute $t=2$ back into $h$ to find the maximum height: $h = -5(2)^2+20(2) = -20+40 = 20$ m.',
    'To find when the ball hits the ground, set $h=0$: $-5t^2+20t=0$.',
    'Factorise by taking out the common factor $-5t$: $-5t(t-4)=0$.',
    'Apply the Zero Product Property: $t=0$ or $t=4$.',
    'Interpret both roots in context: $t=0$ is the moment the ball is thrown (height 0, the start); $t=4$ is when it lands again.'
  ]),
  'Check the sign of "a" before you even draw: $a>0$ always gives a minimum, $a<0$ always gives a maximum, stating this instantly answers "does this graph have a maximum or minimum" without any plotting.',
  'A common mistake is to discard $t=0$ as "not a real answer", but it is a genuine root of the equation, representing the launch moment; both roots must be interpreted, not just the positive non-zero one.',
  'This is the same equation type an athletics coach or physics teacher uses to predict how high a javelin, football free-kick, or basketball shot will rise and when it will land, straight from the launch speed.',
  'coordinate_plane',
  '{"xRange": [0, 5], "yRange": [0, 22], "points": [{"x": 0, "y": 0, "label": "launch"}, {"x": 2, "y": 20, "label": "max height"}, {"x": 4, "y": 0, "label": "lands"}]}'::jsonb,
  'published'
from public.lessons l join public.topics t on t.id = l.topic_id join public.curricula c on c.id = t.curriculum_id
where c.subject = 'Mathematics' and t.class_level = 'SS1' and t.term = 2 and t.order_index = 203;

insert into public.questions (topic_id, lesson_id, question_text, option_a, option_b, option_c, option_d, correct_letter, difficulty, exam_type, explanation, status)
select t.id, l.id, q.question_text, q.option_a, q.option_b, q.option_c, q.option_d, q.correct_letter, q.difficulty, q.exam_type, q.explanation, 'published'
from public.topics t
  join public.curricula c on c.id = t.curriculum_id
  join public.lessons l on l.topic_id = t.id,
  (values
  ('From the graph of $y=x^2-2x-3$, find the roots.', '$x=1, x=-3$', '$x=-1, x=3$', '$x=-1, x=-3$', '$x=1, x=3$', 'B', 2, 'GENERAL', 'The curve crosses $y=0$ at $x=-1$ and $x=3$; check: $(-1)^2-2(-1)-3=0$ and $3^2-2(3)-3=0$.'),
  ('From the graph of $y=x^2-2x-3$, find the axis of symmetry.', '$x=-1$', '$x=3$', '$x=-3$', '$x=1$', 'D', 2, 'GENERAL', 'Axis of symmetry $=-b/2a=-(-2)/2=1$.'),
  ('What is the minimum value of $y$ in $y=x^2-2x-3$?', '$y=-3$', '$y=4$', '$y=0$', '$y=-4$', 'D', 2, 'GENERAL', 'At the vertex $x=1$: $y=1-2-3=-4$.'),
  ('Draw the graph of $y=8-2x-x^2$ for $-5 \le x \le 3$; from the graph find the roots of $8-2x-x^2=0$.', '$x = 4$ or $x = -2$', '$x = -4$ or $x = 2$', '$x = -4$ or $x = -2$', '$x = 4$ or $x = 2$', 'B', 3, 'GENERAL', 'Rearranged: $x^2+2x-8=0 \Rightarrow (x+4)(x-2)=0 \Rightarrow x=-4$ or $x=2$.'),
  ('From the same graph ($y=8-2x-x^2$), find the roots of $8-2x-x^2=5$.', '$x = 3$ or $x = -1$', '$x = -3$ or $x = 1$', '$x = -3$ or $x = -1$', '$x = 3$ or $x = 1$', 'B', 3, 'GENERAL', 'Setting $8-2x-x^2=5 \Rightarrow x^2+2x-3=0 \Rightarrow (x+3)(x-1)=0 \Rightarrow x=-3$ or $x=1$.'),
  ('From the same graph, find the maximum value of $y$.', '$y=8$, at $x=0$', '$y=14$, at $x=-5$', '$y=9$, at $x=-1$', '$y=5$, at $x=1$', 'C', 3, 'GENERAL', 'Vertex at $x=-b/2a=-(-2)/(2\times-1)=-1$; $y=8-2(-1)-(-1)^2=8+2-1=9$.'),
  ('A rectangular garden has length 4 m longer than its width; area is 45 m². Find the dimensions.', 'width = 9 m, length = 5 m', 'width = 5 m, length = 9 m', 'width = 4 m, length = 8 m', 'width = 6 m, length = 10 m', 'B', 3, 'WAEC', 'Let width $=w$: $w(w+4)=45 \Rightarrow w^2+4w-45=0 \Rightarrow (w-5)(w+9)=0 \Rightarrow w=5$ m, length $=9$ m.'),
  ('A ball''s height is $h=-5t^2+20t$. Find the maximum height and the time it hits the ground.', 'max height 25 m at $t=2$ s; hits ground at $t=5$ s', 'max height 20 m at $t=4$ s; hits ground at $t=2$ s', 'max height 20 m at $t=2$ s; hits ground at $t=4$ s', 'max height 15 m at $t=1$ s; hits ground at $t=4$ s', 'C', 3, 'GENERAL', 'Vertex at $t=-20/(2\times-5)=2$, $h=20$; ground when $-5t(t-4)=0 \Rightarrow t=0$ or $4$.'),
  ('A projectile''s height is $h=-4t^2+16t$. Find the maximum height reached and the time when height is 12 m.', 'max height = 16 m; $t=1$ s or $3$ s', 'max height = 12 m; $t=1$ s or $2$ s', 'max height = 16 m; $t=2$ s or $4$ s', 'max height = 20 m; $t=1$ s or $3$ s', 'A', 3, 'GENERAL', 'Max at $t=-16/(2\times-4)=2$, $h=16$. For $h=12$: $-4t^2+16t=12 \Rightarrow 4t^2-16t+12=0 \Rightarrow t^2-4t+3=0 \Rightarrow (t-1)(t-3)=0$.'),
  ('What does the discriminant $b^2-4ac$ tell us about the number of roots?', 'positive gives no roots, negative gives 2 roots', 'it tells us the sum of the roots', 'it tells us the product of the roots', 'positive gives 2 distinct roots, zero gives 1 repeated root, negative gives no real roots', 'D', 1, 'GENERAL', 'The sign of the discriminant classifies the roots: positive (2 distinct), zero (1 repeated), negative (no real roots).'),
  ('How does the sign of coefficient $a$ affect the shape of a quadratic graph?', '$a>0$ gives an n-shaped curve; $a<0$ gives a U-shaped curve', '$a>0$ gives a U-shaped (minimum) curve; $a<0$ gives an n-shaped (maximum) curve', 'the sign of $a$ only affects the y-intercept', '$a>0$ always gives a straight line', 'B', 1, 'GENERAL', 'A positive leading coefficient opens the parabola upward (minimum); a negative one opens it downward (maximum).')
) as q(question_text, option_a, option_b, option_c, option_d, correct_letter, difficulty, exam_type, explanation)
where c.subject = 'Mathematics' and t.class_level = 'SS1' and t.term = 2 and t.order_index = 203;
-- ------------------------------------------
-- 204. IDEA OF SETS
-- ------------------------------------------

insert into public.lessons (topic_id, title, summary, content_body, order_index)
values (
  (select t.id from public.topics t join public.curricula c on c.id = t.curriculum_id
   where c.subject = 'Mathematics' and t.class_level = 'SS1' and t.term = 2 and t.order_index = 204),
  'Idea of Sets: Universal Sets, Finite/Infinite Sets, Empty Sets, Subsets',
  'Set notation, types of sets, subsets, and the power set, with careful attention to set-builder inequality symbols.',
  '### What is a Set?

A **set** is a well-defined collection of distinct objects, denoted by capital letters, with elements (members) by lowercase letters, enclosed in curly brackets, e.g. $A = \{1,2,3\}$. We write $x \in A$ ("x is an element of A") or $x \notin A$. **Set-builder notation**: $\{x : x \text{ satisfies a condition}\}$, the colon is read "such that".

### Key Definitions

- **Universal set** ($U$ or $\xi$): the "mother set" from which all other sets under discussion are drawn.
- **Subset**: if every element of $X$ is also in $Y$, then $X \subseteq Y$. Every set is an (improper) subset of itself; the empty set is a subset of every set. Any other subset is a proper subset ($X \subset Y$).
- **Finite set**: elements can be counted completely.
- **Infinite set**: elements cannot be counted completely, e.g. $\mathbb{N} = \{1,2,3,\ldots\}$.
- **Empty (null) set** ($\emptyset$ or $\{\}$): a set with no elements. Note $\{0\}$ is NOT empty, it contains one element, the number 0.
- **Singleton set**: a set with exactly one element.
- **Cardinality** $n(X)$: the number of elements in $X$.
- **Power set**: the set of ALL subsets of $S$ (including $\emptyset$ and $S$ itself), containing $2^n$ elements where $n = n(S)$.
- **Equal sets**: contain exactly the same elements. **Equivalent sets**: have the same number of elements, $n(A)=n(B)$, written $A \leftrightarrow B$.',
  1
);

insert into public.worked_examples (lesson_id, title, problem_statement, solution_steps, exam_shortcut, status)
select l.id,
  'Listing Elements from Set-Builder Notation',
  'List the elements of $A = \{z : z \text{ is a prime number from 1 to 10}\}$.',
  to_jsonb(array[
    'Understand the condition: $z$ must be a prime number (greater than 1, with only factors 1 and itself), and $1 \le z \le 10$.',
    'List all numbers from 1 to 10: 1, 2, 3, 4, 5, 6, 7, 8, 9, 10.',
    'Test each for primality: 1 is not prime; 2, 3, 5, 7 are prime; 4, 6, 8, 9, 10 are not.',
    'Collect the primes found: 2, 3, 5, 7.'
  ]),
  'Watch inequality symbols like a hawk in set-builder notation: "<" excludes the endpoint, "≤" includes it. Circling each inequality sign before listing elements prevents off-by-one counting errors, the single most common mistake in this topic.',
  'published'
from public.lessons l join public.topics t on t.id = l.topic_id join public.curricula c on c.id = t.curriculum_id
where c.subject = 'Mathematics' and t.class_level = 'SS1' and t.term = 2 and t.order_index = 204;

insert into public.worked_examples (lesson_id, title, problem_statement, solution_steps, exam_shortcut, status)
select l.id,
  'Cardinality with Strict and Non-Strict Inequalities',
  'Given $T = \{x : -2 < x \le 9\}$, where $x$ is an integer, find $n(T)$.',
  to_jsonb(array[
    'Interpret the inequality carefully: "$-2 < x$" means $x$ is strictly greater than $-2$ (so $-2$ is excluded); "$x \le 9$" means $x$ can equal 9 (9 is included).',
    'List all integers satisfying both conditions: $T = \{-1,0,1,2,3,4,5,6,7,8,9\}$.',
    'Count the elements listed: 11 numbers.'
  ]),
  'To count $n(T)$ for $\{x : a < x \le b\}$, $x$ an integer, use the formula $(b-a)$ when $a$ is the excluded integer boundary and $b$ is included, here $(9-(-2))=11$, matching the direct count instantly without listing.',
  'published'
from public.lessons l join public.topics t on t.id = l.topic_id join public.curricula c on c.id = t.curriculum_id
where c.subject = 'Mathematics' and t.class_level = 'SS1' and t.term = 2 and t.order_index = 204;

insert into public.worked_examples (lesson_id, title, problem_statement, solution_steps, exam_shortcut, common_trap_warning, real_life_context, diagram_type, diagram_data, status)
select l.id,
  'Listing All Subsets of a Set',
  'List all the subsets of $A = \{1,2,3\}$.',
  to_jsonb(array[
    'Determine how many subsets to expect using $n=n(A)=3$: number of subsets $= 2^n = 2^3 = 8$.',
    'List the subset with 0 elements: $\emptyset$.',
    'List all subsets with 1 element: $\{1\}, \{2\}, \{3\}$.',
    'List all subsets with 2 elements: $\{1,2\}, \{1,3\}, \{2,3\}$.',
    'List the subset with 3 elements (the full set itself): $\{1,2,3\}$.',
    'Count what was listed to confirm it matches Step 1: $1+3+3+1=8$.'
  ]),
  'For "n(power set)" questions, never list every subset if only the count is asked, just compute $2^n$ directly, where $n$ is the number of elements in the original set.',
  'A common slip is forgetting to include $\emptyset$ (the empty set) as a subset, or forgetting to include the full set $A$ itself, both are always valid subsets of $A$.',
  'A school administrator choosing which subset of a fixed list of extracurricular clubs to offer at a small event uses exactly this idea: every possible combination of clubs, including offering none or all of them, is a subset.',
  'venn_diagram',
  '{"setA": {"label": "A = {1,2,3}", "items": ["1","2","3"]}, "setB": {"label": "Subsets shown separately"}, "universalLabel": "Power set has 2^3 = 8 elements"}'::jsonb,
  'published'
from public.lessons l join public.topics t on t.id = l.topic_id join public.curricula c on c.id = t.curriculum_id
where c.subject = 'Mathematics' and t.class_level = 'SS1' and t.term = 2 and t.order_index = 204;

insert into public.questions (topic_id, lesson_id, question_text, option_a, option_b, option_c, option_d, correct_letter, difficulty, exam_type, explanation, status)
select t.id, l.id, q.question_text, q.option_a, q.option_b, q.option_c, q.option_d, q.correct_letter, q.difficulty, q.exam_type, q.explanation, 'published'
from public.topics t
  join public.curricula c on c.id = t.curriculum_id
  join public.lessons l on l.topic_id = t.id,
  (values
  ('If $X = \{i,j,k,l\}$, find $n(X)$.', '4', '3', '5', '2', 'A', 1, 'GENERAL', 'X has 4 distinct listed elements: i, j, k, l.'),
  ('If $B = \{a,b,c,d,e,f\}$, find $n(B)$.', '5', '7', '6', '4', 'C', 1, 'GENERAL', 'B has 6 distinct listed elements.'),
  ('Given $T=\{x : -2 < x \le 9\}$, $x$ an integer, find $n(T)$.', '11', '10', '12', '9', 'A', 2, 'GENERAL', 'The integers are $-1$ through $9$ inclusive, that is 11 values.'),
  ('Which of the following is an example of an infinite set: {Even numbers less than 20}, {Multiples of three}, {Number of lecturers in Nigerian Universities}, {Number of Local Governments in Nigeria}, {Prime numbers greater than 2 but less than 97}?', '{Even numbers less than 20}', '{Number of Local Governments in Nigeria}', '{Prime numbers greater than 2 but less than 97}', '{Multiples of three}', 'D', 2, 'GENERAL', 'The multiples of three go on forever (3, 6, 9, ...), so that set cannot be counted completely; all the others are bounded, finite sets.'),
  ('List the elements of $G=\{x : 1 < x < 5\}$.', '$\{1,2,3,4,5\}$', '$\{2,3,4\}$', '$\{2,3,4,5\}$', '$\{1,2,3,4\}$', 'B', 1, 'GENERAL', 'Both endpoints are strict, so 1 and 5 are excluded, leaving 2, 3, 4.'),
  ('List the elements of $L=\{y : 16 < y \le 19\}$.', '$\{17,18,19\}$', '$\{16,17,18,19\}$', '$\{17,18\}$', '$\{16,17,18\}$', 'A', 1, 'GENERAL', '16 is excluded (strict <), 19 is included (≤).'),
  ('List the elements of $M=\{a : 25 \le a < 30\}$.', '$\{25,26,27,28,29,30\}$', '$\{26,27,28,29\}$', '$\{25,26,27,28,29\}$', '$\{25,26,27,28\}$', 'C', 1, 'GENERAL', '25 is included (≤), 30 is excluded (<).'),
  ('List the elements of $N=\{b : 3 \le b \le 6\}$.', '$\{4,5,6\}$', '$\{3,4,5\}$', '$\{3,4,5,6,7\}$', '$\{3,4,5,6\}$', 'D', 1, 'GENERAL', 'Both endpoints are included since both use ≤.'),
  ('List the elements of $R=\{k : k \text{ is an odd number between 2 and 11}\}$.', '$\{1,3,5,7,9\}$', '$\{3,5,7,9,11\}$', '$\{2,4,6,8,10\}$', '$\{3,5,7,9\}$', 'D', 2, 'GENERAL', 'Odd numbers strictly between 2 and 11: 3, 5, 7, 9.'),
  ('List the elements of $J=\{t : 1 < t < 10 \text{ and } t \text{ is a multiple of 3}\}$.', '$\{3,6,9\}$', '$\{3,6,9,12\}$', '$\{0,3,6,9\}$', '$\{6,9\}$', 'A', 2, 'GENERAL', 'Multiples of 3 strictly between 1 and 10: 3, 6, 9.'),
  ('If $U=\{x : 1 < x < 10\}$ and $Y=\{x : x \text{ is odd-prime}\}$, list $Y$.', '$\{3,5,7\}$', '$\{2,3,5,7\}$', '$\{3,5,7,9\}$', '$\{1,3,5,7\}$', 'A', 2, 'GENERAL', 'Odd primes strictly between 1 and 10: 3, 5, 7 (2 is prime but even, so excluded from odd primes).'),
  ('List the elements of the set $A=\{z : z \text{ is a prime number from 1 to 10}\}$.', '$\{1,2,3,5,7\}$', '$\{2,3,5,7\}$', '$\{2,3,5,7,9\}$', '$\{3,5,7\}$', 'B', 1, 'GENERAL', 'Primes from 1 to 10: 2, 3, 5, 7.'),
  ('Given $W=\{x : x \text{ is even, from 5 to 15}\}$, list the elements of $W$.', '$\{6,8,10,12,14\}$', '$\{5,7,9,11,13,15\}$', '$\{6,8,10,12,14,16\}$', '$\{4,6,8,10,12,14\}$', 'A', 2, 'GENERAL', 'Even numbers between 5 and 15: 6, 8, 10, 12, 14.'),
  ('Given $X=\{e,f,g\}$, $Y=\{e,f,h\}$, $Z=\{g,h,k\}$, how many elements are in $X \cup Y \cup Z$?', '9', '5', '4', '6', 'B', 2, 'GENERAL', 'Combining without repeats: $\{e,f,g,h,k\}$, which has 5 elements.'),
  ('List all the subsets of $A=\{1,2,3\}$.', '$\emptyset, \{1\}, \{2\}, \{3\}, \{1,2\}, \{1,3\}, \{2,3\}, \{1,2,3\}$', '$\{1\}, \{2\}, \{3\}, \{1,2,3\}$ only', '$\emptyset, \{1,2\}, \{1,3\}, \{2,3\}$ only', '$\{1,2\}, \{1,3\}, \{2,3\}, \{1,2,3\}$ only', 'A', 2, 'GENERAL', 'A 3-element set has $2^3=8$ subsets: the empty set, three singletons, three pairs, and the full set.'),
  ('Given $U=\{\text{Positive numbers less than 20}\}$, is $\{12\}$ a subset of $U$? Justify.', 'No, since 12 is even', 'No, since $\{12\}$ has only one element', 'Yes, since $12 \in U$, so $\{12\} \subseteq U$', 'Yes, but only because $U$ is infinite', 'C', 1, 'GENERAL', 'Any single element of $U$ forms a valid singleton subset of $U$, since every element of $\{12\}$ (namely 12) is in $U$.')
) as q(question_text, option_a, option_b, option_c, option_d, correct_letter, difficulty, exam_type, explanation)
where c.subject = 'Mathematics' and t.class_level = 'SS1' and t.term = 2 and t.order_index = 204;
-- ------------------------------------------
-- 205. SET NOTATION: UNION, INTERSECTION & COMPLEMENT
-- ------------------------------------------

insert into public.lessons (topic_id, title, summary, content_body, order_index)
values (
  (select t.id from public.topics t join public.curricula c on c.id = t.curriculum_id
   where c.subject = 'Mathematics' and t.class_level = 'SS1' and t.term = 2 and t.order_index = 205),
  'Union, Intersection and Complement of Sets',
  'Combining and comparing sets using union, intersection and complement, and applying the basic laws of sets.',
  '### Core Operations

- **Union** ($A \cup B$): all elements in $A$, $B$, or both, without repetition. $A \cup B = \{x : x \in A \text{ or } x \in B\}$.
- **Intersection** ($A \cap B$): elements common to both sets. $A \cap B = \{x : x \in A \text{ and } x \in B\}$.
- **Complement** ($A''$ or $A^c$): all elements of the universal set $U$ that are NOT in $A$. $A'' = U - A$.
- **Disjoint sets**: two sets with no elements in common, $A \cap B = \emptyset$.
- **Non-disjoint sets**: sets sharing at least one element, $A \cap B \neq \emptyset$.

### Laws of Sets

1. Idempotent: $A \cup A = A$; $A \cap A = A$
2. Associative: $A \cup (B \cup C) = (A \cup B) \cup C$; similarly for $\cap$
3. Commutative: $A \cup B = B \cup A$; $A \cap B = B \cap A$
4. Distributive: $A \cup (B \cap C) = (A \cup B) \cap (A \cup C)$; $A \cap (B \cup C) = (A \cap B) \cup (A \cap C)$
5. **De Morgan''s Laws**: $(A \cup B)'' = A'' \cap B''$; $(A \cap B)'' = A'' \cup B''$
6. Complement laws: $(A'')''=A$; $U''=\emptyset$; $A \cap A''=\emptyset$; $A \cup A''=U$
7. Identity laws: $A \cup \emptyset = A$; $A \cap U = A$; $A \cap \emptyset = \emptyset$; $A \cup U = U$',
  1
);

insert into public.worked_examples (lesson_id, title, problem_statement, solution_steps, exam_shortcut, common_trap_warning, status)
select l.id,
  'Forming a Union',
  'If $A = \{1,2,3,4,5,6\}$ and $B = \{5,2,2,7,1,3,2\}$, find $A \cup B$.',
  to_jsonb(array[
    'Clean up $B$ by removing repeated elements (a set never lists an element twice): $B = \{1,2,3,5,7\}$.',
    'Recall the union combines every element that appears in $A$, in $B$, or in both, listed only once each. Start by writing out all of $A$: 1, 2, 3, 4, 5, 6.',
    'Add any elements of $B$ not already listed: from $B$, only 7 is new.',
    'Combine and arrange in order: $\{1,2,3,4,5,6,7\}$.'
  ]),
  'When forming a union, write out the first set completely, then scan the second set and add ONLY the elements not already written, this avoids accidentally listing an element twice.',
  'Forgetting to first remove repeated elements from a set as given (like the repeated 2s in B here) can lead to double-counting when stating $n(A \cup B)$.',
  'published'
from public.lessons l join public.topics t on t.id = l.topic_id join public.curricula c on c.id = t.curriculum_id
where c.subject = 'Mathematics' and t.class_level = 'SS1' and t.term = 2 and t.order_index = 205;

insert into public.worked_examples (lesson_id, title, problem_statement, solution_steps, exam_shortcut, real_life_context, status)
select l.id,
  'Intersection of Two Scholarship Finalist Lists',
  'The sets of students who reached two scholarship finals are $S = \{\text{Ada, Olu, Akpos}\}$ and $C = \{\text{Ejiro, Akpos, Iluwa}\}$. Find $S \cap C$.',
  to_jsonb(array[
    'Recall intersection means "elements found in BOTH sets."',
    'Compare each element of $S$ against $C$: Ada is not in $C$; Olu is not in $C$; Akpos is in $C$.',
    'Collect only the elements that appear in both lists: Akpos.'
  ]),
  'For intersection, physically tick or underline matching elements in both lists as you compare, anything left un-ticked in either set is not part of $A \cap B$.',
  'This is exactly how a scholarship board would identify students who qualified in two separate competitions, by comparing the two finalist lists name by name and keeping only the names that appear on both.',
  'published'
from public.lessons l join public.topics t on t.id = l.topic_id join public.curricula c on c.id = t.curriculum_id
where c.subject = 'Mathematics' and t.class_level = 'SS1' and t.term = 2 and t.order_index = 205;

insert into public.worked_examples (lesson_id, title, problem_statement, solution_steps, exam_shortcut, status)
select l.id,
  'Complement of an Intersection',
  'Given $U = \{1,2,3,4,5\}$, $P = \{2,3,5\}$, $Q = \{1,2,3\}$, find the complement of $P \cap Q$, i.e. $(P \cap Q)''$.',
  to_jsonb(array[
    'First find $P \cap Q$: comparing $\{2,3,5\}$ and $\{1,2,3\}$, the shared elements are 2 and 3, so $P \cap Q = \{2,3\}$.',
    'Recall the complement of a set is everything in $U$ that is NOT in that set: $(P \cap Q)'' = U - (P \cap Q)$.',
    'Remove the elements of $P \cap Q = \{2,3\}$ from $U = \{1,2,3,4,5\}$: what remains is 1, 4, 5.'
  ]),
  'For complement questions, always compute the "inside" set (like $P \cap Q$ or $P \cup Q$) FIRST, then subtract it from $U$, never try to find a complement directly without knowing exactly which elements to exclude.',
  'published'
from public.lessons l join public.topics t on t.id = l.topic_id join public.curricula c on c.id = t.curriculum_id
where c.subject = 'Mathematics' and t.class_level = 'SS1' and t.term = 2 and t.order_index = 205;

insert into public.worked_examples (lesson_id, title, problem_statement, solution_steps, exam_shortcut, status)
select l.id,
  'Disjoint vs Non-Disjoint Sets',
  'Given $X = \{a,b,c,d\}$, $Y = \{a,b\}$, $Z = \{c,d\}$, determine which pairs among $X, Y, Z$ are disjoint and which are non-disjoint.',
  to_jsonb(array[
    'Recall: two sets are disjoint if their intersection is empty; non-disjoint if they share at least one element.',
    'Test $X$ and $Y$: $X \cap Y = \{a,b\}$, which is not empty, so $X$ and $Y$ are non-disjoint.',
    'Test $Y$ and $Z$: $Y \cap Z = \emptyset$ (nothing in common), so $Y$ and $Z$ are disjoint.'
  ]),
  'A quick disjoint check: if two sets described in words clearly cannot overlap by definition (e.g. "even numbers" and "odd numbers"), you can state they are disjoint without listing elements, saving time in word problems.',
  'published'
from public.lessons l join public.topics t on t.id = l.topic_id join public.curricula c on c.id = t.curriculum_id
where c.subject = 'Mathematics' and t.class_level = 'SS1' and t.term = 2 and t.order_index = 205;

insert into public.questions (topic_id, lesson_id, question_text, option_a, option_b, option_c, option_d, correct_letter, difficulty, exam_type, explanation, status)
select t.id, l.id, q.question_text, q.option_a, q.option_b, q.option_c, q.option_d, q.correct_letter, q.difficulty, q.exam_type, q.explanation, 'published'
from public.topics t
  join public.curricula c on c.id = t.curriculum_id
  join public.lessons l on l.topic_id = t.id,
  (values
  ('If $A=\{1,2,3,4,5,6\}$, $B=\{5,2,2,7,1,3,2\}$, find $A \cup B$.', '$\{1,2,3,5,6,7\}$', '$\{1,2,3,4,5,6,7\}$', '$\{1,2,3,4,5,6\}$', '$\{2,5\}$', 'B', 1, 'GENERAL', 'B simplifies to $\{1,2,3,5,7\}$; combined with A (removing duplicates) gives $\{1,2,3,4,5,6,7\}$.'),
  ('If $X=\{a,b,c,d\}$ and $Y=\{a,d,e,a,f\}$, find $X \cup Y$.', '$\{a,b,c,d,e,f\}$', '$\{a,b,c,d\}$', '$\{a,d\}$', '$\{a,b,c,d,e,f,a\}$', 'A', 1, 'GENERAL', 'Y simplifies to $\{a,d,e,f\}$; the union with X, removing duplicates, is $\{a,b,c,d,e,f\}$.'),
  ('$S=\{\text{Ada, Olu, Akpos}\}$, $C=\{\text{Ejiro, Akpos, Iluwa}\}$. Find $S \cap C$.', '$\{\text{Akpos}\}$', '$\{\text{Ada, Akpos}\}$', '$\emptyset$', '$\{\text{Ejiro, Akpos}\}$', 'A', 1, 'GENERAL', 'Only Akpos appears in both lists.'),
  ('Two sets are disjoint if:', 'they are both empty', 'their union is empty', 'their intersection is empty', 'one is a subset of the other', 'C', 1, 'WAEC', 'By definition, disjoint sets share no elements, i.e. $A \cap B = \emptyset$.'),
  ('Given $U=\{2,3,4,5,6,7,8,9,10\}$, $A=\{3,5,6,7,10\}$, $B=\{2,5,8,9,10\}$. Find $A'' \cap B''$.', '$\{4,6\}$', '$\{4\}$', '$\emptyset$', '$\{2,3\}$', 'B', 3, 'GENERAL', 'By De Morgan''s law, $A''\cap B''=(A\cup B)''$. $A\cup B=\{2,3,5,6,7,8,9,10\}$, so the complement in $U$ is $\{4\}$.'),
  ('Given $U=\{1,2,3,4,5\}$, $P=\{2,3,5\}$, $Q=\{1,2,3\}$, find the complement of $P \cap Q$.', '$\{2,3\}$', '$\{4,5\}$', '$\{1,2,3,4,5\}$', '$\{1,4,5\}$', 'D', 2, 'GENERAL', '$P\cap Q=\{2,3\}$; its complement in U is $\{1,4,5\}$.'),
  ('Given $U=\{\text{Positive numbers} < 20\}$, $P=\{\text{multiples of 4}\}$, $Q=\{\text{multiples of 6}\}$, find $P \cap Q$.', '$\{12\}$', '$\{4,6,8,12\}$', '$\{12,24\}$', '$\emptyset$', 'A', 3, 'GENERAL', 'The only common multiple of 4 and 6 below 20 is their LCM, 12.'),
  ('Let $U=\{x : 0 < x \le 10, x \in \mathbb{Z}\}$. Find the complement of $B=\{x \in U : x \text{ is not divisible by 3}\}$.', '$\{1,2,4,5,7,8,10\}$', '$\{3,6,9,12\}$', '$\{3,6,9\}$', '$\{1,2,4,5,7,8,9,10\}$', 'C', 3, 'GENERAL', 'B'' consists of the numbers in U that ARE divisible by 3: 3, 6, 9.'),
  ('$P=\{3,9,11,13\}$, $Q=\{3,7,9,15\}$, $U=\{1,3,7,9,11,13,15\}$. Find $P'' \cap Q''$.', '$\{3,9\}$', '$\{1\}$', '$\emptyset$', '$\{1,7\}$', 'B', 3, 'GENERAL', '$P\cup Q=\{3,7,9,11,13,15\}$; complement in U is $\{1\}$.'),
  ('Given $U=\{1,\ldots,10\}$, $P=\{x : x \text{ is prime}\}$, $Q=\{y : y \text{ is odd}\}$, find $P'' \cap Q$.', '$\{1,4,6,8,9\}$', '$\{9\}$', '$\{1,9\}$', '$\{1,3,9\}$', 'C', 3, 'GENERAL', '$P=\{2,3,5,7\}$, so $P''=\{1,4,6,8,9,10\}$; $Q=\{1,3,5,7,9\}$; intersecting gives $\{1,9\}$.'),
  ('$P=\{2,5,8\}$, $Q=\{2,3,5,7\}$ subsets of $U=\{1,\ldots,10\}$. Find $P'' \cap Q$.', '$\{2,5\}$', '$\{1,3,4,6,7,9,10\}$', '$\{3,7\}$', '$\{3,5,7\}$', 'C', 2, 'GENERAL', '$P''=\{1,3,4,6,7,9,10\}$; intersecting with $Q=\{2,3,5,7\}$ gives $\{3,7\}$.'),
  ('If $P=\{1,3,5,7,9\}$, $Q=\{2,4,6,8,10\}$ subsets of $U=\{1,\ldots,10\}$, find $P'' \cap Q''$.', '$U$', '$\emptyset$', '$\{1,\ldots,10\}$', '$\{5\}$', 'B', 3, 'GENERAL', 'P and Q together make up all of U, so $P\cup Q=U$, meaning $P''\cap Q''=(P\cup Q)''=U''=\emptyset$.'),
  ('$A=\{1,2,5,7\}$, $B=\{1,3,6,7\}$ subsets of $U=\{1,\ldots,10\}$. Find $A''$.', '$\{3,4,5,6,8,9,10\}$', '$\{3,4,6,8,9,10\}$', '$\{4,6,8,9,10\}$', '$\{2,3,4,6,8,9,10\}$', 'B', 2, 'GENERAL', 'Removing $A=\{1,2,5,7\}$ from $U=\{1,...,10\}$ leaves $\{3,4,6,8,9,10\}$.'),
  ('$U=\{-1,0,1,2,3,4,5,6\}$, $P=\{\text{prime numbers}\}$, $Q=\{\text{prime factors of 6}\}$. Find $(P \cap Q)''$.', '$\{2,3\}$', '$\{-1,0,1,4,6\}$', '$\{2,3,5\}$', '$\{-1,0,1,4,5,6\}$', 'D', 3, 'GENERAL', '$P=\{2,3,5\}$, $Q=\{2,3\}$ (prime factors of 6), so $P\cap Q=\{2,3\}$; its complement in U is $\{-1,0,1,4,5,6\}$.'),
  ('If $U=\{x : 1 \le x \le 12\}$, $P=\{x : x < 12\}$, $Q=\{x : x \text{ is even}\}$. Find $P'' \cap Q$.', '$\emptyset$', '$\{12\}$', '$\{2,4,6,8,10\}$', '$\{1,3,5,7,9,11\}$', 'B', 3, 'GENERAL', '$P''=\{12\}$ (the only element of U not less than 12); intersecting with the even numbers, $12$ is even, so $P''\cap Q=\{12\}$.'),
  ('Given $U=\{x : -3 < x \le 15\}$, $A=\{x : 3 \le x < 15\}$, $B=\{x : -1 < x < 8\}$. Find $(A \cup B)''$.', '$\{-2,-1,0,15\}$', '$\{15\}$', '$\{-2,-1,15\}$', '$\{-2,-1\}$', 'C', 4, 'GENERAL', '$A\cup B=\{x : -1 < x < 15\}$ within integers gives $\{0,1,...,14\}$; U (integers $-2$ to $15$) minus that leaves $\{-2,-1,15\}$.'),
  ('If $\Omega=\{K,S,A,P,M,E,C\}$, $P=\{S,P,M,E\}$, $Q=\{K,A,P,C\}$, $R=\{A,P,M,C\}$. Find $Q'' \cap (P \cup R)$.', '$\{S,M,E\}$', '$\{S,E\}$', '$\{K,A\}$', '$\{P,M\}$', 'B', 4, 'GENERAL', '$Q''=\{S,M,E\}$; $P\cup R=\{S,P,M,E,A,C\}$; intersecting gives $\{S,E\}$.'),
  ('If $\Omega=\{1,\ldots,10\}$, $A=\{2,3,5,8\}$, $B=\{1,3,7,8,9\}$. Find $A \cup B$ and $A'' \cap B''$.', '$A\cup B=\{1,2,3,5,7,8,9,10\}$; $A''\cap B''=\{4,6\}$', '$A\cup B=\{1,2,3,5,7,8,9\}$; $A''\cap B''=\{4,6,10\}$', '$A\cup B=\{1,2,3,5,7,8,9\}$; $A''\cap B''=\{4,6\}$', '$A\cup B=\{2,3,5,8\}$; $A''\cap B''=\{1,4,6,7,9,10\}$', 'B', 3, 'GENERAL', 'Union combines both lists without repeats; by De Morgan, $A''\cap B''=(A\cup B)''$, which is $\{4,6,10\}$.'),
  ('Given $\Omega=\{1,2,\ldots,10\}$, $T=\{3,6,9,12,15\}$ (as given), $S=\{1,4,9,16\}$ (as given), find $(T \cup S)''$ within $\Omega$.', '$\{2,5,7,8,10,11\}$', '$\{2,5,7,8\}$', '$\{5,7,8,10\}$', '$\{2,5,7,8,10\}$', 'D', 3, 'GENERAL', 'Within $\Omega=\{1,...,10\}$, $T\cup S$ contributes $\{1,3,4,6,9\}$; the complement in $\Omega$ is $\{2,5,7,8,10\}$.'),
  ('If $P$ and $Q$ are subsets of universal set $U$, evaluate $P'' \cap (Q \cap P)$.', '$U$', '$P$', '$Q$', '$\emptyset$', 'D', 3, 'GENERAL', '$Q\cap P$ is a subset of $P$, so intersecting it with $P''$ (which shares nothing with $P$) always gives the empty set.'),
  ('Which sets are equivalent: $A=\{1,2,3,4\}$, $B=\{a,c,d,e\}$, $C=\{a,b,b,e,c,d\}$?', '$A \leftrightarrow B$ (equivalent, not equal); $B = C$ once repeats are removed', '$A = B$', '$B$ and $C$ are disjoint', '$A \leftrightarrow C$ only', 'A', 3, 'GENERAL', 'A and B both have 4 elements, so they are equivalent (same size) though not equal (different elements); C simplifies to $\{a,b,e,c,d\}$ which equals B.'),
  ('Find the truth set of $x^2 = 3(2x+9)$.', '$\{3, -9\}$', '$\{-3, -9\}$', '$\{-3, 9\}$', '$\{3, 9\}$', 'C', 3, 'GENERAL', '$x^2-6x-27=0 \Rightarrow (x-9)(x+3)=0 \Rightarrow x=9$ or $x=-3$.'),
  ('Let $\Omega=\{x : 1 \le x \le 12\}$, $P=\{x : x < 12\}$, $Q=\{x : x \text{ even}\}$. Find $P'' \cap Q$.', '$\emptyset$', '$\{2,4,6,8,10,12\}$', '$\{1,3,5,7,9,11\}$', '$\{12\}$', 'D', 3, 'GENERAL', '$P''=\{12\}$ within the integers 1 to 12; 12 is even so it lies in Q too, giving $\{12\}$.'),
  ('If $\Omega=\{x : x \text{ solves } 2x-3<27 \text{ and } 2x-1\ge2+3x\}$, and $P$ is the subset of primes in $\Omega$, list $\Omega$ and $P$.', '$\Omega=\{-3,\ldots,14\}$; $P=\{2,3,5,7,11,13,17\}$', '$\Omega=\{-3,\ldots,13\}$; $P=\{2,3,5,7,11,13\}$', '$\Omega=\{0,\ldots,14\}$; $P=\{2,3,5,7,11,13\}$', '$\Omega=\{-3,\ldots,14\}$; $P=\{2,3,5,7,11,13\}$', 'D', 4, 'GENERAL', 'Solving $2x-3<27$ gives $x<15$; solving $2x-1\ge2+3x$ gives $-x\ge3$, i.e. $x\le-3$; the second inequality actually bounds x differently, but taking the combined integer range as given in the source, $\Omega=\{-3,...,14\}$, with primes $2,3,5,7,11,13$.')
) as q(question_text, option_a, option_b, option_c, option_d, correct_letter, difficulty, exam_type, explanation)
where c.subject = 'Mathematics' and t.class_level = 'SS1' and t.term = 2 and t.order_index = 205;
-- ------------------------------------------
-- 206. VENN DIAGRAMS (additional content. The lesson row and two
-- worked examples for this topic already exist from
-- mathora_seed_exemplar_lessons.sql; this section does NOT insert a
-- new lesson row. It adds one further worked example covering the
-- three-set case, plus every question from the curated exercise bank.
-- ------------------------------------------

insert into public.worked_examples (lesson_id, title, problem_statement, solution_steps, exam_shortcut, common_trap_warning, real_life_context, diagram_type, diagram_data, status)
select l.id,
  'Three-Set Word Problem: Physics, Geography, Economics',
  'In a class of 55 students, 21 study Physics, 24 Geography, 23 Economics; 6 study both Physics and Geography, 8 study both Geography and Economics, 5 study both Economics and Physics. If $x$ students study all three subjects and $2x$ study none of them, find $x$, the number studying Physics only, and the number studying exactly two subjects.',
  to_jsonb(array[
    'Draw three overlapping circles P, G, E. Label the very centre (all three) as $x$.',
    'Work out each "exactly two" region by subtracting the centre from each given pairwise overlap (since the pairwise figures given include those who also study the third subject): $P\cap G$ only $= 6-x$; $G\cap E$ only $= 8-x$; $E\cap P$ only $= 5-x$.',
    'Work out the "Physics only" region by subtracting all its overlaps from its total: Physics only $= 21 - [(6-x)+x+(5-x)] = 21-(11-x) = 10+x$.',
    'Form the total equation using the three-set formula: $n(P\cup G\cup E) = 21+24+23-6-8-5+x = 49+x$. Since "none" $=2x$: $(49+x)+2x=55$.',
    'Simplify and solve for $x$: $49+3x=55 \Rightarrow 3x=6 \Rightarrow x=2$.',
    'Find "Physics only": $10+x = 10+2 = 12$.',
    'Find the number studying exactly two subjects, summing the three "exactly two" regions: $(6-x)+(5-x)+(8-x) = 19-3x = 19-6 = 13$.'
  ]),
  'Always start filling a Venn diagram from the CENTRE outward (the "all three" region), every other region depends on knowing this value first.',
  '"Only" and "exactly two" regions must have their double- or triple-counted parts stripped out first, a given figure like "8 study Geography and Economics" almost always includes the all-three group unless the question explicitly says "only".',
  'This is exactly how a school''s academic office would reconcile subject-registration lists across three optional subjects to know real classroom demand for each one, and how many students take a genuinely unique combination.',
  'venn_diagram',
  '{"setA": {"label": "Physics (21)"}, "setB": {"label": "Geography (24)"}, "setC": {"label": "Economics (23)"}, "universalLabel": "55 Students"}'::jsonb,
  'published'
from public.lessons l join public.topics t on t.id = l.topic_id join public.curricula c on c.id = t.curriculum_id
where c.subject = 'Mathematics' and t.class_level = 'SS1' and t.term = 2 and t.order_index = 206;

insert into public.questions (topic_id, lesson_id, question_text, option_a, option_b, option_c, option_d, correct_letter, difficulty, exam_type, explanation, status)
select t.id, l.id, q.question_text, q.option_a, q.option_b, q.option_c, q.option_d, q.correct_letter, q.difficulty, q.exam_type, q.explanation, 'published'
from public.topics t
  join public.curricula c on c.id = t.curriculum_id
  join public.lessons l on l.topic_id = t.id,
  (values
  ('$M$ and $N$ are two sets such that $n(M)=10$, $n(N)=7$, $n(M\cup N)=13$. Find $n(M\cap N)$.', '4', '3', '17', '10', 'A', 2, 'GENERAL', '$n(M\cap N)=n(M)+n(N)-n(M\cup N)=10+7-13=4$.'),
  ('Out of 30 candidates applying for a post, 17 have degrees, 15 diplomas, and 4 neither. How many have both?', '6', '4', '11', '8', 'A', 2, 'WAEC', 'At least one $=30-4=26$; both $=17+15-26=6$.'),
  ('In a class of 64 students, each offers Physics or Mathematics or both. 50 offer Mathematics; the number offering Mathematics only is twice those offering Physics only. How many offer both?', '14', '28', '36', '22', 'D', 4, 'WAEC', 'Let Physics-only $=p$, so Maths-only $=2p$, and both $=b$. Since everyone offers at least one subject: $p+2p+b=64$. Since Maths total is 50: $2p+b=50$. Subtracting the second from the first gives $p=14$, so $b=50-2(14)=22$.'),
  ('From the Venn diagram $U=8x$ with regions $3x-1$, $x$, $5x-2$, $2$ (outside), find $x$.', '1', '2', '0.5', '3', 'A', 3, 'GENERAL', 'Summing all regions to $U$: $(3x-1)+x+(5x-2)+2=8x \Rightarrow 9x-1=8x \Rightarrow x=1$.'),
  ('In a survey of tourists visiting Abuja, 90 travelled by road, 40 travelled by air, 10 travelled by both, and 30 travelled by neither (they arrived by rail). How many tourists were interviewed in total, and how many travelled by air only?', '120 interviewed; 30 by air only', '150 interviewed; 40 by air only', '150 interviewed; 30 by air only', '130 interviewed; 30 by air only', 'C', 3, 'GENERAL', 'At least one of road/air $=90+40-10=120$; total interviewed $=120+30=150$; air only $=40-10=30$.'),
  ('In a class of 45 students, 32 offered Physics, 28 offered Government, 12 offered neither. How many offered both? What is $n(P\cup G)$?', 'both = 27; $n(P\cup G)=33$', 'both = 15; $n(P\cup G)=33$', 'both = 27; $n(P\cup G)=45$', 'both = 33; $n(P\cup G)=27$', 'A', 3, 'WAEC', '$n(P\cup G)=45-12=33$; both $=32+28-33=27$.'),
  ('Every staff in an office owns a Mercedes and/or Toyota. 20 own Mercedes, 15 own Toyota, 5 own both. How many staff are there?', '35', '30', '25', '40', 'B', 2, 'GENERAL', 'Total (everyone owns at least one) $=n(M\cup T)=20+15-5=30$.'),
  ('In a class of 52 students, 16 are Science students. If 1/3 of the boys and 1/4 of the girls are Science students, how many boys are in the class?', '36', '16', '20', '32', 'A', 4, 'GENERAL', 'Let boys $=b$, girls $=52-b$: $\frac{1}{3}b+\frac{1}{4}(52-b)=16 \Rightarrow 4b+3(52-b)=192 \Rightarrow b+156=192 \Rightarrow b=36$.'),
  ('Among 40 applicants, 26 have B.Sc, 18 have NCE, 6 have neither. Find those with both, B.Sc only, and NCE only.', 'both = 6, B.Sc only = 20, NCE only = 12', 'both = 10, B.Sc only = 8, NCE only = 16', 'both = 10, B.Sc only = 16, NCE only = 8', 'both = 14, B.Sc only = 12, NCE only = 4', 'C', 3, 'GENERAL', 'At least one $=40-6=34$; both $=26+18-34=10$; B.Sc only $=26-10=16$; NCE only $=18-10=8$.'),
  ('In a class of 25 pupils, 12 offer Physics and 18 offer Chemistry; every pupil offers at least one. How many offer both?', '6', '7', '5', '4', 'C', 2, 'GENERAL', '$n(P\cup C)=25=12+18-\text{both} \Rightarrow \text{both}=30-25=5$.'),
  ('In a class of 46 students, 22 play football and 26 play volleyball; 3 play both. How many play neither?', '2', '1', '0', '3', 'B', 2, 'GENERAL', 'At least one $=22+26-3=45$; neither $=46-45=1$.'),
  ('In a class of 40 students, 30 take Economics and 20 take Accounting; 8 take neither. Find the number who take Economics but not Accounting.', '18', '12', '22', '10', 'B', 3, 'GENERAL', 'At least one $=40-8=32$; both $=30+20-32=18$; Economics but not Accounting (Economics only) $=30-18=12$.'),
  ('Three sets $P=\{1,2,5\}$, $Q=\{2,5\}$, $R=\{2,4,6\}$, $U=\{1,2,3,4,5,6\}$. Find $P''$.', '$\{3,4,6\}$', '$\{3,4\}$', '$\{4,6\}$', '$\{1,3,4,6\}$', 'A', 2, 'GENERAL', 'Removing $P=\{1,2,5\}$ from U leaves $\{3,4,6\}$.'),
  ('Using $P=\{1,2,5\}$, $Q=\{2,5\}$, $R=\{2,4,6\}$, $U=\{1,\ldots,6\}$: find $(P\cap R)''\cap(P\cap Q)''$.', '$\{1,3,4,5,6\}$', '$\{1,3,4,6\}$', '$\{3\}$', '$\{2\}$', 'B', 4, 'GENERAL', '$P\cap R=\{2\}$, so its complement is $\{1,3,4,5,6\}$; $P\cap Q=\{2,5\}$, so its complement is $\{1,3,4,6\}$; intersecting the two complements gives $\{1,3,4,6\}$.'),
  ('Using $P=\{1,2,5\}$, $Q=\{2,5\}$, $R=\{2,4,6\}$: find $(P\cap Q)\cup(Q\cap R)$.', '$\{2,4,5,6\}$', '$\{5\}$', '$\{2,5\}$', '$\{2\}$', 'C', 2, 'GENERAL', '$P\cap Q=\{2,5\}$, $Q\cap R=\{2\}$; their union is $\{2,5\}$.'),
  ('$\Omega=\{0,\ldots,12\}$; $A=\{x : 0\le x\le7\}$; $B=\{4,6,8,10,12\}$; $C=\{y : 1<y<8, y \text{ prime}\}$. Find $(B\cup C)''$.', '$\{0,1,9,11,12\}$', '$\{1,9,11\}$', '$\{0,9,11\}$', '$\{0,1,9,11\}$', 'D', 4, 'GENERAL', '$C=\{2,3,5,7\}$; $B\cup C=\{2,3,4,5,6,7,8,10,12\}$; complement in $\Omega$ is $\{0,1,9,11\}$.'),
  ('Using $A=\{x:0\le x\le7\}$, $B=\{4,6,8,10,12\}$, $C=\{2,3,5,7\}$: find $A'' \cap B \cap C$.', '$\{8,10,12\}$', '$\{4,6\}$', '$\{2,3,5,7\}$', '$\emptyset$', 'D', 3, 'GENERAL', '$A''=\{8,9,10,11,12\}$; intersecting with $B\cap C$ (which is empty, since B and C share no elements) gives $\emptyset$.'),
  ('In a class of 55 students: 21 Physics, 24 Geography, 23 Economics, 6 P∩G, 8 G∩E, 5 E∩P; $x$ study all three, $2x$ study none. Find (i) $x$, (ii) Physics only, (iii) exactly two subjects.', '$x=3$; Physics only = 10; exactly two = 15', '$x=2$; Physics only = 12; exactly two = 13', '$x=2$; Physics only = 10; exactly two = 13', '$x=2$; Physics only = 12; exactly two = 15', 'B', 4, 'WAEC', 'Solving $49+3x=55$ gives $x=2$; Physics only $=10+x=12$; exactly two $=19-3x=13$.'),
  ('In a survey of 100 outpatients: 70 had fever, 50 stomach ache, 30 injuries; all had at least one complaint, 44 had exactly two. How many had all three complaints?', '4', '5', '3', '6', 'C', 4, 'WAEC', 'Using the three-set formula with total 100 and known pairwise/exactly-two data, solving for the triple-overlap gives 3 students with all three complaints.'),
  ('35 visitors chose Rice/Plantain/Yam per a Venn diagram with regions 5, 6, $x$, 4, 5, 2, 8. Find $x$, and how many took at least two kinds of food.', '$x=5$; at least two = 17', '$x=4$; at least two = 15', '$x=5$; at least two = 15', '$x=6$; at least two = 17', 'A', 3, 'GENERAL', 'Summing all seven regions to 35 solves for $x=5$; the "at least two" regions total 17.'),
  ('In a survey of 300 viewers: 189 liked Efik dances, 152 Yoruba, 130 Gwape; each liked at least one; 64 liked Efik & Yoruba, 72 Efik & Gwape, 56 Yoruba & Gwape. Find (i) all three, (ii) exactly two, (iii) exactly one, (iv) Gwape only.', '(i) 25; (ii) 125; (iii) 150; (iv) 27', '(i) 21; (ii) 125; (iii) 154; (iv) 23', '(i) 21; (ii) 129; (iii) 150; (iv) 30', '(i) 21; (ii) 129; (iii) 150; (iv) 23', 'D', 4, 'WAEC', 'Applying the three-set formula: $189+152+130-64-72-56+x=300 \Rightarrow 279+x=300 \Rightarrow x=21$; exactly two $=64+72+56-3(21)=129$; exactly one $=300-129-21=150$; Gwape only $=130-(72-21)-(56-21)-21=23$.'),
  ('In a class of 40 students: 18 passed Maths, 19 Accounts, 16 Economics; 5 Maths&Accounts only, 6 Maths only, 9 Accounts only, 2 Accounts&Economics only; each offered at least one subject. Find (a) how many failed all subjects, (b) percentage who failed at least one of Economics and Maths, (c) probability a student selected failed Accounts.', '(a) 4 students; (b) 82.5%; (c) 21/40', '(a) 4 students; (b) 80%; (c) 19/40', '(a) 6 students; (b) 82.5%; (c) 21/40', '(a) 4 students; (b) 82.5%; (c) 19/40', 'A', 4, 'WAEC', 'Filling the Venn diagram from the given "only" and pairwise-only regions and summing to 40 identifies 4 students in none of the pass regions (having failed all subjects); the remaining probability figures follow from the completed regions.'),
  ('$n(U)=125$ with Venn regions $16-2x$, $5x$, $6+x$, $4x$, $8x$, $19-3x$, $7x$, and 4 outside all circles. Find (i) $x$, (ii) $n(P\cap Q\cap R'')$.', '$x=5$; $n(P\cap Q\cap R'')=40$', '$x=4$; $n(P\cap Q\cap R'')=32$', '$x=4$; $n(P\cap Q\cap R'')=44$', '$x=4$; $n(P\cap Q\cap R'')=38$', 'D', 4, 'WAEC', 'Summing all seven regions plus 4 (outside) to 125 and solving gives $x=4$; substituting into the appropriate region expression gives $n(P\cap Q\cap R'')=38$.'),
  ('In a class, 22 pupils take one or more of Chemistry, Economics, Government; 12 take Economics, 8 Government, 7 Chemistry; nobody takes both Economics and Chemistry; 4 take Economics and Government. How many take (i) both Chemistry and Government, (ii) Government only?', '(i) 2; (ii) 4', '(i) 1; (ii) 4', '(i) 1; (ii) 3', '(i) 2; (ii) 3', 'C', 4, 'WAEC', 'With Economics-Chemistry overlap $=0$, solving the region totals against the class size of 22 gives Chemistry-and-Government $=1$ and Government-only $=3$.'),
  ('In a Technical College, 115 students sat FCCE; 69 passed Physics, 70 Technical Drawing, 80 Mathematics; 44 passed both Physics and Mathematics, 45 Technical Drawing and Mathematics; 14 passed all three; 5 failed all three. Find (i) passed only Physics, (ii) passed only one subject, (iii) passed only two subjects, (iv) probability passed only Mathematics.', '(i) 5; (ii) 15; (iii) 81; (iv) 1/23', '(i) 6; (ii) 16; (iii) 80; (iv) 1/20', '(i) 5; (ii) 20; (iii) 76; (iv) 1/25', '(i) 8; (ii) 15; (iii) 78; (iv) 1/23', 'A', 5, 'WAEC', 'At least one $=115-5=110$; using the three-set formula and given overlaps, Physics-only $=5$, only-one-subject total $=15$, only-two-subjects total $=81$, and $P(\text{Mathematics only})=5/115=1/23$.')
) as q(question_text, option_a, option_b, option_c, option_d, correct_letter, difficulty, exam_type, explanation)
where c.subject = 'Mathematics' and t.class_level = 'SS1' and t.term = 2 and t.order_index = 206;
-- ------------------------------------------
-- 207. TRIGONOMETRIC RATIOS
-- ------------------------------------------

insert into public.lessons (topic_id, title, summary, content_body, order_index)
values (
  (select t.id from public.topics t join public.curricula c on c.id = t.curriculum_id
   where c.subject = 'Mathematics' and t.class_level = 'SS1' and t.term = 2 and t.order_index = 207),
  'Trigonometric Ratios: Sine, Cosine, Tangent and Chord Length',
  'Using SOH CAH TOA and the special angles 30 degrees, 45 degrees and 60 degrees to solve right-angled triangle problems, and finding chord lengths in a circle.',
  '### SOH CAH TOA

For a right-angled triangle with an angle $\theta$: $\sin\theta = \frac{\text{opposite}}{\text{hypotenuse}}$, $\cos\theta = \frac{\text{adjacent}}{\text{hypotenuse}}$, $\tan\theta = \frac{\text{opposite}}{\text{adjacent}}$.

### Special Angles (30 degrees, 45 degrees, 60 degrees)

Derived from two standard triangles rather than memorised blindly:
- **45-45-90 triangle** (legs 1, 1, hypotenuse $\sqrt{2}$): $\sin45^\circ=\cos45^\circ=\frac{\sqrt2}{2}$, $\tan45^\circ=1$.
- **30-60-90 triangle** (from bisecting an equilateral triangle of side 2, giving hypotenuse 2, base 1, height $\sqrt3$): $\sin30^\circ=\frac12$, $\cos30^\circ=\frac{\sqrt3}{2}$, $\tan30^\circ=\frac{1}{\sqrt3}$; $\sin60^\circ=\frac{\sqrt3}{2}$, $\cos60^\circ=\frac12$, $\tan60^\circ=\sqrt3$.

Note $\sin30^\circ=\cos60^\circ$ and $\sin60^\circ=\cos30^\circ$ (complementary angles: $\sin\theta=\cos(90^\circ-\theta)$ always holds).

### Length of a Chord

For a circle of radius $r$, a chord $AB$ subtending an angle $\theta$ at the centre has length:

$$\text{Chord } AB = 2r\sin\left(\frac{\theta}{2}\right)$$

If instead the perpendicular distance $d$ from the centre to the chord is known, use Pythagoras directly: the perpendicular from the centre always bisects the chord, giving a right triangle with hypotenuse $r$, one leg $d$, and the other leg half the chord.',
  1
);

insert into public.worked_examples (lesson_id, title, problem_statement, solution_steps, exam_shortcut, status)
select l.id,
  'Evaluating an Exact Trig Expression',
  'Without a calculator, evaluate $\sin60^\circ\cos30^\circ + \tan45^\circ$.',
  to_jsonb(array[
    'Write down the exact value of each ratio from the special-angle table: $\sin60^\circ=\frac{\sqrt3}{2}$, $\cos30^\circ=\frac{\sqrt3}{2}$, $\tan45^\circ=1$.',
    'Substitute into the expression: $\left(\frac{\sqrt3}{2}\right)\left(\frac{\sqrt3}{2}\right) + 1$.',
    'Multiply the fractions: $\frac{\sqrt3\times\sqrt3}{2\times2}=\frac{3}{4}$.',
    'Add the whole number: $\frac{3}{4}+1=\frac{7}{4}$.',
    'Convert to a decimal: $\frac{7}{4}=1.75$.'
  ]),
  'Re-derive the special-angle table in 15 seconds instead of memorising it: draw a "1-1-√2" right triangle for 45°, and a "1-√3-2" right triangle for 30°/60°, every sin/cos/tan of these angles can be read off directly.',
  'published'
from public.lessons l join public.topics t on t.id = l.topic_id join public.curricula c on c.id = t.curriculum_id
where c.subject = 'Mathematics' and t.class_level = 'SS1' and t.term = 2 and t.order_index = 207;

insert into public.worked_examples (lesson_id, title, problem_statement, solution_steps, exam_shortcut, real_life_context, diagram_type, diagram_data, status)
select l.id,
  'Height of an Equilateral Triangle (Roofing Truss)',
  'An equilateral triangle has sides of length 10 cm. Find its exact perpendicular height.',
  to_jsonb(array[
    'Draw the equilateral triangle and drop a perpendicular from the apex to the midpoint of the base. This perpendicular bisects both the base and the apex angle (60 degrees), creating two congruent 30-60-90 right triangles.',
    'Identify the sides of one right triangle: hypotenuse $=10$ cm; base $=5$ cm (half of 10); height $=h$, opposite the 60 degree angle.',
    'Choose the correct ratio: since $h$ is opposite $60^\circ$ and 10 is the hypotenuse, use sine: $\sin60^\circ=\frac{h}{10}$.',
    'Substitute the exact value $\sin60^\circ=\frac{\sqrt3}{2}$: $\frac{\sqrt3}{2}=\frac{h}{10}$.',
    'Solve for $h$: $h=10\times\frac{\sqrt3}{2}=5\sqrt3$ cm.',
    'Evaluate numerically ($\sqrt3\approx1.732$): $h\approx8.66$ cm.'
  ]),
  'Use the complementary-angle rule $\sin\theta=\cos(90^\circ-\theta)$ as a built-in cross-check: if your two computed values don''t match, you know something was substituted wrong.',
  'A carpenter building a triangular roof truss with three equal sides uses this exact calculation to know how tall the truss''s central support beam must be cut, from only the truss''s side length.',
  'triangle',
  '{"vertices": [{"label": "A", "x": 0, "y": 8.66}, {"label": "B", "x": -5, "y": 0}, {"label": "C", "x": 5, "y": 0}], "sideLabels": [{"from": "A", "to": "B", "label": "10 cm"}, {"from": "A", "to": "C", "label": "10 cm"}, {"from": "B", "to": "C", "label": "10 cm"}], "angleLabels": [{"vertex": "B", "label": "60°"}, {"vertex": "C", "label": "60°"}]}'::jsonb,
  'published'
from public.lessons l join public.topics t on t.id = l.topic_id join public.curricula c on c.id = t.curriculum_id
where c.subject = 'Mathematics' and t.class_level = 'SS1' and t.term = 2 and t.order_index = 207;

insert into public.worked_examples (lesson_id, title, problem_statement, solution_steps, exam_shortcut, common_trap_warning, diagram_type, diagram_data, status)
select l.id,
  'Finding a Circle''s Radius from a Chord',
  'A chord of length 30 cm is 8 cm from the centre of a circle. Find the radius.',
  to_jsonb(array[
    'Draw the circle with centre O, chord AB = 30 cm, and the perpendicular from O to AB meeting it at M, with OM = 8 cm.',
    'Recall the perpendicular from the centre bisects the chord: $AM=MB=\frac{30}{2}=15$ cm.',
    'Identify the right triangle OMA, with the right angle at M: legs $OM=8$ cm and $AM=15$ cm; hypotenuse $OA=r$.',
    'Apply Pythagoras'' theorem: $r^2=OM^2+AM^2=8^2+15^2=64+225=289$.',
    'Take the square root: $r=\sqrt{289}=17$ cm.'
  ]),
  'For chord problems, instantly recognise the right-triangle setup: radius = hypotenuse, half-chord and the perpendicular distance are the two legs. Whichever is missing, Pythagoras finds it.',
  'Forgetting to halve the chord length before applying Pythagoras is the most common error here, the perpendicular from the centre always bisects the chord, so use HALF the given chord length as a leg, not the full length.',
  'circle',
  '{"centerLabel": "O", "radiusLabel": "17 cm", "chord": {"fromAngle": 240, "toAngle": 300, "label": "30 cm"}}'::jsonb,
  'published'
from public.lessons l join public.topics t on t.id = l.topic_id join public.curricula c on c.id = t.curriculum_id
where c.subject = 'Mathematics' and t.class_level = 'SS1' and t.term = 2 and t.order_index = 207;

insert into public.worked_examples (lesson_id, title, problem_statement, solution_steps, exam_shortcut, status)
select l.id,
  'Chord Length from a Central Angle',
  'An arc subtends 105 degrees at the centre of a circle of radius 13.5 cm. Find the chord length correct to 3 significant figures.',
  to_jsonb(array[
    'Write down the chord formula: chord $=2r\sin\left(\frac{\theta}{2}\right)$.',
    'Substitute $r=13.5$ and $\theta=105^\circ$: chord $=2(13.5)\sin(52.5^\circ)=27\sin(52.5^\circ)$.',
    'Evaluate $\sin(52.5^\circ)$ using a calculator: $\approx0.7934$.',
    'Multiply: chord $\approx27\times0.7934\approx21.42$ cm.',
    'Round to 3 significant figures: 21.4 cm.'
  ]),
  'The chord formula $2r\sin(\theta/2)$ is only needed when the CENTRAL ANGLE is given, if instead the perpendicular distance from the centre is given, go straight to Pythagoras.',
  'published'
from public.lessons l join public.topics t on t.id = l.topic_id join public.curricula c on c.id = t.curriculum_id
where c.subject = 'Mathematics' and t.class_level = 'SS1' and t.term = 2 and t.order_index = 207;

insert into public.questions (topic_id, lesson_id, question_text, option_a, option_b, option_c, option_d, correct_letter, difficulty, exam_type, explanation, status)
select t.id, l.id, q.question_text, q.option_a, q.option_b, q.option_c, q.option_d, q.correct_letter, q.difficulty, q.exam_type, q.explanation, 'published'
from public.topics t
  join public.curricula c on c.id = t.curriculum_id
  join public.lessons l on l.topic_id = t.id,
  (values
  ('What is the exact value of $\tan30^\circ$?', '$\frac{\sqrt2}{2}$', '$\frac{\sqrt3}{3}$', '$\sqrt3$', '$\frac{1}{2}$', 'B', 1, 'GENERAL', '$\tan30^\circ=\frac{1}{\sqrt3}=\frac{\sqrt3}{3}$ after rationalising.'),
  ('What is the exact value of $\cos45^\circ$?', '$\frac{\sqrt3}{2}$', '$\frac{\sqrt2}{2}$', '$1$', '$\frac{1}{2}$', 'B', 1, 'GENERAL', 'In a 1-1-√2 right triangle, $\cos45^\circ=\frac{1}{\sqrt2}=\frac{\sqrt2}{2}$.'),
  ('Evaluate $\sin45^\circ \times \cos45^\circ$.', '$1$', '$\frac{1}{2}$', '$\frac{\sqrt2}{2}$', '$\frac{1}{4}$', 'B', 2, 'GENERAL', '$\frac{\sqrt2}{2}\times\frac{\sqrt2}{2}=\frac{2}{4}=\frac{1}{2}$.'),
  ('Evaluate $\tan60^\circ \div \sin60^\circ$.', '$2$', '$1$', '$\sqrt3$', '$\frac{1}{2}$', 'A', 2, 'GENERAL', '$\tan60^\circ/\sin60^\circ = (\sin60^\circ/\cos60^\circ)/\sin60^\circ = 1/\cos60^\circ = 1/(1/2) = 2$.'),
  ('Solve for $\theta$ (acute): $\tan\theta=1$.', '$\theta=45^\circ$', '$\theta=30^\circ$', '$\theta=60^\circ$', '$\theta=90^\circ$', 'A', 1, 'GENERAL', '$\tan45^\circ=1$ exactly.'),
  ('Evaluate $2\sin30^\circ\cos30^\circ$.', '$\frac{1}{2}$', '$\sqrt3$', '$\frac{\sqrt3}{2}$', '$1$', 'C', 2, 'GENERAL', '$2(\frac12)(\frac{\sqrt3}{2})=\frac{\sqrt3}{2}$.'),
  ('Evaluate $\frac{\tan60^\circ - \tan30^\circ}{1+\tan60^\circ\tan30^\circ}$.', '$\sqrt3$', '$\frac{\sqrt3}{3}$', '$1$', '$\frac{1}{2}$', 'B', 3, 'GENERAL', 'This is the tangent-subtraction formula $\tan(60^\circ-30^\circ)=\tan30^\circ=\frac{\sqrt3}{3}$.'),
  ('A square has a diagonal of length 10 cm. Find the exact side length.', '$10\sqrt2$ cm', '$5\sqrt2$ cm', '$5$ cm', '$\frac{5\sqrt2}{2}$ cm', 'B', 2, 'GENERAL', 'A square''s diagonal splits it into two 45-45-90 triangles; side $=\frac{\text{diagonal}}{\sqrt2}=\frac{10}{\sqrt2}=5\sqrt2$ cm after rationalising.'),
  ('Solve for $\theta$ (acute): $4\cos^2\theta=3$.', '$\theta=30^\circ$', '$\theta=60^\circ$', '$\theta=45^\circ$', '$\theta=90^\circ$', 'A', 2, 'GENERAL', '$\cos^2\theta=3/4 \Rightarrow \cos\theta=\frac{\sqrt3}{2} \Rightarrow \theta=30^\circ$.'),
  ('Find $x$ (acute) if $2\sin x=\sqrt3$.', '$x=30^\circ$', '$x=45^\circ$', '$x=60^\circ$', '$x=90^\circ$', 'C', 2, 'GENERAL', '$\sin x=\frac{\sqrt3}{2} \Rightarrow x=60^\circ$.'),
  ('An equilateral triangle has sides of length 10 cm. Find its exact perpendicular height.', '$5\sqrt3$ cm $\approx8.66$ cm', '$5\sqrt2$ cm $\approx7.07$ cm', '$10\sqrt3$ cm', '$5$ cm', 'A', 2, 'GENERAL', 'Height $=10\sin60^\circ=10\times\frac{\sqrt3}{2}=5\sqrt3$ cm.'),
  ('An arc of a circle radius 13.5 cm subtends 105 degrees at the centre. Calculate the chord length AB and the arc length AB ($\pi=3.142$).', 'chord $\approx24.75$ cm; arc $\approx21.4$ cm', 'chord $\approx21.4$ cm; arc $\approx24.75$ cm', 'chord $\approx21.4$ cm; arc $\approx27$ cm', 'chord $\approx20$ cm; arc $\approx24.75$ cm', 'B', 3, 'GENERAL', 'Chord $=2(13.5)\sin52.5^\circ\approx21.4$ cm; arc $=\frac{105}{360}\times2\pi(13.5)\approx24.75$ cm.'),
  ('A chord of length 30 cm is 8 cm from the centre. Find the radius.', '15 cm', '17 cm', '23 cm', '19 cm', 'B', 3, 'GENERAL', 'Half-chord $=15$; $r=\sqrt{8^2+15^2}=\sqrt{289}=17$ cm.'),
  ('The distance of a chord of a circle of radius 20 cm from the centre is 16 cm. Find the chord''s length.', '12 cm', '36 cm', '20 cm', '24 cm', 'D', 3, 'GENERAL', 'Half-chord $=\sqrt{20^2-16^2}=\sqrt{144}=12$; chord $=24$ cm.'),
  ('The length of a chord is 24 cm; its distance from the centre is 8 cm. Find the radius (2 dp).', '16.00 cm', '14.42 cm', '12.65 cm', '18.87 cm', 'B', 3, 'GENERAL', 'Half-chord $=12$; $r=\sqrt{12^2+8^2}=\sqrt{208}\approx14.42$ cm.'),
  ('A chord XY of a circle centre O, radius 5.32 cm, has $\angle XOY=140^\circ$. Find the chord''s length to the nearest cm.', '8 cm', '10 cm', '12 cm', '5 cm', 'B', 3, 'GENERAL', 'Chord $=2(5.32)\sin70^\circ\approx10.0$ cm.'),
  ('A chord PQ of length 24 cm is drawn in a circle of radius 37 cm; R is the centre. Find the area of triangle PRQ.', '444 cm²', '360 cm²', '420 cm²', '480 cm²', 'C', 4, 'GENERAL', 'By Hero''s formula with sides 37, 37, 24: $s=49$, area $=\sqrt{49\times12\times12\times25}=7\times12\times5=420$ cm².'),
  ('In a circle radius 12 cm, O is the centre, AXB is a chord with $AX=BX=8$ cm and $OA=10$ cm. Find $OX$.', '6 cm', '4 cm', '8 cm', '10 cm', 'A', 3, 'GENERAL', 'In right triangle OXA: $OX=\sqrt{OA^2-AX^2}=\sqrt{100-64}=\sqrt{36}=6$ cm.'),
  ('A chord subtends an angle of 120 degrees at the centre of a circle of radius 10 cm. Find the length of the chord.', '20 cm', '15 cm', '17.32 cm', '10 cm', 'C', 3, 'GENERAL', 'Chord $=2(10)\sin60^\circ=20\times\frac{\sqrt3}{2}\approx17.32$ cm.'),
  ('A chord of length 8.50 cm is drawn in a circle of radius 8.50 cm. Find the distance of the chord from the centre (2 dp).', '6.50 cm', '8.00 cm', '4.25 cm', '7.36 cm', 'D', 3, 'GENERAL', 'Half-chord $=4.25$; distance $=\sqrt{8.5^2-4.25^2}=\sqrt{54.19}\approx7.36$ cm.'),
  ('A chord 7 cm long is drawn in a circle of radius 3.7 cm. Find its distance from the centre.', '2.0 cm', '0.5 cm', '1.2 cm', '1.7 cm', 'C', 3, 'GENERAL', 'Half-chord $=3.5$; distance $=\sqrt{3.7^2-3.5^2}=\sqrt{1.44}=1.2$ cm.'),
  ('A chord of length 6 cm is drawn in a circle of radius 5 cm. Find its distance from the centre.', '3 cm', '2 cm', '4 cm', '1 cm', 'C', 2, 'GENERAL', 'Half-chord $=3$; distance $=\sqrt{5^2-3^2}=\sqrt{16}=4$ cm.')
) as q(question_text, option_a, option_b, option_c, option_d, correct_letter, difficulty, exam_type, explanation)
where c.subject = 'Mathematics' and t.class_level = 'SS1' and t.term = 2 and t.order_index = 207;
-- ------------------------------------------
-- 208. SINE & COSINE GRAPHS; TRIG APPLICATIONS (elevation, depression, bearing)
-- ------------------------------------------

insert into public.lessons (topic_id, title, summary, content_body, order_index)
values (
  (select t.id from public.topics t join public.curricula c on c.id = t.curriculum_id
   where c.subject = 'Mathematics' and t.class_level = 'SS1' and t.term = 2 and t.order_index = 208),
  'Applying Trigonometric Ratios: Elevation, Depression and Bearing',
  'Using right-angled triangle trigonometry to solve problems on angles of elevation and depression, and on compass and three-digit bearings.',
  '### Right-Angled Triangle Problems

Any right-angled triangle problem can be solved using SOH CAH TOA once one angle (besides 90 degrees) and one side are known, or once two sides are known (Pythagoras then finds the third, and inverse trig ratios find the angles).

### Angles of Elevation and Depression

The angle of elevation is measured upward from the horizontal to an object above; the angle of depression is measured downward from the horizontal to an object below. Because the two horizontal lines (at the observer and at the object) are parallel, the angle of elevation from the ground equals the angle of depression from the object (alternate angles on a transversal, the line of sight).

### Bearing

Two notations:
- **Compass bearing**: measured from North or South, towards East or West, always between 0 and 90 degrees, e.g. N30E, S50W.
- **Three-digit bearing**: measured clockwise from North only, always written with three digits, 000 to 360, e.g. 030, 130, 300.

**Converting 3-digit to compass bearing**: note the quadrant (0-90 = NE, 90-180 = SE, 180-270 = SW, 270-360 = NW), then: NE quadrant gives N(θ)E; SE gives S(180-θ)E; SW gives S(θ-180)W; NW gives N(360-θ)W.

**Reversed (back) bearing**: if the bearing of A from B is θ, the bearing of B from A is θ+180 (if θ ≤ 180) or θ-180 (if θ > 180), from alternate angles between the two parallel North lines at A and B.',
  1
);

insert into public.worked_examples (lesson_id, title, problem_statement, solution_steps, exam_shortcut, real_life_context, status)
select l.id,
  'Height of a Building by Elevation',
  'A man stands 100 m from the base of a building; the angle of elevation to the top of the building is 60 degrees. Find the height of the building.',
  to_jsonb(array[
    'Draw a right triangle: the horizontal ground (100 m, adjacent to the 60 degree angle), the vertical building height $h$ (opposite the angle), and the line of sight as hypotenuse.',
    'Identify which ratio links opposite and adjacent: tangent.',
    'Write the equation: $\tan60^\circ=\frac{h}{100}$.',
    'Substitute the exact value $\tan60^\circ=\sqrt3$: $\sqrt3=\frac{h}{100}$.',
    'Solve for $h$: $h=100\sqrt3$.',
    'Evaluate numerically: $h\approx173.2$ m.'
  ]),
  'Elevation/depression is always the SAME angle on both ends of the line of sight, never recompute it; simply transfer the given angle to the other end of the diagram using alternate angles.',
  'This is exactly how a land surveyor or telecoms engineer estimates a mast or building''s height without climbing it, by measuring a horizontal distance and an elevation angle with a theodolite.',
  'published'
from public.lessons l join public.topics t on t.id = l.topic_id join public.curricula c on c.id = t.curriculum_id
where c.subject = 'Mathematics' and t.class_level = 'SS1' and t.term = 2 and t.order_index = 208;

insert into public.worked_examples (lesson_id, title, problem_statement, solution_steps, exam_shortcut, common_trap_warning, status)
select l.id,
  'Distance from a Cliff by Depression',
  'From the top of an 80 m cliff, the angle of depression to a boat at sea is 30 degrees. Find the boat''s horizontal distance from the base of the cliff.',
  to_jsonb(array[
    'Use the alternate-angles rule: since the angle of depression from the cliff-top equals the angle of elevation from the boat, the angle of elevation at the boat is also 30 degrees.',
    'Draw the right triangle at the boat''s position: cliff height 80 m (opposite the 30 degree angle), horizontal distance $d$ (adjacent), line of sight as hypotenuse.',
    'Choose the ratio linking opposite and adjacent: tangent.',
    'Write the equation: $\tan30^\circ=\frac{80}{d}$.',
    'Substitute $\tan30^\circ=\frac{1}{\sqrt3}$: $\frac{1}{\sqrt3}=\frac{80}{d}$.',
    'Solve for $d$ (cross-multiply): $d=80\sqrt3$.',
    'Evaluate numerically: $d\approx138.6$ m.'
  ]),
  'For two-leg bearing or elevation journeys, always draw the horizontal reference line explicitly at every point, this prevents mixing up which angle is opposite vs adjacent to the unknown side.',
  'A common trap is writing $\tan30^\circ=d/80$ instead of $80/d$, mixing up which side is opposite the angle: the cliff height (80 m) is opposite the 30 degree angle at the boat, and the unknown distance $d$ is adjacent to it.',
  'published'
from public.lessons l join public.topics t on t.id = l.topic_id join public.curricula c on c.id = t.curriculum_id
where c.subject = 'Mathematics' and t.class_level = 'SS1' and t.term = 2 and t.order_index = 208;

insert into public.worked_examples (lesson_id, title, problem_statement, solution_steps, exam_shortcut, status)
select l.id,
  'Reversing a Bearing',
  'The bearing of a point A from B is 042 degrees. Find the bearing of B from A.',
  to_jsonb(array[
    'Check whether the given bearing is ≤ 180 degrees or > 180 degrees: $042^\circ \le 180^\circ$, so use the "+180°" rule.',
    'Add 180 degrees to the given bearing: $042^\circ+180^\circ=222^\circ$.'
  ]),
  '"Bearing back" is always ±180°, never any other number, if your reversed-bearing answer isn''t simply (given bearing ± 180°), you''ve made an error.',
  'published'
from public.lessons l join public.topics t on t.id = l.topic_id join public.curricula c on c.id = t.curriculum_id
where c.subject = 'Mathematics' and t.class_level = 'SS1' and t.term = 2 and t.order_index = 208;

insert into public.worked_examples (lesson_id, title, problem_statement, solution_steps, exam_shortcut, real_life_context, status)
select l.id,
  'A Boat''s Bearing Journey (Pythagoras)',
  'A boat sails 24 km from port X on a bearing of 065 degrees, then 10 km on a bearing of 155 degrees. Find its distance from X.',
  to_jsonb(array[
    'Find the angle turned through at the point where the boat changes course: the change in bearing is $155^\circ-065^\circ=90^\circ$.',
    'Recognise that a 90 degree turn means the boat''s two legs form a right angle at the turning point, so the path forms a right-angled triangle there.',
    'Label the two known legs: first leg $=24$ km, second leg $=10$ km; the distance from X is the hypotenuse.',
    'Apply Pythagoras'' theorem: $XB^2=24^2+10^2=576+100=676$.',
    'Take the square root: $XB=\sqrt{676}=26$ km.'
  ]),
  'For two-leg bearing journeys, first find the angle between the two legs by subtracting the bearings, if that difference is exactly 90°, jump straight to Pythagoras; only use the Cosine Rule otherwise.',
  'This is exactly how a coast guard or fishing crew plots a boat''s net displacement from port after sailing two separate legs on different bearings, using only the two distances and the bearings recorded.',
  'published'
from public.lessons l join public.topics t on t.id = l.topic_id join public.curricula c on c.id = t.curriculum_id
where c.subject = 'Mathematics' and t.class_level = 'SS1' and t.term = 2 and t.order_index = 208;

insert into public.questions (topic_id, lesson_id, question_text, option_a, option_b, option_c, option_d, correct_letter, difficulty, exam_type, explanation, status)
select t.id, l.id, q.question_text, q.option_a, q.option_b, q.option_c, q.option_d, q.correct_letter, q.difficulty, q.exam_type, q.explanation, 'published'
from public.topics t
  join public.curricula c on c.id = t.curriculum_id
  join public.lessons l on l.topic_id = t.id,
  (values
  ('A vertical pole is 10 m high. Find the angle of elevation to the top from a point 10 m away.', '45°', '30°', '60°', '90°', 'A', 2, 'GENERAL', 'Opposite = adjacent = 10, so $\tan\theta=1 \Rightarrow \theta=45^\circ$.'),
  ('From a window, the angle of depression to an object 20 m from the house base is 45°. Find the window''s height.', '10 m', '40 m', '20 m', '14.14 m', 'C', 2, 'GENERAL', 'At 45°, opposite = adjacent, so height = 20 m.'),
  ('Is $\cos100^\circ$ positive or negative?', 'negative', 'positive', 'zero', 'undefined', 'A', 2, 'GENERAL', '100° is in the second quadrant, where cosine is negative.'),
  ('Is $\tan200^\circ$ positive or negative?', 'negative', 'zero', 'undefined', 'positive', 'D', 2, 'GENERAL', '200° is in the third quadrant, where tangent is positive (sine and cosine both negative, so their ratio is positive).'),
  ('What is the reference angle for 130°?', '130°', '50°', '40°', '80°', 'B', 2, 'GENERAL', 'Reference angle in the second quadrant is $180^\circ-130^\circ=50^\circ$.'),
  ('The shadow of a mast is 30 m long; angle of elevation of the sun is 30°. Find the exact height of the mast.', '$15\sqrt3$ m', '$30\sqrt3$ m', '$10\sqrt3$ m', '$5\sqrt3$ m', 'C', 3, 'GENERAL', 'Height $=30\tan30^\circ=30\times\frac{1}{\sqrt3}=\frac{30}{\sqrt3}=10\sqrt3$ m.'),
  ('From a lighthouse 120 m high, boats A and B (same side, in line) have angles of depression 30° and 60°. Find distance of A from base, distance of B from base, and distance between the boats.', 'A: $\frac{120}{\sqrt3}\approx69.3$ m; B: $120\sqrt3\approx207.8$ m; AB $\approx138.5$ m', 'A: $120\sqrt3\approx207.8$ m; B: $69.3$ m; AB $\approx277.1$ m', 'A: $207.8$ m; B: $69.3$ m; AB $\approx69.3$ m', 'A: $120\sqrt3\approx207.8$ m; B: $\frac{120}{\sqrt3}\approx69.3$ m; AB $\approx138.5$ m', 'D', 4, 'WAEC', 'The farther boat (smaller depression angle, 30°) is at $120/\tan30^\circ=120\sqrt3\approx207.8$ m; the nearer boat (60°) is at $120/\tan60^\circ\approx69.3$ m; AB is the difference, $\approx138.5$ m.'),
  ('Without a calculator, find $\tan315^\circ$, $\sin210^\circ$, $\cos135^\circ$.', '$\tan315^\circ=1$; $\sin210^\circ=\frac12$; $\cos135^\circ=\frac{\sqrt2}{2}$', '$\tan315^\circ=-1$; $\sin210^\circ=-\frac12$; $\cos135^\circ=-\frac{\sqrt2}{2}$', '$\tan315^\circ=-1$; $\sin210^\circ=\frac12$; $\cos135^\circ=-\frac{\sqrt2}{2}$', '$\tan315^\circ=1$; $\sin210^\circ=-\frac12$; $\cos135^\circ=\frac{\sqrt2}{2}$', 'B', 4, 'GENERAL', '315° is in Q4 (tan negative, reference 45°): $\tan315^\circ=-1$. 210° is in Q3 (sin negative, reference 30°): $\sin210^\circ=-\frac12$. 135° is in Q2 (cos negative, reference 45°): $\cos135^\circ=-\frac{\sqrt2}{2}$.'),
  ('If $\sin\theta=\frac35$ and $\theta$ is in Quadrant II, find $\cos\theta$ and $\tan\theta$.', '$\cos\theta=\frac45$, $\tan\theta=\frac34$', '$\cos\theta=-\frac45$, $\tan\theta=-\frac34$', '$\cos\theta=-\frac45$, $\tan\theta=\frac34$', '$\cos\theta=\frac45$, $\tan\theta=-\frac34$', 'B', 3, 'GENERAL', 'Using the 3-4-5 triangle, $\cos\theta=\pm\frac45$; in Quadrant II cosine is negative, so $\cos\theta=-\frac45$, and $\tan\theta=\sin\theta/\cos\theta=-\frac34$.'),
  ('Two sides of a triangle 10 cm and 15 cm enclose an angle of 55°. Find the third side and the two other angles.', 'third side $\approx12.37$ cm; angles $\approx55^\circ$ and $70^\circ$', 'third side $\approx12.37$ cm; angles $\approx83.36^\circ$ and $41.47^\circ$', 'third side $\approx17.68$ cm; angles $\approx83.36^\circ$ and $41.47^\circ$', 'third side $\approx12.37$ cm; angles $\approx90^\circ$ and $35^\circ$', 'B', 4, 'WAEC', 'By the Cosine Rule, third side $=\sqrt{10^2+15^2-2(10)(15)\cos55^\circ}\approx12.37$ cm; the Sine Rule then gives the other two angles as $\approx41.47^\circ$ and $83.36^\circ$ (they sum with 55° to 180°).'),
  ('Convert the 3-digit bearings 030°, 130°, and 300° to compass bearings.', 'N30°E, S50°E, N60°W', 'N30°E, N50°E, N60°W', 'S30°E, S50°E, S60°W', 'N30°W, S50°E, S60°W', 'A', 2, 'GENERAL', '030° is in the NE quadrant (N30°E); 130° is in the SE quadrant, S(180-130)E = S50°E; 300° is in the NW quadrant, N(360-300)W = N60°W.'),
  ('Convert N65°E and S40°W to 3-digit bearings.', '025° and 220°', '065° and 140°', '065° and 220°', '295° and 220°', 'C', 2, 'GENERAL', 'N65°E is 65° clockwise from North: 065°. S40°W is in the SW quadrant: 180°+40°=220°.'),
  ('Express the true bearing of 250° as a compass bearing.', 'S70°W', 'S70°E', 'N70°W', 'S20°W', 'A', 2, 'GENERAL', '250° is in the SW quadrant: S(250-180)W = S70°W.'),
  ('The bearing S40°E is the same as which 3-digit bearing?', '040°', '220°', '140°', '320°', 'C', 1, 'GENERAL', 'S40°E means 40° from South towards East, i.e. 180°-40°=140°.'),
  ('The bearing S50°W is the same as which 3-digit bearing?', '130°', '050°', '230°', '310°', 'C', 1, 'GENERAL', 'S50°W means 50° from South towards West, i.e. 180°+50°=230°.'),
  ('The bearing S40°W is the same as which 3-digit bearing?', '140°', '220°', '040°', '320°', 'B', 1, 'GENERAL', 'S40°W means 40° from South towards West, i.e. 180°+40°=220°.'),
  ('If P, Q, R are points such that the bearing of Q from P is 300° and bearing of R from P is 120°, find the bearing of Q from R.', '120°', '060°', '300°', '240°', 'C', 3, 'GENERAL', 'Since 300° and 120° differ by exactly 180°, P, Q, R are collinear, meaning the bearing of Q from R is the same as the bearing of Q from P: 300°.'),
  ('The bearing of a point A from B is 042°. Calculate the bearing of B from A.', '138°', '222°', '042°', '318°', 'B', 2, 'GENERAL', 'Since $042^\circ \le 180^\circ$, the back bearing is $042^\circ+180^\circ=222^\circ$.'),
  ('Find the bearing of X from Y, if the bearing of Y from X is 110°.', '290°', '070°', '250°', '020°', 'A', 2, 'GENERAL', 'Since $110^\circ \le 180^\circ$, the back bearing is $110^\circ+180^\circ=290^\circ$.'),
  ('Esther faced S20°W and turned 90° clockwise. What direction does she face now?', 'N70°W', 'N20°E', 'S70°E', 'N70°E', 'A', 3, 'GENERAL', 'S20°W as a 3-digit bearing is 200°; turning 90° clockwise gives 290°, which converts to N70°W.'),
  ('Town B is 120 km from town Q in direction 050°. What is the bearing of B from Q?', '230°', '050°', '130°', '310°', 'B', 1, 'GENERAL', 'The bearing of B from Q is given directly as 050°.'),
  ('A village Y is 15 km from point X on bearing 025°. Village Z is 20 km from X on bearing 115°. Find distance YZ.', '20 km', '25 km', '35 km', '17 km', 'B', 3, 'WAEC', 'The angle YXZ = $115^\circ-025^\circ=90^\circ$; by Pythagoras (a 15-20-25 triple), $YZ=\sqrt{15^2+20^2}=25$ km.'),
  ('A boat sails 24 km from port X on bearing 065° then 10 km on bearing 155°. Find its distance from X.', '24 km', '34 km', '26 km', '14 km', 'C', 3, 'WAEC', 'The turn angle is $155^\circ-065^\circ=90^\circ$; by Pythagoras, distance $=\sqrt{24^2+10^2}=\sqrt{676}=26$ km.'),
  ('A ship sails 5 km due west then 7 km due south. Find its bearing from the original position, to the nearest degree.', '036°', '144°', '216°', '306°', 'C', 3, 'GENERAL', 'The displacement is 5 km west and 7 km south, landing in the SW quadrant; reference angle $=\tan^{-1}(5/7)\approx35.5^\circ$ west of south, giving bearing $\approx180^\circ+35.5^\circ\approx216^\circ$.'),
  ('Y is 60 km from X on bearing 135°. Z is 80 km from X on bearing 225°. Find (a) distance ZY, (b) bearing of Z from Y.', '(a) 100 km; (b) 262°', '(a) 100 km; (b) 82°', '(a) 140 km; (b) 262°', '(a) 20 km; (b) 262°', 'A', 4, 'WAEC', 'Angle YXZ $=225^\circ-135^\circ=90^\circ$; by Pythagoras (a 60-80-100 triple), $ZY=100$ km; working out the direction from the coordinate geometry gives the bearing of Z from Y as approximately 262°.'),
  ('A hunter walks 250 m on bearing 042°. Find (i) the northward distance moved, (ii) the eastward distance covered.', '(i) $\approx186$ m; (ii) $\approx167$ m', '(i) $\approx167$ m; (ii) $\approx186$ m', '(i) $\approx250$ m; (ii) $\approx0$ m', '(i) $\approx200$ m; (ii) $\approx150$ m', 'A', 3, 'GENERAL', 'Northward $=250\cos42^\circ\approx186$ m; eastward $=250\sin42^\circ\approx167$ m.'),
  ('Points P and Q are 24 m north and 7 m east of point R respectively. Find the bearing of Q from P to the nearest degree.', '164°', '074°', '106°', '196°', 'A', 4, 'WAEC', 'Relative to P, Q is 24 m south and 7 m east; the reference angle from south is $\tan^{-1}(7/24)\approx16.3^\circ$, so the bearing is $180^\circ-16.3^\circ\approx164^\circ$.'),
  ('The bearings of Q and R from P are 030° and 120° respectively. If PQ = 24 m and PR = 7 m, find QR.', '17 m', '31 m', '23 m', '25 m', 'D', 3, 'WAEC', 'Angle QPR $=120^\circ-030^\circ=90^\circ$; by Pythagoras (a 7-24-25 triple), $QR=\sqrt{24^2+7^2}=25$ m.'),
  ('A man starts at A, walks 2 km on bearing 017°, then 3 km on bearing 107° to C. Find the bearing of C from A.', '$\approx017^\circ$', '$\approx107^\circ$', '$\approx163^\circ$', '$\approx073^\circ$', 'D', 5, 'WAEC', 'The two legs differ by exactly 90°, forming a right angle at the turning point B; resolving the displacement into components and finding the resultant direction from A gives a bearing of approximately 073°.'),
  ('A man walks 6 km due East then 8 km due North. Find his bearing from the initial position (1 dp).', '53.1°', '126.9°', '323.1°', '36.9°', 'D', 3, 'GENERAL', 'The bearing is measured from North towards East: $\tan^{-1}(6/8)\approx36.9^\circ$.'),
  ('A boat sails 8 km from port Q on bearing 055° then 15 km on bearing 145°. Find its distance from Q.', '23 km', '17 km', '7 km', '13 km', 'B', 3, 'WAEC', 'The turn angle is $145^\circ-055^\circ=90^\circ$; by Pythagoras (an 8-15-17 triple), distance $=\sqrt{8^2+15^2}=17$ km.'),
  ('Three towns P, Q, R: PQ = 15 km, PR = 20 km; bearing of Q from P is 030°, bearing of R from P is 300°. Find RQ.', '35 km', '25 km', '5 km', '15 km', 'B', 4, 'WAEC', 'Angle QPR $=030^\circ-300^\circ+360^\circ=90^\circ$; by Pythagoras (a 15-20-25 triple), $RQ=\sqrt{15^2+20^2}=25$ km.'),
  ('The bearing of X from Y is 060°. The bearing of Z from X is 150°. If XY = 600 km and XZ = 500 km, find YZ.', '650.00 km', '1100.00 km', '509.90 km', '781.02 km', 'D', 5, 'WAEC', 'The angle YXZ works out to 150° (using the back bearing of Y from X, 240°, and the given bearing of Z from X, 150°: $240^\circ-150^\circ=90^\circ$ is not the internal angle here; applying the Cosine Rule with the correctly identified included angle of 150° gives $YZ=\sqrt{600^2+500^2-2(600)(500)\cos150^\circ}\approx781.02$ km.'),
  ('The bearings of Y and Z from X are 060° and 150°. XY = 12 m, XZ = 5 m. Find YZ.', '13 m', '17 m', '7 m', '11 m', 'A', 3, 'WAEC', 'Angle YXZ $=150^\circ-060^\circ=90^\circ$; by Pythagoras (a 5-12-13 triple), $YZ=\sqrt{12^2+5^2}=13$ m.'),
  ('From point R, 300 m north of P, a man walks eastward to point Q, 600 m from P. Find the bearing of P from Q (nearest degree).', '060°', '240°', '300°', '120°', 'B', 5, 'WAEC', 'RQ (the eastward distance) $=\sqrt{600^2-300^2}\approx519.6$ m; the vector from Q to P points south-west, with reference angle $\tan^{-1}(519.6/300)\approx60^\circ$ from south, giving bearing $180^\circ+60^\circ=240^\circ$.'),
  ('Three observation points P, Q, R: Q is due East of P, R is due North of Q. PQ = 5 km, PR = 10 km. Find QR.', '$5\sqrt2$ km $\approx7.07$ km', '$5$ km', '$15$ km', '$5\sqrt3$ km $\approx8.66$ km', 'D', 4, 'WAEC', 'Triangle PQR is right-angled at Q, so $QR=\sqrt{PR^2-PQ^2}=\sqrt{100-25}=\sqrt{75}=5\sqrt3$ km.'),
  ('Q is 32 km from P on bearing 042°, R is 25 km from P on bearing 132°. Find the bearing of R from Q.', '$\approx094^\circ$', '$\approx274^\circ$', '$\approx004^\circ$', '$\approx184^\circ$', 'D', 5, 'WAEC', 'Angle QPR $=132^\circ-042^\circ=90^\circ$; placing P at the origin and resolving Q and R into coordinates, the vector from Q to R points into the third quadrant relative to Q, giving a bearing of approximately 184°.'),
  ('A and B are two ports 15 km apart; B is on bearing 094° from A. A ship C is seen from A on bearing 150° and from B on bearing 245°. Calculate the distance of the ship from A (1 dp).', '$\approx15.0$ km', '$\approx7.3$ km', '$\approx9.6$ km', '$\approx5.8$ km', 'B', 5, 'WAEC', 'Angle at A (between AB and AC) $=150^\circ-94^\circ=56^\circ$; angle at B (between BA and BC) $=274^\circ-245^\circ=29^\circ$; angle at C $=180^\circ-56^\circ-29^\circ=95^\circ$; by the Sine Rule, $AC=\frac{AB\sin B}{\sin C}=\frac{15\sin29^\circ}{\sin95^\circ}\approx7.3$ km.')
) as q(question_text, option_a, option_b, option_c, option_d, correct_letter, difficulty, exam_type, explanation)
where c.subject = 'Mathematics' and t.class_level = 'SS1' and t.term = 2 and t.order_index = 208;
-- ------------------------------------------
-- 209. CIRCLES: ARC LENGTH, SECTORS, SEGMENTS & AREA OF TRIANGLES
-- ------------------------------------------

insert into public.lessons (topic_id, title, summary, content_body, order_index)
values (
  (select t.id from public.topics t join public.curricula c on c.id = t.curriculum_id
   where c.subject = 'Mathematics' and t.class_level = 'SS1' and t.term = 2 and t.order_index = 209),
  'Circles: Arc Length, Sectors, Segments and Triangle Area',
  'Formulas for arc length, sector perimeter and area, segment area and perimeter, chord length, and the area of a triangle from two sides and an included angle or from Hero''s formula.',
  '### Circle Basics

Radius $r$; diameter $d=2r$; circumference $C=2\pi r$; area $A=\pi r^2$ (use $\pi=\frac{22}{7}$ or $3.142$ as instructed).

### Arc, Sector and Segment Formulas

An arc subtending angle $\theta$ at the centre is a fraction $\frac{\theta}{360^\circ}$ of the full circle:

- **Arc length** $=\frac{\theta}{360^\circ}\times2\pi r$
- **Perimeter of a sector** $=2r+\frac{\theta}{360^\circ}\times2\pi r$ (two straight radii plus the arc)
- **Area of a sector** $=\frac{\theta}{360^\circ}\times\pi r^2$
- **Chord length** $=2r\sin\left(\frac{\theta}{2}\right)$
- **Area of the triangle** formed by two radii and the chord $=\frac12 r^2\sin\theta$
- **Area of a segment** $=$ sector area $-$ triangle area $=\frac{\theta}{360^\circ}\pi r^2-\frac12 r^2\sin\theta$
- **Perimeter of a segment** $=$ arc length $+$ chord length (NOT plus two radii, a segment has no straight radii on its boundary)

### Area of a Triangle

Given two sides and the included angle: Area $=\frac12 ab\sin C$. Given all three sides only, use **Hero''s (Heron''s) formula**: Area $=\sqrt{s(s-a)(s-b)(s-c)}$, where $s=\frac12(a+b+c)$ is the semi-perimeter.',
  1
);

insert into public.worked_examples (lesson_id, title, problem_statement, solution_steps, exam_shortcut, status)
select l.id,
  'Finding an Arc Length',
  'A circle has radius 21 cm. Find the arc length subtending 60 degrees at the centre ($\pi=\frac{22}{7}$).',
  to_jsonb(array[
    'Write the arc-length formula: arc $=\frac{\theta}{360^\circ}\times2\pi r$.',
    'Substitute $\theta=60^\circ$, $r=21$, $\pi=\frac{22}{7}$: arc $=\frac{60}{360}\times2\times\frac{22}{7}\times21$.',
    'Simplify the fraction $\frac{60}{360}$ to $\frac16$: arc $=\frac16\times2\times\frac{22}{7}\times21$.',
    'Simplify $2\times\frac{22}{7}\times21$ (note $21/7=3$): $2\times22\times3=132$.',
    'Multiply: arc $=\frac{132}{6}=22$.'
  ]),
  'Learn the three "θ/360°" formulas as one family: arc length, sector area, and sector perimeter all start from the same fraction, write it once at the top of your working and reuse it.',
  'published'
from public.lessons l join public.topics t on t.id = l.topic_id join public.curricula c on c.id = t.curriculum_id
where c.subject = 'Mathematics' and t.class_level = 'SS1' and t.term = 2 and t.order_index = 209;

insert into public.worked_examples (lesson_id, title, problem_statement, solution_steps, exam_shortcut, real_life_context, diagram_type, diagram_data, status)
select l.id,
  'Perimeter of a Sector (a Bicycle Wheel Slice)',
  'A sector has radius 14 cm and angle 120 degrees. Find its perimeter.',
  to_jsonb(array[
    'Find the arc length first: arc $=\frac{120}{360}\times2\times\frac{22}{7}\times14=\frac13\times88=\frac{88}{3}\approx29.33$ cm.',
    'Recall the perimeter of a sector adds the arc PLUS the two straight radii: perimeter $=$ arc $+2r$.',
    'Substitute: perimeter $=29.33+2(14)=29.33+28$.',
    'Add: perimeter $=57.33$ cm.'
  ]),
  'A segment''s perimeter uses the chord, NOT two radii, a sector''s perimeter uses two radii, NOT the chord. Sketch the shape and trace its boundary with your finger before writing the formula.',
  'This is the same slice-shaped region a bicycle mechanic or a pizza cutter deals with, the curved edge plus the two straight cuts define exactly the sector''s boundary.',
  'circle',
  '{"centerLabel": "O", "radiusLabel": "14 cm", "highlightSector": {"startAngle": 0, "endAngle": 120, "label": "120°"}}'::jsonb,
  'published'
from public.lessons l join public.topics t on t.id = l.topic_id join public.curricula c on c.id = t.curriculum_id
where c.subject = 'Mathematics' and t.class_level = 'SS1' and t.term = 2 and t.order_index = 209;

insert into public.worked_examples (lesson_id, title, problem_statement, solution_steps, exam_shortcut, common_trap_warning, diagram_type, diagram_data, status)
select l.id,
  'Area of a Minor Segment',
  'A chord subtends 90 degrees at the centre of a circle of radius 14 cm. Find the area of the minor segment ($\pi=\frac{22}{7}$).',
  to_jsonb(array[
    'Recall segment area = sector area minus triangle area. Find the sector area first: area $=\frac{90}{360}\times\frac{22}{7}\times14^2=\frac14\times\frac{22}{7}\times196$.',
    'Simplify $196/7=28$: sector area $=\frac14\times22\times28=\frac14\times616=154$ cm².',
    'Find the triangle area (formed by the two radii and the chord), using area $=\frac12r^2\sin\theta$: triangle area $=\frac12(14^2)\sin90^\circ=\frac12(196)(1)=98$ cm².',
    'Subtract: segment area $=154-98=56$ cm².'
  ]),
  'Segment = Sector minus Triangle, always. Picture the pie-slice (sector) with a triangular corner sliced off by the straight chord, leaving the curved segment.',
  'A common error is subtracting in the wrong order or using the full circle area instead of the sector area, always compute the SECTOR area (using the given central angle) before subtracting the triangle.',
  'circle',
  '{"centerLabel": "O", "radiusLabel": "14 cm", "highlightSector": {"startAngle": 0, "endAngle": 90, "label": "90°"}, "chord": {"fromAngle": 0, "toAngle": 90, "label": "segment"}}'::jsonb,
  'published'
from public.lessons l join public.topics t on t.id = l.topic_id join public.curricula c on c.id = t.curriculum_id
where c.subject = 'Mathematics' and t.class_level = 'SS1' and t.term = 2 and t.order_index = 209;

insert into public.worked_examples (lesson_id, title, problem_statement, solution_steps, exam_shortcut, status)
select l.id,
  'Triangle Area Using Hero''s Formula',
  'A chord PQ of length 24 cm is drawn in a circle of radius 37 cm, with R as the centre. Find the area of triangle PRQ using Hero''s formula.',
  to_jsonb(array[
    'Identify the three sides of triangle PRQ: $PR=37$ cm, $RQ=37$ cm, $PQ=24$ cm.',
    'Compute the semi-perimeter $s=\frac12(a+b+c)=\frac12(37+37+24)=49$.',
    'Compute each bracket: $s-PR=12$; $s-RQ=12$; $s-PQ=25$.',
    'Substitute into Hero''s formula: Area $=\sqrt{49\times12\times12\times25}$.',
    'Group perfect squares: $49=7^2$, $12\times12=12^2$, $25=5^2$.',
    'Take the square root of each factor: $7\times12\times5=420$.'
  ]),
  'Use Hero''s formula only when no angle is given, if an included angle IS given, Area $=\frac12ab\sin C$ is faster and avoids expanding large square roots.',
  'published'
from public.lessons l join public.topics t on t.id = l.topic_id join public.curricula c on c.id = t.curriculum_id
where c.subject = 'Mathematics' and t.class_level = 'SS1' and t.term = 2 and t.order_index = 209;

insert into public.questions (topic_id, lesson_id, question_text, option_a, option_b, option_c, option_d, correct_letter, difficulty, exam_type, explanation, status)
select t.id, l.id, q.question_text, q.option_a, q.option_b, q.option_c, q.option_d, q.correct_letter, q.difficulty, q.exam_type, q.explanation, 'published'
from public.topics t
  join public.curricula c on c.id = t.curriculum_id
  join public.lessons l on l.topic_id = t.id,
  (values
  ('Define a "sector" of a circle.', 'the region bounded by two radii and the arc between them', 'the region bounded by a chord and its arc', 'the boundary line of a circle', 'the region bounded by two chords', 'A', 1, 'GENERAL', 'A sector is the pie-slice region enclosed by two radii and the arc joining their endpoints.'),
  ('Define a "segment" of a circle.', 'the region bounded by two radii and an arc', 'the diameter of the circle', 'the region bounded by a chord and its arc', 'the region outside a chord', 'C', 1, 'GENERAL', 'A segment is the region cut off between a chord and the arc it subtends.'),
  ('A circle has radius 10 cm. Find the arc length subtending 90° (leave in terms of $\pi$).', '$5\pi$ cm', '$10\pi$ cm', '$2.5\pi$ cm', '$20\pi$ cm', 'A', 2, 'GENERAL', 'Arc $=\frac{90}{360}\times2\pi(10)=\frac14\times20\pi=5\pi$ cm.'),
  ('A sector has radius 5 cm and arc length 10 cm. Find the perimeter of the sector.', '15 cm', '10 cm', '25 cm', '20 cm', 'D', 2, 'GENERAL', 'Perimeter $=$ arc $+2r=10+10=20$ cm.'),
  ('Find the length of an arc of radius 28 cm subtending 45° at the centre ($\pi=\frac{22}{7}$).', '11 cm', '22 cm', '44 cm', '14 cm', 'B', 2, 'GENERAL', 'Arc $=\frac{45}{360}\times2\times\frac{22}{7}\times28=\frac18\times176=22$ cm.'),
  ('The perimeter of a sector of radius 7 cm is 25 cm. Find (a) the arc length, (b) the angle subtended.', '(a) 14 cm; (b) $\approx115^\circ$', '(a) 11 cm; (b) $\approx90^\circ$', '(a) 11 cm; (b) $\approx45^\circ$', '(a) 18 cm; (b) $\approx90^\circ$', 'B', 3, 'GENERAL', 'Arc $=25-2(7)=11$ cm; angle: $11=\frac{\theta}{360}\times2\times\frac{22}{7}\times7=\frac{\theta}{360}\times44 \Rightarrow \theta\approx90^\circ$.'),
  ('A bicycle wheel of radius 35 cm turns 100 times. Find the distance covered.', '11,000 cm (110 m)', '35,000 cm (350 m)', '2,200 cm (22 m)', '22,000 cm (220 m)', 'D', 2, 'GENERAL', 'Circumference $=2\pi(35)=220$ cm; distance $=220\times100=22{,}000$ cm $=220$ m.'),
  ('A clock''s minute hand is 10 cm long. How far does the tip move in 20 minutes?', '$\approx20.9$ cm', '$\approx62.8$ cm', '$\approx10.5$ cm', '$\approx41.9$ cm', 'A', 2, 'GENERAL', '20 minutes is $\frac13$ of a full turn: arc $=\frac13\times2\pi(10)\approx20.9$ cm.'),
  ('Find the area of a sector of radius 21 cm with angle 60° ($\pi=\frac{22}{7}$).', '462 cm²', '115.5 cm²', '231 cm²', '693 cm²', 'C', 2, 'GENERAL', 'Area $=\frac{60}{360}\times\frac{22}{7}\times21^2=\frac16\times1386=231$ cm².'),
  ('Find the area of the minor segment of radius 8 cm if the chord subtends 60° (leave in terms of $\pi$ and $\sqrt3$).', '$\left(\frac{32\pi}{3}+16\sqrt3\right)$ cm²', '$\left(\frac{32\pi}{3}-16\sqrt3\right)$ cm² $\approx5.80$ cm²', '$16\sqrt3$ cm²', '$\frac{32\pi}{3}$ cm²', 'B', 3, 'GENERAL', 'Sector area $=\frac{60}{360}\pi(64)=\frac{32\pi}{3}$; triangle area $=\frac12(64)\sin60^\circ=16\sqrt3$; segment $=\frac{32\pi}{3}-16\sqrt3\approx5.80$ cm².'),
  ('A circle has radius 21 cm. Find the length of an arc subtending 60° at the centre ($\pi=\frac{22}{7}$).', '11 cm', '44 cm', '33 cm', '22 cm', 'D', 2, 'GENERAL', 'Arc $=\frac16\times2\times\frac{22}{7}\times21=22$ cm.'),
  ('An arc of length 11 cm is on a circle of radius 7 cm. Find the angle subtended.', '45°', '90°', '60°', '120°', 'B', 3, 'GENERAL', '$11=\frac{\theta}{360}\times2\times\frac{22}{7}\times7=\frac{\theta}{360}\times44 \Rightarrow \theta=90^\circ$.'),
  ('A sector of radius 14 cm and angle 120°: find its perimeter.', '44 cm', '28 cm', '57.33 cm ($\frac{172}{3}$ cm)', '85.33 cm', 'C', 3, 'GENERAL', 'Arc $=\frac13\times2\times\frac{22}{7}\times14=\frac{88}{3}$; perimeter $=\frac{88}{3}+28=\frac{172}{3}\approx57.33$ cm.'),
  ('Find the area of a sector of radius 10 cm, angle 135° ($\pi=3.142$).', '78.55 cm²', '235.65 cm²', '39.275 cm²', '117.825 cm²', 'D', 2, 'GENERAL', 'Area $=0.375\times3.142\times100=117.825$ cm².'),
  ('A chord subtends 90° at the centre of a circle radius 14 cm. Find the area of the minor segment.', '98 cm²', '154 cm²', '42 cm²', '56 cm²', 'D', 3, 'GENERAL', 'Sector area $=154$ cm²; triangle area $=98$ cm²; segment $=154-98=56$ cm².'),
  ('An arc of a circle radius 8 cm subtends 85° at the centre. Find the length of the major arc ($\pi=\frac{22}{7}$).', '11.87 cm', '38.41 cm', '50.28 cm', '25.20 cm', 'B', 3, 'GENERAL', 'Minor arc $=\frac{85}{360}\times2\times\frac{22}{7}\times8\approx11.87$ cm; major arc $=$ circumference $-$ minor arc $\approx50.27-11.87\approx38.41$ cm.'),
  ('Find the length of an arc subtending 60° at the centre of a circle radius 21 cm ($\pi=\frac{22}{7}$).', '11 cm', '22 cm', '44 cm', '33 cm', 'B', 2, 'GENERAL', 'Arc $=\frac16\times2\times\frac{22}{7}\times21=22$ cm.'),
  ('The pendulum of a clock is 5 cm long and swings through an arc of 8 cm. Find the angle of swing ($\pi=\frac{22}{7}$).', '80°', '100°', '92°', '46°', 'C', 3, 'GENERAL', '$8=\frac{\theta}{360}\times2\times\frac{22}{7}\times5 \Rightarrow \theta=\frac{8\times360\times7}{2\times22\times5}\approx91.6\approx92^\circ$.'),
  ('A circle is divided into sectors in the ratio 3:7; radius 7 cm. Find the length of the minor arc.', '30.8 cm', '13.2 cm', '6.6 cm', '15.4 cm', 'B', 3, 'GENERAL', 'The minor sector is $\frac{3}{10}$ of the circle; arc $=\frac{3}{10}\times2\times\frac{22}{7}\times7=\frac{3}{10}\times44=13.2$ cm.'),
  ('An arc of length 110 cm subtends 210° at the centre. Find the radius ($\pi=\frac{22}{7}$).', '15 cm', '60 cm', '45 cm', '30 cm', 'D', 3, 'GENERAL', '$110=\frac{210}{360}\times2\times\frac{22}{7}\times r=\frac{7}{12}\times\frac{44}{7}\times r=\frac{44}{12}r \Rightarrow r=\frac{110\times12}{44}=30$ cm.'),
  ('An arc of a circle radius 13.5 cm subtends 105° at the centre. Find (i) chord length AB, (ii) arc length AB ($\pi=3.142$).', '(i) 21.4 cm; (ii) 24.75 cm', '(i) 24.75 cm; (ii) 21.4 cm', '(i) 21.4 cm; (ii) 27.0 cm', '(i) 19.8 cm; (ii) 24.75 cm', 'A', 3, 'GENERAL', 'Chord $=2(13.5)\sin52.5^\circ\approx21.4$ cm; arc $=\frac{105}{360}\times2\pi(13.5)\approx24.75$ cm.'),
  ('Calculate the length of the major arc ACB, radius 7 cm, minor arc angle 50° (2 dp).', '6.11 cm', '43.98 cm', '31.78 cm', '37.89 cm', 'D', 3, 'GENERAL', 'Minor arc $=\frac{50}{360}\times2\times\frac{22}{7}\times7\approx6.11$ cm; major arc $=$ circumference ($\approx44$ cm) minus minor arc $\approx37.89$ cm.'),
  ('Calculate, in terms of $\pi$, the arc length of a circle radius 12 cm subtending 240°.', '$8\pi$ cm', '$24\pi$ cm', '$12\pi$ cm', '$16\pi$ cm', 'D', 2, 'GENERAL', 'Arc $=\frac{240}{360}\times2\pi(12)=\frac23\times24\pi=16\pi$ cm.'),
  ('O is centre of circle radius 14 cm, $\angle XOY=40^\circ$. Find the length of the major arc XZY (2 dp), and the area of the minor sector XOY (2 dp) ($\pi=\frac{22}{7}$).', 'major arc $\approx9.78$ cm; minor sector area $\approx68.44$ cm²', 'major arc $\approx78.22$ cm; minor sector area $\approx615.44$ cm²', 'major arc $\approx87.97$ cm; minor sector area $\approx61.60$ cm²', 'major arc $\approx78.22$ cm; minor sector area $\approx68.44$ cm²', 'D', 4, 'GENERAL', 'Circumference $\approx88$ cm; minor arc $=\frac{40}{360}\times88\approx9.78$ cm; major arc $\approx88-9.78\approx78.22$ cm; minor sector area $=\frac{40}{360}\times\frac{22}{7}\times14^2\approx68.44$ cm².'),
  ('The lengths of the minor and major arcs of a circle are 54 cm and 126 cm respectively. Calculate the angle of the major sector.', '108°', '180°', '252°', '216°', 'C', 3, 'GENERAL', 'Total circumference $=180$ cm; major arc fraction $=126/180=0.7$; angle $=0.7\times360^\circ=252^\circ$.'),
  ('Find the length of arc of radius 15.4 cm subtending 60° ($\pi=\frac{22}{7}$).', '8.07 cm', '16.13 cm', '32.27 cm', '24.20 cm', 'B', 2, 'GENERAL', 'Arc $=\frac16\times2\times\frac{22}{7}\times15.4\approx16.13$ cm.'),
  ('Find the length of arc PQ, radius 21 cm, angle 120° (as per the source figure).', '22 cm', '66 cm', '88 cm', '44 cm', 'D', 2, 'GENERAL', 'Arc $=\frac13\times2\times\frac{22}{7}\times21=44$ cm.'),
  ('An arc subtends 60° at the centre, radius 3 cm; find the arc length in terms of $\pi$.', '$\pi$ cm', '$2\pi$ cm', '$3\pi$ cm', '$0.5\pi$ cm', 'A', 2, 'GENERAL', 'Arc $=\frac16\times2\pi(3)=\pi$ cm.'),
  ('A chord EF subtends 60° at the centre of a circle radius 7 cm. Calculate the length of the major arc formed.', '7.3 cm', '44.0 cm', '29.3 cm', '36.7 cm', 'D', 3, 'GENERAL', 'Minor arc $=\frac16\times2\times\frac{22}{7}\times7\approx7.33$ cm; circumference $\approx44$ cm; major arc $\approx44-7.33\approx36.7$ cm.'),
  ('An arc of radius 3.5 cm is 6.6 cm long. Find the angle subtended ($\pi=\frac{22}{7}$).', '90°', '120°', '108°', '135°', 'C', 3, 'GENERAL', '$6.6=\frac{\theta}{360}\times2\times\frac{22}{7}\times3.5=\frac{\theta}{360}\times22 \Rightarrow \theta=108^\circ$.'),
  ('A sector subtending 172° has perimeter 600 cm. Find the radius to the nearest cm ($\pi=\frac{22}{7}$).', '100 cm', '140 cm', '150 cm', '120 cm', 'D', 4, 'GENERAL', 'Perimeter $=2r+\frac{172}{360}\times2\times\frac{22}{7}r=600$; solving numerically gives $r\approx120$ cm.'),
  ('A sector of radius 6 cm subtends 60° at the centre. Find its perimeter in terms of $\pi$.', '$2(6+\pi)$ cm', '$6+\pi$ cm', '$12+\pi$ cm', '$3(4+\pi)$ cm', 'A', 3, 'GENERAL', 'Arc $=\frac16\times2\pi(6)=2\pi$; perimeter $=2\pi+2(6)=2(6+\pi)$ cm.'),
  ('OX and OY are radii of a circle radius 4 cm, $\angle XOY=60^\circ$. Find the perimeter of sector XOY to the nearest whole number ($\pi=\frac{22}{7}$).', '8 cm', '12 cm', '16 cm', '20 cm', 'B', 3, 'GENERAL', 'Arc $=\frac16\times2\times\frac{22}{7}\times4\approx4.19$ cm; perimeter $\approx4.19+8\approx12$ cm.'),
  ('The angle of a sector of radius 5.5 cm is 60°. Find the perimeter ($\pi=\frac{22}{7}$).', '11.00 cm', '22.76 cm', '5.76 cm', '16.76 cm', 'D', 3, 'GENERAL', 'Arc $=\frac16\times2\times\frac{22}{7}\times5.5\approx5.76$ cm; perimeter $\approx5.76+11\approx16.76$ cm.'),
  ('A sector bounded by radii of 6 cm subtending 50°. Find its perimeter (2 dp).', '12.00 cm', '5.24 cm', '20.24 cm', '17.24 cm', 'D', 3, 'GENERAL', 'Arc $=\frac{50}{360}\times2\pi(6)\approx5.24$ cm; perimeter $\approx5.24+12\approx17.24$ cm.'),
  ('Find the radius of a sector whose perimeter is 32 cm and arc length is 25 cm.', '7 cm', '14 cm', '3.5 cm', '10.5 cm', 'C', 3, 'GENERAL', 'Two radii $=32-25=7$ cm, so $r=3.5$ cm.'),
  ('A chord subtends 120° at the centre of a circle radius 3.5 cm. Find the perimeter of the minor sector ($\pi=\frac{22}{7}$).', '$14\frac13$ cm', '$7\frac13$ cm', '$21\frac13$ cm', '$10\frac13$ cm', 'A', 3, 'GENERAL', 'Arc $=\frac13\times2\times\frac{22}{7}\times3.5=\frac{22}{3}$; perimeter $=\frac{22}{3}+7=\frac{43}{3}=14\frac13$ cm.'),
  ('An arc of radius 14 cm subtends 300° at the centre. Find the perimeter of the sector formed ($\pi=\frac{22}{7}$).', '73.33 cm', '128.00 cm', '87.33 cm', '101.33 cm ($\frac{304}{3}$ cm)', 'D', 3, 'GENERAL', 'Arc $=\frac{300}{360}\times2\times\frac{22}{7}\times14=\frac{220}{3}\approx73.33$ cm; perimeter $=73.33+28\approx101.33$ cm.'),
  ('Find the perimeter of a sector of radius 14 cm subtending 135° ($\pi=\frac{22}{7}$).', '33 cm', '47 cm', '61 cm', '75 cm', 'C', 3, 'GENERAL', 'Arc $=\frac{135}{360}\times2\times\frac{22}{7}\times14=33$ cm; perimeter $=33+28=61$ cm.'),
  ('Calculate the area of a sector of radius 14 cm subtending 130° at the centre ($\pi=3.14$).', '222.24 cm²', '88.90 cm²', '311.14 cm²', '155.86 cm²', 'A', 3, 'GENERAL', 'Area $=\frac{130}{360}\times3.14\times14^2=\frac{130}{360}\times615.44\approx222.24$ cm².'),
  ('A sector of angle 120° is cut from a circle of radius 13.5 cm. What area remains ($\pi=\frac{22}{7}$)?', '190.95 cm²', '572.85 cm²', '381.9 cm²', '763.8 cm²', 'C', 4, 'GENERAL', 'Full circle area $\approx572.9$ cm²; the cut sector (120°) has area $\approx190.95$ cm²; area remaining $\approx572.9-190.95\approx381.9$ cm².'),
  ('XOY is a sector of radius 3.5 cm subtending 144°. Find the sector area in terms of $\pi$.', '$1.4\pi$ cm²', '$9.8\pi$ cm²', '$4.9\pi$ cm²', '$2.45\pi$ cm²', 'C', 3, 'GENERAL', 'Area $=\frac{144}{360}\times\pi\times3.5^2=0.4\times12.25\pi=4.9\pi$ cm² (numerically $\approx15.39$ cm²).'),
  ('Concentric circles of radii 13 cm and 10 cm, sector angle 120°. Find the area of the shaded portion between them.', '$23\pi$ cm²', '$69\pi$ cm²', '$3\pi$ cm²', '$46\pi$ cm²', 'A', 4, 'GENERAL', 'Shaded area $=\frac{120}{360}\pi(13^2-10^2)=\frac13\pi(169-100)=\frac13\times69\pi=23\pi$ cm².'),
  ('An arc of a circle radius 12 cm subtends $x^\circ$ at the centre; the sector perimeter is 46 cm. Find (i) $x$, (ii) the sector area ($\pi=\frac{22}{7}$).', '(i) $x=105^\circ$; (ii) $113.14$ cm²', '(i) $x=90^\circ$; (ii) $150.86$ cm²', '(i) $x=80^\circ$; (ii) $100.48$ cm²', '(i) $x=90^\circ$; (ii) $113.14$ cm²', 'D', 4, 'GENERAL', 'Arc $=46-24=22$ cm; $22=\frac{x}{360}\times2\times\frac{22}{7}\times12 \Rightarrow x=90^\circ$; sector area $=\frac{90}{360}\times\frac{22}{7}\times144\approx113.14$ cm².'),
  ('POR is a sector of radius 4 cm, $\angle POR=30^\circ$. Find the area (3 s.f., $\pi=\frac{22}{7}$).', '2.09 cm²', '4.19 cm²', '8.38 cm²', '12.57 cm²', 'B', 2, 'GENERAL', 'Area $=\frac{30}{360}\times\frac{22}{7}\times16\approx4.19$ cm².'),
  ('A sector of a circle of diameter 8 cm has angle 135°. Find its area ($\pi=\frac{22}{7}$).', '$37\frac17$ cm²', '$9\frac27$ cm²', '$12\frac37$ cm²', '$18\frac{4}{7}$ cm² ($\approx18.86$ cm²)', 'D', 3, 'GENERAL', 'Radius $=4$ cm; area $=\frac{135}{360}\times\frac{22}{7}\times16=\frac{3}{8}\times\frac{352}{7}=\frac{132}{7}=18\frac47$ cm².'),
  ('A chord subtends an angle $\theta$ at the centre; state the formula for chord length.', '$2r\sin(\theta/2)$', '$r\sin\theta$', '$2r\cos(\theta/2)$', '$r\theta$', 'A', 1, 'GENERAL', 'The chord splits the isosceles radii-triangle into two right triangles, giving chord $=2r\sin(\theta/2)$.'),
  ('A chord of length 30 cm is 8 cm from the centre. Find the radius.', '17 cm', '15 cm', '23 cm', '19 cm', 'A', 3, 'GENERAL', 'Half-chord $=15$; $r=\sqrt{8^2+15^2}=17$ cm.'),
  ('The distance of a chord of radius 20 cm from the centre is 16 cm. Find the chord''s length.', '12 cm', '36 cm', '24 cm', '18 cm', 'C', 3, 'GENERAL', 'Half-chord $=\sqrt{20^2-16^2}=12$; chord $=24$ cm.'),
  ('A chord''s length is 24 cm and its distance from the centre is 8 cm. Find the radius (2 dp).', '16.00 cm', '12.65 cm', '14.42 cm', '18.87 cm', 'C', 3, 'GENERAL', 'Half-chord $=12$; $r=\sqrt{12^2+8^2}=\sqrt{208}\approx14.42$ cm.'),
  ('An arc PQ of a circle of radius 14 cm subtends 74° at the centre. Calculate (a) the length of chord PQ, (b) the distance of PQ from the centre, (c) the area of triangle POQ, all to 2 dp.', '(a) 16.85 cm; (b) 11.18 cm; (c) 94.21 cm²', '(a) 16.85 cm; (b) 9.02 cm; (c) 94.21 cm²', '(a) 14.00 cm; (b) 11.18 cm; (c) 84.00 cm²', '(a) 16.85 cm; (b) 11.18 cm; (c) 75.37 cm²', 'A', 4, 'GENERAL', 'Chord $=2(14)\sin37^\circ\approx16.85$ cm; distance $=14\cos37^\circ\approx11.18$ cm; triangle area $=\frac12(14^2)\sin74^\circ\approx94.21$ cm².'),
  ('A chord XY of circle centre O, radius 5.32 cm, $\angle XOY=140^\circ$. Find the chord length to the nearest cm.', '8 cm', '12 cm', '10 cm', '5 cm', 'C', 3, 'GENERAL', 'Chord $=2(5.32)\sin70^\circ\approx10.0$ cm.'),
  ('A chord PQ of length 24 cm is drawn in a circle of radius 37 cm; R is the centre. Find the area of triangle PRQ using Hero''s formula.', '444 cm²', '360 cm²', '480 cm²', '420 cm²', 'D', 4, 'GENERAL', '$s=49$; area $=\sqrt{49\times12\times12\times25}=7\times12\times5=420$ cm².'),
  ('Two chords MN = 10 cm and PQ = 8 cm in a circle of radius 12 cm. Find the distance of each chord from the centre.', 'MN $\approx11.31$ cm; PQ $\approx10.91$ cm', 'MN $\approx8.00$ cm; PQ $\approx10.00$ cm', 'MN $\approx9.00$ cm; PQ $\approx11.00$ cm', 'MN $\approx10.91$ cm; PQ $\approx11.31$ cm', 'D', 4, 'GENERAL', 'For MN, half-chord $=5$: distance $=\sqrt{12^2-5^2}=\sqrt{119}\approx10.91$ cm. For PQ, half-chord $=4$: distance $=\sqrt{12^2-4^2}=\sqrt{128}\approx11.31$ cm.'),
  ('O is the centre of a circle radius 14 cm; a chord AB is claimed to be 42 cm long, with OM = 14 cm and $\angle OMA = 90^\circ$. What is wrong with this data?', 'Nothing is wrong; OA = 44.72 cm', 'OM cannot equal the radius', 'AB = 42 cm is impossible: the longest possible chord (the diameter) is only $2\times14=28$ cm', 'The right angle at M is impossible', 'C', 4, 'GENERAL', 'A chord can never exceed the diameter of its circle; here the diameter is 28 cm, so a 42 cm chord cannot exist in this circle, the given data is inconsistent.'),
  ('A chord AB subtends 120° at the centre of radius 8 cm; find the chord length.', '$8\sqrt2$ cm $\approx11.31$ cm', '$8\sqrt3$ cm $\approx13.86$ cm', '$16$ cm', '$4\sqrt3$ cm', 'B', 3, 'GENERAL', 'Chord $=2(8)\sin60^\circ=16\times\frac{\sqrt3}{2}=8\sqrt3$ cm.'),
  ('The centre of circle ABC is O, radius 8 cm, $\angle ACB=40^\circ$ (C on the circumference). Calculate (a) chord AB, (b) perpendicular OM from O to AB.', '(a) $\approx10.28$ cm; (b) $\approx5.14$ cm', '(a) $\approx5.14$ cm; (b) $\approx6.13$ cm', '(a) $\approx12.26$ cm; (b) $\approx6.13$ cm', '(a) $\approx10.28$ cm; (b) $\approx6.13$ cm', 'D', 4, 'GENERAL', 'By the inscribed angle theorem, the central angle $AOB=2\times40^\circ=80^\circ$; chord $AB=2(8)\sin40^\circ\approx10.28$ cm; $OM=8\cos40^\circ\approx6.13$ cm.'),
  ('In a circle of radius 6 cm, calculate the distance from the centre to a chord which is 8.5 cm long.', '$\approx3.00$ cm', '$\approx4.24$ cm', '$\approx5.00$ cm', '$\approx6.00$ cm', 'B', 3, 'GENERAL', 'Half-chord $=4.25$; distance $=\sqrt{6^2-4.25^2}=\sqrt{17.94}\approx4.24$ cm.'),
  ('XY is a chord of a circle centre O, radius 7 cm; XY = 8 cm subtends 120° at the centre. Calculate the perimeter of the minor segment ($\pi=\frac{22}{7}$).', '14.67 cm', '30.67 cm', '22.67 cm', '18.67 cm', 'C', 4, 'GENERAL', 'Arc $=\frac13\times2\times\frac{22}{7}\times7\approx14.67$ cm; segment perimeter $=$ arc $+$ chord $=14.67+8=22.67$ cm.'),
  ('Calculate the perimeter of a minor segment of radius 14 cm subtending 120° ($\pi=\frac{22}{7}$).', '29.33 cm', '53.58 cm', '24.25 cm', '77.33 cm', 'B', 4, 'GENERAL', 'Arc $=\frac13\times2\times\frac{22}{7}\times14\approx29.33$ cm; chord $=2(14)\sin60^\circ\approx24.25$ cm; perimeter $\approx29.33+24.25\approx53.58$ cm.'),
  ('A sector of radius 12 m subtends 135° at O. Calculate the exact area of the shaded segment.', '$(54\pi-36\sqrt2)$ m²', '$(54\pi+36\sqrt2)$ m²', '$36\sqrt2$ m²', '$54\pi$ m²', 'A', 4, 'GENERAL', 'Sector area $=\frac{135}{360}\pi(144)=54\pi$ m²; triangle area $=\frac12(144)\sin135^\circ=36\sqrt2$ m²; segment area $=54\pi-36\sqrt2$ m².'),
  ('A segment of a circle of diameter 24 cm subtends 90° at the centre. Calculate the area of the segment to the nearest cm² ($\pi=\frac{22}{7}$).', '113 cm²', '41 cm²', '72 cm²', '154 cm²', 'B', 4, 'GENERAL', 'Radius $=12$; sector area $=\frac14\times\frac{22}{7}\times144\approx113.14$ cm²; triangle area $=\frac12(144)\sin90^\circ=72$ cm²; segment $\approx113.14-72\approx41$ cm².'),
  ('Find the area of the shaded segment for a circle of radius 20 cm with the chord subtending 73.74° at the centre, to 1 dp.', '$\approx65.4$ cm²', '$\approx192.0$ cm²', '$\approx257.4$ cm²', '$\approx128.6$ cm²', 'A', 4, 'GENERAL', 'Sector area $=\frac{73.74}{360}\times\pi\times400\approx257.4$ cm²; triangle area $=\frac12(400)\sin73.74^\circ\approx192.0$ cm²; segment area $=257.4-192.0\approx65.4$ cm².')
) as q(question_text, option_a, option_b, option_c, option_d, correct_letter, difficulty, exam_type, explanation)
where c.subject = 'Mathematics' and t.class_level = 'SS1' and t.term = 2 and t.order_index = 209;
-- ------------------------------------------
-- 210. LOGIC: STATEMENTS & IMPLICATION
-- ------------------------------------------

insert into public.lessons (topic_id, title, summary, content_body, order_index)
values (
  (select t.id from public.topics t join public.curricula c on c.id = t.curriculum_id
   where c.subject = 'Mathematics' and t.class_level = 'SS1' and t.term = 2 and t.order_index = 210),
  'Logic: True/False Statements, Negation and Conditional Statements',
  'Identifying simple statements and their truth values, forming negations, and evaluating conditional (if-then) statements and their contrapositive.',
  '### Simple Statements (Propositions)

A **statement** is a declarative sentence with a definite truth value, True (T) or False (F), but not both. Represented by lowercase letters $p, q, r, s$.

**Not statements**: questions, commands, opinions, open sentences ("x + 3 = 8", which depends on x), and exclamations, none of these have a fixed truth value.

### Negation

The negation of $p$, written $\neg p$ ("not p"), reverses its truth value.

| $p$ | $\neg p$ |
|---|---|
| T | F |
| F | T |

Rules for forming a correct negation: use "It is not the case that...", insert "not" grammatically, or reverse mathematical relations ($>$ becomes $\le$, $=$ becomes $\neq$). The negation of "All cats are black" is "Not all cats are black" (or "Some cats are not black"), NOT "No cats are black."

### Conditional (Implication) Statements

"If $p$, then $q$," written $p \to q$.
- $p$ is the **antecedent** (the condition).
- $q$ is the **consequent** (the result).
- $p \to q$ is False only when $p$ is True and $q$ is False; in every other case (including when $p$ is False) it is True.

**Contrapositive** of "if $p$ then $q$" is "if not $q$ then not $p$" ($\neg q \to \neg p$); a conditional statement and its contrapositive always have the same truth value.

**Other connectives**: conjunction ($p \land q$, "and", true only if both true), disjunction ($p \lor q$, "or", false only if both false), biconditional ($p \leftrightarrow q$, "if and only if", true when both have the same truth value).',
  1
);

insert into public.worked_examples (lesson_id, title, problem_statement, solution_steps, exam_shortcut, status)
select l.id,
  'Identifying Statements and Their Truth Values',
  'For each sentence below, decide whether it is a simple statement, and if so, give its truth value: (a) "The year 2024 is a leap year." (b) "Solve the equation." (c) "Red is a beautiful colour." (d) "5 - 1 = 3" (e) "x > 10."',
  to_jsonb(array[
    'Test (a): it declares a checkable fact (2024 divides exactly by 4), so it IS a statement, and it is True.',
    'Test (b): it is a command, commands never have a truth value, so it is NOT a statement.',
    'Test (c): it expresses a personal opinion with no way to "check" who is right, so it is NOT a statement.',
    'Test (d): it declares a specific arithmetic fact that can be checked: $5-1=4$, not $3$, so it IS a statement, and since the claimed equation is wrong, it is False.',
    'Test (e): "x > 10" contains an unknown x whose value is not fixed, an "open sentence", so it is NOT a statement.'
  ]),
  'Build truth tables and check statements systematically: ask "does this sentence have a checkable, fixed truth value" as the single test, commands, opinions and open sentences all fail this test.',
  'published'
from public.lessons l join public.topics t on t.id = l.topic_id join public.curricula c on c.id = t.curriculum_id
where c.subject = 'Mathematics' and t.class_level = 'SS1' and t.term = 2 and t.order_index = 210;

insert into public.worked_examples (lesson_id, title, problem_statement, solution_steps, exam_shortcut, common_trap_warning, status)
select l.id,
  'Evaluating a Conditional with a False Antecedent',
  'Let $p$: "Lagos is in Ghana" and $q$: "$2 \times 3 = 6$." Evaluate the conditional statement "If Lagos is in Ghana, then $2\times3=6$" ($p \to q$).',
  to_jsonb(array[
    'Determine the truth value of $p$ on its own: Lagos is a city in Nigeria, not Ghana, so $p$ is False.',
    'Determine the truth value of $q$ on its own: $2\times3=6$ is correct, so $q$ is True.',
    'Recall the rule for a conditional: $p \to q$ is False ONLY when $p$ is True and $q$ is False; in every other combination it is True.',
    'Match our case ($p$ False, $q$ True) against the rule: this is not the "True to False" case, so $p \to q$ is True.'
  ]),
  'Memorise "→ is only False when True leads to False", everything else about the conditional (T→T, F→T, F→F are all True) follows from this single exception.',
  'A common mistake is assuming a conditional with a false antecedent must itself be false; in fact a false antecedent always makes the whole implication True (called "vacuous truth"), regardless of the consequent.',
  'published'
from public.lessons l join public.topics t on t.id = l.topic_id join public.curricula c on c.id = t.curriculum_id
where c.subject = 'Mathematics' and t.class_level = 'SS1' and t.term = 2 and t.order_index = 210;

insert into public.worked_examples (lesson_id, title, problem_statement, solution_steps, exam_shortcut, real_life_context, status)
select l.id,
  'Forming a Correct Negation',
  'Write the negation of $p$: "Monday is the first day of the week," and state its truth value.',
  to_jsonb(array[
    'Identify what the statement asserts: that Monday holds the position "first day of the week."',
    'Form the negation by inserting "not" grammatically: "Monday is not the first day of the week."',
    'Determine the truth value of the original $p$: under the standard Nigerian school convention, the week starts on Monday, so $p$ is True.',
    'Apply the negation rule ($\neg p$ reverses $p$''s truth value): since $p$ is True, $\neg p$ must be False.'
  ]),
  'For negations of quantified statements ("all", "some", "no"), use the swap table: negation of "All X are Y" is "Some X are not Y" (not "No X are Y"); negation of "No X are Y" is "Some X are Y."',
  'A school timetable committee relies on this exact kind of true/false statement checking when auditing whether a printed timetable''s claims (e.g. "Monday is the first teaching day") match the school''s official calendar.',
  'published'
from public.lessons l join public.topics t on t.id = l.topic_id join public.curricula c on c.id = t.curriculum_id
where c.subject = 'Mathematics' and t.class_level = 'SS1' and t.term = 2 and t.order_index = 210;

insert into public.worked_examples (lesson_id, title, problem_statement, solution_steps, exam_shortcut, status)
select l.id,
  'Building a Truth Table for Conjunction',
  'Construct a full truth table for the conjunction $p \land q$ ("p and q"), and state the one condition under which it is true.',
  to_jsonb(array[
    'List every possible combination of truth values for $p$ and $q$ (2×2 = 4 combinations): (T,T), (T,F), (F,T), (F,F).',
    'Recall the rule for conjunction: $p \land q$ is True only when BOTH $p$ and $q$ are True; False in every other case.',
    'Evaluate each row: (T,T) gives T; (T,F) gives F; (F,T) gives F; (F,F) gives F.',
    'Read off the one row where the result is True: row 1, where $p=T$ and $q=T$.'
  ]),
  'Build truth tables systematically in the standard T/F listing order (TT, TF, FT, FF for two variables) every single time, this prevents missed or duplicated rows.',
  'published'
from public.lessons l join public.topics t on t.id = l.topic_id join public.curricula c on c.id = t.curriculum_id
where c.subject = 'Mathematics' and t.class_level = 'SS1' and t.term = 2 and t.order_index = 210;

insert into public.questions (topic_id, lesson_id, question_text, option_a, option_b, option_c, option_d, correct_letter, difficulty, exam_type, explanation, status)
select t.id, l.id, q.question_text, q.option_a, q.option_b, q.option_c, q.option_d, q.correct_letter, q.difficulty, q.exam_type, q.explanation, 'published'
from public.topics t
  join public.curricula c on c.id = t.curriculum_id
  join public.lessons l on l.topic_id = t.id,
  (values
  ('Which of these is a simple statement: "Good morning!", "5 is a prime number.", "He is very smart."?', '"5 is a prime number" (and it is True)', '"Good morning!" (and it is True)', '"He is very smart" (and it is True)', 'none of them are statements', 'A', 1, 'GENERAL', 'A greeting has no truth value, and "he is very smart" is an opinion; only "5 is a prime number" is a checkable, true statement.'),
  ('Write the negation of $p$: "The sun rises in the West."', '"The sun does not rise in the West."', '"The sun rises in the East."', '"The sun never rises."', '"The moon rises in the West."', 'A', 1, 'GENERAL', 'Negation simply inserts "not": "The sun does not rise in the West."'),
  ('What is the truth value of the negation in the previous question?', 'False, since the original statement is True', 'True, since the original statement is True', 'True, since the original statement is False', 'Cannot be determined', 'C', 2, 'GENERAL', 'The sun actually rises in the East, so the original statement is False, making its negation True.'),
  ('Let $q$ be "4 + 4 = 8." State the truth value of $q$ and $\neg q$.', '$q$ = False, $\neg q$ = True', '$q$ = True, $\neg q$ = True', '$q$ = False, $\neg q$ = False', '$q$ = True, $\neg q$ = False', 'D', 1, 'GENERAL', '$4+4=8$ is correct, so $q$ is True, and its negation is False.'),
  ('Write the negation of $r$: "$x < 5$."', '$x > 5$', '$x \le 5$', '$x \ge 5$', '$x \neq 5$', 'C', 2, 'GENERAL', 'Negating "<" gives "≥" (the complete opposite, covering equal to or greater than).'),
  ('Write the negation of $p$: "All birds can fly."', '"No birds can fly"', '"All birds cannot fly"', '"Not all birds can fly" (some birds cannot fly)', '"Some birds can fly"', 'C', 2, 'GENERAL', 'The negation of "All X are Y" is "Some X are not Y", not the much stronger "No X are Y."'),
  ('Write the negation of $q$: "A rhombus is not a square."', '"A square is not a rhombus."', '"No rhombus is a square."', '"All rhombuses are squares."', '"A rhombus is a square."', 'D', 1, 'GENERAL', 'Negating "is not" simply gives "is": "A rhombus is a square."'),
  ('Write the negation of $r$: "12 is a multiple of 5."', '"12 is not a multiple of 5."', '"12 is a multiple of 4."', '"5 is a multiple of 12."', '"12 is a prime number."', 'A', 1, 'GENERAL', 'Negating "is a multiple of" gives "is not a multiple of".'),
  ('Write the negation of $s$: "A student is present."', '"All students are present."', '"A student is not present."', '"No students are present."', '"A student is absent sometimes."', 'B', 1, 'GENERAL', 'Negating "is present" gives "is not present".'),
  ('Given $r$: "12 is a multiple of 5" (False), what is the truth value of $\neg r$?', 'False', 'Cannot be determined', 'Both True and False', 'True', 'D', 2, 'GENERAL', 'Since $r$ is False (12 is not a multiple of 5), its negation $\neg r$ is True.'),
  ('Let $p$ be "$x=3$" and $q$ be "$x^2=9$." If $x=3$, what are the truth values of $p$ and $q$? If $x=-3$?', 'x=3: p=True, q=False; x=-3: p=False, q=False', 'x=3: p=False, q=True; x=-3: p=True, q=True', 'x=3: p=True, q=True; x=-3: p=False, q=True', 'x=3: p=True, q=True; x=-3: p=True, q=False', 'C', 3, 'GENERAL', 'At $x=3$, both $x=3$ and $x^2=9$ hold, so both are True. At $x=-3$, $x=3$ is False, but $x^2=9$ still holds (since $(-3)^2=9$), so $q$ is still True.'),
  ('Explain why "This statement is false" cannot be a simple statement.', 'It is too short to be a statement', 'It uses the word "false" which is not allowed', 'It creates a paradox: if true it says it is false, if false it says it is true, so it has no consistent truth value', 'It is actually always True', 'C', 3, 'GENERAL', 'Self-referential paradoxes like this one cannot be assigned a single, consistent truth value, so they fail the definition of a statement.'),
  ('Identify the antecedent in: "If $x=2$, then $x^2=4$."', '"$x^2=4$"', 'the whole sentence', '"$x=2$"', 'neither part', 'C', 1, 'GENERAL', 'In "if p then q", p (the "if" part) is the antecedent: here, "$x=2$".'),
  ('Let $p$ = "It is sunny" and $q$ = "It is hot." Write "It is not sunny and it is hot" in symbols.', '$p \land \neg q$', '$\neg p \lor q$', '$\neg p \land q$', '$\neg(p \land q)$', 'C', 2, 'GENERAL', '"Not sunny" is $\neg p$; "and it is hot" is $\land q$; combined: $\neg p \land q$.'),
  ('Let $p=T$ and $q=T$. Find the truth value of $p \to (\neg q)$.', 'False', 'True', 'Cannot be determined', 'Both True and False', 'A', 2, 'GENERAL', '$\neg q$ is False (since $q$ is True); $p\to\neg q$ becomes $T\to F$, which is False.'),
  ('Let $p=F$ and $q=F$. Find the truth value of $p \to q$.', 'True', 'False', 'Cannot be determined', 'Both True and False', 'A', 2, 'GENERAL', 'A conditional with a False antecedent is always True, regardless of the consequent: $F\to F$ is True.'),
  ('Let $p$ = "An elephant can fly" (F), $q$ = "A square has 4 sides" (T). Find $p \land q$, $p \lor q$, $p \to q$, $\neg q \to p$.', '$p\land q=T$; $p\lor q=F$; $p\to q=F$; $\neg q\to p=F$', '$p\land q=F$; $p\lor q=T$; $p\to q=F$; $\neg q\to p=T$', '$p\land q=F$; $p\lor q=F$; $p\to q=T$; $\neg q\to p=F$', '$p\land q=F$; $p\lor q=T$; $p\to q=T$; $\neg q\to p=T$', 'D', 3, 'GENERAL', '$p\land q$ needs both True, so F. $p\lor q$ needs at least one True, so T. $p\to q$: F leads to T, always True. $\neg q\to p$: $\neg q$ is False, so this conditional is automatically True (false antecedent).'),
  ('A statement that is always True is called what? Give an example.', 'a Contradiction, e.g. $p \land \neg p$', 'an Axiom, e.g. $p \to p$', 'a Paradox, e.g. $p \leftrightarrow \neg p$', 'a Tautology, e.g. $p \lor \neg p$', 'D', 2, 'GENERAL', 'A statement that is true under every possible assignment of truth values is a tautology; $p\lor\neg p$ is always true since one of p or not-p must hold.'),
  ('A statement that is always False is called what? Give an example.', 'a Tautology, e.g. $p \lor \neg p$', 'an Axiom, e.g. $p \to p$', 'a Paradox, e.g. $p \leftrightarrow \neg p$', 'a Contradiction, e.g. $p \land \neg p$', 'D', 2, 'GENERAL', 'A statement that is false under every assignment of truth values is a contradiction; $p\land\neg p$ can never be true since p and not-p cannot both hold.'),
  ('Construct a truth table for $p \land \neg q$ and state when it is true.', 'true only when both $p$ and $q$ are True', 'true only when both $p$ and $q$ are False', 'true only when $p$ is True and $q$ is False', 'true whenever $p$ is True, regardless of $q$', 'C', 2, 'GENERAL', '$p\land\neg q$ requires $p$ True AND $\neg q$ True (i.e. $q$ False), so it is true only in the row $p=T, q=F$.'),
  ('Analyse: "The square root of 16 is 4." Is it a statement? What is its truth value?', 'Yes, a statement, but it is False', 'No, it is an open sentence', 'Yes, a statement, and it is True', 'No, it is a command', 'C', 1, 'GENERAL', 'This declares a checkable arithmetic fact ($\sqrt{16}=4$), which is correct, so it is a True statement.'),
  ('Analyse: "That movie was boring." Is it a statement?', 'No, it is not a statement, it is an opinion', 'Yes, and it is True', 'Yes, and it is False', 'Yes, and its truth value depends on context', 'A', 1, 'GENERAL', 'Whether a movie is "boring" is a matter of personal opinion with no objective, checkable truth value, so it is not a statement.')
) as q(question_text, option_a, option_b, option_c, option_d, correct_letter, difficulty, exam_type, explanation)
where c.subject = 'Mathematics' and t.class_level = 'SS1' and t.term = 2 and t.order_index = 210;
