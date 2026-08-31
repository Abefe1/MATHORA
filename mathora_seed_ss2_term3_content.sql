-- ==========================================
-- MATHORA -- SS2 Mathematics, Third Term: Full Lesson Content Seed
-- Populates all 8 Third Term topics (order_index 301-308) with real
-- teaching notes, worked examples, and question-bank questions, sourced
-- from SS1-SS3_MATHEMATICS_CURATED.md's "SS2 Mathematics > Third Term"
-- section (curated notes + Gamified Exercise Bank, Weeks 1-9; Weeks 6
-- and 10 are pure revision weeks with no new exercises and are not
-- separately seeded here since they do not correspond to a distinct
-- topic row).
--
-- Does NOT create any topics or curricula rows -- every topic referenced
-- below (order_index 301 through 308) must already exist. Run this file
-- after, in order, from a bare database:
--   mathora_schema.sql
--   mathora_schema_auth_patch.sql
--   mathora_schema_topics_term_patch.sql
--   mathora_schema_content_pipeline_patch.sql
--   mathora_schema_diagrams_patch.sql
--   mathora_schema_five_option_patch.sql
--   mathora_seed_topics_ss1_ss2_ss3.sql
--
-- Follows the exact CTE pattern from mathora_seed_exemplar_lessons.sql:
-- one `with lesson as (insert into lessons ... returning id)` per topic,
-- feeding a chained `insert into worked_examples select id, ... from lesson`,
-- followed by a bulk `insert into questions ... select topic_ref.tid, v...
-- from (topic lookup) topic_ref, lateral (values ...) v` block per topic,
-- matching mathora_seed_ss1_term3_content.sql's bulk-values convention.
-- Topics are referenced only by subquery lookup on
-- (subject, class_level, term, order_index), never by a hardcoded UUID.
--
-- Mapping (curated Third Term week -> seeded topic order_index):
--   Week 1 (Circle Theorems: tangent properties)                  -> 301
--   Week 2 (Sine Rule & Cosine Rule)                               -> 302
--   Week 3 (Bearing, Distances, Elevation & Depression)            -> 303
--   Week 4 (Class boundaries, class marks, cumulative frequency)   -> 304
--   Week 5 (Cumulative Frequency Curve / Ogive)                    -> 305
--   Week 7 (Mean, Median & Mode of Grouped Data)                   -> 306
--   Week 8 (Probability: Introduction)                             -> 307
--   Week 9 (Probability: Addition & Multiplication Rules)          -> 308
--   (Weeks 6 and 10 are half-term/end-of-term revision weeks with no
--   new exercises in the curated source, so they are not mapped here.)
--
-- Every worked example's math was re-derived from the curated source's
-- own "Step 1 / Step 2 / ... / Answer" walkthroughs, and every exercise
-- bank answer was independently recomputed (with a Python check script
-- for every numeric answer, given how easy probability/statistics
-- arithmetic is to get subtly wrong). The following genuine errors were
-- found in the curated source and corrected here (not merely copied):
--   1. Topic 302 (Sine/Cosine Rule), Week 2 Q7: the curated source
--      mislabels which angle is "largest" -- the angle opposite the
--      longest side (15 cm) is actually the largest angle (~67.4 deg),
--      not the ~59.5 deg angle it names as largest. Corrected below.
--   2. Topic 302, Week 2 Q8: cosine rule on p=7.5, r=10.2, Q=72 deg
--      gives q ~= 10.63 cm, not the source's stated ~10.24 cm (an
--      arithmetic slip). Corrected below.
--   3. Topic 302, Week 2 Q22(ii): the two base angles were swapped --
--      the angle opposite the 10 cm side is the smaller one (~41.5 deg,
--      not ~83.4 deg) and the angle opposite the 15 cm side is the
--      larger one (~83.5 deg, not ~41.5 deg). Corrected below.
--   4. Topic 304 (Class Boundaries), Week 4 Q6: binning the 20 given
--      ages into width-5 classes from 25 actually gives frequencies
--      6, 6, 5, 3 (summing to 20), not the source's stated 6, 6, 6, 2
--      (which sums to 20 but misassigns two values). Corrected below.
--   5. Topic 308 (Probability: Addition/Multiplication), Week 9 Q15:
--      of the twelve cards 1-12, the numbers that are even or a
--      perfect square are {1,2,4,6,8,9,10,12}, eight numbers, giving
--      P = 8/12 = 2/3, not the source's stated 7/12. Corrected below.
--   6. Topic 308, Week 9 Q25: picking a red and a black biro without
--      replacement from 4 red/5 blue/6 black must sum BOTH orders
--      (red-then-black plus black-then-red): (4/15)(6/14) +
--      (6/15)(4/14) = 8/35, not the source's stated 4/35, which only
--      counted one order. Corrected below.
-- Two further items are flagged as genuinely under-determined in the
-- source rather than silently invented a clean answer for: Topic 304
-- Week 4 Q10 (the stated conditions have no integer solution; the
-- question is converted below into an equation-setup question rather
-- than a false precise numeric answer) and Q12 (the age range only
-- constrains a class width, not exact frequencies, so it is converted
-- into a class-width/class-count question).
-- ==========================================

-- ==========================================
-- TOPIC 301: CIRCLE THEOREMS -- TANGENT PROPERTIES (Week 1)
-- ==========================================

with lesson as (
  insert into public.lessons (topic_id, title, summary, content_body, order_index)
  values (
    (select t.id from public.topics t join public.curricula c on c.id = t.curriculum_id
     where c.subject = 'Mathematics' and t.class_level = 'SS2' and t.term = 3 and t.order_index = 301),
    'Circle Theorems: Tangent Properties',
    'The three key tangent properties of a circle: tangent-radius perpendicularity, equal tangents from an external point, and the alternate segment theorem.',
    '**Glossary.** A **tangent** is a straight line that touches a circle at exactly one point, called the **point of contact** (think of a ruler resting against the edge of a coin, it touches the coin at just one spot). A **chord** is a straight line joining two points on a circle. The **alternate segment** is the region of the circle on the far side of a chord from a given tangent-chord angle, "alternate" here just means "the other one."

There are three key tangent properties.

**Property 1 (Tangent perpendicular to radius).** A tangent to a circle is always perpendicular to the radius drawn to the point of contact. The moment you see a tangent and a radius meeting at the point of contact, that angle is $90^{\circ}$.

**Property 2 (Equal tangents from an external point).** If $PA$ and $PB$ are two tangents drawn from the same external point $P$ to a circle with centre $O$, then $PA = PB$. In addition, $OP$ bisects both $\angle APB$ (the angle between the two tangents) and $\angle AOB$ (the angle between the two radii to the points of contact).

**Property 3 (Alternate Segment Theorem).** The angle between a tangent and a chord drawn from the point of contact equals the angle subtended by that same chord in the alternate segment (the angle standing on the chord from the far arc, opposite side).

A closely related fact used throughout circle geometry: the **angle in a semicircle** is always $90^{\circ}$. If $AB$ is a diameter and $C$ is any other point on the circle, $\angle ACB = 90^{\circ}$.

These three properties, combined with the angle sum of a triangle ($180^{\circ}$) and Pythagoras'' theorem, are enough to solve almost every tangent-length or tangent-angle problem in the WAEC syllabus.',
    1
  )
  returning id
),
we1 as (
  insert into public.worked_examples (lesson_id, title, problem_statement, solution_steps, real_life_context, exam_shortcut, diagram_type, diagram_data, status)
  select id,
    'Radius from Two Tangents (Pythagoras)',
    'Two tangents PA and PB are drawn from an external point P to a circle with centre O. If PA = 12 cm and OP = 13 cm, find the radius of the circle.',
    to_jsonb(array[
      'Since PA is a tangent and OA is the radius drawn to the point of contact A, Property 1 gives $\angle OAP = 90^{\circ}$. So triangle $OAP$ is right-angled at $A$.',
      'The hypotenuse of this right triangle is $OP$ (the line from the centre to the external point), so Pythagoras'' theorem gives $OP^2 = OA^2 + PA^2$.',
      'Substitute the known values: $13^2 = r^2 + 12^2$, so $169 = r^2 + 144$.',
      'Solve for $r^2$: $r^2 = 169 - 144 = 25$.',
      'Take the square root: $r = \sqrt{25} = 5$.'
    ]),
    'This is exactly the calculation an engineer uses when running a guy-wire from a fixed anchor point outside a circular water tank or a communications mast''s circular fenced base to the point where the wire just grazes the tank''s edge, the anchor distance and wire length are known, and the tank''s radius is what needs to be found.',
    'Recognise the 5-12-13 Pythagorean triple: once you see 12 and 13, the third side is 5 without needing a calculator.',
    'triangle',
    '{"vertices": [{"label": "A", "x": 0, "y": 0}, {"label": "P", "x": 12, "y": 0}, {"label": "O", "x": 0, "y": 5}], "sideLabels": [{"from": "A", "to": "P", "label": "PA = 12 cm"}, {"from": "O", "to": "P", "label": "OP = 13 cm"}, {"from": "O", "to": "A", "label": "r = 5 cm"}], "rightAngleAt": "A"}'::jsonb,
    'published'
  from lesson
  returning id
),
we2 as (
  insert into public.worked_examples (lesson_id, title, problem_statement, solution_steps, exam_shortcut, common_trap_warning, diagram_type, diagram_data, status)
  select lesson.id,
    'Angle in a Semicircle',
    'In a circle with centre O, AB is a diameter and C is a point on the circle with angle CAB = 35 degrees. Find angle CBA.',
    to_jsonb(array[
      'Because $AB$ is a diameter, the angle it subtends at any other point $C$ on the circle is always a right angle, so $\angle ACB = 90^{\circ}$.',
      'The angles of triangle $ABC$ must sum to $180^{\circ}$: $\angle CAB + \angle CBA + \angle ACB = 180^{\circ}$.',
      'Substitute the known angles: $35^{\circ} + \angle CBA + 90^{\circ} = 180^{\circ}$.',
      'Solve for $\angle CBA$: $\angle CBA = 180^{\circ} - 90^{\circ} - 35^{\circ} = 55^{\circ}$.'
    ]),
    'Any time a chord is stated (or shown) to be a diameter, immediately write $90^{\circ}$ at the circumference angle before doing anything else, it usually unlocks the rest of the triangle by angle sum.',
    'Do not assume a chord is a diameter unless the question says so explicitly (or it visibly passes through the centre), the semicircle angle only applies to diameters, not to any chord.',
    'triangle',
    '{"vertices": [{"label": "A", "x": 0, "y": 0}, {"label": "B", "x": 10, "y": 0}, {"label": "C", "x": 2.9, "y": 4.1}], "sideLabels": [{"from": "A", "to": "B", "label": "diameter"}], "angleLabels": [{"vertex": "A", "label": "35°"}, {"vertex": "B", "label": "55°"}], "rightAngleAt": "C"}'::jsonb,
    'published'
  from lesson
  returning id
),
we3 as (
  insert into public.worked_examples (lesson_id, title, problem_statement, solution_steps, exam_shortcut, status)
  select lesson.id,
    'Alternate Segment Theorem',
    'A tangent PT touches a circle at T. A chord TA makes an angle of 40 degrees with the tangent. Find the angle subtended by the chord at a point B on the major arc.',
    to_jsonb(array[
      'The angle $\angle PTA$ is the angle between the tangent $PT$ and the chord $TA$ at the point of contact $T$, and it is given as $40^{\circ}$.',
      'Point $B$ lies on the major arc, on the opposite side of chord $TA$ from the tangent-side angle $\angle PTA$, this is exactly the "alternate segment" referred to in the theorem.',
      'By the Alternate Segment Theorem, the tangent-chord angle equals the angle subtended by the same chord in the alternate segment, so $\angle TBA = \angle PTA$.',
      'Therefore $\angle TBA = 40^{\circ}$.'
    ]),
    'Alternate segment means same chord, opposite side: the tangent-chord angle always equals the inscribed angle standing on the same chord but on the far side of it, never the near side.',
    'published'
  from lesson
  returning id
)
insert into public.worked_examples (lesson_id, title, problem_statement, solution_steps, real_life_context, exam_shortcut, diagram_type, diagram_data, status)
select lesson.id,
  'Distance from Centre using a Tangent',
  'Two tangents TA and TB are drawn to a circle from an external point T, with TA = 24 cm and the radius = 7 cm. Find the distance from T to the centre O.',
  to_jsonb(array[
    'Since $TA$ is tangent at $A$, Property 1 gives $\angle OAT = 90^{\circ}$, so triangle $OAT$ is right-angled at $A$.',
    'Apply Pythagoras'' theorem: $OT^2 = OA^2 + TA^2 = 7^2 + 24^2 = 49 + 576 = 625$.',
    'Take the square root: $OT = \sqrt{625} = 25$.',
    'Notice this is a 7-24-25 Pythagorean triple, recognising common triples (3-4-5, 5-12-13, 7-24-25, 8-15-17) saves time on tangent-length questions.'
  ]),
  'A satellite-dish installer anchoring a support strut from a point on the ground to the rim of a circular dish mount uses this exact right-triangle relationship: strut length and dish radius are known, and the mount-to-anchor distance is what gets calculated before cutting the strut.',
  'Learn the Pythagorean triples cold: 3-4-5, 5-12-13, 7-24-25, 8-15-17 and their multiples appear constantly in tangent-length questions.',
  'triangle',
  '{"vertices": [{"label": "A", "x": 0, "y": 0}, {"label": "T", "x": 24, "y": 0}, {"label": "O", "x": 0, "y": 7}], "sideLabels": [{"from": "A", "to": "T", "label": "TA = 24 cm"}, {"from": "O", "to": "T", "label": "OT = 25 cm"}, {"from": "O", "to": "A", "label": "r = 7 cm"}], "rightAngleAt": "A"}'::jsonb,
  'published'
from lesson;

insert into public.questions (topic_id, question_text, option_a, option_b, option_c, option_d, option_e, correct_letter, difficulty, exam_type, explanation, exam_shortcut, status)
select topic_ref.tid, v.question_text, v.option_a, v.option_b, v.option_c, v.option_d, v.option_e, v.correct_letter, v.difficulty, v.exam_type, v.explanation, v.exam_shortcut, 'published'
from (select t.id as tid from public.topics t join public.curricula c on c.id = t.curriculum_id
      where c.subject = 'Mathematics' and t.class_level = 'SS2' and t.term = 3 and t.order_index = 301) topic_ref,
lateral (values
  ('What is the relationship between a tangent to a circle and the radius drawn to the point of contact?', 'They are perpendicular (meet at 90 degrees)', 'They are parallel', 'They are equal in length', 'They bisect each other', null::text, 'A', 1, 'GENERAL'::exam_type, 'A tangent always meets the radius drawn to the point of contact at a right angle, this is Property 1 of tangents, the most-used fact in tangent problems.', 'Mark a 90 degree box at every tangent-radius meeting point before doing anything else.'),
  ('Two tangents PA and PB are drawn from an external point P to a circle with centre O. If PA = 12 cm and OP = 13 cm, find the radius.', '25 cm', '5 cm', '17 cm', '1 cm', null, 'B', 2, 'GENERAL', 'Triangle OAP is right-angled at A, so $r^2 = OP^2 - PA^2 = 13^2 - 12^2 = 169 - 144 = 25$, giving $r = 5$ cm.', 'Recognise the 5-12-13 Pythagorean triple to skip the calculation.'),
  ('AB is a diameter of a circle. Point C is on the circle with angle BAC = 42 degrees. Find angle BCA and angle ABC.', 'BCA = 90°, ABC = 48°', 'BCA = 90°, ABC = 42°', 'BCA = 48°, ABC = 90°', 'BCA = 42°, ABC = 48°', null, 'A', 2, 'GENERAL', 'AB is a diameter, so angle BCA = 90 degrees by the semicircle theorem. Then angle ABC = 180 - 90 - 42 = 48 degrees by the angle sum of a triangle.', 'A diameter always gives a free 90 degree angle at the circumference.'),
  ('A tangent to a circle makes an angle of 55 degrees with a chord drawn from the point of contact. Find the angle subtended by the chord in the alternate segment.', '27.5°', '35°', '55°', '110°', null, 'C', 2, 'GENERAL', 'By the Alternate Segment Theorem, the tangent-chord angle equals the angle subtended by the same chord in the alternate segment: 55 degrees.', 'Same chord, opposite side, copy the angle straight across.'),
  ('A tangent PT touches a circle at T. A chord TA makes an angle of 40 degrees with the tangent. Find the angle subtended by the chord at a point B on the major arc.', '20°', '50°', '80°', '40°', null, 'D', 2, 'GENERAL', 'By the Alternate Segment Theorem, angle TBA = angle PTA = 40 degrees.', 'Alternate segment theorem: tangent-chord angle equals the inscribed angle in the alternate segment.'),
  ('In a circle with centre O, diameter PQ = 20 cm. Point R is on the circle such that angle PRQ = 90 degrees and PR = 12 cm. Find RQ.', '14 cm', '16 cm', '18 cm', '10 cm', null, 'B', 2, 'GENERAL', 'Since PQ is a diameter, angle PRQ = 90 degrees (already given, consistent with the semicircle theorem), so by Pythagoras: $RQ = \sqrt{20^2 - 12^2} = \sqrt{400 - 144} = \sqrt{256} = 16$ cm.', 'This is a 12-16-20 triple (a multiple of 3-4-5).'),
  ('A circle has radius 4 cm. From a point 10 cm from the centre, tangents are drawn to the circle. Calculate the length of each tangent.', '9.17 cm', '10.77 cm', '6.00 cm', '8.49 cm', null, 'A', 3, 'GENERAL', 'The radius is perpendicular to the tangent at the point of contact, so by Pythagoras the tangent length is $\sqrt{10^2 - 4^2} = \sqrt{84} \approx 9.17$ cm.', 'Set up the right triangle with the external-point distance as the hypotenuse before computing.'),
  ('In a circle, OA = OB = OP are all radii, and P is the vertex where two equal tangent-chord angles x and y meet the diameter at A and B. Which equation correctly proves that angle APB (the angle in a semicircle) equals 90 degrees?', '2x + 2y = 90°, so x + y = 45°', '2x + 2y = 180°, so x + y = 90° = angle APB', 'x + y = 180°, so angle APB = 180°', 'x = y = 90° directly, with no angle sum needed', null, 'B', 3, 'GENERAL', 'Triangles OAP and OBP are isosceles (equal radii), so their base angles are x and y respectively. The angle sum of triangle ABP gives 2x + 2y = 180°, so x + y = 90°, which is exactly angle APB.', 'This is the standard proof that the angle in a semicircle is 90 degrees, built from two isosceles triangles sharing the centre.'),
  ('AB is parallel to CE, TS is a tangent to a circle at A, angle AEC = 5x°, angle ADB = 60°, and angle TAE = x°. Find the value of x.', '10', '12', '15', '20', null, 'C', 4, 'WAEC', 'Using the alternate segment theorem together with the parallel-line angle relationships in the figure, solving the resulting equation gives x = 15 (WAEC 2010 past question, checked against the official mark scheme; reconstructing every intermediate step needs the original figure).', null),
  ('MP is a diameter of a circle, MQ is a straight line, angle NMP = 42°, and NQ is a tangent to the circle at N with angle NQP = x°. Find x.', '42°', '48°', '60°', '84°', null, 'C', 4, 'WAEC', 'Combining the semicircle theorem (angle MNP = 90°, since MP is a diameter) with the tangent-radius and alternate segment relationships in the figure gives x = 60° (WAEC 2014 past question, checked against the official mark scheme).', null),
  ('TU is a tangent to a circle. If angle RVU = 100° and angle URS = 36°, calculate angle STU.', '36°', '44°', '64°', '100°', null, 'B', 4, 'WAEC', 'Applying the alternate segment theorem and the angle relationships around the tangent point in the figure gives angle STU = 44° (WAEC 2012 past question, checked against the official mark scheme).', null),
  ('TS is a tangent to a circle at S, with O the centre. If angle TSP = 21° and angle RQP = 100°, find (i) angle SPR (ii) angle QSR.', '(i) 79°, (ii) 11°', '(i) 69°, (ii) 21°', '(i) 100°, (ii) 21°', '(i) 79°, (ii) 21°', null, 'A', 4, 'WAEC', 'Angle SPR is found from the cyclic-quadrilateral and tangent relationships to be 79°, and angle QSR follows from the alternate segment theorem to be 11° (WAEC 2014 past question, checked against the official mark scheme).', null),
  ('XYT is a tangent to a circle centre O, radius 5 cm. YT = 12 cm and angle ZYT = 58°. What is the length of OT?', '12 cm', '13 cm', '17 cm', '5 cm', null, 'B', 2, 'GENERAL', 'Since XYT is tangent at Y, angle OYT = 90°, so by Pythagoras: $OT = \sqrt{OY^2 + YT^2} = \sqrt{5^2 + 12^2} = \sqrt{169} = 13$ cm. This is a 5-12-13 triple, angle ZYT = 58° is extra information not needed for this part.', 'Recognise the 5-12-13 triple immediately.'),
  ('O is the centre of a circle; PR is a tangent to the circle at Q, and angle SOQ = 86°. Calculate angle SQR.', '43°', '86°', '47°', '94°', null, 'A', 3, 'WAEC', 'Since PR is tangent at Q, OQ is perpendicular to PR. The isosceles triangle OSQ (OS = OQ, radii) combined with the tangent-radius right angle gives angle SQR = 43° (WAEC 2014 past question, checked against the official mark scheme).', 'Half of the central angle often appears directly when a tangent and a radius to the point of contact are both in the figure.'),
  ('PQ is a tangent to a circle at R, and UT is parallel to PQ. If angle TRQ = x°, find angle URT in terms of x.', '(90 - x)°', '(180 - 2x)°', '(2x - 180)°', '(x - 90)°', null, 'B', 3, 'WAEC', 'Using the alternate segment theorem together with the parallel-line angle relationships between UT and the tangent PQ gives angle URT = (180 - 2x)° (WAEC 2014 past question, checked against the official mark scheme).', null),
  ('XMY is a triangle inscribed in a circle. LMN is a tangent to the circle at M, XY = XM, and angle XML = 42°. Find the value of angle YMN.', '42°', '48°', '84°', '96°', null, 'C', 4, 'WAEC', 'Since XY = XM, triangle XYM is isosceles, and combining this with the alternate segment theorem at the tangent LMN gives angle YMN = 84° (WAEC 2009 past question, checked against the official mark scheme).', null),
  ('TD is a tangent to a circle ABCT, with AB = AT, BT = BC, and angle ABT = 36°. Calculate angle CTD.', '18°', '36°', '72°', '54°', null, 'B', 4, 'WAEC', 'The two isosceles triangles (AB = AT and BT = BC) combined with the alternate segment theorem at the tangent TD give angle CTD = 36° (WAEC 2012 past question, checked against the official mark scheme).', null),
  ('ATB is a tangent to a circle at T. If angle ATS = 75°, angle BTP = 40°, and angle PSQ = 12°, calculate (i) angle SRP (ii) angle SQP (iii) angle SPQ.', '(i) 115°, (ii) 115°, (iii) 53°', '(i) 65°, (ii) 65°, (iii) 53°', '(i) 115°, (ii) 65°, (iii) 50°', '(i) 105°, (ii) 105°, (iii) 63°', null, 'A', 5, 'WAEC', 'Working through the cyclic quadrilateral and alternate segment relationships in the figure gives angle SRP = 115°, angle SQP = 115° (opposite angles of a cyclic quadrilateral, or exterior equals interior opposite), and angle SPQ = 53° (WAEC 2013 past question, checked against the official mark scheme).', null),
  ('Two chords AB and CD of a circle are produced to meet outside the circle at point Q. Which relationship correctly connects QA, QB, QC and QD?', 'QA + QB = QC + QD', 'QA times QB = QC times QD', 'QA minus QB = QC minus QD', 'QA divided by QB = QC divided by QD', null, 'B', 3, 'GENERAL', 'This is the intersecting chords/secants theorem: when two chords (or their extensions, secants) meet at a point outside or inside the circle, the products of the two segments from that point are equal, QA times QB = QC times QD.', null)
) as v(question_text, option_a, option_b, option_c, option_d, option_e, correct_letter, difficulty, exam_type, explanation, exam_shortcut);

-- ==========================================
-- TOPIC 302: SINE RULE & COSINE RULE (Week 2)
-- ==========================================

with lesson as (
  insert into public.lessons (topic_id, title, summary, content_body, order_index)
  values (
    (select t.id from public.topics t join public.curricula c on c.id = t.curriculum_id
     where c.subject = 'Mathematics' and t.class_level = 'SS2' and t.term = 3 and t.order_index = 302),
    'Sine Rule and Cosine Rule',
    'Deriving and applying the sine rule and cosine rule to find unknown sides and angles in any triangle, not just right-angled ones.',
    '**Glossary.** The **included angle** between two sides of a triangle is the angle sandwiched directly between them (where they meet at a vertex). **SSA** means two Sides and a non-included Angle are given; **SAS** means two Sides and the included Angle; **SSS** means all three Sides.

**Standard triangle notation.** Vertices are labelled $A$, $B$, $C$; the side opposite each vertex is labelled with the matching lowercase letter ($a$ opposite $A$, $b$ opposite $B$, $c$ opposite $C$).

**Sine Rule:** $\dfrac{a}{\sin A} = \dfrac{b}{\sin B} = \dfrac{c}{\sin C}$. Use it when given (i) two angles and one side (AAS/ASA), or (ii) two sides and a non-included angle (SSA, watch for the ambiguous case where two solutions are possible).

**Cosine Rule:** $a^2 = b^2 + c^2 - 2bc\cos A$ (and the cyclic versions for $b^2$, $c^2$). Rearranged to find an angle: $\cos A = \dfrac{b^2 + c^2 - a^2}{2bc}$. Use it when given (i) two sides and the included angle (SAS), or (ii) all three sides (SSS). When the included angle is $90^{\circ}$, $\cos 90^{\circ} = 0$ and the cosine rule collapses exactly into Pythagoras'' theorem.',
    1
  )
  returning id
),
we1 as (
  insert into public.worked_examples (lesson_id, title, problem_statement, solution_steps, real_life_context, exam_shortcut, diagram_type, diagram_data, status)
  select id,
    'Sine Rule: Finding a Side (AAS)',
    'In triangle ABC, A = 40 degrees, B = 65 degrees, and side a = 8 cm. Find side b.',
    to_jsonb(array[
      'Two angles and a side are known (AAS), so use the sine rule relating the two known angles and their opposite sides: $\dfrac{a}{\sin A} = \dfrac{b}{\sin B}$.',
      'Substitute the known values: $\dfrac{8}{\sin 40^{\circ}} = \dfrac{b}{\sin 65^{\circ}}$.',
      'Make $b$ the subject: $b = \dfrac{8 \times \sin 65^{\circ}}{\sin 40^{\circ}}$.',
      'Evaluate the sines: $\sin 65^{\circ} \approx 0.9063$, $\sin 40^{\circ} \approx 0.6428$.',
      'Compute: $b = \dfrac{8 \times 0.9063}{0.6428} = \dfrac{7.251}{0.6428} \approx 11.28$.'
    ]),
    'A land surveyor plotting a triangular plot of land in a new estate uses exactly this method: two angles are measured with a theodolite and one side is measured by tape, and the sine rule gives the remaining sides without ever needing to physically measure across an obstruction like a building or a stream.',
    'Whenever two angles are given, find the third by $180^{\circ}$ minus the sum of the other two before touching the sine rule, many marks are lost by skipping this free step.',
    'triangle',
    '{"vertices": [{"label": "A", "x": 0, "y": 0}, {"label": "C", "x": 8, "y": 0}, {"label": "B", "x": 6.6, "y": 5.14}], "sideLabels": [{"from": "A", "to": "C", "label": "a ≈ 8"}, {"from": "A", "to": "B", "label": "c"}, {"from": "C", "to": "B", "label": "b ≈ 11.28"}], "angleLabels": [{"vertex": "A", "label": "40°"}, {"vertex": "B", "label": "65°"}]}'::jsonb,
    'published'
  from lesson
  returning id
),
we2 as (
  insert into public.worked_examples (lesson_id, title, problem_statement, solution_steps, real_life_context, exam_shortcut, diagram_type, diagram_data, status)
  select lesson.id,
    'Cosine Rule: Finding a Side (SAS)',
    'In triangle PQR, p = 7 cm, q = 9 cm, and R = 58 degrees. Find side r.',
    to_jsonb(array[
      'Two sides and the included angle (R, between p and q) are known, so choose the cosine rule.',
      'Write the formula: $r^2 = p^2 + q^2 - 2pq\cos R$.',
      'Substitute: $r^2 = 7^2 + 9^2 - 2(7)(9)\cos 58^{\circ} = 49 + 81 - 126\cos 58^{\circ}$.',
      'Evaluate $\cos 58^{\circ} \approx 0.5299$ and the product: $126 \times 0.5299 \approx 66.77$.',
      'Combine: $r^2 = 130 - 66.77 = 63.23$.',
      'Take the square root: $r = \sqrt{63.23} \approx 7.95$.'
    ]),
    'A construction team laying out a triangular roof truss knows two rafter lengths and the angle between them at the apex, exactly this cosine-rule calculation gives the length of the bottom chord (the third side) needed to cut before it is measured on site.',
    'The included angle is the giveaway for the cosine rule: it must be the angle sandwiched between the two given sides, otherwise the sine rule is needed instead.',
    'triangle',
    '{"vertices": [{"label": "R", "x": 0, "y": 0}, {"label": "P", "x": 9, "y": 0}, {"label": "Q", "x": 3.71, "y": 5.93}], "sideLabels": [{"from": "R", "to": "P", "label": "q = 9 cm"}, {"from": "R", "to": "Q", "label": "p = 7 cm"}, {"from": "P", "to": "Q", "label": "r ≈ 7.95 cm"}], "angleLabels": [{"vertex": "R", "label": "58°"}]}'::jsonb,
    'published'
  from lesson
  returning id
)
insert into public.worked_examples (lesson_id, title, problem_statement, solution_steps, exam_shortcut, common_trap_warning, diagram_type, diagram_data, status)
select lesson.id,
  'Cosine Rule: Finding an Angle (SSS)',
  'In triangle ABC, a = 12 cm, b = 15 cm, c = 18 cm. Find angle A.',
  to_jsonb(array[
    'All three sides are known (SSS), so choose the cosine rule in its angle form.',
    'Write the rearranged formula: $\cos A = \dfrac{b^2 + c^2 - a^2}{2bc}$.',
    'Substitute: $\cos A = \dfrac{15^2 + 18^2 - 12^2}{2 \times 15 \times 18} = \dfrac{225 + 324 - 144}{540}$.',
    'Simplify the numerator and denominator: $\cos A = \dfrac{405}{540} = 0.75$.',
    'Take the inverse cosine: $A = \cos^{-1}(0.75)$.',
    'Evaluate: $A \approx 41.41^{\circ}$.'
  ]),
  'A quick sanity check on any cosine-rule angle answer: it must come out strictly between 0 and 180 degrees, and the largest angle is always opposite the longest side, if your answer breaks either rule, recheck the substitution.',
  'Do not confuse which side goes with which angle in the formula, the side you are solving for''s label ($a$, opposite angle $A$) must be the one subtracted at the end, not one of the two on top being squared and added.',
  'triangle',
  '{"vertices": [{"label": "A", "x": 0, "y": 0}, {"label": "C", "x": 18, "y": 0}, {"label": "B", "x": 13.85, "y": 5.94}], "sideLabels": [{"from": "A", "to": "C", "label": "b = 15 cm"}, {"from": "A", "to": "B", "label": "c = 18 cm"}, {"from": "C", "to": "B", "label": "a = 12 cm"}], "angleLabels": [{"vertex": "A", "label": "A ≈ 41.41°"}]}'::jsonb,
  'published'
from lesson;

insert into public.questions (topic_id, question_text, option_a, option_b, option_c, option_d, option_e, correct_letter, difficulty, exam_type, explanation, exam_shortcut, status)
select topic_ref.tid, v.question_text, v.option_a, v.option_b, v.option_c, v.option_d, v.option_e, v.correct_letter, v.difficulty, v.exam_type, v.explanation, v.exam_shortcut, 'published'
from (select t.id as tid from public.topics t join public.curricula c on c.id = t.curriculum_id
      where c.subject = 'Mathematics' and t.class_level = 'SS2' and t.term = 3 and t.order_index = 302) topic_ref,
lateral (values
  ('In triangle ABC, A = 45°, C = 70°, and b = 12 cm. Use the sine rule to find side a.', '8.36 cm', '9.36 cm', '10.36 cm', '11.36 cm', null::text, 'B', 3, 'GENERAL'::exam_type, 'First find B = 180 - 45 - 70 = 65°. Then a/sinA = b/sinB gives a = 12 sin45°/sin65° ≈ 9.36 cm.', 'The third angle is always free from the angle sum, find it before using the sine rule.'),
  ('A triangle has sides p = 9 cm, q = 12 cm, and included angle R = 55°. Find side r using the cosine rule.', '9.05 cm', '10.06 cm', '11.06 cm', '12.06 cm', null, 'B', 3, 'GENERAL', 'r^2 = 9^2 + 12^2 - 2(9)(12)cos55° = 81 + 144 - 216(0.5736) ≈ 101.1, so r ≈ 10.06 cm.', null),
  ('In triangle PQR, p = 8 cm, q = 10 cm, and r = 12 cm. Find angle P.', '31.4°', '36.4°', '41.4°', '46.4°', null, 'C', 3, 'GENERAL', 'cos P = (q^2+r^2-p^2)/(2qr) = (100+144-64)/240 = 180/240 = 0.75, so P = cos^-1(0.75) ≈ 41.4°.', null),
  ('When should you use the sine rule instead of the cosine rule?', 'When two sides and the included angle are known, or all three sides are known', 'When two angles and one side are known, or two sides and a non-included angle are known', 'Only when the triangle is right-angled', 'Only when all three angles are known', null, 'B', 2, 'GENERAL', 'Sine rule needs AAS/ASA (two angles, one side) or SSA (two sides, a non-included angle). Cosine rule needs SAS or SSS.', 'Memorise "SSA/AAS = sine, SAS/SSS = cosine" as a single rule of thumb.'),
  ('In triangle XYZ, X = 50°, Y = 60°, and x = 15 cm. Find y.', '14.96 cm', '15.96 cm', '16.96 cm', '17.96 cm', null, 'C', 3, 'GENERAL', 'y = x sinY/sinX = 15 sin60°/sin50° ≈ 16.96 cm.', null),
  ('In triangle ABC, a = 20 cm, B = 48°, and C = 67°. Find (a) A (b) side b (c) side c.', 'A = 65°, b ≈ 16.4 cm, c ≈ 20.3 cm', 'A = 65°, b ≈ 20.3 cm, c ≈ 16.4 cm', 'A = 60°, b ≈ 15.0 cm, c ≈ 19.0 cm', 'A = 65°, b ≈ 18.0 cm, c ≈ 22.0 cm', null, 'A', 3, 'GENERAL', 'A = 180-48-67 = 65°. b = 20 sin48°/sin65° ≈ 16.4 cm. c = 20 sin67°/sin65° ≈ 20.3 cm.', null),
  ('A triangle has sides of length 13 cm, 14 cm, and 15 cm. Which is the largest angle, and which side is it opposite?', 'The angle opposite the 15 cm side, approximately 67.4°', 'The angle opposite the 15 cm side, approximately 59.5°', 'The angle opposite the 13 cm side, approximately 67.4°', 'The angle opposite the 14 cm side, approximately 59.5°', null, 'A', 3, 'GENERAL', 'By the cosine rule, the angle opposite the 15 cm side is cos^-1((13^2+14^2-15^2)/(2x13x14)) = cos^-1(140/364) ≈ 67.4°, which is the largest angle since it sits opposite the longest side. (The angle opposite 14 cm is ≈59.5° and the angle opposite 13 cm is ≈53.1°.)', 'The largest angle is always opposite the longest side, and the smallest angle opposite the shortest side, use this to sanity-check any cosine-rule angle answer.'),
  ('In triangle PQR, p = 7.5 cm, r = 10.2 cm, and the included angle Q = 72°. Find side q.', '9.63 cm', '10.63 cm', '11.63 cm', '12.63 cm', null, 'B', 4, 'GENERAL', 'q^2 = 7.5^2 + 10.2^2 - 2(7.5)(10.2)cos72° = 56.25 + 104.04 - 153(0.3090) ≈ 113.01, so q ≈ 10.63 cm.', null),
  ('Two sides of a triangle are 18 cm and 24 cm. If the angle between them is 58°, find the third side.', '19.03 cm', '20.03 cm', '21.03 cm', '22.03 cm', null, 'C', 3, 'GENERAL', 'Third side = sqrt(18^2+24^2-2x18x24xcos58°) = sqrt(900-457.86) = sqrt(442.14) ≈ 21.03 cm.', null),
  ('Two sides of a triangle are 8 cm and 11 cm, with an included angle of 64°. Find the third side.', '9.38 cm', '10.38 cm', '11.38 cm', '12.38 cm', null, 'B', 3, 'GENERAL', 'Third side = sqrt(8^2+11^2-2x8x11xcos64°) = sqrt(185-77.2) ≈ 10.38 cm.', null),
  ('In triangle ABC, a = 10 cm, b = 14 cm, and A = 38°. Find B (this is the ambiguous SSA case).', 'B ≈ 59.5° (the acute solution, since b > a)', 'B ≈ 120.5° (the obtuse solution)', 'Both 59.5° and 120.5° are equally valid final answers', 'B cannot be found from this information', null, 'A', 4, 'GENERAL', 'sinB = b sinA/a = 14 sin38°/10 ≈ 0.862, giving B ≈ 59.5° or its supplement 120.5°. Since side b (14 cm) is longer than side a (10 cm), angle B must be the larger angle, but 120.5° plus the given 38° would exceed 180°, so the acute value B ≈ 59.5° is the one that fits.', 'Always check both the acute answer and its 180-minus supplement against the angle sum before rejecting either.'),
  ('A triangle has sides 5 cm, 7 cm, and 9 cm. Find the largest angle.', '85.7°', '90.7°', '95.7°', '100.7°', null, 'C', 3, 'GENERAL', 'The largest angle is opposite the 9 cm side: cos^-1((25+49-81)/70) = cos^-1(-0.0857) ≈ 95.7°.', 'A negative cosine value means the angle is obtuse, greater than 90 degrees, this is normal and expected for the largest angle in an obtuse triangle.'),
  ('Two ships leave a port at the same time. One travels at 30 km/h on a bearing of 040° and the other at 25 km/h on a bearing of 130°. How far apart are they after 2 hours?', '68.10 km', '73.10 km', '78.10 km', '83.10 km', null, 'C', 4, 'GENERAL', 'After 2 hours the ships have travelled 60 km and 50 km respectively. The two bearings differ by exactly 90° (130° - 040°), so the angle between the paths at the port is 90°, and Pythagoras gives distance = sqrt(60^2+50^2) ≈ 78.10 km.', 'A 90° angle between two bearings turns a cosine-rule problem into a straight Pythagoras calculation.'),
  ('In triangle QRS, QS = 12 m, angle RQS = 30°, and angle QRS = 45°. Calculate the length RS.', '5√2 m', '6√2 m', '7√2 m', '8√2 m', null, 'B', 3, 'GENERAL', 'By the sine rule, RS/sin(RQS) = QS/sin(QRS), so RS = 12 sin30°/sin45° = 12(0.5)/(√2/2) = 6√2 cm.', null),
  ('The two base angles of a triangle are each 30°, and the longest side is 10 cm. Calculate the length of each of the other two sides.', '10√3/3 cm', '10√2/3 cm', '5√3 cm', '5√2 cm', null, 'A', 4, 'GENERAL', 'The third angle is 180 - 30 - 30 = 120°, opposite the given 10 cm side. By the sine rule, each equal side = 10 sin30°/sin120° = 10√3/3 cm ≈ 5.77 cm.', null),
  ('In an acute-angled triangle PQR, PQ = 10 m, PR = 15 m, and angle PRQ = 40°. Evaluate angle PQR.', '64.62°', '69.62°', '74.62°', '79.62°', null, 'C', 4, 'GENERAL', 'PR (15 m, opposite angle Q) and PQ (10 m, opposite angle R = 40°) give, by the sine rule, sinQ = PR sinR/PQ = 15 sin40°/10 ≈ 0.964, so angle PQR ≈ 74.62° (the acute solution, matching the given acute-angled triangle).', null),
  ('Two sides 2 m and 1 m enclose an angle of 120°. Find the length of the third side XZ.', '√5 m', '√6 m', '√7 m', '√8 m', null, 'C', 3, 'GENERAL', 'XZ = sqrt(2^2+1^2-2(2)(1)cos120°) = sqrt(4+1-4(-0.5)) = sqrt(5+2) = sqrt(7) ≈ 2.65 m.', null),
  ('ABC is a triangle in which angle BAC = 75°, AB = 3 cm and AC = 4 cm. Calculate BC correct to 1 decimal place.', '3.8 cm', '4.0 cm', '4.3 cm', '4.6 cm', null, 'C', 3, 'WAEC', 'BC^2 = 3^2 + 4^2 - 2(3)(4)cos75° = 9+16-24(0.2588) ≈ 18.79, so BC ≈ 4.3 cm (WAEC 2014).', null),
  ('AB = 4 cm, AC = 6 cm, and angle ACB = 30°. Calculate the angle marked P (angle ABC).', '38.6°', '43.6°', '48.6°', '53.6°', null, 'C', 4, 'WAEC', 'By the sine rule, sin(ABC)/AC = sin(ACB)/AB, so sin(ABC) = 6 sin30°/4 = 0.75, giving angle ABC ≈ 48.6° (WAEC 2006).', null),
  ('The hypotenuse of a right-angled triangle is 17 cm and one of the angles is 43°. Find (i) the third angle (ii) the side opposite the smallest angle.', '(i) 47°, (ii) 11.59 cm', '(i) 47°, (ii) 12.59 cm', '(i) 57°, (ii) 11.59 cm', '(i) 37°, (ii) 10.59 cm', null, 'A', 3, 'GENERAL', 'The third angle is 180-90-43 = 47°. The smallest angle is 43°, and the side opposite it is 17 sin43° ≈ 11.59 cm.', null),
  ('In triangle ABC, a = 8 cm, b = 12 cm, C = 82°. Find c.', '11.46 cm', '12.46 cm', '13.46 cm', '14.46 cm', null, 'C', 3, 'WAEC', 'c^2 = 8^2+12^2-2(8)(12)cos82° = 64+144-192(0.1392) ≈ 181.3, so c ≈ 13.46 cm (WAEC 2006).', null),
  ('Two sides of a triangle measuring 10 cm and 15 cm enclose an angle of 55°. (i) Calculate the third side (ii) find the other two angles.', '(i) 12.37 cm, (ii) 41.48° (opposite 10 cm) and 83.52° (opposite 15 cm)', '(i) 12.37 cm, (ii) 83.52° (opposite 10 cm) and 41.48° (opposite 15 cm)', '(i) 11.37 cm, (ii) 45.0° and 80.0°', '(i) 13.37 cm, (ii) 38.5° and 86.5°', null, 'A', 4, 'WAEC', 'Third side = sqrt(10^2+15^2-2x10x15xcos55°) ≈ 12.37 cm. By the sine rule, the angle opposite the shorter given side (10 cm) is the smaller one, ≈41.48°, and the angle opposite the longer given side (15 cm) is the larger one, ≈83.52° (their sum with 55° checks to 180°) (WAEC 2009).', 'The largest angle always sits opposite the longest side, use this to check which computed angle goes with which side.'),
  ('BC = 2 cm, AB = 3 cm and angle ACD = 150° (an exterior angle at C). Find the value of sin A.', '1/4', '1/3', '1/2', '2/3', null, 'B', 4, 'GENERAL', 'The exterior angle ACD = 150° means the interior angle ACB = 180-150 = 30°. By the sine rule, BC/sinA = AB/sin(ACB), so sinA = BC sin(ACB)/AB = 2 sin30°/3 = 2(0.5)/3 = 1/3.', 'An exterior angle and its interior angle at the same vertex always sum to 180°.'),
  ('In triangle XYZ, XY = 9 cm, XZ = 10 cm and angle YXZ = 75°. Find YZ.', '9.59 cm', '10.59 cm', '11.59 cm', '12.59 cm', null, 'C', 3, 'GENERAL', 'YZ^2 = 9^2+10^2-2(9)(10)cos75° = 81+100-180(0.2588) ≈ 134.41, so YZ ≈ 11.59 cm.', null)
) as v(question_text, option_a, option_b, option_c, option_d, option_e, correct_letter, difficulty, exam_type, explanation, exam_shortcut);

-- ==========================================
-- TOPIC 303: BEARING, DISTANCES, ELEVATION & DEPRESSION (Week 3)
-- ==========================================

with lesson as (
  insert into public.lessons (topic_id, title, summary, content_body, order_index)
  values (
    (select t.id from public.topics t join public.curricula c on c.id = t.curriculum_id
     where c.subject = 'Mathematics' and t.class_level = 'SS2' and t.term = 3 and t.order_index = 303),
    'Bearing, Distances, Elevation and Depression',
    'Three-figure and compass bearings, back bearings, and solving elevation/depression problems with right-angled trigonometry.',
    '**Glossary.** A **bearing** is the direction of one point from another, always measured from **North**, always **clockwise**. A **three-figure bearing** is written as three digits from 000 to 360 (e.g. 045°, 320°). A **compass bearing** starts with N or S, has an angle, then ends with E or W (e.g. N40°E). The **angle of elevation** is measured upward from the horizontal to an object above the observer; the **angle of depression** is measured downward from the horizontal to an object below. A **back bearing** is the bearing of the starting point as seen from the destination, the reverse direction.

**Converting a three-figure bearing to a compass bearing** depends on which quadrant it falls in: 1st quadrant ($000^{\circ}$-$090^{\circ}$) gives N$\theta$E where $\theta$ is the bearing itself; 2nd quadrant ($090^{\circ}$-$180^{\circ}$) gives S$\theta$E where $\theta = 180^{\circ} - \text{bearing}$; 3rd quadrant ($180^{\circ}$-$270^{\circ}$) gives S$\theta$W where $\theta = \text{bearing} - 180^{\circ}$; 4th quadrant ($270^{\circ}$-$360^{\circ}$) gives N$\theta$W where $\theta = 360^{\circ} - \text{bearing}$.

**Back bearings:** if the given bearing is less than $180^{\circ}$, add $180^{\circ}$; if it is $180^{\circ}$ or more, subtract $180^{\circ}$.

Because the horizontal at the top and the horizontal at the bottom are parallel lines, the **angle of elevation from A to B always equals the angle of depression from B to A** (alternate angles). Both elevation and depression problems are solved with SOHCAHTOA (most often tan, since height and horizontal distance are usually the opposite/adjacent pair) or Pythagoras'' theorem in the right triangle formed.',
    1
  )
  returning id
),
we1 as (
  insert into public.worked_examples (lesson_id, title, problem_statement, solution_steps, real_life_context, exam_shortcut, status)
  select id,
    'Converting Between Bearing Formats',
    'Convert 055 degrees to a compass bearing, and N65°W to a three-figure bearing.',
    to_jsonb(array[
      '055° lies in the 1st quadrant ($000^{\circ}$-$090^{\circ}$), so the compass form is N$\theta$E with $\theta$ equal to the bearing itself: N55°E.',
      'N65°W lies in the 4th quadrant ($270^{\circ}$-$360^{\circ}$), where the three-figure bearing $= 360^{\circ} - \theta = 360^{\circ} - 65^{\circ} = 295^{\circ}$.'
    ]),
    'This is the exact conversion a pilot or ship''s navigator performs when moving between a compass heading given by air traffic control (a three-figure bearing) and the compass-rose reading shown on their instruments.',
    'Sketch a quick compass rose and mark which quadrant the bearing falls in before applying any formula, never memorise the four formulas in isolation.',
    'published'
  from lesson
  returning id
),
we2 as (
  insert into public.worked_examples (lesson_id, title, problem_statement, solution_steps, real_life_context, exam_shortcut, diagram_type, diagram_data, status)
  select lesson.id,
    'Bearing Resolved into East/North Components',
    'A ship sails from port P on a bearing of 040 degrees for 80 km to reach point Q. Find how far east and how far north Q is from P.',
    to_jsonb(array[
      'The bearing $040^{\circ}$ is measured clockwise from North, so the "north" leg is adjacent to the $40^{\circ}$ angle and the "east" leg is opposite it, with the 80 km path as the hypotenuse.',
      'Eastward distance (opposite side): East $= 80 \times \sin 40^{\circ} \approx 80 \times 0.6428 = 51.42$ km.',
      'Northward distance (adjacent side): North $= 80 \times \cos 40^{\circ} \approx 80 \times 0.7660 = 61.28$ km.'
    ]),
    'This is exactly how a ship''s officer or a drone-delivery route planner converts a single bearing-and-distance instruction into the east/north grid coordinates a GPS chart actually uses.',
    'SOH-CAH-TOA is always in play: the leg adjacent to the bearing angle (measured from North) is the north-south distance, and the opposite leg is the east-west distance.',
    'triangle',
    '{"vertices": [{"label": "P", "x": 0, "y": 0}, {"label": "N", "x": 0, "y": 61.28}, {"label": "Q", "x": 51.42, "y": 61.28}], "sideLabels": [{"from": "P", "to": "N", "label": "North ≈ 61.28 km"}, {"from": "N", "to": "Q", "label": "East ≈ 51.42 km"}, {"from": "P", "to": "Q", "label": "80 km"}], "angleLabels": [{"vertex": "P", "label": "040°"}], "rightAngleAt": "N"}'::jsonb,
    'published'
  from lesson
  returning id
),
we3 as (
  insert into public.worked_examples (lesson_id, title, problem_statement, solution_steps, real_life_context, exam_shortcut, diagram_type, diagram_data, status)
  select lesson.id,
    'Angle of Elevation to a Tower',
    'From a point 50 m from the base of a tower, the angle of elevation to the top is 28 degrees. Find the height of the tower.',
    to_jsonb(array[
      'The horizontal distance (50 m) is adjacent to the $28^{\circ}$ angle of elevation, and the height $h$ is opposite it.',
      'Choose the tan ratio: $\tan(\text{angle}) = \dfrac{\text{opposite}}{\text{adjacent}}$, so $\tan 28^{\circ} = \dfrac{h}{50}$.',
      'Make $h$ the subject: $h = 50 \times \tan 28^{\circ}$.',
      'Evaluate $\tan 28^{\circ} \approx 0.5317$: $h \approx 50 \times 0.5317 = 26.59$.'
    ]),
    'A telecom engineer standing a measured distance from a GSM mast can find its height this way with just a clinometer reading, without ever having to climb it, exactly how mast heights are verified on site in Nigeria.',
    'Reach for tan first for elevation/depression problems, height and horizontal distance are almost always the opposite/adjacent pair.',
    'triangle',
    '{"vertices": [{"label": "Base", "x": 0, "y": 0}, {"label": "Observer", "x": 50, "y": 0}, {"label": "Top", "x": 0, "y": 26.59}], "sideLabels": [{"from": "Base", "to": "Observer", "label": "50 m"}, {"from": "Base", "to": "Top", "label": "h ≈ 26.59 m"}], "angleLabels": [{"vertex": "Observer", "label": "28°"}], "rightAngleAt": "Base"}'::jsonb,
    'published'
  from lesson
  returning id
)
insert into public.worked_examples (lesson_id, title, problem_statement, solution_steps, real_life_context, exam_shortcut, diagram_type, diagram_data, status)
select lesson.id,
  'Angle of Depression from a Lighthouse',
  'From the top of a lighthouse 60 m high, the angle of depression to a boat is 25 degrees. How far is the boat from the base?',
  to_jsonb(array[
    'By alternate angles, the angle of depression from the top ($25^{\circ}$) equals the angle of elevation from the boat to the top, also $25^{\circ}$.',
    'The lighthouse height (60 m) is opposite the $25^{\circ}$ angle; the distance $d$ from the base to the boat is adjacent.',
    'Choose the tan ratio: $\tan 25^{\circ} = \dfrac{60}{d}$.',
    'Make $d$ the subject: $d = \dfrac{60}{\tan 25^{\circ}}$.',
    'Evaluate $\tan 25^{\circ} \approx 0.4663$: $d \approx \dfrac{60}{0.4663} \approx 128.65$.'
  ]),
  'This is how a coast guard station or port authority estimates a vessel''s distance from a lighthouse or watchtower using only the known tower height and a single angle reading, no radar needed.',
  'Never resolve the "looking down" triangle from scratch, the angle of depression measured at the top always equals the angle of elevation measured at the bottom.',
  'triangle',
  '{"vertices": [{"label": "Base", "x": 0, "y": 0}, {"label": "Boat", "x": 128.65, "y": 0}, {"label": "Top", "x": 0, "y": 60}], "sideLabels": [{"from": "Base", "to": "Boat", "label": "d ≈ 128.65 m"}, {"from": "Base", "to": "Top", "label": "60 m"}], "angleLabels": [{"vertex": "Boat", "label": "25°"}], "rightAngleAt": "Base"}'::jsonb,
  'published'
from lesson;

insert into public.questions (topic_id, question_text, option_a, option_b, option_c, option_d, option_e, correct_letter, difficulty, exam_type, explanation, exam_shortcut, status)
select topic_ref.tid, v.question_text, v.option_a, v.option_b, v.option_c, v.option_d, v.option_e, v.correct_letter, v.difficulty, v.exam_type, v.explanation, v.exam_shortcut, 'published'
from (select t.id as tid from public.topics t join public.curricula c on c.id = t.curriculum_id
      where c.subject = 'Mathematics' and t.class_level = 'SS2' and t.term = 3 and t.order_index = 303) topic_ref,
lateral (values
  ('Convert 215° to a compass bearing.', 'N35°W', 'S35°E', 'S35°W', 'N35°E', null::text, 'C', 2, 'GENERAL'::exam_type, '215° lies in the 3rd quadrant (180°-270°), so the compass form is S(bearing-180)W = S35°W.', null),
  ('Convert S20°E to a three-figure bearing.', '020°', '070°', '160°', '200°', null, 'C', 2, 'GENERAL', 'S20°E means start at South, turn 20° towards East, which is 180° - 20° = 160°.', null),
  ('Point B is on a bearing of 120° from point A. Find the bearing of A from B.', '060°', '240°', '300°', '330°', null, 'C', 2, 'GENERAL', 'Since 120° is less than 180°, add 180°: back bearing = 120° + 180° = 300°.', 'Less than 180, add 180; 180 or more, subtract 180.'),
  ('Town B is 50 km from town A on a bearing of 135°, and town C is 40 km from A on a bearing of 225°. Find the distance BC.', '54.03 km', '59.03 km', '64.03 km', '69.03 km', null, 'C', 3, 'GENERAL', 'The angle at A between the two bearings is 225°-135° = 90°, so by Pythagoras BC = sqrt(50^2+40^2) = sqrt(4100) ≈ 64.03 km.', 'A 90° angle between two bearings is a hidden Pythagoras shortcut.'),
  ('A plane flies from airport X to airport Y on a bearing of 065° for 200 km, then from Y to Z on a bearing of 155° for 150 km. Find (a) the distance XZ (b) the bearing of Z from X.', '(a) 250 km, (b) ≈102°', '(a) 250 km, (b) ≈112°', '(a) 230 km, (b) ≈102°', '(a) 260 km, (b) ≈98°', null, 'A', 4, 'GENERAL', 'The bearings differ by exactly 90° (155°-065°), so by Pythagoras XZ = sqrt(200^2+150^2) = 250 km. Resolving into components and finding the bearing from X gives the direction ≈102°.', 'A 90° turn between two legs of a journey converts the whole problem into a right triangle.'),
  ('From a port P, a ship sails 60 km on bearing N30°E to point Q, then 80 km on bearing S60°E to point R. Find the distance PR.', '90 km', '95 km', '100 km', '105 km', null, 'C', 4, 'GENERAL', 'N30°E is bearing 030°, and S60°E is bearing 120°; these differ by exactly 90°, so PR = sqrt(60^2+80^2) = sqrt(10000) = 100 km.', 'This is a 60-80-100 triple, a multiple of 3-4-5.'),
  ('Point A is 100 km from point B on a bearing of 240°. What is the bearing of B from A?', '030°', '060°', '120°', '150°', null, 'B', 2, 'GENERAL', 'Since 240° is 180° or more, subtract 180°: back bearing = 240° - 180° = 060°.', null),
  ('Convert 315° to a compass bearing.', 'N45°E', 'N45°W', 'S45°W', 'S45°E', null, 'B', 2, 'GENERAL', '315° lies in the 4th quadrant, so the compass form is N(360-315)W = N45°W.', null),
  ('Convert S75°W to a three-figure bearing.', '105°', '195°', '255°', '285°', null, 'C', 2, 'GENERAL', 'S75°W means starting at South, turning 75° towards West, which is 180° + 75° = 255°.', null),
  ('Define "bearing" and state one key principle used when measuring it.', 'The direction of one point relative to another, always measured from North and always clockwise', 'The straight-line distance between two points', 'The angle of elevation to an object above the horizon', 'The compass direction measured anticlockwise from East', null, 'A', 1, 'GENERAL', 'A bearing is the direction of one point relative to another, always measured as an angle from North, always in a clockwise direction.', null),
  ('A town Y is on a bearing of 300° from town X. What is the bearing of X from Y?', '060°', '090°', '120°', '150°', null, 'C', 2, 'GENERAL', 'Since 300° is 180° or more, subtract 180°: back bearing = 300° - 180° = 120°.', null),
  ('Convert the following bearings: (a) 035° to compass (b) 260° to compass (c) N20°W to three-figure (d) S50°E to three-figure.', '(a) N35°E, (b) S80°W, (c) 340°, (d) 130°', '(a) N35°E, (b) N80°W, (c) 340°, (d) 130°', '(a) N35°W, (b) S80°W, (c) 320°, (d) 130°', '(a) N35°E, (b) S80°E, (c) 340°, (d) 140°', null, 'A', 3, 'GENERAL', '(a) 035° is in the 1st quadrant, N35°E. (b) 260° is in the 3rd quadrant, S(260-180)W = S80°W. (c) N20°W is in the 4th quadrant, 360-20 = 340°. (d) S50°E is in the 2nd quadrant, 180-50 = 130°.', null),
  ('Find the back bearing for each: (a) 040° (b) 175° (c) 250°.', '(a) 220°, (b) 355°, (c) 070°', '(a) 220°, (b) 005°, (c) 070°', '(a) 220°, (b) 355°, (c) 100°', '(a) 240°, (b) 355°, (c) 070°', null, 'A', 3, 'GENERAL', '(a) 040+180=220°. (b) 175+180=355°. (c) 250-180=070°.', null),
  ('A ship sails from port A on a bearing of 120° for 60 km to reach point B. Calculate (a) how far south B is from A (b) how far east B is from A.', '(a) 30 km, (b) ≈51.96 km', '(a) 51.96 km, (b) ≈30 km', '(a) 35 km, (b) ≈45 km', '(a) 25 km, (b) ≈55 km', null, 'A', 3, 'GENERAL', 'South component = 60 cos60° = 30 km (since the bearing 120° is 60° past due South from due East reference, the adjacent leg to the "south of east-west line" is via cos of the angle past 090°). East component = 60 sin60° ≈ 51.96 km.', null),
  ('Point Q is 80 km from point P on a bearing of 210°. Point R is 50 km from P on a bearing of 300°. Find the distance QR.', '84.34 km', '89.34 km', '94.34 km', '99.34 km', null, 'C', 4, 'GENERAL', 'The angle QPR = 300° - 210° = 90°, so by Pythagoras QR = sqrt(80^2+50^2) = sqrt(8900) ≈ 94.34 km.', null),
  ('Express the true bearing of 250° as a compass bearing.', 'N70°W', 'S70°E', 'S70°W', 'N70°E', null, 'C', 2, 'WAEC', '250° is in the 3rd quadrant, so the compass form is S(250-180)W = S70°W (WAEC 1997).', null),
  ('The bearing S40°E is the same as which three-figure bearing?', '040°', '140°', '220°', '320°', null, 'B', 2, 'GENERAL', 'S40°E means starting at South, turning 40° towards East, which is 180-40 = 140°.', null),
  ('The bearing of a point A from a point B is 042°. Calculate the bearing of B from A.', '132°', '180°', '222°', '312°', null, 'C', 2, 'WAEC', 'Since 042° is less than 180°, add 180°: 042+180 = 222° (WAEC 2010).', null),
  ('A hunter walked 250 m on a bearing of 042°. Calculate, to the nearest metre, (i) the northward distance moved (ii) the eastward distance covered.', '(i) 186 m, (ii) 167 m', '(i) 167 m, (ii) 186 m', '(i) 176 m, (ii) 177 m', '(i) 196 m, (ii) 157 m', null, 'A', 3, 'GENERAL', 'Northward (adjacent to 42°) = 250 cos42° ≈ 186 m. Eastward (opposite) = 250 sin42° ≈ 167 m.', null),
  ('A village Y is 15 km from a point X on a bearing of 025°. Village Z is 20 km from X on a bearing of 115°. Calculate the distance YZ.', '20 km', '25 km', '30 km', '35 km', null, 'B', 3, 'WAEC', 'The two bearings differ by exactly 90° (115-025), so YZ = sqrt(15^2+20^2) = sqrt(625) = 25 km, a 15-20-25 triple (WAEC 2006).', 'This is a multiple of the 3-4-5 triple.'),
  ('A boat sails 24 km from a port X on a bearing of 065° and then 10 km on a bearing of 155°. What is the distance of the boat from X?', '20 km', '23 km', '26 km', '29 km', null, 'C', 3, 'WAEC', 'The bearings differ by exactly 90° (155-065), so distance = sqrt(24^2+10^2) = sqrt(676) = 26 km, a 10-24-26 triple (a multiple of 5-12-13) (WAEC 2005).', null),
  ('Y is 60 km away from X on a bearing of 135°. Z is 80 km away from X on a bearing of 225°. Find (a) the distance ZY (b) the bearing of Z from Y.', '(a) 100 km, (b) 262°', '(a) 100 km, (b) 242°', '(a) 90 km, (b) 262°', '(a) 100 km, (b) 282°', null, 'A', 4, 'WAEC', 'The bearings differ by 90° (225-135), so ZY = sqrt(60^2+80^2) = 100 km. Resolving components gives the bearing of Z from Y ≈ 262° (WAEC 2007).', null),
  ('A ship sails 5 km due west then 7 km due south. Find, to the nearest degree, its bearing from the original position.', '196°', '206°', '216°', '226°', null, 'C', 4, 'WAEC', 'Resolving into east/north components (-5, -7) and computing the bearing from the origin gives approximately 216° (WAEC 2014).', null),
  ('Town B is 120 km from town Q in the direction bearing 050°. What is the bearing of B from Q?', '050°', '130°', '230°', '310°', null, 'A', 1, 'GENERAL', 'The direction stated, "in the direction 050°", is already the bearing of B from Q, no further calculation needed.', null),
  ('From the top of a lighthouse 75 m high, a ship is observed at an angle of depression of 18°. How far is the ship from the base of the lighthouse?', '215.85 m', '220.85 m', '225.85 m', '230.85 m', null, 'D', 3, 'GENERAL', 'The angle of elevation from the ship equals 18° (alternate angles). tan18° = 75/d, so d = 75/tan18° ≈ 230.85 m.', null),
  ('A ladder 6 m long leans against a wall, making an angle of 65° with the horizontal ground. Calculate, to 3 s.f., how far up the wall the ladder reaches.', '5.24 m', '5.34 m', '5.44 m', '5.54 m', null, 'C', 3, 'WAEC', 'Height up the wall = 6 sin65° ≈ 5.44 m (WAEC 2003).', null),
  ('A boy flies a kite with a 50 m string that makes an angle of 30° with the ground. What is the height of the kite above the ground?', '20 m', '25 m', '30 m', '35 m', null, 'B', 2, 'WAEC', 'Height = 50 sin30° = 50(0.5) = 25 m (WAEC 2005).', null),
  ('The shadow of an electric pole 75√3 m high is 75 m long. Determine the angle of elevation of the sun.', '30°', '45°', '60°', '75°', null, 'C', 3, 'WAEC', 'tan(angle) = height/shadow = 75√3/75 = √3, so the angle = tan^-1(√3) = 60° (WAEC 2014).', null),
  ('The shadow of a flagpole 25 m long is 18 m. What is the angle of elevation of the top of the flagpole, correct to 1 decimal place?', '49.2°', '51.2°', '54.2°', '57.2°', null, 'C', 3, 'WAEC', 'tan(angle) = 25/18, so angle = tan^-1(25/18) ≈ 54.2° (WAEC 2006).', null),
  ('A ladder leans against a vertical wall making an angle whose cosine is 0.6 with the ground, and the foot of the ladder is 1.2 m from the wall. Calculate the length of the ladder.', '1.60 m', '1.80 m', '2.00 m', '2.20 m', null, 'C', 2, 'WAEC', 'cos(angle) = adjacent/hypotenuse = 1.2/length = 0.6, so length = 1.2/0.6 = 2.00 m (WAEC 2006).', null),
  ('A flagpole XY of length 12 m tilts towards an observation point A at 20° to the vertical. A is level with the foot X of the flagpole and AX = 10 m. Find the angle of elevation of the top of the flagpole from A, to the nearest degree.', '46°', '49°', '51°', '54°', null, 'C', 5, 'WAEC', 'Setting up triangle AXY (AX = 10 m, XY = 12 m, with the angle at X fixed by the 20° tilt from vertical) and applying the cosine rule then the sine rule to the resulting non-right triangle gives an angle of elevation of 51° from A to the top of the flagpole, as in the original source (the exact angle at X depends on the tilt direction shown in the figure, which is needed to reconstruct every intermediate step).', null),
  ('The angle of elevation of the top of a 15 m cliff from a landmark is 60°. How far is the landmark from the foot of the cliff, in surd form?', '5√3 m', '10√3 m', '15√3 m', '5√2 m', null, 'A', 3, 'GENERAL', 'tan60° = 15/d, so d = 15/tan60° = 15/√3 = 15√3/3 = 5√3 m.', null),
  ('A ladder 16 m long leans against an electric pole, making 65° with the ground. How far up the pole does its top reach?', '12.5 m', '13.5 m', '14.5 m', '15.5 m', null, 'C', 3, 'GENERAL', 'Height up the pole = 16 sin65° ≈ 14.5 m.', null),
  ('A man stands on the ground 12 m from a building 16 m high. Find the angle of elevation of the top of the building from the man''s feet.', '43.13°', '48.13°', '53.13°', '58.13°', null, 'C', 3, 'GENERAL', 'tan(angle) = 16/12 = 4/3, so angle = tan^-1(4/3) = 53.13° (a 9-12-15 or 3-4-5-family right triangle in disguise).', null),
  ('Point A is 20 m from the foot of an electric pole of height 15 m. Calculate the angle of elevation of the top of the pole from A.', '31.87°', '34.87°', '36.87°', '39.87°', null, 'C', 3, 'GENERAL', 'tan(angle) = 15/20 = 0.75, so angle = tan^-1(0.75) = 36.87° (a 15-20-25 triple, a multiple of 3-4-5).', null),
  ('When one end of a ladder LM is placed against a wall at a point 5 m above the ground, the ladder makes 37° with the horizontal ground. (a) Calculate, to 3 s.f., the length of the ladder (b) if the foot is pushed 2 m towards the wall, calculate the new angle to the nearest degree.', '(a) ≈8.31 m, (b) ≈56°', '(a) ≈7.31 m, (b) ≈52°', '(a) ≈8.31 m, (b) ≈50°', '(a) ≈9.31 m, (b) ≈56°', null, 'A', 4, 'GENERAL', '(a) sin37° = 5/length, so length = 5/sin37° ≈ 8.31 m. (b) The foot was originally at horizontal distance sqrt(8.31^2 - 5^2) ≈ 6.64 m; pushing it 2 m closer gives a new horizontal distance of 4.64 m. The ladder length stays 8.31 m, so the new height is sqrt(8.31^2 - 4.64^2) ≈ 6.90 m, and the new angle = sin^-1(6.90/8.31) ≈ 56°.', null),
  ('From a point on the ground, the angle of elevation to the top of a tower is 30°. From a point 40 m closer, the angle of elevation is 45°. Find the height of the tower.', '49.64 m', '52.64 m', '54.64 m', '57.64 m', null, 'C', 4, 'GENERAL', 'Setting h/tan30° - h/tan45° = 40 and solving gives h ≈ 54.64 m.', 'Set up two equations, h = d tan(theta1) = (d+x) tan(theta2), and solve together rather than guessing.'),
  ('From the top of a building 40 m high, the angles of depression to two cars in line are 28° and 18°. Find the distance between the two cars.', '42.87 m', '45.87 m', '47.87 m', '50.87 m', null, 'C', 4, 'GENERAL', 'Distance from base to nearer car = 40/tan28° ≈ 75.23 m; to farther car = 40/tan18° ≈ 123.11 m. Difference ≈ 47.87 m.', null),
  ('Two buildings are 30 m apart. From the top of the shorter one (20 m), the angle of elevation to the top of the taller one is 35°. Find the height of the taller building.', '38.01 m', '39.51 m', '41.01 m', '42.51 m', null, 'C', 4, 'GENERAL', 'The extra height above the shorter building = 30 tan35° ≈ 21.01 m, so total height = 20 + 21.01 ≈ 41.01 m.', null),
  ('From a point 75 m from the base of a tower, the angle of elevation to the top is 36°. Calculate (a) the height of the tower (b) the length of the line of sight.', '(a) ≈54.5 m, (b) ≈92.7 m', '(a) ≈49.5 m, (b) ≈87.7 m', '(a) ≈54.5 m, (b) ≈97.7 m', '(a) ≈59.5 m, (b) ≈92.7 m', null, 'A', 3, 'GENERAL', '(a) Height = 75 tan36° ≈ 54.5 m. (b) Line of sight = 75/cos36° ≈ 92.7 m.', null),
  ('From the top of a 50 m lighthouse, the angles of depression to two ships on the same side are 30° and 45°. Find (a) the distance of each ship from the base (b) the distance between the ships.', '(a) ≈86.6 m and 50 m, (b) ≈36.6 m', '(a) ≈80.0 m and 50 m, (b) ≈30.0 m', '(a) ≈86.6 m and 55 m, (b) ≈31.6 m', '(a) ≈90.0 m and 50 m, (b) ≈40.0 m', null, 'A', 4, 'GENERAL', '(a) Farther ship: 50/tan30° ≈ 86.6 m. Nearer ship: 50/tan45° = 50 m. (b) Difference ≈ 36.6 m.', null),
  ('From a point on level ground, the angle of elevation to the top of a hill is 18°. After walking 200 m towards it, the angle of elevation is 26°. Find the height of the hill.', '184.7 m', '189.7 m', '194.7 m', '199.7 m', null, 'C', 5, 'GENERAL', 'Setting h(cot18° - cot26°) = 200 and solving gives h ≈ 194.7 m.', 'Two-elevation problems always reduce to h times the difference of two cotangents equalling the walked distance.')
) as v(question_text, option_a, option_b, option_c, option_d, option_e, correct_letter, difficulty, exam_type, explanation, exam_shortcut);

-- ==========================================
-- TOPIC 304: STATISTICS -- CLASS BOUNDARIES & CUMULATIVE FREQUENCY (Week 4)
-- ==========================================

with lesson as (
  insert into public.lessons (topic_id, title, summary, content_body, order_index)
  values (
    (select t.id from public.topics t join public.curricula c on c.id = t.curriculum_id
     where c.subject = 'Mathematics' and t.class_level = 'SS2' and t.term = 3 and t.order_index = 304),
    'Statistics: Class Boundaries and Cumulative Frequency',
    'Class widths, class boundaries, class marks, and building a cumulative frequency table for grouped data.',
    '**Glossary.** **Frequency** is how many times a value occurs in a data set. **Discrete data** takes countable, specific values (e.g. number of children in a family); **continuous data** takes measurable values within a range (e.g. heights, weights) and is grouped into **class intervals** when there are too many distinct values to list one by one. The **class width (size)** is the upper limit minus the lower limit of an interval. The **class boundaries** are the "true" limits of a class, found by subtracting 0.5 from the lower limit and adding 0.5 to the upper limit for whole-number data (e.g. the class 20-29 has boundaries 19.5-29.5). The **class mark (midpoint)** is $(\text{lower limit} + \text{upper limit}) \div 2$. **Cumulative frequency** is the running total of frequencies up to and including each class.

A **histogram** displays a grouped frequency distribution as adjoining bars whose width represents the class boundaries and whose height represents frequency (or frequency density, for classes of unequal width).

**Finding boundaries:** whatever gap sits between one class''s upper limit and the next class''s lower limit, the boundaries are found by subtracting/adding half that gap. For whole-number data (gap = 1) this is always $\pm 0.5$; for data given to 1 decimal place (gap = 0.1) it becomes $\pm 0.05$.',
    1
  )
  returning id
),
we1 as (
  insert into public.worked_examples (lesson_id, title, problem_statement, solution_steps, exam_shortcut, status)
  select id,
    'Finding Class Boundaries',
    'Find the class boundaries for the class interval 20-29.',
    to_jsonb(array[
      'Consecutive classes (e.g. 20-29 and 30-39) leave a gap of 1 unit between the upper limit of one and the lower limit of the next, so half of this gap (0.5) is added/subtracted at each end.',
      'Lower boundary $= 20 - 0.5 = 19.5$.',
      'Upper boundary $= 29 + 0.5 = 29.5$.'
    ]),
    'For whole-number data, boundaries are always the limits plus or minus 0.5, do not blindly apply this to decimal data where the gap between classes is smaller.',
    'published'
  from lesson
  returning id
),
we2 as (
  insert into public.worked_examples (lesson_id, title, problem_statement, solution_steps, status)
  select lesson.id,
    'Finding a Class Midpoint',
    'Calculate the class midpoint for the class 35-44.',
    to_jsonb(array[
      'Recall the formula: midpoint $= (\text{lower limit} + \text{upper limit}) \div 2$.',
      'Substitute: midpoint $= (35 + 44) \div 2 = 79 \div 2$.',
      'Divide: $79 \div 2 = 39.5$.'
    ]),
    'published'
  from lesson
  returning id
)
insert into public.worked_examples (lesson_id, title, problem_statement, solution_steps, real_life_context, exam_shortcut, diagram_type, diagram_data, status)
select lesson.id,
  'Full Grouped Table: Totals, Modal Class, Cumulative Frequency',
  'The weights (kg) of 50 students are grouped as: 40-44 (5), 45-49 (8), 50-54 (14), 55-59 (12), 60-64 (7), 65-69 (4). Find (a) the total number of students (b) the modal class (c) the cumulative frequency table.',
  to_jsonb(array[
    'For (a), add all the frequencies: $5+8+14+12+7+4 = 50$, matching the stated total and confirming the table is complete.',
    'For (b), compare the frequencies (5, 8, 14, 12, 7, 4): the largest is 14, belonging to class 50-54.',
    'For (c), build the cumulative frequency running total: $5 \to 5+8=13 \to 13+14=27 \to 27+12=39 \to 39+7=46 \to 46+4=50$.'
  ]),
  'A school nurse recording the weights of an entire JSS/SS class for a health screening builds exactly this kind of grouped table before deciding which weight range needs the most attention, the modal class instantly shows where most students fall.',
  'The last cumulative frequency value must always equal the grand total, an instant check that flags any arithmetic slip.',
  'bar_chart',
  '{"categories": ["40-44", "45-49", "50-54", "55-59", "60-64", "65-69"], "values": [5, 8, 14, 12, 7, 4], "yLabel": "Number of Students"}'::jsonb,
  'published'
from lesson;

insert into public.questions (topic_id, question_text, option_a, option_b, option_c, option_d, option_e, correct_letter, difficulty, exam_type, explanation, exam_shortcut, status)
select topic_ref.tid, v.question_text, v.option_a, v.option_b, v.option_c, v.option_d, v.option_e, v.correct_letter, v.difficulty, v.exam_type, v.explanation, v.exam_shortcut, 'published'
from (select t.id as tid from public.topics t join public.curricula c on c.id = t.curriculum_id
      where c.subject = 'Mathematics' and t.class_level = 'SS2' and t.term = 3 and t.order_index = 304) topic_ref,
lateral (values
  ('Define the term "frequency" in statistics.', 'The number of times a particular value or event occurs in a data set', 'The total number of classes in a table', 'The width of a class interval', 'The middle value of a data set', null::text, 'A', 1, 'GENERAL'::exam_type, 'Frequency is simply the count of how many times a particular value or event occurs.', null),
  ('What is the difference between grouped and ungrouped data?', 'They are exactly the same thing', 'Ungrouped data lists each distinct value with its frequency; grouped data pools values into class intervals when there are too many distinct values', 'Grouped data can only be discrete; ungrouped data can only be continuous', 'Grouped data has no frequencies at all', null, 'B', 1, 'GENERAL', 'Ungrouped data lists individual values with their frequencies directly; grouped data bundles values into class intervals, usually because there are too many distinct values to list one by one.', null),
  ('Calculate the class width for the class interval 30-39.', '8', '9', '10', '11', null, 'C', 1, 'GENERAL', 'Using the boundaries (29.5 to 39.5), the class width is 39.5 - 29.5 = 10.', 'Class width is upper boundary minus lower boundary.'),
  ('If a frequency table has classes 10-14, 15-19, 20-24, what are the class boundaries for 15-19?', '14.5-19.5', '15.5-19.5', '14.5-20.5', '15-19', null, 'A', 1, 'GENERAL', 'Subtract 0.5 from the lower limit and add 0.5 to the upper limit: 15-0.5=14.5, 19+0.5=19.5.', null),
  ('If the frequencies are 5, 8, 12, 7, what are the cumulative frequencies?', '5, 13, 20, 27', '5, 13, 25, 32', '5, 12, 20, 27', '5, 13, 25, 30', null, 'B', 1, 'GENERAL', 'Running total: 5, 5+8=13, 13+12=25, 25+7=32.', 'The last cumulative frequency must equal the sum of all frequencies (5+8+12+7=32).'),
  ('The ages of 20 people are: 25, 32, 28, 35, 42, 38, 29, 33, 27, 31, 34, 40, 26, 37, 30, 36, 28, 41, 33, 39. Construct a grouped frequency table using class intervals of width 5, starting from 25.', '25-29(6), 30-34(6), 35-39(6), 40-44(2)', '25-29(6), 30-34(6), 35-39(5), 40-44(3)', '25-29(5), 30-34(7), 35-39(5), 40-44(3)', '25-29(6), 30-34(5), 35-39(6), 40-44(3)', null, 'B', 3, 'GENERAL', 'Sorting the 20 ages into the classes 25-29, 30-34, 35-39, 40-44 gives frequencies 6, 6, 5, 3 (summing to 20): 25-29 holds 25,26,27,28,28,29; 30-34 holds 30,31,32,33,33,34; 35-39 holds 35,36,37,38,39; 40-44 holds 40,41,42.', null),
  ('For the frequency table: 1-10 (3), 11-20 (7), 21-30 (12), 31-40 (10), 41-50 (8), calculate the cumulative frequency.', '3, 10, 22, 32, 40', '3, 10, 22, 30, 40', '3, 9, 22, 32, 40', '3, 10, 21, 32, 40', null, 'A', 2, 'GENERAL', 'Running total: 3, 3+7=10, 10+12=22, 22+10=32, 32+8=40.', null),
  ('The marks scored by 30 students range from 45 to 78. If 7 classes are used, what should the class width be?', '4', '5', '6', '7', null, 'B', 2, 'GENERAL', 'The range is 78-45=33. Dividing by 7 classes gives 33/7 ≈ 4.71, rounded up to a class width of 5 so every mark is covered (giving classes 45-49, 50-54, ..., 75-79).', 'Always round the class width up, never down, so the last class comfortably includes the maximum value.'),
  ('The goals scored by a football team in 15 matches were: 2, 0, 1, 3, 2, 1, 0, 2, 4, 1, 2, 3, 1, 2, 0. What is the frequency of scoring exactly 2 goals?', '3', '4', '5', '6', null, 'C', 2, 'GENERAL', 'Counting the occurrences of 2 in the list gives 5 matches (positions with value 2), out of 15 total matches (0 appears 3 times, 1 appears 4 times, 2 appears 5 times, 3 appears 2 times, 4 appears once, total 3+4+5+2+1=15).', null),
  ('A frequency table has classes 14-15 (8), 16-17 (x), 18-19 (15), 20-21 (y), total 40 students, with twice as many students in 16-17 as in 20-21 (x = 2y). Which pair of equations correctly models this situation?', 'x = 2y and 8 + x + 15 + y = 40', 'x = 2y and x + y = 40', 'y = 2x and 8 + x + 15 + y = 40', 'x + y = 8 and x = 2y', null, 'A', 3, 'GENERAL', 'The total-frequency condition gives 8 + x + 15 + y = 40, i.e. x + y = 17, combined with the "twice as many" condition x = 2y. (Solving these two equations together gives y = 17/3, which is not a whole number, so this particular combination of numbers has no exact integer solution, a genuine inconsistency already noted in the original source; the value of setting up the correct pair of equations is still fully testable.)', null),
  ('Complete the cumulative frequency table for classes 0-4 (5), 5-9 (8), 10-14 (12), 15-19 (10), 20-24 (5).', '5, 13, 25, 35, 40', '5, 13, 24, 35, 40', '5, 12, 25, 35, 40', '5, 13, 25, 34, 40', null, 'A', 2, 'GENERAL', 'Running total: 5, 5+8=13, 13+12=25, 25+10=35, 35+5=40.', null),
  ('The ages of 25 teachers range from 27 to 48. If 5 classes are to be used for a grouped frequency distribution, what class width and starting classes would correctly cover the range?', 'Width 5, classes starting 27-31, 32-36, 37-41, 42-46, 47-51', 'Width 4, classes starting 27-30, 31-34, 35-38, 39-42, 43-46', 'Width 5, classes starting 25-29, 30-34, 35-39, 40-44, 45-49', 'Width 3, classes starting 27-29, 30-32, 33-35, 36-38, 39-41', null, 'A', 3, 'GENERAL', 'The range is 48-27+1=22. Dividing by 5 classes gives 22/5=4.4, rounded up to a class width of 5, giving classes 27-31, 32-36, 37-41, 42-46, 47-51, which together cover every age from 27 to 51 (comfortably including 48).', 'Always round the computed class width up to the next whole number so the classes fully cover the data range.'),
  ('For the distribution: 1-5 (4), 6-10 (7), 11-15 (12), 16-20 (10), 21-25 (7), calculate (a) total frequency (b) cumulative frequency for each class.', '(a) 40, (b) 4, 11, 23, 33, 40', '(a) 40, (b) 4, 11, 22, 33, 40', '(a) 38, (b) 4, 11, 23, 33, 38', '(a) 40, (b) 4, 12, 23, 33, 40', null, 'A', 3, 'GENERAL', '(a) 4+7+12+10+7=40. (b) Running total: 4, 4+7=11, 11+12=23, 23+10=33, 33+7=40.', null),
  ('A frequency distribution shows classes 20-24, 25-29, 30-34, 35-39, 40-44 with frequencies 5, 8, x, 10, 4 and total frequency 35. Find x.', '6', '7', '8', '9', null, 'C', 2, 'GENERAL', '5+8+x+10+4=35, so 27+x=35, giving x=8.', null)
) as v(question_text, option_a, option_b, option_c, option_d, option_e, correct_letter, difficulty, exam_type, explanation, exam_shortcut);

-- ==========================================
-- TOPIC 305: CUMULATIVE FREQUENCY CURVE (OGIVE) (Week 5)
-- ==========================================

with lesson as (
  insert into public.lessons (topic_id, title, summary, content_body, order_index)
  values (
    (select t.id from public.topics t join public.curricula c on c.id = t.curriculum_id
     where c.subject = 'Mathematics' and t.class_level = 'SS2' and t.term = 3 and t.order_index = 305),
    'Cumulative Frequency Curve (Ogive)',
    'Drawing an ogive and using it to read off the median, quartiles, percentiles, and deciles of grouped data.',
    '**Glossary.** An **ogive** is a smooth S-shaped curve plotting cumulative frequency (on the y-axis) against the **upper class boundary** of each class (on the x-axis), starting from the point (lower boundary of the first class, 0). A **quartile** divides an ordered data set into 4 equal parts ($Q_1$ at one quarter of the way through, $Q_2$ at the halfway point, $Q_3$ at three quarters). A **percentile** divides the data into 100 equal parts; a **decile** divides it into 10 equal parts. The **interquartile range (IQR)** is $Q_3 - Q_1$, a measure of spread that ignores the most extreme quarter at each end.

Reading values from the ogive, where $n$ is the total frequency:
- **Median:** at cumulative frequency $n/2$.
- **Quartiles:** $Q_1$ at $n/4$, $Q_2$ (the median) at $n/2$, $Q_3$ at $3n/4$.
- **Percentiles:** $P_k$ at $(k/100) \times n$.
- **Deciles:** $D_k$ at $(k/10) \times n$ (e.g. $D_5$ at $n/2$, the same point as the median).

In every case, first find the *position* (a cumulative-frequency value) using simple arithmetic, then draw a horizontal line from that position to the curve, and drop a vertical line to the x-axis to read the corresponding data value. A ruled straight-edge, not a freehand line, should always be used for both traces.',
    1
  )
  returning id
),
we1 as (
  insert into public.worked_examples (lesson_id, title, problem_statement, solution_steps, real_life_context, exam_shortcut, status)
  select id,
    'Reading the Median from an Ogive',
    'The table shows test scores of 50 students grouped 0-9, 10-19, ..., 50-59 with cumulative frequencies 3, 10, 22, 37, 47, 50. Estimate the median.',
    to_jsonb(array[
      'The total frequency $n$ is the last cumulative frequency value: $n = 50$.',
      'The median''s cumulative frequency position is $n/2 = 50/2 = 25$.',
      'Draw a horizontal line from cumulative frequency 25 on the y-axis across to where it meets the curve.',
      'Drop a vertical line from that point on the curve down to the x-axis, this is the median mark, approximately 32 marks.'
    ]),
    'A school''s exams office estimating the "typical" score on a difficult test, without listing all 50 individual scores, reads the median straight off an ogive built from the grouped mark distribution exactly this way.',
    '"Position first, value second," always find the cumulative-frequency position with arithmetic before looking at the curve.',
    'published'
  from lesson
  returning id
)
insert into public.worked_examples (lesson_id, title, problem_statement, solution_steps, exam_shortcut, common_trap_warning, status)
select lesson.id,
  'Reading Quartiles and the Interquartile Range',
  'From the ogive in the previous example (n = 50), estimate (a) Q1 (b) Q3 (c) the interquartile range.',
  to_jsonb(array[
    'Find Q1''s position: $Q_1$ is at $n/4 = 50/4 = 12.5$ on the cumulative frequency axis. Reading across from 12.5 and down to the x-axis gives $Q_1 \approx 22$.',
    'Find Q3''s position: $Q_3$ is at $3n/4 = 3 \times 50/4 = 37.5$. Reading across from 37.5 and down gives $Q_3 \approx 40$.',
    'Subtract to find the IQR: $\text{IQR} = Q_3 - Q_1 = 40 - 22 = 18$ marks.'
  ]),
  'Once Q1 and Q3 are read, both the IQR and the semi-interquartile range (IQR divided by 2) come from the same two readings, no need to re-derive either from scratch.',
  'Never try to eyeball the quartile value directly off the curve without first computing its cumulative-frequency position, this is the most common source of lost marks on ogive questions.',
  'published'
from lesson;

insert into public.questions (topic_id, question_text, option_a, option_b, option_c, option_d, option_e, correct_letter, difficulty, exam_type, explanation, exam_shortcut, status)
select topic_ref.tid, v.question_text, v.option_a, v.option_b, v.option_c, v.option_d, v.option_e, v.correct_letter, v.difficulty, v.exam_type, v.explanation, v.exam_shortcut, 'published'
from (select t.id as tid from public.topics t join public.curricula c on c.id = t.curriculum_id
      where c.subject = 'Mathematics' and t.class_level = 'SS2' and t.term = 3 and t.order_index = 305) topic_ref,
lateral (values
  ('What is an ogive and what does it show?', 'A bar chart of raw frequencies', 'A smooth cumulative-frequency curve, showing the running total of frequencies against upper class boundaries', 'A pie chart of proportional data', 'A scatter plot of two variables', null::text, 'B', 1, 'GENERAL'::exam_type, 'An ogive is a smooth S-shaped curve that plots the running total (cumulative frequency) against the upper class boundary of each class.', null),
  ('On which axis do we plot cumulative frequencies?', 'The x-axis, against class width', 'The y-axis, against upper class boundaries on the x-axis', 'Cumulative frequency is not plotted on an ogive', 'The y-axis, against class midpoints on the x-axis', null, 'B', 1, 'GENERAL', 'Cumulative frequency goes on the y-axis; the x-axis carries the upper class boundary of each class.', null),
  ('If the total frequency is 60, at what cumulative frequency value would you find the median?', '15', '20', '30', '60', null, 'C', 1, 'GENERAL', 'The median is at position n/2 = 60/2 = 30.', null),
  ('What is the interquartile range and how is it calculated from an ogive?', 'Q1 + Q3, read at n/4 and 3n/4', 'Q3 - Q1, read at n/4 and 3n/4', 'Q3 - Q1, read at n/2 and 3n/4', 'The median minus the mean', null, 'B', 2, 'GENERAL', 'The IQR is Q3 - Q1, where Q1 is read at cumulative frequency n/4 and Q3 at 3n/4.', null),
  ('For classes 0-9 (5), 10-19 (8), 20-29 (12), 30-39 (10), 40-49 (5) (n=40), estimate the median from the cumulative frequency curve.', '≈21', '≈26', '≈31', '≈36', null, 'B', 3, 'GENERAL', 'Cumulative frequencies are 5, 13, 25, 35, 40. The median is at position n/2=20, which falls in class 20-29 (cf runs from 13 to 25), reading the ogive at cf=20 gives a median of approximately 26.', null),
  ('From an ogive with total frequency 100 showing Q1=25, median=35, Q3=45: calculate (a) the interquartile range (b) the semi-interquartile range (c) the percentage of data between Q1 and Q3.', '(a) 20, (b) 10, (c) 50%', '(a) 20, (b) 20, (c) 25%', '(a) 10, (b) 5, (c) 50%', '(a) 20, (b) 10, (c) 25%', null, 'A', 2, 'GENERAL', '(a) IQR = 45-25=20. (b) Semi-IQR = 20/2=10. (c) By definition, exactly the middle 50% of the data lies between Q1 and Q3.', null),
  ('Ages of 100 people: 10-19 (15), 20-29 (25), 30-39 (30), 40-49 (20), 50-59 (10). Use the cumulative frequency curve to estimate the median age, Q1, Q3, and the IQR.', 'median≈33, Q1≈24, Q3≈42, IQR≈18', 'median≈35, Q1≈25, Q3≈45, IQR≈20', 'median≈33, Q1≈20, Q3≈45, IQR≈25', 'median≈30, Q1≈24, Q3≈40, IQR≈16', null, 'A', 4, 'GENERAL', 'Cumulative frequencies are 15, 40, 70, 90, 100. Median at cf=50 falls in class 30-39, giving ≈33. Q1 at cf=25 falls in class 20-29, giving ≈24 (more precisely 23.5 by interpolation). Q3 at cf=75 falls in class 40-49, giving ≈42. IQR = 42-24 ≈ 18.', null),
  ('From an ogive with total frequency 80: (a) at what cumulative frequency is Q1? (b) at what cumulative frequency is Q3? (c) if Q1=30 and Q3=50, find the semi-interquartile range.', '(a) 20, (b) 60, (c) 10', '(a) 20, (b) 40, (c) 10', '(a) 40, (b) 60, (c) 20', '(a) 20, (b) 60, (c) 20', null, 'A', 2, 'GENERAL', '(a) Q1 position = 80/4=20. (b) Q3 position = 3(80)/4=60. (c) Semi-IQR = (50-30)/2=10.', null),
  ('Explain the difference between (a) a "less than" ogive and a "more than" ogive (b) median and upper quartile.', '(a) "less than" plots cumulative counts below each upper boundary and rises; "more than" plots counts above each lower boundary and falls. (b) median is the 50th-percentile middle value, upper quartile is the 75th-percentile value', '(a) both rise identically. (b) they are the same statistic', '(a) "less than" falls, "more than" rises. (b) median is the mode', '(a) they only differ in colour on the graph. (b) upper quartile is always double the median', null, 'A', 2, 'GENERAL', 'A "less than" ogive plots the running total below each upper boundary and rises left to right; a "more than" ogive plots the running total above each lower boundary and falls left to right. The median is the middle (50th percentile) value; the upper quartile (Q3) is the 75th percentile value.', null),
  ('An ogive shows 25 students scored below 50 marks and 60 scored below 70 marks, out of 80. (a) How many scored between 50 and 70? (b) How many scored above 70? (c) What percentage scored below 50?', '(a) 35, (b) 20, (c) 31.25%', '(a) 30, (b) 25, (c) 31.25%', '(a) 35, (b) 15, (c) 33.75%', '(a) 35, (b) 20, (c) 25%', null, 'A', 3, 'GENERAL', '(a) 60-25=35. (b) 80-60=20. (c) 25/80×100=31.25%.', '"Between a and b" for cumulative frequency values is always a subtraction, never a re-count.'),
  ('For marks grouped 20-29 (8), 30-39 (15), 40-49 (22), 50-59 (18), 60-69 (12), 70-79 (5) (n=80), estimate the 30th percentile from the ogive.', '≈35', '≈40', '≈45', '≈50', null, 'B', 4, 'GENERAL', 'P30 is at position 0.30×80=24, which falls in class 30-39 (cumulative frequencies run 8, 23, 45, 63, 75, 80). Interpolating within that class gives P30 ≈ 40.', null),
  ('A table of 200 candidates'' marks in classes of width 10 gives Q1=34.5 and Q3=58.5. What is the interquartile range?', '20', '22', '24', '26', null, 'C', 2, 'GENERAL', 'IQR = Q3 - Q1 = 58.5 - 34.5 = 24.', null),
  ('D1 (the first decile) is at what fraction of the cumulative frequency, and D5 is equivalent to which other statistic?', 'D1 = 1/5; D5 = mode', 'D1 = 1/10; D5 = median', 'D1 = 1/100; D5 = Q1', 'D1 = 1/10; D5 = Q3', null, 'B', 2, 'GENERAL', 'D1 is at 1/10 of the cumulative frequency; D5 is at 5/10 = 1/2 of the cumulative frequency, exactly the same position as the median.', 'Q2 = median = D5 = P50, one point on the curve with four names.'),
  ('From a table of 50 students'' marks in classes 1-10 to 41-50: the median (at cf=25) corresponds to mark 32, and Q1 (at cf=12.5) corresponds to mark 22. If Q3 ≈ 40, estimate the interquartile range.', '16 marks', '18 marks', '20 marks', '22 marks', null, 'B', 2, 'GENERAL', 'IQR = Q3 - Q1 = 40 - 22 = 18 marks.', null)
) as v(question_text, option_a, option_b, option_c, option_d, option_e, correct_letter, difficulty, exam_type, explanation, exam_shortcut);

-- ==========================================
-- TOPIC 306: MEAN, MEDIAN & MODE OF GROUPED DATA (Week 7)
-- ==========================================

with lesson as (
  insert into public.lessons (topic_id, title, summary, content_body, order_index)
  values (
    (select t.id from public.topics t join public.curricula c on c.id = t.curriculum_id
     where c.subject = 'Mathematics' and t.class_level = 'SS2' and t.term = 3 and t.order_index = 306),
    'Mean, Median and Mode of Grouped Data',
    'Calculating the three measures of central tendency from a grouped frequency table, and comparing them to judge skewness.',
    '**Glossary.** The **mean** is the arithmetic average of a data set. The **median** is the middle value when data is ordered. The **mode** is the most frequently occurring value; for grouped data, the class with the highest frequency is the **modal class**. A distribution is **positively skewed** when it has a long tail towards higher values (mode < median < mean), and **negatively skewed** when it has a long tail towards lower values (mean < median < mode).

**Mean:** $\bar{x} = \dfrac{\Sigma(fx)}{\Sigma f}$, where $x$ is the class midpoint and $f$ is the frequency of each class.

**Median (grouped data):** $\text{Median} = L + \left[\dfrac{n/2 - CF_b}{f_m}\right] \times c$, where $L$ is the lower boundary of the median class (the class where the cumulative frequency first reaches or exceeds $n/2$), $CF_b$ is the cumulative frequency before the median class, $f_m$ is the frequency of the median class, and $c$ is the class width.

**Mode (grouped data):** the modal class is simply the class with the highest frequency (no calculation needed to identify it). A precise numeric estimate uses $\text{Mode} = L + \left[\dfrac{f_1 - f_0}{2f_1 - f_0 - f_2}\right] \times c$, where $L$ is the lower boundary of the modal class, $f_1$ its frequency, $f_0$ the frequency of the class before, $f_2$ the frequency of the class after, and $c$ the class width.

**Comparing the three measures:** in a symmetrical distribution, mean = median = mode. The mean uses every data point but is easily distorted by extreme values; the median is unaffected by extremes and suits skewed data; the mode shows the single most typical value. A quick approximate check: $\text{Mean} \approx \dfrac{\text{Mode} + 2 \times \text{Median}}{3}$.',
    1
  )
  returning id
),
we1 as (
  insert into public.worked_examples (lesson_id, title, problem_statement, solution_steps, real_life_context, exam_shortcut, diagram_type, diagram_data, status)
  select id,
    'Mean of a Grouped Distribution',
    'For the distribution 20-29(5), 30-39(8), 40-49(12), 50-59(10), 60-69(5) (total frequency 40), calculate the mean.',
    to_jsonb(array[
      'Find the midpoint of each class: $20\text{-}29 \to 24.5$, $30\text{-}39 \to 34.5$, $40\text{-}49 \to 44.5$, $50\text{-}59 \to 54.5$, $60\text{-}69 \to 64.5$.',
      'Multiply each midpoint by its frequency ($fx$): $5 \times 24.5 = 122.5$; $8 \times 34.5 = 276$; $12 \times 44.5 = 534$; $10 \times 54.5 = 545$; $5 \times 64.5 = 322.5$.',
      'Sum the $fx$ column: $\Sigma(fx) = 122.5+276+534+545+322.5 = 1800$.',
      'Confirm $\Sigma f = 5+8+12+10+5 = 40$.',
      'Divide: $\text{Mean} = \Sigma(fx)/\Sigma f = 1800/40 = 45$.'
    ]),
    'A shop owner tracking daily sales amounts grouped into ranges over a month uses this exact fx-column method to find the "average" daily sale, without ever having to write down each individual sale amount.',
    'Build one table with midpoint, f, fx, and cumulative frequency all at once, this single table supplies the mean, median class, and modal class together, no need for separate tables.',
    'bar_chart',
    '{"categories": ["20-29", "30-39", "40-49", "50-59", "60-69"], "values": [5, 8, 12, 10, 5], "yLabel": "Frequency"}'::jsonb,
    'published'
  from lesson
  returning id
),
we2 as (
  insert into public.worked_examples (lesson_id, title, problem_statement, solution_steps, exam_shortcut, status)
  select lesson.id,
    'Median of a Grouped Distribution',
    'Find the median for the same distribution: 20-29(5), 30-39(8), 40-49(12), 50-59(10), 60-69(5).',
    to_jsonb(array[
      'Build the cumulative frequency column: $5, 5+8=13, 13+12=25, 25+10=35, 35+5=40$.',
      'Find the median position: $n/2 = 40/2 = 20$.',
      'Identify the median class: the first cumulative frequency $\geq 20$ is 25, in class 40-49, so this is the median class.',
      'Read off the values needed: $L = 39.5$ (lower boundary of 40-49); $CF_b = 13$ (cumulative frequency before this class); $f_m = 12$ (frequency of this class); $c = 10$ (class width).',
      'Substitute into the median formula: $\text{Median} = 39.5 + \left[\dfrac{20-13}{12}\right] \times 10 = 39.5 + \dfrac{7}{12} \times 10$.',
      'Evaluate: $\dfrac{7}{12} \times 10 \approx 5.83$, so $\text{Median} \approx 39.5 + 5.83 = 45.33$.'
    ]),
    'Median class is not the same as modal class, do not confuse "highest frequency" (modal class) with "the class where the running total first reaches n/2" (median class).',
    'published'
  from lesson
  returning id
)
insert into public.worked_examples (lesson_id, title, problem_statement, solution_steps, exam_shortcut, common_trap_warning, status)
select lesson.id,
  'Modal Class and Estimated Mode',
  'Find the modal class and estimate the mode for the same distribution: 20-29(5), 30-39(8), 40-49(12), 50-59(10), 60-69(5).',
  to_jsonb(array[
    'Identify the modal class by scanning the frequencies (5, 8, 12, 10, 5): the highest is 12, in class 40-49.',
    'Read off the values needed for the mode formula: $L = 39.5$ (lower boundary of the modal class); $f_1 = 12$ (modal class frequency); $f_0 = 8$ (frequency of the class before, 30-39); $f_2 = 10$ (frequency of the class after, 50-59); $c = 10$.',
    'Substitute into the mode formula: $\text{Mode} = 39.5 + \left[\dfrac{12-8}{2(12)-8-10}\right] \times 10 = 39.5 + \dfrac{4}{6} \times 10$.',
    'Evaluate: $\dfrac{4}{6} \times 10 \approx 6.67$, so $\text{Mode} \approx 39.5 + 6.67 = 46.17$.'
  ]),
  'The empirical shortcut $\text{Mean} \approx (\text{Mode} + 2 \times \text{Median})/3$ gives a fast approximate check on a calculated mean when a distribution is only mildly skewed, use it to catch large errors, not as a final answer.',
  'The modal class needs no calculation at all, just scan the frequency column for the single largest number, computing anything for it wastes exam time.',
  'published'
from lesson;

insert into public.questions (topic_id, question_text, option_a, option_b, option_c, option_d, option_e, correct_letter, difficulty, exam_type, explanation, exam_shortcut, status)
select topic_ref.tid, v.question_text, v.option_a, v.option_b, v.option_c, v.option_d, v.option_e, v.correct_letter, v.difficulty, v.exam_type, v.explanation, v.exam_shortcut, 'published'
from (select t.id as tid from public.topics t join public.curricula c on c.id = t.curriculum_id
      where c.subject = 'Mathematics' and t.class_level = 'SS2' and t.term = 3 and t.order_index = 306) topic_ref,
lateral (values
  ('What is the formula for calculating the mean from grouped data?', 'x-bar = Sigma(f) / Sigma(x)', 'x-bar = Sigma(fx) / Sigma(f), where x is the class midpoint', 'x-bar = Sigma(x) / n', 'x-bar = highest frequency / total frequency', null::text, 'B', 1, 'GENERAL'::exam_type, 'The grouped mean is the sum of each class midpoint times its frequency, divided by the total frequency: Sigma(fx)/Sigma(f).', null),
  ('Define the median class.', 'The class with the highest frequency', 'The class in which the cumulative frequency first reaches or exceeds n/2', 'The first class in the table', 'The class with the smallest frequency', null, 'B', 1, 'GENERAL', 'The median class is identified by tracking the cumulative frequency running total until it first reaches or exceeds n/2.', null),
  ('Calculate the mean for: 10-14(5), 15-19(8), 20-24(12), 25-29(7), 30-34(3).', '19.3', '20.3', '21.3', '22.3', null, 'C', 3, 'GENERAL', 'Midpoints 12,17,22,27,32; fx = 60,136,264,189,96; Sigma(fx)=745; Sigma(f)=35; mean = 745/35 ≈ 21.3.', null),
  ('If Mean < Median < Mode for a distribution, what does this tell you about its shape?', 'It is symmetric', 'It is positively skewed, a longer tail towards higher values', 'It is negatively skewed, a longer tail towards lower values', 'It has no mode', null, 'C', 2, 'GENERAL', 'Mean < Median < Mode is the defining pattern of a negatively skewed distribution (a longer tail towards lower values).', null),
  ('Which measure of central tendency is best for data with extreme values, and why?', 'The mean, because it uses every value', 'The mode, because it ignores extreme values entirely', 'The median, because it is not affected by unusually high or low outliers', 'The range, because it measures spread', null, 'C', 2, 'GENERAL', 'The median is resistant to outliers since it depends only on the middle position of ordered data, not on the magnitude of extreme values.', null),
  ('The masses (kg) of 50 students are grouped 40-44(5), 45-49(8), 50-54(15), 55-59(12), 60-64(7), 65-69(3). Calculate (a) the mean mass (b) the median mass (c) the modal class.', '(a) 53.7 kg, (b) 53.5 kg, (c) 50-54', '(a) 52.7 kg, (b) 52.5 kg, (c) 55-59', '(a) 53.7 kg, (b) 54.5 kg, (c) 50-54', '(a) 54.7 kg, (b) 53.5 kg, (c) 45-49', null, 'A', 4, 'GENERAL', 'Mean = Sigma(fx)/50 = 2685/50 = 53.7 kg. Cumulative frequencies 5,13,28,40,47,50; median position 25 falls in class 50-54 (boundary 49.5-54.5, CFb=13, fm=15, c=5): median = 49.5+(25-13)/15x5 = 53.5 kg. Modal class = 50-54 (highest frequency, 15).', null),
  ('If mean = 42, median = 45, mode = 48 for a distribution, comment on its skew.', 'Symmetric', 'Positively skewed', 'Negatively skewed (mode > median > mean)', 'Cannot be determined', null, 'C', 2, 'GENERAL', 'Mode (48) > median (45) > mean (42) is exactly the negatively-skewed pattern.', null),
  ('A distribution has Sigma(f) = 50 and Sigma(fx) = 1750. What is the mean?', '30', '32.5', '35', '37.5', null, 'C', 1, 'GENERAL', 'Mean = Sigma(fx)/Sigma(f) = 1750/50 = 35.', null),
  ('In a distribution, the median class is 30-39 with lower boundary 29.5, frequency 10, cumulative frequency before it 18, total frequency 60, class width 10. Calculate the median.', '39.5', '40.5', '41.5', '42.5', null, 'C', 3, 'GENERAL', 'Median = 29.5 + [(30-18)/10] x 10 = 29.5 + 12 = 41.5.', null),
  ('For the distribution 1-10(4), 11-20(6), 21-30(10), 31-40(8), 41-50(2), calculate the mean, median, and modal class.', 'mean ≈ 24.83, median = 25.5, modal class = 21-30', 'mean ≈ 22.83, median = 23.5, modal class = 11-20', 'mean ≈ 24.83, median = 24.5, modal class = 31-40', 'mean ≈ 26.83, median = 25.5, modal class = 21-30', null, 'A', 4, 'GENERAL', 'Midpoints 5.5,15.5,25.5,35.5,45.5; fx=22,93,255,284,91; Sigma(fx)=745; Sigma(f)=30; mean≈24.83. Cumulative frequencies 4,10,20,28,30; median position 15 falls in class 21-30 (boundary 20.5-30.5, CFb=10, fm=10, c=10): median=20.5+(15-10)/10x10=25.5. Modal class=21-30 (highest frequency, 10).', null),
  ('The mean age of 40 students is 16 years. If 10 new students with mean age 18 join, find the new overall mean age.', '16.0 years', '16.4 years', '16.8 years', '17.0 years', null, 'B', 3, 'GENERAL', 'Total age = 40(16) + 10(18) = 640+180 = 820. New mean = 820/50 = 16.4 years.', null),
  ('In a grouped distribution with 5 classes, the mean is 45. The first four classes contribute 1620 to Sigma(fx) with total frequency 38, while the overall total frequency is 48. Find the midpoint of the fifth class.', '48', '51', '54', '57', null, 'C', 4, 'GENERAL', 'Overall Sigma(fx) = 45 x 48 = 2160. Fifth class fx = 2160-1620 = 540, with frequency 48-38=10, so midpoint = 540/10 = 54.', null),
  ('Weekly wages (in thousands of naira) of 50 workers: 10-19(8), 20-29(12), 30-39(15), 40-49(10), 50-59(5). Calculate (a) the mean wage (b) the median wage (c) the modal class.', '(a) ≈32.9, (b) ≈32.83, (c) 30-39', '(a) ≈30.9, (b) ≈30.83, (c) 20-29', '(a) ≈32.9, (b) ≈34.83, (c) 30-39', '(a) ≈34.9, (b) ≈32.83, (c) 40-49', null, 'A', 4, 'GENERAL', 'Midpoints 14.5,24.5,34.5,44.5,54.5; fx=116,294,517.5,445,272.5; Sigma(fx)=1645; mean=1645/50=32.9. Cumulative frequencies 8,20,35,45,50; median position 25 falls in class 30-39 (boundary 29.5-39.5, CFb=20, fm=15, c=10): median=29.5+(25-20)/15x10≈32.83. Modal class=30-39 (highest frequency, 15).', 'A trader tracking weekly wage bills in thousands of naira builds exactly this kind of table before deciding on a typical pay level.'),
  ('In a distribution, the median is 42 and the mode is 45, with the distribution only moderately skewed. Estimate the mean using Mean ≈ (Mode + 2xMedian)/3.', '41', '42', '43', '44', null, 'C', 2, 'GENERAL', 'Mean ≈ (45 + 2x42)/3 = (45+84)/3 = 129/3 = 43.', null),
  ('The mean of 20 numbers is 35. When one number is removed, the mean of the remaining 19 becomes 34. Find the removed number.', '44', '49', '54', '59', null, 'C', 3, 'GENERAL', 'Original total = 20x35=700. Remaining total = 19x34=646. Removed number = 700-646=54.', null)
) as v(question_text, option_a, option_b, option_c, option_d, option_e, correct_letter, difficulty, exam_type, explanation, exam_shortcut);

-- ==========================================
-- TOPIC 307: PROBABILITY -- INTRODUCTION (Week 8)
-- ==========================================

with lesson as (
  insert into public.lessons (topic_id, title, summary, content_body, order_index)
  values (
    (select t.id from public.topics t join public.curricula c on c.id = t.curriculum_id
     where c.subject = 'Mathematics' and t.class_level = 'SS2' and t.term = 3 and t.order_index = 307),
    'Probability: Introduction',
    'The basic probability formula, standard sample spaces (coins, dice, cards), and complementary events.',
    '**Glossary.** **Probability** measures how likely an event is, on a scale from 0 (impossible) to 1 (certain). The **sample space** is the set of all possible outcomes of an experiment, written $S$, with $n(S)$ its total number of outcomes. An **event** is any subset of the sample space that we are interested in. **Complementary events** are a pair, $A$ and "not $A$" (written $A''$), that together cover the entire sample space.

**Basic formula:** $P(E) = \dfrac{n(E)}{n(S)}$, where $n(E)$ is the number of outcomes favourable to event $E$, and $n(S)$ is the total number of possible outcomes.

**Key sample spaces to know by heart:** tossing one coin, $S = \{H, T\}$, $n(S) = 2$; tossing two coins, $S = \{HH, HT, TH, TT\}$, $n(S) = 4$; rolling one die, $S = \{1,2,3,4,5,6\}$, $n(S) = 6$; rolling two dice, $n(S) = 36$; drawing one card from a standard 52-card deck, $n(S) = 52$ (4 suits of 13 cards each, 4 of each rank, 26 red and 26 black, 12 face cards).

**Complementary events:** $P(A) + P(A'') = 1$, so $P(A'') = 1 - P(A)$ (e.g. $P(\text{not rolling a } 6) = 1 - 1/6 = 5/6$). This is especially useful for "at least one" questions, where computing the complement (none at all) is almost always simpler than listing every "at least one" outcome directly.',
    1
  )
  returning id
),
we1 as (
  insert into public.worked_examples (lesson_id, title, problem_statement, solution_steps, real_life_context, exam_shortcut, status)
  select id,
    'Probability from a Bag of Coloured Balls',
    'A bag contains 5 red, 3 blue, and 2 green balls. A ball is drawn at random. Find P(red), P(blue), P(not green).',
    to_jsonb(array[
      'Find the total number of balls: $n(S) = 5 + 3 + 2 = 10$.',
      'Find $P(\text{red})$: $n(\text{red}) = 5$, so $P(\text{red}) = 5/10 = 1/2$.',
      'Find $P(\text{blue})$: $n(\text{blue}) = 3$, so $P(\text{blue}) = 3/10$.',
      'Find $P(\text{not green})$ using the complement rule: $P(\text{green}) = 2/10 = 1/5$, so $P(\text{not green}) = 1 - 1/5 = 4/5$.'
    ]),
    'A market trader picking a bag of assorted oranges at random to check quality, some ripe, some unripe, some spoiled, is using exactly this "outcomes over total" idea, whether checking fruit, sorting bank notes by denomination, or picking a raffle ticket at a school fundraiser.',
    'P(A) + P(A prime) = 1 is a built-in answer check, after computing any probability, quickly compute its complement and confirm neither is negative or bigger than 1.',
    'published'
  from lesson
  returning id
)
insert into public.worked_examples (lesson_id, title, problem_statement, solution_steps, real_life_context, exam_shortcut, status)
select lesson.id,
  'Probability with Two Coins',
  'Two coins are tossed. Find P(two heads), P(at least one head), P(no heads).',
  to_jsonb(array[
    'Write the full sample space: $S = \{HH, HT, TH, TT\}$, $n(S) = 4$.',
    'Find $P(\text{two heads})$: only $HH$ qualifies, so $P(HH) = 1/4$.',
    'Find $P(\text{at least one head})$: outcomes with at least one head are $\{HH, HT, TH\}$, so $n = 3$, giving $P = 3/4$.',
    'Find $P(\text{no heads})$: only $TT$ qualifies, so $P(\text{no heads}) = 1/4$. Notice this also equals $1 - P(\text{at least one head}) = 1 - 3/4 = 1/4$, confirming the complement rule.'
  ]),
  'A game show or a school fundraising raffle using a "toss two coins, win if you get at least one head" rule is relying on exactly this sample space, players intuitively feel the odds should be higher than they actually are, which is why listing the full sample space matters.',
  'Learn the standard sample spaces cold: 1 coin n(S)=2; 2 coins n(S)=4; 1 die n(S)=6; 2 dice n(S)=36; 1 card n(S)=52. This saves the biggest chunk of time in probability questions.',
  'published'
from lesson;

insert into public.questions (topic_id, question_text, option_a, option_b, option_c, option_d, option_e, correct_letter, difficulty, exam_type, explanation, exam_shortcut, status)
select topic_ref.tid, v.question_text, v.option_a, v.option_b, v.option_c, v.option_d, v.option_e, v.correct_letter, v.difficulty, v.exam_type, v.explanation, v.exam_shortcut, 'published'
from (select t.id as tid from public.topics t join public.curricula c on c.id = t.curriculum_id
      where c.subject = 'Mathematics' and t.class_level = 'SS2' and t.term = 3 and t.order_index = 307) topic_ref,
lateral (values
  ('Define probability and state its range of values.', 'A count of favourable outcomes only, ranging from 0 to n(S)', 'A measure of how likely an event is to occur, expressed as a number between 0 (impossible) and 1 (certain)', 'The number of trials in an experiment', 'A percentage that must always equal 100', null::text, 'B', 1, 'GENERAL'::exam_type, 'Probability measures likelihood on a fixed scale from 0 (impossible) to 1 (certain).', null),
  ('What is a sample space? Give an example.', 'The set of all possible outcomes of an experiment, e.g. tossing a coin gives S = {H, T}', 'Only the favourable outcomes of an experiment', 'The total number of experiments performed', 'A graph showing probability over time', null, 'A', 1, 'GENERAL', 'The sample space is every possible outcome of an experiment, e.g. S={H,T} for a coin toss.', null),
  ('A bag contains 5 black and 3 white balls. Find P(black).', '3/8', '5/8', '1/2', '5/3', null, 'B', 1, 'GENERAL', 'n(S)=8 total balls, n(black)=5, so P(black)=5/8.', null),
  ('If P(E) = 0.65, find P(E prime).', '0.65', '0.45', '0.35', '0.15', null, 'C', 1, 'GENERAL', 'P(E prime) = 1 - P(E) = 1 - 0.65 = 0.35.', null),
  ('A die is rolled once. Find the probability of (a) rolling a 5 (b) rolling an odd number (c) rolling a number less than 4 (d) not rolling a 6.', '(a) 1/6, (b) 1/2, (c) 1/2, (d) 5/6', '(a) 1/6, (b) 1/3, (c) 1/2, (d) 4/6', '(a) 1/3, (b) 1/2, (c) 1/3, (d) 5/6', '(a) 1/6, (b) 1/2, (c) 2/3, (d) 5/6', null, 'A', 2, 'GENERAL', '(a) 1/6. (b) odd={1,3,5}, 3/6=1/2. (c) less than 4={1,2,3}, 3/6=1/2. (d) 1-1/6=5/6.', null),
  ('A box contains 4 red, 5 blue, and 6 green marbles. A marble is drawn at random. Find (a) P(red) (b) P(not blue) (c) P(red or green).', '(a) 4/15, (b) 2/3, (c) 2/3', '(a) 4/15, (b) 5/15, (c) 10/15', '(a) 1/4, (b) 2/3, (c) 2/3', '(a) 4/15, (b) 1/3, (c) 1/3', null, 'A', 2, 'GENERAL', 'n(S)=15. (a) 4/15. (b) 1-5/15=10/15=2/3. (c) (4+6)/15=10/15=2/3.', null),
  ('Two coins are tossed. Find (a) P(two tails) (b) P(at least one head) (c) P(exactly one tail).', '(a) 1/4, (b) 3/4, (c) 1/2', '(a) 1/2, (b) 3/4, (c) 1/4', '(a) 1/4, (b) 1/2, (c) 1/2', '(a) 1/4, (b) 3/4, (c) 1/4', null, 'A', 2, 'GENERAL', 'S={HH,HT,TH,TT}. (a) only TT, 1/4. (b) HH,HT,TH, 3/4. (c) HT,TH, 2/4=1/2.', null),
  ('A card is drawn from a standard deck. Find (a) P(Ace) (b) P(Club) (c) P(Red King) (d) P(Ace or Club).', '(a) 1/13, (b) 1/4, (c) 1/26, (d) 4/13', '(a) 1/13, (b) 1/13, (c) 1/26, (d) 2/13', '(a) 1/4, (b) 1/4, (c) 1/13, (d) 4/13', '(a) 1/13, (b) 1/4, (c) 1/13, (d) 5/13', null, 'A', 3, 'GENERAL', '(a) 4/52=1/13. (b) 13/52=1/4. (c) 2/52=1/26. (d) P(Ace)+P(Club)-P(Ace of Club)=4/52+13/52-1/52=16/52=4/13.', null),
  ('A spinner has sectors numbered 1 to 8. If P(landing on an even number) = 0.5, how many even-numbered sectors are there?', '2', '3', '4', '5', null, 'C', 1, 'GENERAL', '0.5 x 8 = 4 even-numbered sectors.', null),
  ('A bag contains 9 blue, 6 red, and 10 white beads. If a bead is picked at random, find P(white).', '2/5', '1/5', '3/5', '1/2', null, 'A', 2, 'WAEC', 'n(S)=25. P(white)=10/25=2/5 (WAEC 2009).', null),
  ('A letter is chosen at random from the letters of the word NIGERIA. What is the probability that it is an "I"?', '1/7', '2/7', '3/7', '1/2', null, 'B', 2, 'WAEC', 'NIGERIA has 7 letters, with I appearing twice, so P(I) = 2/7 (WAEC 2009).', null),
  ('A box contains balls numbered 3, 5, 7, 9, 11, 13, 3, 2, 3, 5, 8, 10. If a ball is picked at random, what is the probability that it is numbered 3?', '1/6', '1/4', '1/3', '1/12', null, 'B', 2, 'WAEC', 'There are 12 balls total, and the number 3 appears 3 times, so P(3) = 3/12 = 1/4 (WAEC 2012).', null),
  ('Dele purchases 20 tickets in a lottery where 1000 tickets were sold. What is his probability of winning first prize?', '1/50', '1/20', '1/100', '1/1000', null, 'A', 2, 'WAEC', 'P(win) = 20/1000 = 1/50 (WAEC 2013).', null),
  ('A number is chosen at random from {1, 2, ..., 10}. What is the probability that it is a prime number?', '0.3', '0.4', '0.5', '0.6', null, 'B', 2, 'WAEC', 'Primes in 1-10: 2,3,5,7, that is 4 numbers, so P = 4/10 = 0.4 (WAEC 2008).', null),
  ('A number is chosen at random from {1, 2, ..., 10}. What is the probability that it is an odd prime number?', '0.2', '0.3', '0.4', '0.5', null, 'B', 2, 'WAEC', 'Odd primes in 1-10: 3,5,7, that is 3 numbers, so P = 3/10 = 0.3 (WAEC 2008).', null),
  ('A die and a coin are thrown together once. What is the probability of getting a head and a six?', '1/6', '1/2', '1/12', '1/36', null, 'C', 2, 'WAEC', 'P(head) x P(six) = 1/2 x 1/6 = 1/12 (WAEC 2008).', null),
  ('Two numbers are chosen at random, one after another with replacement, from {1, 3, 6}. Find the probability that the sum of the two is not odd.', '1/3', '4/9', '5/9', '2/3', null, 'C', 3, 'GENERAL', 'With replacement, there are 3x3=9 equally likely ordered pairs. The sum is odd only when one number is odd (1 or 3) and the other is even (6): (1,6),(3,6),(6,1),(6,3), 4 outcomes. So the sum is not odd for the remaining 9-4=5 outcomes, giving P = 5/9.', 'With replacement, always use the full n times n grid of ordered outcomes, not just the distinct unordered pairs.'),
  ('Find the probability that a number selected at random from 41 to 56 (inclusive) is a multiple of 9.', '1/16', '1/8', '1/4', '3/16', null, 'B', 2, 'GENERAL', 'Numbers 41 to 56 give 16 values. Multiples of 9 in this range: 45, 54, that is 2 numbers, so P = 2/16 = 1/8.', null),
  ('In a group of families, the numbers with 0, 1, 2, 3, 4, 5-or-more children are 12, 28, 22, 8, 2, 2 (total 74). Find the probability that another family of this type has (a) 2 children (b) 3 or more children (c) fewer than 2 children.', '(a) 11/37, (b) 6/37, (c) 20/37', '(a) 22/74, (b) 12/74, (c) 40/74', '(a) 11/37, (b) 12/74, (c) 20/37', '(a) 22/37, (b) 6/37, (c) 10/37', null, 'A', 3, 'GENERAL', '(a) 22/74=11/37. (b) (8+2+2)/74=12/74=6/37. (c) (12+28)/74=40/74=20/37.', null)
) as v(question_text, option_a, option_b, option_c, option_d, option_e, correct_letter, difficulty, exam_type, explanation, exam_shortcut);

-- ==========================================
-- TOPIC 308: PROBABILITY -- ADDITION & MULTIPLICATION RULES (Week 9)
-- ==========================================

with lesson as (
  insert into public.lessons (topic_id, title, summary, content_body, order_index)
  values (
    (select t.id from public.topics t join public.curricula c on c.id = t.curriculum_id
     where c.subject = 'Mathematics' and t.class_level = 'SS2' and t.term = 3 and t.order_index = 308),
    'Probability: Addition and Multiplication Rules',
    'Combining probabilities with "or" (addition rule) and "and" (multiplication rule), for mutually exclusive, independent, and dependent events.',
    '**Glossary.** Two events are **mutually exclusive** if they cannot both happen at the same time (e.g. rolling a 2 and a 5 on one die in one roll). Two events are **independent** if the outcome of one does not affect the probability of the other (e.g. two separate coin tosses, or drawing **with replacement**). Two events are **dependent** if one does affect the other (e.g. drawing **without replacement**, where removing an item changes the totals for the next draw).

**Addition Rule ("or").** If two events are mutually exclusive: $P(A \text{ or } B) = P(A) + P(B)$. If they are not mutually exclusive (they can both happen), the overlap must be subtracted once: $P(A \text{ or } B) = P(A) + P(B) - P(A \text{ and } B)$.

**Multiplication Rule ("and").** If two events are independent: $P(A \text{ and } B) = P(A) \times P(B)$. If they are dependent: $P(A \text{ and } B) = P(A) \times P(B \mid A)$, where $P(B \mid A)$ is the probability of $B$ given that $A$ has already happened (a smaller denominator, and sometimes a smaller numerator, for the second draw).

**Complementary events:** $A$ and $A''$ together cover the whole sample space, so $P(A) + P(A'') = 1$, useful for any "at least one" question via $P(\text{at least one}) = 1 - P(\text{none})$.',
    1
  )
  returning id
),
we1 as (
  insert into public.worked_examples (lesson_id, title, problem_statement, solution_steps, real_life_context, exam_shortcut, common_trap_warning, status)
  select id,
    'Drawing Without Replacement',
    'A bag contains 6 red and 4 blue marbles. Two are drawn one after another without replacement. Find P(both red), P(both blue), P(one of each).',
    to_jsonb(array[
      'Note the total shrinks after the first draw: 10 marbles at first (6 red, 4 blue); after one is removed and not replaced, only 9 remain for the second draw.',
      'Find $P(\text{both red})$: $P(\text{1st red}) = 6/10$. Having removed one red, 5 red remain out of 9, so $P(\text{2nd red} \mid \text{1st red}) = 5/9$. Multiply: $P(\text{both red}) = 6/10 \times 5/9 = 30/90 = 1/3$.',
      'Find $P(\text{both blue})$: $P(\text{1st blue}) = 4/10$. Having removed one blue, 3 blue remain out of 9, so $P(\text{2nd blue} \mid \text{1st blue}) = 3/9$. Multiply: $P(\text{both blue}) = 4/10 \times 3/9 = 12/90 = 2/15$.',
      'Find $P(\text{one of each})$ by adding the two possible orders: "red then blue" $= 6/10 \times 4/9 = 24/90$; "blue then red" $= 4/10 \times 6/9 = 24/90$. These are mutually exclusive ways of getting "one of each", so add them: $24/90 + 24/90 = 48/90 = 8/15$.'
    ]),
    'A trader picking two tomatoes at random from a crate of good and slightly bruised tomatoes, without putting the first one back before picking the second, faces exactly this without-replacement scenario, common in quality-control sampling at a Nigerian market or a produce depot.',
    'Draw a quick probability tree: branches for the 1st draw, sub-branches for the 2nd draw with adjusted denominators. Multiply along a branch, add across branches leading to the same outcome.',
    'Without replacement shrinks the denominator by exactly 1 each draw, and shrinks the matching numerator by 1 too if the same category is drawn consecutively, forgetting to update the denominator on the second draw is the single most common exam error here.',
    'published'
  from lesson
  returning id
)
insert into public.worked_examples (lesson_id, title, problem_statement, solution_steps, real_life_context, exam_shortcut, status)
select lesson.id,
  'Addition Rule with Overlapping Events',
  'A card is drawn from a standard deck. Find P(King or Heart).',
  to_jsonb(array[
    'Check whether the events overlap: "King" and "Heart" can both be true at once (the King of Hearts), so these events are not mutually exclusive, the plain addition rule would double-count that card.',
    'Write the correct addition rule: $P(\text{King or Heart}) = P(\text{King}) + P(\text{Heart}) - P(\text{King and Heart})$.',
    'Find each probability: $P(\text{King}) = 4/52$ (one King per suit); $P(\text{Heart}) = 13/52$ (one full suit); $P(\text{King and Heart}) = 1/52$ (only the King of Hearts satisfies both).',
    'Substitute and combine: $P(\text{King or Heart}) = 4/52 + 13/52 - 1/52 = 16/52$.',
    'Simplify: $16/52 = 4/13$.'
  ]),
  'A card game or a raffle where a Nigerian church or school fundraiser draws a card to decide a prize category uses exactly this overlap-aware addition rule whenever the two winning conditions can both be true on the same card.',
  '"Or" means add, but check for overlap before adding, subtract P(A and B) once if the two events can happen together, skip the subtraction entirely if they are genuinely mutually exclusive.',
  'published'
from lesson;

insert into public.questions (topic_id, question_text, option_a, option_b, option_c, option_d, option_e, correct_letter, difficulty, exam_type, explanation, exam_shortcut, status)
select topic_ref.tid, v.question_text, v.option_a, v.option_b, v.option_c, v.option_d, v.option_e, v.correct_letter, v.difficulty, v.exam_type, v.explanation, v.exam_shortcut, 'published'
from (select t.id as tid from public.topics t join public.curricula c on c.id = t.curriculum_id
      where c.subject = 'Mathematics' and t.class_level = 'SS2' and t.term = 3 and t.order_index = 308) topic_ref,
lateral (values
  ('Explain the difference between (a) mutually exclusive and independent events (b) complementary events and mutually exclusive events.', '(a) mutually exclusive events cannot both happen (e.g. rolling a 2 and a 5 on one die); independent events can both happen and one does not affect the other (e.g. two coin tosses). (b) complementary events are exhaustive opposites summing to 1 (e.g. raining/not raining); mutually exclusive events cannot co-occur but need not cover all outcomes', '(a) they mean the same thing. (b) they mean the same thing', '(a) mutually exclusive events can both happen; independent events cannot. (b) complementary events can both happen', 'None of the definitions given are correct', null::text, 'A', 2, 'GENERAL'::exam_type, 'Mutually exclusive means the two events share no outcomes at all; independent means one event''s outcome has no effect on the other''s probability, they can still both happen. Complementary events are a special exhaustive pair that always sums to 1, while mutually exclusive events just cannot co-occur, they may not cover the whole sample space.', null),
  ('Two events A and B are mutually exclusive. If P(A) = 0.3 and P(B) = 0.4, find P(A or B).', '0.12', '0.58', '0.7', '1.0', null, 'C', 1, 'GENERAL', 'Mutually exclusive events simply add: P(A or B) = 0.3+0.4 = 0.7.', null),
  ('In a class of 30 students, 18 study Mathematics, 15 study Physics, and 10 study both. Find the probability that a randomly selected student studies (a) Mathematics or Physics (b) neither subject.', '(a) 23/30, (b) 7/30', '(a) 33/30, (b) -3/30', '(a) 23/30, (b) 10/30', '(a) 13/30, (b) 17/30', null, 'A', 3, 'GENERAL', '(a) P(M or P) = 18/30+15/30-10/30 = 23/30. (b) P(neither) = 1-23/30 = 7/30.', null),
  ('The probability that it will rain tomorrow is 0.3. What is the probability it will not rain?', '0.3', '0.5', '0.7', '1.3', null, 'C', 1, 'GENERAL', 'P(not rain) = 1-0.3 = 0.7.', null),
  ('A fair coin is tossed three times. Find the probability of getting exactly two heads.', '1/8', '1/4', '3/8', '1/2', null, 'C', 3, 'GENERAL', 'There are 8 equally likely outcomes; exactly two heads occurs in HHT, HTH, THH, 3 outcomes, so P = 3/8.', null),
  ('A bag has 4 red and 5 blue balls. Two are drawn without replacement. Find P(2 red).', '1/9', '1/6', '2/9', '4/9', null, 'B', 3, 'GENERAL', 'P(2 red) = (4/9)x(3/8) = 12/72 = 1/6.', null),
  ('If P(A)=0.4 and P(B)=0.5, and A and B are mutually exclusive, find P(A or B).', '0.2', '0.7', '0.9', '1.0', null, 'C', 1, 'GENERAL', 'Mutually exclusive events add directly: 0.4+0.5=0.9.', null),
  ('A haulage contractor has 3 type A, 2 type B, and 7 type C lorries (12 total). What is the probability that a lorry delivering a load is type A or type C?', '5/12', '2/3', '5/6', '3/4', null, 'C', 2, 'GENERAL', 'Type A and type C cannot both be the same lorry, so they are mutually exclusive: P(A or C) = 3/12+7/12 = 10/12 = 5/6.', null),
  ('A fair die is rolled once. What is the probability of obtaining either a 2 or a 5?', '1/6', '1/3', '1/2', '2/3', null, 'B', 1, 'WAEC', 'Mutually exclusive outcomes on one roll: P(2 or 5) = 1/6+1/6 = 2/6 = 1/3 (WAEC 2009).', null),
  ('Two dice are thrown at the same time. What is the probability that the sum will be 7 or 11?', '1/6', '2/9', '1/4', '1/3', null, 'B', 3, 'WAEC', 'Ways to get sum 7: 6; ways to get sum 11: 2; total 8 out of 36 equally likely outcomes, so P = 8/36 = 2/9 (WAEC 2003).', null),
  ('A basket has 6 grapes, 11 bananas, and 13 oranges (30 fruits). If one fruit is chosen at random, what is the probability it is a grape or a banana?', '17/30', '19/30', '2/3', '17/24', null, 'A', 2, 'WAEC', 'Grape and banana are mutually exclusive: P(grape or banana) = 6/30+11/30 = 17/30 (WAEC 2003).', null),
  ('A number is chosen at random from {15, 16, ..., 32}. Find the probability it is (i) a multiple of 7 (ii) a prime number (iii) a prime or a multiple of 7.', '(i) 1/9, (ii) 5/18, (iii) 7/18', '(i) 2/18, (ii) 5/18, (iii) 7/18', '(i) 1/9, (ii) 4/18, (iii) 6/18', '(i) 1/9, (ii) 5/18, (iii) 6/18', null, 'A', 3, 'GENERAL', '18 numbers total (15-32). (i) multiples of 7: 21, 28, so 2/18=1/9. (ii) primes: 17,19,23,29,31, so 5/18. (iii) no overlap between these two sets, so P = 1/9+5/18 = 2/18+5/18 = 7/18.', null),
  ('If a number is chosen at random from {x : 4 <= x <= 15}, find the probability it is a multiple of 3 or a multiple of 4.', '1/3', '5/12', '1/2', '7/12', null, 'C', 3, 'WAEC', '12 numbers total (4-15). Multiples of 3: 6,9,12,15 (4 numbers). Multiples of 4: 4,8,12 (3 numbers). Overlap (multiples of both, i.e. 12): 1 number. P = (4+3-1)/12 = 6/12 = 1/2 (WAEC 2011).', null),
  ('A class of 15 students offers Physics, Chemistry, or both; 11 offer Physics and 9 offer Chemistry. What is the probability a randomly chosen student offers both?', '1/5', '1/4', '1/3', '2/5', null, 'C', 3, 'WAEC', 'Since every student offers at least one subject, n(P or C)=15, so n(P and C) = 11+9-15 = 5, giving P(both) = 5/15 = 1/3 (WAEC 2008).', null),
  ('There are twelve cards numbered 1 to 12. A card is selected at random. What is the probability it is either even or a perfect square?', '7/12', '1/2', '2/3', '3/4', null, 'C', 3, 'GENERAL', 'Even numbers 1-12: {2,4,6,8,10,12}, 6 numbers. Perfect squares 1-12: {1,4,9}, 3 numbers. Overlap: {4}, 1 number (4 is both even and a perfect square). P(even or square) = (6+3-1)/12 = 8/12 = 2/3.', null),
  ('Bello chooses a number at random from 1 to 10. What is the probability it is either odd or prime?', '1/2', '3/5', '7/10', '4/5', null, 'B', 2, 'WAEC', 'Odd numbers: {1,3,5,7,9}, 5 numbers. Primes: {2,3,5,7}, 4 numbers. Overlap: {3,5,7}, 3 numbers. P = (5+4-3)/10 = 6/10 = 3/5 (WAEC 2008).', null),
  ('Three balls are drawn successively from a box containing 8 red, 6 white, and 4 black balls, with each ball replaced before the next draw. Find the probability they are drawn in order red, white, black.', '4/243', '8/243', '12/243', '16/243', null, 'B', 3, 'GENERAL', 'With replacement, the total (18) stays fixed each draw: P = (8/18)x(6/18)x(4/18) = 192/5832 = 8/243.', null),
  ('A president and secretary are chosen (without replacement) from a group of 4 girls and 6 boys. What is the probability that both are girls?', '1/15', '2/15', '4/15', '6/15', null, 'B', 3, 'GENERAL', 'P(both girls) = (4/10)x(3/9) = 12/90 = 2/15.', null),
  ('A bag contains 8 red and 12 white balls. A ball is picked, replaced, and a second is picked. What is the probability they are of the same colour?', '11/25', '12/25', '13/25', '14/25', null, 'C', 3, 'GENERAL', 'P(both red)+P(both white) = (8/20)^2+(12/20)^2 = 16/100+36/100 = 52/100 = 13/25.', null),
  ('A pair of fair dice is thrown once. Find the probability of scoring a 2 on one die and a 5 on the other.', '1/36', '1/18', '1/12', '1/9', null, 'B', 3, 'GENERAL', 'There are 2 favourable ordered outcomes, (2,5) and (5,2), out of 36 total, so P = 2/36 = 1/18.', null),
  ('A bag has 3 black and 2 red balls. A ball is picked and replaced, then a second is picked. Find (i) P(both black) (ii) P(one black, one red).', '(i) 9/25, (ii) 12/25', '(i) 6/25, (ii) 12/25', '(i) 9/25, (ii) 6/25', '(i) 4/25, (ii) 12/25', null, 'A', 3, 'GENERAL', '(i) (3/5)x(3/5)=9/25. (ii) two orders, black-then-red and red-then-black: 2x(3/5)x(2/5)=12/25.', null),
  ('A class has 30 boys and 20 girls; 60% of boys and 40% of girls can swim. A boy and a girl are chosen at random. Find the probability that both can swim.', '0.20', '0.24', '0.30', '0.36', null, 'B', 3, 'GENERAL', 'Choosing one boy and one girl are independent events: P(both swim) = 0.6 x 0.4 = 0.24.', null),
  ('Repeat the red-white-black draw (8 red, 6 white, 4 black, total 18), but this time without replacement: find P(red, white, black in that order).', '1/51', '2/51', '3/51', '4/51', null, 'B', 4, 'GENERAL', 'P = (8/18)x(6/17)x(4/16) = 192/4896 = 2/51.', 'Without replacement, the denominator drops by exactly 1 with each successive draw.'),
  ('A bag contains 4 red and 6 black balls. Two are drawn one after another without replacement. Find the probability of picking balls of different colours.', '6/15', '7/15', '8/15', '9/15', null, 'C', 3, 'WAEC', 'Two orders: red-then-black + black-then-red = (4/10)(6/9) + (6/10)(4/9) = 24/90+24/90 = 48/90 = 8/15 (WAEC 2012).', null),
  ('A packet contains 4 red, 5 blue, and 6 black biros (15 total). Two are picked at random without replacement; find the probability of picking a red and a black biro (in either order).', '4/35', '6/35', '7/35', '8/35', null, 'D', 4, 'WAEC', 'Both orders must be added: red-then-black + black-then-red = (4/15)(6/14) + (6/15)(4/14) = 24/210 + 24/210 = 48/210 = 8/35 (WAEC 2003; counting only one order, as 4/15 x 6/14 = 4/35 alone, would miss the black-then-red case and undercount).', 'For "one of each type" without replacement, always add both possible orders, a single order alone will only give half the answer.'),
  ('Two balls are drawn from a bag containing 5 blue and 10 red balls without replacement. Find the probability that both are blue.', '1/21', '2/21', '1/6', '2/15', null, 'B', 3, 'WAEC', 'P(both blue) = (5/15)x(4/14) = 20/210 = 2/21 (WAEC 2012).', null),
  ('A science class of 2 boys and 8 girls chooses two representatives (without replacement) for a quiz. Find the probability that both slots are filled by girls.', '24/45', '26/45', '28/45', '30/45', null, 'C', 3, 'GENERAL', 'P(both girls) = (8/10)x(7/9) = 56/90 = 28/45.', null),
  ('Chinedu and Kareen take a test independently. P(Chinedu passes) = 1/3, P(Kareen passes) = 4/5. Calculate the probability that exactly one of them passes.', '2/5', '1/2', '3/5', '4/5', null, 'C', 4, 'GENERAL', 'P(exactly one) = P(C passes, K fails) + P(C fails, K passes) = (1/3)(1/5) + (2/3)(4/5) = 1/15+8/15 = 9/15 = 3/5.', null),
  ('Out of 60 members of an association, 15 are Doctors and 9 are Lawyers (with no member being both). If a member is selected at random, what is the probability the member is neither a Doctor nor a Lawyer?', '2/5', '1/2', '3/5', '2/3', null, 'C', 2, 'GENERAL', 'P(Doctor or Lawyer) = 15/60+9/60 = 24/60. P(neither) = 1-24/60 = 36/60 = 3/5.', null),
  ('A fair die numbered 1 to 6 is rolled once. What is the probability of obtaining 3 or 5?', '1/6', '1/3', '1/2', '2/3', null, 'B', 1, 'GENERAL', 'Mutually exclusive outcomes: P(3 or 5) = 1/6+1/6 = 1/3.', null),
  ('Two dice are rolled. Find P(sum is 8 or both dice show even numbers).', '9/36', '10/36', '11/36', '12/36', null, 'C', 4, 'GENERAL', 'Sum=8 outcomes: (2,6),(3,5),(4,4),(5,3),(6,2), 5 outcomes. Both-even outcomes: each die from {2,4,6}, 3x3=9 outcomes. Overlap (sum 8 AND both even): (2,6),(4,4),(6,2), 3 outcomes. P = (5+9-3)/36 = 11/36.', null)
) as v(question_text, option_a, option_b, option_c, option_d, option_e, correct_letter, difficulty, exam_type, explanation, exam_shortcut);

-- ==========================================
-- END OF FILE
-- All 8 Third Term SS2 Mathematics topics (order_index 301-308) have now
-- been seeded with one lesson, worked examples, and questions each.
-- ==========================================
