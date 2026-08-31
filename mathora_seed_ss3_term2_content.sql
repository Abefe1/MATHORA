-- ==========================================
-- MATHORA: SS3 Mathematics, Second Term: Full Content Seed
-- (6 topics, order_index 201-206)
--
-- Source of truth for all teaching notes, worked examples and exercise
-- questions: SS1-SS3_MATHEMATICS_CURATED.md ("SS3 Mathematics" >
-- "Second Term", Weeks 1-6). This term has a clean 1:1 mapping between
-- the curated file's weeks and the topic rows already seeded by
-- mathora_seed_topics_ss1_ss2_ss3.sql (no split/merged weeks, unlike
-- some other terms in this project):
--   Week 1 -> topic 201 (Interest on Bonds & Debentures; Taxes & VAT)
--   Week 2 -> topic 202 (Coordinate Geometry: Distance & Midpoint)
--   Week 3 -> topic 203 (Coordinate Geometry: Gradient, Intercepts &
--     Angle Between Lines)
--   Week 4 -> topic 204 (Differentiation: First Principles & Standard
--     Derivatives)
--   Week 5 -> topic 205 (Differentiation: Rules, Maxima & Minima)
--   Week 6 -> topic 206 (Integration of Algebraic Functions)
-- Every week has a non-empty Gamified Exercise Bank, so no topic is
-- skipped as a pure review week.
--
-- Run after (in order, from a bare schema):
--   mathora_schema.sql
--   mathora_schema_auth_patch.sql
--   mathora_schema_topics_term_patch.sql
--   mathora_schema_content_pipeline_patch.sql
--   mathora_schema_diagrams_patch.sql
--   mathora_schema_five_option_patch.sql   (adds questions.option_e and
--                                           widens correct_letter to
--                                           A-E; not actually needed by
--                                           this particular file, every
--                                           question below is a clean
--                                           4-option MCQ, but it is a
--                                           required prerequisite in
--                                           the project's standard run
--                                           order regardless)
--   mathora_seed_topics_ss1_ss2_ss3.sql    (creates the topic rows this
--                                           file references by subquery,
--                                           never by hardcoded UUID)
--   mathora_seed_exemplar_lessons.sql      (does not touch SS3 Term 2,
--                                           no overlap with this file)
--   mathora_seed_ss3_term2_content.sql     (this file)
--
-- Diagram usage: topics 202 and 203 (Coordinate Geometry) use the
-- 'coordinate_plane' diagram_type on several worked examples, plotting
-- the points/lines/tangents involved, since that is a genuine visual
-- aid for this topic and 'coordinate_plane' is a supported type in
-- mathora-web/src/lib/diagramTypes.ts. Topics 201 (bonds/tax/VAT),
-- 204 (differentiation from first principles), 205 (differentiation
-- rules/optimisation) and 206 (integration) are pure algebra/arithmetic
-- with no natural static geometric figure to draw, so diagram_type is
-- left at its 'none' default there, per the standing instruction not
-- to force a diagram onto a topic that does not call for one.
--
-- exam_type rationale: the curated Week 2 (topic 202) exercise bank
-- explicitly tags exactly two exercise-bank questions as "WAEC style"
-- in their own question text (Q13 and Q14, both classic 3-4-5-type
-- distance questions already given as A-D MCQs in the source); those
-- two, and only those two, are seeded here with exam_type = 'WAEC'.
-- Every other question in this file (including several other already-
-- lettered A-D questions elsewhere in Weeks 2 and 3 that are NOT
-- explicitly tagged "WAEC style" in the source text) uses the safe
-- default exam_type = 'GENERAL', per the instruction that the WAEC tag
-- is reserved for questions the curated source itself explicitly marks
-- as a real past WAEC/NECO/NABTEB question, not merely "exam-style".
--
-- Every stated answer below was re-derived by hand against the curated
-- source before being written into this file (per the standing
-- instruction that the curated file has had real errors caught before:
-- bad factorisations, wrong AP/GP terms, OCR corruption, bad option
-- letters, sign errors in differentiation/integration). Genuinely new
-- corrections found and fixed during THIS pass (each shown with the
-- re-derivation that justifies it):
--
--   1. Week 1 / topic 201, Q4: "A worker earns N1,800,000 annually;
--      after N300,000 tax-free allowance, 10% on the first N500,000,
--      15% on the remainder; find the tax payable." Taxable income =
--      1,800,000 - 300,000 = 1,500,000. Band 1: 500,000 * 10% =
--      50,000. Band 2 (remainder): 1,000,000 * 15% = 150,000. Total =
--      200,000. The curated source states 125,000, which does not
--      match this band-by-band computation under any consistent
--      reading of the stated bands; corrected to N200,000 below, with
--      the source's original value kept as one of the wrong-answer
--      distractors (a plausible error: applying 15% to only part of
--      the true remainder).
--   2. Week 3 / topic 203, Q21: "The gradient of the line joining
--      (x,4) and (1,2) is 1/2. Find x." Gradient = (2-4)/(1-x) = 1/2
--      => -2 = 0.5(1-x) => -4 = 1-x => x = 5. Checking: points (5,4)
--      and (1,2) give gradient (4-2)/(5-1) = 1/2, confirmed. The
--      curated source states x = -3, which does not satisfy the given
--      gradient; corrected to x = 5 below (the source's value is kept
--      as a distractor).
--   3. Week 3 / topic 203, Q24: "What is P if the gradient of the line
--      joining (-1,P) and (P,4) is 2/3?" Gradient = (4-P)/(P+1) = 2/3
--      => 3(4-P) = 2(P+1) => 12-3P = 2P+2 => 10 = 5P => P = 2.
--      Checking: points (-1,2) and (2,4) give gradient (4-2)/(2+1) =
--      2/3, confirmed. The curated source states P = 1, which does not
--      satisfy the given gradient; corrected to P = 2 below (the
--      source's value is kept as a distractor).
--   4. Week 5 / topic 205, Q11(b): "Differentiate y=(3x+1)(2x^2+5x-3)
--      using the product rule." u=3x+1, du/dx=3; v=2x^2+5x-3,
--      dv/dx=4x+5. dy/dx = (3x+1)(4x+5) + 3(2x^2+5x-3) =
--      (12x^2+19x+5) + (6x^2+15x-9) = 18x^2+34x-4. Confirmed by
--      expanding the product first (y = 6x^3+17x^2-4x-3) and
--      differentiating directly: dy/dx = 18x^2+34x-4, matching. The
--      curated source states 18x^2+22x-13; corrected below (the
--      source's value is kept as a tempting distractor).
--   5. Week 5 / topic 205, Q25: "Rectangular garden fenced on 3 sides
--      (4th is a wall), 60m fencing; find dimensions for max area."
--      Let w = each of the two perpendicular sides, l = the side
--      parallel to the wall: 2w+l=60 => l=60-2w. Area A(w)=w(60-2w)=
--      60w-2w^2. dA/dw=60-4w=0 => w=15, l=30, area=15*30=450 m^2. The
--      curated source states "width=30m (perpendicular), length=30m
--      (parallel), area=450m^2", which is internally inconsistent
--      (2(30)+30=90m of fencing, not the given 60m, and 30x30 would
--      give area 900m^2, not 450m^2). Corrected to width (perpendicular
--      sides) = 15m, length (parallel to wall) = 30m, area = 450m^2
--      below (the source's inconsistent dimension pair is kept as a
--      distractor, since it does reproduce the source's stated area).
--   6. Week 5 / topic 205, Q38: "30m of fencing wire makes a
--      rectangular enclosure; find the maximum area possible." Standard
--      4-sided rectangle: 2(x+y)=30 => x+y=15, maximised (for fixed
--      perimeter) at x=y=7.5, area=7.5*7.5=56.25 m^2. The curated
--      source states "225m^2, at 7.5m x 7.5m", which is arithmetically
--      inconsistent (7.5 x 7.5 = 56.25, not 225). Corrected to 56.25
--      m^2 below (the source's inconsistent 225m^2 figure is kept as a
--      distractor).
--   7. Week 6 / topic 206, Q23: "Position s=integral(4t+3)dt; s=10 when
--      t=2; find s when t=5." s(t)=2t^2+3t+C. At t=2: 2(4)+3(2)+C=10
--      => 14+C=10 => C=-4 (not -12 as the source states). s(t)=
--      2t^2+3t-4. s(5)=2(25)+15-4=61 (not 53 as the source states).
--      Corrected to s(5)=61 below (the source's original 53 is kept as
--      a distractor).
--   8. Week 6 / topic 206, Q30: "Evaluate integral from 0 to pi/2 of
--      2sin(2x)dx." Antiderivative of 2sin(2x) is -cos(2x) (check:
--      d/dx[-cos(2x)] = 2sin(2x), confirmed). [-cos(2x)] from 0 to
--      pi/2 = -cos(pi) - (-cos(0)) = 1 - (-1) = 2. The curated source
--      states the answer is 0; corrected to 2 below (0 is kept as a
--      distractor, since it is the answer a student gets by mistakenly
--      treating this as a full-period integral of sine).
--   9. Week 6 / topic 206, Q35: "Sketch y=8x-x^2-12; find the area of
--      the finite region bounded by the curve and the x-axis." Roots:
--      -x^2+8x-12=0 => x^2-8x+12=0 => (x-2)(x-6)=0 => x=2, x=6 (a
--      downward parabola, vertex at x=4, peak height y(4)=32-16-12=4).
--      Parabolic-arch area = (2/3) * base * height = (2/3)(4)(4) =
--      32/3 square units (confirmed directly by evaluating
--      [4x^2-x^3/3-12x] from 2 to 6 = 0 - (-32/3) = 32/3). The curated
--      source states 64/3; corrected to 32/3 below (64/3, exactly
--      double, is kept as a distractor, being the answer a student
--      gets by forgetting the (2/3) factor and using base*height
--      directly then halving incorrectly, or an equivalent doubling
--      slip).
--
-- Pre-existing corrections already made by an earlier pass of the
-- curated source itself (kept as-is here, re-verified by hand, not
-- re-derived from scratch a second time): Week 1 Q15 (tax remainder
-- corrected to N1,000,000, total tax N665,000); Week 2 Q9 (closest
-- towns corrected to Y and Z, not X and Z); Week 5 Q19 (absolute
-- extrema on a restricted domain corrected to account for the domain
-- endpoints beating the interior local maximum); Week 6 Q16(b), Q21,
-- Q32 and Q34 (each already corrected/derived in the source itself,
-- confirmed independently here).
-- ==========================================

-- ------------------------------------------
-- 201. INTEREST ON BONDS & DEBENTURES; TAXES AND VAT
-- ------------------------------------------

with lesson as (
  insert into public.lessons (topic_id, title, summary, content_body, order_index)
  values (
    (select t.id from public.topics t join public.curricula c on c.id = t.curriculum_id
     where c.subject = 'Mathematics' and t.class_level = 'SS3' and t.term = 2 and t.order_index = 201),
    'Interest on Bonds and Debentures; Taxes and VAT',
    'Calculating interest on bonds and debentures, dividends on shares, progressive income tax by band, and Nigeria''s 7.5% VAT, both adding it to a price and stripping it back out.',
    '### Bonds

A **bond** is a debt security: an investor lends money to a government or company for a fixed period at a fixed rate (the **coupon rate**). Key terms: **Face value** (the amount repaid at maturity), **Coupon rate** (the fixed annual interest rate, always applied to the face value), **Maturity date** (when the principal is repaid), **Current yield** (annual interest divided by the bond''s current market price, not its face value).

$$\text{Annual interest} = \text{Face value} \times \text{Coupon rate}$$
$$\text{Current yield} = \frac{\text{Annual interest}}{\text{Current market price}} \times 100\%$$

**Speed check**: coupon rate always uses face value on the bottom; current yield always uses market price on the bottom. If a bond sells below face value, its current yield is always higher than its coupon rate, and vice versa, a fast sanity check on your answer.

### Debentures

A **debenture** is an unsecured debt instrument, backed only by the issuer''s general creditworthiness (no collateral), usually at a lower rate than a secured bond, but with priority over ordinary shareholders if the company is wound up.

$$\text{Total repayment at maturity} = \text{Principal} + (\text{Annual interest} \times \text{Number of years})$$

### Shares and Dividends

**Ordinary shares** carry voting rights, but their dividend is never guaranteed. **Preference shares** pay a fixed dividend rate with priority over ordinary shares, but usually no vote. The **nominal (par) value** is a share''s face value; the **market value** is what it currently trades for on the exchange, these are usually different numbers.

$$\text{Dividend per share} = \text{Nominal value} \times \text{Dividend rate}$$
$$\text{Rate of return (dividend yield)} = \frac{\text{Dividend per share}}{\text{Market price}} \times 100\%$$

### Nigerian Income Tax (Progressive Bands)

Taxable income is gross income minus allowable deductions (e.g. the Consolidated Relief Allowance, commonly 20% of gross income plus a flat amount). Tax is then applied **progressively in bands**, each band''s rate applies only to the slice of income that falls inside that band, never to the whole income. Any income left over after every stated band is taxed at a final **remainder rate**, never leave this last slice untaxed.

**Golden rule**: work band by band from the bottom up, and always check how much of the taxable income is left after the stated bands, that leftover goes into the remainder rate, it is the single most commonly forgotten step.

### VAT (Value Added Tax, Nigeria: 7.5%)

$$\text{VAT} = \text{Price} \times \text{VAT rate}$$
$$\text{Price including VAT} = \text{Original price} \times (1 + \text{VAT rate})$$

To strip VAT back out of a VAT-inclusive price, **divide by $(1 + \text{VAT rate})$**, never simply subtract 7.5% of the inclusive price, that undercounts the original price because 7.5% of the bigger (inclusive) number is a bigger amount than 7.5% of the smaller (original) number.

**Mental-math shortcut for 7.5%**: 7.5% is 10% minus a quarter of that 10%. For a price of ₦250,000: 10% is ₦25,000; a quarter of that is ₦6,250; VAT is ₦25,000 minus ₦6,250 equals ₦18,750, computed entirely in your head.

### Glossary

- **Bond**: a loan you make to a government or company, in exchange they pay you a fixed yearly interest and give your money back at a set future date. Buying a ₦100,000 government bond is like lending the government ₦100,000 and being paid rent on that loan every year.
- **Coupon rate**: the fixed percentage rate printed on the bond itself, always calculated on the face value, not on whatever price the bond currently trades for.
- **Debenture**: a company loan with no collateral behind it, just the company''s promise to pay, riskier than a bond backed by specific assets.
- **Dividend**: a company''s payout to its shareholders out of its profits, like a bonus paid per share owned.
- **Progressive tax band**: a slice of income taxed at its own rate, e.g. the first ₦300,000 might be tax-free, the next ₦300,000 taxed at 7%, and so on, never one flat rate on the whole income.
- **VAT (Value Added Tax)**: a Nigerian government tax of 7.5% added onto the price of most goods and services. If a phone costs ₦100,000 before VAT, you actually pay ₦107,500 at the till.',
    1
  )
  returning id
)
insert into public.worked_examples (lesson_id, title, problem_statement, solution_steps, exam_shortcut, real_life_context, status)
select id,
  'Interest on a Government Bond',
  'A government bond has face value ₦100,000, coupon rate 12% per annum, and matures in 5 years. Find (a) the annual interest, (b) the total interest earned over the bond''s life.',
  to_jsonb(array[
    'State the formula: Annual interest = Face value times Coupon rate.',
    'Substitute for (a): $100{,}000 \times 12\% = 100{,}000 \times 0.12 = ₦12{,}000$ per year.',
    'For (b), multiply the annual interest by the number of years: Total interest = $12{,}000 \times 5 = ₦60{,}000$.'
  ]),
  'Coupon rate always multiplies the face value directly, never the market price, so this calculation never needs the bond''s current selling price at all.',
  'This is exactly the calculation a Nigerian civil servant or small investor does before buying a Federal Government of Nigeria (FGN) savings bond: knowing the face value and coupon rate up front tells you your guaranteed yearly income for the life of the bond.',
  'published'
from lesson;

insert into public.worked_examples (lesson_id, title, problem_statement, solution_steps, exam_shortcut, common_trap_warning, real_life_context, status)
select l.id,
  'Current Yield on a Discounted Bond',
  'A bond with face value ₦50,000 and coupon rate 10% is currently selling at ₦45,000. Find its current yield.',
  to_jsonb(array[
    'Find the annual interest, always using the face value, not the market price: $50{,}000 \times 10\% = ₦5{,}000$.',
    'Apply the current yield formula: Current yield $= \frac{\text{Annual interest}}{\text{Current market price}} \times 100\%$.',
    'Substitute: $\frac{5{,}000}{45{,}000} \times 100\% = 11.11\%$ (to 2 decimal places).'
  ]),
  'Sanity check: this bond sells BELOW its face value (₦45,000 < ₦50,000), so its current yield (11.11%) should be HIGHER than its coupon rate (10%). It is, confirming the answer is at least plausible.',
  'A very common mistake is dividing the annual interest by the FACE value (giving back the coupon rate, 10%) instead of the CURRENT MARKET PRICE, current yield always uses whatever the bond is actually selling for right now.',
  'This is how a bond trader on the Nigerian Exchange (NGX) fixed-income desk compares two bonds trading at different discounts to decide which gives a better real return today.',
  'published'
from public.lessons l join public.topics t on t.id = l.topic_id join public.curricula c on c.id = t.curriculum_id
where c.subject = 'Mathematics' and t.class_level = 'SS3' and t.term = 2 and t.order_index = 201;

insert into public.worked_examples (lesson_id, title, problem_statement, solution_steps, exam_shortcut, common_trap_warning, real_life_context, status)
select l.id,
  'Removing VAT from a Restaurant Bill',
  'A restaurant bill including 7.5% VAT comes to ₦21,500. Find the cost before VAT was added.',
  to_jsonb(array[
    'Let the pre-VAT cost be $x$. Since VAT is added on top of $x$: $x + 0.075x = 21{,}500$.',
    'Simplify the left side: $1.075x = 21{,}500$.',
    'Solve for $x$: $x = \frac{21{,}500}{1.075} = ₦20{,}000$.',
    'Check by finding the VAT amount: $21{,}500 - 20{,}000 = ₦1{,}500$, and $20{,}000 \times 0.075 = 1{,}500$ ✓.'
  ]),
  'Never subtract 7.5% of the ₦21,500 inclusive figure directly, that gives ₦19,887.50, the wrong answer. Always divide the inclusive price by 1.075 instead.',
  'The single most common VAT-removal error: 7.5% of the BIGGER (VAT-inclusive) number is a bigger naira amount than 7.5% of the smaller (pre-VAT) number, so subtracting 7.5% of the inclusive price always under-corrects.',
  'This is exactly the check a customer or a small business accountant runs on a supplier invoice quoted "VAT inclusive" to confirm how much of the bill is genuinely goods and services versus government tax.',
  'published'
from public.lessons l join public.topics t on t.id = l.topic_id join public.curricula c on c.id = t.curriculum_id
where c.subject = 'Mathematics' and t.class_level = 'SS3' and t.term = 2 and t.order_index = 201;

insert into public.worked_examples (lesson_id, title, problem_statement, solution_steps, exam_shortcut, common_trap_warning, real_life_context, status)
select l.id,
  'Progressive Income Tax by Band',
  'A worker earns ₦3,600,000 per year. The first ₦300,000 is tax-free; then 7% on the next ₦300,000; 11% on the next ₦500,000; 15% on the next ₦500,000; 19% on the next ₦1,600,000; and 21% on the remainder. Find the total tax payable.',
  to_jsonb(array[
    'Find the taxable income after the tax-free allowance: $3{,}600{,}000 - 300{,}000 = ₦3{,}300{,}000$.',
    'Tax the first ₦300,000 of the taxable income at 7%: $300{,}000 \times 7\% = ₦21{,}000$.',
    'Tax the next ₦500,000 at 11%: $500{,}000 \times 11\% = ₦55{,}000$.',
    'Tax the next ₦500,000 at 15%: $500{,}000 \times 15\% = ₦75{,}000$.',
    'Tax the next ₦1,600,000 at 19%: $1{,}600{,}000 \times 19\% = ₦304{,}000$.',
    'Find how much taxable income is left for the remainder band: bands used so far $= 300{,}000+500{,}000+500{,}000+1{,}600{,}000 = ₦2{,}900{,}000$; remainder $= 3{,}300{,}000 - 2{,}900{,}000 = ₦400{,}000$, taxed at 21%: $400{,}000 \times 21\% = ₦84{,}000$.',
    'Add every band''s tax together: $21{,}000+55{,}000+75{,}000+304{,}000+84{,}000 = ₦539{,}000$.'
  ]),
  'Never apply one single rate to the whole taxable income, work strictly band by band from the bottom up, and always check what is left over for the final remainder band, it is the step students most often skip.',
  'A very common exam error is forgetting the remainder band entirely and stopping after the last STATED band, silently leaving a slice of income untaxed.',
  'This is exactly how a salaried worker''s PAYE (Pay As You Earn) tax is calculated on a Nigerian payslip every month, understanding the bands explains why a raise never all disappears at the highest rate, only the new top slice is taxed there.',
  'published'
from public.lessons l join public.topics t on t.id = l.topic_id join public.curricula c on c.id = t.curriculum_id
where c.subject = 'Mathematics' and t.class_level = 'SS3' and t.term = 2 and t.order_index = 201;

insert into public.questions (topic_id, lesson_id, question_text, option_a, option_b, option_c, option_d, correct_letter, difficulty, exam_type, explanation, status)
select t.id, l.id, q.question_text, q.option_a, q.option_b, q.option_c, q.option_d, q.correct_letter, q.difficulty, q.exam_type::exam_type, q.explanation, 'published'
from public.topics t
  join public.curricula c on c.id = t.curriculum_id
  join public.lessons l on l.topic_id = t.id,
  (values
  ('A bond with face value ₦80,000 pays 9% annual interest. Find the annual interest payment.', '₦7,200', '₦7,000', '₦8,000', '₦720', 'A', 1, 'GENERAL', 'Annual interest = Face value times coupon rate = 80,000 times 0.09 = ₦7,200.'),
  ('An investor buys 800 shares at ₦35 each. The company pays a 12% dividend on a ₦40 nominal value. Find the total dividend received.', '₦3,360', '₦3,840', '₦4,800', '₦2,800', 'B', 3, 'GENERAL', 'Dividend per share uses the nominal value, not the market price: 40 times 12% = ₦4.80 per share. Total dividend = 800 times 4.80 = ₦3,840. Using the ₦35 market price instead (a common error) wrongly gives ₦3,360.'),
  ('Calculate the VAT on goods worth ₦150,000 at the standard 7.5% VAT rate.', '₦15,000', '₦11,000', '₦11,250', '₦18,750', 'C', 1, 'GENERAL', 'VAT = Price times VAT rate = 150,000 times 0.075 = ₦11,250.'),
  ('A worker earns ₦1,800,000 annually. After a ₦300,000 tax-free allowance, 10% is charged on the first ₦500,000 of taxable income and 15% on the remainder. Find the tax payable.', '₦245,000', '₦175,000', '₦150,000', '₦200,000', 'D', 3, 'GENERAL', 'Taxable income = 1,800,000 minus 300,000 = ₦1,500,000. First band: 500,000 times 10% = ₦50,000. Remainder: 1,000,000 times 15% = ₦150,000. Total = ₦200,000. (Corrected: the curated source states ₦125,000, which does not match a band-by-band computation under any consistent reading of the stated bands.)'),
  ('A shop sells an item for ₦53,750, VAT-inclusive at 7.5%. Find the price before VAT.', '₦50,000', '₦49,719', '₦46,250', '₦43,000', 'A', 2, 'GENERAL', 'Dividing out the VAT: 53,750 divided by 1.075 = ₦50,000. Subtracting 7.5% of the inclusive price directly (a common error) wrongly gives about ₦49,719.'),
  ('Shares with a ₦25 nominal value pay a 16% dividend and were purchased at ₦30. Find the rate of return.', '16%', '13.33%', '20%', '12%', 'B', 3, 'GENERAL', 'Dividend per share = 25 times 16% = ₦4. Rate of return = dividend divided by the PURCHASE price = 4 divided by 30 = 13.33%, not the nominal-value-based 16%.'),
  ('Using compound interest, find the amount when ₦25,000 is invested at 12% compound interest for 4 years.', '₦37,000', '₦35,123', '₦39,338', '₦42,000', 'C', 3, 'GENERAL', 'A = P(1+r)^n = 25,000 times 1.12^4 = 25,000 times 1.5735 = approximately ₦39,338. Using simple interest instead (a common error) wrongly gives ₦37,000.'),
  ('A company issues debentures worth ₦2,000,000 at 7% for 8 years. Calculate the total interest payable.', '₦140,000', '₦1,280,000', '₦3,120,000', '₦1,120,000', 'D', 2, 'GENERAL', 'Total interest = Principal times rate times years = 2,000,000 times 0.07 times 8 = ₦1,120,000. Forgetting to multiply by the number of years (a common error) wrongly gives only ₦140,000.'),
  ('Calculate the current yield on a ₦100,000 bond with a 10% coupon rate, currently selling at ₦95,000.', '10.53%', '10%', '11%', '9.5%', 'A', 2, 'GENERAL', 'Annual interest = 100,000 times 10% = ₦10,000 (always on face value). Current yield = 10,000 divided by 95,000 (the market price) times 100% = 10.53%.'),
  ('An investor owns 500 preference shares paying an 8% dividend on a ₦50 nominal value. Calculate the annual dividend.', '₦200', '₦2,000', '₦4,000', '₦1,600', 'B', 2, 'GENERAL', 'Dividend per share = 50 times 8% = ₦4. Total dividend = 500 times 4 = ₦2,000.'),
  ('A government bond with face value ₦250,000 and coupon rate 11% matures in 7 years. Find (i) the annual interest, (ii) the total interest over the bond''s life, (iii) the total received at maturity.', '(i) ₦27,500 (ii) ₦137,500 (iii) ₦387,500', '(i) ₦27,500 (ii) ₦192,500 (iii) ₦250,000', '(i) ₦27,500 (ii) ₦192,500 (iii) ₦442,500', '(i) ₦55,000 (ii) ₦385,000 (iii) ₦635,000', 'C', 3, 'GENERAL', 'Annual interest = 250,000 times 11% = ₦27,500. Total interest over 7 years = 27,500 times 7 = ₦192,500. Total at maturity = face value plus total interest = 250,000 plus 192,500 = ₦442,500.'),
  ('A corporate bond has face value ₦100,000, a 9% coupon rate, and is selling at ₦92,000. Find (i) the current yield, (ii) the annual interest for 5 such bonds.', '(i) 9% (ii) ₦45,000', '(i) 9.78% (ii) ₦9,000', '(i) 10.87% (ii) ₦50,000', '(i) 9.78% (ii) ₦45,000', 'D', 3, 'GENERAL', 'Annual interest per bond = 100,000 times 9% = ₦9,000. Current yield = 9,000 divided by 92,000 = 9.78% (not the coupon rate, 9%). Annual interest for 5 bonds = 9,000 times 5 = ₦45,000.'),
  ('An investor buys 2,500 shares at ₦48 each. The company declares a 20% dividend on a ₦40 nominal value. Find (i) the total investment, (ii) the dividend per share, (iii) the total dividend, (iv) the rate of return.', '(i) ₦120,000 (ii) ₦8 (iii) ₦20,000 (iv) 16.67%', '(i) ₦120,000 (ii) ₦9.60 (iii) ₦24,000 (iv) 20%', '(i) ₦100,000 (ii) ₦8 (iii) ₦20,000 (iv) 20%', '(i) ₦120,000 (ii) ₦8 (iii) ₦16,000 (iv) 13.33%', 'A', 4, 'GENERAL', 'Total investment = 2,500 times 48 = ₦120,000. Dividend per share = 40 times 20% = ₦8. Total dividend = 2,500 times 8 = ₦20,000. Rate of return = dividend per share divided by PURCHASE price = 8 divided by 48 = 16.67%.'),
  ('A company has 5,000,000 shares of ₦10 nominal value and declares a 15% dividend. If you own 0.5% of the company, how much dividend do you receive?', '₦375,000', '₦37,500', '₦250,000', '₦75,000', 'B', 3, 'GENERAL', 'Dividend per share = 10 times 15% = ₦1.50. Total dividend pool = 5,000,000 times 1.50 = ₦7,500,000. Your 0.5% share = 7,500,000 times 0.005 = ₦37,500.'),
  ('Calculate the tax on an annual income of ₦4,200,000 with bands: first ₦300,000 free; next ₦300,000 at 7%; next ₦500,000 at 11%; next ₦500,000 at 15%; next ₦1,600,000 at 19%; remainder at 21%.', '₦644,000', '₦700,000', '₦665,000', '₦620,000', 'C', 4, 'GENERAL', 'Taxable income after the free band = 3,900,000. Stated bands use 300,000+500,000+500,000+1,600,000 = 2,900,000, leaving a remainder of 1,000,000 taxed at 21% = 210,000. Total = 21,000+55,000+75,000+304,000+210,000 = ₦665,000. (Using a remainder of ₦900,000 instead of the correct ₦1,000,000, an error the curated source itself flags and corrects, wrongly gives ₦644,000.)'),
  ('An employee earns ₦350,000 monthly. The annual consolidated relief allowance is 20% of gross income plus ₦200,000. Find (i) the annual gross income, (ii) the total relief, (iii) the taxable income.', '(i) ₦4,200,000 (ii) ₦840,000 (iii) ₦3,360,000', '(i) ₦4,200,000 (ii) ₦1,040,000 (iii) ₦3,360,000', '(i) ₦4,200,000 (ii) ₦900,000 (iii) ₦3,300,000', '(i) ₦4,200,000 (ii) ₦1,040,000 (iii) ₦3,160,000', 'D', 3, 'GENERAL', 'Annual gross = 350,000 times 12 = ₦4,200,000. Relief = (20% times 4,200,000) plus 200,000 = 840,000 plus 200,000 = ₦1,040,000. Taxable income = 4,200,000 minus 1,040,000 = ₦3,160,000.'),
  ('Find the VAT and total price (at 7.5% VAT) for a laptop costing ₦180,000, a restaurant meal costing ₦12,500, and a car costing ₦3,500,000.', 'Laptop: VAT ₦18,000, total ₦198,000; Meal: VAT ₦1,250, total ₦13,750; Car: VAT ₦350,000, total ₦3,850,000', 'Laptop: VAT ₦13,500, total ₦180,000; Meal: VAT ₦937.50, total ₦12,500; Car: VAT ₦262,500, total ₦3,500,000', 'Laptop: VAT ₦9,000, total ₦189,000; Meal: VAT ₦625, total ₦13,125; Car: VAT ₦175,000, total ₦3,675,000', 'Laptop: VAT ₦13,500, total ₦193,500; Meal: VAT ₦937.50, total ₦13,437.50; Car: VAT ₦262,500, total ₦3,762,500', 'D', 2, 'GENERAL', 'Each VAT = price times 0.075, and each total = price times 1.075: Laptop 180,000 times 0.075 = 13,500, total 193,500. Meal 12,500 times 0.075 = 937.50, total 13,437.50. Car 3,500,000 times 0.075 = 262,500, total 3,762,500.'),
  ('A shop''s total monthly sales including VAT are ₦5,375,000. Find (i) the sales before VAT, (ii) the VAT to remit.', '(i) ₦4,968,750 (ii) ₦406,250', '(i) ₦5,000,000 (ii) ₦375,000', '(i) ₦5,100,000 (ii) ₦275,000', '(i) ₦4,900,000 (ii) ₦475,000', 'B', 2, 'GENERAL', 'Sales before VAT = 5,375,000 divided by 1.075 = ₦5,000,000. VAT = 5,375,000 minus 5,000,000 = ₦375,000.'),
  ('Using compound interest, calculate (i) ₦75,500 at 9% for 6 years, (ii) the principal that amounts to ₦50,000 in 4 years at 12%.', '(i) ₦116,270 (ii) ₦33,784', '(i) ₦126,621 (ii) ₦33,784', '(i) ₦126,621 (ii) ₦31,776', '(i) ₦116,270 (ii) ₦31,776', 'C', 4, 'GENERAL', '(i) 75,500 times 1.09^6 = 75,500 times 1.6771 = approximately ₦126,621. (ii) Principal = 50,000 divided by 1.12^4 = 50,000 divided by 1.5735 = approximately ₦31,776. Using simple interest instead of compound (a common error) gives the wrong values in options A, B and D.'),
  ('A bond''s value grows from ₦80,000 to ₦120,000 in 5 years. Find the annual compound growth rate.', '10%', '12%', '7.5%', '8.45%', 'D', 4, 'GENERAL', '(1+r)^5 = 120,000 divided by 80,000 = 1.5, so r = 1.5^(1/5) minus 1, approximately 8.45%. Dividing the total 50% growth evenly by 5 years (a common error, treating it as simple growth) wrongly gives 10%.')
) as q(question_text, option_a, option_b, option_c, option_d, correct_letter, difficulty, exam_type, explanation)
where c.subject = 'Mathematics' and t.class_level = 'SS3' and t.term = 2 and t.order_index = 201;

-- ------------------------------------------
-- 202. COORDINATE GEOMETRY: DISTANCE & MIDPOINT
-- ------------------------------------------

with lesson as (
  insert into public.lessons (topic_id, title, summary, content_body, order_index)
  values (
    (select t.id from public.topics t join public.curricula c on c.id = t.curriculum_id
     where c.subject = 'Mathematics' and t.class_level = 'SS3' and t.term = 2 and t.order_index = 202),
    'Coordinate Geometry: Distance and Midpoint',
    'Using the Cartesian plane''s four quadrants, the distance formula (from Pythagoras'' theorem), and the midpoint formula, including finding a missing endpoint and testing three points for collinearity.',
    '### The Cartesian Plane

The Cartesian plane has an $x$-axis and a $y$-axis crossing at the origin $(0,0)$, dividing the plane into four quadrants: Quadrant I ($x>0, y>0$), Quadrant II ($x<0, y>0$), Quadrant III ($x<0, y<0$), Quadrant IV ($x>0, y<0$). A point sitting exactly on an axis (where $x=0$ or $y=0$) is not considered to lie in any quadrant.

### The Distance Formula

For two points $P(x_1, y_1)$ and $Q(x_2, y_2)$:

$$d = \sqrt{(x_2-x_1)^2 + (y_2-y_1)^2}$$

This comes directly from Pythagoras'' theorem: the horizontal gap between the points has length $|x_2-x_1|$, the vertical gap has length $|y_2-y_1|$, and the straight-line distance $d$ is the hypotenuse of the right triangle they form.

**Speed shortcut**: learn to spot Pythagorean triples (3-4-5, 5-12-13, 6-8-10, 8-15-17, 7-24-25) in the horizontal and vertical differences, if the differences are 8 and 15, the distance is 17 immediately, no arithmetic needed.

### The Midpoint Formula

$$M = \left(\frac{x_1+x_2}{2}, \frac{y_1+y_2}{2}\right)$$

In plain words: average the $x$-coordinates, average the $y$-coordinates.

**Finding a missing endpoint**: if $M$ is the midpoint of $PQ$ and you know $P$ and $M$, then $Q = 2M - P$ (subtract componentwise). This is faster than setting up two equations from scratch.

### Testing for Collinearity

Three points $A$, $B$, $C$ are collinear (lie on one straight line) exactly when the gradient between $A$ and $B$ equals the gradient between $B$ and $C$, so only two gradient calculations are ever needed, never three.

### Glossary

- **Cartesian plane**: the grid formed by a horizontal $x$-axis and a vertical $y$-axis, used to locate any point by an $(x,y)$ pair, like giving a location as "3 streets across, 2 streets up" from a fixed corner.
- **Quadrant**: one of the four regions the Cartesian plane is divided into by its two axes.
- **Midpoint**: the point exactly halfway between two other points, found by simply averaging their coordinates.
- **Collinear**: three or more points that all lie on one single straight line.
- **Hypotenuse**: the longest side of a right-angled triangle, always the side opposite the right angle; in the distance formula, it is the direct straight-line distance itself.',
    1
  )
  returning id
)
insert into public.worked_examples (lesson_id, title, problem_statement, solution_steps, exam_shortcut, real_life_context, diagram_type, diagram_data, status)
select id,
  'Distance Between Two Points',
  'Find the distance between $A(2,3)$ and $B(5,7)$.',
  to_jsonb(array[
    'Label the coordinates: $x_1=2, y_1=3, x_2=5, y_2=7$.',
    'Substitute into the distance formula: $d = \sqrt{(5-2)^2 + (7-3)^2}$.',
    'Simplify inside the root: $= \sqrt{3^2 + 4^2} = \sqrt{9+16} = \sqrt{25}$.',
    'Take the square root: $\sqrt{25} = 5$.'
  ]),
  'Spot the 3-4-5 Pythagorean triple in the differences (3 and 4) and write the answer, 5, straight down without computing the square root manually.',
  'A land surveyor plotting two beacon points on a site map in metres uses exactly this formula to confirm the straight-line distance between them before quoting a fencing cost.',
  'coordinate_plane',
  '{"xRange": [0, 8], "yRange": [0, 9], "points": [{"x": 2, "y": 3, "label": "A(2,3)"}, {"x": 5, "y": 7, "label": "B(5,7)"}], "lines": [{"from": {"x": 2, "y": 3}, "to": {"x": 5, "y": 7}, "label": "d = 5"}]}'::jsonb,
  'published'
from lesson;

insert into public.worked_examples (lesson_id, title, problem_statement, solution_steps, exam_shortcut, real_life_context, diagram_type, diagram_data, status)
select l.id,
  'Midpoint of a Line Segment',
  'Find the midpoint of $A(4,6)$ and $B(10,14)$.',
  to_jsonb(array[
    'Average the $x$-coordinates: $\frac{4+10}{2} = \frac{14}{2} = 7$.',
    'Average the $y$-coordinates: $\frac{6+14}{2} = \frac{20}{2} = 10$.',
    'Combine into the midpoint: $M(7,10)$.'
  ]),
  'For clean numbers, do the averaging in your head rather than writing the formula out fully, e.g. the midpoint of (6,10) and (4,2) is instantly (5,6).',
  'A delivery rider planning a stop exactly halfway between a warehouse at (4,6) and a customer at (10,14) on a city grid map uses this to pick the halfway resting point.',
  'coordinate_plane',
  '{"xRange": [0, 12], "yRange": [0, 16], "points": [{"x": 4, "y": 6, "label": "A(4,6)"}, {"x": 10, "y": 14, "label": "B(10,14)"}, {"x": 7, "y": 10, "label": "M(7,10)"}]}'::jsonb,
  'published'
from public.lessons l join public.topics t on t.id = l.topic_id join public.curricula c on c.id = t.curriculum_id
where c.subject = 'Mathematics' and t.class_level = 'SS3' and t.term = 2 and t.order_index = 202;

insert into public.worked_examples (lesson_id, title, problem_statement, solution_steps, exam_shortcut, status)
select l.id,
  'Midpoint, Distance, and the Halfway Check',
  'A line segment has endpoints $A(-3,5)$ and $B(7,-1)$. Find (a) the midpoint $M$, (b) the distance $|AB|$, (c) the distance $|AM|$, and confirm $|AM| = \frac{1}{2}|AB|$.',
  to_jsonb(array[
    'Find the midpoint (a): $M = \left(\frac{-3+7}{2}, \frac{5+(-1)}{2}\right) = \left(\frac{4}{2}, \frac{4}{2}\right) = (2,2)$.',
    'Find $|AB|$ (b): $|AB| = \sqrt{(7-(-3))^2 + (-1-5)^2} = \sqrt{10^2 + (-6)^2} = \sqrt{100+36} = \sqrt{136} = 2\sqrt{34}$ units.',
    'Find $|AM|$ (c): $|AM| = \sqrt{(2-(-3))^2 + (2-5)^2} = \sqrt{5^2 + (-3)^2} = \sqrt{25+9} = \sqrt{34}$ units.',
    'Check the halfway relationship: $\frac{1}{2}|AB| = \frac{1}{2}(2\sqrt{34}) = \sqrt{34} = |AM|$ ✓.'
  ]),
  'Whenever a question asks you to verify that $M$ is genuinely the midpoint, computing $|AM|$ and comparing it to half of $|AB|$ is faster than re-deriving $M$ a second way.',
  'published'
from public.lessons l join public.topics t on t.id = l.topic_id join public.curricula c on c.id = t.curriculum_id
where c.subject = 'Mathematics' and t.class_level = 'SS3' and t.term = 2 and t.order_index = 202;

insert into public.worked_examples (lesson_id, title, problem_statement, solution_steps, exam_shortcut, real_life_context, status)
select l.id,
  'Finding a Missing Endpoint from a Midpoint',
  'The midpoint of $PQ$ is $(2,3)$ and $P$ is $(-2,1)$. Find $Q$.',
  to_jsonb(array[
    'Let $Q = (a,b)$ and apply the midpoint formula: $\left(\frac{-2+a}{2}, \frac{1+b}{2}\right) = (2,3)$.',
    'Equate the $x$-parts: $\frac{-2+a}{2} = 2 \Rightarrow -2+a = 4 \Rightarrow a = 6$.',
    'Equate the $y$-parts: $\frac{1+b}{2} = 3 \Rightarrow 1+b = 6 \Rightarrow b = 5$.',
    'So $Q = (6,5)$.'
  ]),
  'Skip the two equations entirely with the "double the midpoint, subtract the known point" shortcut: $Q = 2M - P = 2(2,3) - (-2,1) = (4,6) - (-2,1) = (6,5)$, the same answer, much faster.',
  'This is the same reasoning a GPS-style delivery app uses when it knows a rider''s current halfway checkpoint and starting warehouse location, and needs to compute exactly where the customer''s address must be.',
  'published'
from public.lessons l join public.topics t on t.id = l.topic_id join public.curricula c on c.id = t.curriculum_id
where c.subject = 'Mathematics' and t.class_level = 'SS3' and t.term = 2 and t.order_index = 202;

insert into public.questions (topic_id, lesson_id, question_text, option_a, option_b, option_c, option_d, correct_letter, difficulty, exam_type, explanation, diagram_type, diagram_data, status)
select t.id, l.id, q.question_text, q.option_a, q.option_b, q.option_c, q.option_d, q.correct_letter, q.difficulty, q.exam_type::exam_type, q.explanation, q.diagram_type::diagram_type, q.diagram_data::jsonb, 'published'
from public.topics t
  join public.curricula c on c.id = t.curriculum_id
  join public.lessons l on l.topic_id = t.id,
  (values
  ('The points $A(3,2)$, $B(-2,4)$, $C(-3,-1)$, $D(2,-3)$ are plotted on the Cartesian plane. In which quadrant does point $C$ lie?', 'Quadrant III', 'Quadrant I', 'Quadrant II', 'Quadrant IV', 'A', 1, 'GENERAL', 'C(-3,-1) has x<0 and y<0, which is Quadrant III. (For reference: A is in Quadrant I, B in Quadrant II, D in Quadrant IV.)', 'coordinate_plane', '{"xRange": [-5, 5], "yRange": [-5, 5], "points": [{"x": 3, "y": 2, "label": "A"}, {"x": -2, "y": 4, "label": "B"}, {"x": -3, "y": -1, "label": "C"}, {"x": 2, "y": -3, "label": "D"}]}'),
  ('Find the distance between $P(4,7)$ and $Q(10,15)$.', '8', '10', '14', '12', 'B', 2, 'GENERAL', 'd = sqrt((10-4)^2+(15-7)^2) = sqrt(36+64) = sqrt(100) = 10.', 'none', '{}'),
  ('Determine the midpoint of the line joining $A(-4,3)$ and $B(6,-5)$.', '(2,-2)', '(1,1)', '(1,-1)', '(-1,-1)', 'C', 1, 'GENERAL', 'Midpoint = ((-4+6)/2, (3-5)/2) = (2/2, -2/2) = (1,-1).', 'none', '{}'),
  ('Calculate the distance between: (i) $A(5,8)$ and $B(9,11)$, (ii) $P(-3,4)$ and $Q(5,-2)$, (iii) $M(-6,-8)$ and $N(2,7)$.', '(i) 5 (ii) 8 (iii) 15', '(i) 7 (ii) 10 (iii) 17', '(i) 5 (ii) 10 (iii) 15', '(i) 5 (ii) 10 (iii) 17', 'D', 2, 'GENERAL', '(i) sqrt(16+9)=5. (ii) sqrt(64+36)=10. (iii) sqrt(64+225)=sqrt(289)=17.', 'none', '{}'),
  ('Find the midpoint of (i) the line joining $(7,9)$ and $(15,21)$, (ii) $AB$ where $A(-5,3)$ and $B(7,-9)$.', '(i) (11,15) (ii) (1,-3)', '(i) (11,15) (ii) (-1,3)', '(i) (8,12) (ii) (1,-3)', '(i) (11,15) (ii) (6,-6)', 'A', 2, 'GENERAL', '(i) ((7+15)/2,(9+21)/2)=(11,15). (ii) ((-5+7)/2,(3-9)/2)=(1,-3).', 'none', '{}'),
  ('The distance between $A(x,5)$ and $B(7,9)$ is 5 units. Find the possible values of $x$.', 'x = 4 only', 'x = 4 or 10', 'x = 10 only', 'x = 3 or 11', 'B', 3, 'GENERAL', 'd^2=(7-x)^2+16=25, so (7-x)^2=9, giving 7-x=+-3, so x=4 or x=10.', 'none', '{}'),
  ('Three vertices of a rectangle are $A(2,1)$, $B(6,1)$, $C(6,4)$. Find (i) the fourth vertex $D$, (ii) the length of diagonal $AC$, (iii) the midpoint of diagonal $BD$.', '(i) (2,4) (ii) 5 (iii) (4,2)', '(i) (6,4) (ii) 5 (iii) (4,2.5)', '(i) (2,4) (ii) 5 (iii) (4,2.5)', '(i) (2,4) (ii) 7 (iii) (4,2.5)', 'C', 3, 'GENERAL', 'D completes the rectangle at (2,4). AC = sqrt((6-2)^2+(4-1)^2) = sqrt(16+9) = 5. Midpoint of BD = midpoint of (6,1) and (2,4) = (4,2.5).', 'none', '{}'),
  ('A treasure map shows treasure at $T(8,11)$; you start at $S(2,3)$. Find (i) the distance to the treasure, (ii) the midpoint coordinates, (iii) the distance from the midpoint to the treasure.', '(i) 10 (ii) (5,7) (iii) 10', '(i) 8 (ii) (5,7) (iii) 4', '(i) 10 (ii) (4,7) (iii) 5', '(i) 10 (ii) (5,7) (iii) 5', 'D', 2, 'GENERAL', 'ST = sqrt(36+64) = 10. Midpoint = (5,7). Distance from midpoint to treasure is half of ST, which is 5.', 'none', '{}'),
  ('Towns $X(0,0)$, $Y(12,5)$, $Z(4,9)$ are being connected by a road network. (i) Which two towns are closest together? (ii) Find the centroid (a proposed hospital location).', '(i) Y and Z, distance approximately 8.94 (ii) (16/3, 14/3)', '(i) X and Z, distance approximately 9.85 (ii) (16/3, 14/3)', '(i) X and Y, distance 13 (ii) (16/3, 14/3)', '(i) Y and Z, distance approximately 8.94 (ii) (4, 14/3)', 'A', 3, 'GENERAL', 'XY=sqrt(144+25)=13, XZ=sqrt(16+81)=sqrt(97)=~9.85, YZ=sqrt(64+16)=sqrt(80)=~8.94. Y and Z are closest. Centroid = ((0+12+4)/3, (0+5+9)/3) = (16/3, 14/3). (Corrected: an earlier version of this exercise wrongly named X and Z as the closest pair.)', 'none', '{}'),
  ('Which two sides of triangle $A(1,2)$, $B(4,6)$, $C(7,2)$ are equal, proving it is isosceles?', 'AB and AC', 'AB and BC', 'BC and AC', 'No two sides are equal', 'B', 2, 'GENERAL', 'AB = sqrt(9+16) = 5. BC = sqrt(9+16) = 5. AC = 6. Since AB = BC, the triangle is isosceles.', 'none', '{}'),
  ('Which pair of gradients confirms $PQ \parallel SR$ in the quadrilateral $PQRS$ with $P(1,2)$, $Q(5,3)$, $R(6,7)$, $S(2,6)$, showing it is a parallelogram?', 'Gradient PQ = 1/4, gradient QR = 4', 'Gradient PQ = 1/4, gradient SR = 4', 'Gradient PQ = 1/4, gradient SR = 1/4', 'Gradient PQ = 1/4, gradient SR = -4', 'C', 3, 'GENERAL', 'Gradient PQ = (3-2)/(5-1) = 1/4. Gradient SR = (7-6)/(6-2) = 1/4. Equal gradients confirm PQ is parallel to SR (and similarly QR is parallel to PS with gradient 4 each), so PQRS is a parallelogram.', 'none', '{}'),
  ('What are the gradients of $AB$ and $BC$ for $A(0,0)$, $B(4,3)$, $C(8,6)$, and what does this show about the three points?', 'Gradient AB = 3/4, gradient BC = 3/4; not collinear', 'Gradient AB = 4/3, gradient BC = 4/3; collinear', 'Gradient AB = 3/4, gradient BC = 4/3; not collinear', 'Gradient AB = 3/4, gradient BC = 3/4; collinear', 'D', 2, 'GENERAL', 'Gradient AB = (3-0)/(4-0) = 3/4. Gradient BC = (6-3)/(8-4) = 3/4. Equal gradients through a shared point B mean A, B, C are collinear (lie on one straight line).', 'none', '{}'),
  ('Find the distance between $(2,5)$ and $(5,9)$.', '4 units', '5 units', '12 units', '14 units', 'B', 1, 'WAEC', 'd = sqrt((5-2)^2+(9-5)^2) = sqrt(9+16) = sqrt(25) = 5. This is a WAEC classic, the 3-4-5 Pythagorean triple in disguise.', 'none', '{}'),
  ('Find the distance between $Y(7,9)$ and $Z(15,11)$.', '$3\sqrt{17}$', '$2\sqrt{17}$', '$2\sqrt{34}$', '$4\sqrt{17}$', 'B', 2, 'WAEC', 'd = sqrt((15-7)^2+(11-9)^2) = sqrt(64+4) = sqrt(68) = 2*sqrt(17).', 'none', '{}'),
  ('If the distance between $(-3,-2)$ and $(1,y)$ is $2\sqrt{5}$ units, find $y$.', '4', '2', '-2', '-4', 'D', 3, 'GENERAL', 'd^2 = 16+(y+2)^2 = 20, so (y+2)^2=4, giving y=0 or y=-4. Only y=-4 appears among the printed options; y=0, though also mathematically valid, is not offered.', 'none', '{}'),
  ('Find the distance between $\left(\frac{1}{2},\frac{1}{2}\right)$ and $\left(-\frac{1}{2},-\frac{1}{2}\right)$.', '$\sqrt{2}$', '0', '1', '$\sqrt{3}$', 'A', 2, 'GENERAL', 'd = sqrt(1^2+1^2) = sqrt(2), since each coordinate differs by exactly 1.', 'none', '{}'),
  ('What is $r$ if the distance between $(4,2)$ and $(1,r)$ is 3 units?', '1', '2', '3', '4', 'B', 2, 'GENERAL', 'd^2 = 9+(r-2)^2 = 9, so (r-2)^2=0, giving r=2.', 'none', '{}'),
  ('Find the distance between $(4,3)$ and the point of intersection of $y=2x+4$ and $y=7-x$.', '$\sqrt{26}$', '$3\sqrt{2}$', '18', '$3\sqrt{10}$', 'B', 4, 'GENERAL', 'Solving 2x+4=7-x gives x=1, y=6, so the intersection is (1,6). Distance from (4,3): sqrt((4-1)^2+(3-6)^2) = sqrt(9+9) = sqrt(18) = 3*sqrt(2).', 'none', '{}'),
  ('If $\alpha+\beta=2$ and the distance between $(1,\alpha)$ and $(\beta,1)$ is 3 units, find $\alpha^2+\beta^2$.', '9', '13', '11', '7', 'C', 5, 'GENERAL', 'Since beta=2-alpha, (beta-1)=(1-alpha), so d^2=2(1-alpha)^2=9. Expanding (beta-1)^2+(alpha-1)^2=9 directly gives (alpha^2+beta^2)-2(alpha+beta)+2=9, so (alpha^2+beta^2)-4+2=9, giving alpha^2+beta^2=11.', 'none', '{}'),
  ('Find the midpoint of $S(-5,4)$ and $T(-3,-2)$.', '(-4,1)', '(4,-1)', '(-4,2)', '(4,-2)', 'A', 1, 'GENERAL', 'Midpoint = ((-5-3)/2, (4-2)/2) = (-4,1).', 'none', '{}'),
  ('Find the midpoint of $M(6,10)$ and $N(4,2)$.', '(2,8)', '(10,12)', '(-5,-6)', '(5,6)', 'D', 1, 'GENERAL', 'Midpoint = ((6+4)/2, (10+2)/2) = (5,6).', 'none', '{}'),
  ('If the midpoint of $PQ$ is $(2,3)$ and $P$ is $(-2,1)$, find $Q$.', '(8,6)', '(5,6)', '(0,4)', '(6,5)', 'D', 2, 'GENERAL', 'Q = 2M - P = (4,6) - (-2,1) = (6,5).', 'none', '{}'),
  ('The midpoint of $P(m,n)$ and $Q(1,3)$ is $R(2,4)$. Find $m$ and $n$.', 'm=4, n=3', 'm=2, n=7', 'm=4, n=2', 'm=3, n=5', 'D', 2, 'GENERAL', '(m+1)/2=2 gives m=3. (n+3)/2=4 gives n=5.', 'none', '{}'),
  ('$M(3,-4)$ is the midpoint of $PQ$; $P$ is $(6,5)$. Find $Q$.', '(0,-13)', '(4.0,0.5)', '(3,2.5)', '(12,-3)', 'A', 2, 'GENERAL', 'Q = 2M - P = (6,-8) - (6,5) = (0,-13).', 'none', '{}'),
  ('Find $k$ if the midpoint of $(1-k,-4)$ and $(2,k+1)$ is $(-k,k)$.', '-3', '-1', '-4', '-2', 'A', 4, 'GENERAL', 'x-part: ((1-k)+2)/2=-k gives 3-k=-2k, so k=-3. Checking the y-part: ((-4)+(k+1))/2=k also gives k=-3, confirming consistency.', 'none', '{}'),
  ('Find the midpoint of the line $y-4x+3=0$ between its $x$-axis and $y$-axis intercepts.', '(3/8, 3/2)', '(3/8, -3/2)', '(3/4, -3/2)', '(3/8, -3)', 'B', 3, 'GENERAL', 'The line is y=4x-3. x-intercept (y=0): x=3/4, point (3/4,0). y-intercept (x=0): y=-3, point (0,-3). Midpoint = ((3/4+0)/2, (0-3)/2) = (3/8, -3/2).', 'none', '{}')
) as q(question_text, option_a, option_b, option_c, option_d, correct_letter, difficulty, exam_type, explanation, diagram_type, diagram_data)
where c.subject = 'Mathematics' and t.class_level = 'SS3' and t.term = 2 and t.order_index = 202;

-- ------------------------------------------
-- 203. COORDINATE GEOMETRY: GRADIENT, INTERCEPTS & ANGLE BETWEEN LINES
-- ------------------------------------------

with lesson as (
  insert into public.lessons (topic_id, title, summary, content_body, order_index)
  values (
    (select t.id from public.topics t join public.curricula c on c.id = t.curriculum_id
     where c.subject = 'Mathematics' and t.class_level = 'SS3' and t.term = 2 and t.order_index = 203),
    'Coordinate Geometry: Gradient, Intercepts and Angle Between Lines',
    'Finding a line''s gradient and intercepts, writing its equation from a point and gradient (or two points), testing lines for parallelism, perpendicularity or collinearity, and finding the acute angle between two intersecting lines.',
    '### Gradient

The gradient of a line through $P(x_1,y_1)$ and $Q(x_2,y_2)$ is $m = \frac{y_2-y_1}{x_2-x_1}$ (rise over run). A positive gradient rises left to right, a negative gradient falls, a zero gradient is horizontal, and a vertical line has an undefined gradient (division by zero).

- **Parallel lines**: $m_1 = m_2$.
- **Perpendicular lines**: $m_1 \times m_2 = -1$, equivalently $m_2 = -\frac{1}{m_1}$ (the negative reciprocal). Flip the fraction and change its sign, that is the whole rule.
- **Collinear points**: three points lie on one line exactly when the gradient between any two pairs is the same.

### Equation of a Straight Line

- Slope-intercept form: $y = mx + c$ ($m$ = gradient, $c$ = $y$-intercept).
- Point-slope form: $y - y_1 = m(x-x_1)$, use this when you know one point and the gradient.
- Two-point form: first find $m$, then apply point-slope form with either point.
- General form: $ax+by+c=0$.

**Fast rearranging shortcut**: for a line written as $ax+by=c$, the gradient is always $m = -\frac{a}{b}$ and the $y$-intercept is $\frac{c}{b}$, read straight off without fully rearranging into $y=mx+c$ first.

### Intercepts

The $x$-intercept is found by setting $y=0$ and solving for $x$; the $y$-intercept by setting $x=0$ and solving for $y$.

### Angle of Inclination and Angle Between Two Lines

The angle of inclination $\theta$ is the angle a line makes with the positive $x$-axis, measured anticlockwise, and $m = \tan\theta$. Learn the special values cold: $\tan 30° = \frac{1}{\sqrt{3}}$, $\tan 45° = 1$, $\tan 60° = \sqrt{3}$.

For two intersecting lines with gradients $m_1, m_2$, the acute angle $\theta$ between them satisfies:

$$\tan\theta = \left|\frac{m_1-m_2}{1+m_1 m_2}\right|$$

**Always take the modulus (absolute value)** before applying $\tan^{-1}$, this guarantees the acute angle rather than accidentally reporting its obtuse supplement.

### Glossary

- **Gradient (slope)**: how steep a line is and in which direction, found from "how much up" divided by "how much across" between any two of its points.
- **Negative reciprocal**: flip a fraction upside down and change its sign, e.g. $\frac{2}{3}$ becomes $-\frac{3}{2}$; this is exactly the gradient of any line perpendicular to the original.
- **Angle of inclination**: the tilt angle a line makes with the positive $x$-axis, always measured going anticlockwise from that axis.
- **Intercept**: the single point where a line crosses one of the axes, the $x$-intercept is on the $x$-axis, the $y$-intercept is on the $y$-axis.',
    1
  )
  returning id
)
insert into public.worked_examples (lesson_id, title, problem_statement, solution_steps, exam_shortcut, real_life_context, diagram_type, diagram_data, status)
select id,
  'Gradient Between Two Points',
  'Find the gradient of the line through $A(2,3)$ and $B(6,11)$.',
  to_jsonb(array[
    'Label the coordinates: $x_1=2, y_1=3, x_2=6, y_2=11$.',
    'Apply the gradient formula: $m = \frac{y_2-y_1}{x_2-x_1} = \frac{11-3}{6-2}$.',
    'Simplify: $= \frac{8}{4} = 2$.'
  ]),
  'A gradient greater than 1 means the line rises more steeply than a 45-degree line; sanity-check your answer''s size against a rough mental picture of the two points.',
  'A phone-data reseller tracking data bundle sales on two different days plots the two points and reads the gradient as the average extra bundles sold per day, exactly this calculation.',
  'coordinate_plane',
  '{"xRange": [0, 8], "yRange": [0, 13], "points": [{"x": 2, "y": 3, "label": "A(2,3)"}, {"x": 6, "y": 11, "label": "B(6,11)"}], "lines": [{"from": {"x": 2, "y": 3}, "to": {"x": 6, "y": 11}, "label": "m = 2"}]}'::jsonb,
  'published'
from lesson;

insert into public.worked_examples (lesson_id, title, problem_statement, solution_steps, exam_shortcut, status)
select l.id,
  'Equation of a Line from a Gradient and a Point',
  'Find the equation of a line with gradient 3 passing through $(2,5)$.',
  to_jsonb(array[
    'Start from $y = mx+c$ with $m=3$: $y = 3x+c$.',
    'Substitute the known point $(2,5)$ to find $c$: $5 = 3(2)+c \Rightarrow 5 = 6+c$.',
    'Solve for $c$: $c = 5-6 = -1$.',
    'Write the final equation: $y = 3x - 1$.'
  ]),
  'Point-slope form $y-y_1=m(x-x_1)$ skips the need to solve for $c$ separately: $y-5=3(x-2) \Rightarrow y=3x-6+5=3x-1$, the same answer in fewer steps.',
  'published'
from public.lessons l join public.topics t on t.id = l.topic_id join public.curricula c on c.id = t.curriculum_id
where c.subject = 'Mathematics' and t.class_level = 'SS3' and t.term = 2 and t.order_index = 203;

insert into public.worked_examples (lesson_id, title, problem_statement, solution_steps, exam_shortcut, diagram_type, diagram_data, status)
select l.id,
  'Testing Two Lines for Perpendicularity',
  'Show that the line through $P(2,3)$ and $Q(6,5)$ is perpendicular to the line through $R(1,4)$ and $S(3,0)$.',
  to_jsonb(array[
    'Find the gradient of $PQ$: $m_1 = \frac{5-3}{6-2} = \frac{2}{4} = \frac{1}{2}$.',
    'Find the gradient of $RS$: $m_2 = \frac{0-4}{3-1} = \frac{-4}{2} = -2$.',
    'Multiply the two gradients: $m_1 \times m_2 = \frac{1}{2} \times (-2) = -1$.',
    'Since $m_1 m_2 = -1$, the lines $PQ$ and $RS$ are perpendicular.'
  ]),
  'Recognise $\frac{1}{2}$ and $-2$ as a negative-reciprocal pair on sight, flip $\frac{1}{2}$ upside down to get $2$, then change the sign to get $-2$, confirming perpendicularity without even multiplying them out.',
  'coordinate_plane',
  '{"xRange": [0, 7], "yRange": [-1, 6], "points": [{"x": 2, "y": 3, "label": "P"}, {"x": 6, "y": 5, "label": "Q"}, {"x": 1, "y": 4, "label": "R"}, {"x": 3, "y": 0, "label": "S"}], "lines": [{"from": {"x": 2, "y": 3}, "to": {"x": 6, "y": 5}, "label": "PQ, m=1/2"}, {"from": {"x": 1, "y": 4}, "to": {"x": 3, "y": 0}, "label": "RS, m=-2"}]}'::jsonb,
  'published'
from public.lessons l join public.topics t on t.id = l.topic_id join public.curricula c on c.id = t.curriculum_id
where c.subject = 'Mathematics' and t.class_level = 'SS3' and t.term = 2 and t.order_index = 203;

insert into public.worked_examples (lesson_id, title, problem_statement, solution_steps, exam_shortcut, common_trap_warning, status)
select l.id,
  'Acute Angle Between Two Lines',
  'Find the acute angle between the lines $y=x$ and $y=\sqrt{3}x$.',
  to_jsonb(array[
    'Read off the gradients: $m_1 = 1$ (from $y=x$), $m_2 = \sqrt{3}$ (from $y=\sqrt{3}x$).',
    'Apply the angle-between-lines formula: $\tan\theta = \left|\frac{m_1-m_2}{1+m_1 m_2}\right| = \left|\frac{1-\sqrt{3}}{1+\sqrt{3}}\right|$.',
    'Rationalise the denominator by multiplying top and bottom by $(1-\sqrt{3})$: $\frac{(1-\sqrt{3})^2}{(1+\sqrt{3})(1-\sqrt{3})} = \frac{1-2\sqrt{3}+3}{1-3} = \frac{4-2\sqrt{3}}{-2} = \sqrt{3}-2$.',
    'Take the modulus: $\tan\theta = |\sqrt{3}-2| = 2-\sqrt{3} \approx 0.268$.',
    'Take the inverse tangent: $\theta = \tan^{-1}(0.268) = 15°$.'
  ]),
  'Recognise $y=x$ (a 45-degree line) and $y=\sqrt{3}x$ (a 60-degree line, since $\tan 60°=\sqrt{3}$) directly by their gradients, the angle between them is simply $60°-45°=15°$, no formula needed once the two angles of inclination are recognised.',
  'Forgetting the modulus here would give $\tan\theta = \sqrt{3}-2$, a negative number, and blindly applying $\tan^{-1}$ to a negative value risks reporting the wrong (obtuse-related) angle instead of the acute $15°$ actually asked for.',
  'published'
from public.lessons l join public.topics t on t.id = l.topic_id join public.curricula c on c.id = t.curriculum_id
where c.subject = 'Mathematics' and t.class_level = 'SS3' and t.term = 2 and t.order_index = 203;

insert into public.questions (topic_id, lesson_id, question_text, option_a, option_b, option_c, option_d, correct_letter, difficulty, exam_type, explanation, status)
select t.id, l.id, q.question_text, q.option_a, q.option_b, q.option_c, q.option_d, q.correct_letter, q.difficulty, q.exam_type::exam_type, q.explanation, 'published'
from public.topics t
  join public.curricula c on c.id = t.curriculum_id
  join public.lessons l on l.topic_id = t.id,
  (values
  ('Calculate the gradient of the line passing through $(2,5)$ and $(8,17)$.', '2', '1/2', '6', '3', 'A', 1, 'GENERAL', 'm = (17-5)/(8-2) = 12/6 = 2.'),
  ('What are the gradients of $AB$ and $BC$ for $A(1,2)$, $B(3,4)$, $C(7,8)$, and what does this show?', 'Gradient AB = 1, gradient BC = 2; not collinear', 'Gradient AB = 1, gradient BC = 1; collinear', 'Gradient AB = 2, gradient BC = 1; not collinear', 'Gradient AB = 1, gradient BC = 1; not collinear', 'B', 2, 'GENERAL', 'Gradient AB = (4-2)/(3-1) = 1. Gradient BC = (8-4)/(7-3) = 1. Equal gradients through the shared point B confirm A, B, C are collinear.'),
  ('Find the equation of a line with gradient 4 passing through $(1,5)$.', 'y=4x+5', 'y=4x-1', 'y=4x+1', 'y=x+4', 'C', 1, 'GENERAL', 'y=4x+c; 5=4(1)+c gives c=1, so y=4x+1.'),
  ('Are the lines through $A(1,3), B(4,5)$ and $C(2,1), D(8,-5)$ parallel, perpendicular, or neither?', 'Parallel', 'Perpendicular', 'Both', 'Neither', 'D', 3, 'GENERAL', 'Gradient AB = (5-3)/(4-1) = 2/3. Gradient CD = (-5-1)/(8-2) = -1. Neither equal (not parallel) nor multiplying to -1 (not perpendicular, since 2/3 times -1 = -2/3): the lines are neither.'),
  ('Find the $x$ and $y$ intercepts of $5x-3y=15$.', '(3,0) and (0,-5)', '(3,0) and (0,5)', '(5,0) and (0,-3)', '(-3,0) and (0,5)', 'A', 2, 'GENERAL', 'x-intercept (y=0): 5x=15, x=3. y-intercept (x=0): -3y=15, y=-5.'),
  ('A line passes through $(2,7)$ with gradient $-3$. Write its equation.', 'y=-3x+1', 'y=-3x+13', 'y=-3x-13', 'y=-3x+7', 'B', 1, 'GENERAL', 'y-7=-3(x-2) gives y=-3x+6+7=-3x+13.'),
  ('The points $P(3,k)$ and $Q(7,10)$ lie on a line with gradient 2. Find $k$.', '6', '-2', '2', '4', 'C', 2, 'GENERAL', '(10-k)/(7-3)=2 gives 10-k=8, so k=2.'),
  ('Find the gradient of the line through: (i) $(3,7)$ and $(9,19)$, (ii) $(-4,5)$ and $(2,-7)$, (iii) $(a,3a)$ and $(2a,7a)$.', '(i) 2 (ii) 2 (iii) 4', '(i) 2 (ii) -2 (iii) 2', '(i) -2 (ii) -2 (iii) 4', '(i) 2 (ii) -2 (iii) 4', 'D', 3, 'GENERAL', '(i) (19-7)/(9-3)=2. (ii) (-7-5)/(2-(-4))=-12/6=-2. (iii) (7a-3a)/(2a-a)=4a/a=4.'),
  ('What are the gradients of $AB$ and $CD$ for $A(2,3)$, $B(6,7)$, $C(-1,2)$, $D(3,6)$?', 'Gradient AB = 1, gradient CD = 1', 'Gradient AB = 1, gradient CD = -1', 'Gradient AB = 2, gradient CD = 2', 'Gradient AB = 1, gradient CD = 0', 'A', 2, 'GENERAL', 'Gradient AB = (7-3)/(6-2) = 1. Gradient CD = (6-2)/(3-(-1)) = 1. Equal gradients confirm AB is parallel to CD.'),
  ('What are the gradients of $PQ$ and $RS$ for $P(1,4)$, $Q(5,6)$, $R(3,2)$, $S(1,6)$, and their product?', 'Gradient PQ = 1/2, gradient RS = 2; product = 1', 'Gradient PQ = 1/2, gradient RS = -2; product = -1', 'Gradient PQ = -1/2, gradient RS = 2; product = -1', 'Gradient PQ = 1/2, gradient RS = -2; product = 1', 'B', 3, 'GENERAL', 'Gradient PQ = (6-4)/(5-1) = 1/2. Gradient RS = (6-2)/(1-3) = -2. Product = 1/2 times -2 = -1, confirming PQ is perpendicular to RS.'),
  ('Find the equation of the line: (i) with gradient 5 through $(2,3)$, (ii) through $(1,4)$ and $(3,10)$, (iii) with gradient $-2$ and $y$-intercept 5.', '(i) y=5x+7 (ii) y=3x+1 (iii) y=-2x+5', '(i) y=5x-7 (ii) y=3x-1 (iii) y=-2x+5', '(i) y=5x-7 (ii) y=3x+1 (iii) y=-2x+5', '(i) y=5x-7 (ii) y=3x+1 (iii) y=2x+5', 'C', 3, 'GENERAL', '(i) y=5x+c, 3=10+c, c=-7, y=5x-7. (ii) gradient=(10-4)/(3-1)=3, y=3x+c, 4=3+c, c=1, y=3x+1. (iii) directly y=-2x+5.'),
  ('Rewrite in the form $y=mx+c$: (i) $3x+4y=12$, (ii) $2x-5y+10=0$, (iii) $x-y=7$.', '(i) y=(3/4)x+3 (ii) y=(2/5)x+2 (iii) y=x-7', '(i) y=-(3/4)x+3 (ii) y=-(2/5)x+2 (iii) y=x-7', '(i) y=-(3/4)x+3 (ii) y=(2/5)x-2 (iii) y=x-7', '(i) y=-(3/4)x+3 (ii) y=(2/5)x+2 (iii) y=x-7', 'D', 2, 'GENERAL', '(i) 4y=12-3x, y=-(3/4)x+3. (ii) 5y=2x+10, y=(2/5)x+2. (iii) y=x-7.'),
  ('Find the $x$ and $y$ intercepts for: (a) $y=3x-6$, (b) $2x+3y=12$, (c) $5x-4y=20$, (d) $y=-2x+8$.', '(a) (2,0),(0,-6) (b) (6,0),(0,4) (c) (4,0),(0,-5) (d) (4,0),(0,8)', '(a) (2,0),(0,6) (b) (6,0),(0,4) (c) (4,0),(0,-5) (d) (4,0),(0,8)', '(a) (2,0),(0,-6) (b) (4,0),(0,6) (c) (4,0),(0,-5) (d) (4,0),(0,8)', '(a) (2,0),(0,-6) (b) (6,0),(0,4) (c) (5,0),(0,-4) (d) (4,0),(0,8)', 'A', 2, 'GENERAL', 'Each intercept comes from setting the other variable to 0 in turn: (a) (2,0) and (0,-6); (b) (6,0) and (0,4); (c) (4,0) and (0,-5); (d) (4,0) and (0,8).'),
  ('Which two sides prove that the triangle with vertices $A(1,2)$, $B(4,6)$, $C(7,2)$ is isosceles?', 'AB and AC', 'AB and BC', 'BC and AC', 'No two sides are equal', 'B', 2, 'GENERAL', 'AB = sqrt(9+16) = 5. BC = sqrt(9+16) = 5. Since AB = BC, the triangle is isosceles.'),
  ('Find the gradient of a line inclined at $45°$ to the $x$-axis.', '0', '$\sqrt{3}$', '1', '45', 'C', 1, 'GENERAL', 'm = tan(45°) = 1.'),
  ('A line has gradient $\sqrt{3}$. Find its angle of inclination.', '30°', '45°', '90°', '60°', 'D', 2, 'GENERAL', 'tan(theta)=sqrt(3), and tan(60 degrees)=sqrt(3), so theta=60 degrees.'),
  ('Three vertices of a parallelogram are $A(1,2)$, $B(4,3)$, $C(6,6)$. Find the fourth vertex $D$.', '(3,5)', '(9,7)', '(-3,-5)', '(4,5)', 'A', 3, 'GENERAL', 'In parallelogram ABCD, the diagonals bisect each other, so D = A+C-B = (1+6-4, 2+6-3) = (3,5).'),
  ('A road is built from Town $A(2,5)$ km to Town $B(10,17)$ km. Find (a) the distance, (b) the gradient, (c) the midpoint (a proposed rest stop) coordinates.', '(a) 14.42 km (b) 1.5 (c) (6,10)', '(a) 14.42 km (b) 1.5 (c) (6,11)', '(a) 12 km (b) 1.5 (c) (6,11)', '(a) 14.42 km (b) 2 (c) (6,11)', 'B', 3, 'GENERAL', 'Distance = sqrt(64+144) = sqrt(208) = 4*sqrt(13), approximately 14.42 km. Gradient = (17-5)/(10-2) = 12/8 = 1.5. Midpoint = (6,11).'),
  ('Find the gradient of the line passing through $P(1,1)$ and $Q(2,5)$.', '4', '2', '3', '5', 'A', 1, 'GENERAL', 'm = (5-1)/(2-1) = 4.'),
  ('Find the gradient of $PQ$ where $P(5,-7)$, $Q(-2,-3)$.', '1/2', '2/5', '-4/7', '-2/3', 'C', 2, 'GENERAL', 'm = (-3-(-7))/(-2-5) = 4/(-7) = -4/7.'),
  ('The gradient of the line joining $(x,4)$ and $(1,2)$ is $\frac{1}{2}$. Find $x$.', '5', '-3', '3', '-5', 'A', 3, 'GENERAL', 'Gradient = (2-4)/(1-x) = 1/2, giving -2 = 0.5(1-x), so -4 = 1-x, giving x=5. Checking: points (5,4) and (1,2) give gradient (4-2)/(5-1) = 1/2, confirmed. (Corrected: an earlier version of this exercise wrongly stated x=-3, which does not satisfy the given gradient.)'),
  ('Find the gradient of the line joining $P(4,-1)$ and $Q(-3,-5)$.', '4/7', '7', '-4/7', '-7/4', 'A', 2, 'GENERAL', 'm = (-5-(-1))/(-3-4) = -4/-7 = 4/7.'),
  ('Find the gradient of the line joining $S(5,6)$ and $R(-7,-8)$.', '7/6', '-1', '1', '-7/6', 'A', 2, 'GENERAL', 'm = (-8-6)/(-7-5) = -14/-12 = 7/6.'),
  ('What is $P$ if the gradient of the line joining $(-1,P)$ and $(P,4)$ is $\frac{2}{3}$?', '1', '3', '-1', '2', 'D', 4, 'GENERAL', 'Gradient = (4-P)/(P+1) = 2/3, giving 3(4-P) = 2(P+1), so 12-3P = 2P+2, giving 10 = 5P, so P=2. Checking: points (-1,2) and (2,4) give gradient (4-2)/(2+1) = 2/3, confirmed. (Corrected: an earlier version of this exercise wrongly stated P=1, which does not satisfy the given gradient.)'),
  ('A line passes through the origin and $\left(1\frac{1}{4}, 2\frac{1}{2}\right)$. Find its gradient, and the value of $y$ when $x=4$.', 'Gradient = 2, y(4) = 8', 'Gradient = 0.5, y(4) = 2', 'Gradient = 2, y(4) = 6', 'Gradient = 1.25, y(4) = 5', 'A', 2, 'GENERAL', 'Gradient = 2.5/1.25 = 2, so y=2x. At x=4, y=8.'),
  ('A straight line makes an angle of $30°$ with the positive $x$-axis and cuts the $y$-axis at $y=5$. Find its equation.', '$y=\sqrt{3}x+5$', '$y=\frac{x}{\sqrt{3}}+5$', '$y=\frac{x}{\sqrt{3}}-5$', '$y=\frac{x}{3}+5$', 'B', 3, 'GENERAL', 'Gradient = tan(30 degrees) = 1/sqrt(3). With y-intercept 5: y = x/sqrt(3) + 5, equivalently sqrt(3)*y = x + 5*sqrt(3).')
) as q(question_text, option_a, option_b, option_c, option_d, correct_letter, difficulty, exam_type, explanation)
where c.subject = 'Mathematics' and t.class_level = 'SS3' and t.term = 2 and t.order_index = 203;

-- ------------------------------------------
-- 204. DIFFERENTIATION: FIRST PRINCIPLES & STANDARD DERIVATIVES
-- No coordinate_plane or other diagram: this topic is pure algebraic
-- limit-taking and differentiation, with no natural static figure to
-- draw, matching the standing instruction not to force a diagram.
-- ------------------------------------------

with lesson as (
  insert into public.lessons (topic_id, title, summary, content_body, order_index)
  values (
    (select t.id from public.topics t join public.curricula c on c.id = t.curriculum_id
     where c.subject = 'Mathematics' and t.class_level = 'SS3' and t.term = 2 and t.order_index = 204),
    'Differentiation: First Principles and Standard Derivatives',
    'Defining the derivative as a limit of a chord''s gradient, deriving it from first principles for simple functions, and using the power rule and physical interpretation (velocity, acceleration, tangents).',
    '### Limits

$\lim_{x \to a} f(x) = L$ means $f(x)$ gets closer and closer to $L$ as $x$ gets closer and closer to $a$. Direct substitution works whenever it gives a real number. An indeterminate form like $\frac{0}{0}$ is resolved by factorising and cancelling the troublesome factor first, then substituting.

### The First Principles Definition

$$f''(x) = \lim_{h \to 0} \frac{f(x+h) - f(x)}{h}$$

Geometrically: $P(x, f(x))$ and $Q(x+h, f(x+h))$ are two points on the curve. The fraction $\frac{f(x+h)-f(x)}{h}$ is the gradient of the chord $PQ$. As $h \to 0$, $Q$ slides along the curve toward $P$, and the chord''s gradient approaches the gradient of the tangent at $P$, that limiting value is $f''(x)$, the derivative.

### The Power Rule (Standard Derivatives)

If $f(x) = x^n$, then $f''(x) = nx^{n-1}$, "bring the power down as a multiplier, then reduce the power by 1." This rule can itself be proved from first principles using the binomial expansion of $(x+h)^n$.

**Rules**: a constant multiple, $\frac{d}{dx}[c \cdot f(x)] = c \cdot f''(x)$; a sum or difference, $\frac{d}{dx}[f(x) \pm g(x)] = f''(x) \pm g''(x)$; and a lone constant always differentiates to 0.

**Speed tip**: only use first principles when a question explicitly says "from first principles", otherwise, apply the power rule directly to every term, it is always faster.

### Physical Interpretation

If $s(t)$ is distance (displacement), $s''(t) = v(t)$ is velocity (rate of change of distance). If $v(t)$ is velocity, $v''(t) = a(t)$ is acceleration (rate of change of velocity). A particle is momentarily "at rest" when its **velocity** equals zero, never when its position equals zero, a very common exam trap.

**Tangent and normal**: at a point $(x_0, y_0)$ on a curve, the tangent''s gradient is $m = f''(x_0)$; the normal (perpendicular to the tangent) has gradient $-\frac{1}{m}$. Use point-slope form $y-y_0=m(x-x_0)$ for each line''s equation.

### Glossary

- **Derivative**: a formula for the instantaneous rate of change of one quantity with respect to another, e.g. how fast distance changes with time (velocity). If a trader''s stock of rice drops by roughly 2 bags for every extra day, the derivative of "bags remaining" with respect to "day" is $-2$.
- **Limit**: the value a function gets arbitrarily close to as its input approaches some value, without necessarily ever reaching it exactly.
- **Chord**: a straight line joining two distinct points on a curve; a tangent is the limiting case of a chord as its two points merge into one.
- **Stationary (at rest)**: for a moving particle, the instant its velocity equals zero, it has momentarily stopped, even though it may start moving again immediately after.',
    1
  )
  returning id
)
insert into public.worked_examples (lesson_id, title, problem_statement, solution_steps, exam_shortcut, status)
select id,
  'Derivative of x-squared from First Principles',
  'Find the derivative of $f(x) = x^2$ from first principles.',
  to_jsonb(array[
    'Write out $f(x+h)$: $f(x+h) = (x+h)^2 = x^2+2xh+h^2$.',
    'Form the difference $f(x+h)-f(x)$: $(x^2+2xh+h^2) - x^2 = 2xh+h^2$.',
    'Divide by $h$: $\frac{2xh+h^2}{h} = \frac{h(2x+h)}{h} = 2x+h$ (for $h \neq 0$, the $h$''s cancel).',
    'Take the limit as $h \to 0$: $\lim_{h \to 0}(2x+h) = 2x+0 = 2x$.'
  ]),
  'This confirms the power rule for $n=2$: $\frac{d}{dx}[x^2] = 2x^{2-1} = 2x$, so once the power rule is trusted, this same result can be written down instantly without redoing the limit.',
  'published'
from lesson;

insert into public.worked_examples (lesson_id, title, problem_statement, solution_steps, exam_shortcut, common_trap_warning, status)
select l.id,
  'Derivative of 1/x from First Principles',
  'Find the derivative of $f(x) = \frac{1}{x}$ from first principles.',
  to_jsonb(array[
    'Write $f(x+h)$: $f(x+h) = \frac{1}{x+h}$.',
    'Form the difference and combine over a common denominator: $\frac{1}{x+h} - \frac{1}{x} = \frac{x - (x+h)}{x(x+h)} = \frac{-h}{x(x+h)}$.',
    'Divide by $h$: $\frac{-h / [x(x+h)]}{h} = \frac{-1}{x(x+h)}$ (the $h$''s cancel).',
    'Take the limit as $h \to 0$: $\frac{-1}{x(x+0)} = -\frac{1}{x^2}$.'
  ]),
  'This matches the power rule applied to $x^{-1}$: $\frac{d}{dx}[x^{-1}] = -1 \cdot x^{-2} = -\frac{1}{x^2}$, the same answer without any limit-taking.',
  'A very common algebra slip here is forgetting to combine the two fractions over a common denominator before subtracting, attempting to subtract $\frac{1}{x+h}-\frac{1}{x}$ term by term without a common denominator gives a wrong, unsimplifiable expression.',
  'published'
from public.lessons l join public.topics t on t.id = l.topic_id join public.curricula c on c.id = t.curriculum_id
where c.subject = 'Mathematics' and t.class_level = 'SS3' and t.term = 2 and t.order_index = 204;

insert into public.worked_examples (lesson_id, title, problem_statement, solution_steps, exam_shortcut, common_trap_warning, real_life_context, status)
select l.id,
  'Velocity, Rest, and a Moving Particle',
  'A particle moves along a line according to $s(t) = t^3 - 6t^2 + 9t$ ($s$ in metres, $t$ in seconds). Find (a) the velocity at any time $t$, (b) the velocity at $t=2$, (c) when the particle is at rest.',
  to_jsonb(array[
    'Differentiate $s(t)$ to get velocity (a): $v(t) = \frac{ds}{dt} = 3t^2 - 12t + 9$.',
    'Substitute $t=2$ for (b): $v(2) = 3(4) - 12(2) + 9 = 12 - 24 + 9 = -3$ m/s (the negative sign means the particle is momentarily moving in the reverse direction).',
    'Set $v(t) = 0$ and solve for (c): $3t^2 - 12t + 9 = 0$. Divide by 3: $t^2 - 4t + 3 = 0$. Factorise: $(t-1)(t-3) = 0$, giving $t=1$ or $t=3$.'
  ]),
  'Whenever a question asks "when is the particle at rest", set the VELOCITY function (the first derivative), not the position function, equal to zero, this is the single most tested trap on this topic.',
  'A very common exam error is solving $s(t)=0$ instead of $v(t)=0$; $s(t)=0$ finds when the particle is back at the STARTING POINT, a completely different question from when it is momentarily stationary.',
  'This is exactly how a driving-test examiner''s vehicle telemetry, or a delivery van''s GPS tracker, computes speed and momentary stops from a raw position-versus-time log, differentiate position to get speed, and look for where speed hits zero.',
  'published'
from public.lessons l join public.topics t on t.id = l.topic_id join public.curricula c on c.id = t.curriculum_id
where c.subject = 'Mathematics' and t.class_level = 'SS3' and t.term = 2 and t.order_index = 204;

insert into public.worked_examples (lesson_id, title, problem_statement, solution_steps, exam_shortcut, status)
select l.id,
  'Tangent and Normal to a Cubic Curve',
  'Find the equations of both the tangent and the normal to $y = x^3 - 3x$ at $x=2$.',
  to_jsonb(array[
    'Find the $y$-coordinate at $x=2$: $y = (2)^3 - 3(2) = 8-6 = 2$. The point is $(2,2)$.',
    'Differentiate to get the gradient function: $\frac{dy}{dx} = 3x^2 - 3$.',
    'Substitute $x=2$ to get the tangent''s slope: $m = 3(4) - 3 = 12-3 = 9$.',
    'Write the tangent equation using point-slope form, then simplify: $y-2 = 9(x-2) \Rightarrow y = 9x-18+2 = 9x-16$.',
    'The normal''s slope is the negative reciprocal of the tangent''s slope: $m_{\text{normal}} = -\frac{1}{9}$.',
    'Write the normal equation: $y-2 = -\frac{1}{9}(x-2) \Rightarrow 9y-18 = -x+2 \Rightarrow x+9y = 20$.'
  ]),
  'If a question instead asks where the tangent is PARALLEL to a given line, e.g. $y=4x-1$, just set the derivative equal to 4 and solve for $x$, no need to find the full tangent equation first.',
  'published'
from public.lessons l join public.topics t on t.id = l.topic_id join public.curricula c on c.id = t.curriculum_id
where c.subject = 'Mathematics' and t.class_level = 'SS3' and t.term = 2 and t.order_index = 204;

insert into public.questions (topic_id, lesson_id, question_text, option_a, option_b, option_c, option_d, correct_letter, difficulty, exam_type, explanation, status)
select t.id, l.id, q.question_text, q.option_a, q.option_b, q.option_c, q.option_d, q.correct_letter, q.difficulty, q.exam_type::exam_type, q.explanation, 'published'
from public.topics t
  join public.curricula c on c.id = t.curriculum_id
  join public.lessons l on l.topic_id = t.id,
  (values
  ('Evaluate: $\lim_{x \to 5}(x^2+2x)$.', '35', '30', '25', '45', 'A', 1, 'GENERAL', 'Direct substitution: 25+10=35.'),
  ('Evaluate: $\lim_{h \to 0} \frac{(x+h)^2-x^2}{h}$.', 'x', '2x', '2x+h', '$x^2$', 'B', 2, 'GENERAL', 'Expanding and cancelling gives 2x+h, and letting h approach 0 leaves 2x.'),
  ('Differentiate $y=x^3$ from first principles.', '$x^2$', '3x', '$3x^2$', '$x^3$', 'C', 2, 'GENERAL', 'Expanding (x+h)^3, subtracting x^3, dividing by h, then letting h approach 0 gives 3x^2.'),
  ('Find $f''(x)$ if $f(x)=3x^2+5x-2$.', '3x+5', '6x-5', '6x+2', '6x+5', 'D', 1, 'GENERAL', 'Differentiating term by term: 6x+5+0=6x+5.'),
  ('Differentiate $y=4x^3-7x^2+2x-9$.', '$12x^2-14x+2$', '$12x^2-14x-2$', '$12x^2-7x+2$', '$4x^2-14x+2$', 'A', 2, 'GENERAL', 'Differentiating term by term: 12x^2-14x+2+0.'),
  ('If $f(x)=x^4$, find $f''(2)$.', '16', '32', '8', '64', 'B', 2, 'GENERAL', 'f prime(x)=4x^3, so f prime(2)=4(8)=32.'),
  ('Find $\frac{dy}{dx}$ if $y=\frac{2x^3+3}{x}$.', '$4x+3/x^2$', '$2x-3/x^2$', '$4x-3/x^2$', '$4x-3/x$', 'C', 3, 'GENERAL', 'Split first: y=2x^2+3x^(-1). Differentiating: dy/dx=4x-3x^(-2)=4x-3/x^2.'),
  ('A particle''s position is $s(t)=t^3+4t$. Find its velocity at $t=3$.', '27', '35', '24', '31', 'D', 2, 'GENERAL', 'v(t)=3t^2+4, so v(3)=27+4=31.'),
  ('Find the slope of the tangent to $y=x^3$ at $x=1$.', '3', '1', '6', '9', 'A', 1, 'GENERAL', 'dy/dx=3x^2, so at x=1, slope=3.'),
  ('Differentiate $y=3x+\frac{2}{x}$.', '$3+2/x^2$', '$3-2/x^2$', '$3-2/x$', '$3-x^2$', 'B', 2, 'GENERAL', 'y=3x+2x^(-1). dy/dx=3-2x^(-2)=3-2/x^2.'),
  ('Evaluate: (a) $\lim_{x \to 4}\frac{x^2-16}{x-4}$, (b) $\lim_{h \to 0}\frac{(3+h)^2-9}{h}$, (c) $\lim_{x \to 2}\frac{x^3-8}{x-2}$, (d) $\lim_{h \to 0}\frac{(1+h)^3-1}{h}$.', '(a) 8 (b) 6 (c) 12 (d) 6', '(a) 4 (b) 6 (c) 12 (d) 3', '(a) 8 (b) 6 (c) 12 (d) 3', '(a) 8 (b) 3 (c) 12 (d) 3', 'C', 3, 'GENERAL', '(a) factor (x-4)(x+4)/(x-4) gives x+4=8. (b) expand and simplify to 6+h, giving 6. (c) factor (x-2)(x^2+2x+4)/(x-2) gives x^2+2x+4=12. (d) expand and simplify to 3+3h+h^2, giving 3.'),
  ('Differentiate from first principles: (a) $f(x)=3x+2$, (b) $f(x)=x^2+4x$, (c) $f(x)=2x^3$, (d) $f(x)=\frac{1}{x+1}$.', '(a) 3 (b) 2x+4 (c) $6x^2$ (d) $1/(x+1)^2$', '(a) 3x (b) 2x+4 (c) $6x^2$ (d) $-1/(x+1)^2$', '(a) 3 (b) x+4 (c) $6x^2$ (d) $-1/(x+1)^2$', '(a) 3 (b) 2x+4 (c) $6x^2$ (d) $-1/(x+1)^2$', 'D', 3, 'GENERAL', '(a) 3. (b) 2x+4. (c) 6x^2. (d) using the same combine-then-cancel method as 1/x, the result is -1/(x+1)^2.'),
  ('Find $\frac{dy}{dx}$ for: (a) $y=5x^2-3x^3+7$, (b) $y=2x^4+4x^3-6x+1$, (c) $y=x^5-2x^4+3x^2-x$, (d) $y=(x+1)(x^2-3)$, (e) $y=\frac{3x^2-4x}{x^2}$, (f) $y=4x^2-\frac{3}{x}+2\sqrt{x}$.', '(a) $10x-9x^2$ (b) $8x^3+12x^2-6$ (c) $5x^4-8x^3+6x-1$ (d) $3x^2+2x-3$ (e) $4/x^2$ (f) $8x-3/x^2+1/\sqrt{x}$', '(a) $10x+9x^2$ (b) $8x^3+12x^2-6$ (c) $5x^4-8x^3+6x-1$ (d) $3x^2+2x-3$ (e) $4/x^2$ (f) $8x+3/x^2+1/\sqrt{x}$', '(a) $10x-9x^2$ (b) $8x^3+12x^2-6$ (c) $5x^4-8x^3+6x-1$ (d) $3x^2-2x-3$ (e) $4/x^2$ (f) $8x+3/x^2+1/\sqrt{x}$', '(a) $10x-9x^2$ (b) $8x^3+12x^2-6$ (c) $5x^4-8x^3+6x-1$ (d) $3x^2+2x-3$ (e) $4/x^2$ (f) $8x+3/x^2+1/\sqrt{x}$', 'D', 4, 'GENERAL', 'Each part differentiates term by term with the power rule, splitting fractions where needed (e.g. part (e) simplifies to 3-4/x before differentiating).'),
  ('A particle moves according to $s=t^3-9t^2+15t$. Find (i) the velocity function, (ii) the velocity at $t=2$, (iii) when it is at rest, (iv) the acceleration function.', '(i) $3t^2-18t+15$ (ii) -9 (iii) t=1,5 (iv) $6t+18$', '(i) $3t^2-18t+15$ (ii) -9 (iii) t=1,3 (iv) $6t-18$', '(i) $3t^2-18t+15$ (ii) 9 (iii) t=1,5 (iv) $6t-18$', '(i) $3t^2-18t+15$ (ii) -9 (iii) t=1,5 (iv) $6t-18$', 'D', 3, 'GENERAL', 'v(t)=3t^2-18t+15. v(2)=12-36+15=-9. Setting v(t)=0: t^2-6t+5=0, giving t=1 or t=5. a(t)=6t-18.'),
  ('A ball''s height is $h=20t-5t^2$. Find (i) the initial velocity, (ii) the time to reach maximum height, (iii) the maximum height.', '(i) 20 (ii) t=2 (iii) 40', '(i) 10 (ii) t=2 (iii) 20', '(i) 20 (ii) t=2 (iii) 20', '(i) 20 (ii) t=4 (iii) 20', 'C', 3, 'GENERAL', 'v=20-10t; initial velocity (t=0) is 20. Maximum height at v=0: t=2. h(2)=40-20=20.'),
  ('Find the equation of the tangent to $y=x^2+2x$ at $(1,3)$.', '4x+1', '2x-1', '4x-3', '4x-1', 'D', 2, 'GENERAL', 'dy/dx=2x+2; at x=1, slope=4. y-3=4(x-1) gives y=4x-1.'),
  ('Find the equations of the tangent and normal to $y=x^3-3x^2$ at $x=2$.', 'Point (2,-4); tangent y=-4; normal x=-2', 'Point (2,-4); tangent y=4; normal x=2', 'Point (2,4); tangent y=-4; normal x=2', 'Point (2,-4); tangent y=-4; normal x=2', 'D', 4, 'GENERAL', 'y(2)=8-12=-4. dy/dx=3x^2-6x, at x=2 this is 0 (a horizontal tangent), giving tangent y=-4. The normal, perpendicular to a horizontal line, is the vertical line x=2.'),
  ('At what point on $y=x^2$ is the tangent parallel to $y=4x-1$?', '(4,2)', '(2,4)', '(2,-4)', '(-2,4)', 'B', 2, 'GENERAL', 'dy/dx=2x=4 gives x=2, y=4, so the point is (2,4).'),
  ('Find the point on $y=x^3$ where the tangent is horizontal.', '(1,1)', '(-1,-1)', '(0,0)', 'No such point exists', 'C', 2, 'GENERAL', 'dy/dx=3x^2=0 gives x=0, y=0, so the point is (0,0).'),
  ('If $f(x)=ax^2+bx+c$ with $f''(1)=8$, $f''(2)=14$, and $f(0)=5$, find $a$, $b$, $c$.', 'a=3, b=2, c=0', 'a=2, b=3, c=5', 'a=3, b=8, c=5', 'a=3, b=2, c=5', 'D', 4, 'GENERAL', 'f prime(x)=2ax+b. 2a+b=8 and 4a+b=14; subtracting gives 2a=6, a=3, then b=2. f(0)=c=5.'),
  ('The curve $y=x^2+px+q$ passes through $(1,6)$ with slope 5 there. Find $p$ and $q$.', 'p=3, q=2', 'p=5, q=1', 'p=3, q=-2', 'p=2, q=3', 'A', 3, 'GENERAL', 'dy/dx=2x+p; at x=1, 2+p=5 gives p=3. y(1)=1+3+q=6 gives q=2.'),
  ('Using the binomial expansion of $(x+h)^4$, find $f''(x)$ for $f(x)=x^4$ from first principles.', '$x^4$', '$4x^3$', '$x^3$', '$4x^2$', 'B', 3, 'GENERAL', 'Expanding (x+h)^4, subtracting x^4, dividing by h and letting h approach 0 leaves 4x^3, confirming the power rule for n=4.'),
  ('Find the derivative of $y=\frac{1}{x}$ from first principles.', '$1/x^2$', '$-1/x$', '$-1/x^2$', '$-2/x^3$', 'C', 2, 'GENERAL', 'Combining fractions and cancelling h gives -1/[x(x+h)], and letting h approach 0 leaves -1/x^2.'),
  ('Find $f''(x)$ if $f(x)=2x+5$ using first principles.', '5', '0', '2x', '2', 'D', 1, 'GENERAL', 'f(x+h)-f(x)=2h, dividing by h gives 2, and the limit as h approaches 0 is still 2 (no h remains).'),
  ('Differentiate $\frac{1}{x^3}$ from first principles.', '$-3/x^4$', '$3/x^4$', '$-3/x^3$', '$-1/x^4$', 'A', 3, 'GENERAL', 'f(x)=x^(-3), and by the power rule (confirmed via first principles), f prime(x)=-3x^(-4)=-3/x^4.'),
  ('Differentiate $5x-\frac{1}{x^2}$ from first principles.', '$5-2/x^3$', '$5+2/x^3$', '$5+2/x^2$', '$2/x^3$', 'B', 3, 'GENERAL', 'f(x)=5x-x^(-2). f prime(x)=5+2x^(-3)=5+2/x^3.')
) as q(question_text, option_a, option_b, option_c, option_d, correct_letter, difficulty, exam_type, explanation)
where c.subject = 'Mathematics' and t.class_level = 'SS3' and t.term = 2 and t.order_index = 204;

-- ------------------------------------------
-- 205. DIFFERENTIATION: RULES, MAXIMA & MINIMA
-- No coordinate_plane or other diagram: product/quotient/chain rule
-- algebra and optimisation word problems have no single natural static
-- figure here, matching the standing instruction not to force one.
-- ------------------------------------------

with lesson as (
  insert into public.lessons (topic_id, title, summary, content_body, order_index)
  values (
    (select t.id from public.topics t join public.curricula c on c.id = t.curriculum_id
     where c.subject = 'Mathematics' and t.class_level = 'SS3' and t.term = 2 and t.order_index = 205),
    'Differentiation: Product, Quotient and Chain Rules, Maxima and Minima',
    'Differentiating products, quotients and functions-of-functions, using related rates, finding and classifying stationary points with the second-derivative test, and solving real optimisation word problems.',
    '### Product Rule

If $y = u \cdot v$ (both functions of $x$): $\frac{dy}{dx} = u\frac{dv}{dx} + v\frac{du}{dx}$. Memory aid: "first times derivative of second, plus second times derivative of first."

### Quotient Rule

If $y = \frac{u}{v}$: $\frac{dy}{dx} = \frac{v\frac{du}{dx} - u\frac{dv}{dx}}{v^2}$. Memory aid: "bottom times derivative of top, minus top times derivative of bottom, all over bottom squared." Say it out loud in this order every time, it prevents the sign error that is the single most common quotient-rule mistake.

### Chain Rule

If $y = f(u)$ and $u = g(x)$: $\frac{dy}{dx} = \frac{dy}{du} \times \frac{du}{dx}$, used whenever you have "a function of a function." Differentiate the outer function (leaving the inner one alone), then multiply by the derivative of the inner function.

**Fast pattern for $(ax+b)^n$**: $\frac{d}{dx}[(ax+b)^n] = n \cdot a \cdot (ax+b)^{n-1}$, just multiply the usual power-rule result by the derivative of the inner bracket (simply $a$).

**Related rates** connect several quantities changing with time via the chain rule, e.g. $\frac{dV}{dt} = \frac{dV}{dr} \times \frac{dr}{dt}$.

### Stationary Points and the Second-Derivative Test

Stationary (turning) points occur where $f''(x)=0$. Classify each using the **second derivative**:
- $f''''(x) < 0 \Rightarrow$ maximum
- $f''''(x) > 0 \Rightarrow$ minimum
- $f''''(x) = 0 \Rightarrow$ inconclusive (test values either side instead)

This is much faster than sign-testing either side of every stationary $x$-value.

### Optimisation

Set up a single-variable function for the quantity being maximised or minimised (using a given constraint to eliminate the other variable), differentiate, set the derivative to zero, solve, and classify with the second derivative. If the optimal dimensions come out equal, that is a strong hint your algebra is on the right track (many perimeter/area optimisations peak at a square).

**Marginal quantities**: Marginal Cost, Marginal Revenue, and Marginal Profit are simply the derivative of the respective Total Cost, Total Revenue, or Total Profit function, no extra economics reasoning needed, just differentiate.

### Glossary

- **Stationary point (turning point)**: a point on a curve where the gradient (derivative) is exactly zero, the curve is momentarily flat there, either a peak, a trough, or a "shoulder."
- **Second derivative**: the derivative of the derivative, it measures how the gradient itself is changing, and tells you whether a stationary point is a peak (maximum) or a trough (minimum).
- **Marginal cost**: the extra cost of producing exactly one more unit, found by differentiating the total cost function, like the price a market trader pays for just one more extra bag of rice on top of their usual order.
- **Related rates**: a problem connecting how fast several different quantities change over time, e.g. a balloon''s radius growing at one rate driving how fast its volume grows too.',
    1
  )
  returning id
)
insert into public.worked_examples (lesson_id, title, problem_statement, solution_steps, exam_shortcut, status)
select id,
  'Product Rule',
  'Differentiate $y=(3x^2+2)(4x^3-5)$ using the product rule.',
  to_jsonb(array[
    'Identify $u$ and $v$, and differentiate each: $u=3x^2+2 \Rightarrow \frac{du}{dx}=6x$; $v=4x^3-5 \Rightarrow \frac{dv}{dx}=12x^2$.',
    'Apply the product rule $\frac{dy}{dx} = u\frac{dv}{dx}+v\frac{du}{dx}$: $\frac{dy}{dx} = (3x^2+2)(12x^2) + (4x^3-5)(6x)$.',
    'Expand each bracket: $(3x^2+2)(12x^2) = 36x^4+24x^2$; $(4x^3-5)(6x) = 24x^4-30x$.',
    'Combine like terms: $36x^4+24x^2+24x^4-30x = 60x^4+24x^2-30x$.',
    'Check by expanding $y$ first and differentiating directly: $y=12x^5-15x^2+8x^3-10 \Rightarrow \frac{dy}{dx}=60x^4-30x+24x^2$, the same result ✓.'
  ]),
  'Chant the product rule as "first times derivative of second, plus second times derivative of first" every single time, this word order never lets you mix up which factor gets differentiated first.',
  'published'
from lesson;

insert into public.worked_examples (lesson_id, title, problem_statement, solution_steps, exam_shortcut, common_trap_warning, status)
select l.id,
  'Quotient Rule',
  'Differentiate $y=\frac{3x+2}{x-1}$ using the quotient rule.',
  to_jsonb(array[
    'Identify $u$ and $v$, and differentiate each: $u=3x+2 \Rightarrow \frac{du}{dx}=3$; $v=x-1 \Rightarrow \frac{dv}{dx}=1$.',
    'Apply the quotient rule $\frac{dy}{dx}=\frac{v\frac{du}{dx}-u\frac{dv}{dx}}{v^2}$: $\frac{dy}{dx} = \frac{(x-1)(3) - (3x+2)(1)}{(x-1)^2}$.',
    'Expand the numerator: $(x-1)(3) = 3x-3$; $(3x+2)(1) = 3x+2$.',
    'Subtract and simplify: $(3x-3) - (3x+2) = 3x-3-3x-2 = -5$.',
    'Final answer: $\frac{dy}{dx} = \frac{-5}{(x-1)^2}$.'
  ]),
  'Say "bottom times derivative of top, minus top times derivative of bottom, all over bottom squared" out loud, in exactly that order, every time, it is the fastest guard against a sign error here.',
  'Writing the numerator the wrong way round, "top times derivative of bottom minus bottom times derivative of top", silently flips the sign of the whole answer, always double-check which term comes first.',
  'published'
from public.lessons l join public.topics t on t.id = l.topic_id join public.curricula c on c.id = t.curriculum_id
where c.subject = 'Mathematics' and t.class_level = 'SS3' and t.term = 2 and t.order_index = 205;

insert into public.worked_examples (lesson_id, title, problem_statement, solution_steps, exam_shortcut, status)
select l.id,
  'Stationary Points and the Second-Derivative Test',
  'Find the stationary points of $f(x)=x^3-3x^2-9x+5$, and classify each.',
  to_jsonb(array[
    'Differentiate: $f''(x) = 3x^2-6x-9$.',
    'Set $f''(x)=0$ and simplify: $3x^2-6x-9=0 \Rightarrow$ divide by 3: $x^2-2x-3=0$.',
    'Factorise: $(x-3)(x+1)=0 \Rightarrow x=3$ or $x=-1$.',
    'Find the $y$-coordinates: $f(3)=27-27-27+5=-22$; $f(-1)=-1-3+9+5=10$. Stationary points: $(-1,10)$ and $(3,-22)$.',
    'Differentiate again for the second-derivative test: $f''''(x) = 6x-6$.',
    'Test each point: at $x=-1$: $f''''(-1)=-6-6=-12<0 \Rightarrow$ maximum; at $x=3$: $f''''(3)=18-6=12>0 \Rightarrow$ minimum.'
  ]),
  'Once you have both stationary $x$-values, plug each straight into $f''''(x)$: negative means maximum, positive means minimum, no need to test values on either side unless $f''''(x)=0$ exactly.',
  'published'
from public.lessons l join public.topics t on t.id = l.topic_id join public.curricula c on c.id = t.curriculum_id
where c.subject = 'Mathematics' and t.class_level = 'SS3' and t.term = 2 and t.order_index = 205;

insert into public.worked_examples (lesson_id, title, problem_statement, solution_steps, exam_shortcut, real_life_context, status)
select l.id,
  'Optimisation: Maximum Area with Fixed Fencing',
  'A farmer has 200 m of fencing for a rectangular plot. Find the dimensions that give the maximum area.',
  to_jsonb(array[
    'Set up the constraint: let the sides be $x$ and $y$; perimeter $2x+2y=200 \Rightarrow y=100-x$.',
    'Write the area as a function of one variable: $A = xy = x(100-x) = 100x-x^2$.',
    'Differentiate and set to zero: $\frac{dA}{dx} = 100-2x = 0 \Rightarrow x=50$.',
    'Find $y$: $y = 100-50 = 50$.',
    'Confirm it is a maximum: $\frac{d^2A}{dx^2} = -2 < 0 \Rightarrow$ maximum ✓.',
    'Compute the maximum area: $A = 50 \times 50 = 2{,}500$ m².'
  ]),
  'A perimeter-fixed rectangle always maximises area as a square, so once the algebra gives equal side lengths, that itself is a strong self-check that no arithmetic mistake was made along the way.',
  'This is exactly the calculation a Nigerian poultry or crop farmer runs before buying fencing wire, given a fixed roll length, the largest usable pen area is always a square, not a long thin rectangle.',
  'published'
from public.lessons l join public.topics t on t.id = l.topic_id join public.curricula c on c.id = t.curriculum_id
where c.subject = 'Mathematics' and t.class_level = 'SS3' and t.term = 2 and t.order_index = 205;

insert into public.questions (topic_id, lesson_id, question_text, option_a, option_b, option_c, option_d, correct_letter, difficulty, exam_type, explanation, status)
select t.id, l.id, q.question_text, q.option_a, q.option_b, q.option_c, q.option_d, q.correct_letter, q.difficulty, q.exam_type::exam_type, q.explanation, 'published'
from public.topics t
  join public.curricula c on c.id = t.curriculum_id
  join public.lessons l on l.topic_id = t.id,
  (values
  ('Differentiate using the product rule: $y=(2x+3)(x^2-1)$.', '$6x^2+6x-2$', '$6x^2+6x+2$', '$4x^2+6x-2$', '$6x^2-6x-2$', 'A', 2, 'GENERAL', 'u=2x+3, du=2; v=x^2-1, dv=2x. dy/dx=(2x+3)(2x)+(x^2-1)(2)=4x^2+6x+2x^2-2=6x^2+6x-2.'),
  ('Use the quotient rule: $y=\frac{3x+1}{x-2}$.', '$7/(x-2)^2$', '$-7/(x-2)^2$', '$-7/(x-2)$', '$-5/(x-2)^2$', 'B', 2, 'GENERAL', 'u=3x+1,du=3; v=x-2,dv=1. dy/dx=[(x-2)(3)-(3x+1)(1)]/(x-2)^2=[3x-6-3x-1]/(x-2)^2=-7/(x-2)^2.'),
  ('Differentiate using the chain rule: $y=(5x-3)^4$.', '$4(5x-3)^3$', '$20(5x-3)^4$', '$20(5x-3)^3$', '$5(5x-3)^3$', 'C', 2, 'GENERAL', 'dy/dx=4(5x-3)^3 times 5=20(5x-3)^3.'),
  ('Find $f''(x)$ if $f(x)=x^2(x+1)^3$.', '$x(x+1)^3(5x+2)$', '$x(x+1)^2(5x-2)$', '$2x(x+1)^2(5x+2)$', '$x(x+1)^2(5x+2)$', 'D', 3, 'GENERAL', 'Product rule: f prime=2x(x+1)^3+3x^2(x+1)^2, factoring x(x+1)^2 out gives x(x+1)^2[2(x+1)+3x]=x(x+1)^2(5x+2).'),
  ('Differentiate $y=\sqrt{x^2+4}$.', '$x/\sqrt{x^2+4}$', '$x/(x^2+4)$', '$2x/\sqrt{x^2+4}$', '$1/\sqrt{x^2+4}$', 'A', 3, 'GENERAL', 'y=(x^2+4)^(1/2). dy/dx=(1/2)(x^2+4)^(-1/2) times 2x=x/sqrt(x^2+4).'),
  ('A cube''s edge increases at 2 cm/s. Find the rate of volume increase when the edge is 5 cm.', '100 cm3/s', '150 cm3/s', '75 cm3/s', '300 cm3/s', 'B', 3, 'GENERAL', 'V=e^3, dV/dt=3e^2 times de/dt=3(25)(2)=150.'),
  ('Find and classify the stationary point of $f(x)=x^2-12x+5$.', 'Maximum at (6,-31)', 'Minimum at (-6,-31)', 'Minimum at (6,-31)', 'Minimum at (6,31)', 'C', 2, 'GENERAL', 'f prime=2x-12=0 gives x=6. f(6)=36-72+5=-31. f double-prime=2>0, so it is a minimum.'),
  ('A cost function is $C(x)=100+10x+0.5x^2$. Find the marginal cost at $x=20$.', '20', '10', '40', '30', 'D', 2, 'GENERAL', 'MC=C prime(x)=10+x. At x=20, MC=30.'),
  ('Find $\frac{dy}{dx}$ if $y=\frac{(2x+1)^3}{x-3}$.', '$(2x+1)^2(4x-19)/(x-3)^2$', '$(2x+1)^2(4x+19)/(x-3)^2$', '$(2x+1)^2(4x-19)/(x-3)$', '$(2x+1)(4x-19)/(x-3)^2$', 'A', 4, 'GENERAL', 'Combining the quotient rule with the chain rule on u=(2x+1)^3: dy/dx=[(x-3) times 6(2x+1)^2 - (2x+1)^3]/(x-3)^2, and factoring out (2x+1)^2 gives (2x+1)^2[6(x-3)-(2x+1)]/(x-3)^2=(2x+1)^2(4x-19)/(x-3)^2.'),
  ('Maximise the area of a rectangle with perimeter 60 m.', 'Rectangle 10m by 30m, area 300m2', 'Square 15m by 15m, area 225m2', 'Rectangle 20m by 10m, area 200m2', 'Rectangle 12.5m by 17.5m, area 218.75m2', 'B', 2, 'GENERAL', 'x+y=30, A=x(30-x)=30x-x^2. dA/dx=30-2x=0 gives x=15, y=15, area=225 m2 (a square).'),
  ('Differentiate: (a) $y=(x^2+2)(x^2-4)$, (b) $y=(3x+1)(2x^2+5x-3)$, (c) $y=x^2(x-2)^3$, (d) $f(x)=(x^2+1)(x+3)$.', '(a) $4x^3-4x$ (b) $18x^2+22x-13$ (c) $2x(x-2)^3+3x^2(x-2)^2$ (d) $3x^2+6x+1$', '(a) $4x^3+4x$ (b) $18x^2+34x-4$ (c) $2x(x-2)^3+3x^2(x-2)^2$ (d) $3x^2+6x+1$', '(a) $4x^3-4x$ (b) $18x^2+34x-4$ (c) $2x(x-2)^3+3x^2(x-2)^2$ (d) $3x^2+6x+1$', '(a) $4x^3-4x$ (b) $18x^2+34x-4$ (c) $2x(x-2)^3+3x^2(x-2)^2$ (d) $3x^2-6x+1$', 'C', 4, 'GENERAL', '(a) product rule gives 2x[(x^2+2)+(x^2-4)]=4x^3-4x. (b) product rule gives (3x+1)(4x+5)+3(2x^2+5x-3)=(12x^2+19x+5)+(6x^2+15x-9)=18x^2+34x-4 (verified also by expanding the whole product first and differentiating directly). (c) product+chain rule, left unsimplified as given. (d) product rule gives 3x^2+6x+1. (Corrected: an earlier version of this exercise stated part (b) as 18x^2+22x-13, which does not match either method of differentiating this product.)'),
  ('Find $\frac{dy}{dx}$: (a) $y=\frac{x+1}{x-1}$, (b) $y=\frac{2x^2+3}{x+2}$, (c) $y=\frac{x}{x^2+4}$, (d) $y=\frac{x^2-1}{x^2+1}$.', '(a) $2/(x-1)^2$ (b) $(2x^2+8x-3)/(x+2)^2$ (c) $(4-x^2)/(x^2+4)^2$ (d) $4x/(x^2+1)^2$', '(a) $-2/(x-1)^2$ (b) $(2x^2-8x-3)/(x+2)^2$ (c) $(4-x^2)/(x^2+4)^2$ (d) $4x/(x^2+1)^2$', '(a) $-2/(x-1)^2$ (b) $(2x^2+8x-3)/(x+2)^2$ (c) $(x^2-4)/(x^2+4)^2$ (d) $4x/(x^2+1)^2$', '(a) $-2/(x-1)^2$ (b) $(2x^2+8x-3)/(x+2)^2$ (c) $(4-x^2)/(x^2+4)^2$ (d) $4x/(x^2+1)^2$', 'D', 4, 'GENERAL', 'Each part applies the quotient rule directly: (a) -2/(x-1)^2. (b) (2x^2+8x-3)/(x+2)^2. (c) (4-x^2)/(x^2+4)^2. (d) 4x/(x^2+1)^2.'),
  ('Differentiate: (a) $y=(4x-7)^3$, (b) $y=\sqrt{x^2+3x-1}$, (c) $y=(5x+2)^4$, (d) $y=\frac{1}{(3x-4)^2}$, (e) $f(x)=(2x^2-x+1)^{-2}$.', '(a) $12(4x-7)^2$ (b) $(2x+3)/[2\sqrt{x^2+3x-1}]$ (c) $20(5x+2)^3$ (d) $-6/(3x-4)^3$ (e) $-2(4x-1)/(2x^2-x+1)^3$', '(a) $12(4x-7)^3$ (b) $(2x+3)/[2\sqrt{x^2+3x-1}]$ (c) $20(5x+2)^3$ (d) $-6/(3x-4)^3$ (e) $-2(4x-1)/(2x^2-x+1)^3$', '(a) $12(4x-7)^2$ (b) $(2x-3)/[2\sqrt{x^2+3x-1}]$ (c) $20(5x+2)^3$ (d) $-6/(3x-4)^3$ (e) $-2(4x-1)/(2x^2-x+1)^3$', '(a) $12(4x-7)^2$ (b) $(2x+3)/[2\sqrt{x^2+3x-1}]$ (c) $20(5x+2)^4$ (d) $-6/(3x-4)^3$ (e) $-2(4x-1)/(2x^2-x+1)^3$', 'A', 4, 'GENERAL', 'Each part uses the chain rule pattern n times the derivative of the inner function times the outer power reduced by 1: (a) 12(4x-7)^2. (b) (2x+3)/[2 sqrt(x^2+3x-1)]. (c) 20(5x+2)^3. (d) -6/(3x-4)^3. (e) -2(4x-1)/(2x^2-x+1)^3.'),
  ('Find $\frac{dy}{dx}$: (a) $y=x^2(2x+1)^4$, (b) $y=\frac{(x+3)^2}{x-2}$, (c) $y=(x^2+1)^3(x-1)$, (d) $y=\frac{(x^2+1)^2}{(2x-1)^2}$.', '(a) $2x(2x+1)^3(6x+1)$ (b) $(x+3)(x-7)/(x-2)^2$ (c) $(x^2+1)^2(7x^2-6x+1)$ (d) $4(x^2+1)(x^2+x-1)/(2x-1)^3$', '(a) $2x(2x+1)^3(6x+1)$ (b) $(x+3)(x-7)/(x-2)^2$ (c) $(x^2+1)^2(7x^2-6x+1)$ (d) $4(x^2+1)(x^2-x-1)/(2x-1)^3$', '(a) $2x(2x+1)^4(6x+1)$ (b) $(x+3)(x-7)/(x-2)^2$ (c) $(x^2+1)^2(7x^2-6x+1)$ (d) $4(x^2+1)(x^2-x-1)/(2x-1)^3$', '(a) $2x(2x+1)^3(6x+1)$ (b) $(x-3)(x-7)/(x-2)^2$ (c) $(x^2+1)^2(7x^2-6x+1)$ (d) $4(x^2+1)(x^2-x-1)/(2x-1)^3$', 'B', 5, 'GENERAL', 'Each part combines the product or quotient rule with the chain rule: (a) 2x(2x+1)^3(6x+1). (b) (x+3)(x-7)/(x-2)^2. (c) (x^2+1)^2(7x^2-6x+1). (d) 4(x^2+1)(x^2-x-1)/(2x-1)^3.'),
  ('A circle''s radius increases at 3 cm/s. Find the rate of increase of (i) its circumference, (ii) its area, when $r=10$ cm.', '(i) $3\pi$ cm/s (ii) $30\pi$ cm2/s', '(i) $6\pi$ cm/s (ii) $30\pi$ cm2/s', '(i) $6\pi$ cm/s (ii) $60\pi$ cm2/s', '(i) $9\pi$ cm/s (ii) $60\pi$ cm2/s', 'C', 3, 'GENERAL', 'dC/dt=2*pi*dr/dt=6*pi. dA/dt=2*pi*r*dr/dt=2*pi(10)(3)=60*pi.'),
  ('A 10 m ladder leans against a wall; its bottom slides away at 0.5 m/s. How fast is the top sliding down when the bottom is 6 m from the wall?', '1/2 m/s', '3/4 m/s', '1/8 m/s', '3/8 m/s', 'D', 4, 'GENERAL', 'x^2+y^2=100; at x=6, y=8. Differentiating: 2x dx/dt+2y dy/dt=0, giving dy/dt=-(x/y)(dx/dt)=-(6/8)(0.5)=-3/8 m/s (the negative sign shows the top is moving down).'),
  ('Find and classify the stationary points: (i) $f(x)=x^3-6x^2+9x+2$, (ii) $y=2x^3+3x^2-12x+5$.', '(i) max(1,6), min(3,2) (ii) max(1,25), min(-2,-2)', '(i) min(1,6), max(3,2) (ii) max(-2,25), min(1,-2)', '(i) max(1,6), min(3,2) (ii) max(-2,25), min(1,-2)', '(i) max(1,6), min(3,2) (ii) max(-2,-2), min(1,25)', 'C', 3, 'GENERAL', '(i) f prime=3x^2-12x+9=0 gives x=1,3; f double-prime=6x-12 classifies x=1 as max(1,6) and x=3 as min(3,2). (ii) y prime=6x^2+6x-12=0 gives x=1,-2; classified as max(-2,25) and min(1,-2).'),
  ('Find the absolute maximum and minimum of $f(x)=x^4-8x^2+3$ on the domain $-3 \leq x \leq 3$.', 'Minimum -13 at x=0; maximum 3 at x=+-2', 'Minimum 3 at x=0; maximum 12 at x=+-3', 'Minimum -13 at x=+-2; maximum 12 at x=+-3', 'Minimum -13 at x=+-2; maximum 3 at x=0', 'C', 5, 'GENERAL', 'f prime=4x^3-16x=4x(x-2)(x+2)=0 gives x=0,+-2. f(0)=3 (a local max), f(+-2)=-13 (a local min). Because the domain is restricted, the endpoints must also be checked: f(+-3)=12, which beats the local max of 3. So the absolute minimum on this domain is -13 at x=+-2, and the absolute maximum is 12 at x=+-3 (not the interior local maximum at x=0).'),
  ('A rectangle has perimeter 40 cm. Find the dimensions for maximum area.', 'Rectangle 15cm by 5cm, area 75cm2', 'Rectangle 12cm by 8cm, area 96cm2', 'Rectangle 18cm by 2cm, area 36cm2', 'Square 10cm by 10cm, area 100cm2', 'D', 2, 'GENERAL', 'x+y=20, A=x(20-x). dA/dx=20-2x=0 gives x=10, y=10 (a square), area=100 cm2.'),
  ('Find two positive numbers whose sum is 20 and whose product is maximum.', '10 and 10', '8 and 12', '5 and 15', '9 and 11', 'A', 2, 'GENERAL', 'Let the numbers be x and 20-x. P=x(20-x)=20x-x^2. dP/dx=20-2x=0 gives x=10, and the other number is also 10.'),
  ('Total revenue is $R(x)=50x-0.5x^2$. Find (i) the marginal revenue, (ii) the revenue-maximising quantity, (iii) the maximum revenue.', '(i) 50-x (ii) x=50 (iii) 2500', '(i) 50-x (ii) x=50 (iii) 1250', '(i) 50-0.5x (ii) x=100 (iii) 2500', '(i) 50-x (ii) x=25 (iii) 625', 'B', 3, 'GENERAL', 'MR=R prime(x)=50-x. Setting MR=0 gives x=50. R(50)=2500-1250=1250.'),
  ('Given $C(x)=200+30x+0.1x^2$ and $R(x)=80x-0.2x^2$, find (i) the profit function, (ii) the marginal profit, (iii) the profit-maximising quantity, (iv) the maximum profit.', '(i) $-0.3x^2+50x-200$ (ii) $-0.6x+50$ (iii) x=50 (iv) approximately N1,050', '(i) $-0.3x^2+50x+200$ (ii) $-0.6x+50$ (iii) x=83.3 (iv) approximately N2,083.33', '(i) $-0.3x^2+50x-200$ (ii) $-0.6x+50$ (iii) x=83.3 (iv) approximately N1,883.33', '(i) $-0.3x^2+50x-200$ (ii) $0.6x+50$ (iii) x=83.3 (iv) approximately N1,883.33', 'C', 5, 'GENERAL', 'Profit P=R-C=-0.3x^2+50x-200. Marginal profit P prime=-0.6x+50. Setting P prime=0 gives x=83.33. P(83.33)=-2083.33+4166.67-200=approximately N1,883.33.'),
  ('A company''s profit is $P(t)=-t^3+15t^2+72t$ (in N1,000s). Find (i) the rate of profit growth, (ii) when profit is increasing fastest, (iii) the maximum profit and when it occurs.', '(i) $-3t^2+30t+72$ (ii) t=5 (iii) maximum profit N1,296,000 at t=-2', '(i) $-3t^2+30t+72$ (ii) t=10 (iii) maximum profit N1,296,000 at t=12', '(i) $3t^2+30t+72$ (ii) t=5 (iii) maximum profit N1,296,000 at t=12', '(i) $-3t^2+30t+72$ (ii) t=5 (iii) maximum profit N1,296,000 at t=12', 'D', 5, 'GENERAL', 'P prime(t)=-3t^2+30t+72. Profit growth is fastest where P double-prime(t)=-6t+30=0, giving t=5. Maximum profit itself is where P prime(t)=0: -3t^2+30t+72=0 simplifies to t^2-10t-24=0, giving (t-12)(t+2)=0, so t=12 (t=-2 rejected as negative time). P(12)=-1728+2160+864=1296 (in N1,000s), i.e. N1,296,000, confirmed a maximum since P double-prime(12)=-42<0.'),
  ('A rectangular garden is fenced on 3 sides, with the 4th side an existing wall, using 60 m of fencing. Find the dimensions that maximise the area.', 'Width (perpendicular) 30m, length (parallel to wall) 30m, area 450m2', 'Width (perpendicular) 20m, length (parallel to wall) 20m, area 400m2', 'Width (perpendicular) 10m, length (parallel to wall) 40m, area 400m2', 'Width (perpendicular) 15m, length (parallel to wall) 30m, area 450m2', 'D', 4, 'GENERAL', 'Let w=each perpendicular side, l=the side parallel to the wall: 2w+l=60, so l=60-2w. Area A(w)=w(60-2w)=60w-2w^2. dA/dw=60-4w=0 gives w=15, l=30, area=450 m2. (Corrected: an earlier version of this exercise stated both sides as 30m, which is internally inconsistent, that would use 90m of fencing, not 60m, and give an area of 900m2, not 450m2.)'),
  ('A cylindrical can must contain 1,000 cm3. Find the dimensions that minimise its surface area.', 'r = (1000/pi)^(1/3), h = r', 'r = (500/pi)^(1/3), h = 2r', 'r = (500/pi)^(1/3), h = r', 'r = (250/pi)^(1/3), h = 2r', 'B', 5, 'GENERAL', 'With V=pi*r^2*h and surface area S=2*pi*r^2+2V/r, minimising gives r^3=V/(2*pi), i.e. r=(500/pi)^(1/3) (since 1000/(2*pi)=500/pi), and h=V/(pi*r^2) works out to exactly 2r.'),
  ('A wire 100 cm long is cut into two pieces, one bent into a square, the other into a circle. What cutting choice (i) minimises, (ii) maximises, the total enclosed area?', '(i) split the wire equally 50/50 (ii) all wire to the square', '(i) about 56cm to the square, 44cm to the circle (ii) all wire to the square', '(i) about 56cm to the square, 44cm to the circle (ii) all wire to the circle', '(i) about 44cm to the square, 56cm to the circle (ii) all wire to the circle', 'C', 5, 'GENERAL', 'Minimising total area A(x)=x^2/16+(100-x)^2/(4*pi) gives x=800/(2*pi+8), approximately 56.0 cm to the square (approximately 44.0 cm to the circle), minimum area approximately 350 cm2. Since this total-area function is convex over [0,100], its maximum instead occurs at an endpoint: all-circle (x=0) gives area approximately 795.8 cm2, versus all-square (x=100) giving only 625 cm2, so the maximum is achieved by putting all the wire into the circle.'),
  ('A box with a square base and an open top must have volume 32 cm3. Find the dimensions that minimise its surface area.', 'Base 2cm by 2cm, height 8cm', 'Base 8cm by 8cm, height 0.5cm', 'Base 4cm by 4cm, height 4cm', 'Base 4cm by 4cm, height 2cm', 'D', 4, 'GENERAL', 'With base side x and height h, V=x^2*h=32 gives h=32/x^2. Surface area (open top) S=x^2+4xh=x^2+128/x. dS/dx=2x-128/x^2=0 gives x^3=64, so x=4, h=32/16=2.'),
  ('Find the minimum value of $y=2x^3-6x+3$.', '-1', '1', '-3', '5', 'A', 3, 'GENERAL', 'y prime=6x^2-6=0 gives x=+-1. y double-prime=12x classifies x=1 as a minimum. y(1)=2-6+3=-1.'),
  ('Find the maximum value of $f(x)=x^3-12x+5$.', '-11', '21', '13', '29', 'B', 3, 'GENERAL', 'f prime=3x^2-12=0 gives x=+-2. f double-prime=6x classifies x=-2 as a maximum. f(-2)=-8+24+5=21.'),
  ('Obtain the maximum value of $f(x)=x^3-12x+11$.', '-5', '19', '27', '35', 'C', 3, 'GENERAL', 'f prime=3x^2-12=0 gives x=+-2. x=-2 is the maximum: f(-2)=-8+24+11=27.'),
  ('Find the coordinates of point $P$, the maximum point on $y=x^3+3x^2-7$.', '(0,-7)', '(2,13)', '(-2,3)', '(-2,-3)', 'D', 3, 'GENERAL', 'y prime=3x^2+6x=3x(x+2)=0 gives x=0,-2. y double-prime=6x+6 classifies x=-2 as a maximum. y(-2)=-8+12-7=-3.'),
  ('Find the turning points of $y=2x^3-6x^2-18x+3$.', '(-1,-13) and (3,51)', '(-1,-13) and (3,-51)', '(1,13) and (-3,-51)', '(-1,13) and (3,-51)', 'D', 3, 'GENERAL', 'y prime=6x^2-12x-18=0 simplifies to x^2-2x-3=0, giving (x-3)(x+1)=0, so x=3,-1. y(3)=54-54-54+3=-51. y(-1)=-2-6+18+3=13.'),
  ('Find the coordinates of the minimum point for $y=4t^2-40t+300$.', '(5,100)', '(-5,200)', '(10,200)', '(5,200)', 'D', 2, 'GENERAL', 'y prime=8t-40=0 gives t=5. y(5)=100-200+300=200.'),
  ('The turning point of $y=5-2x-x^2$ occurs at:', '(1,6)', '(-1,-6)', '(-1,6)', '(1,2)', 'C', 2, 'GENERAL', 'y prime=-2-2x=0 gives x=-1. y(-1)=5+2-1=6.'),
  ('Given $2x^3y^2-3xy^2=4$, find $\frac{dy}{dx}$ using implicit differentiation.', '$(3y^2-6x^2y^2)/(4x^3-6x)$', '$(3y^2+6x^2y^2)/(4x^3y-6xy)$', '$(3y^2-6x^2y^2)/(4x^3y+6xy)$', '$(3y^2-6x^2y^2)/(4x^3y-6xy)$', 'D', 5, 'GENERAL', 'Differentiating both sides with the product and chain rules: 6x^2y^2+4x^3y y prime - 3y^2 - 6xy y prime = 0. Grouping y prime terms: y prime(4x^3y-6xy)=3y^2-6x^2y^2, so y prime=(3y^2-6x^2y^2)/(4x^3y-6xy).'),
  ('Given $4x^4+y^3=12x^2y$, find $\frac{dy}{dx}$ using implicit differentiation.', '$(24xy-16x^3)/(3y^2-12x^2)$', '$(16x^3-24xy)/(3y^2-12x^2)$', '$(24xy-16x^3)/(3y^2+12x^2)$', '$(12xy-16x^3)/(3y^2-12x^2)$', 'A', 5, 'GENERAL', 'Differentiating both sides: 16x^3+3y^2 y prime = 24xy+12x^2 y prime. Grouping y prime terms: y prime(3y^2-12x^2)=24xy-16x^3, so y prime=(24xy-16x^3)/(3y^2-12x^2).'),
  ('30 m of fencing wire makes a rectangular enclosure (all 4 sides fenced). Find the maximum area possible.', 'Rectangle 15m by 15m, area 225m2', 'Square 7.5m by 7.5m, area 56.25m2', 'Rectangle 10m by 5m, area 50m2', 'Square 7.5m by 7.5m, area 225m2', 'B', 3, 'GENERAL', 'For a standard 4-sided rectangle, 2(x+y)=30, so x+y=15, maximised at x=y=7.5, giving area 7.5 times 7.5 = 56.25 m2. (Corrected: an earlier version of this exercise stated the area as 225m2, which is arithmetically inconsistent with the 7.5m by 7.5m dimensions it also states, since 7.5 times 7.5 equals 56.25, not 225.)')
) as q(question_text, option_a, option_b, option_c, option_d, correct_letter, difficulty, exam_type, explanation)
where c.subject = 'Mathematics' and t.class_level = 'SS3' and t.term = 2 and t.order_index = 205;

-- ------------------------------------------
-- 206. INTEGRATION OF ALGEBRAIC FUNCTIONS
-- No coordinate_plane or other diagram: indefinite/definite integrals,
-- substitution, and marginal-cost applications have no single natural
-- static figure here, matching the standing instruction not to force
-- one (an area-under-a-curve sketch would need per-question custom
-- curve rendering beyond the supported coordinate_plane point/line
-- shape, so it is described in words in the solution steps instead).
-- ------------------------------------------

with lesson as (
  insert into public.lessons (topic_id, title, summary, content_body, order_index)
  values (
    (select t.id from public.topics t join public.curricula c on c.id = t.curriculum_id
     where c.subject = 'Mathematics' and t.class_level = 'SS3' and t.term = 2 and t.order_index = 206),
    'Integration of Algebraic Functions',
    'Integration as the reverse of differentiation: the power rule for indefinite integrals, finding the constant of integration from a given condition, definite integrals and the area under a curve, integration by substitution, and real applications (distance from velocity, total cost from marginal cost).',
    '### Integration as Anti-Differentiation

If $\frac{d}{dx}[F(x)] = f(x)$, then $\int f(x)\,dx = F(x) + C$, where $C$ is the **constant of integration** (needed because the derivative of any constant is zero, so the original function could have had any constant added to it and still differentiate back to the same $f(x)$).

### Standard Integral (Power Rule)

$$\int x^n \, dx = \frac{x^{n+1}}{n+1} + C \quad (n \neq -1)$$

"Raise the power by 1, then divide by the NEW power", a common slip is dividing by the OLD power instead.

**Rules**: constants pull straight out, $\int k \cdot f(x)\,dx = k\int f(x)\,dx$; integrate term by term, $\int[f(x)\pm g(x)]\,dx = \int f(x)\,dx \pm \int g(x)\,dx$.

**Speed check**: integration undoes differentiation, so differentiate your final answer back, if you do not recover the original integrand, you have made an error, this self-check costs seconds and catches most mistakes.

### Finding the Constant of Integration

Use a given initial or boundary condition (a point the curve passes through, or a known value of $y$ at a given $x$), substitute it into the general antiderivative, and solve for $C$.

### Definite Integration and Area Under a Curve

$$\int_a^b f(x)\,dx = \big[F(x)\big]_a^b = F(b) - F(a)$$

This gives the area under $y=f(x)$ between $x=a$ and $x=b$ (the Fundamental Theorem of Calculus). Reversing the limits flips the sign; same limits give 0. **The constant $C$ is never needed for a definite integral, it always cancels out when you subtract $F(a)$ from $F(b)$**, so skip writing it there (but never omit it for an indefinite integral).

If the curve dips below the $x$-axis over part of the interval, the raw integral there comes out negative, split the integral at the $x$-intercept and take the absolute value of the negative part before adding, otherwise areas above and below the axis wrongly cancel.

### Integration by Substitution

For $\int f(g(x)) \cdot g''(x)\,dx$: let $u=g(x)$, so $du = g''(x)\,dx$, rewrite the whole integral in terms of $u$ only, integrate normally, then substitute $u=g(x)$ back in. **Spot the pattern**: a function and (something proportional to) its own derivative multiplied together, e.g. $2x$ next to $(x^2+1)^n$, signals a substitution.

### Applications

- Distance from velocity: $\text{distance} = \int v(t)\,dt$.
- Total Cost from Marginal Cost: $\text{Total Cost} = \int MC\,dx + \text{Fixed Cost}$ (the fixed cost plays the role of the constant of integration).

### Glossary

- **Antiderivative**: a function whose derivative gives back the original function you started with, the "reverse gear" of differentiation.
- **Constant of integration ($C$)**: an unknown constant added to every indefinite integral, because a whole family of curves differing only by a vertical shift all share the exact same derivative.
- **Definite integral**: an integral evaluated between two specific limits, giving a single number, usually interpreted as the (signed) area under a curve over that interval.
- **Substitution**: a technique for integrating a "function of a function" by temporarily renaming the inner expression as a single new variable $u$, integrating in terms of $u$, then substituting back.',
    1
  )
  returning id
)
insert into public.worked_examples (lesson_id, title, problem_statement, solution_steps, exam_shortcut, status)
select id,
  'Indefinite Integration Term by Term',
  'Find $\int(3x^2+4x-5)\,dx$.',
  to_jsonb(array[
    'Integrate each term with the power rule: $\int 3x^2\,dx = 3 \cdot \frac{x^3}{3} = x^3$; $\int 4x\,dx = 4 \cdot \frac{x^2}{2} = 2x^2$; $\int -5\,dx = -5x$.',
    'Add the results and the constant of integration: $x^3+2x^2-5x+C$.'
  ]),
  'Check the answer by differentiating it back: $\frac{d}{dx}[x^3+2x^2-5x+C] = 3x^2+4x-5$, exactly the original integrand ✓.',
  'published'
from lesson;

insert into public.worked_examples (lesson_id, title, problem_statement, solution_steps, exam_shortcut, status)
select l.id,
  'Finding the Constant of Integration',
  'Given $\frac{dy}{dx}=6x^2+4$ and $y=10$ when $x=1$, find $y$ in terms of $x$.',
  to_jsonb(array[
    'Integrate $\frac{dy}{dx}$ to recover $y$: $y = \int(6x^2+4)\,dx = 6 \cdot \frac{x^3}{3} + 4x + C = 2x^3+4x+C$.',
    'Substitute the given point ($x=1, y=10$) to find $C$: $10 = 2(1)^3+4(1)+C = 2+4+C = 6+C$.',
    'Solve for $C$: $C = 10-6 = 4$.',
    'Final answer: $y = 2x^3+4x+4$.'
  ]),
  'Never forget the "+C" step for an INDEFINITE integral, without it there is nothing to solve for using the given condition, and the final answer would be missing a genuine constant term.',
  'published'
from public.lessons l join public.topics t on t.id = l.topic_id join public.curricula c on c.id = t.curriculum_id
where c.subject = 'Mathematics' and t.class_level = 'SS3' and t.term = 2 and t.order_index = 206;

insert into public.worked_examples (lesson_id, title, problem_statement, solution_steps, exam_shortcut, status)
select l.id,
  'Integration by Substitution',
  'Integrate $\int 2x(x^2+1)^3\,dx$ using substitution.',
  to_jsonb(array[
    'Let $u = x^2+1$ (the inner expression): $\frac{du}{dx} = 2x$, so $du = 2x\,dx$.',
    'Rewrite the integral entirely in terms of $u$: $\int 2x(x^2+1)^3\,dx = \int u^3\,du$ (since $2x\,dx = du$ exactly).',
    'Integrate: $\int u^3\,du = \frac{u^4}{4} + C$.',
    'Substitute $u=x^2+1$ back in: $\frac{(x^2+1)^4}{4} + C$.'
  ]),
  'Spotting "$2x$ sitting right next to $(x^2+1)^n$" instantly signals this exact substitution, since $2x$ is precisely the derivative of the inner expression $x^2+1$.',
  'published'
from public.lessons l join public.topics t on t.id = l.topic_id join public.curricula c on c.id = t.curriculum_id
where c.subject = 'Mathematics' and t.class_level = 'SS3' and t.term = 2 and t.order_index = 206;

insert into public.worked_examples (lesson_id, title, problem_statement, solution_steps, exam_shortcut, real_life_context, status)
select l.id,
  'Distance Travelled from a Velocity Function',
  'A particle moves with velocity $v = 3t^2+2t$ m/s. Find the distance travelled in the first 4 seconds.',
  to_jsonb(array[
    'Set up the definite integral of velocity: $\text{Distance} = \int_0^4 (3t^2+2t)\,dt$.',
    'Find the antiderivative: $\int 3t^2\,dt = t^3$; $\int 2t\,dt = t^2$. So $F(t) = t^3+t^2$.',
    'Apply the limits: $F(4) = 64+16 = 80$; $F(0) = 0$.',
    'Subtract: $80 - 0 = 80$.'
  ]),
  'For a definite integral, skip writing "+C" entirely, it always cancels out when subtracting $F(0)$ from $F(4)$, saving time in an exam.',
  'This is exactly how a delivery bike''s speedometer log (velocity over time) is converted into total distance covered on a trip, integrating speed over time always gives distance.',
  'published'
from public.lessons l join public.topics t on t.id = l.topic_id join public.curricula c on c.id = t.curriculum_id
where c.subject = 'Mathematics' and t.class_level = 'SS3' and t.term = 2 and t.order_index = 206;

insert into public.questions (topic_id, lesson_id, question_text, option_a, option_b, option_c, option_d, correct_letter, difficulty, exam_type, explanation, status)
select t.id, l.id, q.question_text, q.option_a, q.option_b, q.option_c, q.option_d, q.correct_letter, q.difficulty, q.exam_type::exam_type, q.explanation, 'published'
from public.topics t
  join public.curricula c on c.id = t.curriculum_id
  join public.lessons l on l.topic_id = t.id,
  (values
  ('Find $\int 4x^3\,dx$.', '$x^4+C$', '$4x^4+C$', '$x^4/4+C$', '$3x^2+C$', 'A', 1, 'GENERAL', 'Raise the power by 1 and divide by the new power: x^4/4 times 4 = x^4, giving x^4+C.'),
  ('Integrate: $\int(2x^2-5x+3)\,dx$.', '$(2/3)x^3-(5/2)x^2+C$', '$(2/3)x^3-(5/2)x^2+3x+C$', '$x^3-x^2+3x+C$', '$(2/3)x^3+(5/2)x^2+3x+C$', 'B', 2, 'GENERAL', 'Integrating term by term: (2/3)x^3-(5/2)x^2+3x+C.'),
  ('Evaluate $\int_1^2 x^3\,dx$.', '15/2', '7/4', '15/4', '4', 'C', 2, 'GENERAL', '[x^4/4] from 1 to 2 = 16/4-1/4 = 15/4.'),
  ('Given $\frac{dy}{dx}=6x-2$ and $y=5$ when $x=1$, find $y$.', '$3x^2-2x+1$', '$3x^2+2x+4$', '$3x^2-2x-4$', '$3x^2-2x+4$', 'D', 3, 'GENERAL', 'y=3x^2-2x+C; 5=3-2+C=1+C gives C=4, so y=3x^2-2x+4.'),
  ('Find $\int \frac{1}{x^2}\,dx$.', '$-1/x+C$', '$1/x+C$', '$-2/x^3+C$', '$\ln|x|+C$', 'A', 2, 'GENERAL', 'x^(-2) integrates to x^(-1)/(-1)=-1/x, giving -1/x+C.'),
  ('Integrate $\int 2x(x^2+1)^3\,dx$.', '$(x^2+1)^4+C$', '$(x^2+1)^4/4+C$', '$(x^2+1)^3/3+C$', '$4(x^2+1)^4+C$', 'B', 3, 'GENERAL', 'Substituting u=x^2+1, du=2x dx gives the integral of u^3 du = u^4/4+C = (x^2+1)^4/4+C.'),
  ('Evaluate $\int_0^2(x^2+2x)\,dx$.', '8/3', '28/3', '20/3', '4', 'C', 2, 'GENERAL', '[x^3/3+x^2] from 0 to 2 = 8/3+4 = 20/3.'),
  ('Find the area under $y=2x+1$ from $x=0$ to $x=3$.', '9', '15', '6', '12', 'D', 2, 'GENERAL', '[x^2+x] from 0 to 3 = 9+3 = 12.'),
  ('Marginal cost is $MC=5x+10$ and fixed cost is N200. Find the total cost of producing 8 units.', '400', '480', '360', '440', 'D', 3, 'GENERAL', 'TC=2.5x^2+10x+200. TC(8)=2.5(64)+80+200=160+80+200=440.'),
  ('Find $\int \sqrt{x}\,dx$.', '$(1/2)x^{3/2}+C$', '$(2/3)x^{3/2}+C$', '$(3/2)x^{1/2}+C$', '$x^{3/2}+C$', 'B', 2, 'GENERAL', 'x^(1/2) integrates to x^(3/2)/(3/2)=(2/3)x^(3/2)+C.'),
  ('Find: (a) $\int 6x^5\,dx$, (b) $\int(4x^3-3x^2+2x-5)\,dx$, (c) $\int(5x^4+3x^2-7)\,dx$, (d) $\int(x^5-2x^4+3x^2-1)\,dx$.', '(a) $6x^6+C$ (b) $x^4-x^3+x^2-5x+C$ (c) $x^5+x^3-7x+C$ (d) $x^6/6-(2/5)x^5+x^3-x+C$', '(a) $x^6+C$ (b) $x^4+x^3+x^2-5x+C$ (c) $x^5+x^3-7x+C$ (d) $x^6/6-(2/5)x^5+x^3-x+C$', '(a) $x^6+C$ (b) $x^4-x^3+x^2-5x+C$ (c) $x^5+x^3-7x+C$ (d) $x^6/6-(2/5)x^5+x^3-x+C$', '(a) $x^6+C$ (b) $x^4-x^3+x^2-5x+C$ (c) $x^5-x^3-7x+C$ (d) $x^6/6-(2/5)x^5+x^3-x+C$', 'C', 3, 'GENERAL', 'Each part applies the power rule term by term: (a) x^6+C. (b) x^4-x^3+x^2-5x+C. (c) x^5+x^3-7x+C. (d) x^6/6-(2/5)x^5+x^3-x+C.'),
  ('Integrate: (a) $\int(1/x^4)\,dx$, (b) $\int(3/x^2)\,dx$, (c) $\int(2/\sqrt{x})\,dx$, (d) $\int\frac{x^4+2x^2-5}{x^2}\,dx$.', '(a) $1/(3x^3)+C$ (b) $-3/x+C$ (c) $4\sqrt{x}+C$ (d) $x^3/3+2x+5/x+C$', '(a) $-1/(3x^3)+C$ (b) $3/x+C$ (c) $4\sqrt{x}+C$ (d) $x^3/3+2x+5/x+C$', '(a) $-1/(3x^3)+C$ (b) $-3/x+C$ (c) $2\sqrt{x}+C$ (d) $x^3/3+2x+5/x+C$', '(a) $-1/(3x^3)+C$ (b) $-3/x+C$ (c) $4\sqrt{x}+C$ (d) $x^3/3+2x+5/x+C$', 'D', 3, 'GENERAL', '(a) x^(-4) integrates to -1/(3x^3). (b) 3x^(-2) integrates to -3/x. (c) 2x^(-1/2) integrates to 4*sqrt(x). (d) splitting first into x^2+2-5x^(-2) gives x^3/3+2x+5/x.'),
  ('Given $\frac{dy}{dx}=4x^2+6x$ and $y=8$ when $x=1$, find $y$.', '$(4/3)x^3+3x^2-11/3$', '$(4/3)x^3+3x^2+8$', '$4x^3+3x^2+11/3$', '$(4/3)x^3+3x^2+11/3$', 'D', 3, 'GENERAL', 'y=(4/3)x^3+3x^2+C. At x=1: 4/3+3+C=8, so C=8-13/3=11/3.'),
  ('A curve has gradient $3x^2-4x+1$ and passes through $(2,5)$. Find its equation.', '$x^3-2x^2+x-3$', '$x^3-2x^2+x+3$', '$x^3+2x^2+x+3$', '$x^3-2x^2+x+5$', 'B', 3, 'GENERAL', 'y=x^3-2x^2+x+C. At x=2: 8-8+2+C=5, so C=3.'),
  ('Given $\frac{dy}{dx}=2x+3$ and $y=10$ when $x=2$, find $y$ when $x=5$.', '34', '45', '40', '25', 'C', 3, 'GENERAL', 'y=x^2+3x+C. At x=2: 4+6+C=10, so C=0. y=x^2+3x. y(5)=25+15=40.'),
  ('Evaluate: (a) $\int_1^2 x^2\,dx$, (b) $\int_0^1(2x^3+3x)\,dx$, (c) $\int_1^4(\sqrt{x}+1/\sqrt{x})\,dx$, (d) $\int_0^2(x-1)^3\,dx$.', '(a) 7/3 (b) 5/2 (c) 20/3 (d) 0', '(a) 7/3 (b) 2 (c) 28/3 (d) 0', '(a) 8/3 (b) 2 (c) 20/3 (d) 0', '(a) 7/3 (b) 2 (c) 20/3 (d) 0', 'D', 4, 'GENERAL', '(a) [x^3/3] from 1 to 2 = 7/3. (b) [x^4/2+3x^2/2] from 0 to 1 = (0.5+1.5)-0 = 2 (an earlier version of this exercise stated 5/2 here, which does not match direct computation). (c) [(2/3)x^(3/2)+2*sqrt(x)] from 1 to 4 = 28/3-8/3 = 20/3. (d) substituting u=x-1 gives limits -1 to 1, and the integral of an odd power over symmetric limits is 0.'),
  ('Find: (a) $\int 4x(x^2+1)^2\,dx$, (b) $\int 6x^2(x^3-2)^2\,dx$, (c) $\int x^3(x^4+1)^2\,dx$, (d) $\int_0^1 2x(x^2+3)^2\,dx$.', '(a) $(2/3)(x^2+1)^3+C$ (b) $(2/3)(x^3-2)^3+C$ (c) $(x^4+1)^3/12+C$ (d) 37/3', '(a) $(2/3)(x^2+1)^3+C$ (b) $(2/3)(x^3-2)^3+C$ (c) $(x^4+1)^3/12+C$ (d) 64/3', '(a) $(2/3)(x^2+1)^2+C$ (b) $(2/3)(x^3-2)^3+C$ (c) $(x^4+1)^3/12+C$ (d) 37/3', '(a) $(2/3)(x^2+1)^3+C$ (b) $(1/3)(x^3-2)^3+C$ (c) $(x^4+1)^3/12+C$ (d) 37/3', 'A', 4, 'GENERAL', 'Each part substitutes u = the inner bracket: (a) u=x^2+1 gives (2/3)(x^2+1)^3+C. (b) u=x^3-2 gives (2/3)(x^3-2)^3+C. (c) u=x^4+1 gives (x^4+1)^3/12+C. (d) u=x^2+3, limits become 3 to 4, giving [u^3/3] from 3 to 4 = 64/3-9 = 37/3.'),
  ('Find the area under $y=x^3$ from $x=0$ to $x=2$.', '8', '4', '2', '16', 'B', 2, 'GENERAL', '[x^4/4] from 0 to 2 = 16/4 = 4.'),
  ('Calculate the area bounded by $y=9-x^2$, the $x$-axis, $x=0$, and $x=3$.', '27', '9', '18', '24', 'C', 3, 'GENERAL', '[9x-x^3/3] from 0 to 3 = 27-9 = 18.'),
  ('Find the area under $y=2x+3$ from $x=1$ to $x=4$.', '28', '20', '18', '24', 'D', 2, 'GENERAL', '[x^2+3x] from 1 to 4 = 28-4 = 24.'),
  ('A particle has velocity $v=2t^2+3t$ m/s. Find the distance travelled in the first 5 seconds.', '725/6 (approximately 120.83m)', 'approximately 245.83m', 'approximately 100.83m', '150m', 'A', 3, 'GENERAL', 'Distance = integral from 0 to 5 of (2t^2+3t) dt = [2t^3/3+3t^2/2] from 0 to 5 = 250/3+37.5 = 725/6, approximately 120.83m. (Corrected: an earlier version of this exercise stated approximately 245.8m, which does not match its own formula: (2/3)(125)+37.5=83.33+37.5=120.83.)'),
  ('Acceleration is $a=6t-4$ m/s2 and initial velocity is 5 m/s. Find (i) the velocity after $t$ seconds, (ii) the velocity after 3 seconds.', '(i) $3t^2-4t+5$ (ii) 16', '(i) $3t^2-4t+5$ (ii) 20', '(i) $3t^2-4t-5$ (ii) 20', '(i) $3t^2+4t+5$ (ii) 32', 'B', 3, 'GENERAL', 'v(t)=3t^2-4t+C; v(0)=5 gives C=5. v(t)=3t^2-4t+5. v(3)=27-12+5=20.'),
  ('Position is $s=\int(4t+3)\,dt$, with $s=10$ when $t=2$. Find $s$ when $t=5$.', '53', '57', '61', '65', 'C', 4, 'GENERAL', 's(t)=2t^2+3t+C. At t=2: 8+6+C=10, so C=-4 (not -12). s(t)=2t^2+3t-4. s(5)=50+15-4=61. (Corrected: an earlier version of this exercise used C=-12 and stated s(5)=53, which does not follow from s(2)=10.)'),
  ('Marginal cost is $MC=6x+15$ and fixed cost is N300. Find (i) the total cost function, (ii) the cost of producing 10 units.', '(i) $3x^2+15x+300$ (ii) 600', '(i) $3x^2+15x$ (ii) 450', '(i) $6x^2+15x+300$ (ii) 1050', '(i) $3x^2+15x+300$ (ii) 750', 'D', 3, 'GENERAL', 'TC=3x^2+15x+300. TC(10)=300+150+300=750.'),
  ('Marginal revenue is $MR=80-4x$. Find (i) the total revenue function, (ii) the revenue from 10 units.', '(i) $80x-2x^2$ (ii) 600', '(i) $80x-4x^2$ (ii) 400', '(i) $80x-2x^2$ (ii) 800', '(i) $80x+2x^2$ (ii) 1000', 'A', 2, 'GENERAL', 'TR=80x-2x^2 (constant is 0, since TR(0)=0). TR(10)=800-200=600.'),
  ('Marginal profit is $MP=40-2x$. Find the total profit from producing units 5 through 15.', '175', '200', '225', '400', 'B', 3, 'GENERAL', 'Integral from 5 to 15 of (40-2x) dx = [40x-x^2] from 5 to 15 = (600-225)-(200-25) = 375-175 = 200.'),
  ('A particle moves with velocity $v=3t^2+2t$ m/s. Find the distance travelled in the first 4 seconds.', '64', '96', '80', '72', 'C', 2, 'GENERAL', 'Integral from 0 to 4 of (3t^2+2t) dt = [t^3+t^2] from 0 to 4 = 64+16 = 80.'),
  ('Marginal cost is $MC=3x^2+20$ and fixed cost is N500. Find the total cost of producing 10 units.', '1500', '1900', '1300', '1700', 'D', 3, 'GENERAL', 'TC=x^3+20x+500. TC(10)=1000+200+500=1700.'),
  ('A company''s marginal revenue is $MR=100-2x$. Find (a) the total revenue function, (b) the revenue from 20 units.', '(a) $100x-x^2$ (b) 1600', '(a) $100x-2x^2$ (b) 1200', '(a) $100x-x^2$ (b) 2000', '(a) $100x+x^2$ (b) 2400', 'A', 2, 'GENERAL', 'TR=100x-x^2. TR(20)=2000-400=1600.'),
  ('Evaluate $\int_0^{\pi/2} 2\sin(2x)\,dx$.', '0', '2', '1', '4', 'B', 4, 'GENERAL', 'The antiderivative of 2sin(2x) is -cos(2x) (check: d/dx[-cos(2x)]=2sin(2x)). [-cos(2x)] from 0 to pi/2 = -cos(pi)-(-cos(0)) = 1-(-1) = 2. (Corrected: an earlier version of this exercise stated the answer is 0, which does not match this evaluation; 0 is the answer a student gets by mistakenly treating this as a full-period sine integral.)'),
  ('Evaluate $\int_1^3(3x^2-2x)\,dx$.', '24', '16', '18', '20', 'C', 2, 'GENERAL', '[x^3-x^2] from 1 to 3 = (27-9)-(1-1) = 18.'),
  ('Evaluate $\int_1^2 \frac{x^3-1}{x^2}\,dx$.', '1.5', '0.5', '2.0', '1.0', 'D', 4, 'GENERAL', 'Simplify first: (x^3-1)/x^2 = x-x^(-2). The antiderivative is x^2/2+1/x. At x=2: 2+0.5=2.5. At x=1: 0.5+1=1.5. Subtracting: 2.5-1.5=1.0 (matching the published WAEC answer key for this exact question; an earlier version of this exercise stated 1.5, which does not match this evaluation).'),
  ('Evaluate $\int_{-1}^{1}(2x+1)^2\,dx$.', '14/3', '13/3', '8/3', '16/3', 'A', 3, 'GENERAL', 'Expanding (2x+1)^2=4x^2+4x+1, the antiderivative is (4/3)x^3+2x^2+x. At x=1: 4/3+2+1=13/3. At x=-1: -4/3+2-1=-1/3. Subtracting: 13/3-(-1/3)=14/3.'),
  ('Evaluate $\int_{-1}^{2}\left(1-\frac{1}{x^2}\right)dx$, using the Fundamental Theorem of Calculus formally (note: $1/x^2$ is technically undefined at $x=0$, which lies inside this interval, so this integral is strictly improper; the WAEC-style answer key below applies the theorem without flagging that discontinuity).', '4', '4.5', '5', '3.5', 'B', 4, 'GENERAL', 'F(x)=x+1/x. F(2)=2+0.5=2.5. F(-1)=-1-1=-2. F(2)-F(-1)=2.5-(-2)=4.5. This is the standard exam-key answer; a rigor-focused teacher should still flag that the integrand is discontinuous at x=0, which lies inside the interval.'),
  ('A curve is $y=8x-x^2-12$. Find the area of the finite region bounded by the curve and the $x$-axis.', '64/3', '16/3', '32/3', '16', 'C', 4, 'GENERAL', 'x-intercepts: -x^2+8x-12=0 simplifies to x^2-8x+12=0, giving (x-2)(x-6)=0, so x=2 and x=6 (a downward parabola peaking at x=4, height 4). The bounded area is a parabolic arch: (2/3) times base times height = (2/3)(4)(4)=32/3 square units (confirmed directly: [4x^2-x^3/3-12x] from 2 to 6 = 0-(-32/3) = 32/3). (Corrected: an earlier version of this exercise stated 64/3, exactly double the verified value.)')
) as q(question_text, option_a, option_b, option_c, option_d, correct_letter, difficulty, exam_type, explanation)
where c.subject = 'Mathematics' and t.class_level = 'SS3' and t.term = 2 and t.order_index = 206;
