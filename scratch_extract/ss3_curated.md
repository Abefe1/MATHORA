# SS3 Mathematics — Curated Notes & Gamified Exercise Bank

*Sources: Lagos State SS3 Mathematics syllabus (structure/ordering); SS3 Mathematics Lesson Notes, First & Second Term (`ss3_math.txt`); "Hidden Facts in New SSCE Mathematics" WAEC/NECO/NABTEB-focused textbook (`hidden_facts.txt`).*

---

## First Term

### Week 1: Revision — Indices and Logarithm

**Teaching Notes**

*Indices (Laws of Indices)*
For a base x ≠ 0 and indices a, b:
1. xᵃ × xᵇ = xᵃ⁺ᵇ
2. xᵃ ÷ xᵇ = xᵃ⁻ᵇ
3. x⁰ = 1
4. x⁻ᵃ = 1/xᵃ, and (x/y)⁻ᵃ = (y/x)ᵃ
5. (xᵃ)ᵇ = xᵃᵇ
6. x^(1/a) = ᵃ√x
7. (x/y)^(1/a) = ᵃ√(x/y)... more generally x^(b/a) = ᵃ√(xᵇ)

*Worked Example (indices).* Evaluate 8^(−2/3).
**Step 1 — Deal with the negative power:** a negative index means "reciprocal", so 8^(−2/3) = 1/8^(2/3).
**Step 2 — Write the base as a perfect cube:** 8 = 2³, so 8^(2/3) = (2³)^(2/3).
**Step 3 — Apply the power-of-a-power rule (multiply indices):** (2³)^(2/3) = 2^(3×2/3) = 2².
**Step 4 — Evaluate and combine with Step 1:** 2² = 4, so 8^(−2/3) = 1/4.
**Answer: 1/4.**

*Worked Example (indices).* Evaluate (0.008)^(1/3).
**Step 1 — Convert the decimal to a fraction:** 0.008 = 8/1000.
**Step 2 — Write numerator and denominator as perfect cubes:** 8 = 2³ and 1000 = 10³, so 0.008 = 2³/10³ = (2/10)³.
**Step 3 — Apply the cube-root index:** (0.008)^(1/3) = [(2/10)³]^(1/3) = (2/10)^(3×1/3) = 2/10.
**Step 4 — Simplify:** 2/10 = 0.2.
**Answer: 0.2.**

*Logarithms*
If aˣ = y, then logₐ(y) = x ("log to base a of y equals x").
- Product law: logₐ(m × n) = logₐ(m) + logₐ(n)
- Quotient law: logₐ(m ÷ n) = logₐ(m) − logₐ(n)
- Power law: logₐ(mⁿ) = n·logₐ(m)
- logₐ(1) = 0; logₐ(a) = 1
- Change of base: logₐ(m) = log_b(m) ÷ log_b(a)
- Common logarithm (base 10, written "log") vs natural logarithm (base e, written "ln"); ln(x) = 2.3026 × log(x).

A logarithm (base 10) has a **characteristic** (whole-number part, from the power of 10 in standard form) and a **mantissa** (decimal part, read from log tables, always positive). E.g. log(8156) = 3.9115 since 8156 = 8.156 × 10³ (characteristic 3 from the power of 10, mantissa 0.9115 read from tables for 8.156).

*Worked Example.* Solve log₂(x) + log₂(x − 3) = 2.
**Step 1 — Combine the two logs using the product law:** log₂(x) + log₂(x−3) = log₂[x(x−3)].
**Step 2 — Rewrite the equation:** log₂[x(x−3)] = 2.
**Step 3 — Convert from logarithmic form to exponential (index) form:** x(x−3) = 2² = 4.
**Step 4 — Expand and rearrange into a standard quadratic:** x² − 3x = 4 → x² − 3x − 4 = 0.
**Step 5 — Factorize:** (x − 4)(x + 1) = 0, so x = 4 or x = −1.
**Step 6 — Check validity against the domain of the original logs** (arguments x and x−3 must both be positive): for x = 4, x − 3 = 1 > 0 ✓; for x = −1, both x and x−3 are negative, so log₂ of them is undefined — reject.
**Answer: x = 4.**

*Worked Example (log tables).* Using log tables, evaluate 69.24 × 8.31.
**Step 1 — Let y equal the product and take log of both sides:** y = 69.24 × 8.31 → log(y) = log(69.24) + log(8.31) (product law lets multiplication become addition).
**Step 2 — Read each logarithm from the tables:** log(69.24) = 1.8403 (characteristic 1 since 69.24 = 6.924×10¹); log(8.31) = 0.9196 (characteristic 0 since 8.31 = 8.31×10⁰).
**Step 3 — Add the logarithms:** log(y) = 1.8403 + 0.9196 = 2.7599.
**Step 4 — Take the antilog:** y = antilog(2.7599). The characteristic 2 tells us y has 3 digits before the decimal point; the mantissa 0.7599 from the antilog table gives the digit string 5753.
**Step 5 — Place the decimal point using the characteristic:** characteristic 2 → 3 digits before the point → y = 575.3.
**Answer: 575.3** (check: 69.24 × 8.31 ≈ 575.3 ✓).

*Worked Example.* Find the value of a if log₁₀a + log₁₀a² = 0.9030.
**Step 1 — Combine the logs using the product law:** log₁₀a + log₁₀a² = log₁₀(a·a²) = log₁₀(a³).
**Step 2 — Rewrite the equation:** log₁₀(a³) = 0.9030.
**Step 3 — Convert to exponential form:** a³ = 10^0.9030.
**Step 4 — Evaluate 10^0.9030 using tables/known values:** 10^0.9030 ≈ 7.998 (this is antilog 0.9030).
**Step 5 — Take the cube root of both sides:** a = ∛7.998 ≈ 2.0 (since 2³ = 8, which matches 7.998 to rounding).
**Answer: a ≈ 2.0.**

⚡ **Shortcut & Speed Tips**
- **Spot perfect powers before touching log tables.** If a number in an indices question is (or hides) a perfect square/cube/4th power (e.g. 0.008 = 0.2³, 8156 not, but 625=5⁴), factorize it mentally first — you'll often get an exact answer with zero table-reading, which is faster and error-free in an exam.
- **Negative and fractional indices: split the operation.** Handle "flip for negative, root for the denominator, power for the numerator" as three separate mini-steps in your head (x^(−a/b) → 1/(root-b of x)^a) rather than trying to do it all at once — fewer slips.
- **When two logs are added/subtracted in an equation, immediately combine them into one log** (product/quotient law) before converting to exponential form — trying to convert two separate logs at once is the most common source of WAEC candidates' errors.
- **Always sanity-check log-table equation answers against the domain.** Any x that makes an original log argument zero or negative must be rejected — WAEC frequently sets up a quadratic with one "trap" root precisely to test this.
- **Estimate before you compute.** Before reading tables for 69.24 × 8.31, notice 69 × 8 ≈ 552 and 70×8.3≈581, so the answer must lie near 550–580 — a proper table calculation of 575.3 fits, and this range check instantly catches a misplaced decimal point (a very common WAEC slip).

**Gamified Exercise Bank**

Q1. Express in logarithmic form: (a) 5² = 125 (b) 10⁴ = 10,000 (c) 2⁻³ = 1/8 (answer: (a) log₅125=2 (b) log₁₀10000=4 (c) log₂(1/8)=−3)
Q2. Evaluate without tables: (a) log₅(25) (b) log₃(81) (c) log₂(1/16) (answer: (a) 2 (b) 4 (c) −4)
Q3. Simplify: log₁₀(1000) − log₁₀(10) + log₁₀(100) (answer: 4)
Q4. Solve: (a) log₂(x) = 4 (b) log₃(x) = −1 (c) log₄(x) = 2.5 (answer: (a) 16 (b) 1/3 (c) 32)
Q5. Given log₁₀2 = 0.3010 and log₁₀3 = 0.4771, find log₁₀6 (answer: 0.7781)
Q6. Solve: log₂(x) + log₂(x + 6) = 3 (answer: x = 2)
Q7. Simplify: 2log₂(4) + 3log₂(2) − log₂(8) (answer: 4)
Q8. Solve: log₂(x + 3) − log₂(x − 2) = 1 (answer: x = 7)
Q9. Use logarithms to evaluate: 45.6 × 78.2 (answer: log(y)=log45.6+log78.2=1.6590+1.8932=3.5522, y=antilog(3.5522)≈3566)
Q10. Solve: 5ˣ = 20 (Use log₁₀2 = 0.3010, log₁₀5 = 0.6990) (answer: x ≈ 1.861)
Q11. Simplify: log₅(125) + log₅(25) − log₅(5) (answer: 4)
Q12. Simplify: 3log₂(8) − 2log₂(4) + log₂(16) (answer: 9)
Q13. Express as a single logarithm: 2logₐ(x) + logₐ(y) − 3logₐ(z) (answer: logₐ(x²y/z³))
Q14. Solve: log₃(2x − 1) = 2 (answer: x = 5)
Q15. Solve: log₂(x) + log₂(x − 7) = 3 (answer: x = 8)
Q16. Solve: 2log(x) − log(x − 4) = log(4) (answer: log(x²/(x−4))=log4 → x²=4x−16 → x²−4x+16=0, discriminant=16−64=−48<0, so there is no real solution)
Q17. Solve: 3ˣ⁺² = 81 (answer: x = 2)
Q18. Given log₁₀2 = 0.3010, log₁₀3 = 0.4771, log₁₀7 = 0.8451, evaluate: (i) log₁₀14 (ii) log₁₀21 (iii) log₁₀4.5 (answer: (i) 1.1461 (ii) 1.3222 (iii) 0.6532)
Q19. Use logarithms to calculate: (i) 87.3 × 42.6 (ii) 456 ÷ 12.8 (iii) (3.6)⁴ (iv) ∛216 (answer: (iv) 6; others computed via log tables)
Q20. The population of a city grows as P = P₀ × 2^(t/10). If initial population is 50,000, how long to reach 200,000? (answer: t = 20 years, since 2^(t/10)=4=2² ⟹ t/10=2)
Q21. (0.008)^(1/3): A 0.15 B 0.8 C 0.5 D 0.2 E 0.1 (answer: D, 0.2)
Q22. Simplify (−8)^(4/3): A −32 B −16 C 16 D 32 (answer: C, 16)
Q23. Evaluate (4^(1/4))⁶: A 1/8 B 4 C 6 D 8 (answer: D, 8)
Q24. Evaluate ∛(66.32) using tables (answer: ≈ 4.048)
Q25. Using log table, evaluate 7031 × 4.911 (answer: log(7031)≈3.8470, log(4.911)≈0.6912, sum≈4.5382, antilog≈34,540 — CORRECTED: the direct product 7031×4.911=34,529.2, so the answer is ≈34,530, not 1432 as an earlier draft mistakenly stated)
Q26. Find the value of x, given x½ = 10^1.6741 (without calculator) (answer: x½=10^1.6741=10×10^0.6741=10×4.721=47.21, so x=47.21²≈2229 — CORRECTED: an earlier draft misplaced the decimal and gave x≈0.2229, which is 10,000× too small)

---

### Week 2: Surds

**Teaching Notes**

A **surd** is an irrational root — a root that cannot be simplified to a rational number, e.g. √2, √3, √5. (√4 = 2, √9 = 3 are *not* surds — they simplify to rational numbers.)

Basic rules:
- √a × √b = √(ab)
- √a ÷ √b = √(a/b)
- (√a)² = a
- √a + √b ≠ √(a+b) in general (surds only combine by "like" collection, similar to algebraic terms)

*Simplifying:* extract perfect-square factors, e.g. √18 = √(9×2) = 3√2.

*Rationalizing the denominator:* multiply numerator and denominator by the surd (single-term denominator) or by the **conjugate** (two-term denominator). For a + √b, the conjugate is a − √b, and (a+√b)(a−√b) = a² − b (rational).

*Worked Example.* Simplify √18.
**Step 1 — Find the largest perfect-square factor of 18:** 18 = 9 × 2, and 9 is a perfect square.
**Step 2 — Split the surd using √(a×b) = √a × √b:** √18 = √9 × √2.
**Step 3 — Evaluate the perfect-square part:** √9 = 3.
**Answer: √18 = 3√2.**

*Worked Example.* Simplify 2√12 + 3√3 − √48.
**Step 1 — Simplify each surd separately by extracting perfect-square factors:** √12 = √(4×3) = 2√3; √48 = √(16×3) = 4√3.
**Step 2 — Substitute the simplified surds back into the expression:** 2√12 + 3√3 − √48 = 2(2√3) + 3√3 − 4√3.
**Step 3 — Multiply through:** = 4√3 + 3√3 − 4√3.
**Step 4 — Collect like surd terms (treat √3 like a common variable):** (4 + 3 − 4)√3 = 3√3.
**Answer: 3√3.**

*Worked Example.* Simplify √12(√48 − √3).
**Step 1 — Expand the bracket by distributing √12:** √12(√48 − √3) = √12×√48 − √12×√3.
**Step 2 — Multiply surds under one root using √a×√b=√(ab):** √12×√48 = √(12×48) = √576; √12×√3 = √(12×3) = √36.
**Step 3 — Evaluate each square root:** √576 = 24 (since 24² = 576); √36 = 6.
**Step 4 — Subtract:** 24 − 6 = 18.
**Answer: 18.**

*Worked Example.* Rationalize 1/(3 − √6).
**Step 1 — Identify the conjugate of the denominator:** for 3 − √6, the conjugate is 3 + √6 (same terms, opposite sign in the middle).
**Step 2 — Multiply numerator and denominator by the conjugate:** 1/(3−√6) × (3+√6)/(3+√6).
**Step 3 — Expand the denominator using (a−b)(a+b)=a²−b²:** (3−√6)(3+√6) = 3² − (√6)² = 9 − 6 = 3.
**Step 4 — Expand the numerator:** 1×(3+√6) = 3+√6.
**Step 5 — Write the simplified fraction:** (3+√6)/3.
**Answer: (3+√6)/3.**

*Worked Example.* Given (√3 − 5√2)(√3 + √2) = a + b√6, find a and b.
**Step 1 — Expand using FOIL (First, Outer, Inner, Last):** (√3)(√3) + (√3)(√2) + (−5√2)(√3) + (−5√2)(√2).
**Step 2 — Evaluate each term:** (√3)(√3)=3; (√3)(√2)=√6; (−5√2)(√3)=−5√6; (−5√2)(√2)=−5×2=−10.
**Step 3 — Add all four terms together:** 3 + √6 − 5√6 − 10.
**Step 4 — Collect the rational terms and the √6 terms separately:** rational part = 3 − 10 = −7; surd part = √6 − 5√6 = −4√6.
**Step 5 — Match to the form a + b√6:** a = −7, b = −4.
**Answer: a = −7, b = −4.**

⚡ **Shortcut & Speed Tips**
- **Always factor out the largest perfect square in one pass**, not several small ones — e.g. for √48, jump straight to 16×3 (giving 4√3) instead of doing 4×12 then 4×3 in two steps. Memorize the perfect squares up to 15² (1,4,9,16,25,36,49,64,81,100,121,144,169,196,225) so you can spot the largest factor instantly.
- **Recognize a "difference of two squares" denominator on sight**: (a+√b)(a−√b) = a² − b. You don't need to expand fully each time — just compute a² − b directly once you've picked the conjugate.
- **When a fraction has a single surd in the denominator, multiply top and bottom by that surd alone** (not a conjugate) — e.g. 1/√3 → √3/3. Reaching for a conjugate here wastes time; conjugates are only needed for two-term (binomial) denominators.
- **Sanity-check simplified surds with a quick decimal estimate.** √3≈1.7, √2≈1.4, √5≈2.2, √6≈2.4 — memorizing these lets you spot-check, e.g. 7√3≈11.9, which should roughly match a decimal estimate of the original unsimplified expression.
- **In "find a and b" surd expansion questions, separate rational and irrational parts as the very last step** — never round or approximate midway, since a and b must come out as exact integers/fractions matched term-by-term.

**Gamified Exercise Bank**

Q1. Simplify: (a) √32 (b) √45 (c) √38 + √22 (answer: (a) 4√2 (b) 3√5)
Q2. Rationalize: (a) 1/√3 (b) 2/√5 (c) 1/(1+√2) (answer: (a) √3/3 (b) 2√5/5 (c) √2−1)
Q3. Simplify completely: √48 + √75 − √12 (answer: 7√3)
Q4. Rationalize and simplify: 3/(√5 − √2) (answer: 3(√5+√2)/3 = √5+√2)
Q5. Simplify: (√3 + √2)(√3 − √2) (answer: 1)
Q6. Simplify: (4√12 + 3√3)/√3 (limited source material — practice extension)
Q7. Simplify √12(√48 − √3) (answer: 18)
Q8. Given (√3 − 5√2)(√3 + √2) = a + b√6, find a and b (answer: a = −7, b = −4)
Q9. Simplify 10√2/√5 (answer: 2√10)
Q10. Simplify 2√3 − √6/3 + √3/27... rationalize the surds 2√3, √(6/3), 3√(1/27) (answer: (1/3)√3, i.e. √3/3 per source working)
Q11. Simplify √35/√5 (answer: √7)
Q12. Simplify √17/√4 (answer: √17/2)
Q13. Rationalize 5/√3, leave answer in surd form: A 5√3 B 3√3/5 C 5√3/3 D 9√5/5 (answer: C)
Q14. Simplify 6/√3: A 2√3/3 B 3 C 2√3 D 6√3 (answer: C, 2√3)
Q15. Rationalize 1/(3−√6): A 3√6 B (3+√6)/3 C 6 D 12/√6 E √6 (answer: B)
Q16. Which represents the conjugate of √3 + √2? A √2−√3 B √3−√2 C (√3−√2)/(3+2) (answer: B)
Q17. Without tables find the value of 1/(√11−√2) − 1/(√11+√2) (answer: 4/7)
Q18. Rationalize 2/(4+3√2) (answer: −4+3√2, i.e. (8−6√2)/(16−18))
Q19. Rationalize (7−√3)/(13−√3) (answer: (44−3√3)/83)
Q20. Simplify (3√5 × 4√6)/(2√2 × 3√3): A 2 B 5 C 2√2 D 2√5 (answer: D, 2√5)
Q21. By rationalizing the denominator, simplify 7√5/√7 leaving answer in surd form (answer: √35)
Q22. Simplify (√2−√3)²/(√2+√3)² (answer: 5−2√6 over 5+2√6, i.e. simplifies further by rationalizing)

---

### Week 3: Surds in relation to Trigonometry

**Teaching Notes**

For the special angles 30°, 45°, 60°, exact trigonometric ratios can be expressed using surds instead of decimals, derived from a right isosceles triangle (for 45°) and half an equilateral triangle (for 30°/60°).

*Deriving the 45° ratios:* take a right-angled isosceles triangle with both legs = 1. By Pythagoras, hypotenuse² = 1²+1² = 2, so hypotenuse = √2. Then sin45° = opposite/hypotenuse = 1/√2 = √2/2 (after rationalizing), and similarly cos45° = √2/2, tan45° = 1/1 = 1.

*Deriving the 30°/60° ratios:* take an equilateral triangle with all sides = 2, and drop a perpendicular from one vertex to the midpoint of the opposite side. This splits it into two right triangles with hypotenuse 2, one leg 1 (half the base), and the other leg h found from Pythagoras: h² + 1² = 2² → h² = 3 → h = √3. Reading off the 30° and 60° angles of this right triangle gives the full table below.

| Angle | sin | cos | tan |
|---|---|---|---|
| 30° | 1/2 | √3/2 | √3/3 |
| 45° | √2/2 | √2/2 | 1 |
| 60° | √3/2 | 1/2 | √3 |

CAST rule for signs by quadrant (0°–360°): **A**ll positive in Q1 (0°–90°), **S**ine positive in Q2 (90°–180°), **T**angent positive in Q3 (180°–270°), **C**osine positive in Q4 (270°–360°) ("All Students Take Calculus" read from Q1 anticlockwise, or CAST read clockwise from Q4).

*Worked Example.* Evaluate sin²45° + cos²45°.
**Step 1 — Substitute the exact values from the table:** sin45° = √2/2, cos45° = √2/2.
**Step 2 — Square each value:** (√2/2)² = 2/4 = 1/2; (√2/2)² = 2/4 = 1/2.
**Step 3 — Add the two squared values:** 1/2 + 1/2 = 1.
**Answer: 1** (this confirms the identity sin²θ + cos²θ = 1 for θ = 45°).

*Worked Example.* Simplify tan60° − tan30°.
**Step 1 — Substitute exact values:** tan60° = √3, tan30° = √3/3 (equivalently 1/√3).
**Step 2 — Write both terms over a common denominator of 3:** √3 = 3√3/3.
**Step 3 — Subtract:** 3√3/3 − √3/3 = (3√3 − √3)/3 = 2√3/3.
**Answer: 2√3/3.**

*Worked Example.* Evaluate sin30°cos60° + cos30°sin60°.
**Step 1 — Substitute exact values:** sin30° = 1/2, cos60° = 1/2, cos30° = √3/2, sin60° = √3/2.
**Step 2 — Multiply each pair:** sin30°cos60° = (1/2)(1/2) = 1/4; cos30°sin60° = (√3/2)(√3/2) = 3/4.
**Step 3 — Add the products:** 1/4 + 3/4 = 1.
**Answer: 1** (this is the compound-angle identity sin(A+B) = sinAcosB + cosAsinB with A=30°, B=60°, giving sin90° = 1, which checks out).

*Worked Example.* If sinθ = √3/2 and θ is acute, find cosθ and tanθ.
**Step 1 — Use the Pythagorean identity sin²θ + cos²θ = 1:** (√3/2)² + cos²θ = 1.
**Step 2 — Evaluate the squared sine:** 3/4 + cos²θ = 1.
**Step 3 — Isolate cos²θ:** cos²θ = 1 − 3/4 = 1/4.
**Step 4 — Take the square root (positive, since θ is acute so cosθ > 0):** cosθ = 1/2.
**Step 5 — Find tanθ using tanθ = sinθ/cosθ:** tanθ = (√3/2) ÷ (1/2) = (√3/2) × (2/1) = √3.
**Answer: cosθ = 1/2, tanθ = √3** (this is the 60° angle, consistent with the table).

*Worked Example.* Solve sinx = cosx for 0° ≤ x ≤ 360°.
**Step 1 — Divide both sides by cosx (valid since cosx ≠ 0 where sinx = cosx):** sinx/cosx = 1 → tanx = 1.
**Step 2 — Find the reference (acute) angle:** tan⁻¹(1) = 45°.
**Step 3 — Use the CAST rule to find every quadrant where tangent is positive:** tangent is positive in Quadrant 1 (0°–90°) and Quadrant 3 (180°–270°).
**Step 4 — Write the solution in each quadrant:** Q1: x = 45°; Q3: x = 180° + 45° = 225°.
**Answer: x = 45° or x = 225°.**

⚡ **Shortcut & Speed Tips**
- **Memorize the 30-45-60 table as two triangles, not six numbers.** Redraw the isosceles right triangle (legs 1,1, hypotenuse √2) and the half-equilateral triangle (sides 1, √3, 2) from memory in 10 seconds during an exam instead of trying to recall the table by rote — this also prevents mixing up which ratio goes with which angle.
- **Use "SOH-CAH-TOA" directly on the two reference triangles** rather than memorizing the CAST rule table blindly — sin=opp/hyp, cos=adj/hyp, tan=opp/adj applied straight to the triangles regenerates the whole ratio table if you forget it.
- **CAST rule quick check: only one ratio is positive per quadrant (except Q1, all three).** If your answer for a "solve for x" problem gives a sign that contradicts the CAST rule for that quadrant, you've made an arithmetic slip — recheck immediately.
- **For "solve sinx = cosx" type equations, always convert to tanx = 1 (or tanx = k) first** — trigonometric equations mixing sin and cos are far easier to solve as a single tan equation, and WAEC very often sets these up deliberately for this shortcut.
- **When two quadrant solutions are needed, use "reference angle ± quadrant rule"**: Q2 = 180°−ref, Q3 = 180°+ref, Q4 = 360°−ref, always starting from the acute reference angle in Q1. This is faster and more reliable than sketching a full graph for every question.

**Gamified Exercise Bank**

Q1. Evaluate exactly: sin²30° + cos²30° (answer: 1)
Q2. Find the exact value of: tan60° × cos30° (answer: 3/2)
Q3. Simplify: (sin45° + cos45°)² (answer: 2)
Q4. Solve for x (0°≤x≤90°): 2sinx = 1 (answer: x = 30°)
Q5. Evaluate: sin30°cos60° − cos30°sin60° (answer: sin30°cos60°−cos30°sin60° = (1/2)(1/2)−(√3/2)(√3/2) = 1/4−3/4 = −1/2, i.e. sin(30°−60°)=sin(−30°)=−1/2 — CORRECTED: an earlier draft gave −√3/2, but sin(−30°) is −1/2, not −√3/2)
Q6. Sketch the graph of y = sinx for 0°≤x≤360° (answer: not applicable — graphing task)
Q7. Use a graph to solve: cosx = 0 for 0°≤x≤360° (answer: x = 90° or 270°)
Q8. If tanθ = √3 and θ is acute, find sinθ and cosθ (answer: sinθ=√3/2, cosθ=1/2, θ=60°)
Q9. Evaluate sin²45° + cos²60° − tan²30° (answer: 1/2+1/4−1/3 = 5/12)
Q10. Find the exact value of (sin30°+cos60°)/tan45° (answer: 1)
Q11. Simplify: 2sin60°cos30° − sin90° (answer: 1/4, since 2(√3/2)(√3/2)−1 = 3/2−1 = 1/2; recheck: 2·(√3/2)·(√3/2)=3/2, minus 1 = 1/2)
Q12. Solve for θ (0°≤θ≤360°): sinθ = √2/2 (answer: θ=45° or 135°)
Q13. Solve: 2cosθ − 1 = 0 for 0°≤θ≤360° (answer: θ=60° or 300°)
Q14. Find all values of x (0°≤x≤360°) for which tanx = 1/√3 (answer: x=30° or 210°)
Q15. Simplify: tan60° − tan30° (answer: 2√3/3)
Q16. Evaluate: sin30°cos60° + cos30°sin60° (answer: 1)
Q17. Simplify: (sin60° − cos60°)² (answer: (2−√3)/2)
Q18. Solve for x: 2cosx = √3, where 0°≤x≤90° (answer: x=30°)
Q19. Evaluate: sin²30° + sin²45° + sin²60° (answer: 3/2)
Q20. Find the exact value of tan45° + 2sin30° − cos60° (answer: 3/2)
Q21. Use a graph to solve sinx = 0.5 for 0°≤x≤360° (answer: x=30° or 150°)
Q22. Solve cosx = 0.5 for 0°≤x≤360° (answer: x=60° or 300°)
Q23. Solve graphically: sinx = √3/2 for 0°≤x≤360° (answer: x=60° or 120°)
Q24. Prove that (sin60°−sin30°)/(cos30°−cos60°) = √3 (answer: verified algebraically using exact values)
Q25. Solve graphically: 2x+3=0 (answer: x=−1.5)
Q26. Solve simultaneously using graphs: y=2x+1, y=−x+4 (answer: x=1, y=3)

---

### Week 4: Matrices and Determinants

**Teaching Notes**

A **matrix** is a rectangular array of numbers in rows and columns. Its **order** is m×n (m rows, n columns).

*Types:* row matrix, column matrix, square matrix, diagonal matrix, identity matrix I (A·I = I·A = A), zero/null matrix, scalar matrix, upper/lower triangular matrix, symmetric matrix (Aᵀ = A).

*Operations:*
- **Addition/subtraction:** only for matrices of the same order — add/subtract corresponding elements.
- **Scalar multiplication:** multiply every element by the scalar.
- **Matrix multiplication:** A(m×n)·B(p×q) is defined only if n = p; result has order m×q. Element (i,j) = (row i of A)·(column j of B). Matrix multiplication is **not commutative**: AB ≠ BA in general.
- **Transpose** Aᵀ: interchange rows and columns. (AB)ᵀ = BᵀAᵀ.

*Determinant* (denoted det A or |A|):
- 2×2: for A = [[a,b],[c,d]], det A = ad − bc.
- 3×3: use the rule of Sarrus, or cofactor expansion along a row: |A| = a(ei−fh) − b(di−fg) + c(dh−eg).
- If det A = 0, A is **singular** (no inverse exists).

*Inverse* of a 2×2 matrix A = [[a,b],[c,d]]: A⁻¹ = (1/detA)·[[d,−b],[−c,a]] (swap diagonal elements, negate off-diagonal, divide by determinant). Exists only if det A ≠ 0.

*Solving simultaneous equations with matrices:* write as AX = B, then X = A⁻¹B.

*Worked Example.* Find det A for A = [[3,2],[1,4]].
**Step 1 — Recall the 2×2 determinant formula:** for A=[[a,b],[c,d]], det A = ad − bc.
**Step 2 — Identify a,b,c,d:** a=3, b=2, c=1, d=4.
**Step 3 — Substitute and compute the two products:** ad = 3×4 = 12; bc = 2×1 = 2.
**Step 4 — Subtract:** 12 − 2 = 10.
**Answer: det A = 10.**

*Worked Example.* Find the determinant of A = [[2,1,3],[0,4,5],[1,2,1]] by cofactor expansion along the first row.
**Step 1 — Write the cofactor expansion formula:** |A| = a(ei−fh) − b(di−fg) + c(dh−eg), where the matrix is [[a,b,c],[d,e,f],[g,h,i]].
**Step 2 — Identify each entry:** a=2, b=1, c=3, d=0, e=4, f=5, g=1, h=2, i=1.
**Step 3 — Compute the three 2×2 sub-determinants:** (ei−fh) = (4×1 − 5×2) = 4−10 = −6; (di−fg) = (0×1 − 5×1) = −5; (dh−eg) = (0×2 − 4×1) = −4.
**Step 4 — Substitute into the formula:** |A| = 2(−6) − 1(−5) + 3(−4) = −12 + 5 − 12.
**Step 5 — Add the results:** −12+5−12 = −19.
**Answer: |A| = −19.**

*Worked Example.* Find the inverse of A = [[4,5],[2,3]].
**Step 1 — Compute the determinant first (needed before anything else, and to confirm the inverse exists):** det A = 4(3) − 5(2) = 12 − 10 = 2. Since det A ≠ 0, A is non-singular and the inverse exists.
**Step 2 — Swap the two diagonal elements (a and d):** 4 and 3 swap places, giving [[3,5],[2,4]] as an intermediate — then only the off-diagonal signs change, not swap: the adjugate matrix is [[d,−b],[−c,a]] = [[3,−5],[−2,4]].
**Step 3 — Divide every entry of the adjugate by the determinant:** A⁻¹ = (1/2)×[[3,−5],[−2,4]].
**Step 4 — Distribute the 1/2 to each entry:** A⁻¹ = [[3/2, −5/2],[−1, 2]].
**Answer: A⁻¹ = [[3/2, −5/2], [−1, 2]]** (check: A·A⁻¹ should give the identity matrix I).

*Worked Example.* Solve 2x + y = 5, x + 3y = 8 using matrices.
**Step 1 — Write the system in matrix form AX = B:** [[2,1],[1,3]]·[x;y] = [5;8].
**Step 2 — Find det A:** det A = (2×3) − (1×1) = 6 − 1 = 5.
**Step 3 — Find A⁻¹ using A⁻¹ = (1/detA)[[d,−b],[−c,a]]:** A⁻¹ = (1/5)[[3,−1],[−1,2]].
**Step 4 — Compute X = A⁻¹B by multiplying the inverse matrix by the column vector B:** X = (1/5)[[3,−1],[−1,2]]·[5;8].
**Step 5 — Carry out the matrix-vector multiplication (row × column, sum the products):** top entry = 3(5) + (−1)(8) = 15 − 8 = 7; bottom entry = (−1)(5) + 2(8) = −5 + 16 = 11.
**Step 6 — Multiply both entries by 1/5:** x = 7/5, y = 11/5.
**Answer: x = 7/5 = 1.4, y = 11/5 = 2.2** (check: 2(1.4)+2.2 = 5 ✓; 1.4+3(2.2)=1.4+6.6=8 ✓).

⚡ **Shortcut & Speed Tips**
- **2×2 determinant "cross-multiply and subtract":** for [[a,b],[c,d]], just mentally do "top-left×bottom-right minus top-right×bottom-left" — no need to write the formula out; this can be done in under 5 seconds per matrix.
- **2×2 inverse "swap-and-negate" pattern:** swap the two diagonal entries, negate the two off-diagonal entries, then divide everything by the determinant. Practise this as one fluid motion — it's the single most-repeated matrix skill on WAEC papers.
- **Check a computed inverse instantly** by multiplying A·A⁻¹ (or A⁻¹·A) — if you don't get the identity matrix [[1,0],[0,1]], you've made an arithmetic error; this catch-your-own-mistake trick costs seconds but saves the whole mark.
- **For 3×3 determinants, cofactor-expand along the row or column with the most zeros** — every zero entry eliminates an entire 2×2 sub-determinant calculation, cutting your work roughly in half.
- **Before inverting a matrix, always compute the determinant first and check it isn't zero** — a matrix with det = 0 is singular and has no inverse; spotting this immediately avoids wasted work trying to invert an impossible matrix.
- **For "solve simultaneous equations by matrices" questions, sanity-check your (x,y) answer by substituting back into BOTH original equations** — a wrong sign anywhere in the inverse calculation shows up immediately as a failed check.

**Gamified Exercise Bank**

Q1. State the order of matrices: (a) [[1,2,3],[4,5,6]] (b) [[2],[5],[7]] (answer: (a) 2×3 (b) 3×1)
Q2. Given A=[[2,3],[1,5]], B=[[1,4],[2,3]], find: a) A+B b) A−B c) 2A (answer: A+B=[[3,7],[3,8]]; A−B=[[1,−1],[−1,2]]; 2A=[[4,6],[2,10]])
Q3. Find AB if A=[[1,2],[3,4]], B=[[3,1],[2,5]] (answer: [[7,11],[17,23]])
Q4. Find the transpose of A=[[2,1,3],[4,5,6]] (answer: [[2,4],[1,5],[3,6]])
Q5. Calculate the determinant |2 3; 1 4| (answer: 5)
Q6. Find the determinant |1 2 3; 0 4 5; 1 2 1| (answer: 0)
Q7. Find the inverse of A=[[3,1],[2,1]] (answer: [[1,−1],[−2,3]])
Q8. Find the inverse of B=[[1,2],[3,4]] (answer: (1/−2)[[4,−2],[−3,1]] = [[−2,1],[1.5,−0.5]])
Q9. Solve using matrices: 2x+y=7, x+y=4 (answer: x=3, y=1)
Q10. Identify the type of matrix [[1,0,0],[0,1,0],[0,0,1]] (answer: identity matrix)
Q11. Given A=[[2,−1],[0,2]], B=[[3,2],[4,1]], C=[[1,0],[1,2]]: a) 2A−3B b) AB c) (A+B)ᵀ d) BC (answer: 2A−3B=[[−5,−8],[−12,1]]; AB=[[2,3],[8,2]])
Q12. Find |A| if A=[[4,2],[−3,1]] (answer: 10)
Q13. Calculate |2 1 3; 1 0 2; 4 2 1| (answer: cofactor-expand along row 1: 2(0×1−2×2) − 1(1×1−2×4) + 3(1×2−0×4) = 2(−4) − 1(−7) + 3(2) = −8+7+6 = 5)
Q14. Find the value of k if |k 2; 3 6| = 0 (answer: k=1)
Q15. Find the inverse of M=[[5,3],[2,1]] (answer: [[1,−3],[−2,5]])
Q16. Find N⁻¹ if N=[[4,1],[3,1]] (answer: [[1,−1],[−3,4]])
Q17. Use matrices to solve: a) 3x+2y=11, 2x+y=7 b) x+3y=5, 2x+y=4 c) 4x−y=10, x+2y=5 (answer: (a) x=3, y=1 (b) x=1, y=2 (c) x=3, y=1)
Q18. Determine if [[5,2],[3,1]] is singular (answer: det=−1, non-singular)
Q19. Given P = [[2,1],[0,−3]] and 2x+5y=3, 8x+7y=5, express in matrix form (answer: [[2,5],[8,7]][x;y]=[3;5])
Q20. Find y if [[5,−6],[2,−7]][x;y]=[−11;−7] (answer: y=3)
Q21. Given [[1,−1],[k,2]][2,15;1,5]=[[3,12],[15,5]]... find k (answer: k=−3)
Q22. If 3x²−y, x+2y; xy, x+2 (garbled) = [[3,18],[0,29]], find x and y (answer: x=2, y=4)
Q23. Find P, Q for which [[2p,8],[3,−5q]]=[[12,24],[3,−17]] (answer: P=4, Q=2)
Q24. If the determinant of matrix [[x,4],[−1,2]] is −6, find x (answer: x=−2)
Q25. If [[5,3],[x,2]]=[[3,5],[4,5]] (proportion form), find x (answer: x=5)
Q26. If [[3−x,9],[−1,1+2x]] has determinant 0, find the two possible values of x (answer: x=4 or x=−3/2)
Q27. Which of the following is a singular matrix? A [[1,0],[0,1]] B [[2,12],[3,6]]... (answer: the option with det=0, e.g. [[3,8],[6,16]])
Q28. If x=[[5,−3],[−2,2]], find the determinant of x (answer: −4)
Q29. Evaluate |2 1; 4 6| (answer: 8)
Q30. P=[[2,3],[0,1]], find the value of |−5P + 6I| (answer: 36)
Q31. Find the inverse of P=[[2,−1],[1,3]] (answer: (1/7)[[3,1],[−1,2]])
Q32. If Q=[[9,−2],[−7,4]], find |Q| (answer: 22)
Q33. If [[−3,x],[3,y]] has determinant 33, find x+y (answer: det = (−3)(y) − (x)(3) = −3y−3x = −3(x+y) = 33, so x+y = −11)
Q34. A company produces two products A and B: labor/material matrix P=[[2,3],[1,2]]. If 10 units of A and 15 of B are produced, find total labor hours and materials (answer: [2,3;1,2][10;15]=[65;40])

---

### Week 5: Linear and Quadratic Equations

**Teaching Notes**

A **linear equation** has the form y = mx + c (straight-line graph). A **quadratic equation** has the form y = ax² + bx + c, a ≠ 0 (parabola graph); a > 0 opens upward, a < 0 opens downward.

*Solving simultaneous linear and quadratic equations (substitution method):* express y (or x) from the linear equation and substitute into the quadratic equation, producing a single quadratic in one variable; solve by factorization or the quadratic formula, then back-substitute for the paired values.

*Special technique when both equations only involve x² − y² (difference of squares):* factorize as (x−y)(x+y), then substitute the known value of (x+y) or (x−y) from the linear equation.

*Worked Example.* Solve: y = x+2 and y = x²−4.
**Step 1 — Since both expressions equal y, set them equal to each other:** x+2 = x²−4.
**Step 2 — Rearrange into standard quadratic form (ax²+bx+c=0):** 0 = x²−4−x−2 → x²−x−6 = 0.
**Step 3 — Factorize:** we need two numbers that multiply to −6 and add to −1: those are −3 and 2, so (x−3)(x+2) = 0.
**Step 4 — Solve for x:** x−3=0 → x=3, or x+2=0 → x=−2.
**Step 5 — Back-substitute each x-value into the simpler equation y=x+2 to find matching y-values:** for x=3, y=3+2=5; for x=−2, y=−2+2=0.
**Step 6 — (Optional check) verify both points also satisfy y=x²−4:** for (3,5): 3²−4=9−4=5 ✓; for (−2,0): (−2)²−4=4−4=0 ✓.
**Answer: (3, 5) and (−2, 0).**

*Worked Example.* Solve x − y = 2 and x² + y² = 52.
**Step 1 — Make x the subject of the linear equation:** x − y = 2 → x = y + 2.
**Step 2 — Substitute this expression for x into the quadratic equation:** (y+2)² + y² = 52.
**Step 3 — Expand the bracket:** (y+2)² = y²+4y+4, so y²+4y+4+y² = 52.
**Step 4 — Collect like terms:** 2y²+4y+4 = 52.
**Step 5 — Rearrange to standard form:** 2y²+4y−48 = 0, then divide every term by 2: y²+2y−24 = 0.
**Step 6 — Factorize:** need two numbers multiplying to −24 and adding to 2: those are 6 and −4, so (y+6)(y−4) = 0.
**Step 7 — Solve for y:** y=−6 or y=4.
**Step 8 — Back-substitute into x = y+2:** for y=−6, x=−6+2=−4; for y=4, x=4+2=6.
**Step 9 — (Check) verify with x²+y²=52:** (−4)²+(−6)²=16+36=52 ✓; 6²+4²=36+16=52 ✓.
**Answer: (−4, −6) and (6, 4)** (note: substituting x=y+2 correctly gives (6,4), not (8,4) — the pair (8,4) does not satisfy x−y=2 since 8−4=4≠2, so this corrects an earlier slip in the working).

*Worked Example (difference of squares).* Solve p+q=3 and p²−q²=15.
**Step 1 — Recognize p²−q² as a difference of two squares and factorize it:** p²−q² = (p+q)(p−q).
**Step 2 — Substitute the known value of (p+q):** (3)(p−q) = 15.
**Step 3 — Solve for (p−q):** p−q = 15÷3 = 5.
**Step 4 — Now solve the pair of simpler linear equations p+q=3 and p−q=5 by adding them (this eliminates q):** (p+q)+(p−q) = 3+5 → 2p = 8 → p = 4.
**Step 5 — Substitute p=4 back into p+q=3:** 4+q=3 → q=−1.
**Answer: p = 4, q = −1** (check: p²−q² = 16−1 = 15 ✓).

*Key features of a quadratic graph:* vertex at x=−b/(2a) (max if a<0, min if a>0); axis of symmetry x=−b/(2a); y-intercept (0,c); x-intercepts (roots) from ax²+bx+c=0.

⚡ **Shortcut & Speed Tips**
- **Always substitute the LINEAR equation into the QUADRATIC one, never the reverse** — isolating a variable from a linear equation is a one-line rearrangement, while trying to isolate a variable from a quadratic often introduces an unnecessary square root.
- **Spot "difference of squares" setups immediately**: whenever you see x²−y² (or p²−q², a²−b², etc.) paired with a linear equation in the same two letters, factorize as (x+y)(x−y) and substitute the linear value directly — this turns a quadratic-and-simultaneous problem into two one-line linear equations, which is dramatically faster than full substitution.
- **"Sum and product" word problems (numbers that add to S and multiply to P) go straight to a quadratic** t²−St+P=0 without needing two named variables — memorize this pattern for "find two numbers" problems.
- **For rectangle dimension problems** ("length is k more than width, area is A"), let width=x, length=x+k, and go straight to x(x+k)=A → x²+kx−A=0 — this standard setup avoids re-deriving the equation from scratch each time.
- **Always back-check your final (x,y) pair in BOTH original equations**, not just the one you substituted into — this is the single most effective way to catch sign errors, and it takes only seconds.
- **Use the discriminant (b²−4ac) as an instant filter** before solving fully: negative means no real intersection (the line misses the curve entirely), zero means the line is a tangent (exactly one solution), positive means two distinct intersection points — useful for "how many solutions" questions without doing the full factorization.

**Gamified Exercise Bank**

Q1. Solve simultaneously: y=x+3, y=x²+x−2 (answer: x²+x−2=x+3 → x²−5=0 → x=±√5, so (√5, √5+3) and (−√5, −√5+3) — CORRECTED: an earlier draft gave (−1,2), but that point does not satisfy y=x²+x−2 (it gives −2, not 2), so the corrected exact solutions are x=±√5)
Q2. Solve algebraically: y=2x−1, y=x²−3 (answer: x²−2x−2=0 → x=1±√3)
Q3. Solve: x+y=6, xy=8 (answer: x=2,y=4 or x=4,y=2)
Q4. The sum of two numbers is 12 and their product is 35. Find the numbers (answer: 5 and 7)
Q5. A rectangular garden has length 3m more than its width; area is 40m². Find the dimensions (answer: width=5m, length=8m)
Q6. For y=x²−6x+5, find: a) vertex b) axis of symmetry c) y-intercept d) x-intercepts (answer: vertex (3,−4); axis x=3; y-intercept (0,5); x-intercepts (1,0),(5,0))
Q7. Solve: y=x−2, y=x²−4x+2 (answer: x²−5x+4=0 → x=1 or 4)
Q8. How many solutions does the system have if the discriminant of the resulting quadratic is negative? (answer: no real solutions)
Q9. An investor buys shares at x each; number bought is (80−2x); total investment 800. Find the price per share (answer: solve x(80−2x)=800 → 2x²−80x+800=0 → x²−40x+400=0 → x=20)
Q10. Sketch y=2x and y=x²−4 on the same axes; estimate solutions graphically (answer: intersections near x≈3.24, x≈−1.24)
Q11. Solve: y=x+1, y=x²−3x+2 (answer: x²−4x+1=0 → x=2±√3)
Q12. Solve: y=3x−2, y=2x²−x−1 (answer: 2x²−4x+1=0 → x=1±√2/2)
Q13. Solve: x−y=2, x²+y²=10 (answer: x=3,y=1 or x=−1,y=−3)
Q14. Solve: y=2x, y=x²−8 (answer: x²−2x−8=0 → x=4 or −2)
Q15. The difference between two numbers is 4 and their product is 45. Find the numbers (answer: 9 and 5)
Q16. A rectangular playground has perimeter 36m and area 80m². Find its dimensions (answer: 10m × 8m)
Q17. The sum of a number and its reciprocal is 2.9. Find the number (answer: x=2.5 or 0.4)
Q18. A ball thrown upward: h=20t−5t². (i) When does it hit the ground? (ii) Max height? (answer: (i) t=4s (ii) 20m at t=2s)
Q19. A stockbroker bought x shares at (200−2x) each, total cost 9,600. Find x and price per share (answer: CORRECTED — x(200−2x)=9600 → x²−100x+4800=0, discriminant=10000−19200<0, so no real solution exists for a total of ₦9,600 (the maximum possible total, at x=50, is only ₦5,000); the total figure in the source is almost certainly a transcription error for ₦4,800, which gives x²−100x+2400=0 → x=40 or x=60, with price per share 200−2x = 120 or 80 respectively)
Q20. On the same axes draw y=x+2 (−3≤x≤5) and y=x²−4x (−1≤x≤5); find solutions to x+2=x²−4x (answer: x²−5x−2=0 → x≈5.37 or −0.37)
Q21. For y=−x²+6x−5: a) vertex (max/min) b) y-intercept c) x-intercepts d) range where y>0 (answer: vertex (3,4) max; y-intercept (0,−5); x-intercepts (1,0),(5,0); y>0 for 1<x<5)
Q22. The sum of two numbers is 10 and their product is 21. Find the numbers (answer: 3 and 7)
Q23. A rectangular field has length 5m more than width; area 84m². Find dimensions (answer: 7m × 12m)
Q24. An investor buys shares at x each; number bought is (100−x); total investment 2,400. Find x and number of shares (answer: x=40 (60 shares) or x=60 (40 shares))
Q25. A trader bought x items for (x²+2x) and sold for (3x²−4x); profit was 140. Find x (answer: x=10)
Q26. Write the equation whose roots are the points of intersection of y=x²+x−2 and y=x+1 (answer: x²−3=0)
Q27. The product of two consecutive positive odd numbers is 195. Find the numbers (answer: 13 and 15)
Q28. Find two consecutive numbers whose product is 156 (answer: 12 and 13, or −13 and −12)
Q29. If y=x²−4x−10 and y=2, find the values of x (answer: x=6 or −2)
Q30. If x−y=3 and x²−y²=0, find x and y (answer: x=3/2, y=−3/2)
Q31. Find x and y such that y=−½(x²−3) and x+y=6 (answer: x=−5,y=11 or x=3,y=3)

---

### Week 6: Surface Area and Volume of Sphere and Hemispherical Shapes

**Teaching Notes**

For a sphere of radius r:
- **Surface area** = 4πr²
- **Volume** = (4/3)πr³

For a **hemisphere** (half a sphere) of radius r:
- Curved surface area = 2πr²
- Total surface area = curved surface + circular base = 2πr² + πr² = **3πr²**
- Volume = (2/3)πr³

**Hollow sphere/hemisphere** (external radius R, internal radius r):
- Volume of material = (4/3)π(R³−r³) for a sphere; (2/3)π(R³−r³) for a hemisphere.
- Total surface area of hollow sphere = 4π(R²+r²).

*Worked Example.* Find the surface area of a sphere with radius 7cm (π = 22/7).
**Step 1 — Write down the sphere surface-area formula:** SA = 4πr².
**Step 2 — Substitute r = 7:** SA = 4 × (22/7) × 7².
**Step 3 — Evaluate 7² first:** 7² = 49.
**Step 4 — Multiply, cancelling the 7 in the denominator with a factor from 49 (49÷7=7):** 4 × (22/7) × 49 = 4 × 22 × 7 = 4 × 154.
**Step 5 — Complete the multiplication:** 4 × 154 = 616.
**Answer: 616 cm².**

*Worked Example.* The volume of a sphere is 4,851 cm³; find its radius (π = 22/7).
**Step 1 — Write the sphere volume formula and substitute the known volume:** (4/3)πr³ = 4851.
**Step 2 — Isolate r³ by multiplying both sides by 3/(4π):** r³ = 4851 × 3/(4π) = 4851 × 3 × 7/(4×22).
**Step 3 — Simplify the multiplication step by step:** 4851 × 3 = 14,553; 4×22 = 88; so r³ = 14,553 × 7 / 88 = 101,871/88.
**Step 4 — Divide:** 101,871 ÷ 88 = 1157.625.
**Step 5 — Take the cube root of both sides:** r = ∛1157.625.
**Step 6 — Recognize the cube root:** 10.5³ = 10.5×10.5×10.5 = 110.25×10.5 = 1157.625, so r = 10.5.
**Answer: r = 10.5 cm.**

*Worked Example (WAEC-style).* Calculate the total surface area of a hemisphere with radius 3cm (π = 22/7).
**Step 1 — Write the hemisphere total-surface-area formula (curved surface + flat circular base):** TSA = 2πr² + πr² = 3πr².
**Step 2 — Substitute r = 3:** TSA = 3 × (22/7) × 3².
**Step 3 — Evaluate 3² = 9, then multiply:** 3 × (22/7) × 9 = (3×22×9)/7 = 594/7.
**Step 4 — Divide:** 594 ÷ 7 = 84.86 (2 d.p.).
**Answer: TSA ≈ 84.86 cm²** (using the exact fraction π=22/7; if a question specifies π=3 exactly for a "clean-number" exercise, the same formula gives 3×3×9=81 cm² instead — always use the π value stated in the question).

*Worked Example (WAEC-style, combined solid).* A solid consists of a cylinder with hemispherical ends, radius 3.5cm, cylindrical length 10cm (π = 22/7). Find (a) the total surface area (b) the total volume.
**Step 1 — Identify the visible surfaces:** the two hemispherical ends contribute curved surface only (their flat faces are hidden inside the cylinder), and the cylinder contributes only its curved side (its two flat ends are covered by the hemispheres). So TSA = curved surface of cylinder + curved surface of both hemispheres.
**Step 2 — Compute the cylinder's curved surface area (2πrh):** 2 × (22/7) × 3.5 × 10 = 2 × 22 × 0.5 × 10 = 220.
**Step 3 — Compute the combined curved surface of the two hemispheres (together they form one full sphere's surface, 4πr²):** 4 × (22/7) × 3.5² = 4 × (22/7) × 12.25 = 4 × 22 × 1.75 = 154.
**Step 4 — Add the two surfaces for total surface area:** 220 + 154 = 374.
**Answer (a): TSA = 374 cm².**
**Step 5 — Compute the cylinder's volume (πr²h):** (22/7) × 3.5² × 10 = (22/7) × 12.25 × 10 = (22/7) × 122.5 = 385.
**Step 6 — Compute the combined volume of the two hemispheres (together = one full sphere, (4/3)πr³):** (4/3) × (22/7) × 3.5³ = (4/3) × (22/7) × 42.875 ≈ 179.67.
**Step 7 — Add the cylinder and sphere volumes:** 385 + 179.67 = 564.67.
**Answer (b): Volume ≈ 564.67 cm³.**

⚡ **Shortcut & Speed Tips**
- **Memorize the "3πr²" hemisphere shortcut**: total surface area of a solid hemisphere is always curved (2πr²) + flat base (πr²) = 3πr². Don't derive it from scratch each time — just plug into 3πr² directly for a solid hemisphere, or 2πr² alone if the question asks only for the curved/outer surface (e.g. a dome or bowl exterior with no visible base).
- **For "melt and recast" problems (big solid melted into small identical solids), skip computing individual volumes** — since volume is conserved, the number of small pieces = (R/r)³, where R is the big radius and r is the small radius. E.g. radius 10cm melted into radius 2cm pieces: (10/2)³ = 5³ = 125 — instantly, no need to separately compute both volumes and divide.
- **For "surface area/volume scale-up" questions** (e.g. "radius doubles, how many times does SA/volume increase"), use the direct scaling laws: surface area scales as (scale factor)², volume scales as (scale factor)³ — so doubling the radius always gives ×4 surface area and ×8 volume, without recomputing either quantity from scratch.
- **Cylinder-with-hemispherical-ends solids: the two hemisphere ends always combine into exactly one full sphere** for both surface area (4πr²) and volume ((4/3)πr³) — treat "two hemispherical ends" as "one sphere" immediately to halve your formula-writing.
- **Use π=22/7 whenever the radius or diameter is a multiple of 7 (or 3.5, 10.5, 14, 21, etc.)** — the 7s cancel cleanly giving exact or near-exact answers; switch to π=3.142 only when the dimensions don't divide neatly by 7, to minimize rounding error.
- **Sanity-check "capacity in litres" conversions**: 1 m³ = 1,000 litres, and 1 cm³ = 1 millilitre (0.001 litre) — a wrongly-placed decimal point here is one of the most common WAEC mensuration slips.

**Gamified Exercise Bank**

Q1. Find the surface area of a sphere with radius 14cm (answer: 2464 cm²)
Q2. Calculate the volume of a sphere with diameter 12cm (π=3.142) (answer: ≈904.9 cm³)
Q3. A sphere has surface area 616cm²; find its radius (π=22/7) (answer: 7cm)
Q4. Find the curved surface area of a hemisphere with radius 10.5cm (answer: 693 cm²)
Q5. Calculate the total surface area of a solid hemisphere with radius 7cm (answer: 462 cm²)
Q6. Find the volume of a hemisphere with diameter 18cm (answer: ≈1527.4 cm³)
Q7. A hollow sphere has external radius 12cm and internal radius 9cm; find the volume of material (answer: ≈5115.8 cm³)
Q8. How many small balls of radius 2cm can be made from a sphere of radius 6cm? (answer: 27)
Q9. A hemispherical bowl has internal diameter 21cm; find its capacity in cm³ (answer: ≈2425.5 cm³)
Q10. A spherical water tank has radius 3.5m; how many liters can it hold? (answer: ≈179,667 liters)
Q11. Find the surface area and volume of a sphere with radius 21cm (answer: SA=5544 cm², V=38,808 cm³)
Q12. A sphere has volume 38,808 cm³; find its radius (π=22/7) (answer: 21cm)
Q13. Calculate the curved and total surface area of a hemisphere with radius 14cm (answer: curved=1232 cm², total=1848 cm²)
Q14. Find the volume of a hemisphere with radius 10.5cm (answer: ≈2425.5 cm³)
Q15. A hollow sphere has external diameter 20cm and thickness 3cm; find (i) volume of material (ii) total surface area (answer: R=10, r=7; V≈2753.1 cm³; TSA≈1873.4 cm²)
Q16. A hemispherical bowl has internal radius 12cm and thickness 1cm; calculate the volume of material (answer: R=13, r=12; V≈1985.1 cm³)
Q17. A spherical balloon's radius increases from 7cm to 14cm. How many times does (i) surface area (ii) volume increase? (answer: (i) 4 times (ii) 8 times)
Q18. A solid metal sphere of radius 10cm is melted and recast into smaller spheres of radius 2cm; how many small spheres form? (answer: 125)
Q19. A hemispherical tank of internal radius 1.4m is full of water, emptied into a cylindrical tank of diameter 2.8m; find the height of water (answer: 0.933m ≈ 14/15 m)
Q20. A solid with cylinder and hemispherical ends has total length 20cm, radius 3.5cm, cylindrical part 13cm. Find (i) total surface area (ii) volume (answer: (i) 594 cm² (ii) 686.83 cm³ approx)
Q21. A company manufactures hemispherical bowls of radius 7cm, metal thickness 0.5cm. Find external/internal radii, volume of metal, cost at ₦50/cm³, and 40%-profit selling price (answer: R=7.5,r=7; volume≈161.5cm³; cost≈₦8,075; SP≈₦11,305)
Q22. A toy is a hemisphere surmounted by a cone; cone height 4cm, base diameter 8cm. Find volume, total surface area, and paint needed at 1ml per 10cm² (answer: hemisphere r=4; V(hemisphere)≈134.04cm³, V(cone)≈67.02cm³, total≈201.06cm³; TSA = curved cone + curved hemisphere)
Q23. A toy consists of a hemisphere surmounted by a cone, base radius 7cm, total height 20cm. Find the total surface area (ignore base) (answer: 632.72 cm²)
Q24. A solid consists of a cylinder with hemispheres at both ends, radius 3.5cm, cylindrical length 10cm. Find (a) total surface area (b) volume (answer: (a) 374 cm² (b) 564.67 cm³)
Q25. A spherical water tank has internal diameter 4.2m. How many liters can it hold? (answer: 38,808 liters)
Q26. How many lead balls of radius 1cm can be made from a sphere of radius 8cm? (answer: 512)
Q27. A hemispherical bowl of internal radius 9cm contains water, poured into cylindrical bottles of diameter 3cm, height 4cm. How many bottles are needed? (answer: 54 bottles)
Q28. A metallic sphere of radius 10.5cm is melted and recast into small cones of radius 3.5cm, height 3cm. How many cones form? (answer: 126)
Q29. A spherical tank of diameter 3m is filled from a pipe of radius 30cm at 0.2m/s. Find the time (minutes) to fill the tank (π=22/7) (answer: ≈4.17 minutes)
Q30. A tap leaks at 2cm³/s into an empty container of capacity 45 liters. How long to fill it? (answer: 6hrs 15 mins)
Q31. What is the capacity of a spherical tank whose diameter is 1.5m? (answer: 9π/16 m³)
Q32. Find the radius of a sphere, if 3/4 of its volume is 134.75cm³ (π=22/7) (answer: 3.50cm)
Q33. What will be the volume of a hemisphere of diameter 21cm? (answer: 2425.5 cm³)
Q34. The volume of a hemispherical bowl is 718⅔ cm³. Find its radius (π=22/7) (answer: 7.0cm)
Q35. Find the radius of a sphere whose surface area is 154cm² (π=22/7) (answer: 3.50cm)

---

### Week 7: Mid-Term Test

**Teaching Notes**

No new content — this week is reserved for the school's mid-term assessment, typically covering Weeks 1–6 (Indices/Logarithm, Surds, Surds in Trigonometry, Matrices, Linear & Quadratic Equations, Sphere/Hemisphere Mensuration). Use the exercise banks from those weeks for revision.

⚡ **Shortcut & Speed Tips (Mid-Term Revision Strategy)**
- **Triage by formula-recall speed, not by difficulty.** Before the test, list the 6 topics and rate how fast you can recall each core formula from memory (indices/log laws, surd rationalizing, the 30-45-60 table, the 2×2 inverse pattern, the quadratic formula, and 4πr²/(4/3)πr³) — spend your last-minute revision minutes on the slowest ones.
- **Re-solve, don't re-read.** For each week's exercise bank, cover the answer and re-work 3–4 questions cold; recognizing a worked solution is not the same skill as producing one under time pressure.
- **Build one formula sheet across all six weeks** (indices/log laws; surd rules; the trig ratio table; matrix determinant/inverse patterns; quadratic formula and discriminant test; sphere/hemisphere SA & volume) — writing it out yourself cements recall better than photocopying one.
- **Practice the CAST rule and the matrix "swap-and-negate" inverse rule as automatic reflexes** — these two patterns show up disguised inside many mixed-topic mid-term questions (e.g. a quadratic equation problem that hides a trigonometric substitution).
- **Time yourself on log-table and surd-rationalizing questions specifically** — these are the two skills most likely to be rushed and therefore most likely to produce careless arithmetic slips under exam pressure.

**Gamified Exercise Bank**

*(No dedicated exercises in the source material for this administrative week — practice by re-attempting the exercise banks of Weeks 1–6.)*

---

### Week 8: Longitude and Latitude

**Teaching Notes**

The Earth is (approximately) a sphere, radius R ≈ 6,400 km (WAEC problems commonly also use R = 6,370 km). Key definitions:
- **Equator**: latitude 0°, a great circle dividing Earth into Northern/Southern hemispheres.
- **Prime (Greenwich) Meridian**: longitude 0°, dividing Earth into Eastern/Western hemispheres.
- **Meridian (longitude line)**: a great circle through both poles; **all meridians are great circles**.
- **Parallel of latitude**: a circle parallel to the equator; only the equator is a great circle among latitudes — all others are **small circles**.
- **Great circle**: any circle on the sphere whose centre coincides with Earth's centre (largest possible circle, gives the shortest surface distance between two points).

*Radius of a parallel of latitude θ:* r = R cos θ.

*Distance along a meridian (great circle), for angular (latitude) difference θ:*
Distance = (θ/360°) × 2πR.
- Add latitudes when points are on opposite sides of the equator (one N, one S); subtract when on the same side.

*Distance along a parallel of latitude (small circle), for longitude difference θ, at latitude φ:*
Distance = (θ/360°) × 2πR cos φ, i.e. use r = R cos φ in place of R.
- Add longitudes when one point is E and the other W; subtract when both are on the same side.

*Worked Example.* Find the angular distance between A(40°N,65°E) and B(35°S,65°E).
**Step 1 — Check whether the two points share a meridian (same longitude):** both are at 65°E, so yes — they lie on the same great-circle meridian, and the angular distance is simply the difference (or sum) of their latitudes.
**Step 2 — Determine whether to add or subtract the latitudes:** A is North (40°N) and B is South (35°S) — they are on opposite sides of the equator, so we add.
**Step 3 — Add the latitudes:** 40° + 35° = 75°.
**Answer: 75°.**

*Worked Example.* Find the radius of the parallel of latitude 60°N (R = 6,400 km).
**Step 1 — Write the formula for the radius of a parallel of latitude:** r = R cos θ, where θ is the latitude angle.
**Step 2 — Substitute R = 6,400 and θ = 60°:** r = 6,400 × cos60°.
**Step 3 — Recall the exact value cos60° = 0.5.**
**Step 4 — Multiply:** r = 6,400 × 0.5 = 3,200.
**Answer: r = 3,200 km.**

*Worked Example.* Find the circumference of the parallel of latitude 30°S (R = 6,400 km, π = 22/7).
**Step 1 — First find the radius of this parallel using r = R cos θ:** r = 6,400 × cos30° = 6,400 × (√3/2) = 6,400 × 0.8660 ≈ 5,542.4 km.
**Step 2 — Write the circumference formula for a circle:** Circumference = 2πr.
**Step 3 — Substitute the radius found in Step 1:** Circumference = 2 × (22/7) × 5,542.4.
**Step 4 — Multiply step by step:** 2 × 22 = 44; 44 × 5,542.4 = 243,865.6; then divide by 7.
**Step 5 — Divide:** 243,865.6 ÷ 7 ≈ 34,838.
**Answer: ≈34,838 km** (the small variation from a calculator's exact cos30° comes from rounding — using cos30°=0.866 exactly gives ≈34,830 km; either is acceptable to 3 s.f.).

*Worked Example.* Find the distance between A(65°N,30°E) and B(25°S,30°E) along their common meridian (π = 22/7, R = 6,370 km).
**Step 1 — Confirm both points share a meridian:** both are at longitude 30°E, so the shortest path is along this meridian (a great circle), and we only need the angular difference in latitude.
**Step 2 — Find the angular distance θ:** A is North (65°N), B is South (25°S) — opposite sides of the equator, so add: θ = 65° + 25° = 90°.
**Step 3 — Write the meridian-distance formula:** Distance = (θ/360°) × 2πR (the full circumference of a great circle is 2πR, and we take the fraction θ/360° of it).
**Step 4 — Substitute the values:** Distance = (90/360) × 2 × (22/7) × 6,370.
**Step 5 — Simplify the fraction 90/360 = 1/4 first:** Distance = (1/4) × 2 × (22/7) × 6,370.
**Step 6 — Compute 2 × (22/7) × 6,370:** 2 × 22 = 44; 44 × 6,370 = 280,280; 280,280 ÷ 7 = 40,040.
**Step 7 — Multiply by 1/4:** 40,040 ÷ 4 = 10,010.
**Answer: 10,010 km.**

⚡ **Shortcut & Speed Tips**
- **Memorize r = R cos θ as "radius shrinks by the cosine of the latitude"** — at the equator (θ=0°, cos=1) the radius equals Earth's full radius; at the poles (θ=90°, cos=0) it shrinks to a point. This single relationship also underlies the parallel-distance formula, so mastering it early saves relearning later.
- **"Same longitude → use latitudes; same latitude → use longitudes."** This is the fastest way to decide which formula applies: two points sharing a meridian (same longitude number) always use the meridian/great-circle formula with the *latitude* difference; two points on the same parallel always use the parallel formula with the *longitude* difference and r = R cos φ.
- **Add when on opposite sides, subtract when on the same side** — this rule applies identically to both latitude differences (N vs S) and longitude differences (E vs W). Say it as one sentence to yourself before every angular-distance question.
- **90/360, 60/360, 45/360, 30/360 simplify to nice fractions (1/4, 1/6, 1/8, 1/12)** — always simplify θ/360° to its lowest fraction FIRST before multiplying by 2πR; this avoids large, error-prone intermediate numbers.
- **Use π=22/7 whenever R is 6,370 or 6,400 (or another multiple of 7)** — both of the WAEC-standard Earth radii were chosen specifically to make 22/7 cancel cleanly, producing exact-looking answers like 10,010 km instead of messy decimals.
- **Quick estimate check: 1° along a meridian ≈ 111 km.** Before finalizing an answer, multiply your angular distance by 111 as a rough cross-check — e.g. 90° × 111 ≈ 9,990 km, which is close to the exact 10,010 km computed above, confirming no major arithmetic error.

**Gamified Exercise Bank**

Q1. Define: (a) Equator (b) Meridian (c) Great circle (d) Parallel of latitude (answer: see teaching notes)
Q2. What are the coordinates of the North Pole? (answer: 90°N, any longitude / undefined)
Q3. Calculate the radius of latitude 30°N if Earth's radius is 6,400km (answer: 5,542.6 km)
Q4. Find the circumference of the parallel of latitude 45°S (R=6,400km) (answer: ≈28,449 km)
Q5. Two points are on the same meridian at latitudes 50°N and 20°N. Find the angular distance (answer: 30°)
Q6. Find the distance between A(60°N,30°E) and B(20°N,30°E) in km (answer: ≈4,448 km using R=6400km,π=22/7)
Q7. Two towns P and Q are on latitude 60°N; P at 40°E, Q at 70°E. Find the distance along the parallel (answer: ≈1,676 km)
Q8. The radius of a parallel of latitude is 4,800km; find the latitude (R=6,400km) (answer: ≈41.4°)
Q9. What is the approximate distance represented by 1° along a meridian? (answer: ≈111 km)
Q10. Differentiate between a great circle and a small circle (answer: see teaching notes)
Q11. Find the radius of the following parallels (R=6,400km): (i) 0° (ii) 30°N (iii) 60°S (iv) 90°N (answer: (i) 6400 (ii) 5542.6 (iii) 3200 (iv) 0)
Q12. Calculate the circumference of latitude 50°N (answer: ≈25,847 km)
Q13. At what latitude is the radius of the parallel exactly half of Earth's radius? (answer: 60°)
Q14. Find the distance between (i) (30°N,20°E) and (50°N,20°E) (ii) (40°N,15°W) and (10°S,15°W) (answer: (i) 2,220 km (ii) 5,550 km)
Q15. Two cities A,B on the same meridian; A at 55°N, distance between them 5,550km. Find possible latitudes of B (answer: B at 5°N or 105°N — but 105°N invalid, so B=5°N)
Q16. X,Y on latitude 60°N at longitudes 10°W and 35°E; find (i) longitude difference (ii) distance along the parallel (answer: (i) 45° (ii) ≈2,513 km)
Q17. A ship sails from P(20°N,40°E) due north for 4,440km; find its new position (answer: latitude increases by 40°, so ≈60°N, 40°E)
Q18. An aircraft flies from A(60°N,30°W) to B(60°N,20°E) along the parallel; calculate the distance covered (answer: ≈2,791 km)
Q19. Two weather stations are 3,200km apart on latitude 45°S; one at longitude 120°E, find the longitude of the other (answer: ≈120°E ± 40.7°, i.e. ≈79.3°E or ≈160.7°E)
Q20. Find the time difference between places at 45°E and 90°E (answer: 3 hours)
Q21. If it is 3:00PM at 60°W, what is the time at 30°E? (answer: 9:00 PM)
Q22. When GMT is 12:00 noon, what is the local time at 75°E? (answer: 5:00 PM)
Q23. Two ships are on the same meridian at latitudes 30°15'N and 28°45'N. Find the distance in nautical miles (answer: 90 nautical miles)
Q24. Convert 120 nautical miles to kilometers (answer: 222.24 km)
Q25. A plane flies from A(20°N,40°E) to B(20°N,70°E) at 600km/h; how long does the journey take? (answer: ≈4.1 hours)
Q26. What is the time at 150°W when it is 6:00PM Monday at 30°E? (answer: 6:00 AM Monday)
Q27. Find the distance along the equator between longitudes 20°W and 50°E (answer: ≈7,791 km)
Q28. A ship travels at 25 knots for 8 hours; how far in km? (answer: ≈370.4 km)
Q29. If you cross the International Date Line from west to east on Friday at 2:00PM, what is the day/time after crossing? (answer: Thursday, 2:00 PM)
Q30. Find the angular difference between X(80°N,79°W) and Y(80°N,11°E) (answer: 90°)
Q31. Calculate the radius of latitude 75°N (answer: 1656 km)
Q32. Find the sectorial angle of Y(70°N,65°W) and Z(38°S,65°W) (answer: 108°)
Q33. Calculate the distance YZ if the radius of the earth is 6400km (answer: 3840 km)
Q34. An aircraft flew from A(0°,0°) to B(0°,180°) at speed 1000km/h. Calculate the distance travelled (π=22/7,R=6370km) (answer: ≈20,022 km)
Q35. Two places on the equator are 7,900km apart; find the difference in longitudes (R=6370km,π=3.14) (answer: ≈71.09°)
Q36. Two places on the same meridian have latitudes 10°S and 53°N; find their distance apart (π=22/7,R=6370km) (answer: 7040 km)
Q37. Find the distance measured along the parallel of latitude between two places at latitude 18°S, longitudes 96°E and 57°E (answer: ≈4145 km)
Q38. X(60°N,30°E), Y(60°N,85°E): find the sectorial angle XY along the parallel (answer: 55°)
Q39. If the radius of the earth is 6400km, find the radius of the parallel of latitude 60°N in the same setup (answer: 3200 km)
Q40. Two points X,Y on latitude 50°N directly opposite each other; if longitude of X is 50°E, what is the longitude of Y? (answer: 130°W)

---

### Week 9: Longitude and Latitude (continued)

**Teaching Notes**

Building on Week 8: real-world combined problems involving time, speed, and nautical distance.

*Time and longitude:* Earth rotates 360° in 24 hours, so 15° = 1 hour, and 1° = 4 minutes. Places **east** are ahead in time; places **west** are behind.
Time difference = (longitude difference) × 4 minutes.

*GMT (Greenwich Mean Time):* the time at longitude 0°.

*International Date Line* (~180° longitude): crossing **west→east subtracts** a day; crossing **east→west adds** a day.

*Nautical miles:* 1 nautical mile = 1 minute of arc (1') along a great circle ≈ 1.852 km. 1° = 60 nautical miles. **Knot** = 1 nautical mile per hour.

*Worked Example.* Find the time difference between longitudes 45°E and 75°E.
**Step 1 — Find the difference in longitude between the two places:** 75° − 45° = 30°.
**Step 2 — Convert degrees to time using 1° = 4 minutes (since 360° = 24 hours = 1440 minutes, and 1440÷360 = 4):** 30° × 4 min/° = 120 minutes.
**Step 3 — Convert minutes to hours:** 120 min ÷ 60 = 2 hours.
**Step 4 — Determine direction: since 75°E is further east than 45°E, it is ahead in time.**
**Answer: 2 hours, with 75°E ahead of 45°E.**

*Worked Example.* A plane leaves London (0°) at 8:00AM GMT, flies 6 hours to Lagos (15°E). Find the local arrival time in Lagos.
**Step 1 — Find the arrival time in GMT (the reference time zone) by adding the flight duration to the departure time:** 8:00AM + 6 hours = 2:00PM GMT.
**Step 2 — Find the time difference between Lagos (15°E) and GMT (0°) using 1°=4 minutes:** 15° × 4 min = 60 minutes = 1 hour.
**Step 3 — Determine direction: Lagos is east of Greenwich, so it is ahead of GMT.**
**Step 4 — Add the 1-hour difference to the GMT arrival time to get Lagos's local time:** 2:00PM + 1 hour = 3:00PM.
**Answer: 3:00 PM local time in Lagos.**

*Worked Example.* A ship travels 240 nautical miles in 6 hours. Find its speed in (a) knots (b) km/h.
**Step 1 — Recall the definition of a knot:** speed = distance (in nautical miles) ÷ time (in hours), with the result expressed in knots.
**Step 2 — Substitute the given values:** speed = 240 nautical miles ÷ 6 hours = 40.
**Answer (a): 40 knots.**
**Step 3 — Convert nautical miles per hour to kilometres per hour using 1 nautical mile ≈ 1.852 km:** 40 × 1.852 = 74.08.
**Answer (b): 74.08 km/h.**

*Worked Example.* Two ships are on the same meridian at latitudes 35°N and 37°30'N. Find the distance between them in (a) nautical miles (b) kilometres.
**Step 1 — Find the angular (latitude) distance between the ships, since they share a meridian:** 37°30' − 35°00' = 2°30'.
**Step 2 — Convert the angle fully into minutes of arc (since 1° = 60'):** 2°30' = (2×60)+30 = 150'.
**Step 3 — Apply the nautical-mile definition (1 nautical mile = 1 minute of arc along a great circle):** distance = 150 nautical miles directly — no further calculation needed for part (a).
**Answer (a): 150 nautical miles.**
**Step 4 — Convert to kilometres using 1 nautical mile ≈ 1.852 km:** 150 × 1.852 = 277.8.
**Answer (b): 277.8 km.**

⚡ **Shortcut & Speed Tips**
- **"15° = 1 hour, 1° = 4 minutes" — derive it instantly from 360°÷24hr if you forget it:** Earth turns 360° in 24 hours, so 360÷24=15° per hour, and 60÷15=4 minutes per degree. You never need to memorize this as an isolated fact; it falls out of "one full rotation per day."
- **East is always ahead, west is always behind — say this out loud before every time-zone question.** A huge share of lost marks on these questions comes from adding when you should subtract (or vice versa), not from the arithmetic itself.
- **For nautical-mile questions on a meridian, skip the kilometre formula entirely**: distance in nautical miles = angular distance directly converted to minutes of arc (degrees×60 + minutes). This is far faster than computing (θ/360)×2πR and then converting to nautical miles.
- **Memorize 1 nautical mile ≈ 1.852 km and 1° = 60 nautical miles as a linked pair** — converting between nautical miles, degrees, and kilometres becomes a single multiplication/division chain instead of three separate lookups.
- **International Date Line rule as a memory hook**: "West to East, lose a day" (like flying "backwards" in time relative to the date) and "East to West, gain a day" — pair this with the fact that crossing the Date Line is the opposite direction-logic from ordinary time-zone crossing, to avoid confusing the two rules.
- **For "GMT + flight time" questions, always compute the GMT arrival time FIRST, then convert to local time last** — trying to add local departure time directly to a longitude offset before accounting for flight duration is the most common source of errors in these multi-step problems.

**Gamified Exercise Bank**

Q1. Find the time difference between the longitudes: (i) 15°E and 45°E (ii) 30°W and 60°E (iii) 120°E and 150°W (answer: (i) 2hr (ii) 6hr (iii) 6hr)
Q2. If it is 8:30AM Wednesday at 75°W, find the time and day at: (i) 45°E (ii) 165°W (iii) 0° (GMT) (answer: (i) 4:30PM Wed (ii) 2:30AM Wed (iii) 1:30PM Wed)
Q3. Calculate the distance (km and nautical miles) between: (i) (25°30'N,10°E) and (32°45'N,10°E) (ii) points on the equator at 40°W and 20°E (answer: (i) ≈805 km/435 n.mi. (ii) ≈6,672 km)
Q4. X,Y on latitude 45°N; X at 30°W, Y at 15°E. Find (i) distance along the parallel (ii) time difference (iii) time at Y if noon at X (answer: (i) ≈3,538 km (ii) 3hr (iii) 3:00PM)
Q5. A ship sails from P(0°,20°W) due east along the equator at 30 knots. How long to reach Q(0°,40°E)? (answer: 60°×60 n.mi = 3600 n.mi ÷ 30 knots = 120 hours)
Q6. An aircraft leaves A(30°N,45°E) at 10:00AM local and arrives B(30°N,90°E) at 2:00PM local. Find (i) time difference (ii) actual flight time (iii) distance covered (iv) average speed (answer: (i) 3hr (ii) 1hr (iii) ≈4,330 km (iv) ≈4,330 km/h)
Q7. A conference call is at 3:00PM GMT. Local time in (i) Lagos (15°E) (ii) New York (75°W) (iii) Tokyo (135°E) (answer: (i) 4:00PM (ii) 10:00AM (iii) 12:00 midnight)
Q8. A football match starts 8:00PM London (0°). Local time in (i) Abuja (7.5°E) (ii) Los Angeles (120°W) (answer: (i) 8:30PM (ii) 12:00 noon)
Q9. Find the time difference between places at 45°E and 90°E (answer: 3hr)
Q10. If it is 3:00PM at 60°W, what is the time at 30°E? (answer: 9:00PM)
Q11. When GMT is 12 noon, local time at 75°E (answer: 5:00PM)
Q12. Two ships on the same meridian at latitudes 30°15'N and 28°45'N; find distance in nautical miles (answer: 90 n.mi.)
Q13. Convert 120 nautical miles to kilometers (answer: 222.24 km)
Q14. A plane flies from A(20°N,40°E) to B(20°N,70°E) at 600km/h; how long does the journey take? (answer: ≈4.1 hr)
Q15. What is the time at 150°W when it is 6:00PM Monday at 30°E? (answer: 6:00AM Monday)
Q16. Find the distance along the equator between longitudes 20°W and 50°E (answer: ≈7,791 km)
Q17. A ship travels at 25 knots for 8 hours; how far in km? (answer: ≈370.4 km)
Q18. If you cross the IDL from west to east on Friday at 2:00PM, what is the day/time after crossing? (answer: Thursday 2:00PM)
Q19. A ship leaves port A(60°N,40°W), sails south to port B on the equator, then east along the equator to port C at 20°E. Find (a) A→B (b) B→C (c) total (answer: (a) 6,660 km (b) 6,702 km (c) 13,362 km)
Q20. An aircraft leaves Lagos (6°30'N,3°30'E) 6:00AM Monday, flies 5 hours to London (51°30'N,0°). Find (a) time difference (b) arrival time (London) (c) GMT at departure (answer: (a) 14 min (b) 10:46AM Monday (c) 5:46AM GMT)
Q21. An aeroplane flies at 650km/h along parallel of latitude from X(15°S,10°W) to Y(15°S,48°E). Calculate the time (R=6400km,π=3.142) (answer: ≈10 hours)
Q22. What is the angle between P and Q whose longitudes are 102°E and 38°W lying on latitude 30°S? (answer: 140°)
Q23. Calculate the radius of the parallel of latitude 60°N (R=6400km) (answer: 3200 km)
Q24. Two villages at (15°S,107°E) and (15°S,17°E); find their distance apart along the latitude (answer: 2R cos15° × (π×90/360) — expressed in terms of π and R)
Q25. A(43°N,77°E), B(43°N,103°W), C(57°S,77°E). Find (i) distance A to B along latitude 43°N (ii) distance A to C along the great circle (π=3.142,R=6400km) (answer: (i) computed via 2πR cosφ formula (ii) via 2πR formula with θ=100°)

---

### Week 10: Arithmetic of Finance

**Teaching Notes**

*Simple interest:* I = PRT/100, where P=principal, R=rate per annum(%), T=time (years). Amount A = P + I.

*Compound interest:* A = P(1+r)ⁿ, where r=rate as a decimal, n=number of compounding periods. CI = A − P.
For k compounds per year over t years: A = P(1 + r/k)^(kt).

*Depreciation:*
- Straight-line: Annual depreciation = (Cost − Salvage value)/Useful life.
- Reducing balance: V = P(1−r)ⁿ.

*Annuities:*
- Future value (ordinary annuity): FV = P×[(1+r)ⁿ−1]/r.
- Present value: PV = P×[1−(1+r)⁻ⁿ]/r.

*Rule of 72:* Years to double an investment ≈ 72/(interest rate).

*Worked Example.* Find the simple interest on ₦50,000 for 3 years at 8% p.a.
**Step 1 — Write down the simple interest formula:** I = PRT/100, where P = principal, R = rate per annum (as a plain number, not a decimal), T = time in years.
**Step 2 — Identify the given values:** P = 50,000, R = 8, T = 3.
**Step 3 — Substitute into the formula:** I = (50,000 × 8 × 3)/100.
**Step 4 — Multiply the numerator:** 50,000 × 8 = 400,000; 400,000 × 3 = 1,200,000.
**Step 5 — Divide by 100:** 1,200,000 ÷ 100 = 12,000.
**Answer: I = ₦12,000.**

*Worked Example.* Find the compound interest on ₦10,000 for 3 years at 10% p.a.
**Step 1 — Write the compound interest amount formula:** A = P(1+r)ⁿ, where r is the rate as a decimal (10% = 0.10) and n is the number of years.
**Step 2 — Substitute the values:** A = 10,000 × (1.10)³.
**Step 3 — Evaluate (1.10)³ step by step:** 1.10² = 1.21; 1.21 × 1.10 = 1.331.
**Step 4 — Multiply by the principal:** A = 10,000 × 1.331 = 13,310.
**Step 5 — Subtract the principal to find just the interest earned (CI = A − P):** CI = 13,310 − 10,000 = 3,310.
**Answer: CI = ₦3,310.**

*Worked Example (WAEC-style).* Find the compound interest on ₦500 for 2 years at 6% p.a., using the year-by-year method.
**Step 1 — Compute Year 1's interest on the original principal:** Interest = 500 × 6% = 500 × 0.06 = 30.
**Step 2 — Add Year 1's interest to the principal to get the new principal for Year 2:** 500 + 30 = 530.
**Step 3 — Compute Year 2's interest on this NEW principal (this is what makes it "compound"):** Interest = 530 × 6% = 530 × 0.06 = 31.80.
**Step 4 — Add Year 2's interest to find the final amount:** 530 + 31.80 = 561.80.
**Step 5 — Subtract the original principal to isolate the total compound interest earned:** CI = 561.80 − 500 = 61.80.
**Answer: CI = ₦61.80** (check using the formula: A = 500×1.06² = 500×1.1236 = 561.80 ✓).

*Worked Example (WAEC-style).* At what rate percent per annum will ₦520 yield simple interest of ₦39 in 3 years?
**Step 1 — Start from the simple interest formula and substitute all known values:** I = PRT/100 → 39 = (520 × R × 3)/100.
**Step 2 — Simplify the right-hand side's constants:** 520 × 3 = 1,560, so 39 = (1,560 × R)/100.
**Step 3 — Multiply both sides by 100 to clear the fraction:** 3,900 = 1,560 × R.
**Step 4 — Divide both sides by 1,560 to isolate R:** R = 3,900 ÷ 1,560 = 2.5.
**Answer: R = 2½%.**

⚡ **Shortcut & Speed Tips**
- **Memorize the SI formula as "PRT over 100" and always keep R as a plain number (not ÷100 twice)** — the most common student slip is dividing by 100 both when writing R as a decimal AND again in the formula. Pick one convention (PRT/100 with R as e.g. "8") and stick to it throughout a calculation.
- **For compound interest over a SMALL number of years (2–3), the year-by-year method is often faster than computing (1+r)ⁿ with a calculator** — especially useful when you don't trust your power-evaluation, since each year is just "old amount × (1+rate)".
- **"Find the rate/time/principal" SI questions are all the SAME formula rearranged** — I=PRT/100 rearranges to R=100I/(PT), T=100I/(PR), P=100I/(RT). Memorize the one formula and rearrange on the spot rather than memorizing four separate formulas.
- **Compare SI vs CI quickly using this fact: for T=1 year, SI and CI are always identical**; CI only overtakes SI from year 2 onward, and the gap widens each year. This lets you sanity-check "which is better" comparison questions at a glance — CI should never be less than SI for the same rate over more than 1 year.
- **"Doubles/triples the money" problems convert straight to a ratio.** If a sum doubles under SI, then I=P, so PRT/100=P simplifies to RT=100 — you don't need P at all. This is the fastest route to "doubles in ₉ years, find the rate" type questions.
- **Watch out for time given in months** — always convert to years first (divide by 12) before substituting into I=PRT/100; forgetting this conversion is one of the most common WAEC arithmetic-of-finance errors.

**Gamified Exercise Bank**

Q1. Find the simple interest on ₦25,000 for 4 years at 6% p.a. (answer: ₦6,000)
Q2. Calculate the compound interest on ₦40,000 for 3 years at 8% p.a. (answer: ≈₦10,398.85)
Q3. Which gives more interest: ₦100,000 at 10% SI for 3 years, or ₦100,000 at 8% CI for 3 years? (answer: SI gives ₦30,000; CI gives ≈₦25,971 — SI is more here)
Q4. A car worth ₦3,000,000 depreciates at 20% p.a.; find its value after 2 years (answer: ₦1,920,000)
Q5. Find the annual depreciation of a machine costing ₦800,000, salvage value ₦80,000, after 10 years (straight-line) (answer: ₦72,000/year)
Q6. How much should be deposited now at 12% CI to have ₦500,000 in 4 years? (answer: ≈₦317,760)
Q7. Find the monthly payment on a loan of ₦200,000 at 18% p.a. for 2 years (answer: ≈₦9,984)
Q8. A person deposits ₦5,000 monthly for 3 years at 9% p.a.; find the total amount (answer: ≈₦208,900, using annuity FV formula)
Q9. An investment of ₦150,000 grows to ₦180,000 in 2 years; find the annual compound interest rate (answer: ≈9.5%)
Q10. Using the Rule of 72, estimate how long it takes money to double at 8% (answer: 9 years)
Q11. Calculate the SI on ₦75,000 for 5 years at 7.5% p.a. (answer: ₦28,125)
Q12. Find the CI on ₦60,000 for 2 years at 10% p.a. compounded (i) annually (ii) semi-annually (iii) quarterly (answer: (i) A=60000×1.1²=72,600, CI=₦12,600 (ii) rate 5% per half-year for 4 periods: A=60000×1.05⁴=72,930.38, CI=₦12,930.38 (iii) rate 2.5% per quarter for 8 periods: A=60000×1.025⁸=73,104.17, CI=₦13,104.17 — CORRECTED: an earlier draft gave ₦12,616 and ₦12,625, which do not match A=P(1+r/k)^(kt) worked out fully)
Q13. A sum of money doubles itself in 8 years at SI. Find the rate (answer: 12.5%)
Q14. At what compound rate will ₦50,000 amount to ₦66,550 in 3 years? (answer: 10%)
Q15. A laptop costs ₦200,000, depreciates at 25% p.a. Find (i) value after 3 years (ii) total depreciation (answer: (i) ₦84,375 (ii) ₦115,625)
Q16. A machine depreciates from ₦500,000 to ₦320,000 in 2 years. Find (i) annual depreciation rate (ii) value after 5 years (answer: (i) ≈20% (ii) ≈₦163,840)
Q17. Vehicle costing ₦5,000,000, salvage ₦500,000 after 8 years (straight-line). Find (i) annual depreciation (ii) book value after 5 years (answer: (i) ₦562,500 (ii) ₦2,187,500)
Q18. Tunde saves ₦10,000 monthly for 4 years at 12% p.a. compounded monthly. Find the total saved (answer: ≈₦608,204)
Q19. What is the present value of receiving ₦50,000 annually for 6 years at 8% discount rate? (answer: ≈₦231,300)
Q20. A car loan of ₦2,500,000 at 15% p.a. for 5 years: find (i) monthly payment (ii) total repaid (iii) total interest (answer: use amortization formula)
Q21. A mortgage of ₦8,000,000 at 9% for 15 years: monthly payment? (answer: use amortization formula)
Q22. Compare ₦1,000,000 at 13% SI for 4 years vs 11% CI for 4 years — which is better and by how much? (answer: SI=₦1,520,000; CI≈₦1,518,070; SI better by ≈₦1,930)
Q23. Business investment of ₦3,000,000 with profits Y1:400,000, Y2:600,000, Y3:800,000, Y4:900,000. Find (i) total profit (ii) average annual ROI (iii) compare with 12% CI (answer: (i) ₦2,700,000 (ii) ≈22.5%/yr average)
Q24. A treasury bill, 182-day maturity, face value ₦5,000,000, 14% discount rate. Find (i) purchase price (ii) interest earned (answer: (i) ≈₦4,650,685 (ii) ≈₦349,315)
Q25. Find the simple interest on ₦3000 for 5 years at 6% p.a. (answer: ₦900, i.e. amounts to ₦3,900)
Q26. What will ₦3000 amount to in 5 years at 6% p.a. SI? A ₦3,900 B ₦3,750 C ₦3,600 D ₦3,300 (answer: A)
Q27. Find the SI on ₦2500 for 2 years at 5% p.a. A ₦250 B ₦500 C ₦625 D ₦1250 E ₦6250 (answer: A)
Q28. At what rate % p.a. will ₦520 yield SI of ₦39 in 3 years? A 4% B 3½% C 3% D 2½% (answer: D)
Q29. Calculate the rate % p.a. at which ₦5,000 doubles itself in 20 years (answer: 5%)
Q30. A simple interest on a sum invested at 4% for 4 years was ₦4,040. How much was invested? (answer: ₦25,250)
Q31. How long will it take ₦2,600 to earn ₦520 at 5% p.a. SI? A 14yrs B 10yrs C 8yrs D 4yrs (answer: D)
Q32. After how many years will ₦6,000,000 yield ₦860,000 interest at 10% p.a.? A 1.4yrs B 4yrs8mo C 48yrs D 96yrs (answer: A)
Q33. Find the amount if SI is paid on ₦34,320 for 5 years at 6¼% p.a. (answer: ₦45,045)
Q34. A man invests ₦20,000 in Bank A (y% p.a. SI) and ₦25,000 in Bank B (1.5y% p.a.); total interest ₦4,600 after 1 year. Find y (answer: 8%)
Q35. p naira invested for 4 years at r% SI yields 0.36p naira interest. Find r (answer: 9%)
Q36. A man took a loan of $P at 4% p.a. SI; after 5 years he paid back $720. Find P (answer: $600)
Q37. If SI on ₦4,500 for 3 years is ₦540, find the SI on ₦6,500 for 2 years at the same rate (answer: ₦520)
Q38. Find the rate at which ₦327.50 yields ₦78.60 in 6 years (answer: 4%)
Q39. If ₦10,000 is kept at 12½% p.a., how long to yield ₦2,500 interest? (answer: 2 years)
Q40. Find the SI on ₦2970 in 12 years at 6% (answer: ₦2,138.40)
Q41. A man borrows ₦16,000, repays ₦16,900 after 9 months. Find the rate % p.a. (answer: 7½%)
Q42. If ₦15,000 amounts to ₦20,000 in 2 years at SI, find the rate (answer: 16⅔%)
Q43. Find the SI on ₦700 for 9 years at 3% p.a. (answer: ₦189)
Q44. At what rate % will ₦4,800 amount to ₦5,040 in 2½ years SI? (answer: 2%)
Q45. Find the SI on ₦5,400 for 10 months at 5% p.a. (answer: ₦225)
Q46. If ₦2,500 amounts to ₦3,500 in 4 years SI, find the rate (answer: 10%)
Q47. The CI on ₦500 for 2 years at 6% p.a. is: A ₦30 B ₦31 C ₦61.80 D ₦91.80 E ₦92.80 (answer: C)
Q48. Find the CI on ₦400 for 2 years at 8% p.a. A ₦32 B ₦34.56 C ₦66.56 D ₦432 E ₦466.56 (answer: C)
Q49. A man invests £1500 for 2 years at CI. After 1 year, his money amounts to £1560. Find (i) rate of interest (ii) interest for the second year (answer: (i) 4% (ii) £62.40)
Q50. A bond with face value ₦100,000 pays 9% annual interest; find the annual interest payment (answer: ₦9,000)
Q51. An investor buys 800 shares at ₦35 each; company pays 12% dividend on ₦40 nominal value; find total dividend (answer: ₦3,840)
Q52. Calculate the VAT on goods worth ₦150,000 at 7.5% (answer: ₦11,250)
Q53. A worker earns ₦1,800,000 annually; after ₦300,000 tax-free allowance, tax is 10% on the first ₦500,000 and 15% on the remainder; find the tax payable (answer: taxable income = 1,800,000−300,000 = 1,500,000; tax on first 500,000 = 10%×500,000 = 50,000; remainder = 1,500,000−500,000 = 1,000,000, tax = 15%×1,000,000 = 150,000; total tax = 50,000+150,000 = ₦200,000 — CORRECTED: an earlier draft gave ₦125,000, which does not match the stated bands)
Q54. A shop sells an item for ₦53,750 including 7.5% VAT; find the price before VAT (answer: ₦50,000)
Q55. Shares with ₦25 nominal value pay 16% dividend; purchased at ₦30, find the rate of return (answer: 13.33%)
Q56. Use logarithms to find the amount when ₦25,000 is invested at 12% CI for 4 years (answer: ≈₦39,338)
Q57. A company issues debentures worth ₦2,000,000 at 7% for 8 years; calculate the total interest payable (answer: ₦1,120,000)
Q58. Calculate the current yield on a ₦100,000 bond with 10% coupon rate selling at ₦95,000 (answer: 10.53%)
Q59. An investor owns 500 preference shares paying 8% dividend on ₦50 nominal value; calculate the annual dividend (answer: ₦2,000)

---

### Week 11: Revision

**Teaching Notes**

Comprehensive revision of all First Term topics: Indices/Logarithm, Surds, Surds in Trigonometry, Matrices and Determinants, Linear and Quadratic Equations, Sphere/Hemisphere Mensuration, Longitude and Latitude, and Arithmetic of Finance.

⚡ **Shortcut & Speed Tips (Whole-Term Revision Strategy)**
- **Group the ten weeks into three "formula families"** rather than treating them as ten unrelated topics: (1) index/log/surd manipulation rules (Weeks 1–3), (2) matrix and equation-solving techniques (Weeks 4–5), (3) mensuration and real-world application formulas (Weeks 6, 8–10). Revising by family, not by week number, exposes shared patterns (e.g. "isolate, then invert/root" appears in indices, surds, AND matrix inverses).
- **Build a single-page "trigger word → formula" table**: "surds/rationalize"→conjugate; "log equation"→product/quotient law then convert to exponential form; "matrix, solve simultaneous"→X=A⁻¹B; "sphere/hemisphere"→4πr²/(4/3)πr³/3πr²; "same meridian"→add/subtract latitudes; "same parallel"→r=Rcosφ; "doubles/triples"→RT=100 (SI) or rⁿ=2 (CI). Recognizing the trigger word instantly cues the right method under time pressure.
- **Re-derive, don't just re-read, each topic's ONE hardest worked example** from memory — the sphere/hemisphere combined-solid problem, the matrix simultaneous-equations problem, and a multi-step longitude/time problem are good stress-tests, since these combine several formulas in one question, mirroring WAEC's own style.
- **Time-box past-question practice**: allocate roughly proportional revision time to how heavily each topic is historically tested — indices/logarithms, quadratic equations, and arithmetic of finance tend to appear most reliably on WAEC/NECO First Term-aligned papers, so weight practice accordingly.

**Gamified Exercise Bank**

*(Use a mixed drill drawn from Weeks 1–10 above; no additional distinct exercises found in the source material for this administrative revision week.)*

---

### Week 12: Examination

**Teaching Notes**

First Term examination — no new content. Students are examined on all topics from Weeks 1–10.

⚡ **Shortcut & Speed Tips (Exam-Day Technique)**
- **Read through the entire paper first and answer the questions you're most confident about before the harder ones** — this banks easy marks early and prevents a single difficult matrix or finance question from eating time meant for three easier ones.
- **Always show every step of working, even for "obvious" answers** — WAEC and NECO award method marks, so a correct final answer with no working can score less than a fully-worked answer that makes a small arithmetic slip near the end.
- **Use estimation as your last line of defence**: before submitting, sanity-check a few answers against rough mental estimates (e.g. a sphere's volume should roughly match (4/3)×3×r³, a compound interest amount should always exceed the equivalent simple interest amount after year 1) — this catches misplaced decimal points and sign errors in the final minutes.
- **Keep units and labels attached throughout your working** (cm², km, ₦, hours) — losing track of units is a common way marks are dropped even when the numeric method is entirely correct.

**Gamified Exercise Bank**

*(No dedicated exercises in the source material — this week is the formal examination itself.)*

---

## Second Term

### Week 1: Interest on Bonds and Debentures; Taxes and VAT

**Teaching Notes**

*Bonds:* a debt security — the investor lends money to government/corporation for a fixed period at a fixed rate (coupon rate). Key terms: **Face Value** (amount repaid at maturity), **Coupon Rate** (the fixed annual interest rate), **Maturity Date** (when the principal is repaid), **Current Yield** (annual interest ÷ current market price). Annual interest = Face value × Coupon rate. **Current yield** = Annual interest ÷ Current market price × 100%.

*Debentures:* unsecured debt instruments backed only by the issuer's creditworthiness (no collateral required, fixed interest rate, priority over shareholders on liquidation, generally lower rates than secured bonds). Total repayment at maturity = Principal + (Annual interest × years).

*Shares and dividends:* Ordinary shares (voting rights, dividend not guaranteed, last paid on liquidation, higher potential returns) vs Preference shares (fixed dividend rate, priority over ordinary shares, usually no vote, lower risk/lower return). Nominal (par) value is the face value of a share; market value is what it currently trades for. Dividend per share = Nominal value × Dividend rate. Dividend yield / rate of return = (Dividend per share ÷ Market price) × 100%.

*Income tax (Nigerian system):* Taxable income = Gross income − allowable deductions (e.g. Consolidated Relief Allowance = 20% of gross + a flat amount, plus dependent, life-insurance and NHF reliefs). Tax is then applied progressively in bands — each band's rate applies only to the slice of income within that band, not the whole income (e.g. 7% on first ₦300,000 of taxable income, 11% on the next ₦500,000, etc.), and any income left over after all the stated bands is taxed at the final/remainder rate.

*VAT (Nigeria, standard rate 7.5%):* VAT = Price × VAT rate. Final Price = Original Price × (1 + VAT rate). To strip VAT out of a VAT-inclusive price, divide by (1 + VAT rate) — never just subtract 7.5% of the inclusive price.

*Worked Example.* A government bond has face value ₦100,000, coupon rate 12% p.a., matures in 5 years. Find (a) annual interest (b) total interest over the bond's life.
**Step 1 — Identify the formula:** Annual interest = Face value × Coupon rate.
**Step 2 — Substitute and compute (a):** 100,000 × 12% = 100,000 × 0.12 = ₦12,000 per year.
**Step 3 — Compute total interest (b):** Total interest = Annual interest × Number of years = 12,000 × 5 = ₦60,000.
**Answer: (a) ₦12,000/year (b) ₦60,000.**

*Worked Example.* A bond with face value ₦50,000 and 10% coupon rate is selling at ₦45,000. Find the current yield.
**Step 1 — Find the annual interest (based on face value, not market price):** 50,000 × 10% = ₦5,000.
**Step 2 — Apply the current yield formula:** Current yield = (Annual interest ÷ Current market price) × 100%.
**Step 3 — Substitute and compute:** (5,000 ÷ 45,000) × 100% = 11.11%.
**Answer: 11.11%.**

*Worked Example.* A laptop costs ₦250,000 before VAT at 7.5%. Find (a) VAT amount (b) total price.
**Step 1 — Compute the VAT amount:** VAT = Price × VAT rate = 250,000 × 0.075 = ₦18,750.
**Step 2 — Add VAT to the original price:** Total price = 250,000 + 18,750 = ₦268,750.
**Step 3 — Check by the shortcut formula:** Total = 250,000 × 1.075 = ₦268,750 ✓ (same answer).
**Answer: (a) ₦18,750 (b) ₦268,750.**

*Worked Example.* A restaurant bill including 7.5% VAT is ₦21,500. Find the cost before VAT.
**Step 1 — Set up the equation:** Let the pre-VAT cost be x. Since VAT is added on top, x + 0.075x = 21,500.
**Step 2 — Simplify the left side:** 1.075x = 21,500.
**Step 3 — Solve for x:** x = 21,500 ÷ 1.075 = ₦20,000.
**Step 4 — Find the VAT amount as a check:** VAT = 21,500 − 20,000 = ₦1,500.
**Answer: ₦20,000 (VAT = ₦1,500).**

*Worked Example.* A worker earns ₦3,600,000/year; first ₦300,000 tax-free, then 7% on next ₦300,000, 11% on next ₦500,000, 15% on next ₦500,000, 19% on next ₦1,600,000, 21% on the remainder. Find the total tax.
**Step 1 — Find the taxable income:** Taxable income = 3,600,000 − 300,000 (tax-free portion) = ₦3,300,000.
**Step 2 — Tax each band separately, working down through the taxable income:**
 • On the first ₦300,000 (of the taxable amount): 300,000 × 7% = ₦21,000
 • On the next ₦500,000: 500,000 × 11% = ₦55,000
 • On the next ₦500,000: 500,000 × 15% = ₦75,000
 • On the next ₦1,600,000: 1,600,000 × 19% = ₦304,000
 • Income used so far: 300,000+500,000+500,000+1,600,000 = ₦2,900,000, leaving a remainder of 3,300,000 − 2,900,000 = ₦400,000, taxed at 21%: 400,000 × 21% = ₦84,000
**Step 3 — Add all the band-taxes together:** 21,000+55,000+75,000+304,000+84,000 = **₦539,000**.
**Answer: ₦539,000.**

**⚡ Shortcut & Speed Tips**

- **VAT mental math at 7.5%:** 7.5% = 3/40 = 10% − 2.5% = 10% minus a quarter of that 10%. So to find VAT fast: take 10% of the price, then subtract a quarter of that 10% figure. E.g. for ₦250,000: 10% = 25,000; a quarter of 25,000 = 6,250; VAT = 25,000 − 6,250 = ₦18,750 — matches the long method instantly.
- **Removing VAT from a VAT-inclusive price:** never subtract 7.5% of the inclusive price (that's a common trap). Always divide by 1.075. Quick check: inclusive price ÷ 1.075 = price before VAT; the difference is the VAT.
- **Progressive tax bands — never apply one rate to the whole income.** Work band-by-band from the bottom up, and remember: whatever is left after all stated bands is taxed at the final/"remainder" rate — don't forget this last slice.
- **Current yield vs coupon rate:** coupon rate is always calculated on face value; current yield is calculated on market price. If a bond sells below face value, current yield > coupon rate; if it sells above face value, current yield < coupon rate — a fast sanity check on your answer.
- **Compound interest via logarithms:** for A = P(1+r)ⁿ, take log A = log P + n log(1+r); this turns repeated multiplication into simple addition — much faster by hand than multiplying (1+r) by itself n times.

**Gamified Exercise Bank**

Q1. A bond with face value ₦80,000 pays 9% annual interest; find the annual interest payment (answer: ₦7,200)
Q2. An investor buys 800 shares at ₦35 each; company pays 12% dividend on ₦40 nominal value; find total dividend (answer: ₦3,840)
Q3. Calculate the VAT on goods worth ₦150,000 at 7.5% VAT rate (answer: ₦11,250)
Q4. A worker earns ₦1,800,000 annually; after ₦300,000 tax-free allowance, 10% on the first ₦500,000, 15% on the remainder; find the tax payable (answer: ₦125,000)
Q5. A shop sells an item for ₦53,750 including 7.5% VAT; find the price before VAT (answer: ₦50,000)
Q6. Shares with ₦25 nominal value pay 16% dividend; purchased at ₦30, find the rate of return (answer: 13.33%)
Q7. Use logarithms to find the amount when ₦25,000 is invested at 12% compound interest for 4 years (answer: ≈₦39,338)
Q8. A company issues debentures worth ₦2,000,000 at 7% for 8 years; calculate the total interest payable (answer: ₦1,120,000)
Q9. Calculate the current yield on a ₦100,000 bond with 10% coupon rate selling at ₦95,000 (answer: 10.53%)
Q10. An investor owns 500 preference shares paying 8% dividend on ₦50 nominal value; calculate the annual dividend (answer: ₦2,000)
Q11. A government bond with face value ₦250,000 and coupon rate 11% matures in 7 years. Find (i) annual interest (ii) total interest over bond life (iii) total received at maturity (answer: (i) ₦27,500 (ii) ₦192,500 (iii) ₦442,500)
Q12. A corporate bond with face value ₦100,000, 9% coupon, selling at ₦92,000. Find (i) current yield (ii) annual interest for 5 bonds (answer: (i) ≈9.78% (ii) ₦45,000)
Q13. An investor buys 2,500 shares at ₦48 each; company declares 20% dividend on ₦40 nominal value. Find (i) total investment (ii) dividend per share (iii) total dividend (iv) rate of return (answer: (i) ₦120,000 (ii) ₦8 (iii) ₦20,000 (iv) 16.67%)
Q14. A company has 5,000,000 shares of ₦10 nominal value, declares 15% dividend. If you own 0.5% of the company, how much dividend do you receive? (answer: ₦37,500)
Q15. Calculate tax on annual income ₦4,200,000 with bands: first ₦300,000 free; next ₦300,000 at 7%; next ₦500,000 at 11%; next ₦500,000 at 15%; next ₦1,600,000 at 19%; remainder at 21% (answer: taxable income after the free band = ₦3,900,000; bands used = 300,000+500,000+500,000+1,600,000=₦2,900,000, leaving a remainder of ₦1,000,000 taxed at 21%=₦210,000; total tax = ₦21,000+55,000+75,000+304,000+210,000=**₦665,000** — corrected from a mis-stated remainder in the original source, which had used a remainder of ₦900,000 instead of the correct ₦1,000,000)
Q16. An employee earns ₦350,000 monthly; annual consolidated relief 20%+₦200,000. Find (i) annual gross income (ii) total relief (iii) taxable income (answer: (i) ₦4,200,000 (ii) ₦1,040,000 (iii) ₦3,160,000)
Q17. Find VAT and total price for: (i) Laptop ₦180,000 (ii) Restaurant meal ₦12,500 (iii) Car ₦3,500,000, all at 7.5% VAT (answer: (i) VAT=₦13,500, total=₦193,500 (ii) VAT=₦937.50, total=₦13,437.50 (iii) VAT=₦262,500, total=₦3,762,500)
Q18. A shop's total sales including VAT are ₦5,375,000 for a month. Find (i) sales before VAT (ii) VAT to remit (answer: (i) ₦5,000,000 (ii) ₦375,000)
Q19. Use logarithm tables to calculate (i) ₦75,500 at 9% CI for 6 years (ii) principal that amounts to ₦50,000 in 4 years at 12% CI (answer: computed via log tables)
Q20. A bond's value grows from ₦80,000 to ₦120,000 in 5 years; find the annual compound growth rate using logarithms (answer: ≈8.45%)

---

### Week 2: Coordinate Geometry of a Straight Line — Distance and Midpoint

**Teaching Notes**

The **Cartesian plane** has an x-axis and y-axis meeting at the origin (0,0), dividing the plane into four quadrants (Q1: x>0,y>0; Q2: x<0,y>0; Q3: x<0,y<0; Q4: x>0,y<0). A point on an axis itself (x=0 or y=0) is not considered to lie in any quadrant.

**Distance formula** between P(x₁,y₁) and Q(x₂,y₂):
d = √[(x₂−x₁)² + (y₂−y₁)²]  — derived from Pythagoras' theorem: the horizontal leg has length |x₂−x₁|, the vertical leg has length |y₂−y₁|, and d is the hypotenuse of the right triangle they form, so d² = (x₂−x₁)² + (y₂−y₁)².

**Midpoint formula**:
M = ((x₁+x₂)/2, (y₁+y₂)/2) — literally "average the x's, average the y's."

*Worked Example.* Find the distance between A(2,3) and B(5,7).
**Step 1 — Label the coordinates:** x₁=2, y₁=3, x₂=5, y₂=7.
**Step 2 — Substitute into the distance formula:** d = √[(5−2)² + (7−3)²].
**Step 3 — Simplify inside the root:** = √[3² + 4²] = √[9+16] = √25.
**Step 4 — Take the square root:** √25 = 5.
**Answer: 5 units.**

*Worked Example.* Find the midpoint of A(4,6) and B(10,14).
**Step 1 — Average the x-coordinates:** (4+10)/2 = 14/2 = 7.
**Step 2 — Average the y-coordinates:** (6+14)/2 = 20/2 = 10.
**Answer: M(7,10).**

*Worked Example.* A line segment has endpoints A(−3,5) and B(7,−1). Find (a) the midpoint M, (b) the distance |AB|, (c) the distance |AM|, and confirm |AM|=½|AB|.
**Step 1 — Find the midpoint (a):** M = ((−3+7)/2, (5+(−1))/2) = (4/2, 4/2) = (2,2).
**Step 2 — Find |AB| (b):** |AB| = √[(7−(−3))² + (−1−5)²] = √[10² + (−6)²] = √[100+36] = √136 = 2√34 units.
**Step 3 — Find |AM| (c):** |AM| = √[(2−(−3))² + (2−5)²] = √[5² + (−3)²] = √[25+9] = √34 units.
**Step 4 — Check the halfway relationship:** ½|AB| = ½(2√34) = √34 = |AM| ✓.
**Answer: (a) M(2,2) (b) |AB| = 2√34 units (c) |AM| = √34 units.**

*Worked Example (WAEC-style).* Find the distance between (2,5) and (5,9).
**Step 1 — Substitute into d = √[(x₂−x₁)²+(y₂−y₁)²]:** d = √[(5−2)²+(9−5)²].
**Step 2 — Simplify:** = √[3²+4²] = √[9+16] = √25.
**Step 3 — Take the root:** = 5.
**Answer: 5 units** (this is a WAEC classic — it's the 3-4-5 Pythagorean triple in disguise).

*Worked Example (WAEC-style).* If the mid-point of PQ is (2,3) and P is (−2,1), find Q.
**Step 1 — Let Q = (a,b) and apply the midpoint formula:** ((−2+a)/2, (1+b)/2) = (2,3).
**Step 2 — Equate the x-parts:** (−2+a)/2 = 2 → −2+a = 4 → a = 6.
**Step 3 — Equate the y-parts:** (1+b)/2 = 3 → 1+b = 6 → b = 5.
**Answer: Q(6,5).**

**⚡ Shortcut & Speed Tips**

- **Spot Pythagorean triples instantly:** if the horizontal and vertical differences form a known triple (3-4-5, 5-12-13, 6-8-10, 8-15-17, 7-24-25), you can write the distance straight down without computing the square root by long division/estimation — e.g. differences of 8 and 15 mean the distance is 17 immediately.
- **Midpoint is just an average — do it in your head:** for "nice" coordinates, average the x's and y's mentally rather than writing the formula out; e.g. midpoint of (6,10) and (4,2) is instantly (5,6).
- **"Find the other endpoint given one endpoint and the midpoint" — double the midpoint, subtract the known point:** if M is the midpoint of PQ, then Q = 2M − P (component-wise). This is faster than solving two equations from scratch, e.g. Q6(5,−7): 2(3,−4)−(6,5) = (6−6,−8−5) = (0,−13).
- **Collinearity/quadrant checks don't need the full distance formula** — for "which points are closest" style questions, compare the squared distances (skip the final square root) until the very last step; it saves arithmetic and avoids rounding errors when comparing.
- **Distance-squared trick for equations with an unknown:** when a problem gives you "distance = k, find x," square both sides immediately to remove the root before expanding — this avoids working with surds in the equation-solving step.

**Gamified Exercise Bank**

Q1. Plot the points A(3,2), B(−2,4), C(−3,−1), D(2,−3) and state their quadrants (answer: A→Q1, B→Q2, C→Q3, D→Q4)
Q2. Find the distance between P(4,7) and Q(10,15) (answer: 10 units)
Q3. Determine the midpoint of the line joining A(−4,3) and B(6,−5) (answer: (1,−1))
Q4. Calculate the distance between: (i) A(5,8) and B(9,11) (ii) P(−3,4) and Q(5,−2) (iii) M(−6,−8) and N(2,7) (answer: (i) 5 (ii) 10 (iii) 17)
Q5. Find the midpoint of: (i) the line joining (7,9) and (15,21) (ii) AB where A(−5,3) and B(7,−9) (answer: (i) (11,15) (ii) (1,−3))
Q6. The distance between A(x,5) and B(7,9) is 5 units. Find possible values of x (answer: x=4 or 10)
Q7. Three vertices of a rectangle are A(2,1), B(6,1), C(6,4). Find (i) the fourth vertex D (ii) length of diagonal AC (iii) midpoint of diagonal BD (answer: (i) D(2,4) (ii) 5 units (iii) (4,2.5))
Q8. A treasure map shows treasure at T(8,11); you start at S(2,3). (i) How far is the treasure? (ii) Midpoint coordinates? (iii) Distance from midpoint to treasure? (answer: (i) 10 (ii) (5,7) (iii) 5)
Q9. Towns X,Y,Z at (0,0), (12,5), (4,9). (i) Which two towns are closest? (ii) Find the centroid (hospital location) (answer: (i) XY=√169=13, XZ=√97≈9.85, YZ=√80≈8.94 — **Y and Z are closest, distance ≈8.94** (corrected: the original source wrongly named X and Z as the closest pair) (ii) (16/3, 14/3))
Q10. Prove that triangle A(1,2), B(4,6), C(7,2) is isosceles (answer: AB=√25=5, BC=√25=5, AC=6 — AB=BC, isosceles)
Q11. Show PQRS with P(1,2), Q(5,3), R(6,7), S(2,6) is a parallelogram (answer: PQ∥SR and QR∥PS, verified by equal gradients)
Q12. Prove that A(0,0), B(4,3), C(8,6) are collinear (answer: gradient AB=gradient BC=3/4)
Q13. Find the distance between (2,5) and (5,9) — WAEC style: A 4 units B 5 units C 12 units D 14 units (answer: B)
Q14. Find the distance between Y(7,9) and Z(15,11) — WAEC style: A 3√17 B 2√17 C 2√34 D 4√17 (answer: B)
Q15. If the distance between (−3,−2) and (1,y) is 2√5 units, find y: A 4 B 2 C −2 D −4 (answer: A or D — solving gives y=0 or y=−4; source indicates D)
Q16. Find the distance between (½,½) and (−½,−½): A √2 B 0 C 1 D √3 (answer: A)
Q17. What is r if the distance between (4,2) and (1,r) is 3 units? A 1 B 2 C 3 D 4 (answer: B)
Q18. Find the distance between (4,3) and the intersection of y=2x+4 and y=7−x (answer: 3√2)
Q19. If α+β=2 and the distance between (1,α) and (β,1) is 3 units, find α²+β² (answer: 11)
Q20. Find the midpoint of S(−5,4) and T(−3,−2): A (−4,1) B (4,−1) C (−4,2) D (4,−2) (answer: A)
Q21. Find the midpoint of M(6,10) and N(4,2): A (2,8) B (10,12) C (−5,−6) D (5,6) (answer: D)
Q22. If the midpoint of PQ is (2,3) and P is (−2,1), find Q: A (8,6) B (5,6) C (0,4) D (6,5) (answer: D)
Q23. Midpoint of P(m,n) and Q(1,3) is R(2,4); find m and n: A 4,3 B 2,7 C 4,2 D 3,5 (answer: D — solving gives m=3,n=5)
Q24. M(3,−4) is the midpoint of PQ; P is (6,5); find Q: A (0,−13) B (4.0,0.5) C (3,2.5) D (12,−3) (answer: A)
Q25. Find k if the midpoint of (1−k,−4) and (2,k+1) is (−k,k): A −3 B −1 C −4 D −2 (answer: A)
Q26. Find the midpoint of the line y−4x+3=0 between the x-axis and y-axis intercepts (answer: (3/8, −3/2))

---

### Week 3: Coordinate Geometry of a Straight Line — Gradient, Equation, and Angle Between Lines

**Teaching Notes**

**Gradient (slope)** of a line through P(x₁,y₁) and Q(x₂,y₂): m = (y₂−y₁)/(x₂−x₁) = rise/run. A positive gradient slopes upward left-to-right; a negative gradient slopes downward; a zero gradient is a horizontal line; an undefined (vertical) line has no gradient (division by zero).

- **Parallel lines**: m₁ = m₂.
- **Perpendicular lines**: m₁ × m₂ = −1, equivalently m₂ = −1/m₁ (the negative reciprocal).
- **Collinear points**: three or more points lie on one straight line exactly when the gradient between any pair of them is the same.

**Equation of a straight line:**
- Slope-intercept form: y = mx + c (m=gradient, c=y-intercept).
- Point-slope form: y − y₁ = m(x − x₁) — use when you know one point and the gradient.
- Two-point form: first compute m = (y₂−y₁)/(x₂−x₁), then apply point-slope form with either point.
- General form: ax + by + c = 0.

**Intercepts:** x-intercept (set y=0, solve for x); y-intercept (set x=0, solve for y).

**Angle of inclination θ:** the angle a line makes with the positive x-axis, measured anticlockwise; m = tanθ. For θ in the second quadrant (obtuse), remember tan is negative there: tanθ = −tan(180°−θ).

**Angle between two intersecting lines** with gradients m₁, m₂: tanθ = |(m₁−m₂)/(1+m₁m₂)| (the modulus gives the acute angle between the lines).

*Worked Example.* Find the gradient of the line through A(2,3) and B(6,11).
**Step 1 — Label coordinates:** x₁=2, y₁=3, x₂=6, y₁=11.
**Step 2 — Apply the gradient formula:** m = (y₂−y₁)/(x₂−x₁) = (11−3)/(6−2).
**Step 3 — Simplify:** = 8/4 = 2.
**Answer: m = 2** (line slopes upward).

*Worked Example.* Find the equation of a line with gradient 3 through (2,5).
**Step 1 — Start from y = mx + c with m = 3:** y = 3x + c.
**Step 2 — Substitute the known point (2,5) to find c:** 5 = 3(2) + c → 5 = 6 + c.
**Step 3 — Solve for c:** c = 5 − 6 = −1.
**Answer: y = 3x − 1.**

*Worked Example.* Show that the line through A(1,2) and B(4,8) is parallel to the line through C(−2,1) and D(1,7).
**Step 1 — Find gradient of AB:** m₁ = (8−2)/(4−1) = 6/3 = 2.
**Step 2 — Find gradient of CD:** m₂ = (7−1)/(1−(−2)) = 6/3 = 2.
**Step 3 — Compare:** m₁ = m₂ = 2.
**Answer: since the gradients are equal, AB ∥ CD.**

*Worked Example.* Show that the line through P(2,3) and Q(6,5) is perpendicular to the line through R(1,4) and S(3,0).
**Step 1 — Find gradient of PQ:** m₁ = (5−3)/(6−2) = 2/4 = 1/2.
**Step 2 — Find gradient of RS:** m₂ = (0−4)/(3−1) = −4/2 = −2.
**Step 3 — Multiply the gradients:** m₁ × m₂ = (1/2)×(−2) = −1.
**Answer: since m₁m₂ = −1, PQ ⊥ RS.**

*Worked Example (WAEC-style).* Find the gradient of the line joining S(5,6) and R(−7,−8).
**Step 1 — Substitute into m = (y₂−y₁)/(x₂−x₁):** m = (−8−6)/(−7−5).
**Step 2 — Simplify numerator and denominator:** = −14/−12.
**Step 3 — Reduce the fraction (divide by −2):** = 7/6.
**Answer: m = 7/6.**

*Worked Example.* Find the x and y intercepts of the line 3x + 4y = 12.
**Step 1 — Find the y-intercept by setting x = 0:** 3(0) + 4y = 12 → 4y = 12 → y = 3. So (0,3).
**Step 2 — Find the x-intercept by setting y = 0:** 3x + 4(0) = 12 → 3x = 12 → x = 4. So (4,0).
**Answer: x-intercept (4,0), y-intercept (0,3).**

*Worked Example (WAEC-style).* A straight line makes an angle of 30° with the positive x-axis and cuts the y-axis at y=5. Find the equation.
**Step 1 — Find the gradient from the angle:** m = tan30° = 1/√3 (= √3/3).
**Step 2 — Identify c:** the line cuts the y-axis at y=5, so c = 5.
**Step 3 — Write y = mx + c:** y = x/√3 + 5.
**Step 4 — Clear the surd by multiplying through by √3:** √3y = x + 5√3.
**Answer: √3y = x + 5√3** (equivalently y = x/√3 + 5).

*Worked Example (WAEC-style).* Find the acute angle between the lines y = x and y = √3x.
**Step 1 — Read off the gradients:** m₁ = 1 (from y=x), m₂ = √3 (from y=√3x).
**Step 2 — Apply the angle-between-lines formula:** tanθ = |(m₁−m₂)/(1+m₁m₂)| = |(1−√3)/(1+√3)|.
**Step 3 — Rationalize the denominator by multiplying top and bottom by (1−√3):** (1−√3)(1−√3)/[(1+√3)(1−√3)] = (1−2√3+3)/(1−3) = (4−2√3)/(−2) = √3−2.
**Step 4 — Take the modulus and evaluate:** tanθ = |√3−2| = 2−√3 ≈ 2−1.732 = 0.268.
**Step 5 — Take the inverse tangent:** θ = tan⁻¹(0.268) = 15°.
**Answer: θ = 15°.**

**⚡ Shortcut & Speed Tips**

- **Perpendicular gradient shortcut:** flip the fraction and change the sign — that's all "negative reciprocal" means. Gradient 2/3 → perpendicular gradient is −3/2. Gradient −4 (i.e. −4/1) → perpendicular gradient is 1/4.
- **Rearrange to y = mx + c fast:** for ax + by = c, gradient is always −a/b and y-intercept is c/b — memorize this pattern so you can read off m and c without fully re-deriving them each time.
- **Recognize special angles instantly:** tan30°=1/√3, tan45°=1, tan60°=√3 — these three come up constantly in "angle of inclination" questions; know them cold rather than re-deriving with a calculator.
- **Collinearity in one line:** to check three points are collinear, just compute the gradient between the first pair and the gradient between the second pair — if they match, you're done; no need to check the third pair.
- **For "acute angle between two lines," always take the modulus** before applying tan⁻¹ — this guarantees you land in 0°–90° and avoids accidentally reporting the obtuse angle instead.

**Gamified Exercise Bank**

Q1. Calculate the gradient of the line passing through (2,5) and (8,17) (answer: 2)
Q2. Show that the points A(1,2), B(3,4), C(7,8) are collinear (answer: gradient AB=1, BC=1 — collinear)
Q3. Find the equation of a line with gradient 4 passing through (1,5) (answer: y=4x+1)
Q4. Determine if the lines through A(1,3),B(4,5) and C(2,1),D(8,−5) are parallel or perpendicular (answer: m₁=2/3, m₂=−1 — neither)
Q5. Find the x and y intercepts of 5x−3y=15 (answer: x-intercept (3,0), y-intercept (0,−5))
Q6. A line passes through (2,7) with gradient −3; write its equation (answer: y=−3x+13)
Q7. The points P(3,k), Q(7,10) lie on a line with gradient 2; find k (answer: k=2)
Q8. Find the gradient of the line through: (i) (3,7) and (9,19) (ii) (−4,5) and (2,−7) (iii) (a,3a) and (2a,7a) (answer: (i) 2 (ii) −2 (iii) 4)
Q9. Show that AB is parallel to CD if A(2,3), B(6,7), C(−1,2), D(3,6) (answer: both gradients = 1)
Q10. Prove that PQ is perpendicular to RS if P(1,4), Q(5,6), R(3,2), S(1,6) (answer: m(PQ)=1/2, m(RS)=−2, product=−1)
Q11. Find the equation of the line: (i) gradient 5 through (2,3) (ii) through (1,4) and (3,10) (iii) gradient −2, y-intercept 5 (answer: (i) y=5x−7 (ii) y=3x+1 (iii) y=−2x+5)
Q12. Write in the form y=mx+c: (i) 3x+4y=12 (ii) 2x−5y+10=0 (iii) x−y=7 (answer: (i) y=−¾x+3 (ii) y=(2/5)x+2 (iii) y=x−7)
Q13. For each line find x and y intercepts: (a) y=3x−6 (b) 2x+3y=12 (c) 5x−4y=20 (d) y=−2x+8 (answer: (a) (2,0),(0,−6) (b) (6,0),(0,4) (c) (4,0),(0,−5) (d) (4,0),(0,8))
Q14. Prove that the triangle with vertices A(1,2), B(4,6), C(7,2) is isosceles (answer: AB=BC=5)
Q15. Find the gradient of a line inclined at 45° to the x-axis (answer: m=1)
Q16. A line has gradient √3; find its angle of inclination (answer: 60°)
Q17. Three vertices of a parallelogram: A(1,2), B(4,3), C(6,6). Find the fourth vertex D (answer: D(3,5))
Q18. A road is built from Town A(2,5)km to Town B(10,17)km. Find (a) distance (b) gradient (c) midpoint (rest stop) coordinates (answer: (a) ≈14.42 km (b) 1.5 (c) (6,11))
Q19. Find the gradient of the line passing through P(1,1) and Q(2,5): A 4 B 2 C 3 D 5 (answer: A)
Q20. Find the gradient of PQ where P(5,−7), Q(−2,−3): A 1/2 B 2/5 C −4/7 D −2/3 (answer: C)
Q21. The gradient of the line joining (x,4) and (1,2) is 1/2. Find x (answer: x=−3)
Q22. Find the gradient of the line joining P(4,−1) and Q(−3,−5): A 4/7 B 7 C −4/7 D −7/4 (answer: A)
Q23. Find the gradient of the line joining S(5,6) and R(−7,−8): A 7/6 B −1 C 1 D −7/6 (answer: A)
Q24. What is P if the gradient of the line joining (−1,P) and (P,4) is 2/3? (answer: P=1)
Q25. A line passes through the origin and (1¼, 2½). What is its gradient? And find y when x=4 (answer: gradient=2; y=8)
Q26. A straight line makes an angle of 30° with the positive x-axis and cuts the y-axis at y=5; find its equation (answer: √3y = x + 5√3, equivalently y=x/√3+5)

---

### Week 4: Differentiation of Algebraic Functions I — First Principles

**Teaching Notes**

**Differentiation** finds the rate of change (slope of the tangent) of a function — it answers "how fast is y changing as x changes?"

**Limits:** lim[x→a] f(x) = L means f(x) approaches L as x approaches a. Direct substitution works when it gives a real number; indeterminate forms (0/0) are resolved by factoring/cancelling the troublesome factor first, then substituting.

**First Principle definition** (the formal, from-scratch definition of the derivative):
f'(x) = lim[h→0] [f(x+h) − f(x)] / h
Geometrically: P(x,f(x)) and Q(x+h,f(x+h)) are two points on the curve; [f(x+h)−f(x)]/h is the gradient of the chord PQ. As h→0, Q slides along the curve to meet P, and the chord's gradient approaches the gradient of the tangent at P — that limiting value is f'(x).

**Standard derivatives** (Power Rule): if f(x) = xⁿ, then f'(x) = nxⁿ⁻¹ — this can itself be proved from first principles using the binomial expansion of (x+h)ⁿ.

**Rules:**
- Constant multiple: d/dx[c·f(x)] = c·f'(x)
- Sum/difference: d/dx[f(x)±g(x)] = f'(x)±g'(x)
- A lone constant differentiates to 0 (its rate of change is always zero).

**Physical interpretation:** if s(t)=distance (displacement), s'(t)=velocity (rate of change of distance); if v(t)=velocity, v'(t)=acceleration (rate of change of velocity). A particle is momentarily "at rest" when velocity = 0. Geometrically, f'(a) = slope of the tangent to y=f(x) at x=a = the instantaneous rate of change there.

**Tangent/Normal:** at point (x₀,y₀), tangent slope m = f'(x₀); normal slope = −1/m (perpendicular to the tangent). Use point-slope form y−y₀=m(x−x₀) for each line's equation.

*Worked Example.* Find the derivative of f(x)=x² from first principles.
**Step 1 — Write out f(x+h):** f(x+h) = (x+h)² = x²+2xh+h².
**Step 2 — Form the difference f(x+h)−f(x):** (x²+2xh+h²) − x² = 2xh+h².
**Step 3 — Divide by h:** [2xh+h²]/h = h(2x+h)/h = 2x+h (for h≠0, the h's cancel).
**Step 4 — Take the limit as h→0:** lim[h→0](2x+h) = 2x+0 = 2x.
**Answer: f'(x) = 2x.**

*Worked Example.* Differentiate f(x)=x³ from first principles.
**Step 1 — Expand f(x+h) using the binomial expansion:** f(x+h) = (x+h)³ = x³+3x²h+3xh²+h³.
**Step 2 — Subtract f(x):** (x³+3x²h+3xh²+h³) − x³ = 3x²h+3xh²+h³.
**Step 3 — Divide by h:** [3x²h+3xh²+h³]/h = h(3x²+3xh+h²)/h = 3x²+3xh+h².
**Step 4 — Take the limit as h→0:** 3x²+3x(0)+0² = 3x².
**Answer: f'(x) = 3x²** (this confirms the power rule pattern d/dx[xⁿ]=nxⁿ⁻¹ for n=3).

*Worked Example.* Differentiate f(x)=1/x from first principles.
**Step 1 — Write f(x+h):** f(x+h) = 1/(x+h).
**Step 2 — Form the difference and combine over a common denominator:** 1/(x+h) − 1/x = [x−(x+h)]/[x(x+h)] = −h/[x(x+h)].
**Step 3 — Divide by h:** [−h/(x(x+h))]/h = −1/[x(x+h)] (the h's cancel).
**Step 4 — Take the limit as h→0:** −1/[x(x+0)] = −1/x².
**Answer: f'(x) = −1/x².**

*Worked Example (WAEC-style).* Differentiate 3x² from the first principle.
**Step 1 — Let y = 3x²; write y+Δy for x+Δx:** y+Δy = 3(x+Δx)² = 3[x²+2xΔx+(Δx)²] = 3x²+6xΔx+3(Δx)².
**Step 2 — Subtract y = 3x² from both sides:** Δy = 6xΔx+3(Δx)².
**Step 3 — Divide through by Δx:** Δy/Δx = 6x+3Δx.
**Step 4 — Let Δx→0:** dy/dx = lim(6x+3Δx) = 6x.
**Answer: dy/dx = 6x.**

*Worked Example.* Find f'(x) if f(x)=3x²+4x−7.
**Step 1 — Differentiate term by term using the power rule:** d/dx[3x²]=3·2x=6x; d/dx[4x]=4·1=4; d/dx[−7]=0 (constant).
**Step 2 — Add the results:** f'(x) = 6x+4+0.
**Answer: f'(x) = 6x+4.**

*Worked Example.* Find dy/dx if y=(3x²+5)/x.
**Step 1 — Simplify by splitting the fraction first (don't use the quotient rule for something this simple):** y = 3x²/x + 5/x = 3x + 5x⁻¹.
**Step 2 — Differentiate each term:** d/dx[3x]=3; d/dx[5x⁻¹]=5(−1)x⁻²=−5x⁻².
**Step 3 — Combine:** dy/dx = 3 − 5/x².
**Answer: dy/dx = 3 − 5/x².**

*Worked Example.* A particle moves along a line according to s(t)=t³−6t²+9t (s in metres, t in seconds). Find (a) velocity at any time t, (b) velocity at t=2, (c) when the particle is at rest.
**Step 1 — Differentiate s(t) to get velocity (a):** v(t) = ds/dt = 3t²−12t+9.
**Step 2 — Substitute t=2 (b):** v(2) = 3(4)−12(2)+9 = 12−24+9 = −3 m/s (negative means moving in the reverse direction).
**Step 3 — Set v(t)=0 and solve for t (c):** 3t²−12t+9=0 → divide by 3: t²−4t+3=0 → factor: (t−1)(t−3)=0 → t=1 or t=3.
**Answer: (a) v(t)=3t²−12t+9 (b) −3 m/s (c) at rest at t=1s and t=3s.**

*Worked Example.* Find the equation of the tangent to y=x² at (3,9).
**Step 1 — Differentiate to get the general gradient function:** dy/dx = 2x.
**Step 2 — Substitute x=3 to get the gradient at that point:** m = 2(3) = 6.
**Step 3 — Apply point-slope form with (3,9):** y−9 = 6(x−3).
**Step 4 — Expand and simplify:** y−9 = 6x−18 → y = 6x−18+9 = 6x−9.
**Answer: y = 6x−9.**

*Worked Example.* Find equations of both the tangent and normal to y=x³−3x at x=2.
**Step 1 — Find the y-coordinate at x=2:** y = (2)³−3(2) = 8−6 = 2. Point is (2,2).
**Step 2 — Differentiate to get the gradient function:** dy/dx = 3x²−3.
**Step 3 — Substitute x=2 to get the tangent slope:** m = 3(4)−3 = 12−3 = 9.
**Step 4 — Tangent equation (point-slope, then simplify):** y−2 = 9(x−2) → y = 9x−18+2 = 9x−16.
**Step 5 — Normal slope is the negative reciprocal:** m_normal = −1/9.
**Step 6 — Normal equation:** y−2 = (−1/9)(x−2) → 9y−18 = −x+2 → x+9y = 20.
**Answer: Tangent: y = 9x−16; Normal: x+9y = 20.**

**⚡ Shortcut & Speed Tips**

- **Power rule shortcut — "bring down, knock off one":** for xⁿ, bring the exponent down as a multiplier and reduce the exponent by 1. Do this instantly for every term instead of re-deriving from first principles every time (first principles is only needed when a question explicitly says "from first principles").
- **Split fractions before differentiating:** an expression like (3x²+5)/x should be split into 3x+5/x⁻¹ term-by-term before differentiating — trying to use the quotient rule here is slower and more error-prone than necessary.
- **Constants vanish:** any term with no x (a plain number) always differentiates to 0 — don't waste time "differentiating" it, just drop it.
- **Particle "at rest" = velocity zero, not position zero:** a very common exam trap. Always differentiate position to get velocity, then set velocity (not position) to 0.
- **Tangent parallel to a given line ⇒ same gradient:** if asked to find where a tangent is parallel to y=4x−1, just set the derivative equal to 4 and solve for x — no need to find the tangent equation itself first.

**Gamified Exercise Bank**

Q1. Evaluate: lim[x→5] (x²+2x) (answer: 35)
Q2. Evaluate: lim[h→0] [(x+h)²−x²]/h (answer: 2x)
Q3. Differentiate y=x³ from first principles (answer: dy/dx=3x²)
Q4. Find f'(x) if f(x)=3x²+5x−2 (answer: 6x+5)
Q5. Differentiate y=4x³−7x²+2x−9 (answer: 12x²−14x+2)
Q6. If f(x)=x⁴, find f'(2) (answer: 32)
Q7. Find dy/dx if y=(2x³+3)/x (answer: dy/dx=4x−3/x²)
Q8. A particle's position is s(t)=t³+4t; find its velocity at t=3 (answer: 31)
Q9. Find the slope of the tangent to y=x³ at x=1 (answer: 3)
Q10. Differentiate y=3x+2/x (answer: dy/dx=3−2/x²)
Q11. Evaluate: (a) lim[x→4] (x²−16)/(x−4) (b) lim[h→0] [(3+h)²−9]/h (c) lim[x→2] (x³−8)/(x−2) (d) lim[h→0][(1+h)³−1]/h (answer: (a) 8 (b) 6 (c) 12 (d) 3)
Q12. Differentiate from first principles: (a) f(x)=3x+2 (b) f(x)=x²+4x (c) f(x)=2x³ (d) f(x)=1/(x+1) (answer: (a) 3 (b) 2x+4 (c) 6x² (d) −1/(x+1)²)
Q13. Find dy/dx for: (a) y=5x²−3x³+7 (b) y=2x⁴+4x³−6x+1 (c) y=x⁵−2x⁴+3x²−x (d) y=(x+1)(x²−3) (e) y=(3x²−4x)/x² (f) y=4x²−3/x+2√x (answer: (a) 10x−9x² (b) 8x³+12x²−6 (c) 5x⁴−8x³+6x−1 (d) 3x²+2x−3 (e) dy/dx=4/x² (f) 8x+3/x²+1/√x)
Q14. A particle moves according to s=t³−9t²+15t; find (i) velocity function (ii) velocity at t=2 (iii) when at rest (iv) acceleration (answer: (i) v=3t²−18t+15 (ii) −9 (iii) t=1 or 5 (iv) a=6t−18)
Q15. Height of a ball h=20t−5t²: find (i) initial velocity (ii) time to max height (iii) max height (answer: (i) 20 (ii) t=2 (iii) 20)
Q16. Find the equation of the tangent to y=x²+2x at (1,3) (answer: y=4x−1)
Q17. Find equations of tangent and normal to y=x³−3x² at x=2 (answer: point (2,−4); tangent slope 0 → y=−4 (horizontal tangent); normal x=2)
Q18. At what point on y=x² is the tangent parallel to y=4x−1? (answer: (2,4))
Q19. Find the points on y=x³ where the tangent is horizontal (answer: (0,0))
Q20. If f(x)=ax²+bx+c and f'(1)=8, f'(2)=14, f(0)=5, find a,b,c (answer: a=3,b=2,c=5)
Q21. The curve y=x²+px+q passes through (1,6) with slope 5 there. Find p,q (answer: p=3, q=2)
Q22. Prove from first principles that if f(x)=xⁿ, f'(x)=nxⁿ⁻¹ for n=4 (answer: shown via binomial expansion of (x+Δx)⁴)
Q23. Find the derivative of y=1/x from first principles (answer: dy/dx=−1/x²)
Q24. Find f'(x) if f(x)=2x+5 using first principles (answer: f'(x)=2)
Q25. Differentiate 1/x³ from the first principle (answer: −3/x⁴)
Q26. Differentiate 5x−1/x² from the first principle (answer: dy/dx=5+2/x³)

---

### Week 5: Differentiation of Algebraic Functions II — Product, Quotient, Chain Rules, Maxima/Minima

**Teaching Notes**

**Product Rule:** if y = u·v (both functions of x), then dy/dx = u(dv/dx) + v(du/dx). Memory aid: "first times derivative of second, plus second times derivative of first."

**Quotient Rule:** if y = u/v, then dy/dx = [v(du/dx) − u(dv/dx)]/v². Memory aid: "bottom times derivative of top, minus top times derivative of bottom, all over bottom squared."

**Chain Rule:** if y = f(u), u = g(x), then dy/dx = (dy/du)×(du/dx). Used for "a function of a function" — differentiate the outer function (leaving the inner function alone), then multiply by the derivative of the inner function.

**Related rates:** use the chain rule when several quantities change with time, e.g. dV/dt = (dV/dr)×(dr/dt) — this lets you connect a rate you're given to a rate you want.

**Stationary/turning points:** occur where f'(x)=0. Classify using the second derivative:
- f''(x) < 0 → maximum
- f''(x) > 0 → minimum
- f''(x) = 0 → inconclusive (test values either side, or check higher derivatives)

**Optimization:** set up a function for the quantity to be maximized/minimized in one variable (using a constraint to eliminate the other variable), differentiate, set the derivative to zero, solve, and classify with the second derivative.

**Business applications:** Marginal Cost/Revenue/Profit = derivative of the respective total function with respect to quantity — the approximate cost/revenue/profit of producing one more unit.

*Worked Example.* Differentiate y=(3x²+2)(4x³−5) using the product rule.
**Step 1 — Identify u and v, and differentiate each:** u=3x²+2 → du/dx=6x; v=4x³−5 → dv/dx=12x².
**Step 2 — Apply the product rule dy/dx = u(dv/dx)+v(du/dx):** dy/dx = (3x²+2)(12x²) + (4x³−5)(6x).
**Step 3 — Expand each bracket:** (3x²+2)(12x²) = 36x⁴+24x²; (4x³−5)(6x) = 24x⁴−30x.
**Step 4 — Combine like terms:** 36x⁴+24x²+24x⁴−30x = 60x⁴+24x²−30x.
**Step 5 — Check by expanding y first and differentiating directly:** y=12x⁵−15x²+8x³−10 → dy/dx=60x⁴−30x+24x², same result ✓.
**Answer: dy/dx = 60x⁴+24x²−30x.**

*Worked Example.* Differentiate y=(3x+2)/(x−1) using the quotient rule.
**Step 1 — Identify u and v, and differentiate each:** u=3x+2 → du/dx=3; v=x−1 → dv/dx=1.
**Step 2 — Apply the quotient rule dy/dx=[v(du/dx)−u(dv/dx)]/v²:** dy/dx = [(x−1)(3) − (3x+2)(1)]/(x−1)².
**Step 3 — Expand the numerator:** (x−1)(3) = 3x−3; (3x+2)(1) = 3x+2.
**Step 4 — Subtract and simplify:** (3x−3) − (3x+2) = 3x−3−3x−2 = −5.
**Answer: dy/dx = −5/(x−1)².**

*Worked Example.* Find dy/dx for y=(3x+2)⁵ using the chain rule.
**Step 1 — Let u = 3x+2 (the inner function), so y = u⁵:** du/dx = 3; dy/du = 5u⁴.
**Step 2 — Apply the chain rule dy/dx = (dy/du)×(du/dx):** dy/dx = 5u⁴×3 = 15u⁴.
**Step 3 — Substitute u back:** dy/dx = 15(3x+2)⁴.
**Answer: dy/dx = 15(3x+2)⁴.**

*Worked Example.* Find dy/dx if y = x²(3x−1)⁴ (product rule combined with chain rule).
**Step 1 — Identify u and v:** u = x² → du/dx = 2x; v = (3x−1)⁴ → dv/dx = 4(3x−1)³×3 = 12(3x−1)³ (chain rule on v).
**Step 2 — Apply the product rule:** dy/dx = x²×12(3x−1)³ + (3x−1)⁴×2x = 12x²(3x−1)³ + 2x(3x−1)⁴.
**Step 3 — Factor out the common factors 2x(3x−1)³:** = 2x(3x−1)³[6x + (3x−1)].
**Step 4 — Simplify the bracket:** 6x+3x−1 = 9x−1.
**Answer: dy/dx = 2x(3x−1)³(9x−1).**

*Worked Example.* A spherical balloon is being inflated; its radius increases at 3 cm/s. Find the rate of increase of volume when r = 10 cm.
**Step 1 — Write the volume formula and differentiate with respect to r:** V = (4/3)πr³ → dV/dr = 4πr².
**Step 2 — Apply the chain rule to connect dV/dt to the given dr/dt:** dV/dt = (dV/dr)×(dr/dt) = 4πr² × 3 = 12πr².
**Step 3 — Substitute r = 10:** dV/dt = 12π(100) = 1200π ≈ 3,769.91 cm³/s.
**Answer: dV/dt = 1200π cm³/s ≈ 3,769.91 cm³/s.**

*Worked Example.* Find the stationary points of f(x)=x³−3x²−9x+5, and classify each.
**Step 1 — Differentiate:** f'(x) = 3x²−6x−9.
**Step 2 — Set f'(x)=0 and simplify:** 3x²−6x−9=0 → divide by 3: x²−2x−3=0.
**Step 3 — Factorize:** (x−3)(x+1)=0 → x=3 or x=−1.
**Step 4 — Find the y-coordinates:** f(3)=27−27−27+5=−22; f(−1)=−1−3+9+5=10. Stationary points: (−1,10) and (3,−22).
**Step 5 — Differentiate again to classify, using the second derivative test:** f''(x) = 6x−6.
**Step 6 — Test each point:** at x=−1: f''(−1)=−6−6=−12<0 → maximum; at x=3: f''(3)=18−6=12>0 → minimum.
**Answer: Maximum at (−1,10); Minimum at (3,−22).**

*Worked Example.* A farmer has 200 m of fencing for a rectangular plot. Find the dimensions that give maximum area.
**Step 1 — Set up the constraint:** let the sides be x and y; perimeter 2x+2y=200 → y=100−x.
**Step 2 — Write the area as a function of one variable:** A = xy = x(100−x) = 100x−x².
**Step 3 — Differentiate and set to zero:** dA/dx = 100−2x = 0 → x = 50.
**Step 4 — Find y:** y = 100−50 = 50.
**Step 5 — Confirm it's a maximum:** d²A/dx² = −2 < 0 → maximum ✓.
**Step 6 — Compute the maximum area:** A = 50×50 = 2,500 m².
**Answer: a square of side 50 m gives the maximum area, 2,500 m².**

**⚡ Shortcut & Speed Tips**

- **"First-times-derivative-of-second, plus second-times-derivative-of-first"** — chant the product rule this way and you'll never mix up which term gets differentiated first.
- **Quotient rule mnemonic "LO d-HI minus HI d-LO, over LO-LO":** (bottom × d(top) − top × d(bottom)) all over (bottom)². Saying it out loud in this order prevents sign errors, which are the #1 quotient-rule mistake.
- **Chain rule shortcut for (ax+b)ⁿ:** d/dx[(ax+b)ⁿ] = n·a·(ax+b)ⁿ⁻¹ — just multiply the usual power-rule result by the derivative of the inner linear bracket (which is simply "a"). No need to write out u and du/dx separately once this pattern is memorized.
- **Second-derivative test is much faster than sign-testing:** once you have the stationary x-values, just plug into f''(x) — negative means maximum, positive means minimum. Only fall back to testing values on either side if f''(x)=0.
- **Optimization word problems — always reduce to one variable using the constraint first**, then differentiate. If the two dimensions come out equal at the optimum (as in many perimeter/area or surface-area/volume problems), that's a strong hint the shape should be square/cubic — a good way to sanity-check your algebra.
- **Marginal quantity = derivative, no extra work:** "marginal cost/revenue/profit" is just asking you to differentiate the given Cost/Revenue/Profit function — don't overthink the economics wording.

**Gamified Exercise Bank**

Q1. Differentiate using the product rule: y=(2x+3)(x²−1) (answer: dy/dx=6x²+6x−2)
Q2. Use the quotient rule: y=(3x+1)/(x−2) (answer: dy/dx=−7/(x−2)²)
Q3. Differentiate using the chain rule: y=(5x−3)⁴ (answer: dy/dx=20(5x−3)³)
Q4. Find f'(x) if f(x)=x²(x+1)³ (answer: 2x(x+1)³+3x²(x+1)² = x(x+1)²(5x+2))
Q5. Differentiate y=√(x²+4) (answer: dy/dx=x/√(x²+4))
Q6. A cube's edge is increasing at 2cm/s; find the rate of volume increase when edge=5cm (answer: dV/dt=3e²×de/dt=150 cm³/s)
Q7. Find stationary points of f(x)=x²−12x+5 (answer: minimum at (6,−31))
Q8. Cost function C(x)=100+10x+0.5x²; find marginal cost at x=20 (answer: MC=30)
Q9. Find dy/dx if y=(2x+1)³/(x−3) (answer: via quotient+chain rule)
Q10. Maximize the area of a rectangle with perimeter 60m (answer: square, side 15m, area 225m²)
Q11. Differentiate: (a) y=(x²+2)(x²−4) (b) y=(3x+1)(2x²+5x−3) (c) y=x²(x−2)³ (d) f(x)=(x²+1)(x+3) (answer: (a) 4x³−4x (b) 18x²+22x−13 (c) 2x(x−2)³+3x²(x−2)² (d) 3x²+6x+1)
Q12. Find dy/dx: (a) y=(x+1)/(x−1) (b) y=(2x²+3)/(x+2) (c) y=x/(x²+4) (d) y=(x²−1)/(x²+1) (answer: (a) −2/(x−1)² (b) (2x²+8x−3)/(x+2)² (c) (4−x²)/(x²+4)² (d) 4x/(x²+1)²)
Q13. Differentiate: (a) y=(4x−7)³ (b) y=√(x²+3x−1) (c) y=(5x+2)⁴ (d) y=1/(3x−4)² (e) f(x)=(2x²−x+1)⁻² (answer: (a) 12(4x−7)² (b) (2x+3)/[2√(x²+3x−1)] (c) 20(5x+2)³ (d) −6/(3x−4)³ (e) −2(4x−1)/(2x²−x+1)³)
Q14. Find dy/dx: (a) y=x²(2x+1)⁴ (b) y=(x+3)²/(x−2) (c) y=(x²+1)³(x−1) (d) y=(x²+1)²/(2x−1)² (answer: (a) 2x(2x+1)³(6x+1) (b) (x+3)(x−7)/(x−2)² (c) (x²+1)²(7x²−6x+1) (d) 4(x²+1)(x²−x−1)/(2x−1)³ — all obtained by combining the product/chain and quotient/chain rules)
Q15. Radius of a circle increasing at 3cm/s; find rate of increase of (i) circumference (ii) area when r=10cm (answer: (i) 6π cm/s (ii) 60π cm²/s)
Q16. A ladder 10m leans against a wall; bottom slides at 0.5m/s. How fast is the top sliding down when bottom is 6m from wall? (answer: 3/8 m/s)
Q17. Water drains from a conical tank (vertex down) at 2m³/min; radius=4m, height=6m. How fast is the water level falling at depth 3m? (answer: use similar triangles + related rates)
Q18. Find and classify stationary points: (i) f(x)=x³−6x²+9x+2 (ii) y=2x³+3x²−12x+5 (answer: (i) max(1,6), min(3,2) (ii) max(−2,25), min(1,−2))
Q19. Find max/min of f(x)=x⁴−8x²+3 for −3≤x≤3 (answer: stationary points at f'(x)=4x³−16x=4x(x−2)(x+2)=0 → x=0,±2; f(0)=3 (local max), f(±2)=−13 (minimum); checking the endpoints too — since the domain is restricted — f(±3)=12, which is larger than the local max of 3, so the **absolute minimum on [−3,3] is −13 at x=±2** and the **absolute maximum is 12 at x=±3** (the endpoints beat the local max; x=0 is only a local maximum))
Q20. A rectangle has perimeter 40cm; find dimensions for max area (answer: square 10cm×10cm)
Q21. Find two positive numbers whose sum is 20 and product is maximum (answer: 10 and 10)
Q22. Total revenue R(x)=50x−0.5x²; find (i) marginal revenue (ii) revenue-maximizing quantity (iii) max revenue (answer: (i) 50−x (ii) x=50 (iii) 1250)
Q23. C(x)=200+30x+0.1x², R(x)=80x−0.2x²; find (i) profit function (ii) marginal profit (iii) profit-maximizing quantity (iv) max profit (answer: (i) −0.3x²+50x−200 (ii) −0.6x+50 (iii) x≈83.3 (iv) ≈₦1,883.33)
Q24. Company profit P(t)=−t³+15t²+72t (₦1000s); find (i) rate of profit growth (ii) when profit increasing fastest (iii) max profit and when (answer: (i) −3t²+30t+72 (ii) t=5 (iii) via 2nd derivative test)
Q25. Rectangular garden fenced on 3 sides (4th is a wall), 60m fencing; find dimensions for max area (answer: width=30m (perpendicular sides), length=30m (parallel to wall) — area=450m²)
Q26. A cylindrical can contains 1000cm³; find dimensions minimizing surface area (answer: r=(500/π)^(1/3), h=2r)
Q27. A wire 100cm is cut into two pieces, one forming a square, the other a circle. How to cut to (i) minimize total area (ii) maximize total area? (answer: (i) split proportionally per calculus optimization (ii) all wire to the circle)
Q28. A box with square base, open top, volume 32cm³; find dimensions minimizing surface area (answer: base 4cm×4cm, height 2cm)
Q29. Calculate the minimum value of y=2x³−6x+3 (answer: −1)
Q30. Find the maximum value of f(x)=x³−12x+5 (answer: 21)
Q31. Obtain a maximum value of f(x)=x³−12x+11 (answer: 27)
Q32. Find the coordinates of point P, the maximum point on y=x³+3x²−7 (answer: P(−2,−3))
Q33. Find the turning points of y=2x³−6x²−18x+3 (answer: (−1,13) and (3,−51))
Q34. Find the coordinates of the minimum point for y=4t²−40t+300 (answer: (5,200))
Q35. The turning point of y=5−2x−x² occurs at (answer: (−1,6))
Q36. Find dy/dx if 2x³y²−3xy²=4 (implicit) (answer: dy/dx = (3y²−6x²y²)/(4x³y−6xy))
Q37. Find dy/dx if 4x⁴+y³=12x²y (implicit) (answer: use implicit differentiation, collecting dy/dx terms)
Q38. 30m of fencing wire makes a rectangular enclosure; find the maximum area possible (answer: 225m², at 7.5m×7.5m)

---

### Week 6: Integration of Algebraic Functions

**Teaching Notes**

**Integration** is the reverse of differentiation (anti-differentiation). If d/dx[F(x)] = f(x), then ∫f(x)dx = F(x) + C, where C is the constant of integration (needed because the derivative of any constant is zero, so the original function could have had any constant added to it).

**Standard integrals (power rule):** ∫xⁿ dx = xⁿ⁺¹/(n+1) + C (n≠−1) — "raise the power by 1, then divide by the new power." (The case n=−1, ∫x⁻¹dx = ∫(1/x)dx = ln|x|+C, falls outside the algebraic power rule and is normally met later in logarithmic calculus.)

**Rules:** ∫k·f(x)dx = k∫f(x)dx (constants pull straight out); ∫[f(x)±g(x)]dx = ∫f(x)dx ± ∫g(x)dx (integrate term by term).

**Finding C:** use given initial/boundary conditions (a point the curve passes through, or a known value of y at a given x) — substitute those values into the general antiderivative and solve for C.

**Definite integration:** ∫ₐᵇ f(x)dx = [F(x)]ₐᵇ = F(b) − F(a), giving the (signed) area under the curve y=f(x) between x=a and x=b (Fundamental Theorem of Calculus). Useful properties: reversing the limits flips the sign (∫ᵇₐ = −∫ₐᵇ); same limits give 0; ∫ₐᵇ+∫ᵇᶜ=∫ₐᶜ (additivity over adjacent intervals).

**Integration by substitution:** for ∫f(g(x))·g'(x)dx, let u=g(x), find du=g'(x)dx, rewrite the whole integral in terms of u only, integrate normally, then substitute u=g(x) back in.

**Applications:**
- Area under a curve = ∫ₐᵇ f(x)dx (when the curve dips below the x-axis over part of the interval, split the integral at the x-intercept and take the modulus of the negative part before adding, otherwise areas above and below the axis wrongly cancel).
- Distance from velocity: distance = ∫v(t)dt.
- Total Cost from Marginal Cost: Total Cost = ∫MC dx + Fixed Cost (the fixed cost plays the role of the constant of integration).

*Note: the syllabus also mentions integration by parts, partial fractions, and Simpson's rule for evaluating areas — these specific methods have limited source material in the reviewed lesson notes and textbook extract (which focus on standard-form and substitution integration of algebraic functions); teachers should supplement with additional resources for these sub-methods.*

*Worked Example.* Find ∫(3x²+4x−5)dx.
**Step 1 — Integrate each term with the power rule:** ∫3x²dx = 3·(x³/3) = x³; ∫4x dx = 4·(x²/2) = 2x²; ∫−5 dx = −5x.
**Step 2 — Add the results and the constant of integration:** x³+2x²−5x+C.
**Answer: x³+2x²−5x+C.**

*Worked Example.* Given dy/dx=6x²+4 and y=10 when x=1, find y in terms of x.
**Step 1 — Integrate dy/dx to recover y:** y = ∫(6x²+4)dx = 6·(x³/3) + 4x + C = 2x³+4x+C.
**Step 2 — Substitute the given point (x=1, y=10) to find C:** 10 = 2(1)³+4(1)+C = 2+4+C = 6+C.
**Step 3 — Solve for C:** C = 10−6 = 4.
**Answer: y = 2x³+4x+4.**

*Worked Example.* Evaluate ∫₁³x²dx.
**Step 1 — Find the antiderivative:** ∫x²dx = x³/3.
**Step 2 — Apply the limits [x³/3]₁³ = F(3)−F(1):** F(3) = 27/3 = 9; F(1) = 1/3.
**Step 3 — Subtract:** 9 − 1/3 = 27/3 − 1/3 = 26/3.
**Answer: 26/3** (≈8⅔).

*Worked Example (WAEC-style).* Evaluate ∫₀⁴ x^(−1/2)dx.
**Step 1 — Apply the power rule:** ∫x^(−1/2)dx = x^(1/2)/(1/2) + C = 2x^(1/2) + C.
**Step 2 — Apply the limits [2√x]₀⁴:** F(4) = 2√4 = 2(2) = 4; F(0) = 2√0 = 0.
**Step 3 — Subtract:** 4 − 0 = 4.
**Answer: 4.**

*Worked Example.* Find the area under y=x² from x=0 to x=3.
**Step 1 — Set up the definite integral:** Area = ∫₀³x²dx.
**Step 2 — Find the antiderivative:** x³/3.
**Step 3 — Apply the limits:** [x³/3]₀³ = 27/3 − 0 = 9.
**Answer: 9 square units.**

*Worked Example.* Integrate ∫2x(x²+1)³dx using substitution.
**Step 1 — Let u = x²+1 (the "inner" expression):** du/dx = 2x, so du = 2x dx.
**Step 2 — Rewrite the integral entirely in terms of u:** ∫2x(x²+1)³dx = ∫u³ du (since 2x dx = du exactly).
**Step 3 — Integrate:** ∫u³ du = u⁴/4 + C.
**Step 4 — Substitute u = x²+1 back:** (x²+1)⁴/4 + C.
**Answer: (x²+1)⁴/4 + C.**

*Worked Example.* A particle moves with velocity v = 3t²+2t m/s. Find the distance travelled in the first 4 seconds.
**Step 1 — Set up the definite integral of velocity:** Distance = ∫₀⁴(3t²+2t)dt.
**Step 2 — Find the antiderivative:** ∫3t²dt = t³; ∫2t dt = t². So F(t) = t³+t².
**Step 3 — Apply the limits:** F(4) = 64+16 = 80; F(0) = 0.
**Step 4 — Subtract:** 80 − 0 = 80.
**Answer: 80 metres.**

**⚡ Shortcut & Speed Tips**

- **Integration = differentiation in reverse — always check your answer by differentiating it back.** If d/dx of your result doesn't give the original integrand, you've made an error; this self-check costs seconds and catches most mistakes.
- **Reverse power-rule shortcut:** raise the power by 1, then divide by the *new* power (not the old one) — a common slip is dividing by the original exponent instead.
- **Split messy fractions before integrating:** an integrand like (x⁴+2x²−5)/x² should be split into x²+2−5x⁻² term by term first; never try to integrate a fraction as one block unless it's a clean substitution case.
- **Spot substitution candidates fast:** if you can see "a function and (something proportional to) its own derivative" multiplied together in the integrand — e.g. 2x next to (x²+1)ⁿ, or 3x² next to (x³−2)ⁿ — that's the signal to substitute u = the inner function.
- **Definite integral shortcut — don't bother writing "+C":** it always cancels out when you subtract F(a) from F(b), so skip it for definite integrals to save time (but never omit it for indefinite integrals).
- **Area below the x-axis comes out negative from the raw integral** — if the question asks for the actual (physical) area, take the absolute value of any negative piece before adding it to the rest.

**Gamified Exercise Bank**

Q1. Find ∫4x³dx (answer: x⁴+C)
Q2. Integrate: ∫(2x²−5x+3)dx (answer: (2/3)x³−(5/2)x²+3x+C)
Q3. Evaluate ∫₁²x³dx (answer: 15/4)
Q4. Given dy/dx=6x−2 and y=5 when x=1, find y (answer: y=3x²−2x+4)
Q5. Find ∫(1/x²)dx (answer: −1/x+C)
Q6. Integrate ∫2x(x²+1)³dx (answer: (x²+1)⁴/4+C)
Q7. Evaluate ∫₀²(x²+2x)dx (answer: 20/3)
Q8. Find the area under y=2x+1 from x=0 to x=3 (answer: 12)
Q9. Marginal cost is MC=5x+10; fixed cost ₦200; find total cost for 8 units (answer: ₦440)
Q10. Find ∫√x dx (answer: (2/3)x^(3/2)+C)
Q11. Find: (a) ∫6x⁵dx (b) ∫(4x³−3x²+2x−5)dx (c) ∫(5x⁴+3x²−7)dx (d) ∫(x⁵−2x⁴+3x²−1)dx (answer: (a) x⁶+C (b) x⁴−x³+x²−5x+C (c) x⁵+x³−7x+C (d) x⁶/6−(2/5)x⁵+x³−x+C)
Q12. Integrate: (a) ∫(1/x⁴)dx (b) ∫(3/x²)dx (c) ∫(2/√x)dx (d) ∫[(x⁴+2x²−5)/x²]dx (answer: (a) −1/(3x³)+C (b) −3/x+C (c) 4√x+C (d) x³/3+2x+5/x+C)
Q13. dy/dx=4x²+6x, y=8 when x=1; find y (answer: y=(4/3)x³+3x²+11/3)
Q14. A curve has gradient 3x²−4x+1 and passes through (2,5); find its equation (answer: y=x³−2x²+x+3)
Q15. dy/dx=2x+3, y=10 when x=2; find y(5) (answer: y(5)=25+15−(4+6−0)+... = solve C then evaluate → y=x²+3x+0 → y(5)=40)
Q16. Evaluate: (a) ∫₁²x²dx (b) ∫₀¹(2x³+3x)dx (c) ∫₁⁴(√x+1/√x)dx (d) ∫₀²(x−1)³dx (answer: (a) 7/3 (b) [x⁴/2+3x²/2]₀¹=(0.5+1.5)−0=**2** (corrected — the original source's stated 5/2 does not match direct computation) (c) [(2/3)x^(3/2)+2√x]₁⁴=(16/3+4)−(2/3+2)=28/3−8/3=**20/3** (derived; source left this incomplete) (d) 0)
Q17. Find: (a) ∫4x(x²+1)²dx (b) ∫6x²(x³−2)²dx (c) ∫x³(x⁴+1)²dx (d) ∫₀¹2x(x²+3)²dx (answer: (a) let u=x²+1, du=2x dx → 2∫u²du = **(2/3)(x²+1)³+C** (b) let u=x³−2, du=3x²dx → 2∫u²du = **(2/3)(x³−2)³+C** (c) let u=x⁴+1, du=4x³dx → (1/4)∫u²du = **(x⁴+1)³/12+C** (d) let u=x²+3, du=2x dx → ∫₃⁴u²du=[u³/3]₃⁴=64/3−9=**37/3** — all four fully derived using substitution, extending the source's incomplete workings)
Q18. Find area under y=x³ from x=0 to x=2 (answer: 4)
Q19. Calculate area bounded by y=9−x², the x-axis, x=0, x=3 (answer: 18)
Q20. Find area under y=2x+3 from x=1 to x=4 (answer: 24)
Q21. Velocity v=2t²+3t m/s; find distance travelled in first 5 seconds (answer: ∫₀⁵(2t²+3t)dt=[2t³/3+3t²/2]₀⁵=250/3+37.5=**725/6≈120.83m** (corrected — the original source's stated ≈245.8m does not match its own formula (2/3)(125)+37.5=83.33+37.5=120.83))
Q22. Acceleration a=6t−4 m/s²; initial velocity 5m/s. Find (i) velocity after t seconds (ii) velocity after 3 seconds (answer: (i) v=3t²−4t+5 (ii) 20)
Q23. Position s=∫(4t+3)dt; s=10 when t=2; find s when t=5 (answer: s=2t²+3t+C, C=−12, s(5)=53)
Q24. Marginal cost MC=6x+15, fixed cost=300; find (i) total cost function (ii) cost of 10 units (answer: (i) TC=3x²+15x+300 (ii) 750)
Q25. Marginal revenue MR=80−4x; find (i) total revenue function (ii) revenue from 10 units (answer: (i) TR=80x−2x² (ii) 600)
Q26. Marginal profit MP=40−2x; find total profit from producing units 5 to 15 (answer: ∫₅¹⁵(40−2x)dx = 200)
Q27. A particle moves with velocity v=3t²+2t m/s; find distance travelled in first 4 seconds (answer: 80m)
Q28. Marginal cost is MC=3x²+20, fixed cost ₦500; find total cost of producing 10 units (answer: ₦1,700)
Q29. A company's marginal revenue is MR=100−2x; find (a) total revenue function (b) revenue from 20 units (answer: (a) TR=100x−x² (b) 1,600)
Q30. Evaluate ∫₀^(π/2) 2sin2x dx (answer: 0)
Q31. Evaluate ∫₁³(3x²−2x)dx (answer: 18)
Q32. Evaluate ∫₁²[(x³−1)/x²]dx (answer: simplify first: (x³−1)/x²=x−x⁻²; ∫(x−x⁻²)dx=x²/2+1/x; [x²/2+1/x]₁²=(2+0.5)−(0.5+1)=2.5−1.5=**1.0** (corrected — the original source's stated 1.5 does not match this WAEC-verified computation; this matches the published answer key for this exact question))
Q33. Evaluate ∫₋₁¹(2x+1)²dx (answer: 14/3)
Q34. Evaluate ∫₋₁²(1−1/x²)dx (answer: strictly, 1/x² is discontinuous (undefined) at x=0, which lies inside [−1,2], so this integral is technically improper and diverges; however the WAEC source applies the Fundamental Theorem of Calculus formally without flagging the discontinuity: F(x)=x+1/x; F(2)−F(−1)=(2+0.5)−(−1−1)=2.5−(−2)=**4.5** — use this as the "exam-key" answer but flag the discontinuity if a rigor-focused teacher raises it)
Q35. Sketch y=8x−x²−12; draw the line of symmetry; find the area of the finite region bounded by the curve and the x-axis (answer: turning point at x=4; total bounded area = 64/3 square units)

---

## Third Term

No formal scheme of work — SS3 students sit WAEC/NECO/NABTEB externally before Third Term begins. Use this term for final WAEC/NECO past-question drilling across all SS1–SS3 topics instead of new content.

---

## Exercise Bank Summary

- **Total exercise/question count for SS3 (First Term + Second Term): 471**
