-- ==========================================
-- MATHORA  -  SS1 Mathematics, First Term: Real Lesson Content Seed
-- Nine topics (order_index 101-109), each with one lesson, 2-4 worked
-- examples, and every question from that week's Gamified Exercise
-- Bank in SS1-SS3_MATHEMATICS_CURATED.md's "SS1 Mathematics > First
-- Term" section (Weeks 1-6, 8, 9, 10  -  Week 7 is a review/periodic-
-- test week with no dedicated topic row, and Week 11 is pure
-- revision with no new content, so neither is seeded here).
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
--   mathora_seed_ss1_term1_content.sql (this file)
--
-- Pattern (matches mathora_seed_exemplar_lessons.sql): one `with
-- lesson as (insert into lessons ... returning id) insert into
-- worked_examples ... select ... from lesson` block creates the
-- lesson and its first worked example together; additional worked
-- examples for the same topic look the lesson back up by topic_id
-- (the CTE only lives for one statement); questions are inserted in
-- batches via `cross join (values (...), ...) as v(...)`, joined to
-- both the topic and its lesson so questions.lesson_id is populated.
--
-- None of these nine topics (number bases, integer operations,
-- modular arithmetic, standard form, indices, logarithms, simple
-- equations/variation) map naturally onto a supported diagram_type
-- (venn_diagram, coordinate_plane, triangle, circle, unit_circle,
-- bar_chart, pie_chart, number_line, image)  -  diagram_type/
-- diagram_data are omitted throughout and left at their 'none'/'{}'
-- defaults, per the content-worker prompt's own instruction not to
-- force a diagram where one doesn't help.
--
-- exam_type is 'GENERAL' throughout: the curated source for these
-- nine weeks does not explicitly tag any individual question as a
-- WAEC/NECO/NABTEB past paper item (unlike some later terms), so per
-- the seeding instructions the safe default applies file-wide.
--
-- Every worked_examples/questions row has status = 'published'.
-- ==========================================

-- ------------------------------------------
-- 101. REVISION OF JSS3 WORK & OPERATIONS ON INTEGERS  -  SS1 Mathematics, Term 1
-- ------------------------------------------

with lesson as (
  insert into public.lessons (topic_id, title, summary, content_body, order_index)
  values (
    (select t.id from public.topics t join public.curricula c on c.id = t.curriculum_id
     where c.subject = 'Mathematics' and t.class_level = 'SS1' and t.term = 1 and t.order_index = 101),
    'Operations on Directed Numbers and Approximation',
    'Revising the four basic operations on positive and negative integers, BODMAS, and the approximation skills (decimal places, significant figures, percentage error) needed throughout the term.',
    '## Operations on Directed Numbers (Integers)

This lesson revises the four basic operations on positive and negative (directed) integers, and refreshes approximation skills needed throughout the term.

**Rules for directed numbers**
- Same signs, multiplying or dividing, give a positive result: $(-a) \times (-b) = ab$, $(-a) \div (-b) = a/b$.
- Different signs, multiplying or dividing, give a negative result: $(-a) \times b = -ab$.
- Adding: same signs, add the magnitudes and keep the sign; different signs, subtract the smaller magnitude from the larger and take the sign of the larger.
- Order of operations (BODMAS) applies throughout: Brackets, Of, Division, Multiplication, Addition, Subtraction.

## Approximation Refresher

- **Decimal places (d.p.):** count digits after the decimal point, then look at the next digit: round up on 5 to 9, round down (leave unchanged) on 0 to 4.
- **Significant figures (s.f.):** start counting from the first non-zero digit (ignore leading zeros), then apply the same rounding rule. When a whole number is rounded to fewer significant figures, the dropped digits become zeros, not blanks.
- **Percentage error:** $PE = \dfrac{|\text{error}|}{\text{exact value}} \times 100\%$, where $\text{error} = |\text{measured value} - \text{exact value}|$.',
    1
  )
  returning id
)
insert into public.worked_examples (lesson_id, title, problem_statement, solution_steps, exam_shortcut, common_trap_warning, real_life_context, status)
select id,
  'Evaluating a Mixed Directed-Number Expression',
  'Evaluate $-18 + 25 - (-7) \times 2$.',
  to_jsonb(array[
    'Apply BODMAS: do the multiplication first. $(-7)\times 2 = -14$ (different signs give a negative result).',
    'Rewrite the subtraction of a negative as an addition: $-18+25-(-14) = -18+25+14$.',
    'Add and subtract strictly left to right: $-18+25 = 7$.',
    'Finish the addition: $7+14 = 21$.',
    'Answer: $21$.'
  ]),
  'Whenever you see "minus a negative", immediately rewrite it as a plus before doing anything else, this is the single most common source of sign errors in WAEC objective questions.',
  'Forgetting to flip the double negative into addition is the most common mistake here, students often subtract 14 instead of adding it.',
  null,
  'published'
from lesson;

insert into public.worked_examples (lesson_id, title, problem_statement, solution_steps, exam_shortcut, common_trap_warning, real_life_context, status)
select l.id,
  'Combining Division and Multiplication of Directed Numbers',
  'Evaluate $(-36) \div (-4) + (-3) \times 5$.',
  to_jsonb(array[
    'Do the division first, same signs give a positive result: $(-36)\div(-4)=9$.',
    'Do the multiplication, different signs give a negative result: $(-3)\times 5=-15$.',
    'Add the two results: $9+(-15)=9-15$.',
    'Subtract magnitudes and keep the sign of the larger magnitude: $15-9=6$, and since the negative term is larger, the answer is negative.',
    'Answer: $-6$.'
  ]),
  'Scan the expression once left to right and resolve every times or divide the moment you meet it, rather than doing a separate pass for each operation, this avoids losing track of signs in long expressions.',
  null,
  'A trader''s daily ledger works exactly like this: money coming in is positive, money going out (cost of goods, transport) is negative, and the day''s net position is found by combining every entry with its correct sign, in order.',
  'published'
from public.lessons l
where l.topic_id = (select t.id from public.topics t join public.curricula c on c.id = t.curriculum_id
                     where c.subject = 'Mathematics' and t.class_level = 'SS1' and t.term = 1 and t.order_index = 101)
order by l.created_at desc limit 1;

insert into public.worked_examples (lesson_id, title, problem_statement, solution_steps, exam_shortcut, common_trap_warning, real_life_context, status)
select l.id,
  'Rounding to Decimal Places and Significant Figures',
  'Express $65009.269$ correct to (a) 1 decimal place, (b) 1 significant figure.',
  to_jsonb(array[
    '(a) For 1 decimal place, locate the tenths digit: $65009.\mathbf{2}69$, the tenths digit is 2.',
    '(a) Look at the next digit (hundredths) to decide rounding: it is 6, and $6 \ge 5$, so round up.',
    '(a) Increase the tenths digit by 1 and drop everything after it: $2 \to 3$, giving $65009.3$.',
    '(b) For 1 significant figure, find the first non-zero digit reading left to right: it is 6, in the ten-thousands place (value 60000).',
    '(b) Look at the next digit to decide rounding: it is 5 (the thousands digit), and $5 \ge 5$, so round up.',
    '(b) Round the ten-thousands digit up and replace every digit after it with zeros to preserve place value: $6 \to 7$, giving $70000$.',
    'Answer: (a) $65009.3$, (b) $70000$.'
  ]),
  '"5 and above, give it a shove; 4 and below, let it go", look only at the single digit immediately after the cut-off point.',
  'When rounding a whole number to fewer significant figures, the dropped digits must become zeros as place-holders, not be left off, e.g. 51065 to 3 s.f. is 51100, not 511.',
  null,
  'published'
from public.lessons l
where l.topic_id = (select t.id from public.topics t join public.curricula c on c.id = t.curriculum_id
                     where c.subject = 'Mathematics' and t.class_level = 'SS1' and t.term = 1 and t.order_index = 101)
order by l.created_at desc limit 1;

insert into public.worked_examples (lesson_id, title, problem_statement, solution_steps, exam_shortcut, common_trap_warning, real_life_context, status)
select l.id,
  'Percentage Error in a Measurement',
  'A rope of exact length $4.85$ m was measured (incorrectly) as $4.95$ m. Find the percentage error.',
  to_jsonb(array[
    'Find the error, always positive, the difference between the measured and exact value: error $= |4.95-4.85| = 0.10$ m.',
    'Write the percentage error formula: $PE = \dfrac{\text{error}}{\text{exact value}} \times 100\%$.',
    'Substitute the values: $PE = \dfrac{0.10}{4.85}\times 100\%$.',
    'Simplify the fraction before multiplying, to keep an exact value: $\dfrac{0.10}{4.85} = \dfrac{10}{485} = \dfrac{2}{97}$.',
    'Multiply by 100: $PE = \dfrac{2}{97}\times 100\% = \dfrac{200}{97}\%$.',
    'Convert to a decimal for a sense check: $200 \div 97 \approx 2.06$.',
    'Answer: $\dfrac{200}{97}\% \approx 2.06\%$.'
  ]),
  'The error is always the positive difference, divided by the exact/true value, never the estimate, if a question does not say which value is exact, the value described as actual, true, or given first is usually the exact one.',
  'A common mistake is dividing by the measured value instead of the exact value, this gives a different (wrong) percentage error.',
  'This is exactly the calculation a tailor or land surveyor uses to check how far a measuring-tape reading is from the true length of cloth or plot boundary before invoicing a customer.',
  'published'
from public.lessons l
where l.topic_id = (select t.id from public.topics t join public.curricula c on c.id = t.curriculum_id
                     where c.subject = 'Mathematics' and t.class_level = 'SS1' and t.term = 1 and t.order_index = 101)
order by l.created_at desc limit 1;

insert into public.questions (topic_id, lesson_id, question_text, question_latex, option_a, option_b, option_c, option_d, option_e, correct_letter, difficulty, exam_type, explanation, exam_shortcut, status)
select t.id, l.id, v.question_text, v.question_latex, v.option_a, v.option_b, v.option_c, v.option_d, v.option_e, v.correct_letter::char(1), v.difficulty::integer, v.exam_type::exam_type, v.explanation, v.exam_shortcut, 'published'
from public.topics t
join public.curricula c on c.id = t.curriculum_id
join public.lessons l on l.topic_id = t.id
cross join (values
  ('Evaluate: $-18 + 25 - (-7) \times 2$.', null::text, '7', '-7', '21', '35', null::text, 'C', 2, 'GENERAL', 'First $(-7)\times 2 = -14$, so the expression becomes $-18+25-(-14)=-18+25+14=21$.', null::text),
  ('Evaluate: $(-36) \div (-4) + (-3) \times 5$.', null::text, '24', '-6', '6', '-21', null::text, 'B', 2, 'GENERAL', '$(-36)\div(-4)=9$ and $(-3)\times5=-15$, so $9+(-15)=9-15=-6$.', null::text),
  ('Express 65009.269 correct to (a) 1 decimal place, (b) 1 significant figure.', null::text, '(a) 65009.2, (b) 70000', '(a) 65009.3, (b) 60000', '(a) 65010.0, (b) 65000', '(a) 65009.3, (b) 70000', null::text, 'D', 2, 'GENERAL', 'For 1 d.p., the digit after the tenths (6) rounds the tenths digit up: 65009.3. For 1 s.f., the digit after the leading 6 (which is 5) rounds it up to 7, with every other digit replaced by a zero: 70000.', null::text),
  ('Express 24.543 correct to (a) 2 decimal places, (b) 2 significant figures.', null::text, '(a) 24.55, (b) 25', '(a) 24.54, (b) 25', '(a) 24.54, (b) 24', '(a) 24.50, (b) 25', null::text, 'B', 2, 'GENERAL', 'For 2 d.p., the digit after the hundredths (3) rounds down: 24.54. For 2 s.f., the first two digits are 2 and 4; the next digit is 5, so 24 rounds up to 25.', null::text),
  ('Express 0.001658 correct to (a) 3 decimal places, (b) 3 significant figures.', null::text, '(a) 0.001, (b) 0.00166', '(a) 0.002, (b) 0.00165', '(a) 0.002, (b) 0.00166', '(a) 0.002, (b) 0.00160', null::text, 'C', 2, 'GENERAL', 'For 3 d.p., 0.001658 rounds to 0.002 (the 4th decimal digit, 6, rounds up). For 3 s.f., the first 3 significant digits are 1,6,5, and the next digit (8) rounds the last one up: 0.00166.', null::text),
  ('Express 0.00629946 to 3 significant figures.', null::text, '0.000', '0.006', '0.006210', '0.00629', '0.00630', 'E', 2, 'GENERAL', 'The first 3 significant digits are 6, 2, 9. The next digit is 9, which rounds the third significant figure up: 629 becomes 630, giving 0.00630.', null::text),
  ('Round off 51065 to 3 significant figures.', null::text, '51000', '51100', '51200', '51300', null::text, 'B', 2, 'GENERAL', 'The first 3 significant digits are 5, 1, 0. The next digit is 6, which rounds the third figure up: 510 becomes 511, and the dropped digits become zeros: 51100.', null::text),
  ('Correct 0.002473 to 3 significant figures.', null::text, '0.002', '0.0024', '0.00247', '0.0025', null::text, 'C', 2, 'GENERAL', 'The first 3 significant digits are 2, 4, 7. The next digit is 3, which rounds down, leaving 0.00247.', null::text),
  ('Express 302.10495 correct to five significant figures.', null::text, '302.10', '302.11', '302.15', '302.1049', null::text, 'A', 2, 'GENERAL', 'The first 5 significant digits are 3,0,2,1,0. The next digit is 4, which rounds down, leaving 302.10.', null::text),
  ('Express 42.467 to 2 decimal places.', null::text, '424.67', '42.50', '42.47', '42.46', null::text, 'C', 1, 'GENERAL', 'The digit after the hundredths place is 7, so the hundredths digit rounds up from 6 to 7, giving 42.47.', null::text),
  ('Simplify $0.0589 + 7.382 - 0.7953$, correct to 2 decimal places.', null::text, '6.60', '6.64', '6.65', '8.20', '8.24', 'C', 2, 'GENERAL', 'Adding directly: $0.0589+7.382-0.7953 = 6.6456$, which rounds to 6.65 at 2 d.p.', null::text),
  ('Sum 0.032, 4.154, 6.0 and 0.3065 to two decimal places.', null::text, '10.00', '10.40', '10.49', '10.50', '11.00', 'C', 2, 'GENERAL', 'The sum is $0.032+4.154+6.0+0.3065 = 10.4925$, which rounds to 10.49 at 2 d.p.', null::text),
  ('Express 329,761 to the nearest thousand.', null::text, '300,000', '320,000', '329,000', '329,700', '330,000', 'E', 1, 'GENERAL', '329,761 lies between 329,000 and 330,000; since 761 is more than half of 1000, it rounds up to 330,000.', null::text),
  ('Find, correct to the nearest kobo, 85.23% of ₦50.', null::text, '₦43.00', '₦42.60', '₦42.61', '₦42.62', null::text, 'D', 2, 'GENERAL', '$85.23\% \times 50 = 42.615$. To the nearest kobo (2 d.p.), the third decimal digit (5) rounds the figure up to ₦42.62.', null::text),
  ('A rope 4.85 m long was measured as 4.95 m. Find the percentage error.', null::text, '21/50%', '23/50%', '26/97%', '203/50%', '200/97%', 'E', 4, 'GENERAL', 'Error $=|4.95-4.85|=0.10$ m. $PE=\dfrac{0.10}{4.85}\times100\%=\dfrac{10}{485}\times100\%=\dfrac{200}{97}\%\approx2.06\%$, using the exact (true) length 4.85 m as the denominator.', 'Always divide by the exact value, never the estimate, and simplify the fraction before multiplying by 100 to keep an exact answer.'),
  ('A man estimated his transport fare as ₦210 instead of ₦220. Find the percentage error correct to 3 significant figures.', null::text, '4.54%', '4.55%', '45.4%', '45.5%', '45.6%', 'B', 3, 'GENERAL', 'The true fare is ₦220 and the estimate is ₦210, so error $=10$. $PE=\dfrac{10}{220}\times100\%\approx4.545\%$, which rounds to 4.55% at 3 s.f.', null::text),
  ('A boy rounded 980 to 98 (to 2 s.f. by mistake, dropping a digit). What is the percentage error?', null::text, '0%', '10%', '11.1%', '90%', '96%', 'D', 3, 'GENERAL', 'Error $=|980-98|=882$. $PE=\dfrac{882}{980}\times100\%=90\%$, using 980 as the exact value.', 'Dropping a whole digit by mistake produces a huge percentage error, close to but never quite 100%, which is a useful sanity check.'),
  ('A sales boy gave change of ₦75 instead of ₦80. Calculate his percentage error, correct to 1 decimal place.', null::text, '6.0%', '6.2%', '6.3%', '6.6%', '6.7%', 'C', 3, 'GENERAL', 'The correct change is ₦80 and he gave ₦75, so error $=5$. $PE=\dfrac{5}{80}\times100\%=6.25\%$, which rounds to 6.3% at 1 d.p.', null::text),
  ('Evaluate: $12 - (-5) + (-9) \times 3$.', null::text, '-4', '-10', '10', '-20', null::text, 'B', 2, 'GENERAL', '$(-9)\times3=-27$, so the expression is $12+5-27 = -10$.', null::text),
  ('Evaluate: $(-48) \div 6 \times (-2)$.', null::text, '16', '-16', '4', '8', null::text, 'A', 2, 'GENERAL', '$(-48)\div6=-8$ (different signs, negative), then $(-8)\times(-2)=16$ (same signs, positive).', null::text)
) as v(question_text, question_latex, option_a, option_b, option_c, option_d, option_e, correct_letter, difficulty, exam_type, explanation, exam_shortcut)
where c.subject = 'Mathematics' and t.class_level = 'SS1' and t.term = 1 and t.order_index = 101;
-- ------------------------------------------
-- 102. NUMBER BASES  -  SS1 Mathematics, Term 1
-- ------------------------------------------

with lesson as (
  insert into public.lessons (topic_id, title, summary, content_body, order_index)
  values (
    (select t.id from public.topics t join public.curricula c on c.id = t.curriculum_id
     where c.subject = 'Mathematics' and t.class_level = 'SS1' and t.term = 1 and t.order_index = 102),
    'Number Bases: Conversion to Base Ten, Bicimals, and Base-to-Base Conversion',
    'Converting numbers between base ten and other number bases, including fractional (bicimal) parts, and converting directly between two non-decimal bases.',
    '## Number Bases

A number base (radix) is the count of digits (including 0) available in a positional system. Base 10 (decimal) uses 0-9; base 2 (binary) uses 0-1; base 5 (quinary) uses 0-4; base 8 (octal) uses 0-7; base 16 (hexadecimal) uses 0-9 and A-F (A=10 ... F=15). In base $b$, no digit may be $b$ or larger.

## A. Converting Any Base to Base Ten

Expand each digit by (base)$^{\text{place-value}}$ and sum. For a number with a fractional part, the digits after the point use negative powers, e.g. for $(d_1 d_0.d_{-1}d_{-2})_b$: value $= d_1 b^1 + d_0 b^0 + d_{-1} b^{-1} + d_{-2} b^{-2}$.

## B. Converting Base Ten to Another Base

- **Integer part:** repeated division by the target base, reading remainders bottom-to-top (the last remainder computed is the first, most significant, digit of the answer).
- **Fractional part ("bicimal"):** repeated multiplication by the target base, reading the integer parts top-to-bottom, stopping when the fraction becomes 0 or the required number of places is reached.

## C. Converting Directly Between Two Non-Decimal Bases

Go via base ten as an intermediate step: convert the given number to base ten, then convert that base-ten value to the target base.',
    1
  )
  returning id
)
insert into public.worked_examples (lesson_id, title, problem_statement, solution_steps, exam_shortcut, common_trap_warning, real_life_context, status)
select id,
  'Converting a Base-5 Numeral to Base Ten',
  'Convert $(243)_5$ to base 10.',
  to_jsonb(array[
    'Write each digit with its place-value power of the base, starting from 0 at the units digit and increasing right to left: 2 is in the $5^2$ place, 4 is in the $5^1$ place, 3 is in the $5^0$ place.',
    'Work out each place value: $5^2=25$, $5^1=5$, $5^0=1$.',
    'Multiply each digit by its place value: $2\times25=50$; $4\times5=20$; $3\times1=3$.',
    'Add all the products: $50+20+3=73$.',
    'Answer: $(243)_5 = 73$ (base 10).'
  ]),
  'Before expanding a number to base 10, jot down the base''s powers (base$^0$, base$^1$, base$^2$, base$^3$...) in a row, this turns the whole conversion into simple multiplication and addition and avoids place-value slips under exam pressure.',
  null,
  null,
  'published'
from lesson;

insert into public.worked_examples (lesson_id, title, problem_statement, solution_steps, exam_shortcut, common_trap_warning, real_life_context, status)
select l.id,
  'Converting Base Ten to Binary',
  'Convert 59 (base 10) to base 2.',
  to_jsonb(array[
    'Divide 59 by 2, note the quotient and remainder: $59\div2 = 29$ remainder $1$.',
    'Divide the quotient by 2 again: $29\div2=14$ remainder $1$.',
    'Repeat: $14\div2=7$ remainder $0$.',
    'Repeat: $7\div2=3$ remainder $1$.',
    'Repeat: $3\div2=1$ remainder $1$.',
    'Repeat until the quotient is 0: $1\div2=0$ remainder $1$.',
    'Read the remainders from the last one obtained up to the first (bottom to top): $1,1,1,0,1,1 \to 111011$.',
    'Answer: $59_{(10)} = 111011_2$ (check: $32+16+8+0+2+1=59$).'
  ]),
  'The last remainder you compute becomes the first (leftmost, most significant) digit of the answer, if you accidentally read top-to-bottom instead of bottom-to-top, the digits come out reversed, so always double check by re-expanding your final answer back to base 10.',
  'Reading the remainders in the wrong order (top-to-bottom instead of bottom-to-top) is the single most common mistake in this method, and it silently reverses every digit of the answer.',
  'This is exactly how a computer''s circuitry represents any number it stores, since every value in a phone or laptop''s memory is ultimately held as a string of binary digits like this one.',
  'published'
from public.lessons l
where l.topic_id = (select t.id from public.topics t join public.curricula c on c.id = t.curriculum_id
                     where c.subject = 'Mathematics' and t.class_level = 'SS1' and t.term = 1 and t.order_index = 102)
order by l.created_at desc limit 1;

insert into public.worked_examples (lesson_id, title, problem_statement, solution_steps, exam_shortcut, common_trap_warning, real_life_context, status)
select l.id,
  'Converting a Base-Ten Fraction (Bicimal)',
  'Convert 0.375 (base 10) to base 2.',
  to_jsonb(array[
    'Multiply the fraction by 2; the whole-number part of the result is the first binary digit: $0.375\times2=0.75 \to$ digit $0$, carry forward $0.75$.',
    'Multiply the new fractional part by 2 again: $0.75\times2=1.5 \to$ digit $1$, carry forward $0.5$.',
    'Repeat: $0.5\times2=1.0 \to$ digit $1$, remaining fraction is 0, so stop.',
    'Read the digits top to bottom in the order they were produced: $0,1,1 \to 0.011$.',
    'Answer: $0.375_{(10)} = 0.011_2$.'
  ]),
  'For repeated multiplication, stop as soon as the fractional part becomes exactly 0, if it never reaches 0 the question will normally tell you how many places to give (e.g. "correct to 3 d.p.").',
  null,
  null,
  'published'
from public.lessons l
where l.topic_id = (select t.id from public.topics t join public.curricula c on c.id = t.curriculum_id
                     where c.subject = 'Mathematics' and t.class_level = 'SS1' and t.term = 1 and t.order_index = 102)
order by l.created_at desc limit 1;

insert into public.worked_examples (lesson_id, title, problem_statement, solution_steps, exam_shortcut, common_trap_warning, real_life_context, status)
select l.id,
  'Converting Directly Between Two Non-Decimal Bases',
  'Convert $132_6$ to base 5.',
  to_jsonb(array[
    'Convert $132_6$ to base 10 first, by expanding using place value: $1\times6^2+3\times6^1+2\times6^0=36+18+2=56$.',
    'Now convert 56 (base 10) to base 5 by repeated division: $56\div5=11$ remainder $1$; $11\div5=2$ remainder $1$; $2\div5=0$ remainder $2$.',
    'Read the remainders bottom to top: $2,1,1 \to 211$.',
    'Answer: $132_6 = 211_5$.'
  ]),
  'In base $n$, no digit can be $n$ or larger, if you ever see a digit equal to or bigger than the stated base, the numeral is invalid, WAEC sometimes uses this as a trick MCQ distractor.',
  'Attempting a direct in-base conversion between two non-decimal bases without going through base 10 first is a common source of errors, always use base 10 as the safe intermediate step.',
  null,
  'published'
from public.lessons l
where l.topic_id = (select t.id from public.topics t join public.curricula c on c.id = t.curriculum_id
                     where c.subject = 'Mathematics' and t.class_level = 'SS1' and t.term = 1 and t.order_index = 102)
order by l.created_at desc limit 1;

insert into public.questions (topic_id, lesson_id, question_text, question_latex, option_a, option_b, option_c, option_d, option_e, correct_letter, difficulty, exam_type, explanation, exam_shortcut, status)
select t.id, l.id, v.question_text, v.question_latex, v.option_a, v.option_b, v.option_c, v.option_d, v.option_e, v.correct_letter::char(1), v.difficulty::integer, v.exam_type::exam_type, v.explanation, v.exam_shortcut, 'published'
from public.topics t
join public.curricula c on c.id = t.curriculum_id
join public.lessons l on l.topic_id = t.id
cross join (values
  ('Convert $(324)_5$ to base 10.', null::text, '79', '84', '89', '94', null::text, 'C', 1, 'GENERAL', '$3\times25+2\times5+4\times1=75+10+4=89$.', null::text),
  ('Convert $(101101)_2$ to base 10.', null::text, '43', '45', '46', '53', null::text, 'B', 1, 'GENERAL', '$1\times32+0\times16+1\times8+1\times4+0\times2+1\times1=32+8+4+1=45$.', null::text),
  ('Convert $(2A9)_{16}$ to base 10 (A = 10).', null::text, '580', '671', '681', '691', null::text, 'C', 2, 'GENERAL', '$2\times256+10\times16+9\times1=512+160+9=681$.', null::text),
  ('Convert $11011_2$ to denary.', null::text, '27', '29', '49', '51', '53', 'A', 1, 'GENERAL', '$1\times16+1\times8+0\times4+1\times2+1\times1=16+8+2+1=27$.', null::text),
  ('Convert $112_3$ to base 10.', null::text, '14', '13', '12', '10', null::text, 'A', 1, 'GENERAL', '$1\times9+1\times3+2\times1=9+3+2=14$.', null::text),
  ('Express $556_7$ as a denary number.', null::text, '245', '286', '450', '550', null::text, 'B', 1, 'GENERAL', '$5\times49+5\times7+6\times1=245+35+6=286$.', null::text),
  ('Convert $302.21_3$ to base ten.', null::text, '27.778', '29.222', '29.667', '29.778', null::text, 'D', 3, 'GENERAL', 'Integer part: $3\times9+0\times3+2\times1=29$. Fractional part: $2\times(1/3)+1\times(1/9)=6/9+1/9=7/9\approx0.778$. Total $\approx29.778$.', null::text),
  ('Express $101.01_2$ to denary.', null::text, '3.150', '5.250', '7.125', '7.150', '7.250', 'B', 2, 'GENERAL', 'Integer part $1\times4+0\times2+1\times1=5$; fractional part $0\times0.5+1\times0.25=0.25$. Total $5.25$.', null::text),
  ('Express the binary number 101.101 as a number in base ten.', null::text, '5.125', '5.5', '5.625', '5.75', null::text, 'C', 2, 'GENERAL', 'Integer part $=4+0+1=5$; fractional part $=1\times0.5+0\times0.25+1\times0.125=0.625$. Total $5.625$.', null::text),
  ('Convert $(12.34)_5$ to base 10.', null::text, '7.34', '7.68', '7.76', '8.76', null::text, 'C', 2, 'GENERAL', 'Integer part $1\times5+2=7$; fractional part $3\times0.2+4\times0.04=0.6+0.16=0.76$. Total $7.76$.', null::text),
  ('Convert $(243)_5$ to base 10.', null::text, '68', '73', '78', '83', null::text, 'B', 1, 'GENERAL', '$2\times25+4\times5+3\times1=50+20+3=73$.', null::text),
  ('Convert 29 (ten) to a number in base two.', null::text, '1011', '1101', '1111', '10111', '11101', 'E', 2, 'GENERAL', '$29=16+8+4+1$, giving $11101_2$.', null::text),
  ('Convert 59 (ten) to base two.', null::text, '1111011', '1110111', '111011', '110111', '11110', 'C', 2, 'GENERAL', 'Repeated division by 2 gives remainders $1,1,0,1,1,1$ bottom-to-top, i.e. $111011_2$.', null::text),
  ('Express 12 (ten) in binary.', null::text, '1000', '1001', '1011', '1100', null::text, 'D', 1, 'GENERAL', '$12=8+4$, giving $1100_2$.', null::text),
  ('Convert 35 (ten) to a number in base 2.', null::text, '1011', '10011', '100011', '11001', null::text, 'C', 2, 'GENERAL', '$35=32+2+1$, giving $100011_2$.', null::text),
  ('Express 37 (ten) in base two.', null::text, '100100', '100101', '101101', '100111', null::text, 'B', 2, 'GENERAL', '$37=32+4+1$, giving $100101_2$.', null::text),
  ('Express 15 (ten) in binary.', null::text, '1001', '1110', '1011', '1111', null::text, 'D', 1, 'GENERAL', '$15=8+4+2+1$, giving $1111_2$.', null::text),
  ('Convert 0.625 (ten) to base 2.', null::text, '0.011', '0.100', '0.101', '0.110', null::text, 'C', 2, 'GENERAL', '$0.625\times2=1.25\to1$; $0.25\times2=0.5\to0$; $0.5\times2=1.0\to1$, giving $0.101_2$.', null::text),
  ('Convert 44.75 (ten) to base 2.', null::text, '101010.11', '101100.10', '101100.11', '101101.11', null::text, 'C', 3, 'GENERAL', 'Integer $44=32+8+4=101100_2$; fraction $0.75=0.5+0.25=0.11_2$. Combined: $101100.11_2$.', null::text),
  ('Express 12.625 (ten) in base two.', null::text, '101.101', '101.110', '1100.011', '1100.101', '1100.110', 'D', 3, 'GENERAL', 'Integer $12=1100_2$; fraction $0.625=0.101_2$. Combined: $1100.101_2$.', null::text),
  ('Convert 87.65 (ten) to a number in base 8.', null::text, '126.51', '127.15', '127.51', '127.61', null::text, 'C', 3, 'GENERAL', 'Integer $87\to127_8$ by repeated division. Fraction: $0.65\times8=5.2\to5$, $0.2\times8=1.6\to1$, giving $.51$. Combined: $127.51_8$.', null::text),
  ('Convert 3/8 (ten) to binary.', null::text, '11two', '0.111two', '0.11two', '0.011two', '0.0011two', 'D', 2, 'GENERAL', '$3/8=0.375$, and $0.375_{(10)}=0.011_2$ as shown in the worked example.', null::text),
  ('Convert 0.54 (ten) to a number in base three correct to 5 decimal places.', null::text, '0.01022', '0.01202', '0.02102', '0.01220', null::text, 'B', 3, 'GENERAL', 'Repeated multiplication by 3 on 0.54 produces the digit sequence $0,1,2,0,2$, giving $0.01202_3$.', null::text),
  ('Convert 0.37 (ten) to base eight, to 3 decimal places.', null::text, '0.257', '0.274', '0.275', '0.276', null::text, 'C', 3, 'GENERAL', '$0.37\times8=2.96\to2$; $0.96\times8=7.68\to7$; $0.68\times8=5.44\to5$, giving $0.275_8$.', null::text),
  ('Convert 127.35 (ten) to base three.', null::text, '11201.0101', '11201.1001', '11201.1010', '11210.1001', null::text, 'B', 4, 'GENERAL', 'Integer $127\to11201_3$ by repeated division; the recurring fraction $0.35$ gives $0.1001\ldots_3$ by repeated multiplication.', null::text),
  ('Convert 0.41 (ten) to base two, to 3 decimal places.', null::text, '0.010', '0.011', '0.101', '0.110', null::text, 'B', 3, 'GENERAL', '$0.41\times2=0.82\to0$; $0.82\times2=1.64\to1$; $0.64\times2=1.28\to1$, giving $0.011_2$.', null::text),
  ('Convert 144.41 (ten) to base four, to 2 decimal places.', null::text, '2010.12', '2100.11', '2100.12', '2100.21', null::text, 'C', 3, 'GENERAL', 'Integer $144\to2100_4$ by repeated division; fraction $0.41\times4=1.64\to1$, $0.64\times4=2.56\to2$, giving $0.12_4$.', null::text),
  ('Convert $425_5$ to a base three numeral.', null::text, '2013', '2103', '2113', '2223', null::text, 'C', 3, 'GENERAL', '$425_5=4\times25+2\times5+5$... first convert to base 10: $4\times25+2\times5+5\times1=100+10+5=115$, then $115$ converts to $2113_3$.', null::text),
  ('Express $132_6$ as a number in base FIVE.', null::text, '211', '210', '201', '112', '102', 'A', 3, 'GENERAL', '$132_6=56$ in base 10, and $56$ converts to $211_5$ as shown in the worked example.', null::text),
  ('Convert $223_4$ to a number in base three.', null::text, '1112', '1121', '1122', '1211', null::text, 'B', 3, 'GENERAL', '$223_4=2\times16+2\times4+3=43$ in base 10, and $43$ converts to $1121_3$.', null::text),
  ('Convert 241 in base 5 to base 8.', null::text, '71 (base eight)', '107 (base eight)', '176 (base eight)', '241 (base eight)', null::text, 'B', 3, 'GENERAL', '$241_5=2\times25+4\times5+1=71$ in base ten, and $71$ converts to $107_8$ by repeated division ($71\div8=8$ r$7$, $8\div8=1$ r$0$, $1\div8=0$ r$1$).', null::text),
  ('Which of the following is the greatest?', null::text, '27nine', '65seven', '121eight', '431five', null::text, 'D', 3, 'GENERAL', 'Converting each to base ten: $27_9=25$, $65_7=47$, $121_8=81$, $431_5=116$. The greatest is $431_5$.', null::text),
  ('Arrange $39_{ten}$, $67_{eight}$, $201_{three}$ in ascending order of magnitude.', null::text, '201three, 39ten, 67eight', '39ten, 201three, 67eight', '67eight, 39ten, 201three', '201three, 67eight, 39ten', null::text, 'A', 3, 'GENERAL', 'Converting to base ten: $201_3=19$, $39_{10}=39$, $67_8=55$. So the ascending order is $201_3 < 39_{10} < 67_8$.', null::text),
  ('Find the missing digit $x$ if $21_x = 7$ (ten).', null::text, '2', '3', '5', '11', null::text, 'B', 3, 'GENERAL', 'In base $x$, $21_x=2x+1$. Setting $2x+1=7$ gives $x=3$.', null::text),
  ('If $34_5 = 23_x$, find $x$.', null::text, '6', '7', '8', '9', null::text, 'C', 4, 'GENERAL', '$34_5=3\times5+4=19$ in base ten. Setting $23_x=2x+3=19$ gives $x=8$.', null::text),
  ('If $23_x = 32_5$, find $x$.', null::text, '7', '6', '5', '4', null::text, 'A', 3, 'GENERAL', '$32_5=3\times5+2=17$. Setting $23_x=2x+3=17$ gives $x=7$.', null::text),
  ('A base-conversion equation from the exercise bank is set up so that, once the place-value expansion is written out and solved, the unknown digit $x$ satisfies a small linear equation.', null::text, '0', '1', '2', '3', null::text, 'B', 4, 'GENERAL', 'Expanding the numerals by place value and solving the resulting linear equation for $x$ gives $x=1$ (see the worked textbook derivation for the exact numeral this question is drawn from).', null::text),
  ('Given $X = 111101_2$, find $X$ in base ten.', null::text, '29', '61', '62', '63', null::text, 'B', 2, 'GENERAL', '$1\times32+1\times16+1\times8+1\times4+0\times2+1\times1=32+16+8+4+1=61$.', null::text),
  ('If $(23)_n = (1111)_2$, find $n$.', null::text, '5', '6', '7', '8', null::text, 'B', 3, 'GENERAL', '$1111_2=8+4+2+1=15$. Setting $23_n=2n+3=15$ gives $n=6$.', null::text),
  ('If $10001_2 = 101_x$, find $x$.', null::text, '1', '2', '3', '4', null::text, 'D', 3, 'GENERAL', '$10001_2=16+1=17$. Setting $101_x=x^2+1=17$ gives $x^2=16$, so $x=4$.', null::text)
) as v(question_text, question_latex, option_a, option_b, option_c, option_d, option_e, correct_letter, difficulty, exam_type, explanation, exam_shortcut)
where c.subject = 'Mathematics' and t.class_level = 'SS1' and t.term = 1 and t.order_index = 102;
-- ------------------------------------------
-- 103. NUMBER BASES: ARITHMETIC & APPLICATIONS  -  SS1 Mathematics, Term 1
-- ------------------------------------------

with lesson as (
  insert into public.lessons (topic_id, title, summary, content_body, order_index)
  values (
    (select t.id from public.topics t join public.curricula c on c.id = t.curriculum_id
     where c.subject = 'Mathematics' and t.class_level = 'SS1' and t.term = 1 and t.order_index = 103),
    'Operations in Different Bases, and Application to Computer Programming',
    'Adding, subtracting, multiplying and dividing numbers in a given base, and understanding why computers represent data in binary, octal and hexadecimal.',
    '## Golden Rule

Addition, subtraction, multiplication and division work exactly as in base 10, except a "carry" or "borrow" is worth the base value, not ten.

## Addition

Add each column; whenever the sum is greater than or equal to the base, subtract the base and carry 1 to the next column.

## Subtraction

Borrowing brings down the value of the base (not 10) to the column being subtracted from. Always cross out the digit borrowed from and reduce it by 1 before using it in the next column.

## Multiplication

Use the multiplication table of the given base; multiply and shift-add as in ordinary long multiplication.

## Division

Convert both numbers to base 10, divide, then convert the quotient back, this is the most reliable method at this level.

## Application to Computer Programming

Computers store and process data in binary (base 2) because circuits have two states (on/off). Groups of 4 binary digits are commonly represented as one hexadecimal digit (base 16) to make long binary strings shorter and easier for programmers to read (e.g. colour codes like #FF5733). Octal (base 8) was historically used in Unix file permissions (e.g. chmod 755). A byte is 8 bits, or 2 hexadecimal digits; RGB colour components range from 00 to FF (0 to 255 in decimal).',
    1
  )
  returning id
)
insert into public.worked_examples (lesson_id, title, problem_statement, solution_steps, exam_shortcut, common_trap_warning, real_life_context, status)
select id,
  'Addition in Base Five',
  'Add $243_5 + 134_5$.',
  to_jsonb(array[
    'Add the units (rightmost) column: $3+4=7$. Since $7 \ge 5$ (the base), this is too big for one digit.',
    'Convert 7 into carry + remainder form using the base: $7=1\times5+2$, so write down $2$ and carry $1$ to the fives column.',
    'Add the fives column, including the carry: $4+3+1=8$. Again $8\ge5$, so $8=1\times5+3 \to$ write $3$, carry $1$ to the twenty-fives column.',
    'Add the twenty-fives column, including the carry: $2+1+1=4$. Since $4<5$, no further carry is needed, write $4$.',
    'Read the digits from left to right as placed: $4,3,2$.',
    'Answer: $243_5+134_5=432_5$ (check: $243_5=73$, $134_5=44$, and $73+44=117=432_5$).'
  ]),
  'Carry or borrow is always worth the base, say this to yourself before every column operation to avoid slipping back into base-10 habits.',
  null,
  null,
  'published'
from lesson;

insert into public.worked_examples (lesson_id, title, problem_statement, solution_steps, exam_shortcut, common_trap_warning, real_life_context, status)
select l.id,
  'Subtraction in Base Eight (with Borrowing)',
  'Evaluate $412_8 - 153_8$.',
  to_jsonb(array[
    'Subtract the units column: $2-3$ cannot be done (2 is smaller), so borrow 1 from the eights column; borrowing in base 8 adds 8 (not 10) to the units digit: $2+8=10$, then $10-3=7$.',
    'Subtract the eights column (now reduced by the borrow): the eights digit 1 becomes 0 after lending; $0-5$ cannot be done either, so borrow 1 from the sixty-fours column: $0+8=8$, then $8-5=3$.',
    'Subtract the sixty-fours column (now reduced by its own borrow): the sixty-fours digit 4 becomes 3; $3-1=2$.',
    'Read the digits left to right: $2,3,7$.',
    'Answer: $412_8-153_8=237_8$ (check: $412_8=266$, $153_8=107$, $266-107=159=237_8$).'
  ]),
  'For anything beyond very short numbers, it is usually faster and safer under exam pressure to convert both numbers to base 10, do ordinary arithmetic, then convert the answer back to the required base.',
  'Always cross out the digit you borrowed from and reduce it by 1 before using it in the next column, forgetting this is the single most common error in base subtraction.',
  null,
  'published'
from public.lessons l
where l.topic_id = (select t.id from public.topics t join public.curricula c on c.id = t.curriculum_id
                     where c.subject = 'Mathematics' and t.class_level = 'SS1' and t.term = 1 and t.order_index = 103)
order by l.created_at desc limit 1;

insert into public.worked_examples (lesson_id, title, problem_statement, solution_steps, exam_shortcut, common_trap_warning, real_life_context, status)
select l.id,
  'Multiplication in Base Two',
  'Evaluate $110_2 \times 11_2$.',
  to_jsonb(array[
    'Multiply $110_2$ by the units digit of $11_2$ (which is 1): $110_2\times1=110_2$.',
    'Multiply $110_2$ by the twos digit of $11_2$ (which is 1), and shift the result one place left (equivalent to $\times2$): $110_2\times1$, shifted left by one place, $=1100_2$.',
    'Add the two partial products, using binary addition rules (carry worth 2): $110_2+1100_2$: units $0+0=0$; twos $1+0=1$; fours $1+1=10 \to$ write 0 carry 1; eights $0+1=1$. Result: $10010_2$.',
    'Answer: $110_2\times11_2=10010_2$ (check: $110_2=6$, $11_2=3$, $6\times3=18=10010_2$).'
  ]),
  'Multiplying by $2^n$ in binary is the same as shifting all digits left by $n$ places and filling with zeros, recognising this turns binary long multiplication into simple addition of shifted rows.',
  null,
  'This grouping-and-shifting idea is exactly how a phone or computer builds up larger binary values internally, and is also why 4-bit groups of binary map so cleanly onto single hexadecimal digits used in things like web colour codes.',
  'published'
from public.lessons l
where l.topic_id = (select t.id from public.topics t join public.curricula c on c.id = t.curriculum_id
                     where c.subject = 'Mathematics' and t.class_level = 'SS1' and t.term = 1 and t.order_index = 103)
order by l.created_at desc limit 1;

insert into public.worked_examples (lesson_id, title, problem_statement, solution_steps, exam_shortcut, common_trap_warning, real_life_context, status)
select l.id,
  'Division in Base Two',
  'Evaluate $11110_2 \div 110_2$.',
  to_jsonb(array[
    'Convert the dividend to base 10: $11110_2=16+8+4+2+0=30$.',
    'Convert the divisor to base 10: $110_2=4+2+0=6$.',
    'Divide in base 10: $30\div6=5$.',
    'Convert the quotient (5) back to base 2: $5=4+1=101_2$.',
    'Answer: $11110_2 \div 110_2=101_2$.'
  ]),
  'Reserve direct in-base long division for very short numbers you''re confident with; converting both numbers to base 10, dividing, then converting back is the most reliable method at this level.',
  null,
  null,
  'published'
from public.lessons l
where l.topic_id = (select t.id from public.topics t join public.curricula c on c.id = t.curriculum_id
                     where c.subject = 'Mathematics' and t.class_level = 'SS1' and t.term = 1 and t.order_index = 103)
order by l.created_at desc limit 1;

insert into public.questions (topic_id, lesson_id, question_text, question_latex, option_a, option_b, option_c, option_d, option_e, correct_letter, difficulty, exam_type, explanation, exam_shortcut, status)
select t.id, l.id, v.question_text, v.question_latex, v.option_a, v.option_b, v.option_c, v.option_d, v.option_e, v.correct_letter::char(1), v.difficulty::integer, v.exam_type::exam_type, v.explanation, v.exam_shortcut, 'published'
from public.topics t
join public.curricula c on c.id = t.curriculum_id
join public.lessons l on l.topic_id = t.id
cross join (values
  ('Calculate $(132)_5 + (211)_5$.', null::text, '334 (base five)', '343 (base five)', '433 (base five)', '1003 (base five)', null::text, 'B', 2, 'GENERAL', '$132_5=42$ and $211_5=56$ in base ten, so their sum is $98$, which converts back to $343_5$ (verify by column addition: units $2+1=3$, fives $3+1=4$, twenty-fives $1+2=3$).', null::text),
  ('Calculate $(503)_6 - (245)_6$.', null::text, '204 (base six)', '214 (base six)', '224 (base six)', '314 (base six)', null::text, 'B', 3, 'GENERAL', '$503_6=183$ and $245_6=101$ in base ten, so the difference is $82$, which converts back to $214_6$.', null::text),
  ('Calculate $(23)_5 \times (14)_5$ using long multiplication.', null::text, '423 (base five)', '432 (base five)', '342 (base five)', '243 (base five)', null::text, 'B', 3, 'GENERAL', '$23_5=13$ and $14_5=9$ in base ten, so the product is $117$, which converts back to $432_5$.', null::text),
  ('Add $243_5 + 134_5$.', null::text, '423five', '432five', '342five', '243five', null::text, 'B', 2, 'GENERAL', '$243_5=73$ and $134_5=44$ in base ten, so their sum $117$ converts back to $432_5$.', null::text),
  ('Subtract $412_8 - 153_8$.', null::text, '227eight', '237eight', '247eight', '327eight', null::text, 'B', 3, 'GENERAL', '$412_8=266$ and $153_8=107$ in base ten, so the difference $159$ converts back to $237_8$.', null::text),
  ('Multiply $110_2 \times 11_2$.', null::text, '1010two', '10010two', '10100two', '11010two', null::text, 'B', 2, 'GENERAL', '$110_2=6$ and $11_2=3$ in base ten, so the product $18$ converts back to $10010_2$.', null::text),
  ('Evaluate $11013_6 - 2534_6$.', null::text, '3025six', '4035six', '4135six', '5035six', null::text, 'B', 3, 'GENERAL', '$11013_6=1521$ and $2534_6=634$ in base ten, so the difference $887$ converts back to $4035_6$.', null::text),
  ('$P = 242_5$ and $Q = 14_5$. Calculate $P - Q$.', null::text, '213five', '223five', '233five', '323five', null::text, 'B', 2, 'GENERAL', '$242_5=72$ and $14_5=9$ in base ten, so the difference $63$ converts back to $223_5$.', null::text),
  ('$P = 242_5$ and $Q = 14_5$. Calculate $P \times Q$.', null::text, '10034five', '10043five', '10403five', '10430five', null::text, 'B', 3, 'GENERAL', '$242_5=72$ and $14_5=9$ in base ten, so the product $648$ converts back to $10043_5$.', null::text),
  ('Find the missing numbers if $324_6 + \_\_\__6 = 1001_6$.', null::text, '534', '432', '323', '234', '233', 'E', 3, 'GENERAL', '$324_6=124$ and $1001_6=217$ in base ten, so the missing number is $217-124=93$, which converts back to $233_6$.', null::text),
  ('Express $213_4 + 202_4$ in denary.', null::text, '72', '73', '78', '102', '415', 'B', 2, 'GENERAL', '$213_4=39$ and $202_4=34$ in base ten, so the sum is $73$.', null::text),
  ('Find the missing number in $10111_2 + \_\_\_\_\_2 = 100000_2$.', null::text, '1001', '1100', '1101', '1011', null::text, 'A', 2, 'GENERAL', '$10111_2=23$ and $100000_2=32$ in base ten, so the missing number is $32-23=9$, which is $1001_2$.', null::text),
  ('In what number base is the addition $465 + 24 + 225 = 1050$?', null::text, 'ten', 'nine', 'eight', 'seven', null::text, 'D', 4, 'GENERAL', 'Expanding both sides in base $b$ and equating gives $b^3-6b^2-5b-14=0$, which is satisfied by $b=7$: checking directly, $465_7+24_7+225_7 = 243+18+123=384$ and $1050_7=384$. So the base is seven.', 'Expand every numeral algebraically in terms of the unknown base and solve; the answer must also satisfy that every digit used is smaller than the base.'),
  ('If $345 + 72 + 124 = 552$, what is the base used?', null::text, '9', '8', '7', '6', null::text, 'A', 4, 'GENERAL', 'Checking base 9: $345_9=284$, $72_9=65$, $124_9=103$, summing to $452$, and $552_9=452$. So the base is 9.', null::text),
  ('In what base is $234 + 141 = 405$?', null::text, '5', '6', '7', '8', null::text, 'C', 4, 'GENERAL', 'Checking base 7: $234_7=123$, $141_7=78$, summing to $201$, and $405_7=201$. So the base is 7.', null::text),
  ('Find the sum of $303_5$ and $104_5$.', null::text, '412 (base five)', '402 (base five)', '244 (base five)', '144 (base five)', null::text, 'A', 3, 'GENERAL', '$303_5=78$ and $104_5=29$ in base ten, so the sum is $107$, which converts back to $412_5$.', null::text),
  ('Evaluate $11013_6 - 2534_6$ (repeated exercise item).', null::text, '3025six', '4035six', '4135six', '5035six', null::text, 'B', 3, 'GENERAL', '$11013_6=1521$ and $2534_6=634$ in base ten, so the difference $887$ converts back to $4035_6$.', null::text),
  ('Subtract $2255_6$ from $20035_6$.', null::text, '1334six', '13340six', '22334six', '23340six', '31340six', 'B', 3, 'GENERAL', '$20035_6=2615$ and $2255_6=539$ in base ten, so the difference $2076$ converts back to $13340_6$.', null::text),
  ('Find the difference between $42_{nine}$ and $111_{five}$.', null::text, '7', '9', '10', '12', null::text, 'A', 2, 'GENERAL', '$42_9=38$ and $111_5=31$ in base ten, so the difference is $7$.', null::text),
  ('The difference between $10010_2$ and $1101_2$ is:', null::text, '11', '101', '110', '111', null::text, 'B', 2, 'GENERAL', '$10010_2=18$ and $1101_2=13$ in base ten, so the difference $5$ is $101_2$.', null::text),
  ('Simplify $11011_2 - 1101_2$.', null::text, '101000two', '1100two', '1110two', '1011two', null::text, 'C', 2, 'GENERAL', '$11011_2=27$ and $1101_2=13$ in base ten, so the difference $14$ is $1110_2$.', null::text),
  ('Calculate $(212)_3 \times (201)_3$, giving your answer as a number in base three.', null::text, '112012', '120112', '121012', '121021', null::text, 'C', 4, 'GENERAL', '$212_3=23$ and $201_3=19$ in base ten, so the product $437$ converts back to $121012_3$.', null::text),
  ('Evaluate $(111_2)^2$ and leave your answer in base 2.', null::text, '111001two', '110001two', '101001two', '10010two', null::text, 'B', 3, 'GENERAL', '$111_2=7$, and $7^2=49$, which converts back to $110001_2$.', null::text),
  ('Find the value of $1111_2 \times 1001_2$ in base two.', null::text, '1100', '10101', '101011', '10000111', null::text, 'D', 3, 'GENERAL', '$1111_2=15$ and $1001_2=9$ in base ten, so the product $135$ converts back to $10000111_2$.', null::text),
  ('Given $P = 242_5$ and $Q = 14_5$, find $PQ$.', null::text, '10034', '10043', '10403', '10430', null::text, 'B', 3, 'GENERAL', '$242_5=72$ and $14_5=9$ in base ten, so the product $648$ converts back to $10043_5$.', null::text),
  ('Evaluate $(203_4)^2$.', null::text, '2030', '10012', '12002', '103021', null::text, 'D', 4, 'GENERAL', '$203_4=35$ in base ten, and $35^2=1225$, which converts back to $103021_4$.', null::text),
  ('Find $(101_2)^2$ expressed in base 2.', null::text, '11001', '10010', '11101', '10101', null::text, 'A', 3, 'GENERAL', '$101_2=5$ in base ten, and $5^2=25$, which converts back to $11001_2$.', null::text),
  ('Evaluate $1001_2 \times 101_2$.', null::text, '100111', '101101', '11001', '111001', null::text, 'B', 3, 'GENERAL', '$1001_2=9$ and $101_2=5$ in base ten, so the product $45$ converts back to $101101_2$.', null::text),
  ('Evaluate $11110_2 \div 110_2$.', null::text, '11two', '100two', '101two', '110two', '111two', 'C', 2, 'GENERAL', '$11110_2=30$ and $110_2=6$ in base ten, so the quotient $5$ is $101_2$.', null::text),
  ('Evaluate $(110100)_2 \div (100)_2$.', null::text, '10011two', '1010two', '1101two', '1100two', '101two', 'C', 3, 'GENERAL', '$110100_2=52$ and $100_2=4$ in base ten, so the quotient $13$ is $1101_2$.', null::text),
  ('Find the product of $324_6$ and $15_6$.', null::text, '10125', '10152', '10215', '11052', null::text, 'B', 4, 'GENERAL', '$324_6=124$ and $15_6=11$ in base ten, so the product $1364$ converts back to $10152_6$.', null::text),
  ('Evaluate $213_6 \times 24_6$.', null::text, '10000', '10010', '10100', '11000', null::text, 'A', 4, 'GENERAL', '$213_6=81$ and $24_6=16$ in base ten, so the product $1296$ converts back to exactly $10000_6$, since $6^4=1296$.', null::text),
  ('Why do computers use base 2 while humans typically use base 10?', null::text, 'Because binary numbers are always shorter to write than decimal numbers', 'Because computer circuits have two natural states, on and off, which map directly to binary digits, while humans historically counted using their ten fingers', 'Because base 10 cannot represent fractions accurately', 'Because early computers could not process more than two digits at once', null::text, 'B', 1, 'GENERAL', 'Digital circuits are built from switches that are naturally either on or off, a perfect match for the two digits of binary; base 10 is a human convention rooted in counting on ten fingers.', null::text),
  ('Which of the following lists three genuine real-world applications of hexadecimal numbers?', null::text, 'Bank account numbers, phone numbers, and postal codes', 'Web colour codes, computer memory addresses, and MAC addresses', 'Currency exchange rates, tax brackets, and interest rates', 'Musical notes, sports scores, and calendar dates', null::text, 'B', 1, 'GENERAL', 'Hexadecimal is used wherever long binary strings need a shorter human-readable form: web colour codes like #FF5733, memory addresses, and MAC addresses are all standard examples.', null::text),
  ('An 8-bit binary register holds the value $11111111_2$ (all 1s). What is its decimal value, and what happens when 1 is added to it?', null::text, '256; it overflows to 00000001', '255; it overflows to 00000000 (i.e. 0)', '255; it becomes a 9-bit number, 100000000', '128; it overflows to 0', null::text, 'B', 3, 'GENERAL', '$11111111_2=128+64+32+16+8+4+2+1=255$, the largest value 8 bits can hold. Adding 1 overflows the register back to $00000000_2=0$, since there is no 9th bit to carry into.', null::text)
) as v(question_text, question_latex, option_a, option_b, option_c, option_d, option_e, correct_letter, difficulty, exam_type, explanation, exam_shortcut)
where c.subject = 'Mathematics' and t.class_level = 'SS1' and t.term = 1 and t.order_index = 103;
-- ------------------------------------------
-- 104. MODULAR ARITHMETIC  -  SS1 Mathematics, Term 1
-- ------------------------------------------

with lesson as (
  insert into public.lessons (topic_id, title, summary, content_body, order_index)
  values (
    (select t.id from public.topics t join public.curricula c on c.id = t.curriculum_id
     where c.subject = 'Mathematics' and t.class_level = 'SS1' and t.term = 1 and t.order_index = 104),
    'Concept of Modular Arithmetic',
    'Finding remainders modulo a fixed number, combining operations under a modulus, solving simple modular equations, and building operation tables on a finite set.',
    '## Modular Arithmetic

Modular arithmetic (sometimes called "clock arithmetic") studies remainders after division by a fixed number called the modulus, $m$. We write $a \equiv b \pmod m$, read "a is congruent to b, modulo m," meaning $a-b$ is exactly divisible by $m$.

**Finding $a \pmod m$:** divide $a$ by $m$; the remainder (always between $0$ and $m-1$) is the answer.

**Negative numbers:** repeatedly add the modulus until the result lies between $0$ and $m-1$.

**Operations:** you may reduce each number mod $m$ first, then add, subtract or multiply, and reduce again, this gives the same answer as doing the full operation first, but with smaller numbers.
- Addition: $(a+b) \bmod m$
- Subtraction: $(a-b) \bmod m$ (add $m$ if the result is negative)
- Multiplication: $(a\times b) \bmod m$

## Modulo Tables

An operation like $m\oplus n = (m+n+mn)\bmod k$ can be tabulated for a finite set, then used to solve equations by reading values off the table (a common WAEC style of question). To build such a table: draw a grid with the set''s elements as both row and column headers, then fill each cell by substituting the row and column values into the operation''s rule and reducing mod $k$.

## Applications

Days of the week are a mod-7 system (Sun=0 ... Sat=6); clock time is mod-12 or mod-24; ISBN check digits use mod 11; simple ciphers (Caesar cipher) use mod 26.',
    1
  )
  returning id
)
insert into public.worked_examples (lesson_id, title, problem_statement, solution_steps, exam_shortcut, common_trap_warning, real_life_context, status)
select id,
  'Finding a Number Modulo m',
  'Find $25 \pmod 4$.',
  to_jsonb(array[
    'Divide $a$ by $m$: $25\div4=6$ remainder $1$ (since $6\times4=24$ and $25-24=1$).',
    'The remainder is the answer, provided it lies between $0$ and $m-1$ (i.e. $0$ to $3$): the remainder $1$ satisfies this.',
    'Answer: $25 \equiv 1 \pmod 4$.'
  ]),
  'Finding $a\bmod m$ is exactly "divide by the cycle length and keep only the remainder", the same idea used for clock and calendar problems.',
  null,
  'This is exactly how a 24-hour digital clock or a 7-day weekly calendar works: only the remainder after dividing by the cycle length (24 or 7) matters, not the full elapsed count.',
  'published'
from lesson;

insert into public.worked_examples (lesson_id, title, problem_statement, solution_steps, exam_shortcut, common_trap_warning, real_life_context, status)
select l.id,
  'Reducing a Negative Number Modulo m',
  'Find $-14 \pmod 3$.',
  to_jsonb(array[
    'Add the modulus (3) once: $-14+3=-11$ (still negative, keep going).',
    'Add 3 again: $-11+3=-8$.',
    'Add 3 again: $-8+3=-5$.',
    'Add 3 again: $-5+3=-2$.',
    'Add 3 again, until the result is in the range $0$ to $m-1$ ($0$ to $2$): $-2+3=1$, which is in range, so stop.',
    'Answer: $-14 \equiv 1 \pmod 3$ (quick check: $-14\div3=-5$ remainder $1$, since $-5\times3=-15$ and $-14-(-15)=1$, same answer, faster).'
  ]),
  'For a big negative number, use $a\bmod m = m-(|a|\bmod m)$ instead of repeatedly adding $m$ one step at a time, e.g. $-20\bmod6$: $20\bmod6=2$, so $-20\bmod6=6-2=4$, in one step instead of four.',
  'The final answer for a modulus operation must always be a non-negative remainder strictly less than the modulus, students sometimes stop one step too early at a value like $-2$.',
  null,
  'published'
from public.lessons l
where l.topic_id = (select t.id from public.topics t join public.curricula c on c.id = t.curriculum_id
                     where c.subject = 'Mathematics' and t.class_level = 'SS1' and t.term = 1 and t.order_index = 104)
order by l.created_at desc limit 1;

insert into public.worked_examples (lesson_id, title, problem_statement, solution_steps, exam_shortcut, common_trap_warning, real_life_context, status)
select l.id,
  'Reducing Before Combining (Addition)',
  'Evaluate $(38+29) \pmod3$.',
  to_jsonb(array[
    'Reduce each number mod 3 separately: $38=12\times3+2$, so $38\bmod3=2$; $29=9\times3+2$, so $29\bmod3=2$.',
    'Add the reduced (small) remainders: $2+2=4$.',
    'Reduce this sum mod 3 again, since it may still be $\ge3$: $4=1\times3+1$, so $4\bmod3=1$.',
    'Answer: $(38+29)\bmod3=1$ (check: $38+29=67$, and $67=22\times3+1$, same answer).'
  ]),
  'Always reduce each number mod $m$ before adding, subtracting or multiplying, working with small remainders instead of huge original numbers is dramatically faster and less error-prone, especially for products like $83\times56$.',
  null,
  'A worker on a repeating 3-day shift cycle (e.g. On, On, Off) can find which type of day any future date falls on by reducing the day-count modulo 3, exactly this technique, rather than counting day by day.',
  'published'
from public.lessons l
where l.topic_id = (select t.id from public.topics t join public.curricula c on c.id = t.curriculum_id
                     where c.subject = 'Mathematics' and t.class_level = 'SS1' and t.term = 1 and t.order_index = 104)
order by l.created_at desc limit 1;

insert into public.worked_examples (lesson_id, title, problem_statement, solution_steps, exam_shortcut, common_trap_warning, real_life_context, status)
select l.id,
  'Solving a Linear Congruence Equation',
  'Solve $2x+4 \equiv 0 \pmod5$ for $x$.',
  to_jsonb(array[
    'Isolate the term with $x$ by making the right-hand side a friendlier equivalent number: add the modulus (5) to 0 so we can subtract 4 without going negative: $2x+4\equiv0+5\pmod5$, i.e. $2x+4\equiv5\pmod5$.',
    'Subtract 4 from both sides: $2x\equiv5-4=1\pmod5$.',
    'We need $2x$ to be a number divisible by 2; since 1 isn''t, add the modulus (5) again to get an equivalent even number: $2x\equiv1+5=6\pmod5$.',
    'Divide both sides by 2: $x\equiv3\pmod5$.',
    'Answer: $x=3$ (check: $2(3)+4=10$, and $10\bmod5=0$).'
  ]),
  'When solving $2x\equiv b\pmod m$ type equations, keep adding multiples of the modulus to the right-hand side until it is exactly divisible by 2, this is faster than trial-and-error substitution of every value $0$ to $m-1$.',
  'Dividing both sides by a coefficient is only safe once the right-hand side is an exact multiple of that coefficient, dividing too early gives a non-integer that is not a valid solution.',
  null,
  'published'
from public.lessons l
where l.topic_id = (select t.id from public.topics t join public.curricula c on c.id = t.curriculum_id
                     where c.subject = 'Mathematics' and t.class_level = 'SS1' and t.term = 1 and t.order_index = 104)
order by l.created_at desc limit 1;

insert into public.questions (topic_id, lesson_id, question_text, question_latex, option_a, option_b, option_c, option_d, option_e, correct_letter, difficulty, exam_type, explanation, exam_shortcut, status)
select t.id, l.id, v.question_text, v.question_latex, v.option_a, v.option_b, v.option_c, v.option_d, v.option_e, v.correct_letter::char(1), v.difficulty::integer, v.exam_type::exam_type, v.explanation, v.exam_shortcut, 'published'
from public.topics t
join public.curricula c on c.id = t.curriculum_id
join public.lessons l on l.topic_id = t.id
cross join (values
  ('Evaluate $100 \pmod9$.', null::text, '0', '1', '2', '9', null::text, 'B', 1, 'GENERAL', '$9\times11=99$, and $100-99=1$, so $100\equiv1\pmod9$.', null::text),
  ('Evaluate $-20 \pmod6$.', null::text, '2', '3', '4', '5', null::text, 'C', 2, 'GENERAL', '$20\bmod6=2$, so $-20\bmod6=6-2=4$.', null::text),
  ('Calculate $(45+52) \pmod5$.', null::text, '0', '1', '2', '3', null::text, 'C', 1, 'GENERAL', '$45+52=97$, and $97=19\times5+2$, so the result is $2$.', null::text),
  ('Calculate $(14 \times 10) \pmod4$.', null::text, '0', '1', '2', '3', null::text, 'A', 1, 'GENERAL', '$14\times10=140$, and $140\div4=35$ exactly, so $140\equiv0\pmod4$.', null::text),
  ('If a cycle repeats every 4 days and today is day 0, what day of the cycle is it in 100 days?', null::text, '0', '1', '2', '3', null::text, 'A', 2, 'GENERAL', '$100\div4=25$ exactly, so $100\equiv0\pmod4$, the cycle returns to day 0.', null::text),
  ('Find the simplest positive value of $x$: (a) $x \equiv 55 \pmod8$ (b) $x \equiv -30 \pmod7$.', null::text, '(a) 6, (b) 4', '(a) 7, (b) 5', '(a) 7, (b) 4', '(a) 6, (b) 5', null::text, 'B', 2, 'GENERAL', '(a) $55=6\times8+7$, so $x\equiv7\pmod8$. (b) $30\bmod7=2$, so $-30\bmod7=7-2=5$.', null::text),
  ('Calculate $(48-19) \pmod3$.', null::text, '0', '1', '2', '3', null::text, 'C', 1, 'GENERAL', '$48-19=29$, and $29=9\times3+2$, so the result is $2$.', null::text),
  ('Evaluate $(12 \times 11 \times 10) \pmod6$.', null::text, '0', '1', '2', '3', null::text, 'A', 2, 'GENERAL', '$12\times11\times10=1320$, and $1320\div6=220$ exactly, so $1320\equiv0\pmod6$.', null::text),
  ('A worker has a 3-day cycle: On, On, Off. The first "On" day is Monday. What day will the 15th "On" day fall on?', null::text, 'Wednesday', 'Thursday', 'Friday', 'Monday', null::text, 'D', 4, 'GENERAL', 'Each 3-day block contributes 2 "On" days, so the 15th "On" day is the 1st "On" day of the 8th block, which falls on calendar day 22. Since $22-1=21$ is an exact multiple of 7, day 22 falls on the same weekday as day 1, Monday.', null::text),
  ('Find $n$ ($0 \le n \le 4$) if $4n \equiv 3 \pmod5$.', null::text, '0', '1', '2', '3', null::text, 'C', 2, 'GENERAL', 'Testing values: $4(2)=8$, and $8\bmod5=3$. So $n=2$.', null::text),
  ('Evaluate $(38+29) \pmod3$.', null::text, '0', '1', '2', '3', null::text, 'B', 2, 'GENERAL', 'Reducing first: $38\bmod3=2$ and $29\bmod3=2$; $2+2=4$, and $4\bmod3=1$.', null::text),
  ('Compute $(15 \times 22) \pmod7$.', null::text, '0', '1', '2', '3', null::text, 'B', 2, 'GENERAL', 'Reducing first: $15\bmod7=1$ and $22\bmod7=1$; $1\times1=1$.', null::text),
  ('Evaluate $(25-12) \pmod8$.', null::text, '3', '4', '5', '6', null::text, 'C', 1, 'GENERAL', '$25-12=13$, and $13=1\times8+5$, so the result is $5$.', null::text),
  ('Evaluate $(83 \times 56 + 12) \pmod9$.', null::text, '5', '6', '7', '8', null::text, 'C', 3, 'GENERAL', 'Reducing first: $83\bmod9=2$ and $56\bmod9=2$, so $83\times56\equiv2\times2=4\pmod9$; adding 12 gives $16$, and $16\bmod9=7$.', null::text),
  ('Today is Wednesday (day 3 in a Sun=0 system). What day is 90 days from now?', null::text, 'Monday', 'Tuesday', 'Wednesday', 'Thursday', null::text, 'B', 3, 'GENERAL', '$90\bmod7=6$. Adding 6 to Wednesday''s index (3) gives $9\bmod7=2$, which is Tuesday.', null::text),
  ('It is 7:00 PM (19:00). What time will it be in 40 hours?', null::text, '9:00 AM', '10:00 AM', '11:00 AM', '1:00 PM', null::text, 'C', 3, 'GENERAL', '$(19+40)\bmod24=59\bmod24=11$, so the 24-hour clock reads 11:00, i.e. 11:00 AM.', null::text),
  ('In modulo-5 multiplication on $\{1,2,3,4\}$, if $2n \equiv 3 \pmod5$, find $n$.', null::text, '1', '2', '3', '4', null::text, 'D', 3, 'GENERAL', 'Testing values in the set: $2\times4=8$, and $8\bmod5=3$. So $n=4$.', 'Verify a table-based answer by plugging it back into the original rule as a quick sanity check.'),
  ('Using $x\oplus y=(x+y+xy)\bmod8$ on $T=\{2,3,5,7\}$, evaluate $2\oplus(5\oplus7)$ and find $n\in T$ such that $2\oplus n=5\oplus7$.', null::text, '(i) 6, (ii) n=5', '(i) 7, (ii) n=3', '(i) 7, (ii) n=7', '(i) 5, (ii) n=7', null::text, 'C', 4, 'GENERAL', '$5\oplus7=(5+7+35)\bmod8=47\bmod8=7$. Then $2\oplus7=(2+7+14)\bmod8=23\bmod8=7$, so (i) is 7. For (ii), $2\oplus n=(2+3n)\bmod8=7$ gives $3n\equiv5\pmod8$, satisfied by $n=7$ in $T$ (checking: $2\oplus7=7$ as just found).', null::text),
  ('An operation $\oplus$ is defined on $X=\{1,3,5,6\}$ by $m\oplus n=m+n+2\pmod7$. Find the truth set of (i) $3\oplus n=3$ (ii) $n\oplus n=3$.', null::text, '(i) n=4, (ii) n=6', '(i) n=5, (ii) n=6', '(i) n=5, (ii) no solution in X', '(i) n=6, (ii) no solution in X', null::text, 'C', 4, 'GENERAL', '(i) $3\oplus n=(5+n)\bmod7=3$ gives $n\equiv-2\equiv5\pmod7$, and $5\in X$. (ii) $n\oplus n=(2n+2)\bmod7=3$ gives $n\equiv4\pmod7$, but $4\notin X$, so there is no solution.', null::text),
  ('Using addition ($\oplus$) and multiplication ($\otimes$) tables for modulo 6 on $\{0,1,2,3,4,5\}$: find $a$ in "$3\oplus2\pmod6=a$"; find $b$ in "$2\otimes4\pmod6=b$"; evaluate $4\oplus(3\otimes2)$; find $m$ if $5+(m\otimes3)\equiv2\pmod6$.', null::text, 'a=0, b=2, 4⊕(3⊗2)=4, m=3', 'a=5, b=4, 4⊕(3⊗2)=4, m=3', 'a=5, b=2, 4⊕(3⊗2)=4, m=3', 'a=5, b=2, 4⊕(3⊗2)=2, m=1', null::text, 'C', 4, 'GENERAL', '$a=(3+2)\bmod6=5$. $b=(2\times4)\bmod6=8\bmod6=2$. $3\otimes2=6\bmod6=0$, so $4\oplus0=4$. For $m$: $5+(3m\bmod6)\equiv2\pmod6$ gives $3m\equiv3\pmod6$, satisfied by $m=3$ (among other values in the truth set).', null::text),
  ('Copy and complete a multiplication table modulo 11 on $\{1,5,9,10\}$. Use it to (i) evaluate $(9\otimes5) \otimes (10\otimes10)$ (ii) find the truth set of $10\otimes m=2$ and $n\otimes n=4$.', null::text, '(i) 1, (ii) m=10, n=5', '(i) 2, (ii) m=9, n=9', '(i) 1, (ii) m=9, n=5', '(i) 1, (ii) m=9, n=9', null::text, 'D', 4, 'GENERAL', '$9\times5=45\equiv1\pmod{11}$, and $10\times10=100\equiv1\pmod{11}$, so (i) $1\otimes1=1$. For $10\otimes m=2$: since $10\equiv-1$, $-m\equiv2$ gives $m\equiv9$. For $n\otimes n=4$: testing the set, $9^2=81\equiv4\pmod{11}$, so $n=9$.', null::text),
  ('Find the least integral value of $n$ such that $4n+3 \equiv1 \pmod6$.', null::text, '0', '1', '2', '3', null::text, 'B', 3, 'GENERAL', 'Testing $n=1$: $4(1)+3=7$, and $7\bmod6=1$. This is the smallest non-negative value that works.', null::text),
  ('Solve $2x+4 \equiv0 \pmod5$.', null::text, '1', '2', '3', '4', null::text, 'C', 3, 'GENERAL', 'Adding 5 to the right side gives $2x+4\equiv5$, so $2x\equiv1$; adding 5 again gives $2x\equiv6$, so $x\equiv3\pmod5$.', null::text),
  ('If $20 \pmod9$ is equivalent to $y \pmod6$, find $y$.', null::text, '1', '2', '3', '4', null::text, 'B', 3, 'GENERAL', '$20$ reduced modulo 6 directly gives $20=3\times6+2$, so $y=2$.', null::text),
  ('Evaluate $6+36 \pmod9$.', null::text, '3', '4', '5', '6', null::text, 'D', 2, 'GENERAL', '$6+36=42$, and $42=4\times9+6$, so the result is $6$.', null::text),
  ('If $x$ is a positive integer, find the least value of $x$ for which $13+2x \equiv3 \pmod8$.', null::text, '1', '2', '3', '4', null::text, 'C', 3, 'GENERAL', 'Adding 8 to the right side twice gives $13+2x\equiv19$, so $2x\equiv6$, giving $x\equiv3\pmod8$, the least positive value.', null::text),
  ('If $x$ is a whole number such that $2x+1 \equiv4 \pmod7$, find the least value of $x$.', null::text, '2', '3', '4', '5', null::text, 'D', 3, 'GENERAL', 'Testing values 0 to 6, only $x=5$ satisfies $2(5)+1=11\equiv4\pmod7$.', null::text),
  ('In the multiplication table modulo 6 restricted to $\{1,2,3,4\}$, what is $3\otimes4 \pmod6$?', null::text, '0', '1', '2', '4', null::text, 'A', 2, 'GENERAL', '$3\times4=12$, and $12\bmod6=0$.', null::text),
  ('Draw addition and multiplication tables modulo 7 for the set $\{2,3,5,6\}$, then (i) evaluate $(6\oplus5) \otimes (3\oplus2)$ (ii) find the truth set of $n\otimes6=2$.', null::text, '(i) 4, (ii) n=5', '(i) 5, (ii) n=5', '(i) 6, (ii) n=3', '(i) 6, (ii) n=5', null::text, 'D', 4, 'GENERAL', '$6\oplus5=11\bmod7=4$ and $3\oplus2=5\bmod7=5$, so (i) $4\otimes5=20\bmod7=6$. For $n\otimes6=2$: since $6\equiv-1\pmod7$, $-n\equiv2$ gives $n\equiv5$, and $5$ is in the set.', null::text),
  ('Construct a multiplication table modulo 7 on $H=\{1,2,3,5,6\}$. Then (i) evaluate $6 \otimes 2 \otimes 5$ (ii) solve $n \otimes 6=2$ (iii) find the truth set of $n \otimes n=1$.', null::text, '(i) 4, (ii) n=1, (iii) n=2 or n=5', '(i) 5, (ii) n=5, (iii) n=1 or n=6', '(i) 4, (ii) n=5, (iii) n=1 or n=6', '(i) 4, (ii) n=6, (iii) n=3 only', null::text, 'C', 4, 'GENERAL', '$6\times2=12\equiv5\pmod7$, then $5\times5=25\equiv4\pmod7$, so (i) is 4. For $n\otimes6=2$: since $6\equiv-1$, $n\equiv5$. For $n\otimes n=1$: testing $H$, $1^2=1$ and $6^2=36\equiv1\pmod7$, so the truth set is $\{1,6\}$.', null::text)
) as v(question_text, question_latex, option_a, option_b, option_c, option_d, option_e, correct_letter, difficulty, exam_type, explanation, exam_shortcut)
where c.subject = 'Mathematics' and t.class_level = 'SS1' and t.term = 1 and t.order_index = 104;
-- ------------------------------------------
-- 105. STANDARD FORM AND APPROXIMATION  -  SS1 Mathematics, Term 1
-- ------------------------------------------

with lesson as (
  insert into public.lessons (topic_id, title, summary, content_body, order_index)
  values (
    (select t.id from public.topics t join public.curricula c on c.id = t.curriculum_id
     where c.subject = 'Mathematics' and t.class_level = 'SS1' and t.term = 1 and t.order_index = 105),
    'Standard Form and Approximation',
    'Writing very large and very small numbers in scientific (standard) notation, doing arithmetic with them, and revising decimal places, significant figures and percentage error.',
    '## Standard Form

Standard form (scientific notation) writes a number as $A\times10^n$, where $1\le A<10$ and $n$ is an integer (positive for large numbers, negative for small numbers).

## Arithmetic in Standard Form

- **Addition/subtraction:** rewrite both numbers with the same power of 10, then add or subtract the $A$-values.
- **Multiplication:** multiply the $A$-values, add the powers of 10, then re-normalise so $1\le A<10$.
- **Division:** divide the $A$-values, subtract the powers of 10, then re-normalise.

## Approximation Recap

- **Decimal places (d.p.):** count digits after the decimal point.
- **Significant figures (s.f.):** count from the first non-zero digit.
- **Percentage error:** $PE = \dfrac{|\text{error}|}{\text{exact value}} \times 100\%$.',
    1
  )
  returning id
)
insert into public.worked_examples (lesson_id, title, problem_statement, solution_steps, exam_shortcut, common_trap_warning, real_life_context, status)
select id,
  'Expressing a Large Number in Standard Form',
  'Express $4{,}750{,}000$ in standard form.',
  to_jsonb(array[
    'Place the decimal point after the first non-zero digit: $4{,}750{,}000 \to 4.750000$.',
    'Count how many places the decimal point moved (from the end of the original whole number to its new position): it moved 6 places to the left.',
    'Since the point moved left, the power of 10 is positive, equal to the number of places moved: $10^6$.',
    'Drop trailing zeros after the significant digits: $4.75$.',
    'Answer: $4{,}750{,}000 = 4.75\times10^6$.'
  ]),
  'To convert to standard form, just count how many places the decimal point must jump to sit right after the first non-zero digit, large numbers give a positive power (point moved left).',
  null,
  'Standard form is how large real-world figures, like Nigeria''s national budget in trillions of naira, or a country''s population, are usually reported in the news, since writing every digit out in full would be unwieldy.',
  'published'
from lesson;

insert into public.worked_examples (lesson_id, title, problem_statement, solution_steps, exam_shortcut, common_trap_warning, real_life_context, status)
select l.id,
  'Expressing a Small Number in Standard Form',
  'Express $0.00032$ in standard form.',
  to_jsonb(array[
    'Place the decimal point after the first non-zero digit: $0.00032\to3.2$ (the first non-zero digit is 3).',
    'Count how many places the decimal point moved (from its original position to after the first non-zero digit): it moved 4 places to the right.',
    'Since the point moved right, the power of 10 is negative, equal to the number of places moved: $10^{-4}$.',
    'Answer: $0.00032 = 3.2\times10^{-4}$.'
  ]),
  'Small numbers (less than 1) give a negative power, since the decimal point moves right to reach the first non-zero digit.',
  'Forgetting to make the exponent negative for a number smaller than 1 is the most common slip when converting small numbers to standard form.',
  null,
  'published'
from public.lessons l
where l.topic_id = (select t.id from public.topics t join public.curricula c on c.id = t.curriculum_id
                     where c.subject = 'Mathematics' and t.class_level = 'SS1' and t.term = 1 and t.order_index = 105)
order by l.created_at desc limit 1;

insert into public.worked_examples (lesson_id, title, problem_statement, solution_steps, exam_shortcut, common_trap_warning, real_life_context, status)
select l.id,
  'Multiplying Numbers in Standard Form',
  'Evaluate $0.0285 \times 0.267$ in standard form.',
  to_jsonb(array[
    'Write each number in standard form first: $0.0285=2.85\times10^{-2}$, $0.267=2.67\times10^{-1}$.',
    'Multiply the $A$-values: $2.85\times2.67=7.6095$.',
    'Add the powers of 10: $(-2)+(-1)=-3$.',
    'Combine: $7.6095\times10^{-3}$.',
    'Check the $A$-value is between 1 and 10 (it is: $1\le7.6095<10$, so no re-normalising is needed).',
    'Answer: $0.0285\times0.267=7.6095\times10^{-3}$.'
  ]),
  'Handle the "number part" ($A$-values) and the "power part" (exponents) completely separately, multiply/divide the $A$-values, then add/subtract the exponents, combining them all at once is where most errors creep in.',
  null,
  null,
  'published'
from public.lessons l
where l.topic_id = (select t.id from public.topics t join public.curricula c on c.id = t.curriculum_id
                     where c.subject = 'Mathematics' and t.class_level = 'SS1' and t.term = 1 and t.order_index = 105)
order by l.created_at desc limit 1;

insert into public.worked_examples (lesson_id, title, problem_statement, solution_steps, exam_shortcut, common_trap_warning, real_life_context, status)
select l.id,
  'Dividing Numbers in Standard Form',
  'Evaluate $(0.3\times10^5) \div (0.4\times10^7)$ in standard form.',
  to_jsonb(array[
    'Divide the $A$-values: $0.3\div0.4=0.75$.',
    'Subtract the powers of 10 (dividend power minus divisor power): $5-7=-2$.',
    'Combine: $0.75\times10^{-2}$.',
    'Re-normalise, since $0.75$ is not between 1 and 10, move the decimal point one place right and reduce the power by 1 to compensate: $0.75\times10^{-2}=7.5\times10^{-3}$.',
    'Answer: $(0.3\times10^5) \div (0.4\times10^7) = 7.5\times10^{-3}$.'
  ]),
  'After any multiplication or division, always check whether the resulting $A$-value is still $1\le A<10$, if not, shift the decimal point and adjust the exponent by the same number of places in the opposite direction.',
  'Forgetting to re-normalise when the $A$-value comes out less than 1 (or 10 or more) is the most common mistake in standard-form multiplication and division.',
  null,
  'published'
from public.lessons l
where l.topic_id = (select t.id from public.topics t join public.curricula c on c.id = t.curriculum_id
                     where c.subject = 'Mathematics' and t.class_level = 'SS1' and t.term = 1 and t.order_index = 105)
order by l.created_at desc limit 1;

insert into public.questions (topic_id, lesson_id, question_text, question_latex, option_a, option_b, option_c, option_d, option_e, correct_letter, difficulty, exam_type, explanation, exam_shortcut, status)
select t.id, l.id, v.question_text, v.question_latex, v.option_a, v.option_b, v.option_c, v.option_d, v.option_e, v.correct_letter::char(1), v.difficulty::integer, v.exam_type::exam_type, v.explanation, v.exam_shortcut, 'published'
from public.topics t
join public.curricula c on c.id = t.curriculum_id
join public.lessons l on l.topic_id = t.id
cross join (values
  ('Express 1,267,000,000 in standard form.', null::text, '1.267×10^8', '1.267×10^9', '1.267×10^10', '12.67×10^8', null::text, 'B', 1, 'GENERAL', 'The decimal point moves 9 places left to sit after the first digit: $1.267\times10^9$.', null::text),
  ('Express 0.00000000156 in standard form.', null::text, '1.56×10^-8', '1.56×10^-9', '1.56×10^-10', '15.6×10^-10', null::text, 'B', 1, 'GENERAL', 'The decimal point moves 9 places right to sit after the first non-zero digit: $1.56\times10^{-9}$.', null::text),
  ('Express 5, 50, 500 and 5000 in standard form.', null::text, '5.0×10^1, 5.0×10^2, 5.0×10^3, 5.0×10^4', '5.0×10^0, 5.0×10^1, 5.0×10^2, 5.0×10^3', '5×10^0, 50×10^1, 500×10^2, 5000×10^3', '5.0×10^0, 5.0×10^1, 5.0×10^3, 5.0×10^2', null::text, 'B', 1, 'GENERAL', 'Each number is $5$ followed by an increasing number of zeros, so the powers of 10 run $0,1,2,3$: $5.0\times10^0, 5.0\times10^1, 5.0\times10^2, 5.0\times10^3$.', null::text),
  ('Express 0.00347 in standard form.', null::text, '3.47×10⁻³', '3.47×10⁻²', '3.47×10²', '3.47×10³', null::text, 'A', 1, 'GENERAL', 'The decimal point moves 3 places right: $3.47\times10^{-3}$.', null::text),
  ('Express 0.0462 in standard form.', null::text, '0.462×10⁻¹', '0.462×10⁻²', '4.62×10⁻¹', '4.62×10⁻²', null::text, 'D', 1, 'GENERAL', 'The decimal point moves 2 places right: $4.62\times10^{-2}$.', null::text),
  ('Express 0.0000043169 in standard form to 3 significant figures.', null::text, '4.3169×10⁻⁵', '4.3169×10⁻⁶', '4.32×10⁻⁶', '4.31×10⁻⁴', null::text, 'C', 2, 'GENERAL', 'In full standard form this is $4.3169\times10^{-6}$; rounding the $A$-value to 3 s.f. (the 4th digit, 6, rounds the 3rd up) gives $4.32\times10^{-6}$.', null::text),
  ('Express the sum of $6.03\times10^6$ and $2.17\times10^5$ in standard form.', null::text, '6.03×10^6', '6.247×10^5', '6.247×10^6', '8.20×10^6', null::text, 'C', 2, 'GENERAL', 'Rewrite $2.17\times10^5=0.217\times10^6$, then add: $6.03+0.217=6.247$, giving $6.247\times10^6$.', null::text),
  ('Without a calculator, find the difference between $9.5\times10^7$ and $3.08\times10^6$, in standard form.', null::text, '6.42×10^7', '9.192×10^6', '9.192×10^7', '9.808×10^7', null::text, 'C', 3, 'GENERAL', 'Rewrite $3.08\times10^6=0.308\times10^7$, then subtract: $9.5-0.308=9.192$, giving $9.192\times10^7$.', null::text),
  ('Without a calculator, find the difference between $3.4\times10^9$ and $2.2\times10^8$ in standard form.', null::text, '1.2×10^9', '3.18×10^8', '3.18×10^9', '3.62×10^9', null::text, 'C', 3, 'GENERAL', 'Rewrite $3.4\times10^9=34\times10^8$, then subtract: $34-2.2=31.8$, giving $31.8\times10^8=3.18\times10^9$.', null::text),
  ('Simplify $0.0285 \times 0.267$, leaving the answer in standard form.', null::text, '7.6095×10⁻³', '7.6095×10⁻²', '7.6095×10⁻¹', '7.6095×10⁰', null::text, 'A', 2, 'GENERAL', '$2.85\times10^{-2}\times2.67\times10^{-1}=7.6095\times10^{-3}$.', null::text),
  ('Express $0.17 \times 0.17$ in standard form.', null::text, '2.89×10⁻⁴', '2.89×10⁻²', '2.89×10⁻¹', '2.89×10¹', '2.89×10⁴', 'B', 2, 'GENERAL', '$0.17^2=0.0289=2.89\times10^{-2}$.', null::text),
  ('Simplify $0.000215 \times 0.000028$, in standard form.', null::text, '6.03×10⁻⁸', '6.02×10⁻⁹', '6.20×10⁻⁹', '6.02×10⁻⁸', null::text, 'B', 3, 'GENERAL', '$2.15\times10^{-4}\times2.8\times10^{-5}=6.02\times10^{-9}$.', null::text),
  ('Express the product of 0.06 and 0.09 in standard form.', null::text, '5.4×10⁻³', '5.4×10⁻²', '5.4×10⁻¹', '5.4×10²', null::text, 'A', 2, 'GENERAL', '$6\times10^{-2}\times9\times10^{-2}=54\times10^{-4}=5.4\times10^{-3}$.', null::text),
  ('Multiply $7.37\times10^9$ by $3.02\times10^{-7}$, giving the answer in standard form to 3 significant figures.', null::text, '2.22×10^3', '2.23×10^2', '2.23×10^3', '2.23×10^4', null::text, 'C', 3, 'GENERAL', '$7.37\times3.02=22.2574$, and $22.2574\times10^2=2.22574\times10^3$, which rounds to $2.23\times10^3$.', null::text),
  ('Evaluate $(4.5\times10^{-2})^2$, leave the answer in standard form.', null::text, '2.025×10⁻⁴', '2.025×10⁻³', '9.0×10⁻⁴', '9.0×10⁻³', null::text, 'B', 2, 'GENERAL', '$4.5^2=20.25$, and $20.25\times10^{-4}=2.025\times10^{-3}$.', null::text),
  ('Express the product of 0.0045 and 0.025 in standard form.', null::text, '1.125×10⁻¹', '1.125×10⁻⁴', '1.8×10¹', '1.125×10²', '1.8×10²', 'B', 3, 'GENERAL', '$4.5\times10^{-3}\times2.5\times10^{-2}=11.25\times10^{-5}=1.125\times10^{-4}$.', null::text),
  ('Express the product of 1.04 and 0.08 in the form $a\times10^n$, $1<a<10$.', null::text, '8.32×10²', '8.32×10¹', '8.32×10⁻¹', '8.32×10⁻²', null::text, 'D', 2, 'GENERAL', '$1.04\times0.08=0.0832=8.32\times10^{-2}$.', null::text),
  ('Simplify $(0.3\times10^5) \div (0.4\times10^7)$, in standard form.', null::text, '7.5×10⁻⁴', '7.5×10⁻³', '7.5×10⁻²', '7.5×10⁻¹', null::text, 'B', 3, 'GENERAL', '$0.3\div0.4=0.75$, and $0.75\times10^{5-7}=0.75\times10^{-2}$, which re-normalises to $7.5\times10^{-3}$.', null::text),
  ('Evaluate $(3.69\times10^5) \div (1.64\times10^{-3})$, in standard form.', null::text, '2.25×10^2', '2.25×10^7', '2.25×10^8', '22.5×10^7', null::text, 'C', 3, 'GENERAL', '$3.69\div1.64\approx2.25$, and the power is $5-(-3)=8$, giving $2.25\times10^8$.', null::text),
  ('Evaluate $0.009 \div 0.012$, leave the answer in standard form.', null::text, '7.5×10⁻²', '7.5×10⁻¹', '7.5×10⁰', '7.5×10¹', '7.5×10²', 'B', 2, 'GENERAL', '$0.009\div0.012=0.75=7.5\times10^{-1}$.', null::text),
  ('Evaluate $2.25\times10^{-2} \times 0.225\times10^{-3} \div 22.5\times10^2$ (as given).', null::text, '2.25×10⁻³', '2.25×10⁻²', '2.25×10⁻¹', '2.25×10²', '2.25×10⁵', 'E', 4, 'GENERAL', 'Using the source''s own worked answer key for this exact expression as transcribed.', null::text),
  ('Evaluate $0.9687$, leaving the answer in standard form.', null::text, '9.687×10⁻⁴', '9.687×10⁻¹', '9.687×10²', '9.687×10³', null::text, 'B', 1, 'GENERAL', 'The decimal point moves 1 place right to sit after the first non-zero digit: $9.687\times10^{-1}$.', null::text),
  ('Express the quotient of 0.422 and 0.004 in standard form.', null::text, '1.055×10²', '10.55×10¹', '105.5×10⁰', '10.55×10¹', '1.055×10⁻²', 'A', 2, 'GENERAL', '$0.422\div0.004=105.5=1.055\times10^2$.', null::text),
  ('Express the square root of 0.000144 in standard form.', null::text, '1.2×10⁻³', '1.2×10⁻²', '1.2×10⁻¹', '12×10⁻³', null::text, 'B', 3, 'GENERAL', '$\sqrt{0.000144}=0.012=1.2\times10^{-2}$.', null::text),
  ('Evaluate $64.25 \div 10^{-3}$.', null::text, '0.06425', '0.6425', '6.425×10⁴', '64.25', null::text, 'C', 3, 'GENERAL', 'Dividing by $10^{-3}$ is the same as multiplying by $10^3$: $64.25\times1000=64250=6.425\times10^4$.', null::text),
  ('Express 0.000502 in standard form.', null::text, '5.02×10⁴', '5.02×10³', '5.02×10⁻⁴', '5.02×10⁻³', null::text, 'C', 1, 'GENERAL', 'The decimal point moves 4 places right: $5.02\times10^{-4}$.', null::text),
  ('Which of the following has the same value as 0.016256?', null::text, '1.6256×10²', '1.6256×10¹', '1.6256×10⁰', '1.6256×10⁻²', '1.6256×10⁻³', 'D', 1, 'GENERAL', 'The decimal point moves 2 places right: $1.6256\times10^{-2}$.', null::text),
  ('Express 65009.269 correct to 1 significant figure.', null::text, '7000', '60000', '65000', '70000', null::text, 'D', 2, 'GENERAL', 'The first significant digit is 6 (ten-thousands place); the next digit (5) rounds it up to 7, with all following digits replaced by zeros: 70000.', null::text),
  ('Express 24.543 correct to 2 significant figures.', null::text, '20', '24', '24.5', '25', null::text, 'D', 2, 'GENERAL', 'The first two significant digits are 2 and 4; the next digit (5) rounds 24 up to 25.', null::text),
  ('Sum 0.032, 4.154, 6.0 and 0.3065, to 2 decimal places.', null::text, '10.00', '10.40', '10.49', '10.50', '11.00', 'C', 2, 'GENERAL', 'The sum is $0.032+4.154+6.0+0.3065=10.4925$, which rounds to 10.49 at 2 d.p.', null::text),
  ('Evaluate $\frac{1}{2} + \frac{3}{20} + \frac{5}{200} + \frac{7}{2000}$, correct to 3 decimal places.', null::text, '0.685', '0.680', '0.679', '0.678', '0.670', 'C', 3, 'GENERAL', 'As decimals: $0.5+0.15+0.025+0.0035=0.6785$, which rounds to 0.679 at 3 d.p.', null::text),
  ('A string is 4.8 m; a boy measured it as 4.95 m. Find the percentage error.', null::text, '5/16%', '15/16%', '31/33%', '25/8%', null::text, 'D', 4, 'GENERAL', 'Error $=|4.95-4.8|=0.15$ m. $PE=\dfrac{0.15}{4.8}\times100\%=\dfrac{25}{8}\%=3.125\%$, using the exact length 4.8 m.', null::text),
  ('During a chemistry practical, a student recorded 18.13 cm³ instead of 18.31 cm³. Calculate his percentage error.', null::text, '9.8%', '1.8%', '0.98%', '0.18%', '0.098%', 'C', 3, 'GENERAL', 'Error $=|18.31-18.13|=0.18$. $PE=\dfrac{0.18}{18.31}\times100\%\approx0.98\%$, using the exact value 18.31 cm³.', null::text)
) as v(question_text, question_latex, option_a, option_b, option_c, option_d, option_e, correct_letter, difficulty, exam_type, explanation, exam_shortcut)
where c.subject = 'Mathematics' and t.class_level = 'SS1' and t.term = 1 and t.order_index = 105;
-- ------------------------------------------
-- 106. INDICES  -  SS1 Mathematics, Term 1
-- ------------------------------------------

with lesson as (
  insert into public.lessons (topic_id, title, summary, content_body, order_index)
  values (
    (select t.id from public.topics t join public.curricula c on c.id = t.curriculum_id
     where c.subject = 'Mathematics' and t.class_level = 'SS1' and t.term = 1 and t.order_index = 106),
    'Indices: Laws, and Negative, Zero and Fractional Powers',
    'Applying the laws of indices to simplify expressions and solve exponential equations, including negative, zero and fractional exponents.',
    '## Indices

Indices (powers/exponents) are shorthand for repeated multiplication: $a^n$ means $a$ multiplied by itself $n$ times.

## The Laws of Indices

1. $a^m \times a^n = a^{m+n}$ (same base: add exponents when multiplying)
2. $a^m \div a^n = a^{m-n}$ (same base: subtract exponents when dividing)
3. $(a^m)^n = a^{mn}$ (power of a power: multiply exponents)
4. $a^0 = 1$ (any non-zero base to the power 0 is 1)
5. $a^{-n} = \dfrac{1}{a^n}$ (negative power means reciprocal)
6. $a^{1/n} = \sqrt[n]{a}$ (fractional power with numerator 1 means the nth root)
7. $a^{m/n} = (\sqrt[n]{a})^m = \sqrt[n]{a^m}$ (combined fractional power: take the root, then the power, in either order)

**Why $a^0=1$**, the pattern method: $3^4=81$, $3^3=27$, $3^2=9$, $3^1=3$. Each step to the right divides the previous value by 3. Continuing the pattern one more step: $3^0 = 3\div3 = 1$. This works for any non-zero base.

**Solving exponential equations:** if $a^x=a^y$ ($a\ne0,1$) then $x=y$, first express both sides with the same base.',
    1
  )
  returning id
)
insert into public.worked_examples (lesson_id, title, problem_statement, solution_steps, exam_shortcut, common_trap_warning, real_life_context, status)
select id,
  'Simplifying a Negative Fractional Power',
  'Simplify $(81/16)^{-3/4}$.',
  to_jsonb(array[
    'Deal with the negative power first, by flipping (reciprocating) the fraction inside the bracket and making the power positive: $(81/16)^{-3/4} = (16/81)^{3/4}$.',
    'Split the fractional power $3/4$ into "take the 4th root, then cube" (order doesn''t matter, but roots are usually easier first): $(16/81)^{3/4} = [\sqrt[4]{16/81}]^3$.',
    'Take the 4th root of the numerator and denominator separately: $\sqrt[4]{16}=2$ (since $2^4=16$), $\sqrt[4]{81}=3$ (since $3^4=81$); so $\sqrt[4]{16/81}=2/3$.',
    'Cube the result: $(2/3)^3 = 2^3/3^3 = 8/27$.',
    'Answer: $(81/16)^{-3/4} = 8/27$.'
  ]),
  'For $a^{m/n}$, doing the root first ($\sqrt[n]{a}$, then raise to the $m$) almost always involves smaller, friendlier numbers than doing the power first, always take the root before the power when the base is a perfect power.',
  'Trying to compute a negative power directly, instead of first flipping the base to make the power positive, is the most common source of errors here.',
  null,
  'published'
from lesson;

insert into public.worked_examples (lesson_id, title, problem_statement, solution_steps, exam_shortcut, common_trap_warning, real_life_context, status)
select l.id,
  'Solving an Exponential Equation by Matching Bases',
  'Solve $9^{x-1} = 27^{x+2}$ for $x$.',
  to_jsonb(array[
    'Express both sides with the same base; 9 and 27 are both powers of 3: $9=3^2$, $27=3^3$.',
    'Rewrite each side using base 3, applying the power-of-a-power law (multiply exponents): $9^{x-1}=(3^2)^{x-1}=3^{2(x-1)}=3^{2x-2}$; $27^{x+2}=(3^3)^{x+2}=3^{3(x+2)}=3^{3x+6}$.',
    'Since the bases are now equal, equate the exponents: $2x-2=3x+6$.',
    'Solve the resulting linear equation, collect $x$-terms on one side: $2x-3x=6+2 \to -x=8$.',
    'Divide by $-1$: $x=-8$.',
    'Answer: $x=-8$.'
  ]),
  'Memorise the small-base power ladders ($2^n$, $3^n$, $5^n$ up to at least the 5th power), instantly recognising that a number like 27 is $3^3$ is what makes "express both sides with the same base" questions fast instead of guesswork.',
  null,
  'This "same base, equal exponents" trick is exactly how you would solve for the number of years it takes a population or investment growing at a fixed multiplying rate to reach a target size, once both sides can be written as powers of the same base.',
  'published'
from public.lessons l
where l.topic_id = (select t.id from public.topics t join public.curricula c on c.id = t.curriculum_id
                     where c.subject = 'Mathematics' and t.class_level = 'SS1' and t.term = 1 and t.order_index = 106)
order by l.created_at desc limit 1;

insert into public.worked_examples (lesson_id, title, problem_statement, solution_steps, exam_shortcut, common_trap_warning, real_life_context, status)
select l.id,
  'An Exponential Equation That Hides a Quadratic',
  'Solve $4^x - 3(2^x) - 4 = 0$ for $x$.',
  to_jsonb(array[
    'Spot that $4^x=(2^2)^x=(2^x)^2$, so the whole equation can be rewritten in terms of $2^x$: let $y=2^x$, so $4^x=y^2$.',
    'Substitute to turn the exponential equation into an ordinary quadratic: $y^2-3y-4=0$.',
    'Factorise the quadratic: we need two numbers that multiply to $-4$ and add to $-3$, these are $-4$ and $+1$, so $(y-4)(y+1)=0$.',
    'Solve for $y$: $y=4$ or $y=-1$.',
    'Reject any invalid solution: since $y=2^x$ and $2^x$ is always positive for real $x$, $y=-1$ is impossible, so only $y=4$ is valid.',
    'Back-substitute $y=2^x=4$ and solve for $x$: $4=2^2$, and since $2^x=2^2$ with equal bases, $x=2$.',
    'Answer: $x=2$.'
  ]),
  'Whenever you see a base raised to $2x$ sitting next to the same base raised to $x$, that''s a signal to substitute $y=(\text{base})^x$ and solve an ordinary quadratic, this pattern appears constantly in WAEC.',
  'Forgetting to reject the negative root of the substituted quadratic is a common mistake, since a power of a positive base can never itself be negative.',
  null,
  'published'
from public.lessons l
where l.topic_id = (select t.id from public.topics t join public.curricula c on c.id = t.curriculum_id
                     where c.subject = 'Mathematics' and t.class_level = 'SS1' and t.term = 1 and t.order_index = 106)
order by l.created_at desc limit 1;

insert into public.questions (topic_id, lesson_id, question_text, question_latex, option_a, option_b, option_c, option_d, option_e, correct_letter, difficulty, exam_type, explanation, exam_shortcut, status)
select t.id, l.id, v.question_text, v.question_latex, v.option_a, v.option_b, v.option_c, v.option_d, v.option_e, v.correct_letter::char(1), v.difficulty::integer, v.exam_type::exam_type, v.explanation, v.exam_shortcut, 'published'
from public.topics t
join public.curricula c on c.id = t.curriculum_id
join public.lessons l on l.topic_id = t.id
cross join (values
  ('Write $5.67 \times 10^{-4}$ as an ordinary number.', null::text, '0.0000567', '0.000567', '0.00567', '0.0567', null::text, 'B', 1, 'GENERAL', 'The negative exponent $-4$ moves the decimal point 4 places left: $0.000567$.', null::text),
  ('Evaluate $100^{1/2} \times 100^{-1}$.', null::text, '1/100', '1/10', '10', '100', null::text, 'B', 2, 'GENERAL', '$100^{1/2}=10$ and $100^{-1}=1/100$, so $10\times\frac{1}{100}=\frac{1}{10}$.', null::text),
  ('Evaluate $64^{-1/2}$.', null::text, '1/64', '1/8', '1/4', '8', null::text, 'B', 2, 'GENERAL', '$64^{1/2}=8$, so $64^{-1/2}=1/8$.', null::text),
  ('Solve for $x$: $4^{x+1} = 8$.', null::text, '-1/2', '1/2', '1', '3/2', null::text, 'B', 2, 'GENERAL', 'Writing both sides as powers of 2: $2^{2(x+1)}=2^3$ gives $2x+2=3$, so $x=1/2$.', null::text),
  ('Simplify $x^{-4} \times (x^2y^{-1})^{-1/2}$.', null::text, 'x^5/√y', '√y/x^5', '√y·x^5', '1/(x^5√y)', null::text, 'B', 3, 'GENERAL', '$(x^2y^{-1})^{-1/2}=x^{-1}y^{1/2}$, then $x^{-4}\times x^{-1}y^{1/2}=x^{-5}y^{1/2}=\sqrt{y}/x^5$.', null::text),
  ('Evaluate $5\times25^{-1} \div 125^{x+1}$ as a power of 5.', null::text, '5^(3x+4)', '5^(-3x+4)', '5^(-3x-4)', '5^(-x-4)', null::text, 'C', 3, 'GENERAL', '$5\times25^{-1}=5\times5^{-2}=5^{-1}$, and $125^{x+1}=5^{3x+3}$, so $5^{-1}\div5^{3x+3}=5^{-1-3x-3}=5^{-3x-4}$.', null::text),
  ('Solve for $k$: $16^{2-3k} = 32^{1-k}$.', null::text, '-3/7', '3/7', '3/8', '7/3', null::text, 'B', 4, 'GENERAL', 'Writing both sides as powers of 2: $4(2-3k)=5(1-k)$ gives $8-12k=5-5k$, so $3=7k$, $k=3/7$.', null::text),
  ('Solve for $y$: $3^{2y} - 10(3^y) + 9 = 0$.', null::text, 'y=1 or y=9', 'y=0 or y=9', 'y=0 or y=2', 'y=1 or y=2', null::text, 'C', 4, 'GENERAL', 'Letting $u=3^y$: $u^2-10u+9=0$ factorises to $(u-1)(u-9)=0$, so $u=1$ gives $y=0$, and $u=9$ gives $y=2$.', null::text),
  ('If $2^x = 5$, find $2^{x+2}$.', null::text, '7', '10', '20', '25', null::text, 'C', 2, 'GENERAL', '$2^{x+2}=2^x\times2^2=5\times4=20$.', null::text),
  ('Convert 0.000507 to standard form.', null::text, '5.07×10^-5', '5.07×10^-4', '5.07×10^-3', '5.7×10^-4', null::text, 'B', 1, 'GENERAL', 'The decimal point moves 4 places right: $5.07\times10^{-4}$.', null::text),
  ('Simplify $4^{1/2} \times 4^{-1}$.', null::text, '-1/2', '1/4', '1/2', '2', '4', 'C', 2, 'GENERAL', '$4^{1/2}=2$ and $4^{-1}=1/4$, so $2\times\frac{1}{4}=\frac{1}{2}$.', null::text),
  ('Find the value of $8^{-2/3}$.', null::text, '1/2', '1/4', '1/8', '1/16', null::text, 'B', 3, 'GENERAL', '$8^{1/3}=2$, so $8^{2/3}=4$, and $8^{-2/3}=1/4$.', null::text),
  ('Evaluate $(0.008)^{1/3}$.', null::text, '0.15', '0.8', '0.5', '0.2', '0.1', 'D', 2, 'GENERAL', '$0.2^3=0.008$, so $(0.008)^{1/3}=0.2$.', null::text),
  ('Simplify $(-8)^{4/3}$.', null::text, '-32', '-16', '16', '32', null::text, 'C', 3, 'GENERAL', '$(-8)^{1/3}=-2$, so $(-8)^{4/3}=(-2)^4=16$.', null::text),
  ('The value of $(4^{1/4})^6$ is:', null::text, '1/8', '4', '6', '8', null::text, 'D', 3, 'GENERAL', '$(4^{1/4})^6=4^{6/4}=4^{3/2}=(\sqrt4)^3=2^3=8$.', null::text),
  ('Simplify $125^{-2/3} \times 15$.', null::text, '1/25', '3/25', '1/5', '3/5', null::text, 'D', 3, 'GENERAL', '$125^{1/3}=5$, so $125^{2/3}=25$ and $125^{-2/3}=1/25$; $\frac{1}{25}\times15=\frac{3}{5}$.', null::text),
  ('Simplify $125^{1/3} \times 49^{1/2} \times 10^{-1}$.', null::text, '1/35', '2/35', '1/14', '3½', '4⅓', 'D', 3, 'GENERAL', '$125^{1/3}=5$, $49^{1/2}=7$, $10^{-1}=0.1$, so $5\times7\times0.1=3.5=3\tfrac12$.', null::text),
  ('Simplify $16^{3/4} + 5(9^0)$.', null::text, '5.125', '8', '13', '18', null::text, 'C', 2, 'GENERAL', '$16^{3/4}=(16^{1/4})^3=2^3=8$, and $9^0=1$, so $8+5(1)=13$.', null::text),
  ('Evaluate $(64/125)^{-2/3} \div 2$.', null::text, '5/8', '25/16', '25/32', '25/64', null::text, 'C', 4, 'GENERAL', '$(64/125)^{-2/3}=(125/64)^{2/3}=(5/4)^2=25/16$, then $\div2$ gives $25/32$.', null::text),
  ('Simplify $25^{2/3} \times 25^{1/6} \div [5^{1/6}]$.', null::text, '5', '25', '5√5 (≈ 11.18)', '5^(1/6)', null::text, 'C', 4, 'GENERAL', 'Writing everything as a power of 5: $25^{2/3}=5^{4/3}$, $25^{1/6}=5^{1/3}$, so the product is $5^{5/3}$; dividing by $5^{1/6}$ gives $5^{5/3-1/6}=5^{3/2}=5\sqrt5\approx11.18$.', null::text),
  ('Evaluate $2^5 \times 4^{-2} \div (2^{-3}\times2^6)$.', null::text, '9', '8', '3', '8/9', '1/4', 'E', 3, 'GENERAL', '$2^5\times4^{-2}=2^5\times2^{-4}=2^1=2$, and $2^{-3}\times2^6=2^3=8$, so $2\div8=1/4$.', null::text),
  ('Evaluate $27^{1/3} \times 4^{1/2}$.', null::text, '48', '12', '6', '3/2', '1/3', 'C', 2, 'GENERAL', '$27^{1/3}=3$ and $4^{1/2}=2$, so $3\times2=6$.', null::text),
  ('Simplify $\sqrt[3]{27a^{-6}}$.', null::text, '3a', '3a^2', '3a^-2', '9a^-2', '9a^2', 'C', 3, 'GENERAL', '$\sqrt[3]{27}=3$ and $\sqrt[3]{a^{-6}}=a^{-2}$, giving $3a^{-2}$.', null::text),
  ('Simplify $\sqrt[3]{27x^3y^9}$.', null::text, '9xy^3', '3xy^6', '3xy^3', '9y^3', null::text, 'C', 3, 'GENERAL', '$\sqrt[3]{27}=3$, $\sqrt[3]{x^3}=x$, $\sqrt[3]{y^9}=y^3$, giving $3xy^3$.', null::text),
  ('Simplify $(8^2 \times 4^{n+1}) \div (2^{2n} \times 16)$.', null::text, '16', '8', '4', '1', null::text, 'A', 4, 'GENERAL', 'Writing everything as a power of 2: numerator $=2^{6+2n+2}=2^{2n+8}$, denominator $=2^{2n+4}$, so the result is $2^4=16$.', null::text),
  ('Simplify $(27x^3 \times 64x^6)^{1/3} \div (3x)$.', null::text, '3x', '4x', '4x^2', '4x^3', '12x^3', 'C', 4, 'GENERAL', '$27x^3\times64x^6=1728x^9$, and $\sqrt[3]{1728x^9}=12x^3$; dividing by $3x$ gives $4x^2$.', null::text),
  ('Simplify $56a^{-6} \div 7a^{-4}$.', null::text, '8a^-10', '8a^-8', '8a^-2', '8a^2', null::text, 'C', 2, 'GENERAL', '$56\div7=8$ and $a^{-6-(-4)}=a^{-2}$, giving $8a^{-2}$.', null::text),
  ('Simplify $3x^3 \div (3x)^3$.', null::text, '1', '1/3', '1/9', '1/27', null::text, 'C', 2, 'GENERAL', '$(3x)^3=27x^3$, so $3x^3\div27x^3=3/27=1/9$.', null::text),
  ('Solve the equation $3^{2x-1} = 1/27^x$.', null::text, '-3', '-1', '-1/5', '1/5', '3', 'D', 3, 'GENERAL', '$1/27^x=27^{-x}=3^{-3x}$, so equating exponents: $2x-1=-3x$ gives $5x=1$, so $x=1/5$.', null::text),
  ('Simplify $x^2y^{-2} \div (xy)^{-1}$.', null::text, 'x/y^3', 'x^3/y', 'x^5/y', 'y/x^3', null::text, 'B', 3, 'GENERAL', '$(xy)^{-1}=x^{-1}y^{-1}$, so dividing means multiplying by $xy$: $x^2y^{-2}\times xy=x^3y^{-1}=x^3/y$.', null::text),
  ('Solve $5^x = 125$.', null::text, '2', '3', '4', '5', null::text, 'B', 1, 'GENERAL', '$125=5^3$, so $x=3$.', null::text),
  ('Solve $9^{x-1} = 27^{x+2}$.', null::text, '-8', '-2', '2', '8', null::text, 'A', 3, 'GENERAL', 'Writing both sides as powers of 3: $2(x-1)=3(x+2)$ gives $2x-2=3x+6$, so $x=-8$.', null::text),
  ('Solve $4^x - 3(2^x) - 4 = 0$.', null::text, '-1', '1', '2', '4', null::text, 'C', 4, 'GENERAL', 'Letting $y=2^x$: $y^2-3y-4=0$ factorises to $(y-4)(y+1)=0$; rejecting the invalid $y=-1$, $y=4$ gives $x=2$.', null::text),
  ('Simplify $(81/16)^{-3/4}$.', null::text, '3/4', '16/81', '8/27', '27/8', null::text, 'C', 3, 'GENERAL', 'Flipping and applying the fractional power: $(16/81)^{3/4}=[\sqrt[4]{16/81}]^3=(2/3)^3=8/27$.', null::text),
  ('Simplify $x^{-2} \times (x^{-2}y^3)^{-1}$.', null::text, '1/(x^2y^3)', '1/y^3', 'x^-2/y^3', 'y^3', null::text, 'B', 3, 'GENERAL', '$(x^{-2}y^3)^{-1}=x^2y^{-3}$, so $x^{-2}\times x^2y^{-3}=x^0y^{-3}=1/y^3$.', null::text),
  ('What is the conceptual difference between $a^{-n}$ and $1/a^n$?', null::text, 'a^-n is always negative while 1/a^n is always positive', 'They are equal by definition, a^-n is simply another way of writing 1/a^n', 'a^-n only applies to fractions, while 1/a^n only applies to whole numbers', 'a^-n means -a^n, while 1/a^n is the reciprocal of a^n', null::text, 'B', 1, 'GENERAL', 'The law of indices $a^{-n}=1/a^n$ is a definition, not a coincidence, the two expressions always have exactly the same value.', null::text),
  ('Using the pattern method, why does any non-zero number raised to the power 0 equal 1?', null::text, 'Because a power of 0 is undefined but assigned 1 by convention only for even bases', 'Because dividing consecutive powers of a in the pattern a^3, a^2, a^1 each step divides by a, so continuing one more step gives a^0 = a÷a = 1', 'Because a^0 means a multiplied by itself zero times, which is always 0, written as 1 by convention', 'Because a^0 = a^1 - a^1, which always equals 0, not 1', null::text, 'B', 2, 'GENERAL', 'Each step down the power ladder ($a^3,a^2,a^1,\ldots$) divides the previous value by $a$; continuing this pattern one more step past $a^1$ gives $a^0=a\div a=1$.', null::text)
) as v(question_text, question_latex, option_a, option_b, option_c, option_d, option_e, correct_letter, difficulty, exam_type, explanation, exam_shortcut)
where c.subject = 'Mathematics' and t.class_level = 'SS1' and t.term = 1 and t.order_index = 106;
-- ------------------------------------------
-- 107. LOGARITHMS OF NUMBERS GREATER THAN 1  -  SS1 Mathematics, Term 1
-- ------------------------------------------

with lesson as (
  insert into public.lessons (topic_id, title, summary, content_body, order_index)
  values (
    (select t.id from public.topics t join public.curricula c on c.id = t.curriculum_id
     where c.subject = 'Mathematics' and t.class_level = 'SS1' and t.term = 1 and t.order_index = 107),
    'Logarithms of Numbers Greater Than 1',
    'Finding logarithms and antilogarithms using tables, and using the laws of logarithms to multiply and divide numbers.',
    '## Logarithms

A logarithm is the inverse of an exponent: it answers "what power must the base be raised to, to get this number?" Definition: if $a^x=y$, then $x=\log_a(y)$.

Fundamental identities: $\log_a(a)=1$ (since $a^1=a$); $\log_a(1)=0$ (since $a^0=1$).

## Characteristic and Mantissa

A base-10 (common) logarithm has two parts: the **characteristic** (the whole-number part, found from the power of 10 when the number is written in standard form) and the **mantissa** (the decimal part, read from log tables using the digits only, ignoring the decimal point). For numbers less than 1, the characteristic is negative and is written with a bar over it, e.g. $\log 0.0716 = \bar{2}.8549$ (meaning $-2+0.8549$), so the mantissa itself always stays positive.

## The Laws of Logarithms (Used With Tables)

- $\log(M\times N)=\log M+\log N$ (multiplication becomes addition)
- $\log(M\div N)=\log M-\log N$ (division becomes subtraction)
- $\log(M^p)=p\times\log M$ (power becomes multiplication)
- $\log(\sqrt[n]{M})=\frac{1}{n}\times\log M$ (root becomes division)

## Finding Antilogarithms

Separate the characteristic and mantissa; look up the mantissa in the antilog table to get the digits; use the characteristic to place the decimal point.

## Real-World Uses

The Richter scale (earthquake magnitude), the pH scale (acidity), and the decibel scale (sound intensity) are all logarithmic, since they compress a huge range of values into a manageable scale.',
    1
  )
  returning id
)
insert into public.worked_examples (lesson_id, title, problem_statement, solution_steps, exam_shortcut, common_trap_warning, real_life_context, status)
select id,
  'Finding the Logarithm of a Number Greater Than 1',
  'Find $\log 43.82$.',
  to_jsonb(array[
    'Write the number in standard form to find the characteristic: $43.82=4.382\times10^1$, so the characteristic is 1.',
    'Look up the mantissa for the digit-string 4382 in the log tables (using only the digits, ignoring the decimal point): mantissa of $4.382 \approx 0.6417$.',
    'Combine the characteristic and mantissa: $\log43.82=1+0.6417$.',
    'Answer: $\log43.82=1.6417$.'
  ]),
  'The characteristic of $\log_{10}N$ is simply the power of 10 when $N$ is written in standard form, no table is needed for this half of the answer, only the mantissa needs the table.',
  null,
  'This same idea of compressing a huge range of values into a manageable scale is exactly why earthquake magnitude (the Richter scale) and sound intensity (the decibel scale) are both defined using logarithms.',
  'published'
from lesson;

insert into public.worked_examples (lesson_id, title, problem_statement, solution_steps, exam_shortcut, common_trap_warning, real_life_context, status)
select l.id,
  'Finding the Logarithm of a Number Less Than 1 (Bar Notation)',
  'Find $\log 0.0716$.',
  to_jsonb(array[
    'Write the number in standard form to find the characteristic: $0.0716=7.16\times10^{-2}$, so the characteristic is $-2$.',
    'Look up the mantissa for the digit-string 716 in the log tables: mantissa of $7.16 \approx 0.8549$.',
    'Combine, using bar notation since the characteristic is negative (this keeps the mantissa positive): $\log0.0716=\bar2.8549$, meaning $-2+0.8549$.',
    'Answer: $\log0.0716=\bar2.8549$.'
  ]),
  null,
  'If a calculation produces something like log $=-1.2$, immediately convert it to bar form ($\bar2.8$, since $-1.2=-2+0.8$) before doing anything else, this is the number one source of lost marks in log-table questions.',
  null,
  'published'
from public.lessons l
where l.topic_id = (select t.id from public.topics t join public.curricula c on c.id = t.curriculum_id
                     where c.subject = 'Mathematics' and t.class_level = 'SS1' and t.term = 1 and t.order_index = 107)
order by l.created_at desc limit 1;

insert into public.worked_examples (lesson_id, title, problem_statement, solution_steps, exam_shortcut, common_trap_warning, real_life_context, status)
select l.id,
  'Using Log Tables for Multiplication and Division',
  'Evaluate $(38.4 \times 8.6) \div 15.2$ using log tables.',
  to_jsonb(array[
    'Rewrite the expression as a log equation using the laws: $\log(\text{answer})=\log38.4+\log8.6-\log15.2$.',
    'Look up each logarithm in the tables: $\log38.4=1.5843$, $\log8.6=0.9345$, $\log15.2=1.1818$.',
    'Add the logs for the numerator: $1.5843+0.9345=2.5188$.',
    'Subtract the log for the denominator: $2.5188-1.1818=1.3370$.',
    'This is the log of the answer; convert back using the antilog table. Characteristic $=1$, mantissa $=0.3370 \to$ antilog digits $\approx2173$, and characteristic 1 places the decimal after 2 digits: $21.73$.',
    'Answer: $(38.4\times8.6)\div15.2\approx21.73$ (check by direct multiplication: $38.4\times8.6=330.24$, and $330.24\div15.2\approx21.73$).'
  ]),
  'Rewrite the whole expression as a sum/difference of logs first (using the laws), then look up every value in one pass, jumping between the problem and the tables repeatedly wastes time and invites transcription errors.',
  null,
  null,
  'published'
from public.lessons l
where l.topic_id = (select t.id from public.topics t join public.curricula c on c.id = t.curriculum_id
                     where c.subject = 'Mathematics' and t.class_level = 'SS1' and t.term = 1 and t.order_index = 107)
order by l.created_at desc limit 1;

insert into public.worked_examples (lesson_id, title, problem_statement, solution_steps, exam_shortcut, common_trap_warning, real_life_context, status)
select l.id,
  'Finding an Antilogarithm',
  'Find $\text{antilog}(3.9042)$.',
  to_jsonb(array[
    'Separate the characteristic and mantissa: characteristic $=3$, mantissa $=0.9042$.',
    'Look up the mantissa $0.9042$ in the antilog table to get the digit string: digits $\approx8021$.',
    'Use the characteristic to place the decimal point: a positive characteristic of 3 means the decimal point sits after $(3+1)=4$ digits from the left: $8.021\times10^3$.',
    'Answer: $\text{antilog}(3.9042)=8021$.'
  ]),
  'The mantissa depends only on the sequence of significant digits, not on where the decimal point is, so one antilog-table lookup gives the digit string, and the characteristic alone decides where the point goes.',
  null,
  null,
  'published'
from public.lessons l
where l.topic_id = (select t.id from public.topics t join public.curricula c on c.id = t.curriculum_id
                     where c.subject = 'Mathematics' and t.class_level = 'SS1' and t.term = 1 and t.order_index = 107)
order by l.created_at desc limit 1;

insert into public.questions (topic_id, lesson_id, question_text, question_latex, option_a, option_b, option_c, option_d, option_e, correct_letter, difficulty, exam_type, explanation, exam_shortcut, status)
select t.id, l.id, v.question_text, v.question_latex, v.option_a, v.option_b, v.option_c, v.option_d, v.option_e, v.correct_letter::char(1), v.difficulty::integer, v.exam_type::exam_type, v.explanation, v.exam_shortcut, 'published'
from public.topics t
join public.curricula c on c.id = t.curriculum_id
join public.lessons l on l.topic_id = t.id
cross join (values
  ('Write $2^5 = 32$ in logarithmic form.', null::text, 'log32 2 = 5', 'log2 5 = 32', 'log2 32 = 5', 'log5 32 = 2', null::text, 'C', 1, 'GENERAL', 'By definition, $a^x=y \iff \log_a y = x$, so $2^5=32$ becomes $\log_2 32=5$.', null::text),
  ('Write $3^{-2} = 1/9$ in exponential and logarithmic form.', null::text, 'log3 9 = -2', 'log(1/9) 3 = -2', 'log3 (1/9) = 2', 'log3 (1/9) = -2', null::text, 'D', 1, 'GENERAL', 'By definition, $3^{-2}=1/9 \iff \log_3(1/9)=-2$.', null::text),
  ('Solve for $x$: $\log_7 49 = x$.', null::text, '0.5', '2', '7', '49', null::text, 'B', 1, 'GENERAL', '$7^2=49$, so $\log_7 49=2$.', null::text),
  ('Using log tables, find $\log_{10}2.87$.', null::text, '0.4597', '0.4579', '0.5479', '1.4579', null::text, 'B', 2, 'GENERAL', 'From the tables, the mantissa for digits 287 is approximately 0.4579, and since $1\le2.87<10$ the characteristic is 0: $\log2.87\approx0.4579$.', null::text),
  ('Using antilog tables, find the antilog of 1.4502.', null::text, '2.821', '14.50', '28.21', '282.1', null::text, 'C', 2, 'GENERAL', 'The mantissa 0.4502 gives digits approximately 2821; the characteristic 1 places the decimal after 2 digits: $28.21$.', null::text),
  ('Solve for $x$: $\log_4 x = 3$.', null::text, '7', '12', '64', '81', null::text, 'C', 2, 'GENERAL', '$\log_4x=3$ means $x=4^3=64$.', null::text),
  ('Solve for $x$: $\log_3 27 = x$.', null::text, '1', '3', '9', '27', null::text, 'B', 1, 'GENERAL', '$3^3=27$, so $\log_3 27=3$.', null::text),
  ('Using log tables, find $\log_{10}602.4$.', null::text, '1.7799', '2.6799', '2.7799', '3.7799', null::text, 'C', 2, 'GENERAL', '$602.4=6.024\times10^2$, so the characteristic is 2; the mantissa for digits 6024 is approximately 0.7799: $\log602.4\approx2.7799$.', null::text),
  ('Using log tables, find $\log_{10}0.000199$.', null::text, '3̄.2989', '4̄.2989', '4̄.7011', '3.2989', null::text, 'B', 3, 'GENERAL', '$0.000199=1.99\times10^{-4}$, so the characteristic is $-4$; the mantissa for digits 199 is approximately 0.2989, giving bar notation $\bar4.2989$.', null::text),
  ('Using antilog tables, find antilog(4.8872).', null::text, '7.7', '7700', '77000', '770000', null::text, 'C', 2, 'GENERAL', 'The mantissa 0.8872 gives digits approximately 7710 (rounded to 77 for this scale); the characteristic 4 places the decimal after 5 digits: approximately $77000$.', null::text),
  ('Using antilog tables, find antilog(2̄.1119).', null::text, '0.00129', '0.0129', '0.129', '1.29', null::text, 'B', 3, 'GENERAL', 'The mantissa 0.1119 gives digits approximately 1294; the negative characteristic $-2$ places this as $1.294\times10^{-2}\approx0.0129$.', null::text),
  ('Find the characteristics of $\log_{10}5432$ and $\log_{10}0.5432$.', null::text, '2 and -1', '3 and -1', '3 and 0', '4 and -1', null::text, 'B', 2, 'GENERAL', '$5432=5.432\times10^3$, characteristic 3; $0.5432=5.432\times10^{-1}$, characteristic $-1$.', null::text),
  ('Evaluate $(38.4 \times 8.6) \div 15.2$, using log tables.', null::text, '2.173', '21.73', '23.71', '217.3', null::text, 'B', 3, 'GENERAL', '$\log38.4+\log8.6-\log15.2=1.5843+0.9345-1.1818=1.3370$, and antilog(1.3370) $\approx21.73$.', null::text),
  ('Evaluate $(403.2 \times 0.056) \div 10.8$, using 4-figure log tables.', null::text, '0.209', '2.09', '2.90', '20.9', null::text, 'B', 3, 'GENERAL', 'Summing and subtracting the relevant logarithms and taking the antilog gives approximately $2.09$.', null::text),
  ('Evaluate $45.6^2$, using log tables.', null::text, '207.936', '2076.36', '2079.36', '2079.63', null::text, 'C', 2, 'GENERAL', '$\log45.6^2=2\log45.6\approx2(1.6590)=3.3180$, and antilog(3.3180)$\approx2079.36$.', null::text),
  ('Evaluate $(1.34)^5$, using log tables.', null::text, '3.40', '4.03', '4.30', '5.30', null::text, 'C', 3, 'GENERAL', '$\log(1.34)^5=5\log1.34\approx5(0.1271)=0.6355$, and antilog(0.6355)$\approx4.30$.', null::text),
  ('Find $n$ if $1000 = 200(1.05)^n$, using logs.', null::text, '≈16 years', '≈20 years', '≈33 years', '≈40 years', null::text, 'C', 4, 'GENERAL', 'Dividing gives $(1.05)^n=5$; taking logs, $n\log1.05=\log5$, so $n=\log5/\log1.05\approx0.6990/0.0212\approx32.99$, about 33 years.', null::text),
  ('Using log tables, evaluate $69.24 \times 8.31$.', null::text, '57.53', '557.3', '575.3', '5753', null::text, 'C', 2, 'GENERAL', '$\log69.24+\log8.31\approx1.8404+0.9196=2.7600$, and antilog(2.7600)$\approx575.3$.', null::text),
  ('Using log tables, evaluate $7031 \times 4.911$.', null::text, '3453', '34430', '34530', '35430', null::text, 'C', 3, 'GENERAL', 'Direct multiplication gives $7031\times4.911\approx34529$, which rounds to about $34530$; the log-table method gives a close approximation.', null::text),
  ('Evaluate $0.5624 \times 0.0378$, using log tables.', null::text, '0.002125', '0.02125', '0.02152', '0.2125', null::text, 'B', 2, 'GENERAL', '$\log0.5624+\log0.0378\approx\bar1.7501+\bar2.5775=\bar2.3276$, and antilog gives approximately $0.02125$.', null::text),
  ('Evaluate $0.003512 \times 0.6207$, using log tables.', null::text, '0.0002180', '0.002180', '0.02180', '0.005657', null::text, 'B', 3, 'GENERAL', 'Direct multiplication gives $0.003512\times0.6207\approx0.002180$.', null::text),
  ('Evaluate $(0.07392)^4$, using log tables.', null::text, '0.000002826', '0.00002826', '0.0002826', '0.0002986', null::text, 'B', 3, 'GENERAL', '$\log(0.07392)^4=4\log0.07392$; taking the antilog of the result gives approximately $0.00002826$.', null::text),
  ('With the aid of tables, evaluate $(42.95)^3$.', null::text, '7925', '78250', '79250', '792500', null::text, 'C', 3, 'GENERAL', '$\log(42.95)^3=3\log42.95\approx3(1.6330)=4.8990$, and antilog(4.8990)$\approx79250$.', null::text),
  ('Evaluate $\sqrt[3]{66.32}$ using tables.', null::text, '3.048', '4.048', '4.480', '40.48', null::text, 'B', 3, 'GENERAL', '$\log\sqrt[3]{66.32}=\frac13\log66.32\approx\frac13(1.8218)=0.6073$, and antilog(0.6073)$\approx4.048$.', null::text),
  ('How many years will it take ₦50,000 to grow to ₦70,000 at 8% per year (compound interest), using logs?', null::text, '≈3.4 years', '≈4.4 years', '≈5.4 years', '≈8.75 years', null::text, 'B', 4, 'GENERAL', '$(1.08)^n=70000/50000=1.4$; taking logs, $n=\log1.4/\log1.08\approx0.1461/0.0334\approx4.4$ years.', null::text)
) as v(question_text, question_latex, option_a, option_b, option_c, option_d, option_e, correct_letter, difficulty, exam_type, explanation, exam_shortcut)
where c.subject = 'Mathematics' and t.class_level = 'SS1' and t.term = 1 and t.order_index = 107;
-- ------------------------------------------
-- 108. LOGARITHMS: POWERS, ROOTS & RELATIONSHIP TO INDICES  -  SS1 Mathematics, Term 1
-- ------------------------------------------

with lesson as (
  insert into public.lessons (topic_id, title, summary, content_body, order_index)
  values (
    (select t.id from public.topics t join public.curricula c on c.id = t.curriculum_id
     where c.subject = 'Mathematics' and t.class_level = 'SS1' and t.term = 1 and t.order_index = 108),
    'Logarithms: Calculations Involving Powers and Roots, and the Relationship to Indices',
    'Doing arithmetic (addition, subtraction, multiplication, division) with bar logarithms, evaluating powers and roots using logs, and converting between logarithmic and index (exponential) form.',
    '## Indices and Logarithms Are Inverse Operations

Every law of indices has a matching law of logarithms:
- Multiplication of numbers corresponds to addition of logarithms
- Division of numbers corresponds to subtraction of logarithms
- Raising to a power corresponds to multiplying the logarithm by the power
- Taking a root corresponds to dividing the logarithm by the root index

## Bar Notation Arithmetic

When the characteristic is negative (written as a bar, e.g. $\bar2.7$), never let the mantissa itself become negative, always "borrow" 1 from the next characteristic unit to keep the mantissa positive.

## Relationship Between Indices and Logarithms

If $y=a^x$, then $x=\log_a(y)$; equating powers when both sides share a base is equivalent to comparing logarithms directly. When a question mixes logs and indices, rewrite everything in one language (index form, or log form) before solving.',
    1
  )
  returning id
)
insert into public.worked_examples (lesson_id, title, problem_statement, solution_steps, exam_shortcut, common_trap_warning, real_life_context, status)
select id,
  'Subtracting Bar Logarithms',
  'Evaluate $\bar2.3 - \bar1.5$.',
  to_jsonb(array[
    'Expand each bar logarithm into its true (negative characteristic plus positive mantissa) form: $\bar2.3=-2+0.3$; $\bar1.5=-1+0.5$.',
    'Subtract, distributing the minus sign carefully across the second bracket: $(-2+0.3)-(-1+0.5)=-2+0.3+1-0.5$.',
    'Collect the whole-number parts and the decimal parts separately: whole numbers $-2+1=-1$; decimals $0.3-0.5=-0.2$.',
    'Combine: $-1-0.2=-1.2$.',
    'Convert back into proper bar notation (mantissa must be positive): $-1.2=-2+0.8$, so this is $\bar2.8$.',
    'Answer: $\bar2.3-\bar1.5=\bar2.8$.'
  ]),
  'Bar arithmetic mistakes are common, so it is often faster to mentally convert to an ordinary negative decimal as a private check, do the sum as ordinary signed decimals, and convert the final result back to bar form.',
  'Distributing the minus sign across the whole second bar logarithm, not just its mantissa, is essential, forgetting to flip the sign of its characteristic too is a common error.',
  'This kind of subtraction of bar logarithms is exactly the step used when log tables compare two very large or very small lab-measured quantities, such as two solutions'' hydrogen-ion concentrations on the pH scale.',
  'published'
from lesson;

insert into public.worked_examples (lesson_id, title, problem_statement, solution_steps, exam_shortcut, common_trap_warning, real_life_context, status)
select l.id,
  'Multiplying a Bar Logarithm by an Integer',
  'Evaluate $\bar2.7 \times 3$.',
  to_jsonb(array[
    'Expand the bar logarithm: $\bar2.7=-2+0.7$.',
    'Multiply every term by 3: $(-2+0.7)\times3=-6+2.1$.',
    'Combine into a single decimal: $-6+2.1=-3.9$.',
    'Convert to bar notation with a positive mantissa: $-3.9=-4+0.1$, so this is $\bar4.1$.',
    'Answer: $\bar2.7\times3=\bar4.1$.'
  ]),
  'Power outside a log multiplies the log, this is exactly why multiplying a bar logarithm by an integer is the log-table equivalent of raising the original number to that power.',
  null,
  null,
  'published'
from public.lessons l
where l.topic_id = (select t.id from public.topics t join public.curricula c on c.id = t.curriculum_id
                     where c.subject = 'Mathematics' and t.class_level = 'SS1' and t.term = 1 and t.order_index = 108)
order by l.created_at desc limit 1;

insert into public.worked_examples (lesson_id, title, problem_statement, solution_steps, exam_shortcut, common_trap_warning, real_life_context, status)
select l.id,
  'Dividing a Bar Logarithm',
  'Evaluate $\bar3.4 \div 2$.',
  to_jsonb(array[
    'Expand the bar logarithm: $\bar3.4=-3+0.4$.',
    'Check whether the whole-number part divides evenly by 2, here $-3$ does not, so borrow 1 unit from the characteristic and add it to the mantissa to make the division clean: $-3+0.4=-4+1.4$.',
    'Now divide both parts by 2: $(-4\div2)+(1.4\div2)=-2+0.7$.',
    'This is already in valid bar form (positive mantissa): $\bar2.7$.',
    'Answer: $\bar3.4\div2=\bar2.7$.'
  ]),
  'Whenever a bar logarithm''s characteristic does not divide evenly by the divisor, borrow just enough whole units from the characteristic into the mantissa first, choosing the borrow so the new characteristic is an exact multiple of the divisor.',
  null,
  null,
  'published'
from public.lessons l
where l.topic_id = (select t.id from public.topics t join public.curricula c on c.id = t.curriculum_id
                     where c.subject = 'Mathematics' and t.class_level = 'SS1' and t.term = 1 and t.order_index = 108)
order by l.created_at desc limit 1;

insert into public.worked_examples (lesson_id, title, problem_statement, solution_steps, exam_shortcut, common_trap_warning, real_life_context, status)
select l.id,
  'Simultaneous Equations in Logarithmic Form',
  'If $\log_3(p+q)=1$ and $\log_2(2p-q)=2$, find $p$ and $q$.',
  to_jsonb(array[
    'Convert the first logarithmic equation into index form: $\log_3(p+q)=1$ means $p+q=3^1=3$.',
    'Convert the second logarithmic equation into index form: $\log_2(2p-q)=2$ means $2p-q=2^2=4$.',
    'Solve the two resulting linear equations simultaneously. Add them in a way that eliminates $q$, add $(p+q=3)$ to $(2p-q=4)$: $(p+q)+(2p-q)=3+4 \to 3p=7$.',
    'Solve for $p$: $p=7/3$.',
    'Substitute $p=7/3$ back into $p+q=3$ to find $q$: $7/3+q=3 \to q=3-7/3=9/3-7/3=2/3$.',
    'Answer: $p=7/3$, $q=2/3$.'
  ]),
  'Don''t try to combine logarithms of different bases directly, convert each log equation to its index (ordinary algebraic) form first, and only then use elimination or substitution.',
  'Mixing up which base each logarithm uses when converting to index form is a common error here, keep each equation''s base attached to its own converted equation.',
  null,
  'published'
from public.lessons l
where l.topic_id = (select t.id from public.topics t join public.curricula c on c.id = t.curriculum_id
                     where c.subject = 'Mathematics' and t.class_level = 'SS1' and t.term = 1 and t.order_index = 108)
order by l.created_at desc limit 1;

insert into public.questions (topic_id, lesson_id, question_text, question_latex, option_a, option_b, option_c, option_d, option_e, correct_letter, difficulty, exam_type, explanation, exam_shortcut, status)
select t.id, l.id, v.question_text, v.question_latex, v.option_a, v.option_b, v.option_c, v.option_d, v.option_e, v.correct_letter::char(1), v.difficulty::integer, v.exam_type::exam_type, v.explanation, v.exam_shortcut, 'published'
from public.topics t
join public.curricula c on c.id = t.curriculum_id
join public.lessons l on l.topic_id = t.id
cross join (values
  ('State the logarithmic law for (a) log(M×N) (b) log(Mⁿ).', null::text, '(a) log M − log N, (b) log M / n', '(a) log M + log N, (b) n log M', '(a) log M × log N, (b) (log M)^n', '(a) log M + log N, (b) log M + n', null::text, 'B', 1, 'GENERAL', 'Multiplication of numbers becomes addition of logs: $\log(MN)=\log M+\log N$. A power becomes a multiplier: $\log(M^n)=n\log M$.', null::text),
  ('Set up the log table method to calculate $P = 5.2 \times 9.8$.', null::text, 'log P = log5.2 − log9.8', 'log P = log5.2 + log9.8', 'log P = log9.8 − log5.2', 'log P = log5.2 × log9.8', null::text, 'B', 1, 'GENERAL', 'Multiplication becomes addition of logarithms: $\log P=\log5.2+\log9.8$.', null::text),
  ('Set up the log table method to calculate $Q = \sqrt{5.2}$.', null::text, 'log Q = 2 log5.2', 'log Q = log5.2 / 5.2', 'log Q = (1/2) log5.2', 'log Q = log(5.2/2)', null::text, 'C', 1, 'GENERAL', 'A square root becomes division of the log by 2: $\log Q=\frac12\log5.2$.', null::text),
  ('Calculate $2 \times \bar3.6100$ (bar logarithm notation), leaving your answer in log form.', null::text, '2̄.2200', '4̄.2200', '5̄.2200', '5̄.7800', null::text, 'C', 3, 'GENERAL', '$\bar3.6100=-3+0.61=-2.39$; multiplying by 2 gives $-4.78$, which converts to bar form as $-5+0.22=\bar5.2200$.', null::text),
  ('Calculate $\bar5.2000 \div 4$.', null::text, '1̄.3000', '1̄.8000', '2̄.3000', '2̄.8000', null::text, 'D', 3, 'GENERAL', '$\bar5.2000=-5+0.2=-4.8$; dividing by 4 gives $-1.2$, which converts to bar form as $-2+0.8=\bar2.8000$.', null::text),
  ('Add $\bar2.3 + \bar1.5$ (bar logarithms).', null::text, '2̄.2', '2̄.8', '3̄.2', '3̄.8', null::text, 'D', 2, 'GENERAL', '$\bar2.3=-1.7$ and $\bar1.5=-0.5$; their sum is $-2.2$, which converts to bar form as $-3+0.8=\bar3.8$.', null::text),
  ('Subtract $\bar2.3 - \bar1.5$ (bar logarithms).', null::text, '0̄.8', '1̄.8', '2̄.8', '1̄.2', null::text, 'C', 2, 'GENERAL', '$\bar2.3=-1.7$ and $\bar1.5=-0.5$; their difference is $-1.2$, which converts to bar form as $-2+0.8=\bar2.8$.', null::text),
  ('Multiply $\bar2.7 \times 3$ (bar logarithms).', null::text, '3̄.1', '4̄.1', '4̄.9', '5̄.1', null::text, 'B', 2, 'GENERAL', '$\bar2.7=-1.3$; multiplying by 3 gives $-3.9$, which converts to bar form as $-4+0.1=\bar4.1$.', null::text),
  ('Divide $\bar3.4 \div 2$ (bar logarithms).', null::text, '1̄.2', '1̄.7', '2̄.2', '2̄.7', null::text, 'D', 3, 'GENERAL', '$\bar3.4=-2.6$, which is $-4+1.4$ after borrowing; dividing by 2 gives $-2+0.7=\bar2.7$.', null::text),
  ('Evaluate $\sqrt[3]{1.65^2} \div 29.4$, using logarithm tables.', null::text, '0.04525', '0.4525', '0.5425', '4.525', null::text, 'B', 4, 'GENERAL', 'Using logs: $\log(\text{answer})=\frac13[2\log1.65-\log29.4]=\frac13[0.4350-1.4683]=\bar1.6556$, and antilog($\bar1.6556)\approx0.4525$.', null::text),
  ('Evaluate $2 \times \bar3.6100$ (repeated exercise item, same as above), leaving your answer in log form.', null::text, '2̄.2200', '4̄.2200', '5̄.2200', '5̄.7800', null::text, 'C', 3, 'GENERAL', '$\bar3.6100=-2.39$; multiplying by 2 gives $-4.78$, which converts to bar form as $\bar5.2200$.', null::text),
  ('Evaluate $\bar5.2000 \div 4$ (repeated exercise item, same as above).', null::text, '1̄.3000', '1̄.8000', '2̄.3000', '2̄.8000', null::text, 'D', 3, 'GENERAL', '$\bar5.2000=-4.8$; dividing by 4 gives $-1.2$, which converts to bar form as $\bar2.8000$.', null::text),
  ('Using logarithm tables, evaluate $0.00784 \div 0.4907$.', null::text, '0.001598', '0.01598', '0.01958', '0.1598', null::text, 'B', 3, 'GENERAL', '$\log0.00784\approx\bar3.8943$ and $\log0.4907\approx\bar1.6908$; their difference is $\bar2.2035$, and antilog($\bar2.2035)\approx0.01598$.', null::text),
  ('Use logarithm tables to evaluate $\sqrt[3]{0.5915}$.', null::text, '0.08395', '0.8395', '0.9385', '8.395', null::text, 'B', 3, 'GENERAL', '$\log0.5915\approx\bar1.7720$ (i.e. $-0.2280$); dividing by 3 gives $-0.0760=\bar1.9240$, and antilog gives approximately $0.8395$.', null::text),
  ('Convert $\bar1.4507$ to an ordinary (single) negative decimal.', null::text, '-1.4507', '-0.5493', '-0.4507', '0.5493', null::text, 'B', 2, 'GENERAL', '$\bar1.4507$ means $-1+0.4507=-0.5493$.', null::text),
  ('Use logarithm tables to evaluate $846.22 \div (54.36\times10^{-3})$.', null::text, '15.57', '1557', '15570', '155700', null::text, 'C', 3, 'GENERAL', '$846.22\div0.05436\approx15569.9$, approximately $15570$.', null::text),
  ('Use logarithm tables to evaluate $\sqrt[3]{0.5915} \times (392.8)^3$.', null::text, '0.509×10^7', '5.09×10^6', '5.09×10^7', '5.09×10^8', null::text, 'C', 4, 'GENERAL', 'Using $\sqrt[3]{0.5915}\approx0.8395$ and $(392.8)^3\approx6.061\times10^7$, the product is approximately $5.09\times10^7$.', null::text),
  ('If $a=5.732$, $b=0.2795$ and $c=378.4$, use logarithm tables to evaluate $a^2b^3/c$, correct to 3 significant figures.', null::text, '1.90×10^-4', '1.90×10^-3', '1.90×10^-2', '9.50×10^-4', null::text, 'B', 4, 'GENERAL', '$a^2\approx32.86$, $b^3\approx0.02183$, so $a^2b^3\approx0.7174$; dividing by $c=378.4$ gives approximately $0.0018957\approx1.90\times10^{-3}$.', null::text),
  ('If $\log 5.957 = 0.7750$, find $\log\sqrt[3]{0.0005957}$.', null::text, '4̄.1986', '2̄.9250', '1̄.5917', '1̄.2853', null::text, 'B', 4, 'GENERAL', '$\log0.0005957=0.7750-4=\bar4.7750$. Dividing by 3 for the cube root: borrow so $-4+0.7750=-6+2.7750$, then $\div3$ gives $-2+0.9250=\bar2.9250$.', null::text),
  ('Express $4^x = 256$ in logarithmic form.', null::text, 'log4 x = 256', 'log256 4 = x, and x = 2', 'log4 256 = x, and x = 4', 'log4 256 = x, and x = 3', null::text, 'C', 2, 'GENERAL', '$4^x=256 \iff \log_4256=x$; since $4^4=256$, $x=4$.', null::text),
  ('Write $7^{-2} = 1/49$ in logarithmic form.', null::text, 'log7 49 = -2', 'log(1/49) 7 = -2', 'log7 (1/49) = 2', 'log7 (1/49) = -2', null::text, 'D', 2, 'GENERAL', '$7^{-2}=1/49 \iff \log_7(1/49)=-2$.', null::text),
  ('Solve the equation $\log_2 x^2 = -6$ (changing from logs to indices).', null::text, 'x = 1/64', 'x = 1/32', 'x = 1/8 (or ±1/8)', 'x = -6', null::text, 'C', 3, 'GENERAL', '$\log_2x^2=-6$ means $x^2=2^{-6}=1/64$, so $x=\pm1/8$.', null::text),
  ('If $\log_6 216 = 4x-1$, find $x$.', null::text, 'x = 0.5', 'x = 1', 'x = 1.47', 'x = 1.75', null::text, 'B', 3, 'GENERAL', '$216=6^3$, so $\log_6216=3$; setting $4x-1=3$ gives $x=1$.', null::text),
  ('Simplify $\log(x^8) - \log(x^2) + \log(x^4)$ using laws of logarithms.', null::text, '2 log x', 'log x^4', '10 log x', '14 log x', null::text, 'C', 2, 'GENERAL', 'Combining exponents: $8-2+4=10$, so the expression simplifies to $10\log x$.', null::text),
  ('Simplify $\log_{10}125 - 2\log_{10}5$.', null::text, 'log 25 ≈ 1.398', 'log 5 ≈ 0.699', 'log 100 = 2', 'log 5 ≈ 1.699', null::text, 'B', 2, 'GENERAL', '$2\log5=\log25$, so $\log125-\log25=\log(125/25)=\log5\approx0.699$.', null::text),
  ('Simplify $\log 200 - 2\log 5 + \log 3$.', null::text, 'log 8', 'log 24 (≈ 1.380)', 'log 40', 'log 120', null::text, 'B', 3, 'GENERAL', '$2\log5=\log25$, so $\log200-\log25+\log3=\log(200/25)+\log3=\log8+\log3=\log24$.', null::text),
  ('If $\log_3(p+q) = 1$ and $\log_2(2p-q) = 2$, find $p$ and $q$.', null::text, 'p=2, q=1', 'p=3, q=0', 'p=7/3, q=-2/3', 'p=7/3, q=2/3', null::text, 'D', 4, 'GENERAL', 'Converting to index form: $p+q=3$ and $2p-q=4$. Adding eliminates $q$: $3p=7$, so $p=7/3$, and $q=3-7/3=2/3$.', null::text),
  ('Solve the logarithmic equation $(6a+3)/3 = 7(2a-1)$.', null::text, '1/3', '2/3', '3/4', '3/2', null::text, 'B', 3, 'GENERAL', 'Clearing the fraction: $6a+3=21(2a-1)=42a-21$, so $24=36a$, giving $a=2/3$.', null::text),
  ('Express $y$ in terms of $x$: which is the correct rearranged form of $\log y = 3\log2 + (1/2)\log m$?', null::text, 'log y = 3log2 − (1/2)log m', 'log y = (3+1/2)log(2m)', 'log y = 3log2 + (1/2)log m', 'log y = log(3×2 + m/2)', null::text, 'C', 2, 'GENERAL', 'The equation is already in simplified additive log form; equivalently $y=2^3\sqrt m=8\sqrt m$.', null::text),
  ('Given that $(y_2)^2 = 2211_3 - 220_4$, find the value of $y$ (convert both sides to base ten first).', null::text, 'y = 101₂ (i.e. 5)', 'y = 110₂ (i.e. 6)', 'y = 111₂ (i.e. 7)', 'y = 1000₂ (i.e. 8)', null::text, 'B', 3, 'GENERAL', '$2211_3=76$ and $220_4=40$ in base ten, so $y^2=76-40=36$, giving $y=6$, which is $110_2$.', null::text)
) as v(question_text, question_latex, option_a, option_b, option_c, option_d, option_e, correct_letter, difficulty, exam_type, explanation, exam_shortcut)
where c.subject = 'Mathematics' and t.class_level = 'SS1' and t.term = 1 and t.order_index = 108;
-- ------------------------------------------
-- 109. SIMPLE EQUATIONS, VARIATION & CHANGE OF SUBJECT  -  SS1 Mathematics, Term 1
-- ------------------------------------------

with lesson as (
  insert into public.lessons (topic_id, title, summary, content_body, order_index)
  values (
    (select t.id from public.topics t join public.curricula c on c.id = t.curriculum_id
     where c.subject = 'Mathematics' and t.class_level = 'SS1' and t.term = 1 and t.order_index = 109),
    'Simple Equations, Change of Subject of Formulae, and Variation',
    'Solving linear equations, rearranging a formula to make a different letter the subject, and setting up and solving direct, inverse, joint and partial variation problems.',
    '## A. Change of Subject of a Formula

The subject is the variable standing alone on one side. To change the subject: (1) clear brackets and fractions, (2) collect all terms containing the required letter on one side, (3) factorise if the letter appears more than once, (4) divide by the remaining factor, (5) undo any powers/roots last. Whatever is done to one side must be done to the other (the balance principle).

## B. Simple Linear Equations

Clear brackets, collect like terms, and (for fractions) multiply through by the LCM of all denominators before solving.

## C. Variation

Variation describes how one quantity changes as another changes; the symbol $\propto$ means "varies as," and is converted to an equation using a constant of variation, $k$.

| Type | Statement | Equation |
|---|---|---|
| Direct | $y$ varies directly as $x$ | $y=kx$ |
| Inverse | $y$ varies inversely as $x$ | $y=k/x$ |
| Joint | $y$ varies jointly as $x$ and $z$ | $y=kxz$ |
| Partial | $y$ is partly constant and partly varies as $x$ | $y=a+bx$ |
| Combined | $y$ varies directly as $x$ and inversely as $z$ | $y=kx/z$ |

**Method:** (1) write the proportionality statement, (2) introduce $k$ to form an equation, (3) substitute given values to find $k$, (4) rewrite the complete formula, (5) substitute to find the unknown.',
    1
  )
  returning id
)
insert into public.worked_examples (lesson_id, title, problem_statement, solution_steps, exam_shortcut, common_trap_warning, real_life_context, status)
select id,
  'Making a Letter the Subject of a Formula',
  'Make $x$ the subject of $a(x+b)=c$.',
  to_jsonb(array[
    'Divide both sides by $a$ to undo the multiplication (the outermost operation): $\frac{a(x+b)}{a}=\frac{c}{a} \to x+b=\frac{c}{a}$.',
    'Subtract $b$ from both sides to undo the addition: $x=\frac{c}{a}-b$.',
    'Optionally combine over a common denominator for a tidier form: $x=\frac{c}{a}-\frac{ab}{a}=\frac{c-ab}{a}$.',
    'Answer: $x=\frac{c-ab}{a}$.'
  ]),
  'To isolate a variable, undo the operations surrounding it in the opposite order to normal BODMAS, working from the outside in.',
  null,
  null,
  'published'
from lesson;

insert into public.worked_examples (lesson_id, title, problem_statement, solution_steps, exam_shortcut, common_trap_warning, real_life_context, status)
select l.id,
  'Solving a Linear Equation With Brackets',
  'Solve $5(x-7) - 7x = -3(4x-5)$.',
  to_jsonb(array[
    'Expand both brackets: $5(x-7)=5x-35$; $-3(4x-5)=-12x+15$.',
    'Rewrite the full equation with brackets expanded: $5x-35-7x=-12x+15$.',
    'Simplify the left-hand side by collecting like terms: $5x-7x=-2x$, so the left side is $-2x-35$.',
    'Collect all $x$-terms on one side (add $12x$ to both sides) and constants on the other: $-2x+12x-35=15 \to 10x-35=15$.',
    'Add 35 to both sides: $10x=50$.',
    'Divide both sides by 10: $x=5$.',
    'Answer: $x=5$.'
  ]),
  'Visualise the equals sign as the pivot of a balance scale that must stay level, whatever you do to one side of an equation, you must do to the other.',
  null,
  null,
  'published'
from public.lessons l
where l.topic_id = (select t.id from public.topics t join public.curricula c on c.id = t.curriculum_id
                     where c.subject = 'Mathematics' and t.class_level = 'SS1' and t.term = 1 and t.order_index = 109)
order by l.created_at desc limit 1;

insert into public.worked_examples (lesson_id, title, problem_statement, solution_steps, exam_shortcut, common_trap_warning, real_life_context, status)
select l.id,
  'Direct Variation',
  '$y$ varies directly as $x^2$. When $x=3$, $y=18$. Find $y$ when $x=5$.',
  to_jsonb(array[
    'Write the proportionality statement: $y \propto x^2$.',
    'Convert to an equation using a constant $k$: $y=kx^2$.',
    'Substitute the given values ($x=3$, $y=18$) to find $k$: $18=k(3)^2=9k \to k=2$.',
    'Write the complete formula with $k$ replaced by its value: $y=2x^2$.',
    'Substitute $x=5$ to find the required value: $y=2(5)^2=2(25)=50$.',
    'Answer: $y=50$.'
  ]),
  'In every variation problem, the very first substitution should use the given pair of values to solve for $k$, never try to answer the "find the unknown" part before $k$ is pinned down numerically.',
  null,
  'Direct-square variation like this describes how a vehicle''s braking distance relates to its speed, doubling your speed does not double the stopping distance, it roughly quadruples it, exactly matching this $y=kx^2$ pattern.',
  'published'
from public.lessons l
where l.topic_id = (select t.id from public.topics t join public.curricula c on c.id = t.curriculum_id
                     where c.subject = 'Mathematics' and t.class_level = 'SS1' and t.term = 1 and t.order_index = 109)
order by l.created_at desc limit 1;

insert into public.worked_examples (lesson_id, title, problem_statement, solution_steps, exam_shortcut, common_trap_warning, real_life_context, status)
select l.id,
  'Partial Variation',
  'The cost of sewing a garment is partly constant and partly varies with time $t$. At $t=6$h, cost $=$ ₦2800; at $t=10$h, cost $=$ ₦3600. Find the cost at $t=4$h.',
  to_jsonb(array[
    'Write the partial variation equation, with $k$ as the constant part and $b$ as the rate of variation with $t$: $c=k+bt$.',
    'Substitute the first data pair ($t=6$, $c=2800$): $2800=k+6b$. (i)',
    'Substitute the second data pair ($t=10$, $c=3600$): $3600=k+10b$. (ii)',
    'Subtract equation (i) from equation (ii) to eliminate $k$: $(3600-2800)=(10b-6b) \to 800=4b$.',
    'Solve for $b$: $b=200$.',
    'Substitute $b=200$ back into equation (i) to find $k$: $2800=k+6(200)=k+1200 \to k=1600$.',
    'Write the complete formula: $c=1600+200t$.',
    'Substitute $t=4$ to find the required cost: $c=1600+200(4)=1600+800=2400$.',
    'Answer: ₦2400.'
  ]),
  'When you have two data pairs for $c=k+bt$, subtracting one equation from the other instantly eliminates $k$ and gives you $b$ directly, much faster than solving simultaneously by substitution.',
  null,
  'This is exactly how a tailor prices a job that has a fixed materials cost plus an hourly labour charge, or how a phone repair shop quotes a fixed call-out fee plus a per-hour service charge.',
  'published'
from public.lessons l
where l.topic_id = (select t.id from public.topics t join public.curricula c on c.id = t.curriculum_id
                     where c.subject = 'Mathematics' and t.class_level = 'SS1' and t.term = 1 and t.order_index = 109)
order by l.created_at desc limit 1;

insert into public.questions (topic_id, lesson_id, question_text, question_latex, option_a, option_b, option_c, option_d, option_e, correct_letter, difficulty, exam_type, explanation, exam_shortcut, status)
select t.id, l.id, v.question_text, v.question_latex, v.option_a, v.option_b, v.option_c, v.option_d, v.option_e, v.correct_letter::char(1), v.difficulty::integer, v.exam_type::exam_type, v.explanation, v.exam_shortcut, 'published'
from public.topics t
join public.curricula c on c.id = t.curriculum_id
join public.lessons l on l.topic_id = t.id
cross join (values
  ('Make $C$ the subject of $F = (9/5)C + 32$.', null::text, 'C=(5/9)F-32', 'C=(5/9)(F-32)', 'C=(5/9)(F+32)', 'C=(9/5)(F-32)', null::text, 'B', 3, 'GENERAL', 'Subtract 32: $F-32=(9/5)C$. Multiply both sides by $5/9$: $C=(5/9)(F-32)$.', null::text),
  ('Make $r$ the subject of $A = P(1+r)^n$.', null::text, 'r=(A/P)^n - 1', 'r=(A/P)^(1/n) - 1', 'r=(A/P)^(1/n) + 1', 'r=(A-P)^(1/n)', null::text, 'B', 4, 'GENERAL', 'Divide by $P$: $A/P=(1+r)^n$. Take the $n$th root: $(A/P)^{1/n}=1+r$. Subtract 1: $r=(A/P)^{1/n}-1$.', null::text),
  ('If $y \propto x$ and $y=10$ when $x=2$, find $y$ when $x=7$.', null::text, '14', '17.5', '35', '70', null::text, 'C', 2, 'GENERAL', '$k=y/x=10/2=5$, so $y=5x$; at $x=7$, $y=35$.', null::text),
  ('If $y \propto 1/x$ and $y=5$ when $x=4$, find $y$ when $x=10$.', null::text, '0.5', '2', '8', '12.5', null::text, 'B', 2, 'GENERAL', '$k=xy=4\times5=20$, so $y=20/x$; at $x=10$, $y=2$.', null::text),
  ('If $P \propto L^2$ and $L$ is doubled, what happens to $P$?', null::text, 'P doubles', 'P becomes 4 times larger', 'P becomes 8 times larger', 'P stays the same', null::text, 'B', 2, 'GENERAL', 'Since $P=kL^2$, doubling $L$ gives $k(2L)^2=4kL^2$, so $P$ becomes 4 times as large.', null::text),
  ('Make $h$ the subject of $V = (1/3)\pi r^2(h+k)$.', null::text, 'h=3V/(πr²)+k', 'h=3V/(πr²)-k', 'h=V/(3πr²)-k', 'h=3V/(πr)-k', null::text, 'B', 3, 'GENERAL', 'Multiply both sides by $3/(\pi r^2)$: $h+k=3V/(\pi r^2)$. Subtract $k$: $h=3V/(\pi r^2)-k$.', null::text),
  ('Make $x$ the subject of $y = ax/(x-b)$.', null::text, 'x=ay/(y-b)', 'x=by/(y-a)', 'x=by/(y+a)', 'x=b(y-a)/y', null::text, 'B', 4, 'GENERAL', 'Clear the fraction: $y(x-b)=ax$, so $xy-by=ax$; collecting $x$-terms: $x(y-a)=by$, giving $x=by/(y-a)$.', null::text),
  ('If $V = (1/3)\pi r^2 h$, find $V$ when $\pi=22/7$, $r=3$, $h=7$.', null::text, '22', '33', '66', '198', null::text, 'C', 2, 'GENERAL', '$V=\frac13\times\frac{22}{7}\times9\times7=\frac13\times198=66$.', null::text),
  ('$F$ varies inversely as $d^2$. When $d=2$cm, $F=5$N. Find $F$ when $d=5$cm.', null::text, '0.8N', '2N', '8N', '12.5N', null::text, 'A', 3, 'GENERAL', '$k=Fd^2=5\times4=20$, so $F=20/d^2$; at $d=5$, $F=20/25=0.8$N.', null::text),
  ('$Z$ varies directly as $x^2$ and inversely as $y$. When $x=2$, $y=3$, $Z=8$. Find $Z$ when $x=3$, $y=2$.', null::text, '6', '13.5', '18', '27', null::text, 'D', 4, 'GENERAL', '$k=Zy/x^2=8\times3/4=6$, so $Z=6x^2/y$; at $x=3,y=2$: $Z=6\times9/2=27$.', null::text),
  ('Make $x$ the subject of $1/x + 1/a = 1/b$.', null::text, 'x=ab/(b-a)', 'x=ab/(a-b)', 'x=(a+b)/(ab)', 'x=a-b', null::text, 'B', 4, 'GENERAL', '$1/x=1/b-1/a=(a-b)/(ab)$, so $x=ab/(a-b)$.', null::text),
  ('$P$ varies directly as $q$ and inversely as the square of $r$. $P=12$ when $q=6$, $r=3$. Find $P$ when $q=8$, $r=2$.', null::text, '24', '36', '54', '72', null::text, 'B', 4, 'GENERAL', '$k=Pr^2/q=12\times9/6=18$, so $P=18q/r^2$; at $q=8,r=2$: $P=18\times8/4=36$.', null::text),
  ('Make $t$ the subject of $s = \frac{1}{2}gt^2$.', null::text, 't=√(2g/s)', 't=√(2s/g)', 't=2s/g', 't=√(s/2g)', null::text, 'B', 3, 'GENERAL', 'Multiply both sides by $2/g$: $t^2=2s/g$. Take the square root: $t=\sqrt{2s/g}$.', null::text),
  ('Make $x$ the subject of $y = (k^2+x^2)/t$.', null::text, 'x=√(yt-k²)', 'x=(yt)²-k²', 'x=yt-k²', 'x=√(yt)-k²', null::text, 'A', 3, 'GENERAL', 'Multiply by $t$: $yt=k^2+x^2$. Subtract $k^2$: $x^2=yt-k^2$. Take the square root: $x=\sqrt{yt-k^2}$.', null::text),
  ('If $4a^3 = c - b^2$, find $b$ when $a=-3$ and $c=24$, correct to 2 decimal places.', null::text, '≈-11.49', '≈10.39', '≈11.49', '≈132.00', null::text, 'C', 4, 'GENERAL', '$4(-3)^3=-108$, so $b^2=c-4a^3=24-(-108)=132$, giving $b=\sqrt{132}\approx11.49$.', null::text),
  ('Make $r$ the subject of $Q = P(1+r/100)^2$. Find $r$ (to 3 significant figures) when $Q=625$, $P=225$.', null::text, '≈33.3', '≈66.7', '≈77.8', '≈166.7', null::text, 'B', 4, 'GENERAL', '$Q/P=(1+r/100)^2=625/225\approx2.778$; taking the square root, $1+r/100\approx1.667$, so $r\approx66.7$.', null::text),
  ('Given $100[(A/P)^{1/n} - 1] = r$, make $A$ the subject; find $A$ when $P=₦7808$, $n=3$, $r=25$.', null::text, '₦7,930', '₦9,760', '₦15,250', '₦19,520', null::text, 'C', 4, 'GENERAL', '$(A/P)^{1/n}=1+r/100=1.25$, so $A/P=1.25^3=1.953125$, giving $A=7808\times1.953125=₦15{,}250$.', null::text),
  ('Given $h = \sqrt{(2p+q)/(p-3q)}$, express $p$ in terms of $q$ and $h$.', null::text, 'p=q(3h²-1)/(h²+2)', 'p=q(3h²+1)/(h²-2)', 'p=q(h²-2)/(3h²+1)', 'p=q(1-3h²)/(h²-2)', null::text, 'B', 4, 'GENERAL', 'Squaring: $h^2(p-3q)=2p+q$, so $h^2p-2p=q+3qh^2$, giving $p(h^2-2)=q(1+3h^2)$, so $p=q(3h^2+1)/(h^2-2)$.', null::text),
  ('If $v^2 = u^2 + 2as$, find $u$ when $v=7$, $a=10$, $s=2$.', null::text, '±3', '3', '-3', '±9', '9', 'A', 2, 'GENERAL', '$u^2=v^2-2as=49-40=9$, so $u=\pm3$.', null::text),
  ('If $S = \sqrt{a^2(b^2-c)}/(2a)$, find $S$ when $a=2$, $b=-2$, $c=-5$.', null::text, '6', '7¾', 'S = ±3/2', '-3/2 only', null::text, 'C', 4, 'GENERAL', '$b^2-c=4-(-5)=9$, so $a^2(b^2-c)=4\times9=36$, and $\sqrt{36}=6$; dividing by $2a=4$ gives $S=\pm3/2$.', null::text),
  ('Make $t$ the subject of $p = (t-1)ax - at$.', null::text, 't=(p-ax)/(ax-a)', 't=(p+ax)/(ax-a)', 't=(p+ax)/(ax+a)', 't=(p+a)/(ax-a)', null::text, 'B', 4, 'GENERAL', 'Expanding: $p=atx-ax-at=at(x-1)-ax$, so $p+ax=at(x-1)$, giving $t=(p+ax)/(ax-a)$.', null::text),
  ('If $(2d-3c)/(5d+c) = m/n$, express $d$ in terms of $c$, $m$ and $n$.', null::text, 'd=c(m-3n)/(2n-5m)', 'd=c(m+3n)/(2n-5m)', 'd=c(m+3n)/(2n+5m)', 'd=c(3n-m)/(5m-2n)', null::text, 'B', 4, 'GENERAL', 'Cross-multiplying: $n(2d-3c)=m(5d+c)$ gives $2nd-5md=mc+3nc$, so $d(2n-5m)=c(m+3n)$, giving $d=c(m+3n)/(2n-5m)$.', null::text),
  ('If $1/p = 1/q + 1/r$, and $p=2/5$, $q=4/7$, find $r$.', null::text, '3/4', '4/3', '4/9', '9/4', null::text, 'B', 3, 'GENERAL', '$1/p=5/2$ and $1/q=7/4$, so $1/r=5/2-7/4=3/4$, giving $r=4/3$.', null::text),
  ('Make $r$ the subject of $r/(yx) + p/x = r/x$.', null::text, 'r=yp/(x-y)', 'r=yp/(y-x)', 'r=p/[y(y-x)]', 'r=xy/p', 'r=(x+y)/p', 'B', 4, 'GENERAL', 'Multiplying through by the LCM $yx$ and collecting the $r$-terms on one side gives $r=yp/(y-x)$ after factorising.', null::text),
  ('Solve for $x$: $5(x-7) - 7x = -3(4x-5)$.', null::text, '1/5', '5/6', '2', '5', null::text, 'D', 3, 'GENERAL', 'Expanding and collecting terms: $10x-35=15$, so $10x=50$, giving $x=5$.', null::text),
  ('If $5x-3 = 4x-7$, what is the value of $6x$?', null::text, '26', '6', '4', '-4', '-24', 'E', 2, 'GENERAL', '$5x-4x=-7+3$ gives $x=-4$, so $6x=-24$.', null::text),
  ('If $6x+7 = 4x-3$, what is the value of $8x-4$?', null::text, '-44', '-5', '-1', '36', '44', 'A', 2, 'GENERAL', '$6x-4x=-3-7$ gives $2x=-10$, so $x=-5$, and $8x-4=8(-5)-4=-44$.', null::text),
  ('Solve the equation: $3(2x-7) = 2(x-8)$.', null::text, '-5/4', '4/5', '5/4', '5', null::text, 'C', 2, 'GENERAL', 'Expanding: $6x-21=2x-16$, so $4x=5$, giving $x=5/4$.', null::text),
  ('Simplify $3x/5 + 2x/15 = 3/5$, solve for $x$.', null::text, '9/11', '7/11', '7', '8/7', null::text, 'A', 2, 'GENERAL', 'Multiplying through by 15: $9x+2x=9$, so $11x=9$, giving $x=9/11$.', null::text),
  ('Find $t$ if $(1/3)(t+5) = (1/4)(5t-2)$.', null::text, '13/11', '2 4/11 (=26/11)', '2 6/11', '26/13', null::text, 'B', 3, 'GENERAL', 'Multiplying through by 12: $4(t+5)=3(5t-2)$ gives $4t+20=15t-6$, so $26=11t$, giving $t=26/11=2\frac4{11}$.', null::text),
  ('Solve $3b/9 + 1/2 = 3/4 + b/4$.', null::text, '-3', '-2', '2', '3', '4', 'D', 2, 'GENERAL', 'Multiplying through by 12: $4b+6=9+3b$, giving $b=3$.', null::text),
  ('Solve the equation $3/[2(x-2)] - 2/[3(2-x)] = 0$.', null::text, '2', '3', '6', '13', '26', 'D', 4, 'GENERAL', 'Combining the fractions over a common denominator and solving the resulting linear equation gives $x=13$.', null::text),
  ('Solve $(4x-1)/3 - (3x-1)/2 = (5-2x)/4$.', null::text, '3¾', '4¼', '13/6', '3¼ (=13/4)', null::text, 'D', 3, 'GENERAL', 'Multiplying through by 12: $4(4x-1)-6(3x-1)=3(5-2x)$ gives $-2x+2=15-6x$, so $4x=13$, giving $x=13/4=3\frac14$.', null::text),
  ('$y$ varies directly as the square of $x$. When $x=3$, $y=18$. Find $y$ when $x=5$.', null::text, '30', '50', '54', '90', null::text, 'B', 2, 'GENERAL', '$k=y/x^2=18/9=2$, so $y=2x^2$; at $x=5$, $y=2(25)=50$.', null::text),
  ('$R$ varies inversely as $V$. When $R=10$, $V=25$, find $V$ when $R=5$.', null::text, '25', '50', '100', '125', null::text, 'B', 3, 'GENERAL', '$k=RV=10\times25=250$, so $V=250/R$; at $R=5$, $V=250/5=50$.', null::text),
  ('$y$ varies jointly as $x$ and $z$. When $x=2$, $z=3$, $y=24$, find $y$ when $x=4$, $z=6$.', null::text, '48', '72', '96', '192', null::text, 'C', 2, 'GENERAL', '$k=y/(xz)=24/6=4$, so $y=4xz$; at $x=4,z=6$: $y=4\times24=96$.', null::text),
  ('$y$ varies directly as $x^2$ and inversely as $z$. When $x=4$, $z=9$, $y=8$, find $y$ when $x=6$, $z=16$.', null::text, '6.75', '10.125', '13.5', '20.25', null::text, 'B', 4, 'GENERAL', '$k=yz/x^2=8\times9/16=4.5$, so $y=4.5x^2/z$; at $x=6,z=16$: $y=4.5\times36/16=10.125$.', null::text),
  ('If $x \propto y$, when $x=5$, $y=15$, find $y$ when $x=1.5$.', null::text, '50', '45', '5', '4.5', '2.25', 'D', 2, 'GENERAL', '$k=x/y=5/15=1/3$, so $y=3x$; at $x=1.5$, $y=4.5$.', null::text),
  ('The period of a pendulum varies as the square root of its length. If a 49cm pendulum oscillates for 35 sec, find the oscillation time for a 121cm pendulum.', null::text, '77', '55', '18', '11', '7', 'B', 3, 'GENERAL', '$k=T/\sqrt L=35/7=5$, so $T=5\sqrt L$; at $L=121$, $T=5\times11=55$ sec.', null::text),
  ('$G$ varies directly as the square of $H$. If $G=4$ when $H=3$, find $H$ when $G=100$.', null::text, '15', '25', '75', '225', null::text, 'A', 3, 'GENERAL', '$k=G/H^2=4/9$, so $H^2=100/(4/9)=225$, giving $H=15$.', null::text),
  ('The resistance $R$ of a wire is proportional to its length $L$. $R=25\Omega$ when $L=12$m. Find the length for $R=40\Omega$.', null::text, '15.0m', '19.2m', '24.0m', '30.0m', null::text, 'B', 3, 'GENERAL', '$k=R/L=25/12$, so $L=R/k=40\times12/25=19.2$m.', null::text),
  ('$Q$ varies directly as the cube of $P$. When $P=1$, $Q=3$. Find $P$ when $Q=24$.', null::text, '1/3', '1/2', '2', '3', null::text, 'C', 3, 'GENERAL', '$k=3$, so $Q=3P^3$; $24=3P^3$ gives $P^3=8$, so $P=2$.', null::text),
  ('$P$ varies directly as the cube root of $Q$, and $P=3$ when $Q=125$. Find $Q$ when $P=18/5$.', null::text, '169', '216', '343', '450', '512', 'B', 3, 'GENERAL', '$k=P/\sqrt[3]Q=3/5$; at $P=3.6$, $\sqrt[3]Q=3.6/0.6=6$, so $Q=216$.', null::text),
  ('If $a$ is directly proportional to $b$, and $a=-1$, $b=-4$, find the formula connecting $a$ and $b$.', null::text, 'a=(1/4)b', 'a=(1/2)b', 'a=b', 'a=2b', 'a=4b', 'A', 2, 'GENERAL', '$k=a/b=(-1)/(-4)=1/4$, so $a=(1/4)b$.', null::text)
) as v(question_text, question_latex, option_a, option_b, option_c, option_d, option_e, correct_letter, difficulty, exam_type, explanation, exam_shortcut)
where c.subject = 'Mathematics' and t.class_level = 'SS1' and t.term = 1 and t.order_index = 109;

insert into public.questions (topic_id, lesson_id, question_text, question_latex, option_a, option_b, option_c, option_d, option_e, correct_letter, difficulty, exam_type, explanation, exam_shortcut, status)
select t.id, l.id, v.question_text, v.question_latex, v.option_a, v.option_b, v.option_c, v.option_d, v.option_e, v.correct_letter::char(1), v.difficulty::integer, v.exam_type::exam_type, v.explanation, v.exam_shortcut, 'published'
from public.topics t
join public.curricula c on c.id = t.curriculum_id
join public.lessons l on l.topic_id = t.id
cross join (values
  ('$y$ varies directly as an unknown power $n$ of $x$. If $y=0.4$ when $x=2$ and $y=6.4$ when $x=4$, find $n$ and the relation.', null::text, 'n=2, y=(1/10)x²', 'n=3, y=(1/20)x³', 'n=4, y=(1/16)x⁴', 'n=4, y=(1/40)x⁴', null::text, 'D', 4, 'GENERAL', 'Dividing the two equations: $6.4/0.4=16=(4/2)^n=2^n$, so $n=4$. Then $k=0.4/2^4=1/40$, giving $y=(1/40)x^4$.', null::text),
  ('If $S$ is directly proportional to $T$ and $T=120$ when $S=30$, find $T$ when $S=136$.', null::text, '453', '510', '544', '576', null::text, 'C', 2, 'GENERAL', '$k=T/S=120/30=4$, so $T=4S$; at $S=136$, $T=544$.', null::text),
  ('$P$ varies directly as the cube root of $Q$. When $P=20$, $Q=125$, find $P$ when $Q=27$.', null::text, '12', '15', '24', '25', '30', 'A', 3, 'GENERAL', '$k=P/\sqrt[3]Q=20/5=4$; at $Q=27$, $\sqrt[3]Q=3$, so $P=4\times3=12$.', null::text),
  ('If $A$ varies directly as the square root of $B$, $A=35$ when $B=25$, find $B$ when $A=14$.', null::text, '14', '7', '6', '5', '4', 'E', 3, 'GENERAL', '$k=A/\sqrt B=35/5=7$; at $A=14$, $\sqrt B=2$, so $B=4$.', null::text),
  ('The rate of petrol consumption varies directly as the square of the distance covered. 4 litres for 15km, how far on 9 litres?', null::text, '22½km', '30km', '33¾km', '45km', null::text, 'A', 4, 'GENERAL', '$k=4/15^2=4/225$; at 9 litres, $d^2=9/k=506.25$, giving $d=22.5$km.', null::text),
  ('If $y$ is inversely proportional to $x$ and $x=3$ when $y=4$, find $y$ when $x=2$.', null::text, '1', '3', '6', '9', null::text, 'C', 2, 'GENERAL', '$k=xy=12$, so $y=12/x$; at $x=2$, $y=6$.', null::text),
  ('$y$ varies inversely as $x^2$. If $y=3$ when $x=4$, find $y$ when $x=2$.', null::text, '8', '9', '10', '11', '12', 'E', 3, 'GENERAL', '$k=yx^2=3\times16=48$, so $y=48/x^2$; at $x=2$, $y=48/4=12$.', null::text),
  ('A body weighs 80N on the earth''s surface (radius 6400km) and weight varies inversely as the square of distance from the centre. (i) find the relation, (ii) distance for a 20N weight, (iii) weight 1600km above the surface.', null::text, '(i) w=3.2768×10⁹/d², (ii) d=6400km, (iii) w=51.2N', '(i) w=3.2768×10⁹/d², (ii) d=12800km, (iii) w=51.2N', '(i) w=3.2768×10⁸/d², (ii) d=12800km, (iii) w=51.2N', '(i) w=3.2768×10⁹/d², (ii) d=12800km, (iii) w=20.0N', null::text, 'B', 4, 'GENERAL', '$k=Wd^2=80\times6400^2=3.2768\times10^9$. (ii) $20=k/d^2$ gives $d=12800$km. (iii) at $d=8000$km, $w=k/d^2=51.2$N.', null::text),
  ('If $(y+2)$ varies inversely as $x$, and $y=3$ when $x=2$, find $y$ when $x=5$.', null::text, '0', '2', '4', '7', '11', 'A', 3, 'GENERAL', '$k=(y+2)x=5\times2=10$, so $(y+2)=10/x$; at $x=5$, $y+2=2$, giving $y=0$.', null::text),
  ('$n$ varies inversely as the square root of $m$. If $n=5$ when $m=9$, state the relation between $n$ and $m$.', null::text, 'n=15m', 'm=15n', 'm=k/(15n)', 'n=15/√m', 'n=15/m', 'D', 3, 'GENERAL', '$k=n\sqrt m=5\times3=15$, so $n=15/\sqrt m$.', null::text),
  ('$Y$ varies inversely as the cube root of $x$. If $Y=4$ when $x=0.125$, find $Y$ when $x=8$.', null::text, '5', '4', '3', '2', '1', 'E', 3, 'GENERAL', '$k=Y\sqrt[3]x=4\times0.5=2$, so $Y=2/\sqrt[3]x$; at $x=8$, $\sqrt[3]x=2$, giving $Y=1$.', null::text),
  ('If $y \propto 1/x^2$ and $y=12$ when $x=4$, find $y$ when $x=1/2$.', null::text, '2½', '5', '10', '768', null::text, 'D', 4, 'GENERAL', '$k=yx^2=12\times16=192$; at $x=1/2$, $y=192/(1/4)=768$.', null::text),
  ('The resistance of an electric wire varies inversely as the square of the potential difference. Resistance 0.7$\Omega$ at 0.4V. Find the p.d. when resistance is 44.8$\Omega$.', null::text, '0.05V', '0.13V', '0.50V', '0.52V', '5.18V', 'A', 4, 'GENERAL', '$k=RV^2=0.7\times0.16=0.112$; at $R=44.8$, $V^2=0.112/44.8=0.0025$, giving $V=0.05$V.', null::text),
  ('If $p$ varies inversely as the square of $q$, and $p=8$ when $q=2$, find $p$ when $q=4$.', null::text, '2', '4', '8', '16', null::text, 'A', 2, 'GENERAL', '$k=pq^2=8\times4=32$; at $q=4$, $p=32/16=2$.', null::text),
  ('If $y$ is inversely proportional to $x$, $y=20$ when $x=1/4$, find $x$ when $y=30$.', null::text, '1/6', '1/5', '1/4', '1/3', '1/2', 'A', 3, 'GENERAL', '$k=xy=20\times0.25=5$; at $y=30$, $x=5/30=1/6$.', null::text),
  ('$x$ varies directly as $y$ and inversely as $z$. When $x=5$, $y=2$, $z=1$, find $x$ when $y=5$, $z=2$.', null::text, '2.5', '5.0', '6.25', '6.52', '7.5', 'C', 3, 'GENERAL', '$k=xz/y=5\times1/2=2.5$, so $x=2.5y/z$; at $y=5,z=2$: $x=2.5\times5/2=6.25$.', null::text),
  ('The cost of material for a drum varies as the cube of the radius and inversely as the surface area. Cost ₦150 when area$=2250$cm², radius$=15$cm. Find cost when radius$=18$cm, area$=2700$cm².', null::text, '₦270', '₦216', '₦196', '₦180', '₦168', 'B', 4, 'GENERAL', '$k=\text{cost}\times\text{area}/r^3=150\times2250/3375=100$; at $r=18,\text{area}=2700$: cost$=100\times5832/2700=₦216$.', null::text),
  ('The energy $E$ of a moving object varies directly as mass $m$ and the square of velocity $v$. When $m=8$kg, $v=5$m/s, $E=100$J, find $E$ when $m=6$kg, $v=2$m/s.', null::text, '6J', '12J', '24J', '48J', '96J', 'B', 3, 'GENERAL', '$k=E/(mv^2)=100/(8\times25)=0.5$; at $m=6,v=2$: $E=0.5\times6\times4=12$J.', null::text),
  ('$F \propto Q/T^2$. When $Q=32$, $T=4$, $F=20$. Find $F$ when $Q=49$, $T=7$.', null::text, '7', '10', '14', '49', '160', 'B', 3, 'GENERAL', '$k=FT^2/Q=20\times16/32=10$, so $F=10Q/T^2$; at $Q=49,T=7$: $F=10\times49/49=10$.', null::text),
  ('Given $x \propto by$, when $x=2$, $y=3$, $b=2$, find $b$ when $x=3$, $y=1$.', null::text, '1/3', '3', '6', '9', '12', 'D', 4, 'GENERAL', '$k=x/(by)=2/6=1/3$, so $x=(1/3)by$; at $x=3,y=1$: $3=(1/3)b$, giving $b=9$.', null::text),
  ('$A=kB/C^2$, $A=20$ when $B=5$, $C=1/3$. Find (i) the relation (ii) $A$ when $B=4$, $C=1/6$.', null::text, '(i) A=(4/9)(B/C²), (ii) A=16', '(i) A=(9/4)(B/C²), (ii) A=64', '(i) A=(4/9)(B/C²), (ii) A=64', '(i) A=(4/9)(B/C), (ii) A=64', null::text, 'C', 4, 'GENERAL', '$k=AC^2/B=20\times(1/9)/5=4/9$. At $B=4,C=1/6$: $A=(4/9)\times4/(1/36)=64$.', null::text),
  ('The energy $E$ varies directly as resistance $R$ and inversely as the square of distance $D$. $E=32/25$ when $R=16$, $D=10$. Find $R$ when $E=32$, $D=7$.', null::text, '49', '98', '196', '392', null::text, 'C', 4, 'GENERAL', '$k=ED^2/R=(32/25)\times100/16=8$; at $E=32,D=7$: $32=8R/49$, giving $R=196$.', null::text),
  ('The cost of sewing a garment is partly constant and partly varies with time. At 6h, cost=₦2800; at 10h, cost=₦3600. Find the cost at 4h.', null::text, '₦2000', '₦2400', '₦2800', '₦3600', null::text, 'B', 3, 'GENERAL', 'Solving $c=k+bt$ from the two data points gives $k=1600,b=200$; at $t=4$, $c=1600+800=₦2400$.', null::text),
  ('$A$ varies partly as $B$ and partly as $C$. $A=4$ when $B=2$, $C=-2$; $A=3$ when $B=3$, $C=1.5$. Find $C$ when $A=0.5$, $B=2.7$.', null::text, '2.33', '3.10', '4.65', '5.40', null::text, 'C', 5, 'GENERAL', 'Solving $A=k_1B+k_2C$ from the two data points gives $k_1=4/3, k_2=-2/3$; substituting $A=0.5,B=2.7$ and solving for $C$ gives $C=4.65$.', null::text),
  ('$z$ is partly constant and partly varies as $y$. $z=2$ when $y=1$; $z=1$ when $y=2$. State the equation connecting $y$ and $z$.', null::text, 'z=2−y', 'z=3−2y', 'z=3−y', 'z=2+y', 'z=2+3y', 'C', 3, 'GENERAL', 'Solving $z=a+by$ from the two data points gives $a=3, b=-1$, so $z=3-y$.', null::text),
  ('The resistance $R$ to the motion of a car is partly constant and partly varies as the square of speed $V$. At 80km/h, $R=1060$N; at 120km/h, $R=1460$N. Find $R$ at 140km/h.', null::text, '1700N', '1720N', '1760N', '1780N', null::text, 'B', 5, 'GENERAL', 'Solving $R=k+bV^2$ from the two data points gives $b=0.05, k=740$; at $V=140$, $R=740+0.05(19600)=1720$N.', null::text),
  ('$y$ varies partly as the square of $x$ and partly as the inverse of the square root of $x$. $y=2$ when $x=1$; $y=6$ when $x=4$. Find the relation.', null::text, 'y = x² + 1/x', 'y=(10/31)x²+(1/31)(1/√x)', 'y=(10/31)x²+(1/31)(1/x)', 'y=(10/31)x²+(52/31)(1/√x)', null::text, 'D', 5, 'GENERAL', 'Solving $y=k_1x^2+k_2/\sqrt x$ from the two data points gives $k_1=10/31$ and $k_2=52/31$, so $y=(10/31)x^2+(52/31)(1/\sqrt x)$.', null::text),
  ('If $x$ varies inversely as $y$ and $y$ varies directly as $z$, what is the relationship between $x$ and $z$?', null::text, 'x∝z', 'x∝√z', 'x∝z²', 'x∝1/z', null::text, 'D', 3, 'GENERAL', 'Since $x=k_1/y$ and $y=k_2z$, substituting gives $x=k_1/(k_2z)$, so $x\propto1/z$.', null::text)
) as v(question_text, question_latex, option_a, option_b, option_c, option_d, option_e, correct_letter, difficulty, exam_type, explanation, exam_shortcut)
where c.subject = 'Mathematics' and t.class_level = 'SS1' and t.term = 1 and t.order_index = 109;
