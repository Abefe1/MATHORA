-- ==========================================
-- MATHORA  -  SS3 Mathematics, First Term: Real Lesson Content Seed
-- Nine topics (order_index 101-109), each with one lesson, 3 worked
-- examples, and every question from that week's Gamified Exercise Bank
-- in SS1-SS3_MATHEMATICS_CURATED.md's "SS3 Mathematics > First Term"
-- section. The curated file's First Term runs Weeks 1-12:
--   Week 1  -> topic 101 (Revision: Indices and Logarithm)
--   Week 2  -> topic 102 (Surds)
--   Week 3  -> topic 103 (Surds in Relation to Trigonometry)
--   Week 4  -> topic 104 (Matrices and Determinants)
--   Week 5  -> topic 105 (Linear and Quadratic Equations)
--   Week 6  -> topic 106 (Surface Area & Volume of Sphere and
--     Hemispherical Shapes)
--   Week 7  -> SKIPPED: explicitly a "Mid-Term Test" administrative
--     week, no new teaching content, and the Gamified Exercise Bank is
--     explicitly empty ("No dedicated exercises in the source material
--     for this administrative week - practice by re-attempting the
--     exercise banks of Weeks 1-6"), so it has no dedicated topic row.
--   Week 8  -> topic 107 (Longitude and Latitude)
--   Week 9  -> topic 108 (Longitude and Latitude (Continued))
--   Week 10 -> topic 109 (Arithmetic of Finance)
--   Week 11 -> SKIPPED: explicitly a "Revision" week, comprehensive
--     review of Weeks 1-10 with no new teaching content and an empty
--     Gamified Exercise Bank ("Use a mixed drill drawn from Weeks 1-10
--     above; no additional distinct exercises found in the source
--     material"), so it has no dedicated topic row.
--   Week 12 -> SKIPPED: explicitly the "Examination" week itself, no
--     new content and an empty Gamified Exercise Bank ("No dedicated
--     exercises in the source material - this week is the formal
--     examination itself"), so it has no dedicated topic row.
--
-- Run after (in this order):
--   mathora_schema.sql
--   mathora_schema_auth_patch.sql
--   mathora_schema_topics_term_patch.sql
--   mathora_schema_content_pipeline_patch.sql
--   mathora_schema_diagrams_patch.sql
--   mathora_schema_five_option_patch.sql (adds questions.option_e and
--     widens the correct_letter check to allow 'E')
--   mathora_seed_topics_ss1_ss2_ss3.sql (creates the topic rows this
--     file's subqueries look up by curriculum_id + class_level + term
--     + order_index  -  this file inserts NO topic rows of its own)
--   mathora_seed_ss3_term1_content.sql (this file)
--
-- Pattern (matches mathora_seed_exemplar_lessons.sql and the SS1/SS2
-- seed files): one `with lesson as (insert into lessons ... returning
-- id) insert into worked_examples ... select ... from lesson` block
-- creates the lesson and its first worked example together; additional
-- worked examples for the same topic look the lesson back up by
-- topic_id (the CTE only lives for one statement); questions are
-- inserted in one batch per topic via `cross join (values (...), ...)
-- as v(...)`, joined to both the topic and its lesson so
-- questions.lesson_id is populated.
--
-- Diagram usage: topic 103 (Surds in Relation to Trigonometry) uses
-- diagram_type='triangle' on its special-angle worked examples (the
-- 45-45-90 and 30-60-90 reference triangles are genuine geometric
-- figures, not forced). Topic 105 (Linear and Quadratic Equations)
-- uses diagram_type='coordinate_plane' on its line-meets-parabola
-- worked example, since that is a real graphable intersection. Topics
-- 107 and 108 (Longitude and Latitude) use diagram_type='circle' on
-- worked examples that show two points on the meridian/globe
-- cross-section, since a circle is a reasonable stand-in for a
-- great-circle cross-section with labelled points. There is no sphere
-- diagram type in mathora-web/src/lib/diagramTypes.ts, so topic 106
-- (Sphere & Hemisphere mensuration) is left at diagram_type='none'
-- rather than forcing an unsupported shape. Topics 101, 102, 104, and
-- 109 (logarithms/indices, surds, matrices, arithmetic of finance) are
-- pure algebra/arithmetic with no natural geometric figure and are
-- also left at 'none'/'{}'.
--
-- exam_type is 'GENERAL' throughout: as with the SS2 Term 1 file, the
-- curated source's "(WAEC-style)" labels describe the teaching style of
-- individual worked examples, not a source attribution marking any
-- Gamified Exercise Bank item as a genuine, verbatim past WAEC/NECO/
-- NABTEB paper question, so the safe GENERAL default applies file-wide.
--
-- Every stated answer below was re-derived by hand against the curated
-- source before being written into this file. The curated SS3 Term 1
-- material has noticeably more transcription/arithmetic slips than the
-- SS2 Term 1 material did; the substantial ones found and fixed here
-- (minor sub-1%-rounding differences are not listed; this file simply
-- uses the more precise recomputed figure in those cases) are:
--   1. Topic 101 (Logs) Q6: "log2(x) + log2(x+6) = 3" has no clean
--      solution (x = 2 gives log2(2)+log2(8) = 4, not 3). The equation's
--      right-hand side is corrected to 4, which reproduces the source's
--      stated answer x = 2 exactly.
--   2. Topic 102 (Surds) Q6: source flagged this as "limited source
--      material - practice extension" with no answer. Direct
--      simplification gives (4 sqrt12 + 3 sqrt3)/sqrt3 = 11 exactly,
--      supplied here as the verified answer.
--   3. Topic 102 Q10: the stem ("2 sqrt3 - sqrt6/3 + sqrt3/27...
--      rationalize the surds 2 sqrt3, sqrt(6/3), 3 sqrt(1/27)") is
--      garbled/uninterpretable in the source. Replaced with a clean,
--      well-posed surd-simplification question testing the identical
--      skill and reproducing the source's target answer sqrt3/3
--      exactly: "Simplify sqrt3 - (2 sqrt3)/3."
--   4. Topic 102 Q17: as literally written, "1/(sqrt11-sqrt2) -
--      1/(sqrt11+sqrt2)" evaluates to 2 sqrt2 / 9, not the source's
--      stated 4/7. Changing the second surd from sqrt2 to the integer 2
--      (i.e. "1/(sqrt11-2) - 1/(sqrt11+2)") reproduces 4/7 exactly, and
--      is used here as the corrected question.
--   5. Topic 103 (Surds & Trig) Q11: the source's own shown working
--      ("2(sqrt3/2)(sqrt3/2) - 1 = 3/2 - 1 = 1/2") computes 1/2, but the
--      stated final answer is mislabelled 1/4. Corrected to 1/2.
--   6. Topic 103 Q24: "(sin60-sin30)/(cos30-cos60)" is claimed to prove
--      the ratio equals sqrt3, but direct computation gives
--      (sqrt3-1)/2 divided by (sqrt3-1)/2 = 1, not sqrt3. Corrected to 1.
--   7. Topic 104 (Matrices) Q6: the determinant of
--      [[1,2,3],[0,4,5],[1,2,1]] is -8 by cofactor expansion (and by
--      row-reduction to upper-triangular form), not 0 as stated.
--      Corrected to -8.
--   8. Topic 104 Q15: the inverse of [[5,3],[2,1]] is [[-1,3],[2,-5]]
--      (verified by matrix-multiplying it against the original to
--      confirm the identity matrix), not [[1,-3],[-2,5]] as stated,
--      which omits the required division by the determinant (-1).
--   9. Topic 104 Q17(b) and (c): the stated clean answers (1,2) and
--      (3,1) do not solve the equations exactly as transcribed
--      ("x+3y=5, 2x+y=4" gives (1.4,1.2); "4x-y=10, x+2y=5" gives no
--      integer solution). Changing one constant in each pair
--      ("x+3y=7" and "4x-y=11" respectively) reproduces the stated
--      clean answers exactly.
--  10. Topic 104 Q20: as transcribed, the system
--      [[5,-6],[2,-7]]*[x;y]=[-11;-7] gives y = 13/23, not the stated
--      y=3. Changing the first target value from -11 to 17 (keeping
--      -7 unchanged) reproduces y=3 (with x=7) exactly.
--  11. Topic 104 Q21, Q22, Q23, Q25: these four exercise items are
--      internally inconsistent / garbled as transcribed (the stated
--      matrices do not multiply or equate to give the stated answers
--      under any reasonable reading). Each has been replaced with a
--      clean, well-posed matrix problem that reproduces the source's
--      stated final answer exactly (k=-3; x=2,y=4; p=4,q=2; x=5).
--  12. Topic 104 Q24: the determinant equation 2x+4=-6 gives x=-5, not
--      x=-2 as stated. Corrected to x=-5.
--  13. Topic 104 Q27: the source's option list was incomplete/garbled.
--      Rebuilt as a full 4-option question with [[3,8],[6,16]]
--      (determinant 0) as the singular matrix, matching the sample
--      answer the source itself proposed.
--  14. Topic 104 Q28: the determinant of [[5,-3],[-2,2]] is
--      5(2)-(-3)(-2)=10-6=4, not -4 as stated. Corrected to 4.
--  15. Topic 104 Q30: |-5P+6I| for P=[[2,3],[0,1]] works out to -4 by
--      direct computation, not 36 as stated. Corrected to -4.
--  16. Topic 105 (Linear/Quadratic) Q31: as transcribed with
--      "y = -(1/2)(x^2-3)", neither stated solution point satisfies the
--      equation; with the sign flipped to "y = (1/2)(x^2-3)" both
--      stated points, (3,3) and (-5,11), satisfy the system exactly.
--      Corrected the sign.
--  17. Topic 106 (Sphere/Hemisphere) Q7: the volume of material in a
--      hollow sphere (external radius 12cm, internal radius 9cm) is
--      (4/3)*pi*(12^3-9^3) = 1332*pi ~ 4186 cubic cm by direct
--      computation, not ~5115.8 as stated. Corrected to ~4186 cm^3.
--  18. Topic 106 Q16: a hemispherical bowl's shell volume uses
--      (2/3)*pi*(R^3-r^3); with R=13cm, r=12cm this gives ~982.7 cm^3,
--      not ~1985.1 cm^3 as stated (which is almost exactly double the
--      correct value, consistent with an accidental use of the full-
--      sphere (4/3)*pi factor instead of the hemisphere (2/3)*pi
--      factor). Corrected to ~982.7 cm^3.
--  19. Topic 106 Q20: for the stated solid (radius 3.5cm, cylindrical
--      part 13cm, hemispherical ends), the total surface area is
--      curved-cylinder (2*pi*r*h=286) + one-sphere-equivalent curved
--      surface (4*pi*r^2=154) = 440 cm^2, not 594 cm^2 as stated (594
--      is exactly 440 plus a second, duplicated 154, consistent with
--      double-counting the sphere surface). Volume corrected similarly
--      from ~686.83 to ~680.2 cm^3 by direct computation.
--  20. Topic 106 Q21: the volume of metal in a hemispherical bowl
--      (external radius 7.5cm, internal radius 7cm) is
--      (2/3)*pi*(7.5^3-7^3) ~ 165.3 cm^3 by direct computation, not
--      ~161.5 cm^3 as stated; the downstream cost (~N8,265) and 40%-
--      profit selling price (~N11,571) are recalculated accordingly.
--  21. Topic 107 (Longitude/Latitude) Q33: the meridian distance
--      between two points 108 degrees apart (R=6400km) is
--      (108/360)*2*pi*R ~ 12,068.6 km by direct computation, not 3840
--      km as stated (3840 = R*108/180 exactly, consistent with omitting
--      the pi factor when converting degrees to an arc length).
--      Corrected to ~12,068.6 km.
--  22. Topic 109 (Arithmetic of Finance) Q2: the compound interest on
--      N40,000 for 3 years at 8% p.a. is 40000*(1.08^3 - 1) = N10,388.48
--      by direct computation, not ~N10,398.85 as stated. Corrected.
-- A handful of exercise items left symbolic/unresolved in the source
-- (e.g. Topic 107/108 items that say "computed via 2*pi*R*cos(phi)
-- formula" without stating the final number, and Topic 109's loan-
-- amortisation items that say "use amortization formula") have been
-- completed here with a directly computed numeric answer rather than
-- flagged as errors, since the source's method was correct, only the
-- final arithmetic was left undone.
--
-- Every worked_examples/questions row has status = 'published'.
-- ==========================================


-- ------------------------------------------
-- 101. REVISION: INDICES AND LOGARITHM  -  SS3 Mathematics, Term 1
-- ------------------------------------------


with lesson as (
  insert into public.lessons (topic_id, title, summary, content_body, order_index)
  values (
    (select t.id from public.topics t join public.curricula c on c.id = t.curriculum_id where c.subject = 'Mathematics' and t.class_level = 'SS3' and t.term = 1 and t.order_index = 101),
    'Revision: Laws of Indices and Logarithms',
    'Revising the laws of indices (including negative and fractional powers) and the laws of logarithms, and solving equations that combine both.',
    '## Revision: Indices and Logarithms

**Laws of Indices.** For a base $x \neq 0$ and indices $a, b$:
- $x^a \times x^b = x^{a+b}$
- $x^a \div x^b = x^{a-b}$
- $x^0 = 1$
- $x^{-a} = \dfrac{1}{x^a}$, and $\left(\dfrac{x}{y}\right)^{-a} = \left(\dfrac{y}{x}\right)^a$
- $(x^a)^b = x^{ab}$
- $x^{1/a} = \sqrt[a]{x}$, and more generally $x^{b/a} = \sqrt[a]{x^b}$

**Glossary**
- **Index (plural: indices), or power/exponent:** the small raised number showing how many times a base is multiplied by itself. Example: in $2^3 = 8$, the index is $3$.
- **Reciprocal:** the result of flipping a fraction (or writing $1$ over a number). Example: the reciprocal of $8$ is $\frac{1}{8}$; a negative index always means "take the reciprocal of the positive-index version."
- **Logarithm:** the power needed on a base to produce a given number. Since $2^3 = 8$, we say $\log_2(8) = 3$.
- **Characteristic and mantissa:** a base-10 logarithm splits into a whole-number part (characteristic, from the power of 10 in standard form) and a decimal part (mantissa, read from log tables, always positive). Example: $\log(8156) = 3.9115$ because $8156 = 8.156 \times 10^3$ gives characteristic $3$, and the mantissa for digits 8156 is $0.9115$.

**Laws of Logarithms.** If $a^x = y$, then $\log_a(y) = x$.
- Product law: $\log_a(m \times n) = \log_a(m) + \log_a(n)$
- Quotient law: $\log_a(m \div n) = \log_a(m) - \log_a(n)$
- Power law: $\log_a(m^n) = n \log_a(m)$
- $\log_a(1) = 0$; $\log_a(a) = 1$
- Change of base: $\log_a(m) = \dfrac{\log_b(m)}{\log_b(a)}$

A very common exam skill is combining two logarithms with the product or quotient law, then converting the single resulting logarithm into an ordinary (exponential) equation to solve for the unknown, always checking afterward that the solution keeps every original logarithm''s argument positive.',
    1
  )
  returning id
)
insert into public.worked_examples (lesson_id, title, problem_statement, solution_steps, exam_shortcut, common_trap_warning, real_life_context, status)
select id,
  'A Negative Fractional Index',
  'Evaluate $8^{-2/3}$.',
  to_jsonb(array[
    'A negative index means "take the reciprocal": $8^{-2/3} = \dfrac{1}{8^{2/3}}$.',
    'Write the base as a perfect cube: $8 = 2^3$, so $8^{2/3} = (2^3)^{2/3}$.',
    'Apply the power-of-a-power rule (multiply the indices): $(2^3)^{2/3} = 2^{3 \times 2/3} = 2^2$.',
    'Evaluate: $2^2 = 4$, so $8^{2/3} = 4$.',
    'Combine with Step 1: $8^{-2/3} = \dfrac{1}{4}$.',
    'Answer: $8^{-2/3} = \dfrac{1}{4}$.'
  ]),
  'Spot perfect powers before doing anything else: recognizing $8 = 2^3$ turns a scary fractional-negative index into two clean, mechanical steps (flip, then simplify the power) with zero table lookups needed.',
  'Never apply the negative sign to the base itself (that would wrongly give a negative answer): the negative index only ever means "reciprocal," it does not make the result negative unless the base itself was already negative.',
  'This is the same reasoning a phone-credit vendor uses when working out that a "1/8 discount rate applied 3 times" collapses to a single clean fraction rather than three separate messy calculations, spotting the pattern early saves time either way.',
  'published'
from lesson;

insert into public.worked_examples (lesson_id, title, problem_statement, solution_steps, exam_shortcut, common_trap_warning, real_life_context, status)
select l.id,
  'Solving a Logarithmic Equation (With a Domain Check)',
  'Solve $\log_2(x) + \log_2(x - 3) = 2$.',
  to_jsonb(array[
    'Combine the two logarithms using the product law: $\log_2(x) + \log_2(x-3) = \log_2[x(x-3)]$.',
    'Rewrite the equation with the single combined logarithm: $\log_2[x(x-3)] = 2$.',
    'Convert from logarithmic form to exponential (index) form: $x(x-3) = 2^2 = 4$.',
    'Expand and rearrange into a standard quadratic: $x^2 - 3x = 4 \Rightarrow x^2 - 3x - 4 = 0$.',
    'Factorize: two numbers multiplying to $-4$ and adding to $-3$ are $-4$ and $1$, so $(x-4)(x+1) = 0$, giving $x = 4$ or $x = -1$.',
    'Check both roots against the domain of the original logarithms (their arguments $x$ and $x-3$ must both be positive): for $x=4$, $x-3=1 > 0$, valid; for $x=-1$, both $x$ and $x-3$ are negative, so $\log_2$ of them is undefined, this root is rejected.',
    'Answer: $x = 4$.'
  ]),
  'Whenever two logs are added or subtracted in an equation, combine them into a single log FIRST (product/quotient law), then convert to exponential form, never try to convert two separate logs at once.',
  'Always check every root against the domain of the ORIGINAL logarithms before finalizing an answer. WAEC frequently designs a quadratic with one deliberately invalid "trap" root, exactly like $x=-1$ here, precisely to test this check.',
  null::text,
  'published'
from public.lessons l
where l.topic_id = (select t.id from public.topics t join public.curricula c on c.id = t.curriculum_id where c.subject = 'Mathematics' and t.class_level = 'SS3' and t.term = 1 and t.order_index = 101)
order by l.created_at desc limit 1;

insert into public.worked_examples (lesson_id, title, problem_statement, solution_steps, exam_shortcut, common_trap_warning, real_life_context, status)
select l.id,
  'Multiplying with Log Tables',
  'Using log tables, evaluate $69.24 \times 8.31$.',
  to_jsonb(array[
    'Let $y = 69.24 \times 8.31$ and take logs of both sides. By the product law: $\log(y) = \log(69.24) + \log(8.31)$.',
    'Read each logarithm from the tables: $\log(69.24) = 1.8403$ (characteristic $1$, since $69.24 = 6.924 \times 10^1$); $\log(8.31) = 0.9196$ (characteristic $0$, since $8.31 = 8.31 \times 10^0$).',
    'Add the logarithms: $\log(y) = 1.8403 + 0.9196 = 2.7599$.',
    'Take the antilog of $2.7599$: the mantissa $0.7599$ corresponds to digits "5753", and the characteristic $2$ means there are 3 digits before the decimal point.',
    'Place the decimal point using the characteristic: $y = 575.3$.',
    'Answer: $69.24 \times 8.31 \approx 575.3$ (a quick mental check, $69 \times 8 \approx 552$, confirms this is the right size of answer, with no misplaced decimal point).'
  ]),
  'Estimate first with rough mental multiplication before trusting a table-based antilog: here $69 \times 8 \approx 552$, so an answer near $575$ is clearly right, while an answer like $5.753$ or $5753$ would immediately signal a misplaced decimal point.',
  null::text,
  'This is exactly how a market trader or a school bursar totalled bulk purchase costs by hand before calculators were common in Nigerian shops and schools, for example working out the cost of 69.24 kg of a commodity at ₦8.31 per kg equivalent unit, log tables turned the multiplication into simple addition.',
  'published'
from public.lessons l
where l.topic_id = (select t.id from public.topics t join public.curricula c on c.id = t.curriculum_id where c.subject = 'Mathematics' and t.class_level = 'SS3' and t.term = 1 and t.order_index = 101)
order by l.created_at desc limit 1;

insert into public.questions (topic_id, lesson_id, question_text, question_latex, option_a, option_b, option_c, option_d, option_e, correct_letter, difficulty, exam_type, explanation, exam_shortcut, status)
select t.id, l.id, v.question_text, v.question_latex, v.option_a, v.option_b, v.option_c, v.option_d, v.option_e, v.correct_letter::char(1), v.difficulty::integer, v.exam_type::exam_type, v.explanation, v.exam_shortcut, 'published'
from public.topics t
join public.curricula c on c.id = t.curriculum_id
join public.lessons l on l.topic_id = t.id
cross join (values
  ('Express in logarithmic form: (a) $5^2 = 125$ (b) $10^4 = 10{,}000$ (c) $2^{-3} = 1/8$.', null::text, '(a) $\log_5 125 = 2$ (b) $\log_{10} 10000 = 4$ (c) $\log_2(1/8) = -3$', '(a) $\log_5 125 = 25$ (b) $\log_{10} 10000 = 4$ (c) $\log_2(1/8) = -3$', '(a) $\log_5 125 = 2$ (b) $\log_{10} 10000 = 10000$ (c) $\log_2(1/8) = -3$', '(a) $\log_5 125 = 2$ (b) $\log_{10} 10000 = 4$ (c) $\log_2(1/8) = 3$', null::text, 'A', 1, 'GENERAL', 'Since $b^x=y \Rightarrow \log_b y = x$: $5^2=125 \Rightarrow \log_5125=2$; $10^4=10000 \Rightarrow \log_{10}10000=4$; $2^{-3}=1/8 \Rightarrow \log_2(1/8)=-3$.', 'The logarithm is always the index (the small raised number), never the base or the result itself.'),
  ('Evaluate without tables: (a) $\log_5(25)$ (b) $\log_3(81)$ (c) $\log_2(1/16)$.', null::text, '(a) 2 (b) 4 (c) -4', '(a) 5 (b) 3 (c) 2', '(a) 2 (b) 4 (c) 4', '(a) 2 (b) 3 (c) -4', null::text, 'A', 1, 'GENERAL', '$5^2=25$; $3^4=81$; $2^{-4}=1/16$. So the three logarithms are 2, 4, and -4.', null::text),
  ('Simplify: $\log_{10}(1000) - \log_{10}(10) + \log_{10}(100)$.', null::text, '3', '5', '4', '2', null::text, 'C', 2, 'GENERAL', '$\log1000=3$, $\log10=1$, $\log100=2$; so $3-1+2=4$.', null::text),
  ('Solve: (a) $\log_2(x) = 4$ (b) $\log_3(x) = -1$ (c) $\log_4(x) = 2.5$.', null::text, '(a) 16 (b) 1/3 (c) 32', '(a) 8 (b) -3 (c) 16', '(a) 16 (b) -1/3 (c) 32', '(a) 16 (b) 1/3 (c) 10', null::text, 'A', 2, 'GENERAL', '$x=2^4=16$; $x=3^{-1}=1/3$; $x=4^{2.5}=4^2\times4^{0.5}=16\times2=32$.', null::text),
  ('Given $\log_{10}2 = 0.3010$ and $\log_{10}3 = 0.4771$, find $\log_{10}6$.', null::text, '0.7781', '0.1761', '0.1441', '1.4331', null::text, 'A', 2, 'GENERAL', '$\log6=\log(2\times3)=\log2+\log3=0.3010+0.4771=0.7781$.', 'Break any composite number into prime factors already given in the question, then add their logs, never try to look up $\log6$ directly if $\log2$ and $\log3$ are already supplied.'),
  ('Solve: $\log_2(x) + \log_2(x + 6) = 4$.', null::text, 'x = 2', 'x = 4', 'x = -8', 'x = 8', null::text, 'A', 3, 'GENERAL', 'Combine: $\log_2[x(x+6)]=4 \Rightarrow x(x+6)=16 \Rightarrow x^2+6x-16=0 \Rightarrow (x+8)(x-2)=0$, giving $x=2$ or $x=-8$ (rejected, as it makes both log arguments negative). (Note: the right-hand side was corrected from 3 to 4 here, since $\log_2(x)+\log_2(x+6)=3$ has no clean solution.)', 'Reject any root that makes an original logarithm''s argument zero or negative.'),
  ('Simplify: $2\log_2(4) + 3\log_2(2) - \log_2(8)$.', null::text, '4', '5', '3', '7', null::text, 'A', 2, 'GENERAL', '$2\log_24=2(2)=4$; $3\log_22=3(1)=3$; $\log_28=3$; total $=4+3-3=4$.', null::text),
  ('Solve: $\log_2(x + 3) - \log_2(x - 2) = 1$.', null::text, 'x = 5', 'x = 7', 'x = 4', 'x = 9', null::text, 'B', 3, 'GENERAL', '$\log_2\frac{x+3}{x-2}=1 \Rightarrow \frac{x+3}{x-2}=2 \Rightarrow x+3=2x-4 \Rightarrow x=7$.', null::text),
  ('Use logarithms to evaluate $45.6 \times 78.2$.', null::text, '3566', '356.6', '35660', '3.566', null::text, 'A', 2, 'GENERAL', '$\log45.6=1.6590$, $\log78.2=1.8932$; sum $=3.5522$; antilog $\approx 3566$ (direct multiplication also gives $45.6\times78.2=3565.92$, matching).', null::text),
  ('Solve $5^x = 20$ (use $\log_{10}2=0.3010$, $\log_{10}5=0.6990$).', null::text, 'x ≈ 1.861', 'x ≈ 2.861', 'x ≈ 0.861', 'x ≈ 4', null::text, 'A', 3, 'GENERAL', '$\log20=\log(4\times5)=2\log2+\log5=0.6020+0.6990=1.3010$. $x=\log20/\log5=1.3010/0.6990\approx1.861$.', 'Take logs of both sides whenever the unknown is stuck in the index.'),
  ('Simplify: $\log_5(125) + \log_5(25) - \log_5(5)$.', null::text, '4', '5', '3', '6', null::text, 'A', 2, 'GENERAL', '$\log_5125=3$, $\log_525=2$, $\log_55=1$; $3+2-1=4$.', null::text),
  ('Simplify: $3\log_2(8) - 2\log_2(4) + \log_2(16)$.', null::text, '7', '9', '5', '11', null::text, 'B', 3, 'GENERAL', '$3\log_28=3(3)=9$; $2\log_24=2(2)=4$; $\log_216=4$; total $=9-4+4=9$.', null::text),
  ('Express as a single logarithm: $2\log_a(x) + \log_a(y) - 3\log_a(z)$.', null::text, '$\log_a\left(\dfrac{x^2 y}{z^3}\right)$', '$\log_a\left(\dfrac{2xy}{3z}\right)$', '$\log_a(x^2yz^3)$', '$\log_a\left(\dfrac{x^2}{yz^3}\right)$', null::text, 'A', 3, 'GENERAL', 'Power law first: $2\log_ax=\log_ax^2$, $3\log_az=\log_az^3$; then combine with product/quotient law: $\log_a(x^2)+\log_a(y)-\log_a(z^3)=\log_a\frac{x^2y}{z^3}$.', null::text),
  ('Solve: $\log_3(2x - 1) = 2$.', null::text, 'x = 5', 'x = 4', 'x = 4.5', 'x = 9', null::text, 'A', 2, 'GENERAL', '$2x-1=3^2=9 \Rightarrow 2x=10 \Rightarrow x=5$.', null::text),
  ('Solve: $\log_2(x) + \log_2(x - 7) = 3$.', null::text, 'x = 8', 'x = -1', 'x = 7', 'x = 15', null::text, 'A', 3, 'GENERAL', '$x(x-7)=8 \Rightarrow x^2-7x-8=0 \Rightarrow (x-8)(x+1)=0$; $x=8$ (valid), $x=-1$ rejected (negative log arguments).', null::text),
  ('Solve: $2\log(x) - \log(x - 4) = \log(4)$.', null::text, 'No real solution', 'x = 4', 'x = 8', 'x = -4', null::text, 'A', 4, 'GENERAL', '$\log\frac{x^2}{x-4}=\log4 \Rightarrow x^2=4x-16 \Rightarrow x^2-4x+16=0$; discriminant $=16-64=-48<0$, so there is no real solution.', 'A negative discriminant after converting a log equation to exponential form means the log equation itself has no real solution, don''t keep hunting for an arithmetic slip.'),
  ('Solve: $3^{x+2} = 81$.', null::text, 'x = 2', 'x = 4', 'x = 1', 'x = 6', null::text, 'A', 2, 'GENERAL', '$81=3^4$, so $x+2=4 \Rightarrow x=2$.', null::text),
  ('Given $\log_{10}2=0.3010$, $\log_{10}3=0.4771$, $\log_{10}7=0.8451$, evaluate $\log_{10}14$.', null::text, '1.1461', '1.3222', '0.6532', '1.6902', null::text, 'A', 3, 'GENERAL', '$14=2\times7$, so $\log14=\log2+\log7=0.3010+0.8451=1.1461$.', null::text),
  ('Using the same values as the previous question, evaluate $\log_{10}21$.', null::text, '1.1461', '1.3222', '0.6532', '1.3781', null::text, 'B', 3, 'GENERAL', '$21=3\times7$, so $\log21=\log3+\log7=0.4771+0.8451=1.3222$.', null::text),
  ('Using the same values, evaluate $\log_{10}4.5$.', null::text, '1.1461', '1.3222', '0.6532', '0.9542', null::text, 'C', 3, 'GENERAL', '$4.5=9/2$, so $\log4.5=\log9-\log2=2\log3-\log2=0.9542-0.3010=0.6532$.', null::text),
  ('Using logarithms, evaluate $\sqrt[3]{216}$.', null::text, '6', '8', '4', '36', null::text, 'A', 2, 'GENERAL', '$\log216=\frac{1}{3}\log216^{3}$... more directly, $216=6^3$ so $\sqrt[3]{216}=6$ exactly, confirmed via logs: $\frac{1}{3}\log216=\frac{1}{3}(2.3345)=0.7782$, and antilog(0.7782)=6.', 'Spot a perfect cube before reaching for tables: $216=6^3$ gives an instant exact answer.'),
  ('The population of a town grows as $P = P_0 \times 2^{t/10}$. If the initial population is 50,000, how many years until it reaches 200,000?', null::text, '20 years', '10 years', '40 years', '15 years', null::text, 'A', 3, 'GENERAL', '$200000=50000\times2^{t/10} \Rightarrow 4=2^{t/10} \Rightarrow 2^2=2^{t/10} \Rightarrow t/10=2 \Rightarrow t=20$.', null::text),
  ('Evaluate $(0.008)^{1/3}$.', null::text, '0.2', '0.5', '0.8', '0.15', '0.1', 'A', 2, 'GENERAL', '$0.008=(0.2)^3$ since $0.2\times0.2\times0.2=0.008$, so $(0.008)^{1/3}=0.2$.', 'Write the decimal as a fraction of small cubes ($8/1000=2^3/10^3$) to spot the cube root instantly.'),
  ('Simplify $(-8)^{4/3}$.', null::text, '-32', '-16', '16', '32', null::text, 'C', 3, 'GENERAL', 'Take the real cube root first: $\sqrt[3]{-8}=-2$; then raise to the 4th power: $(-2)^4=16$.', null::text),
  ('Evaluate $(4^{1/4})^6$.', null::text, '1/8', '4', '6', '8', null::text, 'D', 3, 'GENERAL', '$(4^{1/4})^6=4^{6/4}=4^{1.5}=4\times\sqrt4=4\times2=8$.', null::text),
  ('Using logarithm tables, evaluate $\sqrt[3]{66.32}$.', null::text, '4.048', '40.48', '2.024', '8.096', null::text, 'A', 3, 'GENERAL', '$\log66.32=1.8218$; divide by 3: $0.6073$; antilog gives approximately $4.048$ (check: $4.048^3\approx66.3$).', null::text),
  ('Using log tables, evaluate $7031 \times 4.911$.', null::text, '34,530', '3453', '1432', '345,300', null::text, 'A', 3, 'GENERAL', 'Direct multiplication: $7031\times4.911\approx34{,}529.2$, so the product is approximately $34{,}530$ (log tables give the same result to 4 significant figures: $\log7031=3.8470$, $\log4.911=0.6912$, sum $=4.5382$, antilog $\approx34{,}540$, matching within table-rounding).', null::text),
  ('Find the value of $x$, given $x^{1/2} = 10^{1.6741}$ (without a calculator).', null::text, '2229', '0.2229', '22,290', '229', null::text, 'A', 4, 'GENERAL', '$x^{1/2}=10^{1.6741}=10\times10^{0.6741}=10\times4.721=47.21$, so $x=47.21^2\approx2229$.', 'When a power has a whole-number part greater than 0, split it off first ($10^{1.6741}=10^1\times10^{0.6741}$) so only the mantissa needs an antilog lookup.')
) as v(question_text, question_latex, option_a, option_b, option_c, option_d, option_e, correct_letter, difficulty, exam_type, explanation, exam_shortcut)
where c.subject = 'Mathematics' and t.class_level = 'SS3' and t.term = 1 and t.order_index = 101;

-- ------------------------------------------
-- 102. SURDS  -  SS3 Mathematics, Term 1
-- ------------------------------------------


with lesson as (
  insert into public.lessons (topic_id, title, summary, content_body, order_index)
  values (
    (select t.id from public.topics t join public.curricula c on c.id = t.curriculum_id where c.subject = 'Mathematics' and t.class_level = 'SS3' and t.term = 1 and t.order_index = 102),
    'Surds: Simplifying and Rationalizing',
    'Simplifying surds by extracting perfect-square factors, combining like surds, and rationalizing denominators using a single surd or a conjugate.',
    '## Surds

**Glossary**
- **Surd:** an irrational root, a root that cannot be simplified to a rational (whole or fraction) number. Example: $\sqrt2$, $\sqrt3$, and $\sqrt5$ are surds, but $\sqrt4=2$ and $\sqrt9=3$ are not surds since they simplify to whole numbers.
- **Rationalize:** to rewrite a fraction so that its denominator no longer contains a surd, by multiplying top and bottom by a carefully chosen expression.
- **Conjugate:** for a two-term expression like $a+\sqrt b$, its conjugate is $a-\sqrt b$ (same terms, opposite middle sign). Multiplying a two-term surd expression by its conjugate always removes the surd, since $(a+\sqrt b)(a-\sqrt b)=a^2-b$.

**Basic rules**
- $\sqrt a \times \sqrt b = \sqrt{ab}$
- $\sqrt a \div \sqrt b = \sqrt{a/b}$
- $(\sqrt a)^2 = a$
- $\sqrt a + \sqrt b \neq \sqrt{a+b}$ in general, surds only combine by collecting "like" surd terms, the same way $3x+2x=5x$ but $3x+2y$ cannot be combined further.

**Simplifying:** extract the largest perfect-square factor. Example: $\sqrt{18}=\sqrt{9\times2}=3\sqrt2$.

**Rationalizing the denominator:** for a single surd in the denominator, multiply top and bottom by that same surd. For a two-term (binomial) denominator such as $a+\sqrt b$, multiply top and bottom by its conjugate $a-\sqrt b$, since $(a+\sqrt b)(a-\sqrt b)=a^2-b$ is always rational.',
    1
  )
  returning id
)
insert into public.worked_examples (lesson_id, title, problem_statement, solution_steps, exam_shortcut, common_trap_warning, real_life_context, status)
select id,
  'Simplifying and Combining Surds',
  'Simplify $2\sqrt{12} + 3\sqrt3 - \sqrt{48}$.',
  to_jsonb(array[
    'Simplify each surd separately by extracting perfect-square factors: $\sqrt{12}=\sqrt{4\times3}=2\sqrt3$; $\sqrt{48}=\sqrt{16\times3}=4\sqrt3$.',
    'Substitute the simplified surds back into the expression: $2\sqrt{12}+3\sqrt3-\sqrt{48}=2(2\sqrt3)+3\sqrt3-4\sqrt3$.',
    'Multiply through: $=4\sqrt3+3\sqrt3-4\sqrt3$.',
    'Collect like surd terms (treat $\sqrt3$ like a common variable): $(4+3-4)\sqrt3=3\sqrt3$.',
    'Answer: $3\sqrt3$.'
  ]),
  'Factor out the LARGEST perfect square in one pass, not several small ones, e.g. for $\sqrt{48}$ jump straight to $16\times3$ (giving $4\sqrt3$) rather than doing $4\times12$ then $4\times3$ in two steps. Memorizing perfect squares up to $15^2$ makes this instant.',
  null::text,
  null::text,
  'published'
from lesson;

insert into public.worked_examples (lesson_id, title, problem_statement, solution_steps, exam_shortcut, common_trap_warning, real_life_context, status)
select l.id,
  'Rationalizing a Binomial Denominator',
  'Rationalize $\dfrac{1}{3 - \sqrt6}$.',
  to_jsonb(array[
    'Identify the conjugate of the denominator: for $3-\sqrt6$, the conjugate is $3+\sqrt6$ (same terms, opposite middle sign).',
    'Multiply numerator and denominator by the conjugate: $\dfrac{1}{3-\sqrt6}\times\dfrac{3+\sqrt6}{3+\sqrt6}$.',
    'Expand the denominator using $(a-b)(a+b)=a^2-b^2$: $(3-\sqrt6)(3+\sqrt6)=3^2-(\sqrt6)^2=9-6=3$.',
    'Expand the numerator: $1\times(3+\sqrt6)=3+\sqrt6$.',
    'Write the simplified fraction: $\dfrac{3+\sqrt6}{3}$.',
    'Answer: $\dfrac{3+\sqrt6}{3}$.'
  ]),
  'Recognize a "difference of two squares" denominator on sight: $(a+\sqrt b)(a-\sqrt b)=a^2-b$. There is no need to fully expand every time, just compute $a^2-b$ directly once the conjugate is chosen.',
  'For a denominator with only a single surd (like $\dfrac{1}{\sqrt3}$), multiply by that surd alone, not a conjugate, since conjugates are only needed for two-term (binomial) denominators.',
  'This is the same rearranging a phone-repair technician does when converting an awkward "per square-root-unit" cost figure from a supplier''s price sheet into a clean ₦-per-unit rate before quoting a customer.',
  'published'
from public.lessons l
where l.topic_id = (select t.id from public.topics t join public.curricula c on c.id = t.curriculum_id where c.subject = 'Mathematics' and t.class_level = 'SS3' and t.term = 1 and t.order_index = 102)
order by l.created_at desc limit 1;

insert into public.worked_examples (lesson_id, title, problem_statement, solution_steps, exam_shortcut, common_trap_warning, real_life_context, status)
select l.id,
  'Expanding a Product of Two Surd Binomials',
  'Given $(\sqrt3 - 5\sqrt2)(\sqrt3 + \sqrt2) = a + b\sqrt6$, find $a$ and $b$.',
  to_jsonb(array[
    'Expand using FOIL (First, Outer, Inner, Last): $(\sqrt3)(\sqrt3) + (\sqrt3)(\sqrt2) + (-5\sqrt2)(\sqrt3) + (-5\sqrt2)(\sqrt2)$.',
    'Evaluate each term: $(\sqrt3)(\sqrt3)=3$; $(\sqrt3)(\sqrt2)=\sqrt6$; $(-5\sqrt2)(\sqrt3)=-5\sqrt6$; $(-5\sqrt2)(\sqrt2)=-5\times2=-10$.',
    'Add all four terms together: $3+\sqrt6-5\sqrt6-10$.',
    'Collect the rational terms and the $\sqrt6$ terms separately: rational part $=3-10=-7$; surd part $=\sqrt6-5\sqrt6=-4\sqrt6$.',
    'Match to the form $a+b\sqrt6$: $a=-7$, $b=-4$.',
    'Answer: $a=-7$, $b=-4$.'
  ]),
  'In "find a and b" surd expansion questions, separate rational and irrational parts as the very LAST step, never round or approximate midway, since $a$ and $b$ must come out as exact numbers matched term-by-term.',
  null::text,
  null::text,
  'published'
from public.lessons l
where l.topic_id = (select t.id from public.topics t join public.curricula c on c.id = t.curriculum_id where c.subject = 'Mathematics' and t.class_level = 'SS3' and t.term = 1 and t.order_index = 102)
order by l.created_at desc limit 1;

insert into public.questions (topic_id, lesson_id, question_text, question_latex, option_a, option_b, option_c, option_d, option_e, correct_letter, difficulty, exam_type, explanation, exam_shortcut, status)
select t.id, l.id, v.question_text, v.question_latex, v.option_a, v.option_b, v.option_c, v.option_d, v.option_e, v.correct_letter::char(1), v.difficulty::integer, v.exam_type::exam_type, v.explanation, v.exam_shortcut, 'published'
from public.topics t
join public.curricula c on c.id = t.curriculum_id
join public.lessons l on l.topic_id = t.id
cross join (values
  ('Simplify: (a) $\sqrt{32}$ (b) $\sqrt{45}$ (c) $\sqrt{38} + \sqrt{22}$.', null::text, '(a) $4\sqrt2$ (b) $3\sqrt5$ (c) cannot be simplified further (38 and 22 share no common perfect-square factor)', '(a) $4\sqrt2$ (b) $3\sqrt5$ (c) $\sqrt{60}$', '(a) $2\sqrt8$ (b) $3\sqrt5$ (c) cannot be simplified further', '(a) $4\sqrt2$ (b) $9\sqrt5$ (c) cannot be simplified further', null::text, 'A', 2, 'GENERAL', '$32=16\times2\Rightarrow\sqrt{32}=4\sqrt2$; $45=9\times5\Rightarrow\sqrt{45}=3\sqrt5$; 38 and 22 have no shared perfect-square factor, so $\sqrt{38}+\sqrt{22}$ is already in simplest form (unlike surds cannot be added).', null::text),
  ('Rationalize: (a) $\dfrac{1}{\sqrt3}$ (b) $\dfrac{2}{\sqrt5}$ (c) $\dfrac{1}{1+\sqrt2}$.', null::text, '(a) $\sqrt3/3$ (b) $2\sqrt5/5$ (c) $\sqrt2-1$', '(a) $\sqrt3$ (b) $2\sqrt5$ (c) $\sqrt2-1$', '(a) $\sqrt3/3$ (b) $\sqrt5/5$ (c) $\sqrt2+1$', '(a) $3\sqrt3$ (b) $2\sqrt5/5$ (c) $1-\sqrt2$', null::text, 'A', 2, 'GENERAL', '(a) $\frac{1}{\sqrt3}\times\frac{\sqrt3}{\sqrt3}=\frac{\sqrt3}{3}$. (b) $\frac{2}{\sqrt5}\times\frac{\sqrt5}{\sqrt5}=\frac{2\sqrt5}{5}$. (c) multiply by conjugate $\frac{\sqrt2-1}{\sqrt2-1}$: denominator $(1+\sqrt2)(\sqrt2-1)=2-1=1$, numerator $=\sqrt2-1$, giving $\sqrt2-1$.', null::text),
  ('Simplify completely: $\sqrt{48} + \sqrt{75} - \sqrt{12}$.', null::text, '7√3', '5√3', '9√3', '3√3', null::text, 'A', 2, 'GENERAL', '$\sqrt{48}=4\sqrt3$, $\sqrt{75}=5\sqrt3$, $\sqrt{12}=2\sqrt3$; $4\sqrt3+5\sqrt3-2\sqrt3=7\sqrt3$.', null::text),
  ('Rationalize and simplify: $\dfrac{3}{\sqrt5 - \sqrt2}$.', null::text, '√5 + √2', '3(√5 - √2)', '√5 - √2', '3√5 + √2', null::text, 'A', 3, 'GENERAL', 'Multiply by the conjugate $\frac{\sqrt5+\sqrt2}{\sqrt5+\sqrt2}$: denominator $=5-2=3$; numerator $=3(\sqrt5+\sqrt2)$; the 3s cancel, giving $\sqrt5+\sqrt2$.', null::text),
  ('Simplify: $(\sqrt3 + \sqrt2)(\sqrt3 - \sqrt2)$.', null::text, '1', '5', '6', '√6', null::text, 'A', 2, 'GENERAL', 'Difference of two squares: $(\sqrt3)^2-(\sqrt2)^2=3-2=1$.', null::text),
  ('Simplify: $\dfrac{4\sqrt{12} + 3\sqrt3}{\sqrt3}$.', null::text, '11', '7', '15', '4', null::text, 'A', 3, 'GENERAL', '$\sqrt{12}=2\sqrt3$, so $4\sqrt{12}=8\sqrt3$; numerator $=8\sqrt3+3\sqrt3=11\sqrt3$; dividing by $\sqrt3$ gives 11.', 'Simplify every surd in a numerator to the SAME surd first, then the division by the denominator surd becomes a plain number division.'),
  ('Simplify $\sqrt{12}(\sqrt{48} - \sqrt3)$.', null::text, '18', '12', '24', '36', null::text, 'A', 3, 'GENERAL', 'Expand: $\sqrt{12}\times\sqrt{48}-\sqrt{12}\times\sqrt3=\sqrt{576}-\sqrt{36}=24-6=18$.', null::text),
  ('Given $(\sqrt3 - 5\sqrt2)(\sqrt3 + \sqrt2) = a + b\sqrt6$, find $a$ and $b$.', null::text, 'a = -7, b = -4', 'a = 7, b = 4', 'a = -7, b = 4', 'a = -3, b = -4', null::text, 'A', 3, 'GENERAL', 'FOIL expansion gives $3+\sqrt6-5\sqrt6-10=-7-4\sqrt6$, so $a=-7$, $b=-4$.', null::text),
  ('Simplify $\dfrac{10\sqrt2}{\sqrt5}$.', null::text, '2√10', '10√10', '2√2', '5√10', null::text, 'A', 2, 'GENERAL', 'Multiply by $\frac{\sqrt5}{\sqrt5}$: $\frac{10\sqrt2\times\sqrt5}{5}=\frac{10\sqrt{10}}{5}=2\sqrt{10}$.', null::text),
  ('Simplify $\sqrt3 - \dfrac{2\sqrt3}{3}$.', null::text, '√3/3', '2√3/3', '√3', '5√3/3', null::text, 'A', 2, 'GENERAL', 'Write $\sqrt3$ as $\frac{3\sqrt3}{3}$: $\frac{3\sqrt3}{3}-\frac{2\sqrt3}{3}=\frac{\sqrt3}{3}$. (This replaces a garbled item in the source with a clean question testing the same "combine surds over a common denominator" skill, and reproduces the source''s target answer $\sqrt3/3$ exactly.)', null::text),
  ('Simplify $\dfrac{\sqrt{35}}{\sqrt5}$.', null::text, '√7', '7', '√35/5', '5√7', null::text, 'A', 2, 'GENERAL', '$\sqrt{35}/\sqrt5=\sqrt{35/5}=\sqrt7$.', null::text),
  ('Simplify $\dfrac{\sqrt{17}}{\sqrt4}$.', null::text, '√17/2', '√17', '2√17', '√13', null::text, 'A', 1, 'GENERAL', '$\sqrt4=2$, so $\sqrt{17}/\sqrt4=\sqrt{17}/2$.', null::text),
  ('Rationalize $\dfrac{5}{\sqrt3}$, leaving your answer in surd form.', null::text, '5√3', '3√3/5', '5√3/3', '9√5/5', null::text, 'C', 2, 'GENERAL', '$\frac{5}{\sqrt3}\times\frac{\sqrt3}{\sqrt3}=\frac{5\sqrt3}{3}$.', null::text),
  ('Simplify $\dfrac{6}{\sqrt3}$.', null::text, '2√3/3', '3', '2√3', '6√3', null::text, 'C', 2, 'GENERAL', '$\frac{6}{\sqrt3}\times\frac{\sqrt3}{\sqrt3}=\frac{6\sqrt3}{3}=2\sqrt3$.', null::text),
  ('Rationalize $\dfrac{1}{3-\sqrt6}$.', null::text, '3√6', '(3+√6)/3', '6', '12/√6', '√6', 'B', 3, 'GENERAL', 'Multiply by the conjugate $3+\sqrt6$: denominator $=9-6=3$, numerator $=3+\sqrt6$, giving $(3+\sqrt6)/3$.', null::text),
  ('Which of the following is the conjugate of $\sqrt3 + \sqrt2$?', null::text, '$\sqrt2 - \sqrt3$', '$\sqrt3 - \sqrt2$', '$\dfrac{\sqrt3-\sqrt2}{3+2}$', '$-\sqrt3-\sqrt2$', null::text, 'B', 2, 'GENERAL', 'The conjugate keeps the same terms but flips the middle sign: the conjugate of $\sqrt3+\sqrt2$ is $\sqrt3-\sqrt2$.', null::text),
  ('Without tables, find the value of $\dfrac{1}{\sqrt{11}-2} - \dfrac{1}{\sqrt{11}+2}$.', null::text, '4/7', '2√2/9', '4/9', '2/7', null::text, 'A', 4, 'GENERAL', 'Denominator of the combined fraction: $(\sqrt{11}-2)(\sqrt{11}+2)=11-4=7$. Numerator: $(\sqrt{11}+2)-(\sqrt{11}-2)=4$. Result $=4/7$. (Corrected from the source''s "$\sqrt{11}-\sqrt2$" wording, which evaluates to $2\sqrt2/9$, not the stated $4/7$; using $2$ instead of $\sqrt2$ reproduces $4/7$ exactly.)', null::text),
  ('Rationalize $\dfrac{2}{4+3\sqrt2}$.', null::text, '3√2 - 4', '4 - 3√2', '3√2 + 4', '-3√2 - 4', null::text, 'A', 4, 'GENERAL', 'Multiply by the conjugate $4-3\sqrt2$: denominator $=16-18=-2$; numerator $=2(4-3\sqrt2)=8-6\sqrt2$; dividing by $-2$ gives $-4+3\sqrt2=3\sqrt2-4$.', null::text),
  ('Rationalize $\dfrac{7-\sqrt3}{13-\sqrt3}$.', null::text, '(44 - 3√3)/83', '(44 + 3√3)/83', '(91 - 3√3)/166', '(7-\sqrt3)/13', null::text, 'A', 4, 'GENERAL', 'Multiply by the conjugate $13+\sqrt3$: denominator $=169-3=166$; numerator $=(7-\sqrt3)(13+\sqrt3)=91+7\sqrt3-13\sqrt3-3=88-6\sqrt3$; simplify by dividing by 2: $(44-3\sqrt3)/83$.', null::text),
  ('Simplify $\dfrac{3\sqrt5 \times 4\sqrt6}{2\sqrt2 \times 3\sqrt3}$.', null::text, '2', '5', '2√2', '2√5', null::text, 'D', 3, 'GENERAL', 'Numerator $=12\sqrt{30}$; denominator $=6\sqrt6$; ratio $=2\sqrt{30/6}=2\sqrt5$.', null::text),
  ('By rationalizing the denominator, simplify $\dfrac{7\sqrt5}{\sqrt7}$, leaving your answer in surd form.', null::text, '√35', '7√35', '√35/7', '5√7', null::text, 'A', 3, 'GENERAL', '$\frac{7\sqrt5}{\sqrt7}\times\frac{\sqrt7}{\sqrt7}=\frac{7\sqrt{35}}{7}=\sqrt{35}$.', null::text),
  ('Simplify $\dfrac{(\sqrt2-\sqrt3)^2}{(\sqrt2+\sqrt3)^2}$.', null::text, '49 - 20√6', '5 - 2√6', '5 + 2√6', '49 + 20√6', null::text, 'A', 4, 'GENERAL', '$(\sqrt2-\sqrt3)^2=5-2\sqrt6$; $(\sqrt2+\sqrt3)^2=5+2\sqrt6$. Rationalizing $\frac{5-2\sqrt6}{5+2\sqrt6}$ by multiplying by $\frac{5-2\sqrt6}{5-2\sqrt6}$: denominator $=25-24=1$, numerator $=(5-2\sqrt6)^2=49-20\sqrt6$, giving $49-20\sqrt6$.', null::text)
) as v(question_text, question_latex, option_a, option_b, option_c, option_d, option_e, correct_letter, difficulty, exam_type, explanation, exam_shortcut)
where c.subject = 'Mathematics' and t.class_level = 'SS3' and t.term = 1 and t.order_index = 102;

-- ------------------------------------------
-- 103. SURDS IN RELATION TO TRIGONOMETRY  -  SS3 Mathematics, Term 1
-- ------------------------------------------


with lesson as (
  insert into public.lessons (topic_id, title, summary, content_body, order_index)
  values (
    (select t.id from public.topics t join public.curricula c on c.id = t.curriculum_id where c.subject = 'Mathematics' and t.class_level = 'SS3' and t.term = 1 and t.order_index = 103),
    'Exact Trigonometric Ratios of 30, 45, and 60 Degrees',
    'Deriving exact sine, cosine, and tangent values for 30 degrees, 45 degrees, and 60 degrees from two reference triangles, and using the CAST rule to solve trigonometric equations.',
    '## Surds in Relation to Trigonometry

For the special angles $30^\circ$, $45^\circ$, $60^\circ$, exact trigonometric ratios can be written using surds instead of decimals, derived from two reference triangles.

**Glossary**
- **Exact value:** a trigonometric ratio written using surds (e.g. $\sqrt2/2$) rather than a rounded decimal (e.g. $0.7071$), so no accuracy is lost.
- **Reference angle:** the acute angle between $0^\circ$ and $90^\circ$ that a given angle "matches" in size, used to find ratios for angles outside the first quadrant.
- **CAST rule:** a memory device for which trigonometric ratio is positive in each quadrant of $0^\circ$ to $360^\circ$: **A**ll positive in Quadrant 1, **S**ine positive in Quadrant 2, **T**angent positive in Quadrant 3, **C**osine positive in Quadrant 4.

**Deriving the $45^\circ$ ratios:** take a right-angled isosceles triangle with both legs $=1$. By Pythagoras, hypotenuse$^2 = 1^2+1^2=2$, so hypotenuse $=\sqrt2$. Then $\sin45^\circ=\frac{1}{\sqrt2}=\frac{\sqrt2}{2}$ (after rationalizing), $\cos45^\circ=\frac{\sqrt2}{2}$, $\tan45^\circ=\frac{1}{1}=1$.

**Deriving the $30^\circ$/$60^\circ$ ratios:** take an equilateral triangle with all sides $=2$, and drop a perpendicular from one vertex to the midpoint of the opposite side. This splits it into two right triangles with hypotenuse $2$, one leg $1$ (half the base), and the other leg $h$ found from $h^2+1^2=2^2 \Rightarrow h=\sqrt3$.

| Angle | sin | cos | tan |
|---|---|---|---|
| $30^\circ$ | $1/2$ | $\sqrt3/2$ | $\sqrt3/3$ |
| $45^\circ$ | $\sqrt2/2$ | $\sqrt2/2$ | $1$ |
| $60^\circ$ | $\sqrt3/2$ | $1/2$ | $\sqrt3$ |

The two reference triangles are worth redrawing from memory rather than memorizing the table by rote, since SOH-CAH-TOA applied directly to either triangle regenerates every ratio.',
    1
  )
  returning id
)
insert into public.worked_examples (lesson_id, title, problem_statement, solution_steps, exam_shortcut, common_trap_warning, diagram_type, diagram_data, status)
select id,
  'The 45-45-90 Reference Triangle',
  'Using a right-angled isosceles triangle with both legs equal to 1, find the exact value of $\sin^2 45^\circ + \cos^2 45^\circ$.',
  to_jsonb(array[
    'Draw the reference triangle: legs of length 1 and 1, right angle between them. By Pythagoras, hypotenuse $= \sqrt{1^2+1^2}=\sqrt2$.',
    'Read off $\sin45^\circ = \dfrac{\text{opposite}}{\text{hypotenuse}} = \dfrac{1}{\sqrt2} = \dfrac{\sqrt2}{2}$ after rationalizing, and $\cos45^\circ = \dfrac{\sqrt2}{2}$ by the same reasoning (the triangle is symmetric).',
    'Square each value: $\left(\dfrac{\sqrt2}{2}\right)^2 = \dfrac{2}{4} = \dfrac{1}{2}$ for both sine and cosine.',
    'Add the two squared values: $\dfrac12+\dfrac12=1$.',
    'Answer: $1$ (this confirms the identity $\sin^2\theta+\cos^2\theta=1$ for $\theta=45^\circ$).'
  ]),
  'Redraw the 45-45-90 triangle (legs 1, 1, hypotenuse $\sqrt2$) from memory in a few seconds rather than trying to recall the ratio table by rote, this also prevents mixing up which ratio belongs to which angle.',
  null::text,
  'triangle',
  '{"vertices": [{"label": "A", "x": 0, "y": 0}, {"label": "B", "x": 1, "y": 0}, {"label": "C", "x": 0, "y": 1}], "sideLabels": [{"from": "A", "to": "B", "label": "1"}, {"from": "A", "to": "C", "label": "1"}, {"from": "B", "to": "C", "label": "√2"}], "angleLabels": [{"vertex": "B", "label": "45°"}], "rightAngleAt": "A"}'::jsonb,
  'published'
from lesson;

insert into public.worked_examples (lesson_id, title, problem_statement, solution_steps, exam_shortcut, common_trap_warning, diagram_type, diagram_data, status)
select l.id,
  'The 30-60-90 Reference Triangle',
  'Using half an equilateral triangle of side 2, find the exact value of $\tan60^\circ - \tan30^\circ$.',
  to_jsonb(array[
    'Draw the reference triangle: an equilateral triangle of side 2, split into two right triangles by a perpendicular from one vertex, giving hypotenuse $2$, short leg $1$, and long leg $\sqrt3$ (from $1^2+h^2=2^2$).',
    'Read off $\tan60^\circ = \dfrac{\sqrt3}{1} = \sqrt3$ and $\tan30^\circ = \dfrac{1}{\sqrt3} = \dfrac{\sqrt3}{3}$ after rationalizing.',
    'Write both terms over a common denominator of 3: $\sqrt3 = \dfrac{3\sqrt3}{3}$.',
    'Subtract: $\dfrac{3\sqrt3}{3} - \dfrac{\sqrt3}{3} = \dfrac{2\sqrt3}{3}$.',
    'Answer: $\dfrac{2\sqrt3}{3}$.'
  ]),
  'Use SOH-CAH-TOA directly on the two reference triangles rather than memorizing a table blindly, sin = opposite/hypotenuse, cos = adjacent/hypotenuse, tan = opposite/adjacent applied straight to the triangles regenerates the whole ratio table if it slips your memory.',
  null::text,
  'triangle',
  '{"vertices": [{"label": "A", "x": 0, "y": 0}, {"label": "B", "x": 1, "y": 0}, {"label": "C", "x": 0, "y": 1.732}], "sideLabels": [{"from": "A", "to": "B", "label": "1"}, {"from": "A", "to": "C", "label": "√3"}, {"from": "B", "to": "C", "label": "2"}], "angleLabels": [{"vertex": "B", "label": "60°"}, {"vertex": "C", "label": "30°"}], "rightAngleAt": "A"}'::jsonb,
  'published'
from public.lessons l
where l.topic_id = (select t.id from public.topics t join public.curricula c on c.id = t.curriculum_id where c.subject = 'Mathematics' and t.class_level = 'SS3' and t.term = 1 and t.order_index = 103)
order by l.created_at desc limit 1;

insert into public.worked_examples (lesson_id, title, problem_statement, solution_steps, exam_shortcut, common_trap_warning, real_life_context, status)
select l.id,
  'Solving a Trigonometric Equation with the CAST Rule',
  'Solve $\sin x = \cos x$ for $0^\circ \le x \le 360^\circ$.',
  to_jsonb(array[
    'Divide both sides by $\cos x$ (valid since $\cos x \neq 0$ wherever $\sin x = \cos x$): $\dfrac{\sin x}{\cos x} = 1 \Rightarrow \tan x = 1$.',
    'Find the reference (acute) angle: $\tan^{-1}(1) = 45^\circ$.',
    'Use the CAST rule to find every quadrant where tangent is positive: tangent is positive in Quadrant 1 ($0^\circ$ to $90^\circ$) and Quadrant 3 ($180^\circ$ to $270^\circ$).',
    'Write the solution in each quadrant: Quadrant 1 gives $x = 45^\circ$ directly; Quadrant 3 gives $x = 180^\circ + 45^\circ = 225^\circ$.',
    'Answer: $x = 45^\circ$ or $x = 225^\circ$.'
  ]),
  'For "solve $\sin x = \cos x$" type equations, always convert to $\tan x = 1$ (or $\tan x = k$) first, trigonometric equations mixing sin and cos are far easier to solve as a single tan equation, and this is deliberately a very common exam setup.',
  'When two quadrant solutions are needed, use "reference angle plus/minus quadrant rule": Q2 = $180^\circ$ minus reference, Q3 = $180^\circ$ plus reference, Q4 = $360^\circ$ minus reference, always starting from the acute reference angle in Quadrant 1.',
  'This is the same reasoning an architect or a carpenter uses when checking that a roof''s two opposite support angles produce identical slope ratios, before cutting timber to the exact same length on both sides.',
  'published'
from public.lessons l
where l.topic_id = (select t.id from public.topics t join public.curricula c on c.id = t.curriculum_id where c.subject = 'Mathematics' and t.class_level = 'SS3' and t.term = 1 and t.order_index = 103)
order by l.created_at desc limit 1;

insert into public.questions (topic_id, lesson_id, question_text, question_latex, option_a, option_b, option_c, option_d, option_e, correct_letter, difficulty, exam_type, explanation, exam_shortcut, status)
select t.id, l.id, v.question_text, v.question_latex, v.option_a, v.option_b, v.option_c, v.option_d, v.option_e, v.correct_letter::char(1), v.difficulty::integer, v.exam_type::exam_type, v.explanation, v.exam_shortcut, 'published'
from public.topics t
join public.curricula c on c.id = t.curriculum_id
join public.lessons l on l.topic_id = t.id
cross join (values
  ('Evaluate exactly: $\sin^2 30^\circ + \cos^2 30^\circ$.', null::text, '1', '0', '1/2', '√3/2', null::text, 'A', 1, 'GENERAL', 'This is the identity $\sin^2\theta+\cos^2\theta=1$ for any angle, so the value is 1 regardless of the angle.', null::text),
  ('Find the exact value of $\tan60^\circ \times \cos30^\circ$.', null::text, '3/2', '√3', '1/2', '3', null::text, 'A', 2, 'GENERAL', '$\sqrt3\times\dfrac{\sqrt3}{2}=\dfrac{3}{2}$.', null::text),
  ('Simplify: $(\sin45^\circ + \cos45^\circ)^2$.', null::text, '2', '1', '√2', '1/2', null::text, 'A', 2, 'GENERAL', '$\left(\dfrac{\sqrt2}{2}+\dfrac{\sqrt2}{2}\right)^2=(\sqrt2)^2=2$.', null::text),
  ('Solve for $x$ ($0^\circ \le x \le 90^\circ$): $2\sin x = 1$.', null::text, 'x = 30°', 'x = 60°', 'x = 45°', 'x = 90°', null::text, 'A', 2, 'GENERAL', '$\sin x=1/2 \Rightarrow x=30^\circ$ (the acute angle whose sine is $1/2$).', null::text),
  ('Evaluate: $\sin30^\circ\cos60^\circ - \cos30^\circ\sin60^\circ$.', null::text, '-1/2', '1/2', '-√3/2', '0', null::text, 'A', 3, 'GENERAL', '$\left(\dfrac12\right)\left(\dfrac12\right)-\left(\dfrac{\sqrt3}{2}\right)\left(\dfrac{\sqrt3}{2}\right)=\dfrac14-\dfrac34=-\dfrac12$ (this is the compound-angle identity $\sin(A-B)$ with $A=30^\circ,B=60^\circ$, giving $\sin(-30^\circ)=-1/2$).', null::text),
  ('For the graph of $y=\sin x$, $0^\circ \le x \le 360^\circ$, what is the maximum value of $y$ and at what value of $x$ does it occur?', null::text, 'Maximum 1 at x = 90°', 'Maximum 1 at x = 180°', 'Maximum 2 at x = 90°', 'Maximum 1 at x = 0°', null::text, 'A', 2, 'GENERAL', 'The sine curve rises from 0 at $x=0^\circ$ to its peak value of 1 at $x=90^\circ$, then falls back down, so the maximum is 1, reached at $x=90^\circ$.', null::text),
  ('Use a graph to solve $\cos x = 0$ for $0^\circ \le x \le 360^\circ$.', null::text, 'x = 90° or 270°', 'x = 0° or 180°', 'x = 45° or 225°', 'x = 90° only', null::text, 'A', 2, 'GENERAL', 'The cosine curve crosses zero at $x=90^\circ$ and $x=270^\circ$ within this range.', null::text),
  ('If $\tan\theta = \sqrt3$ and $\theta$ is acute, find $\sin\theta$ and $\cos\theta$.', null::text, 'sinθ = √3/2, cosθ = 1/2', 'sinθ = 1/2, cosθ = √3/2', 'sinθ = √3/2, cosθ = √3/2', 'sinθ = 1, cosθ = 0', null::text, 'A', 3, 'GENERAL', '$\tan\theta=\sqrt3$ corresponds to $\theta=60^\circ$, where $\sin60^\circ=\sqrt3/2$ and $\cos60^\circ=1/2$.', null::text),
  ('Evaluate $\sin^2 45^\circ + \cos^2 60^\circ - \tan^2 30^\circ$.', null::text, '5/12', '1/2', '7/12', '1', null::text, 'A', 3, 'GENERAL', '$\dfrac12+\dfrac14-\dfrac13$: common denominator 12 gives $\dfrac{6}{12}+\dfrac{3}{12}-\dfrac{4}{12}=\dfrac{5}{12}$.', null::text),
  ('Find the exact value of $\dfrac{\sin30^\circ + \cos60^\circ}{\tan45^\circ}$.', null::text, '1', '1/2', '2', '√3', null::text, 'A', 2, 'GENERAL', '$\dfrac{1/2+1/2}{1}=\dfrac{1}{1}=1$.', null::text),
  ('Simplify: $2\sin60^\circ\cos30^\circ - \sin90^\circ$.', null::text, '1/2', '1/4', '3/2', '0', null::text, 'A', 3, 'GENERAL', '$2\left(\dfrac{\sqrt3}{2}\right)\left(\dfrac{\sqrt3}{2}\right)-1=\dfrac32-1=\dfrac12$. (Corrected: the source''s own working shows this same computation reaching 1/2 but mislabels the final answer as 1/4.)', null::text),
  ('Solve for $\theta$ ($0^\circ \le \theta \le 360^\circ$): $\sin\theta = \dfrac{\sqrt2}{2}$.', null::text, 'θ = 45° or 135°', 'θ = 45° or 225°', 'θ = 60° or 120°', 'θ = 45° only', null::text, 'A', 2, 'GENERAL', 'Sine is positive in Quadrants 1 and 2: reference angle $45^\circ$ gives $\theta=45^\circ$ (Q1) or $\theta=180^\circ-45^\circ=135^\circ$ (Q2).', null::text),
  ('Solve: $2\cos\theta - 1 = 0$ for $0^\circ \le \theta \le 360^\circ$.', null::text, 'θ = 60° or 300°', 'θ = 60° or 120°', 'θ = 30° or 330°', 'θ = 60° or 240°', null::text, 'A', 2, 'GENERAL', '$\cos\theta=1/2$; cosine is positive in Q1 and Q4: $\theta=60^\circ$ (Q1) or $\theta=360^\circ-60^\circ=300^\circ$ (Q4).', null::text),
  ('Find all values of $x$ ($0^\circ \le x \le 360^\circ$) for which $\tan x = \dfrac{1}{\sqrt3}$.', null::text, 'x = 30° or 210°', 'x = 30° or 150°', 'x = 60° or 240°', 'x = 30° or 330°', null::text, 'A', 3, 'GENERAL', 'Tangent is positive in Q1 and Q3: reference angle $30^\circ$ gives $x=30^\circ$ (Q1) or $x=180^\circ+30^\circ=210^\circ$ (Q3).', null::text),
  ('Simplify: $\tan60^\circ - \tan30^\circ$.', null::text, '2√3/3', '√3', '√3/3', '4√3/3', null::text, 'A', 3, 'GENERAL', '$\sqrt3-\dfrac{\sqrt3}{3}=\dfrac{3\sqrt3-\sqrt3}{3}=\dfrac{2\sqrt3}{3}$.', null::text),
  ('Evaluate: $\sin30^\circ\cos60^\circ + \cos30^\circ\sin60^\circ$.', null::text, '1', '1/2', '√3/2', '0', null::text, 'A', 3, 'GENERAL', '$\left(\dfrac12\right)\left(\dfrac12\right)+\left(\dfrac{\sqrt3}{2}\right)\left(\dfrac{\sqrt3}{2}\right)=\dfrac14+\dfrac34=1$ (this is $\sin(A+B)$ with $A=30^\circ,B=60^\circ$, giving $\sin90^\circ=1$).', null::text),
  ('Simplify: $(\sin60^\circ - \cos60^\circ)^2$.', null::text, '(2 - √3)/2', '(2 + √3)/2', '1/4', '1', null::text, 'A', 3, 'GENERAL', '$\left(\dfrac{\sqrt3}{2}-\dfrac12\right)^2=\dfrac34-2\left(\dfrac{\sqrt3}{2}\right)\left(\dfrac12\right)+\dfrac14=1-\dfrac{\sqrt3}{2}=\dfrac{2-\sqrt3}{2}$.', null::text),
  ('Solve for $x$: $2\cos x = \sqrt3$, where $0^\circ \le x \le 90^\circ$.', null::text, 'x = 30°', 'x = 60°', 'x = 45°', 'x = 15°', null::text, 'A', 2, 'GENERAL', '$\cos x=\sqrt3/2 \Rightarrow x=30^\circ$.', null::text),
  ('Evaluate: $\sin^2 30^\circ + \sin^2 45^\circ + \sin^2 60^\circ$.', null::text, '3/2', '1', '2', '5/4', null::text, 'A', 3, 'GENERAL', '$\dfrac14+\dfrac12+\dfrac34=\dfrac{1+2+3}{4}=\dfrac64=\dfrac32$.', null::text),
  ('Find the exact value of $\tan45^\circ + 2\sin30^\circ - \cos60^\circ$.', null::text, '3/2', '1', '2', '1/2', null::text, 'A', 3, 'GENERAL', '$1+2\left(\dfrac12\right)-\dfrac12=1+1-\dfrac12=\dfrac32$.', null::text),
  ('Use a graph to solve $\sin x = 0.5$ for $0^\circ \le x \le 360^\circ$.', null::text, 'x = 30° or 150°', 'x = 30° or 210°', 'x = 60° or 120°', 'x = 30° only', null::text, 'A', 2, 'GENERAL', 'Sine is positive in Q1 and Q2: reference angle $30^\circ$ gives $x=30^\circ$ or $x=180^\circ-30^\circ=150^\circ$.', null::text),
  ('Solve $\cos x = 0.5$ for $0^\circ \le x \le 360^\circ$.', null::text, 'x = 60° or 300°', 'x = 60° or 120°', 'x = 30° or 330°', 'x = 60° or 240°', null::text, 'A', 2, 'GENERAL', 'Cosine is positive in Q1 and Q4: reference angle $60^\circ$ gives $x=60^\circ$ or $x=360^\circ-60^\circ=300^\circ$.', null::text),
  ('Solve graphically: $\sin x = \dfrac{\sqrt3}{2}$ for $0^\circ \le x \le 360^\circ$.', null::text, 'x = 60° or 120°', 'x = 30° or 150°', 'x = 60° or 240°', 'x = 60° only', null::text, 'A', 2, 'GENERAL', 'Sine is positive in Q1 and Q2: reference angle $60^\circ$ gives $x=60^\circ$ or $x=180^\circ-60^\circ=120^\circ$.', null::text),
  ('Evaluate $\dfrac{\sin60^\circ - \sin30^\circ}{\cos30^\circ - \cos60^\circ}$.', null::text, '1', '√3', '1/2', '√3/2', null::text, 'A', 4, 'GENERAL', 'Numerator $=\dfrac{\sqrt3}{2}-\dfrac12=\dfrac{\sqrt3-1}{2}$; denominator $=\dfrac{\sqrt3}{2}-\dfrac12=\dfrac{\sqrt3-1}{2}$; the two are identical, so the ratio is 1. (Corrected: the source claims this ratio equals $\sqrt3$, but direct computation shows numerator and denominator are equal, giving 1.)', null::text),
  ('Solve graphically: $2x + 3 = 0$.', null::text, 'x = -1.5', 'x = 1.5', 'x = -3', 'x = 3', null::text, 'A', 1, 'GENERAL', '$2x=-3 \Rightarrow x=-1.5$.', null::text),
  ('Solve simultaneously using graphs: $y = 2x + 1$, $y = -x + 4$.', null::text, 'x = 1, y = 3', 'x = 3, y = 1', 'x = 2, y = 5', 'x = -1, y = -1', null::text, 'A', 2, 'GENERAL', '$2x+1=-x+4 \Rightarrow 3x=3 \Rightarrow x=1$, then $y=2(1)+1=3$.', null::text)
) as v(question_text, question_latex, option_a, option_b, option_c, option_d, option_e, correct_letter, difficulty, exam_type, explanation, exam_shortcut)
where c.subject = 'Mathematics' and t.class_level = 'SS3' and t.term = 1 and t.order_index = 103;

-- ------------------------------------------
-- 104. MATRICES AND DETERMINANTS  -  SS3 Mathematics, Term 1
-- ------------------------------------------


with lesson as (
  insert into public.lessons (topic_id, title, summary, content_body, order_index)
  values (
    (select t.id from public.topics t join public.curricula c on c.id = t.curriculum_id where c.subject = 'Mathematics' and t.class_level = 'SS3' and t.term = 1 and t.order_index = 104),
    'Matrices, Determinants, and Inverses',
    'Matrix operations (addition, scalar multiplication, multiplication), finding determinants and inverses of 2x2 (and 3x3) matrices, and solving simultaneous equations using matrices.',
    '## Matrices and Determinants

**Glossary**
- **Matrix:** a rectangular array of numbers arranged in rows and columns, for example $\begin{pmatrix}1 & 2\\ 3 & 4\end{pmatrix}$.
- **Order of a matrix:** its size, written rows $\times$ columns. A matrix with 2 rows and 3 columns has order $2\times3$.
- **Determinant:** a single number calculated from a square matrix, written $\det A$ or $|A|$, that tells us whether the matrix has an inverse.
- **Singular matrix:** a square matrix whose determinant is 0, it has no inverse.
- **Identity matrix ($I$):** a square matrix with 1s on the main diagonal and 0s elsewhere, e.g. $\begin{pmatrix}1&0\\0&1\end{pmatrix}$; multiplying any matrix by $I$ leaves it unchanged.

**Operations**
- **Addition/subtraction:** only for matrices of the same order, add or subtract corresponding entries.
- **Scalar multiplication:** multiply every entry by the scalar.
- **Matrix multiplication:** $A_{(m\times n)} \cdot B_{(p\times q)}$ is only defined when $n = p$; each entry of the result is (a row of $A$) dotted with (a column of $B$). Matrix multiplication is **not commutative**: $AB \neq BA$ in general.
- **Transpose ($A^T$):** interchange rows and columns.

**Determinant of a 2x2 matrix.** For $A=\begin{pmatrix}a&b\\c&d\end{pmatrix}$: $\det A = ad - bc$ ("cross-multiply and subtract").

**Determinant of a 3x3 matrix** (cofactor expansion along the first row), for $A=\begin{pmatrix}a&b&c\\d&e&f\\g&h&i\end{pmatrix}$: $\det A = a(ei-fh) - b(di-fg) + c(dh-eg)$.

**Inverse of a 2x2 matrix.** For $A=\begin{pmatrix}a&b\\c&d\end{pmatrix}$ with $\det A \neq 0$: $A^{-1} = \dfrac{1}{\det A}\begin{pmatrix}d&-b\\-c&a\end{pmatrix}$ ("swap the diagonal entries, negate the off-diagonal entries, divide everything by the determinant").

**Solving simultaneous equations with matrices.** Write the system as $AX=B$, then $X = A^{-1}B$.',
    1
  )
  returning id
)
insert into public.worked_examples (lesson_id, title, problem_statement, solution_steps, exam_shortcut, common_trap_warning, real_life_context, status)
select id,
  'Determinant of a 3x3 Matrix by Cofactor Expansion',
  'Find the determinant of $A = \begin{pmatrix}2&1&3\\0&4&5\\1&2&1\end{pmatrix}$ by cofactor expansion along the first row.',
  to_jsonb(array[
    'Write the cofactor expansion formula: for $\begin{pmatrix}a&b&c\\d&e&f\\g&h&i\end{pmatrix}$, $|A| = a(ei-fh) - b(di-fg) + c(dh-eg)$.',
    'Identify each entry: $a=2, b=1, c=3, d=0, e=4, f=5, g=1, h=2, i=1$.',
    'Compute the three $2\times2$ sub-determinants: $(ei-fh)=(4)(1)-(5)(2)=4-10=-6$; $(di-fg)=(0)(1)-(5)(1)=-5$; $(dh-eg)=(0)(2)-(4)(1)=-4$.',
    'Substitute into the formula: $|A| = 2(-6) - 1(-5) + 3(-4) = -12+5-12$.',
    'Add the results: $-12+5-12=-19$.',
    'Answer: $|A| = -19$.'
  ]),
  'For 3x3 determinants, cofactor-expand along the row or column with the MOST zeros, every zero entry eliminates an entire $2\times2$ sub-determinant calculation, cutting the work roughly in half.',
  null::text,
  null::text,
  'published'
from lesson;

insert into public.worked_examples (lesson_id, title, problem_statement, solution_steps, exam_shortcut, common_trap_warning, real_life_context, status)
select l.id,
  'Finding the Inverse of a 2x2 Matrix',
  'Find the inverse of $A = \begin{pmatrix}4&5\\2&3\end{pmatrix}$.',
  to_jsonb(array[
    'Compute the determinant first, since it is needed before anything else and confirms whether the inverse exists: $\det A = 4(3)-5(2)=12-10=2$. Since $\det A \neq 0$, $A$ is non-singular and the inverse exists.',
    'Form the adjugate matrix by swapping the two diagonal entries and negating the two off-diagonal entries: $\begin{pmatrix}d&-b\\-c&a\end{pmatrix} = \begin{pmatrix}3&-5\\-2&4\end{pmatrix}$.',
    'Divide every entry of the adjugate by the determinant: $A^{-1} = \dfrac{1}{2}\begin{pmatrix}3&-5\\-2&4\end{pmatrix}$.',
    'Distribute the $\dfrac12$ to each entry: $A^{-1} = \begin{pmatrix}3/2 & -5/2\\ -1 & 2\end{pmatrix}$.',
    'Answer: $A^{-1} = \begin{pmatrix}3/2 & -5/2\\ -1 & 2\end{pmatrix}$ (check: multiplying $A \cdot A^{-1}$ should give the identity matrix).'
  ]),
  'The 2x2 inverse "swap-and-negate" pattern (swap the diagonal entries, negate the off-diagonal entries, then divide everything by the determinant) is the single most-repeated matrix skill on exams, practise it as one fluid motion.',
  'Check a computed inverse instantly by multiplying $A \cdot A^{-1}$: if the result is not the identity matrix $\begin{pmatrix}1&0\\0&1\end{pmatrix}$, an arithmetic error has been made somewhere, this catch costs seconds but saves the whole mark.',
  null::text,
  'published'
from public.lessons l
where l.topic_id = (select t.id from public.topics t join public.curricula c on c.id = t.curriculum_id where c.subject = 'Mathematics' and t.class_level = 'SS3' and t.term = 1 and t.order_index = 104)
order by l.created_at desc limit 1;

insert into public.worked_examples (lesson_id, title, problem_statement, solution_steps, exam_shortcut, common_trap_warning, real_life_context, status)
select l.id,
  'Solving Simultaneous Equations Using Matrices',
  'Solve $2x + y = 5$, $x + 3y = 8$ using matrices.',
  to_jsonb(array[
    'Write the system in matrix form $AX=B$: $\begin{pmatrix}2&1\\1&3\end{pmatrix}\begin{pmatrix}x\\y\end{pmatrix} = \begin{pmatrix}5\\8\end{pmatrix}$.',
    'Find $\det A$: $\det A = (2)(3)-(1)(1)=6-1=5$.',
    'Find $A^{-1}$ using the swap-and-negate rule: $A^{-1} = \dfrac{1}{5}\begin{pmatrix}3&-1\\-1&2\end{pmatrix}$.',
    'Compute $X = A^{-1}B$ by multiplying the inverse matrix by the column vector $B$: $X = \dfrac{1}{5}\begin{pmatrix}3&-1\\-1&2\end{pmatrix}\begin{pmatrix}5\\8\end{pmatrix}$.',
    'Carry out the matrix-vector multiplication (row times column, sum the products): top entry $=3(5)+(-1)(8)=15-8=7$; bottom entry $=(-1)(5)+2(8)=-5+16=11$.',
    'Multiply both entries by $\dfrac15$: $x=\dfrac75$, $y=\dfrac{11}{5}$.',
    'Answer: $x=1.4$, $y=2.2$ (check: $2(1.4)+2.2=5$ correct; $1.4+3(2.2)=8$ correct).'
  ]),
  'For "solve simultaneous equations by matrices" questions, sanity-check the final $(x,y)$ answer by substituting back into BOTH original equations, a wrong sign anywhere in the inverse calculation shows up immediately as a failed check.',
  'Before inverting a matrix, always compute the determinant first and check it is not zero, a matrix with $\det=0$ is singular and has no inverse, spotting this immediately avoids wasted work trying to invert an impossible matrix.',
  'This is the same method a cooperative society''s treasurer could use to solve two linked contribution equations at once (for example total naira contributed and a ratio between two categories of contributors) rather than guessing and checking.',
  'published'
from public.lessons l
where l.topic_id = (select t.id from public.topics t join public.curricula c on c.id = t.curriculum_id where c.subject = 'Mathematics' and t.class_level = 'SS3' and t.term = 1 and t.order_index = 104)
order by l.created_at desc limit 1;

insert into public.questions (topic_id, lesson_id, question_text, question_latex, option_a, option_b, option_c, option_d, option_e, correct_letter, difficulty, exam_type, explanation, exam_shortcut, status)
select t.id, l.id, v.question_text, v.question_latex, v.option_a, v.option_b, v.option_c, v.option_d, v.option_e, v.correct_letter::char(1), v.difficulty::integer, v.exam_type::exam_type, v.explanation, v.exam_shortcut, 'published'
from public.topics t
join public.curricula c on c.id = t.curriculum_id
join public.lessons l on l.topic_id = t.id
cross join (values
  ('State the order of the matrices: (a) $\begin{pmatrix}1&2&3\\4&5&6\end{pmatrix}$ (b) $\begin{pmatrix}2\\5\\7\end{pmatrix}$.', null::text, '(a) 2×3 (b) 3×1', '(a) 3×2 (b) 1×3', '(a) 2×3 (b) 1×3', '(a) 3×2 (b) 3×1', null::text, 'A', 1, 'GENERAL', 'Order is rows × columns: (a) has 2 rows, 3 columns; (b) has 3 rows, 1 column.', null::text),
  ('Given $A=\begin{pmatrix}2&3\\1&5\end{pmatrix}$, $B=\begin{pmatrix}1&4\\2&3\end{pmatrix}$, find (a) $A+B$ (b) $A-B$ (c) $2A$.', null::text, 'A+B=[[3,7],[3,8]]; A-B=[[1,-1],[-1,2]]; 2A=[[4,6],[2,10]]', 'A+B=[[3,7],[3,8]]; A-B=[[1,1],[-1,2]]; 2A=[[2,3],[1,5]]', 'A+B=[[1,-1],[-1,2]]; A-B=[[3,7],[3,8]]; 2A=[[4,6],[2,10]]', 'A+B=[[3,7],[3,8]]; A-B=[[1,-1],[-1,2]]; 2A=[[4,3],[2,5]]', null::text, 'A', 2, 'GENERAL', 'Add/subtract corresponding entries; scalar-multiply every entry by 2.', null::text),
  ('Find $AB$ if $A=\begin{pmatrix}1&2\\3&4\end{pmatrix}$, $B=\begin{pmatrix}3&1\\2&5\end{pmatrix}$.', null::text, '[[7,11],[17,23]]', '[[3,2],[6,20]]', '[[5,7],[11,17]]', '[[7,11],[15,23]]', null::text, 'A', 2, 'GENERAL', 'Row 1: $(1)(3)+(2)(2)=7$, $(1)(1)+(2)(5)=11$. Row 2: $(3)(3)+(4)(2)=17$, $(3)(1)+(4)(5)=23$.', null::text),
  ('Find the transpose of $A=\begin{pmatrix}2&1&3\\4&5&6\end{pmatrix}$.', null::text, '[[2,4],[1,5],[3,6]]', '[[2,1,3],[4,5,6]]', '[[4,2],[5,1],[6,3]]', '[[2,1],[3,4],[5,6]]', null::text, 'A', 1, 'GENERAL', 'Transpose interchanges rows and columns: column 1 of $A$ becomes row 1 of $A^T$, etc.', null::text),
  ('Calculate the determinant $\begin{vmatrix}2&3\\1&4\end{vmatrix}$.', null::text, '5', '11', '8', '-5', null::text, 'A', 1, 'GENERAL', '$\det=ad-bc=(2)(4)-(3)(1)=8-3=5$.', null::text),
  ('Find the determinant $\begin{vmatrix}1&2&3\\0&4&5\\1&2&1\end{vmatrix}$.', null::text, '-8', '0', '8', '-19', null::text, 'A', 3, 'GENERAL', 'Cofactor expansion along row 1: $1(4(1)-5(2))-2(0(1)-5(1))+3(0(2)-4(1))=1(-6)-2(-5)+3(-4)=-6+10-12=-8$. (Corrected: the source states 0, but both cofactor expansion and row-reduction to upper-triangular form confirm -8.)', null::text),
  ('Find the inverse of $A=\begin{pmatrix}3&1\\2&1\end{pmatrix}$.', null::text, '[[1,-1],[-2,3]]', '[[1,-1],[-2,-3]]', '[[-1,1],[2,-3]]', '[[3,-1],[-2,1]]', null::text, 'A', 2, 'GENERAL', '$\det A=3(1)-1(2)=1$; $A^{-1}=\frac{1}{1}\begin{pmatrix}1&-1\\-2&3\end{pmatrix}$.', null::text),
  ('Find the inverse of $B=\begin{pmatrix}1&2\\3&4\end{pmatrix}$.', null::text, '[[-2,1],[1.5,-0.5]]', '[[2,-1],[-1.5,0.5]]', '[[4,-2],[-3,1]]', '[[-2,-1],[-1.5,-0.5]]', null::text, 'A', 3, 'GENERAL', '$\det B=1(4)-2(3)=-2$; $B^{-1}=\frac{1}{-2}\begin{pmatrix}4&-2\\-3&1\end{pmatrix}=\begin{pmatrix}-2&1\\1.5&-0.5\end{pmatrix}$.', null::text),
  ('Solve using matrices: $2x+y=7$, $x+y=4$.', null::text, 'x = 3, y = 1', 'x = 1, y = 3', 'x = 4, y = 0', 'x = 2, y = 2', null::text, 'A', 2, 'GENERAL', 'Subtracting the equations eliminates $y$: $(2x+y)-(x+y)=7-4 \Rightarrow x=3$, then $y=4-3=1$.', null::text),
  ('Identify the type of matrix $\begin{pmatrix}1&0&0\\0&1&0\\0&0&1\end{pmatrix}$.', null::text, 'Identity matrix', 'Zero matrix', 'Diagonal matrix only', 'Scalar matrix of scale 0', null::text, 'A', 1, 'GENERAL', 'A matrix with 1s on the main diagonal and 0s elsewhere is the identity matrix (a special case of a diagonal matrix).', null::text),
  ('Given $A=\begin{pmatrix}2&-1\\0&2\end{pmatrix}$, $B=\begin{pmatrix}3&2\\4&1\end{pmatrix}$, find (a) $2A-3B$ (b) $AB$.', null::text, '(a) [[-5,-8],[-12,1]] (b) [[2,3],[8,2]]', '(a) [[-5,-8],[-12,1]] (b) [[6,-2],[0,2]]', '(a) [[1,4],[-12,7]] (b) [[2,3],[8,2]]', '(a) [[-5,-8],[-12,1]] (b) [[10,3],[8,4]]', null::text, 'A', 3, 'GENERAL', '$2A=[[4,-2],[0,4]]$, $3B=[[9,6],[12,3]]$, so $2A-3B=[[-5,-8],[-12,1]]$. $AB$ row1: $2(3)+(-1)(4)=2$, $2(2)+(-1)(1)=3$; row2: $0(3)+2(4)=8$, $0(2)+2(1)=2$.', null::text),
  ('Find $|A|$ if $A=\begin{pmatrix}4&2\\-3&1\end{pmatrix}$.', null::text, '10', '-2', '4', '-10', null::text, 'A', 2, 'GENERAL', '$\det=4(1)-2(-3)=4+6=10$.', null::text),
  ('Calculate $\begin{vmatrix}2&1&3\\1&0&2\\4&2&1\end{vmatrix}$.', null::text, '5', '-5', '15', '0', null::text, 'A', 3, 'GENERAL', 'Cofactor-expand row 1: $2(0(1)-2(2))-1(1(1)-2(4))+3(1(2)-0(4))=2(-4)-1(-7)+3(2)=-8+7+6=5$.', null::text),
  ('Find the value of $k$ if $\begin{vmatrix}k&2\\3&6\end{vmatrix}=0$.', null::text, 'k = 1', 'k = 2', 'k = 0', 'k = 4', null::text, 'A', 2, 'GENERAL', '$6k-6=0 \Rightarrow k=1$.', null::text),
  ('Find the inverse of $M=\begin{pmatrix}5&3\\2&1\end{pmatrix}$.', null::text, '[[-1,3],[2,-5]]', '[[1,-3],[-2,5]]', '[[1,3],[2,5]]', '[[-1,-3],[-2,-5]]', null::text, 'A', 3, 'GENERAL', '$\det M=5(1)-3(2)=-1$; $M^{-1}=\frac{1}{-1}\begin{pmatrix}1&-3\\-2&5\end{pmatrix}=\begin{pmatrix}-1&3\\2&-5\end{pmatrix}$ (verified: $M\cdot M^{-1}=I$). (Corrected: the source omits dividing by the determinant of -1, leaving the un-negated [[1,-3],[-2,5]].)', null::text),
  ('Find $N^{-1}$ if $N=\begin{pmatrix}4&1\\3&1\end{pmatrix}$.', null::text, '[[1,-1],[-3,4]]', '[[1,1],[3,4]]', '[[-1,1],[3,-4]]', '[[4,-1],[-3,1]]', null::text, 'A', 2, 'GENERAL', '$\det N=4(1)-1(3)=1$; $N^{-1}=\begin{pmatrix}1&-1\\-3&4\end{pmatrix}$.', null::text),
  ('Use matrices to solve: (a) $3x+2y=11$, $2x+y=7$ (b) $x+3y=7$, $2x+y=4$.', null::text, '(a) x=3,y=1 (b) x=1,y=2', '(a) x=1,y=4 (b) x=1,y=2', '(a) x=3,y=1 (b) x=1.4,y=1.2', '(a) x=3,y=1 (b) x=2,y=1', null::text, 'A', 3, 'GENERAL', '(a) From eq2: $y=7-2x$; sub: $3x+2(7-2x)=11 \Rightarrow -x=-3 \Rightarrow x=3,y=1$. (b) From eq2: $y=4-2x$; sub: $x+3(4-2x)=7 \Rightarrow -5x=-5 \Rightarrow x=1,y=2$. (Corrected: part (b)''s first equation is adjusted from "x+3y=5" to "x+3y=7" to reproduce the source''s own stated clean answer.)', null::text),
  ('Determine if $\begin{pmatrix}5&2\\3&1\end{pmatrix}$ is singular.', null::text, 'Non-singular (det = -1)', 'Singular (det = 0)', 'Non-singular (det = 1)', 'Singular (det = -1)', null::text, 'A', 2, 'GENERAL', '$\det=5(1)-2(3)=-1 \neq 0$, so the matrix is non-singular.', null::text),
  ('Given $2x+5y=3$, $8x+7y=5$, express this system in matrix form $AX=B$.', null::text, '[[2,5],[8,7]][x;y]=[3;5]', '[[2,8],[5,7]][x;y]=[3;5]', '[[3,5],[2,8]][x;y]=[5;7]', '[[2,5],[8,7]][x;y]=[5;3]', null::text, 'A', 1, 'GENERAL', 'The coefficients of $x$ and $y$ form matrix $A$ (rows = equations), and the constants form $B$: $\begin{pmatrix}2&5\\8&7\end{pmatrix}\begin{pmatrix}x\\y\end{pmatrix}=\begin{pmatrix}3\\5\end{pmatrix}$.', null::text),
  ('Find $y$ if $\begin{pmatrix}5&-6\\2&-7\end{pmatrix}\begin{pmatrix}x\\y\end{pmatrix}=\begin{pmatrix}17\\-7\end{pmatrix}$.', null::text, 'y = 3', 'y = 7', 'y = -3', 'y = 5', null::text, 'A', 3, 'GENERAL', 'Using Cramer''s rule: $\det A=5(-7)-(-6)(2)=-23$; $y=\frac{5(-7)-17(2)}{-23}=\frac{-35-34}{-23}=\frac{-69}{-23}=3$ (with $x=7$, confirmed by back-substitution: $5(7)-6(3)=17$, $2(7)-7(3)=-7$). (Corrected: the target vector''s first entry is adjusted from -11 to 17 to reproduce the source''s own stated clean answer y=3.)', null::text),
  ('Given $\begin{pmatrix}1&-1\\k&2\end{pmatrix}\begin{pmatrix}2\\1\end{pmatrix} = \begin{pmatrix}1\\-4\end{pmatrix}$, find $k$.', null::text, 'k = -3', 'k = 3', 'k = -1', 'k = 1', null::text, 'A', 3, 'GENERAL', 'Second row of the product: $2k+2(1)=-4 \Rightarrow 2k=-6 \Rightarrow k=-3$. (Reconstructed: the source''s original matrix-equation item is internally inconsistent as transcribed; this clean version reproduces the source''s own stated answer k=-3.)', null::text),
  ('If $\begin{pmatrix}x+y & 3x-y\\ 2x & xy\end{pmatrix} = \begin{pmatrix}6 & 2\\ 4 & 8\end{pmatrix}$, find $x$ and $y$.', null::text, 'x = 2, y = 4', 'x = 4, y = 2', 'x = 3, y = 3', 'x = 2, y = 2', null::text, 'A', 3, 'GENERAL', 'From $2x=4$: $x=2$. From $x+y=6$: $y=4$. Check: $3(2)-4=2$ correct, $xy=8$ correct. (Reconstructed: the source''s original item is garbled/inconsistent as transcribed; this clean version reproduces the source''s own stated answer x=2, y=4.)', null::text),
  ('Find $p$ and $q$ for which $\begin{pmatrix}2p&8\\3&-5q\end{pmatrix}=\begin{pmatrix}8&8\\3&-10\end{pmatrix}$.', null::text, 'p = 4, q = 2', 'p = 6, q = 2', 'p = 4, q = 3', 'p = 2, q = 4', null::text, 'A', 2, 'GENERAL', 'Matching entries: $2p=8 \Rightarrow p=4$; $-5q=-10 \Rightarrow q=2$. (Reconstructed: the source''s right-hand matrix as transcribed is inconsistent with its own stated answer p=4, q=2; this version is consistent.)', null::text),
  ('If the determinant of $\begin{pmatrix}x&4\\-1&2\end{pmatrix}$ is $-6$, find $x$.', null::text, 'x = -5', 'x = -2', 'x = 5', 'x = 2', null::text, 'A', 2, 'GENERAL', '$2x-4(-1)=-6 \Rightarrow 2x+4=-6 \Rightarrow 2x=-10 \Rightarrow x=-5$. (Corrected: the source states x=-2, but substituting confirms only x=-5 satisfies the equation.)', null::text),
  ('If $\begin{pmatrix}5&3\\x&2\end{pmatrix} = \begin{pmatrix}5&3\\5&2\end{pmatrix}$, find $x$.', null::text, 'x = 5', 'x = 3', 'x = 2', 'x = 10/3', null::text, 'A', 1, 'GENERAL', 'Matrix equality requires every entry to match: the (2,1) position gives $x=5$ directly. (Reconstructed as a direct matrix-equality question in place of the source''s garbled "proportion form" wording, reproducing the source''s own stated answer x=5.)', null::text),
  ('If $\begin{pmatrix}3-x&9\\-1&1+2x\end{pmatrix}$ has determinant $0$, find the two possible values of $x$.', null::text, 'x = 4 or x = -3/2', 'x = -4 or x = 3/2', 'x = 4 or x = 3/2', 'x = -4 or x = -3/2', null::text, 'A', 4, 'GENERAL', '$(3-x)(1+2x)+9=0 \Rightarrow -2x^2+5x+12=0 \Rightarrow 2x^2-5x-12=0$; discriminant $=25+96=121$, $\sqrt{121}=11$; $x=\frac{5\pm11}{4}=4$ or $-1.5$.', null::text),
  ('Which of the following is a singular matrix?', null::text, '[[1,0],[0,1]]', '[[2,12],[3,6]]', '[[3,8],[6,16]]', '[[5,2],[3,1]]', null::text, 'C', 3, 'GENERAL', 'A singular matrix has determinant 0. Checking each: A has det 1, B has det $12-36=-24$, D has det $5-6=-1$, but C has det $3(16)-8(6)=48-48=0$, so C is singular. (Rebuilt as a full 4-option question in place of the source''s incomplete option list.)', null::text),
  ('If $X=\begin{pmatrix}5&-3\\-2&2\end{pmatrix}$, find the determinant of $X$.', null::text, '4', '-4', '10', '16', null::text, 'A', 2, 'GENERAL', '$\det X=5(2)-(-3)(-2)=10-6=4$. (Corrected: the source states -4, but direct computation gives 4.)', null::text),
  ('Evaluate $\begin{vmatrix}2&1\\4&6\end{vmatrix}$.', null::text, '8', '4', '2', '-8', null::text, 'A', 1, 'GENERAL', '$\det=2(6)-1(4)=12-4=8$.', null::text),
  ('Given $P=\begin{pmatrix}2&3\\0&1\end{pmatrix}$, find $|-5P + 6I|$.', null::text, '-4', '36', '4', '-36', null::text, 'A', 4, 'GENERAL', '$-5P=[[-10,-15],[0,-5]]$, $6I=[[6,0],[0,6]]$, sum $=[[-4,-15],[0,1]]$; determinant $=(-4)(1)-(-15)(0)=-4$. (Corrected: the source states 36, but direct computation gives -4.)', null::text),
  ('Find the inverse of $P=\begin{pmatrix}2&-1\\1&3\end{pmatrix}$.', null::text, '(1/7)[[3,1],[-1,2]]', '(1/7)[[3,-1],[1,2]]', '(1/5)[[3,1],[-1,2]]', '[[3,1],[-1,2]]', null::text, 'A', 3, 'GENERAL', '$\det P=2(3)-(-1)(1)=7$; $P^{-1}=\frac{1}{7}\begin{pmatrix}3&1\\-1&2\end{pmatrix}$.', null::text),
  ('If $Q=\begin{pmatrix}9&-2\\-7&4\end{pmatrix}$, find $|Q|$.', null::text, '22', '36', '-22', '8', null::text, 'A', 2, 'GENERAL', '$\det Q=9(4)-(-2)(-7)=36-14=22$.', null::text),
  ('If $\begin{pmatrix}-3&x\\3&y\end{pmatrix}$ has determinant $33$, find $x+y$.', null::text, '-11', '11', '30', '-30', null::text, 'A', 3, 'GENERAL', '$\det=(-3)(y)-(x)(3)=-3(x+y)=33 \Rightarrow x+y=-11$.', null::text),
  ('A company''s labour/material requirements are $P=\begin{pmatrix}2&3\\1&2\end{pmatrix}$ (hours and materials per unit of products A and B). If 10 units of A and 15 units of B are produced, find the total labour hours and materials needed.', null::text, '65 labour hours, 40 units of material', '40 labour hours, 65 units of material', '25 labour hours, 50 units of material', '50 labour hours, 25 units of material', null::text, 'A', 3, 'GENERAL', '$\begin{pmatrix}2&3\\1&2\end{pmatrix}\begin{pmatrix}10\\15\end{pmatrix}=\begin{pmatrix}2(10)+3(15)\\1(10)+2(15)\end{pmatrix}=\begin{pmatrix}65\\40\end{pmatrix}$.', null::text)
) as v(question_text, question_latex, option_a, option_b, option_c, option_d, option_e, correct_letter, difficulty, exam_type, explanation, exam_shortcut)
where c.subject = 'Mathematics' and t.class_level = 'SS3' and t.term = 1 and t.order_index = 104;

-- ------------------------------------------
-- 105. LINEAR AND QUADRATIC EQUATIONS  -  SS3 Mathematics, Term 1
-- ------------------------------------------


with lesson as (
  insert into public.lessons (topic_id, title, summary, content_body, order_index)
  values (
    (select t.id from public.topics t join public.curricula c on c.id = t.curriculum_id where c.subject = 'Mathematics' and t.class_level = 'SS3' and t.term = 1 and t.order_index = 105),
    'Solving Simultaneous Linear and Quadratic Equations',
    'Solving a linear equation together with a quadratic equation by substitution, spotting the difference-of-squares shortcut, and reading key features off a quadratic graph.',
    '## Linear and Quadratic Equations

A **linear equation** has the form $y=mx+c$ (a straight-line graph). A **quadratic equation** has the form $y=ax^2+bx+c$, $a \neq 0$ (a parabola graph); $a>0$ opens upward (a "smile"), $a<0$ opens downward (a "frown").

**Glossary**
- **Simultaneous equations:** two (or more) equations that must be solved together, so that the found values satisfy all of them at once.
- **Substitution method:** solving simultaneous equations by expressing one variable in terms of the other from one equation, then plugging that expression into the other equation.
- **Discriminant:** the value $b^2-4ac$ from the quadratic formula. A positive discriminant means two distinct real solutions, zero means exactly one (repeated) solution, and negative means no real solutions.

**Solving a linear and a quadratic equation together (substitution):** express $y$ (or $x$) from the linear equation, and substitute into the quadratic equation, producing a single quadratic in one variable; solve it by factorization or the quadratic formula, then back-substitute for the paired values. Always substitute the LINEAR equation into the quadratic one, never the reverse, since isolating a variable from a linear equation is a one-line rearrangement, while isolating one from a quadratic often forces an unnecessary square root.

**Difference-of-squares shortcut:** whenever both equations only involve $x^2-y^2$ paired with a linear equation in $x$ and $y$, factorize $x^2-y^2=(x-y)(x+y)$ and substitute the already-known value of $(x+y)$ or $(x-y)$ directly, this turns a quadratic-and-simultaneous problem into two simple linear equations.

**Key features of a quadratic graph $y=ax^2+bx+c$:** vertex at $x=-\dfrac{b}{2a}$ (a minimum point if $a>0$, a maximum point if $a<0$); axis of symmetry $x=-\dfrac{b}{2a}$; $y$-intercept at $(0,c)$; $x$-intercepts (roots) found by solving $ax^2+bx+c=0$.',
    1
  )
  returning id
)
insert into public.worked_examples (lesson_id, title, problem_statement, solution_steps, exam_shortcut, common_trap_warning, diagram_type, diagram_data, status)
select id,
  'Line Meets Parabola: Substitution Method',
  'Solve simultaneously: $y = x + 2$ and $y = x^2 - 4$.',
  to_jsonb(array[
    'Since both expressions equal $y$, set them equal to each other: $x+2 = x^2-4$.',
    'Rearrange into standard quadratic form $ax^2+bx+c=0$: $0 = x^2-4-x-2 \Rightarrow x^2-x-6=0$.',
    'Factorize: two numbers that multiply to $-6$ and add to $-1$ are $-3$ and $2$, so $(x-3)(x+2)=0$.',
    'Solve for $x$: $x-3=0 \Rightarrow x=3$, or $x+2=0 \Rightarrow x=-2$.',
    'Back-substitute each $x$-value into the simpler equation $y=x+2$: for $x=3$, $y=3+2=5$; for $x=-2$, $y=-2+2=0$.',
    'Check both points also satisfy $y=x^2-4$: for $(3,5)$, $3^2-4=5$ correct; for $(-2,0)$, $(-2)^2-4=0$ correct.',
    'Answer: the two intersection points are $(3, 5)$ and $(-2, 0)$.'
  ]),
  'Always substitute the LINEAR equation into the QUADRATIC one, never the reverse, and use the discriminant ($b^2-4ac$) as an instant filter for how many intersection points to expect before solving fully: positive means two, zero means one (a tangent line), negative means none.',
  'Always back-check the final $(x,y)$ pair in BOTH original equations, not just the one substituted into, this is the single most effective way to catch a sign error, and it takes only seconds.',
  'coordinate_plane',
  '{"xRange": [-4, 5], "yRange": [-5, 6], "points": [{"x": 3, "y": 5, "label": "(3,5)"}, {"x": -2, "y": 0, "label": "(-2,0)"}], "lines": [{"from": {"x": -4, "y": -2}, "to": {"x": 5, "y": 7}, "label": "y = x + 2"}]}'::jsonb,
  'published'
from lesson;

insert into public.worked_examples (lesson_id, title, problem_statement, solution_steps, exam_shortcut, common_trap_warning, real_life_context, status)
select l.id,
  'The Difference-of-Squares Shortcut',
  'Solve $p + q = 3$ and $p^2 - q^2 = 15$.',
  to_jsonb(array[
    'Recognize $p^2-q^2$ as a difference of two squares and factorize it: $p^2-q^2=(p+q)(p-q)$.',
    'Substitute the known value of $(p+q)$: $(3)(p-q)=15$.',
    'Solve for $(p-q)$: $p-q=15\div3=5$.',
    'Now solve the pair of simpler linear equations $p+q=3$ and $p-q=5$ by adding them (this eliminates $q$): $(p+q)+(p-q)=3+5 \Rightarrow 2p=8 \Rightarrow p=4$.',
    'Substitute $p=4$ back into $p+q=3$: $4+q=3 \Rightarrow q=-1$.',
    'Answer: $p=4$, $q=-1$ (check: $p^2-q^2=16-1=15$ correct).'
  ]),
  'Spot "difference of squares" setups immediately: whenever $x^2-y^2$ (or $p^2-q^2$, $a^2-b^2$, etc.) is paired with a linear equation in the same two letters, factorize and substitute the linear value directly, this is dramatically faster than full substitution.',
  null::text,
  'This is exactly the shortcut a market association''s treasurer could use when told the total of two traders'' daily sales AND the difference of their squared sales figures, going straight to the linear sum and difference is far quicker than an unstructured guess-and-check.',
  'published'
from public.lessons l
where l.topic_id = (select t.id from public.topics t join public.curricula c on c.id = t.curriculum_id where c.subject = 'Mathematics' and t.class_level = 'SS3' and t.term = 1 and t.order_index = 105)
order by l.created_at desc limit 1;

insert into public.worked_examples (lesson_id, title, problem_statement, solution_steps, exam_shortcut, common_trap_warning, real_life_context, status)
select l.id,
  'A Rectangular Garden: Setting Up a Quadratic from Words',
  'A rectangular garden has a length 3 m more than its width, and its area is 40 m^2. Find the dimensions.',
  to_jsonb(array[
    'Let the width be $x$ metres. Since the length is 3 m more than the width, the length is $x+3$ metres.',
    'Write the area equation: length $\times$ width $=$ area, so $x(x+3)=40$.',
    'Expand and rearrange into standard quadratic form: $x^2+3x-40=0$.',
    'Factorize: two numbers multiplying to $-40$ and adding to $3$ are $8$ and $-5$, so $(x+8)(x-5)=0$.',
    'Solve for $x$: $x=-8$ (rejected, a width cannot be negative) or $x=5$.',
    'Find the length: length $=x+3=5+3=8$.',
    'Answer: width $=5$ m, length $=8$ m (check: $5\times8=40$ correct).'
  ]),
  'For rectangle-dimension word problems ("length is $k$ more than width, area is $A$"), let width $=x$, length $=x+k$, and go straight to $x(x+k)=A \Rightarrow x^2+kx-A=0$, this standard setup avoids re-deriving the equation from scratch every time.',
  'Always reject a negative solution for a physical length or width measurement, a quadratic will often produce one valid and one impossible root, and only the positive one is the real-world answer.',
  'This is exactly how a landowner or a builder in Nigeria works out the actual length and width of a plot of land from an agent''s stated area and a stated relationship between the two sides, before fencing or pricing it.',
  'published'
from public.lessons l
where l.topic_id = (select t.id from public.topics t join public.curricula c on c.id = t.curriculum_id where c.subject = 'Mathematics' and t.class_level = 'SS3' and t.term = 1 and t.order_index = 105)
order by l.created_at desc limit 1;

insert into public.questions (topic_id, lesson_id, question_text, question_latex, option_a, option_b, option_c, option_d, option_e, correct_letter, difficulty, exam_type, explanation, exam_shortcut, status)
select t.id, l.id, v.question_text, v.question_latex, v.option_a, v.option_b, v.option_c, v.option_d, v.option_e, v.correct_letter::char(1), v.difficulty::integer, v.exam_type::exam_type, v.explanation, v.exam_shortcut, 'published'
from public.topics t
join public.curricula c on c.id = t.curriculum_id
join public.lessons l on l.topic_id = t.id
cross join (values
  ('Solve simultaneously: $y=x+3$, $y=x^2+x-2$.', null::text, '(√5, √5+3) and (-√5, 3-√5)', '(-1, 2) and (1, 4)', '(√5, √5+3) and (-√5, -√5+3) only for x>0', '(2, 5) and (-2, 1)', null::text, 'A', 4, 'GENERAL', '$x+3=x^2+x-2 \Rightarrow x^2-5=0 \Rightarrow x=\pm\sqrt5$, giving points $(\sqrt5, \sqrt5+3)$ and $(-\sqrt5, 3-\sqrt5)$. (Corrected: the source''s stated point (-1,2) does not satisfy $y=x^2+x-2$, which gives -2 at x=-1, not 2; the exact solutions are x=±√5.)', null::text),
  ('Solve algebraically: $y=2x-1$, $y=x^2-3$.', null::text, 'x = 1 ± √3', 'x = 1 ± √2', 'x = -1 ± √3', 'x = 2 ± √3', null::text, 'A', 3, 'GENERAL', '$2x-1=x^2-3 \Rightarrow x^2-2x-2=0 \Rightarrow x=\frac{2\pm\sqrt{4+8}}{2}=1\pm\sqrt3$.', null::text),
  ('Solve: $x+y=6$, $xy=8$.', null::text, 'x=2,y=4 or x=4,y=2', 'x=1,y=5 or x=5,y=1', 'x=3,y=3', 'x=6,y=0 or x=0,y=6', null::text, 'A', 2, 'GENERAL', '$x,y$ are roots of $t^2-6t+8=0 \Rightarrow (t-2)(t-4)=0$, giving 2 and 4.', null::text),
  ('The sum of two numbers is 12 and their product is 35. Find the numbers.', null::text, '5 and 7', '4 and 8', '3 and 9', '6 and 6', null::text, 'A', 2, 'GENERAL', 'Roots of $t^2-12t+35=0 \Rightarrow (t-5)(t-7)=0$, giving 5 and 7.', null::text),
  ('A rectangular garden has length 3 m more than its width; its area is 40 m^2. Find the dimensions.', null::text, 'width 5 m, length 8 m', 'width 4 m, length 10 m', 'width 8 m, length 5 m', 'width 5 m, length 7 m', null::text, 'A', 2, 'GENERAL', '$x(x+3)=40 \Rightarrow x^2+3x-40=0 \Rightarrow (x+8)(x-5)=0 \Rightarrow x=5$, length $=8$.', null::text),
  ('For $y=x^2-6x+5$, find (a) the vertex (b) the axis of symmetry (c) the y-intercept (d) the x-intercepts.', null::text, '(a) (3,-4) (b) x=3 (c) (0,5) (d) (1,0),(5,0)', '(a) (3,4) (b) x=3 (c) (0,-5) (d) (1,0),(5,0)', '(a) (6,-4) (b) x=6 (c) (0,5) (d) (1,0),(5,0)', '(a) (3,-4) (b) x=-3 (c) (0,5) (d) (-1,0),(-5,0)', null::text, 'A', 3, 'GENERAL', 'Vertex $x=-b/2a=6/2=3$, $y=9-18+5=-4$; y-intercept $(0,5)$; roots of $x^2-6x+5=0$ are $(x-1)(x-5)=0 \Rightarrow x=1,5$.', null::text),
  ('Solve: $y=x-2$, $y=x^2-4x+2$.', null::text, 'x = 1 or 4', 'x = -1 or 4', 'x = 1 or -4', 'x = 2 or 4', null::text, 'A', 3, 'GENERAL', '$x-2=x^2-4x+2 \Rightarrow x^2-5x+4=0 \Rightarrow (x-1)(x-4)=0$.', null::text),
  ('If the discriminant of the quadratic formed by combining a line and a curve is negative, how many real points of intersection are there?', null::text, 'None (the line misses the curve)', 'Exactly one (tangent)', 'Exactly two', 'Infinitely many', null::text, 'A', 2, 'GENERAL', 'A negative discriminant means the resulting quadratic has no real roots, so the line and curve never meet.', null::text),
  ('An investor buys shares at ₦x each; the number bought is (80-2x); total investment is ₦800. Find the price per share.', null::text, '₦20', '₦40', '₦10', '₦16', null::text, 'A', 3, 'GENERAL', '$x(80-2x)=800 \Rightarrow 2x^2-80x+800=0 \Rightarrow x^2-40x+400=0 \Rightarrow (x-20)^2=0 \Rightarrow x=20$.', null::text),
  ('Sketch $y=2x$ and $y=x^2-4$ on the same axes; estimate the solutions of $2x=x^2-4$ graphically.', null::text, 'x ≈ 3.24 or x ≈ -1.24', 'x ≈ 2 or x ≈ -2', 'x ≈ 4 or x ≈ -1', 'x ≈ 3 or x ≈ -2', null::text, 'A', 3, 'GENERAL', '$x^2-2x-4=0 \Rightarrow x=\frac{2\pm\sqrt{4+16}}{2}=1\pm\sqrt5 \approx 3.24$ or $-1.24$.', null::text),
  ('Solve: $y=x+1$, $y=x^2-3x+2$.', null::text, 'x = 2 ± √3', 'x = 2 ± √2', 'x = -2 ± √3', 'x = 1 ± √3', null::text, 'A', 3, 'GENERAL', '$x+1=x^2-3x+2 \Rightarrow x^2-4x+1=0 \Rightarrow x=\frac{4\pm\sqrt{16-4}}{2}=2\pm\sqrt3$.', null::text),
  ('Solve: $y=3x-2$, $y=2x^2-x-1$.', null::text, 'x = 1 ± √2/2', 'x = 1 ± √2', 'x = 2 ± √2/2', 'x = -1 ± √2/2', null::text, 'A', 4, 'GENERAL', '$3x-2=2x^2-x-1 \Rightarrow 2x^2-4x+1=0 \Rightarrow x=\frac{4\pm\sqrt{16-8}}{4}=1\pm\frac{\sqrt2}{2}$.', null::text),
  ('Solve: $x-y=2$, $x^2+y^2=10$.', null::text, 'x=3,y=1 or x=-1,y=-3', 'x=1,y=-1 or x=3,y=1', 'x=2,y=0 or x=-2,y=-4', 'x=3,y=1 only', null::text, 'A', 3, 'GENERAL', '$x=y+2$; $(y+2)^2+y^2=10 \Rightarrow 2y^2+4y-6=0 \Rightarrow y^2+2y-3=0 \Rightarrow (y+3)(y-1)=0$, giving $y=-3,x=-1$ or $y=1,x=3$.', null::text),
  ('Solve: $y=2x$, $y=x^2-8$.', null::text, 'x = 4 or -2', 'x = -4 or 2', 'x = 4 or 2', 'x = 8 or -8', null::text, 'A', 3, 'GENERAL', '$2x=x^2-8 \Rightarrow x^2-2x-8=0 \Rightarrow (x-4)(x+2)=0$.', null::text),
  ('The difference between two numbers is 4 and their product is 45. Find the numbers.', null::text, '9 and 5', '7 and 3', '10 and 6', '15 and 11', null::text, 'A', 2, 'GENERAL', 'Let the numbers be $b+4$ and $b$: $(b+4)b=45 \Rightarrow b^2+4b-45=0 \Rightarrow (b+9)(b-5)=0 \Rightarrow b=5$, giving 9 and 5.', null::text),
  ('A rectangular playground has perimeter 36 m and area 80 m^2. Find its dimensions.', null::text, '10 m × 8 m', '12 m × 6 m', '9 m × 9 m', '15 m × 3 m', null::text, 'A', 3, 'GENERAL', 'Length+width$=18$; solving $t^2-18t+80=0$ gives $t=10$ or $8$ (discriminant $=324-320=4$).', null::text),
  ('The sum of a number and its reciprocal is 2.9. Find the number.', null::text, '2.5 or 0.4', '2 or 0.5', '3 or 1/3', '2.9 or 1', null::text, 'A', 3, 'GENERAL', '$x+1/x=2.9 \Rightarrow 10x^2-29x+10=0$; discriminant $=841-400=441$, $\sqrt{441}=21$; $x=\frac{29\pm21}{20}=2.5$ or $0.4$.', null::text),
  ('A ball is thrown upward so that its height (in metres) after $t$ seconds is $h=20t-5t^2$. (i) When does it hit the ground? (ii) What is its maximum height?', null::text, '(i) t=4s (ii) 20m at t=2s', '(i) t=2s (ii) 20m at t=4s', '(i) t=4s (ii) 40m at t=2s', '(i) t=5s (ii) 25m at t=2.5s', null::text, 'A', 3, 'GENERAL', '(i) $20t-5t^2=0 \Rightarrow 5t(4-t)=0 \Rightarrow t=4$ (excluding $t=0$). (ii) Vertex $t=-b/2a=20/10=2$; $h=20(2)-5(4)=20$.', null::text),
  ('A stockbroker bought x shares at (₦200-2x) each, spending a total of ₦4,800 (corrected from a transcription of ₦9,600, since 200x-2x^2=9600 gives a negative discriminant and no real solution). Find x and the price per share.', null::text, 'x=40 (₦120/share) or x=60 (₦80/share)', 'x=48 (₦104/share)', 'x=50 (₦100/share)', 'x=40 (₦80/share) or x=60 (₦120/share)', null::text, 'A', 4, 'GENERAL', '$x(200-2x)=4800 \Rightarrow x^2-100x+2400=0 \Rightarrow x=40$ (price ₦120) or $x=60$ (price ₦80). (The source''s stated total of ₦9,600 is almost certainly a transcription error, since the maximum possible total at x=50 is only ₦5,000; ₦4,800 is used here as the corrected, solvable figure.)', null::text),
  ('On the same axes, $y=x+2$ and $y=x^2-4x$ are drawn; find the solutions to $x+2=x^2-4x$.', null::text, 'x ≈ 5.37 or x ≈ -0.37', 'x ≈ 5 or x ≈ 0', 'x ≈ 4.37 or x ≈ -1.37', 'x ≈ 6 or x ≈ -1', null::text, 'A', 3, 'GENERAL', '$x^2-5x-2=0 \Rightarrow x=\frac{5\pm\sqrt{25+8}}{2}=\frac{5\pm\sqrt{33}}{2}\approx5.37$ or $-0.37$.', null::text),
  ('For $y=-x^2+6x-5$, find (a) the vertex (max or min) (b) the y-intercept (c) the x-intercepts (d) the range of $x$ where $y>0$.', null::text, '(a) (3,4) max (b) (0,-5) (c) (1,0),(5,0) (d) 1<x<5', '(a) (3,-4) min (b) (0,5) (c) (1,0),(5,0) (d) x<1 or x>5', '(a) (3,4) max (b) (0,-5) (c) (-1,0),(-5,0) (d) 1<x<5', '(a) (6,4) max (b) (0,-5) (c) (1,0),(5,0) (d) 1<x<5', null::text, 'A', 3, 'GENERAL', 'Vertex $x=-6/(2(-1))=3$, $y=-9+18-5=4$ (a maximum, since $a=-1<0$); y-intercept $(0,-5)$; roots of $x^2-6x+5=0$ give $x=1,5$; since it opens downward, $y>0$ between the roots, $1<x<5$.', null::text),
  ('The sum of two numbers is 10 and their product is 21. Find the numbers.', null::text, '3 and 7', '4 and 6', '2 and 8', '5 and 5', null::text, 'A', 2, 'GENERAL', 'Roots of $t^2-10t+21=0 \Rightarrow (t-3)(t-7)=0$.', null::text),
  ('A rectangular field has length 5 m more than its width; its area is 84 m^2. Find its dimensions.', null::text, '7 m × 12 m', '6 m × 14 m', '8 m × 10.5 m', '7 m × 17 m', null::text, 'A', 3, 'GENERAL', '$w(w+5)=84 \Rightarrow w^2+5w-84=0$; discriminant $=25+336=361$, $\sqrt{361}=19$; $w=\frac{-5+19}{2}=7$, length $=12$.', null::text),
  ('An investor buys shares at ₦x each; the number bought is (100-x); total investment ₦2,400. Find x and the number of shares.', null::text, 'x=40 (60 shares) or x=60 (40 shares)', 'x=48 (52 shares)', 'x=50 (50 shares)', 'x=24 (76 shares)', null::text, 'A', 3, 'GENERAL', '$x(100-x)=2400 \Rightarrow x^2-100x+2400=0 \Rightarrow (x-40)(x-60)=0$.', null::text),
  ('A trader bought x items for ₦(x^2+2x) and sold them for ₦(3x^2-4x); the profit was ₦140. Find x.', null::text, 'x = 10', 'x = 14', 'x = 7', 'x = 20', null::text, 'A', 3, 'GENERAL', 'Profit $=(3x^2-4x)-(x^2+2x)=2x^2-6x=140 \Rightarrow x^2-3x-70=0$; discriminant $=9+280=289$, $\sqrt{289}=17$; $x=\frac{3+17}{2}=10$.', null::text),
  ('Write the equation whose roots are the x-values at the points of intersection of $y=x^2+x-2$ and $y=x+1$.', null::text, 'x² - 3 = 0', 'x² + x - 3 = 0', 'x² - x - 3 = 0', 'x² + 3 = 0', null::text, 'A', 3, 'GENERAL', '$x^2+x-2=x+1 \Rightarrow x^2-3=0$.', null::text),
  ('The product of two consecutive positive odd numbers is 195. Find the numbers.', null::text, '13 and 15', '11 and 13', '15 and 17', '9 and 11', null::text, 'A', 3, 'GENERAL', 'Let the numbers be $n,n+2$: $n(n+2)=195 \Rightarrow n^2+2n-195=0$; discriminant $=4+780=784$, $\sqrt{784}=28$; $n=\frac{-2+28}{2}=13$.', null::text),
  ('Find two consecutive numbers whose product is 156.', null::text, '12 and 13 (or -13 and -12)', '11 and 12', '13 and 14', '10 and 15', null::text, 'A', 2, 'GENERAL', '$n(n+1)=156 \Rightarrow n^2+n-156=0$; discriminant $=1+624=625$, $\sqrt{625}=25$; $n=\frac{-1+25}{2}=12$ or $n=\frac{-1-25}{2}=-13$.', null::text),
  ('If $y=x^2-4x-10$ and $y=2$, find the values of $x$.', null::text, 'x = 6 or -2', 'x = -6 or 2', 'x = 6 or 2', 'x = -6 or -2', null::text, 'A', 3, 'GENERAL', '$x^2-4x-10=2 \Rightarrow x^2-4x-12=0 \Rightarrow (x-6)(x+2)=0$.', null::text),
  ('If $x-y=3$ and $x^2-y^2=0$, find $x$ and $y$.', null::text, 'x = 3/2, y = -3/2', 'x = 3, y = 0', 'x = 0, y = -3', 'x = -3/2, y = 3/2', null::text, 'A', 3, 'GENERAL', '$(x-y)(x+y)=0$; since $x-y=3\neq0$, we need $x+y=0 \Rightarrow y=-x$. Combined with $x-y=3$: $2x=3 \Rightarrow x=1.5, y=-1.5$.', null::text),
  ('Find $x$ and $y$ such that $y=\dfrac{1}{2}(x^2-3)$ and $x+y=6$.', null::text, 'x=-5,y=11 or x=3,y=3', 'x=5,y=1 or x=-3,y=9', 'x=-5,y=-11 or x=3,y=-3', 'x=5,y=11 or x=-3,y=3', null::text, 'A', 4, 'GENERAL', 'Substituting $y=6-x$: $6-x=\frac12(x^2-3) \Rightarrow 12-2x=x^2-3 \Rightarrow x^2+2x-15=0 \Rightarrow (x+5)(x-3)=0$, giving $x=-5,y=11$ or $x=3,y=3$. (Corrected: the source''s equation has a sign error, "$y=-\frac12(x^2-3)$"; with that sign neither stated point satisfies the system, but flipping the sign to $+\frac12$ makes both points check out exactly.)', null::text)
) as v(question_text, question_latex, option_a, option_b, option_c, option_d, option_e, correct_letter, difficulty, exam_type, explanation, exam_shortcut)
where c.subject = 'Mathematics' and t.class_level = 'SS3' and t.term = 1 and t.order_index = 105;

-- ------------------------------------------
-- 106. SURFACE AREA & VOLUME OF SPHERE AND HEMISPHERICAL SHAPES  -  SS3 Mathematics, Term 1
-- ------------------------------------------


with lesson as (
  insert into public.lessons (topic_id, title, summary, content_body, order_index)
  values (
    (select t.id from public.topics t join public.curricula c on c.id = t.curriculum_id where c.subject = 'Mathematics' and t.class_level = 'SS3' and t.term = 1 and t.order_index = 106),
    'Surface Area and Volume of Spheres and Hemispheres',
    'Calculating the surface area and volume of spheres and hemispheres, including hollow shells and composite solids made from a cylinder with hemispherical ends.',
    '## Surface Area and Volume of Sphere and Hemispherical Shapes

**Glossary**
- **Sphere:** a perfectly round 3D solid, like a football, where every point on the surface is the same distance (the radius) from the centre.
- **Hemisphere:** exactly half of a sphere, like a bowl shape, cut through its centre.
- **Hollow shell:** a solid with material only between an outer (external) radius and an inner (internal) radius, like a rubber ball''s wall or a metal bowl''s wall, with empty space or air inside.

**For a sphere of radius $r$:**
- Surface area $=4\pi r^2$
- Volume $=\dfrac{4}{3}\pi r^3$

**For a hemisphere of radius $r$:**
- Curved surface area $=2\pi r^2$
- Total surface area (curved $+$ flat circular base) $=2\pi r^2+\pi r^2=3\pi r^2$
- Volume $=\dfrac{2}{3}\pi r^3$

**Hollow sphere/hemisphere (external radius $R$, internal radius $r$):**
- Volume of material $=\dfrac{4}{3}\pi(R^3-r^3)$ for a hollow sphere; $\dfrac{2}{3}\pi(R^3-r^3)$ for a hollow hemisphere (bowl shell).
- Total surface area of a hollow sphere $=4\pi(R^2+r^2)$.

**Melt-and-recast shortcut.** Since volume is conserved when a solid is melted and recast into smaller identical solids, the number of small pieces produced $=\left(\dfrac{R}{r}\right)^3$, where $R$ is the original radius and $r$ is each small piece''s radius, this avoids computing both volumes separately and dividing.

**Scaling law.** If a sphere''s radius is scaled by a factor $k$, its surface area scales by $k^2$ and its volume scales by $k^3$.

**Cylinder with hemispherical ends.** The two hemispherical ends of such a composite solid always combine into exactly one full sphere''s worth of curved surface ($4\pi r^2$) and volume ($\dfrac{4}{3}\pi r^3$); the cylinder itself contributes only its curved side ($2\pi rh$) to the total surface area, since its flat ends are covered by the hemispheres.',
    1
  )
  returning id
)
insert into public.worked_examples (lesson_id, title, problem_statement, solution_steps, exam_shortcut, common_trap_warning, real_life_context, status)
select id,
  'Surface Area of a Sphere',
  'Find the surface area of a sphere with radius 7 cm (use $\pi=\frac{22}{7}$).',
  to_jsonb(array[
    'Write down the sphere surface-area formula: $SA=4\pi r^2$.',
    'Substitute $r=7$: $SA=4\times\frac{22}{7}\times7^2$.',
    'Evaluate $7^2$ first: $7^2=49$.',
    'Multiply, cancelling the 7 in the denominator against a factor from 49 (since $49\div7=7$): $4\times\frac{22}{7}\times49=4\times22\times7$.',
    'Complete the multiplication: $4\times22\times7=4\times154=616$.',
    'Answer: $SA=616$ cm^2.'
  ]),
  'Use $\pi=22/7$ whenever the radius or diameter is a multiple of 7 (or 3.5, 10.5, 14, 21, etc.), the 7s cancel cleanly, giving exact or near-exact answers with less rounding error.',
  null::text,
  null::text,
  'published'
from lesson;

insert into public.worked_examples (lesson_id, title, problem_statement, solution_steps, exam_shortcut, common_trap_warning, real_life_context, status)
select l.id,
  'A Hollow Hemispherical Bowl: Cost and Selling Price',
  'A company manufactures hemispherical bowls of internal radius 7 cm, with metal 0.5 cm thick. Find (a) the volume of metal used, (b) the cost at ₦50 per cm^3, and (c) the selling price after adding a 40% profit.',
  to_jsonb(array[
    'Identify the internal and external radii: internal radius $r=7$ cm; external radius $R=7+0.5=7.5$ cm (the thickness adds to the outside).',
    'Write the hollow-hemisphere volume-of-material formula: $V=\dfrac{2}{3}\pi(R^3-r^3)$.',
    'Compute $R^3$ and $r^3$: $R^3=7.5^3=421.875$; $r^3=7^3=343$; difference $=78.875$.',
    'Substitute into the formula with $\pi=\frac{22}{7}$: $V=\dfrac{2}{3}\times\dfrac{22}{7}\times78.875=\dfrac{2\times22\times78.875}{3\times7}=\dfrac{3470.5}{21}\approx165.3$.',
    'Answer (a): $V\approx165.3$ cm^3.',
    'Find the cost at ₦50 per cm^3: Cost $=165.3\times50=₦8{,}265$.',
    'Answer (b): Cost $\approx ₦8{,}265$.',
    'Add a 40% profit to find the selling price: Selling price $=8265\times1.40\approx₦11{,}571$.',
    'Answer (c): Selling price $\approx ₦11{,}571$.'
  ]),
  'Memorize the hemisphere-shell volume formula $\dfrac23\pi(R^3-r^3)$ as "the sphere formula, but with the 4/3 changed to 2/3", mixing up the two factors (using $4/3$ for a hemisphere) is the most common error on hollow-hemisphere questions, and it exactly doubles the correct answer.',
  'Always add the thickness to the internal radius to find the external radius for a bowl described by its INTERNAL radius and wall thickness, not the other way round.',
  'This is exactly how a small manufacturing business in Nigeria (for example, one producing metal or plastic bowls) prices a product: work out the raw-material volume, apply the material cost per cm^3, then add the desired profit margin to set the final ₦ selling price.',
  'published'
from public.lessons l
where l.topic_id = (select t.id from public.topics t join public.curricula c on c.id = t.curriculum_id where c.subject = 'Mathematics' and t.class_level = 'SS3' and t.term = 1 and t.order_index = 106)
order by l.created_at desc limit 1;

insert into public.worked_examples (lesson_id, title, problem_statement, solution_steps, exam_shortcut, common_trap_warning, real_life_context, status)
select l.id,
  'A Composite Solid: Cylinder with Hemispherical Ends',
  'A solid consists of a cylinder with hemispherical ends, radius 3.5 cm, cylindrical length 10 cm (use $\pi=\frac{22}{7}$). Find (a) the total surface area, (b) the total volume.',
  to_jsonb(array[
    'Identify the visible surfaces: the two hemispherical ends contribute curved surface only (their flat faces sit hidden inside the cylinder), and the cylinder contributes only its curved side (its two flat ends are covered by the hemispheres). So $TSA=$ curved surface of cylinder $+$ curved surface of both hemispheres (which together equal one full sphere''s surface).',
    'Compute the cylinder''s curved surface area ($2\pi rh$): $2\times\frac{22}{7}\times3.5\times10=2\times22\times0.5\times10=220$.',
    'Compute the combined curved surface of the two hemispheres (together they form one full sphere''s surface, $4\pi r^2$): $4\times\frac{22}{7}\times3.5^2=4\times\frac{22}{7}\times12.25=4\times22\times1.75=154$.',
    'Add the two surfaces for the total surface area: $220+154=374$.',
    'Answer (a): $TSA=374$ cm^2.',
    'Compute the cylinder''s volume ($\pi r^2 h$): $\frac{22}{7}\times3.5^2\times10=\frac{22}{7}\times122.5=385$.',
    'Compute the combined volume of the two hemispheres (together = one full sphere, $\frac43\pi r^3$): $\frac43\times\frac{22}{7}\times3.5^3=\frac43\times\frac{22}{7}\times42.875\approx179.67$.',
    'Add the cylinder and sphere volumes: $385+179.67=564.67$.',
    'Answer (b): Volume $\approx564.67$ cm^3.'
  ]),
  'Treat "two hemispherical ends" as "one sphere" immediately, for both surface area ($4\pi r^2$) and volume ($\frac43\pi r^3$), this halves the formula-writing on any cylinder-with-hemispherical-ends question.',
  null::text,
  'This is the shape of many real Nigerian water-storage tanks and cooking-gas cylinders, engineers use exactly this "cylinder plus two hemisphere ends" breakdown to calculate how much steel sheeting or paint is needed to cover it.',
  'published'
from public.lessons l
where l.topic_id = (select t.id from public.topics t join public.curricula c on c.id = t.curriculum_id where c.subject = 'Mathematics' and t.class_level = 'SS3' and t.term = 1 and t.order_index = 106)
order by l.created_at desc limit 1;

insert into public.questions (topic_id, lesson_id, question_text, question_latex, option_a, option_b, option_c, option_d, option_e, correct_letter, difficulty, exam_type, explanation, exam_shortcut, status)
select t.id, l.id, v.question_text, v.question_latex, v.option_a, v.option_b, v.option_c, v.option_d, v.option_e, v.correct_letter::char(1), v.difficulty::integer, v.exam_type::exam_type, v.explanation, v.exam_shortcut, 'published'
from public.topics t
join public.curricula c on c.id = t.curriculum_id
join public.lessons l on l.topic_id = t.id
cross join (values
  ('Find the surface area of a sphere with radius 14 cm ($\pi=22/7$).', null::text, '2464 cm²', '1232 cm²', '4928 cm²', '616 cm²', null::text, 'A', 2, 'GENERAL', '$SA=4\times\frac{22}{7}\times14^2=4\times22\times28=2464$ cm².', null::text),
  ('Calculate the volume of a sphere with diameter 12 cm ($\pi=3.142$).', null::text, '≈904.9 cm³', '≈452.4 cm³', '≈1809.6 cm³', '≈339.1 cm³', null::text, 'A', 2, 'GENERAL', 'Radius $=6$ cm; $V=\frac43(3.142)(6)^3=\frac43(3.142)(216)\approx904.9$ cm³.', null::text),
  ('A sphere has surface area 616 cm²; find its radius ($\pi=22/7$).', null::text, '7 cm', '14 cm', '3.5 cm', '10 cm', null::text, 'A', 2, 'GENERAL', '$r^2=616\div(4\times22/7)=616\times7/88=49 \Rightarrow r=7$.', null::text),
  ('Find the curved surface area of a hemisphere with radius 10.5 cm ($\pi=22/7$).', null::text, '693 cm²', '346.5 cm²', '1039.5 cm²', '1155 cm²', null::text, 'A', 2, 'GENERAL', '$2\pi r^2=2\times\frac{22}{7}\times110.25=693$ cm².', null::text),
  ('Calculate the total surface area of a solid hemisphere with radius 7 cm ($\pi=22/7$).', null::text, '462 cm²', '308 cm²', '154 cm²', '616 cm²', null::text, 'A', 2, 'GENERAL', '$3\pi r^2=3\times\frac{22}{7}\times49=462$ cm².', null::text),
  ('Find the volume of a hemisphere with diameter 18 cm ($\pi=3.142$).', null::text, '≈1527.4 cm³', '≈3054.8 cm³', '≈763.7 cm³', '≈2544 cm³', null::text, 'A', 3, 'GENERAL', 'Radius $=9$; $V=\frac23(3.142)(9)^3=\frac23(3.142)(729)\approx1527.4$ cm³.', null::text),
  ('A hollow sphere has external radius 12 cm and internal radius 9 cm; find the volume of material ($\pi=22/7$).', null::text, '≈4186 cm³', '≈5115.8 cm³', '≈2093 cm³', '≈8372 cm³', null::text, 'A', 4, 'GENERAL', '$V=\frac43\pi(R^3-r^3)=\frac43\times\frac{22}{7}\times(1728-729)=\frac43\times\frac{22}{7}\times999\approx4186$ cm³. (Corrected: the source states ≈5115.8, but direct computation gives ≈4186.)', null::text),
  ('How many small balls of radius 2 cm can be made from a sphere of radius 6 cm (by melting and recasting)?', null::text, '27', '9', '18', '54', null::text, 'A', 2, 'GENERAL', 'Number of pieces $=(R/r)^3=(6/2)^3=3^3=27$.', 'Use $(R/r)^3$ directly instead of computing both volumes separately and dividing.'),
  ('A hemispherical bowl has internal diameter 21 cm; find its capacity in cm³ ($\pi=22/7$).', null::text, '≈2425.5 cm³', '≈4851 cm³', '≈1212.75 cm³', '≈808.5 cm³', null::text, 'A', 3, 'GENERAL', 'Radius $=10.5$; $V=\frac23\times\frac{22}{7}\times10.5^3\approx2425.5$ cm³.', null::text),
  ('A spherical water tank has radius 3.5 m; how many litres can it hold? ($\pi=22/7$, 1 m³ = 1000 L)', null::text, '≈179,667 litres', '≈89,833 litres', '≈359,334 litres', '≈17,967 litres', null::text, 'A', 3, 'GENERAL', '$V=\frac43\times\frac{22}{7}\times3.5^3\approx179.667$ m³ $=179{,}667$ litres.', null::text),
  ('Find the surface area and volume of a sphere with radius 21 cm ($\pi=22/7$).', null::text, 'SA=5544 cm², V=38,808 cm³', 'SA=2772 cm², V=19,404 cm³', 'SA=5544 cm², V=19,404 cm³', 'SA=1386 cm², V=9702 cm³', null::text, 'A', 3, 'GENERAL', '$SA=4\times\frac{22}{7}\times441=5544$; $V=\frac43\times\frac{22}{7}\times9261=38{,}808$.', null::text),
  ('A sphere has volume 38,808 cm³; find its radius ($\pi=22/7$).', null::text, '21 cm', '14 cm', '10.5 cm', '7 cm', null::text, 'A', 3, 'GENERAL', '$r^3=38808\times3\times7/(4\times22)=9261 \Rightarrow r=21$ (since $21^3=9261$).', null::text),
  ('Calculate the curved and total surface area of a hemisphere with radius 14 cm ($\pi=22/7$).', null::text, 'curved=1232 cm², total=1848 cm²', 'curved=616 cm², total=924 cm²', 'curved=1232 cm², total=1232 cm²', 'curved=2464 cm², total=3696 cm²', null::text, 'A', 3, 'GENERAL', 'Curved $=2\pi r^2=2\times\frac{22}{7}\times196=1232$; total $=3\pi r^2=1848$.', null::text),
  ('Find the volume of a hemisphere with radius 10.5 cm ($\pi=22/7$).', null::text, '≈2425.5 cm³', '≈4851 cm³', '≈1212.75 cm³', '≈808.5 cm³', null::text, 'A', 3, 'GENERAL', '$V=\frac23\times\frac{22}{7}\times10.5^3\approx2425.5$ cm³.', null::text),
  ('A hollow sphere has external diameter 20 cm and wall thickness 3 cm; find (i) the volume of material (ii) the total surface area ($\pi=22/7$).', null::text, '(i) ≈2753.1 cm³ (ii) ≈1873.4 cm²', '(i) ≈1376.6 cm³ (ii) ≈936.7 cm²', '(i) ≈2753.1 cm³ (ii) ≈936.7 cm²', '(i) ≈5506.2 cm³ (ii) ≈1873.4 cm²', null::text, 'A', 4, 'GENERAL', '$R=10$, $r=10-3=7$. (i) $V=\frac43\times\frac{22}{7}\times(1000-343)\approx2753.1$ cm³. (ii) $TSA=4\pi(R^2+r^2)=4\times\frac{22}{7}\times149\approx1873.4$ cm².', null::text),
  ('A hemispherical bowl has internal radius 12 cm and metal thickness 1 cm; calculate the volume of material used ($\pi=22/7$).', null::text, '≈982.7 cm³', '≈1985.1 cm³', '≈491.4 cm³', '≈1965.4 cm³', null::text, 'A', 4, 'GENERAL', '$R=13$, $r=12$; $V=\frac23\times\frac{22}{7}\times(2197-1728)=\frac23\times\frac{22}{7}\times469\approx982.7$ cm³. (Corrected: the source states ≈1985.1, almost exactly double, consistent with an accidental use of the full-sphere 4/3 factor instead of the hemisphere 2/3 factor.)', null::text),
  ('A spherical balloon''s radius increases from 7 cm to 14 cm. How many times does (i) the surface area (ii) the volume increase?', null::text, '(i) 4 times (ii) 8 times', '(i) 2 times (ii) 2 times', '(i) 2 times (ii) 4 times', '(i) 8 times (ii) 4 times', null::text, 'A', 2, 'GENERAL', 'Scale factor $=2$; surface area scales by $2^2=4$; volume scales by $2^3=8$.', 'Never recompute both surface areas/volumes from scratch for a "how many times bigger" question, use the scaling laws directly.'),
  ('A solid metal sphere of radius 10 cm is melted and recast into smaller spheres of radius 2 cm; how many small spheres form?', null::text, '125', '25', '50', '250', null::text, 'A', 3, 'GENERAL', '$(R/r)^3=(10/2)^3=5^3=125$.', null::text),
  ('A hemispherical tank of internal radius 1.4 m, full of water, is emptied into a cylindrical tank of diameter 2.8 m. Find the height of water in the cylindrical tank.', null::text, '≈0.933 m', '≈1.4 m', '≈0.467 m', '≈1.867 m', null::text, 'A', 4, 'GENERAL', '$V_{hemisphere}=\frac23\pi(1.4)^3$; cylindrical radius is also $1.4$ m; $h=V/(\pi R^2)=\frac23(1.4)=0.933$ m (the radii being equal makes this a direct $\frac23$ scaling).', null::text),
  ('A solid with a cylindrical middle and hemispherical ends has total length 20 cm, radius 3.5 cm, and cylindrical part 13 cm. Find (i) the total surface area (ii) the volume ($\pi=22/7$).', null::text, '(i) 440 cm² (ii) ≈680.2 cm³', '(i) 594 cm² (ii) ≈686.83 cm³', '(i) 440 cm² (ii) ≈500.5 cm³', '(i) 286 cm² (ii) ≈680.2 cm³', null::text, 'A', 4, 'GENERAL', '(i) Curved cylinder $=2\pi rh=2\times\frac{22}{7}\times3.5\times13=286$; two hemisphere ends $=4\pi r^2=154$; total $=440$ cm². (ii) Cylinder volume $=\pi r^2 h=500.5$; sphere-equivalent volume $=\frac43\pi r^3\approx179.67$; total $\approx680.2$ cm³. (Corrected: the source states 594 cm² and ≈686.83 cm³; 594 appears to double-count the sphere''s surface contribution, since 594-440=154 exactly.)', null::text),
  ('A company manufactures hemispherical bowls of internal radius 7 cm, with metal 0.5 cm thick. Find the volume of metal used ($\pi=22/7$).', null::text, '≈165.3 cm³', '≈161.5 cm³', '≈330.6 cm³', '≈82.65 cm³', null::text, 'A', 4, 'GENERAL', 'External radius $=7.5$; $V=\frac23\times\frac{22}{7}\times(421.875-343)\approx165.3$ cm³. (Corrected: the source states ≈161.5 cm³.)', null::text),
  ('A toy is a hemisphere surmounted by a cone; the cone has height 4 cm and base diameter 8 cm. Find the total surface area (excluding the hidden internal base), and the paint needed at 1 mL per 10 cm² ($\pi=22/7$).', null::text, '≈171.7 cm², ≈17.2 mL', '≈201.1 cm², ≈20.1 mL', '≈134 cm², ≈13.4 mL', '≈100.6 cm², ≈10.1 mL', null::text, 'A', 4, 'GENERAL', 'Radius $=4$; cone slant height $l=\sqrt{4^2+4^2}=\sqrt{32}\approx5.657$; curved cone $=\pi rl\approx71.1$; curved hemisphere $=2\pi r^2\approx100.6$; total $\approx171.7$ cm²; paint $\approx17.2$ mL.', null::text),
  ('A toy consists of a hemisphere surmounted by a cone, base radius 7 cm, total height 20 cm. Find the total surface area, ignoring the base ($\pi=22/7$).', null::text, '≈632.7 cm²', '≈316.4 cm²', '≈770 cm²', '≈462 cm²', null::text, 'A', 4, 'GENERAL', 'Cone height $=20-7=13$; slant height $=\sqrt{7^2+13^2}=\sqrt{218}\approx14.76$; curved cone $=\frac{22}{7}(7)(14.76)\approx324.8$; curved hemisphere $=2\times\frac{22}{7}\times49=308$; total $\approx632.7$.', null::text),
  ('A solid consists of a cylinder with hemispherical ends, radius 3.5 cm, cylindrical length 10 cm ($\pi=22/7$). Find (a) the total surface area (b) the volume.', null::text, '(a) 374 cm² (b) ≈564.67 cm³', '(a) 440 cm² (b) ≈680.2 cm³', '(a) 220 cm² (b) ≈385 cm³', '(a) 374 cm² (b) ≈179.67 cm³', null::text, 'A', 4, 'GENERAL', 'Curved cylinder $=220$, curved sphere-equivalent $=154$, total $=374$ cm²; cylinder volume $=385$, sphere-equivalent volume $\approx179.67$, total $\approx564.67$ cm³.', null::text),
  ('A spherical water tank has internal diameter 4.2 m. How many litres can it hold? ($\pi=22/7$)', null::text, '38,808 litres', '19,404 litres', '77,616 litres', '9702 litres', null::text, 'A', 3, 'GENERAL', 'Radius $=2.1$ m $=210$ cm; $V=\frac43\times\frac{22}{7}\times210^3=38{,}808{,}000$ cm³ $=38{,}808$ litres.', null::text),
  ('How many lead balls of radius 1 cm can be made from a sphere of radius 8 cm?', null::text, '512', '64', '256', '128', null::text, 'A', 3, 'GENERAL', '$(8/1)^3=512$.', null::text),
  ('A hemispherical bowl of internal radius 9 cm contains water, poured into cylindrical bottles of diameter 3 cm and height 4 cm. How many bottles are needed ($\pi=22/7$)?', null::text, '54 bottles', '27 bottles', '108 bottles', '18 bottles', null::text, 'A', 4, 'GENERAL', 'Bowl volume $\approx1527.4$ cm³; bottle volume $=\pi(1.5)^2(4)\approx28.29$ cm³; number needed $=1527.4/28.29\approx54$.', null::text),
  ('A metallic sphere of radius 10.5 cm is melted and recast into small cones of radius 3.5 cm, height 3 cm. How many cones form?', null::text, '126', '63', '252', '84', null::text, 'A', 4, 'GENERAL', 'Sphere volume $=\frac43\times\frac{22}{7}\times10.5^3=4851$; cone volume $=\frac13\times\frac{22}{7}\times12.25\times3=38.5$; number $=4851/38.5=126$.', null::text),
  ('A spherical tank of diameter 3 m is filled from a pipe of radius 30 cm at 0.2 m/s. Find the time (in minutes) to fill the tank ($\pi=22/7$).', null::text, '≈4.17 minutes', '≈8.33 minutes', '≈2.08 minutes', '≈16.7 minutes', null::text, 'A', 4, 'GENERAL', 'Tank volume $=\frac43\times\frac{22}{7}\times1.5^3\approx14.14$ m³; pipe flow rate $=\pi(0.3)^2(0.2)\approx0.0566$ m³/s; time $=14.14/0.0566\approx250$ s $\approx4.17$ min.', null::text),
  ('A tap leaks at 2 cm³/s into an empty container of capacity 45 litres. How long will it take to fill it?', null::text, '6 hr 15 min', '3 hr 7.5 min', '12 hr 30 min', '6 hr 45 min', null::text, 'A', 3, 'GENERAL', '$45{,}000\text{ cm}^3\div2\text{ cm}^3/\text{s}=22{,}500$ s $=6.25$ hr $=6$ hr 15 min.', null::text),
  ('What is the capacity of a spherical tank whose diameter is 1.5 m?', null::text, '9π/16 m³', '3π/4 m³', '9π/8 m³', '27π/16 m³', null::text, 'A', 3, 'GENERAL', 'Radius $=0.75$ m; $V=\frac43\pi(0.75)^3=\frac43\pi(0.421875)=\frac{9\pi}{16}$ m³.', null::text),
  ('Find the radius of a sphere, if 3/4 of its volume is 134.75 cm³ ($\pi=22/7$).', null::text, '3.50 cm', '7 cm', '5.25 cm', '2.63 cm', null::text, 'A', 4, 'GENERAL', 'Full volume $=134.75\times4/3\approx179.67$; $r^3=179.67\times3\times7/(4\times22)=42.875 \Rightarrow r=3.5$.', null::text),
  ('What is the volume of a hemisphere of diameter 21 cm ($\pi=22/7$)?', null::text, '2425.5 cm³', '4851 cm³', '1212.75 cm³', '808.5 cm³', null::text, 'A', 3, 'GENERAL', 'Radius $=10.5$; $V=\frac23\times\frac{22}{7}\times10.5^3=2425.5$.', null::text),
  ('The volume of a hemispherical bowl is 718 2/3 cm³. Find its radius ($\pi=22/7$).', null::text, '7.0 cm', '3.5 cm', '10.5 cm', '14 cm', null::text, 'A', 3, 'GENERAL', '$r^3=718.667\times3\times7/(2\times22)=343 \Rightarrow r=7$.', null::text),
  ('Find the radius of a sphere whose surface area is 154 cm² ($\pi=22/7$).', null::text, '3.50 cm', '7 cm', '1.75 cm', '5.25 cm', null::text, 'A', 2, 'GENERAL', '$r^2=154\times7/(4\times22)=12.25 \Rightarrow r=3.5$.', null::text)
) as v(question_text, question_latex, option_a, option_b, option_c, option_d, option_e, correct_letter, difficulty, exam_type, explanation, exam_shortcut)
where c.subject = 'Mathematics' and t.class_level = 'SS3' and t.term = 1 and t.order_index = 106;

-- ------------------------------------------
-- 107. LONGITUDE AND LATITUDE  -  SS3 Mathematics, Term 1
-- ------------------------------------------


with lesson as (
  insert into public.lessons (topic_id, title, summary, content_body, order_index)
  values (
    (select t.id from public.topics t join public.curricula c on c.id = t.curriculum_id where c.subject = 'Mathematics' and t.class_level = 'SS3' and t.term = 1 and t.order_index = 107),
    'Longitude and Latitude: Great Circles and Distances',
    'Understanding the equator, meridians, and parallels of latitude on the Earth as a sphere, and calculating distances along a meridian and along a parallel of latitude.',
    '## Longitude and Latitude

The Earth is (approximately) a sphere, radius $R \approx 6{,}400$ km (some questions use $R=6{,}370$ km instead, always use the value stated in the question).

**Glossary**
- **Equator:** the circle at latitude $0^\circ$, dividing the Earth into Northern and Southern hemispheres.
- **Prime (Greenwich) meridian:** the half-circle at longitude $0^\circ$, dividing the Earth into Eastern and Western hemispheres.
- **Meridian (longitude line):** a great circle passing through both the North and South Poles; every meridian is a great circle.
- **Parallel of latitude:** a circle parallel to the equator; only the equator itself is a great circle among latitude circles, every other parallel is a smaller ("small") circle.
- **Great circle:** any circle drawn on the sphere whose centre is the same as the Earth''s centre, this is the largest possible circle on the sphere and gives the shortest surface path between two points on it.

**Radius of a parallel of latitude $\theta$:** $r=R\cos\theta$ (the radius shrinks by the cosine of the latitude: at the equator, $\theta=0^\circ$ and $\cos0^\circ=1$, so $r=R$; at a pole, $\theta=90^\circ$ and $\cos90^\circ=0$, so $r=0$, a single point).

**Distance along a meridian (a great circle), for an angular (latitude) difference $\theta$:** Distance $=\dfrac{\theta}{360^\circ}\times2\pi R$. Add the two latitudes when the points are on opposite sides of the equator (one North, one South); subtract when they are on the same side.

**Distance along a parallel of latitude (a small circle), for a longitude difference $\theta$, at latitude $\varphi$:** Distance $=\dfrac{\theta}{360^\circ}\times2\pi R\cos\varphi$ (using $r=R\cos\varphi$ in place of $R$). Add the two longitudes when one point is East and the other West; subtract when they are on the same side.

**Deciding which formula to use:** two points sharing the same longitude (on the same meridian) always use the meridian formula with the LATITUDE difference; two points sharing the same latitude (on the same parallel) always use the parallel formula with the LONGITUDE difference.',
    1
  )
  returning id
)
insert into public.worked_examples (lesson_id, title, problem_statement, solution_steps, exam_shortcut, common_trap_warning, diagram_type, diagram_data, status)
select id,
  'Angular Distance Along a Shared Meridian',
  'Find the angular distance between $A(40^\circ N, 65^\circ E)$ and $B(35^\circ S, 65^\circ E)$.',
  to_jsonb(array[
    'Check whether the two points share a meridian (the same longitude): both are at $65^\circ E$, so yes, they lie on the same great-circle meridian, and the angular distance is simply the sum or difference of their latitudes.',
    'Determine whether to add or subtract: $A$ is North ($40^\circ N$) and $B$ is South ($35^\circ S$), opposite sides of the equator, so we ADD.',
    'Add the latitudes: $40^\circ + 35^\circ = 75^\circ$.',
    'Answer: the angular distance between $A$ and $B$ is $75^\circ$.'
  ]),
  '"Same longitude, use latitudes; same latitude, use longitudes" is the fastest way to decide which formula applies. Say "add when on opposite sides, subtract when on the same side" as one sentence before every angular-distance question, this rule applies identically to North/South and East/West.',
  null::text,
  'circle',
  '{"centerLabel": "Earth''s centre", "points": [{"label": "A (40°N)", "angleDegrees": 40}, {"label": "B (35°S)", "angleDegrees": -35}], "highlightSector": {"startAngle": -35, "endAngle": 40, "label": "75°"}}'::jsonb,
  'published'
from lesson;

insert into public.worked_examples (lesson_id, title, problem_statement, solution_steps, exam_shortcut, common_trap_warning, diagram_type, diagram_data, status)
select l.id,
  'Radius and Circumference of a Parallel of Latitude',
  'Find the circumference of the parallel of latitude $30^\circ S$ (use $R=6{,}400$ km, $\pi=\frac{22}{7}$).',
  to_jsonb(array[
    'Find the radius of this parallel using $r=R\cos\theta$: $r=6{,}400\times\cos30^\circ=6{,}400\times\dfrac{\sqrt3}{2}\approx5{,}542.6$ km.',
    'Write the circumference formula for a circle: Circumference $=2\pi r$.',
    'Substitute the radius found in Step 1: Circumference $=2\times\dfrac{22}{7}\times5{,}542.6$.',
    'Multiply step by step: $2\times22=44$; $44\times5{,}542.6\approx243{,}874.4$.',
    'Divide by 7: $243{,}874.4\div7\approx34{,}839.2$.',
    'Answer: the circumference is approximately $34{,}839$ km (the exact figure depends slightly on how many decimal places of $\cos30^\circ$ are used, but any value near $34{,}830$-$34{,}840$ km is correct to 3 significant figures).'
  ]),
  'Quick estimate check: $1^\circ$ along a meridian is approximately 111 km. Multiplying an angular distance by 111 gives a rough cross-check that instantly catches a misplaced decimal point or a wrongly-applied cosine.',
  null::text,
  'circle',
  '{"centerLabel": "O", "points": [{"label": "30°S parallel", "angleDegrees": -30}], "highlightSector": {"startAngle": 0, "endAngle": -30, "label": "r = R cos30°"}}'::jsonb,
  'published'
from public.lessons l
where l.topic_id = (select t.id from public.topics t join public.curricula c on c.id = t.curriculum_id where c.subject = 'Mathematics' and t.class_level = 'SS3' and t.term = 1 and t.order_index = 107)
order by l.created_at desc limit 1;

insert into public.worked_examples (lesson_id, title, problem_statement, solution_steps, exam_shortcut, common_trap_warning, real_life_context, status)
select l.id,
  'Distance Along a Meridian',
  'Find the distance between $A(65^\circ N, 30^\circ E)$ and $B(25^\circ S, 30^\circ E)$ along their common meridian (use $\pi=\frac{22}{7}$, $R=6{,}370$ km).',
  to_jsonb(array[
    'Confirm both points share a meridian: both are at longitude $30^\circ E$, so the shortest path is along this meridian (a great circle), and only the angular difference in latitude is needed.',
    'Find the angular distance $\theta$: $A$ is North ($65^\circ N$), $B$ is South ($25^\circ S$), opposite sides of the equator, so add: $\theta=65^\circ+25^\circ=90^\circ$.',
    'Write the meridian-distance formula: Distance $=\dfrac{\theta}{360^\circ}\times2\pi R$.',
    'Substitute the values: Distance $=\dfrac{90}{360}\times2\times\dfrac{22}{7}\times6{,}370$.',
    'Simplify the fraction $90/360=1/4$ first: Distance $=\dfrac14\times2\times\dfrac{22}{7}\times6{,}370$.',
    'Compute $2\times\dfrac{22}{7}\times6{,}370$: $2\times22=44$; $44\times6{,}370=280{,}280$; $280{,}280\div7=40{,}040$.',
    'Multiply by $\dfrac14$: $40{,}040\div4=10{,}010$.',
    'Answer: $10{,}010$ km.'
  ]),
  'Fractions like $90/360$, $60/360$, $45/360$, $30/360$ simplify to nice values ($1/4$, $1/6$, $1/8$, $1/12$), always simplify $\theta/360^\circ$ to its lowest fraction FIRST before multiplying by $2\pi R$, avoiding large, error-prone intermediate numbers.',
  'Use $\pi=22/7$ whenever $R$ is 6,370 or 6,400 (or another multiple of 7), both standard Earth-radius values were chosen specifically to make $22/7$ cancel cleanly.',
  'This is the same calculation an airline route-planner uses to estimate the shortest possible flight distance between two Nigerian cities (or between Nigeria and a country on a nearby meridian) before accounting for actual flight paths and wind.',
  'published'
from public.lessons l
where l.topic_id = (select t.id from public.topics t join public.curricula c on c.id = t.curriculum_id where c.subject = 'Mathematics' and t.class_level = 'SS3' and t.term = 1 and t.order_index = 107)
order by l.created_at desc limit 1;

insert into public.questions (topic_id, lesson_id, question_text, question_latex, option_a, option_b, option_c, option_d, option_e, correct_letter, difficulty, exam_type, explanation, exam_shortcut, status)
select t.id, l.id, v.question_text, v.question_latex, v.option_a, v.option_b, v.option_c, v.option_d, v.option_e, v.correct_letter::char(1), v.difficulty::integer, v.exam_type::exam_type, v.explanation, v.exam_shortcut, 'published'
from public.topics t
join public.curricula c on c.id = t.curriculum_id
join public.lessons l on l.topic_id = t.id
cross join (values
  ('Define: (a) Equator (b) Meridian (c) Great circle (d) Parallel of latitude.', null::text, 'See teaching notes for all four definitions', 'All four terms mean the same thing', 'Only the equator and meridian are real circles', 'These terms only apply to maps, not the real Earth', null::text, 'A', 1, 'GENERAL', 'The equator is latitude 0°; a meridian is a great circle through both poles; a great circle shares the Earth''s centre; a parallel of latitude is a circle parallel to the equator (only the equator itself is a great circle among them).', null::text),
  ('What are the coordinates of the North Pole?', null::text, '90°N, longitude undefined (or any value)', '0°N, 0°E', '90°N, 0°E only', '180°N, 0°E', null::text, 'A', 1, 'GENERAL', 'At the pole, every meridian meets at a single point, so latitude is 90°N but longitude has no single defined value.', null::text),
  ('Calculate the radius of the parallel of latitude 30°N if Earth''s radius is 6,400 km.', null::text, '≈5,542.6 km', '≈3,200 km', '≈6,400 km', '≈4,525.5 km', null::text, 'A', 2, 'GENERAL', '$r=6400\cos30°=6400\times0.866\approx5542.6$ km.', null::text),
  ('Find the circumference of the parallel of latitude 45°S (R=6,400 km, π=22/7).', null::text, '≈28,449 km', '≈14,225 km', '≈40,229 km', '≈20,114 km', null::text, 'A', 3, 'GENERAL', '$r=6400\cos45°\approx4525.5$; circumference $=2\times\frac{22}{7}\times4525.5\approx28{,}449$ km.', null::text),
  ('Two points are on the same meridian at latitudes 50°N and 20°N. Find the angular distance between them.', null::text, '30°', '70°', '50°', '20°', null::text, 'A', 1, 'GENERAL', 'Same side of the equator (both North), so subtract: $50°-20°=30°$.', null::text),
  ('Find the distance between A(60°N,30°E) and B(20°N,30°E) in km (R=6,400 km, π=22/7).', null::text, '≈4,471 km', '≈8,942 km', '≈2,236 km', '≈4,448 km', null::text, 'A', 3, 'GENERAL', 'Same meridian, same side, subtract: $60-20=40°$. Distance $=\frac{40}{360}\times2\times\frac{22}{7}\times6400\approx4471$ km.', null::text),
  ('Towns P and Q are both on latitude 60°N; P at 40°E, Q at 70°E. Find the distance along the parallel (R=6,400 km, π=22/7).', null::text, '≈1,676 km', '≈838 km', '≈3,352 km', '≈2,236 km', null::text, 'A', 3, 'GENERAL', 'Longitude diff $=30°$; $r=6400\cos60°=3200$; distance $=\frac{30}{360}\times2\times\frac{22}{7}\times3200\approx1676$ km.', null::text),
  ('The radius of a parallel of latitude is 4,800 km; find the latitude (R=6,400 km).', null::text, '≈41.4°', '≈75°', '≈30°', '≈60°', null::text, 'A', 3, 'GENERAL', '$\cos\theta=4800/6400=0.75 \Rightarrow \theta=\cos^{-1}(0.75)\approx41.4°$.', null::text),
  ('What is the approximate distance represented by 1° of latitude along a meridian?', null::text, '≈111 km', '≈60 km', '≈1.852 km', '≈40,000 km', null::text, 'A', 1, 'GENERAL', '$2\pi R/360 \approx 40{,}030/360 \approx 111$ km per degree.', null::text),
  ('Differentiate between a great circle and a small circle on a sphere.', null::text, 'A great circle shares the sphere''s centre (e.g. the equator, all meridians); a small circle does not (e.g. any other parallel)', 'A great circle is any circle on the surface; a small circle is any straight line', 'They are the same thing with different names', 'A great circle only exists at the poles', null::text, 'A', 2, 'GENERAL', 'A great circle''s plane passes through the centre of the sphere, giving the maximum possible circle radius (equal to the sphere''s own radius); a small circle''s plane does not.', null::text),
  ('Find the radius of the following parallels (R=6,400 km): (i) 0° (ii) 30°N (iii) 60°S (iv) 90°N.', null::text, '(i) 6400 (ii) 5542.6 (iii) 3200 (iv) 0', '(i) 0 (ii) 3200 (iii) 5542.6 (iv) 6400', '(i) 6400 (ii) 6400 (iii) 3200 (iv) 3200', '(i) 3200 (ii) 5542.6 (iii) 3200 (iv) 0', null::text, 'A', 2, 'GENERAL', 'Using $r=R\cos\theta$: $\cos0°=1$ (6400), $\cos30°\approx0.866$ (5542.6), $\cos60°=0.5$ (3200), $\cos90°=0$ (0).', null::text),
  ('Calculate the circumference of the parallel of latitude 50°N (R=6,400 km, π=22/7).', null::text, '≈25,859 km', '≈12,930 km', '≈40,229 km', '≈18,443 km', null::text, 'A', 3, 'GENERAL', '$r=6400\cos50°\approx4113.9$; circumference $=2\times\frac{22}{7}\times4113.9\approx25{,}859$ km.', null::text),
  ('At what latitude is the radius of the parallel exactly half of Earth''s radius?', null::text, '60°', '30°', '45°', '75°', null::text, 'A', 2, 'GENERAL', '$\cos\theta=0.5 \Rightarrow \theta=60°$.', null::text),
  ('Find the distance between (i) (30°N,20°E) and (50°N,20°E) (ii) (40°N,15°W) and (10°S,15°W), R=6,400km, π=22/7.', null::text, '(i) ≈2,235 km (ii) ≈5,587 km', '(i) ≈4,470 km (ii) ≈2,793 km', '(i) ≈2,235 km (ii) ≈2,793 km', '(i) ≈1,117 km (ii) ≈5,587 km', null::text, 'A', 3, 'GENERAL', '(i) Same side, diff=20°: $\frac{20}{360}\times2\pi(6400)\approx2235$ km. (ii) Opposite sides, sum=50°: $\frac{50}{360}\times2\pi(6400)\approx5587$ km.', null::text),
  ('Two cities A and B are on the same meridian; A is at 55°N and the distance between them is 5,550 km (R=6,400 km, π=22/7). Find the possible latitude(s) of B.', null::text, '≈5.3°N (the alternative, ≈104.7°N, is not a valid latitude)', '≈49.7°N only', '≈104.7°N only', '≈60.3°N', null::text, 'A', 4, 'GENERAL', 'Angular distance $\theta=5550/(2\pi R/360)\approx49.7°$; B is at $55-49.7\approx5.3°N$ or $55+49.7\approx104.7°N$ (invalid, since latitude cannot exceed 90°), so B is at ≈5.3°N.', null::text),
  ('X and Y are on latitude 60°N at longitudes 10°W and 35°E; find (i) the longitude difference (ii) the distance along the parallel (R=6,400 km, π=22/7).', null::text, '(i) 45° (ii) ≈2,514 km', '(i) 25° (ii) ≈1,397 km', '(i) 45° (ii) ≈5,028 km', '(i) 45° (ii) ≈1,257 km', null::text, 'A', 3, 'GENERAL', 'Opposite sides, sum $=10+35=45°$. $r=6400\cos60°=3200$; distance $=\frac{45}{360}\times2\pi(3200)\approx2514$ km.', null::text),
  ('A ship sails from P(20°N,40°E) due north for 4,440 km (R=6,400 km, π=22/7). Find its new position.', null::text, '≈60°N, 40°E', '≈40°N, 40°E', '≈20°N, 80°E', '≈70°N, 40°E', null::text, 'A', 3, 'GENERAL', 'Angular distance $=4440/(2\pi R/360)\approx40°$; sailing due north keeps longitude fixed, new latitude $=20+40=60°N$.', null::text),
  ('An aircraft flies from A(60°N,30°W) to B(60°N,20°E) along the parallel; calculate the distance covered (R=6,400 km, π=22/7).', null::text, '≈2,794 km', '≈1,397 km', '≈5,588 km', '≈3,352 km', null::text, 'A', 3, 'GENERAL', 'Opposite sides, sum $=30+20=50°$; $r=6400\cos60°=3200$; distance $=\frac{50}{360}\times2\pi(3200)\approx2794$ km.', null::text),
  ('Two weather stations are 3,200 km apart on latitude 45°S; one is at longitude 120°E. Find the longitude of the other (R=6,400 km).', null::text, '≈79.5°E or ≈160.5°E', '≈120°E ± 20°', '≈79.5°E only', '≈160.5°E only', null::text, 'A', 4, 'GENERAL', '$r=6400\cos45°\approx4525.5$; angular longitude difference $=3200/(2\pi r/360)\approx40.5°$; other longitude $=120\pm40.5$, i.e. ≈79.5°E or ≈160.5°E.', null::text),
  ('Find the time difference between places at 45°E and 90°E.', null::text, '3 hours', '1.5 hours', '6 hours', '45 minutes', null::text, 'A', 2, 'GENERAL', 'Longitude diff $=45°$; $45\times4$ minutes/degree $=180$ minutes $=3$ hours.', null::text),
  ('If it is 3:00PM at 60°W, what is the time at 30°E?', null::text, '9:00 PM', '9:00 AM', '3:00 AM', '6:00 PM', null::text, 'A', 2, 'GENERAL', 'Longitude diff $=90°$ (opposite sides, add); time diff $=6$ hours; 30°E is east of 60°W so it is ahead: 3:00PM+6h=9:00PM.', null::text),
  ('When GMT is 12:00 noon, what is the local time at 75°E?', null::text, '5:00 PM', '7:00 AM', '5:00 AM', '3:00 PM', null::text, 'A', 2, 'GENERAL', '$75\times4=300$ minutes $=5$ hours ahead of GMT: 12:00+5h=5:00PM.', null::text),
  ('Two ships are on the same meridian at latitudes 30°15''N and 28°45''N. Find the distance between them in nautical miles.', null::text, '90 nautical miles', '45 nautical miles', '150 nautical miles', '60 nautical miles', null::text, 'A', 3, 'GENERAL', 'Latitude diff $=30°15''-28°45''=1°30''=90''$ (minutes of arc); since 1 nautical mile = 1 minute of arc, the distance is 90 nautical miles.', null::text),
  ('Convert 120 nautical miles to kilometres.', null::text, '222.24 km', '111.12 km', '64.8 km', '200 km', null::text, 'A', 2, 'GENERAL', '$120\times1.852=222.24$ km.', null::text),
  ('A plane flies from A(20°N,40°E) to B(20°N,70°E) at 600 km/h (R=6,400 km, π=22/7). How long does the journey take?', null::text, '≈4.1 hours', '≈8.2 hours', '≈2.1 hours', '≈5.3 hours', null::text, 'A', 3, 'GENERAL', 'Longitude diff $=30°$; $r=6400\cos20°\approx6014$; distance $\approx\frac{30}{360}\times2\pi(6014)\approx3150$ km; time $=3150/600\approx5.25$ hours. (Corrected: the source states ≈4.1 hours, but direct computation with these figures gives ≈5.25 hours.)', null::text),
  ('What is the time at 150°W when it is 6:00PM Monday at 30°E?', null::text, '6:00 AM Monday', '6:00 AM Tuesday', '6:00 PM Tuesday', 'Midnight Monday', null::text, 'A', 3, 'GENERAL', 'Longitude diff $=180°$ (opposite sides), time diff $=12$ hours; 150°W is behind 30°E: 6:00PM-12h=6:00AM (same calendar day, since 180° alone does not itself trigger a date-line crossing rule).', null::text),
  ('Find the distance along the equator between longitudes 20°W and 50°E (R=6,370 km, π=22/7).', null::text, '≈7,786 km', '≈3,893 km', '≈15,572 km', '≈5,000 km', null::text, 'A', 3, 'GENERAL', 'Longitude diff $=70°$ (opposite sides); distance $=\frac{70}{360}\times2\times\frac{22}{7}\times6370\approx7786$ km.', null::text),
  ('A ship travels at 25 knots for 8 hours; how far does it travel in km?', null::text, '≈370.4 km', '≈185.2 km', '≈740.8 km', '≈200 km', null::text, 'A', 2, 'GENERAL', 'Distance $=25\times8=200$ nautical miles $=200\times1.852\approx370.4$ km.', null::text),
  ('If you cross the International Date Line from west to east on Friday at 2:00PM, what is the day and time immediately after crossing?', null::text, 'Thursday, 2:00 PM', 'Saturday, 2:00 PM', 'Friday, 2:00 AM', 'Thursday, 2:00 AM', null::text, 'A', 2, 'GENERAL', 'Crossing the Date Line west to east subtracts a day: Friday 2:00PM becomes Thursday 2:00PM.', null::text),
  ('Find the angular difference between X(80°N,79°W) and Y(80°N,11°E).', null::text, '90°', '68°', '180°', '11°', null::text, 'A', 2, 'GENERAL', 'Same latitude, opposite sides: longitude difference $=79+11=90°$.', null::text),
  ('Calculate the radius of the parallel of latitude 75°N (R=6,400 km).', null::text, '≈1,656 km', '≈3,200 km', '≈6,182 km', '≈4,525 km', null::text, 'A', 3, 'GENERAL', '$r=6400\cos75°\approx6400\times0.2588\approx1656$ km.', null::text),
  ('Find the sectorial angle between Y(70°N,65°W) and Z(38°S,65°W).', null::text, '108°', '32°', '70°', '38°', null::text, 'A', 2, 'GENERAL', 'Same meridian, opposite sides: $70+38=108°$.', null::text),
  ('Calculate the distance YZ between Y(70°N,65°W) and Z(38°S,65°W) if the radius of the Earth is 6,400 km (π=22/7).', null::text, '≈12,069 km', '≈3,840 km', '≈6,034 km', '≈24,137 km', null::text, 'A', 4, 'GENERAL', 'Angular distance $=108°$; distance $=\frac{108}{360}\times2\times\frac{22}{7}\times6400\approx12{,}069$ km. (Corrected: the source states 3,840 km, which equals $6400\times108/180$, consistent with omitting the required factor of π when converting the angle to an arc length.)', null::text),
  ('An aircraft flew from A(0°,0°) to B(0°,180°) at speed 1,000 km/h. Calculate the distance travelled (π=22/7, R=6,370 km).', null::text, '≈20,020 km', '≈10,010 km', '≈40,040 km', '≈6,370 km', null::text, 'A', 3, 'GENERAL', 'Half the equator''s circumference: $\pi R=\frac{22}{7}\times6370=20{,}020$ km.', null::text),
  ('Two places on the equator are 7,900 km apart; find the difference in longitude between them (R=6,370 km, π=3.14).', null::text, '≈71.09°', '≈35.5°', '≈142.2°', '≈60°', null::text, 'A', 3, 'GENERAL', 'Equator circumference $=2\pi R\approx40{,}003.6$ km; longitude diff $=(7900/40003.6)\times360\approx71.09°$.', null::text),
  ('Two places on the same meridian have latitudes 10°S and 53°N; find their distance apart (π=22/7, R=6,370 km).', null::text, '≈7,007 km', '≈4,782 km', '≈3,503 km', '≈14,014 km', null::text, 'A', 3, 'GENERAL', 'Opposite sides, sum $=10+53=63°$; distance $=\frac{63}{360}\times2\times\frac{22}{7}\times6370\approx7007$ km.', null::text),
  ('Find the distance measured along the parallel of latitude between two places at latitude 18°S, longitudes 96°E and 57°E (R=6,400 km, π=22/7).', null::text, '≈4,145 km', '≈2,073 km', '≈8,290 km', '≈3,000 km', null::text, 'A', 3, 'GENERAL', 'Same side, diff $=96-57=39°$; $r=6400\cos18°\approx6087$; distance $=\frac{39}{360}\times2\times\frac{22}{7}\times6087\approx4145$ km.', null::text),
  ('X(60°N,30°E) and Y(60°N,85°E): find the sectorial angle XY along the parallel.', null::text, '55°', '25°', '115°', '30°', null::text, 'A', 2, 'GENERAL', 'Same side, diff $=85-30=55°$.', null::text),
  ('If the radius of the Earth is 6,400 km, find the radius of the parallel of latitude 60°N.', null::text, '3,200 km', '6,400 km', '5,542.6 km', '1,600 km', null::text, 'A', 2, 'GENERAL', '$r=6400\cos60°=6400(0.5)=3200$ km.', null::text),
  ('Two points X and Y on latitude 50°N are directly opposite each other on the globe (180° apart in longitude); if the longitude of X is 50°E, what is the longitude of Y?', null::text, '130°W', '50°W', '130°E', '180°E', null::text, 'A', 3, 'GENERAL', '$50°E+180°=230°E$, which converts to $230-360=-130$, i.e. $130°W$.', null::text)
) as v(question_text, question_latex, option_a, option_b, option_c, option_d, option_e, correct_letter, difficulty, exam_type, explanation, exam_shortcut)
where c.subject = 'Mathematics' and t.class_level = 'SS3' and t.term = 1 and t.order_index = 107;

-- ------------------------------------------
-- 108. LONGITUDE AND LATITUDE (CONTINUED)  -  SS3 Mathematics, Term 1
-- ------------------------------------------


with lesson as (
  insert into public.lessons (topic_id, title, summary, content_body, order_index)
  values (
    (select t.id from public.topics t join public.curricula c on c.id = t.curriculum_id where c.subject = 'Mathematics' and t.class_level = 'SS3' and t.term = 1 and t.order_index = 108),
    'Longitude, Time Zones, and Nautical Distance',
    'Building on longitude and latitude: converting longitude differences to time differences, handling the International Date Line, and working with nautical miles and knots.',
    '## Longitude and Latitude (Continued): Time, Speed, and Nautical Distance

**Glossary**
- **GMT (Greenwich Mean Time):** the time at longitude $0^\circ$, used as the world''s time reference point.
- **Nautical mile:** a unit of distance equal to 1 minute of arc ($1''$) along a great circle, approximately $1.852$ km. Since $1^\circ = 60$ minutes of arc, $1^\circ = 60$ nautical miles.
- **Knot:** a unit of speed equal to 1 nautical mile per hour, used for ships and aircraft.
- **International Date Line:** an imaginary line near longitude $180^\circ$ where the calendar date changes.

**Time and longitude.** The Earth rotates $360^\circ$ in 24 hours, so $360^\circ \div 24 = 15^\circ$ per hour, and $60 \div 15 = 4$ minutes per degree. This gives the rule "$15^\circ = 1$ hour, $1^\circ = 4$ minutes," which can always be re-derived from "one full rotation per day" if forgotten. Places further **East** are ahead in time; places further **West** are behind.

$$\text{Time difference} = (\text{longitude difference}) \times 4 \text{ minutes}$$

**International Date Line rule:** crossing it while travelling **West to East subtracts** a day (as if flying "backwards" in time relative to the calendar); crossing **East to West adds** a day. This is the opposite direction-logic from ordinary time-zone crossing, and is worth remembering as a separate rule.

**Nautical miles and knots:** for distances along a meridian, distance in nautical miles = the angular distance converted directly to minutes of arc (degrees $\times 60$ + any extra minutes), this is much faster than computing $(\theta/360)\times2\pi R$ and then converting.',
    1
  )
  returning id
)
insert into public.worked_examples (lesson_id, title, problem_statement, solution_steps, exam_shortcut, common_trap_warning, diagram_type, diagram_data, status)
select id,
  'Local Arrival Time After a Flight',
  'A plane leaves London ($0^\circ$) at 8:00AM GMT, and flies for 6 hours to Lagos ($15^\circ E$). Find the local arrival time in Lagos.',
  to_jsonb(array[
    'Find the arrival time in GMT (the reference time zone) by adding the flight duration to the departure time: $8:00\text{AM} + 6 \text{ hours} = 2:00\text{PM GMT}$.',
    'Find the time difference between Lagos ($15^\circ E$) and GMT ($0^\circ$) using $1^\circ = 4$ minutes: $15^\circ \times 4 \text{ min} = 60 \text{ minutes} = 1 \text{ hour}$.',
    'Determine the direction: Lagos is East of Greenwich, so it is ahead of GMT.',
    'Add the 1-hour difference to the GMT arrival time to get Lagos''s local time: $2:00\text{PM} + 1 \text{ hour} = 3:00\text{PM}$.',
    'Answer: $3:00$PM local time in Lagos.'
  ]),
  'For "GMT + flight time" questions, always compute the GMT arrival time FIRST, then convert to local time last, trying to add the local departure time directly to a longitude offset before accounting for flight duration is the most common source of error in these multi-step problems.',
  'East is always ahead, West is always behind, say this out loud before every time-zone question, since adding when subtraction is needed (or vice versa) causes most of the lost marks on this topic, not the arithmetic itself.',
  'circle',
  '{"centerLabel": "GMT (0°)", "points": [{"label": "London (0°)", "angleDegrees": 0}, {"label": "Lagos (15°E)", "angleDegrees": 15}], "highlightSector": {"startAngle": 0, "endAngle": 15, "label": "15° = 1 hour ahead"}}'::jsonb,
  'published'
from lesson;

insert into public.worked_examples (lesson_id, title, problem_statement, solution_steps, exam_shortcut, common_trap_warning, real_life_context, status)
select l.id,
  'Speed in Knots and Kilometres per Hour',
  'A ship travels 240 nautical miles in 6 hours. Find its speed in (a) knots (b) km/h.',
  to_jsonb(array[
    'Recall the definition of a knot: speed (in knots) $=$ distance (in nautical miles) $\div$ time (in hours).',
    'Substitute the given values: speed $=240 \div 6 = 40$.',
    'Answer (a): $40$ knots.',
    'Convert nautical miles per hour to kilometres per hour using $1$ nautical mile $\approx 1.852$ km: $40 \times 1.852 = 74.08$.',
    'Answer (b): $74.08$ km/h.'
  ]),
  'Memorize "$1$ nautical mile $\approx 1.852$ km" and "$1^\circ = 60$ nautical miles" as a linked pair, converting between nautical miles, degrees, and kilometres then becomes a single multiplication or division rather than three separate lookups.',
  null::text,
  'This is exactly how a Nigerian Navy vessel or a coastal cargo ship reports its speed and estimates its arrival time along a shipping route, knots (not km/h) is the standard unit used at sea worldwide.',
  'published'
from public.lessons l
where l.topic_id = (select t.id from public.topics t join public.curricula c on c.id = t.curriculum_id where c.subject = 'Mathematics' and t.class_level = 'SS3' and t.term = 1 and t.order_index = 108)
order by l.created_at desc limit 1;

insert into public.worked_examples (lesson_id, title, problem_statement, solution_steps, exam_shortcut, common_trap_warning, real_life_context, status)
select l.id,
  'A Multi-Step Flight-Time Problem',
  'An aircraft leaves Lagos ($6^\circ30''N, 3^\circ30''E$) at 6:00AM Monday, and flies for 5 hours to London ($51^\circ30''N, 0^\circ$). Find (a) the time difference between Lagos and London, (b) the arrival time in London, (c) the GMT at departure.',
  to_jsonb(array[
    'Find the longitude difference between Lagos ($3^\circ30''E$) and London ($0^\circ$, effectively GMT): the difference is $3^\circ30'' = 3.5^\circ$.',
    'Convert to time using $1^\circ=4$ minutes: $3.5 \times 4 = 14$ minutes.',
    'Answer (a): the time difference is $14$ minutes, with Lagos ahead of London since it is further East.',
    'Find the GMT at departure by subtracting the 14-minute difference from the Lagos local departure time: $6:00\text{AM} - 14 \text{ min} = 5:46\text{AM GMT}$.',
    'Answer (c): $5:46$AM GMT.',
    'Add the 5-hour flight duration (measured in the constant GMT reference) to find the GMT arrival time: $5:46\text{AM} + 5 \text{ hours} = 10:46\text{AM GMT}$.',
    'Since London''s local time is effectively the same as GMT (longitude $0^\circ$), the arrival local time in London is also $10:46$AM.',
    'Answer (b): $10:46$AM Monday in London.'
  ]),
  'For multi-step time-zone-plus-flight-time problems, always convert everything to the constant GMT reference FIRST (find GMT at departure, add flight time to get GMT at arrival), then convert the final GMT value to whatever local time zone is asked for last.',
  null::text,
  'This mirrors exactly how airlines schedule real Lagos-to-London flights and publish both a local departure and local arrival time that differ by more than just the flight duration, because of the small time-zone offset between the two cities.',
  'published'
from public.lessons l
where l.topic_id = (select t.id from public.topics t join public.curricula c on c.id = t.curriculum_id where c.subject = 'Mathematics' and t.class_level = 'SS3' and t.term = 1 and t.order_index = 108)
order by l.created_at desc limit 1;

insert into public.questions (topic_id, lesson_id, question_text, question_latex, option_a, option_b, option_c, option_d, option_e, correct_letter, difficulty, exam_type, explanation, exam_shortcut, status)
select t.id, l.id, v.question_text, v.question_latex, v.option_a, v.option_b, v.option_c, v.option_d, v.option_e, v.correct_letter::char(1), v.difficulty::integer, v.exam_type::exam_type, v.explanation, v.exam_shortcut, 'published'
from public.topics t
join public.curricula c on c.id = t.curriculum_id
join public.lessons l on l.topic_id = t.id
cross join (values
  ('Find the time difference between the longitudes (i) 15°E and 45°E (ii) 30°W and 60°E (iii) 120°E and 150°W.', null::text, '(i) 2 hr (ii) 6 hr (iii) 6 hr', '(i) 2 hr (ii) 3 hr (iii) 12 hr', '(i) 4 hr (ii) 6 hr (iii) 6 hr', '(i) 2 hr (ii) 6 hr (iii) 9 hr', null::text, 'A', 2, 'GENERAL', '(i) diff=30°=2hr. (ii) opposite sides, diff=90°=6hr. (iii) short way around: 360-(120+150)=90°=6hr.', null::text),
  ('If it is 8:30AM Wednesday at 75°W, find the time and day at (i) 45°E (ii) 165°W (iii) 0° (GMT).', null::text, '(i) 4:30PM Wed (ii) 2:30AM Wed (iii) 1:30PM Wed', '(i) 4:30PM Wed (ii) 2:30AM Thu (iii) 1:30PM Wed', '(i) 12:30PM Wed (ii) 2:30AM Wed (iii) 1:30PM Wed', '(i) 4:30PM Thu (ii) 2:30AM Wed (iii) 1:30PM Wed', null::text, 'A', 3, 'GENERAL', '(i) diff=120°=8hr ahead: 8:30AM+8h=4:30PM. (ii) same side, diff=90°=6hr behind: 8:30AM-6h=2:30AM. (iii) diff=75°=5hr ahead of the location, so GMT=8:30AM+5h=1:30PM.', null::text),
  ('Calculate the distance (in km and nautical miles) between (25°30''N,10°E) and (32°45''N,10°E).', null::text, '≈805 km / 435 n.mi.', '≈402 km / 217 n.mi.', '≈1610 km / 870 n.mi.', '≈805 km / 87 n.mi.', null::text, 'A', 3, 'GENERAL', 'Latitude diff $=32°45''-25°30''=7°15''=435''$; distance $=435$ nautical miles $=435\times1.852\approx805$ km.', null::text),
  ('X and Y are on latitude 45°N; X at 30°W, Y at 15°E. Find (i) the distance along the parallel (ii) the time difference (iii) the time at Y if it is noon at X (R=6,400km, π=22/7).', null::text, '(i) ≈3,556 km (ii) 3 hr (iii) 3:00PM', '(i) ≈7,112 km (ii) 3 hr (iii) 3:00PM', '(i) ≈3,556 km (ii) 6 hr (iii) 6:00PM', '(i) ≈3,556 km (ii) 3 hr (iii) 9:00AM', null::text, 'A', 3, 'GENERAL', 'Longitude diff=45° (opposite sides); r=6400cos45°≈4525.5; distance≈3556 km; time diff=45×4=180min=3hr; Y is East so ahead: noon+3h=3:00PM.', null::text),
  ('A ship sails from P(0°,20°W) due east along the equator at 30 knots. How long does it take to reach Q(0°,40°E)?', null::text, '120 hours', '60 hours', '240 hours', '90 hours', null::text, 'A', 3, 'GENERAL', 'Longitude diff=60° (opposite sides); at the equator, 1°=60 nautical miles exactly, so distance=60×60=3600 n.mi.; time=3600/30=120 hours.', null::text),
  ('An aircraft leaves A(30°N,45°E) at 10:00AM local and arrives B(30°N,90°E) at 2:00PM local. Find (i) the time difference (ii) the actual flight time (iii) the distance covered (iv) the average speed (R=6,400km, π=22/7).', null::text, '(i) 3 hr (ii) 1 hr (iii) ≈4,355 km (iv) ≈4,355 km/h', '(i) 3 hr (ii) 4 hr (iii) ≈4,355 km (iv) ≈1,089 km/h', '(i) 4 hr (ii) 1 hr (iii) ≈4,355 km (iv) ≈4,355 km/h', '(i) 3 hr (ii) 1 hr (iii) ≈2,178 km (iv) ≈2,178 km/h', null::text, 'A', 4, 'GENERAL', 'Longitude diff=45°=3hr time diff. Actual flight time = 4hr apparent - 3hr timezone shift = 1hr. Distance along latitude 30°N: r=6400cos30°≈5542.6, distance=(45/360)×2π(5542.6)≈4355 km. Average speed=4355/1≈4355 km/h.', null::text),
  ('A conference call is scheduled for 3:00PM GMT. Find the local time in (i) Lagos (15°E) (ii) New York (75°W) (iii) Tokyo (135°E).', null::text, '(i) 4:00PM (ii) 10:00AM (iii) 12:00 midnight', '(i) 4:00PM (ii) 8:00AM (iii) 12:00 noon', '(i) 2:00PM (ii) 10:00AM (iii) 12:00 midnight', '(i) 4:00PM (ii) 10:00AM (iii) 6:00PM', null::text, 'A', 3, 'GENERAL', '(i) 15×4=1hr ahead: 4:00PM. (ii) 75×4=5hr behind: 10:00AM. (iii) 135×4=9hr ahead: 3:00PM+9h=12:00 midnight.', null::text),
  ('A football match starts at 8:00PM in London (0°). Find the local time in (i) Abuja (7.5°E) (ii) Los Angeles (120°W).', null::text, '(i) 8:30PM (ii) 12:00 noon', '(i) 8:30PM (ii) 4:00PM', '(i) 7:30PM (ii) 12:00 noon', '(i) 8:30PM (ii) 8:00AM', null::text, 'A', 3, 'GENERAL', '(i) 7.5×4=30min ahead: 8:30PM. (ii) 120×4=8hr behind: 8:00PM-8h=12:00 noon (same day).', null::text),
  ('Find the time difference between places at 45°E and 90°E.', null::text, '3 hours', '1.5 hours', '6 hours', '45 minutes', null::text, 'A', 2, 'GENERAL', 'Diff=45°=3hr.', null::text),
  ('If it is 3:00PM at 60°W, what is the time at 30°E?', null::text, '9:00 PM', '9:00 AM', '3:00 AM', '6:00 PM', null::text, 'A', 2, 'GENERAL', 'Diff=90° (opposite sides)=6hr ahead: 3:00PM+6h=9:00PM.', null::text),
  ('When GMT is 12 noon, what is the local time at 75°E?', null::text, '5:00 PM', '7:00 AM', '5:00 AM', '3:00 PM', null::text, 'A', 2, 'GENERAL', '75×4=300min=5hr ahead: 12:00+5h=5:00PM.', null::text),
  ('Two ships on the same meridian are at latitudes 30°15''N and 28°45''N; find the distance between them in nautical miles.', null::text, '90 n.mi.', '45 n.mi.', '150 n.mi.', '60 n.mi.', null::text, 'A', 3, 'GENERAL', 'Diff=1°30''=90 minutes of arc=90 nautical miles.', null::text),
  ('Convert 120 nautical miles to kilometres.', null::text, '222.24 km', '111.12 km', '64.8 km', '200 km', null::text, 'A', 2, 'GENERAL', '$120\times1.852=222.24$ km.', null::text),
  ('A plane flies from A(20°N,40°E) to B(20°N,70°E) at 600 km/h (R=6,400 km, π=22/7). How long does the journey take?', null::text, '≈5.25 hours', '≈4.1 hours', '≈2.6 hours', '≈10.5 hours', null::text, 'A', 3, 'GENERAL', 'Longitude diff=30°; r=6400cos20°≈6014; distance≈3150 km; time=3150/600≈5.25 hours. (Corrected: the source states ≈4.1 hours for this repeated exercise item.)', null::text),
  ('What is the time at 150°W when it is 6:00PM Monday at 30°E?', null::text, '6:00 AM Monday', '6:00 AM Tuesday', 'Midnight Monday', '6:00 PM Tuesday', null::text, 'A', 3, 'GENERAL', 'Diff=180°=12hr behind: 6:00PM-12h=6:00AM (same calendar day).', null::text),
  ('Find the distance along the equator between longitudes 20°W and 50°E (R=6,370 km, π=22/7).', null::text, '≈7,786 km', '≈3,893 km', '≈15,572 km', '≈5,000 km', null::text, 'A', 3, 'GENERAL', 'Diff=70°; distance=(70/360)×2×(22/7)×6370≈7786 km.', null::text),
  ('A ship travels at 25 knots for 8 hours; how far does it travel in km?', null::text, '≈370.4 km', '≈185.2 km', '≈740.8 km', '≈200 km', null::text, 'A', 2, 'GENERAL', 'Distance=25×8=200 n.mi.=200×1.852≈370.4 km.', null::text),
  ('If you cross the International Date Line from west to east on Friday at 2:00PM, what is the day and time immediately after crossing?', null::text, 'Thursday, 2:00 PM', 'Saturday, 2:00 PM', 'Friday, 2:00 AM', 'Thursday, 2:00 AM', null::text, 'A', 2, 'GENERAL', 'West to east crossing subtracts a day: Friday 2:00PM becomes Thursday 2:00PM.', null::text),
  ('A ship leaves port A(60°N,40°W), sails south to port B on the equator (same meridian), then sails east along the equator to port C at 20°E (R=6,370 km, π=22/7). Find (a) distance A to B (b) distance B to C (c) total distance.', null::text, '(a) ≈6,665 km (b) ≈6,665 km (c) ≈13,330 km', '(a) ≈6,665 km (b) ≈3,333 km (c) ≈9,998 km', '(a) ≈4,443 km (b) ≈6,665 km (c) ≈11,108 km', '(a) ≈6,665 km (b) ≈13,330 km (c) ≈19,995 km', null::text, 'A', 4, 'GENERAL', '(a) Meridian distance for 60°: (60/360)×2×(22/7)×6370≈6665 km. (b) Equator distance for longitude diff 40+20=60°: same formula, ≈6665 km. (c) Total≈13,330 km.', null::text),
  ('An aircraft leaves Lagos (6°30''N,3°30''E) at 6:00AM Monday, flies 5 hours to London (51°30''N,0°). Find (a) the time difference (b) the arrival time in London (c) the GMT at departure.', null::text, '(a) 14 min (b) 10:46AM Monday (c) 5:46AM GMT', '(a) 14 min (b) 11:00AM Monday (c) 6:00AM GMT', '(a) 30 min (b) 10:30AM Monday (c) 5:30AM GMT', '(a) 14 min (b) 10:46AM Monday (c) 5:46AM Monday', null::text, 'A', 4, 'GENERAL', 'Longitude diff=3.5°=14min. GMT at departure=6:00AM-14min=5:46AM. GMT at arrival=5:46AM+5h=10:46AM, which is also London local time (London ≈ GMT).', null::text),
  ('An aeroplane flies at 650 km/h along the parallel of latitude from X(15°S,10°W) to Y(15°S,48°E) (R=6,400km, π=3.142). Calculate the time taken.', null::text, '≈9.6 hours', '≈10 hours', '≈4.8 hours', '≈19.3 hours', null::text, 'A', 4, 'GENERAL', 'Longitude diff=58° (opposite sides); r=6400cos15°≈6182; distance≈(58/360)×2π(6182)≈6259 km; time=6259/650≈9.6 hours.', null::text),
  ('What is the angle between P and Q whose longitudes are 102°E and 38°W, both lying on latitude 30°S?', null::text, '140°', '64°', '180°', '38°', null::text, 'A', 2, 'GENERAL', 'Opposite sides, sum=102+38=140°.', null::text),
  ('Calculate the radius of the parallel of latitude 60°N (R=6,400 km).', null::text, '3,200 km', '6,400 km', '5,542.6 km', '1,600 km', null::text, 'A', 2, 'GENERAL', '$r=6400\cos60°=3200$ km.', null::text),
  ('Two villages are at (15°S,107°E) and (15°S,17°E); find their distance apart along the latitude (R=6,400 km, π=22/7).', null::text, '≈9,734 km', '≈4,867 km', '≈19,468 km', '≈6,182 km', null::text, 'A', 4, 'GENERAL', 'Same side, longitude diff=90°; r=6400cos15°≈6182; distance=(90/360)×2×(22/7)×6182≈9734 km.', null::text),
  ('A(43°N,77°E), B(43°N,103°W), C(57°S,77°E). Find (i) the distance A to B along latitude 43°N (ii) the distance A to C along the great circle (π=3.142, R=6,400km).', null::text, '(i) ≈14,707 km (ii) ≈11,172 km', '(i) ≈29,414 km (ii) ≈11,172 km', '(i) ≈14,707 km (ii) ≈22,344 km', '(i) ≈7,354 km (ii) ≈11,172 km', null::text, 'A', 4, 'GENERAL', '(i) Longitude diff=77+103=180° (opposite sides); r=6400cos43°≈4681; distance=(180/360)×2π(4681)≈14707 km. (ii) Same meridian, opposite sides, sum=43+57=100°; distance=(100/360)×2π(6400)≈11172 km.', null::text)
) as v(question_text, question_latex, option_a, option_b, option_c, option_d, option_e, correct_letter, difficulty, exam_type, explanation, exam_shortcut)
where c.subject = 'Mathematics' and t.class_level = 'SS3' and t.term = 1 and t.order_index = 108;

-- ------------------------------------------
-- 109. ARITHMETIC OF FINANCE  -  SS3 Mathematics, Term 1
-- ------------------------------------------


with lesson as (
  insert into public.lessons (topic_id, title, summary, content_body, order_index)
  values (
    (select t.id from public.topics t join public.curricula c on c.id = t.curriculum_id where c.subject = 'Mathematics' and t.class_level = 'SS3' and t.term = 1 and t.order_index = 109),
    'Simple Interest, Compound Interest, and Depreciation',
    'Calculating simple interest, compound interest, depreciation, and basic annuities, and comparing simple versus compound interest over time.',
    '## Arithmetic of Finance

**Glossary**
- **Principal ($P$):** the original sum of money invested, saved, or borrowed, before any interest is added.
- **Interest:** the extra money earned (on savings/investments) or owed (on a loan), calculated as a percentage of the principal.
- **Depreciation:** the loss in value of an asset (like a car or machine) over time.
- **Amount ($A$):** the total value after interest has been added: $A=P+\text{Interest}$.

**Simple interest.** $I=\dfrac{PRT}{100}$, where $P=$ principal, $R=$ rate per annum as a plain number (e.g. use "8" for 8%, not $0.08$), $T=$ time in years. Amount $A=P+I$. This one formula rearranges to find any missing quantity: $R=\dfrac{100I}{PT}$, $T=\dfrac{100I}{PR}$, $P=\dfrac{100I}{RT}$.

**Compound interest.** $A=P(1+r)^n$, where $r=$ rate as a decimal (e.g. $0.08$ for 8%) and $n=$ number of compounding periods. Compound interest earned $=A-P$. For $k$ compounding periods per year over $t$ years: $A=P\left(1+\dfrac{r}{k}\right)^{kt}$. For $T=1$ year, simple and compound interest are always identical, compound interest only overtakes simple interest from year 2 onward.

**Depreciation.**
- Straight-line method: annual depreciation $=\dfrac{\text{Cost}-\text{Salvage value}}{\text{Useful life}}$.
- Reducing-balance method: $V=P(1-r)^n$, where $r$ is the annual depreciation rate as a decimal.

**Rule of 72.** Years to double an investment $\approx \dfrac{72}{\text{interest rate (as a whole number)}}$.',
    1
  )
  returning id
)
insert into public.worked_examples (lesson_id, title, problem_statement, solution_steps, exam_shortcut, common_trap_warning, real_life_context, status)
select id,
  'Simple Interest',
  'Find the simple interest on ₦50,000 for 3 years at 8% per annum.',
  to_jsonb(array[
    'Write down the simple interest formula: $I=\dfrac{PRT}{100}$, where $P=$ principal, $R=$ rate per annum (as a plain number), $T=$ time in years.',
    'Identify the given values: $P=50{,}000$, $R=8$, $T=3$.',
    'Substitute into the formula: $I=\dfrac{50{,}000\times8\times3}{100}$.',
    'Multiply the numerator: $50{,}000\times8=400{,}000$; $400{,}000\times3=1{,}200{,}000$.',
    'Divide by 100: $1{,}200{,}000\div100=12{,}000$.',
    'Answer: $I=₦12{,}000$.'
  ]),
  'Memorize the simple interest formula as "PRT over 100" and always keep $R$ as a plain number (not divided by 100 twice), dividing by 100 both when writing $R$ as a decimal AND again in the formula is the most common student slip.',
  null::text,
  'This is exactly how a Nigerian cooperative society (esusu/ajo) or a microfinance bank works out how much interest a member''s ₦ deposit earns over a fixed savings period.',
  'published'
from lesson;

insert into public.worked_examples (lesson_id, title, problem_statement, solution_steps, exam_shortcut, common_trap_warning, real_life_context, status)
select l.id,
  'Compound Interest, Year by Year',
  'Find the compound interest on ₦500 for 2 years at 6% per annum, using the year-by-year method.',
  to_jsonb(array[
    'Compute Year 1''s interest on the original principal: Interest $=500\times6\%=500\times0.06=30$.',
    'Add Year 1''s interest to the principal to get the new principal for Year 2: $500+30=530$.',
    'Compute Year 2''s interest on this NEW principal (this is what makes it "compound"): Interest $=530\times6\%=530\times0.06=31.80$.',
    'Add Year 2''s interest to find the final amount: $530+31.80=561.80$.',
    'Subtract the original principal to isolate the total compound interest earned: $CI=561.80-500=61.80$.',
    'Answer: $CI=₦61.80$ (check using the formula: $A=500\times1.06^2=500\times1.1236=561.80$, correct).'
  ]),
  'For compound interest over a SMALL number of years (2-3), the year-by-year method is often faster and safer than computing $(1+r)^n$ with a calculator, since each year is just "old amount times (1+rate)".',
  'Compound interest should never be less than simple interest for the same rate over more than 1 year, if a comparison calculation comes out the other way round, recheck the working.',
  'This is exactly how a Nigerian bank''s fixed-deposit or savings account statement shows interest building up: each year''s interest is calculated on the PREVIOUS year''s total, not on the original deposit alone.',
  'published'
from public.lessons l
where l.topic_id = (select t.id from public.topics t join public.curricula c on c.id = t.curriculum_id where c.subject = 'Mathematics' and t.class_level = 'SS3' and t.term = 1 and t.order_index = 109)
order by l.created_at desc limit 1;

insert into public.worked_examples (lesson_id, title, problem_statement, solution_steps, exam_shortcut, common_trap_warning, real_life_context, status)
select l.id,
  'Finding the Rate from Simple Interest',
  'At what rate percent per annum will ₦520 yield simple interest of ₦39 in 3 years?',
  to_jsonb(array[
    'Start from the simple interest formula and substitute all known values: $I=\dfrac{PRT}{100} \Rightarrow 39=\dfrac{520\times R\times3}{100}$.',
    'Simplify the right-hand side''s constants: $520\times3=1{,}560$, so $39=\dfrac{1{,}560\times R}{100}$.',
    'Multiply both sides by 100 to clear the fraction: $3{,}900=1{,}560\times R$.',
    'Divide both sides by 1,560 to isolate $R$: $R=3{,}900\div1{,}560=2.5$.',
    'Answer: $R=2\tfrac12\%$.'
  ]),
  '"Find the rate/time/principal" simple-interest questions are all the SAME formula rearranged: memorize $I=PRT/100$ once, and rearrange it on the spot rather than trying to memorize four separate formulas.',
  'Watch out for time given in months, always convert to years first (divide by 12) before substituting into $I=PRT/100$, forgetting this conversion is one of the most common arithmetic-of-finance errors.',
  'This is the same reverse calculation a customer does when comparing loan offers from different Nigerian microfinance lenders, working out the effective interest rate being charged from the naira amounts quoted.',
  'published'
from public.lessons l
where l.topic_id = (select t.id from public.topics t join public.curricula c on c.id = t.curriculum_id where c.subject = 'Mathematics' and t.class_level = 'SS3' and t.term = 1 and t.order_index = 109)
order by l.created_at desc limit 1;

insert into public.questions (topic_id, lesson_id, question_text, question_latex, option_a, option_b, option_c, option_d, option_e, correct_letter, difficulty, exam_type, explanation, exam_shortcut, status)
select t.id, l.id, v.question_text, v.question_latex, v.option_a, v.option_b, v.option_c, v.option_d, v.option_e, v.correct_letter::char(1), v.difficulty::integer, v.exam_type::exam_type, v.explanation, v.exam_shortcut, 'published'
from public.topics t
join public.curricula c on c.id = t.curriculum_id
join public.lessons l on l.topic_id = t.id
cross join (values
  ('Find the simple interest on ₦25,000 for 4 years at 6% p.a.', null::text, '₦6,000', '₦1,500', '₦12,000', '₦4,500', null::text, 'A', 2, 'GENERAL', '$I=25000\times6\times4/100=6000$.', null::text),
  ('Calculate the compound interest on ₦40,000 for 3 years at 8% p.a.', null::text, '≈₦10,388.48', '≈₦9,600', '≈₦12,800', '≈₦13,310', null::text, 'A', 3, 'GENERAL', '$A=40000\times1.08^3=40000\times1.259712=50{,}388.48$; $CI=₦10{,}388.48$. (Corrected: the source states ≈₦10,398.85.)', null::text),
  ('Which gives more interest: ₦100,000 at 10% simple interest for 3 years, or ₦100,000 at 8% compound interest for 3 years?', null::text, 'SI gives ₦30,000, more than CI''s ≈₦25,971', 'CI gives more than SI', 'They give exactly the same interest', 'SI gives ₦25,971, less than CI', null::text, 'A', 3, 'GENERAL', 'SI$=100000\times10\times3/100=30000$. CI$=100000\times1.08^3-100000\approx25{,}971$. So SI is more here.', null::text),
  ('A car worth ₦3,000,000 depreciates at 20% p.a. Find its value after 2 years.', null::text, '₦1,920,000', '₦2,400,000', '₦1,800,000', '₦2,160,000', null::text, 'A', 2, 'GENERAL', '$V=3000000\times0.8^2=3000000\times0.64=1{,}920{,}000$.', null::text),
  ('Find the annual (straight-line) depreciation of a machine costing ₦800,000 with salvage value ₦80,000, over 10 years.', null::text, '₦72,000/year', '₦80,000/year', '₦8,000/year', '₦720,000/year', null::text, 'A', 2, 'GENERAL', '$(800000-80000)/10=72{,}000$/year.', null::text),
  ('How much should be deposited now at 12% compound interest per annum to have ₦500,000 in 4 years?', null::text, '≈₦317,760', '≈₦440,000', '≈₦380,000', '≈₦250,000', null::text, 'A', 3, 'GENERAL', '$P=500000/1.12^4=500000/1.57352\approx317{,}760$.', null::text),
  ('Find the approximate monthly payment on a loan of ₦200,000 at 18% p.a. for 2 years (24 monthly instalments).', null::text, '≈₦9,984', '≈₦8,333', '≈₦18,000', '≈₦16,667', null::text, 'A', 4, 'GENERAL', 'Monthly rate $=1.5\%$; using the loan-payment formula $P\times r/(1-(1+r)^{-n})=200000\times0.015/(1-1.015^{-24})\approx₦9{,}984$.', null::text),
  ('A person deposits ₦5,000 monthly for 3 years (36 months) into an account paying 9% p.a. compounded monthly. Find the approximate total amount saved.', null::text, '≈₦205,767', '≈₦180,000', '≈₦230,000', '≈₦196,320', null::text, 'A', 4, 'GENERAL', 'Monthly rate $=0.75\%$; future value of annuity $=5000\times[(1.0075)^{36}-1]/0.0075\approx₦205{,}767$.', null::text),
  ('An investment of ₦150,000 grows to ₦180,000 in 2 years; find the approximate annual compound interest rate.', null::text, '≈9.5%', '≈10%', '≈20%', '≈15%', null::text, 'A', 3, 'GENERAL', '$(180000/150000)=1.2=(1+r)^2 \Rightarrow 1+r=\sqrt{1.2}\approx1.0954 \Rightarrow r\approx9.5\%$.', null::text),
  ('Using the Rule of 72, estimate how long it takes for money to double at 8% p.a.', null::text, '9 years', '8 years', '12 years', '7.2 years', null::text, 'A', 2, 'GENERAL', '$72/8=9$ years.', null::text),
  ('Calculate the simple interest on ₦75,000 for 5 years at 7.5% p.a.', null::text, '₦28,125', '₦5,625', '₦37,500', '₦2,812.50', null::text, 'A', 2, 'GENERAL', '$I=75000\times7.5\times5/100=28{,}125$.', null::text),
  ('Find the compound interest on ₦60,000 for 2 years at 10% p.a. compounded (i) annually (ii) semi-annually (iii) quarterly.', null::text, '(i) ₦12,600 (ii) ≈₦12,930.38 (iii) ≈₦13,104.17', '(i) ₦12,000 (ii) ₦12,600 (iii) ₦12,900', '(i) ₦12,600 (ii) ₦12,600 (iii) ₦12,600', '(i) ₦6,000 (ii) ₦6,465 (iii) ₦6,552', null::text, 'A', 4, 'GENERAL', '(i) $60000(1.1)^2-60000=12{,}600$. (ii) rate 5% for 4 periods: $60000(1.05)^4-60000\approx12{,}930.38$. (iii) rate 2.5% for 8 periods: $60000(1.025)^8-60000\approx13{,}104.17$.', null::text),
  ('A sum of money doubles itself in 8 years at simple interest. Find the rate.', null::text, '12.5%', '8%', '25%', '6.25%', null::text, 'A', 3, 'GENERAL', 'If money doubles, $I=P$, so $PRT/100=P \Rightarrow RT=100 \Rightarrow R=100/8=12.5\%$.', null::text),
  ('At what compound rate will ₦50,000 amount to ₦66,550 in 3 years?', null::text, '10%', '11%', '9%', '12%', null::text, 'A', 3, 'GENERAL', '$(66550/50000)=1.331=(1+r)^3$; since $1.1^3=1.331$ exactly, $r=10\%$.', null::text),
  ('A laptop costs ₦200,000 and depreciates at 25% p.a. Find (i) its value after 3 years (ii) the total depreciation.', null::text, '(i) ₦84,375 (ii) ₦115,625', '(i) ₦75,000 (ii) ₦125,000', '(i) ₦84,375 (ii) ₦125,000', '(i) ₦150,000 (ii) ₦50,000', null::text, 'A', 3, 'GENERAL', '(i) $200000\times0.75^3=84{,}375$. (ii) $200000-84375=115{,}625$.', null::text),
  ('A machine depreciates from ₦500,000 to ₦320,000 in 2 years. Find (i) the annual depreciation rate (ii) its value after 5 years.', null::text, '(i) ≈20% (ii) ≈₦163,840', '(i) ≈36% (ii) ≈₦82,000', '(i) ≈20% (ii) ≈₦200,000', '(i) ≈18% (ii) ≈₦180,000', null::text, 'A', 4, 'GENERAL', '(i) $(320000/500000)=0.64=(1-r)^2 \Rightarrow 1-r=0.8 \Rightarrow r=20\%$. (ii) $500000\times0.8^5\approx163{,}840$.', null::text),
  ('A vehicle costing ₦5,000,000 has a salvage value of ₦500,000 after 8 years (straight-line depreciation). Find (i) the annual depreciation (ii) the book value after 5 years.', null::text, '(i) ₦562,500 (ii) ₦2,187,500', '(i) ₦625,000 (ii) ₦1,875,000', '(i) ₦562,500 (ii) ₦2,500,000', '(i) ₦450,000 (ii) ₦2,750,000', null::text, 'A', 3, 'GENERAL', '(i) $(5000000-500000)/8=562{,}500$. (ii) $5000000-5(562500)=2{,}187{,}500$.', null::text),
  ('Tunde saves ₦10,000 monthly for 4 years (48 months) at 12% p.a. compounded monthly. Find the approximate total saved.', null::text, '≈₦612,226', '≈₦480,000', '≈₦540,000', '≈₦600,000', null::text, 'A', 4, 'GENERAL', 'Monthly rate $=1\%$; future value $=10000\times[(1.01)^{48}-1]/0.01\approx₦612{,}226$.', null::text),
  ('What is the present value of receiving ₦50,000 annually for 6 years, at an 8% discount rate?', null::text, '≈₦231,145', '≈₦300,000', '≈₦250,000', '≈₦200,000', null::text, 'A', 4, 'GENERAL', '$PV=50000\times[1-1.08^{-6}]/0.08\approx₦231{,}145$.', null::text),
  ('A car loan of ₦2,500,000 at 15% p.a. is to be repaid over 5 years (60 monthly instalments). Find (i) the approximate monthly payment (ii) the total repaid (iii) the total interest.', null::text, '(i) ≈₦59,471 (ii) ≈₦3,568,260 (iii) ≈₦1,068,260', '(i) ≈₦41,667 (ii) ≈₦2,500,000 (iii) ₦0', '(i) ≈₦59,471 (ii) ≈₦2,975,000 (iii) ≈₦475,000', '(i) ≈₦69,444 (ii) ≈₦4,166,640 (iii) ≈₦1,666,640', null::text, 'A', 5, 'GENERAL', 'Monthly rate $=1.25\%$; payment $=2500000\times0.0125/(1-1.0125^{-60})\approx₦59{,}471$; total repaid $\approx59471\times60\approx₦3{,}568{,}260$; interest $\approx₦1{,}068{,}260$.', null::text),
  ('A mortgage of ₦8,000,000 at 9% p.a. is to be repaid over 15 years (180 monthly instalments). Find the approximate monthly payment.', null::text, '≈₦81,143', '≈₦60,000', '≈₦100,000', '≈₦44,444', null::text, 'A', 5, 'GENERAL', 'Monthly rate $=0.75\%$; payment $=8000000\times0.0075/(1-1.0075^{-180})\approx₦81{,}143$.', null::text),
  ('Compare ₦1,000,000 at 13% simple interest for 4 years vs 11% compound interest for 4 years, which is better and by how much?', null::text, 'SI is better, by ≈₦1,930', 'CI is better, by ≈₦1,930', 'They are exactly equal', 'CI is better, by ≈₦20,000', null::text, 'A', 4, 'GENERAL', 'SI$=1000000(1+0.13\times4)=₦1{,}520{,}000$. CI$=1000000\times1.11^4\approx₦1{,}518{,}070$. SI is better by ≈₦1,930.', null::text),
  ('A business investment of ₦3,000,000 yields profits of ₦400,000, ₦600,000, ₦800,000, ₦900,000 in Years 1-4. Find (i) the total profit (ii) the average annual return on investment (ROI).', null::text, '(i) ₦2,700,000 (ii) ≈22.5%/yr average', '(i) ₦2,700,000 (ii) ≈90%/yr average', '(i) ₦5,700,000 (ii) ≈47.5%/yr average', '(i) ₦2,700,000 (ii) ≈9%/yr average', null::text, 'A', 4, 'GENERAL', '(i) $400000+600000+800000+900000=2{,}700{,}000$. (ii) average profit $=2700000/4=675000$; ROI $=675000/3000000=22.5\%$/yr.', null::text),
  ('A treasury bill with 182-day maturity, face value ₦5,000,000, has a 14% discount rate. Find (i) the purchase price (ii) the interest (discount) earned.', null::text, '(i) ≈₦4,650,685 (ii) ≈₦349,315', '(i) ≈₦4,300,000 (ii) ≈₦700,000', '(i) ≈₦5,000,000 (ii) ₦0', '(i) ≈₦4,900,000 (ii) ≈₦100,000', null::text, 'A', 4, 'GENERAL', 'Discount $=5000000\times0.14\times(182/365)\approx₦349{,}315$; purchase price $=5000000-349315\approx₦4{,}650{,}685$.', null::text),
  ('Find the simple interest on ₦3,000 for 5 years at 6% p.a.', null::text, '₦900', '₦1,800', '₦180', '₦450', null::text, 'A', 2, 'GENERAL', '$I=3000\times6\times5/100=900$.', null::text),
  ('What will ₦3,000 amount to in 5 years at 6% p.a. simple interest?', null::text, '₦3,900', '₦3,750', '₦3,600', '₦3,300', null::text, 'A', 2, 'GENERAL', '$A=P+I=3000+900=3900$.', null::text),
  ('Find the simple interest on ₦2,500 for 2 years at 5% p.a.', null::text, '₦250', '₦500', '₦625', '₦1250', '₦6250', 'A', 2, 'GENERAL', '$I=2500\times5\times2/100=250$.', null::text),
  ('At what rate % p.a. will ₦520 yield simple interest of ₦39 in 3 years?', null::text, '4%', '3½%', '3%', '2½%', null::text, 'D', 3, 'GENERAL', '$R=39\times100/(520\times3)=3900/1560=2.5\%$.', null::text),
  ('Calculate the rate % p.a. at which ₦5,000 doubles itself in 20 years at simple interest.', null::text, '5%', '10%', '20%', '2.5%', null::text, 'A', 3, 'GENERAL', 'Doubling means $I=P$, so $RT=100 \Rightarrow R=100/20=5\%$.', null::text),
  ('A simple interest on a sum invested at 4% p.a. for 4 years was ₦4,040. How much was invested?', null::text, '₦25,250', '₦20,200', '₦16,160', '₦10,100', null::text, 'A', 3, 'GENERAL', '$P=4040\times100/(4\times4)=404000/16=25{,}250$.', null::text),
  ('How long will it take ₦2,600 to earn ₦520 at 5% p.a. simple interest?', null::text, '14 yrs', '10 yrs', '8 yrs', '4 yrs', null::text, 'D', 2, 'GENERAL', '$T=520\times100/(2600\times5)=52000/13000=4$ years.', null::text),
  ('After how many years will ₦6,000,000 yield ₦860,000 interest at 10% p.a. simple interest?', null::text, '1.4 yrs', '4yrs 8mo', '48 yrs', '96 yrs', null::text, 'A', 3, 'GENERAL', '$T=860000\times100/(6000000\times10)=86000000/60000000\approx1.4$ years.', null::text),
  ('Find the amount if simple interest is paid on ₦34,320 for 5 years at 6¼% p.a.', null::text, '₦45,045', '₦40,000', '₦44,000', '₦37,750', null::text, 'A', 3, 'GENERAL', '$I=34320\times6.25\times5/100=10{,}725$; $A=34320+10725=45{,}045$.', null::text),
  ('A man invests ₦20,000 in Bank A (y% p.a. simple interest) and ₦25,000 in Bank B (1.5y% p.a.); the total interest after 1 year is ₦4,600. Find y.', null::text, '8%', '10%', '6%', '12%', null::text, 'A', 4, 'GENERAL', '$I_1=200y$, $I_2=375y$; sum $=575y=4600 \Rightarrow y=8$.', null::text),
  ('₦p invested for 4 years at r% simple interest yields 0.36p naira in interest. Find r.', null::text, '9%', '4%', '14.4%', '36%', null::text, 'A', 3, 'GENERAL', '$I=pr(4)/100=0.36p \Rightarrow 4r/100=0.36 \Rightarrow r=9$.', null::text),
  ('A man took a loan of $P at 4% p.a. simple interest; after 5 years he paid back a total of $720. Find $P.', null::text, '$600', '$576', '$700', '$500', null::text, 'A', 3, 'GENERAL', 'Total repaid $=P(1+0.04\times5)=1.2P=720 \Rightarrow P=600$.', null::text),
  ('If simple interest on ₦4,500 for 3 years is ₦540, find the simple interest on ₦6,500 for 2 years at the same rate.', null::text, '₦520', '₦780', '₦360', '₦650', null::text, 'A', 3, 'GENERAL', 'Rate $=540\times100/(4500\times3)=4\%$. New interest $=6500\times4\times2/100=520$.', null::text),
  ('Find the rate at which ₦327.50 yields ₦78.60 simple interest in 6 years.', null::text, '4%', '5%', '3%', '6%', null::text, 'A', 3, 'GENERAL', '$R=78.60\times100/(327.5\times6)=7860/1965=4\%$.', null::text),
  ('If ₦10,000 is kept at 12½% p.a. simple interest, how long will it take to yield ₦2,500 interest?', null::text, '2 years', '1.25 years', '2.5 years', '4 years', null::text, 'A', 2, 'GENERAL', '$T=2500\times100/(10000\times12.5)=250000/125000=2$ years.', null::text),
  ('Find the simple interest on ₦2,970 for 12 years at 6% p.a.', null::text, '₦2,138.40', '₦1,782', '₦2,376', '₦356.40', null::text, 'A', 2, 'GENERAL', '$I=2970\times6\times12/100=2138.40$.', null::text),
  ('A man borrows ₦16,000 and repays ₦16,900 after 9 months. Find the rate % p.a.', null::text, '7½%', '5%', '10%', '6%', null::text, 'A', 3, 'GENERAL', '$I=900$, $T=9/12=0.75$; $R=900\times100/(16000\times0.75)=90000/12000=7.5\%$.', null::text),
  ('If ₦15,000 amounts to ₦20,000 in 2 years at simple interest, find the rate.', null::text, '16⅔%', '20%', '25%', '10%', null::text, 'A', 2, 'GENERAL', '$I=5000$; $R=5000\times100/(15000\times2)=500000/30000\approx16.67\%$.', null::text),
  ('Find the simple interest on ₦700 for 9 years at 3% p.a.', null::text, '₦189', '₦210', '₦63', '₦252', null::text, 'A', 2, 'GENERAL', '$I=700\times3\times9/100=189$.', null::text),
  ('At what rate % will ₦4,800 amount to ₦5,040 in 2½ years at simple interest?', null::text, '2%', '5%', '4%', '1%', null::text, 'A', 3, 'GENERAL', '$I=240$; $R=240\times100/(4800\times2.5)=24000/12000=2\%$.', null::text),
  ('Find the simple interest on ₦5,400 for 10 months at 5% p.a.', null::text, '₦225', '₦270', '₦450', '₦135', null::text, 'A', 2, 'GENERAL', '$I=5400\times5\times(10/12)/100=225$.', null::text),
  ('If ₦2,500 amounts to ₦3,500 in 4 years at simple interest, find the rate.', null::text, '10%', '14%', '25%', '8%', null::text, 'A', 2, 'GENERAL', '$I=1000$; $R=1000\times100/(2500\times4)=100000/10000=10\%$.', null::text),
  ('The compound interest on ₦500 for 2 years at 6% p.a. is:', null::text, '₦30', '₦31', '₦61.80', '₦91.80', '₦92.80', 'C', 3, 'GENERAL', '$A=500\times1.06^2=561.80$; $CI=561.80-500=61.80$.', null::text),
  ('Find the compound interest on ₦400 for 2 years at 8% p.a.', null::text, '₦32', '₦34.56', '₦66.56', '₦432', '₦466.56', 'C', 3, 'GENERAL', '$A=400\times1.08^2=466.56$; $CI=66.56$.', null::text),
  ('A man invests £1,500 for 2 years at compound interest. After 1 year, his money amounts to £1,560. Find (i) the rate of interest (ii) the interest earned in the second year.', null::text, '(i) 4% (ii) £62.40', '(i) 6% (ii) £93.60', '(i) 4% (ii) £60', '(i) 5% (ii) £78', null::text, 'A', 3, 'GENERAL', '(i) $(1560-1500)/1500=4\%$. (ii) second-year interest $=1560\times0.04=£62.40$.', null::text),
  ('A bond with face value ₦100,000 pays 9% annual interest. Find the annual interest payment.', null::text, '₦9,000', '₦900', '₦90,000', '₦10,000', null::text, 'A', 1, 'GENERAL', '$100000\times9\%=9000$.', null::text),
  ('An investor buys 800 shares at ₦35 each; the company pays a 12% dividend on a ₦40 nominal value per share. Find the total dividend.', null::text, '₦3,840', '₦2,800', '₦4,200', '₦3,360', null::text, 'A', 3, 'GENERAL', 'Dividend per share $=40\times0.12=4.8$; total $=800\times4.8=3{,}840$.', null::text),
  ('Calculate the VAT on goods worth ₦150,000 at 7.5%.', null::text, '₦11,250', '₦15,000', '₦7,500', '₦22,500', null::text, 'A', 1, 'GENERAL', '$150000\times7.5\%=11{,}250$.', null::text),
  ('A worker earns ₦1,800,000 annually; after a ₦300,000 tax-free allowance, tax is charged at 10% on the first ₦500,000 of taxable income and 15% on the remainder. Find the tax payable.', null::text, '₦200,000', '₦125,000', '₦180,000', '₦270,000', null::text, 'A', 4, 'GENERAL', 'Taxable income $=1800000-300000=1{,}500{,}000$; tax on first ₦500,000 $=50{,}000$; tax on remaining ₦1,000,000 at 15% $=150{,}000$; total $=₦200{,}000$.', null::text),
  ('A shop sells an item for ₦53,750 including 7.5% VAT; find the price before VAT.', null::text, '₦50,000', '₦49,500', '₦46,250', '₦51,000', null::text, 'A', 2, 'GENERAL', 'Price before VAT $=53750\div1.075=50{,}000$.', null::text),
  ('Shares with a ₦25 nominal value pay a 16% dividend; if purchased at ₦30, find the rate of return.', null::text, '13.33%', '16%', '20%', '10.67%', null::text, 'A', 3, 'GENERAL', 'Dividend per share $=25\times0.16=4$; rate of return $=4/30\approx13.33\%$.', null::text),
  ('Use logarithms to find the amount when ₦25,000 is invested at 12% compound interest for 4 years.', null::text, '≈₦39,338', '≈₦35,000', '≈₦30,000', '≈₦42,000', null::text, 'A', 3, 'GENERAL', '$A=25000\times1.12^4=25000\times1.573519\approx39{,}338$.', null::text),
  ('A company issues debentures worth ₦2,000,000 at 7% p.a. for 8 years; calculate the total interest payable.', null::text, '₦1,120,000', '₦140,000', '₦560,000', '₦2,240,000', null::text, 'A', 2, 'GENERAL', '$2000000\times0.07\times8=1{,}120{,}000$.', null::text),
  ('Calculate the current yield on a ₦100,000 bond with a 10% coupon rate, currently selling at ₦95,000.', null::text, '≈10.53%', '10%', '≈9.5%', '≈11%', null::text, 'A', 3, 'GENERAL', 'Current yield $=$ annual coupon $\div$ market price $=10000/95000\approx10.53\%$.', null::text),
  ('An investor owns 500 preference shares paying an 8% dividend on a ₦50 nominal value; calculate the annual dividend.', null::text, '₦2,000', '₦4,000', '₦1,600', '₦2,500', null::text, 'A', 2, 'GENERAL', 'Dividend per share $=50\times0.08=4$; total $=500\times4=2{,}000$.', null::text)
) as v(question_text, question_latex, option_a, option_b, option_c, option_d, option_e, correct_letter, difficulty, exam_type, explanation, exam_shortcut)
where c.subject = 'Mathematics' and t.class_level = 'SS3' and t.term = 1 and t.order_index = 109;
