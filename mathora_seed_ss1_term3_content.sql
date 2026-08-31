-- ==========================================
-- MATHORA -- SS1 Mathematics, Third Term: Full Lesson Content Seed
-- Populates all 14 Third Term topics (order_index 301-314) with real
-- teaching notes, worked examples, and question-bank questions, sourced
-- from SS1-SS3_MATHEMATICS_CURATED.md's "SS1 Mathematics > Third Term"
-- section (curated notes + Gamified Exercise Bank, Weeks 1-11).
--
-- Does NOT create any topics or curricula rows -- every topic referenced
-- below (order_index 301 through 314) must already exist. Run this file
-- after, in order, from a bare database:
--   mathora_schema.sql
--   mathora_schema_five_option_patch.sql
--   mathora_schema_topics_term_patch.sql
--   mathora_seed_topics_ss1_ss2_ss3.sql
-- (mathora_schema_auth_patch.sql, mathora_schema_content_pipeline_patch.sql,
-- and mathora_schema_diagrams_patch.sql must also already be applied, since
-- this file writes worked_examples.real_life_context / diagram_type /
-- diagram_data / status and questions.status / option_e / diagram_type /
-- diagram_data -- all columns those patches add.)
--
-- Follows the exact CTE pattern from mathora_seed_exemplar_lessons.sql:
-- one `with lesson as (insert into lessons ... returning id)` per topic,
-- feeding a chained `insert into worked_examples select id, ... from lesson`,
-- followed by standalone `insert into questions ... select t.id from topics t
-- join curricula c ...` blocks referencing the topic by lookup, never by a
-- hardcoded UUID.
--
-- Every worked example's math was re-derived from the curated source's
-- own "Step 1 / Step 2 / ... / Answer" walkthroughs; every question's
-- correct_letter was checked against the curated file's stated answer
-- before being assigned a slot A-E.
--
-- Mapping note: the curated file organizes Third Term into 11 weeks that
-- do not line up 1:1 with the 14 seeded topics (topics 301/302 and
-- 307/308 each pull from a shared week; topics 309-314 subdivide the
-- curated file's Weeks 10-11 by sub-theme). See the per-topic section
-- comments below for exactly which curated week(s) and question numbers
-- feed each topic.
-- ==========================================
-- ==========================================
-- TOPIC 301: Mensuration: 3-D Shapes, Surface Area & Volume
-- Source: Third Term Week 1 (TSA of cube/cuboid/cylinder/cone/prism/
-- pyramid) + Week 2 (Volume of prisms/pyramids/cylinders/cones/spheres
-- and compound solids). Questions: Week 1 Q1-30 + Week 2 Q1-31 (61 total).
-- ==========================================

with lesson as (
  insert into public.lessons (topic_id, title, summary, content_body, order_index)
  values (
    (select t.id from public.topics t join public.curricula c on c.id = t.curriculum_id
     where c.subject = 'Mathematics' and t.class_level = 'SS1' and t.term = 3 and t.order_index = 301),
    'Mensuration: 3-D Shapes, Surface Area & Volume',
    'Finding the total surface area and volume of cubes, cuboids, cylinders, cones, prisms, pyramids and compound solids.',
    '## Surface Area

**Surface area (SA)** of a solid is the total area of all its faces, i.e. the area of its "net" if unfolded flat. It is measured in square units ($cm^2$, $m^2$).

- **Cube** (side $l$): $TSA = 6l^2$ (6 identical square faces).
- **Cuboid** (length $l$, width $w$, height $h$): $TSA = 2(lw + lh + wh)$.
- **Cylinder** (radius $r$, height $h$): the curved surface, unrolled, is a rectangle of width $2\pi r$ and height $h$.
  - Curved surface area: $CSA = 2\pi rh$
  - TSA (closed): $TSA = 2\pi r^2 + 2\pi rh = 2\pi r(r+h)$
  - TSA (open at one end): $TSA = \pi r^2 + 2\pi rh = \pi r(r+2h)$
- **Cone** (base radius $R$, slant height $l$, vertical height $h$): a cone is formed by folding a sector of a circle, the sector radius becomes the slant height and the arc length becomes the base circumference.
  - $CSA = \pi Rl$
  - $TSA = \pi R^2 + \pi Rl = \pi R(R+l)$
  - $l^2 = h^2 + R^2$ (slant height, vertical height and radius form a right triangle)
- **Prism** (uniform cross-section, length $L$): $TSA = 2(\text{base area}) + (\text{perimeter of base} \times L)$.
- **Pyramid** (square base side $l$, slant height $s$ of a triangular face): $TSA = l^2 + 2ls$.

## Volume

**Volume** is the space a solid occupies, in cubic units ($cm^3$, $m^3$). $1$ litre $= 1000\ cm^3$.

**Prisms** (uniform cross-section): $V = \text{Base area} \times \text{height}$.
- Cube: $V = l^3$
- Cuboid: $V = lwh$
- Cylinder: $V = \pi r^2 h$
- Triangular prism: $V = \left(\tfrac{1}{2}bH\right) \times L$

**Pyramids and cones** (tapering solids): $V = \tfrac{1}{3} \times \text{Base area} \times h$, where $h$ is always the vertical height, never the slant height.
- Square-based pyramid: $V = \tfrac{1}{3}l^2 h$
- Cone: $V = \tfrac{1}{3}\pi r^2 h$

**Sphere and hemisphere** (radius $r$): $V(\text{sphere}) = \tfrac{4}{3}\pi r^3$; $V(\text{hemisphere}) = \tfrac{2}{3}\pi r^3$.

**Compound shapes** are made of two or more simple solids joined together. Total volume = sum of the volumes of each part; when finding total surface area of a compound shape, exclude any "hidden" joined surfaces (e.g. a cone base glued onto a cylinder top).

**Key exam habits:** always convert diameter to radius before substituting; always confirm whether a cone/pyramid problem gives the slant height or the vertical height before choosing a formula; sanity-check that TSA is always bigger than CSA alone, and that a frustum-style compound volume is always less than the volume of the full uncut solid.',
    1
  )
  returning id
),
we1 as (
  insert into public.worked_examples (lesson_id, title, problem_statement, solution_steps, exam_shortcut, real_life_context, diagram_type, diagram_data, status)
  select id,
    'Total Surface Area of a Closed Cylindrical Tin',
    'A closed cylindrical tin has radius $7\ cm$ and height $10\ cm$. Find its total surface area (use $\pi = \tfrac{22}{7}$).',
    to_jsonb(array[
      'A closed cylinder has two circular ends plus the curved side, so $TSA = 2\pi r(r+h)$.',
      'Write down the known values: $r = 7\ cm$, $h = 10\ cm$, $\pi = \tfrac{22}{7}$.',
      'Substitute into the formula: $TSA = 2 \times \tfrac{22}{7} \times 7 \times (7+10)$.',
      'Simplify inside the bracket first: $7 + 10 = 17$.',
      'Cancel the 7s (one 7 in $\tfrac{22}{7}$ cancels the radius 7): $2 \times 22 \times 17$.',
      'Multiply: $2 \times 22 = 44$; $44 \times 17 = 748$.',
      'Answer: $TSA = 748\ cm^2$.'
    ]),
    'For a closed cylinder, always factor first, $TSA = 2\pi r(r+h)$, rather than expanding $2\pi r^2 + 2\pi rh$ separately, since it needs only one multiplication at the end instead of adding two products.',
    'This is exactly the calculation a metalworker uses to know how much sheet metal is needed to make a closed cylindrical tin or a water storage drum before cutting the metal.',
    'none', '{}'::jsonb,
    'published'
  from lesson
  returning id
),
we2 as (
  insert into public.worked_examples (lesson_id, title, problem_statement, solution_steps, exam_shortcut, real_life_context, diagram_type, diagram_data, status)
  select id,
    'Capacity of a Cylindrical Oil Drum',
    'A cylindrical oil drum has radius $0.7\ m$ and height $1.5\ m$. Find its capacity in litres (use $\pi = \tfrac{22}{7}$).',
    to_jsonb(array[
      'Write the volume formula for a cylinder: $V = \pi r^2 h$.',
      'Square the radius first: $r^2 = 0.7^2 = 0.49\ m^2$.',
      'Substitute all values: $V = \tfrac{22}{7} \times 0.49 \times 1.5$.',
      'Multiply $\tfrac{22}{7}$ by $0.49$ (note $0.49 = 0.07 \times 7$, which cancels neatly with the 7 on the bottom): $\tfrac{22}{7} \times 0.49 = 22 \times 0.07 = 1.54$.',
      'Multiply by the height: $1.54 \times 1.5 = 2.31$.',
      'State the volume in $m^3$: $V = 2.31\ m^3$.',
      'Convert to litres, using $1\ m^3 = 1000$ litres: $2.31 \times 1000 = 2310$.',
      'Answer: capacity $= 2310$ litres.'
    ]),
    'Always cancel $\pi$''s denominator against a matching factor in $r$ or $r^2$ before multiplying everything out, it avoids messy decimals and is much faster by hand. Remember $m^3 \times 1000 = $ litres, while $cm^3 \div 1000 = $ litres.',
    'This is exactly how a fuel depot or a Nigerian filling station estimates how many litres of petrol or diesel a cylindrical storage drum holds, from just its radius and height.',
    'none', '{}'::jsonb,
    'published'
  from lesson
  returning id
)
insert into public.worked_examples (lesson_id, title, problem_statement, solution_steps, exam_shortcut, real_life_context, diagram_type, diagram_data, status)
select id,
  'Volume of a Compound Solid: Hemisphere on a Cylinder',
  'A hemisphere of radius $7\ cm$ sits on top of a cylinder of radius $7\ cm$ and height $10\ cm$. Find the total volume (use $\pi = \tfrac{22}{7}$).',
  to_jsonb(array[
    'Recognise this is a compound solid: find each part''s volume separately, then add.',
    'Find the cylinder''s volume, $V = \pi r^2 h$: $V(\text{cylinder}) = \tfrac{22}{7} \times 7^2 \times 10 = \tfrac{22}{7} \times 49 \times 10$.',
    'Cancel the 7s ($49 \div 7 = 7$): $= 22 \times 7 \times 10 = 1540\ cm^3$.',
    'Find the hemisphere''s volume, $V = \tfrac{2}{3}\pi r^3$ (half of a full sphere''s $\tfrac{4}{3}\pi r^3$): $r^3 = 7^3 = 343$.',
    'Substitute: $V(\text{hemisphere}) = \tfrac{2}{3} \times \tfrac{22}{7} \times 343$.',
    'Cancel the 7 with 343 ($343 \div 7 = 49$): $= \tfrac{2}{3} \times 22 \times 49$.',
    'Multiply $22 \times 49 = 1078$, then multiply by 2: $1078 \times 2 = 2156$.',
    'Divide by 3: $2156 \div 3 \approx 718.67\ cm^3$.',
    'Add the two volumes: Total $= 1540 + 718.67 = 2258.67\ cm^3$.',
    'Answer: total volume $\approx 2258.67\ cm^3$.'
  ]),
  'For compound solids, always compute and label each part''s volume separately before adding, mixing formulas into one giant expression is where most marks are lost to arithmetic slips.',
  'This models a Nigerian overhead water tank capped with a dome-shaped (hemispherical) lid, a shape often seen on rooftops, where a plumber needs the total holding capacity.',
  'none', '{}'::jsonb,
  'published'
from we1;

insert into public.questions (topic_id, question_text, question_latex, option_a, option_b, option_c, option_d, option_e, correct_letter, difficulty, exam_type, explanation, exam_shortcut, status)
select topic_ref.tid, v.question_text, v.question_latex, v.option_a, v.option_b, v.option_c, v.option_d, v.option_e, v.correct_letter, v.difficulty, v.exam_type, v.explanation, v.exam_shortcut, 'published'
from (select t.id as tid from public.topics t join public.curricula c on c.id = t.curriculum_id
      where c.subject = 'Mathematics' and t.class_level = 'SS1' and t.term = 3 and t.order_index = 301) topic_ref,
lateral (values
  ('What is the "net" of a solid?', null::text, 'The 2-D shape obtained by unfolding all its faces flat', 'The volume of the solid in cubic units', 'The perimeter of the solid''s base', 'The number of faces the solid has', null::text, 'A', 1, 'GENERAL'::exam_type, 'A net is the flat, 2-D shape you get when every face of a 3-D solid is unfolded and laid out flat, used to derive surface area formulas.', null::text),
  ('Write the formula for the total surface area of a cube of side l.', '$TSA = ?$', '$TSA = 6l^2$', '$TSA = l^3$', '$TSA = 4l^2$', '$TSA = l^2$', null, 'A', 1, 'GENERAL', 'A cube has 6 identical square faces, each of area $l^2$, so $TSA = 6l^2$.', null),
  ('A cube has side 5 cm. Find its total surface area.', null, '125 cm²', '100 cm²', '150 cm²', '175 cm²', null, 'C', 1, 'GENERAL', '$TSA = 6l^2 = 6 \times 5^2 = 6 \times 25 = 150\ cm^2$.', 'Square the side first, then multiply by 6 last, so you only do one multiplication with the bigger number.'),
  ('Write the formula for the total surface area of a cuboid of length l, width w and height h.', '$TSA = ?$', '$TSA = lwh$', '$TSA = 2(lw + lh + wh)$', '$TSA = l^2 + w^2 + h^2$', '$TSA = 2(l+w+h)$', null, 'B', 2, 'GENERAL', 'A cuboid has 3 pairs of identical rectangular faces of areas $lw$, $lh$, and $wh$, so $TSA = 2(lw+lh+wh)$.', null),
  ('A room shaped like a cuboid is 10 m long, 8 m wide and 3 m high. Find the total area of the 4 walls and the ceiling (excluding the floor).', null, '188 m²', '240 m²', '108 m²', '80 m²', null, 'A', 3, 'GENERAL', 'Walls $= 2(10+8)(3) = 108\ m^2$; ceiling $= 10 \times 8 = 80\ m^2$; total $= 108 + 80 = 188\ m^2$.', 'Split the surfaces you actually need (walls + ceiling) rather than computing the full cuboid TSA and subtracting the floor, it is the same answer either way but this route has fewer steps.'),
  ('Find the total surface area of a cuboid of length 8 cm, width 5 cm and height 4 cm.', null, '160 cm²', '184 cm²', '200 cm²', '17 cm²', null, 'B', 2, 'GENERAL', '$TSA = 2(8 \times 5 + 8 \times 4 + 5 \times 4) = 2(40+32+20) = 2(92) = 184\ cm^2$.', null),
  ('Write the formula for the curved surface area of a cylinder of radius r and height h.', '$CSA = ?$', '$CSA = \pi r^2 h$', '$CSA = 2\pi rh$', '$CSA = \pi r(r+h)$', '$CSA = 2\pi r^2$', null, 'B', 1, 'GENERAL', 'Unrolled, the curved surface is a rectangle of width $2\pi r$ (the circumference) and height $h$, so $CSA = 2\pi rh$.', null),
  ('A closed cylindrical tin has radius 7 cm and height 10 cm. Find its total surface area (π = 22/7).', null, '440 cm²', '748 cm²', '628 cm²', '814 cm²', null, 'B', 2, 'GENERAL', '$TSA = 2\pi r(r+h) = 2 \times \tfrac{22}{7} \times 7 \times 17 = 748\ cm^2$.', 'Cancel the 7 in the formula against the radius first before multiplying anything else.'),
  ('A cylinder of radius 5 cm has a curved surface area of 100π cm². Find (a) its height, (b) its total surface area.', null, 'h = 8 cm, TSA = 130π cm²', 'h = 10 cm, TSA = 150π cm²', 'h = 20 cm, TSA = 250π cm²', 'h = 10 cm, TSA = 100π cm²', null, 'B', 3, 'GENERAL', '$100\pi = 2\pi(5)h \Rightarrow h = 10\ cm$. $TSA = 2\pi(5)(5+10) = 150\pi\ cm^2$.', null),
  ('Find the total surface area of a closed cylinder of diameter 10 cm and height 21 cm (π = 22/7).', null, '817.14 cm²', '660 cm²', '440 cm²', '942.86 cm²', null, 'A', 3, 'GENERAL', 'Radius $= 10/2 = 5\ cm$. $TSA = 2\pi r(r+h) = 2 \times \tfrac{22}{7} \times 5 \times 26 \approx 817.14\ cm^2$.', 'Halve the diameter to get the radius before you substitute anything, never after.'),
  ('What is the total surface area of a closed cylinder of height 10 cm and diameter 7 cm (π = 22/7)?', null, '253 cm²', '297 cm²', '154 cm²', '176 cm²', null, 'B', 3, 'GENERAL', 'Radius $= 3.5\ cm$. $TSA = 2\pi(3.5)(3.5+10) = 2 \times \tfrac{22}{7} \times 3.5 \times 13.5 = 297\ cm^2$.', null),
  ('A cylinder with radius 3.5 cm has both ends closed. If its total surface area is 209 cm², find its height (π = 22/7).', null, '4 cm', '5 cm', '6 cm', '7 cm', null, 'C', 3, 'GENERAL', '$209 = 2 \times \tfrac{22}{7} \times 3.5 \times (3.5+h) = 22(3.5+h) \Rightarrow 3.5+h = 9.5 \Rightarrow h = 6\ cm$.', null),
  ('A solid cylindrical object of radius 7 cm is 10 cm high. Find its total surface area (π = 22/7).', null, '748 cm²', '440 cm²', '880 cm²', '628 cm²', null, 'A', 2, 'GENERAL', '$TSA = 2\pi r(r+h) = 2 \times \tfrac{22}{7} \times 7 \times 17 = 748\ cm^2$, the same setup as a closed tin.', null),
  ('A cylindrical tin with base diameter 14 cm and height 20 cm is open at the top. Find its total surface area (π = 22/7).', null, '880 cm²', '1034 cm²', '1188 cm²', '946 cm²', null, 'B', 3, 'GENERAL', 'Radius $= 7\ cm$. Open-top TSA $= \pi r(r+2h) = \tfrac{22}{7} \times 7 \times (7+40) = 22 \times 47 = 1034\ cm^2$.', 'An open cylinder loses one circular end, so its formula is $\pi r^2 + 2\pi rh$, not $2\pi r(r+h)$: a common trap is using the closed-cylinder formula by mistake.'),
  ('The total surface area of a solid cylinder is 88 cm², with height 7 cm. Find, to 3 s.f., its diameter (π = 22/7).', null, 'Diameter ≈ 3.25 cm', 'Diameter ≈ 1.63 cm', 'Diameter ≈ 6.50 cm', 'Diameter ≈ 12.6 cm', null, 'A', 4, 'GENERAL', 'Solving $2\pi r(r+7) = 88$ gives $r \approx 1.625\ cm$, so diameter $\approx 3.25\ cm$.', null),
  ('The curved surface area of a cylindrical tin is 704 cm² and its radius is 8 cm. Find its height (π = 22/7).', null, '10 cm', '12 cm', '14 cm', '16 cm', null, 'C', 2, 'GENERAL', '$704 = 2 \times \tfrac{22}{7} \times 8 \times h \Rightarrow h = 14\ cm$.', null),
  ('Write the formula for the total surface area of a cone in terms of base radius R and slant height l.', '$TSA = ?$', '$TSA = \pi R^2 h$', '$TSA = \pi R(R+l)$', '$TSA = \pi R l^2$', '$TSA = 2\pi R l$', null, 'B', 1, 'GENERAL', 'A cone''s TSA is the base circle plus the curved surface: $\pi R^2 + \pi Rl = \pi R(R+l)$.', null),
  ('What formula connects the slant height l, vertical height h, and base radius R of a cone?', '$l^2 = ?$', '$l^2 = h + R$', '$l^2 = h^2 + R^2$', '$l^2 = h^2 - R^2$', '$l^2 = 2hR$', null, 'B', 1, 'GENERAL', 'The vertical height, radius and slant height form a right triangle inside the cone, so by Pythagoras, $l^2 = h^2 + R^2$.', null),
  ('A cone has base radius 3 cm and vertical height 4 cm. Find its slant height.', null, '5 cm', '7 cm', '6 cm', '4.5 cm', null, 'A', 2, 'GENERAL', '$l^2 = 3^2+4^2 = 9+16 = 25 \Rightarrow l = 5\ cm$ (the 3-4-5 Pythagorean triple).', 'Spot Pythagorean triples (3-4-5, 5-12-13, 7-24-25, 8-15-17) inside cone problems to skip the square-root step.'),
  ('Find the total surface area of a cone with base radius 5 cm and vertical height 12 cm (leave in terms of π).', null, '85π cm²', '90π cm²', '65π cm²', '150π cm²', null, 'B', 3, 'GENERAL', '$l = \sqrt{5^2+12^2} = 13\ cm$. $TSA = \pi R(R+l) = \pi(5)(5+13) = 90\pi\ cm^2$.', null),
  ('A cone has slant height 10 cm and base radius 6 cm. Find (a) its vertical height, (b) its total surface area in terms of π.', null, 'h = 8 cm, TSA = 96π cm²', 'h = 6 cm, TSA = 60π cm²', 'h = 8 cm, TSA = 60π cm²', 'h = 10 cm, TSA = 96π cm²', null, 'A', 3, 'GENERAL', '$h = \sqrt{10^2-6^2} = 8\ cm$. $TSA = \pi(6)(6+10) = 96\pi\ cm^2$.', null),
  ('A sector of a circle of radius 15 cm and angle 216° is folded into a cone. Find (a) the base radius, (b) the vertical height.', null, 'R = 9 cm, h = 12 cm', 'R = 12 cm, h = 9 cm', 'R = 6 cm, h = 15 cm', 'R = 9 cm, h = 15 cm', null, 'A', 4, 'GENERAL', 'Arc length $= \tfrac{216}{360} \times 2\pi(15) = 2\pi R \Rightarrow R = 9\ cm$; slant height $l = 15\ cm$, so $h = \sqrt{15^2-9^2} = 12\ cm$.', null),
  ('Write the formula for the total surface area of a prism with base perimeter P, base area A, and length L.', '$TSA = ?$', '$TSA = A \times L$', '$TSA = 2A + PL$', '$TSA = PA$', '$TSA = 2P + AL$', null, 'B', 2, 'GENERAL', 'A prism''s TSA is the two end faces (base area A, twice) plus the rectangular side faces (base perimeter times length): $TSA = 2A + PL$.', null),
  ('A square-based pyramid has base side 10 cm and slant height (of a triangular face) 12 cm. Find its total surface area.', null, '340 cm²', '580 cm²', '220 cm²', '100 cm²', null, 'A', 3, 'GENERAL', '$TSA = l^2 + 2ls = 10^2 + 2(10)(12) = 100+240 = 340\ cm^2$.', null),
  ('What is the difference between the vertical height and the slant height of a cone or pyramid?', null, 'They are always equal in any cone or pyramid', 'Vertical height runs from the apex straight down to the centre of the base; slant height runs along a face from the apex to the base edge', 'Slant height is always shorter than the vertical height', 'Vertical height is only used for surface area, slant height only for volume', null, 'B', 2, 'GENERAL', 'Vertical height is the perpendicular distance apex-to-base-centre; slant height runs down a triangular or curved face to the base edge, and the two are only equal for a flat (degenerate) shape.', null),
  ('A triangular prism has a right-triangular cross-section of legs 5 cm and 12 cm, and length 20 cm. Find its total surface area.', null, '600 cm²', '660 cm²', '360 cm²', '780 cm²', null, 'B', 4, 'GENERAL', 'Hypotenuse $= \sqrt{5^2+12^2} = 13\ cm$. $TSA = 2(\tfrac{1}{2}\times5\times12) + (5+12+13)(20) = 60+600 = 660\ cm^2$.', null),
  ('A cylindrical drum has radius 50 cm and height 1.2 m. Before applying the TSA formula 2πr(r+h), what must be checked first?', null, 'That the radius and height are converted to the same units', 'That the drum is open at the top', 'That π is taken as 3.142, never 22/7', 'That the drum''s volume is calculated first', null, 'A', 2, 'GENERAL', 'r is in cm and h is in m here, so one must be converted (e.g. h = 120 cm) before substituting, or the TSA will be wrong.', null),
  ('State the curved surface area formula for an open-top cylinder of radius r and height h.', null, '$CSA = \pi r(r+2h)$', '$CSA = 2\pi rh$', '$CSA = \pi r^2 + 2\pi rh$', '$CSA = \pi r^2$', null, 'B', 1, 'GENERAL', 'The curved surface area is the same whether a cylinder is open or closed, $CSA = 2\pi rh$; only the TSA formula changes.', null),
  ('A hemisphere of radius r sits on top of a cylinder of the same radius. Which surfaces are excluded from the total exposed surface area?', null, 'The curved surface of the cylinder only', 'The circular top of the cylinder and the flat circular base of the hemisphere, since they are joined together', 'The flat base of the cylinder only', 'None, all surfaces remain exposed', null, 'B', 2, 'GENERAL', 'Where two solids are glued together, the joined faces are hidden inside the compound solid and must not be counted in the exposed TSA.', null),
  ('Two similar cylindrical jugs have radii in ratio 3:7. What is the ratio of their curved surface areas?', null, '3:7', '9:49', '6:14', '27:343', null, 'A', 3, 'GENERAL', 'For similar shapes, $CSA = 2\pi rh \propto r$, so the CSA ratio equals the linear ratio, $3:7$.', 'Area ratios of similar shapes scale as the square of the linear ratio only when both dimensions scale together; here CSA depends linearly on r for a fixed height ratio matching r, so it stays 3:7.'),
  ('State the general formula for the volume of any prism.', '$V = ?$', '$V = \text{Base area} \times \text{height}$', '$V = \tfrac{1}{3} \times \text{Base area} \times \text{height}$', '$V = \text{Perimeter} \times \text{height}$', '$V = \text{Base area}^2$', null, 'A', 1, 'GENERAL', 'Any solid with a uniform cross-section (a prism, including a cylinder) has volume equal to base area times height.', null),
  ('State the general formula for the volume of any pyramid or cone.', '$V = ?$', '$V = \text{Base area} \times \text{height}$', '$V = \tfrac{1}{3} \times \text{Base area} \times \text{height}$', '$V = \tfrac{1}{2} \times \text{Base area} \times \text{height}$', '$V = \text{Base area} \times \text{slant height}$', null, 'B', 1, 'GENERAL', 'A pyramid or cone tapers to a point, so its volume is exactly one-third of the prism/cylinder sharing the same base and height.', null),
  ('A cube has side 4 cm. Find its volume.', null, '16 cm³', '48 cm³', '64 cm³', '12 cm³', null, 'C', 1, 'GENERAL', '$V = l^3 = 4^3 = 64\ cm^3$.', null),
  ('A cylindrical oil drum has radius 0.7 m and height 1.5 m. How many litres does it hold (π = 22/7)?', null, '2310 litres', '1540 litres', '2100 litres', '3300 litres', null, 'A', 3, 'GENERAL', '$V = \pi r^2 h = \tfrac{22}{7}(0.49)(1.5) = 2.31\ m^3 = 2310$ litres.', null),
  ('A cylindrical tank of length 24 cm has volume 14 784 cm³. Find its radius (π = 22/7).', null, '12 cm', '14 cm', '16 cm', '10 cm', null, 'B', 3, 'GENERAL', '$r^2 = \dfrac{14784 \times 7}{22 \times 24} = 196 \Rightarrow r = 14\ cm$.', null),
  ('A cylindrical container of base radius 4 cm has volume 352 cm³. Find its depth (π = 22/7).', null, '5 cm', '6 cm', '7 cm', '8 cm', null, 'C', 2, 'GENERAL', '$h = \dfrac{352 \times 7}{22 \times 16} = 7\ cm$.', null),
('The volume of a cube-shaped tank is 0.216 m³. Find the length of one side.', null, '0.4 m', '0.5 m', '0.6 m', '0.7 m', null, 'C', 3, 'GENERAL', '$V = l^3 = 0.216 \Rightarrow l = \sqrt[3]{0.216} = 0.6\ m$, since $0.6^3 = 0.216$.', 'Recognise 0.216 as $0.6^3$ instantly by noticing $216 = 6^3$ and shifting the decimal point appropriately.'),
  ('A cylindrical tank with diameter 1 m and height 2 m is half filled with water. Find the volume of water, in terms of π.', null, 'π/4 m³', 'π/2 m³', 'π m³', '2π m³', null, 'A', 3, 'GENERAL', 'Radius $=0.5\ m$. Full volume $=\pi(0.5)^2(2)=0.5\pi\ m^3$; half filled $= 0.25\pi = \pi/4\ m^3$.', null),
  ('A tin of milk has height 10.3 cm and base radius 6.8 cm. Find the volume of liquid it holds, in litres (π = 22/7).', null, 'About 1.497 litres', 'About 2.994 litres', 'About 0.749 litres', 'About 14.97 litres', null, 'A', 4, 'GENERAL', '$V = \pi r^2 h \approx \tfrac{22}{7}(6.8^2)(10.3) \approx 1497\ cm^3 \approx 1.497$ litres.', null),
  ('Find the capacity in litres of a cylinder of diameter 18 cm and height 17 cm (π = 22/7).', null, 'About 4.328 litres', 'About 2.164 litres', 'About 8.656 litres', 'About 1.082 litres', null, 'A', 4, 'GENERAL', 'Radius $=9\ cm$. $V = \tfrac{22}{7}(81)(17) \approx 4327.71\ cm^3 \approx 4.328$ litres.', null),
  ('The volume of a cylinder is 1200 cm³ and its base area is 150 cm². Find its height.', null, '6 cm', '7 cm', '8 cm', '9 cm', null, 'C', 1, 'GENERAL', '$h = V \div \text{base area} = 1200 \div 150 = 8\ cm$.', null),
  ('The radii of two similar cylindrical jugs are in ratio 3:7. Find the ratio of their volumes.', null, '3:7', '9:49', '27:343', '6:14', null, 'C', 3, 'GENERAL', 'Volume ratios of similar solids scale as the cube of the linear ratio: $3^3:7^3 = 27:343$.', null),
  ('Two similar cylinders have volumes in ratio 216:125; the taller one is 30 cm high. Find the height of the smaller one.', null, '20 cm', '25 cm', '15 cm', '18 cm', null, 'B', 4, 'GENERAL', 'Volume ratio $216:125 = 6^3:5^3$, so the linear (height) ratio is $6:5$. Smaller height $= 30 \times \tfrac{5}{6} = 25\ cm$.', null),
  ('Write the formula for the volume of a cone.', '$V=?$', '$V = \pi r^2 h$', '$V = \tfrac{1}{3}\pi r^2 h$', '$V = \tfrac{2}{3}\pi r^3$', '$V = \tfrac{4}{3}\pi r^3$', null, 'B', 1, 'GENERAL', 'A cone is one-third of the cylinder sharing its base and height: $V = \tfrac{1}{3}\pi r^2 h$.', null),
  ('To find the volume of a cone, which height must you use?', null, 'The slant height', 'The vertical height', 'Either, they give the same answer', 'The average of both', null, 'B', 1, 'GENERAL', 'Volume formulas always need the vertical (perpendicular) height, not the slant height, which is only used for surface area.', null),
  ('A cone has volume 110 cm³ and height 21 cm. Find its base radius (π = 22/7).', null, '√5 cm ≈ 2.24 cm', '5 cm', '√10 cm ≈ 3.16 cm', '2.5 cm', null, 'A', 4, 'GENERAL', '$110 = \tfrac{1}{3}\times\tfrac{22}{7}\times r^2 \times 21 = 22r^2 \Rightarrow r^2 = 5 \Rightarrow r = \sqrt5 \approx 2.24\ cm$.', null),
  ('Find the volume of a cone with radius 7 cm and slant height 25 cm (π = 22/7).', null, '1232 cm³', '1848 cm³', '616 cm³', '2464 cm³', null, 'A', 4, 'GENERAL', '$h = \sqrt{25^2-7^2} = 24\ cm$. $V = \tfrac13 \times \tfrac{22}{7} \times 49 \times 24 = 1232\ cm^3$.', null),
  ('A cylindrical container 20 cm deep holds 3.08 litres of water. Find its radius (π = 22/7).', null, '5 cm', '6 cm', '7 cm', '8 cm', null, 'C', 3, 'GENERAL', '$V = 3080\ cm^3$. $r^2 = \dfrac{3080 \times 7}{22 \times 20} = 49 \Rightarrow r = 7\ cm$.', null),
  ('A cone and a cylinder have the same radius and height. If the cylinder''s volume is 30 m³, what is the cone''s volume?', null, '30 m³', '15 m³', '10 m³', '90 m³', null, 'C', 2, 'GENERAL', 'A cone''s volume is always one-third of a cylinder sharing its base and height: $30 \div 3 = 10\ m^3$.', null),
  ('State the relationship between the volume of a cone and a cylinder with the same base and height.', null, 'Cone = cylinder', 'Cone = half of cylinder', 'Cone = one-third of cylinder', 'Cone = twice the cylinder', null, 'C', 1, 'GENERAL', 'Any pyramid or cone has exactly one-third the volume of the prism or cylinder sharing its base and height.', null),
  ('A square-based pyramid has base side 10 cm and slant height (of a triangular face) 13 cm. Find its volume.', null, '400 cm³', '360 cm³', '433 cm³', '520 cm³', null, 'A', 4, 'GENERAL', 'Apothem $=5\ cm$; vertical height $h=\sqrt{13^2-5^2}=12\ cm$; base area $=100\ cm^2$; $V=\tfrac13(100)(12)=400\ cm^3$.', null),
  ('A square-based pyramid has base side 18 cm and vertical height 12 cm. Find its volume.', null, '1296 cm³', '648 cm³', '2592 cm³', '864 cm³', null, 'A', 2, 'GENERAL', '$V = \tfrac13 (18^2)(12) = \tfrac13(324)(12) = 1296\ cm^3$.', null),
  ('A triangular prism has a right-triangular base of legs 5 cm and 12 cm, and length 20 cm. Find its volume.', null, '600 cm³', '300 cm³', '1200 cm³', '780 cm³', null, 'A', 2, 'GENERAL', 'Base area $= \tfrac12(5)(12)=30\ cm^2$; $V = 30 \times 20 = 600\ cm^3$.', null),
  ('A hemisphere of radius 7 cm sits atop a cylinder of radius 7 cm, height 10 cm. Find the total volume (π = 22/7).', null, '2258.67 cm³', '1540 cm³', '718.67 cm³', '3080 cm³', null, 'A', 4, 'GENERAL', '$V(\text{cylinder}) = 1540\ cm^3$; $V(\text{hemisphere}) = \tfrac23 \times \tfrac{22}{7} \times 343 \approx 718.67\ cm^3$; total $\approx 2258.67\ cm^3$.', null),
  ('How many cm³ are in 1 litre?', null, '100 cm³', '1000 cm³', '10 000 cm³', '10 cm³', null, 'B', 1, 'GENERAL', 'By definition, $1$ litre $= 1000\ cm^3$.', null),
  ('A drum of radius 50 cm and height 1.2 m is filled with water using a bucket of top radius 15 cm, bottom radius 10 cm, height 50 cm (π = 22/7). How many bucket-fuls fill the drum, to the nearest whole bucket?', null, '38 buckets', '30 buckets', '45 buckets', '52 buckets', null, 'A', 5, 'GENERAL', 'Drum volume $= \pi(50)^2(120) \approx 942\,857\ cm^3$; bucket (frustum) volume $\approx 24\,791\ cm^3$; ratio $\approx 38$ buckets.', null),
  ('A bucket holds 10 litres of water. How many buckets fill a reservoir of size 8 m × 7 m × 5 m?', null, '2800 buckets', '280 buckets', '28 000 buckets', '56 buckets', null, 'C', 3, 'GENERAL', 'Reservoir volume $= 8 \times 7 \times 5 = 280\ m^3 = 280\,000$ litres; buckets $=280\,000 \div 10 = 28\,000$.', null),
  ('A rectangular tank 11 m × 2 m × 7 m has the same volume as a cylindrical tank of height 4 m. Find the cylinder''s radius (π = 22/7).', null, '3.5 m', '7 m', '4 m', '2.5 m', null, 'A', 4, 'GENERAL', 'Tank volume $= 11\times2\times7 = 154\ m^3$. $154 = \tfrac{22}{7}r^2(4) \Rightarrow r^2 = 12.25 \Rightarrow r = 3.5\ m$.', null)
) as v(question_text, question_latex, option_a, option_b, option_c, option_d, option_e, correct_letter, difficulty, exam_type, explanation, exam_shortcut);

-- ==========================================
-- TOPIC 302: Frustums & Angle Sum of a Triangle
-- Source: Third Term Week 3 (frustums of cones and pyramids) + the
-- numeric-application half of Week 4 (angle sum = 180 degrees, exterior
-- angle theorem). Questions: Week 3 Q1-20 (20) + Week 4 numeric
-- application Q7,8,9,10,12,13,15,16,17,18,20 (11) = 31 total.
-- ==========================================

with lesson as (
  insert into public.lessons (topic_id, title, summary, content_body, order_index)
  values (
    (select t.id from public.topics t join public.curricula c on c.id = t.curriculum_id
     where c.subject = 'Mathematics' and t.class_level = 'SS1' and t.term = 3 and t.order_index = 302),
    'Frustums of Cones and Pyramids; Angle Sum of a Triangle',
    'Finding the volume and surface area of frustums using the "large minus small" strategy, and applying the fact that a triangle''s angles sum to 180 degrees.',
    '## Frustums

A **frustum** is the solid left when the top of a cone or pyramid is sliced off by a cut parallel to the base (e.g. a bucket, a lampshade, a flower vase). The standard strategy is: **large solid minus small solid**.

Let $R$ = radius (or half-base) of the large base, $r$ = radius of the small (top) face, $H$ = height of the complete original cone/pyramid, $h_s$ = height of the removed small cone/pyramid, $h_f$ = height of the frustum, so $H = h_s + h_f$. Because the small cone/pyramid is similar to the large one:

$$\dfrac{r}{R} = \dfrac{h_s}{H}$$

Solve this (usually by cross-multiplication) to find $h_s$, then $H = h_s + h_f$.

**Volume of a frustum (cone):** $V = \tfrac13\pi R^2 H - \tfrac13\pi r^2 h_s$, which is also equal to the direct formula $V = \dfrac{\pi}{3}h_f(R^2+Rr+r^2)$.

**Volume of a frustum (pyramid):** $V = \tfrac13(\text{base area})H - \tfrac13(\text{top area})h_s$.

**Surface area of a frustum (cone):** $CSA = \pi RL - \pi r l_s$ (difference of the two cones'' curved surfaces); $TSA = \pi R^2 + \pi r^2 + CSA$.

## Angle Sum of a Triangle

An **axiom** is a statement accepted as true without proof; a **theorem** is proved true using logic and axioms.

**The sum of the angles in any triangle is $180^\circ$.**

**The exterior angle of a triangle equals the sum of the two opposite (remote) interior angles.**

**Key exam habits:** always draw the "phantom" small cone/pyramid above a frustum first, labelling $H$, $h_s$, $h_f$; simplify the $r/R$ ratio to lowest terms before cross-multiplying; a frustum volume must always be less than the volume of the complete large solid; for triangle angle problems, if you know two angles the third is always $180^\circ$ minus their sum, and any angle set that does not sum to $180^\circ$ cannot be a real triangle.',
    1
  )
  returning id
),
we1 as (
  insert into public.worked_examples (lesson_id, title, problem_statement, solution_steps, exam_shortcut, real_life_context, diagram_type, diagram_data, status)
  select id,
    'Volume of a Bucket-Shaped Frustum',
    'A bucket is 28 cm high (frustum height); its top and bottom radii are 10 cm and 15 cm. Find its volume (use $\pi = \tfrac{22}{7}$).',
    to_jsonb(array[
      'Sketch the idea: the bucket is a large cone (radius 15 cm) with a small cone (radius 10 cm) sliced off the top. Let $h_s$ = height of the removed small cone, $H$ = height of the whole original cone.',
      'Set up the similar-triangle ratio: $\dfrac{r}{R} = \dfrac{h_s}{H}$, i.e. $\dfrac{10}{15} = \dfrac{h_s}{h_s+28}$ (since $H = h_s+28$).',
      'Cross-multiply: $15h_s = 10(h_s+28)$.',
      'Expand and collect: $15h_s = 10h_s + 280 \Rightarrow 5h_s = 280 \Rightarrow h_s = 56\ cm$.',
      'Find the full height: $H = h_s + 28 = 56+28 = 84\ cm$.',
      'Volume of the large cone: $V(\text{large}) = \tfrac13 \times \tfrac{22}{7} \times 15^2 \times 84 = 19\,800\ cm^3$.',
      'Volume of the small cone: $V(\text{small}) = \tfrac13 \times \tfrac{22}{7} \times 10^2 \times 56 \approx 5866.67\ cm^3$.',
      'Subtract: $V(\text{frustum}) = 19\,800 - 5866.67 = 13\,933.33\ cm^3$.',
      'Answer: $V(\text{frustum}) \approx 13\,933.33\ cm^3$.'
    ]),
    'Use the direct formula $V = \tfrac{\pi}{3}h_f(R^2+Rr+r^2)$ instead of "large minus small" whenever $h_f$, $R$, and $r$ are already known directly, it is one substitution instead of two full volume calculations and a subtraction.',
    'This is exactly the shape of a builder''s mixing bucket or a Nigerian household water-fetching bucket, both wider at the top than the bottom, and the same method finds how much water or cement mix one holds.',
    'none', '{}'::jsonb,
    'published'
  from lesson
  returning id
),
we2 as (
  insert into public.worked_examples (lesson_id, title, problem_statement, solution_steps, exam_shortcut, real_life_context, diagram_type, diagram_data, status)
  select id,
    'Finding an Unknown Angle Using the Angle Sum of a Triangle',
    'In a triangle, the three angles are $2x$, $3x$, and $40^\circ$. Find $x$.',
    to_jsonb(array[
      'Apply the angle-sum theorem: the three angles of any triangle add to $180^\circ$, so $2x + 3x + 40 = 180$.',
      'Collect the like ($x$) terms on the left: $2x+3x = 5x$, so the equation becomes $5x+40=180$.',
      'Subtract 40 from both sides: $5x = 180-40 = 140$.',
      'Divide both sides by 5: $x = 140/5 = 28$.',
      'Check by substituting back: angles are $2(28)=56^\circ$, $3(28)=84^\circ$, and $40^\circ$; sum $=56+84+40=180^\circ$. ✓',
      'Answer: $x = 28^\circ$.'
    ]),
    'Watch for triangles described by ratios (e.g. 2:3:4): add the ratio parts, divide $180^\circ$ by that total to get the value of "one part", then multiply each ratio number by that value, this is faster than writing full equations.',
    'A surveyor laying out a triangular plot of land uses exactly this kind of equation to find an unknown boundary angle from two known ones before drawing the site plan.',
    'triangle',
    '{"vertices": [{"label": "A", "x": 0, "y": 0}, {"label": "B", "x": 6, "y": 0}, {"label": "C", "x": 2, "y": 4}], "angleLabels": [{"vertex": "A", "label": "2x = 56°"}, {"vertex": "B", "label": "3x = 84°"}, {"vertex": "C", "label": "40°"}]}'::jsonb,
    'published'
  from lesson
  returning id
)
insert into public.worked_examples (lesson_id, title, problem_statement, solution_steps, exam_shortcut, real_life_context, diagram_type, diagram_data, status)
select id,
  'Exterior Angle of a Triangle',
  'In triangle $ABC$, $\angle A = 50^\circ$ and $\angle B = 70^\circ$. Find the exterior angle at $C$.',
  to_jsonb(array[
    'Identify which theorem applies: the exterior angle at any vertex equals the sum of the two remote (non-adjacent) interior angles, here $\angle A$ and $\angle B$.',
    'Apply the theorem directly: exterior angle at $C = \angle A + \angle B = 50^\circ + 70^\circ$.',
    'Add: $50+70=120$.',
    'Cross-check using the straight-line method: first find $\angle C = 180-50-70=60^\circ$; the exterior angle at $C$ is then $180-60=120^\circ$ (angles on a straight line), matching the answer above.',
    'Answer: exterior angle at $C = 120^\circ$.'
  ]),
  'To find an exterior angle you can use either "sum of the two remote interior angles" or "180° minus the interior angle at that vertex", doing both is a fast, free way to double-check your working in an exam.',
  'A carpenter extending a triangular roof truss''s bottom beam to check the roof''s outward-facing angle uses exactly this exterior-angle relationship.',
  'triangle',
  '{"vertices": [{"label": "A", "x": 0, "y": 0}, {"label": "B", "x": 6, "y": 0}, {"label": "C", "x": 4, "y": 3.5}], "angleLabels": [{"vertex": "A", "label": "50°"}, {"vertex": "B", "label": "70°"}, {"vertex": "C", "label": "60°"}]}'::jsonb,
  'published'
from we1;

insert into public.questions (topic_id, question_text, question_latex, option_a, option_b, option_c, option_d, option_e, correct_letter, difficulty, exam_type, explanation, exam_shortcut, status)
select topic_ref.tid, v.question_text, v.question_latex, v.option_a, v.option_b, v.option_c, v.option_d, v.option_e, v.correct_letter, v.difficulty, v.exam_type, v.explanation, v.exam_shortcut, 'published'
from (select t.id as tid from public.topics t join public.curricula c on c.id = t.curriculum_id
      where c.subject = 'Mathematics' and t.class_level = 'SS1' and t.term = 3 and t.order_index = 302) topic_ref,
lateral (values
  ('What is a frustum?', null::text, 'The part of a cone or pyramid left after slicing off the top parallel to the base', 'Any solid with a circular cross-section', 'The net of a cone unfolded flat', 'A cone with its apex removed and replaced by a sphere', null::text, 'A', 1, 'GENERAL'::exam_type, 'A frustum is exactly the shape remaining when a cone or pyramid''s top is cut off by a plane parallel to its base.', null::text),
  ('What key mathematical principle is used to find the "missing" height of the original cone or pyramid above a frustum?', null, 'Similar triangles', 'The Pythagorean theorem', 'Congruent triangles', 'The angle sum of a triangle', null, 'A', 2, 'GENERAL', 'The small removed cone/pyramid is similar (same shape, different size) to the whole original one, so ratios of corresponding lengths are equal.', null),
  ('Write the similar-triangle ratio linking the radii and heights of a cone frustum (r = small radius, R = large radius, hₛ = removed height, H = whole height).', '$\dfrac{r}{R} = ?$', '$\dfrac{r}{R} = \dfrac{h_s}{H}$', '$\dfrac{r}{R} = \dfrac{H}{h_s}$', '$\dfrac{R}{r} = \dfrac{h_s}{H}$', '$r \times R = h_s \times H$', null, 'A', 2, 'GENERAL', 'The small cone is similar to the large one, so the ratio of radii equals the ratio of heights measured from the same apex: $r/R = h_s/H$.', null),
  ('Write the direct volume formula for a cone frustum of height h, large radius R, small radius r.', '$V = ?$', '$V = \pi h(R+r)$', '$V = \dfrac{\pi}{3}h(R^2+Rr+r^2)$', '$V = \pi R^2 h$', '$V = \dfrac{\pi}{3}(R+r)^2 h$', null, 'B', 2, 'GENERAL', 'This direct formula comes from subtracting the small cone''s volume from the large cone''s volume and simplifying algebraically.', null),
  ('Write the formula for the total surface area of a cone frustum (R, r = radii; L, lₛ = large/small slant heights).', '$TSA = ?$', '$TSA = \pi R^2 + \pi r^2 + \pi(RL - r l_s)$', '$TSA = \pi(R+r)^2$', '$TSA = \pi RL$', '$TSA = 2\pi(R+r)$', null, 'A', 3, 'GENERAL', 'TSA of a frustum adds the two flat circular ends to the curved surface, which is the difference of the two cones'' curved surfaces.', null),
  ('A frustum of a cone has top radius 5 cm, bottom radius 10 cm, vertical height 12 cm. Find (a) the height of the small cone cut off, (b) the volume of the frustum (leave in terms of π).', null, 'hₛ = 12 cm, V = 700π cm³', 'hₛ = 6 cm, V = 500π cm³', 'hₛ = 24 cm, V = 800π cm³', 'hₛ = 12 cm, V = 900π cm³', null, 'A', 4, 'GENERAL', '$5/10 = h_s/(h_s+12) \Rightarrow H=24, h_s=12$. $V(\text{large})=800\pi$, $V(\text{small})=100\pi$, $V(\text{frustum})=700\pi\ cm^3$.', null),
  ('A frustum is cut from a square-based pyramid; large base 15 cm, small base 5 cm, frustum height 6 cm. Find (a) the height of the original pyramid, (b) the volume of the frustum.', null, 'H = 9 cm, V = 650 cm³', 'H = 12 cm, V = 700 cm³', 'H = 9 cm, V = 600 cm³', 'H = 15 cm, V = 675 cm³', null, 'A', 4, 'GENERAL', '$5/15 = h_s/(h_s+6) \Rightarrow h_s=3, H=9$. $V(\text{large})=675$, $V(\text{small})=25$, $V(\text{frustum})=650\ cm^3$.', null),
  ('A bucket is 28 cm high with top and bottom radii 15 cm and 10 cm (π = 22/7). Find its volume.', null, '13 933.33 cm³', '19 800 cm³', '5866.67 cm³', '9800 cm³', null, 'A', 4, 'GENERAL', 'Large cone $19\,800\ cm^3$ minus small cone $5866.67\ cm^3$ gives $13\,933.33\ cm^3$.', null),
  ('A frustum has top radius 4 cm, bottom radius 8 cm, slant height 5 cm. Find its vertical height.', null, '2 cm', '3 cm', '4 cm', '5 cm', null, 'B', 3, 'GENERAL', 'Using the slant-height right triangle for the removed portion of the frustum, the vertical height works out to 3 cm.', null),
  ('A frustum of a pyramid with square base has top and bottom squares of side 2 m and 5 m, and the sections are 6 m apart. Find the height of the whole pyramid.', null, '10 m', '8 m', '12 m', '6 m', null, 'A', 4, 'GENERAL', '$2/5 = h_s/(h_s+6) \Rightarrow 5h_s=2h_s+12 \Rightarrow h_s=4, H=10\ m$.', null),
  ('A frustum of a pyramid with square base has top and bottom squares of side 7 m and 13 m, 10 m apart. Find the height of the whole pyramid.', null, 'About 21.67 m', 'About 18 m', 'About 15 m', 'About 25 m', null, 'A', 4, 'GENERAL', '$7/13 = h_s/(h_s+10) \Rightarrow 13h_s=7h_s+70 \Rightarrow h_s \approx 11.67, H \approx 21.67\ m$.', null),
  ('Find the height of the cone cut off to leave a frustum with top radius 4 cm and bottom radius 8 cm, height of frustum 6 cm.', null, '4 cm', '6 cm', '8 cm', '12 cm', null, 'B', 3, 'GENERAL', '$4/8 = h_s/(h_s+6) \Rightarrow 8h_s=4h_s+24 \Rightarrow h_s=6\ cm$.', null),
  ('A frustum has top radius 6 cm, bottom radius 8 cm, frustum height 10 cm. Find (i) the height of the whole cone, (ii) the volume of the frustum to the nearest whole number (π = 22/7).', null, 'H = 40 cm, V ≈ 1550 cm³', 'H = 30 cm, V ≈ 1200 cm³', 'H = 40 cm, V ≈ 1200 cm³', 'H = 24 cm, V ≈ 900 cm³', null, 'A', 4, 'GENERAL', '$6/8=h_s/(h_s+10)\Rightarrow h_s=30, H=40$. Direct formula gives $V\approx1550\ cm^3$.', null),
  ('A bucket is 28 cm in diameter at the top, 18 cm in diameter at the bottom, and 20 cm deep. Find its capacity in litres (π = 3.142).', null, 'About 8.44 litres', 'About 4.22 litres', 'About 16.88 litres', 'About 2.11 litres', null, 'A', 5, 'GENERAL', 'R=14, r=9, h=20; $V=\tfrac{\pi}{3}h(R^2+Rr+r^2)\approx8441.65\ cm^3\approx8.44$ litres.', null),
  ('A flower vase 8 cm high is a frustum of a square-based pyramid, side 6 cm at the bottom and 10 cm at the top. Find the volume of water it holds when full.', null, 'About 522.67 cm³', 'About 480 cm³', 'About 600 cm³', 'About 261.33 cm³', null, 'A', 5, 'GENERAL', 'Using $V=\tfrac{h}{3}(A_1+A_2+\sqrt{A_1A_2})$ with $A_1=36, A_2=100$: $V=\tfrac83(36+100+60)\approx522.67\ cm^3$.', null),
  ('A frustum of a square-based pyramid is 4 m at the top and 12 m at the bottom, height 10 m. Find (i) the height of the whole pyramid, (ii) the volume of the frustum to the nearest whole number.', null, 'H = 15 m, V ≈ 693 m³', 'H = 12 m, V ≈ 720 m³', 'H = 15 m, V ≈ 720 m³', 'H = 20 m, V ≈ 800 m³', null, 'A', 4, 'GENERAL', '$4/12=h_s/(h_s+10)\Rightarrow h_s=5, H=15$. $V(\text{large})=720, V(\text{small})\approx26.67, V(\text{frustum})\approx693\ m^3$.', null),
  ('A drum of radius 50 cm and height 1.2 m is filled using a frustum-shaped bucket (top radius 15 cm, bottom radius 10 cm, height 50 cm). Find the number of buckets needed to fill the drum, to the nearest whole bucket (π = 22/7).', null, '38 buckets', '30 buckets', '45 buckets', '25 buckets', null, 'A', 5, 'GENERAL', 'Drum volume divided by the frustum bucket''s volume rounds to 38 buckets.', null),
  ('When finding the total surface area of a compound shape (e.g. a cone sitting on a cylinder), what must you be careful not to include?', null, 'The base of the cylinder', 'The "hidden" joined surfaces, e.g. the cone''s base and the cylinder''s top, which are not exposed', 'The curved surface of the cone', 'The curved surface of the cylinder', null, 'B', 2, 'GENERAL', 'Wherever two solids are glued together, that shared face is internal, not part of the exposed surface, and must be left out of the TSA.', null),
  ('A solid object is made of a cylinder of height 10 cm and radius 3 cm, topped by a hemisphere of radius 3 cm. Find (a) the total volume, (b) the total surface area, both in terms of π.', null, 'V = 108π cm³, TSA = 87π cm²', 'V = 90π cm³, TSA = 78π cm²', 'V = 108π cm³, TSA = 78π cm²', 'V = 126π cm³, TSA = 96π cm²', null, 'A', 5, 'GENERAL', '$V=90\pi+18\pi=108\pi\ cm^3$; $TSA=60\pi+9\pi+18\pi=87\pi\ cm^2$ (cylinder curved + exposed base + hemisphere curved).', null),
  ('State the "large minus small" volume strategy for any frustum problem in one sentence.', null, 'Volume of frustum = volume of the complete large solid minus the volume of the small solid removed from the top', 'Volume of frustum = base area times the frustum height', 'Volume of frustum = average of the two end areas times the height', 'Volume of frustum = volume of the small solid alone', null, 'A', 1, 'GENERAL', 'A frustum is what remains after the small top solid is removed from the complete original large solid, so its volume is the large solid''s volume minus the small solid''s volume.', null),
  ('In a triangle, the angles are 2x, 3x and 40°. Find x.', null, '20°', '28°', '35°', '32°', null, 'B', 2, 'GENERAL', '$2x+3x+40=180 \Rightarrow 5x=140 \Rightarrow x=28^\circ$.', null),
  ('Triangle ABC has ∠A = 50° and ∠B = 70°. Find the exterior angle at C.', null, '100°', '110°', '120°', '130°', null, 'C', 2, 'GENERAL', 'Exterior angle at $C = \angle A+\angle B = 50+70=120^\circ$.', null),
  ('One angle in a right triangle is 90°; the other two are x and 2x. Find x.', null, '20°', '25°', '30°', '35°', null, 'C', 2, 'GENERAL', '$90+x+2x=180 \Rightarrow 3x=90 \Rightarrow x=30^\circ$.', null),
  ('The exterior angle of a triangle is 110°; one of its opposite (remote) interior angles is 40°. Find the other remote interior angle.', null, '60°', '65°', '70°', '75°', null, 'C', 2, 'GENERAL', 'Exterior angle = sum of the two remote interior angles: $110=40+x \Rightarrow x=70^\circ$.', null),
  ('The angles of a triangle are in the ratio 2:3:4. Find the largest angle.', null, '60°', '70°', '80°', '90°', null, 'C', 2, 'GENERAL', 'Ratio parts sum to 9; one part $=180/9=20^\circ$. Angles are $40^\circ,60^\circ,80^\circ$; largest is $80^\circ$.', null),
  ('In triangle PQR, ∠P = 2x, ∠Q = 3x, and the exterior angle at R is 140°. Find x.', null, '20°', '24°', '28°', '32°', null, 'C', 3, 'GENERAL', 'Exterior angle at R = sum of remote angles: $140=2x+3x=5x \Rightarrow x=28^\circ$.', null),
  ('A triangle has one angle of 90°. If the other two are in the ratio 1:2, find the smaller of the two.', null, '20°', '25°', '30°', '35°', null, 'C', 2, 'GENERAL', 'The two remaining angles sum to $90^\circ$ and are in ratio 1:2, so 3 parts = 90°, one part = 30°, giving 30° and 60°; the smaller is 30°.', null),
  ('Find x: the angles of a triangle are (2x+10)°, (3x−5)°, and (x+25)°.', null, '20°', '22°', '25°', '28°', null, 'C', 3, 'GENERAL', 'Sum of angles: $(2x+10)+(3x-5)+(x+25)=180 \Rightarrow 6x+30=180 \Rightarrow 6x=150 \Rightarrow x=25$.', null),
  ('A triangle''s interior angles are x, (x+10)°, and (x+20)°. Find the largest angle.', null, '60°', '65°', '70°', '75°', null, 'C', 2, 'GENERAL', '$x+(x+10)+(x+20)=180 \Rightarrow 3x+30=180 \Rightarrow x=50$; largest angle $=x+20=70^\circ$.', null),
  ('Two angles of an isosceles triangle are equal, and the third is 40° larger than each equal angle. Find each equal angle, to 1 decimal place.', null, 'About 46.7°', 'About 50.0°', 'About 43.3°', 'About 53.3°', null, 'A', 3, 'GENERAL', '$2x+(x+40)=180 \Rightarrow 3x=140 \Rightarrow x\approx46.7^\circ$.', null)
) as v(question_text, question_latex, option_a, option_b, option_c, option_d, option_e, correct_letter, difficulty, exam_type, explanation, exam_shortcut);

-- ==========================================
-- TOPIC 303: Geometrical Construction: Triangles & Line Segments
-- Source: Third Term Week 5 (bisection of a line segment; bisection of
-- angles; construction of 90 degrees, 60 degrees, 45 degrees, 135
-- degrees, 22.5 degrees; triangle construction using these angles).
-- Questions: Week 5 Q1-20 (20 total).
-- ==========================================

with lesson as (
  insert into public.lessons (topic_id, title, summary, content_body, order_index)
  values (
    (select t.id from public.topics t join public.curricula c on c.id = t.curriculum_id
     where c.subject = 'Mathematics' and t.class_level = 'SS1' and t.term = 3 and t.order_index = 303),
    'Geometrical Construction: Bisecting Lines and Angles; 90°, 45°, 135°, 22½°',
    'Using only a straightedge and compasses to bisect a line segment or an angle, and to construct 90 degrees, 45 degrees, 135 degrees and 22.5 degrees.',
    '## Tools and Ground Rules

Pure geometric construction uses only two tools: an **unmarked straightedge** (for drawing straight lines) and a **pair of compasses** (for drawing arcs and circles). A protractor may only be used to *check* a finished construction, never to create an angle. Never erase construction arcs, they are the visible proof of method, and WAEC/NECO examiners look for them.

## Bisecting a Line Segment

To bisect a line segment $AB$ (find its perpendicular bisector):
1. Open the compass to a radius **more than half** of $AB$.
2. With the point on $A$, draw an arc above the line and another below it.
3. Keeping the same radius, repeat from $B$, so the new arcs cross the first pair at two points.
4. Join those two crossing points with a straight line, this is the perpendicular bisector of $AB$: every point on it is equidistant from $A$ and $B$, and it crosses $AB$ at its exact midpoint.

## Bisecting an Angle

To bisect an angle $\angle ABC$:
1. Place the compass at vertex $B$ and draw an arc cutting both arms, at points $P$ and $Q$.
2. With the same or a new radius, draw two intersecting arcs from $P$ and from $Q$; call their crossing point $R$.
3. Draw the line $BR$, it bisects $\angle ABC$ exactly.

## Constructing 90°, 60°, 45°, 135°, 22½°

**90°:** on a line, mark a point $P$; draw an arc from $P$ cutting the line on both sides (at $X$ and $Y$); from $X$ and $Y$, with a wider equal radius, draw two arcs that intersect above the line at $Z$; join $PZ$, so $\angle ZPY = 90^\circ$.

**60°:** draw a line, mark $P$; draw an arc from $P$ cutting the line at $Q$; from $Q$, with the same radius, draw an arc cutting the first at $R$; join $PR$, so $\angle RPQ = 60^\circ$ (triangle $PQR$ is equilateral).

**45°:** construct $90^\circ$, then bisect it.

**135°:** $135^\circ = 90^\circ + 45^\circ$. Construct $90^\circ$ at a point on a straight line (this automatically leaves a second $90^\circ$ on the other side of that point); bisect that second $90^\circ$ to get $45^\circ$; the total swept from the first arm is $90^\circ+45^\circ = 135^\circ$.

**22½°:** bisect $45^\circ$ (itself half of $90^\circ$), so $90^\circ \to 45^\circ \to 22\tfrac12^\circ$ by two successive bisections.

**Key exam habits:** open the compass to clearly more than half a segment before bisecting it, or the arcs will not cross; keep the compass setting fixed between the two arcs of the same bisection, accidentally nudging the width mid-construction is the most common cause of errors; when constructing a triangle from two angles and an included side, draw the base first and build both base angles before worrying about where the two rays cross, the crossing point is automatically the third vertex.',
    1
  )
  returning id
),
we1 as (
  insert into public.worked_examples (lesson_id, title, problem_statement, solution_steps, exam_shortcut, real_life_context, diagram_type, diagram_data, status)
  select id,
    'Constructing a 135° Angle',
    'Using only a ruler and compasses, construct an angle of $135^\circ$.',
    to_jsonb(array[
      'Draw the base line: using a ruler, draw a straight line $AB$ of any convenient length and mark a point $P$ on it, not too close to either end.',
      'Construct $90^\circ$ at $P$: open the compass to a medium radius and, with the point on $P$, draw an arc cutting line $AB$ at two points, $X$ (towards $A$) and $Y$ (towards $B$).',
      'Swing two more arcs of the same (or a slightly wider) radius: from $X$, draw an arc above the line; from $Y$, without changing the radius, draw a second arc above the line, crossing the first at a point $Z$.',
      'Draw the $90^\circ$ line: join $P$ to $Z$. $\angle ZPB = 90^\circ$ (and so does $\angle ZPA$, on the other side).',
      'Bisect $\angle ZPA$ (the $90^\circ$ angle on the same side as $A$) to get $45^\circ$: with the compass on $P$, draw an arc cutting both $PA$ and $PZ$; using equal-radius arcs centred on those two cut points, mark their intersection $W$; draw $PW$, bisecting $\angle ZPA$ into two $45^\circ$ angles.',
      'Read off the $135^\circ$: the angle from $PB$, sweeping through $PZ$ ($90^\circ$) and on to $PW$ (a further $45^\circ$), totals $90^\circ+45^\circ=135^\circ$.',
      'Answer: $\angle BPW = 135^\circ$, built as $90^\circ + 45^\circ$.'
    ]),
    'Memorise the bisection chain $90^\circ \to 45^\circ \to 22\tfrac12^\circ$: almost every "special" construction angle up to $180^\circ$ can be reached by bisecting and adding just a $60^\circ$ and a $90^\circ$ construction, with no protractor needed.',
    'This exact technique is used by a technical drawing student or a builder''s apprentice laying out a roof truss angle with only a ruler and a pair of compasses, no protractor on site.',
    'none', '{}'::jsonb,
    'published'
  from lesson
  returning id
)
insert into public.worked_examples (lesson_id, title, problem_statement, solution_steps, exam_shortcut, real_life_context, diagram_type, diagram_data, status)
select id,
  'Constructing a Triangle from a Side and Two Angles',
  'Using only a ruler and compasses, construct triangle $ABC$ with $AB = 6\ cm$, $\angle CAB = 60^\circ$, $\angle CBA = 45^\circ$.',
  to_jsonb(array[
    'Draw the base: using a ruler, draw line segment $AB = 6\ cm$ exactly.',
    'Construct $60^\circ$ at $A$: with compass point on $A$, draw an arc cutting $AB$ at $M$; without changing the radius, move the compass to $M$ and draw a second arc cutting the first at $N$; draw ray $AN$, so $\angle NAB = 60^\circ$ (triangle $AMN$ is equilateral).',
    'Construct $90^\circ$ at $B$: with compass point on $B$, draw an arc cutting $AB$ (extended if needed) on both sides of $B$; from those two points, with equal wider-radius arcs, find a point above the line; join $B$ to that point, this ray is perpendicular to $AB$.',
    'Bisect the $90^\circ$ at $B$ to get $45^\circ$: using the arc-and-intersection bisection method on the $90^\circ$ angle just constructed, draw the bisecting ray from $B$, making $45^\circ$ with $BA$.',
    'Extend both new rays (from $A$ at $60^\circ$, and from $B$ at $45^\circ$) until they cross; label the crossing point $C$.',
    'Check with the angle-sum theorem: $\angle ACB$ should measure $180-60-45=75^\circ$ when checked with a protractor.',
    'Answer: triangle $ABC$ is constructed with $\angle A=60^\circ$, $\angle B=45^\circ$, and (by angle sum) $\angle C=75^\circ$.'
  ]),
  'When constructing a triangle from two angles and an included side (ASA), draw the base first and construct both base angles before worrying about where the rays cross, the crossing point is automatically the third vertex.',
  'This is the exact ASA method a surveyor uses to plot a triangular building plot on a site drawing once two boundary angles and the shared side length are known.',
  'triangle',
  '{"vertices": [{"label": "A", "x": 0, "y": 0}, {"label": "B", "x": 6, "y": 0}, {"label": "C", "x": 3.6, "y": 3.6}], "sideLabels": [{"from": "A", "to": "B", "label": "6 cm"}], "angleLabels": [{"vertex": "A", "label": "60°"}, {"vertex": "B", "label": "45°"}, {"vertex": "C", "label": "75°"}]}'::jsonb,
  'published'
from we1;

insert into public.questions (topic_id, question_text, question_latex, option_a, option_b, option_c, option_d, option_e, correct_letter, difficulty, exam_type, explanation, exam_shortcut, status)
select topic_ref.tid, v.question_text, v.question_latex, v.option_a, v.option_b, v.option_c, v.option_d, v.option_e, v.correct_letter, v.difficulty, v.exam_type, v.explanation, v.exam_shortcut, 'published'
from (select t.id as tid from public.topics t join public.curricula c on c.id = t.curriculum_id
      where c.subject = 'Mathematics' and t.class_level = 'SS1' and t.term = 3 and t.order_index = 303) topic_ref,
lateral (values
  ('What are the only two tools permitted in pure geometric construction?', null::text, 'An unmarked straightedge and a pair of compasses', 'A ruler and a protractor', 'A set square and a protractor', 'A compass and a calculator', null::text, 'A', 1, 'GENERAL'::exam_type, 'Pure geometric construction uses only an unmarked straightedge for lines and compasses for arcs; a protractor may only check a finished figure, never build one.', null::text),
  ('What does "to bisect" mean?', null, 'To cut into two exactly equal halves', 'To double a length or angle', 'To draw a perpendicular line', 'To measure with a protractor', null, 'A', 1, 'GENERAL', 'Bisecting means dividing something, a line segment or an angle, into two exactly equal parts.', null),
  ('How is a 60° angle related to an equilateral triangle?', null, 'They are unrelated', 'Constructing an equilateral triangle (three equal arcs/sides) automatically produces three 60° angles', 'A 60° angle can only be found using a protractor', 'An equilateral triangle always has one 90° angle', null, 'B', 2, 'GENERAL', 'An equilateral triangle has all three sides equal, which forces all three angles to be equal, and since they sum to 180°, each must be 60°.', null),
  ('How would you construct 15° using only compasses and a straightedge?', null, 'Construct 90°, bisect once', 'Construct 60°, bisect it, then bisect again', 'Construct 45°, then double it', 'Measure it directly with a protractor', null, 'B', 2, 'GENERAL', '60° bisected once gives 30°; bisecting 30° again gives 15°.', null),
  ('How would you construct 22½° using only compasses and a straightedge?', null, 'Construct 60°, bisect twice', 'Construct 90°, bisect twice: to 45° then to 22½°', 'Construct 45° directly with a protractor', 'Construct 30°, bisect once', null, 'B', 2, 'GENERAL', '90° bisected once gives 45°; bisecting 45° again gives 22½°.', null),
  ('What is the first step in bisecting a given line segment AB?', null, 'Draw a circle centred at the midpoint', 'Open the compass to a radius more than half of AB', 'Measure AB with a ruler and divide by 2', 'Draw a 90° angle at A', null, 'B', 2, 'GENERAL', 'The compass radius must exceed half of AB, otherwise the arcs drawn from A and from B will not reach far enough to cross each other.', null),
  ('What is the first step in constructing a 90° angle at a point P on a line?', null, 'Draw an arc from P cutting the line on both sides', 'Draw a line perpendicular to the given line by eye', 'Bisect the given line first', 'Construct a 60° angle first', null, 'A', 2, 'GENERAL', 'The 90° construction begins with one arc from P marking two equal points on the line, which the next pair of arcs then use.', null),
  ('What is the first step in constructing a 30° angle?', null, 'Construct a 90° angle and bisect it', 'Construct a 60° angle first, then bisect it', 'Construct a 45° angle and add 15°', 'Draw any angle and measure 30° with a protractor', null, 'B', 2, 'GENERAL', '30° is exactly half of 60°, so the fastest route is constructing 60° with the equilateral-triangle method and then bisecting it.', null),
  ('If you construct a 60° angle and a 90° angle sharing a common vertex and arm, what is the angle between the two outer arms?', null, '20°', '25°', '30°', '35°', null, 'C', 2, 'GENERAL', 'The 90° arm and the 60° arm, both measured from the same shared arm, are 30° apart: $90-60=30^\circ$.', null),
  ('Which two base angles are added to construct 105° at a single vertex?', null, '45° and 45°', '60° and 45°', '90° and 30°', '30° and 60°', null, 'B', 2, 'GENERAL', '$105^\circ = 60^\circ + 45^\circ$, both individually constructible by the standard methods.', null),
  ('When constructing a 90° angle at P by the standard arc method, what is the role of the two "wider radius" arcs drawn from the points where the first arc cuts the line?', null, 'They locate the point directly above P that, when joined to P, gives exactly 90°', 'They are only used to check the construction with a protractor', 'They locate the midpoint of the base line', 'They bisect the 90° angle immediately', null, 'A', 3, 'GENERAL', 'The two equal-radius arcs from the two points on the line intersect directly above P at a point that makes a perpendicular (90°) line when joined to P.', null),
  ('Construct triangle ABC with AB = 8 cm, ∠A = 30°, ∠B = 60°. What is ∠C by the angle-sum theorem?', null, '80°', '85°', '90°', '95°', null, 'C', 2, 'GENERAL', '$\angle C = 180-30-60=90^\circ$.', null),
  ('Construct a triangle ABC with AB = 8 cm, ∠A = 60°, ∠B = 45°. What is ∠C?', null, '65°', '70°', '75°', '80°', null, 'C', 2, 'GENERAL', '$\angle C = 180-60-45=75^\circ$.', null),
  ('Construct △ABC with AB = 7.1 cm, AC = 7 cm, ∠BAC = 105°. Which two constructible angles add to make the 105° at A?', null, '45° and 60°', '90° and 15°', '30° and 75°', '60° and 45° or 90° and 15°, both are valid routes', null, 'D', 3, 'GENERAL', '105° can be built either as 60°+45° or as 90°+15°, since both routes use only bisections and additions of 60° and 90°.', null),
  ('Construct a triangle with AB = 6 cm, BC = 8 cm, AC = 10 cm; what is ∠ABC?', null, '75°', '80°', '85°', '90°', null, 'D', 2, 'GENERAL', '6-8-10 is a Pythagorean triple ($6^2+8^2=10^2$), so the angle opposite the 10 cm side, ∠ABC, is exactly 90°.', null),
  ('Construct triangle XYZ with XY = 10 cm, YZ = 6 cm, ZX = 11 cm. Mark D on XY with XD = 4.5 cm and draw ZD. What is the length of ZD, from the accurate construction?', null, '6.8 cm', '7.2 cm', '7.6 cm', '8.0 cm', null, 'C', 3, 'GENERAL', 'Constructing the triangle accurately to scale and measuring ZD with a ruler gives ZD = 7.6 cm, as recorded from the construction.', null),
  ('What angle results from bisecting a 90° angle twice in succession?', null, '15°', '20°', '22½°', '30°', null, 'C', 2, 'GENERAL', '$90^\circ \to 45^\circ$ (first bisection) $\to 22\tfrac12^\circ$ (second bisection).', null),
  ('In the 135° construction (90° + 45°), which angle is bisected to supply the extra 45°?', null, 'The original 60° construction angle', 'The second 90° angle left on the other side of the base point', 'The full 180° straight line', 'A freshly drawn 30° angle', null, 'B', 3, 'GENERAL', 'Constructing 90° at a point on a line automatically leaves a second 90° angle on the other side; bisecting that second 90° supplies the 45° that is added to the first to make 135°.', null),
  ('Why must construction arcs never be erased in a WAEC/NECO-style construction answer?', null, 'They make the diagram look neater', 'They are the visible proof of the correct method and are needed for marking', 'They show where the protractor was placed', 'Erasing them is technically impossible with a compass', null, 'B', 1, 'GENERAL', 'Examiners specifically look for the construction arcs as evidence of method; a "clean" figure with no arcs loses marks even if the final shape happens to be accurate.', null),
  ('In the bisection of an angle ∠ABC using arcs from points P and Q on its two arms, what determines the location of the bisecting ray''s direction point R?', null, 'R is the midpoint of segment PQ measured with a ruler', 'R is the intersection of two equal-radius arcs centred at P and at Q', 'R is found by trial and error with a protractor', 'R is the point where the two original arms cross', null, 'B', 2, 'GENERAL', 'R is defined purely by compass arcs, drawing equal-radius arcs from P and from Q and taking their intersection point, which lies exactly on the angle bisector.', null),
  ('Two rays are drawn from a common vertex: one at 90° from a base line and one at 45° from the same base line, on the same side. What is the angle between just these two rays?', null, '30°', '35°', '40°', '45°', null, 'D', 2, 'GENERAL', 'The angle between the 90° ray and the 45° ray, both measured from the same base, is simply $90-45=45^\circ$.', null)
) as v(question_text, question_latex, option_a, option_b, option_c, option_d, option_e, correct_letter, difficulty, exam_type, explanation, exam_shortcut);

-- ==========================================
-- TOPIC 304: Construction & Bisection of Angles
-- Source: Third Term Week 6 (constructing 30, 60, 90, 120, 150 degrees,
-- and combinations such as 75 and 105 degrees, plus copying a given
-- angle). Questions: Week 6 Q1-20 (20 total).
-- ==========================================

with lesson as (
  insert into public.lessons (topic_id, title, summary, content_body, order_index)
  values (
    (select t.id from public.topics t join public.curricula c on c.id = t.curriculum_id
     where c.subject = 'Mathematics' and t.class_level = 'SS1' and t.term = 3 and t.order_index = 304),
    'Construction and Bisection of Angles: 30°, 60°, 90°, 120°, 150°',
    'Building the remaining special construction angles from 60 degrees and 90 degrees by bisection and addition, and copying a given angle onto a new position.',
    '## Building on 60° and 90°

This topic builds the remaining "special angle" family, all obtainable from $60^\circ$ and $90^\circ$ by bisection and addition.

**60° and 120°:** construct $60^\circ$ as before (equilateral-triangle method). For $120^\circ$, use the *same* arcs but do **not** join the first intersection point; instead swing one more arc of the same radius from that first intersection to get a second point on the original arc, and join the vertex to this second point, giving $120^\circ$ (two $60^\circ$s added together).

**150°:** $150^\circ = 120^\circ + 30^\circ$. Construct $120^\circ$, then bisect the remaining $60^\circ$ (between the $120^\circ$ arm and the original line) to get $30^\circ$, and add it to the $120^\circ$.

**75° and 105°:** built from combinations of $60^\circ$ and its bisections: $75^\circ = 60^\circ + 15^\circ$ (construct $60^\circ$, then bisect the next $60^\circ$ twice to get $15^\circ$, and add); $105^\circ = 90^\circ + 15^\circ$, or equivalently $60^\circ + 30^\circ + 15^\circ$.

## Copying a Given Angle

To copy an existing angle onto a new position:
1. Draw the base line for the new angle.
2. At the *original* angle''s vertex, draw an arc cutting both arms.
3. Using the same radius, draw the same arc at the new vertex.
4. Measure the "opening" (the chord) between the original arc''s two intersection points with the compass, and transfer that width to the new arc.
5. Join the new vertex through the new intersection point, this exactly copies the original angle, whatever its size, without ever needing to know its value in degrees.

**Key exam habits:** build $120^\circ$ as "$60^\circ$ continued" rather than a fresh construction, reusing the same radius saves an entire extra equilateral-triangle setup; multiples of $15^\circ$ from $15^\circ$ to $150^\circ$ are all reachable by bisecting and adding just $60^\circ$ and $90^\circ$; when copying an angle, transfer the compass "opening" (the chord between the two arc-line intersection points), not the arc radius used to strike the arc itself, mixing these two up is the most common copying mistake.',
    1
  )
  returning id
),
we1 as (
  insert into public.worked_examples (lesson_id, title, problem_statement, solution_steps, exam_shortcut, real_life_context, diagram_type, diagram_data, status)
  select id,
    'Constructing a 75° Angle',
    'Using only a ruler and compasses, construct $\angle BAC = 75^\circ$ (as $60^\circ + 15^\circ$).',
    to_jsonb(array[
      'Draw the base line and mark the vertex: draw ray $AB$ from vertex $A$.',
      'Construct the first $60^\circ$: compass on $A$, draw an arc cutting $AB$ at $M$; same radius, compass on $M$, arc cutting the first arc at $N$; draw $AN$. Now $\angle NAB = 60^\circ$.',
      'Construct a second, adjacent $60^\circ$ (to reach $120^\circ$ total): keeping the same radius, place the compass on $N$ and draw another arc crossing the first large arc at a new point $P$; draw $AP$. Now $\angle PAB = 120^\circ$, with $AN$ exactly halfway between $AB$ and $AP$.',
      'Bisect the second $60^\circ$ (the one between $AN$ and $AP$) to get $30^\circ$: using equal-radius arcs centred on $N$ and $P$, find their intersection and bisect $\angle NAP$; call the resulting ray $AQ$, so $\angle NAQ=30^\circ$.',
      'Bisect $\angle NAQ$ again to get $15^\circ$: find the bisector of $\angle NAQ$ using the same method; call this final ray $AR$, so $\angle NAR = 15^\circ$.',
      'Add to the base $60^\circ$: the total angle from $AB$ to $AR$ is $\angle RAB = \angle NAB + \angle NAR = 60^\circ + 15^\circ = 75^\circ$.',
      'Answer: $\angle BAC = 75^\circ$ (taking $C = R$).'
    ]),
    'Remember the two "master" angle families: every multiple of $15^\circ$ from $15^\circ$ to $150^\circ$ is reachable by bisecting and adding just $60^\circ$ and $90^\circ$ constructions, no protractor is ever needed for a standard WAEC construction angle.',
    'A technical drawing student laying out a roof pitch angle of 75° for a scale drawing, with only a compass and straightedge, uses exactly this bisect-and-add method.',
    'none', '{}'::jsonb,
    'published'
  from lesson
  returning id
)
insert into public.worked_examples (lesson_id, title, problem_statement, solution_steps, exam_shortcut, real_life_context, diagram_type, diagram_data, status)
select id,
  'Constructing a Triangle with 30° and 60° Base Angles',
  'Using only a ruler and compasses, construct triangle $PQR$ with $PQ = 10\ cm$, $\angle P = 30^\circ$, $\angle Q = 60^\circ$. State $\angle R$.',
  to_jsonb(array[
    'Draw the base: $PQ = 10\ cm$ exactly, using a ruler.',
    'Construct $30^\circ$ at $P$: first construct $60^\circ$ at $P$ (equilateral-triangle arc method), then bisect it to get $30^\circ$; draw this ray from $P$.',
    'Construct $60^\circ$ at $Q$: use the equilateral-triangle arc method directly at $Q$ (arc from $Q$ cutting $QP$, then same-radius arc from that cut point, crossing the first arc); draw this ray from $Q$.',
    'Extend both rays until they meet; label the meeting point $R$.',
    'Find $\angle R$ using the angle-sum theorem (no further construction needed): $\angle R = 180^\circ - \angle P - \angle Q = 180^\circ-30^\circ-60^\circ=90^\circ$.',
    'Measure $PR$ and $QR$ with a ruler once the construction is complete; since $\angle R = 90^\circ$ is the largest angle, the side opposite it, $PQ = 10\ cm$, is the longest side.',
    'Answer: $\angle R = 90^\circ$ (a right angle, since $30^\circ+60^\circ+90^\circ=180^\circ$).'
  ]),
  'For triangle constructions where two angles are given (ASA), calculate the third angle mentally first, it lets you predict roughly where the third vertex should land, catching a construction error before the whole figure is drawn.',
  'A land surveyor plotting a triangular plot boundary with a known base length and two known corner angles uses exactly this ASA construction method on site.',
  'triangle',
  '{"vertices": [{"label": "P", "x": 0, "y": 0}, {"label": "Q", "x": 10, "y": 0}, {"label": "R", "x": 7.5, "y": 4.33}], "sideLabels": [{"from": "P", "to": "Q", "label": "10 cm"}], "angleLabels": [{"vertex": "P", "label": "30°"}, {"vertex": "Q", "label": "60°"}, {"vertex": "R", "label": "90°"}], "rightAngleAt": "R"}'::jsonb,
  'published'
from we1;

insert into public.questions (topic_id, question_text, question_latex, option_a, option_b, option_c, option_d, option_e, correct_letter, difficulty, exam_type, explanation, exam_shortcut, status)
select topic_ref.tid, v.question_text, v.question_latex, v.option_a, v.option_b, v.option_c, v.option_d, v.option_e, v.correct_letter, v.difficulty, v.exam_type, v.explanation, v.exam_shortcut, 'published'
from (select t.id as tid from public.topics t join public.curricula c on c.id = t.curriculum_id
      where c.subject = 'Mathematics' and t.class_level = 'SS1' and t.term = 3 and t.order_index = 304) topic_ref,
lateral (values
  ('Describe the first step to construct a 30° angle from scratch.', null::text, 'Construct 60° using the equilateral-triangle method, then bisect it', 'Draw a 30° angle by eye and check with a protractor', 'Construct 90° and add 60° to it', 'Bisect a straight line first', null::text, 'A', 2, 'GENERAL'::exam_type, '30° is exactly half of 60°, so the standard route is constructing 60° with equal-radius arcs and then bisecting the result.', null::text),
  ('How is 120° constructed using the same arcs as for 60°?', null, 'By doubling the compass radius', 'By continuing the same-radius arc one more equal step around the first arc, and joining the vertex to that second point instead of the first', 'By constructing 90° and adding 30°', 'By reflecting the 60° angle across the base line', null, 'B', 2, 'GENERAL', 'Rather than restarting, 120° reuses the 60° arcs: one more equal-radius step around the arc gives a point that is 120° from the base ray.', null),
  ('Describe how 150° is constructed from simpler angles.', null, '90° + 60°', '120° + 30°, where the 30° comes from bisecting the leftover 60°', '180° minus 30°, measured directly', '75° doubled', null, 'B', 2, 'GENERAL', '150° = 120° + 30°: construct 120° first, then bisect the remaining 60° (between the 120° arm and the base line) to get the extra 30°.', null),
  ('How is 75° built from simpler constructible angles?', null, '60° + 15°, where 15° comes from bisecting 60° twice', '45° + 30°', '90° − 15°, measured directly', '25° tripled', null, 'A', 2, 'GENERAL', '75° = 60° + 15°; the 15° itself comes from bisecting a 60° angle twice in succession (60° → 30° → 15°).', null),
  ('How is 105° built from simpler constructible angles?', null, '60° + 45°', '90° + 15°, or equivalently 60° + 30° + 15°', '120° − 15°, measured directly', '150° halved', null, 'B', 2, 'GENERAL', '105° can be reached either as 90°+15° or as the sum 60°+30°+15°, both built purely from bisections and additions.', null),
  ('When copying an angle ∠ABC onto a new ray, what exact measurement is transferred with the compass?', null, 'The radius originally used to strike the arc at the vertex', 'The "opening" (chord) between the arc''s two intersection points with the original angle''s arms', 'The full length of one arm of the angle', 'The angle''s measured value in degrees', null, 'B', 3, 'GENERAL', 'What makes the copy accurate is transferring the chord distance between the two arc/arm intersection points, not the radius used to draw the arc itself.', null),
  ('Construct △PQR with PQ = 9 cm, ∠PQR = 60°, QR = 10 cm. By the angle-sum theorem, what must ∠QPR + ∠QRP equal?', null, '90°', '100°', '110°', '120°', null, 'D', 2, 'GENERAL', 'Since ∠PQR = 60°, the other two angles must sum to $180-60=120^\circ$.', null),
  ('Construct △PQR with PQ = 10 cm, ∠RPQ = 30°, ∠PQR = 60°. What is ∠R?', null, '80°', '85°', '90°', '95°', null, 'C', 2, 'GENERAL', '$\angle R = 180-30-60=90^\circ$.', null),
  ('Construct △XYZ with ∠X = ∠Z = 45° and XZ = 8 cm. What is ∠Y?', null, '80°', '85°', '90°', '95°', null, 'C', 2, 'GENERAL', '$\angle Y = 180-45-45=90^\circ$, since the two given base angles sum to 90°.', null),
  ('In a locus/construction problem, a trapezium QRSP is built on base QR with QTP a straight line and PQ ∥ SR. If PS turns out to measure 6 cm and the perpendicular distance between RS and PQ is about 5.9 cm, what type of quadrilateral is QRSP?', null, 'A parallelogram', 'A trapezium', 'A rhombus', 'A kite', null, 'B', 2, 'GENERAL', 'QRSP has exactly one pair of parallel sides (PQ ∥ SR) with the other pair (QR and PS) not parallel or equal, which is the definition of a trapezium.', null),
  ('Construct △ABC with AB = 7 cm, BC = 5 cm, ∠ABC = 75°. Which two constructible angles combine to give the 75° at B?', null, '45° and 30°', '60° and 15°', '90° and 15°, or 60° and 15°', '20° and 55°', null, 'C', 2, 'GENERAL', '75° can be reached as 60°+15° or as 90°+15°, both routes rely only on bisecting and adding 60°/90° constructions.', null),
  ('Construct △ABC with AB = 9 cm and ∠BAC = 105°, then bisect ∠BAC to meet BC at X. What angle does each half of the bisected 105° measure?', null, '45°', '52.5°', '55°', '60°', null, 'B', 3, 'GENERAL', 'Bisecting a 105° angle splits it into two exactly equal halves of $105/2 = 52.5^\circ$ each.', null),
  ('Construct △ABC with AB = 6.5 cm, BC = 8 cm, ∠ABC = 45°. How is the 45° at B constructed?', null, 'By constructing 90° and bisecting it', 'By constructing 60° and bisecting it', 'By constructing 30° and doubling it', 'By constructing 135° and halving it', null, 'A', 2, 'GENERAL', '45° is exactly half of 90°, so it is built by the standard 90° construction followed by one bisection.', null),
  ('What angle do you get by bisecting the 60° left over after constructing a 120° angle on a straight line?', null, '20°', '25°', '30°', '35°', null, 'C', 2, 'GENERAL', 'Bisecting that leftover 60° gives 30°, which is then added to the 120° to reach 150° in total.', null),
  ('Why does copying an angle not require knowing its numeric value in degrees?', null, 'Because all angles are secretly multiples of 15°', 'Because the method transfers the physical "opening" (chord) between two equal-radius arcs, which exactly reproduces the angle regardless of its degree value', 'Because a protractor is used instead', 'Because only right angles can be copied this way', null, 'B', 3, 'GENERAL', 'The compass-transfer method reproduces the geometric relationship (the chord length) directly, so it works for any angle at all, known or unknown.', null),
  ('Construct a 60° angle and, on the same line, a 120° angle sharing the same arm. What is the angle between the two new arms (the 60° ray and the 120° ray)?', null, '40°', '50°', '60°', '70°', null, 'C', 2, 'GENERAL', 'The two outer arms are 60° and 120° from the same base, so the angle between just the two new arms is $120-60=60^\circ$.', null),
  ('A triangular plot ABC has BC = 105 m, ∠ABC = 45°, ∠ACB = 75°, drawn to a scale of 10 m : 1 cm. What length, in cm, should BC be drawn as on paper?', null, '9.5 cm', '10.0 cm', '10.5 cm', '11.0 cm', null, 'C', 2, 'GENERAL', 'At 10 m : 1 cm, 105 m becomes $105/10 = 10.5\ cm$ on the drawing.', null),
  ('At the plot-construction scale of 10 m : 1 cm, what real-world distance does a measured 3.2 cm on the drawing represent?', null, '16 m', '24 m', '32 m', '40 m', null, 'C', 2, 'GENERAL', 'Multiply the measured cm by the scale''s "real units per cm": $3.2 \times 10 = 32\ m$.', null),
  ('Is building 150° from three separate 50° pieces a valid construction method?', null, 'Yes, since 3×50°=150°', 'No, because 50° is not one of the constructible "special" angles from bisecting 60°/90°', 'Yes, but only using a protractor to check each 50°', 'No, because 150° cannot be constructed at all', null, 'B', 2, 'GENERAL', '50° cannot itself be built by pure bisection/addition of 60° and 90°, so 150° must instead be built as 120°+30° or 90°+60°.', null),
  ('An angle of 135° is constructed two different ways: once as 90°+45°, and once as 120°+15°. What should be true of the two resulting angles?', null, 'They will differ slightly due to rounding', 'They give exactly the same 135° angle, since both are valid decompositions', 'Only the 90°+45° method is geometrically valid', 'Only the 120°+15° method is geometrically valid', null, 'B', 2, 'GENERAL', 'Since both are exact constructions built purely from bisection and addition, they must produce the identical 135° angle; only the convenience of the intermediate steps differs.', null),
  ('When constructing 120° as "60° continued," what radius must be used for the second arc from the first intersection point?', null, 'Half the original radius', 'Double the original radius', 'The same radius as the first arc', 'Any convenient radius, it does not matter', null, 'C', 2, 'GENERAL', 'Keeping the identical compass radius throughout is what guarantees the second 60° step is exactly equal to the first, giving a true 120° total.', null)
) as v(question_text, question_latex, option_a, option_b, option_c, option_d, option_e, correct_letter, difficulty, exam_type, explanation, exam_shortcut);

-- ==========================================
-- TOPIC 305: Construction of Quadrilaterals & Equilateral Triangles
-- Source: Third Term Week 7 (constructing parallelograms, rhombi,
-- trapeziums and general quadrilaterals by splitting into two
-- triangles; constructing an equilateral triangle by arcs).
-- Questions: Week 7 Q1-20 (20 total). Only 1 fully worked construction
-- example exists in the curated source for this week.
-- ==========================================

with lesson as (
  insert into public.lessons (topic_id, title, summary, content_body, order_index)
  values (
    (select t.id from public.topics t join public.curricula c on c.id = t.curriculum_id
     where c.subject = 'Mathematics' and t.class_level = 'SS1' and t.term = 3 and t.order_index = 305),
    'Construction of Quadrilaterals and the Equilateral Triangle',
    'Constructing parallelograms, rhombi, trapeziums and general quadrilaterals by splitting them into two triangles, and constructing an equilateral triangle using arcs only.',
    '## Quadrilaterals Need More Information Than Triangles

A **quadrilateral** (four-sided figure) is generally not "rigid" like a triangle, so you typically need **5 independent pieces of information** to construct one uniquely (compared to 3 for a triangle). The standard method is to split the quadrilateral into two triangles using a diagonal, and construct each triangle in turn.

## Equilateral Triangle

All three sides equal, all three angles $= 60^\circ$. To construct one of side length $s$: draw a base of length $s$; at each end, construct a $60^\circ$ angle, or equivalently, draw two arcs of radius $s$ centred at each end of the base, their intersection is the third vertex.

## Constructing a Parallelogram

Given $AB$, $BC$, and $\angle ABC$: draw $AB$; at $B$ construct the given angle; mark $BC$ along the new ray; then find $D$ by compass arcs, from $A$ with radius $BC$, and from $C$ with radius $AB$, their intersection is $D$.

**Properties used to check a parallelogram construction:** opposite sides equal and parallel; opposite angles equal; adjacent angles supplementary (sum to $180^\circ$); diagonals bisect each other.

## Trapezium and Rhombus

A **trapezium** has one pair of parallel sides; it is constructed by drawing a base, constructing the given angle, drawing a parallel line at the specified perpendicular distance, and completing the sides.

A **rhombus** is a parallelogram with all four sides equal; it is constructed exactly like a parallelogram but with the second side length made equal to the first.

## Constructing a Parallel Line Through an External Point

With a point $C$ given and a line $AB$: draw an arc from $C$ with radius $AB$ cutting near the line; using equal-radius arcs from $A$ and $C$, find the fourth point $D$ so that $CD \parallel AB$.

**Key exam habits:** for any parallelogram, once two sides and the included angle are known, $D$ is always found by the same "double-arc" trick, no separate parallel-line construction is needed; a rhombus reuses the exact parallelogram steps, only making the second side length equal to the first; check a finished parallelogram fast by drawing both diagonals, they must cross at the exact midpoint of each.',
    1
  )
  returning id
)
insert into public.worked_examples (lesson_id, title, problem_statement, solution_steps, exam_shortcut, real_life_context, diagram_type, diagram_data, status)
select id,
  'Constructing a Parallelogram from Two Sides and an Included Angle',
  'Using only a ruler and compasses, construct parallelogram $ABCD$ with $AB = 6\ cm$, $BC = 4\ cm$, $\angle ABC = 60^\circ$.',
  to_jsonb(array[
    'Draw the base: using a ruler, draw $AB = 6\ cm$ exactly.',
    'Construct $60^\circ$ at $B$: compass on $B$, arc cutting $BA$ at a point; same radius, compass on that point, second arc crossing the first; the ray from $B$ through that crossing point makes $\angle ABC = 60^\circ$ with $BA$.',
    'Mark off $BC$ along the new ray: measure $4\ cm$ from $B$ along this $60^\circ$ ray with the ruler, and label the point $C$.',
    'Locate $D$ using the "opposite sides equal" property (AD must equal BC = 4 cm, CD must equal AB = 6 cm): open the compass to $4\ cm$, place the point on $A$, and draw an arc on the side of $AB$ where $C$ lies.',
    'Draw the second locating arc: open the compass to $6\ cm$, place the point on $C$, and draw an arc that crosses the arc from the previous step.',
    'Mark the crossing point as $D$.',
    'Join the sides: draw $AD$ and $CD$ with a ruler to complete the parallelogram.',
    'Verify: $AD$ should measure $4\ cm$ (matching $BC$), $CD$ should measure $6\ cm$ (matching $AB$), and $\angle BCD$ should measure $180^\circ-60^\circ=120^\circ$ (co-interior with $\angle ABC$).',
    'Answer: parallelogram $ABCD$ is constructed with $AB=DC=6\ cm$, $BC=AD=4\ cm$, $\angle ABC=\angle ADC=60^\circ$, $\angle BCD=\angle DAB=120^\circ$.'
  ]),
  'For any parallelogram construction, once two sides and the included angle are known, D is always found by the same "double-arc" trick: swing an arc from A with radius equal to the second given side, and from C with radius equal to the first given side; their crossing point is D every time.',
  'This is exactly how a carpenter marks out a parallelogram-shaped panel, such as a slanted shelf brace or a decorative window frame, using only a tape measure and a compass-style marking tool.',
  'none', '{}'::jsonb,
  'published'
from lesson;

insert into public.questions (topic_id, question_text, question_latex, option_a, option_b, option_c, option_d, option_e, correct_letter, difficulty, exam_type, explanation, exam_shortcut, status)
select topic_ref.tid, v.question_text, v.question_latex, v.option_a, v.option_b, v.option_c, v.option_d, v.option_e, v.correct_letter, v.difficulty, v.exam_type, v.explanation, v.exam_shortcut, 'published'
from (select t.id as tid from public.topics t join public.curricula c on c.id = t.curriculum_id
      where c.subject = 'Mathematics' and t.class_level = 'SS1' and t.term = 3 and t.order_index = 305) topic_ref,
lateral (values
  ('How many independent pieces of information are generally needed to construct a unique quadrilateral?', null::text, '3', '4', '5', '6', null::text, 'C', 2, 'GENERAL'::exam_type, 'Unlike a triangle (rigid with 3 pieces of information), a quadrilateral can flex at its vertices, so 5 independent measurements are typically needed to fix it uniquely.', null::text),
  ('What is the standard method for constructing a general quadrilateral?', null, 'Measure all four sides only, ignoring angles', 'Split it into two triangles using a diagonal, and construct each triangle in turn', 'Construct a circle and inscribe the quadrilateral inside it', 'Estimate the shape freehand and refine it', null, 'B', 2, 'GENERAL', 'Since a triangle is rigid once three suitable measurements are fixed, splitting a quadrilateral along one diagonal reduces the problem to two ordinary triangle constructions.', null),
  ('Which property is NOT one of the four standard checks for a completed parallelogram construction?', null, 'Opposite sides equal and parallel', 'Diagonals bisect each other', 'All four angles equal 90°', 'Adjacent angles are supplementary', null, 'C', 2, 'GENERAL', 'All four angles equal 90° is a property of a rectangle, not every parallelogram; a general parallelogram only needs opposite angles equal, not all four equal.', null),
  ('Construct a parallelogram ABCD with AB = 6 cm, BC = 4 cm, ∠ABC = 60°. What should ∠BCD measure?', null, '60°', '90°', '120°', '150°', null, 'C', 2, 'GENERAL', '∠BCD and ∠ABC are co-interior angles across the parallel sides AB and DC, so they sum to 180°: $180-60=120^\circ$.', null),
  ('Construct a rhombus ABCD with side 5 cm and ∠A = 60°. What length should each of the four sides measure?', null, '4 cm', '5 cm', '6 cm', 'It varies from side to side', null, 'B', 1, 'GENERAL', 'A rhombus has all four sides equal by definition, so every side is 5 cm, matching the given "side" length.', null),
  ('In a rhombus PQRS of side 7 cm with ∠PQR = 60°, point X is equidistant from PQ and QR, and also equidistant from Q and R. What two loci does X lie on?', null, 'A circle and a parallel line', 'The bisector of ∠PQR and the perpendicular bisector of QR', 'Two perpendicular bisectors', 'Two angle bisectors', null, 'B', 3, 'GENERAL', 'Equidistant from two lines PQ and QR means X is on the bisector of ∠PQR; equidistant from Q and R means X is on the perpendicular bisector of QR.', null),
  ('Construct parallelogram PQRS with RS as base, PQ = 7.8 cm, QR = 5.6 cm, ∠QRS = 120°. What should ∠RSP measure (the angle at S)?', null, '60°', '90°', '120°', '150°', null, 'A', 3, 'GENERAL', '∠RSP and ∠QRS are co-interior across the parallel sides QR and PS, so they sum to 180°: $180-120=60^\circ$.', null),
  ('Construct parallelogram EFGH with EF = 9 cm, EG = 11.5 cm (a diagonal), ∠EFG = 105°. What must be true about a circle drawn through E, F and G?', null, 'It cannot exist since E, F, G are collinear', 'It passes through exactly those three points, since any three non-collinear points determine a unique circle', 'It must also pass through H', 'Its centre must lie on side EF', null, 'B', 3, 'GENERAL', 'Any three non-collinear points, here E, F, G, determine exactly one circle passing through all three; H (the fourth parallelogram vertex) is not generally on that same circle.', null),
  ('Construct a trapezium WXYZ with WX = 8 cm, XY = 5.5 cm, XZ = 8.3 cm, ∠WXY = 60°, WX ∥ ZY. What defines this shape as a trapezium rather than a parallelogram?', null, 'It has no equal sides at all', 'It has exactly one pair of parallel sides (WX ∥ ZY), not two', 'It has four right angles', 'Its diagonals are equal in length', null, 'B', 2, 'GENERAL', 'A trapezium has only one pair of parallel sides; if both pairs were parallel it would be a parallelogram instead.', null),
  ('Construct a trapezium PQRS with parallel sides PQ and SR 5 cm apart, ∠SPQ = 60°, PQ = 9 cm, SR = 6 cm. What locus type is "points equidistant from P and Q"?', null, 'A circle centred at the midpoint of PQ', 'The perpendicular bisector of PQ', 'The angle bisector of ∠SPQ', 'A line parallel to PQ, 5 cm away', null, 'B', 2, 'GENERAL', 'Points equidistant from two fixed points P and Q always lie on the perpendicular bisector of the segment PQ.', null),
  ('Construct a trapezium ABCD with parallel sides AB and DC 2 cm apart, ∠DAB = 60°, AB = 4 cm, BC = 2.5 cm. What must DC be less than, for ABCD to remain a valid trapezium and not a parallelogram?', null, 'DC must equal AB exactly', 'DC must simply differ in length from AB', 'DC must always be longer than AB', 'DC must equal BC', null, 'B', 2, 'GENERAL', 'If DC equalled AB exactly (with both pairs of opposite sides then parallel and equal) the shape would become a parallelogram; a trapezium requires DC to differ from AB.', null),
  ('Construct quadrilateral PQRS with ∠PQR = 75°, ∠QRS = 60°, PQ = 6 cm, QR = 8 cm, PS ∥ QR. What kind of quadrilateral is PQRS, given only one stated pair of parallel sides?', null, 'A rhombus', 'A trapezium', 'A rectangle', 'A kite', null, 'B', 2, 'GENERAL', 'With only PS ∥ QR stated as parallel (not both pairs), PQRS is a trapezium.', null),
  ('Construct △ABC with AB = 9 cm, ∠A = 60°, and locate D on BC such that CD ∥ AB. What must ∠ACD equal, given CD ∥ AB and using alternate angles with transversal AC?', null, 'It equals ∠BAC = 60° by alternate angles', 'It always equals 90°', 'It equals ∠ABC regardless of ∠BAC', 'It cannot be determined without more information', null, 'A', 3, 'GENERAL', 'Since CD ∥ AB and AC is a transversal, the alternate angle to ∠BAC at C (i.e. ∠ACD) equals ∠BAC = 60°.', null),
  ('What is the key difference between the information needed for a trapezium construction versus a parallelogram construction?', null, 'A trapezium needs fewer measurements overall than a parallelogram', 'A trapezium needs the two different-length parallel sides plus their separation and an angle, since only one pair of sides is parallel; a parallelogram is fixed by just two sides and the included angle', 'They need exactly the same information', 'A parallelogram cannot be constructed with ruler and compasses at all', null, 'B', 3, 'GENERAL', 'A parallelogram''s second pair of sides is automatically determined by the equal/parallel property once two sides and the angle are fixed; a trapezium''s non-parallel sides are not automatically determined, so more direct information is needed.', null),
  ('Construct an equilateral triangle of side 6 cm using arcs only. What radius should both arcs use?', null, '3 cm', '6 cm', '9 cm', '12 cm', null, 'B', 1, 'GENERAL', 'Both arcs, one from each end of the 6 cm base, must use a radius equal to the base length itself, 6 cm, so that all three sides come out equal.', null),
  ('Why does drawing two equal-radius arcs from the two ends of a base segment produce an equilateral triangle?', null, 'Because both new sides equal the radius used, which is also set equal to the base length, so all three sides are equal', 'Because arcs always cross at exactly 60°', 'Because the compass automatically measures angles', 'It does not always produce an equilateral triangle', null, 'A', 2, 'GENERAL', 'Setting the compass radius equal to the base length means both new sides drawn from the arcs equal the base, making all three sides, and hence all three angles, equal.', null),
  ('Construct a rectangle PQRS with PQ = 8 cm, QR = 5 cm. What locus type is "points equidistant from P and R" (a diagonal''s endpoints)?', null, 'A circle centred at Q', 'The perpendicular bisector of diagonal PR', 'The angle bisector of ∠PQR', 'A line parallel to PQ', null, 'B', 2, 'GENERAL', 'Points equidistant from two fixed points P and R lie on the perpendicular bisector of segment PR, which for a rectangle also passes through its centre.', null),
  ('What kind of real-world object is essentially a constructed parallelogram or general quadrilateral shape?', null, 'A circular clock face', 'A picture frame or a tabletop', 'A single straight fence post', 'A spherical water tank', null, 'B', 1, 'GENERAL', 'Everyday rectangular or parallelogram-shaped objects, such as picture frames or tabletops, are physical examples of constructed quadrilaterals.', null),
  ('Construct a quadrilateral ABCD given AB = 5 cm, BC = 6 cm, ∠ABC = 90°, CD = 4 cm, ∠BCD = 120°. Which diagonal is the natural choice to split this quadrilateral into two triangles?', null, 'AC', 'BD', 'Either works equally well here', 'No diagonal is needed', null, 'A', 2, 'GENERAL', 'Since AB, BC and the included ∠ABC are all given, triangle ABC can be constructed directly (SAS); diagonal AC then lets triangle ACD be built next using CD and ∠BCD.', null),
  ('Why does an arbitrary quadrilateral generally require more given information to construct than a triangle?', null, 'Because quadrilaterals have curved sides', 'Because a triangle is rigid once three suitable measurements fix it (SSS, SAS, or ASA), but a quadrilateral can flex at its vertices, needing one more independent measurement', 'Because quadrilaterals always need a protractor', 'There is no real difference in information needed', null, 'B', 3, 'GENERAL', 'A triangle''s shape is completely fixed by three suitable measurements, but a quadrilateral can still flex (change shape) even after three measurements are fixed, so a fourth and fifth are needed to pin it down uniquely.', null)
) as v(question_text, question_latex, option_a, option_b, option_c, option_d, option_e, correct_letter, difficulty, exam_type, explanation, exam_shortcut);

-- ==========================================
-- TOPIC 306: Locus of Moving Points
-- Source: Third Term Week 8 (the four fundamental loci: fixed distance
-- from a point, equidistant from two points, fixed distance from a
-- line, equidistant from two intersecting lines). Questions: Week 8
-- Q1-20 (20 total).
-- ==========================================

with lesson as (
  insert into public.lessons (topic_id, title, summary, content_body, order_index)
  values (
    (select t.id from public.topics t join public.curricula c on c.id = t.curriculum_id
     where c.subject = 'Mathematics' and t.class_level = 'SS1' and t.term = 3 and t.order_index = 306),
    'Locus of Moving Points',
    'Identifying and constructing the four fundamental loci, and finding where two loci intersect to answer a geometric constraint problem.',
    '## What Is a Locus?

A **locus** (plural: loci) is the set of all points that satisfy a given geometric rule, the "path" traced by a point moving under that rule.

## The Four Fundamental Loci

1. **Fixed distance from a point:** the locus is a **circle** centred at that point, with radius equal to the fixed distance.
2. **Equidistant from two fixed points $A$ and $B$:** the locus is the **perpendicular bisector** of the line segment $AB$.
3. **Fixed distance from a line:** the locus is a **pair of lines parallel** to the given line, one on each side, at that distance.
4. **Equidistant from two intersecting lines:** the locus is the **angle bisector** of the angle between them (there are two such bisectors, one for the angle and one for its supplement, interior and exterior).

To solve a locus problem: identify which of the four types applies to each condition, construct each locus, and the answer is usually where two loci intersect.

**Key exam habits:** memorise the four loci as a quick lookup table before any exam; for "grazing goat" or "overlap region" problems, always draw both circles fully, the overlap region is easiest to see and shade accurately when both full circles are visible; always state a scale explicitly and convert real-world distances to drawing distances *before* starting to draw; to convert a measured drawing distance back to real life, multiply by the scale''s "real units per cm".',
    1
  )
  returning id
),
we1 as (
  insert into public.worked_examples (lesson_id, title, problem_statement, solution_steps, exam_shortcut, real_life_context, diagram_type, diagram_data, status)
  select id,
    'Locus of Points Equidistant from Two Fixed Points',
    'Draw $XY = 7\ cm$; construct the locus of points $P$ equidistant from $X$ and $Y$.',
    to_jsonb(array[
      'Identify the locus type: "equidistant from two fixed points" is locus type 2, a perpendicular bisector.',
      'Draw the line: using a ruler, draw $XY = 7\ cm$.',
      'Open the compass wide: set the radius to more than half of $XY$ (more than $3.5\ cm$), so the arcs from each end will reach across and cross each other.',
      'Draw arcs from $X$: with the compass point on $X$, draw one arc above the line $XY$ and one arc below it.',
      'Draw arcs from $Y$ (same radius, do not adjust the compass): with the compass point on $Y$, draw arcs above and below the line, crossing the arcs from $X$ at two points.',
      'Join the two crossing points with a straight line.',
      'Confirm: this line crosses $XY$ at its exact midpoint ($3.5\ cm$ from both $X$ and $Y$) and is perpendicular to it.',
      'Answer: the locus is the perpendicular bisector of $XY$, passing through its midpoint.'
    ]),
    'Memorise the four loci as a quick-reference table: (1) fixed distance from a point → circle; (2) equidistant from two points → perpendicular bisector; (3) fixed distance from a line → two parallel lines; (4) equidistant from two lines → angle bisector.',
    'This is exactly how a town planner locates a new clinic site that must be equally accessible (equal walking distance) from two existing villages on either side of a road.',
    'none', '{}'::jsonb,
    'published'
  from lesson
  returning id
),
we2 as (
  insert into public.worked_examples (lesson_id, title, problem_statement, solution_steps, exam_shortcut, real_life_context, diagram_type, diagram_data, status)
  select id,
    'The Grazing Goat: Overlap of Two Circular Loci',
    'A goat is tied to post $P$ by a $4\ m$ rope and to post $Q$ by a $3\ m$ rope; $P$ and $Q$ are $5\ m$ apart. Shade the region where the goat can graze if tethered to both posts at once.',
    to_jsonb(array[
      'Choose and state a scale: since the distances are in metres and we are drawing on paper, use $1\ m : 1\ cm$.',
      'Draw the base line $PQ$ to scale: $PQ = 5\ cm$ (representing $5\ m$).',
      'Identify the locus type for each rope separately: "fixed distance from a point" is locus type 1, a circle.',
      'Draw the first circle: centre $P$, radius $4\ cm$ (representing the goat''s $4\ m$ rope at post $P$).',
      'Draw the second circle: centre $Q$, radius $3\ cm$ (representing the goat''s $3\ m$ rope at post $Q$).',
      'Identify the grazing region: since the goat is tethered by both ropes simultaneously, it can only reach a point that is within $4\ m$ of $P$ *and* within $3\ m$ of $Q$ at the same time.',
      'Shade the overlapping lens-shaped region where both circles intersect.',
      'Answer: the grazing region is the lens-shaped overlap of a $4\ cm$ circle at $P$ and a $3\ cm$ circle at $Q$, drawn on a $1\ m : 1\ cm$ scale.'
    ]),
    'For "grazing goat" or "overlap region" problems, always draw both circles fully rather than just the arcs you think you need, the overlap region is easiest to see and shade correctly when both full circles are visible.',
    'This is a genuine everyday scenario for a Nigerian farmer working out exactly how much land a tethered goat or cow can safely graze without damaging a neighbour''s crops.',
    'none', '{}'::jsonb,
    'published'
  from lesson
  returning id
)
insert into public.worked_examples (lesson_id, title, problem_statement, solution_steps, exam_shortcut, real_life_context, diagram_type, diagram_data, status)
select id,
  'Combining Three Loci for a Triangular Plot',
  'A triangular plot $ABC$ has $BC = 105\ m$, $\angle ABC = 45^\circ$, $\angle ACB = 75^\circ$ (scale $10\ m : 1\ cm$). Construct locus $l_1$ of points equidistant from $B$ and $C$, locus $l_2$ of points equidistant from $AB$ and $BC$, and locus $l_3$ of points $5\ cm$ from $A$; find $T_1$ and $T_2$, the intersections of $l_1$ and $l_3$, and measure $T_1T_2$.',
  to_jsonb(array[
    'Convert $BC$ to the drawing scale: $105\ m$ at $10\ m : 1\ cm$ means $BC = 105/10 = 10.5\ cm$ on paper.',
    'Draw $BC = 10.5\ cm$.',
    'Construct $45^\circ$ at $B$ and $75^\circ$ at $C$: using the special-angle construction methods (bisection and addition of $60^\circ$/$90^\circ$), draw rays from $B$ and from $C$; where they meet is vertex $A$.',
    'Construct $l_1$ (locus type 2, equidistant from $B$ and $C$): draw the perpendicular bisector of $BC$ using equal-radius arcs from $B$ and $C$.',
    'Construct $l_2$ (locus type 4, equidistant from two lines $AB$ and $BC$): bisect the angle $\angle ABC$ at vertex $B$.',
    'Construct $l_3$ (locus type 1, fixed distance from $A$): with the compass centred at $A$, radius $5\ cm$, draw an arc (or full circle), representing points $50\ m$ from $A$ on the ground.',
    'Mark $T_1$ and $T_2$ where $l_1$ (the perpendicular bisector of $BC$) crosses $l_3$ (the $5\ cm$ circle centred at $A$), since a line generally crosses a circle at up to two points.',
    'Measure the straight-line distance $T_1T_2$ directly on the accurate drawing with a ruler, and convert back to real-world metres by multiplying by the scale factor ($\times 10$) if needed.',
    'Answer: $T_1$ and $T_2$ are the two intersection points of the perpendicular bisector of $BC$ with the circle of radius $5\ cm$ centred at $A$; $T_1T_2$ is measured directly from the completed, accurate construction.'
  ]),
  'When a problem gives three loci and asks for an intersection, lightly sketch the whole figure freehand first to predict roughly where the intersection point(s) should appear, this catches gross construction errors before committing to the final inked lines.',
  'This mirrors exactly how a Nigerian land surveyor locates a legally required feature, such as a borehole site or a boundary marker, that must satisfy multiple distance and angle constraints on a real plot of land.',
  'triangle',
  '{"vertices": [{"label": "B", "x": 0, "y": 0}, {"label": "C", "x": 10.5, "y": 0}, {"label": "A", "x": 5.6, "y": 5.6}], "sideLabels": [{"from": "B", "to": "C", "label": "10.5 cm (105 m)"}], "angleLabels": [{"vertex": "B", "label": "45°"}, {"vertex": "C", "label": "75°"}]}'::jsonb,
  'published'
from we1;

insert into public.questions (topic_id, question_text, question_latex, option_a, option_b, option_c, option_d, option_e, correct_letter, difficulty, exam_type, explanation, exam_shortcut, status)
select topic_ref.tid, v.question_text, v.question_latex, v.option_a, v.option_b, v.option_c, v.option_d, v.option_e, v.correct_letter, v.difficulty, v.exam_type, v.explanation, v.exam_shortcut, 'published'
from (select t.id as tid from public.topics t join public.curricula c on c.id = t.curriculum_id
      where c.subject = 'Mathematics' and t.class_level = 'SS1' and t.term = 3 and t.order_index = 306) topic_ref,
lateral (values
  ('What is a "locus"?', null::text, 'The set of all points satisfying a given geometric rule; the path traced by a moving point under that rule', 'A single fixed point on a diagram', 'The area enclosed by a closed shape', 'A straight line joining two vertices', null::text, 'A', 1, 'GENERAL'::exam_type, 'A locus is defined as the entire set of points that satisfy a stated geometric condition, not just one point.', null::text),
  ('What is the locus of a point equidistant from two points A and B?', null, 'A circle centred at A', 'The perpendicular bisector of AB', 'A line parallel to AB', 'The midpoint of AB only', null, 'B', 1, 'GENERAL', 'Every point on the perpendicular bisector of AB is the same distance from A as from B; the midpoint of AB is just one point on that whole locus.', null),
  ('What is the locus of a point equidistant from two intersecting lines?', null, 'A circle centred at the intersection point', 'The angle bisector between them', 'A line parallel to one of the lines', 'The perpendicular bisector of the angle''s arms', null, 'B', 1, 'GENERAL', 'Points equidistant from two intersecting lines lie exactly on the bisector of the angle formed between them.', null),
  ('Describe the locus of the tip of the minute hand of a clock.', null, 'A straight line', 'A circle, with the clock''s centre as centre and the hand''s length as radius', 'A parallel pair of lines', 'An angle bisector', null, 'B', 1, 'GENERAL', 'The tip stays a fixed distance (the hand''s length) from a fixed point (the clock''s centre) at all times, which is exactly the definition of a circle locus.', null),
  ('Describe, in words, the locus of a point P that always stays 5 cm from a fixed point O.', null, 'A straight line 5 cm long', 'A circle of radius 5 cm centred at O', 'Two parallel lines 5 cm apart', 'A single point 5 cm from O', null, 'B', 1, 'GENERAL', '"Fixed distance from a point" is always locus type 1, a circle of that radius centred at the fixed point.', null),
  ('Two parallel lines l₁ and l₂ are 6 cm apart. Describe the locus of points equidistant from both lines.', null, 'A circle midway between them', 'A straight line parallel to both, exactly 3 cm from each', 'The angle bisector of the two lines', 'There is no such locus, since parallel lines never meet', null, 'B', 2, 'GENERAL', 'For two parallel lines, the locus of points equidistant from both is a straight line running exactly midway between them, at half their separation.', null),
  ('What two tools are used to construct the perpendicular bisector of a line?', null, 'A ruler and a protractor', 'A straightedge and a pair of compasses', 'A set square only', 'A calculator and a ruler', null, 'B', 1, 'GENERAL', 'Like all pure geometric constructions, the perpendicular bisector uses only an unmarked straightedge and compasses.', null),
  ('What is the first step in finding the locus of points equidistant from two intersecting lines?', null, 'Bisect the angle formed at their intersection', 'Draw a circle at the intersection point', 'Measure both lines with a ruler', 'Draw a line parallel to one of them', null, 'A', 2, 'GENERAL', 'The relevant locus (angle bisector) is found by bisecting the angle formed where the two lines cross.', null),
  ('Draw XY = 7 cm; what is the locus of points P equidistant from X and Y?', null, 'A circle of radius 7 cm centred at the midpoint of XY', 'The perpendicular bisector of XY', 'A line parallel to XY, 3.5 cm away', 'Two arcs, one from X and one from Y, left undrawn', null, 'B', 1, 'GENERAL', 'This is a direct locus type 2 case: equidistant from two fixed points gives the perpendicular bisector of the segment joining them.', null),
  ('A goat is tied to post P by a 4 m rope and to post Q by a 3 m rope, with P and Q 5 m apart. What region represents where the goat can graze if tethered to both ropes at once?', null, 'The union of both circles (everywhere reachable by either rope)', 'The overlapping lens-shaped region of a circle of radius 4 m at P and a circle of radius 3 m at Q', 'Only the straight line segment PQ', 'A single circle of radius 3.5 m at the midpoint of PQ', null, 'B', 2, 'GENERAL', 'Being tethered to both ropes at once restricts the goat to points reachable under both constraints simultaneously, the lens-shaped overlap of the two circles.', null),
  ('Draw AB = 6 cm; construct locus l₁, the points 4 cm from line AB, and l₂, the points equidistant from A and B. What locus type is l₁?', null, 'Locus type 1 (circle)', 'Locus type 2 (perpendicular bisector)', 'Locus type 3 (a pair of parallel lines)', 'Locus type 4 (angle bisector)', null, 'C', 2, 'GENERAL', '"Fixed distance from a line" is always locus type 3, giving two parallel lines, one on each side of AB, each 4 cm away.', null),
  ('Two intersecting lines AB and CD form a 45° angle. What is the locus of points equidistant from AB and CD?', null, 'A circle at the intersection point', 'The pair of bisectors of the 45°/135° angles formed', 'A line parallel to AB only', 'A line parallel to CD only', null, 'B', 2, 'GENERAL', 'Two intersecting lines create two pairs of vertical angles; the equidistant locus is the pair of bisectors, one for the 45° angle and one for its 135° supplement.', null),
  ('Construct △ABC with AB = 8 cm, ∠A = 60°, ∠B = 45°; construct l₁ (equidistant from A and B) and l₂ (equidistant from AB and AC), meeting at P. What locus type is l₂?', null, 'Locus type 1 (circle)', 'Locus type 2 (perpendicular bisector)', 'Locus type 3 (parallel lines)', 'Locus type 4 (angle bisector)', null, 'D', 2, 'GENERAL', 'Being equidistant from two lines (AB and AC) is always locus type 4, the angle bisector of the angle between them, here ∠A.', null),
  ('Construct rectangle PQRS with PQ = 8 cm, QR = 5 cm; construct the locus of points 3 cm from Q and the locus of points equidistant from P and R. What is the second locus, geometrically, for this rectangle?', null, 'A circle of radius 3 cm centred at the rectangle''s centre', 'The 45° diagonal-direction line through the rectangle''s centre (the perpendicular bisector of diagonal PR)', 'A line parallel to PQ through Q', 'The angle bisector of ∠PQR', null, 'B', 3, 'GENERAL', 'Equidistant from P and R (opposite corners) is the perpendicular bisector of diagonal PR, which for a rectangle passes through its centre.', null),
  ('A triangular plot ABC has BC = 105 m, ∠ABC = 45°, ∠ACB = 75° (scale 10 m : 1 cm). What locus type is l₁, the points equidistant from B and C?', null, 'A circle centred at B', 'The perpendicular bisector of BC', 'A pair of parallel lines either side of BC', 'The bisector of angle A', null, 'B', 2, 'GENERAL', 'Equidistant from two fixed points B and C is always locus type 2, the perpendicular bisector of segment BC.', null),
  ('A plot of land ABC has AB = 121 m, AC = 105 m, ∠ACB = 75° (scale 10 m : 1 cm). A flagpole Q is equidistant from A, B, and C. What point is Q, geometrically?', null, 'The centroid of the triangle', 'The circumcentre, found from the perpendicular bisectors of two sides', 'The incentre, found from two angle bisectors', 'The midpoint of the longest side', null, 'B', 3, 'GENERAL', 'A point equidistant from all three vertices of a triangle is its circumcentre, located where the perpendicular bisectors of any two sides intersect.', null),
  ('A plot ABC has BC = 85 m; locus l₁ is the points equidistant from A and C, and locus l₂ is the points 60 m from A; a tree T lies on both. What locus type is l₂?', null, 'A circle of radius 60 m centred at A', 'The perpendicular bisector of AC', 'A pair of parallel lines 60 m either side of BC', 'The angle bisector at A', null, 'A', 2, 'GENERAL', '"Fixed distance from a point" (here, 60 m from A) is always locus type 1, a circle of that radius centred at the given point.', null),
  ('Construct △XYZ with XY = 10 cm, ∠XYZ = 30°, ∠YXZ = 45°; construct l₁ (equidistant from Y and Z) and l₂ (a line through Z parallel to XY); locate M where they meet. What is ∠ZMY?', null, '90°', '105°', '120°', '135°', null, 'C', 4, 'GENERAL', 'From the accurate construction and the geometry of the perpendicular bisector meeting the parallel line through Z, ∠ZMY works out to 120°.', null),
  ('A region must be "nearer to AC than BC" and "more than 60 m from A." Which two locus constructions describe this region?', null, 'A circle of radius 60 m and a parallel line pair', 'The angle bisector between AC and BC, and a circle of radius 60 m centred at A', 'Two perpendicular bisectors', 'A single angle bisector only', null, 'B', 3, 'GENERAL', '"Nearer to AC than BC" is bounded by the angle bisector between the two lines; "more than 60 m from A" is the region outside a 60 m circle centred at A.', null),
  ('When a locus problem gives three separate loci and asks for an intersection point, what is recommended before starting the final accurate construction?', null, 'Skip straight to the final inked construction to save time', 'Lightly sketch the whole figure freehand first, to predict roughly where the intersection point(s) should appear', 'Use a protractor to estimate all angles first', 'Draw only the loci that are circles', null, 'B', 2, 'GENERAL', 'A quick freehand sketch predicts roughly where the answer should land, which helps catch a construction error before committing to the final accurate drawing.', null),
  ('At a scale of 10 m : 1 cm, if a real-world distance is 32 m, what length should be drawn on paper?', null, '0.32 cm', '3.2 cm', '32 cm', '320 cm', null, 'B', 2, 'GENERAL', 'Divide the real distance by the scale''s "real units per cm": $32 \div 10 = 3.2\ cm$.', null)
) as v(question_text, question_latex, option_a, option_b, option_c, option_d, option_e, correct_letter, difficulty, exam_type, explanation, exam_shortcut);

-- ==========================================
-- TOPIC 307: Deductive Proof: Angle Sum of a Triangle
-- Source: the formal-proof half of Third Term Week 4 (axiom vs
-- theorem; the Given/To-Prove/Construction/Proof/Q.E.D. structure;
-- the full proofs that a triangle's angles sum to 180 degrees and
-- that the exterior angle equals the sum of the two remote interior
-- angles). Questions: Week 4 Q1, 2, 3, 4, 5, 6, 11, 14, 19 (9 total,
-- the conceptual/proof-structure questions, distinct from the numeric
-- application questions already used under topic 302). This is the
-- thinnest topic in the curated source: only these two theorem proofs
-- and nine conceptual questions exist for it.
-- ==========================================

with lesson as (
  insert into public.lessons (topic_id, title, summary, content_body, order_index)
  values (
    (select t.id from public.topics t join public.curricula c on c.id = t.curriculum_id
     where c.subject = 'Mathematics' and t.class_level = 'SS1' and t.term = 3 and t.order_index = 307),
    'Deductive Proof: The Angle Sum of a Triangle',
    'Writing a formal Given/To-Prove/Construction/Proof argument for why the angles of any triangle sum to 180 degrees, and for the exterior angle theorem.',
    '## Axioms, Theorems, and Formal Proof Structure

An **axiom** (postulate) is a statement accepted as true without proof; a **theorem** is a statement proved true using logic and axioms. A formal proof has the structure:

**Given** (what is known) $\to$ **To Prove** (the goal) $\to$ **Construction** (an added helper line, if needed) $\to$ **Proof** (a step-by-step argument, with a reason for every statement) $\to$ **Conclusion (Q.E.D.)**, where Q.E.D. stands for *quod erat demonstrandum*, "what was to be shown."

## Theorem 1: The Sum of the Angles in a Triangle Is 180°

**Given:** triangle $ABC$. **Construction:** draw a line $XY$ through $A$, parallel to $BC$.

**Proof:** $\angle XAB = \angle ABC$ (alternate angles, since $XY \parallel BC$); $\angle YAC = \angle ACB$ (alternate angles); $\angle XAB + \angle BAC + \angle YAC = 180^\circ$ (angles on the straight line $XY$). Substituting the first two equalities: $\angle ABC + \angle BAC + \angle ACB = 180^\circ$. **Q.E.D.**

## Theorem 2: The Exterior Angle of a Triangle Equals the Sum of the Two Remote Interior Angles

**Given:** triangle $ABC$ with $BC$ extended to $D$. **To prove:** exterior angle $\angle ACD = \angle A + \angle B$.

**Proof:** $\angle A + \angle B + \angle ACB = 180^\circ$ (Theorem 1); $\angle ACB + \angle ACD = 180^\circ$ (angles on the straight line $BCD$). Both expressions equal $180^\circ$, so $\angle A + \angle B + \angle ACB = \angle ACB + \angle ACD$; subtracting $\angle ACB$ from both sides gives $\angle A + \angle B = \angle ACD$. **Q.E.D.**

**Key exam habits:** in any deductive proof (rider), always write the reason in brackets next to every statement (e.g. "(alternate angles, $XY \parallel BC$)"), WAEC/NECO award marks *per correct reason*, not just for the final result; the two angle rules that make both proofs work are alternate angles between parallel lines, and angles on a straight line summing to $180^\circ$, memorising exactly these two unlocks both theorems.',
    1
  )
  returning id
),
we1 as (
  insert into public.worked_examples (lesson_id, title, problem_statement, solution_steps, exam_shortcut, real_life_context, diagram_type, diagram_data, status)
  select id,
    'Proving the Angle Sum of a Triangle Is 180°',
    'Prove that the sum of the angles of any triangle $ABC$ is $180^\circ$.',
    to_jsonb(array[
      'State what is given: triangle $ABC$, with angles $\angle ABC$, $\angle BAC$, and $\angle ACB$.',
      'State what is to be proved: $\angle ABC + \angle BAC + \angle ACB = 180^\circ$.',
      'Make the construction: draw a line $XY$ through vertex $A$, parallel to side $BC$.',
      'Apply the alternate angle rule on one side: since $XY \parallel BC$ and $AB$ is a transversal, $\angle XAB = \angle ABC$ (alternate angles).',
      'Apply the alternate angle rule on the other side: since $XY \parallel BC$ and $AC$ is a transversal, $\angle YAC = \angle ACB$ (alternate angles).',
      'Use the straight-line angle fact at $A$: $\angle XAB + \angle BAC + \angle YAC = 180^\circ$, since $X$, $A$, $Y$ all lie on the straight line $XY$.',
      'Substitute the two alternate-angle equalities from steps 4 and 5 into the straight-line equation from step 6: $\angle ABC + \angle BAC + \angle ACB = 180^\circ$.',
      'Answer: the sum of the angles of triangle $ABC$ is $180^\circ$. Q.E.D.'
    ]),
    'The two rules that make this whole proof work are alternate angles between parallel lines, and angles on a straight line summing to 180°, memorise exactly these two facts to reproduce the full proof from scratch under exam conditions.',
    'This proof is the mathematical foundation behind why a carpenter or roofer can always trust that any triangular roof truss''s three corner angles will add up to a straight line''s worth of turning, 180°, no matter its shape.',
    'triangle',
    '{"vertices": [{"label": "A", "x": 3, "y": 4}, {"label": "B", "x": 0, "y": 0}, {"label": "C", "x": 6, "y": 0}], "angleLabels": [{"vertex": "A", "label": "∠BAC"}, {"vertex": "B", "label": "∠ABC"}, {"vertex": "C", "label": "∠ACB"}]}'::jsonb,
    'published'
  from lesson
  returning id
)
insert into public.worked_examples (lesson_id, title, problem_statement, solution_steps, exam_shortcut, real_life_context, diagram_type, diagram_data, status)
select id,
  'Proving the Exterior Angle Theorem',
  'Prove that the exterior angle of a triangle equals the sum of the two opposite (remote) interior angles.',
  to_jsonb(array[
    'State what is given: triangle $ABC$, with side $BC$ extended to a point $D$, so that $\angle ACD$ is the exterior angle at $C$.',
    'State what is to be proved: $\angle ACD = \angle A + \angle B$.',
    'Use Theorem 1 (angle sum of a triangle): $\angle A + \angle B + \angle ACB = 180^\circ$.',
    'Use the straight-line angle fact at $C$: since $B$, $C$, $D$ lie on a straight line, $\angle ACB + \angle ACD = 180^\circ$.',
    'Compare the two equations from steps 3 and 4: both expressions equal $180^\circ$, so $\angle A + \angle B + \angle ACB = \angle ACB + \angle ACD$.',
    'Subtract $\angle ACB$ from both sides of the equation: $\angle A + \angle B = \angle ACD$.',
    'Answer: the exterior angle $\angle ACD$ equals the sum of the two remote interior angles, $\angle A + \angle B$. Q.E.D.'
  ]),
  'Once Theorem 1 (angle sum = 180°) is proved, the exterior angle theorem follows in just two more lines by comparing it against the straight-line fact at the extended vertex, there is no need to reconstruct a fresh parallel line.',
  'A structural engineer checking that an extended support beam''s outward angle matches the sum of the two far corner angles of a triangular brace relies on exactly this proven relationship.',
  'triangle',
  '{"vertices": [{"label": "A", "x": 3, "y": 4}, {"label": "B", "x": 0, "y": 0}, {"label": "C", "x": 6, "y": 0}], "sideLabels": [{"from": "C", "to": "D", "label": "extended to D"}], "angleLabels": [{"vertex": "A", "label": "∠A"}, {"vertex": "B", "label": "∠B"}]}'::jsonb,
  'published'
from we1;

insert into public.questions (topic_id, question_text, question_latex, option_a, option_b, option_c, option_d, option_e, correct_letter, difficulty, exam_type, explanation, exam_shortcut, status)
select topic_ref.tid, v.question_text, v.question_latex, v.option_a, v.option_b, v.option_c, v.option_d, v.option_e, v.correct_letter, v.difficulty, v.exam_type, v.explanation, v.exam_shortcut, 'published'
from (select t.id as tid from public.topics t join public.curricula c on c.id = t.curriculum_id
      where c.subject = 'Mathematics' and t.class_level = 'SS1' and t.term = 3 and t.order_index = 307) topic_ref,
lateral (values
  ('What is the difference between an axiom and a theorem?', null::text, 'An axiom is accepted as true without proof; a theorem is proved true using logic from axioms', 'They mean exactly the same thing', 'An axiom only applies to triangles; a theorem applies to all shapes', 'A theorem is always about angles; an axiom is always about lengths', null::text, 'A', 2, 'GENERAL'::exam_type, 'An axiom is a starting assumption taken as self-evidently true, while a theorem must be logically derived and proved from axioms and previously proved theorems.', null::text),
  ('What does "Q.E.D." stand for at the end of a formal proof?', null, 'Quod Erat Demonstrandum, "what was to be shown"', 'Quick Estimate, Draw Diagram', 'Question Ends Definitively', 'Quantity Equals Distance', null, 'A', 1, 'GENERAL', 'Q.E.D. is the traditional Latin abbreviation marking that the statement to be proved has now been fully demonstrated.', null),
  ('In the proof that the angles of a triangle sum to 180°, what construction line is drawn?', null, 'A line joining the triangle''s midpoints', 'A line through one vertex, parallel to the opposite side', 'The perpendicular bisector of one side', 'A diagonal of an inscribed quadrilateral', null, 'B', 2, 'GENERAL', 'The standard proof draws a line through one vertex (A) parallel to the opposite side (BC), which creates the alternate angles needed for the argument.', null),
  ('Which angle rules connect the triangle''s angles to the straight-line angles in the angle-sum proof?', null, 'Corresponding angles and vertically opposite angles', 'Alternate angles between parallel lines, and angles on a straight line summing to 180°', 'Co-interior angles only', 'The Pythagorean theorem', null, 'B', 2, 'GENERAL', 'The proof relies on exactly two facts: alternate angles are equal across the parallel construction line, and angles on a straight line sum to 180°.', null),
  ('State the theorem about the exterior angle of a triangle.', null, 'It equals the interior angle at the same vertex', 'It equals the sum of the two interior opposite (remote) angles', 'It is always 180° minus the smallest interior angle', 'It equals half the angle sum of the triangle', null, 'B', 2, 'GENERAL', 'The exterior angle theorem states that an exterior angle equals the sum of the two interior angles not adjacent to it (the two "remote" angles).', null),
  ('What two rules combine to prove the exterior angle theorem, once the angle-sum theorem is already known?', null, 'Vertically opposite angles and co-interior angles', 'The angle sum of a triangle (=180°) and angles on a straight line (=180°)', 'Corresponding angles and the Pythagorean theorem', 'Alternate angles alone, with no straight-line fact needed', null, 'B', 2, 'GENERAL', 'Both equal 180°: the triangle''s angle sum, and the straight line through the extended side; equating and simplifying them gives the exterior angle theorem directly.', null),
  ('In the "Given / To Prove / Construction / Proof / Q.E.D." structure of a formal proof, what is the purpose of the "Construction" step?', null, 'To state the final answer', 'To add a helper line or point (if needed) that makes the rest of the logical argument possible', 'To measure the diagram with a protractor', 'To restate the "Given" information a second time', null, 'B', 2, 'GENERAL', 'A construction step introduces an extra line, point, or circle not originally given, purely to enable the logical steps that follow, such as the parallel line XY through A in Theorem 1.', null),
  ('Write out, in outline, the full logical structure used to prove the angle sum of a triangle is 180°.', null, 'Measure all three angles with a protractor and add them', 'State the given triangle, draw a line through one vertex parallel to the opposite side, apply alternate angles twice, then use the straight-line angle fact, concluding with Q.E.D.', 'Assume the result is true without proof, since it is an axiom', 'Compare the triangle to a square and subtract 90° four times', null, 'B', 3, 'GENERAL', 'The proof''s outline is exactly: given triangle, construct a parallel line through one vertex, apply alternate angles on both sides, then use the straight-line fact and substitute, concluding Q.E.D.', null),
  ('In the exterior angle theorem''s proof, an equation from Theorem 1 and an equation from the straight-line fact are compared. What algebraic step directly produces the final result?', null, 'Multiplying both equations together', 'Subtracting the common term ∠ACB from both sides, since both equations equal 180°', 'Dividing both equations by 2', 'Adding a new construction line and starting over', null, 'B', 3, 'GENERAL', 'Since both $\angle A+\angle B+\angle ACB$ and $\angle ACB+\angle ACD$ equal 180°, setting them equal and subtracting the shared $\angle ACB$ term isolates $\angle A+\angle B=\angle ACD$ directly.', null),
  ('State, in your own words, why an exterior angle of a triangle is always greater than either remote interior angle alone.', null, 'Because exterior angles are always obtuse', 'Because it equals the sum of the two remote interior angles, and both of those angles are positive, so the sum must exceed each one individually', 'Because exterior angles are measured differently from interior angles', 'It is not always true; it depends on the triangle''s shape', null, 'B', 3, 'GENERAL', 'Since the exterior angle is the sum of two positive angles, it must be strictly larger than either one of them taken alone, this holds for every triangle without exception.', null)
) as v(question_text, question_latex, option_a, option_b, option_c, option_d, option_e, correct_letter, difficulty, exam_type, explanation, exam_shortcut);

-- ==========================================
-- TOPIC 308: Parallel Lines, Congruent Triangles & Parallelograms
-- Source: Third Term Week 9 in full (parallel-line angle theorems,
-- congruent-triangle conditions SSS/SAS/ASA/RHS, parallelogram
-- properties, polygon angle-sum rules, the intercept theorem).
-- Questions: Week 9 Q1-22 (22 total).
-- ==========================================

with lesson as (
  insert into public.lessons (topic_id, title, summary, content_body, order_index)
  values (
    (select t.id from public.topics t join public.curricula c on c.id = t.curriculum_id
     where c.subject = 'Mathematics' and t.class_level = 'SS1' and t.term = 3 and t.order_index = 308),
    'Parallel Lines, Congruent Triangles, and Parallelogram Properties',
    'The full toolbox of angle and shape theorems, parallel-line angles, congruent-triangle conditions, parallelogram properties, polygon angle rules, and the intercept theorem, used to solve geometric riders and write formal proofs.',
    '## Basic Angle Facts

Angles on a straight line sum to $180^\circ$; angles at a point sum to $360^\circ$; vertically opposite angles are equal.

## Parallel Line Theorems

Given $l_1 \parallel l_2$ cut by a transversal: **alternate angles are equal** ("Z-angles"); **corresponding angles are equal** ("F-angles"); **co-interior (allied) angles sum to $180^\circ$** ("C-angles").

## Triangle Theorems

Angles sum to $180^\circ$; the exterior angle equals the sum of the two opposite interior angles; in an isosceles triangle, the base angles (opposite the equal sides) are equal.

## Congruent Triangles

Two triangles are identical in shape and size if any one of these holds: **SSS** (all three sides equal); **SAS** (two sides and the *included* angle equal); **ASA** (two angles and the *included* side equal); **RHS** (right angle, hypotenuse, and one other side equal).

## Properties of a Parallelogram

Opposite sides equal and parallel; opposite angles equal; diagonals bisect each other; adjacent angles are supplementary (sum to $180^\circ$).

## Polygon Angle Rules

Sum of interior angles of an $n$-sided polygon $= (n-2) \times 180^\circ$; sum of exterior angles of any convex polygon $= 360^\circ$ (always, regardless of the number of sides).

## Intercept Theorem

If three or more parallel lines cut two transversals, they divide the transversals in the same ratio; in particular, equal intercepts on one transversal correspond to equal intercepts on the other.

**Key exam habits:** memorise the "letter shapes" for spotting parallel-line angles fast, Z-shape = alternate (equal), F-shape = corresponding (equal), C/U-shape = co-interior (sum to $180^\circ$); for any regular polygon, remember one formula and derive the rest, exterior angle $= 360^\circ/n$, interior angle $= 180^\circ$ minus exterior angle; for congruent-triangle riders, scan the diagram for a shared side, vertically opposite angles, or a midpoint first, these are the most commonly overlooked ways to complete an SSS, SAS, ASA, or RHS argument.',
    1
  )
  returning id
),
we1 as (
  insert into public.worked_examples (lesson_id, title, problem_statement, solution_steps, exam_shortcut, real_life_context, diagram_type, diagram_data, status)
  select id,
    'Using Alternate Angles and the Angle Sum in a Combined Rider',
    '$PQ \parallel RS$, with a transversal cutting them so that $\angle PQR = 40^\circ$; at $R$, a small triangle is formed with a third angle of $70^\circ$ at vertex $T$. Find $\angle QRT$.',
    to_jsonb(array[
      'Identify the angle relationship between the parallel lines: since $PQ \parallel RS$ and $QR$ is a transversal, the angle at $R$ alternate to $\angle PQR$ is related by the alternate-angle rule ("Z-angles").',
      'Apply alternate angles: because $PQ \parallel RS$, the angle at $R$ alternate to $\angle PQR$ (on the opposite side of transversal $QR$, between the parallels) equals $40^\circ$.',
      'Set up triangle $QRT$ with this transferred angle: it now has one angle $=40^\circ$ (transferred by alternate angles) and another given angle $=70^\circ$.',
      'Apply the angle-sum theorem to triangle $QRT$: $40^\circ+70^\circ+\angle QRT=180^\circ$.',
      'Add the two known angles: $40+70=110$.',
      'Subtract from $180^\circ$: $\angle QRT=180-110=70^\circ$.',
      'Answer: $\angle QRT = 70^\circ$.'
    ]),
    'Trace the "letter shapes" with your finger on the diagram, Z for alternate angles, F for corresponding, C/U for co-interior, this is faster under exam pressure than trying to recall the rule names from memory alone.',
    'A fabricator laying out parallel roof rafters that are crossed by a diagonal support beam uses exactly this alternate-angle transfer to find an unmarked joint angle without measuring it directly.',
    'none', '{}'::jsonb,
    'published'
  from lesson
  returning id
),
we2 as (
  insert into public.worked_examples (lesson_id, title, problem_statement, solution_steps, exam_shortcut, real_life_context, diagram_type, diagram_data, status)
  select id,
    'Proving a Parallelogram Is a Rhombus',
    'In parallelogram $ABCD$, diagonal $AC$ bisects $\angle A$. Prove that $ABCD$ is a rhombus.',
    to_jsonb(array[
      'State what is given: $ABCD$ is a parallelogram (so $AB \parallel DC$ and $AD \parallel BC$, with $AB=DC$ and $AD=BC$), and diagonal $AC$ bisects $\angle DAB$.',
      'State what is to be proved: $ABCD$ is a rhombus, i.e. all four sides are equal ($AB=BC=CD=AD$).',
      'Use the bisection condition: since $AC$ bisects $\angle A$, let $\angle DAC = \angle CAB = x$.',
      'Bring in the parallel sides: $AD \parallel BC$, and $AC$ is a transversal crossing both, so $\angle DAC$ and $\angle ACB$ are alternate angles, meaning $\angle ACB = x$ too.',
      'Look at triangle $ABC$: it now has $\angle CAB = x$ and $\angle ACB = x$, two equal angles.',
      'Apply the isosceles-triangle rule (converse): a triangle with two equal angles has the sides opposite them equal, so $AB = BC$.',
      'Bring in the parallelogram side property: opposite sides are equal, so $AB=DC$ and $BC=AD$.',
      'Combine the results: since $AB=BC$ and $AB=DC$, $BC=AD$, all four sides must be equal, $AB=BC=CD=AD$.',
      'Answer: $ABCD$ is a rhombus. Q.E.D.'
    ]),
    'In deductive proofs (riders), always write the reason in brackets next to every statement, WAEC/NECO award marks per correct reason, not just for the final conclusion.',
    'This exact rider structure mirrors how a fabricator verifying a diamond-shaped (rhombus) gate panel checks that a diagonal brace bisecting one corner guarantees all four sides came out equal.',
    'none', '{}'::jsonb,
    'published'
  from lesson
  returning id
)
insert into public.worked_examples (lesson_id, title, problem_statement, solution_steps, exam_shortcut, real_life_context, diagram_type, diagram_data, status)
select id,
  'Proving Opposite Angles of a Parallelogram Are Equal',
  'Prove that opposite angles of a parallelogram $ABCD$ are equal.',
  to_jsonb(array[
    'State what is given: $ABCD$ is a parallelogram, so $AB \parallel DC$ and $AD \parallel BC$.',
    'State what is to be proved: $\angle A = \angle C$ and $\angle B = \angle D$.',
    'Use $AB \parallel DC$ with $AD$ as the transversal: co-interior (allied) angles between parallel lines sum to $180^\circ$, so $\angle A + \angle D = 180^\circ$.',
    'Use $AD \parallel BC$ with $AB$ as the transversal: again by co-interior angles, $\angle A + \angle B = 180^\circ$.',
    'Compare the two equations: both equal $180^\circ$, so $\angle A + \angle D = \angle A + \angle B$.',
    'Subtract $\angle A$ from both sides: $\angle D = \angle B$.',
    'Repeat the same argument using the other pair of parallel sides ($BC \parallel AD$ with $DC$ as transversal, and $AB \parallel DC$ with $BC$ as transversal) to show $\angle B + \angle C = 180^\circ$, giving $\angle A = \angle C$ by the same subtraction method.',
    'Answer: $\angle A = \angle C$ and $\angle B = \angle D$, opposite angles of a parallelogram are equal. Q.E.D.'
  ]),
  'Use co-interior angles (they sum to 180° across parallel sides) instead of a protractor whenever a "verify the opposite angle" check is asked for, it is faster and shows full geometric reasoning to an examiner.',
  'A welder checking that a parallelogram-shaped metal frame, such as a folding gate or scissor lift arm, has matching opposite angles uses exactly this co-interior angle argument instead of measuring each corner.',
  'none', '{}'::jsonb,
  'published'
from we1;

insert into public.questions (topic_id, question_text, question_latex, option_a, option_b, option_c, option_d, option_e, correct_letter, difficulty, exam_type, explanation, exam_shortcut, status)
select topic_ref.tid, v.question_text, v.question_latex, v.option_a, v.option_b, v.option_c, v.option_d, v.option_e, v.correct_letter, v.difficulty, v.exam_type, v.explanation, v.exam_shortcut, 'published'
from (select t.id as tid from public.topics t join public.curricula c on c.id = t.curriculum_id
      where c.subject = 'Mathematics' and t.class_level = 'SS1' and t.term = 3 and t.order_index = 308) topic_ref,
lateral (values
  ('List the three main parallel-line angle theorems.', null::text, 'Alternate angles equal, corresponding angles equal, co-interior angles sum to 180°', 'Vertically opposite angles equal, angles on a line sum to 180°, angles at a point sum to 360°', 'SSS, SAS, ASA', 'Interior angle sum, exterior angle sum, intercept theorem', null::text, 'A', 1, 'GENERAL'::exam_type, 'The three parallel-line rules are: alternate angles equal (Z), corresponding angles equal (F), co-interior angles sum to 180° (C).', null::text),
  ('What are the four conditions for proving two triangles congruent?', null, 'SSS, SAS, ASA, RHS', 'AAA, SSA, ASA, HL', 'SSS, AAA, SAS, SSA', 'RHS only, since it is the strongest condition', null, 'A', 2, 'GENERAL', 'The four valid congruence conditions are SSS, SAS (included angle), ASA (included side), and RHS (right angle, hypotenuse, one side).', null),
  ('What is the formula for the sum of interior angles of an n-sided polygon?', '$\text{Sum} = ?$', '$(n-2) \times 180^\circ$', '$n \times 180^\circ$', '$(n-1) \times 180^\circ$', '$360^\circ / n$', null, 'A', 1, 'GENERAL', 'A convex n-sided polygon can be split into $(n-2)$ triangles from one vertex, each contributing 180°.', null),
  ('What is the sum of all exterior angles of any convex polygon?', null, '180°', '270°', '360°', 'It depends on the number of sides', null, 'C', 1, 'GENERAL', 'Walking once fully around any convex polygon''s boundary means turning through exactly one full revolution, 360° in total.', null),
  ('What is the difference between a parallelogram and a rhombus?', null, 'A rhombus is a parallelogram with all four sides equal, not just opposite sides', 'A parallelogram always has four right angles; a rhombus does not', 'They are unrelated shapes', 'A rhombus has one pair of parallel sides; a parallelogram has two', null, 'A', 1, 'GENERAL', 'Every rhombus is a parallelogram, but with the extra condition that all four sides (not just opposite pairs) are equal in length.', null),
  ('In parallelogram ABCD, ∠A = 100°. Find ∠B.', null, '80°', '90°', '100°', '110°', null, 'A', 2, 'GENERAL', '∠A and ∠B are co-interior (adjacent) angles, so they sum to 180°: $180-100=80^\circ$.', null),
  ('What does the Intercept Theorem state?', null, 'Parallel lines cutting two transversals divide them in the same ratio, so equal intercepts on one give equal intercepts on the other', 'All triangles cut by a parallel line have equal areas', 'Every polygon has equal interior and exterior angle sums', 'Congruent triangles always have equal perimeters', null, 'A', 2, 'GENERAL', 'The intercept theorem says a family of parallel lines cuts any two transversals in matching, proportional segments.', null),
  ('State the SAS condition for triangle congruence, and explain why the angle must be "included."', null, 'Two sides and any angle equal; the angle''s position does not matter', 'Two sides and the angle between them equal; if the angle is not between the two given sides, the triangles need not be congruent', 'Two angles and any side equal', 'Three angles equal, regardless of side lengths', null, 'B', 3, 'GENERAL', 'SAS requires the angle to sit between the two given sides; otherwise (the SSA case) the third side is not uniquely determined and two different triangles could result.', null),
  ('In a diagram, PQ ∥ RS, ∠PQR = 40°, and a triangle at R has another angle of 70°. Find ∠QRT (the third angle of that triangle).', null, '60°', '65°', '70°', '75°', null, 'C', 3, 'GENERAL', 'By alternate angles, the transferred angle at R is 40°; then $40+70+\angle QRT=180 \Rightarrow \angle QRT=70^\circ$.', null),
  ('A regular polygon has 9 sides (a nonagon). Find each interior angle.', null, '120°', '130°', '140°', '150°', null, 'C', 2, 'GENERAL', 'Sum of interior angles $=(9-2)\times180=1260^\circ$; each angle (regular) $=1260/9=140^\circ$.', null),
  ('A regular polygon has 10 sides. Find its exterior angle.', null, '30°', '36°', '40°', '45°', null, 'B', 2, 'GENERAL', 'For any regular polygon, exterior angle $=360^\circ/n=360/10=36^\circ$.', null),
  ('Given a parallelogram ABCD where diagonal AC bisects ∠A, what shape must ABCD be?', null, 'A rectangle', 'A rhombus', 'A trapezium', 'A kite (but not a parallelogram)', null, 'B', 3, 'GENERAL', 'Bisecting one angle with a diagonal, combined with the parallelogram side properties, forces all four sides equal, making it a rhombus.', null),
  ('What must be true of opposite angles in any parallelogram?', null, 'They are always supplementary (sum to 180°)', 'They are always equal', 'They are always right angles', 'They cannot be determined without more information', null, 'B', 2, 'GENERAL', 'Opposite angles of a parallelogram are always equal, this follows from applying co-interior angles to both pairs of parallel sides.', null),
  ('A polygon has an interior angle sum of 900°. How many sides does it have?', null, '5', '6', '7', '8', null, 'C', 2, 'GENERAL', '$(n-2)\times180=900 \Rightarrow n-2=5 \Rightarrow n=7$.', null),
  ('The exterior angle of a regular polygon is 30°. How many sides does it have?', null, '8', '10', '12', '15', null, 'C', 2, 'GENERAL', '$n = 360/30 = 12$ sides.', null),
  ('Given an isosceles triangle ABC with AB = AC, and M the midpoint of BC, which congruence condition proves △ABM ≅ △ACM using only side lengths?', null, 'ASA', 'RHS', 'SSS (AB=AC given, BM=CM since M is the midpoint, AM common)', 'SAS with a non-included angle', null, 'C', 3, 'GENERAL', 'All three corresponding sides match: AB=AC (given), BM=CM (M is the midpoint), and AM is shared by both triangles, giving SSS.', null),
  ('Find the interior angle of a regular pentagon (5 sides).', null, '100°', '104°', '108°', '112°', null, 'C', 2, 'GENERAL', 'Sum $=(5-2)\times180=540^\circ$; each angle $=540/5=108^\circ$.', null),
  ('AB is a straight line; two angles marked 3x and 2x lie on it with a third angle of 50°. Find x.', null, '24°', '26°', '28°', '30°', null, 'B', 3, 'GENERAL', 'Angles on a straight line sum to 180°: $3x+2x+50=180 \Rightarrow 5x=130 \Rightarrow x=26^\circ$.', null),
  ('Two triangles share a common side and have two pairs of equal angles. Which congruence condition applies if the shared side lies between the two equal angles?', null, 'SSS', 'SAS', 'ASA (or AAS if the side is not included)', 'RHS', null, 'C', 3, 'GENERAL', 'Two equal angles and a shared included side give ASA directly; if the shared side is not between the two angles, it is AAS, still sufficient since the third angles must also match.', null),
  ('A quadrilateral''s angles are (x+10)°, 2x°, 90°, and (x+20)°. Find x, using the fact that a quadrilateral''s angles sum to 360°.', null, '50°', '55°', '60°', '65°', null, 'C', 3, 'GENERAL', '$(x+10)+2x+90+(x+20)=360 \Rightarrow 4x+120=360 \Rightarrow x=60^\circ$.', null),
  ('State why the sum of the exterior angles of any convex polygon is always 360°, regardless of the number of sides.', null, 'Because every polygon can be split into the same number of triangles', 'Because walking once fully around the polygon''s boundary means turning through one complete revolution, 360°, in total, one exterior-angle turn at each vertex', 'Because exterior angles are always equal to interior angles', 'It is only true for regular polygons, not irregular ones', null, 'B', 3, 'GENERAL', 'Tracing the full perimeter of any convex polygon and returning to the start means the total turning at every vertex adds up to exactly one full revolution, 360°, true for regular and irregular convex polygons alike.', null),
  ('In triangle ABC with AB ∥ DE (DE inside the triangle, cutting AC and BC), what theorem allows the ratio AD:DC to be compared with BE:EC?', null, 'The angle sum theorem', 'The intercept theorem (basic proportionality)', 'The exterior angle theorem', 'The congruent triangles SSS rule', null, 'B', 3, 'GENERAL', 'A line parallel to one side of a triangle, cutting the other two sides, divides them in the same ratio, which is exactly the intercept theorem applied inside a triangle.', null)
) as v(question_text, question_latex, option_a, option_b, option_c, option_d, option_e, correct_letter, difficulty, exam_type, explanation, exam_shortcut);

-- ==========================================
-- TOPIC 309: Statistics: Data Collection & Presentation
-- Source: the definitions/data-types half of Third Term Week 10
-- (statistics, population/sample, primary/secondary data,
-- qualitative/quantitative/discrete/continuous data, raw data, array,
-- frequency table). Questions: Week 10 Q1-9 (9 total). Thin topic:
-- the curated source has no dedicated numeric worked example for pure
-- data collection/classification, so the one worked example below was
-- authored to demonstrate building a frequency table, using the same
-- method the source applies throughout the term.
-- ==========================================

with lesson as (
  insert into public.lessons (topic_id, title, summary, content_body, order_index)
  values (
    (select t.id from public.topics t join public.curricula c on c.id = t.curriculum_id
     where c.subject = 'Mathematics' and t.class_level = 'SS1' and t.term = 3 and t.order_index = 309),
    'Statistics: Data Collection and Presentation',
    'Understanding what statistics is, the different types of data, and how raw data is organised into an array or a frequency table.',
    '## What Is Statistics?

**Statistics** is the science of collecting, organising, analysing, and interpreting data. The **population** is the entire group of interest; a **sample** is a smaller, representative subgroup studied when the population is too large.

**Primary data** is collected first-hand (questionnaires, interviews, experiments, observation); **secondary data** is obtained from an existing source (reports, textbooks, databases).

## Types of Data

**Qualitative (categorical)** data describes a quality, not a number (e.g. favourite colour). **Quantitative (numerical)** data is either **discrete** (countable, e.g. number of children) or **continuous** (measurable, can take any value in a range, e.g. height).

## Organising Data

**Raw data** is unorganised, as collected. An **array** arranges it in ascending or descending order. A **frequency table** tallies how many times each value occurs, using a tally column as a quick counting aid while going through the raw data, then totalling the tallies into a frequency column.

**Key exam habits:** to classify data quickly, ask two questions in sequence: "Can I count it in whole numbers?" (yes = discrete; no, but still numerical = continuous), and "Is it even a number at all?" (no = qualitative); always check whether a data source involved the researcher directly collecting it (primary) or reading it from an existing record (secondary).',
    1
  )
  returning id
)
insert into public.worked_examples (lesson_id, title, problem_statement, solution_steps, exam_shortcut, real_life_context, diagram_type, diagram_data, status)
select id,
  'Building a Frequency Table from Raw Survey Data',
  'A researcher asks 15 SS1 students how many siblings they have, and records the raw data as it comes in: 2, 1, 3, 0, 2, 1, 1, 2, 3, 0, 1, 2, 2, 1, 0. Organise this raw data into a frequency table.',
  to_jsonb(array[
    'Identify the data type first: "number of siblings" is countable in whole numbers, so it is quantitative and discrete data, and this was collected first-hand by the researcher, so it is primary data.',
    'List the distinct values that appear in the raw data: 0, 1, 2, 3.',
    'Go through the raw data once, making a tally mark next to the matching value for every entry, this is the purpose of the tally column, a quick running count.',
    'Count the tally marks for each value: 0 appears 3 times, 1 appears 5 times, 2 appears 5 times, 3 appears 2 times.',
    'Write these counts as the frequency column, and check the frequencies add up to the total number of students surveyed: $3+5+5+2=15$. ✓',
    'Answer: the frequency table is Siblings 0,1,2,3 with frequencies 3,5,5,2 respectively, confirmed against the 15 students surveyed.'
  ]),
  'Always total the frequency column at the end and check it matches the number of data items you started with, this single check catches almost every tallying mistake before it affects a mean, median or mode calculated from the table.',
  'This is exactly the first step a school administrator takes when turning a raw list of, say, WAEC exam scores or attendance records for a Nigerian SS1 class into an organised table ready for further analysis.',
  'none', '{}'::jsonb,
  'published'
from lesson;

insert into public.questions (topic_id, question_text, question_latex, option_a, option_b, option_c, option_d, option_e, correct_letter, difficulty, exam_type, explanation, exam_shortcut, status)
select topic_ref.tid, v.question_text, v.question_latex, v.option_a, v.option_b, v.option_c, v.option_d, v.option_e, v.correct_letter, v.difficulty, v.exam_type, v.explanation, v.exam_shortcut, 'published'
from (select t.id as tid from public.topics t join public.curricula c on c.id = t.curriculum_id
      where c.subject = 'Mathematics' and t.class_level = 'SS1' and t.term = 3 and t.order_index = 309) topic_ref,
lateral (values
  ('Define Statistics.', null::text, 'The science of collecting, organising, analysing and interpreting data', 'The study of shapes and their properties', 'The calculation of probabilities of random events only', 'The measurement of physical quantities like length and mass', null::text, 'A', 1, 'GENERAL'::exam_type, 'Statistics is broadly defined as the science covering the whole data lifecycle: collection, organisation, analysis, and interpretation.', null::text),
  ('What is the difference between Primary and Secondary data?', null, 'Primary data is collected first-hand by the researcher; secondary data is already collected by someone else', 'Primary data is always numerical; secondary data is always categorical', 'There is no real difference between them', 'Primary data comes from textbooks; secondary data comes from surveys', null, 'A', 1, 'GENERAL', 'Primary data is gathered directly by the person doing the study (e.g. a survey they ran); secondary data is sourced from an existing report or database someone else compiled.', null),
  ('What is the difference between Qualitative and Quantitative data?', null, 'Qualitative data describes categories or qualities (non-numerical); quantitative data consists of numbers', 'Qualitative data is always continuous; quantitative data is always discrete', 'They are two names for the same type of data', 'Qualitative data can only come from surveys', null, 'A', 1, 'GENERAL', 'Qualitative (categorical) data records a quality or label, like a favourite colour; quantitative data records an actual number.', null),
  ('Which pair correctly gives an example of Discrete data and an example of Continuous data?', null, 'Discrete: height; Continuous: number of siblings', 'Discrete: number of siblings; Continuous: height', 'Discrete: favourite colour; Continuous: number of siblings', 'Discrete: height; Continuous: favourite colour', null, 'B', 2, 'GENERAL', 'Number of siblings is countable in whole numbers (discrete); height can take any value in a range, including decimals (continuous).', null),
  ('What is the purpose of the Tally column in a frequency table?', null, 'To record the final total only', 'A quick way to count occurrences while going through the raw data, before totalling as the frequency', 'To list the data in alphabetical order', 'To calculate the mean directly', null, 'B', 1, 'GENERAL', 'A tally is a running count made as you scan through the raw data once, which is then totalled into the frequency column.', null),
  ('A researcher gets data from the National Bureau of Statistics for a class project. Is this primary or secondary data?', null, 'Primary data', 'Secondary data', 'Neither, it is not valid data', 'Both, depending on the topic', null, 'B', 1, 'GENERAL', 'Since the data was already collected and published by another organisation (NBS), using it counts as secondary data.', null),
  ('A student personally counts and records the number of cars passing the school gate each hour. Is this primary or secondary data?', null, 'Primary data', 'Secondary data', 'Neither, it is not statistics', 'It cannot be determined', null, 'A', 1, 'GENERAL', 'The student collected this data first-hand through direct observation, which makes it primary data.', null),
  ('Classify the following: (a) phone brands owned by students in a class, (b) number of siblings a student has, (c) time taken to run 100 m.', null, '(a) qualitative, (b) discrete, (c) continuous', '(a) discrete, (b) qualitative, (c) continuous', '(a) qualitative, (b) continuous, (c) discrete', '(a) continuous, (b) discrete, (c) qualitative', null, 'A', 2, 'GENERAL', 'Phone brand is a category (qualitative); number of siblings is a countable whole number (discrete); time is measured and can take any value (continuous).', null),
  ('What is "raw data"?', null, 'Data that has already been sorted into an array', 'Data as collected, not yet organised or arranged in order', 'Only data collected from a secondary source', 'Data that has already been converted into a frequency table', null, 'B', 1, 'GENERAL', 'Raw data is the unprocessed list of values exactly as gathered, before any sorting, tallying, or tabulation has been done.', null)
) as v(question_text, question_latex, option_a, option_b, option_c, option_d, option_e, correct_letter, difficulty, exam_type, explanation, exam_shortcut);

-- ==========================================
-- TOPIC 310: Range, Median & Mode (Ungrouped Data)
-- Source: the ungrouped calculation half of Third Term Week 10 (mean,
-- median, mode, range, and quartiles of raw/array data). Questions:
-- Week 10 Q10-44 (35 total).
-- ==========================================

with lesson as (
  insert into public.lessons (topic_id, title, summary, content_body, order_index)
  values (
    (select t.id from public.topics t join public.curricula c on c.id = t.curriculum_id
     where c.subject = 'Mathematics' and t.class_level = 'SS1' and t.term = 3 and t.order_index = 310),
    'Range, Median and Mode of Ungrouped Data',
    'Calculating the mean, median, mode, and range of a set of raw or tabulated ungrouped data.',
    '## Measures of Central Tendency

- **Mean** ($\bar{x}$): $\bar{x} = \dfrac{\Sigma x}{n}$ for raw data; for a frequency distribution, $\bar{x} = \dfrac{\Sigma fx}{\Sigma f}$.
- **Median:** arrange the data in an array (ascending order); if $n$ is odd, the median is the single middle value, at position $\dfrac{n+1}{2}$; if $n$ is even, it is the mean of the two middle values, at positions $\dfrac{n}{2}$ and $\dfrac{n}{2}+1$.
- **Mode:** the value that occurs with the greatest frequency (there may be more than one mode, or none).

## Range and Quartiles

**Range** (a simple measure of spread): the difference between the largest and smallest values in the data.

**Quartiles** (from cumulative frequency): $Q_1 = \tfrac14(\text{cum. freq.})$, $Q_2 = \tfrac24(\text{cum. freq.})$ (the median), $Q_3 = \tfrac34(\text{cum. freq.})$.

**Semi-interquartile range** $= \dfrac{Q_3 - Q_1}{2}$.

**Key exam habits:** for the median''s position, always sort the data into a full array first, an unsorted list gives a wrong median even with correct counting; when finding the mean from a frequency table, build the $fx$ column beside the frequency column and total both before dividing, never divide by the number of *distinct* scores instead of the total frequency $\Sigma f$, this is the single most common error in frequency-table mean questions.',
    1
  )
  returning id
),
we1 as (
  insert into public.worked_examples (lesson_id, title, problem_statement, solution_steps, exam_shortcut, real_life_context, diagram_type, diagram_data, status)
  select id,
    'Finding the Mean of Raw Data',
    'Find the mean of $1, 3, 4, 8, 8, 4, 7$.',
    to_jsonb(array[
      'Recall the mean formula for raw data: mean $= \Sigma x / n$ (sum of all values, divided by how many values there are).',
      'Add up all the values: $1+3+4+8+8+4+7$.',
      'Add carefully in pairs to avoid mistakes: $1+3=4$; $4+4=8$; $8+8=16$; $16+8=24$; $24+4=28$; $28+7=35$.',
      'Count how many values there are: $n=7$.',
      'Divide the sum by $n$: mean $= 35 \div 7 = 5$.',
      'Answer: mean $= 5$.'
    ]),
    'Add the numbers in convenient pairs (rather than left to right blindly) to reduce arithmetic slips, and always recount n before dividing.',
    'A shop owner in a Nigerian market averaging her daily sales figures over a week uses exactly this mean calculation to see her typical takings.',
    'none', '{}'::jsonb,
    'published'
  from lesson
  returning id
),
we2 as (
  insert into public.worked_examples (lesson_id, title, problem_statement, solution_steps, exam_shortcut, real_life_context, diagram_type, diagram_data, status)
  select id,
    'Finding the Median: Odd Number of Values',
    'Find the median of $6, 1, 0, 3, 10, 2, 5$.',
    to_jsonb(array[
      'Recall that the median needs the data sorted first, arrange the values into an array (ascending order).',
      'Sort the numbers: $0, 1, 2, 3, 5, 6, 10$.',
      'Count the values: $n=7$ (an odd number).',
      'Since $n$ is odd, the median is the single middle value, at position $(n+1)/2 = (7+1)/2 = 4$th value.',
      'Count to the 4th value in the sorted array ($0,1,2,[3],5,6,10$): the 4th value is $3$.',
      'Answer: median $= 3$.'
    ]),
    'Never try to "eyeball" the middle of a list without sorting first, an unsorted list gives a wrong median even if the position formula is applied correctly.',
    'A school counsellor finding the median score on a class quiz to describe a "typical" result unaffected by one very high or very low outlier score uses exactly this array-and-middle-value method.',
    'none', '{}'::jsonb,
    'published'
  from lesson
  returning id
)
insert into public.worked_examples (lesson_id, title, problem_statement, solution_steps, exam_shortcut, real_life_context, diagram_type, diagram_data, status)
select id,
  'Finding the Median: Even Number of Values',
  'Find the median of $5, 7, 11, 9, 15, 12, 18, 6$.',
  to_jsonb(array[
    'Sort the numbers into an array: $5, 6, 7, 9, 11, 12, 15, 18$.',
    'Count the values: $n=8$ (an even number).',
    'Since $n$ is even, the median is the mean of the two middle values, at positions $n/2=4$ and $(n/2)+1=5$.',
    'Identify the 4th and 5th values in the array ($5,6,7,[9],[11],12,15,18$): they are $9$ and $11$.',
    'Average them: median $= (9+11)/2 = 20/2 = 10$.',
    'Answer: median $= 10$.'
  ]),
  'Use "odd → (n+1)/2-th value" and "even → average the (n/2)-th and (n/2+1)-th values" as a fixed rule, never guess which pair of values is the middle pair without counting positions carefully.',
  'A transport company finding the median fuel cost across eight delivery routes, so that one unusually cheap or expensive route does not distort the typical figure, uses exactly this even-count median method.',
  'none', '{}'::jsonb,
  'published'
from we1;

insert into public.questions (topic_id, question_text, question_latex, option_a, option_b, option_c, option_d, option_e, correct_letter, difficulty, exam_type, explanation, exam_shortcut, status)
select topic_ref.tid, v.question_text, v.question_latex, v.option_a, v.option_b, v.option_c, v.option_d, v.option_e, v.correct_letter, v.difficulty, v.exam_type, v.explanation, v.exam_shortcut, 'published'
from (select t.id as tid from public.topics t join public.curricula c on c.id = t.curriculum_id
      where c.subject = 'Mathematics' and t.class_level = 'SS1' and t.term = 3 and t.order_index = 310) topic_ref,
lateral (values
  ('Find the mean of 1, 3, 4, 8, 8, 4, 7.', null::text, '4', '5', '6', '7', null::text, 'B', 1, 'GENERAL'::exam_type, 'Sum $=35$; $n=7$; mean $=35/7=5$.', null::text),
  ('Calculate the mean of 1, 0, 1, 2, 3, 2, 0, 2, 3, 2.', null, '1.4', '1.6', '1.8', '2.0', null, 'B', 2, 'GENERAL', 'Sum $=16$; $n=10$; mean $=16/10=1.6$.', null),
  ('Calculate the mean of 4, 3, 6, 8, 9, 3, 9.', null, '5', '6', '7', '8', null, 'B', 2, 'GENERAL', 'Sum $=42$; $n=7$; mean $=42/7=6$.', null),
  ('Divide the sum of 8, 6, 7, 2, 0, 4, 7, 2, 3 by their mean.', null, '7', '8', '9', '10', null, 'C', 2, 'GENERAL', 'Sum $\div$ mean always equals $n$ (since mean $=$ sum$/n$); here $n=9$.', 'Recognise that sum divided by mean is always just n, no need to actually compute the mean first.'),
  ('If the mean of 6, 8, 9, x, 5, 7 is 8, find x.', null, '11', '12', '13', '14', null, 'C', 2, 'GENERAL', 'Sum must equal $8\times6=48$. $6+8+9+x+5+7=35+x=48 \Rightarrow x=13$.', null),
  ('The weights of 5 girls are 48, x, 52, 50, and (2x−5) kg; the average is 47 kg. Find the heaviest girl''s weight.', null, '50 kg', '52 kg', '55 kg', '60 kg', null, 'C', 4, 'GENERAL', 'Sum $=47\times5=235$. $48+x+52+50+(2x-5)=145+3x=235 \Rightarrow x=30$, so weights are 48,30,52,50,55; the heaviest is 55 kg.', null),
  ('The ages of Abu, Segun, Kofi, Funmi are 17, (2x−13), 14, and 16 years; their mean age is 17.5. Find x.', null, '16', '17', '18', '19', null, 'C', 3, 'GENERAL', 'Sum $=17.5\times4=70$. $17+(2x-13)+14+16=34+2x=70 \Rightarrow x=18$.', null),
  ('The average cost of 20 articles is ₦213; the average cost of the first 9 is ₦115. Find the average cost of the remaining 11 articles.', null, '₦250.00', '₦275.45', '₦293.18', '₦310.00', null, 'C', 4, 'GENERAL', 'Total for 20 $= 20\times213=4260$; first 9 total $=9\times115=1035$; remaining 11 total $=4260-1035=3225$; average $=3225/11\approx293.18$.', null),
  ('The mean age of 10 students is 10 years 6 months. Removing two students aged 12y10m and 13y6m, find the mean age of the remaining 8, to the nearest month.', null, 'About 9 years 5 months', 'About 9 years 10 months', 'About 10 years 2 months', 'About 8 years 6 months', null, 'B', 4, 'GENERAL', 'Total for 10 $\approx105$ years; removing $12\tfrac{10}{12}+13\tfrac{6}{12}\approx26.33$ years leaves $\approx78.67$ years over 8 students $\approx9$ years 10 months.', null),
  ('The mean of 68, 65, x, 69, 77, 48, 64 is 67. Find x.', null, '75', '76', '77', '78', null, 'D', 3, 'GENERAL', 'Sum must equal $67\times7=469$. $68+65+x+69+77+48+64=391+x=469 \Rightarrow x=78$.', null),
  ('A table shows scores 1-8 with frequencies 3, 4, 3, 6, 5, 4, 3, 2. Find the mean, to 1 d.p.', null, '3.9', '4.1', '4.3', '4.5', null, 'C', 3, 'GENERAL', '$\Sigma f=30$, $\Sigma fx=130$; mean $=130/30\approx4.3$.', 'Always divide by the total frequency Σf, not the number of distinct scores.'),
  ('Twenty girls and y boys sat an exam; girls'' mean = 62, boys'' mean = 57, and the total combined score = 2950. Find y.', null, '25', '28', '30', '32', null, 'C', 4, 'GENERAL', 'Girls'' total $=20\times62=1240$. Boys'' total $=2950-1240=1710$. $y=1710/57=30$.', null),
  ('The average age of 10 boys was 12 years; a 15-year-old boy is replaced by a 5-year-old. Find the new average age.', null, '10 years', '11 years', '12 years', '13 years', null, 'B', 3, 'GENERAL', 'Original total $=120$. New total $=120-15+5=110$. New mean $=110/10=11$.', null),
  ('For the distribution: Scores 2, 4, 5, 6, 7 with frequencies 5, 3, 6, 4, 2, find the mean.', null, '4.0', '4.3', '4.5', '4.8', null, 'C', 3, 'GENERAL', '$\Sigma f=20$, $\Sigma fx = 10+12+30+24+14=90$; mean $=90/20=4.5$.', null),
  ('The mean of a frequency distribution (x-values 0, p, 3 with frequencies 2, 3, 1) is 1.5. Find p.', null, '1', '1.5', '2', '2.5', null, 'C', 3, 'GENERAL', '$\Sigma f=6$; $\Sigma fx=0+3p+3$; mean: $(3p+3)/6=1.5 \Rightarrow 3p+3=9 \Rightarrow p=2$.', null),
  ('A frequency table (scores 1-6, frequencies 1, 4, x, 6, 2, 2) has mean 3.5. Find x.', null, '3', '4', '5', '6', null, 'C', 4, 'GENERAL', '$\Sigma f=15+x$; $\Sigma fx = 1+8+3x+24+10+12=55+3x$; solving $(55+3x)/(15+x)=3.5$ gives $x=5$.', null),
  ('Find the median of 6, 1, 0, 3, 10, 2, 5.', null, '2', '3', '5', '6', null, 'B', 2, 'GENERAL', 'Sorted: 0,1,2,3,5,6,10 (n=7, odd); median is the 4th value, 3.', null),
  ('Find the median of 5, 7, 11, 9, 15, 12, 18, 6.', null, '9', '9.5', '10', '11', null, 'C', 2, 'GENERAL', 'Sorted: 5,6,7,9,11,12,15,18 (n=8, even); median $=(9+11)/2=10$.', null),
  ('Find the median of 2.64, 2.50, 2.72, 2.91, 2.35.', null, '2.50', '2.64', '2.72', '2.91', null, 'B', 2, 'GENERAL', 'Sorted: 2.35, 2.50, 2.64, 2.72, 2.91 (n=5, odd); median is the 3rd value, 2.64.', null),
  ('Calculate the median of 3, 2, 6, 8, 9, 6, 8, 12, 11, 12.', null, '7', '7.5', '8', '8.5', null, 'C', 3, 'GENERAL', 'Sorted: 2,3,6,6,8,8,9,11,12,12 (n=10, even); median $=(8+8)/2=8$.', null),
  ('What is the median of 22, 41, 35, 63, 82, 74?', null, '48', '49', '52', '55', null, 'C', 2, 'GENERAL', 'Sorted: 22,35,41,63,74,82 (n=6, even); median $=(41+63)/2=52$.', null),
  ('Find the median of 16, 20, 8, 14, 12, 16, 10, 12, 7, 16.', null, '12', '12.5', '13', '13.5', null, 'C', 3, 'GENERAL', 'Sorted: 7,8,10,12,12,14,16,16,16,20 (n=10, even); median $=(12+14)/2=13$.', null),
  ('Calculate the median of 6, 8, 3, 2, 10, 6, 11, 9, 12, 4.', null, '6.5', '7', '7.5', '8', null, 'B', 3, 'GENERAL', 'Sorted: 2,3,4,6,6,8,9,10,11,12 (n=10, even); median $=(6+8)/2=7$.', null),
  ('What is the mode of: 1,2,3,4,4,5,5,5,4,2,2,3,4,5,5,6?', null, '2', '3', '4', '5', null, 'D', 2, 'GENERAL', 'Counting each value, 5 occurs most often (5 times), so the mode is 5.', null),
  ('Ages of pupils: 7,9,6,10,8,8,9,11,8,7,9,6,8,9,10,7,8,7,9,8. Find the mode.', null, '7', '8', '9', '10', null, 'B', 3, 'GENERAL', 'Counting occurrences, 8 appears most frequently (6 times), so the mode is 8.', null),
  ('The type of average that shows the most popular (most frequent) item in a data set is called what?', null, 'The mean', 'The median', 'The mode', 'The range', null, 'C', 1, 'GENERAL', 'The mode is defined as the value that occurs most often in a data set.', null),
  ('For a distribution with x = 2, 6, 10 and f = 5, 10, 9, find the mode.', null, '2', '6', '9', '10', null, 'B', 2, 'GENERAL', 'The mode is the x-value with the highest frequency; f=10 (the highest) belongs to x=6.', null),
  ('The ages of 10 students are 15, 16, 15.5, 17, 14.9, 14.5, 14.1, 15.1, 15.2, 14.8. Find the range.', null, '2.5', '2.7', '2.9', '3.1', null, 'C', 2, 'GENERAL', 'Largest $=17$, smallest $=14.1$; range $=17-14.1=2.9$.', null),
  ('Numbers in ascending order are (x−2), 8, (5+x), 12, (x+14). Find the range.', null, '14', '15', '16', '17', null, 'C', 3, 'GENERAL', 'Range = largest − smallest = $(x+14)-(x-2)=16$; the unknown x cancels out entirely.', 'Whenever both the largest and smallest terms share the same unknown with the same coefficient, the range is fixed regardless of that unknown''s value.'),
  ('For x = 1,2,3,5,6,7,8 with frequencies 3,4,5,7,6,5,4, find the range of the data.', null, '5', '6', '7', '8', null, 'C', 2, 'GENERAL', 'The x-values range from 1 to 8; range $=8-1=7$.', null),
  ('Which of the following is NOT a measure of dispersion: interquartile range, mean, mean deviation, range, standard deviation?', null, 'Interquartile range', 'Mean', 'Mean deviation', 'Standard deviation', null, 'B', 2, 'GENERAL', 'The mean is a measure of central tendency (an average), not a measure of spread; all the others describe how spread out the data is.', null),
  ('State the formula for the semi-interquartile range.', '$\text{Semi-IQR} = ?$', '$Q_3 - Q_1$', '$\dfrac{Q_3-Q_1}{2}$', '$\dfrac{Q_1+Q_3}{2}$', '$Q_3 \times Q_1$', null, 'B', 1, 'GENERAL', 'The semi-interquartile range is half of the full interquartile range: $(Q_3-Q_1)/2$.', null),
  ('Marks: 6, 7, 8, 12, 15, 8, 9, 5, 28, 15, 17, 21. Find the semi-interquartile range.', null, '3', '3.5', '4', '4.5', null, 'C', 4, 'GENERAL', 'Sorting the 12 marks and locating Q1 and Q3 from the cumulative positions gives a semi-interquartile range of 4.', null),
  ('Shoe sizes of 12 students: size 4, 6, 7, 9, 14 with frequencies 3, 2, 4, 2, 1. Find the semi-interquartile range.', null, '1', '1.5', '2', '2.5', null, 'B', 4, 'GENERAL', 'Building the cumulative frequency table and locating Q1 and Q3 gives a semi-interquartile range of 1.5.', null)
) as v(question_text, question_latex, option_a, option_b, option_c, option_d, option_e, correct_letter, difficulty, exam_type, explanation, exam_shortcut);

-- ==========================================
-- TOPIC 311: Grouped Data: Collection, Tabulation & Presentation
-- Source: the grouped-data tabulation portion of Week 10 (class
-- intervals, class boundaries, class width, class mark, grouped mean
-- formulas) plus the introductory data-presentation portion of Week 11
-- (bar chart vs histogram vs frequency polygon, purpose of each).
-- Questions: Week 10 Q45, 46, 53, 54 (4) + Week 11 Q1-9 (9) = 13 total.
-- The curated source has no single fully-worked numeric example
-- covering the whole "raw data -> grouped table -> mean" pipeline for
-- this specific sub-topic (the grouped median/mode worked examples are
-- reserved for topic 312), so the one worked example below was
-- authored using the direct-method grouped-mean formula taught here.
-- ==========================================

with lesson as (
  insert into public.lessons (topic_id, title, summary, content_body, order_index)
  values (
    (select t.id from public.topics t join public.curricula c on c.id = t.curriculum_id
     where c.subject = 'Mathematics' and t.class_level = 'SS1' and t.term = 3 and t.order_index = 311),
    'Grouped Data: Collection, Tabulation and Presentation',
    'Organising raw data into class intervals, finding class boundaries and class marks, and choosing the right chart type to present grouped or discrete data.',
    '## Grouped Data

When raw data spans a wide range, it is organised into **class intervals** (e.g. 40-42, 43-45, ...).

- **Class boundaries** close the gaps between stated class limits (subtract 0.5 from the lower limit, add 0.5 to the upper limit, or average the gap between adjacent classes).
- **Class width** $=$ upper boundary $-$ lower boundary.
- **Class mark (midpoint)** $= \dfrac{\text{lower limit} + \text{upper limit}}{2}$.

## Mean of Grouped Data

**Direct method:** $\bar{x} = \dfrac{\Sigma fx}{\Sigma f}$, using each class mark $x$ multiplied by its frequency $f$.

**Assumed-mean method:** $\bar{x} = A + \dfrac{\Sigma fd}{\Sigma f}$, where $A$ is an assumed mean and $d = x - A$ for each class mark.

## Choosing a Chart

**Bar chart:** used for discrete or qualitative data; bars have gaps between them, are of equal width, and can be rearranged; the x-axis lists categories or discrete values.

**Histogram:** used for continuous, grouped data; bars must touch (no gaps); the x-axis is marked with class boundaries.

**Frequency polygon:** a line graph joining the midpoints of the tops of histogram bars, "grounded" by adding an imaginary zero-frequency class at each end so the shape closes into a proper polygon, and useful for comparing two distributions on one graph.

**Key exam habits:** for a class interval like $20$-$29$, the class mark is $(20+29)/2=24.5$ and the class boundaries are $19.5$-$29.5$; ask "does this need gaps (bar chart) or must the bars touch (histogram)?" as a fast way to pick the right chart for a data type.',
    1
  )
  returning id
)
insert into public.worked_examples (lesson_id, title, problem_statement, solution_steps, exam_shortcut, real_life_context, diagram_type, diagram_data, status)
select id,
  'Grouping Raw Data and Finding the Mean by the Direct Method',
  'The test scores (out of 50) of 20 SS1 students, grouped into class intervals, are: 21-25 (3 students), 26-30 (5 students), 31-35 (7 students), 36-40 (3 students), 41-45 (2 students). Find the mean score using the direct method.',
  to_jsonb(array[
    'Find the class mark (midpoint) of each interval: $21$-$25 \to 23$; $26$-$30 \to 28$; $31$-$35 \to 33$; $36$-$40 \to 38$; $41$-$45 \to 43$.',
    'Multiply each class mark by its frequency to build the $fx$ column: $23\times3=69$; $28\times5=140$; $33\times7=231$; $38\times3=114$; $43\times2=86$.',
    'Sum the frequency column: $\Sigma f = 3+5+7+3+2=20$ (matches the 20 students). ✓',
    'Sum the $fx$ column: $\Sigma fx = 69+140+231+114+86=640$.',
    'Apply the direct-method formula: $\bar{x} = \Sigma fx / \Sigma f = 640/20$.',
    'Divide: $640 \div 20 = 32$.',
    'Answer: mean score $= 32$ (out of 50).'
  ]),
  'Build the fx column directly beside the frequency column and total both before dividing, never divide Σfx by the number of class intervals instead of the total frequency Σf.',
  'This is exactly how a school records officer summarises a whole class''s test performance into one representative average score for a report card or a school assembly announcement.',
  'none', '{}'::jsonb,
  'published'
from lesson;

insert into public.questions (topic_id, question_text, question_latex, option_a, option_b, option_c, option_d, option_e, correct_letter, difficulty, exam_type, explanation, exam_shortcut, status)
select topic_ref.tid, v.question_text, v.question_latex, v.option_a, v.option_b, v.option_c, v.option_d, v.option_e, v.correct_letter, v.difficulty, v.exam_type, v.explanation, v.exam_shortcut, 'published'
from (select t.id as tid from public.topics t join public.curricula c on c.id = t.curriculum_id
      where c.subject = 'Mathematics' and t.class_level = 'SS1' and t.term = 3 and t.order_index = 311) topic_ref,
lateral (values
  ('What is the median class formula (position) for grouped data when the total frequency Σf is even?', null::text, 'Median class position = Σf', 'Median class position = (Σf)/2', 'Median class position = (Σf + 1)/2', 'Median class position = (Σf)/4', null::text, 'B', 2, 'GENERAL'::exam_type, 'When Σf is even, the median class is located at position Σf/2 in the cumulative frequency.', null::text),
  ('What is the median class formula (position) for grouped data when the total frequency Σf is odd?', null, 'Median class position = (Σf)/2', 'Median class position = (Σf + 1)/2', 'Median class position = Σf − 1', 'Median class position = (Σf)/3', null, 'B', 2, 'GENERAL', 'When Σf is odd, the median class position uses (Σf+1)/2, matching the ungrouped odd-n median rule.', null),
  ('Weights of 50 students are grouped into class intervals and the direct method is used to find the mean weight. What two columns must be built and totalled before dividing?', null, 'Class limits and class boundaries', 'Frequency (f) and class-mark-times-frequency (fx)', 'Tally marks and cumulative frequency only', 'Upper limit and lower limit only', null, 'B', 2, 'GENERAL', 'The direct method needs Σf (total frequency) and Σfx (frequency times class mark, summed), then divides the second by the first.', null),
  ('State the two formulas for the mean of grouped data (with and without an assumed mean).', null, 'x̄ = Σfx/Σf (direct); x̄ = A + Σfd/Σf (assumed-mean method, with d = x − A)', 'x̄ = Σx/n (direct); x̄ = Σf/n (assumed-mean method)', 'x̄ = Σf/Σx (direct); x̄ = A − Σfd/Σf (assumed-mean method)', 'x̄ = Σfd (direct); x̄ = Σfx/A (assumed-mean method)', null, 'A', 2, 'GENERAL', 'The direct method sums fx over f; the assumed-mean (shortcut) method adds a chosen assumed mean A to the average deviation Σfd/Σf.', null),
  ('Why do we use "grouped" frequency tables for large or continuous datasets?', null, 'To make the data harder to interpret', 'To organise many individual values into manageable class intervals, making patterns easier to see', 'Because ungrouped data cannot have a mean', 'Only to satisfy WAEC formatting requirements', null, 'B', 1, 'GENERAL', 'Grouping condenses a long list of individual values into a small number of class intervals, which reveals the overall shape and pattern of the data much more clearly.', null),
  ('What is the main physical difference between a bar chart and a histogram?', null, 'A bar chart uses colour; a histogram does not', 'A bar chart''s bars have gaps between them; a histogram''s bars touch', 'A histogram is always drawn horizontally', 'There is no difference, they are the same chart', null, 'B', 1, 'GENERAL', 'Bar chart bars are deliberately separated by gaps (since categories are distinct); histogram bars touch, reflecting a continuous scale with no gaps between class boundaries.', null),
  ('What type of data is a bar chart typically used for?', null, 'Continuous, grouped data only', 'Discrete or qualitative data', 'Only data with negative values', 'Only data collected from a secondary source', null, 'B', 1, 'GENERAL', 'A bar chart suits discrete counts or qualitative categories, where each bar represents a separate, distinct group.', null),
  ('What type of data is a histogram typically used for?', null, 'Discrete data only', 'Qualitative data only', 'Continuous, grouped data', 'Data with fewer than 5 values', null, 'C', 1, 'GENERAL', 'A histogram is designed for continuous data organised into class intervals, where the touching bars reflect the unbroken number line.', null),
  ('What is plotted on the x-axis of a histogram?', null, 'Class marks (midpoints) only', 'Class boundaries', 'Cumulative frequencies', 'Tally marks', null, 'B', 1, 'GENERAL', 'A histogram''s x-axis is marked using class boundaries, so that adjacent bars sit flush against each other with no gap.', null),
  ('For class interval 20-29, find (a) the class midpoint, (b) the class boundaries.', null, '(a) 24, (b) 20-29', '(a) 24.5, (b) 19.5-29.5', '(a) 25, (b) 19-30', '(a) 24.5, (b) 20-29', null, 'B', 2, 'GENERAL', 'Midpoint $=(20+29)/2=24.5$; boundaries extend the limits by 0.5 on each side: $19.5$-$29.5$.', null),
  ('If you have data for "number of children per family," would you use a bar chart or a histogram?', null, 'A histogram, since family sizes vary continuously', 'A bar chart, since it is discrete, countable data', 'Neither, a pie chart is required', 'A histogram, but only if there are more than 20 families', null, 'B', 2, 'GENERAL', 'Number of children is a countable, discrete quantity, so a bar chart (with gaps between bars) is the appropriate choice.', null),
  ('If you have data for "height of students," would you use a bar chart or a histogram?', null, 'A bar chart, since height is easy to measure', 'A histogram, since height is continuous, measured data', 'Neither, only a line graph works for height', 'A bar chart, but only for small class sizes', null, 'B', 2, 'GENERAL', 'Height can take any value within a range (continuous data), so a histogram, with touching bars over class boundaries, is the correct choice.', null),
  ('What is plotted on the x-axis of a frequency polygon?', null, 'Class boundaries', 'Class midpoints', 'Cumulative frequencies', 'Tally marks', null, 'B', 2, 'GENERAL', 'A frequency polygon is formed by plotting frequency against each class''s midpoint and joining the points with straight lines.', null)
) as v(question_text, question_latex, option_a, option_b, option_c, option_d, option_e, correct_letter, difficulty, exam_type, explanation, exam_shortcut);

-- ==========================================
-- TOPIC 312: Range, Median & Mode (Grouped Data)
-- Source: the grouped-median and grouped-mode worked examples and
-- formulas from Third Term Week 10. Questions: Week 10 Q47-52 (6
-- total). Thinnest question count of the six statistics topics, since
-- most of Week 10's 54 questions are ungrouped (covered under topic
-- 310) or tabulation-focused (covered under topic 311).
-- ==========================================

with lesson as (
  insert into public.lessons (topic_id, title, summary, content_body, order_index)
  values (
    (select t.id from public.topics t join public.curricula c on c.id = t.curriculum_id
     where c.subject = 'Mathematics' and t.class_level = 'SS1' and t.term = 3 and t.order_index = 312),
    'Range, Median and Mode of Grouped Data',
    'Estimating the median and mode of grouped, class-interval data using the standard interpolation formulas.',
    '## Median of Grouped Data

First locate the median class using cumulative frequency (the class containing position $n/2$, or $\Sigma f/2$), then apply:

$$\text{Median} = L_1 + \left[\dfrac{n/2 - Cf_b}{F_m}\right] \times C$$

where $L_1 =$ lower class boundary of the median class, $n =$ total frequency, $Cf_b =$ cumulative frequency before the median class, $F_m =$ frequency of the median class, $C =$ class width.

## Mode of Grouped Data

$$\text{Mode} = L_1 + \left[\dfrac{\Delta_1}{\Delta_1 + \Delta_2}\right] \times C$$

where $L_1 =$ lower boundary of the modal class (the class with the highest frequency), $\Delta_1 = $ (modal frequency $-$ frequency of the class before it), $\Delta_2 = $ (modal frequency $-$ frequency of the class after it), $C =$ class width.

**Key exam habits:** in $\Delta_1/\Delta_2$ mode calculations, $\Delta_1$ always compares the modal class to the class *before* it, and $\Delta_2$ to the class *after* it, reversing them shifts the mode toward the wrong neighbouring class; a fast built-in check for any grouped median: it must fall *within* the median class''s own boundaries, if the computed value falls outside that range, an arithmetic error was made somewhere.',
    1
  )
  returning id
),
we1 as (
  insert into public.worked_examples (lesson_id, title, problem_statement, solution_steps, exam_shortcut, real_life_context, diagram_type, diagram_data, status)
  select id,
    'Estimating the Median of Grouped Data',
    'A distribution has median class $21$-$25$ with class boundaries $20.5$-$25.5$, cumulative frequency before this class $Cf_b = 16$, frequency of this class $F_m = 9$, class width $C = 5$, and total frequency $n = 50$. Find the median.',
    to_jsonb(array[
      'Recall the grouped-median formula: Median $= L_1 + \left[\dfrac{n/2 - Cf_b}{F_m}\right] \times C$.',
      'Identify each symbol from the question: $L_1 = 20.5$ (lower boundary of the median class), $n = 50$, $Cf_b = 16$, $F_m = 9$, $C = 5$.',
      'Compute $n/2$: $50/2 = 25$.',
      'Subtract $Cf_b$ from $n/2$: $25 - 16 = 9$.',
      'Divide by $F_m$: $9 \div 9 = 1$.',
      'Multiply by the class width $C$: $1 \times 5 = 5$.',
      'Add this to $L_1$: Median $= 20.5 + 5$.',
      'Answer: median $= 25.5$.'
    ]),
    'A fast built-in check: the computed median must always fall within the median class''s own boundaries (here, between 20.5 and 25.5), if it falls outside that range, an arithmetic error was made.',
    'A school examination board estimating the median WAEC-style mock exam score across a whole SS1 cohort, grouped into mark ranges, uses exactly this interpolation formula rather than re-sorting every single script.',
    'none', '{}'::jsonb,
    'published'
  from lesson
  returning id
)
insert into public.worked_examples (lesson_id, title, problem_statement, solution_steps, exam_shortcut, real_life_context, diagram_type, diagram_data, status)
select id,
  'Estimating the Mode of Grouped Data',
  'The modal class is $26$-$30$ (boundaries $25.5$-$30.5$); the class before it has frequency 9, the modal class has frequency 13, the class after it has frequency 8; class width $C = 5$. Find the mode.',
  to_jsonb(array[
    'Recall the grouped-mode formula: Mode $= L_1 + \left[\dfrac{\Delta_1}{\Delta_1+\Delta_2}\right] \times C$.',
    'Identify $L_1$: the lower class boundary of the modal class $= 25.5$.',
    'Compute $\Delta_1$ (modal frequency minus the frequency of the class *before* it): $\Delta_1 = 13-9=4$.',
    'Compute $\Delta_2$ (modal frequency minus the frequency of the class *after* it): $\Delta_2 = 13-8=5$.',
    'Add $\Delta_1$ and $\Delta_2$: $4+5=9$.',
    'Divide $\Delta_1$ by this sum: $4 \div 9 \approx 0.444$.',
    'Multiply by the class width $C$: $0.444 \times 5 \approx 2.22$.',
    'Add this to $L_1$: Mode $= 25.5 + 2.22$.',
    'Answer: mode $\approx 27.72$.'
  ]),
  'Remember Δ₁ always compares the modal class to the class before it, and Δ₂ to the class after it, reversing them shifts the mode toward the wrong neighbouring class.',
  'A retailer analysing grouped daily sales figures to find the most typical (modal) sales bracket for restocking decisions uses exactly this grouped-mode formula.',
  'none', '{}'::jsonb,
  'published'
from we1;

insert into public.questions (topic_id, question_text, question_latex, option_a, option_b, option_c, option_d, option_e, correct_letter, difficulty, exam_type, explanation, exam_shortcut, status)
select topic_ref.tid, v.question_text, v.question_latex, v.option_a, v.option_b, v.option_c, v.option_d, v.option_e, v.correct_letter, v.difficulty, v.exam_type, v.explanation, v.exam_shortcut, 'published'
from (select t.id as tid from public.topics t join public.curricula c on c.id = t.curriculum_id
      where c.subject = 'Mathematics' and t.class_level = 'SS1' and t.term = 3 and t.order_index = 312) topic_ref,
lateral (values
  ('A group of families reports numbers of children in classes 1,2,3,4,5,6 with frequencies 10,15,8,6,4,7. Find the median (treating this as grouped/discrete class data).', null::text, '1', '2', '3', '4', null::text, 'B', 3, 'GENERAL'::exam_type, 'With Σf=50, the median position (25th/26th value) falls within the class "2" once cumulative frequencies are built up, giving a median of 2.', null::text),
  ('Daily wages (in ₦100s): 2,3,4,5,6,8,10 with frequencies 2,4,10,11,15,10,3. Find (a) total workers, (b) the median wage.', null, '(a) 50, (b) ₦500', '(a) 55, (b) ₦600', '(a) 55, (b) ₦500', '(a) 60, (b) ₦600', null, 'B', 4, 'GENERAL', 'Total workers $=2+4+10+11+15+10+3=55$; locating the median position in the cumulative frequency gives a median wage of ₦600 (in ₦100s, wage class 6).', null),
  ('Scores 1-6 have frequencies 2,5,x,11,9,10 (x unknown); the probability of scoring 3 is 0.26. Find x, then the median.', null, 'x = 12, median = 4', 'x = 13, median = 4', 'x = 13, median = 5', 'x = 14, median = 4', null, 'B', 4, 'GENERAL', 'Total frequency must satisfy $x/\Sigma f = 0.26$; solving gives $x=13$ (total 50), and the median position then falls in the class scoring 4.', null),
  ('State the formula for the median of grouped data, defining every symbol.', null, 'Median = L₁ + [(n/2 − Cfb)/Fm] × C, where L₁ = lower boundary of the median class, n = total frequency, Cfb = cumulative frequency before the median class, Fm = frequency of the median class, C = class width', 'Median = L₁ × [(n/2)/Fm] + C', 'Median = (L₁ + Fm)/2', 'Median = Cfb + (n/2)', null, 'A', 2, 'GENERAL', 'This is the standard grouped-median interpolation formula, with each symbol defined exactly as shown.', null),
  ('State the formula for the mode of grouped data, defining every symbol.', null, 'Mode = L₁ + [Δ₁/(Δ₁+Δ₂)] × C, where L₁ = lower boundary of the modal class, Δ₁ = modal frequency minus the class before it''s frequency, Δ₂ = modal frequency minus the class after it''s frequency, C = class width', 'Mode = L₁ − [Δ₁/(Δ₁+Δ₂)] × C', 'Mode = (Δ₁ + Δ₂)/C', 'Mode = L₁ + Δ₁ × Δ₂ × C', null, 'A', 2, 'GENERAL', 'This is the standard grouped-mode interpolation formula, with Δ₁ and Δ₂ defined exactly as shown, comparing the modal class to its two neighbours.', null),
  ('A frequency table has modal class 41-50 (boundaries 40.5-50.5), with the class before it having frequency 90, the modal class 110, and the class after it 70; class width 10. Find the mode.', null, '42.50', '43.83', '45.00', '46.67', null, 'B', 4, 'GENERAL', '$\Delta_1=110-90=20$, $\Delta_2=110-70=40$. Mode $=40.5+\frac{20}{20+40}\times10=40.5+3.33\approx43.83$.', null)
) as v(question_text, question_latex, option_a, option_b, option_c, option_d, option_e, correct_letter, difficulty, exam_type, explanation, exam_shortcut);

-- ==========================================
-- TOPIC 313: Statistical Graphs
-- Source: Third Term Week 11's graphing methods (bar chart, histogram,
-- pie chart, frequency polygon, cumulative frequency curve/ogive) and
-- the questions that specifically exercise reading/drawing a graph.
-- Questions: Week 11 Q1-23 (23) + Q46, moved here from topic 314 since
-- it is a histogram/mode-from-graph question rather than a mean-
-- deviation/variance question (24 total).
-- ==========================================

with lesson as (
  insert into public.lessons (topic_id, title, summary, content_body, order_index)
  values (
    (select t.id from public.topics t join public.curricula c on c.id = t.curriculum_id
     where c.subject = 'Mathematics' and t.class_level = 'SS1' and t.term = 3 and t.order_index = 313),
    'Statistical Graphs: Bar Charts, Pie Charts, Histograms and the Ogive',
    'Drawing and reading bar charts, pie charts, histograms, frequency polygons and cumulative frequency curves (ogives), and using an ogive to estimate the median and quartiles.',
    '## Bar Chart, Histogram, Frequency Polygon

**Bar chart:** used for discrete or qualitative data; bars have gaps, are of equal width, and can be rearranged.

**Histogram:** used for continuous, grouped data; bars must touch (no gaps); the x-axis is marked with class boundaries.

**Frequency polygon:** a line graph joining the midpoints of the tops of histogram bars, "grounded" by adding an imaginary zero-frequency class at each end so the shape closes.

## Pie Chart

A circle divided into sectors, each representing a proportion of the whole ($360^\circ$ total, or 100%):

$$\text{Angle of a sector} = \dfrac{\text{frequency of item}}{\text{total frequency}} \times 360^\circ$$

## Cumulative Frequency Curve (Ogive)

Plots the *upper class boundary* of each class against its *cumulative frequency*. Used to read off the median (the value at $\Sigma f/2$), quartiles, deciles, and percentiles directly from the curve.

- Lower quartile $Q_1 = \tfrac14$ of the cumulative frequency; upper quartile $Q_3 = \tfrac34$ of the cumulative frequency.
- Inter-quartile range $= Q_3 - Q_1$; semi-inter-quartile range $= (Q_3-Q_1)/2$.

**Key exam habits:** for pie charts, simplify each frequency-to-total fraction to lowest terms *before* multiplying by $360^\circ$, smaller numbers are faster to multiply mentally; always finish a pie-chart question by checking that all sector angles sum to exactly $360^\circ$, this single check catches almost every arithmetic slip; on an ogive, the median is always read at the $n/2$ mark on the cumulative-frequency axis, the lower quartile at $n/4$, and the upper quartile at $3n/4$.',
    1
  )
  returning id
),
we1 as (
  insert into public.worked_examples (lesson_id, title, problem_statement, solution_steps, exam_shortcut, real_life_context, diagram_type, diagram_data, status)
  select id,
    'Drawing a Pie Chart for a Class of Students',
    'An SS1 class of 80 students has 30 in Arts, 40 in Science, and 10 in Commercial. Find each sector''s angle for a pie chart.',
    to_jsonb(array[
      'Recall the pie-chart angle formula: angle $= \left(\dfrac{\text{frequency of item}}{\text{total frequency}}\right) \times 360^\circ$.',
      'Confirm the total: $30+40+10=80$ students, matching the given total. ✓',
      'Find the Arts angle: $(30/80) \times 360^\circ$.',
      'Simplify $30/80 = 3/8$ first: $(3/8) \times 360^\circ = 3 \times 45^\circ = 135^\circ$.',
      'Find the Science angle: $(40/80) \times 360^\circ$.',
      'Simplify $40/80=1/2$: $(1/2) \times 360^\circ = 180^\circ$.',
      'Find the Commercial angle: $(10/80) \times 360^\circ$.',
      'Simplify $10/80=1/8$: $(1/8) \times 360^\circ = 45^\circ$.',
      'Check that all sector angles add to exactly $360^\circ$: $135^\circ+180^\circ+45^\circ=360^\circ$. ✓',
      'Answer: Arts $=135^\circ$, Science $=180^\circ$, Commercial $=45^\circ$.'
    ]),
    'Simplify each frequency-to-total fraction to lowest terms before multiplying by 360°, and always finish by checking that all sector angles sum to exactly 360°, this single check catches almost every arithmetic slip.',
    'This is exactly the calculation a school administrator makes every year to show, on a single pie chart in the school''s annual report, how an SS1 cohort splits across the Arts, Science, and Commercial streams.',
    'pie_chart',
    '{"slices": [{"label": "Arts", "value": 30}, {"label": "Science", "value": 40}, {"label": "Commercial", "value": 10}]}'::jsonb,
    'published'
  from lesson
  returning id
)
insert into public.worked_examples (lesson_id, title, problem_statement, solution_steps, exam_shortcut, real_life_context, diagram_type, diagram_data, status)
select id,
  'Reading the Median from a Cumulative Frequency Curve',
  'A distribution has total frequency $n = 200$. Find the median position, and describe how to read the median mark from the ogive.',
  to_jsonb(array[
    'Recall that the median corresponds to the cumulative-frequency value at position $n/2$ on a cumulative frequency curve.',
    'Compute $n/2$: $200/2=100$.',
    'On the cumulative-frequency (vertical) axis, locate the value 100.',
    'Draw a horizontal line from 100 across until it meets the ogive curve.',
    'From that meeting point on the curve, draw a vertical line straight down to the marks (horizontal) axis.',
    'Read off the value where this vertical line meets the marks axis, this is the estimated median mark.',
    'Answer: median position $=$ 100th value; the median mark itself is read directly off the ogive at that cumulative-frequency height.'
  ]),
  'On an ogive, the median is always read at the n/2 mark on the cumulative-frequency axis, the lower quartile at n/4, and the upper quartile at 3n/4, memorising these three fractions answers several ogive sub-questions from a single drawn curve.',
  'A WAEC examination body uses exactly this ogive-reading method to estimate the median score and the pass-mark cutoff for the top 5% of candidates across an entire cohort''s results.',
  'none', '{}'::jsonb,
  'published'
from we1;

insert into public.questions (topic_id, question_text, question_latex, option_a, option_b, option_c, option_d, option_e, correct_letter, difficulty, exam_type, explanation, exam_shortcut, status)
select topic_ref.tid, v.question_text, v.question_latex, v.option_a, v.option_b, v.option_c, v.option_d, v.option_e, v.correct_letter, v.difficulty, v.exam_type, v.explanation, v.exam_shortcut, 'published'
from (select t.id as tid from public.topics t join public.curricula c on c.id = t.curriculum_id
      where c.subject = 'Mathematics' and t.class_level = 'SS1' and t.term = 3 and t.order_index = 313) topic_ref,
lateral (values
  ('Why do we use "grouped" frequency tables and histograms for large continuous datasets rather than plotting every value?', null::text, 'To organise many individual values into manageable class intervals, making patterns easier to see', 'Because a bar chart cannot show more than 10 values', 'Because histograms are only used for qualitative data', 'To avoid calculating the mean altogether', null::text, 'A', 1, 'GENERAL'::exam_type, 'Grouping and plotting as a histogram reveals the overall shape of a large continuous dataset far more clearly than a long unsorted list would.', null::text),
  ('What is the main physical difference between a bar chart and a histogram?', null, 'Bar chart bars have gaps; histogram bars touch', 'Bar charts are always drawn in colour', 'Histograms never have a y-axis label', 'There is no difference between them', null, 'A', 1, 'GENERAL', 'The defining visual difference is that bar chart bars are separated by gaps (distinct categories), while histogram bars touch (a continuous scale).', null),
  ('What type of data is a bar chart used for?', null, 'Continuous data only', 'Discrete or qualitative data', 'Only negative-valued data', 'Only data with exactly 4 categories', null, 'B', 1, 'GENERAL', 'A bar chart is the standard choice for discrete counts or qualitative categories.', null),
  ('What type of data is a histogram used for?', null, 'Discrete data only', 'Continuous, grouped data', 'Only qualitative data', 'Only data already in a pie chart', null, 'B', 1, 'GENERAL', 'A histogram suits continuous data organised into class intervals with touching bars.', null),
  ('What is plotted on the x-axis of a histogram?', null, 'Class boundaries', 'Tally marks', 'Cumulative frequency', 'Sector angles', null, 'A', 1, 'GENERAL', 'A histogram''s bars are positioned according to class boundaries along the x-axis.', null),
  ('For class interval 20-29, find (a) the class midpoint, (b) the class boundaries, as needed to draw a histogram.', null, '(a) 24.5, (b) 19.5-29.5', '(a) 25, (b) 20-29', '(a) 24, (b) 19-30', '(a) 24.5, (b) 20-29', null, 'A', 2, 'GENERAL', 'Midpoint $=(20+29)/2=24.5$; boundaries extend by 0.5 each way, giving 19.5-29.5.', null),
  ('If you have data for "number of children per family," would you use a bar chart or a histogram?', null, 'A histogram, because it is discrete data', 'A bar chart, because it is discrete, countable data', 'A pie chart is the only correct option', 'A frequency polygon only', null, 'B', 2, 'GENERAL', 'Number of children is discrete data, so a bar chart with gaps between bars is appropriate.', null),
  ('If you have data for "height of students," would you use a bar chart or a histogram?', null, 'A bar chart, because height is easy to measure', 'A histogram, because height is continuous, measured data', 'Neither, only a pie chart works', 'A bar chart, but only above 30 students', null, 'B', 2, 'GENERAL', 'Height is continuous data, so a histogram with touching bars over class boundaries is correct.', null),
  ('What is the main purpose of a pie chart?', null, 'To show how a total is divided into proportional parts', 'To compare two completely unrelated data sets', 'To display data over time', 'To calculate the mean of a distribution', null, 'A', 1, 'GENERAL', 'A pie chart''s sectors show each category''s proportional share of the whole total.', null),
  ('State the formula for the angle of a sector in a pie chart.', '$\text{angle} = ?$', '$\left(\dfrac{\text{frequency of item}}{\text{total frequency}}\right) \times 360^\circ$', '$\left(\dfrac{\text{total frequency}}{\text{frequency of item}}\right) \times 360^\circ$', '$\text{frequency of item} \times 100\%$', '$\dfrac{360^\circ}{\text{frequency of item}}$', null, 'A', 1, 'GENERAL', 'Each sector''s angle is its share of the total frequency, scaled up to the full circle''s 360°.', null),
  ('In an SS1 class of 80 students, 30 study Arts, 40 Science, 10 Commercial. Find the angle for the Science stream on a pie chart.', null, '90°', '135°', '180°', '225°', null, 'C', 2, 'GENERAL', '$(40/80)\times360^\circ = 180^\circ$.', null),
  ('A sector on a pie chart represents 20 people out of a total of 80. Find its angle.', null, '45°', '60°', '75°', '90°', null, 'D', 2, 'GENERAL', '$(20/80)\times360^\circ=90^\circ$.', null),
  ('A pie chart shows "Food" taking up 120° of a student''s monthly budget. What percentage of the budget is this?', null, '25%', '30%', '33⅓%', '40%', null, 'C', 2, 'GENERAL', '$(120/360)\times100\% = 33\tfrac13\%$.', null),
  ('What is plotted on the x-axis of a frequency polygon?', null, 'Class boundaries', 'Class midpoints', 'Cumulative frequencies', 'Tally counts', null, 'B', 1, 'GENERAL', 'A frequency polygon plots frequency against each class''s midpoint.', null),
  ('Why must a frequency polygon be "grounded" at zero frequency at both ends?', null, 'To make the chart look symmetrical', 'So it forms a closed shape (polygon) that starts and ends on the baseline, rather than an open line', 'Because the first and last classes always have zero frequency in real data', 'It is not actually necessary', null, 'B', 2, 'GENERAL', 'Adding an imaginary zero-frequency class at each end closes the shape into a true polygon rather than leaving it as an open-ended line.', null),
  ('What is the main advantage of a frequency polygon over a histogram?', null, 'It requires less data to draw', 'It more clearly shows the overall shape/trend of the distribution, and allows easy comparison of two datasets on one graph', 'It removes the need for class boundaries entirely', 'It can only be used for qualitative data', null, 'B', 2, 'GENERAL', 'A frequency polygon''s line makes the distribution''s overall trend easier to see, and multiple polygons can be overlaid on the same axes for direct comparison.', null),
  ('What does a cumulative frequency curve (ogive) plot?', null, 'Class midpoints against frequency', 'Upper class boundaries against cumulative frequency', 'Lower class boundaries against frequency', 'Tally marks against class width', null, 'B', 2, 'GENERAL', 'An ogive plots the running total (cumulative frequency) against each class''s upper boundary.', null),
  ('What can a cumulative frequency curve be used to estimate?', null, 'Only the mean', 'The median, quartiles, deciles, and percentiles', 'Only the range', 'Only the mode', null, 'B', 2, 'GENERAL', 'An ogive is specifically used to read off position-based statistics like the median, quartiles, deciles, and percentiles.', null),
  ('State the formula for the lower quartile Q1 and upper quartile Q3 using cumulative frequency n.', null, 'Q1 = n/2, Q3 = n', 'Q1 = n/4, Q3 = 3n/4', 'Q1 = n/3, Q3 = 2n/3', 'Q1 = n, Q3 = n/4', null, 'B', 2, 'GENERAL', 'The lower quartile sits at one quarter of the way through the cumulative frequency; the upper quartile at three quarters.', null),
  ('A table shows marks for 200 candidates; use the ogive to estimate the interquartile range, given Q1 ≈ 60.5 and Q3 ≈ 84.5.', null, '20', '22', '24', '26', null, 'C', 3, 'GENERAL', 'Interquartile range $=Q_3-Q_1=84.5-60.5=24$.', null),
  ('From an ogive for 80 students, the median mark is read as 45.5 and the lower quartile as 31.5. What is Q1, restated directly?', null, '31.5', '38.5', '45.5', '52.5', null, 'A', 2, 'GENERAL', 'Q1 is simply read directly off the ogive at the n/4 cumulative-frequency mark, here given as 31.5.', null),
  ('From an ogive for 80 students, 77 students scored 75% or above. What is the probability that a randomly picked student scored 75% or above?', null, '3/80', '75/80', '77/80', '80/80', null, 'C', 2, 'GENERAL', 'Probability $=$ (number meeting the condition)/(total students) $=77/80$.', null),
  ('For 200 candidates, the ogive shows that 70 candidates scored at most 45%. Find the probability that a randomly picked candidate scored at most 45%.', null, '3/20', '7/20', '9/20', '11/20', null, 'B', 3, 'GENERAL', 'Probability $=70/200=7/20$.', null),
  ('A histogram is drawn for marks 1-5, 6-10, ..., 21-25 with frequencies 4, 6, 11, 8, 1. Which is the modal class, and what is the probability a randomly selected student scored at most 15 marks?', null, 'Modal class 6-10, probability 1/3', 'Modal class 11-15, probability 7/10', 'Modal class 16-20, probability 4/5', 'Modal class 11-15, probability 1/2', null, 'B', 3, 'GENERAL', 'The highest bar (frequency 11) is class 11-15, the modal class; probability of at most 15 marks $=(4+6+11)/30=21/30=7/10$.', null)
) as v(question_text, question_latex, option_a, option_b, option_c, option_d, option_e, correct_letter, difficulty, exam_type, explanation, exam_shortcut);

-- ==========================================
-- TOPIC 314: Mean Deviation, Variance & Standard Deviation
-- Source: the dispersion half of Third Term Week 11 (mean deviation,
-- variance, standard deviation, both raw and grouped/shortcut
-- formulas). Questions: Week 11 Q24-45, 47, 48 (24 total; Q46 was
-- moved to topic 313 as a histogram/mode-reading question).
-- ==========================================

with lesson as (
  insert into public.lessons (topic_id, title, summary, content_body, order_index)
  values (
    (select t.id from public.topics t join public.curricula c on c.id = t.curriculum_id
     where c.subject = 'Mathematics' and t.class_level = 'SS1' and t.term = 3 and t.order_index = 314),
    'Mean Deviation, Variance and Standard Deviation',
    'Measuring how spread out a data set is around its mean, using mean deviation, variance and standard deviation, for both raw and grouped data.',
    '## Range

**Range:** largest value minus smallest value (the simplest, but weakest, measure of spread, since it only uses two extreme values).

## Mean Deviation

The average absolute distance of each value from the mean:

$$\text{M.D.} = \dfrac{\Sigma |x - \bar{x}|}{n} \text{ (ungrouped)}; \qquad \text{M.D.} = \dfrac{\Sigma f|x-\bar{x}|}{\Sigma f} \text{ (grouped/frequency distribution)}$$

## Variance and Standard Deviation

These measure how spread out the data is around the mean:

$$\text{Variance } V = \dfrac{\Sigma (x-\bar{x})^2}{n} \text{ (ungrouped)}; \qquad V = \dfrac{\Sigma f(x-\bar{x})^2}{\Sigma f} \text{ (grouped)}$$

$$\text{Standard deviation S.D.} = \sqrt{\text{Variance}}$$

A useful computational shortcut for grouped data: $\text{S.D.} = \sqrt{\dfrac{\Sigma fx^2}{\Sigma f} - \left(\dfrac{\Sigma fx}{\Sigma f}\right)^2}$

**Key exam habits:** for variance/S.D., always compute the mean first, freeze it, then build a simple table with columns $x$, $(x-\bar{x})$, $(x-\bar{x})^2$, laying out a table (rather than working "in your head") is what prevents sign errors from the negative deviations; variance and standard deviation are always non-negative, and S.D. $= \sqrt{\text{Variance}}$, so if you are given the variance, taking the square root is a one-line answer; for grouped standard deviation, the shortcut formula avoids computing every individual $(x-\bar{x})^2$ by hand, build an $fx^2$ column alongside the usual $fx$ column from the start, since both $\Sigma fx$ (for the mean) and $\Sigma fx^2$ (for the shortcut) are needed anyway.',
    1
  )
  returning id
),
we1 as (
  insert into public.worked_examples (lesson_id, title, problem_statement, solution_steps, exam_shortcut, real_life_context, diagram_type, diagram_data, status)
  select id,
    'Finding the Variance and Standard Deviation of Raw Data',
    'Find the variance and standard deviation of $2, 5, 6, 3, 4$.',
    to_jsonb(array[
      'Find the mean: $\bar{x} = (2+5+6+3+4)/5 = 20/5 = 4$.',
      'Find each deviation from the mean ($x - \bar{x}$): $2-4=-2$; $5-4=1$; $6-4=2$; $3-4=-1$; $4-4=0$.',
      'Square each deviation (this removes the negative signs, which is why variance is always non-negative): $(-2)^2=4$; $(1)^2=1$; $(2)^2=4$; $(-1)^2=1$; $(0)^2=0$.',
      'Sum the squared deviations: $4+1+4+1+0=10$.',
      'Divide by $n$ to get the variance: Variance $=10/5=2$.',
      'Take the square root of the variance to get the standard deviation: S.D. $=\sqrt{2}$.',
      'Evaluate: $\sqrt{2} \approx 1.4$ (2 s.f.).',
      'Answer: Variance $=2$; Standard deviation $\approx 1.4$.'
    ]),
    'Variance and standard deviation are always non-negative, and S.D. = √Variance, so if you are ever given the variance directly, taking the square root is a one-line answer with no need to redo the whole calculation from raw data.',
    'A quality-control officer at a Nigerian bottling plant checking how consistently a machine fills bottles, by finding the standard deviation of five sampled fill volumes, uses exactly this calculation.',
    'none', '{}'::jsonb,
    'published'
  from lesson
  returning id
),
we2 as (
  insert into public.worked_examples (lesson_id, title, problem_statement, solution_steps, exam_shortcut, real_life_context, diagram_type, diagram_data, status)
  select id,
    'Finding the Mean Deviation of Raw Data',
    'Find the mean deviation of $2, 4, 6, 5, 3$.',
    to_jsonb(array[
      'Find the mean: $\bar{x} = (2+4+6+5+3)/5 = 20/5 = 4$.',
      'Find each deviation from the mean, then take its absolute value (ignore the sign): $|2-4|=2$; $|4-4|=0$; $|6-4|=2$; $|5-4|=1$; $|3-4|=1$.',
      'Sum the absolute deviations: $2+0+2+1+1=6$.',
      'Divide by $n$: M.D. $=6/5$.',
      'Evaluate: $6 \div 5 = 1.2$.',
      'Answer: mean deviation $=1.2$.'
    ]),
    'For variance/S.D. or mean deviation questions alike, always compute the mean first and freeze it before building the deviation table, this prevents having to redo every row if a mistake is found partway through.',
    'A market trader averaging how far each of five days'' sales figures typically strays from the week''s mean sale, to judge how predictable her income is, uses exactly this mean-deviation calculation.',
    'none', '{}'::jsonb,
    'published'
  from lesson
  returning id
)
insert into public.worked_examples (lesson_id, title, problem_statement, solution_steps, exam_shortcut, real_life_context, diagram_type, diagram_data, status)
select id,
  'Mean, Mean Deviation and Standard Deviation of Grouped Exam Marks',
  'For marks $51$-$60$, $61$-$70$, $71$-$80$, $81$-$90$, $91$-$100$ with frequencies $11, 23, 39, 17, 10$ ($\Sigma f = 100$), find the mean, mean deviation, and standard deviation.',
  to_jsonb(array[
    'Find the midpoint (class mark) of each class interval: $51$-$60 \to 55.5$; $61$-$70 \to 65.5$; $71$-$80 \to 75.5$; $81$-$90 \to 85.5$; $91$-$100 \to 95.5$.',
    'Multiply each midpoint by its frequency (fx): $55.5\times11=610.5$; $65.5\times23=1506.5$; $75.5\times39=2944.5$; $85.5\times17=1453.5$; $95.5\times10=955$.',
    'Sum the fx column: $610.5+1506.5+2944.5+1453.5+955=7470$.',
    'Divide by $\Sigma f=100$ to get the mean: mean $=7470/100=74.7$.',
    'For the mean deviation, find $|x-\bar{x}|$ for each midpoint ($\bar{x}=74.7$): $|55.5-74.7|=19.2$; $|65.5-74.7|=9.2$; $|75.5-74.7|=0.8$; $|85.5-74.7|=10.8$; $|95.5-74.7|=20.8$.',
    'Multiply each by its frequency ($f|x-\bar{x}|$): $19.2\times11=211.2$; $9.2\times23=211.6$; $0.8\times39=31.2$; $10.8\times17=183.6$; $20.8\times10=208$.',
    'Sum this column: $211.2+211.6+31.2+183.6+208=845.6$.',
    'Divide by $\Sigma f=100$: M.D. $=845.6/100=8.456 \approx 8$ (nearest whole number).',
    'For the standard deviation, use the shortcut formula S.D. $=\sqrt{\Sigma fx^2/\Sigma f - (\Sigma fx/\Sigma f)^2}$; find $fx^2$ for each class: $610.5\times55.5\approx33\,882.75$; $1506.5\times65.5\approx98\,675.75$; $2944.5\times75.5\approx222\,309.75$; $1453.5\times85.5\approx124\,274.25$; $955\times95.5\approx91\,202.5$.',
    'Sum $\Sigma fx^2$: $33\,882.75+98\,675.75+222\,309.75+124\,274.25+91\,202.5=570\,345$. Divide by $\Sigma f$: $570\,345/100=5703.45$.',
    'Subtract the mean squared: $(74.7)^2=5580.09$; $5703.45-5580.09=123.36$. Take the square root: $\sqrt{123.36}\approx11.11 \approx 11$ (nearest whole number).',
    'Answer: mean $=74.7$ ($\approx75$ to the nearest whole number); mean deviation $\approx8$; standard deviation $\approx11$.'
  ]),
  'Build the fx² column alongside the usual fx column from the very start of the table, since both Σfx (needed for the mean) and Σfx² (needed for the standard-deviation shortcut) are required anyway, doing them together saves re-scanning the whole table twice.',
  'A WAEC-style examination analysis of a whole cohort''s grouped exam marks, reporting the mean, mean deviation and standard deviation together, uses exactly this three-column table method to summarise the spread of performance in one report.',
  'bar_chart',
  '{"categories": ["51-60", "61-70", "71-80", "81-90", "91-100"], "values": [11, 23, 39, 17, 10], "yLabel": "Number of Students"}'::jsonb,
  'published'
from we1;

insert into public.questions (topic_id, question_text, question_latex, option_a, option_b, option_c, option_d, option_e, correct_letter, difficulty, exam_type, explanation, exam_shortcut, status)
select topic_ref.tid, v.question_text, v.question_latex, v.option_a, v.option_b, v.option_c, v.option_d, v.option_e, v.correct_letter, v.difficulty, v.exam_type, v.explanation, v.exam_shortcut, 'published'
from (select t.id as tid from public.topics t join public.curricula c on c.id = t.curriculum_id
      where c.subject = 'Mathematics' and t.class_level = 'SS1' and t.term = 3 and t.order_index = 314) topic_ref,
lateral (values
  ('Define range, and state its main weakness as a measure of spread.', null::text, 'Range = largest minus smallest value; its weakness is that it only uses two extreme values, ignoring the rest of the data', 'Range = mean of the largest and smallest values; it ignores the middle values', 'Range = sum of all values divided by n; it is affected by every value equally', 'Range = the most frequent value; it can have more than one answer', null::text, 'A', 1, 'GENERAL'::exam_type, 'Range is simply the largest value minus the smallest, which makes it very easy to compute but blind to everything happening between those two extremes.', null::text),
  ('Find the mean deviation of 2, 4, 6, 5, 3.', null, '1.0', '1.2', '1.4', '1.6', null, 'B', 2, 'GENERAL', 'Mean $=4$; absolute deviations sum to 6; M.D. $=6/5=1.2$.', null),
  ('Calculate the mean deviation of 0, −1, −3, 4, 5, 1.', null, '2', '7/3', '5/2', '3', null, 'B', 3, 'GENERAL', 'Mean $=6/6=1$; absolute deviations sum to $1+2+4+3+4+0=14$; M.D. $=14/6=7/3$.', null),
  ('Find the mean deviation of 20, 25, 21, 27, 28, 29, to the nearest whole number.', null, '2', '3', '4', '5', null, 'B', 3, 'GENERAL', 'Mean $=150/6=25$; absolute deviations sum to 18; M.D. $=18/6=3$.', null),
  ('Calculate the mean deviation of 6, 7, 8, 9, 10.', null, '1.0', '1.2', '1.4', '1.6', null, 'B', 2, 'GENERAL', 'Mean $=8$; absolute deviations sum to 6; M.D. $=6/5=1.2$.', null),
  ('Find the mean deviation of 2, 3, 5, 6.', null, '1.0', '1.5', '2.0', '2.5', null, 'B', 2, 'GENERAL', 'Mean $=16/4=4$; absolute deviations sum to 6; M.D. $=6/4=1.5$.', null),
  ('A die is thrown 50 times; scores 1-6 have frequencies 2, 5, 13, 11, 9, 10. Calculate the mean deviation, to 2 d.p.', null, '1.06', '1.16', '1.26', '1.36', null, 'B', 4, 'GENERAL', 'Computing Σf|x−x̄|/Σf across all six scores gives a mean deviation of approximately 1.16.', null),
  ('State the formula for the variance of a set of n raw numbers.', '$V = ?$', '$V = \Sigma(x-\bar{x})/n$', '$V = \Sigma(x-\bar{x})^2/n$', '$V = \Sigma x^2/n$', '$V = \Sigma|x-\bar{x}|/n$', null, 'B', 1, 'GENERAL', 'Variance is the mean of the squared deviations from the mean: $\Sigma(x-\bar{x})^2/n$.', null),
  ('State the formula for standard deviation.', '$\text{S.D.} = ?$', '$\text{S.D.} = \text{Variance}^2$', '$\text{S.D.} = \sqrt{\text{Variance}}$', '$\text{S.D.} = \text{Variance}/n$', '$\text{S.D.} = 2 \times \text{Variance}$', null, 'B', 1, 'GENERAL', 'Standard deviation is defined as the square root of the variance.', null),
  ('If the variance of a distribution is 25, find the standard deviation.', null, '4', '5', '6', '25', null, 'B', 1, 'GENERAL', 'S.D. $=\sqrt{25}=5$.', null),
  ('Find the variance and standard deviation of 2, 5, 6, 3, 4.', null, 'Variance = 1, S.D. ≈ 1.0', 'Variance = 2, S.D. ≈ 1.4', 'Variance = 3, S.D. ≈ 1.7', 'Variance = 4, S.D. = 2.0', null, 'B', 3, 'GENERAL', 'Mean $=4$; squared deviations sum to 10; variance $=10/5=2$; S.D. $=\sqrt{2}\approx1.4$.', null),
  ('Calculate the variance of 5, 11, 13, 14, 17.', null, '14.0', '15.0', '16.0', '17.0', null, 'C', 3, 'GENERAL', 'Mean $=60/5=12$; squared deviations sum to 80; variance $=80/5=16.0$.', null),
  ('Given that the mean of 15, 21, 17, 26, 18, 29 is 21, find the standard deviation.', null, '4', '5', '6', '7', null, 'B', 3, 'GENERAL', 'Squared deviations from the mean 21 sum to 150; variance $=150/6=25$; S.D. $=\sqrt{25}=5$.', null),
  ('Find the standard deviation of 6, 0, 4, 3, 2.', null, '1', '2', '3', '4', null, 'B', 3, 'GENERAL', 'Mean $=15/5=3$; squared deviations sum to 20; variance $=20/5=4$; S.D. $=\sqrt4=2$.', null),
  ('Calculate the standard deviation of 2, 3, 4, 4, 5, 6, to 2 d.p.', null, '1.09', '1.19', '1.29', '1.39', null, 'C', 3, 'GENERAL', 'Mean $=4$; squared deviations sum to 10; variance $=10/6\approx1.67$; S.D. $\approx1.29$.', null),
  ('A distribution has x = 1,2,3,4,5 with f = 2,1,2,1,2. Find the variance and standard deviation.', null, 'Variance = 2.00, S.D. = 1.41', 'Variance = 2.25, S.D. = 1.50', 'Variance = 2.50, S.D. = 1.58', 'Variance = 2.75, S.D. = 1.66', null, 'B', 4, 'GENERAL', 'Mean $=3$; computing Σf(x−x̄)²/Σf gives variance 2.25; S.D. $=\sqrt{2.25}=1.5$.', null),
  ('For scores 1-6 with frequencies 2,5,x,11,9,10 and the probability of a 3 being 0.26, find (a) x, (b) the standard deviation (approx).', null, '(a) x=12, (b) S.D.≈1.41', '(a) x=13, (b) S.D.≈1.51', '(a) x=14, (b) S.D.≈1.61', '(a) x=13, (b) S.D.≈1.31', null, 'B', 5, 'GENERAL', 'x=13 satisfies the total-frequency/probability condition; computing Σf(x−x̄)²/Σf with mean 4 gives S.D.≈1.51.', null),
  ('A table (marks 51-60,...,91-100 with frequencies 11,23,39,17,10, total 100 students) is analysed. Find (i) the mean mark, (ii) the mean deviation, (iii) the standard deviation, all to the nearest whole number.', null, '(i) 70, (ii) 7, (iii) 10', '(i) 75, (ii) 8, (iii) 11', '(i) 80, (ii) 9, (iii) 12', '(i) 75, (ii) 10, (iii) 13', null, 'B', 4, 'GENERAL', 'Following the full grouped table method gives mean 74.7≈75, mean deviation 8.456≈8, and standard deviation ≈11.', null),
  ('State the shortcut formula for the standard deviation of grouped data using Σfx² and Σfx.', '$\text{S.D.} = ?$', '$\sqrt{\Sigma fx^2/\Sigma f - (\Sigma fx/\Sigma f)^2}$', '$\Sigma fx^2/\Sigma f + (\Sigma fx/\Sigma f)^2$', '$\sqrt{\Sigma fx/\Sigma f}$', '$(\Sigma fx^2/\Sigma f)^2$', null, 'A', 2, 'GENERAL', 'This shortcut formula avoids computing every individual (x−x̄)² by hand, using only the Σfx and Σfx² totals already needed for the mean.', null),
  ('What is the mean deviation of a grouped frequency distribution, in formula terms?', '$\text{M.D.} = ?$', '$\Sigma|x-\bar{x}|/n$', '$\Sigma f|x-\bar{x}|/\Sigma f$', '$\Sigma fx/\Sigma f$', '$\Sigma(x-\bar{x})^2/\Sigma f$', null, 'B', 1, 'GENERAL', 'The grouped mean deviation formula weights each absolute deviation by its class frequency before averaging: $\Sigma f|x-\bar{x}|/\Sigma f$.', null),
  ('If the mean and median of the five numbers 170, 230, y, 215, 235 are 210 and x respectively, find x and y.', null, 'x = 210, y = 195', 'x = 215, y = 200', 'x = 220, y = 205', 'x = 215, y = 210', null, 'B', 4, 'GENERAL', 'Mean condition: $170+230+y+215+235=210\times5=1050 \Rightarrow y=200$. Sorting 170,200,215,230,235 gives median (the middle value) $x=215$.', null),
  ('The mean height of 100 students (grouped, 1.40-1.63 m) is found via the assumed-mean method. Which columns must be prepared to compute both the mean and the mean deviation?', null, 'Only x (midpoint) and f', 'x (midpoint), f, fx or fd, |x−x̄|, and f|x−x̄|', 'Only cumulative frequency', 'Only the class boundaries', null, 'B', 2, 'GENERAL', 'Both the mean (via fx or fd) and the mean deviation (via |x−x̄| and f|x−x̄|) need their own dedicated columns built alongside the basic midpoint and frequency columns.', null),
  ('Why is standard deviation generally preferred over mean deviation as a measure of spread in advanced statistics?', null, 'Because it is always a smaller number', 'Because squaring removes the need for absolute values and gives more mathematical weight to larger deviations, and it connects directly to variance used in further statistical theory', 'Because it does not require finding the mean first', 'Because it can be calculated without any data', null, 'B', 3, 'GENERAL', 'Squaring avoids the awkward absolute-value operation, penalises large deviations more heavily, and standard deviation feeds directly into more advanced statistical tools built on variance.', null),
  ('A factory records the wages of 50 workers, grouped into class intervals 21-30, 31-40, etc. Outline the correct first step to draw the cumulative frequency curve and find the median and inter-quartile range.', null, 'Plot the raw wages directly without grouping', 'Construct the cumulative frequency table using upper class boundaries, then plot boundary vs. cumulative frequency and draw a smooth curve', 'Skip straight to computing the mean only', 'Draw a pie chart instead of an ogive', null, 'B', 2, 'GENERAL', 'An ogive requires a cumulative frequency table built from upper class boundaries first, which is then plotted and smoothly curved before the median or quartiles can be read off.', null)
) as v(question_text, question_latex, option_a, option_b, option_c, option_d, option_e, correct_letter, difficulty, exam_type, explanation, exam_shortcut);

-- ==========================================
-- END OF FILE
-- All 14 Third Term SS1 Mathematics topics (order_index 301-314) have
-- now been seeded with one lesson, worked examples, and questions each.
-- ==========================================
