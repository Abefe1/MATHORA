-- ==========================================
-- MATHORA  -  SS2 Mathematics, First Term: Real Lesson Content Seed
-- Eight topics (order_index 101-108), each with one lesson, worked
-- examples, and every question from that week's Gamified Exercise
-- Bank in SS1-SS3_MATHEMATICS_CURATED.md's "SS2 Mathematics > First
-- Term" section. The curated file's First Term runs Weeks 1-10:
--   Week 1 -> topic 101 (Logarithms)
--   Week 2 -> topic 102 (Approximations/Standard Form/% Error)
--   Week 3 -> topic 103 (Sequences & Series: A.P.)
--   Week 4 -> topic 104 (Geometric Progression)
--   Week 5 -> topic 105 (Quadratic Equations from Sum & Product of Roots)
--   Week 6 -> SKIPPED: explicitly a "Review of half term work and
--     periodic test" week with no new teaching content and an empty
--     Gamified Exercise Bank ("no new exercises - use a mixed review
--     quiz drawn from Weeks 1-5"), so it has no dedicated topic row.
--   Week 7 -> topic 106 (Simultaneous Equations: Elimination & Substitution)
--   Week 8 -> topic 107 (Simultaneous Equations: Linear & Quadratic)
--   Week 9 -> topic 108 (Straight Line Graphs: Gradient)
--   Week 10 -> SKIPPED: explicitly a "Revision" week, comprehensive
--     review of Weeks 1-9 with no new teaching content and an empty
--     Gamified Exercise Bank ("no new exercises - combine questions
--     from Weeks 1-9"), so it has no dedicated topic row.
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
--   mathora_seed_ss2_term1_content.sql (this file)
--
-- Pattern (matches mathora_seed_exemplar_lessons.sql and
-- mathora_seed_ss1_term1_content.sql): one `with lesson as (insert
-- into lessons ... returning id) insert into worked_examples ...
-- select ... from lesson` block creates the lesson and its first
-- worked example together; additional worked examples for the same
-- topic look the lesson back up by topic_id (the CTE only lives for
-- one statement); questions are inserted in batches via `cross join
-- (values (...), ...) as v(...)`, joined to both the topic and its
-- lesson so questions.lesson_id is populated.
--
-- Only topic 108 (Straight Line Graphs: Gradient) uses a supported
-- diagram_type (coordinate_plane), on its worked examples  -  the
-- other seven topics (logarithms, approximation, A.P., G.P.,
-- quadratics from roots, simultaneous equations x2) are pure algebra
-- with no natural geometric figure, so diagram_type/diagram_data are
-- left at their 'none'/'{}' defaults there, per the content-worker
-- prompt's own instruction not to force a diagram where one doesn't
-- help.
--
-- exam_type is 'GENERAL' throughout: the curated source for these
-- eight topics does not explicitly tag any individual question as a
-- WAEC/NECO/NABTEB past paper item (unlike some later terms/levels),
-- so per the seeding instructions the safe default applies file-wide.
--
-- Every stated answer below was re-derived by hand against the
-- curated source before being written into this file. Two genuine
-- errors were found and fixed (both noted inline where they occur):
--   1. GP topic (104), exercise Q23: the curated source states
--      S3 = 1281/4 for a GP with a = 243/4, r = 2/3, third term 27.
--      Direct computation of a + ar + ar^2 = 60.75 + 40.5 + 27 =
--      128.25 = 513/4, not 1281/4. Corrected here to 513/4.
--   2. GP topic (104), exercise Q9: the curated source's question
--      stem ("common ratio of the GP 10 + 5*sqrt... type series") is
--      garbled/OCR-corrupted and its answer is marked "not confirmed
--      in source." Replaced here with a clean, well-posed question
--      testing the identical skill (common ratio of a surd GP), using
--      the same four answer options the corrupted source question
--      already listed (sqrt(3), sqrt(5), 2, 5), with sqrt(3) verified
--      correct for the replacement GP.
-- Three questions in the Logarithms bank (Q16-Q18) were marked
-- "answer: not given in source" (they only ask to "compare calculator
-- and log-table results" without stating either result) -- the
-- calculator values were computed directly and used as the verified
-- correct answers.
--
-- Every worked_examples/questions row has status = 'published'.
-- ==========================================


-- ------------------------------------------
-- 101. LOGARITHMS: NUMBERS LESS THAN ONE & RECIPROCALS  -  SS2 Mathematics, Term 1
-- ------------------------------------------


with lesson as (
  insert into public.lessons (topic_id, title, summary, content_body, order_index)
  values (
    (select t.id from public.topics t join public.curricula c on c.id = t.curriculum_id where c.subject = 'Mathematics' and t.class_level = 'SS2' and t.term = 1 and t.order_index = 101),
    'Logarithms: Characteristic, Mantissa, and the Log Laws',
    'Using the laws of logarithms and characteristic/mantissa tables to multiply, divide, and find powers and roots without a calculator.',
    '## Logarithms: Numbers Less Than One and Reciprocals

A logarithm is the power to which a base must be raised to produce a given number: if $b^x = y$, then $\log_b(y) = x$. Common logarithms use base 10, so $\log(x)$ means $\log_{10}(x)$. Logarithms turn multiplication into addition, division into subtraction, and powers/roots into multiplication/division, which is exactly why they were used before calculators to make heavy arithmetic manageable.

**Glossary**
- **Logarithm:** the power needed on a base to get a number. Example: since $10^2 = 100$, $\log 100 = 2$.
- **Characteristic:** the whole-number part of a logarithm, found from where the decimal point sits. For $237$, written in standard form as $2.37 \times 10^2$, the characteristic is $2$.
- **Mantissa:** the decimal part of a logarithm, read from a log table. It only depends on the digit sequence, not on the size of the number: $\log 237$, $\log 23.7$, and $\log 2.37$ all share the mantissa $0.3747$.
- **Antilogarithm (antilog):** the reverse of a logarithm, it converts a logarithm value back into an ordinary number.

**Laws of Logarithms**
- Product rule: $\log(M \times N) = \log M + \log N$
- Quotient rule: $\log(M \div N) = \log M - \log N$
- Power rule: $\log(M^n) = n \log M$
- Root rule: $\log(\sqrt[n]{M}) = \frac{1}{n}\log M$
- $\log 1 = 0$, $\log 10 = 1$, $\log(10^n) = n$

**Characteristic and Mantissa**

A logarithm has two parts: characteristic (integer part) and mantissa (decimal part, always positive, read from tables). For a number $\ge 1$, characteristic $=$ (number of digits before the decimal point) $- 1$. For a number less than $1$, the characteristic is negative, written in bar notation such as $\bar{2}$, meaning "negative 2, positive mantissa": it equals $-($number of zeros immediately after the decimal point $+ 1)$.',
    1
  )
  returning id
)
insert into public.worked_examples (lesson_id, title, problem_statement, solution_steps, exam_shortcut, common_trap_warning, real_life_context, status)
select id,
  'Finding the Logarithm of a Number Greater Than One',
  'Use logarithm tables to find $\log 237$.',
  to_jsonb(array[
    'Write 237 in standard form to find the characteristic: $237 = 2.37 \times 10^2$.',
    'The power of 10 is 2, so the characteristic is $2$.',
    'Look up the mantissa for the digit sequence 237 in a log table (row 23, column 7): mantissa $= 0.3747$.',
    'Combine the characteristic and mantissa: $2 + 0.3747 = 2.3747$.',
    'Answer: $\log 237 = 2.3747$.'
  ]),
  'Sanity-check the characteristic before touching tables: count digits before the decimal point and subtract 1, for example a 5-digit whole number always has characteristic 4. Getting this wrong is the number-one source of lost marks, so do it first, separately from the mantissa lookup.',
  null::text,
  null::text,
  'published'
from lesson;

insert into public.worked_examples (lesson_id, title, problem_statement, solution_steps, exam_shortcut, common_trap_warning, real_life_context, status)
select l.id,
  'Multiplying Using Logarithms (Product Rule)',
  'Use logarithms to calculate $52.3 \times 8.94$.',
  to_jsonb(array[
    'Let $N = 52.3 \times 8.94$ and take logs of both sides. By the product rule: $\log N = \log 52.3 + \log 8.94$.',
    'Find $\log 52.3$: in standard form $52.3 = 5.23 \times 10^1$, so the characteristic is 1; the mantissa (row 52, column 3) is $0.7185$, giving $\log 52.3 = 1.7185$.',
    'Find $\log 8.94$: in standard form $8.94 = 8.94 \times 10^0$, so the characteristic is 0; the mantissa (row 89, column 4) is $0.9513$, giving $\log 8.94 = 0.9513$.',
    'Add the two logarithms: $1.7185 + 0.9513 = 2.6698$.',
    'Take the antilog of $2.6698$: the mantissa $0.6698$ corresponds to digits $4.675$, and the characteristic $2$ means the decimal point sits after 3 digits, giving $467.5$.',
    'Answer: $52.3 \times 8.94 = 467.5$.'
  ]),
  'Product, quotient, power, and root all reduce to addition or subtraction of logs: write log N = ... first, do all the adding and subtracting of logs, and only then take one single antilog at the end. Never take an antilog partway through a multi-step calculation.',
  'Estimate first with rough mental multiplication (52 times 9 is about 468) so a wrongly placed decimal point in the final antilog answer is caught immediately.',
  'This is exactly how a market trader or bookkeeper worked out bulk-price totals and exchange conversions by hand before calculators became common and affordable in Nigerian schools and shops, logarithm tables did the heavy multiplication safely and quickly.',
  'published'
from public.lessons l
where l.topic_id = (select t.id from public.topics t join public.curricula c on c.id = t.curriculum_id where c.subject = 'Mathematics' and t.class_level = 'SS2' and t.term = 1 and t.order_index = 101)
order by l.created_at desc limit 1;

insert into public.worked_examples (lesson_id, title, problem_statement, solution_steps, exam_shortcut, common_trap_warning, real_life_context, status)
select l.id,
  'Roots Using Logarithms (Root Rule)',
  'Use logarithms to calculate $\sqrt[4]{2560}$.',
  to_jsonb(array[
    'Let $N = \sqrt[4]{2560}$ and take logs. By the root rule: $\log N = \frac{1}{4}\log 2560$.',
    'Find $\log 2560$: in standard form $2560 = 2.56 \times 10^3$, characteristic 3, mantissa $0.4082$, giving $\log 2560 = 3.4082$.',
    'Divide by 4: $3.4082 \div 4 = 0.8521$ (rounded to 4 decimal places).',
    'Take the antilog of $0.8521$: digits $7.113$, characteristic $0$ means no shift of the decimal point.',
    'Answer: $\sqrt[4]{2560} \approx 7.11$.'
  ]),
  'Same digits, same mantissa: once the mantissa for one digit sequence is found, the mantissa for any number with the same digits (just a moved decimal point) is already known, only the characteristic changes. Use this to skip repeat table lookups.',
  null::text,
  null::text,
  'published'
from public.lessons l
where l.topic_id = (select t.id from public.topics t join public.curricula c on c.id = t.curriculum_id where c.subject = 'Mathematics' and t.class_level = 'SS2' and t.term = 1 and t.order_index = 101)
order by l.created_at desc limit 1;

insert into public.worked_examples (lesson_id, title, problem_statement, solution_steps, exam_shortcut, common_trap_warning, real_life_context, status)
select l.id,
  'Compound Interest Using Logarithms',
  'A cooperative society deposits ₦10,000 at 8% per annum compound interest. Use logarithms to find the amount after 5 years, using $A = P(1+r)^n$.',
  to_jsonb(array[
    'Write down the compound interest formula with the given values: $A = P(1+r)^n = 10000(1.08)^5$.',
    'Take logs of both sides. By the power and product rules: $\log A = \log 10000 + 5\log 1.08$.',
    'Find $\log 10000$: since $10000 = 10^4$, $\log 10000 = 4$.',
    'Find $\log 1.08$ from tables: $\log 1.08 = 0.0334$.',
    'Multiply by 5: $5 \times 0.0334 = 0.1670$.',
    'Add: $\log A = 4 + 0.1670 = 4.1670$.',
    'Take the antilog: mantissa $0.1670$ corresponds to digits $1.469$, characteristic $4$ shifts the decimal point to give about $14690$ (a calculator gives the more precise $14693.28$; log tables round to about 4 significant figures).',
    'Answer: $A \approx ₦14,693$ after 5 years.'
  ]),
  'For negative characteristics always keep the mantissa positive, never simplify a bar-notation logarithm like 2-bar.7505 into -2.7505 during table work, only convert to a single negative decimal at the very end if the question needs it in that form.',
  'A rounded log-table answer (about ₦14,690) will differ slightly from an exact calculator answer (₦14,693.28), this small gap is expected with log tables and is not a mistake.',
  'This is the same calculation a savings cooperative (esusu/ajo) or a bank uses to project how a member''s deposit grows year on year at a fixed interest rate.',
  'published'
from public.lessons l
where l.topic_id = (select t.id from public.topics t join public.curricula c on c.id = t.curriculum_id where c.subject = 'Mathematics' and t.class_level = 'SS2' and t.term = 1 and t.order_index = 101)
order by l.created_at desc limit 1;

insert into public.questions (topic_id, lesson_id, question_text, question_latex, option_a, option_b, option_c, option_d, option_e, correct_letter, difficulty, exam_type, explanation, exam_shortcut, status)
select t.id, l.id, v.question_text, v.question_latex, v.option_a, v.option_b, v.option_c, v.option_d, v.option_e, v.correct_letter::char(1), v.difficulty::integer, v.exam_type::exam_type, v.explanation, v.exam_shortcut, 'published'
from public.topics t
join public.curricula c on c.id = t.curriculum_id
join public.lessons l on l.topic_id = t.id
cross join (values
  ('Use logarithm tables to find $\log 237$.', null::text, '2.3747', '1.3747', '2.3740', '3.3747', null::text, 'A', 2, 'GENERAL', '$237 = 2.37 \times 10^2$ gives characteristic 2; the mantissa for digits 237 is 0.3747; combined, $\log 237 = 2.3747$.', 'Find the characteristic from standard form before touching the mantissa table.'),
  ('Find $\log 0.0563$, giving your answer as a single decimal.', null::text, '-2.7505', '-1.2495', '-0.7505', '1.2495', null::text, 'B', 3, 'GENERAL', '0.0563 has one zero after the decimal point before the first non-zero digit, so the characteristic is $-2$ (bar notation $\bar{2}$); the mantissa for digits 563 is 0.7505. Combined as a single decimal: $-2 + 0.7505 = -1.2495$.', 'Never combine a negative characteristic with a positive mantissa by simple subtraction of the wrong parts, convert to one signed decimal only at the very end.'),
  ('Use logarithms to calculate $52.3 \times 8.94$.', null::text, '46.75', '4675', '467.5', '567.5', null::text, 'C', 2, 'GENERAL', '$\log 52.3 = 1.7185$, $\log 8.94 = 0.9513$; sum $= 2.6698$; antilog gives $467.5$.', null::text),
  ('Evaluate $456 \times 34.7$ using logarithms.', null::text, '1582.32', '158232', '14823.2', '15823.2', null::text, 'D', 3, 'GENERAL', '$\log 456 = 2.6590$, $\log 34.7 = 1.5403$; sum $= 4.1993$; antilog gives approximately $15823.2$.', null::text),
  ('Find the value of $(2.45)^5$ using logarithm tables.', null::text, '88.27', '8.827', '882.7', '8827', null::text, 'A', 3, 'GENERAL', '$\log 2.45 = 0.3892$; multiply by 5: $1.9460$; antilog gives approximately $88.27$.', 'For a power, multiply the log by the index before taking one single antilog at the end.'),
  ('Find $\log 0.00845$ using logarithm tables, and state the value as a decimal.', null::text, '-3.9269', '-2.0731', '-1.9269', '2.0731', null::text, 'B', 3, 'GENERAL', '0.00845 has two zeros after the decimal point before the first non-zero digit, so the characteristic is $-3$; the mantissa for digits 845 is 0.9269. Combined: $-3 + 0.9269 = -2.0731$.', null::text),
  ('If $\log x = 2.3456$, find $x$ using antilogarithm tables, in standard form.', null::text, '234.56', '22.16', '221.6', '2.216', null::text, 'C', 3, 'GENERAL', 'Mantissa $0.3456$ gives digits $2.216$; characteristic $2$ shifts the decimal point to give $221.6 \approx 2.216 \times 10^2$.', null::text),
  ('Use logarithms to evaluate $(78.5 \times 23.4) \div 45.6$, showing complete working.', null::text, '4.028', '402.8', '4.28', '40.28', null::text, 'D', 3, 'GENERAL', '$\log 78.5 + \log 23.4 - \log 45.6 = 1.8949 + 1.3692 - 1.6590 = 1.6051$; antilog gives approximately $40.28$.', null::text),
  ('Calculate $\sqrt[4]{2560}$ using logarithms.', null::text, '7.11', '71.1', '17.1', '0.711', null::text, 'A', 3, 'GENERAL', '$\log 2560 = 3.4082$; divide by 4: $0.8521$; antilog gives approximately $7.11$.', null::text),
  ('Simplify $(0.456)^3 \times \sqrt{89.2}$ using logarithm tables.', null::text, '8.955', '0.8955', '0.08955', '89.55', null::text, 'B', 4, 'GENERAL', '$3\log 0.456 + \frac{1}{2}\log 89.2 = 3(\bar{1}.6590) + \frac{1}{2}(1.9504) = -0.9995 + 0.9752 = -0.0243$; antilog of $-0.0243$ gives approximately $0.8955$.', null::text),
  ('Use logarithm tables to find $\log 345$.', null::text, '1.5378', '3.5378', '2.5378', '2.4378', null::text, 'C', 2, 'GENERAL', '$345 = 3.45 \times 10^2$, characteristic 2; mantissa for digits 345 is 0.5378; combined, $\log 345 = 2.5378$.', null::text),
  ('Use logarithm tables to find $\log 0.0678$.', null::text, '-2.8312', '-0.8312', '-1.8312', '-1.1688', null::text, 'D', 3, 'GENERAL', '0.0678 has one zero after the decimal point, characteristic $-2$; mantissa for digits 678 is 0.8312; combined as a decimal: $-2+0.8312=-1.1688$.', null::text),
  ('Use logarithm tables to find $\log 7890$.', null::text, '3.8971', '2.8971', '3.7891', '4.8971', null::text, 'A', 2, 'GENERAL', '$7890 = 7.89 \times 10^3$, characteristic 3; mantissa for digits 789 is 0.8971; combined, $\log 7890 = 3.8971$.', null::text),
  ('Find the antilog of $1.5263$.', null::text, '3.36', '33.6', '336', '0.336', null::text, 'B', 2, 'GENERAL', 'Mantissa $0.5263$ gives digits $3.36$; characteristic $1$ shifts the decimal point to give $33.6$.', null::text),
  ('Find the antilog of $\bar{3}.7520$ (that is, a logarithm with characteristic $-3$ and mantissa $0.7520$).', null::text, '0.0565', '0.565', '0.00565', '0.0000565', null::text, 'C', 3, 'GENERAL', 'Mantissa $0.7520$ gives digits $5.65$; characteristic $-3$ means placing the digits with two zeros before them after the decimal point, giving $0.00565$.', null::text),
  ('Using logarithms (or a calculator to check), evaluate $45.6 \times 23.8$.', null::text, '108.528', '10852.8', '1052.8', '1085.28', null::text, 'D', 2, 'GENERAL', 'Direct multiplication: $45.6 \times 23.8 = 1085.28$. Using logs: $\log 45.6 + \log 23.8 = 1.6590+1.3766=3.0356$, antilog $\approx 1085.3$, matching.', null::text),
  ('Using logarithms (or a calculator to check), evaluate $234 \div 5.67$.', null::text, '41.27', '4.127', '412.7', '40.27', null::text, 'A', 2, 'GENERAL', 'Direct division: $234 \div 5.67 \approx 41.27$. Using logs: $\log 234 - \log 5.67 = 2.3692-0.7536=1.6156$, antilog $\approx 41.27$, matching.', null::text),
  ('Using logarithms (or a calculator to check), evaluate $(3.4)^3$.', null::text, '11.56', '39.304', '3.4', '10.2', null::text, 'B', 2, 'GENERAL', 'Direct: $3.4 \times 3.4 \times 3.4 = 39.304$. Using logs: $3 \log 3.4 = 3(0.5315)=1.5945$, antilog $\approx 39.3$, matching.', null::text),
  ('Calculate the compound interest amount using $A = P(1+r)^n$ where $P = ₦10{,}000$, $r = 0.08$, $n = 5$.', null::text, '₦10,800', '₦13,000', '₦14,693.28', '₦15,000', null::text, 'C', 3, 'GENERAL', '$A = 10000(1.08)^5 = 10000 \times 1.469328 = ₦14{,}693.28$ (log tables give an approximate ₦14,690, close to this exact calculator value).', null::text)
) as v(question_text, question_latex, option_a, option_b, option_c, option_d, option_e, correct_letter, difficulty, exam_type, explanation, exam_shortcut)
where c.subject = 'Mathematics' and t.class_level = 'SS2' and t.term = 1 and t.order_index = 101;

-- ------------------------------------------
-- 102. APPROXIMATIONS, STANDARD FORM & PERCENTAGE ERROR  -  SS2 Mathematics, Term 1
-- ------------------------------------------


with lesson as (
  insert into public.lessons (topic_id, title, summary, content_body, order_index)
  values (
    (select t.id from public.topics t join public.curricula c on c.id = t.curriculum_id where c.subject = 'Mathematics' and t.class_level = 'SS2' and t.term = 1 and t.order_index = 102),
    'Standard Form, Significant Figures, and Percentage Error',
    'Writing numbers in standard form, rounding to significant figures, and measuring how far an approximation is from an exact value using percentage error.',
    '## Approximations, Standard Form and Percentage Error

A number in **standard form** (also called scientific notation) is written as $A \times 10^n$, where $1 \le A < 10$ and $n$ is an integer. To convert a large number, count how many places the decimal point moves left (giving a positive power); for a small number (less than 1), count how many places it moves right (giving a negative power).

**Glossary**
- **Standard form:** writing a number as a single non-zero digit before the decimal point, times a power of 10. Example: $3400 = 3.4 \times 10^3$.
- **Significant figures:** the digits in a number that carry real precision. Non-zero digits are always significant; zeros between non-zero digits are significant; leading zeros before the first non-zero digit are never significant; trailing zeros after a decimal point are significant.
- **Percentage error:** how far an approximate (measured or rounded) value is from the exact (true) value, expressed as a percentage. It is always reported as a positive number, since the direction of the error (too high or too low) does not matter for this measure.

**Percentage error formula**

$$\%\ \text{Error} = \frac{|\text{Approximate} - \text{Exact}|}{\text{Exact}} \times 100\%$$

The absolute value bars mean the sign does not matter, only the size of the gap between the approximate and exact values counts.',
    1
  )
  returning id
)
insert into public.worked_examples (lesson_id, title, problem_statement, solution_steps, exam_shortcut, common_trap_warning, real_life_context, status)
select id,
  'Writing a Small Number in Standard Form',
  'Express $0.000456$ in standard form.',
  to_jsonb(array[
    'Identify the first non-zero digit: it is 4, so the leading part of the answer will start with 4.56 (keeping the digit sequence).',
    'Count how many places the decimal point must move to sit right after that first digit: $0.000456 \to 4.56$ requires moving the point 4 places to the right.',
    'Since the original number is smaller than 1, the power of 10 is negative: moving right by 4 places means the exponent is $-4$.',
    'Answer: $0.000456 = 4.56 \times 10^{-4}$.'
  ]),
  'Standard form direction rule: number 10 or more moves the decimal left (positive power); number less than 1 moves the decimal right (negative power). Say this rule out loud every time to avoid the classic sign-flip error.',
  null::text,
  null::text,
  'published'
from lesson;

insert into public.worked_examples (lesson_id, title, problem_statement, solution_steps, exam_shortcut, common_trap_warning, real_life_context, status)
select l.id,
  'Rounding to a Given Number of Significant Figures',
  'Round $3.14159$ to 4 significant figures.',
  to_jsonb(array[
    'Count off the first 4 significant digits: 3, 1, 4, 1, giving "3.141".',
    'Look at the next digit (the 5th significant figure) to decide rounding: it is 5, so round the 4th digit up.',
    'Apply the round-up: $3.141 \to 3.142$ (the last 1 becomes 2).',
    'Answer: $3.142$.'
  ]),
  'Count significant digits, not decimal places, when a question asks for significant figures, that mix-up is the most common mistake on this topic.',
  null::text,
  null::text,
  'published'
from public.lessons l
where l.topic_id = (select t.id from public.topics t join public.curricula c on c.id = t.curriculum_id where c.subject = 'Mathematics' and t.class_level = 'SS2' and t.term = 1 and t.order_index = 102)
order by l.created_at desc limit 1;

insert into public.worked_examples (lesson_id, title, problem_statement, solution_steps, exam_shortcut, common_trap_warning, real_life_context, status)
select l.id,
  'Percentage Error in an Approximated Constant',
  'A measurement of $\pi$ is taken as $3.14$ while the actual value is $3.14159$. Find the percentage error.',
  to_jsonb(array[
    'Write down the formula: $\%\ \text{Error} = \dfrac{|\text{Approximate} - \text{Exact}|}{\text{Exact}} \times 100\%$.',
    'Substitute the values: $= \dfrac{|3.14 - 3.14159|}{3.14159} \times 100\%$.',
    'Compute the numerator: $|3.14 - 3.14159| = |-0.00159| = 0.00159$.',
    'Divide by the exact value: $0.00159 \div 3.14159 = 0.0005061$.',
    'Convert to a percentage: $0.0005061 \times 100\% = 0.05061\%$.',
    'Answer: $\approx 0.051\%$.'
  ]),
  'Use the exact value as the denominator, never the approximate one, this is the single most common mistake students make in percentage error questions.',
  'If a percentage error answer comes out larger than about 10%, re-check the subtraction, it is very rare for a genuine rounding or measurement question to have such a large error.',
  'This is the same check an engineering student or technician runs when comparing a rounded constant used in a quick calculation against its true value, to judge whether the rounding is safe to use.',
  'published'
from public.lessons l
where l.topic_id = (select t.id from public.topics t join public.curricula c on c.id = t.curriculum_id where c.subject = 'Mathematics' and t.class_level = 'SS2' and t.term = 1 and t.order_index = 102)
order by l.created_at desc limit 1;

insert into public.worked_examples (lesson_id, title, problem_statement, solution_steps, exam_shortcut, common_trap_warning, real_life_context, status)
select l.id,
  'Percentage Error on a Market Weighing Scale',
  'A trader''s weighing scale reads a bag of rice as $48.5$ kg, but the actual mass on a calibrated scale is $50$ kg. Find the percentage error.',
  to_jsonb(array[
    'Find the error: $|\text{Approximate} - \text{Exact}| = |48.5 - 50| = 1.5$ kg.',
    'Divide by the exact value: $1.5 \div 50 = 0.03$.',
    'Convert to a percentage: $0.03 \times 100\% = 3\%$.',
    'Answer: the percentage error is $3\%$.'
  ]),
  'Trailing-zero trap: a number like 3,400,000 written as $3.4 \times 10^6$ drops trailing zeros that may or may not be meant as significant, always check whether trailing zeros are meant to be significant before dropping them.',
  null::text,
  'A market trader or a rice depot checks a weighing scale exactly this way against a certified scale, to know whether customers are being overcharged or undercharged by a faulty machine.',
  'published'
from public.lessons l
where l.topic_id = (select t.id from public.topics t join public.curricula c on c.id = t.curriculum_id where c.subject = 'Mathematics' and t.class_level = 'SS2' and t.term = 1 and t.order_index = 102)
order by l.created_at desc limit 1;

insert into public.questions (topic_id, lesson_id, question_text, question_latex, option_a, option_b, option_c, option_d, option_e, correct_letter, difficulty, exam_type, explanation, exam_shortcut, status)
select t.id, l.id, v.question_text, v.question_latex, v.option_a, v.option_b, v.option_c, v.option_d, v.option_e, v.correct_letter::char(1), v.difficulty::integer, v.exam_type::exam_type, v.explanation, v.exam_shortcut, 'published'
from public.topics t
join public.curricula c on c.id = t.curriculum_id
join public.lessons l on l.topic_id = t.id
cross join (values
  ('Express $0.00072$ in standard form.', null::text, '$7.2 \times 10^{-4}$', '$7.2 \times 10^{4}$', '$0.72 \times 10^{-3}$', '$72 \times 10^{-5}$', null::text, 'A', 1, 'GENERAL', 'The first non-zero digit is 7; the decimal point moves 4 places right, giving a negative exponent: $7.2 \times 10^{-4}$.', null::text),
  ('Round $0.0078234$ to 3 significant figures.', null::text, '0.0078', '0.00782', '0.008', '0.0079', null::text, 'B', 2, 'GENERAL', 'The first 3 significant digits are 7, 8, 2; the next digit is 3, which rounds down, leaving 0.00782.', null::text),
  ('A measurement is $48.5$ kg; the actual mass is $50$ kg. Find the percentage error.', null::text, '1.5%', '2.9%', '3%', '3.1%', null::text, 'C', 2, 'GENERAL', 'Error $= |48.5-50| = 1.5$; $\%\text{Error} = 1.5/50 \times 100\% = 3\%$.', null::text),
  ('Express in standard form: (a) $0.00072$ (b) $345{,}000$.', null::text, '(a) $7.2\times10^{-4}$ (b) $34.5\times10^{4}$', '(a) $72\times10^{-5}$ (b) $3.45\times10^{5}$', '(a) $7.2\times10^{-3}$ (b) $3.45\times10^{5}$', '(a) $7.2\times10^{-4}$ (b) $3.45\times10^{5}$', null::text, 'D', 2, 'GENERAL', '$0.00072 = 7.2\times10^{-4}$ (decimal moves 4 right); $345{,}000 = 3.45\times10^{5}$ (decimal moves 5 left).', null::text),
  ('Round $0.0078234$ to 3 significant figures.', null::text, '0.00782', '0.0078', '0.008', '0.0079', null::text, 'A', 2, 'GENERAL', 'The first 3 significant digits are 7, 8, 2; the next digit is 3, which rounds down, leaving 0.00782 (this repeats the earlier exercise-bank item as it appears twice in the source).', null::text),
  ('Calculate $(4.5 \times 10^3) \times (1.5 \times 10^{-2})$ in standard form.', null::text, '$6.75 \times 10^{0}$', '$6.75 \times 10^{1}$', '$6.75 \times 10^{2}$', '$67.5 \times 10^{1}$', null::text, 'B', 2, 'GENERAL', 'Multiply the leading digits: $4.5 \times 1.5 = 6.75$; add the exponents: $3+(-2)=1$, giving $6.75 \times 10^1$.', 'Add exponents directly when multiplying two standard-form numbers, no need to fully expand either number first.'),
  ('Find the percentage error when $\pi \approx 3.14$ (actual value $3.14159$).', null::text, '0.51%', '0.0051%', '0.051%', '5.1%', null::text, 'C', 3, 'GENERAL', 'Error $=|3.14-3.14159|=0.00159$; $\%\text{Error} = 0.00159/3.14159 \times 100\% \approx 0.051\%$.', null::text)
) as v(question_text, question_latex, option_a, option_b, option_c, option_d, option_e, correct_letter, difficulty, exam_type, explanation, exam_shortcut)
where c.subject = 'Mathematics' and t.class_level = 'SS2' and t.term = 1 and t.order_index = 102;

-- ------------------------------------------
-- 103. SEQUENCES & SERIES: ARITHMETIC PROGRESSION  -  SS2 Mathematics, Term 1
-- ------------------------------------------


with lesson as (
  insert into public.lessons (topic_id, title, summary, content_body, order_index)
  values (
    (select t.id from public.topics t join public.curricula c on c.id = t.curriculum_id where c.subject = 'Mathematics' and t.class_level = 'SS2' and t.term = 1 and t.order_index = 103),
    'Arithmetic Progressions: nth Term and Sum of n Terms',
    'Finding the common difference, nth term, and sum of n terms of an arithmetic progression, and applying these to word problems.',
    '## Sequences and Series: Arithmetic Progression

**Glossary**
- **Sequence:** an ordered list of numbers following a rule, e.g. $2, 5, 8, 11, \ldots$
- **Series:** the sum of the terms of a sequence, e.g. $2+5+8+11+\ldots$
- **Arithmetic progression (AP):** a sequence where the difference between consecutive terms is always the same constant, called the common difference.
- **Common difference ($d$):** the constant amount added to get from one term to the next, found by $T_2 - T_1$ (or any $T_{n+1}-T_n$).

**Formulas**
- nth term: $T_n = a + (n-1)d$
- Sum of first $n$ terms: $S_n = \dfrac{n}{2}[2a + (n-1)d]$, or equivalently $S_n = \dfrac{n}{2}(a+l)$ where $l$ is the last (nth) term.',
    1
  )
  returning id
)
insert into public.worked_examples (lesson_id, title, problem_statement, solution_steps, exam_shortcut, common_trap_warning, real_life_context, status)
select id,
  'Finding a Given Term of an AP',
  'Find the 20th term of the AP $7, 11, 15, 19, \ldots$',
  to_jsonb(array[
    'Identify $a$ and $d$: first term $a = 7$; common difference $d = 11 - 7 = 4$.',
    'Write the nth-term formula with $n = 20$: $T_{20} = a + (20-1)d = 7 + 19d$.',
    'Substitute $d = 4$: $T_{20} = 7 + 19 \times 4 = 7 + 76$.',
    'Add: $7 + 76 = 83$.',
    'Answer: $T_{20} = 83$.'
  ]),
  'Find d instantly by subtracting any term from the very next one, you never need two far-apart terms if consecutive terms are given.',
  null::text,
  null::text,
  'published'
from lesson;

insert into public.worked_examples (lesson_id, title, problem_statement, solution_steps, exam_shortcut, common_trap_warning, real_life_context, status)
select l.id,
  'Finding the First Term and Common Difference from Two Given Terms',
  'The 5th term of an AP is 23 and the 12th term is 58. Find $a$ and $d$.',
  to_jsonb(array[
    'Write the nth-term formula for each given term: $T_5 = a + 4d = 23$; $T_{12} = a + 11d = 58$.',
    'Subtract the first equation from the second to eliminate $a$: $(a+11d)-(a+4d) = 58-23 \Rightarrow 7d = 35$.',
    'Solve for $d$: $d = 35 \div 7 = 5$.',
    'Substitute $d=5$ back into $T_5 = a+4d = 23$: $a + 20 = 23 \Rightarrow a = 3$.',
    'Answer: $a = 3$, $d = 5$.'
  ]),
  'Simultaneous AP equations trick: whenever given two terms, always subtract the equations to cancel a first, never solve for a before finding d.',
  null::text,
  null::text,
  'published'
from public.lessons l
where l.topic_id = (select t.id from public.topics t join public.curricula c on c.id = t.curriculum_id where c.subject = 'Mathematics' and t.class_level = 'SS2' and t.term = 1 and t.order_index = 103)
order by l.created_at desc limit 1;

insert into public.worked_examples (lesson_id, title, problem_statement, solution_steps, exam_shortcut, common_trap_warning, real_life_context, status)
select l.id,
  'Sum of the First n Terms of an AP',
  'Find the sum of the first 15 terms of the AP $3, 7, 11, 15, \ldots$',
  to_jsonb(array[
    'Identify $a, d, n$: $a = 3$, $d = 7-3 = 4$, $n = 15$.',
    'Write the sum formula: $S_n = \dfrac{n}{2}[2a+(n-1)d]$.',
    'Substitute: $S_{15} = \dfrac{15}{2}[2(3)+14(4)] = \dfrac{15}{2}[6+56]$.',
    'Simplify inside the brackets: $6+56=62$.',
    'Multiply: $\dfrac{15}{2} \times 62 = 15 \times 31 = 465$.',
    'Answer: $S_{15} = 465$.'
  ]),
  'Use $S_n = \dfrac{n}{2}(a+l)$ whenever the last term is known, it is faster than expanding $2a+(n-1)d$.',
  null::text,
  null::text,
  'published'
from public.lessons l
where l.topic_id = (select t.id from public.topics t join public.curricula c on c.id = t.curriculum_id where c.subject = 'Mathematics' and t.class_level = 'SS2' and t.term = 1 and t.order_index = 103)
order by l.created_at desc limit 1;

insert into public.worked_examples (lesson_id, title, problem_statement, solution_steps, exam_shortcut, common_trap_warning, real_life_context, status)
select l.id,
  'A Theatre Modelled as an AP',
  'A theatre has 20 seats in row 1, 24 seats in row 2, 28 seats in row 3, and so on for 15 rows. Find the total number of seats.',
  to_jsonb(array[
    'Identify $a$, $d$, $n$: $a = 20$ (row 1), $d = 24-20=4$ (each row has 4 more seats than the last), $n = 15$ rows.',
    'Write the sum formula: $S_n = \dfrac{n}{2}[2a+(n-1)d]$.',
    'Substitute: $S_{15} = \dfrac{15}{2}[2(20)+14(4)] = \dfrac{15}{2}[40+56]$.',
    'Simplify inside the brackets: $40+56=96$.',
    'Multiply: $\dfrac{15}{2}\times 96 = 15 \times 48 = 720$.',
    'Answer: the theatre has $720$ seats in total.'
  ]),
  'Quick check for word problems modelled as AP: if a quantity increases by the same fixed amount every step, it is an AP, reach for Tn and Sn immediately rather than listing all terms by hand.',
  null::text,
  'This is exactly how an events company or a school assembly hall planner works out total seating capacity from a stated row-by-row seat increase, without physically counting every seat.',
  'published'
from public.lessons l
where l.topic_id = (select t.id from public.topics t join public.curricula c on c.id = t.curriculum_id where c.subject = 'Mathematics' and t.class_level = 'SS2' and t.term = 1 and t.order_index = 103)
order by l.created_at desc limit 1;

insert into public.worked_examples (lesson_id, title, problem_statement, solution_steps, exam_shortcut, common_trap_warning, real_life_context, status)
select l.id,
  'A Trader''s Monthly Savings Modelled as an AP',
  'A man saves ₦500 in month 1, ₦650 in month 2, ₦800 in month 3, and so on. Find his saving in the 12th month, and his total savings after 12 months.',
  to_jsonb(array[
    'Identify $a$ and $d$: $a = 500$, $d = 650-500=150$.',
    'Find the 12th-month saving using $T_n = a+(n-1)d$: $T_{12} = 500+11\times150 = 500+1650 = 2150$.',
    'Find the total savings using $S_n = \dfrac{n}{2}[2a+(n-1)d]$: $S_{12} = \dfrac{12}{2}[2(500)+11(150)] = 6\times[1000+1650]$.',
    'Simplify inside the brackets: $1000+1650=2650$.',
    'Multiply: $6 \times 2650 = 15{,}900$.',
    'Answer: 12th-month saving $=₦2{,}150$; total after 12 months $=₦15{,}900$.'
  ]),
  'Pattern-spotting for word problems: a fixed naira increase every month is the AP signal, jump straight to Tn and Sn.',
  null::text,
  'A trader, an ajo/esusu contributor, or a student saving pocket money by a fixed extra amount each month uses exactly this pattern to project a future month''s saving and a running total.',
  'published'
from public.lessons l
where l.topic_id = (select t.id from public.topics t join public.curricula c on c.id = t.curriculum_id where c.subject = 'Mathematics' and t.class_level = 'SS2' and t.term = 1 and t.order_index = 103)
order by l.created_at desc limit 1;

insert into public.questions (topic_id, lesson_id, question_text, question_latex, option_a, option_b, option_c, option_d, option_e, correct_letter, difficulty, exam_type, explanation, exam_shortcut, status)
select t.id, l.id, v.question_text, v.question_latex, v.option_a, v.option_b, v.option_c, v.option_d, v.option_e, v.correct_letter::char(1), v.difficulty::integer, v.exam_type::exam_type, v.explanation, v.exam_shortcut, 'published'
from public.topics t
join public.curricula c on c.id = t.curriculum_id
join public.lessons l on l.topic_id = t.id
cross join (values
  ('Identify the pattern and find the next 3 terms of $4, 9, 14, 19, 24, ?, ?, ?$', null::text, '28, 33, 38', '29, 34, 39', '30, 35, 40', '29, 35, 41', null::text, 'B', 1, 'GENERAL', 'Common difference $d=5$; continuing: $24+5=29$, $29+5=34$, $34+5=39$.', null::text),
  ('Identify the pattern and find the next 3 terms of $100, 95, 90, 85, ?, ?, ?$', null::text, '75, 70, 65', '85, 80, 75', '80, 75, 70', '80, 70, 60', null::text, 'C', 1, 'GENERAL', 'Common difference $d=-5$; continuing: $85-5=80$, $80-5=75$, $75-5=70$.', null::text),
  ('Identify the pattern and find the next 3 terms of $2, 6, 10, 14, ?, ?, ?$', null::text, '16, 20, 24', '20, 24, 28', '18, 23, 28', '18, 22, 26', null::text, 'D', 1, 'GENERAL', 'Common difference $d=4$; continuing: $14+4=18$, $18+4=22$, $22+4=26$.', null::text),
  ('Identify the pattern and find the next 3 terms of $50, 47, 44, 41, ?, ?, ?$', null::text, '38, 35, 32', '37, 34, 31', '39, 36, 33', '38, 34, 30', null::text, 'A', 1, 'GENERAL', 'Common difference $d=-3$; continuing: $41-3=38$, $38-3=35$, $35-3=32$.', null::text),
  ('Find the common difference of the AP: $12, 17, 22, 27, \ldots$', null::text, '4', '5', '6', '7', null::text, 'B', 1, 'GENERAL', '$d = 17-12 = 5$.', null::text),
  ('Calculate the 25th term of the AP: $4, 9, 14, 19, \ldots$', null::text, '119', '120', '124', '129', null::text, 'C', 2, 'GENERAL', '$a=4$, $d=5$; $T_{25}=4+24\times5=4+120=124$.', null::text),
  ('The 3rd term of an AP is 18 and the 7th term is 34. Find the first term.', null::text, '6', '8', '12', '10', null::text, 'D', 3, 'GENERAL', '$T_7-T_3=4d=34-18=16 \Rightarrow d=4$; then $a=T_3-2d=18-8=10$.', null::text),
  ('Find the sum of the first 20 terms of the AP: $2, 5, 8, 11, \ldots$', null::text, '610', '600', '590', '620', null::text, 'A', 2, 'GENERAL', '$a=2$, $d=3$; $S_{20}=\frac{20}{2}[4+19(3)]=10[4+57]=10\times61=610$.', null::text),
  ('How many terms of the AP $8, 12, 16, 20, \ldots$ are needed for the sum to first reach or exceed $240$?', null::text, '9', '10', '11', '12', null::text, 'B', 4, 'GENERAL', '$a=8$, $d=4$; $S_9 = \frac{9}{2}[16+8(4)]=\frac{9}{2}(48)=216 < 240$; $S_{10}=\frac{10}{2}[16+9(4)]=5(52)=260 \ge 240$. So 10 terms are needed (no whole number of terms gives exactly 240).', 'When a target sum falls between two consecutive Sn values, the answer is always the larger n, since the sum only increases as more terms are added.'),
  ('Write the first five terms of an AP whose first term is 7 and common difference is $-3$.', null::text, '7, 5, 3, 1, -1', '7, 3, -1, -5, -9', '7, 4, 1, -2, -5', '7, 4, 2, -1, -4', null::text, 'C', 1, 'GENERAL', 'Subtract 3 each time: $7, 4, 1, -2, -5$.', null::text),
  ('Find the 30th term of the AP: $-5, -1, 3, 7, \ldots$', null::text, '107', '108', '110', '111', null::text, 'D', 2, 'GENERAL', '$a=-5$, $d=4$; $T_{30}=-5+29\times4=-5+116=111$.', null::text),
  ('The sum of the first 8 terms of an AP is 156, and the first term is 6. Calculate the common difference.', null::text, '27/7', '3', '4', '13/4', null::text, 'A', 3, 'GENERAL', '$S_8=\frac{8}{2}[2(6)+7d]=4[12+7d]=156 \Rightarrow 12+7d=39 \Rightarrow 7d=27 \Rightarrow d=27/7$.', null::text),
  ('An AP has first term 10 and last term 82. If the sum of all terms is 460, find the number of terms.', null::text, '8', '10', '12', '9', null::text, 'B', 2, 'GENERAL', '$S_n=\frac{n}{2}(a+l) \Rightarrow 460=\frac{n}{2}(10+82)=46n \Rightarrow n=10$.', null::text),
  ('A theatre has 20 seats in row 1, 24 in row 2, 28 in row 3, and so on for 15 rows. Find the total number of seats.', null::text, '700', '710', '720', '730', null::text, 'C', 2, 'GENERAL', '$a=20$, $d=4$, $n=15$; $S_{15}=\frac{15}{2}[40+14(4)]=\frac{15}{2}(96)=720$.', null::text),
  ('Find the 20th term of the AP: $7, 11, 15, 19, \ldots$', null::text, '79', '80', '81', '83', null::text, 'D', 1, 'GENERAL', '$a=7$, $d=4$; $T_{20}=7+19\times4=83$.', null::text),
  ('The 5th term of an AP is 23 and the 12th term is 58. Find the first term and common difference.', null::text, 'a=3, d=5', 'a=5, d=3', 'a=2, d=6', 'a=4, d=4', null::text, 'A', 3, 'GENERAL', '$7d=58-23=35 \Rightarrow d=5$; $a=23-4(5)=3$.', null::text),
  ('Find the sum of the first 15 terms of the AP: $3, 7, 11, 15, \ldots$', null::text, '450', '465', '480', '495', null::text, 'B', 2, 'GENERAL', '$a=3$, $d=4$; $S_{15}=\frac{15}{2}[6+14(4)]=\frac{15}{2}(62)=465$.', null::text),
  ('How many terms of the AP $5, 8, 11, 14, \ldots$ are needed for the sum to first reach or exceed $345$?', null::text, '13', '14', '15', '16', null::text, 'C', 4, 'GENERAL', '$a=5$, $d=3$; $S_{14}=\frac{14}{2}[10+13(3)]=7(49)=343<345$; $S_{15}=\frac{15}{2}[10+14(3)]=\frac{15}{2}(52)=390\ge345$. So 15 terms are needed (no exact whole number of terms sums to precisely 345).', null::text),
  ('A man saves ₦500 in month 1, ₦650 in month 2, ₦800 in month 3, and so on. Find his saving in the 12th month and his total savings after 12 months.', null::text, 'T12=₦2,000, S12=₦15,000', 'T12=₦2,100, S12=₦15,300', 'T12=₦2,150, S12=₦15,450', 'T12=₦2,150, S12=₦15,900', null::text, 'D', 3, 'GENERAL', '$a=500$, $d=150$; $T_{12}=500+11(150)=2150$; $S_{12}=6[1000+1650]=15{,}900$.', null::text),
  ('The sum of the first $n$ terms of the AP $5, 11, 17, 23, 29, 35, \ldots$ is:', null::text, '$n(3n - 0.5)$', '$n(3n + 2)$', '$n(3n + 2.5)$', '$n(3n + 5)$', null::text, 'B', 3, 'GENERAL', '$a=5$, $d=6$; $S_n=\frac{n}{2}[10+6(n-1)]=\frac{n}{2}(6n+4)=n(3n+2)$.', null::text),
  ('The sum of the first $n$ positive integers is:', null::text, '$\frac{1}{2}n(n-1)$', '$n(n+1)$', '$\frac{1}{2}n(n+1)$', '$\frac{1}{2}n(n-1)$ (repeated)', null::text, 'C', 2, 'GENERAL', 'For $1,2,3,\ldots,n$: $a=1$, $d=1$; $S_n=\frac{n}{2}[2+(n-1)]=\frac{n}{2}(n+1)$.', null::text),
  ('If $U_n = n(n^2+1)$, evaluate $U_5 - U_4$.', null::text, '18', '56', '62', '80', null::text, 'C', 2, 'GENERAL', '$U_5=5(26)=130$; $U_4=4(17)=68$; $U_5-U_4=130-68=62$.', null::text),
  ('A sequence is given by $2\frac{1}{2}, 5, 7\frac{1}{2}, \ldots$ If the nth term is 25, find $n$.', null::text, '9', '10', '12', '15', null::text, 'B', 2, 'GENERAL', '$a=2.5$, $d=2.5$; $2.5+(n-1)(2.5)=25 \Rightarrow (n-1)(2.5)=22.5 \Rightarrow n-1=9 \Rightarrow n=10$.', null::text),
  ('What is the 13th term of the series $-4 + 1 + 6 + 11 + \ldots$?', null::text, '51', '56', '61', '66', null::text, 'B', 2, 'GENERAL', '$a=-4$, $d=5$; $T_{13}=-4+12(5)=-4+60=56$.', null::text),
  ('The nth term of a sequence is $T_n = 5 + (n-1)^2$. Evaluate $T_4 - T_6$.', null::text, '30', '16', '-16', '-30', null::text, 'C', 3, 'GENERAL', '$T_4=5+3^2=14$; $T_6=5+5^2=30$; $T_4-T_6=14-30=-16$.', null::text)
) as v(question_text, question_latex, option_a, option_b, option_c, option_d, option_e, correct_letter, difficulty, exam_type, explanation, exam_shortcut)
where c.subject = 'Mathematics' and t.class_level = 'SS2' and t.term = 1 and t.order_index = 103;

-- ------------------------------------------
-- 104. GEOMETRIC PROGRESSION  -  SS2 Mathematics, Term 1
-- ------------------------------------------


with lesson as (
  insert into public.lessons (topic_id, title, summary, content_body, order_index)
  values (
    (select t.id from public.topics t join public.curricula c on c.id = t.curriculum_id where c.subject = 'Mathematics' and t.class_level = 'SS2' and t.term = 1 and t.order_index = 104),
    'Geometric Progressions: nth Term, Sum of n Terms, and Sum to Infinity',
    'Finding the common ratio, nth term, sum of n terms, and (where it exists) the sum to infinity of a geometric progression.',
    '## Geometric Progression

**Glossary**
- **Geometric progression (GP):** a sequence where each term is found by multiplying the previous one by a constant ratio, e.g. $2, 6, 18, 54, \ldots$
- **Common ratio ($r$):** the constant multiplier between consecutive terms, found by $T_2 \div T_1$ (or any $T_{n+1}\div T_n$).
- **Geometric mean:** for two numbers $p$ and $q$, their geometric mean is $\sqrt{pq}$; three numbers $x,y,z$ are consecutive terms of a GP exactly when $y^2 = xz$.
- **Sum to infinity:** the limiting (finite) sum of an infinite GP, which only exists when $-1 < r < 1$.

**Formulas**
- nth term: $T_n = ar^{n-1}$
- Sum of first $n$ terms ($r \ne 1$): $S_n = \dfrac{a(1-r^n)}{1-r}$ (use this form when $r<1$) or $S_n = \dfrac{a(r^n-1)}{r-1}$ (use this form when $r>1$)
- Sum to infinity (only valid when $-1<r<1$): $S_\infty = \dfrac{a}{1-r}$',
    1
  )
  returning id
)
insert into public.worked_examples (lesson_id, title, problem_statement, solution_steps, exam_shortcut, common_trap_warning, real_life_context, status)
select id,
  'Finding a Given Term of a GP',
  'Find the 7th term of the GP $4, 12, 36, \ldots$',
  to_jsonb(array[
    'Identify $a$ and $r$: $a = 4$; $r = 12 \div 4 = 3$.',
    'Write the nth-term formula with $n=7$: $T_7 = ar^6 = 4 \times 3^6$.',
    'Evaluate $3^6$: $3^6 = 3\times3\times3\times3\times3\times3 = 729$.',
    'Multiply: $4 \times 729 = 2916$.',
    'Answer: $T_7 = 2916$.'
  ]),
  'Find r instantly by dividing the 2nd term by the 1st, never derive it from a longer calculation if consecutive terms are given directly.',
  null::text,
  null::text,
  'published'
from lesson;

insert into public.worked_examples (lesson_id, title, problem_statement, solution_steps, exam_shortcut, common_trap_warning, real_life_context, status)
select l.id,
  'Using the Middle-Squared Test for a 3-Term GP',
  'If $y+2, y+6, y+14$ are consecutive terms of a GP, find $y$ and the 42nd term in index form.',
  to_jsonb(array[
    'Use the GP property that (middle term)$^2$ = (first term)(third term): $(y+6)^2 = (y+2)(y+14)$.',
    'Expand both sides: LHS $= y^2+12y+36$; RHS $= y^2+16y+28$.',
    'Set equal and simplify: $y^2+12y+36=y^2+16y+28 \Rightarrow 36-28=16y-12y \Rightarrow 8=4y$.',
    'Solve for $y$: $y = 2$.',
    'Substitute back to find the GP: terms are $(2+2), (2+6), (2+14) = 4, 8, 16$, so $a=4$, $r=8\div4=2$.',
    'Find $T_{42}=ar^{41}$: $T_{42}=4\times2^{41}=2^2\times2^{41}$ (writing 4 as $2^2$ so the powers of 2 combine).',
    'Add the exponents (law of indices, $a^m\times a^n=a^{m+n}$): $2^2\times2^{41}=2^{43}$.',
    'Answer: $y=2$; $T_{42}=2^{43}$.'
  ]),
  '"Middle squared equals outer product" is the fastest route whenever three terms are said to be in GP, cross-multiply immediately instead of writing separate ratio equations.',
  'When the first term and ratio are both powers of the same base, rewrite the whole answer in that base and add exponents rather than multiplying out a huge number by hand.',
  null::text,
  'published'
from public.lessons l
where l.topic_id = (select t.id from public.topics t join public.curricula c on c.id = t.curriculum_id where c.subject = 'Mathematics' and t.class_level = 'SS2' and t.term = 1 and t.order_index = 104)
order by l.created_at desc limit 1;

insert into public.worked_examples (lesson_id, title, problem_statement, solution_steps, exam_shortcut, common_trap_warning, real_life_context, status)
select l.id,
  'A Bouncing Ball Modelled as a GP',
  'A ball is dropped from a height of 20 m. Each time it bounces, it rises to three-fifths ($r=0.6$) of the height it fell from. Find the height it reaches after the 4th bounce, and, assuming this pattern continues forever, the total distance it would rise across all its bounces if it never stopped.',
  to_jsonb(array[
    'Model the bounce heights as a GP: after the first bounce the ball rises to $0.6 \times 20 = 12$ m, so $a=12$ and the common ratio is $r=0.6$ (each bounce rises to 0.6 of the previous rise).',
    'Find the height after the 4th bounce using $T_n=ar^{n-1}$: $T_4=12\times0.6^3$.',
    'Evaluate $0.6^3=0.216$.',
    'Multiply: $12\times0.216=2.592$ m.',
    'Since $-1<0.6<1$, the sum-to-infinity formula applies to the total rise distance: $S_\infty=\dfrac{a}{1-r}=\dfrac{12}{1-0.6}=\dfrac{12}{0.4}=30$ m.',
    'Answer: the ball reaches about $2.59$ m on its 4th bounce, and the total rise distance across all its bounces is $30$ m.'
  ]),
  'Before applying the sum-to-infinity formula, always confirm $-1<r<1$ first, if $|r|\ge1$ the series diverges and no sum to infinity exists, a common trap in objective questions.',
  null::text,
  'This is the standard way a physics or sports-science demonstration models a bouncing ball''s rebound heights, each bounce loses a fixed fraction of energy, giving exactly a geometric progression of heights.',
  'published'
from public.lessons l
where l.topic_id = (select t.id from public.topics t join public.curricula c on c.id = t.curriculum_id where c.subject = 'Mathematics' and t.class_level = 'SS2' and t.term = 1 and t.order_index = 104)
order by l.created_at desc limit 1;

insert into public.worked_examples (lesson_id, title, problem_statement, solution_steps, exam_shortcut, common_trap_warning, real_life_context, status)
select l.id,
  'Population Growth Modelled as a GP',
  'A town''s population is 8,000 and grows at a constant rate of 5% per year. Find the population after 3 years, correct to the nearest whole number.',
  to_jsonb(array[
    'Model the population after $t$ years as $P_t = P_0 \times r^t$ where $P_0=8000$ is the starting population and $r=1.05$ is the year-on-year growth factor (5% growth means multiplying by 1.05 each year).',
    'Substitute $t=3$: $P_3 = 8000 \times 1.05^3$.',
    'Evaluate $1.05^3 = 1.157625$.',
    'Multiply: $8000 \times 1.157625 = 9261$.',
    'Answer: the population after 3 years is about $9{,}261$ people.'
  ]),
  'Combine powers of the same base fast: whenever a GP grows by a fixed percentage, the growth factor r is 1 plus the percentage as a decimal, and each year is one more multiplication by r.',
  null::text,
  'Town planners, school administrators, and businesses use this exact geometric-growth model to project population, enrolment, or customer numbers a few years ahead from a known growth rate.',
  'published'
from public.lessons l
where l.topic_id = (select t.id from public.topics t join public.curricula c on c.id = t.curriculum_id where c.subject = 'Mathematics' and t.class_level = 'SS2' and t.term = 1 and t.order_index = 104)
order by l.created_at desc limit 1;

insert into public.questions (topic_id, lesson_id, question_text, question_latex, option_a, option_b, option_c, option_d, option_e, correct_letter, difficulty, exam_type, explanation, exam_shortcut, status)
select t.id, l.id, v.question_text, v.question_latex, v.option_a, v.option_b, v.option_c, v.option_d, v.option_e, v.correct_letter::char(1), v.difficulty::integer, v.exam_type::exam_type, v.explanation, v.exam_shortcut, 'published'
from public.topics t
join public.curricula c on c.id = t.curriculum_id
join public.lessons l on l.topic_id = t.id
cross join (values
  ('Find the 7th term of the geometric progression $4, 12, 36, \ldots$', null::text, '365', '729', '1458', '2916', '4374', 'D', 2, 'GENERAL', '$a=4$, $r=3$; $T_7=4\times3^6=4\times729=2916$.', null::text),
  ('The first term of a GP is 6 and its common ratio is 3. Find the sixth term (in index form).', null::text, '$6^5$', '$3\times9^5$', '$3\times6^5$', '$6\times3^5$', null::text, 'D', 2, 'GENERAL', '$T_6=ar^5=6\times3^5$.', null::text),
  ('If $y+2, y+6, y+14$ are consecutive terms of a GP, find the value of $y$.', null::text, '1', '2', '3', '4', null::text, 'B', 3, 'GENERAL', '$(y+6)^2=(y+2)(y+14) \Rightarrow y^2+12y+36=y^2+16y+28 \Rightarrow 8=4y \Rightarrow y=2$. (The resulting GP is $4,8,16,\ldots$ with 42nd term $2^{43}$.)', null::text),
  ('The first and third terms of a GP are 1 and 9. Find the second term.', null::text, '4', '3', '2', '1/3', null::text, 'B', 2, 'GENERAL', 'Middle term$^2$ = product of outer terms: $T_2^2=1\times9=9 \Rightarrow T_2=3$.', null::text),
  ('The first, second and last terms of a GP are 3, 6 and 1536. Find the number of terms.', null::text, '8', '9', '10', '12', '14', 'C', 3, 'GENERAL', '$a=3$, $r=2$; $3\times2^{n-1}=1536 \Rightarrow 2^{n-1}=512=2^9 \Rightarrow n=10$.', null::text),
  ('Find the 12th term of the GP $-3, 6, -12, \ldots$', null::text, '-12288', '-6144', '-2048', '2048', '6144', 'E', 3, 'GENERAL', '$a=-3$, $r=-2$; $T_{12}=-3\times(-2)^{11}=-3\times(-2048)=6144$.', null::text),
  ('The 6th term of a GP is 1215. If the common ratio is 3, find its 3rd term.', null::text, '15', '30', '45', '60', null::text, 'C', 2, 'GENERAL', '$T_6=T_3\times r^3 \Rightarrow 1215=T_3\times27 \Rightarrow T_3=45$.', null::text),
  ('Given $6, 3\sqrt{2}, 3\sqrt{6}, 9\sqrt{2}, \ldots$ as the first four terms of a GP, find the 8th term in simplest form.', null::text, '$27\sqrt{2}$', '$27\sqrt{6}$', '$81\sqrt{2}$', '$81\sqrt{6}$', null::text, 'D', 4, 'GENERAL', 'Taking $a=3\sqrt{2}$ and $r=\sqrt{3}$ (the consistent ratio between the later terms): $T_8=3\sqrt{2}\times(\sqrt{3})^7=3\sqrt{2}\times27\sqrt{3}=81\sqrt{6}$.', null::text),
  ('Three consecutive terms of a GP are $\sqrt{3}, 3, 3\sqrt{3}$. Find the common ratio.', null::text, '$\sqrt{3}$', '$\sqrt{5}$', '2', '5', null::text, 'A', 2, 'GENERAL', '$r = 3 \div \sqrt{3} = \sqrt{3}$; check: $3\times\sqrt{3}=3\sqrt{3}$, confirming the ratio. (This question replaces a garbled, unrecoverable item in the source with a well-posed equivalent using the same option set.)', null::text),
  ('The 2nd and 4th terms of a GP are 10 and 40. Taking the common ratio as positive, find the 8th term.', null::text, '320', '480', '640', '800', null::text, 'C', 3, 'GENERAL', '$r^2=T_4/T_2=4 \Rightarrow r=2$; $a=T_2/r=5$; $T_8=ar^7=5\times128=640$.', null::text),
  ('The 4th term of a GP is 384 and the 3rd term is 96. Find the first term.', null::text, '2', '4', '6', '24', '288', 'C', 2, 'GENERAL', '$r=T_4/T_3=4$; $a=T_3/r^2=96/16=6$.', null::text),
  ('The fifth term of a GP is 8 times the 2nd term. Find its common ratio.', null::text, '-4', '-2', '1/2', '2', '4', 'D', 2, 'GENERAL', '$ar^4=8ar \Rightarrow r^3=8 \Rightarrow r=2$.', null::text),
  ('The fourth term of a geometric sequence is 2 and the sixth term is 8. Find the positive common ratio.', null::text, '1', '2', '3', '4', null::text, 'B', 2, 'GENERAL', '$r^2=T_6/T_4=4 \Rightarrow r=\pm2$; taking the positive value, $r=2$.', null::text),
  ('The fourth term of an exponential sequence is 192 and its ninth term is 6. Find the common ratio.', null::text, '1/3', '1/2', '2', '3', null::text, 'B', 3, 'GENERAL', '$r^5=T_9/T_4=6/192=1/32=(1/2)^5 \Rightarrow r=1/2$.', null::text),
  ('The 5th term of a GP is 9 times the 3rd term. What is the positive value of the common ratio?', null::text, '5', '4', '3', '2', null::text, 'C', 2, 'GENERAL', '$r^2=T_5/T_3=9 \Rightarrow r=3$ (positive value).', null::text),
  ('The third term of a GP is 24 and its seventh term is $4\frac{20}{27}$. Find its first term.', null::text, '36', '45', '54', '63', null::text, 'C', 4, 'GENERAL', '$4\frac{20}{27}=\frac{128}{27}$; $r^4=T_7/T_3=\frac{128}{27\times24}=\frac{16}{81}=(2/3)^4 \Rightarrow r=2/3$; $a=T_3/r^2=24/(4/9)=54$.', null::text),
  ('In a geometric series $a=2$ and $r=1/2$, find the sum of the first 5 terms.', null::text, '1/8', '$3\frac{3}{4}$', '$3\frac{7}{8}$', '4', null::text, 'C', 2, 'GENERAL', '$S_5=\frac{2(1-(1/2)^5)}{1-1/2}=\frac{2(31/32)}{1/2}=\frac{31}{16}\times2=\frac{31}{8}=3\frac{7}{8}$.', null::text),
  ('$\frac{10}{3}, \frac{5}{3}, \frac{5}{6}, \ldots$ is a GP. Find the 8th term.', null::text, '5/96', '5/192', '5/384', '5/48', null::text, 'B', 3, 'GENERAL', '$a=10/3$, $r=1/2$; $T_8=ar^7=\frac{10}{3}\times\frac{1}{128}=\frac{10}{384}=\frac{5}{192}$.', null::text),
  ('The sum of the second and third terms of a GP is six times the fourth term. If the second term is 8 and $r$ is positive, find the first term.', null::text, '8', '12', '16', '20', null::text, 'C', 4, 'GENERAL', '$ar+ar^2=6ar^3 \Rightarrow 1+r=6r^2 \Rightarrow 6r^2-r-1=0 \Rightarrow r=1/2$ or $r=-1/3$; taking the positive root $r=1/2$: $a=T_2/r=8/(1/2)=16$.', null::text),
  ('In a GP, the 5th term exceeds the 4th term by 24 and the 4th term exceeds the 3rd by 8. Find the common ratio.', null::text, '2', '3', '4', '5', null::text, 'B', 4, 'GENERAL', '$T_5-T_4=ar^3(r-1)=24$; $T_4-T_3=ar^2(r-1)=8$; dividing gives $r=24/8=3$.', null::text),
  ('The 5th term of a GP is $2/81$. If the first term is 2, find the positive value of the common ratio.', null::text, '1/9', '1/3', '1/2', '2/3', null::text, 'B', 3, 'GENERAL', '$ar^4=2/81 \Rightarrow 2r^4=2/81 \Rightarrow r^4=1/81=(1/3)^4 \Rightarrow r=\pm1/3$; the positive value is $r=1/3$.', null::text),
  ('The sum of the first 3 terms of a GP is 40 while the 4th and 6th terms are in ratio 1:4. Find the positive value of the common ratio.', null::text, '1', '2', '3', '4', null::text, 'B', 4, 'GENERAL', '$T_4:T_6=1:r^2=1:4 \Rightarrow r^2=4 \Rightarrow r=\pm2$; the positive value is $r=2$ (giving $a=40/7$ and 5th term $640/7$).', null::text),
  ('Find the sum of the first three terms of the GP whose third term is 27 and whose 6th term is 8.', null::text, '513/4', '1281/4', '243/4', '128', null::text, 'A', 4, 'GENERAL', '$r^3=T_6/T_3=8/27=(2/3)^3 \Rightarrow r=2/3$; $a=T_3/r^2=27/(4/9)=243/4$. Sum of first 3 terms $=a+ar+ar^2=60.75+40.5+27=128.25=513/4$. (Note: an earlier source stated 1281/4 for this sum; direct computation confirms 513/4 is correct, and that value is kept as a distractor here.)', null::text),
  ('Find the sum to infinity of the GP $4, 2, 1, \ldots$', null::text, '6', '7', '8', '9', null::text, 'C', 2, 'GENERAL', '$a=4$, $r=1/2$; $S_\infty=\frac{4}{1-1/2}=\frac{4}{1/2}=8$.', null::text),
  ('The sum to infinity of a GP is 80. If the first term is 20, find the second term.', null::text, '15', '$11\frac{1}{4}$', '5', '$1\frac{1}{4}$', null::text, 'A', 3, 'GENERAL', '$S_\infty=a/(1-r) \Rightarrow 80=20/(1-r) \Rightarrow 1-r=1/4 \Rightarrow r=3/4$; $T_2=ar=20\times3/4=15$.', null::text),
  ('Find the sum to infinity of the series $2 + \frac{3}{2} + \frac{9}{8} + \frac{27}{32} + \ldots$', null::text, '1', '2', '8', '4', null::text, 'C', 3, 'GENERAL', '$a=2$, $r=3/4$; $S_\infty=\frac{2}{1-3/4}=\frac{2}{1/4}=8$.', null::text),
  ('Find the sum of the exponential series $96 + 24 + 6 + \ldots$', null::text, '144', '128', '72', '64', null::text, 'B', 2, 'GENERAL', '$a=96$, $r=1/4$; $S_\infty=\frac{96}{1-1/4}=\frac{96}{3/4}=128$.', null::text),
  ('Find the sum to infinity of the sequence $1, \frac{9}{10}, (\frac{9}{10})^2, (\frac{9}{10})^3, \ldots$', null::text, '10', '9', '10/9', '9/10', null::text, 'A', 2, 'GENERAL', '$a=1$, $r=9/10$; $S_\infty=\frac{1}{1-9/10}=\frac{1}{1/10}=10$.', null::text),
  ('The sum to infinity of a GP is $-1/10$ and the first term is $-1/8$. Find the common ratio.', null::text, '-1/5', '-1/4', '-1/3', '-1/2', null::text, 'B', 3, 'GENERAL', '$S_\infty=a/(1-r) \Rightarrow -1/10=(-1/8)/(1-r) \Rightarrow 1-r=5/4 \Rightarrow r=-1/4$.', null::text),
  ('The nth term of the sequence $-2, 4, -8, 16, \ldots$ is given by:', null::text, '$T_n = 2^n$', '$T_n = (-2)^n$', '$T_n = -2n$', '$T_n = n^2$', null::text, 'B', 2, 'GENERAL', 'Checking $n=1,2,3$: $(-2)^1=-2$, $(-2)^2=4$, $(-2)^3=-8$, matching the sequence.', null::text)
) as v(question_text, question_latex, option_a, option_b, option_c, option_d, option_e, correct_letter, difficulty, exam_type, explanation, exam_shortcut)
where c.subject = 'Mathematics' and t.class_level = 'SS2' and t.term = 1 and t.order_index = 104;

-- ------------------------------------------
-- 105. QUADRATIC EQUATIONS FROM SUM & PRODUCT OF ROOTS  -  SS2 Mathematics, Term 1
-- ------------------------------------------


with lesson as (
  insert into public.lessons (topic_id, title, summary, content_body, order_index)
  values (
    (select t.id from public.topics t join public.curricula c on c.id = t.curriculum_id where c.subject = 'Mathematics' and t.class_level = 'SS2' and t.term = 1 and t.order_index = 105),
    'Building a Quadratic from Its Roots, and the Discriminant',
    'Forming a quadratic equation from the sum and product of its roots, solving related word problems, and using the discriminant to determine the nature of the roots.',
    '## Quadratic Equations from Sum and Product of Roots

**Glossary**
- **Roots:** the solutions of a quadratic equation, often labelled $\alpha$ and $\beta$.
- **Discriminant:** the expression $b^2-4ac$ inside the square root of the quadratic formula, it reveals the nature of the roots without solving the equation fully.

For $ax^2+bx+c=0$ with roots $\alpha, \beta$:
- **Sum of roots:** $\alpha+\beta = -b/a$
- **Product of roots:** $\alpha\beta = c/a$
- An equation can be built from these: $x^2 - (\text{sum})x + (\text{product}) = 0$.

**Nature of roots from the discriminant:** if $b^2-4ac>0$, two distinct real roots; if $b^2-4ac=0$, equal (repeated) real roots; if $b^2-4ac<0$, no real roots (the roots are a complex conjugate pair).

Special root relationships: if one root is $k$ times the other, let the roots be $\alpha$ and $k\alpha$; if roots differ by a constant, let them be $\alpha$ and $\alpha+d$. For word problems: define a variable, translate the condition into an equation, solve (usually by factorization or the quadratic formula), and reject any solution that is not physically sensible (e.g. a negative length or a negative age).',
    1
  )
  returning id
)
insert into public.worked_examples (lesson_id, title, problem_statement, solution_steps, exam_shortcut, common_trap_warning, real_life_context, status)
select id,
  'Building a Quadratic Equation from Given Roots',
  'Form a quadratic equation with roots 3 and $-2$.',
  to_jsonb(array[
    'Find the sum of the roots: $\alpha+\beta = 3+(-2)=1$.',
    'Find the product of the roots: $\alpha\beta=3\times(-2)=-6$.',
    'Substitute into $x^2-(\text{sum})x+(\text{product})=0$: $x^2-(1)x+(-6)=0$.',
    'Answer: $x^2-x-6=0$.'
  ]),
  'For "form the equation from these roots" questions, skip expanding (x-alpha)(x-beta) by hand, just plug sum and product straight into the standard form.',
  null::text,
  null::text,
  'published'
from lesson;

insert into public.worked_examples (lesson_id, title, problem_statement, solution_steps, exam_shortcut, common_trap_warning, real_life_context, status)
select l.id,
  'Roots Given in a Ratio',
  'The roots of $x^2-px+12=0$ are in ratio 3:4. Find $p$ and the roots.',
  to_jsonb(array[
    'Represent the roots using the ratio: let the roots be $3k$ and $4k$.',
    'Use the product of roots ($=c/a=12$): $(3k)(4k)=12 \Rightarrow 12k^2=12$.',
    'Solve for $k$: $k^2=1 \Rightarrow k=\pm1$.',
    'Case $k=1$: roots are $3(1)=3$ and $4(1)=4$; sum $=7$, so $p=7$.',
    'Case $k=-1$: roots are $-3$ and $-4$; sum $=-7$, so $p=-7$.',
    'Answer: $p=7$ with roots 3, 4; or $p=-7$ with roots $-3, -4$.'
  ]),
  'Whenever roots are given "in the ratio m:n", represent them as mk and nk using one unknown k, this turns the product-of-roots equation into a simple k-squared equation.',
  'Don''t forget the negative case: k can be negative too, giving a second valid value of p.',
  null::text,
  'published'
from public.lessons l
where l.topic_id = (select t.id from public.topics t join public.curricula c on c.id = t.curriculum_id where c.subject = 'Mathematics' and t.class_level = 'SS2' and t.term = 1 and t.order_index = 105)
order by l.created_at desc limit 1;

insert into public.worked_examples (lesson_id, title, problem_statement, solution_steps, exam_shortcut, common_trap_warning, real_life_context, status)
select l.id,
  'Rectangular Farmland Dimensions',
  'A farmer wants to fence a rectangular plot whose length is 3 m more than its width. If the area must be 40 m², find the width and length.',
  to_jsonb(array[
    'Define a variable: let width $= w$ m, so length $= (w+3)$ m.',
    'Write the area equation: $w(w+3)=40$.',
    'Expand and rearrange into standard form: $w^2+3w-40=0$.',
    'Factorize: find two numbers that multiply to $-40$ and add to $3$: $8$ and $-5$.',
    'Write the factorized form and solve: $(w+8)(w-5)=0 \Rightarrow w=-8$ or $w=5$.',
    'Reject the physically impossible solution: width cannot be negative, so $w=-8$ is rejected.',
    'Find the length: length $= w+3 = 5+3=8$.',
    'Answer: width $=5$ m, length $=8$ m.'
  ]),
  'The moment you see "3 more than" or "5 cm longer", define one unknown, write the second quantity in terms of it, and go straight to a product/area equation.',
  'Always reject a negative width or length root immediately, physical dimensions can never be negative.',
  'This is exactly how a farmer or land surveyor works out plot dimensions from a required area and a stated length-width relationship before fencing or selling the land.',
  'published'
from public.lessons l
where l.topic_id = (select t.id from public.topics t join public.curricula c on c.id = t.curriculum_id where c.subject = 'Mathematics' and t.class_level = 'SS2' and t.term = 1 and t.order_index = 105)
order by l.created_at desc limit 1;

insert into public.worked_examples (lesson_id, title, problem_statement, solution_steps, exam_shortcut, common_trap_warning, real_life_context, status)
select l.id,
  'A Journey Time Problem',
  'A car travels 180 km. If its speed had been 15 km/h faster, the journey would have taken 1 hour less. Find the original speed.',
  to_jsonb(array[
    'Define a variable: let the original speed be $s$ km/h, so the original time is $180/s$ hours.',
    'Write the condition as an equation: $(s+15)\left(\dfrac{180}{s}-1\right)=180$.',
    'Expand: $180 - s + \dfrac{2700}{s} - 15 = 180$.',
    'Simplify and clear the fraction by multiplying through by $s$: $-s^2 - 15s + 2700 = 0$, i.e. $s^2+15s-2700=0$.',
    'Solve using the quadratic formula: discriminant $=15^2-4(1)(-2700)=225+10800=11025=105^2$; $s=\dfrac{-15\pm105}{2}$.',
    'Take the positive root (speed cannot be negative): $s=\dfrac{-15+105}{2}=\dfrac{90}{2}=45$.',
    'Answer: the original speed was $45$ km/h.'
  ]),
  'Always sanity-check word-problem roots against reality: after solving, throw away any root that gives a negative length, negative age, or negative speed.',
  null::text,
  'This is the same reasoning a transport company or commercial driver uses to compare journey times across different average speeds on a fixed route, such as the Lagos-Ibadan expressway.',
  'published'
from public.lessons l
where l.topic_id = (select t.id from public.topics t join public.curricula c on c.id = t.curriculum_id where c.subject = 'Mathematics' and t.class_level = 'SS2' and t.term = 1 and t.order_index = 105)
order by l.created_at desc limit 1;

insert into public.questions (topic_id, lesson_id, question_text, question_latex, option_a, option_b, option_c, option_d, option_e, correct_letter, difficulty, exam_type, explanation, exam_shortcut, status)
select t.id, l.id, v.question_text, v.question_latex, v.option_a, v.option_b, v.option_c, v.option_d, v.option_e, v.correct_letter::char(1), v.difficulty::integer, v.exam_type::exam_type, v.explanation, v.exam_shortcut, 'published'
from public.topics t
join public.curricula c on c.id = t.curriculum_id
join public.lessons l on l.topic_id = t.id
cross join (values
  ('Form a quadratic equation with roots 4 and $-1$.', null::text, '$x^2+3x-4=0$', '$x^2-3x-4=0$', '$x^2-3x+4=0$', '$x^2-4x-3=0$', null::text, 'B', 1, 'GENERAL', 'Sum $=3$, product $=-4$; equation: $x^2-3x-4=0$.', null::text),
  ('Form a quadratic equation with roots 3 and $-2$.', null::text, '$x^2+x-6=0$', '$x^2-x+6=0$', '$x^2-x-6=0$', '$x^2+6x-1=0$', null::text, 'C', 1, 'GENERAL', 'Sum $=1$, product $=-6$; equation: $x^2-x-6=0$.', null::text),
  ('The sum of roots of a quadratic equation is 5 and their product is 6. Find the equation and its roots.', null::text, '$x^2-5x+6=0$; $x=2$ or 3', '$x^2+5x+6=0$; $x=-2$ or $-3$', '$x^2-5x-6=0$; $x=6$ or $-1$', '$x^2-6x+5=0$; $x=1$ or $5$', null::text, 'A', 2, 'GENERAL', 'Equation: $x^2-5x+6=0$, which factorizes as $(x-2)(x-3)=0$, giving $x=2$ or $x=3$.', null::text),
  ('Form quadratic equations with roots: (a) 5 and 2 (b) $-3$ and 4 (c) $1/2$ and 3.', null::text, '(a) $x^2-7x+10=0$ (b) $x^2-x-12=0$ (c) $x^2-3.5x+1.5=0$', '(a) $x^2+7x+10=0$ (b) $x^2-x-12=0$ (c) $2x^2-7x+3=0$', '(a) $x^2-7x+10=0$ (b) $x^2+x-12=0$ (c) $2x^2-7x+3=0$', '(a) $x^2-7x+10=0$ (b) $x^2-x-12=0$ (c) $2x^2-7x+3=0$', null::text, 'D', 2, 'GENERAL', '(a) sum 7, product 10: $x^2-7x+10=0$. (b) sum 1, product $-12$: $x^2-x-12=0$. (c) sum 3.5, product 1.5, clear fractions: $2x^2-7x+3=0$.', null::text),
  ('The roots of $x^2-px+12=0$ are in ratio 3:4. Find $p$ and the roots.', null::text, '$p=7$; roots 3, 4 only', '$p=\pm7$; roots 3, 4 or $-3$, $-4$', '$p=7$; roots $-3$, $-4$', '$p=12$; roots 3, 4', null::text, 'B', 3, 'GENERAL', 'Letting roots be $3k, 4k$: $12k^2=12 \Rightarrow k=\pm1$, giving $p=\pm7$ with roots 3,4 or $-3,-4$.', null::text),
  ('The roots of $x^2-px+15=0$ are in ratio 2:3. Find $p$.', null::text, '$p=\pm5$', '$p=\pm\frac{5\sqrt{10}}{2}$', '$p=\pm\sqrt{15}$', '$p=\pm10$', null::text, 'B', 4, 'GENERAL', 'Letting roots be $2k,3k$: $6k^2=15 \Rightarrow k^2=5/2 \Rightarrow k=\pm\sqrt{2.5}$; $p=5k=\pm5\sqrt{2.5}=\pm\frac{5\sqrt{10}}{2}$.', null::text),
  ('If one root of $x^2+px+8=0$ is 4, find $p$ and the other root.', null::text, '$p=-6$, other root $=2$', '$p=6$, other root $=-2$', '$p=-2$, other root $=6$', '$p=2$, other root $=-6$', null::text, 'A', 2, 'GENERAL', 'Product $=8=4\times$other $\Rightarrow$ other root $=2$; sum $=4+2=6=-p \Rightarrow p=-6$.', null::text),
  ('If one root of $3x^2+kx-2=0$ is 2, find $k$ and the other root.', null::text, '$k=-5$, other root $=-1/3$', '$k=5$, other root $=1/3$', '$k=-5$, other root $=1/3$', '$k=5$, other root $=-1/3$', null::text, 'A', 3, 'GENERAL', 'Product $=-2/3=2\times$other $\Rightarrow$ other $=-1/3$; sum $=2-1/3=5/3=-k/3 \Rightarrow k=-5$.', null::text),
  ('One root of $2x^2+kx-6=0$ is 2. Find $k$ and the other root.', null::text, '$k=1$, other root $=3/2$', '$k=-1$, other root $=-3/2$', '$k=-1$, other root $=3/2$', '$k=1$, other root $=-3/2$', null::text, 'B', 3, 'GENERAL', 'Product $=-3=2\times$other $\Rightarrow$ other $=-3/2$; sum $=2-3/2=1/2=-k/2 \Rightarrow k=-1$.', null::text),
  ('The roots of $2x^2-7x+k=0$ are equal. Find $k$.', null::text, '49/8', '7/2', '49/4', '7/8', null::text, 'A', 2, 'GENERAL', 'Equal roots: discriminant $=49-8k=0 \Rightarrow k=49/8$.', 'Equal roots always means discriminant = 0, set that up directly instead of trying to factorize.'),
  ('$x^2+kx+9=0$ has equal roots. Find $k$.', null::text, '$\pm3$', '$\pm6$', '$\pm9$', '$\pm12$', null::text, 'B', 2, 'GENERAL', 'Discriminant $=k^2-36=0 \Rightarrow k=\pm6$.', null::text),
  ('$kx^2-6x+2=0$ has one root as 2. Find $k$.', null::text, '5/2', '2', '3', '5', null::text, 'A', 3, 'GENERAL', 'Substitute $x=2$: $4k-12+2=0 \Rightarrow 4k=10 \Rightarrow k=5/2$.', null::text),
  ('$2x^2+5x+k=0$ has product of roots equal to 3. Find $k$.', null::text, '3', '5', '6', '10', null::text, 'C', 2, 'GENERAL', 'Product $=k/2=3 \Rightarrow k=6$.', null::text),
  ('The square of a number exceeds the number by 12. Find the number(s).', null::text, '4 or -3', '3 or -4', '4 or 3', '-3 or -4', null::text, 'A', 2, 'GENERAL', '$x^2=x+12 \Rightarrow x^2-x-12=0 \Rightarrow (x-4)(x+3)=0 \Rightarrow x=4$ or $-3$.', null::text),
  ('Two numbers differ by 3 and their product is 70. Find them.', null::text, '5, 8', '7, 10 or -10, -7', '6, 9', '4, 7', null::text, 'B', 2, 'GENERAL', '$x(x+3)=70 \Rightarrow x^2+3x-70=0 \Rightarrow (x+10)(x-7)=0 \Rightarrow x=7$ or $-10$, giving 7,10 or -10,-7.', null::text),
  ('The sum of two numbers is 12 and their product is 35. Find the numbers.', null::text, '4, 8', '6, 6', '5, 7', '3, 9', null::text, 'C', 1, 'GENERAL', 'Numbers are roots of $x^2-12x+35=0=(x-5)(x-7)$, giving 5 and 7.', null::text),
  ('A rectangle has length 3 cm more than its width and area 40 cm². Find the dimensions.', null::text, 'width 4 cm, length 7 cm', 'width 6 cm, length 9 cm', 'width 5 cm, length 7 cm', 'width 5 cm, length 8 cm', null::text, 'D', 2, 'GENERAL', '$w(w+3)=40 \Rightarrow w^2+3w-40=0 \Rightarrow (w+8)(w-5)=0 \Rightarrow w=5$, length $=8$.', null::text),
  ('A rectangle has length 5 cm more than its width. If the area is 84 cm², find the dimensions.', null::text, 'width 7 cm, length 12 cm', 'width 6 cm, length 11 cm', 'width 8 cm, length 13 cm', 'width 7 cm, length 10 cm', null::text, 'A', 2, 'GENERAL', '$w(w+5)=84 \Rightarrow w^2+5w-84=0 \Rightarrow (w+12)(w-7)=0 \Rightarrow w=7$, length $=12$.', null::text),
  ('The base of a triangle is 4 cm longer than its height. If the area is 30 cm², find the base and height.', null::text, 'height 5 cm, base 9 cm', 'height 6 cm, base 10 cm', 'height 7 cm, base 11 cm', 'height 6 cm, base 9 cm', null::text, 'B', 3, 'GENERAL', '$\frac{1}{2}h(h+4)=30 \Rightarrow h^2+4h-60=0 \Rightarrow (h+10)(h-6)=0 \Rightarrow h=6$, base $=10$.', null::text),
  ('The perimeter of a rectangle is 26 cm and its area is 40 cm². Find its dimensions.', null::text, '9 cm by 4 cm', '10 cm by 3 cm', '8 cm by 5 cm', '7 cm by 6 cm', null::text, 'C', 3, 'GENERAL', '$l+w=13$, $lw=40$; roots of $x^2-13x+40=0=(x-8)(x-5)$, giving 8 cm by 5 cm.', null::text),
  ('A car travels 180 km. If the speed was 15 km/h faster, the journey would take 1 hour less. Find the original speed.', null::text, '30 km/h', '36 km/h', '40 km/h', '45 km/h', null::text, 'D', 4, 'GENERAL', '$(s+15)(180/s-1)=180$ leads to $s^2+15s-2700=0$, giving $s=45$ km/h (the negative root is rejected).', null::text),
  ('A man is 24 years older than his son. In 4 years, the product of their ages will be 360. Find their present ages.', null::text, 'son $\approx6.45$, man $\approx30.45$', 'son 6, man 30', 'son 8, man 32', 'son 5, man 29', null::text, 'A', 4, 'GENERAL', 'Let the son''s present age be $x$: $(x+4)(x+28)=360 \Rightarrow x^2+32x-248=0$; $x=-16+6\sqrt{14}\approx6.45$ (negative root rejected). These ages are not whole numbers, unusual for a typical exam problem, but that is what the given figures produce.', null::text),
  ('The product of two consecutive positive integers is 132. Find the integers.', null::text, '10, 11', '11, 12', '12, 13', '9, 10', null::text, 'B', 2, 'GENERAL', '$n(n+1)=132 \Rightarrow n^2+n-132=0 \Rightarrow (n+12)(n-11)=0 \Rightarrow n=11$, giving 11 and 12.', null::text),
  ('The sum of a number and its reciprocal is $13/6$. Find the number(s).', null::text, '1/2 or 2', '3/4 or 4/3', '2/3 or 3/2', '1/3 or 3', null::text, 'C', 3, 'GENERAL', '$x+1/x=13/6 \Rightarrow 6x^2-13x+6=0 \Rightarrow (3x-2)(2x-3)=0 \Rightarrow x=2/3$ or $3/2$.', null::text),
  ('What is the nature of the roots of $2x^2-5x+4=0$?', null::text, 'discriminant $=9>0$, two real roots', 'discriminant $=0$, equal roots', 'discriminant $=-9<0$, no real roots', 'discriminant $=-7<0$, no real roots (complex conjugate pair)', null::text, 'D', 2, 'GENERAL', '$b^2-4ac=25-32=-7<0$, so the equation has no real roots, its roots form a complex conjugate pair.', null::text),
  ('Without solving, determine the nature of roots of $x^2-4x+4=0$.', null::text, 'discriminant $=0$, equal (repeated) real roots', 'discriminant $=16>0$, two real roots', 'discriminant $=-16<0$, no real roots', 'discriminant $=8>0$, two real roots', null::text, 'A', 2, 'GENERAL', '$b^2-4ac=16-16=0$, so the roots are equal (repeated).', null::text),
  ('Without solving, determine the nature of roots of $2x^2+3x-5=0$.', null::text, 'discriminant $=-49<0$, no real roots', 'discriminant $=49>0$, two distinct real roots', 'discriminant $=0$, equal roots', 'discriminant $=9>0$, two real roots', null::text, 'B', 2, 'GENERAL', '$b^2-4ac=9+40=49>0$, so there are two distinct real roots.', null::text),
  ('Without solving, determine the nature of roots of $x^2+x+1=0$.', null::text, 'discriminant $=3>0$, two real roots', 'discriminant $=0$, equal roots', 'discriminant $=-3<0$, no real roots', 'discriminant $=1>0$, two real roots', null::text, 'C', 2, 'GENERAL', '$b^2-4ac=1-4=-3<0$, so there are no real roots.', null::text),
  ('Determine the nature of the roots of $3x^2-5x+4=0$ without solving.', null::text, 'discriminant $=23>0$', 'discriminant $=0$', 'discriminant $=-25<0$', 'discriminant $=-23<0$, no real roots', null::text, 'D', 2, 'GENERAL', '$b^2-4ac=25-48=-23<0$, so there are no real roots.', null::text),
  ('Without solving, determine the nature of roots of $3x^2+7x+5=0$.', null::text, 'discriminant $=-11<0$, no real roots', 'discriminant $=11>0$, two real roots', 'discriminant $=0$, equal roots', 'discriminant $=-9<0$, no real roots', null::text, 'A', 2, 'GENERAL', '$b^2-4ac=49-60=-11<0$, so there are no real roots.', null::text)
) as v(question_text, question_latex, option_a, option_b, option_c, option_d, option_e, correct_letter, difficulty, exam_type, explanation, exam_shortcut)
where c.subject = 'Mathematics' and t.class_level = 'SS2' and t.term = 1 and t.order_index = 105;

-- ------------------------------------------
-- 106. SIMULTANEOUS EQUATIONS: ELIMINATION & SUBSTITUTION  -  SS2 Mathematics, Term 1
-- ------------------------------------------


with lesson as (
  insert into public.lessons (topic_id, title, summary, content_body, order_index)
  values (
    (select t.id from public.topics t join public.curricula c on c.id = t.curriculum_id where c.subject = 'Mathematics' and t.class_level = 'SS2' and t.term = 1 and t.order_index = 106),
    'Solving Simultaneous Equations by Elimination and Substitution',
    'Solving pairs of linear equations using elimination and substitution, and applying both methods to word problems.',
    '## Simultaneous Equations: Elimination and Substitution

**Glossary**
- **Simultaneous equations:** two or more equations sharing common unknowns, solved together so every unknown satisfies all the equations at once.
- **Elimination method:** make the coefficients of one variable equal (by multiplying), then add or subtract the equations to remove that variable.
- **Substitution method:** make one variable the subject of one equation, then substitute that expression into the other equation.',
    1
  )
  returning id
)
insert into public.worked_examples (lesson_id, title, problem_statement, solution_steps, exam_shortcut, common_trap_warning, real_life_context, status)
select id,
  'Solving by Elimination',
  'Solve by elimination: $3x+4y=25$ … (i), $2x-3y=-6$ … (ii).',
  to_jsonb(array[
    'Choose a variable to eliminate ($x$) and find a common multiple of its coefficients: coefficients are 3 and 2; LCM $=6$.',
    'Multiply equation (i) by 2: $6x+8y=50$ … (iii).',
    'Multiply equation (ii) by 3: $6x-9y=-18$ … (iv).',
    'Subtract (iv) from (iii) to eliminate $x$: $(6x+8y)-(6x-9y)=50-(-18) \Rightarrow 17y=68$.',
    'Solve for $y$: $y=68\div17=4$.',
    'Substitute $y=4$ back into equation (i): $3x+4(4)=25 \Rightarrow 3x+16=25 \Rightarrow 3x=9 \Rightarrow x=3$.',
    'Check in equation (ii): $2(3)-3(4)=6-12=-6$ ✓.',
    'Answer: $(x,y)=(3,4)$.'
  ]),
  'Multiply by the smallest possible numbers: to make coefficients match, multiply by the other equation''s coefficient of that variable (cross-multiplying), this is guaranteed to work and is usually smaller than finding a full LCM by trial.',
  null::text,
  null::text,
  'published'
from lesson;

insert into public.worked_examples (lesson_id, title, problem_statement, solution_steps, exam_shortcut, common_trap_warning, real_life_context, status)
select l.id,
  'Solving by Substitution',
  'Solve by substitution: $y=3x-5$ … (i), $2x+3y=4$ … (ii).',
  to_jsonb(array[
    'Since (i) already gives $y$ in terms of $x$, substitute it into (ii): $2x+3(3x-5)=4$.',
    'Expand the bracket: $2x+9x-15=4$.',
    'Collect like terms: $11x-15=4$.',
    'Solve for $x$: $11x=19 \Rightarrow x=19/11$.',
    'Substitute $x=19/11$ back into (i) to find $y$: $y=3(19/11)-5=57/11-55/11=2/11$.',
    'Answer: $x=19/11$, $y=2/11$.'
  ]),
  'Pick the method that needs the least algebra: if one equation already has a variable alone on one side, use substitution immediately, don''t force elimination.',
  'Always verify both values in the other original equation, not the one used to find them, this catches almost every sign or arithmetic slip.',
  null::text,
  'published'
from public.lessons l
where l.topic_id = (select t.id from public.topics t join public.curricula c on c.id = t.curriculum_id where c.subject = 'Mathematics' and t.class_level = 'SS2' and t.term = 1 and t.order_index = 106)
order by l.created_at desc limit 1;

insert into public.worked_examples (lesson_id, title, problem_statement, solution_steps, exam_shortcut, common_trap_warning, real_life_context, status)
select l.id,
  'Cost of Books and Pens',
  'Three books and two pens cost ₦350. Five books and three pens cost ₦550. Find the cost of each.',
  to_jsonb(array[
    'Define variables: let one book cost $x$ naira, one pen cost $y$ naira.',
    'Translate the two statements into equations: $3x+2y=350$ … (i); $5x+3y=550$ … (ii).',
    'Eliminate $y$: the LCM of 2 and 3 is 6, so multiply (i) by 3 and (ii) by 2: $9x+6y=1050$ … (iii); $10x+6y=1100$ … (iv).',
    'Subtract (iii) from (iv): $(10x+6y)-(9x+6y)=1100-1050 \Rightarrow x=50$.',
    'Substitute $x=50$ into (i): $3(50)+2y=350 \Rightarrow 150+2y=350 \Rightarrow 2y=200 \Rightarrow y=100$.',
    'Check in equation (ii): $5(50)+3(100)=250+300=550$ ✓.',
    'Answer: one book $=₦50$, one pen $=₦100$.'
  ]),
  'Word-problem setup shortcut: the two numeric costs go directly on the right-hand side of the two equations, and the item quantities become the left-hand coefficients, write both equations in one pass straight from the sentence.',
  null::text,
  'This is exactly how a shopkeeper or parent works out unit prices from two different combined receipts, without the shop needing to itemise every single price separately.',
  'published'
from public.lessons l
where l.topic_id = (select t.id from public.topics t join public.curricula c on c.id = t.curriculum_id where c.subject = 'Mathematics' and t.class_level = 'SS2' and t.term = 1 and t.order_index = 106)
order by l.created_at desc limit 1;

insert into public.worked_examples (lesson_id, title, problem_statement, solution_steps, exam_shortcut, common_trap_warning, real_life_context, status)
select l.id,
  'Fruit Stall Pricing',
  'At a fruit stall, 5 oranges and 3 apples cost ₦200; 7 oranges and 5 apples cost ₦310. Find the cost of each fruit.',
  to_jsonb(array[
    'Define variables: let one orange cost $x$ naira, one apple cost $y$ naira.',
    'Translate into equations: $5x+3y=200$ … (i); $7x+5y=310$ … (ii).',
    'Eliminate $y$: multiply (i) by 5 and (ii) by 3: $25x+15y=1000$ … (iii); $21x+15y=930$ … (iv).',
    'Subtract (iv) from (iii): $4x=70 \Rightarrow x=17.5$.',
    'Substitute $x=17.5$ into (i): $5(17.5)+3y=200 \Rightarrow 87.5+3y=200 \Rightarrow 3y=112.5 \Rightarrow y=37.5$.',
    'Answer: one orange $=₦17.50$, one apple $=₦37.50$.'
  ]),
  'Verify both values in the other original equation, not the one used to find them, this catches almost every sign or arithmetic slip.',
  null::text,
  'A market fruit seller or a customer comparing two different combined purchases uses exactly this method to work back to the price of a single orange or apple.',
  'published'
from public.lessons l
where l.topic_id = (select t.id from public.topics t join public.curricula c on c.id = t.curriculum_id where c.subject = 'Mathematics' and t.class_level = 'SS2' and t.term = 1 and t.order_index = 106)
order by l.created_at desc limit 1;

insert into public.questions (topic_id, lesson_id, question_text, question_latex, option_a, option_b, option_c, option_d, option_e, correct_letter, difficulty, exam_type, explanation, exam_shortcut, status)
select t.id, l.id, v.question_text, v.question_latex, v.option_a, v.option_b, v.option_c, v.option_d, v.option_e, v.correct_letter::char(1), v.difficulty::integer, v.exam_type::exam_type, v.explanation, v.exam_shortcut, 'published'
from public.topics t
join public.curricula c on c.id = t.curriculum_id
join public.lessons l on l.topic_id = t.id
cross join (values
  ('Solve by elimination: $2x+3y=13$, $2x-y=5$.', null::text, '(3.5, 2)', '(2, 3)', '(4, 1.5)', '(3, 2.5)', null::text, 'A', 2, 'GENERAL', 'Subtracting the equations gives $4y=8 \Rightarrow y=2$; substituting gives $2x-2=5 \Rightarrow x=3.5$.', null::text),
  ('Solve by elimination: $3x+2y=16$, $2x+5y=21$.', null::text, '(3, 2)', '(38/11, 31/11)', '(4, 2)', '(2, 4)', null::text, 'B', 3, 'GENERAL', 'Multiplying and subtracting gives $11y=31 \Rightarrow y=31/11$; back-substitution gives $x=38/11$.', null::text),
  ('Solve by substitution: $y=2x-1$, $3x+2y=12$.', null::text, '(1, 1)', '(3, 5)', '(2, 3)', '(2.5, 4)', null::text, 'C', 2, 'GENERAL', '$3x+2(2x-1)=12 \Rightarrow 7x-2=12 \Rightarrow x=2$, $y=3$.', null::text),
  ('Solve by substitution: $2x+y=7$, $3x-2y=4$.', null::text, '(2, 3)', '(3, 1)', '(18/7, 15/7)', '(18/7, 13/7)', null::text, 'D', 3, 'GENERAL', '$y=7-2x$; $3x-2(7-2x)=4 \Rightarrow 7x=18 \Rightarrow x=18/7$, $y=13/7$.', null::text),
  ('Solve by elimination: $3x+4y=25$, $2x-3y=-6$.', null::text, '(3, 4)', '(4, 3)', '(5, 2)', '(2, 5)', null::text, 'A', 2, 'GENERAL', 'Solving gives $y=4$, $x=3$.', null::text),
  ('Solve by substitution: $y=3x-5$, $2x+3y=4$.', null::text, '(2, 1)', '(19/11, 2/11)', '(1, 19/11)', '(2/11, 19/11)', null::text, 'B', 3, 'GENERAL', '$2x+3(3x-5)=4 \Rightarrow 11x=19 \Rightarrow x=19/11$, $y=2/11$.', null::text),
  ('At a fruit stall, 5 oranges and 3 apples cost ₦200; 7 oranges and 5 apples cost ₦310. Find the cost of each fruit.', null::text, 'orange ₦20, apple ₦33.33', 'orange ₦15, apple ₦41.67', 'orange ₦17.50, apple ₦37.50', 'orange ₦25, apple ₦25', null::text, 'C', 3, 'GENERAL', 'Solving the pair of equations gives orange $=₦17.50$, apple $=₦37.50$.', null::text),
  ('At a shop, 3 pens and 2 books cost ₦450; 5 pens and 4 books cost ₦830. Find the cost of one pen and one book.', null::text, 'pen ₦50, book ₦150', 'pen ₦90, book ₦90', 'pen ₦60, book ₦135', 'pen ₦70, book ₦120', null::text, 'D', 3, 'GENERAL', 'Solving $3p+2b=450$ and $5p+4b=830$ gives $p=70$, $b=120$.', null::text),
  ('A man is 3 times as old as his son. In 12 years, he will be twice as old as his son. Find their present ages.', null::text, 'son 12, man 36', 'son 10, man 30', 'son 15, man 45', 'son 8, man 24', null::text, 'A', 3, 'GENERAL', 'Let son $=s$, man $=3s$. $3s+12=2(s+12) \Rightarrow s=12$, man $=36$.', null::text),
  ('Solve: $x+y=10$, $x-y=2$.', null::text, '(5, 5)', '(6, 4)', '(7, 3)', '(4, 6)', null::text, 'B', 1, 'GENERAL', 'Adding the equations: $2x=12 \Rightarrow x=6$, $y=4$.', null::text),
  ('Solve by elimination: $2x+3y=12$, $3x-2y=5$.', null::text, '(2, 3)', '(1, 10/3)', '(3, 2)', '(4, 4/3)', null::text, 'C', 2, 'GENERAL', 'Multiplying and adding gives $13x=39 \Rightarrow x=3$, $y=2$.', null::text),
  ('Solve by substitution: $y=2x-1$, $3x+y=14$.', null::text, '(4, 7)', '(2, 3)', '(5, 9)', '(3, 5)', null::text, 'D', 2, 'GENERAL', '$3x+2x-1=14 \Rightarrow 5x=15 \Rightarrow x=3$, $y=5$.', null::text),
  ('Three books and two pens cost ₦350. Five books and three pens cost ₦550. Find the cost of each.', null::text, 'book ₦50, pen ₦100', 'book ₦100, pen ₦50', 'book ₦70, pen ₦70', 'book ₦60, pen ₦85', null::text, 'A', 2, 'GENERAL', 'Solving the two equations gives book $=₦50$, pen $=₦100$.', null::text),
  ('The sum of two numbers is 50. If the larger number is 10 more than the smaller, find both numbers.', null::text, '15, 35', '20, 30', '25, 25', '18, 32', null::text, 'B', 1, 'GENERAL', '$s+l=50$, $l=s+10 \Rightarrow 2s=40 \Rightarrow s=20$, $l=30$.', null::text),
  ('The sum of two numbers is 25 and their difference is 7. Find the numbers.', null::text, '15, 10', '18, 7', '16, 9', '14, 11', null::text, 'C', 1, 'GENERAL', 'Numbers are $(25+7)/2=16$ and $(25-7)/2=9$.', null::text),
  ('Solve by elimination: (a) $3x+2y=16$, $5x-3y=2$ (b) $4x+5y=23$, $3x+4y=18$.', null::text, '(a) x=4, y=2 (b) x=2, y=3', '(a) x=38/19, y=74/19 (b) x=3, y=2', '(a) x=2, y=5 (b) x=2, y=3', '(a) x=38/19, y=74/19 (b) x=2, y=3', null::text, 'D', 4, 'GENERAL', '(a) solving gives $x=38/19$, $y=74/19$ (note: an earlier stated answer of $x=4,y=2$ does not satisfy $5x-3y=2$). (b) solving gives $x=2$, $y=3$.', null::text),
  ('Solve by substitution: (a) $x=3y-2$, $2x+y=11$ (b) $y=2x+1$, $3x-4y=-13$.', null::text, '(a) x=31/7, y=15/7 (b) x=9/5, y=23/5', '(a) x=4, y=2 (b) x=3, y=7', '(a) x=31/7, y=15/7 (b) x=3, y=7', '(a) x=4, y=2 (b) x=9/5, y=23/5', null::text, 'A', 4, 'GENERAL', '(a) solving gives $x=31/7$, $y=15/7$. (b) solving gives $x=9/5$, $y=23/5$ (both correcting earlier stated answers that fail to satisfy the second equation in each pair).', null::text),
  ('At a restaurant, 4 meals and 3 drinks cost ₦2,400. 6 meals and 5 drinks cost ₦3,700. Find the cost of one meal and one drink.', null::text, 'meal ₦400, drink ₦267', 'meal ₦450, drink ₦200', 'meal ₦500, drink ₦133', 'meal ₦350, drink ₦300', null::text, 'B', 3, 'GENERAL', 'Solving $4m+3d=2400$ and $6m+5d=3700$ gives $m=450$, $d=200$.', null::text),
  ('The perimeter of a rectangle is 40 cm. The length is 4 cm more than the width. Find the dimensions.', null::text, 'length 10 cm, width 10 cm', 'length 14 cm, width 6 cm', 'length 12 cm, width 8 cm', 'length 11 cm, width 9 cm', null::text, 'C', 2, 'GENERAL', '$l+w=20$, $l=w+4 \Rightarrow 2w=16 \Rightarrow w=8$, $l=12$.', null::text)
) as v(question_text, question_latex, option_a, option_b, option_c, option_d, option_e, correct_letter, difficulty, exam_type, explanation, exam_shortcut)
where c.subject = 'Mathematics' and t.class_level = 'SS2' and t.term = 1 and t.order_index = 106;

-- ------------------------------------------
-- 107. SIMULTANEOUS EQUATIONS: LINEAR & QUADRATIC  -  SS2 Mathematics, Term 1
-- ------------------------------------------


with lesson as (
  insert into public.lessons (topic_id, title, summary, content_body, order_index)
  values (
    (select t.id from public.topics t join public.curricula c on c.id = t.curriculum_id where c.subject = 'Mathematics' and t.class_level = 'SS2' and t.term = 1 and t.order_index = 107),
    'Solving a Linear-Quadratic System, and Graphical Solution of Quadratics',
    'Solving simultaneous equations where one equation is linear and one is quadratic, and reading key features (roots, vertex) from a plotted quadratic graph.',
    '## Simultaneous Equations: Linear and Quadratic

**Glossary**
- **Quadratic-linear system:** a pair of equations where one is linear ($y=mx+c$) and the other quadratic ($y=ax^2+bx+c$), solved by substitution into a single quadratic in one variable.
- **Vertex (turning point):** the highest or lowest point of a parabola, with $x$-coordinate at $-b/(2a)$.

When one equation is linear and the other quadratic, substitute the linear expression for $y$ into the quadratic, giving a single quadratic in $x$. This can have 0, 1, or 2 solutions, corresponding to the line missing, touching (tangent to), or crossing the parabola twice, this is revealed by the discriminant of the resulting quadratic.

To solve a quadratic **graphically**: plot $y=ax^2+bx+c$ using a table of values, drawing a smooth curve; the roots of $ax^2+bx+c=0$ are the $x$-intercepts (where the curve crosses the $x$-axis).',
    1
  )
  returning id
)
insert into public.worked_examples (lesson_id, title, problem_statement, solution_steps, exam_shortcut, common_trap_warning, real_life_context, status)
select id,
  'Solving a Linear-Quadratic System',
  'Solve simultaneously: $y=x+2$, $y=x^2-4x+6$.',
  to_jsonb(array[
    'Since both expressions equal $y$, set them equal to each other: $x+2=x^2-4x+6$.',
    'Rearrange to standard form: $0=x^2-4x+6-x-2 \Rightarrow x^2-5x+4=0$.',
    'Factorize: find two numbers that multiply to 4 and add to $-5$: $-1$ and $-4$.',
    'Write the factorized form and solve: $(x-4)(x-1)=0 \Rightarrow x=4$ or $x=1$.',
    'Find the matching $y$-value for each $x$ using $y=x+2$: $x=4 \Rightarrow y=6$; $x=1 \Rightarrow y=3$.',
    'Check both points satisfy the quadratic too: $(4,6)$: $16-16+6=6$ ✓; $(1,3)$: $1-4+6=3$ ✓.',
    'Answer: $(4,6)$ and $(1,3)$.'
  ]),
  'Substitute the linear equation into the quadratic, never the reverse, isolating y from the linear equation is always easier.',
  null::text,
  null::text,
  'published'
from lesson;

insert into public.worked_examples (lesson_id, title, problem_statement, solution_steps, exam_shortcut, common_trap_warning, real_life_context, status)
select l.id,
  'A System With Irrational Solutions',
  'Solve simultaneously: $y=x^2-2x+3$, $y=2x+1$.',
  to_jsonb(array[
    'Set the two expressions for $y$ equal: $x^2-2x+3=2x+1$.',
    'Rearrange to standard form: $x^2-4x+2=0$.',
    'This does not factorize with whole numbers, so use the quadratic formula with $a=1,b=-4,c=2$: $x=\dfrac{4\pm\sqrt{16-8}}{2}=\dfrac{4\pm\sqrt{8}}{2}$.',
    'Simplify $\sqrt{8}=2\sqrt{2}$: $x=\dfrac{4\pm2\sqrt{2}}{2}=2\pm\sqrt{2}$.',
    'Find the matching $y$-value using $y=2x+1$: for $x=2+\sqrt{2}$, $y=5+2\sqrt{2}$; for $x=2-\sqrt{2}$, $y=5-2\sqrt{2}$.',
    'Answer: $(2+\sqrt{2}, 5+2\sqrt{2})$ and $(2-\sqrt{2}, 5-2\sqrt{2})$.'
  ]),
  'Count solutions before fully solving using the discriminant: positive means two intersection points, zero means tangent, negative means no real solutions.',
  null::text,
  'Modelling two competing cost curves as a straight line and a curve like this is exactly how a business analyst finds the input levels where a fixed-rate plan and a rising-cost plan produce the same total, even when the exact crossing points are irrational numbers in a real forecast.',
  'published'
from public.lessons l
where l.topic_id = (select t.id from public.topics t join public.curricula c on c.id = t.curriculum_id where c.subject = 'Mathematics' and t.class_level = 'SS2' and t.term = 1 and t.order_index = 107)
order by l.created_at desc limit 1;

insert into public.worked_examples (lesson_id, title, problem_statement, solution_steps, exam_shortcut, common_trap_warning, real_life_context, status)
select l.id,
  'Sketching a Parabola and Reading Off Its Key Features',
  'Draw $y=x^2-4x+3$ for $0 \le x \le 4$ and identify its key features.',
  to_jsonb(array[
    'Build a table of values: $x=0: y=3$; $x=1: y=0$; $x=2: y=-1$; $x=3: y=0$; $x=4: y=3$.',
    'Plot the points $(0,3),(1,0),(2,-1),(3,0),(4,3)$ and join them with a smooth curve.',
    'Read off the roots (where the curve crosses the $x$-axis, $y=0$): $x=1$ and $x=3$.',
    'Confirm algebraically by factorizing: $x^2-4x+3=(x-1)(x-3)=0 \Rightarrow x=1$ or $3$ ✓.',
    'Find the vertex $x$-coordinate: $-b/(2a)=-(-4)/(2\times1)=2$.',
    'Find the vertex $y$-coordinate by substituting $x=2$: $y=4-8+3=-1$.',
    'Answer: vertex $(2,-1)$; roots at $x=1$ and $x=3$; $y$-intercept $(0,3)$.'
  ]),
  'The turning point''s x-coordinate is always -b/(2a), read it straight off the equation without completing the square.',
  null::text,
  null::text,
  'published'
from public.lessons l
where l.topic_id = (select t.id from public.topics t join public.curricula c on c.id = t.curriculum_id where c.subject = 'Mathematics' and t.class_level = 'SS2' and t.term = 1 and t.order_index = 107)
order by l.created_at desc limit 1;

insert into public.worked_examples (lesson_id, title, problem_statement, solution_steps, exam_shortcut, common_trap_warning, real_life_context, status)
select l.id,
  'Break-even Between Cost and Revenue (Thousands of Naira)',
  'A small business''s weekly cost is $C=x+2$ (in ₦''000, where $x$ is hundreds of items sold) and its revenue is $R=x^2-4x+6$ (in ₦''000). Find the sales levels $x$ at which cost equals revenue.',
  to_jsonb(array[
    'Set cost equal to revenue: $x+2=x^2-4x+6$.',
    'Rearrange to standard form: $x^2-5x+4=0$.',
    'Factorize: $(x-4)(x-1)=0 \Rightarrow x=4$ or $x=1$.',
    'Find the matching cost/revenue for each: $x=4 \Rightarrow C=₦6{,}000$; $x=1 \Rightarrow C=₦3{,}000$.',
    'Answer: cost equals revenue at $x=1$ (₦3,000) and $x=4$ (₦6,000) hundred items sold.'
  ]),
  null::text,
  null::text,
  'This mirrors how a small business compares a simple linear cost model against a more complex (quadratic) revenue model to find break-even sales volumes.',
  'published'
from public.lessons l
where l.topic_id = (select t.id from public.topics t join public.curricula c on c.id = t.curriculum_id where c.subject = 'Mathematics' and t.class_level = 'SS2' and t.term = 1 and t.order_index = 107)
order by l.created_at desc limit 1;

insert into public.questions (topic_id, lesson_id, question_text, question_latex, option_a, option_b, option_c, option_d, option_e, correct_letter, difficulty, exam_type, explanation, exam_shortcut, status)
select t.id, l.id, v.question_text, v.question_latex, v.option_a, v.option_b, v.option_c, v.option_d, v.option_e, v.correct_letter::char(1), v.difficulty::integer, v.exam_type::exam_type, v.explanation, v.exam_shortcut, 'published'
from public.topics t
join public.curricula c on c.id = t.curriculum_id
join public.lessons l on l.topic_id = t.id
cross join (values
  ('Solve: $y=x+2$, $y=x^2-4x+6$.', null::text, '(4,6) and (1,3)', '(4,6) and (-1,3)', '(3,5) and (1,3)', '(4,6) only', null::text, 'A', 3, 'GENERAL', 'Setting equal: $x^2-5x+4=0 \Rightarrow x=4$ or $1$, giving points (4,6) and (1,3).', null::text),
  ('Solve $y=x^2+1$, $y=2x+3$.', null::text, 'x = 3 or -1', '$x=1\pm\sqrt{3}$', '$x=2\pm\sqrt{2}$', '$x=1\pm2\sqrt{3}$', null::text, 'B', 4, 'GENERAL', '$x^2+1=2x+3 \Rightarrow x^2-2x-2=0 \Rightarrow x=\frac{2\pm\sqrt{12}}{2}=1\pm\sqrt{3}$.', null::text),
  ('Solve $y=x^2-x-2$, $y=x+1$.', null::text, '(2,3) or (-1,0)', '(3,4) or (0,1)', '(3,4) or (-1,0)', '(4,5) or (-2,-1)', null::text, 'C', 3, 'GENERAL', '$x^2-x-2=x+1 \Rightarrow x^2-2x-3=0 \Rightarrow (x-3)(x+1)=0 \Rightarrow x=3$ (y=4) or $x=-1$ (y=0).', null::text),
  ('Solve $y=x^2-2x+3$, $y=2x+1$.', null::text, '$x=1\pm\sqrt{2}$', '$x=3\pm\sqrt{2}$', '$x=2\pm2\sqrt{2}$', '$x=2\pm\sqrt{2}$', null::text, 'D', 4, 'GENERAL', '$x^2-4x+2=0 \Rightarrow x=\frac{4\pm\sqrt{8}}{2}=2\pm\sqrt{2}$.', null::text),
  ('Solve: (a) $y=x^2-4x+5$, $y=2x-1$ (b) $y=x^2+2x+1$, $y=x+3$.', null::text, '(a) $x=3\pm\sqrt{3}$ (b) $x=1$ or $-2$', '(a) $x=2\pm\sqrt{3}$ (b) $x=1$ or $-2$', '(a) $x=3\pm\sqrt{3}$ (b) $x=2$ or $-1$', '(a) $x=3\pm2\sqrt{3}$ (b) $x=1$ or $-2$', null::text, 'A', 4, 'GENERAL', '(a) $x^2-6x+6=0 \Rightarrow x=3\pm\sqrt{3}$. (b) $x^2+x-2=0=(x+2)(x-1) \Rightarrow x=1$ or $-2$.', null::text),
  ('Draw the graph of $y=x^2-4$ and identify its key features.', null::text, 'vertex (0,4), roots ±2', 'vertex (0,-4), roots x=±2, y-intercept -4', 'vertex (2,-4), roots 0,4', 'vertex (0,-4), roots ±4', null::text, 'B', 2, 'GENERAL', '$y=x^2-4$ has vertex $(0,-4)$, roots where $x^2=4 \Rightarrow x=\pm2$, y-intercept $-4$.', null::text),
  ('Draw $y=x^2-3x+2$ for $0\le x\le3$. State the minimum point.', null::text, '(1, 0)', '(2, 0)', '(1.5, -0.25)', '(1.5, 0.25)', null::text, 'C', 3, 'GENERAL', 'Vertex $x=-(-3)/(2)=1.5$; $y=1.5^2-3(1.5)+2=-0.25$.', null::text),
  ('From the graph of $y=x^2-4x+3$, find the roots, vertex, and y-intercept.', null::text, 'roots 0,3; vertex (1.5,-1); y-int 3', 'roots 1,4; vertex (2.5,-1); y-int 3', 'roots 1,3; vertex (2,1); y-int 3', 'roots 1,3; vertex (2,-1); y-int 3', null::text, 'D', 2, 'GENERAL', '$(x-1)(x-3)=0 \Rightarrow$ roots 1,3; vertex $x=2, y=-1$; y-intercept 3.', null::text),
  ('Draw $y=x^2+2x-3$ for $-4\le x\le2$. Find the vertex, axis of symmetry, roots, and range.', null::text, 'vertex (-1,-4), axis x=-1, roots x=-3,1, range y≥-4', 'vertex (1,-4), axis x=1, roots x=-3,1, range y≥-4', 'vertex (-1,4), axis x=-1, roots x=-3,1, range y≤-4', 'vertex (-1,-4), axis x=-1, roots x=-1,3, range y≥-4', null::text, 'A', 3, 'GENERAL', 'Vertex $x=-1$, $y=1-2-3=-4$; roots from $(x+3)(x-1)=0$: $x=-3,1$; since the parabola opens upward, range is $y\ge-4$.', null::text),
  ('Solve graphically: $y=x^2$, $y=2x+3$.', null::text, '(3,9) and (1,-1)', '(3,9) and (-1,1)', '(2,4) and (-1,1)', '(3,9) and (-1,-1)', null::text, 'B', 3, 'GENERAL', '$x^2-2x-3=0=(x-3)(x+1) \Rightarrow x=3$ (y=9) or $x=-1$ (y=1).', null::text)
) as v(question_text, question_latex, option_a, option_b, option_c, option_d, option_e, correct_letter, difficulty, exam_type, explanation, exam_shortcut)
where c.subject = 'Mathematics' and t.class_level = 'SS2' and t.term = 1 and t.order_index = 107;

-- ------------------------------------------
-- 108. STRAIGHT LINE GRAPHS: GRADIENT  -  SS2 Mathematics, Term 1
-- ------------------------------------------


with lesson as (
  insert into public.lessons (topic_id, title, summary, content_body, order_index)
  values (
    (select t.id from public.topics t join public.curricula c on c.id = t.curriculum_id where c.subject = 'Mathematics' and t.class_level = 'SS2' and t.term = 1 and t.order_index = 108),
    'Gradient of a Straight Line and of a Curve',
    'Finding the gradient of a line from two points or from its equation, reading intercepts, and estimating the gradient of a curve using a tangent.',
    '## Straight Line Graphs: Gradient

**Glossary**
- **Gradient (slope):** how steep a line is; for $y=mx+c$, $m$ is the gradient. Between two points, $m=\dfrac{y_2-y_1}{x_2-x_1}$.
- **y-intercept:** the point where a line crosses the y-axis, equal to $c$ in $y=mx+c$.
- **Tangent to a curve:** a straight line that touches a curve at exactly one point without crossing it there; the gradient of a curve at a point is defined as the gradient of its tangent at that point.

Parallel lines share the same gradient; perpendicular lines have gradients whose product is $-1$.',
    1
  )
  returning id
)
insert into public.worked_examples (lesson_id, title, problem_statement, solution_steps, exam_shortcut, common_trap_warning, real_life_context, diagram_type, diagram_data, status)
select id,
  'Sketching a Line and Reading Off Gradient and Intercepts',
  'Draw $y=3x-2$ for $-1 \le x \le 3$, and state its gradient and intercepts.',
  to_jsonb(array[
    'Build a table of values: $x=-1: y=-5$; $x=0: y=-2$; $x=1: y=1$; $x=2: y=4$; $x=3: y=7$.',
    'Plot the points and draw a straight line through them.',
    'Read the gradient directly from $y=mx+c$ (here $m=3$): confirm using two table points: $(7-(-5))/(3-(-1))=12/4=3$ ✓.',
    'Read the y-intercept (where $x=0$): $(0,-2)$.',
    'Find the x-intercept by setting $y=0$: $0=3x-2 \Rightarrow x=2/3$.',
    'Answer: gradient $=3$, y-intercept $(0,-2)$, x-intercept $(2/3,0)$.'
  ]),
  'Read the gradient straight from y=mx+c, never compute it from two table points if the equation is already in this form.',
  null::text,
  null::text,
  'coordinate_plane',
  '{"xRange": [-2, 4], "yRange": [-6, 8], "points": [{"x": -1, "y": -5, "label": "x=-1"}, {"x": 0, "y": -2, "label": "y-intercept"}, {"x": 3, "y": 7, "label": "x=3"}], "lines": [{"from": {"x": -1, "y": -5}, "to": {"x": 3, "y": 7}, "label": "y = 3x - 2"}]}'::jsonb,
  'published'
from lesson;

insert into public.worked_examples (lesson_id, title, problem_statement, solution_steps, exam_shortcut, common_trap_warning, real_life_context, diagram_type, diagram_data, status)
select l.id,
  'Estimating the Gradient of a Curve From a Tangent',
  'Draw the tangent to $y=x^2$ at the point (2, 4) and estimate its gradient.',
  to_jsonb(array[
    'Plot the curve $y=x^2$ using a table of values around $x=2$ (e.g. $x=0,1,2,3$ giving $y=0,1,4,9$), and mark the point $(2,4)$ on it.',
    'Draw a straight line that touches the curve only at $(2,4)$ without crossing it there, this is the tangent.',
    'Read off (or extend the tangent to find) a second convenient point it passes through, here the tangent passes through $(0,-4)$.',
    'Apply the gradient formula using the two points $(0,-4)$ and $(2,4)$: $m=(4-(-4))\div(2-0)=8\div2$.',
    'Divide: $8\div2=4$.',
    'Answer: gradient $\approx4$ (this matches the true calculus derivative $dy/dx=2x$ at $x=2$, which gives exactly 4, the tangent construction estimates this value graphically).'
  ]),
  'For tangent-gradient questions, pick two points on the tangent that are far apart, the further apart your two chosen points are, the smaller the effect of small drawing or reading errors on your final gradient estimate.',
  null::text,
  null::text,
  'coordinate_plane',
  '{"xRange": [-1, 4], "yRange": [-5, 10], "points": [{"x": 2, "y": 4, "label": "(2,4)"}, {"x": 0, "y": -4, "label": "tangent point"}], "lines": [{"from": {"x": 0, "y": -4}, "to": {"x": 3, "y": 8}, "label": "tangent, m=4"}]}'::jsonb,
  'published'
from public.lessons l
where l.topic_id = (select t.id from public.topics t join public.curricula c on c.id = t.curriculum_id where c.subject = 'Mathematics' and t.class_level = 'SS2' and t.term = 1 and t.order_index = 108)
order by l.created_at desc limit 1;

insert into public.worked_examples (lesson_id, title, problem_statement, solution_steps, exam_shortcut, common_trap_warning, real_life_context, diagram_type, diagram_data, status)
select l.id,
  'Comparing Two Taxi Fare Plans',
  'A taxi charges a fixed fee of ₦200 plus ₦50 per km; a second taxi charges ₦100 plus ₦75 per km. Find when their costs are equal.',
  to_jsonb(array[
    'Write a cost equation for each taxi in terms of distance $d$: Taxi A: $C=200+50d$; Taxi B: $C=100+75d$.',
    'Set the two expressions equal (this is exactly where the two lines cross on a graph): $200+50d=100+75d$.',
    'Collect the $d$-terms on one side and constants on the other: $200-100=75d-50d \Rightarrow 100=25d$.',
    'Solve for $d$: $d=100\div25=4$.',
    'Substitute $d=4$ into either cost equation: $C=200+50(4)=400$.',
    'Answer: the two taxis cost the same (₦400) at a distance of 4 km.'
  ]),
  '"When are the costs equal" graph questions are just simultaneous equations in disguise, skip the drawing and solve algebraically, then draw only to illustrate the answer.',
  null::text,
  'This is exactly how a commuter compares two taxi or ride-hailing fare structures to know at what trip distance one becomes cheaper than the other.',
  'coordinate_plane',
  '{"xRange": [0, 8], "yRange": [0, 700], "points": [{"x": 4, "y": 400, "label": "equal cost"}], "lines": [{"from": {"x": 0, "y": 200}, "to": {"x": 8, "y": 600}, "label": "Taxi A"}, {"from": {"x": 0, "y": 100}, "to": {"x": 8, "y": 700}, "label": "Taxi B"}]}'::jsonb,
  'published'
from public.lessons l
where l.topic_id = (select t.id from public.topics t join public.curricula c on c.id = t.curriculum_id where c.subject = 'Mathematics' and t.class_level = 'SS2' and t.term = 1 and t.order_index = 108)
order by l.created_at desc limit 1;

insert into public.worked_examples (lesson_id, title, problem_statement, solution_steps, exam_shortcut, common_trap_warning, real_life_context, diagram_type, diagram_data, status)
select l.id,
  'Comparing Two Phone Plans',
  'A phone plan costs ₦1000 monthly plus ₦5 per minute; another costs ₦500 plus ₦10 per minute. Find when the two plans cost the same, and state which is cheaper at 150 minutes.',
  to_jsonb(array[
    'Write a cost equation for each plan in terms of minutes $m$: Plan 1: $C=1000+5m$; Plan 2: $C=500+10m$.',
    'Set the two expressions equal: $1000+5m=500+10m$.',
    'Collect terms: $1000-500=10m-5m \Rightarrow 500=5m$.',
    'Solve for $m$: $m=100$.',
    'Find the common cost: $C=1000+5(100)=1500$.',
    'At 150 minutes: Plan 1 $=1000+5(150)=1750$; Plan 2 $=500+10(150)=2000$.',
    'Answer: the plans cost the same (₦1500) at 100 minutes; at 150 minutes, Plan 1 (₦1750) is cheaper than Plan 2 (₦2000).'
  ]),
  null::text,
  null::text,
  'This is the exact comparison a phone or data subscriber runs before choosing between a lower-base-fee plan with a higher per-minute rate and a higher-base-fee plan with a lower per-minute rate.',
  'coordinate_plane',
  '{"xRange": [0, 200], "yRange": [0, 2500], "points": [{"x": 100, "y": 1500, "label": "equal cost"}], "lines": [{"from": {"x": 0, "y": 1000}, "to": {"x": 200, "y": 2000}, "label": "Plan 1"}, {"from": {"x": 0, "y": 500}, "to": {"x": 200, "y": 2500}, "label": "Plan 2"}]}'::jsonb,
  'published'
from public.lessons l
where l.topic_id = (select t.id from public.topics t join public.curricula c on c.id = t.curriculum_id where c.subject = 'Mathematics' and t.class_level = 'SS2' and t.term = 1 and t.order_index = 108)
order by l.created_at desc limit 1;

insert into public.questions (topic_id, lesson_id, question_text, question_latex, option_a, option_b, option_c, option_d, option_e, correct_letter, difficulty, exam_type, explanation, exam_shortcut, status)
select t.id, l.id, v.question_text, v.question_latex, v.option_a, v.option_b, v.option_c, v.option_d, v.option_e, v.correct_letter::char(1), v.difficulty::integer, v.exam_type::exam_type, v.explanation, v.exam_shortcut, 'published'
from public.topics t
join public.curricula c on c.id = t.curriculum_id
join public.lessons l on l.topic_id = t.id
cross join (values
  ('Draw the graph of $y=3x-2$ for $-1 \le x \le 3$ and state its gradient and intercepts.', null::text, 'gradient 3, y-intercept (0,-2), x-intercept (2/3,0)', 'gradient 3, y-intercept (0,2), x-intercept (-2/3,0)', 'gradient -3, y-intercept (0,-2), x-intercept (2/3,0)', 'gradient 2, y-intercept (0,-3), x-intercept (3/2,0)', null::text, 'A', 2, 'GENERAL', 'Comparing to $y=mx+c$: gradient $=3$, y-intercept $=-2$; setting $y=0$ gives x-intercept $2/3$.', null::text),
  ('Draw the tangent to the curve $y=x^2$ at the point (2, 4) and estimate its gradient.', null::text, 'gradient ≈ 2', 'gradient ≈ 4', 'gradient ≈ 8', 'gradient ≈ 1', null::text, 'B', 3, 'GENERAL', 'A carefully drawn tangent at (2,4) passes close to (0,-4); gradient $=(4-(-4))/(2-0)=4$.', null::text),
  ('Draw the graph of $y=2x-3$ for a chosen domain and state its gradient and y-intercept.', null::text, 'gradient 3, y-int -2', 'gradient -2, y-int 3', 'gradient 2, y-intercept (0,-3)', 'gradient 2, y-intercept (0,3)', null::text, 'C', 1, 'GENERAL', 'Comparing to $y=mx+c$: gradient $=2$, y-intercept $=-3$.', null::text),
  ('Draw the graph of $y=3x+2$ for $-2 \le x \le 2$ and state its gradient and y-intercept.', null::text, 'gradient 2, y-int 3', 'gradient -3, y-int 2', 'gradient 3, y-int -2', 'gradient 3, y-intercept (0,2)', null::text, 'D', 1, 'GENERAL', 'Comparing to $y=mx+c$: gradient $=3$, y-intercept $=2$.', null::text),
  ('Find the gradients of, for $-3 \le x \le 3$: (a) $y=x-2$ (b) $y=-2x+1$ (c) $y=\frac{1}{2}x+3$.', null::text, '(a) 1 (b) -2 (c) 1/2', '(a) -1 (b) 2 (c) -1/2', '(a) 1 (b) 2 (c) 1/2', '(a) 2 (b) -2 (c) 1', null::text, 'A', 1, 'GENERAL', 'Each gradient is the coefficient of x: 1, -2, and 1/2 respectively.', null::text),
  ('A company charges a ₦500 setup fee plus ₦100/hour; another charges ₦300 plus ₦150/hour. Find when their costs are equal.', null::text, '3 hours, ₦800', '4 hours, ₦900', '5 hours, ₦1000', '4 hours, ₦800', null::text, 'B', 2, 'GENERAL', '$500+100h=300+150h \Rightarrow 200=50h \Rightarrow h=4$; cost $=500+400=900$.', null::text),
  ('A phone plan costs ₦1000 monthly plus ₦5/minute; another costs ₦500 plus ₦10/minute. Find when the costs are equal, and which is better at 150 minutes.', null::text, 'equal at 80 min; plan 2 cheaper at 150 min', 'equal at 120 min; plan 1 cheaper at 150 min', 'equal at 100 min (₦1500); plan 1 cheaper at 150 min (₦1750 vs ₦2000)', 'equal at 100 min (₦1500); plan 2 cheaper at 150 min', null::text, 'C', 3, 'GENERAL', '$1000+5m=500+10m \Rightarrow m=100$, cost ₦1500; at 150 min: plan 1 = ₦1750, plan 2 = ₦2000, so plan 1 is cheaper.', null::text),
  ('A taxi charges a fixed fee of ₦200 plus ₦50/km; a second taxi charges ₦100 plus ₦75/km. Find when the costs are equal.', null::text, '3 km, ₦350', '5 km, ₦450', '4 km, ₦350', '4 km, ₦400', null::text, 'D', 2, 'GENERAL', '$200+50d=100+75d \Rightarrow d=4$; cost $=200+200=400$.', null::text),
  ('Using the two points (0,1) and (2,5) on a drawn line, calculate the gradient.', null::text, '2', '4', '1', '0.5', null::text, 'A', 1, 'GENERAL', '$m=(5-1)/(2-0)=4/2=2$.', null::text),
  ('Draw $y=x+1$ and $y=5-x$ on the same axes and solve graphically.', null::text, '(1, 4)', '(2, 3)', '(3, 2)', '(2, 4)', null::text, 'B', 2, 'GENERAL', '$x+1=5-x \Rightarrow 2x=4 \Rightarrow x=2$, $y=3$.', null::text)
) as v(question_text, question_latex, option_a, option_b, option_c, option_d, option_e, correct_letter, difficulty, exam_type, explanation, exam_shortcut)
where c.subject = 'Mathematics' and t.class_level = 'SS2' and t.term = 1 and t.order_index = 108;
