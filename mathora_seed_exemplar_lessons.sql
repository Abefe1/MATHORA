-- ==========================================
-- MATHORA — Exemplar Verified Lessons (Stage 2 demonstration batch)
-- Run after mathora_seed_topics_ss1_ss2_ss3.sql + mathora_schema_diagrams_patch.sql
-- + mathora_schema_content_pipeline_patch.sql (the `status` column this
-- file sets on every worked_examples/questions row doesn't exist until
-- that patch runs). Full order from a bare schema:
--   mathora_schema.sql
--   mathora_schema_auth_patch.sql
--   mathora_schema_topics_term_patch.sql
--   mathora_schema_content_pipeline_patch.sql
--   mathora_schema_diagrams_patch.sql
--   mathora_seed_topics_ss1_ss2_ss3.sql
--   mathora_seed_exemplar_lessons.sql (this file)
--
-- Six topics, hand-authored and hand-checked (not run through
-- content-worker's LLM pipeline), covering five of the eight diagram
-- types end-to-end: venn_diagram, triangle, coordinate_plane,
-- bar_chart, pie_chart, circle. This is NOT the full Stage 2 batch —
-- it's a small, verified slice that (a) gives students real content
-- on these topics today, (b) proves the diagram_type/diagram_data
-- contract end-to-end against the actual renderer components, and
-- (c) doubles as ground truth to spot-check the automated pipeline's
-- output against once it's run for real.
--
-- Every arithmetic result below was checked by hand:
--   Venn: |R∪B| = 28+24-10 = 42; neither = 50-42 = 8.
--   Ladder: 5-12-13 Pythagorean triple, height = sqrt(13^2-5^2) = 12,
--     angle = arccos(5/13) ≈ 67.4°.
--   Gradient: (50-90)/(5-1) = -10; y = -10x + 100; at x=8, y=20.
--   Pie chart: 1500+2000+1000+500 = 5000; each category's degrees =
--     (amount/5000)*360, summing to exactly 360°.
--   Circle theorem: angle at centre = 2 * angle at circumference = 140°.
--   Bar chart: 4+7+6+3 = 20 (matches the stated survey size); mode of
--     the football-goals question = 2 goals (4 matches, the highest
--     frequency).
-- ==========================================

-- ------------------------------------------
-- 1. VENN DIAGRAMS — SS1 Mathematics, Term 2
-- ------------------------------------------

with lesson as (
  insert into public.lessons (topic_id, title, summary, content_body, order_index)
  values (
    (select t.id from public.topics t join public.curricula c on c.id = t.curriculum_id
     where c.subject = 'Mathematics' and t.class_level = 'SS1' and t.term = 2 and t.order_index = 206),
    'Venn Diagrams: Two-Set Problems',
    'Using Venn diagrams to solve real survey-style problems involving two overlapping sets.',
    'A Venn diagram represents sets as overlapping circles inside a rectangle (the universal set, $\mathcal{U}$). For two sets $A$ and $B$: $n(A \cup B) = n(A) + n(B) - n(A \cap B)$, and the number outside both circles is $n(\mathcal{U}) - n(A \cup B)$.',
    1
  )
  returning id
)
insert into public.worked_examples (lesson_id, title, problem_statement, solution_steps, real_life_context, diagram_type, diagram_data, status)
select id,
  'Market Survey: Rice and Beans Traders',
  'In a survey of 50 traders in a market, 28 sell rice, 24 sell beans, and 10 sell both rice and beans. (a) How many traders sell only rice? (b) How many sell only beans? (c) How many sell neither rice nor beans?',
  to_jsonb(array[
    'Let $R$ = the set of traders selling rice, $B$ = the set of traders selling beans. We are given $n(R) = 28$, $n(B) = 24$, $n(R \cap B) = 10$, and the total surveyed $n(\mathcal{U}) = 50$.',
    'Traders selling only rice (not beans) $= n(R) - n(R \cap B) = 28 - 10 = 18$.',
    'Traders selling only beans (not rice) $= n(B) - n(R \cap B) = 24 - 10 = 14$.',
    'Traders selling at least one of the two: $n(R \cup B) = n(R) + n(B) - n(R \cap B) = 28 + 24 - 10 = 42$.',
    'Traders selling neither $= n(\mathcal{U}) - n(R \cup B) = 50 - 42 = 8$.'
  ]),
  'This is exactly how a market association or local government would estimate stall diversification from a physical survey sheet — the same union/intersection method applies whether you''re counting traders, students taking two subjects, or households owning two types of livestock.',
  'venn_diagram',
  '{"setA": {"label": "Rice (28)"}, "setB": {"label": "Beans (24)"}, "universalLabel": "50 Traders Surveyed"}'::jsonb,
  'published'
from lesson;

insert into public.questions (topic_id, question_text, option_a, option_b, option_c, option_d, correct_letter, difficulty, exam_type, explanation, exam_shortcut, diagram_type, diagram_data, status)
select t.id,
  'In a market survey of 60 traders, 35 sell tomatoes, 30 sell pepper, and 15 sell both. How many traders sell neither?',
  '5', '10', '15', '20', 'B', 2, 'WAEC',
  '$n(T \cup P) = 35 + 30 - 15 = 50$. Traders selling neither $= 60 - 50 = 10$.',
  'For two-set "neither" problems: neither = total - (sum of both sets - overlap). Compute the overlap subtraction first.',
  'venn_diagram',
  '{"setA": {"label": "Tomatoes (35)"}, "setB": {"label": "Pepper (30)"}, "universalLabel": "60 Traders Surveyed"}'::jsonb,
  'published'
from public.topics t join public.curricula c on c.id = t.curriculum_id
where c.subject = 'Mathematics' and t.class_level = 'SS1' and t.term = 2 and t.order_index = 206;

insert into public.questions (topic_id, question_text, option_a, option_b, option_c, option_d, correct_letter, difficulty, exam_type, explanation, exam_shortcut, status)
select t.id,
  'Using the same survey (35 sell tomatoes, 30 sell pepper, 15 sell both, out of 60), how many traders sell only pepper?',
  '10', '15', '20', '25', 'B', 2, 'WAEC',
  'Only pepper $= n(P) - n(T \cap P) = 30 - 15 = 15$.',
  '',
  'published'
from public.topics t join public.curricula c on c.id = t.curriculum_id
where c.subject = 'Mathematics' and t.class_level = 'SS1' and t.term = 2 and t.order_index = 206;

-- ------------------------------------------
-- 2. TRIGONOMETRIC RATIOS — SS1 Mathematics, Term 2
-- ------------------------------------------

with lesson as (
  insert into public.lessons (topic_id, title, summary, content_body, order_index)
  values (
    (select t.id from public.topics t join public.curricula c on c.id = t.curriculum_id
     where c.subject = 'Mathematics' and t.class_level = 'SS1' and t.term = 2 and t.order_index = 208),
    'Trigonometric Ratios in Right-Angled Triangles',
    'Using sine, cosine and tangent to find unknown sides and angles in right-angled triangles.',
    'For a right-angled triangle with an angle $\theta$: $\sin\theta = \frac{\text{opposite}}{\text{hypotenuse}}$, $\cos\theta = \frac{\text{adjacent}}{\text{hypotenuse}}$, $\tan\theta = \frac{\text{opposite}}{\text{adjacent}}$.',
    1
  )
  returning id
)
insert into public.worked_examples (lesson_id, title, problem_statement, solution_steps, real_life_context, diagram_type, diagram_data, status)
select id,
  'The Leaning Ladder',
  'A ladder 13 m long leans against a vertical wall so that its foot is 5 m from the base of the wall. Find (a) the height the ladder reaches up the wall, and (b) the angle the ladder makes with the ground.',
  to_jsonb(array[
    'Sketch the situation as a right-angled triangle: the wall is vertical, the ground is horizontal, and the ladder is the hypotenuse. The right angle is where the wall meets the ground. Hypotenuse $= 13$ m, base (foot from wall) $= 5$ m.',
    'By Pythagoras'' theorem, height$^2$ = hypotenuse$^2$ $-$ base$^2$ = $13^2 - 5^2 = 169 - 25 = 144$.',
    'Height $= \sqrt{144} = 12$ m. So the ladder reaches 12 m up the wall.',
    'Let $\theta$ be the angle between the ladder and the ground. The side adjacent to $\theta$ is the 5 m base, and the hypotenuse is 13 m, so $\cos\theta = \frac{5}{13}$.',
    '$\theta = \cos^{-1}\left(\frac{5}{13}\right) \approx 67.4^{\circ}$.'
  ]),
  'This is the standard safety calculation a technician or fire service uses before placing an extension ladder — the foot-to-wall distance and the ladder''s rated length are known, and the reachable height and safe leaning angle are worked out exactly this way.',
  'triangle',
  '{"vertices": [{"label": "F", "x": 5, "y": 0}, {"label": "B", "x": 0, "y": 0}, {"label": "T", "x": 0, "y": 12}], "sideLabels": [{"from": "F", "to": "B", "label": "5 m"}, {"from": "B", "to": "T", "label": "12 m"}, {"from": "T", "to": "F", "label": "13 m (ladder)"}], "angleLabels": [{"vertex": "F", "label": "θ ≈ 67.4°"}], "rightAngleAt": "B"}'::jsonb,
  'published'
from lesson;

insert into public.questions (topic_id, question_text, option_a, option_b, option_c, option_d, correct_letter, difficulty, exam_type, explanation, exam_shortcut, diagram_type, diagram_data, status)
select t.id,
  'A ladder 17 m long leans against a wall with its foot 8 m from the wall. Calculate the height the ladder reaches on the wall.',
  '15 m', '14 m', '16 m', '13 m', 'A', 3, 'WAEC',
  'By Pythagoras: height $= \sqrt{17^2 - 8^2} = \sqrt{289 - 64} = \sqrt{225} = 15$ m.',
  'Recognize the 8-15-17 Pythagorean triple to skip the full calculation.',
  'triangle',
  '{"vertices": [{"label": "F", "x": 8, "y": 0}, {"label": "B", "x": 0, "y": 0}, {"label": "T", "x": 0, "y": 15}], "sideLabels": [{"from": "F", "to": "B", "label": "8 m"}, {"from": "T", "to": "F", "label": "17 m (ladder)"}], "rightAngleAt": "B"}'::jsonb,
  'published'
from public.topics t join public.curricula c on c.id = t.curriculum_id
where c.subject = 'Mathematics' and t.class_level = 'SS1' and t.term = 2 and t.order_index = 208;

-- ------------------------------------------
-- 3. STRAIGHT LINE GRAPHS: GRADIENT — SS2 Mathematics, Term 1
-- ------------------------------------------

with lesson as (
  insert into public.lessons (topic_id, title, summary, content_body, order_index)
  values (
    (select t.id from public.topics t join public.curricula c on c.id = t.curriculum_id
     where c.subject = 'Mathematics' and t.class_level = 'SS2' and t.term = 1 and t.order_index = 108),
    'Gradient of a Straight Line',
    'Finding the gradient of a line through two points, and using it to form the equation of the line.',
    'The gradient of a line through $(x_1, y_1)$ and $(x_2, y_2)$ is $m = \frac{y_2 - y_1}{x_2 - x_1}$. The equation of the line is $y - y_1 = m(x - x_1)$.',
    1
  )
  returning id
)
insert into public.worked_examples (lesson_id, title, problem_statement, solution_steps, real_life_context, diagram_type, diagram_data, status)
select id,
  'A Trader''s Depleting Stock',
  'A rice trader had 90 bags in stock at the end of week 1, and 50 bags left at the end of week 5. Assuming the stock decreases at a constant weekly rate: (a) find the weekly rate of depletion, (b) find the equation relating bags remaining $y$ to week number $x$, (c) predict how many bags remain at week 8.',
  to_jsonb(array[
    'Let $x$ = week number and $y$ = bags remaining. We have two points: $(1, 90)$ and $(5, 50)$.',
    'Gradient $m = \frac{y_2 - y_1}{x_2 - x_1} = \frac{50 - 90}{5 - 1} = \frac{-40}{4} = -10$. The negative sign means the stock is decreasing — by 10 bags every week.',
    'Using $y - y_1 = m(x - x_1)$ with $(x_1, y_1) = (1, 90)$: $y - 90 = -10(x - 1)$.',
    'Expanding: $y = -10x + 10 + 90 = -10x + 100$.',
    'At week 8: $y = -10(8) + 100 = -80 + 100 = 20$ bags remaining.'
  ]),
  'This is exactly how a shop owner or supply manager tracks a depletion rate from two stock-count dates to forecast when a restock is needed, without having to count the stock every single day.',
  'coordinate_plane',
  '{"xRange": [0, 10], "yRange": [0, 100], "points": [{"x": 1, "y": 90, "label": "Week 1"}, {"x": 5, "y": 50, "label": "Week 5"}, {"x": 8, "y": 20, "label": "Week 8"}], "lines": [{"from": {"x": 1, "y": 90}, "to": {"x": 8, "y": 20}, "label": "y = -10x + 100"}]}'::jsonb,
  'published'
from lesson;

insert into public.questions (topic_id, question_text, option_a, option_b, option_c, option_d, correct_letter, difficulty, exam_type, explanation, exam_shortcut, diagram_type, diagram_data, status)
select t.id,
  'Find the gradient of the line joining the points $(2, 3)$ and $(6, 11)$.',
  '2', '4', '1/2', '-2', 'A', 2, 'WAEC',
  '$m = \frac{11 - 3}{6 - 2} = \frac{8}{4} = 2$.',
  '',
  'coordinate_plane',
  '{"xRange": [0, 8], "yRange": [0, 12], "points": [{"x": 2, "y": 3, "label": "(2,3)"}, {"x": 6, "y": 11, "label": "(6,11)"}], "lines": [{"from": {"x": 2, "y": 3}, "to": {"x": 6, "y": 11}}]}'::jsonb,
  'published'
from public.topics t join public.curricula c on c.id = t.curriculum_id
where c.subject = 'Mathematics' and t.class_level = 'SS2' and t.term = 1 and t.order_index = 108;

-- ------------------------------------------
-- 4. STATISTICAL GRAPHS — SS1 Mathematics, Term 3
-- Two worked examples: the syllabus text itself names "bar chart, pie
-- chart and histogram" together, so both fit naturally on one topic.
-- ------------------------------------------

with lesson as (
  insert into public.lessons (topic_id, title, summary, content_body, order_index)
  values (
    (select t.id from public.topics t join public.curricula c on c.id = t.curriculum_id
     where c.subject = 'Mathematics' and t.class_level = 'SS1' and t.term = 3 and t.order_index = 313),
    'Statistical Graphs: Bar Charts and Pie Charts',
    'Representing frequency data as a bar chart, and proportional data as a pie chart.',
    'A bar chart shows frequencies as bars of equal width and height proportional to frequency. A pie chart divides a circle ($360^{\circ}$ total) into sectors, each sector''s angle proportional to its share of the total: $\text{angle} = \frac{\text{category value}}{\text{total}} \times 360^{\circ}$.',
    1
  )
  returning id
),
worked_example_bar_chart as (
  insert into public.worked_examples (lesson_id, title, problem_statement, solution_steps, real_life_context, diagram_type, diagram_data, status)
  select id,
    'Number of Siblings (Bar Chart)',
    'A survey of 20 SS1 students recorded their number of siblings: 4 students have 0 siblings, 7 have 1 sibling, 6 have 2 siblings, and 3 have 3 siblings. Represent this data on a bar chart.',
    to_jsonb(array[
      'List the categories (number of siblings) and their frequencies: $0 \to 4$, $1 \to 7$, $2 \to 6$, $3 \to 3$.',
      'Check the total matches the students surveyed: $4 + 7 + 6 + 3 = 20$. ✓',
      'Choose a vertical scale large enough for the highest frequency (7) — e.g. 0 to 8.',
      'Draw one bar per category, with equal width and equal spacing, each bar''s height equal to its frequency.',
      'Label the horizontal axis "Number of Siblings" and the vertical axis "Number of Students".'
    ]),
    '',
    'bar_chart',
    '{"categories": ["0", "1", "2", "3"], "values": [4, 7, 6, 3], "yLabel": "Number of Students"}'::jsonb,
    'published'
  from lesson
  returning id
)
insert into public.worked_examples (lesson_id, title, problem_statement, solution_steps, real_life_context, diagram_type, diagram_data, status)
select id,
  'Monthly Pocket Money (Pie Chart)',
  'A student''s monthly pocket money of ₦5,000 is spent as follows: Transport ₦1,500, Food ₦2,000, Books ₦1,000, Savings ₦500. Represent this as a pie chart.',
  to_jsonb(array[
    'Find the total: $1500 + 2000 + 1000 + 500 = 5000$ (matches the stated total). ✓',
    'Convert each category to a sector angle: $\text{angle} = \frac{\text{amount}}{5000} \times 360^{\circ}$.',
    'Transport: $\frac{1500}{5000} \times 360^{\circ} = 108^{\circ}$. Food: $\frac{2000}{5000} \times 360^{\circ} = 144^{\circ}$.',
    'Books: $\frac{1000}{5000} \times 360^{\circ} = 72^{\circ}$. Savings: $\frac{500}{5000} \times 360^{\circ} = 36^{\circ}$.',
    'Check the angles sum to a full circle: $108 + 144 + 72 + 36 = 360^{\circ}$. ✓ Draw the circle and mark out each sector by its angle, labeling each with its category and amount.'
  ]),
  'This is the same method a household or a small business uses to visualize a monthly budget breakdown — knowing the naira amounts, converting each to a fraction of the total is the only step that matters, the rest is direct substitution into the angle formula.',
  'pie_chart',
  '{"slices": [{"label": "Transport", "value": 1500}, {"label": "Food", "value": 2000}, {"label": "Books", "value": 1000}, {"label": "Savings", "value": 500}]}'::jsonb,
  'published'
from lesson;

insert into public.questions (topic_id, question_text, option_a, option_b, option_c, option_d, correct_letter, difficulty, exam_type, explanation, exam_shortcut, status)
select t.id,
  'A football team''s goals scored in 10 matches: 0 goals in 2 matches, 1 goal in 3 matches, 2 goals in 4 matches, 3 goals in 1 match. What is the modal number of goals scored?',
  '0', '1', '2', '3', 'C', 2, 'WAEC',
  'The mode is the value with the highest frequency. 2 goals occurred in 4 matches — more than any other value — so the mode is 2.',
  'The mode is just "which value appears most often" — read it straight off the frequency column, no calculation needed.',
  'published'
from public.topics t join public.curricula c on c.id = t.curriculum_id
where c.subject = 'Mathematics' and t.class_level = 'SS1' and t.term = 3 and t.order_index = 313;

-- ------------------------------------------
-- 5. CIRCLE THEOREMS: ANGLE PROPERTIES — SS2 Mathematics, Term 2
-- No real_life_context here deliberately — a pure circle theorem has
-- no natural real-world framing, and the generator prompt explicitly
-- says not to force one onto topics like this.
-- ------------------------------------------

with lesson as (
  insert into public.lessons (topic_id, title, summary, content_body, order_index)
  values (
    (select t.id from public.topics t join public.curricula c on c.id = t.curriculum_id
     where c.subject = 'Mathematics' and t.class_level = 'SS2' and t.term = 2 and t.order_index = 210),
    'Circle Theorems: Angle at the Centre',
    'The angle subtended by an arc at the centre of a circle is twice the angle subtended by the same arc at the circumference.',
    'For a circle with centre $O$: if an arc $AB$ subtends $\angle ACB$ at a point $C$ on the circumference, and $\angle AOB$ at the centre, then $\angle AOB = 2 \times \angle ACB$, provided $C$ is on the major arc.',
    1
  )
  returning id
)
insert into public.worked_examples (lesson_id, title, problem_statement, solution_steps, diagram_type, diagram_data, status)
select id,
  'Angle at the Centre from the Circumference',
  'In a circle with centre $O$, an arc $AB$ subtends an angle of $70^{\circ}$ at a point $C$ on the circumference. Find the angle $AOB$ subtended by the same arc at the centre.',
  to_jsonb(array[
    'State the theorem: the angle subtended by an arc at the centre of a circle is twice the angle it subtends at any point on the remaining (major) arc of the circumference.',
    'Identify the given angle at the circumference: $\angle ACB = 70^{\circ}$.',
    'Apply the theorem: $\angle AOB = 2 \times \angle ACB = 2 \times 70^{\circ} = 140^{\circ}$.',
    'So the angle at the centre, $\angle AOB$, is $140^{\circ}$.'
  ]),
  'circle',
  '{"centerLabel": "O", "points": [{"label": "A", "angleDegrees": 0}, {"label": "B", "angleDegrees": 140}, {"label": "C", "angleDegrees": 250}], "highlightSector": {"startAngle": 0, "endAngle": 140, "label": "140°"}}'::jsonb,
  'published'
from lesson;

insert into public.questions (topic_id, question_text, option_a, option_b, option_c, option_d, correct_letter, difficulty, exam_type, explanation, exam_shortcut, diagram_type, diagram_data, status)
select t.id,
  'An arc of a circle subtends an angle of $50^{\circ}$ at the circumference. What angle does the same arc subtend at the centre?',
  '25°', '50°', '100°', '200°', 'C', 2, 'WAEC',
  'Angle at centre $= 2 \times$ angle at circumference $= 2 \times 50^{\circ} = 100^{\circ}$.',
  'Centre angle is always double the circumference angle on the same arc — never the other way round.',
  'circle',
  '{"centerLabel": "O", "points": [{"label": "A", "angleDegrees": 0}, {"label": "B", "angleDegrees": 100}, {"label": "C", "angleDegrees": 220}], "highlightSector": {"startAngle": 0, "endAngle": 100, "label": "100°"}}'::jsonb,
  'published'
from public.topics t join public.curricula c on c.id = t.curriculum_id
where c.subject = 'Mathematics' and t.class_level = 'SS2' and t.term = 2 and t.order_index = 210;
