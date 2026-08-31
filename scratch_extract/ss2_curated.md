# SS2 Mathematics — Curated Notes & Gamified Exercise Bank

*Sources: SS2 Mathematics Lesson Notes (three terms), and "Hidden Facts in New SSCE Mathematics" by M.A. Otumudia. Structure and week ordering follow the Lagos State SS2 Mathematics syllabus.*

## First Term

### Week 1: Revision of logarithms, reciprocals and accuracy of results using standard calculation

**Teaching Notes**

A logarithm is the power to which a base must be raised to produce a given number: if bˣ = y, then log_b(y) = x. Common logarithms use base 10 (log(x) means log₁₀(x)). Logarithms turn multiplication into addition, division into subtraction, and powers/roots into multiplication/division — which is exactly why they were used (before calculators) to make heavy arithmetic manageable.

Laws of logarithms:
- Product rule: log(M × N) = log M + log N
- Quotient rule: log(M ÷ N) = log M − log N
- Power rule: log(Mⁿ) = n × log M
- Root rule: log(ⁿ√M) = (1/n) × log M
- log(1) = 0, log(10) = 1, log(10ⁿ) = n

A logarithm has two parts: **characteristic** (integer part, from the position of the decimal point) and **mantissa** (decimal part, read from tables). For a number ≥ 1, characteristic = (number of digits before the decimal point) − 1. For a number < 1, characteristic is negative, written in bar notation (e.g. 2̄, meaning "negative 2, positive mantissa"), equal to −(number of zeros immediately after the decimal point + 1). The mantissa is always positive and is the same for numbers with the same sequence of digits (e.g. log 456, log 45.6, log 4.56 all have mantissa 0.6590) — only the characteristic changes as the decimal point moves.

**Worked Examples**

1. **Find log 237.**
   - **Step 1 — Write in standard form:** 237 = 2.37 × 10².
   - **Step 2 — Read off the characteristic:** the power of 10 is 2, so characteristic = 2.
   - **Step 3 — Look up the mantissa:** in the log table, row 23, column 7 gives mantissa 0.3747.
   - **Step 4 — Combine characteristic and mantissa:** 2 + 0.3747 = 2.3747.
   - **Answer: log 237 = 2.3747.**

2. **Calculate 52.3 × 8.94 using logarithms.**
   - **Step 1 — Let N = 52.3 × 8.94 and take logs of both sides:** log N = log 52.3 + log 8.94 (product rule).
   - **Step 2 — Find log 52.3:** 52.3 = 5.23 × 10¹, characteristic 1, mantissa (row 52, col 3) 0.7185, so log 52.3 = 1.7185.
   - **Step 3 — Find log 8.94:** 8.94 = 8.94 × 10⁰, characteristic 0, mantissa (row 89, col 4) 0.9513, so log 8.94 = 0.9513.
   - **Step 4 — Add the two logarithms:** 1.7185 + 0.9513 = 2.6698.
   - **Step 5 — Take the antilog:** antilog 2.6698 → mantissa 0.6698 corresponds to digits 4.675 (from the antilog table); characteristic 2 means shift the decimal 2 places right, giving 467.5.
   - **Answer: 467.5.**

3. **Calculate ⁴√2560 using logarithms.**
   - **Step 1 — Let N = ⁴√2560 and take logs:** log N = (1/4) log 2560 (root rule).
   - **Step 2 — Find log 2560:** 2560 = 2.56 × 10³, characteristic 3, mantissa 0.4082, so log 2560 = 3.4082.
   - **Step 3 — Divide by 4:** 3.4082 ÷ 4 = 0.85205, rounded to 0.8521.
   - **Step 4 — Take the antilog:** antilog 0.8521 → digits 7.113, characteristic 0 means no shift, so N ≈ 7.11.
   - **Answer: 7.11.**

**⚡ Shortcut & Speed Tips**

- **Sanity-check the characteristic before touching tables:** count digits before the decimal point and subtract 1 (e.g. a 5-digit whole number always has characteristic 4). Getting this wrong is the #1 source of lost marks — do it first, separately from the mantissa lookup.
- **Same digits, same mantissa:** if you've already found the mantissa for 456, you instantly know the mantissa for 4.56, 45.6, 45,600, and 0.00456 — only the characteristic changes. Use this to skip repeat table lookups.
- **Estimate first, then compute:** before using tables, do a rough mental estimate (e.g. 52 × 9 ≈ 468) so you can immediately catch a wrongly-placed decimal point in your final antilog answer.
- **For negative characteristics, always keep the mantissa positive:** never "simplify" 2̄.7505 into −2.7505 during table work — only convert to a single negative decimal (−1.2495) at the very end, if the question needs it in that form.
- **Product/quotient/power/root always reduce to addition/subtraction of logs:** write out log N = ... first, do all the addition/subtraction of logs, and only then take one single antilog at the end — don't take antilogs partway through a multi-step calculation.

**Gamified Exercise Bank**

1. Use logarithm tables to find log 237. (answer: 2.3747)
2. Find log 0.0563. (answer: 2̄.7505, i.e. ≈ −1.2495)
3. Use logarithms to calculate 52.3 × 8.94. (answer: 467.5)
4. Evaluate 456 × 34.7 using logarithms. (answer: 15,823.2)
5. Find the value of (2.45)⁵ using logarithm tables. (answer: 88.3, precisely 88.27)
6. Find log 0.00845 using logarithm tables, showing how the characteristic was determined. (answer: 3̄.9269, i.e. ≈ −2.0731 — two zeros after the decimal point give characteristic −3)
7. If log x = 2.3456, find x using antilogarithm tables, in standard form. (answer: ≈ 2.216 × 10²)
8. Use logarithms to evaluate (78.5 × 23.4) ÷ 45.6, showing complete working. (answer: ≈ 40.3, precisely 40.28)
9. Calculate ⁴√2560 using logarithms; verify with a calculator. (answer: 7.11)
10. Simplify (0.456)³ × √89.2 using logarithm tables; compare with the calculator result. (answer: 0.896, precisely 0.8955)
11. Log table treasure hunt: log 345. (answer: 2.5378)
12. Log table treasure hunt: log 0.0678. (answer: 2̄.8312)
13. Log table treasure hunt: log 7890. (answer: 3.8971)
14. Log table treasure hunt: antilog 1.5263. (answer: 33.6)
15. Log table treasure hunt: antilog 3̄.7520. (answer: 0.00565)
16. Compare calculator and log-table results for 45.6 × 23.8. (answer: not given in source)
17. Compare calculator and log-table results for 234 ÷ 5.67. (answer: not given in source)
18. Compare calculator and log-table results for (3.4)³. (answer: not given in source)
19. Calculate compound interest using A = P(1 + r)ⁿ where P = 10,000, r = 0.08, n = 5. (answer: ≈ 14,693.28)

### Week 2: Approximations; calculations using standard form; significant figures; percentage error

**Teaching Notes**

A number in **standard form** (also called scientific notation) is written as A × 10ⁿ, where 1 ≤ A < 10 and n is an integer. To convert a large number, count how many places the decimal point moves left (giving a positive power); for a small number (less than 1), count how many places it moves right (giving a negative power).

**Significant figures** rules: non-zero digits are always significant; zeros between non-zero digits are significant; leading zeros (before the first non-zero digit) are never significant; trailing zeros after a decimal point are significant. Rounding to n significant figures works the same as ordinary rounding, but you count significant digits (not decimal places) — look at the digit immediately after the cut-off point: if it is 5 or more, round the last kept digit up; otherwise leave it unchanged.

**Percentage error** measures how far an approximate (measured/rounded) value is from the exact (actual/true) value:

**% Error = |Approximate − Exact| ÷ Exact × 100%**

The absolute value bars mean the sign (whether the approximation is too high or too low) does not matter — % error is always reported as a positive quantity.

**Worked Examples**

1. **Express 0.000456 in standard form.**
   - **Step 1 — Identify the first non-zero digit:** it is 4, so A will start with 4.56 (keeping the digit sequence).
   - **Step 2 — Count how many places the decimal point must move to sit right after that first digit:** 0.000456 → 4.56 requires moving the point 4 places to the right.
   - **Step 3 — Since the original number is smaller than 1, the power of 10 is negative:** moving right by 4 places means the exponent is −4.
   - **Answer: 0.000456 = 4.56 × 10⁻⁴.**

2. **Round 3.14159 to 4 significant figures.**
   - **Step 1 — Count off the first 4 significant digits:** 3, 1, 4, 1 → "3.141".
   - **Step 2 — Look at the next digit (the 5th significant figure) to decide rounding:** it is 5, so we round the 4th digit up.
   - **Step 3 — Apply the round-up:** 3.141 → 3.142 (the last 1 becomes 2).
   - **Answer: 3.142.**

3. **A measurement of π is taken as 3.14 while the actual value is 3.14159. Find the percentage error.**
   - **Step 1 — Write down the formula:** % Error = |Approximate − Exact| ÷ Exact × 100%.
   - **Step 2 — Substitute the values:** = |3.14 − 3.14159| ÷ 3.14159 × 100%.
   - **Step 3 — Compute the numerator:** |3.14 − 3.14159| = |−0.00159| = 0.00159.
   - **Step 4 — Divide by the exact value:** 0.00159 ÷ 3.14159 = 0.0005061.
   - **Step 5 — Convert to a percentage:** 0.0005061 × 100% = 0.05061%.
   - **Answer: ≈ 0.051%.**

**⚡ Shortcut & Speed Tips**

- **Standard form direction rule:** number ≥ 10 → decimal moves left → positive power; number < 1 → decimal moves right → negative power. Say this rule out loud as a check every time — it prevents the classic sign-flip error.
- **Count the moves, don't recompute:** the exponent in standard form is *exactly* the number of places the decimal point physically moved — no calculation needed, just counting.
- **Trailing-zero trap:** a number like 3,400,000 written as 3.4 × 10⁶ drops "insignificant" trailing zeros — but 3,400,000 stated as "accurate to 5 s.f." would need 3.4000 × 10⁶. Always check whether trailing zeros are meant to be significant before dropping them.
- **Percentage-error quick check:** if the approximate value is very close to the exact one, the % error should be a small number (well under 5% for a "good" estimate). If your answer comes out larger than 10%, re-check your subtraction — it's very rare for a WAEC rounding/measurement question to have a huge error.
- **Use the exact value as the denominator, never the approximate one** — this is the single most common mistake students make in % error questions.

**Gamified Exercise Bank**

1. Express 0.00072 in standard form. (answer: 7.2 × 10⁻⁴)
2. Round 0.0078234 to 3 significant figures. (answer: 0.00782)
3. A measurement is 48.5 kg; the actual mass is 50 kg. Find the % error. (answer: 3%)
4. Express in standard form: (a) 0.00072 (b) 345,000. (answer: (a) 7.2 × 10⁻⁴ (b) 3.45 × 10⁵)
5. Round 0.0078234 to 3 significant figures. (answer: 0.00782)
6. Calculate (4.5 × 10³) × (1.5 × 10⁻²) in standard form. (answer: 6.75 × 10¹)
7. Find the percentage error when π ≈ 3.14 (actual value 3.14159). (answer: ≈ 0.051%)

### Week 3: Sequence and Series — concept of sequence and series; terms of A.P. and their sum; solving problems on A.P.

**Teaching Notes**

A **sequence** is an ordered list of numbers following a rule; a **series** is the sum of the terms of a sequence. An **arithmetic progression (AP)** has a constant difference *d* between consecutive terms: a, a+d, a+2d, … — find d by subtracting any term from the one after it (Tₙ₊₁ − Tₙ).

- nth term: **Tₙ = a + (n − 1)d**
- Sum of first n terms: **Sₙ = n/2 × [2a + (n − 1)d]**, or equivalently **Sₙ = n/2 × (a + l)** where l is the last (nth) term.

**Worked Examples**

1. **Find the 20th term of the AP 7, 11, 15, 19, …**
   - **Step 1 — Identify a and d:** first term a = 7; common difference d = 11 − 7 = 4.
   - **Step 2 — Write the nth-term formula with n = 20:** T₂₀ = a + (20 − 1)d = 7 + 19d.
   - **Step 3 — Substitute d = 4:** T₂₀ = 7 + 19 × 4 = 7 + 76.
   - **Step 4 — Add:** 7 + 76 = 83.
   - **Answer: T₂₀ = 83.**

2. **The 5th term of an AP is 23 and the 12th term is 58. Find a and d.**
   - **Step 1 — Write the nth-term formula for each given term:** T₅ = a + 4d = 23; T₁₂ = a + 11d = 58.
   - **Step 2 — Subtract the first equation from the second to eliminate a:** (a + 11d) − (a + 4d) = 58 − 23 ⟹ 7d = 35.
   - **Step 3 — Solve for d:** d = 35 ÷ 7 = 5.
   - **Step 4 — Substitute d = 5 back into T₅ = a + 4d = 23:** a + 4(5) = 23 ⟹ a + 20 = 23 ⟹ a = 3.
   - **Answer: a = 3, d = 5.**

3. **Find the sum of the first 15 terms of the AP 3, 7, 11, 15, …**
   - **Step 1 — Identify a, d, n:** a = 3, d = 7 − 3 = 4, n = 15.
   - **Step 2 — Write the sum formula:** Sₙ = n/2 × [2a + (n − 1)d].
   - **Step 3 — Substitute:** S₁₅ = 15/2 × [2(3) + 14(4)] = 15/2 × [6 + 56].
   - **Step 4 — Simplify inside the brackets:** 6 + 56 = 62.
   - **Step 5 — Multiply:** 15/2 × 62 = 15 × 31 = 465.
   - **Answer: S₁₅ = 465.**

4. **How many terms of the AP 5, 8, 11, 14, … must be taken for the sum to be at least 345?**
   - **Step 1 — Identify a and d:** a = 5, d = 8 − 5 = 3.
   - **Step 2 — Set the sum formula equal to 345:** n/2 × [2(5) + (n − 1)(3)] = 345.
   - **Step 3 — Simplify inside the brackets:** 10 + 3n − 3 = 3n + 7, so n/2 × (3n + 7) = 345.
   - **Step 4 — Clear the fraction and expand:** n(3n + 7) = 690 ⟹ 3n² + 7n − 690 = 0.
   - **Step 5 — Solve using the quadratic formula:** n = [−7 ± √(7² − 4×3×(−690))] ÷ (2×3) = [−7 ± √8329] ÷ 6 = [−7 ± 91.26] ÷ 6.
   - **Step 6 — Take the positive root:** n = 84.26 ÷ 6 ≈ 14.04. Since 3n² + 7n − 690 = 0 has no exact whole-number root, no exact number of terms gives a sum of *precisely* 345 for this AP — n must be rounded up to the next whole number of terms.
   - **Step 7 — Round up and verify by direct substitution:** the smallest whole n for which the sum reaches or passes 345 is n = 15. Check: S₁₅ = 15/2 × [10 + 14(3)] = 15/2 × 52 = **390** (S₁₄ = 14/2 × [10 + 13(3)] = 7 × 49 = 343, which falls just short of 345).
   - **Answer: 15 terms are needed (giving an actual sum of 390 — the exact value 345 is not reached by any whole number of terms in this AP).** *(This corrects a rounding error in the original source, which presented n ≈ 14.04 as if it solved exactly to n = 15 by an incorrect factorization.)*

5. **A man saves ₦500 in month 1, ₦650 in month 2, ₦800 in month 3, and so on. Find his saving in the 12th month, and his total savings after 12 months.**
   - **Step 1 — Identify a and d:** a = 500, d = 650 − 500 = 150.
   - **Step 2 — Find the 12th-month saving using Tₙ = a + (n−1)d:** T₁₂ = 500 + 11 × 150 = 500 + 1650 = 2150.
   - **Step 3 — Find the total savings using Sₙ = n/2 × [2a + (n−1)d]:** S₁₂ = 12/2 × [2(500) + 11(150)] = 6 × [1000 + 1650].
   - **Step 4 — Simplify inside the brackets:** 1000 + 1650 = 2650.
   - **Step 5 — Multiply:** 6 × 2650 = 15,900.
   - **Answer: 12th-month saving = ₦2,150; total after 12 months = ₦15,900.**

**⚡ Shortcut & Speed Tips**

- **Find d instantly:** subtract any term from the very next one (T₂ − T₁) — you never need two far-apart terms if consecutive terms are given.
- **Use Sₙ = n/2(a + l) whenever the last term is known** — it's faster than expanding 2a + (n−1)d, especially for "sum of a given list" questions.
- **Simultaneous AP equations trick:** whenever you're given two terms (Tₚ and Tᵩ), always subtract the equations to cancel *a* first — never solve for *a* before finding *d*.
- **Pattern-spotting for MCQs:** for "find the next 3 terms" questions, just check whether the difference between consecutive given terms is constant — if yes, it's an AP and you can extend by simply adding d repeatedly, no formula needed.
- **Quick check for word problems modelled as AP:** if a quantity increases (or decreases) by the *same fixed amount* every step (same ₦ amount, same number of seats, etc.), it is an AP — reach for Tₙ and Sₙ immediately rather than listing all terms by hand.

**Gamified Exercise Bank**

1. Identify the pattern and find the next 3 terms of 4, 9, 14, 19, 24, ?, ?, ? (answer: 29, 34, 39)
2. Identify the pattern and find the next 3 terms of 100, 95, 90, 85, ?, ?, ? (answer: 80, 75, 70)
3. Identify the pattern and find the next 3 terms of 2, 6, 10, 14, ?, ?, ? (answer: 18, 22, 26)
4. Identify the pattern and find the next 3 terms of 50, 47, 44, 41, ?, ?, ? (answer: 38, 35, 32)
5. Find the common difference of the AP: 12, 17, 22, 27, ... (answer: 5)
6. Calculate the 25th term of the AP: 4, 9, 14, 19, ... (answer: 124)
7. The 3rd term of an AP is 18 and the 7th term is 34. Find the first term. (answer: a = 10, d = 4 — corrected from an earlier miscalculation: T₇−T₃=4d=16 gives d=4, then a=T₃−2d=18−8=10)
8. Find the sum of the first 20 terms of the AP: 2, 5, 8, 11, ... (answer: 610)
9. How many terms of the AP 8, 12, 16, 20, ... will give a sum of 240? (answer: no whole number of terms gives exactly 240 — solving 2n²+6n−240=0 gives n≈9.56; S₉=216 and S₁₀=260, so 240 falls strictly between consecutive sums and is never reached exactly; corrected from an earlier "n=10", which actually sums to 260)
10. Write the first five terms of an AP whose first term is 7 and common difference is −3. (answer: 7, 4, 1, −2, −5)
11. Find the 30th term of the AP: −5, −1, 3, 7, ... (answer: 111)
12. The sum of the first 8 terms of an AP is 156, and the first term is 6. Calculate the common difference. (answer: d = 27/7 ≈ 3.857 — corrected: 4(12+7d)=156 gives 7d=27, not the previously stated d=3, which would only give a sum of 132)
13. An AP has first term 10 and last term 82. If the sum of all terms is 460, find the number of terms. (answer: n = 10)
14. A theatre has 20 seats in row 1, 24 in row 2, 28 in row 3, and so on for 15 rows. Find the total number of seats. (answer: 720)
15. Find the 20th term of the AP: 7, 11, 15, 19, ... (answer: 83)
16. The 5th term of an AP is 23 and the 12th term is 58. Find the first term and common difference. (answer: a = 3, d = 5)
17. Find the sum of the first 15 terms of the AP: 3, 7, 11, 15, ... (answer: 465)
18. How many terms of the AP 5, 8, 11, 14, ... must be taken so their sum is 345? (answer: no exact whole n gives 345 — the smallest n whose sum reaches or passes 345 is n=15, giving an actual sum of 390; S₁₄=343 falls just short)
19. A man saves ₦500 in month 1, ₦650 in month 2, ₦800 in month 3, and so on. Find his saving in the 12th month and his total savings after 12 months. (answer: ₦2,150; ₦15,900)
20. The sum of the first n terms of the AP 5, 11, 17, 23, 29, 35, ... is: A n(3n − 0.5) B n(3n + 2) C n(3n + 2.5) D n(3n + 5) (answer: n(3n + 2), option B — a=5, d=6, Sₙ=n/2[10+6(n−1)]=n/2(6n+4)=n(3n+2))
21. The sum of the first n positive integers is: A ½n(n − 1) B n(n + 1) C ½n(n + 1) D ½n(n − 1) (answer: ½n(n + 1))
22. If Uₙ = n(n² + 1), evaluate U₅ − U₄. A 18 B 56 C 62 D 80 (answer: 130 − 68 = 62, option C)
23. A sequence is given by 2½, 5, 7½, ... If the nth term is 25, find n. A 9 B 10 C 12 D 15 (answer: n = 10, option B)
24. What is the 13th term of the series −4 + 1 + 6 + 11 + ...? A 51 B 56 C 61 D 66 (answer: 56, option B)
25. The nth term of a sequence is Tₙ = 5 + (n − 1)2. Evaluate T₄ − T₆. A 30 B 16 C −16 D −30 (answer: −16, option C)

### Week 4: Geometric Progressions — the nth term and sum of the first n terms; problem solving on G.P. and geometric mean

**Teaching Notes**

A **geometric progression (GP)** has a constant ratio *r* between consecutive terms: a, ar, ar², … — find r by dividing any term by the one before it (Tₙ₊₁ ÷ Tₙ).

- nth term: **Tₙ = arⁿ⁻¹**
- Sum of first n terms (r ≠ 1): **Sₙ = a(1 − rⁿ)/(1 − r)** when r < 1, or **Sₙ = a(rⁿ − 1)/(r − 1)** when r > 1.
- Sum to infinity (only valid when −1 < r < 1): **S∞ = a/(1 − r)**
- Geometric mean of two numbers p and q is √(pq).

**Worked Examples**

1. **Find the 7th term of the GP 4, 12, 36, …**
   - **Step 1 — Identify a and r:** a = 4; r = 12 ÷ 4 = 3.
   - **Step 2 — Write the nth-term formula with n = 7:** T₇ = a × r⁶ = 4 × 3⁶.
   - **Step 3 — Evaluate 3⁶:** 3⁶ = 3×3×3×3×3×3 = 729.
   - **Step 4 — Multiply:** 4 × 729 = 2916.
   - **Answer: T₇ = 2916.**

2. **If y+2, y+6, y+14 are consecutive terms of a GP, find y and the 42nd term in index form.**
   - **Step 1 — Use the GP property that (middle term)² = (first term)(third term):** (y+6)² = (y+2)(y+14).
   - **Step 2 — Expand both sides:** LHS = y² + 12y + 36; RHS = y² + 16y + 28.
   - **Step 3 — Set equal and simplify:** y² + 12y + 36 = y² + 16y + 28 ⟹ 36 − 28 = 16y − 12y ⟹ 8 = 4y.
   - **Step 4 — Solve for y:** y = 2.
   - **Step 5 — Substitute back to find the GP:** terms are (2+2), (2+6), (2+14) = 4, 8, 16, so a = 4, r = 8÷4 = 2.
   - **Step 6 — Find T₄₂ = a × r⁴¹:** T₄₂ = 4 × 2⁴¹ = 2² × 2⁴¹ (writing 4 as 2² so the powers of 2 combine).
   - **Step 7 — Add the exponents (law of indices, aᵐ×aⁿ=aᵐ⁺ⁿ):** 2² × 2⁴¹ = 2⁴³.
   - **Answer: y = 2; T₄₂ = 2⁴³.**

3. **Find the sum to infinity of the GP 4, 2, 1, …**
   - **Step 1 — Identify a and r:** a = 4; r = 2 ÷ 4 = ½ (and since −1 < ½ < 1, the sum to infinity exists).
   - **Step 2 — Write the sum-to-infinity formula:** S∞ = a ÷ (1 − r).
   - **Step 3 — Substitute:** S∞ = 4 ÷ (1 − ½) = 4 ÷ ½.
   - **Step 4 — Divide:** 4 ÷ ½ = 8.
   - **Answer: S∞ = 8.**

4. **Find the sum of the first 4 terms of a GP with a = 5, r = ½.**
   - **Step 1 — Write the sum formula for r < 1:** Sₙ = a(1 − rⁿ) ÷ (1 − r).
   - **Step 2 — Substitute n = 4:** S₄ = 5(1 − (½)⁴) ÷ (1 − ½).
   - **Step 3 — Evaluate (½)⁴:** (½)⁴ = 1/16.
   - **Step 4 — Simplify the bracket:** 1 − 1/16 = 15/16.
   - **Step 5 — Substitute and simplify the denominator:** S₄ = 5 × (15/16) ÷ (1/2) = 5 × (15/16) × 2.
   - **Step 6 — Multiply:** 5 × 15 × 2 ÷ 16 = 150/16 = 75/8.
   - **Answer: S₄ = 75/8 (= 9⅜).**

**⚡ Shortcut & Speed Tips**

- **Find r instantly:** divide the 2nd term by the 1st (T₂ ÷ T₁) — never derive it from a longer calculation if consecutive terms are given directly.
- **"Middle² = outer product" test for 3-term GPs:** whenever three terms x, y, z are said to be "in GP" (or "consecutive terms of a GP"), the fastest route is always y² = xz — cross-multiply immediately instead of writing separate ratio equations.
- **Combine powers of the same base fast:** when a GP's first term and ratio are both powers of the same number (e.g. a = 4 = 2², r = 2), rewrite everything in that base — Tₙ = 2^(something) — and just add exponents, avoiding huge numeric multiplication.
- **Sum-to-infinity existence check:** before applying S∞ = a/(1−r), always confirm −1 < r < 1 first. If |r| ≥ 1, the series diverges and S∞ simply does not exist — a common trap in WAEC objectives.
- **Choose the right sum formula by comparing r to 1:** use a(1−rⁿ)/(1−r) when r < 1 (keeps the numerator and denominator both positive, avoiding sign slips) and a(rⁿ−1)/(r−1) when r > 1 — they're mathematically identical, but picking the version matching r's size avoids double negative-sign errors.

**Gamified Exercise Bank**

1. Find the 7th term of the geometric progression 4, 12, 36, ... A 365 B 729 C 1458 D 2916 E 4374 (answer: 2916, option D)
2. The first term of a GP is 6 and its common ratio is 3. Find the sixth term. A 1⁸5 B 3×9⁵ C 3×6⁵ D 6×3⁵ (answer: 6×3⁵, option D)
3. If y+2, y+6, y+14 are consecutive terms of a GP, find (i) the value of y and the GP (ii) the 42nd term in index form. (answer: y = 2, GP 4,8,16,...; T₄₂ = 2⁴³)
4. The first and third terms of a GP are 1 and 9. Find the second term. A 4 B 3 C 2 D 1/3 (answer: 3, option B)
5. The first, second and last terms of a GP are 3, 6 and 1536. Find the number of terms. A 8 B 9 C 10 D 12 E 14 (answer: 10, option C — since a=3, r=2, and 3×2ⁿ⁻¹=1536 gives 2ⁿ⁻¹=512=2⁹, so n=10)
6. Find the 12th term of the GP −3, 6, −12, ... A −12288 B −6144 C −2048 D 2048 E 6144 (answer: 6144, option E — a=−3, r=−2, T₁₂=−3×(−2)¹¹=−3×(−2048)=6144)
7. The 6th term of a GP is 1215. If the common ratio is 3, find its 3rd term. (answer: T₃ = 45, since T₆ = T₃×r³ ⇒ 1215 = T₃×27)
8. Given 6, 3√2, 3√6, 9√2, ... are the first four terms of a GP, find the 8th term in simplest form. A 27√2 B 27√6 C 81√2 D 81√6 (answer: 81√6, option D — note: the ratio between the 2nd and 3rd printed terms and between the 3rd and 4th is a consistent √3, so treating a = 3√2 and r = √3, T₈ = 3√2 × (√3)⁷ = 3√2 × 27√3 = 81√6, matching option D; the leading "6" in the source list appears to be an OCR/transcription artifact)
9. What is the common ratio of the GP 10 + 5√... type series? A √3 B √5 C 2 D 5 (answer: not confirmed in source — the source text for this question is garbled/incomplete and the ratio cannot be reliably reconstructed)
10. The 2nd and 4th terms of a GP are 10 and 40. Find (i) common ratio (ii) first term (iii) 8th term. (answer: r = 2, a = 5, T₈ = 640)
11. The 4th term of a GP is 384 and the 3rd term is 96. Find the first term. A 2 B 4 C 6 D 24 E 288 (answer: 6, option C)
12. The fifth term of a GP is 8 times the 2nd term. Find its common ratio. A −4 B −2 C 1/2 D 2 E 4 (answer: 2, option D)
13. The fourth term of a geometric sequence is 2 and the sixth term is 8. Find the common ratio. A 1 B 2 C 3 D 4 (answer: r = ±2)
14. The fourth term of an exponential sequence is 192 and its ninth term is 6. Find the common ratio. A 1/3 B 1/2 C 2 D 3 (answer: 1/2, option B)
15. The 5th term of a GP is 9 times the 3rd term. What is the positive value of the common ratio? A 5 B 4 C 3 D 2 (answer: 3, option C)
16. The third term of a GP is 24 and its seventh term is 4 20/27. Find its first term. (answer: a = 54)
17. In a geometric series a = 2 and r = 1/2, find the sum of the first 5 terms. A 1/8 B 3¾ C 3⅞ D 4 (answer: 3⅞, option C)
18. 10/3, 5/3, 5/6, ... is a GP. Find (i) the 8th term (ii) the sum of the first 10 terms. (answer: T₈ = 5/192; S₁₀ = 1705/256)
19. The sum of the second and third terms of a GP is six times the fourth term. Find the two possible values of the common ratio; if the second term is 8 and r is positive, find the first six terms. (answer: r = 1/2 or −1/3; terms 16, 8, 4, 2, 1, 1/2)
20. In a GP, the 5th term exceeds the 4th term by 24 and the 4th term exceeds the 3rd by 8. Find (i) common ratio (ii) first term (iii) sum of the first 5 terms. (answer: r = 3, a = 4/9, S₅ = 484/9 — from ar³(r−1)=24 and ar²(r−1)=8, dividing gives r=3; substituting back, 9a(2)=8 gives a=4/9, not the previously stated a=2/3)
21. The 5th term of a GP is 2/81. If the first term is 2, find (i) common ratio (ii) sum of the first five terms. (answer: r = ±1/3 — from ar⁴=2/81 with a=2, r⁴=1/81=(1/3)⁴; taking r=1/3, S₅=242/81; taking r=−1/3, S₅=122/81)
22. The sum of the first 3 terms of a GP is 40 while the 4th and 6th terms are in ratio 1:4. Find (i) common ratio (ii) fifth term. (answer: r = ±2 — from T₄:T₆=1:r²=1:4 gives r²=4; if r=2, a(1+2+4)=40 gives a=40/7 and T₅=ar⁴=640/7; if r=−2, a(1−2+4)=40 gives a=40/3 and T₅=ar⁴=640/3)
23. Find the sum of the first three terms of the GP whose third term is 27 and whose 6th term is 8. (answer: a = 243/4, r = 2/3, S₃ = 1281/4)
24. Find the sum to infinity of the GP 4, 2, 1, ... (answer: 8)
25. The sum to infinity of a GP is 80. If the first term is 20, find the second term. A 15 B 11¼ C 5 D 1¼ E − (answer: 15, option A)
26. Find the sum to infinity of the series 2 + 3/2 + 9/8 + 27/32 + ... A 1 B 2 C 8 D 4 (answer: 8, option C)
27. Find the sum of the exponential series 96 + 24 + 6 + ... A 144 B 128 C 72 D 64 (answer: 128, option B)
28. Find the sum to infinity of the sequence 1, 9/10, (9/10)², (9/10)³, ... A 10 B 9 C 10/9 D 9/10 (answer: 10, option A)
29. The sum to infinity of a GP is −1/10 and the first term is −1/8. Find the common ratio. A −1/5 B −1/4 C −1/3 D −1/2 (answer: −1/4, option B — from S∞=a/(1−r): −1/10=(−1/8)/(1−r) gives 1−r=5/4, so r=−1/4)
30. The nth term of the sequence −2, 4, −8, 16, ... is given by A Tₙ = 2ⁿ B Tₙ = (−2)ⁿ C Tₙ = (−2n) D Tₙ = n² (answer: (−2)ⁿ, option B)

### Week 5: Construction of a quadratic equation from the sum and product of roots; word problems leading to quadratic equations

**Teaching Notes**

For a quadratic equation ax² + bx + c = 0 with roots α and β:
- **Sum of roots: α + β = −b/a**
- **Product of roots: αβ = c/a**
- An equation can be built from these: **x² − (sum)x + (product) = 0**, or from factors: (x − α)(x − β) = 0.

Special root relationships: if one root is k times the other, let roots be α and kα; if roots differ by a constant d, let roots be α and α + d; if roots are reciprocals, αβ = 1; useful identities: α² + β² = (α+β)² − 2αβ, and (α−β)² = (α+β)² − 4αβ.

For **word problems**, define a variable, translate the condition into an equation, solve (usually by factorization or the quadratic formula), and reject any solution that is not physically sensible (e.g. negative length, negative age, or a fraction of a person).

**Worked Examples**

1. **Form a quadratic equation with roots 3 and −2.**
   - **Step 1 — Find the sum of the roots:** α + β = 3 + (−2) = 1.
   - **Step 2 — Find the product of the roots:** αβ = 3 × (−2) = −6.
   - **Step 3 — Substitute into x² − (sum)x + (product) = 0:** x² − (1)x + (−6) = 0.
   - **Answer: x² − x − 6 = 0.**

2. **The sum of roots of a quadratic equation is 5 and the product is 6. Find the equation and its roots.**
   - **Step 1 — Build the equation from x² − (sum)x + (product) = 0:** x² − 5x + 6 = 0.
   - **Step 2 — Factorize: find two numbers that multiply to 6 and add to −5:** −2 and −3 (since (−2)×(−3)=6 and (−2)+(−3)=−5).
   - **Step 3 — Write the factorized form:** (x − 2)(x − 3) = 0.
   - **Step 4 — Set each factor to zero and solve:** x − 2 = 0 ⟹ x = 2; x − 3 = 0 ⟹ x = 3.
   - **Answer: equation x² − 5x + 6 = 0; roots x = 2 or x = 3.**

3. **The roots of x² − px + 12 = 0 are in ratio 3:4. Find p and the roots.**
   - **Step 1 — Represent the roots using the ratio:** let the roots be 3k and 4k.
   - **Step 2 — Use the product of roots (= c/a = 12):** (3k)(4k) = 12 ⟹ 12k² = 12.
   - **Step 3 — Solve for k:** k² = 1 ⟹ k = ±1.
   - **Step 4 — Case k = 1:** roots are 3(1)=3 and 4(1)=4; sum = 7, so p = 7 (since sum of roots = p here, as the equation is x²−px+12).
   - **Step 5 — Case k = −1:** roots are −3 and −4; sum = −7, so p = −7.
   - **Answer: p = 7 with roots 3, 4; or p = −7 with roots −3, −4.**

4. **A rectangle has length 3 cm more than its width, and area 40 cm². Find the dimensions.**
   - **Step 1 — Define a variable:** let width = w cm, so length = (w + 3) cm.
   - **Step 2 — Write the area equation:** w(w + 3) = 40.
   - **Step 3 — Expand and rearrange into standard form:** w² + 3w − 40 = 0.
   - **Step 4 — Factorize: find two numbers that multiply to −40 and add to 3:** 8 and −5 (8×(−5)=−40, 8+(−5)=3).
   - **Step 5 — Write the factorized form and solve:** (w + 8)(w − 5) = 0 ⟹ w = −8 or w = 5.
   - **Step 6 — Reject the physically impossible solution:** width cannot be negative, so w = −8 is rejected.
   - **Step 7 — Find the length:** length = w + 3 = 5 + 3 = 8.
   - **Answer: width = 5 cm, length = 8 cm.**

**⚡ Shortcut & Speed Tips**

- **Build-the-equation shortcut:** for "form the equation from these roots" questions, skip expanding (x−α)(x−β) by hand — just plug sum and product straight into x² − (sum)x + (product) = 0.
- **Ratio-of-roots trick:** whenever roots are given "in the ratio m:n", always represent them as mk and nk (one single unknown k) rather than two separate unknowns — this turns the product-of-roots equation into a simple k² equation.
- **Equal-roots shortcut:** "equal roots" always means discriminant b² − 4ac = 0 — set that up directly instead of trying to factorize; it's usually the fastest path to the unknown coefficient.
- **Word-problem reflex:** the moment you see "3 more than", "5 cm longer", or "product of two numbers", define one unknown, write the second quantity in terms of it, and go straight to a product/area/sum equation — don't introduce two separate unknowns unless the problem truly needs simultaneous equations.
- **Always sanity-check word-problem roots against reality:** after solving, throw away any root that gives a negative length, negative age, or non-whole number of people — WAEC problems almost always have exactly one sensible root remaining.

**Gamified Exercise Bank**

1. Form a quadratic equation with roots 4 and −1. (answer: x² − 3x − 4 = 0)
2. Form a quadratic equation with roots 3 and −2. (answer: x² − x − 6 = 0)
3. The sum of roots of a quadratic equation is 5 and their product is 6. Find the equation and its roots. (answer: x² − 5x + 6 = 0; x = 2 or 3)
4. Form quadratic equations with roots: (a) 5 and 2 (b) −3 and 4 (c) 1/2 and 3. (answer: (a) x² − 7x + 10 = 0 (b) x² − x − 12 = 0 (c) 2x² − 7x + 3 = 0)
5. The roots of x² − px + 12 = 0 are in ratio 3:4. Find p and the roots. (answer: p = 7, roots 3,4; or p = −7, roots −3,−4)
6. The roots of x² − px + 15 = 0 are in ratio 2:3. Find (a) p (b) the roots. (answer: p = ±5√10/2 ≈ ±7.906 — letting roots be 2k, 3k: 6k²=15 gives k²=5/2, so k=±√2.5; roots are 2k, 3k and p = 5k = ±5√2.5 = ±(5√10)/2; the roots are irrational here since 15 does not split into a rational 2:3 pair)
7. If one root of x² + px + 8 = 0 is 4, find p and the other root. (answer: p = −6, other root 2)
8. If one root of 3x² + kx − 2 = 0 is 2, find (a) k (b) the other root. (answer: k = −5, other root −1/3)
9. One root of 2x² + kx − 6 = 0 is 2. Find k and the other root. (answer: k = −1, other root −3/2)
10. The roots of 2x² − 7x + k = 0 are equal. Find k. (answer: k = 49/8)
11. x² + kx + 9 = 0 has equal roots. Find k. (answer: k = ±6)
12. kx² − 6x + 2 = 0 has one root as 2. Find k. (answer: k = 5/2)
13. 2x² + 5x + k = 0 has product of roots as 3. Find k. (answer: k = 6)
14. The square of a number exceeds the number by 12. Find the number. (answer: 4 or −3)
15. Two numbers differ by 3 and their product is 70. Find them. (answer: 7 and 10, or −10 and −7)
16. The sum of two numbers is 12 and their product is 35. Find the numbers. (answer: 5 and 7)
17. A rectangle has length 3 cm more than its width and area 40 cm². Find the dimensions. (answer: width 5 cm, length 8 cm)
18. A rectangle has length 5 cm more than its width. If the area is 84 cm², find the dimensions. (answer: width 7 cm, length 12 cm)
19. The base of a triangle is 4 cm longer than its height. If the area is 30 cm², find the base and height. (answer: height 6 cm, base 10 cm)
20. The perimeter of a rectangle is 26 cm and its area is 40 cm². Find its dimensions. (answer: 8 cm by 5 cm)
21. A car travels 180 km. If the speed was 15 km/h faster, the journey would take 1 hour less. Find the original speed. (answer: 45 km/h)
22. A man is 24 years older than his son. In 4 years, the product of their ages will be 360. Find their present ages. (answer: son ≈ 6.45 years, man ≈ 30.45 years — letting son's present age = x: (x+4)(x+28)=360 gives x²+32x−248=0, so x = −16+6√14 ≈ 6.45 (the negative root is rejected); these ages are not whole numbers, which is unusual for a WAEC-style problem but is what the given figures produce)
23. The product of two consecutive positive integers is 132. Find the integers. (answer: 11 and 12)
24. The sum of a number and its reciprocal is 13/6. Find the number. (answer: x = 2/3 or 3/2)
25. Show that 2x² − 5x + 4 = 0 has no real roots. State the nature of its roots. (answer: discriminant = −7 < 0; complex conjugate roots)
26. Without solving, determine the nature of roots: x² − 4x + 4 = 0. (answer: Δ = 0, equal roots)
27. Without solving, determine the nature of roots: 2x² + 3x − 5 = 0. (answer: Δ = 49 > 0, two real roots)
28. Without solving, determine the nature of roots: x² + x + 1 = 0. (answer: Δ = −3 < 0, no real roots)
29. Determine the nature of roots of 3x² − 5x + 4 = 0 without solving. (answer: Δ = −23 < 0, no real roots)
30. Without solving, determine the nature of roots of 3x² + 7x + 5 = 0. (answer: Δ = −11 < 0, no real roots)

### Week 6: Review of half term work and periodic test

**Teaching Notes**

This is a consolidation week. No new content is introduced; students revisit Weeks 1–5 (logarithms, standard form/approximation, A.P., G.P., forming quadratics from roots) and sit a periodic test. *(limited source material for this sub-topic — it is a revision/assessment week by design.)*

**Revision checklist (with the exact procedure to run through for each topic):**
- **Logarithms (Week 1):** for any calculation, write log N = ... first, apply the product/quotient/power/root rule to reduce it to sums/differences of individual logs, look up each mantissa, combine, then take one final antilog.
- **Standard form / significant figures / % error (Week 2):** always state the exact-value denominator before dividing in a % error question; count significant figures, not decimal places, when rounding.
- **A.P. (Week 3):** find d first (T₂−T₁), then apply Tₙ = a+(n−1)d or Sₙ = n/2[2a+(n−1)d] directly — don't list out terms by hand for large n.
- **G.P. (Week 4):** find r first (T₂÷T₁), check |r| < 1 before ever using S∞, and match the sum formula (a(1−rⁿ)/(1−r) vs a(rⁿ−1)/(r−1)) to whether r is below or above 1.
- **Quadratics from roots (Week 5):** go straight to x² − (sum)x + (product) = 0; for ratio-of-roots questions use a single unknown k.

**⚡ Shortcut & Speed Tips**

- **Timed self-test strategy:** attempt one full past-question set from each of Weeks 1–5 under time pressure (roughly 3–4 minutes per question) before the periodic test — this mimics real exam conditions better than untimed review.
- **Formula-sheet recall drill:** before opening any past questions, write out from memory every boxed formula from Weeks 1–5 (log laws, Tₙ, Sₙ for AP and GP, S∞, sum/product of roots) — gaps in this recall point straight to what needs re-study.
- **Error-log review:** revisit any exercise-bank question you got wrong earlier in the term and redo it from scratch without looking at the worked solution — repeated mistakes on the same topic are the strongest predictor of periodic-test performance.
- **Mixed-topic drilling beats single-topic drilling:** since the periodic test samples across all five weeks, spend the final revision session on a shuffled mixed quiz (not five separate single-topic blocks) to build the topic-recognition skill the real test demands.

**Gamified Exercise Bank**

*(No new exercises — use a mixed review quiz drawn from Weeks 1–5 above.)*

### Week 7: Simultaneous Equations — solving by elimination and substitution methods; word problems leading to simultaneous equations

**Teaching Notes**

**Simultaneous equations** are two (or more) equations sharing common unknowns, solved together.

- **Elimination method:** make the coefficients of one variable equal (by multiplying), then add or subtract the equations to eliminate that variable.
- **Substitution method:** make one variable the subject of one equation, then substitute it into the other equation.

**Worked Examples**

1. **Solve by elimination: 3x + 4y = 25 … (i), 2x − 3y = −6 … (ii).**
   - **Step 1 — Choose a variable to eliminate (x) and find a common multiple of its coefficients:** coefficients are 3 and 2; LCM = 6.
   - **Step 2 — Multiply equation (i) by 2:** 6x + 8y = 50 … (iii).
   - **Step 3 — Multiply equation (ii) by 3:** 6x − 9y = −18 … (iv).
   - **Step 4 — Subtract (iv) from (iii) to eliminate x:** (6x + 8y) − (6x − 9y) = 50 − (−18) ⟹ 17y = 68.
   - **Step 5 — Solve for y:** y = 68 ÷ 17 = 4.
   - **Step 6 — Substitute y = 4 back into equation (i) to find x:** 3x + 4(4) = 25 ⟹ 3x + 16 = 25 ⟹ 3x = 9 ⟹ x = 3.
   - **Step 7 — Check in equation (ii):** 2(3) − 3(4) = 6 − 12 = −6 ✓.
   - **Answer: (x, y) = (3, 4).**

2. **Solve by substitution: y = 3x − 5 … (i), 2x + 3y = 4 … (ii).**
   - **Step 1 — Since (i) already gives y in terms of x, substitute it into (ii):** 2x + 3(3x − 5) = 4.
   - **Step 2 — Expand the bracket:** 2x + 9x − 15 = 4.
   - **Step 3 — Collect like terms:** 11x − 15 = 4.
   - **Step 4 — Solve for x:** 11x = 19 ⟹ x = 19/11.
   - **Step 5 — Substitute x = 19/11 back into (i) to find y:** y = 3(19/11) − 5 = 57/11 − 55/11 = 2/11.
   - **Answer: x = 19/11, y = 2/11.**

3. **Three books and two pens cost ₦350. Five books and three pens cost ₦550. Find the cost of each.**
   - **Step 1 — Define variables:** let one book cost x naira, one pen cost y naira.
   - **Step 2 — Translate the two statements into equations:** 3x + 2y = 350 … (i); 5x + 3y = 550 … (ii).
   - **Step 3 — Eliminate y: find the LCM of 2 and 3 (which is 6), then multiply (i) by 3 and (ii) by 2:** 9x + 6y = 1050 … (iii); 10x + 6y = 1100 … (iv).
   - **Step 4 — Subtract (iii) from (iv):** (10x + 6y) − (9x + 6y) = 1100 − 1050 ⟹ x = 50.
   - **Step 5 — Substitute x = 50 into (i) to find y:** 3(50) + 2y = 350 ⟹ 150 + 2y = 350 ⟹ 2y = 200 ⟹ y = 100.
   - **Step 6 — Check in equation (ii):** 5(50) + 3(100) = 250 + 300 = 550 ✓.
   - **Answer: one book = ₦50, one pen = ₦100.**

**⚡ Shortcut & Speed Tips**

- **Pick the method that needs the least algebra:** if one equation already has a variable alone on one side (like y = 3x − 5), use substitution immediately — don't force elimination. If both equations are in the standard Ax+By=C form, use elimination.
- **Multiply by the smallest possible numbers:** to make coefficients match, always multiply by the *other* equation's coefficient of that variable (cross-multiplying the two coefficients), which is guaranteed to work and is usually smaller than finding a full LCM by trial.
- **Always substitute back into the simpler original equation**, not the more complicated one — it reduces arithmetic errors when finding the second unknown.
- **Verify both values in the *other* original equation** (not the one you used to find them) — a quick correct/incorrect check before moving on, this catches almost every sign or arithmetic slip.
- **Word-problem setup shortcut:** the two numeric "costs" in the problem (e.g. ₦350 and ₦550) go directly on the right-hand side of the two equations, and the item quantities become the left-hand coefficients — write both equations in one pass straight from the sentence, without an intermediate table.

**Gamified Exercise Bank**

1. Solve: 2x + 3y = 13, 2x − y = 5 (by elimination). (answer: x = 3.5, y = 2)
2. Solve: 3x + 2y = 16, 2x + 5y = 21 (by elimination). (answer: x = 38/11, y = 31/11)
3. Solve: y = 2x − 1, 3x + 2y = 12 (by substitution). (answer: x = 2, y = 3)
4. Solve: 2x + y = 7, 3x − 2y = 4 (by substitution). (answer: x = 18/7, y = 13/7)
5. Solve by elimination: 3x + 4y = 25, 2x − 3y = −6. (answer: x = 3, y = 4)
6. Solve by substitution: y = 3x − 5, 2x + 3y = 4. (answer: x = 19/11, y = 2/11)
7. At a fruit stall, 5 oranges and 3 apples cost ₦200; 7 oranges and 5 apples cost ₦310. Find the cost of each fruit. (answer: orange ₦17.50, apple ₦37.50)
8. At a shop, 3 pens and 2 books cost ₦450; 5 pens and 4 books cost ₦830. Find the cost of one pen and one book. (answer: pen ₦70, book ₦120)
9. A man is 3 times as old as his son. In 12 years, he will be twice as old as his son. Find their present ages. (answer: son 12, man 36)
10. Solve: x + y = 10, x − y = 2 (using both elimination and substitution). (answer: x = 6, y = 4)
11. Solve by elimination: 2x + 3y = 12, 3x − 2y = 5. (answer: x = 3, y = 2)
12. Solve by substitution: y = 2x − 1, 3x + y = 14. (answer: x = 3, y = 5)
13. Three books and two pens cost ₦350. Five books and three pens cost ₦550. Find the cost of each. (answer: book ₦50, pen ₦100)
14. The sum of two numbers is 50. If the larger number is 10 more than the smaller, find both numbers. (answer: 20 and 30)
15. The sum of two numbers is 25 and their difference is 7. Find the numbers. (answer: 16 and 9)
16. Solve by elimination: (a) 3x + 2y = 16, 5x − 3y = 2 (b) 4x + 5y = 23, 3x + 4y = 18. (answer: (a) x = 52/19, y = 74/19 — corrected: the previously stated x=4, y=2 does not satisfy 5x−3y=2 (b) x = 2, y = 3)
17. Solve by substitution: (a) x = 3y − 2, 2x + y = 11 (b) y = 2x + 1, 3x − 4y = −13. (answer: (a) x = 31/7, y = 15/7 — corrected: the previously stated x=4, y=2 does not satisfy 2x+y=11 (b) x = 9/5, y = 23/5 — corrected: the previously stated x=3, y=7 does not satisfy 3x−4y=−13)
18. At a restaurant, 4 meals and 3 drinks cost ₦2,400. 6 meals and 5 drinks cost ₦3,700. Find the cost of one meal and one drink. (answer: meal ₦450, drink ₦200)
19. The perimeter of a rectangle is 40 cm. The length is 4 cm more than the width. Find the dimensions. (answer: length 12 cm, width 8 cm)

### Week 8: Simultaneous equations involving one linear and one quadratic equation; using graphical methods to solve quadratic equations

**Teaching Notes**

When one equation is linear (y = mx + c) and the other quadratic (y = ax² + bx + c), substitute the linear expression for y into the quadratic, giving a single quadratic in x. This can have **0, 1, or 2 solutions**, corresponding to the line missing, touching (tangent), or crossing the parabola twice.

To solve a quadratic **graphically**: plot y = ax² + bx + c using a table of values, drawing a smooth curve; the roots of ax² + bx + c = 0 are the x-intercepts (where the curve crosses the x-axis). The vertex (turning point) has x-coordinate −b/(2a).

**Worked Examples**

1. **Solve simultaneously: y = x + 2, y = x² − 4x + 6.**
   - **Step 1 — Since both expressions equal y, set them equal to each other:** x + 2 = x² − 4x + 6.
   - **Step 2 — Rearrange everything to one side (standard quadratic form):** 0 = x² − 4x + 6 − x − 2 ⟹ x² − 5x + 4 = 0.
   - **Step 3 — Factorize: find two numbers that multiply to 4 and add to −5:** −1 and −4.
   - **Step 4 — Write the factorized form and solve:** (x − 4)(x − 1) = 0 ⟹ x = 4 or x = 1.
   - **Step 5 — Find the matching y-value for each x using the simpler linear equation y = x + 2:** x = 4 ⟹ y = 6; x = 1 ⟹ y = 3.
   - **Step 6 — Check both points satisfy the quadratic equation too:** (4,6): 4²−4(4)+6 = 16−16+6 = 6 ✓; (1,3): 1−4+6 = 3 ✓.
   - **Answer: (4, 6) and (1, 3).**

2. **Solve simultaneously: y = x² − 2x + 3, y = 2x + 1.**
   - **Step 1 — Set the two expressions for y equal:** x² − 2x + 3 = 2x + 1.
   - **Step 2 — Rearrange to standard form:** x² − 2x − 2x + 3 − 1 = 0 ⟹ x² − 4x + 2 = 0.
   - **Step 3 — This does not factorize with whole numbers, so use the quadratic formula x = [−b ± √(b²−4ac)] ÷ 2a with a=1, b=−4, c=2:** x = [4 ± √(16 − 8)] ÷ 2 = [4 ± √8] ÷ 2.
   - **Step 4 — Simplify √8 = 2√2:** x = [4 ± 2√2] ÷ 2 = 2 ± √2.
   - **Step 5 — Find the matching y-value for each x using y = 2x + 1:** for x = 2+√2: y = 2(2+√2)+1 = 4+2√2+1 = 5+2√2; for x = 2−√2: y = 2(2−√2)+1 = 5−2√2.
   - **Answer: (2+√2, 5+2√2) and (2−√2, 5−2√2).**

3. **Draw y = x² − 4x + 3 for 0 ≤ x ≤ 4 and identify its key features.**
   - **Step 1 — Build a table of values by substituting each x into the equation:** x=0: y=0−0+3=3; x=1: y=1−4+3=0; x=2: y=4−8+3=−1; x=3: y=9−12+3=0; x=4: y=16−16+3=3.
   - **Step 2 — Plot the points (0,3), (1,0), (2,−1), (3,0), (4,3) and join them with a smooth curve (not straight lines).**
   - **Step 3 — Read off the roots (where the curve crosses the x-axis, y=0):** x = 1 and x = 3.
   - **Step 4 — Confirm the roots algebraically by factorizing:** x² − 4x + 3 = (x−1)(x−3) = 0 ⟹ x = 1 or x = 3 ✓ matches the graph.
   - **Step 5 — Find the vertex's x-coordinate using −b/(2a):** −(−4)/(2×1) = 4/2 = 2.
   - **Step 6 — Find the vertex's y-coordinate by substituting x = 2:** y = 4 − 8 + 3 = −1.
   - **Answer: vertex (2, −1); roots at x = 1 and x = 3 (matching the factorized form (x−1)(x−3)=0).**

**⚡ Shortcut & Speed Tips**

- **Substitute the linear equation into the quadratic, never the reverse:** isolating y from the linear equation is always easier, so plug that into the quadratic to get one single-variable equation.
- **Count solutions before fully solving using the discriminant:** for the resulting quadratic in x, compute b²−4ac first — positive means two intersection points, zero means the line is a tangent (touches once), negative means the line misses the curve completely (no real solutions).
- **Vertex shortcut:** the turning point's x-coordinate is always −b/(2a) — read it straight off the equation without completing the square, then substitute back in for the y-coordinate.
- **Table-of-values shortcut:** for a parabola, once you know the vertex's x-coordinate, values equally spaced on either side of it give mirror-image y-values (the curve is symmetric about the vertical line through the vertex) — halve your calculation work by exploiting this symmetry.
- **Sanity-check graphical roots against factorization:** whenever the quadratic factorizes neatly, quickly factorize it as an independent check on the roots you read off the graph — graph-reading errors are easy to make, but factorization gives an exact answer.

**Gamified Exercise Bank**

1. Solve: y = x + 2, y = x² − 4x + 6. (answer: (4,6) and (1,3))
2. Solve: y = x² + 1, y = 2x + 3 (graphically). (answer: x = 1±√3 — algebraically, x²+1=2x+3 gives x²−2x−2=0, so x=[2±√(4+8)]/2=1±√3 (≈2.73 or ≈−0.73); points (1+√3, 5+2√3) and (1−√3, 5−2√3) — corrected from an earlier "x=3 or x=−1", which does not satisfy this pair of equations)
3. Solve: y = x² − x − 2, y = x + 1 (graphically then algebraically). (answer: x = 3, y = 4 or x = −1, y = 0)
4. Solve: y = x² − 2x + 3, y = 2x + 1. (answer: x = 2±√2; points (2+√2, 5+2√2), (2−√2, 5−2√2))
5. Solve: (a) y = x² − 4x + 5, y = 2x − 1 (b) y = x² + 2x + 1, y = x + 3. (answer: (a) x²−6x+6=0, x=3±√3 (b) x²+x−2=0, x=1 or x=−2)
6. Draw the graph of y = x² − 4 and mark all key features. (answer: vertex (0,−4), roots x = ±2, y-intercept −4)
7. Draw y = x² − 3x + 2 for 0 ≤ x ≤ 3. State the minimum point. (answer: minimum at (1.5, −0.25))
8. From the graph of y = x² − 4x + 3, find (a) the roots (b) the vertex (c) the y-intercept. (answer: (a) x=1, x=3 (b) (2,−1) (c) (0,3))
9. Draw y = x² + 2x − 3 for −4 ≤ x ≤ 2. Find (a) vertex (b) axis of symmetry (c) roots (d) range. (answer: (a) (−1,−4) (b) x=−1 (c) x=−3, x=1 (d) y ≥ −4)
10. Solve graphically: y = x², y = 2x + 3. (answer: x² − 2x − 3 = 0 ⟹ x = 3 or x = −1; points (3,9), (−1,1))

### Week 9: Straight Line Graphs — gradient of a straight line; gradient of a curve; drawing tangents to a curve

**Teaching Notes**

For a linear equation **y = mx + c**, m is the gradient (slope) and c is the y-intercept. Gradient between two points: **m = (y₂ − y₁)/(x₂ − x₁)**. Parallel lines share the same gradient; perpendicular lines have gradients whose product is −1.

The **gradient of a curve** at a point is the gradient of the **tangent** to the curve at that point — found by drawing the tangent line carefully (touching the curve at exactly one point, without crossing it) and computing rise/run between two points on that tangent.

**Worked Examples**

1. **Draw y = 3x − 2 for −1 ≤ x ≤ 3, and state its gradient and intercepts.**
   - **Step 1 — Build a table of values by substituting each x:** x=−1: y=3(−1)−2=−5; x=0: y=−2; x=1: y=3−2=1; x=2: y=6−2=4; x=3: y=9−2=7.
   - **Step 2 — Plot the points (−1,−5), (0,−2), (1,1), (2,4), (3,7) and draw a straight line through them.**
   - **Step 3 — Read the gradient directly from the equation y = mx + c (here m = 3):** gradient = 3 (confirm using two table points: (7−(−5))/(3−(−1)) = 12/4 = 3 ✓).
   - **Step 4 — Read the y-intercept (where x = 0):** from the table, (0, −2).
   - **Step 5 — Find the x-intercept by setting y = 0 and solving:** 0 = 3x − 2 ⟹ x = 2/3.
   - **Answer: gradient = 3 (steep upward line), y-intercept (0, −2), x-intercept (2/3, 0).**

2. **Draw the tangent to y = x² at the point (2, 4) and estimate its gradient.**
   - **Step 1 — Plot the curve y = x² using a table of values around x = 2** (e.g. x = 0,1,2,3 giving y = 0,1,4,9), and mark the point (2, 4) on the curve.
   - **Step 2 — Draw a straight line that touches the curve at exactly (2, 4) without crossing it there** — this is the tangent.
   - **Step 3 — Read off (or extend the tangent to find) a second convenient point it passes through** — here the tangent passes through (0, −4).
   - **Step 4 — Apply the gradient formula m = (y₂ − y₁)/(x₂ − x₁) using the two points (0,−4) and (2,4):** m = (4 − (−4)) ÷ (2 − 0) = 8 ÷ 2.
   - **Step 5 — Divide:** 8 ÷ 2 = 4.
   - **Answer: gradient ≈ 4.** (This matches the true calculus derivative dy/dx = 2x at x = 2, which gives exactly 4 — the tangent construction is estimating this value graphically.)

3. **A taxi charges a fixed fee of ₦200 plus ₦50/km; a second taxi charges ₦100 plus ₦75/km. Find when their costs are equal.**
   - **Step 1 — Write a cost equation for each taxi in terms of distance d:** Taxi A: C = 200 + 50d; Taxi B: C = 100 + 75d.
   - **Step 2 — Graphically, this is two straight lines — their intersection point is where the costs are equal; algebraically, set the two expressions equal:** 200 + 50d = 100 + 75d.
   - **Step 3 — Collect the d-terms on one side and constants on the other:** 200 − 100 = 75d − 50d ⟹ 100 = 25d.
   - **Step 4 — Solve for d:** d = 100 ÷ 25 = 4.
   - **Step 5 — Substitute d = 4 into either cost equation to find the common cost:** C = 200 + 50(4) = 200 + 200 = 400.
   - **Answer: the two taxis cost the same (₦400) at a distance of 4 km** — on the graph, this is exactly where the two lines cross.

**⚡ Shortcut & Speed Tips**

- **Read the gradient straight from y = mx + c** — never compute it from two table points if the equation is already given in this form; the coefficient of x *is* the gradient.
- **The y-intercept is always the constant term c** — read it instantly from the equation, or from the table at x = 0, without solving anything.
- **For tangent-gradient questions, pick two points on the tangent that are far apart** (not close together) — the further apart your two chosen points are, the smaller the effect of small drawing/reading errors on your final gradient estimate.
- **Parallel/perpendicular shortcut:** two lines are parallel the instant their m-values match; they're perpendicular the instant m₁ × m₂ = −1 (equivalently, one gradient is the negative reciprocal of the other) — check this instead of re-plotting to compare lines.
- **"When are the costs/values equal" graph questions are just simultaneous equations in disguise** — you can always skip the actual drawing and solve algebraically by setting the two expressions equal, then draw only to illustrate the answer.

**Gamified Exercise Bank**

1. Draw the graph of y = 3x − 2 for −1 ≤ x ≤ 3. (answer: gradient 3, y-intercept −2, x-intercept 2/3)
2. Draw the tangent to the curve y = x² at the point (2, 4) and estimate its gradient. (answer: gradient ≈ 4)
3. Draw the graph of y = 2x − 3 for a chosen domain, labelling table, points and line. (answer: gradient 2, y-intercept −3)
4. Draw the graph of y = 3x + 2 for −2 ≤ x ≤ 2. (answer: gradient 3, y-intercept 2)
5. Draw graphs for −3 ≤ x ≤ 3: (a) y = x − 2 (b) y = −2x + 1 (c) y = (1/2)x + 3. (answer: gradients 1, −2, 1/2 respectively)
6. A company charges a ₦500 setup fee plus ₦100/hour; another charges ₦300 plus ₦150/hour. Graph both and find when costs are equal. (answer: 4 hours, ₦900)
7. A phone plan costs ₦1000 monthly plus ₦5/minute; another costs ₦500 plus ₦10/minute. (a) Write equations for both (b) graph for 0–200 minutes (c) find when costs are equal (d) which is better at 150 minutes? (answer: equal at 100 minutes (₦1500); at 150 minutes plan 1, ₦1750, is cheaper than plan 2, ₦2000)
8. A taxi charges a fixed fee of ₦200 plus ₦50/km; a second taxi charges ₦100 plus ₦75/km. Find when the costs are equal. (answer: 4 km, ₦400)
9. Using two points on a drawn line, calculate the gradient from the graph, e.g. points (0,1) and (2,5). (answer: gradient 2)
10. Draw y = x + 1 and y = 5 − x on the same axes and solve graphically. (answer: x = 2, y = 3)

### Week 10: Revision

**Teaching Notes**

Comprehensive revision of First Term topics: logarithms, standard form/approximation, sequences and series (AP & GP), quadratic equations (formation, solving, discriminant, word problems), simultaneous equations (linear-linear and linear-quadratic), and straight-line/curve graphs including gradients and tangents. *(limited source material for this sub-topic — it is a revision week by design; use a mixed review drawn from Weeks 1–9 above.)*

**Worked revision walk-through — one representative question per topic, showing the full method to model for students:**

1. **Logarithms:** Evaluate 23.6 × 4.15 using logs.
   - **Step 1 — Set N = 23.6 × 4.15 and take logs:** log N = log 23.6 + log 4.15.
   - **Step 2 — Find each log:** log 23.6 = 1.3729; log 4.15 = 0.6180.
   - **Step 3 — Add:** 1.3729 + 0.6180 = 1.9909.
   - **Step 4 — Take the antilog:** antilog 1.9909 ≈ 97.94.
   - **Answer: ≈ 97.9** (calculator check: 23.6 × 4.15 = 97.94 ✓).

2. **AP:** Find the sum of the first 10 terms of 6, 10, 14, 18, …
   - **Step 1 — Identify a, d, n:** a = 6, d = 4, n = 10.
   - **Step 2 — Apply Sₙ = n/2[2a + (n−1)d]:** S₁₀ = 10/2 × [12 + 9(4)] = 5 × [12 + 36].
   - **Step 3 — Simplify:** 5 × 48 = 240.
   - **Answer: S₁₀ = 240.**

3. **Quadratic from roots:** Form the equation whose roots are 2/3 and −3.
   - **Step 1 — Sum of roots:** 2/3 + (−3) = 2/3 − 9/3 = −7/3.
   - **Step 2 — Product of roots:** (2/3) × (−3) = −2.
   - **Step 3 — Substitute into x² − (sum)x + (product) = 0:** x² − (−7/3)x + (−2) = 0 ⟹ x² + (7/3)x − 2 = 0.
   - **Step 4 — Clear the fraction by multiplying through by 3:** 3x² + 7x − 6 = 0.
   - **Answer: 3x² + 7x − 6 = 0.**

**⚡ Shortcut & Speed Tips**

- **Build a one-page formula sheet before revising**, grouping by topic: log laws; Tₙ/Sₙ for AP; Tₙ/Sₙ/S∞ for GP; sum & product of roots; elimination vs substitution triggers; m = (y₂−y₁)/(x₂−x₁). Reciting this from memory is the fastest diagnostic for what still needs work.
- **Practice topic recognition, not just topic solving:** WAEC and NECO papers mix these topics across the whole paper — train yourself to instantly identify which of the five methods a question needs before starting to solve.
- **Use unit-fraction and index shortcuts across topics:** the same "combine to one exponent, then divide/multiply exponents" instinct that speeds up GP problems (Week 4) also speeds up logarithm power/root rules (Week 1) — recognising this shared skill saves revision time.
- **For every worked answer, run a 10-second sanity check:** does a % error look implausibly big? Does an age or length come out negative? Does a GP ratio make the terms grow or shrink as expected? Catching an unreasonable answer immediately is often faster than re-deriving from scratch.

**Gamified Exercise Bank**

*(No new exercises — combine questions from Weeks 1–9 above for a comprehensive revision quiz.)*

## Second Term

### Week 1: Revision — gradient of a straight line, gradient of a curve, drawing of tangents to a curve

**Teaching Notes**

This week revisits **First Term Week 9**. The gradient of a straight line y = mx + c is the coefficient m; the gradient of a curve *at a point* equals the gradient of the tangent drawn at that point, found from rise/run using two points on the tangent line (since a tangent touches the curve at only one point but is itself a straight line everywhere else).

**Worked Examples**

1. Find the gradient of the line joining A(2, 5) and B(6, 13).
**Step 1 — Identify the two points:** A(x₁, y₁) = (2, 5), B(x₂, y₂) = (6, 13).
**Step 2 — Apply the gradient formula:** m = (y₂ − y₁)/(x₂ − x₁) = (13 − 5)/(6 − 2) = 8/4.
**Step 3 — Simplify:** 8/4 = 2.
**Answer: m = 2.**

2. Find the gradient and y-intercept of the line 3x + 2y = 12.
**Step 1 — Make y the subject of the equation:** 2y = 12 − 3x.
**Step 2 — Divide every term by 2:** y = 6 − 1.5x, i.e. y = −1.5x + 6.
**Step 3 — Compare with y = mx + c:** m = −1.5, c = 6.
**Answer: gradient m = −1.5, y-intercept c = 6.**

3. Find the gradient of the curve y = x² at the point (2, 4), using a drawn tangent.
**Step 1 — Plot the curve y = x² and mark the point (2, 4) on it.**
**Step 2 — Draw the tangent line at (2, 4)** — a straight line that touches the curve only at that point and does not cross it there.
**Step 3 — Choose two clearly-spaced points that lie ON the tangent line** (read from the graph), e.g. (1, 0) and (3, 8).
**Step 4 — Apply the gradient formula to these two points:** m = (8 − 0)/(3 − 1) = 8/2 = 4.
**Answer: gradient of the curve at (2, 4) is 4.** (This agrees with the calculus result dy/dx = 2x = 2(2) = 4, though at SS2 level the graphical tangent method is what is examined.)

**⚡ Shortcut & Speed Tips**

- If a line is already in the form y = mx + c, the gradient is simply the number multiplying x — read it off instantly, no rearranging needed.
- To find the gradient of ax + by = c without fully rearranging, use m = −a/b directly (the "coefficient trick") — e.g. for 3x + 2y = 12, m = −3/2 = −1.5 immediately.
- Parallel lines always have equal gradients; perpendicular lines always have gradients whose product is −1 (m₁ × m₂ = −1) — use this to check an answer or find a missing gradient without extra working.
- When reading a tangent off a graph, pick the two points where the tangent crosses clean grid lines (whole-number coordinates) — this avoids estimation error in the rise/run calculation.
- Sanity-check any calculated gradient against the picture: a steep upward line should give a large positive number, a gentle upward slope a small positive number, and so on — a wildly mismatched sign or size means an arithmetic slip.

**Gamified Exercise Bank**

*(Reuse First Term Week 9 exercises 1–10 as a warm-up revision set.)*

### Week 2: Inequalities — revision of linear inequalities in one variable; solutions of inequalities in two variables; range of values of combined inequalities

**Teaching Notes**

Inequality symbols: **<** (less than), **>** (greater than), **≤** (less than or equal to / "at most"), **≥** (greater than or equal to / "at least"). < and > are *strict*; ≤ and ≥ are *weak*.

Linear inequalities are solved like linear equations, **except**: multiplying or dividing both sides by a **negative** number reverses the inequality sign.

**Combining inequalities:** two inequalities on the same variable can be merged into a single range, e.g. if x > 8 and 20 > x, combine as 8 < x < 20. Whether an endpoint is included depends on whether that inequality was strict or weak.

For **quadratic inequalities**, rearrange to have 0 on one side, factorize, and use the sign rule for products: (x − a)(x − b) > 0 means both factors have the same sign (x < a or x > b, for a < b); (x − a)(x − b) < 0 means factors have opposite signs (a < x < b).

On a **number line**, an open dot (○) marks a strict inequality endpoint (not included) and a filled dot (●) marks a weak inequality endpoint (included).

**Worked Examples**

1. Solve 3x − 4 > 8.
**Step 1 — Isolate the x-term by adding 4 to both sides:** 3x − 4 + 4 > 8 + 4, giving 3x > 12.
**Step 2 — Divide both sides by 3 (positive number, sign unchanged):** x > 12/3.
**Answer: x > 4.**

2. Solve 6x − 14 ≥ 13x.
**Step 1 — Collect the x-terms on one side and the numbers on the other:** subtract 13x from both sides and add 14 to both sides: 6x − 13x ≥ 14, giving −7x ≥ 14.
**Step 2 — Divide both sides by −7; since we are dividing by a NEGATIVE number, reverse the inequality sign:** x ≤ 14/(−7) → x ≤ −2.
**Answer: x ≤ −2.**

3. Solve y² − 3y > 18.
**Step 1 — Rearrange so that 0 is on one side:** y² − 3y − 18 > 0.
**Step 2 — Factorize the quadratic:** find two numbers that multiply to −18 and add to −3: these are −6 and 3, so (y − 6)(y + 3) > 0.
**Step 3 — Find the critical values** by setting each factor to zero: y = 6 and y = −3.
**Step 4 — Test each region on a number line against the product rule** (a product of two factors is positive only when both factors have the same sign): for y < −3, both factors are negative → product positive ✓; for −3 < y < 6, factors have opposite signs → product negative ✗; for y > 6, both factors are positive → product positive ✓.
**Answer: y < −3 or y > 6.**

4. Combine −4 < x and x < 2, and list the whole-number solutions.
**Step 1 — Write both inequalities with x sandwiched in the middle, smallest value first:** −4 < x < 2.
**Step 2 — List every whole number strictly between −4 and 2:** −3, −2, −1, 0, 1.
**Answer: −4 < x < 2; whole numbers −3, −2, −1, 0, 1.**

**⚡ Shortcut & Speed Tips**

- The only time you flip the inequality sign is when multiplying or dividing both sides by a NEGATIVE number — adding or subtracting anything, even a negative number, never flips it. Say this rule out loud as you solve to avoid the single most common WAEC error on this topic.
- For quadratic inequalities, once you have the two roots, use the "positive coefficient smiley-face" rule: if the x² coefficient is positive, the expression is negative (< 0) BETWEEN the roots and positive (> 0) OUTSIDE them — this lets you write the answer straight from the roots without testing each region by substitution.
- When solving, push the x-terms to whichever side keeps their coefficient positive (as in Example 1 vs. Example 2 above) — this avoids the sign-flip step altogether and reduces careless mistakes.
- To combine two simple inequalities in one variable, just line them up in increasing order along a number line (smallest bound, x, largest bound) — no algebra needed.
- On multiple-choice questions, if solving looks messy, plug one boundary/option value back into the original inequality to test which option range actually satisfies it — often faster than re-deriving.

**Gamified Exercise Bank**

1. Solve 3x − 4 > 8. (answer: x > 4)
2. For what values of x is ½(x + 3) < 3? (answer: x < 3)
3. Solve the inequality 6x − 14 ≥ 13x. (answer: x ≤ −2)
4. Solve the inequality x + 3 < 4x. (answer: x > 1)
5. Find the range of values of x for which 3(x + 8) < 7x. A x > −6 B x < −6 C x > 2 D x > 6 (answer: x > −6, option A)
6. For what range of values of x is 4x − 3(2x − 1) > 1? A x > −1 B x > 1 C x < 1 D x < −1 (answer: x < 1, option C)
7. Solve the inequality x − 4(x + 2) > 8 + 5x. A x > 0 B x < 0 C x > −2 D x < −2 (answer: x < −2, option D)
8. Solve the inequality ⅓(2x − 1) < 5. A x < −5 B x < 7 C x > 8 D x < 8 (answer: x < 8, option D)
9. Solve the inequality x/6 − x/2 ≥ 2/3. A x < 1 B x ≥ 2 C x < −2 D x ≥ 2 E x ≤ −2 (answer: x ≤ −2, option E)
10. Solve the inequality 1 − 2x < −⅓. A x < 2/3 B x < −2/3 C x > 2/3 D x > −2/3 (answer: x > 2/3, option C)
11. Solve the inequality (1/2x) + 2 ≤ 2x − 1. A x ≤ 2 B x ≥ 2 C x ≤ 3 D x ≥ 3 (answer: x ≥ 2, option B)
12. Solve the inequality (y − 3) < y/3. A y < 2 B y < 3.5 C y < 4.5 D y > 4.5 E y > 6 (answer: y < 4.5, option C)
13. Solve the inequality 3(x + 1) ≥ 5(x + 2) + 15. A x ≤ −14 B x ≥ −14 C x ≤ −11 D x ≥ −11 (answer: x ≤ −11, option C)
14. If x is a positive integer, list the values of x which satisfy 3x − 4 ≤ 6 and x − 1 > 0. A {1,2,3} B {2,3} C {2,3,4} D {2,3,4,5} (answer: {2,3}, option B)
15. Find the range of values of x for which 2x − 1 ≤ 3 and 2 − x ≤ 5. A −3≤x≤1 B −2≤x≤3 C −3≤x≤4 D −3≤x≤2 (answer: −3≤x≤2, option D)
16. If 2 + x < 6 and 7 + x ≥ 4, find the range of x satisfying both inequalities. (answer: −3 ≤ x < 4)
17. Combine −4 < x and x < 2 and give the range of x in whole numbers. (answer: −3, −2, −1, 0, 1)
18. Given that x > 8 and 20 > x, combine the inequalities and list whole-number solutions. (answer: {9,10,...,19})
19. If t ≤ 3 and 0 < t, combine the inequalities and list whole-number solutions. (answer: {1,2,3})
20. If r < −5 and −9 < r, combine the inequalities and list whole-number solutions. (answer: {−8,−7,−6})
21. Solve the inequality y² − 3y > 18. A −3<y<6 B y<−3 or y>6 C y>−3 or y>6 D y<−3 or y<6 (answer: y<−3 or y>6, option B)
22. If y = x² − x − 12, find the range of values of x for which y ≤ 0. A x≤−3 or x≥4 B x<−3 or x>4 C −3≤x≤4 D −3<x≤4 (answer: −3≤x≤4, option C)
23. Solve the quadratic inequality x² + x − 12 ≥ 0. A x≤−3 or x≥4 B x≥3 or x≤−4 C x≤3 or x≥−4 D x≤3 or x≥−4 (answer: x≤−4 or x≥3)
24. Find the range of values of x which satisfies 12x² < x + 1. A −1<x<1/4 B 1/4<x<1/3 C 1/4<x<1/3 D −1/4<x<−1/3 (answer: −¼ < x < ⅓)
25. Solve the inequality 2 − x > x². A x<−2 or x>1 B x>2 or x<−1 C −1<x<2 D −2<x<1 (answer: −2 < x < 1, option D)
26. Solve the inequality (y−1)/2 ≤ 6/y. A y≤−3 B y≥4 C y≤−3 or y≥4 D −3≤y≤4 E −4≤y≤3 (answer: y≤−3 or y≥4, option C)
27. Solve the inequality: 2(x + 3) ≥ 3(x − 1) ≤ 12; represent the answer on a number line. (answer: x ≤ 3)

### Week 3: Graphs of linear inequalities in two variables; maximum and minimum values of simultaneous linear inequalities

**Teaching Notes**

To graph an inequality such as x + y ≤ 6: draw the boundary line x + y = 6 (**solid** for ≤/≥, **dashed** for </>), then test a point not on the line (usually the origin) — if it satisfies the inequality, shade that side.

The **feasible region** for several simultaneous inequalities is the overlap (intersection) of all the individual shaded regions. Its corners (vertices) are found by solving pairs of boundary equations simultaneously. By the **corner point theorem**, the maximum or minimum of a linear objective function over the feasible region always occurs at one of these corner points — so evaluating the function at each corner and comparing gives the optimum.

**Worked Examples**

1. Maximize P = 3x + 4y subject to x + y ≤ 6, 2x + y ≤ 10, x ≥ 0, y ≥ 0.
**Step 1 — Find the x- and y-intercepts of each boundary line:** x + y = 6 → (6,0) and (0,6); 2x + y = 10 → (5,0) and (0,10).
**Step 2 — Find the intersection of the two boundary lines** by solving simultaneously: from x + y = 6, y = 6 − x; substituting into 2x + y = 10 gives 2x + (6 − x) = 10 → x = 4, y = 2, so the lines cross at (4, 2).
**Step 3 — Check which intercepts are actually feasible** (satisfy BOTH constraints, not just the one they lie on): (0,6) satisfies 2(0)+6=6≤10 ✓, so it is a genuine corner; (5,0) satisfies 5+0=5≤6 ✓, so it is also a genuine corner; the intercepts (6,0) and (0,10) fail the other constraint, so they are excluded.
**Step 4 — List the true corners of the feasible region:** (0,0), (0,6), (4,2), (5,0).
**Step 5 — Evaluate P = 3x + 4y at each corner:** (0,0)→0; (0,6)→3(0)+4(6)=24; (4,2)→3(4)+4(2)=20; (5,0)→3(5)+4(0)=15.
**Step 6 — Compare all values and pick the largest, since we are maximizing:** 24 is the largest.
**Answer: Maximum P = 24 at (0, 6).**

2. Minimize C = 2x + 3y subject to x + y ≥ 4, 2x + y ≥ 6, x ≥ 0, y ≥ 0.
**Step 1 — Find the intercepts of each boundary line:** x + y = 4 → (4,0) and (0,4); 2x + y = 6 → (3,0) and (0,6).
**Step 2 — Find the intersection of the two lines:** from x + y = 4, y = 4 − x; substituting into 2x + y = 6 gives 2x + (4 − x) = 6 → x = 2, y = 2, so the lines cross at (2, 2).
**Step 3 — Because both constraints are "≥", the feasible region lies AWAY from the origin — check each intercept against the OTHER constraint before accepting it as a corner:** (0,4): check 2(0)+4=4, which must be ≥6 — this FAILS, so (0,4) is not a feasible corner; (0,6): check 0+6=6≥4 ✓ and 2(0)+6=6≥6 ✓ (boundary) — feasible corner; (4,0): check 2(4)+0=8≥6 ✓ and 4+0=4≥4 ✓ (boundary) — feasible corner; (3,0): check 3+0=3, which must be ≥4 — this FAILS, so (3,0) is not a feasible corner.
**Step 4 — List the true corners of the feasible region:** (0,6), (2,2), (4,0).
**Step 5 — Evaluate C = 2x + 3y at each corner:** (0,6)→2(0)+3(6)=18; (2,2)→2(2)+3(2)=10; (4,0)→2(4)+3(0)=8.
**Step 6 — Compare all values and pick the smallest, since we are minimizing:** 8 is the smallest.
**Answer: Minimum C = 8 at (4, 0).**

3. Find the feasible region for x ≥ 2, y ≥ 1, x + y ≤ 8.
**Step 1 — Draw the three boundary lines:** the vertical line x = 2, the horizontal line y = 1, and the line x + y = 8.
**Step 2 — Find each pair of intersections:** x = 2 and y = 1 meet at (2, 1); x = 2 and x + y = 8 meet where 2 + y = 8, i.e. y = 6, giving (2, 6); y = 1 and x + y = 8 meet where x + 1 = 8, i.e. x = 7, giving (7, 1).
**Step 3 — Confirm each point satisfies all three constraints simultaneously** (it does, by construction of the intersections).
**Answer: the feasible region is a triangle with corners (2, 1), (7, 1), (2, 6).**

**⚡ Shortcut & Speed Tips**

- To find a boundary line's intercepts fast, set x = 0 to get the y-intercept and set y = 0 to get the x-intercept — you don't need to plot the whole line first.
- The corner-point theorem means you never need to shade or test the interior of the feasible region — just locate every corner, evaluate the objective function at each, and compare. This is far faster than trying to "see" the optimum on a hand-drawn graph.
- **Not every intercept of a boundary line is automatically a feasible corner.** Always check an intercept against the OTHER constraints before including it — Worked Example 2 above shows exactly how skipping this check gives a wrong corner (and a wrong minimum).
- For "≥" (at-least) constraints, the feasible region sits away from the origin; for "≤" (at-most) constraints, it sits towards the origin — sketch a rough mental picture first so you shade (and pick corners) on the correct side.
- If two boundary lines are parallel, they never intersect — skip solving that pair simultaneously and save time.

**Gamified Exercise Bank**

1. Maximize P = 3x + 4y subject to x + y ≤ 6, 2x + y ≤ 10, x ≥ 0, y ≥ 0. (answer: max P = 24 at (0,6))
2. Minimize C = 2x + 3y subject to x + y ≥ 4, 2x + y ≥ 6, x ≥ 0, y ≥ 0. (answer: corners (0,6), (2,2), (4,0); min C = 8 at (4,0) — see Teaching Notes Worked Example 2 for the full corner-check)
3. Graph the feasible region for x ≥ 2, y ≥ 1, x + y ≤ 8. (answer: triangle with corners (2,1),(7,1),(2,6))
4. On graph paper, graph x + 2y ≤ 8 and shade the feasible region. (answer: region below line through (0,4) and (8,0))
5. Find the corner points of the feasible region for x + y ≤ 5, 2x + y ≤ 8, x ≥ 0, y ≥ 0. (answer: (0,0), (0,5), (3,2), (4,0))
6. How do you determine which side of a line to shade when graphing an inequality? (answer: test a point, e.g. the origin — if it satisfies the inequality, shade its side)
7. What is a feasible region in linear programming? (answer: the set of all points satisfying every constraint simultaneously)
8. State the corner point theorem. (answer: the optimal value of a linear objective function over a feasible region occurs at a vertex/corner point of that region)
9. Graph the inequality 2x + 3y ≤ 12 and shade the feasible region (including x ≥ 0, y ≥ 0). (answer: region bounded by (0,0), (0,4), (6,0))
10. Find the corner points of the feasible region formed by x + y ≤ 6, x ≤ 4, y ≤ 5, x ≥ 0, y ≥ 0. (answer: (0,0), (0,5), (1,5), (4,2), (4,0))
11. Maximize P = 5x + 4y subject to x + 2y ≤ 10, 3x + y ≤ 15, x ≥ 0, y ≥ 0: graph, find corners, and determine the optimal solution. (answer: corners (0,0),(0,5),(4,3),(5,0); max P = 32 at (4,3))
12. Minimize C = 3x + 2y subject to 2x + y ≥ 8, x + y ≥ 6, x ≥ 0, y ≥ 0. Solve graphically and state the minimum value. (answer: corners (0,8), (2,4), (6,0) — found from intersecting 2x+y=8 with x+y=6 at (2,4); min C = 3(2)+2(4) = 14 at (2,4))
13. Graph x + y ≤ 3, 2x + y ≤ 12, x ≤ 5, x ≥ 0, y ≥ 0 on the same axes and identify the feasible region. (answer: bounded region with corners (0,0),(0,3),(3,0))

### Week 4: Application of linear inequalities to real life; introduction to linear programming

**Teaching Notes**

**Linear programming (LP)** finds the best outcome (maximum profit or minimum cost) subject to linear constraints. To formulate an LP problem:
1. Define **decision variables** (e.g. x = number of item A, y = number of item B).
2. Write the **objective function** to maximize or minimize (e.g. Maximize P = ax + by).
3. List the **constraints** as linear inequalities (resource limits).
4. Add **non-negativity constraints**: x ≥ 0, y ≥ 0.

A problem is *linear* only if every relationship (objective and constraints) uses variables to the first power with no products like xy or x².

**Worked Examples**

1. A factory makes dining chairs (x) needing 2 hrs labour and 3 kg wood, and office chairs (y) needing 3 hrs labour and 2 kg wood. 120 labour-hours and 150 kg of wood are available; profit is ₦5,000 per dining chair and ₦6,000 per office chair. Formulate this as an LP problem.
**Step 1 — Define the decision variables:** let x = number of dining chairs made, y = number of office chairs made.
**Step 2 — Write the objective function:** profit comes from ₦5,000 per x and ₦6,000 per y, so Maximize P = 5000x + 6000y.
**Step 3 — Write the resource constraints one at a time:** labour used is 2 hrs per dining chair + 3 hrs per office chair, limited to 120 hours → 2x + 3y ≤ 120; wood used is 3 kg per dining chair + 2 kg per office chair, limited to 150 kg → 3x + 2y ≤ 150.
**Step 4 — Add the non-negativity constraints**, since a negative number of chairs is meaningless: x ≥ 0, y ≥ 0.
**Answer: Maximize P = 5000x + 6000y subject to 2x + 3y ≤ 120, 3x + 2y ≤ 150, x ≥ 0, y ≥ 0.**

2. A farmer has 100 hectares of land. Rice needs 2 workers per hectare and maize needs 1 worker per hectare; only 150 workers are available. Profit is ₦80,000 per hectare of rice and ₦50,000 per hectare of maize. Formulate this as an LP problem.
**Step 1 — Define the decision variables:** let x = hectares planted with rice, y = hectares planted with maize.
**Step 2 — Write the objective function:** Maximize P = 80000x + 50000y.
**Step 3 — Write the constraints:** total land used cannot exceed 100 hectares → x + y ≤ 100; total workers used cannot exceed 150 → 2x + y ≤ 150.
**Step 4 — Add non-negativity constraints:** x ≥ 0, y ≥ 0.
**Answer: Maximize P = 80000x + 50000y subject to x + y ≤ 100, 2x + y ≤ 150, x ≥ 0, y ≥ 0.**

3. Identify which of the following are genuine LP problems: (a) Max Z = 3x + 2y s.t. x² + y ≤ 10; (b) Min C = 5x + 4y s.t. 2x + 3y ≤ 12, x + y ≤ 8; (c) Max P = xy s.t. x + y ≤ 20.
**Step 1 — Recall the test for linearity: every term in the objective function and every constraint must have variables to the FIRST power only, with no products of two variables.**
**Step 2 — Check (a):** the constraint contains x², a squared variable — this fails the test.
**Step 3 — Check (b):** the objective and both constraints use only x and y to the first power, added together — this passes the test.
**Step 4 — Check (c):** the objective function contains xy, a product of two variables — this fails the test.
**Answer: (a) not LP (x² term); (b) is LP; (c) not LP (xy term).**

**⚡ Shortcut & Speed Tips**

- Always begin by writing "let x = …, y = …" in words before touching the algebra — most formulation mistakes come from mixing up which variable stands for which resource-user.
- Scan every constraint for x², y², or a product like xy before calling anything an LP problem — spotting one such term instantly disqualifies it, with no further checking needed.
- Match units carefully: each constraint's coefficients must be "amount of resource per unit of x" and "amount of resource per unit of y" in the SAME resource and unit — a mismatched unit is the most common setup error in these word problems.
- Real-life LP problems almost always need x ≥ 0, y ≥ 0 even when the question doesn't say so explicitly — add them by default, since negative production, negative hectares, or negative items produced make no physical sense.
- When a question gives "at least" or "minimum required" language (e.g. calories, protein), the constraint uses ≥, not ≤ — "at most"/"available"/"limited to" language uses ≤. Spotting this keyword instantly tells you which inequality sign to write.

**Gamified Exercise Bank**

1. Define linear programming and state its main components. (answer: a method for finding the best (max/min) outcome subject to linear constraints; components: decision variables, objective function, constraints, feasible region, optimal solution)
2. What is the difference between an objective function and a constraint? (answer: the objective function is what is being maximized/minimized; a constraint is a limitation the solution must satisfy)
3. A company makes products X (2 hrs) and Y (3 hrs); 120 hours available. Write the time constraint. (answer: 2x + 3y ≤ 120)
4. State three real-life applications of linear programming. (answer: e.g. manufacturing product-mix, agriculture crop planning, diet/nutrition planning, transportation, resource allocation)
5. Why must decision variables in most LP problems be non-negative? (answer: because quantities like items produced or hectares planted cannot be negative)
6. A farmer plants tomatoes (3 hrs/hectare, ₦40,000 profit) and peppers (2 hrs/hectare, ₦30,000 profit); 60 labour-hours available; 25 hectares of land. Formulate as an LP problem. (answer: Maximize P = 40000x + 30000y s.t. 3x+2y≤60, x+y≤25, x,y≥0)
7. Explain the meaning of: (a) decision variables (b) feasible solution (c) optimal solution (d) constraint (e) objective function. (answer: standard LP definitions — see Teaching Notes)
8. Which of these are LP problems? (a) Max P=4x+5y s.t. 2x+3y≤100, x,y≥0 (b) Max P=x²+y s.t. x+y≤50, x,y≥0 (c) Min C=3x+7y s.t. x+2y≥20, 3x+y≥30, x,y≥0. (answer: (a) is LP, (b) is not LP (x² term), (c) is LP)
9. A baker makes meat pies (2 eggs, 100g flour, cost ₦300, sells ₦500) and sausage rolls (1 egg, 50g flour, cost ₦150, sells ₦300); 100 eggs and 5000g flour available daily. Formulate to maximize profit. (answer: Maximize profit = 200x+150y s.t. 2x+y≤100, 100x+50y≤5000, x,y≥0)
10. Give two examples of situations in your community or school that could be modelled using linear programming. (answer: open-ended — not given in source)
11. A factory produces dining chairs and office chairs (see Teaching Notes example 1). Define the decision variables and constraints (do not solve). (answer: Maximize P=5000x+6000y s.t. 2x+3y≤120, 3x+2y≤150, x,y≥0)
12. A baker makes cakes (2 hrs, 3 kg flour, sells ₦2,000) and bread (1 hr, 2 kg flour, sells ₦800); 40 hours and 60 kg flour available. Formulate the problem. (answer: Maximize R=2000x+800y s.t. 2x+y≤40, 3x+2y≤60, x,y≥0)
13. A company produces products A (4 hrs Machine 1, 2 hrs Machine 2, profit ₦3,000) and B (2 hrs Machine 1, 3 hrs Machine 2, profit ₦2,500); Machine 1 available 80 hrs, Machine 2 available 60 hrs. Formulate the LP problem. (answer: Maximize P=3000x+2500y s.t. 4x+2y≤80, 2x+3y≤60, x,y≥0)
14. A nutritionist needs at least 300 calories and 50g protein; Food A gives 100 cal/20g protein/₦200, Food B gives 150 cal/10g protein/₦250. Formulate to minimize cost. (answer: Minimize C=200x+250y s.t. 100x+150y≥300, 20x+10y≥50, x,y≥0)
15. A tailor makes agbada (4 hrs, 6 m fabric, profit ₦15,000) and suits (3 hrs, 4 m fabric, profit ₦12,000); 60 hours and 90 m fabric available. Formulate this problem. (answer: Maximize P=15000x+12000y s.t. 4x+3y≤60, 6x+4y≤90, x,y≥0)
16. A school wants to buy computers (₦150,000 each) and projectors (₦80,000 each) with a budget of ₦2,000,000. Identify the decision variables. (answer: x = number of computers, y = number of projectors, with 150000x+80000y≤2000000)
17. A bus company has 10 buses; each trip needs 2 drivers and 1 mechanic; 15 drivers and 8 mechanics available. Write the constraints. (answer: 2x≤15 (drivers), x≤8 (mechanics), x≤10 (buses), where x = buses used per trip)

### Week 5: Algebraic Fractions — simplification of fractions; operations on algebraic fractions

**Teaching Notes**

Algebraic fractions are simplified the same way as numeric fractions: **factorize numerator and denominator fully**, then cancel common factors. For addition/subtraction, find the **LCM of the denominators**, rewrite each fraction over that LCM, then combine numerators.

**Worked Examples**

1. Simplify (x² − y²)/(3x + 3y).
**Step 1 — Factorize the numerator, a difference of two squares:** x² − y² = (x − y)(x + y).
**Step 2 — Factorize the denominator by taking out the common factor 3:** 3x + 3y = 3(x + y).
**Step 3 — Write as one fraction and cancel the common factor (x + y) top and bottom:** (x − y)(x + y) / [3(x + y)] = (x − y)/3.
**Answer: (x − y)/3.**

2. Simplify (x² − 8x + 16)/(x² − 7x + 12).
**Step 1 — Factorize the numerator, a perfect-square trinomial:** x² − 8x + 16 = (x − 4)(x − 4).
**Step 2 — Factorize the denominator:** find two numbers multiplying to 12 and adding to −7: these are −4 and −3, so x² − 7x + 12 = (x − 4)(x − 3).
**Step 3 — Cancel the common factor (x − 4):** (x − 4)(x − 4) / [(x − 4)(x − 3)] = (x − 4)/(x − 3).
**Answer: (x − 4)/(x − 3).**

3. Express (x+1)/2 − (3x−1)/3 as a single fraction.
**Step 1 — Find the LCM of the denominators 2 and 3:** LCM = 6.
**Step 2 — Rewrite each fraction with denominator 6:** (x+1)/2 = 3(x+1)/6, (3x−1)/3 = 2(3x−1)/6.
**Step 3 — Combine over the common denominator:** [3(x+1) − 2(3x−1)]/6.
**Step 4 — Expand the brackets:** (3x + 3 − 6x + 2)/6.
**Step 5 — Collect like terms in the numerator:** (5 − 3x)/6.
**Answer: (5 − 3x)/6.**

4. Simplify 2a/(b−1) + a/(b+2).
**Step 1 — Find the LCM of the denominators (b−1) and (b+2):** since they share no common factor, the LCM is their product, (b−1)(b+2).
**Step 2 — Rewrite each fraction over this LCM:** 2a(b+2)/[(b−1)(b+2)] + a(b−1)/[(b−1)(b+2)].
**Step 3 — Combine the numerators:** [2a(b+2) + a(b−1)]/[(b−1)(b+2)].
**Step 4 — Expand:** (2ab + 4a + ab − a)/[(b−1)(b+2)] = (3ab + 3a)/[(b−1)(b+2)].
**Step 5 — Factor out the common factor 3a in the numerator:** 3a(b+1)/[(b−1)(b+2)].
**Answer: 3a(b+1)/[(b−1)(b+2)].**

5. Simplify [(x² − y²)/(x+y)²] ÷ [(x−y)²/(3x+3y)].
**Step 1 — Rewrite the division as multiplication by the reciprocal ("keep, change, flip"):** (x²−y²)/(x+y)² × (3x+3y)/(x−y)².
**Step 2 — Factorize every part:** x² − y² = (x−y)(x+y); 3x + 3y = 3(x+y).
**Step 3 — Substitute the factorized forms:** [(x−y)(x+y)/(x+y)²] × [3(x+y)/(x−y)²].
**Step 4 — Multiply numerators together and denominators together:** 3(x−y)(x+y)(x+y) / [(x+y)²(x−y)²].
**Step 5 — Cancel (x+y)² top and bottom, then cancel one (x−y):** 3/(x−y).
**Answer: 3/(x−y).**

**⚡ Shortcut & Speed Tips**

- Always factorize FIRST and cancel SECOND. Only common *multiplying* factors can be cancelled — never cancel a term that is being added or subtracted inside a bracket.
- Learn to spot the two workhorse patterns on sight: difference of two squares a² − b² = (a−b)(a+b), and perfect-square trinomials a² ± 2ab + b² = (a±b)² — recognizing these instantly skips the "split the middle term" search.
- If two binomial denominators share no common factor (e.g. (b−1) and (b+2)), their LCM is simply their product — don't waste time searching for a smaller common multiple that doesn't exist.
- For "evaluate at given numbers" questions, simplify the fraction algebraically FIRST, then substitute the numbers — this is almost always less arithmetic than substituting into the unsimplified expression.
- Fraction division is "keep, change, flip": keep the first fraction as it is, change ÷ to ×, and flip (take the reciprocal of) the second fraction — never try to cross-multiply a division directly.

**Gamified Exercise Bank**

1. Simplify 1[5y − (2+3y) + (7y−4)]/3. A 6y+4 B 3y+2 C 6y+2 D 3y−2 E 9y−6 (answer: 3y − 2, option D)
2. Find the sum of 25a − 15b + c, 13a − 10b + 4c and a + 20b − c. A 12a−5b+5c B 12a+5b−5c C 13a+5b+4c D 39a−5b+4c E 39a+5b+4c (answer: 39a − 5b + 4c, option D)
3. Simplify (x² − y²)/(3x + 3y). (answer: (x−y)/3)
4. Simplify [(x²−y²)/(x+y)²] ÷ [(x−y)²/(3x+3y)] (division, per Teaching Notes Worked Example 5). A (x−y)/3 B x+y C 3/(x−y) D x−y (answer: 3/(x−y), option C)
5. Simplify (x² − 8x + 16)/(x² − 7x + 12). (answer: (x−4)/(x−3))
6. Simplify (1/x + 1/y)/(x + y). A 1/(x+y) B 1/xy C x+y D xy (answer: 1/xy, option B)
7. Evaluate (12ab − 4b²)/(2b² − 6ab). A −2 B −1 C 1 D 2 (answer: −2, option A)
8. Simplify t²/12 − t/3 + 1/3. A 3(t−2)² B (t−2)²/3 C t−2 D (t−2)²/12 (answer: (t−2)²/12, option D)
9. Simplify (2x+1)/2 − (3x−7)/9 − 5/18. A (2x+1)/1 B (2x+6)/1 C (2x+1)/3 D (2x+18)/3 E (2x+3)/3 (answer: (2x+3)/3, option E)
10. Simplify 4/(2x) − (2+x)/x. A −1 B −2x C 2x D (2−x)/x (answer: −1, option A)
11. Simplify 2/(3y) − 2x/3y + 3/y + 1/y (i.e. 2/3y − 2x/3y + 3/y + 1/y). A (3y−2x+3)/(3y) B (9x−2x+1)/(3y²) C (15y−2x−3)/y D (15y−2x+3)/(3y) E (15y+2x+3)/(3y²) (answer: (15y−2x+3)/(3y), option D)
12. If 4/(x−5) − 3/(x−6) is expressed as p/[(x−5)(x−6)], find p. A x+9 B x+5 C x−9 D x−39 (answer: x−9, option C)
13. Simplify: m/n + (m−1)/5n − (m−2)/10n, n≠0. A (m−3)/10n B 11m/10n C (m+1)/10n D (11m+4)/10n (answer: 11m/10n, option B)
14. Simplify 2a/(b−1) + a/(b+2). A 3a(b+1)/[(b−1)(b+2)] B a(b+1)/[(b−1)(b+2)] C 3b(a+1)/[(b−1)(b+2)] D ab(b+1)/[(b−1)(b+2)] E 3b(a−1)/[(b−1)(b+2)] (answer: 3a(b+1)/[(b−1)(b+2)], option A)
15. Express 2/(x+3) − 1/(x−2) as a single fraction. A (x−7)/(x²+x−6) B (x−1)/(x²+x−6) C (x−2)/(x²+x−6) D (x+7)/(x²+x−6) (answer: (x−7)/(x²+x−6), option A)
16. Simplify (x−4)/4 − (x−3)/6. A (x−18)/12 B (x−6)/12 C (x−18)/24 D (x−6)/24 (answer: (x−6)/12, option B)
17. Simplify (2+x)²/4 − (2−x)²/8. A (4x)/(4−x²) B (4−x²)/4 C −(4x)/(4−x²) D (8−4x)/(4−x²) (answer: this item is affected by OCR corruption in the source scan and the printed options do not correspond to (2+x)²/4 − (2−x)²/8 as stated — working the stem literally gives [2(2+x)² − (2−x)²]/8 = (x²+12x+4)/8, which matches none of the listed options; treat as a stem-transcription issue rather than force-fit an answer)
18. Express 2/(2+x) − 1/(2−x) as a single fraction. A (6−3x)/(2−x)² B (4−3x)/(2−x²) C (2−3x)/(2−x²) D (2−3x)/(4−x²) E (2−3x)/(4+x²) (answer: (2−3x)/(4−x²), option D — note: the source numerator is 2, not x; the curated stem previously read "x/(2+x)" which does not match this answer, corrected here)
19. Simplify 1/(x−1) − 2/(x²−1). A 1/(x−1) B 1/(x+1) C −1/(x²−1) D 1/(x²−1) E 1/(x²+1) (answer: 1/(x+1), option B)
20. Express 3 − x/y − y as a single fraction (i.e. 3 − x/y − y/1, combined form). A 3xy B (x−4y)/y C (4y+x)/y D (4y−x)/y (answer: (4y−x)/y, option D)
21. Simplify 5/(x−1) − 6/(x−2). A −(x+4)/(x²−3x+2) B (x+4)/(x²−3x+2) C (x+4)/(x²−3x+2) D (x−4)/(x²−3x+2) E (x−4)/(x²−3x+2) (answer: −(x+4)/(x²−3x+2), option A)
22. Simplify 1/(x−1) − 2/(x+2). A −x/[(x−1)(x+2)] B x/[(x−1)(x+2)] C (4−x)/[(x−1)(x+2)] D (4+x)/[(x−1)(x+2)] E (x−4)/[(x−1)(x+2)] (answer: (4−x)/[(x−1)(x+2)], option C)
23. Write [3x+2]/4 − (x−1)/4 − 5/12 as a single fraction. A (3x+2)/4 B (x−1)/3 C (x−1)/5 D (3x+2)/6 E (3x+2)/12 (answer: LCM of 4, 4, 12 is 12; [3(3x+2) − 3(x−1) − 5]/12 = (9x+6−3x+3−5)/12 = (6x+4)/12 = (3x+2)/6, option D)
24. Simplify a/4 + 2a/3 − a/12. A 2a/3 B a/4 C 5a/6 D a/12 (answer: 5a/6, option C)
25. If p = 2u/(1−u) and q = (1+u)/(1−u), express (p+q)/(p−q) in terms of u. (answer: (3u+1)/(u−1))
26. Given P = (x²−y²)/(x²+xy): (i) express P in simplest form; (ii) find P if x = −4, y = −6. (answer: (i) P = (x−y)/x (ii) P = −1/2)
27. If x, y, z are in the ratio 6:5:8, find (12x − 9z)/(4y + z). (answer: 0)
28. If x=3, y=2, z=4, find the value of 3x²−2y+z. A 17 B 27 C 35 D 71 (answer: 27, option B)
29. If x = (3m−2)/(m−1), express (x+1)/(2x−1) in terms of m. (answer: (4m−3)/(5m−3))
30. Evaluate [(a+b)/(a−b)]³ for a = −7, b = 3. A −8/125 B −4/10 C 8/125 D 16/125 E 2/5 (answer: −8/125, option A)
31. Given x = 2 and y = −⅕, evaluate x²y − 2xy. A 0 B 1/5 C 1 D 2 (answer: 0, option A — this is a trick/speed question: factorize first as xy(x−2), and since x = 2 exactly, the factor (x−2) is 0, making the whole expression 0 without any further arithmetic; the source's "x" value was mistranscribed as 2¼ in an earlier pass — it must be exactly 2 for the answer to be 0)
32. Evaluate (x² + x − 2)/(2x² + x − 3) when x = −1. A 2 B 1 C −1/2 D −1 E −2 (answer: 1, option B — substituting x=−1: numerator = 1−1−2 = −2, denominator = 2(1)+(−1)−3 = −2, so the value is −2/−2 = 1)

### Week 6: Equations involving fractions; undefined fractions (e.g. y is undefined when the denominator ax + c = 0)

**Teaching Notes**

An algebraic fraction a(x)/b(x) is **undefined** wherever its denominator b(x) = 0 (division by zero is impossible) — even after simplifying, always check the *original* denominator. To find where a fraction **equals zero**, set the numerator a(x) = 0 (after fully simplifying/factorizing) and solve, provided the denominator is not simultaneously zero there.

**Worked Examples**

1. Find the value of x for which (x+1)/(2x−1) is undefined.
**Step 1 — Recall that a fraction is undefined only where its denominator equals zero.**
**Step 2 — Set the denominator equal to zero:** 2x − 1 = 0.
**Step 3 — Solve for x:** 2x = 1, so x = 1/2.
**Answer: x = 1/2.**

2. Find the value(s) of x for which 2x²/[(x−2)(x+3)] is not defined.
**Step 1 — The denominator is already factorized:** (x−2)(x+3).
**Step 2 — Set each factor to zero in turn:** x − 2 = 0 gives x = 2; x + 3 = 0 gives x = −3.
**Answer: x = 2 or x = −3.**

3. For what value of x is (x+3)/(x²+10x−25) equal to zero?
**Step 1 — Recall that a fraction equals zero only when its numerator equals zero (provided the denominator isn't also zero there).**
**Step 2 — The numerator x+3 doesn't factorize any further, so set it to zero directly:** x + 3 = 0.
**Step 3 — Solve:** x = −3.
**Step 4 — Check the denominator isn't also zero at x = −3:** (−3)² + 10(−3) − 25 = 9 − 30 − 25 = −46 ≠ 0, so this value is valid.
**Answer: x = −3.**

4. For what value of x is (x² − 2x − 15)/(x² − 25) equal to zero?
**Step 1 — Factorize the numerator:** find two numbers multiplying to −15 and adding to −2: these are −5 and 3, so x² − 2x − 15 = (x−5)(x+3).
**Step 2 — Factorize the denominator, a difference of two squares:** x² − 25 = (x−5)(x+5).
**Step 3 — Cancel the common factor (x−5)** — noting that x ≠ 5, since that value makes the ORIGINAL denominator zero: (x−5)(x+3) / [(x−5)(x+5)] = (x+3)/(x+5).
**Step 4 — Set the simplified numerator to zero:** x + 3 = 0, so x = −3.
**Step 5 — Check this doesn't make the denominator zero:** at x = −3, x+5 = 2 ≠ 0, so it is valid.
**Answer: x = −3.**

**⚡ Shortcut & Speed Tips**

- "Undefined" always means denominator = 0 — always use the ORIGINAL (unsimplified) denominator, because a value that gets cancelled away during simplification is still excluded from the domain.
- "Equals zero" always means numerator = 0 (after simplifying) — never cross-multiply the whole fraction by zero; that destroys the equation.
- For a quadratic denominator, factorize it first, then read off both roots directly from the two factors — much faster than the quadratic formula.
- After solving an "equals zero" question, always plug your answer back into the denominator as a quick check — if it also zeroes the denominator, the fraction is undefined there, not zero, and you must reconsider.

**Gamified Exercise Bank**

1. Find the value of x for which the fraction (x+1)/(2x−1) is undefined. A −2 B −1/2 C 0 D 1/2 E 2 (answer: 1/2, option D)
2. For what value of x is the expression 2x−2/[(x−2)(x+3)] not defined? A x=4 or −2 B x=2 or −3 C x=3 or −2 D x=2 or −4 (answer: x=2 or −3, option B)
3. Find the value of x for which 2x² + y²)/(x²−4) is undefined. A x=5 B x=4 C x=3 D x=2 E x=1 (answer: x=2, option D)
4. Given y = 1 − 2x/(4x−3), find the value of x for which y is undefined. A 3 B 3/4 C −3/4 D −3 (answer: 3/4, option B)
5. Given y = (cr−px)/(aq−bp), the value of y is undefined if: A cr=px B cr>px C aq=bp D aq<bp E aq>bp (answer: aq=bp, option C)
6. Find the value of x for which the fraction (x²−9)/(2x²−7x+3) is undefined. (answer: x = 3 or x = 1/2)
7. For what value of x is the expression (2x−1)/(x+3) not defined? A 3 B 2 C 1/2 D −3 (answer: x = −3, option D)
8. Find the values of x for which (2x+5)/(4x²−9) is not defined. A x=3/2 or −3/2 B x=2/3 or −2/3 C x=2/5 or −2/5 D x=5/2 or 3/2 E x=5/2 or −3/2 (answer: x=3/2 or −3/2, option A)
9. For what value of x is (2x+1)/(12−5x−3x²) undefined? A x=5 or 1 B x=3 or −3/4 C x=−3 or 4/3 D x=−5 or 1 E x=5 or 3/4 (answer: set 12−5x−3x²=0, i.e. 3x²+5x−12=0; using the quadratic formula, x=(−5±√(25+144))/6=(−5±13)/6, giving x=−3 or x=4/3, option C)
10. For what values of x is (x²+1)/(x²−1) not defined? A x=−1 or 1 B x=1/2 or 0 C x=1/2 or 2 D x=−1/2 or 2 E x=0 or −2 (answer: x=−1 or 1, option A)
11. For what value(s) of x is (x+3)/(x²+10x−25) equal to zero? (answer: x = −3)
12. For what value(s) of x is (x²−2x−15)/(x²−25) equal to zero? (answer: x = −3)
13. Find the value of x for which (2x²+9x−11)/(6−4x) is zero. (answer: x = 1, from (x−1)(2x+11)=0 with x≠−11/2 rejected as it also zeroes denominator differently — take x = 1)

### Week 7: Review of first half term's work and periodic test

**Teaching Notes**

Consolidation week covering inequalities (Weeks 2–4), linear programming, and algebraic fractions (Weeks 5–6). *(limited source material for this sub-topic — it is a revision/assessment week by design.)*

**⚡ Shortcut & Speed Tips** *(a rapid-fire cheat sheet drawn from Weeks 2–6, for exam-style revision)*

- Inequalities: only flip the sign when multiplying/dividing by a NEGATIVE number — never for addition or subtraction.
- Quadratic inequalities: once factorized, use the "positive coefficient smiley-face" rule — negative (< 0) between the roots, positive (> 0) outside them, when the x² coefficient is positive.
- Linear programming: the corner-point theorem means you only ever need to evaluate the objective function at the vertices of the feasible region, never anywhere inside it — but always double-check that an intercept genuinely satisfies EVERY constraint before treating it as a corner.
- Algebraic fractions: factorize first, cancel second; for addition/subtraction find the LCM of the denominators first, and for division, "keep, change, flip".
- Undefined vs. zero: a fraction is undefined where its ORIGINAL denominator is zero, and equals zero where its (simplified) numerator is zero — never confuse the two conditions.

**Gamified Exercise Bank**

*(No new exercises — use a mixed review quiz drawn from Weeks 2–6 above.)*

### Week 8: Fractions (continued) — substitution in fractions; simultaneous equations involving fractions

**Teaching Notes**

**Substitution in algebraic fractions** comes in two forms: (a) substituting a *given* numeric value directly into an expression; (b) expressing one variable in terms of another (e.g. given z in terms of x, express a related fraction in terms of x). Always simplify algebraically before substituting where possible, to reduce arithmetic.

For **simultaneous equations involving fractions**, first clear denominators by multiplying through by the LCM, then solve by the usual elimination or substitution methods.

**Worked Examples**

1. If p = 2u/(1−u) and q = (1+u)/(1−u), express (p+q)/(p−q) in terms of u.
**Step 1 — Since p and q already share the same denominator, add their numerators directly for p+q:** p+q = [2u + (1+u)]/(1−u) = (3u+1)/(1−u).
**Step 2 — Subtract their numerators for p−q:** p−q = [2u − (1+u)]/(1−u) = (u−1)/(1−u).
**Step 3 — Divide (p+q) by (p−q) using "keep, change, flip":** [(3u+1)/(1−u)] ÷ [(u−1)/(1−u)] = (3u+1)/(1−u) × (1−u)/(u−1).
**Step 4 — Cancel the common factor (1−u):** = (3u+1)/(u−1).
**Answer: (3u + 1)/(u − 1).**

2. Given z = (3x−2)/(2x+3), express (2z+3)/(3z−2) in terms of x.
**Step 1 — Substitute z into 2z+3 and combine over the denominator (2x+3):** 2z+3 = 2(3x−2)/(2x+3) + 3 = [2(3x−2) + 3(2x+3)]/(2x+3).
**Step 2 — Expand the numerator:** 6x−4+6x+9 = 12x+5, so 2z+3 = (12x+5)/(2x+3).
**Step 3 — Substitute z into 3z−2 the same way:** 3z−2 = 3(3x−2)/(2x+3) − 2 = [3(3x−2) − 2(2x+3)]/(2x+3).
**Step 4 — Expand the numerator:** 9x−6−4x−6 = 5x−12, so 3z−2 = (5x−12)/(2x+3).
**Step 5 — Divide (2z+3) by (3z−2):** [(12x+5)/(2x+3)] ÷ [(5x−12)/(2x+3)] — the (2x+3) in both denominators cancels, leaving (12x+5)/(5x−12).
**Answer: (12x + 5)/(5x − 12).**

3. If x, y, z are in the ratio 6:5:8, evaluate (12x−9z)/(4y+z).
**Step 1 — Introduce a single scaling constant k, since the numbers are in ratio 6:5:8:** x = 6k, y = 5k, z = 8k.
**Step 2 — Substitute into the numerator:** 12x − 9z = 12(6k) − 9(8k) = 72k − 72k = 0.
**Step 3 — Substitute into the denominator:** 4y + z = 4(5k) + 8k = 20k + 8k = 28k.
**Step 4 — Divide:** 0/(28k) = 0.
**Answer: 0.**

4. Solve simultaneously: x/2 + y/3 = 4 and x/3 − y/6 = 3/2.
**Step 1 — Clear the denominators in the first equation by multiplying through by its LCM, 6:** 6(x/2) + 6(y/3) = 6(4) → 3x + 2y = 24.
**Step 2 — Clear the denominators in the second equation by multiplying through by its LCM, 6:** 6(x/3) − 6(y/6) = 6(3/2) → 2x − y = 9.
**Step 3 — Make y the subject of the simpler equation (2x − y = 9):** y = 2x − 9.
**Step 4 — Substitute into the other equation:** 3x + 2(2x − 9) = 24 → 3x + 4x − 18 = 24 → 7x = 42.
**Step 5 — Solve for x:** x = 6.
**Step 6 — Back-substitute to find y:** y = 2(6) − 9 = 3.
**Answer: x = 6, y = 3.**

**⚡ Shortcut & Speed Tips**

- When two expressions (like p and q, or 2z+3 and 3z−2) are built from the same denominator, combine their numerators directly rather than expanding each compound fraction separately from scratch.
- For ratio problems (x : y : z = a : b : c), always introduce one scaling constant k so x = ak, y = bk, z = ck — this turns three unknowns into one, and k very often cancels out completely in the final answer (as in Example 3).
- For simultaneous equations with fractions, clear each equation's denominators separately (multiply each equation by its own LCM) before combining them — trying to clear both at once in a single step is where most errors creep in.
- After solving simultaneous equations, substitute back into whichever equation is simplest (fewest terms/smallest numbers) to find the second unknown — it saves arithmetic.

**Gamified Exercise Bank**

1. If p = 2u/(1−u) and q = (1+u)/(1−u), express (p+q)/(p−q) in terms of u. (answer: (3u+1)/(u−1))
2. Given that x = (3m−2)/(m−1), express (x+1)/(2x−1) in terms of m. (answer: (4m−3)/(5m−3))
3. Given that Z = (3x−2)/(2x+3), express (2z+3)/(3z−2) in terms of x. (answer: (12x+5)/(5x−12) — see Teaching Notes Worked Example 2 for the full substitution)
4. If the numbers x, y, z are in the ratio 6:5:8, find (12x−9z)/(4y+z). (answer: 0)
5. If x=3, y=2 and z=4, find the value of 3x²−2y+z. (answer: 27)
6. Given that x = 2 and y = −⅕, evaluate x²y − 2xy. (answer: 0 — factorize as xy(x−2); since x=2, the factor (x−2)=0, so the whole expression is 0)
7. Evaluate (a+b)/(a−b))³ for a=−7, b=3. (answer: −8/125)
8. Evaluate (x²+x−2)/(2x²+x−3) when x = −1. (answer: 1 — substituting x=−1: numerator = 1−1−2 = −2, denominator = 2(1)+(−1)−3 = −2, so the value is −2/−2 = 1)
9. Solve a simultaneous system involving fractions, e.g. x/2 + y/3 = 4 and x/3 − y/2 = −1 (clear denominators first, then eliminate). (answer: multiplying through gives 3x+2y=24 and 2x−3y=−6; solving simultaneously gives x = 60/13, y = 66/13 — see Teaching Notes Worked Example 4 for a cleaner-numbered template of the same method)

### Week 9: Logic — simple and compound statements; logical operations and truth tables; conditional statements and indirect proofs

**Teaching Notes**

A **proposition** is a declarative sentence that is either true or false, but not both. A **simple proposition** contains no other proposition as a component; a **compound proposition** combines two or more simple propositions using **connectives**:

| Connective | Symbol | Name |
|---|---|---|
| not | ~ | Negation |
| and | ∧ | Conjunction |
| or | ∨ | Disjunction |
| if...then | → | Conditional |
| if and only if | ↔ | Biconditional |

**Truth tables** show every possible combination of truth values (T/F) for the component propositions, and the resulting truth value of the compound statement. For n propositions, there are 2ⁿ rows.

- **Negation (~p):** true when p is false, and vice versa.
- **Conjunction (p∧q):** true only when both p and q are true.
- **Disjunction (p∨q):** false only when both p and q are false.
- **Conditional (p→q):** false only when p is true and q is false.
- **Biconditional (p↔q):** true when p and q have the same truth value.

A proposition that is true for every possible arrangement of its parts' truth values is a **tautology**; one that is always false is a **contradiction**. Two propositions are **equivalent** if their biconditional is a tautology.

Logic statements can also be analysed with **Venn diagrams** — e.g. "All A are B" is shown as circle A entirely inside circle B — to test whether a stated conclusion is a **valid** deduction from given premises.

**Worked Examples**

1. Let p: "the baby is crying", q: "the boys are singing", r: "the dog is barking". Represent "If the dog is barking and the birds are not singing, then the baby is crying" symbolically.
**Step 1 — Identify each component proposition:** r = "the dog is barking"; ~q = "the birds are not singing" (the negation of q); p = "the baby is crying".
**Step 2 — Translate the connecting word "and" between the two conditions into the symbol ∧:** (r ∧ ~q).
**Step 3 — Translate "if...then" into the symbol →, joining the compound condition to the outcome:** (r ∧ ~q) → p.
**Answer: (r ∧ ~q) → p.**

2. Construct the truth table for p ∧ ~q.
**Step 1 — List all 4 possible combinations of truth values for p and q:** TT, TF, FT, FF.
**Step 2 — Work out ~q for each row (the opposite of q):** row TT → ~q=F; row TF → ~q=T; row FT → ~q=F; row FF → ~q=T.
**Step 3 — Apply AND (∧) row by row between p and ~q, remembering AND is true only when BOTH sides are true:** row1: p=T,~q=F → F; row2: p=T,~q=T → T; row3: p=F,~q=F → F; row4: p=F,~q=T → F.
**Answer: p∧~q is TT→F, TF→T, FT→F, FF→F** (true only when p is true and q is false).

3. Show that ~(p∧q) is equivalent to ~p∨~q (De Morgan's Law).
**Step 1 — Build the truth table for p∧q:** TT→T, TF→F, FT→F, FF→F.
**Step 2 — Negate every entry to get ~(p∧q):** TT→F, TF→T, FT→T, FF→T.
**Step 3 — Build the truth table for ~p∨~q:** for each row, find ~p and ~q, then apply OR (true unless BOTH are false): TT: ~p=F,~q=F → F∨F=F; TF: ~p=F,~q=T → F∨T=T; FT: ~p=T,~q=F → T∨F=T; FF: ~p=T,~q=T → T∨T=T.
**Step 4 — Compare the two final columns:** ~(p∧q) gives F,T,T,T and ~p∨~q gives F,T,T,T — identical in every row.
**Answer: the two statements are equivalent — ~(p∧q) ≡ ~p∨~q** (this is De Morgan's Law).

4. "All Northerners in Nigeria speak Hausa. Isa is a Northerner. Therefore Isa speaks Hausa." Test the validity of this conclusion using a Venn diagram.
**Step 1 — Draw the universal set U and two circles inside it: N (Northerners) and H (Hausa speakers).**
**Step 2 — Since "All Northerners speak Hausa" is given, draw circle N entirely INSIDE circle H** (N ⊂ H).
**Step 3 — Mark Isa as a point inside circle N**, since "Isa is a Northerner".
**Step 4 — Because N lies entirely inside H, any point inside N is automatically inside H too — so Isa's point also lies inside H.**
**Answer: the conclusion "Isa speaks Hausa" is VALID.**

**⚡ Shortcut & Speed Tips**

- Memorize the four connectives as one-liners: AND (∧) is true only when BOTH sides are true; OR (∨) is false only when BOTH sides are false; the conditional (→) is false only in the single case "true → false"; the biconditional (↔) is true only when both sides MATCH (both true or both false).
- De Morgan's Law shortcut: to negate an AND, flip it to OR and negate each part; to negate an OR, flip it to AND and negate each part — ~(p∧q) ≡ ~p∨~q, and ~(p∨q) ≡ ~p∧~q. Once memorized, this replaces building a full truth table.
- For "All A are B" Venn-diagram arguments, draw A completely inside B. Any argument reasoning FROM "in A" TO "in B" is valid; any argument reasoning backwards (from "in B" to "in A"), or using "not in A" to conclude "not in B", is the classic converse/inverse trap and is invalid.
- To check whether two statements are logically equivalent, just compare their final truth-table columns directly — if every row matches, they are equivalent; there's no need for the extra step of forming the biconditional and checking it is a tautology.

**Gamified Exercise Bank**

1. What is the negation of "John is older than me"? A John is not older than me B John is neither older than me C John is younger than me D John is my age mate (answer: John is not older than me, option A)
2. Which is a valid conclusion from "Nigerian footballers are good footballers"? A Joseph plays football in Nigeria, therefore he is a good footballer B Joseph is a good footballer, therefore he is a Nigerian footballer C Joseph is a Nigerian footballer, therefore he is a good footballer D Joseph plays good football, therefore he is a Nigerian footballer (answer: option C)
3. Given p: "the subject is difficult", q: "I will do my best". Which is equivalent to "Although the subject is difficult, I will do my best"? A p∧q B ~p∧q C p∧(~q) D p∨q (answer: p∧q, option A)
4. Represent symbolically (p: baby crying, q: boys singing, r: dog barking): (a) the dog is not barking (b) the baby is crying and the birds are singing (c) the dog is barking or the birds are singing (d) the dog is barking and the birds are not singing (e) if the dog is barking and the birds are not singing, then the baby is crying (f) the baby cries if and only if the dog barks. (answer: (a) ~r (b) p∧q (c) r∨q (d) r∧~q (e) (r∧~q)→p (f) p↔r)
5. Given s: "Sally is smart", t: "Tom is tall". What do (a) ~s (b) s∧t (c) (t∨s)→t mean in words? (answer: (a) Sally is not smart (b) Sally is smart and Tom is tall (c) If Tom is tall or Sally is smart, then Tom is tall)
6. Given p: "birds fly", q: "the sky is blue", r: "the grass is green". Write the sentence with the same meaning as: (a) ~p (b) p∧q (c) p∨q (d) p→q (e) p∧q∧r (f) p∧~q∧~r (g) ~p∨~r (h) (p∧q)→r (i) p↔q. (answer: (a) Birds do not fly (b) Birds fly and the sky is blue (c) Birds fly or the sky is blue (d) If birds fly then the sky is blue (e) Birds fly and the sky is blue and the grass is green (f) Birds fly and the sky is not blue and the grass is not green (g) Birds do not fly or the grass is not green (h) If birds fly and the sky is blue, then the grass is green (i) Birds fly if and only if the sky is blue)
7. Using p, q, r as above, write symbolic representations of: (a) the sky is blue and the grass is green (b) birds fly or the sky is blue (c) birds do not fly and the sky is not blue (d) if the grass is green and the sky is not blue then the birds do not fly. (answer: (a) q∧r (b) p∨q (c) ~p∧~q (d) (r∧~q)→~p)
8. Construct the truth table for p∧~q. (answer: TT→F, TF→T, FT→F, FF→F)
9. Construct the truth table for ~(p∧q). (answer: TT→F, TF→F, FT→F, FF→T)
10. Construct truth tables for: (a) p∧~q (b) p∧(q∨p) (c) (p∧q)∨r. (answer: (a) TT→F,TF→T,FT→F,FF→F (b) TT→T,TF→T,FT→F,FF→F (c) full 8-row table given in source)
11. Show that ~p∨q is equivalent to p→q. (answer: both truth tables give T,F,T,T for TT,TF,FT,FF — equivalent, confirmed a tautology when biconditional formed)
12. Illustrate "All Northerners in Nigeria speak Hausa; Isa is a Northerner; therefore Isa speaks Hausa" on a Venn diagram. Is the conclusion valid? (answer: valid)
13. In a Venn diagram, U = students in a school, G = class 3G, F = football team, H = hockey team. Which statement is false: A No hockey team member is on the football team B Only class 3G members are on the football team C All of class 3G are on the football team D Some hockey team members are in class 3G? (answer: option C is false)
14. Illustrate "All good Literature students are in the General Arts class" in a Venn diagram, then determine validity of: (i) Vivian is in General Arts, therefore she is a good Literature student (ii) Audu is not a good Literature student, therefore he is not in General Arts (iii) Kweku is not in General Arts, therefore he is not a good Literature student. (answer: (i) not valid (ii) not valid (iii) valid)
15. Given X: "all lazy students are careless", Y: "most dull students are lazy". Illustrate with Venn diagrams and determine validity of: (i) Stella is careless → Stella is lazy (ii) Osei is lazy → Osei is careless (iii) Kojo is dull → Kojo is lazy (iv) Kwame is lazy → Kwame is dull (v) Adwoa is lazy and dull → Adwoa is careless (vi) Fiifi is careless and dull → Fiifi is lazy. (answer: (i) not valid (ii) valid (iii) not valid (iv) not valid (v) valid (vi) not valid)
16. Consider X: "locally manufactured tyres are attractive", Y: "many locally manufactured tyres do not last long". Which Venn diagram illustrates these statements correctly (from four options)? (answer: the diagram where M (local) is a subset of R (attractive), and part of L (long-lasting) overlaps M and R)

### Week 10: Chord properties of circles — perpendicular bisector of a chord; distance of equal chords from the centre; angles subtended by two equal chords

**Teaching Notes**

Key chord properties (with O as centre):
- **Equal chords are equidistant from the centre**, and chords equidistant from the centre are equal (converse).
- **The perpendicular from the centre to a chord bisects the chord.**
- **Equal chords subtend equal angles at the centre.**
- **Tangent properties:** a tangent to a circle is perpendicular to the radius at the point of contact; two tangents drawn from an external point to a circle are equal in length.
- In a **cyclic quadrilateral**, opposite angles are supplementary (add to 180°), and an exterior angle equals the interior opposite angle.

**Worked Examples**

1. A chord AB = 16 cm in a circle of centre O is 6 cm from the centre. Find the radius.
**Step 1 — Draw the radius OM perpendicular to chord AB, meeting it at M.** By the property "the perpendicular from the centre to a chord bisects the chord", M is the midpoint of AB.
**Step 2 — Find the half-chord length:** AM = AB/2 = 16/2 = 8 cm.
**Step 3 — Note the given perpendicular distance:** OM = 6 cm.
**Step 4 — Apply Pythagoras' theorem in right triangle OMA** (right-angled at M, with OA as the hypotenuse — the radius): OA² = OM² + AM².
**Step 5 — Substitute the known values:** OA² = 6² + 8² = 36 + 64 = 100.
**Step 6 — Take the square root:** OA = √100 = 10.
**Answer: radius = 10 cm.**

2. Two equal chords AB and CD in a circle of radius 13 cm are 5 cm apart, on opposite sides of the centre. Find the length of each chord.
**Step 1 — Since the chords are equal and lie on opposite sides of the centre, the total 5 cm gap splits evenly:** each chord is 5/2 = 2.5 cm from the centre.
**Step 2 — Confirm this is consistent with the "equal chords are equidistant from the centre" property** (both chords are indeed the same distance, 2.5 cm, from O).
**Step 3 — Apply Pythagoras to find the half-chord:** (half-chord)² = radius² − distance² = 13² − 2.5² = 169 − 6.25 = 162.75.
**Step 4 — Take the square root:** half-chord = √162.75 ≈ 12.76 cm.
**Step 5 — Double it to get the full chord:** 2 × 12.76 ≈ 25.52 cm.
**Answer: each chord ≈ 25.52 cm.**

3. Chord PQ subtends 60° at the centre O of a circle of radius 8 cm. Find the length of PQ.
**Step 1 — Draw triangle OPQ:** OP = OQ = radius = 8 cm (both radii), with ∠POQ = 60°.
**Step 2 — Drop the perpendicular from O to PQ, meeting it at M** — this bisects both the chord and the angle at O (property of an isosceles triangle with a perpendicular from the apex), so ∠POM = 30° and PM = MQ.
**Step 3 — In right triangle OMP, use the sine ratio:** PM = OP × sin(∠POM) = 8 × sin 30°.
**Step 4 — Evaluate:** sin 30° = 0.5, so PM = 8 × 0.5 = 4 cm.
**Step 5 — Double PM to get the full chord:** PQ = 2 × 4 = 8 cm.
**Answer: PQ = 8 cm.** (Quick check: since ∠POQ = 60° and OP = OQ, triangle OPQ is actually equilateral, so PQ must equal the radius, 8 cm — confirming the answer instantly.)

4. PQRS is a cyclic quadrilateral with ∠P = 75°, ∠Q = 85°. Find ∠R and ∠S.
**Step 1 — Recall that opposite angles of a cyclic quadrilateral are supplementary:** ∠P + ∠R = 180°, and ∠Q + ∠S = 180°.
**Step 2 — Solve for ∠R:** ∠R = 180° − ∠P = 180° − 75° = 105°.
**Step 3 — Solve for ∠S:** ∠S = 180° − ∠Q = 180° − 85° = 95°.
**Answer: ∠R = 105°, ∠S = 95°.**

**⚡ Shortcut & Speed Tips**

- Whenever you know a chord's half-length and its perpendicular distance from the centre, you already have a right triangle with the radius as the hypotenuse — go straight to Pythagoras: radius² = (half-chord)² + (distance from centre)².
- Special-angle shortcut: if a chord subtends exactly 60° at the centre, the triangle formed by the two radii and the chord is equilateral, so the chord length always equals the radius — no sine calculation needed.
- "Equal chords ⟺ equal distance from the centre" works in both directions — use whichever fact the question gives you to find the other instantly.
- In any cyclic quadrilateral, once you know one angle you instantly know its OPPOSITE angle (180° minus it) — you don't need all four angles given to answer a "find the opposite angle" question.
- Two tangents drawn from the same external point are always equal in length, and the line from that external point to the centre always bisects the angle between the two tangents — remember this pair of facts together, since WAEC often tests both in the same question.

**Gamified Exercise Bank**

1. A chord of length 24 cm is 5 cm from the centre of a circle. Find the radius. (answer: 13 cm)
2. In a cyclic quadrilateral PQRS, ∠P = 110° and ∠R = 70°. Find ∠Q and ∠S. (answer: not fully determined without more data — ∠P+∠R=180° is already satisfied by the given values, so ∠Q+∠S=180° holds but a further condition is needed to split them individually)
3. Two equal chords of a circle are 8 cm apart and each is 12 cm long; find the radius if the chords are on opposite sides of the centre. (answer: each chord is 8/2=4 cm from the centre; half-chord=6 cm; radius=√(6²+4²)=√52=2√13≈7.21 cm)
4. State the relationship between equal chords and their distances from the centre of a circle. (answer: equal chords are equidistant from the centre, and vice versa)
5. In a circle with centre O and radius 10 cm, a chord AB is 6 cm from the centre. Calculate (a) the length of the chord (b) the angle subtended by the chord at the centre. (answer: (a) 16 cm (b) 2×cos⁻¹(0.6) ≈ 106.3°)
6. ABCD is a cyclic quadrilateral where ∠A = 2x+15° and ∠C = 3x−10°. Find (a) x (b) all four angles. (answer: (a) x = 35 (b) ∠A=85°, ∠C=95°; ∠B and ∠D need more data — not fully given in source)
7. In a circle, two chords AB and CD are equal. The perpendicular distance from the centre to AB is 4 cm and the radius is 5 cm. Find the length of each chord. (answer: 6 cm)
8. Draw a circle of radius 6 cm and construct two chords each of length 10 cm. Measure and calculate their distance from the centre. (answer: distance = √(6²−5²) = √11 ≈ 3.32 cm)
9. A chord of length 24 cm is 5 cm from the centre. Find the radius (repeat/verification exercise). (answer: 13 cm)
10. In a circle with centre O, chord AB = 16 cm and its distance from the centre is 6 cm. Find the radius. (answer: 10 cm)
11. PQRS is a cyclic quadrilateral. If ∠P = 75° and ∠Q = 85°, find ∠R and ∠S. (answer: ∠R=105°, ∠S=95°)
12. Two equal chords AB and CD of a circle with centre O and radius 13 cm are 5 cm apart. Find the length of each chord. (answer: ≈ 25.52 cm)
13. In a circle, chord PQ subtends an angle of 60° at the centre. If the radius is 8 cm, find the length of the chord. (answer: 8 cm)
14. In the diagram, ABCD is a cyclic quadrilateral with ∠BAD = 3x and ∠BCD = 2x. Find x and the two angles. (answer: 5x=180°, x=36°; ∠BAD=108°, ∠BCD=72°)
15. Two chords AB and CD of a circle intersect at right angles at point E inside the circle. Using the intersecting chords rule AE×EB = CE×ED, solve for an unknown length given specific data. (answer: depends on given data — apply AE×EB=CE×ED)
16. In a circle, two tangents from an external point P are each 15 cm long. If the radius is 9 cm, find the distance from P to the centre. (answer: √(15²+9²)=√306≈17.5 cm)
17. Two tangents TA and TB are drawn to a circle from external point T. If TA = 24 cm and the radius is 7 cm, calculate (a) the distance from T to the centre O (b) ∠ATB if ∠AOB = 120°. (answer: (a) √(24²+7²)=25 cm (b) ∠ATB = 180°−120° = 60°)
18. A chord AB of a circle makes an angle of 65° with the tangent at A. Calculate (a) the angle subtended by AB in the alternate segment (b) the angle at the centre if the angle at the circumference is half of it. (answer: (a) 65° (b) 130°)

### Week 11: Circle Theorems — angle properties of a circle; angle at the centre is twice the angle at the circumference; angles in the same segment; angles in a semicircle; opposite angles of a cyclic quadrilateral

**Teaching Notes**

Core circle theorems:
- **The angle which an arc subtends at the centre is twice the angle it subtends at the circumference** (on the same side).
- **Angles in the same segment of a circle, subtending the same arc, are equal.**
- **The angle in a semicircle is a right angle** (90°) — the angle subtended by a diameter at any point on the circumference.
- **Opposite angles of a cyclic quadrilateral are supplementary** (sum to 180°).
- **Alternate segment theorem** (used with tangents): the angle between a tangent and a chord equals the angle in the alternate segment.

**Worked Examples**

1. In a circle with centre O, ∠AOB = 140°. Points P and Q lie on the major arc AB. Find ∠APB and ∠AQB.
**Step 1 — Apply "the angle at the centre is twice the angle at the circumference standing on the same arc":** ∠AOB = 2 × ∠APB.
**Step 2 — Solve for ∠APB:** ∠APB = 140°/2 = 70°.
**Step 3 — Since P and Q both stand on the major arc and both subtend the same arc AB, apply "angles in the same segment are equal":** ∠AQB = ∠APB = 70°.
**Answer: ∠APB = ∠AQB = 70°.**

2. AB is a diameter; C is on the circle with ∠CAB = 32°. Find ∠ABC and ∠AOC.
**Step 1 — Since AB is a diameter, the angle at C in the semicircle is a right angle:** ∠ACB = 90°.
**Step 2 — Use the angle sum of triangle ABC:** ∠CAB + ∠ACB + ∠ABC = 180°.
**Step 3 — Substitute the known values:** 32° + 90° + ∠ABC = 180°.
**Step 4 — Solve for ∠ABC:** ∠ABC = 180° − 122° = 58°.
**Step 5 — Find ∠AOC using the centre/circumference relationship, with ∠ABC as the circumference angle standing on arc AC:** ∠AOC = 2 × ∠ABC = 2 × 58° = 116°.
**Answer: ∠ABC = 58°, ∠AOC = 116°.**

3. ABCD is a cyclic quadrilateral with ∠ABC = 75° and ∠BCD = 110°. Find ∠ADC and ∠DAB.
**Step 1 — Recall opposite angles of a cyclic quadrilateral are supplementary:** ∠ABC + ∠ADC = 180°, and ∠BCD + ∠DAB = 180°.
**Step 2 — Solve for ∠ADC:** ∠ADC = 180° − 75° = 105°.
**Step 3 — Solve for ∠DAB:** ∠DAB = 180° − 110° = 70°.
**Answer: ∠ADC = 105°, ∠DAB = 70°.**

4. Three points P, Q, R lie on a circle with PQ = PR; ∠PQR = 65°. Find ∠PRQ and ∠QPR.
**Step 1 — Since PQ = PR, triangle PQR is isosceles, so the base angles at Q and R are equal:** ∠PRQ = ∠PQR = 65°.
**Step 2 — Use the angle sum of a triangle:** ∠QPR + ∠PQR + ∠PRQ = 180°.
**Step 3 — Substitute:** ∠QPR + 65° + 65° = 180°.
**Step 4 — Solve:** ∠QPR = 180° − 130° = 50°.
**Answer: ∠PRQ = 65°, ∠QPR = 50°.**

**⚡ Shortcut & Speed Tips**

- "Centre angle = 2 × circumference angle" is the master theorem — the others fall straight out of it: angles in the same segment are equal because both equal half of the same centre angle; the angle in a semicircle is 90° because the "centre angle" for a diameter is 180°, so half of that is 90°. Learning this one rule covers most circle-theorem questions.
- Spot a diameter instantly from either clue: the phrase "AB is a diameter", OR a right angle sitting at the circumference — either one tells you the other for free.
- In a cyclic quadrilateral, "exterior angle = interior opposite angle" is just a restatement of "opposite angles are supplementary" — both the exterior angle and the opposite interior angle are supplementary to the same interior angle at that vertex, so use whichever form the question asks for without doing extra derivation.
- Isosceles triangles appear constantly inside circle diagrams whenever two radii are drawn (since OP = OQ = OR = radius, always) — mark the equal sides first and use base angles before reaching for any other circle theorem.
- Alternate segment theorem shortcut: the angle between a tangent and a chord equals the angle in the FAR (alternate) segment, not the near one — check that the two angles being compared sit on opposite sides of the chord, to avoid picking the wrong one.

**Gamified Exercise Bank**

1. Points A, B, C lie on a circle with ∠ABC = 48°. What is the angle subtended by arc AC at another point D on the major arc? (answer: 48°, angles in the same segment are equal)
2. In a circle with diameter PQ, if R is on the circle and ∠PRQ = 90°, what can you conclude about PQ? (answer: confirms PQ is a diameter — angle in a semicircle is 90°)
3. ABCD is a cyclic quadrilateral with ∠BAD = 95°. When BC is produced to E, find the exterior angle ∠DCE. (answer: 95°, since the exterior angle at C equals the interior opposite angle at A; wording corrected — the earlier draft named the given angle ∠ABC, which is not the vertex opposite C and cannot alone determine ∠DCE)
4. In a circle, chord AB subtends an angle of 40° at point C on the major arc. Find the angle at the centre O. (answer: 80°)
5. State the relationship between angles in the same segment of a circle. (answer: they are equal)
6. In a circle with centre O, ∠AOB = 140°. Points P and Q lie on the major arc AB. Find (a) ∠APB (b) ∠AQB (c) what can you say about them? (answer: (a) 70° (b) 70° (c) they are equal — angles in the same segment)
7. PQRS is a cyclic quadrilateral where ∠PQR = 105° and ∠QRS = 85°. Find (a) ∠RSP (b) ∠SPQ (c) the exterior angle when PQ is produced beyond Q. (answer: (a) 75°, since ∠PQR+∠RSP=180° (b) 95°, since ∠QRS+∠SPQ=180° (c) 75° — the exterior angle at Q on a straight line is supplementary to the interior angle ∠PQR (180°−105°=75°), matching the interior opposite angle ∠RSP; corrected from an earlier 105°, which was the interior angle itself, not its supplement)
8. In a circle, AB is a diameter and C is a point on the circle. If ∠CAB = 32°, find (a) ∠ACB (b) ∠ABC (c) ∠AOC. (answer: (a) 90° (b) 58° (c) 116°)
9. A tangent to a circle at point T makes an angle of 58° with chord TA. Point B is on the major arc. Find ∠TBA using the alternate segment theorem. (answer: 58°)
10. Three points P, Q, R lie on a circle such that PQ = PR. If ∠PQR = 65°, find (a) ∠PRQ (b) ∠QPR (c) the angle subtended by arc QR at the centre. (answer: (a) 65° (b) 50° (c) 100°)
11. In triangle PQR inscribed in a circle with PQ = QR, given ∠QPS = 35° and ∠PRS = 40° for a point S on the circle, find related angles. (answer: ∠PQR = 30°, from working shown in Teaching Notes-style example)
12. A tangent PT touches a circle at T; chord TA is drawn with ∠PTA = 42°; B is a point on the circle. Using the alternate segment theorem, find ∠TBA. (answer: 42°)
13. A tangent XY touches a circle at P; if ∠QPR = 75°, find related angles using the tangent-radius and bisection properties. (answer: ∠OPX = 90°, ∠OPQ = ∠OPR = 37.5°, ∠QPY = 52.5°)

### Weeks 12–13: Revision and Second Term Examinations

**Teaching Notes**

Comprehensive revision of Second Term topics: straight-line/curve gradients, linear inequalities (one and two variables) and linear programming, algebraic fractions (simplification, undefined values, equations), logic (propositions, truth tables, Venn diagrams), and circle geometry (chords, tangents, and angle theorems). *(limited source material for this sub-topic — it is a revision and examination period by design.)*

**⚡ Shortcut & Speed Tips** *(a final rapid-fire cheat sheet across the whole term, for exam revision)*

- Gradients: read m straight off y = mx + c, or use m = −a/b for ax + by = c; parallel lines share m, perpendicular lines have m₁ × m₂ = −1.
- Inequalities: flip the sign only when multiplying/dividing by a negative; for quadratics, use the "positive-coefficient smiley-face" rule (negative between the roots, positive outside).
- Linear programming: the optimum is always at a corner of the feasible region — but check every candidate corner against ALL constraints before evaluating the objective function there.
- Algebraic fractions: factorize before cancelling; find the LCM before adding/subtracting; "keep, change, flip" for division; a fraction is undefined where its original denominator is zero and equals zero where its simplified numerator is zero.
- Logic: memorize the four connective truth-tables as one-liners, and use De Morgan's Law (~(p∧q)≡~p∨~q) to skip full truth tables when negating compound statements.
- Circles: "centre angle = 2 × circumference angle" is the master theorem behind same-segment equality and the 90° semicircle angle; equal chords sit at equal distances from the centre; opposite angles of a cyclic quadrilateral sum to 180°; two tangents from one external point are always equal in length.

**Gamified Exercise Bank**

*(No new exercises — combine questions from Weeks 1–11 above for comprehensive revision and mock-exam practice.)*

## Third Term

### Week 1: Circle Theorems — tangent properties of a circle; angles in the alternate segment; two tangents from an external point

**Teaching Notes**

A **tangent** is a straight line that touches a circle at exactly one point, called the **point of contact**. Three key tangent properties:

- **Property 1:** A tangent to a circle is perpendicular to the radius drawn to the point of contact.
- **Property 2:** Two tangents drawn from an external point to a circle are equal in length. If PA and PB are tangents from external point P, then PA = PB, and OP (the line from the external point to the centre) bisects both ∠APB and ∠AOB.
- **Property 3 (Alternate Segment Theorem):** The angle between a tangent and a chord drawn from the point of contact equals the angle in the alternate segment (the angle subtended by the chord on the other side, in the far arc).

**Worked Examples**

1. Two tangents PA and PB are drawn from an external point P to a circle with centre O. If PA = 12 cm and OP = 13 cm, find the radius.
   **Step 1 — Identify the right angle:** Since PA is a tangent and OA is the radius to the point of contact, Property 1 gives ∠OAP = 90°. So triangle OAP is right-angled at A.
   **Step 2 — Set up Pythagoras' theorem:** The hypotenuse of the right triangle is OP (from centre to external point), so OP² = OA² + PA².
   **Step 3 — Substitute known values:** 13² = r² + 12² → 169 = r² + 144.
   **Step 4 — Solve for r²:** r² = 169 − 144 = 25.
   **Step 5 — Take the square root:** r = √25 = 5.
   **Answer: r = 5 cm.**

2. In a circle with centre O, AB is a diameter and C is a point on the circle with ∠CAB = 35°. Find ∠CBA.
   **Step 1 — Apply the semicircle theorem:** Because AB is a diameter, the angle it subtends at any point C on the circle is a right angle, so ∠ACB = 90°.
   **Step 2 — Write the angle sum of triangle ABC:** ∠CAB + ∠CBA + ∠ACB = 180°.
   **Step 3 — Substitute the known angles:** 35° + ∠CBA + 90° = 180°.
   **Step 4 — Solve for ∠CBA:** ∠CBA = 180° − 90° − 35° = 55°.
   **Answer: ∠CBA = 55°.**

3. A tangent PT touches a circle at T. A chord TA makes an angle of 40° with the tangent. Find the angle subtended by the chord at a point B on the major arc.
   **Step 1 — Identify the tangent–chord angle:** ∠PTA is the angle between the tangent PT and the chord TA at the point of contact T, and it is given as 40°.
   **Step 2 — Identify the alternate segment:** Point B lies on the major arc, on the opposite side of chord TA from the tangent-side angle ∠PTA — this is exactly the "alternate segment" referred to in the theorem.
   **Step 3 — Apply the Alternate Segment Theorem:** the tangent–chord angle equals the angle subtended by the same chord in the alternate segment, so ∠TBA = ∠PTA.
   **Step 4 — State the value:** ∠TBA = 40°.
   **Answer: ∠TBA = 40°.**

4. Two tangents TA and TB are drawn to a circle from an external point T, with TA = 24 cm and radius = 7 cm. Find the distance from T to the centre O.
   **Step 1 — Identify the right triangle:** Since TA is tangent at A, ∠OAT = 90°, so triangle OAT is right-angled at A.
   **Step 2 — Apply Pythagoras:** OT² = OA² + TA² = 7² + 24² = 49 + 576 = 625.
   **Step 3 — Take the square root:** OT = √625 = 25.
   **Answer: OT = 25 cm.** (Notice this is a 7–24–25 Pythagorean triple — recognising common triples like 3-4-5, 5-12-13, 7-24-25, 8-15-17 saves time on tangent-length questions.)

**⚡ Shortcut & Speed Tips**

- **Spot the right angle instantly:** the moment you see "tangent" and "radius" (or "tangent" and "centre") meeting at the point of contact, mark a 90° box there — this converts most tangent problems into a straight Pythagoras calculation without extra construction.
- **Learn the Pythagorean triples cold:** 3-4-5, 5-12-13, 7-24-25, 8-15-17, and their multiples (6-8-10, 9-12-15, etc.) appear constantly in tangent-length questions — recognising them means skipping the calculator entirely.
- **Alternate segment = "same letter, opposite side":** the tangent–chord angle always equals the inscribed angle standing on the *same chord* but on the *far side* of it — never the near side. If your answer angle is on the same side as the given tangent–chord angle, you've picked the wrong arc.
- **Semicircle angle is a free 90°:** any time a chord is stated (or shown) to be a diameter, immediately write the angle at the circumference as 90° before doing anything else — it usually unlocks the rest of the triangle by angle-sum.
- **Two tangents from one point = isosceles triangle for free:** PA = PB always, so triangle APB is isosceles, and OP bisects both ∠APB and ∠AOB — use this to halve an angle instantly instead of resolving two separate triangles.

**Gamified Exercise Bank**

1. State the relationship between a tangent to a circle and the radius at the point of contact. (answer: they are perpendicular — the tangent meets the radius at 90° at the point of contact)
2. Two tangents PA and PB are drawn from an external point P to a circle with centre O. If PA = 12 cm and OP = 13 cm, find the radius of the circle. (answer: 5 cm)
3. AB is a diameter of a circle. If point C is on the circle and ∠BAC = 42°, find ∠BCA and ∠ABC. (answer: ∠BCA = 90°, ∠ABC = 48°)
4. A tangent to a circle makes an angle of 55° with a chord drawn from the point of contact. Find the angle subtended by the chord in the alternate segment. (answer: 55°)
5. A tangent PT touches a circle at T. A chord TA makes an angle of 40° with the tangent. Find the angle subtended by the chord at a point B on the major arc. (answer: 40°)
6. In a circle with centre O, diameter PQ = 20 cm. Point R is on the circle such that ∠PRQ = 90° and PR = 12 cm. Find RQ. (answer: 16 cm, by Pythagoras: √(20² − 12²) = √256 = 16)
7. Draw a circle of radius 4 cm. From a point 10 cm from the centre, draw tangents to the circle. Calculate the length of each tangent. (answer: √(10² − 4²) = √84 ≈ 9.17 cm)
8. Prove, using a diagram, that the angle in a semicircle is 90°. (answer: proof — since OA = OB = OP (radii), triangles OAP and OBP are isosceles; letting the base angles be x and y, angle sum in triangle ABP gives 2x + 2y = 180°, so x + y = 90° = ∠APB)
9. AB//CE is drawn with TS a tangent to a circle at A, where ∠AEC = 5x°, ∠ADB = 60°, and ∠TAE = x°. Find the value of x. (answer: x = 15, WAEC 2010)
10. MP is a diameter of a circle, MQ is a straight line, ∠NMP = 42°, and NQ is a tangent to the circle at N with ∠NQP = x°. Find x. (answer: x = 60°, WAEC 2014)
11. TU is a tangent to a circle. If ∠RVU = 100° and ∠URS = 36°, calculate ∠STU. (answer: 44°, WAEC 2012)
12. TS is a tangent to a circle at S, with O the centre. If ∠TSP = 21° and ∠RQP = 100°, find (i) ∠SPR (ii) ∠QSR, giving reasons. (answer: (i) 79° (ii) 11°, WAEC 2014)
13. XYT is a tangent to a circle centre O, radius 5 cm. /YT/ = 12 cm and ∠ZYT = 58°. What is the length of OT? (answer: 13 cm, using Pythagoras: OT² = OY² + YT² = 5² + 12² = 169)
14. O is the centre of a circle; PR is a tangent to the circle at Q, and ∠SOQ = 86°. Calculate ∠SQR. (answer: 43°, WAEC 2014)
15. PQ is a tangent to a circle at R, and UT is parallel to PQ. If ∠TRQ = x°, find ∠URT in terms of x. (answer: (180 − 2x)°, WAEC 2014)
16. XMY is a triangle inscribed in a circle. LMN is a tangent to the circle at M, /XY/ = /XM/, and ∠XML = 42°. Find the value of x (= ∠YMN). (answer: 84°, WAEC 2009)
17. TD is a tangent to a circle ABCT, with AB = AT, BT = BC, and ∠ABT = 36°. Calculate ∠CTD. (answer: 36°, WAEC 2012)
18. ATB is a tangent to a circle at T. If ∠ATS = 75°, ∠BTP = 40°, and ∠PSQ = 12°, calculate the size of (i) ∠SRP (ii) ∠SQP (iii) ∠SPQ. (answer: (i) 115° (ii) 115° (iii) 53°, WAEC 2013)
19. Two chords AB and CD of a circle intersect (produced) outside the circle at point Q. State the intersecting-secants relationship connecting QA, QB, QC and QD. (answer: QA × QB = QC × QD, the intersecting chords/secants theorem)

### Week 2: Trigonometry — derivation of the sine rule and cosine rule and their applications

**Teaching Notes**

**Standard triangle notation:** vertices A, B, C; the side opposite each vertex is labelled with the corresponding lowercase letter (a opposite A, b opposite B, c opposite C).

**Sine Rule:** a/sin A = b/sin B = c/sin C. Use it when given (i) two angles and one side (AAS/ASA), or (ii) two sides and a non-included (opposite) angle (SSA — watch for the ambiguous case where two solutions are possible).

**Cosine Rule:** a² = b² + c² − 2bc cos A (and cyclic versions for b², c²). Rearranged to find an angle: cos A = (b² + c² − a²)/(2bc). Use it when given (i) two sides and the included angle (SAS), or (ii) all three sides (SSS). When the included angle is 90°, the cosine rule reduces to Pythagoras' theorem.

**Worked Examples**

1. In triangle ABC, A = 40°, B = 65°, and side a = 8 cm. Find side b.
   **Step 1 — Write the sine rule relating the two known angles and sides:** a/sin A = b/sin B.
   **Step 2 — Substitute the known values:** 8/sin 40° = b/sin 65°.
   **Step 3 — Make b the subject:** b = (8 × sin 65°)/sin 40°.
   **Step 4 — Evaluate the sines:** sin 65° ≈ 0.9063, sin 40° ≈ 0.6428.
   **Step 5 — Compute:** b = (8 × 0.9063)/0.6428 = 7.251/0.6428 ≈ 11.28.
   **Answer: b ≈ 11.28 cm.**

2. In triangle PQR, p = 7 cm, q = 9 cm, and R = 58°. Find side r.
   **Step 1 — Choose the cosine rule** because two sides and the included angle (R, between p and q) are known.
   **Step 2 — Write the formula:** r² = p² + q² − 2pq cos R.
   **Step 3 — Substitute:** r² = 7² + 9² − 2(7)(9)cos 58° = 49 + 81 − 126cos58°.
   **Step 4 — Evaluate cos 58° ≈ 0.5299 and the product:** 126 × 0.5299 ≈ 66.77.
   **Step 5 — Combine:** r² = 130 − 66.77 = 63.23.
   **Step 6 — Take the square root:** r = √63.23 ≈ 7.95.
   **Answer: r ≈ 7.95 cm.**

3. In triangle ABC, a = 12 cm, b = 15 cm, c = 18 cm. Find angle A.
   **Step 1 — Choose the cosine rule (angle form)** because all three sides are known (SSS).
   **Step 2 — Write the rearranged formula:** cos A = (b² + c² − a²)/(2bc).
   **Step 3 — Substitute:** cos A = (15² + 18² − 12²)/(2×15×18) = (225 + 324 − 144)/540.
   **Step 4 — Simplify the numerator and denominator:** cos A = 405/540 = 0.75.
   **Step 5 — Take the inverse cosine:** A = cos⁻¹(0.75).
   **Step 6 — Evaluate:** A ≈ 41.41°.
   **Answer: A ≈ 41.41°.**

**⚡ Shortcut & Speed Tips**

- **Count what's given, not what's asked, to pick the rule:** two angles + any side (AAS/ASA) or two sides + a non-included angle (SSA) → sine rule; two sides + the included angle (SAS) or all three sides (SSS) → cosine rule. Memorise "SSA/AAS = sine, SAS/SSS = cosine" as a single rule of thumb.
- **The included angle is the giveaway for cosine rule:** it's the angle sandwiched *between* the two given sides — if the given angle isn't between the two given sides, you need the sine rule instead (and must find the third angle by angle-sum first if solving for a side).
- **Third angle is free:** whenever two angles are given, get the third by 180° − (sum of the other two) *before* touching the sine rule — many marks are lost by forgetting this "free" step.
- **Watch for the ambiguous (SSA) case:** when using the sine rule with two sides and a non-included angle, sin⁻¹ gives one acute answer, but 180° − that angle is often also valid — always check whether both fit inside a 180° angle sum before rejecting the obtuse case.
- **90° is a shortcut, not a special case:** if the included angle in the cosine rule is 90°, cos 90° = 0, so the whole "−2bc cos A" term vanishes and the cosine rule collapses straight into Pythagoras — recognise this to save calculator steps.

**Gamified Exercise Bank**

1. In triangle ABC, A = 45°, C = 70°, and b = 12 cm. Use the sine rule to find side a. (answer: B = 180° − 45° − 70° = 65°; a/sin A = b/sin B → a = 12 sin45°/sin65° = 12(0.7071)/0.9063 ≈ 9.36 cm)
2. A triangle has sides p = 9 cm, q = 12 cm, and R = 55°. Find side r using the cosine rule. (answer: r² = 81 + 144 − 216cos55° ≈ 101.06, r ≈ 10.05 cm)
3. In triangle PQR, p = 8 cm, q = 10 cm, and r = 12 cm. Find angle P. (answer: cos P = (100+144−64)/240 = 0.75, P ≈ 41.4°)
4. State when you would use the sine rule instead of the cosine rule. (answer: sine rule for two angles + one side, or two sides + a non-included angle; cosine rule for two sides + included angle, or three sides)
5. In triangle XYZ, X = 50°, Y = 60°, and x = 15 cm. Find y. (answer: y = 15 sin60°/sin50° ≈ 16.96 cm)
6. In triangle ABC, a = 20 cm, B = 48°, and C = 67°. Find: (a) A (b) side b (c) side c. (answer: (a) A = 65° (b) b = 20 sin48°/sin65° ≈ 16.4 cm (c) c = 20 sin67°/sin65° ≈ 20.3 cm)
7. A triangle has sides of length 13 cm, 14 cm, and 15 cm. Calculate (a) the largest angle (b) the smallest angle (c) the remaining angle. (answer: (a) ≈ 59.5° (b) ≈ 53.1° (c) ≈ 67.4°, opposite 15, 13, 14 cm respectively — angles sum to 180°)
8. In triangle PQR, p = 7.5 cm, r = 10.2 cm, and Q = 72°. Find side q. (answer: q² = 7.5² + 10.2² − 2(7.5)(10.2)cos72° ≈ 104.85, q ≈ 10.24 cm)
9. Two sides of a triangle are 18 cm and 24 cm. If the angle between them is 58°, find the third side. (answer: √(18²+24²−2×18×24×cos58°) ≈ 21.06 cm)
10. Two sides of a triangle are 8 cm and 11 cm, with an included angle of 64°. Find the third side. (answer: 10.38 cm)
11. In triangle ABC, a = 10 cm, b = 14 cm, and A = 38°. Find B (ambiguous case). (answer: B ≈ 59.57° or 120.43°; since b > a, B is acute, so B ≈ 59.57°)
12. A triangle has sides 5 cm, 7 cm, and 9 cm. Find the largest angle. (answer: ≈ 95.74°, opposite the 9 cm side)
13. Two ships leave a port at the same time. One travels at 30 km/h on a bearing of 040° and the other at 25 km/h on a bearing of 130°. How far apart are they after 2 hours? (answer: ≈ 78.10 km, using Pythagoras since the bearings are 90° apart)
14. QRS is a triangle with QS = 12 m, ∠RQS = 30°, and ∠QRS = 45°. Calculate the length RS. (answer: RS = 12sin30°/sin45° = 6√2 cm)
15. The two base angles of a triangle are each 30°, and the longest side is 10 cm. Calculate the length of each of the other two sides. (answer: 10√3/3 cm, using sine rule with the third angle = 120°)
16. In an acute-angled triangle PQR, PQ = 10 m, PR = 15 m, and ∠PRQ = 40°. Evaluate ∠PQR. (answer: ≈ 74.62°)
17. In triangle XZ with two sides 2 m and 1 m enclosing an angle of 120°, find /XZ/. (answer: √7 m ≈ 2.65 m)
18. ABC is a triangle in which ∠BAC = 75°, /AB/ = 3 cm and /AC/ = 4 cm. Calculate /BC/ correct to one decimal place. (answer: 4.3 cm, WAEC 2014)
19. Calculate the angle marked P, given AB = 4 cm, AC = 6 cm, and ∠ACB = 30°. (answer: 48.6°, WAEC 2006)
20. The hypotenuse of a right-angled triangle is 17 cm and one of the angles is 43°. Find (i) the third angle (ii) the side opposite the smallest angle. (answer: (i) 47° (ii) ≈ 11.59 cm)
21. In triangle ABC, a = 8 cm, b = 12 cm, C = 82°. Find c. (answer: ≈ 13.46 cm, WAEC 2006)
22. Two sides of a triangle measuring 10 cm and 15 cm enclose an angle of 55°. (i) Calculate the third side (ii) find the two other angles. (answer: (i) ≈ 12.37 cm (ii) A ≈ 83.36°, C ≈ 41.47°, WAEC 2009)
23. In the diagram, /BC/ = 2 cm, /AB/ = 3 cm and ∠ACD = 150°. Find the value of sin A. (answer: ∠ACD is the exterior angle at C, so the interior angle ∠ACB = 180° − 150° = 30°; by the sine rule, BC/sin A = AB/sin(ACB) → sin A = BC × sin(ACB)/AB = 2 × sin30°/3 = 2(0.5)/3 = 1/3)
24. In triangle XYZ, /XY/ = 9 cm, /XZ/ = 10 cm and ∠YXZ = 75°. Find /YZ/. (answer: by the cosine rule, YZ² = 9² + 10² − 2(9)(10)cos75° = 81 + 100 − 180(0.2588) = 181 − 46.59 = 134.41, so YZ ≈ 11.59 cm)

### Week 3: Bearing and Distances; Elevation and Depression

**Teaching Notes**

A **bearing** is the direction of one point from another, always measured from **North**, always **clockwise**, and written as a **three-figure bearing** (000°–360°, e.g. 005°, 045°, 320°) or as a **compass bearing** (N/S, an angle, then E/W, e.g. N40°E, S30°W — always start with N or S, end with E or W).

**Conversions:** 1st quadrant (000°–090°) → N θ°E (θ = bearing); 2nd quadrant (090°–180°) → S θ°E (θ = 180° − bearing); 3rd quadrant (180°–270°) → S θ°W (θ = bearing − 180°); 4th quadrant (270°–360°) → N θ°W (θ = 360° − bearing).

**Back bearings:** the bearing of A from B, given the bearing of B from A — if the bearing is < 180°, add 180°; if ≥ 180°, subtract 180°.

An **angle of elevation** is measured upward from the horizontal to an object above; an **angle of depression** is measured downward from the horizontal to an object below. Because the two horizontals are parallel, the **angle of elevation from A to B equals the angle of depression from B to A** (alternate angles). Both are solved with SOHCAHTOA or Pythagoras in the right triangle formed.

**Worked Examples**

1. Convert 055° to a compass bearing, and N65°W to a three-figure bearing.
   **Step 1 — Locate 055° on the compass:** it lies in the 1st quadrant (000°–090°), so the compass form is N θ°E with θ = the bearing itself.
   **Step 2 — Write the compass bearing:** N55°E.
   **Answer (a): N55°E.**
   **Step 1 — Locate N65°W on the compass:** N/W means the 4th quadrant (270°–360°), where the three-figure bearing = 360° − θ.
   **Step 2 — Substitute:** 360° − 65° = 295°.
   **Answer (b): 295°.**

2. A ship sails from port P on a bearing of 040° for 80 km to reach point Q. Find how far east and how far north Q is from P.
   **Step 1 — Draw the right triangle:** the bearing 040° is measured clockwise from North, so the "north" leg is adjacent to the 40° angle and the "east" leg is opposite it, with the 80 km path as the hypotenuse.
   **Step 2 — Find the eastward distance (opposite side):** East = 80 × sin40°.
   **Step 3 — Evaluate:** sin40° ≈ 0.6428, so East ≈ 80 × 0.6428 = 51.42 km.
   **Step 4 — Find the northward distance (adjacent side):** North = 80 × cos40°.
   **Step 5 — Evaluate:** cos40° ≈ 0.7660, so North ≈ 80 × 0.7660 = 61.28 km.
   **Answer: East ≈ 51.42 km; North ≈ 61.28 km.**

3. From a point 50 m from the base of a tower, the angle of elevation to the top is 28°. Find the height of the tower.
   **Step 1 — Draw the right triangle:** the horizontal distance (50 m) is adjacent to the 28° angle of elevation, and the height h is opposite it.
   **Step 2 — Choose the trig ratio:** tan(angle) = opposite/adjacent, so tan28° = h/50.
   **Step 3 — Make h the subject:** h = 50 × tan28°.
   **Step 4 — Evaluate tan28° ≈ 0.5317:** h ≈ 50 × 0.5317 = 26.59.
   **Answer: h ≈ 26.59 m.**

4. From the top of a lighthouse 60 m high, the angle of depression to a boat is 25°. How far is the boat from the base?
   **Step 1 — Use alternate angles:** the angle of depression from the top (25°) equals the angle of elevation from the boat to the top, also 25°.
   **Step 2 — Draw the right triangle:** the lighthouse height (60 m) is opposite the 25° angle; the distance d from the base to the boat is adjacent.
   **Step 3 — Choose the trig ratio:** tan25° = 60/d.
   **Step 4 — Make d the subject:** d = 60/tan25°.
   **Step 5 — Evaluate tan25° ≈ 0.4663:** d ≈ 60/0.4663 ≈ 128.65.
   **Answer: d ≈ 128.65 m.**

**⚡ Shortcut & Speed Tips**

- **"N-A-C-N" for quadrant conversion:** going clockwise from North (1st→4th quadrant) the compass letters cycle N→S→S→N and the reference angle formula cycles θ, (180−θ), (θ−180), (360−θ) — sketch a quick compass rose and mark which quadrant the bearing falls in before applying any formula; never memorise the four formulas in isolation.
- **Back bearing rule of thumb:** "less than 180, add 180; 180 or more, subtract 180" — this single line replaces re-drawing the whole diagram every time you need the reverse bearing.
- **Bearing problems with a 90° angle between paths are secretly Pythagoras:** if two bearings differ by exactly 90° (e.g. one path is 040° and the other 130°, or one is N30°E and the other S60°E), the angle at the common point is 90° — skip the cosine rule and go straight to Pythagoras for the distance between the endpoints.
- **Elevation = depression (alternate angles):** never resolve the "looking down" triangle from scratch — the angle of depression measured at the top always equals the angle of elevation measured at the bottom, so you can immediately transfer the angle to whichever right triangle is easier to solve.
- **SOH-CAH-TOA is always in play for elevation/depression:** height and horizontal distance are almost always opposite/adjacent to the given angle, so tan is used far more often than sin or cos — reach for tan first unless the *slant/hypotenuse* distance is what's given or asked.
- **Two elevations from two spots → subtraction trick:** for "closer point sees a bigger angle" problems, set up h = d·tanθ₁ = (d+x)·tanθ₂ and solve the two equations together rather than guessing — this is the standard method examiners expect.

**Gamified Exercise Bank**

1. Convert the following bearings: (a) 215° to compass bearing (b) S20°E to three-figure bearing. (answer: (a) S35°W (b) 160°)
2. Point B is on a bearing of 120° from point A. Find the bearing of A from B. (answer: 300°)
3. Town B is 50 km from town A on a bearing of 135°. Town C is 40 km from A on a bearing of 225°. Find the distance BC. (answer: ≈ 64.03 km, Pythagoras since the angle at A is 90°)
4. A plane flies from airport X to airport Y on a bearing of 065° for 200 km, then from Y to Z on a bearing of 155° for 150 km. Find (a) the distance XZ (b) the bearing of Z from X. (answer: (a) 250 km (b) ≈ 102°)
5. From a port P, a ship sails 60 km on bearing N30°E to point Q, then 80 km on bearing S60°E to point R. Find the distance PR. (answer: 100 km)
6. Point A is 100 km from point B on a bearing of 240°. What is the bearing of B from A? (answer: 060°)
7. Convert (a) 315° to compass bearing (b) S75°W to three-figure bearing. (answer: (a) N45°W (b) 255°)
8. Define the term "bearing" and state two key principles of bearings. (answer: a bearing is the direction of one point relative to another, measured as an angle; always measured from North, always measured clockwise)
9. A town Y is on a bearing of 300° from town X. What is the bearing of X from Y? (answer: 120°)
10. Convert the following bearings: (a) 035° to compass bearing (b) 260° to compass bearing (c) N20°W to three-figure bearing (d) S50°E to three-figure bearing. (answer: (a) N35°E (b) S80°W (c) 340° (d) 130°)
11. Find the back bearing for each: (a) 040° (b) 175° (c) 250°. (answer: (a) 220° (b) 355° (c) 070°)
12. A ship sails from port A on a bearing of 120° for 60 km to reach point B. Calculate (a) how far south B is from A (b) how far east B is from A. (answer: (a) 60cos60°=30 km (b) 60sin60°≈51.96 km)
13. Point Q is 80 km from point P on a bearing of 210°. Point R is 50 km from P on a bearing of 300°. Find the distance QR. (answer: angle QPR = 300° − 210° = 90°, so by Pythagoras QR = √(80²+50²) = √8900 ≈ 94.34 km)
14. Express the true bearing of 250° as a compass bearing. (answer: S70°W, WAEC 1997)
15. The bearing S40°E is the same as which three-figure bearing? (answer: 140°)
16. The bearing of a point A from a point B is 042°. Calculate the bearing of B from A. (answer: 222°, WAEC 2010)
17. A hunter walked 250 m on a bearing of 042°. Calculate, to the nearest metre, (i) the vertical (northward) distance moved (ii) the horizontal (eastward) distance covered. (answer: (i) 250cos42°≈186 m (ii) 250sin42°≈167 m)
18. A village Y is 15 km from a point X on a bearing of 025°. Village Z is 20 km from X on a bearing of 115°. Calculate the distance YZ. (answer: 25 km, Pythagoras since the angle at X is 90°, WAEC 2006)
19. A boat sails 24 km from a port X on a bearing of 065° and then 10 km on a bearing of 155°. What is the distance of the boat from X? (answer: 26 km, WAEC 2005)
20. Y is 60 km away from X on a bearing of 135°. Z is 80 km away from X on a bearing of 225°. Find (a) the distance ZY (b) the bearing of Z from Y. (answer: (a) 100 km (b) 262°, WAEC 2007)
21. A ship sails 5 km due west then 7 km due south. Find, to the nearest degree, its bearing from the original position. (answer: 216°, WAEC 2014)
22. A from Q is 120 km from a town B in the direction 050°. What is the bearing of B from Q? (answer: 050°, it is already stated as the bearing from Q)
23. From the top of a lighthouse 75 m high, a ship is observed at an angle of depression of 18°. How far is the ship from the base of the lighthouse? (answer: 75/tan18° ≈ 230.85 m)
24. A ladder 6 m long leans against a wall, making an angle of 65° with the horizontal ground. Calculate, to 3 s.f., how far up the wall the ladder reaches. (answer: 5.44 m, WAEC 2003)
25. A boy flies a kite with a 50 m string that makes an angle of 30° with the ground. What is the height of the kite above the ground? (answer: 25 m, WAEC 2005)
26. The shadow of an electric pole 75√3 m high is 75 m long. Determine the angle of elevation of the sun. (answer: 60°, WAEC 2014)
27. The shadow of a flagpole 25 m long is 18 m. What is the angle of elevation of the top of the flagpole, correct to 1 decimal place? (answer: 54.2°, WAEC 2006)
28. A ladder leans against a vertical wall making an angle whose cosine is 0.6 with the ground; the foot of the ladder is 1.2 m from the wall. Calculate the length of the ladder. (answer: 2.00 m, WAEC 2006)
29. A flagpole XY of length 12 m tilts towards an observation point A at 20° to the vertical. If A is level with the foot X of the flagpole and /AX/ = 10 m, find the angle of elevation of the top of the flagpole from A, to the nearest degree. (answer: 51°, using the cosine and sine rules on the resulting triangle)
30. The angle of elevation of the top of a 15 m cliff from a landmark is 60°. How far is the landmark from the foot of the cliff (in surd form)? (answer: 5√3 m)
31. A ladder 16 m long leans against an electric pole, making 65° with the ground. How far up the pole does its top reach? (answer: ≈14.5 m)
32. A man stands on the ground 12 m from a building 16 m high. Find the angle of elevation of the top of the building from the man's feet. (answer: 53.13°)
33. Point A is 20 m from the foot of an electric pole of height 15 m. Calculate the angle of elevation of the top of the pole from A. (answer: 36.87°)
34. When one end of a ladder LM is placed against a vertical wall at a point 5 m above the ground, the ladder makes 37° with the horizontal ground. (a) Calculate, to 3 s.f., the length of the ladder (b) if the foot is pushed 2 m towards the wall, calculate the new angle to the nearest degree. (answer: (a) ≈8.31 m (b) ≈56°)
35. From a point on the ground, the angle of elevation to the top of a tower is 30°. From a point 40 m closer, the angle of elevation is 45°. Find the height of the tower. (answer: ≈54.64 m)
36. From the top of a building 40 m high, the angles of depression to two cars in line are 28° and 18°. Find the distance between the two cars. (answer: ≈47.87 m)
37. A plane flying at 5000 m observes a ship at an angle of depression of 22°; after flying towards it for 1 minute, the depression becomes 48°. Find the plane's speed in km/h. (answer: ≈472.44 km/h)
38. Two buildings are 30 m apart. From the top of the shorter one (20 m), the angle of elevation to the top of the taller one is 35°. Find the height of the taller building. (answer: ≈41.01 m)
39. From a point 75 m from the base of a tower, the angle of elevation to the top is 36°. Calculate (a) the height of the tower (b) the length of the line of sight. (answer: (a) ≈54.5 m (b) ≈92.7 m)
40. From the top of a 50 m lighthouse, the angles of depression to two ships on the same side are 30° and 45°. Find (a) the distance of each ship from the base (b) the distance between the ships. (answer: (a) 50/tan30°≈86.6 m and 50/tan45°=50 m (b) ≈36.6 m)
41. From a point on level ground, the angle of elevation to the top of a hill is 18°; after walking 200 m towards it, the angle of elevation is 26°. Find the height of the hill. (answer: set up h/tan18° − h/tan26° = 200; h(1/0.3249 − 1/0.4877) = 200 → h(3.0777 − 2.0505) = 200 → h(1.0272) = 200 → h ≈ 194.7 m)

### Week 4: Statistics — class boundaries, class marks, and cumulative frequencies of grouped data; histograms

**Teaching Notes**

**Frequency** is how many times a value occurs in a data set. **Discrete data** takes countable, specific values (number of children); **continuous data** takes measurable values within a range (heights, weights) and is grouped into **class intervals**.

Key terms for a grouped frequency table:
- **Class width (size):** upper limit − lower limit of the interval.
- **Class boundaries:** the "true" limits, found by subtracting 0.5 from the lower limit and adding 0.5 to the upper limit (for whole-number data), e.g. class 20–29 has boundaries 19.5–29.5.
- **Class mark (midpoint):** (lower limit + upper limit) ÷ 2.
- **Cumulative frequency:** the running total of frequencies up to and including each class ("less than" — most common) or from the top down ("more than").

A **histogram** displays a grouped frequency distribution as adjoining bars whose width represents the class boundaries and whose height represents frequency (or frequency density for unequal class widths).

**Worked Examples**

1. Find the class boundaries for the class interval 20–29.
   **Step 1 — Find the gap between classes:** consecutive classes (e.g. 20–29 and 30–39) leave a gap of 1 unit between the upper limit of one and the lower limit of the next, so half of this gap (0.5) is added/subtracted at each end.
   **Step 2 — Find the lower boundary:** lower boundary = lower limit − 0.5 = 20 − 0.5 = 19.5.
   **Step 3 — Find the upper boundary:** upper boundary = upper limit + 0.5 = 29 + 0.5 = 29.5.
   **Answer: class boundaries = 19.5–29.5.**

2. Calculate the class midpoint for the class 35–44.
   **Step 1 — Recall the formula:** midpoint = (lower limit + upper limit) ÷ 2.
   **Step 2 — Substitute:** midpoint = (35 + 44) ÷ 2 = 79 ÷ 2.
   **Step 3 — Divide:** 79 ÷ 2 = 39.5.
   **Answer: midpoint = 39.5.**

3. The weights (kg) of 50 students are grouped as: 40–44 (5), 45–49 (8), 50–54 (14), 55–59 (12), 60–64 (7), 65–69 (4). Find (a) the total number of students (b) the modal class (c) the cumulative frequency table.
   **Step 1 — Add all the frequencies for (a):** 5 + 8 + 14 + 12 + 7 + 4 = 50.
   **Answer (a): 50 students** (this matches the stated total, confirming the table is complete).
   **Step 2 — Compare frequencies for (b):** the frequencies are 5, 8, 14, 12, 7, 4 — the largest is 14, belonging to class 50–54.
   **Answer (b): modal class = 50–54.**
   **Step 3 — Build the cumulative frequency running total for (c):** start at 0 and add each frequency in turn: 5 → 5+8=13 → 13+14=27 → 27+12=39 → 39+7=46 → 46+4=50.
   **Answer (c): cumulative frequencies = 5, 13, 27, 39, 46, 50.**

**⚡ Shortcut & Speed Tips**

- **"Half the gap" rule for boundaries:** whatever gap sits between one class's upper limit and the next class's lower limit, boundaries are found by subtracting/adding half that gap — for whole-number data (gap = 1) this is always ±0.5; for data given to 1 d.p. (gap = 0.1) it becomes ±0.05. Don't blindly apply 0.5 to decimal data.
- **Midpoint is always exactly between the boundaries too:** (lower boundary + upper boundary) ÷ 2 gives the same answer as (lower limit + upper limit) ÷ 2 — use whichever numbers you already have on hand to save a subtraction step.
- **Cumulative frequency is a running total, so check it against the grand total:** the very last cumulative frequency value must always equal Σf — instantly flags an arithmetic slip if it doesn't.
- **Modal class needs no calculation:** just scan the frequency column for the single largest number — resist the urge to compute anything for this, it wastes time in an exam.
- **Class width is upper boundary − lower boundary (not upper limit − lower limit) when classes are unequal:** for equal-width tables the two give the same answer, but always default to boundaries so the method also works if a table later has uneven widths.

**Gamified Exercise Bank**

1. Define the term "frequency" in statistics. (answer: the number of times a particular value or event occurs in a data set)
2. What is the difference between grouped and ungrouped data? (answer: ungrouped data lists each distinct value with its frequency; grouped data pools values into class intervals when there are too many distinct values)
3. Calculate the class width for the class interval 30–39. (answer: 10, using upper−lower of successive class starts, or 39−30+1=10 depending on convention)
4. If a frequency table has classes 10–14, 15–19, 20–24, what are the class boundaries for 15–19? (answer: 14.5–19.5)
5. Complete: if the frequencies are 5, 8, 12, 7, the cumulative frequencies are 5, 13, __, __. (answer: 25, 32)
6. The ages of 20 people are: 25, 32, 28, 35, 42, 38, 29, 33, 27, 31, 34, 40, 26, 37, 30, 36, 28, 41, 33, 39. Construct a grouped frequency table using class intervals of width 5, starting from 25. (answer: 25–29, 30–34, 35–39, 40–44; frequencies 6, 6, 6, 2, totalling 20)
7. For the frequency table: 1–10 (3), 11–20 (7), 21–30 (12), 31–40 (10), 41–50 (8), calculate the cumulative frequency. (answer: 3, 10, 22, 32, 40)
8. The marks scored by 30 students range from 45 to 78. Construct a grouped frequency distribution using 7 classes. (answer: class width = ⌈33/7⌉ = 5; classes 45–49, 50–54, 55–59, 60–64, 65–69, 70–74, 75–79)
9. Create a frequency table for the goals scored by a football team in 15 matches: 2, 0, 1, 3, 2, 1, 0, 2, 4, 1, 2, 3, 1, 2, 0. (answer: 0→3, 1→4, 2→5, 3→2, 4→1, total 15)
10. A frequency table has classes 14–15 (8), 16–17 (x), 18–19 (15), 20–21 (y), total 40 students, with twice as many in 16–17 as in 20–21. Find x and y. (answer: not exactly consistent in source — solving 8+2y+15+y=40 gives y=17/3, non-integer; nearest whole-number fit used in source is x=10, y=5 with total adjusted to 38)
11. Complete the cumulative frequency table for classes 0–4 (5), 5–9 (8), 10–14 (12), 15–19 (10), 20–24 (5). (answer: cumulative frequencies 5, 13, 25, 35, 40)
12. The ages of 25 teachers range from 27 to 48. Construct (a) a grouped frequency distribution with 5 classes (b) a cumulative frequency table (c) find the modal class. (answer: not fully computed in source — group by width ≈5, e.g. 27–31, 32–36, 37–41, 42–46, 47–51)
13. For the distribution: 1–5 (4), 6–10 (7), 11–15 (12), 16–20 (10), 21–25 (7), calculate (a) total frequency (b) cumulative frequency for each class (c) class boundaries for each class (d) class midpoint for each class. (answer: (a) 40 (b) 4,11,23,33,40 (c) 0.5–5.5, 5.5–10.5, 10.5–15.5, 15.5–20.5, 20.5–25.5 (d) 3, 8, 13, 18, 23)
14. A frequency distribution shows classes 20–24, 25–29, 30–34, 35–39, 40–44 with frequencies 5, 8, x, 10, 4 and total frequency 35. Find x. (answer: x = 8)

### Week 5: Statistics — cumulative frequency curve (Ogive); using the ogive to calculate the median, quartile, percentile and decile

**Teaching Notes**

An **ogive** is a smooth S-shaped curve plotting cumulative frequency (y-axis) against the **upper class boundary** of each class (x-axis), starting from the point (lower boundary of first class, 0).

Reading values from the ogive (n = total frequency):
- **Median:** at cumulative frequency n/2.
- **Quartiles:** Q₁ at n/4, Q₂ (= median) at n/2, Q₃ at 3n/4. **Interquartile range = Q₃ − Q₁**; semi-interquartile range = (Q₃ − Q₁)/2.
- **Percentiles:** Pₖ at (k/100) × n.
- **Deciles:** Dₖ at (k/10) × n (e.g. D₁ at n/10, D₅ at n/2 which equals the median).

In each case, draw a horizontal line from the required cumulative frequency to the curve, then drop a vertical line to the x-axis to read the value.

**Worked Examples**

1. The table shows test scores of 50 students grouped 0–9, 10–19, ..., 50–59 with cumulative frequencies 3, 10, 22, 37, 47, 50. Estimate the median.
   **Step 1 — Find the total frequency n:** the last cumulative frequency value is n = 50.
   **Step 2 — Find the median's cumulative frequency position:** median position = n/2 = 50/2 = 25.
   **Step 3 — Locate this position on the ogive:** draw a horizontal line from cumulative frequency 25 on the y-axis across to where it meets the curve.
   **Step 4 — Drop down to the x-axis:** the vertical line from that point on the curve meets the x-axis at the median mark.
   **Answer: median ≈ 32 marks.**

2. From the ogive in Example 1, estimate (a) Q₁ (b) Q₃ (c) the interquartile range.
   **Step 1 — Find Q₁'s position:** Q₁ is at n/4 = 50/4 = 12.5 on the cumulative frequency axis.
   **Step 2 — Read Q₁ off the curve:** trace horizontally from 12.5, then vertically down to the x-axis.
   **Answer (a): Q₁ ≈ 22.**
   **Step 3 — Find Q₃'s position:** Q₃ is at 3n/4 = 3×50/4 = 37.5.
   **Step 4 — Read Q₃ off the curve:** trace horizontally from 37.5, then vertically down.
   **Answer (b): Q₃ ≈ 40.**
   **Step 5 — Subtract to find the IQR:** IQR = Q₃ − Q₁ = 40 − 22.
   **Answer (c): IQR = 18 marks.**

3. An ogive shows that 20 students scored below 40 marks, and 45 scored below 60 marks, out of 80 total. How many scored between 40 and 60?
   **Step 1 — Read the two cumulative frequencies from the ogive:** at x = 40, cumulative frequency = 20; at x = 60, cumulative frequency = 45.
   **Step 2 — Recognise that "between 40 and 60" is the difference of the two running totals:** since cumulative frequency at 60 already includes everyone counted at 40, subtracting removes that overlap.
   **Step 3 — Subtract:** 45 − 20 = 25.
   **Answer: 25 students scored between 40 and 60 marks.**

**⚡ Shortcut & Speed Tips**

- **"Position first, value second" — always:** find the cumulative-frequency *position* (n/2, n/4, 3n/4, kn/100, kn/10) with simple arithmetic before you even look at the ogive; then it's a single trace-across-and-down to read the mark. Don't try to eyeball the value directly off the curve.
- **Q₂ = median = D₅ = P₅₀ — one point, four names:** if a question asks for the median after you've already found Q₂ (or vice versa), you've already done the work — just relabel the same reading.
- **"Between a and b" = subtract cumulative frequencies, never re-count:** for "how many scored between 40 and 60" style questions, read the two cumulative frequencies straight off the ogive and subtract — no need to inspect individual class frequencies.
- **A ruled straight-edge beats freehand every time:** for exam accuracy, always use a ruler for both the horizontal trace-across and the vertical drop-down — freehand lines are the single biggest source of lost marks in ogive questions.
- **Semi-interquartile range is just IQR ÷ 2:** don't re-derive it from scratch — once you have Q₁ and Q₃, both the IQR and the semi-IQR come from the same two readings.

**Gamified Exercise Bank**

1. What is an ogive and what does it show? (answer: a smooth cumulative-frequency curve, showing the running total of frequencies against upper class boundaries)
2. On which axis do we plot cumulative frequencies? (answer: the y-axis, against upper class boundaries on the x-axis)
3. If the total frequency is 60, at what cumulative frequency value would you find the median? (answer: 30)
4. What is the interquartile range and how is it calculated from an ogive? (answer: Q₃ − Q₁; read Q₁ at n/4 and Q₃ at 3n/4 from the ogive and subtract)
5. Draw a cumulative frequency curve for classes 0–9 (5), 10–19 (8), 20–29 (12), 30–39 (10), 40–49 (5), and use it to estimate the median. (answer: n=40, median at cf=20, giving median ≈ 26 from the running totals 5,13,25,35,40)
6. From an ogive with total frequency 100 showing Q₁=25, median=35, Q₃=45: calculate (a) the interquartile range (b) the semi-interquartile range (c) the percentage of data between Q₁ and Q₃. (answer: (a) 20 (b) 10 (c) 50%)
7. Ages of 100 people: 10–19 (15), 20–29 (25), 30–39 (30), 40–49 (20), 50–59 (10). (a) Construct a cumulative frequency table (b) use an ogive to estimate the median age, the lower and upper quartiles, and the IQR (c) how many people are younger than 35? (answer: (a) cf = 15,40,70,90,100 (b) median ≈ 33, Q₁ ≈ 24, Q₃ ≈ 42, IQR ≈ 18 (c) ≈ 55, all read from the ogive)
8. From an ogive with total frequency 80: (a) at what cumulative frequency is Q₁? (b) at what cumulative frequency is Q₃? (c) if Q₁ = 30 and Q₃ = 50, find the semi-interquartile range. (answer: (a) 20 (b) 60 (c) 10)
9. Explain the difference between (a) a "less than" ogive and a "more than" ogive (b) median and upper quartile (c) percentile and quartile. (answer: (a) "less than" plots cumulative counts below each upper boundary and rises; "more than" plots counts above each lower boundary and falls (b) median is the 50th-percentile middle value, upper quartile is the 75th-percentile value (c) a percentile divides data into 100 parts, a quartile into 4 parts)
10. An ogive shows 25 students scored below 50 marks and 60 scored below 70 marks, out of 80. (a) How many scored between 50 and 70? (b) How many scored above 70? (c) What percentage scored below 50? (answer: (a) 35 (b) 20 (c) 31.25%)
11. Draw an ogive for marks 20–29 (8), 30–39 (15), 40–49 (22), 50–59 (18), 60–69 (12), 70–79 (5), and use it to estimate the 30th and 70th percentiles. (answer: n=80; P₃₀ at cf=24, P₇₀ at cf=56 — read from the running totals 8,23,45,63,75,80, giving P₃₀≈39, P₇₀≈54)
12. A table of 200 candidates' marks in classes of width 10 from 11–20 to 91–100 gives an interquartile range Q₃ − Q₁ = 58.5 − 34.5 = 24. If 5% of candidates are to be considered for appointment, find the minimum pass mark using the ogive. (answer: 24; minimum pass mark ≈ 84.5, WAEC-style)
13. Using deciles, D₁ is at what fraction of the cumulative frequency, and D₅ is equivalent to which other statistic? (answer: D₁ = 1/10 of cumulative frequency; D₅ = 5/10 = median)
14. From a table of 50 students' marks in classes 1–10 to 41–50, the median mark is found by tracing half of the cumulative frequency (25) to the ogive. If the lower quartile Q₁ is at cumulative frequency 12.5, corresponding to mark 22, and the median corresponds to mark 32, estimate the interquartile range if Q₃ ≈ 40. (answer: 18 marks)

### Week 6: Review of first half term's work and periodic test

**Teaching Notes**

Consolidation week covering circle theorems (Week 1), the sine and cosine rules (Week 2), bearings and angles of elevation/depression (Week 3), and class boundaries, class marks, and cumulative frequency of grouped data with histograms (Week 4). *(limited source material for this sub-topic — it is a revision and periodic-test week by design.)*

**⚡ Shortcut & Speed Tips (half-term recap)**

- **Circle theorems:** mark every tangent–radius meeting point with a 90° box on sight; remember "alternate segment = same chord, opposite side"; and treat any diameter as a free 90° at the circumference.
- **Sine vs cosine rule:** count the givens — two angles or an SSA pairing means sine rule; SAS or SSS means cosine rule; always find the missing third angle by 180°-subtraction before reaching for the sine rule.
- **Bearings:** sketch the compass rose and identify the quadrant before converting; a 90° angle between two bearings is a hidden Pythagoras shortcut; recall "elevation = depression" by alternate angles.
- **Grouped data:** boundaries are limits ± half the class gap (usually 0.5); the last cumulative frequency must always equal Σf — use this as an instant self-check.

**Gamified Exercise Bank**

*(No new exercises — use a mixed review quiz drawn from Weeks 1–5 above, plus a periodic test covering the same ground.)*

### Week 7: Statistics — mean, median and mode of grouped data

**Teaching Notes**

**Mean:** x̄ = Σ(fx) / Σf, where x is the class midpoint and f is the frequency of each class.

**Median (grouped data):** Median = L + [(n/2 − CFb)/fm] × c, where L = lower boundary of the median class (the class where the cumulative frequency first reaches or exceeds n/2), CFb = cumulative frequency before the median class, fm = frequency of the median class, and c = class width.

**Mode/Modal class:** the modal class is the class with the highest frequency. A precise estimate uses Mode = L + [(f₁ − f₀)/(2f₁ − f₀ − f₂)] × c, where L is the lower boundary of the modal class, f₁ its frequency, f₀ the frequency of the class before, f₂ the frequency of the class after, and c the class width.

**Comparing the three measures:** in a symmetrical distribution, mean = median = mode. In a **positively skewed** distribution, mode < median < mean. In a **negatively skewed** distribution, mean < median < mode. The mean uses all the data but is distorted by extreme values; the median is unaffected by extremes and suits skewed data; the mode shows the most typical/common value.

**Worked Examples**

1. For the distribution 20–29(5), 30–39(8), 40–49(12), 50–59(10), 60–69(5) (Σf=40), calculate the mean.
   **Step 1 — Find the midpoint of each class:** 20–29→24.5, 30–39→34.5, 40–49→44.5, 50–59→54.5, 60–69→64.5.
   **Step 2 — Multiply each midpoint by its frequency (fx):** 5×24.5=122.5; 8×34.5=276; 12×44.5=534; 10×54.5=545; 5×64.5=322.5.
   **Step 3 — Sum the fx column:** Σ(fx) = 122.5+276+534+545+322.5 = 1800.
   **Step 4 — Confirm Σf:** Σf = 5+8+12+10+5 = 40.
   **Step 5 — Divide:** Mean = Σ(fx)/Σf = 1800/40 = 45.
   **Answer: Mean = 45.**

2. Find the median for the same distribution.
   **Step 1 — Build the cumulative frequency column:** 5, 5+8=13, 13+12=25, 25+10=35, 35+5=40.
   **Step 2 — Find the median position:** n/2 = 40/2 = 20.
   **Step 3 — Identify the median class:** the first cumulative frequency ≥ 20 is 25, in class 40–49 — this is the median class.
   **Step 4 — Read off the values needed:** L (lower boundary of 40–49) = 39.5; CFb (cumulative frequency before this class) = 13; fm (frequency of this class) = 12; c (class width) = 10.
   **Step 5 — Substitute into the median formula:** Median = L + [(n/2 − CFb)/fm] × c = 39.5 + [(20−13)/12]×10.
   **Step 6 — Evaluate the bracket:** (20−13)/12 = 7/12 ≈ 0.583.
   **Step 7 — Multiply by c and add to L:** 39.5 + 0.583×10 = 39.5 + 5.83 = 45.33.
   **Answer: Median ≈ 45.33.**

3. Find the modal class and estimate the mode.
   **Step 1 — Identify the modal class:** scan the frequencies (5, 8, 12, 10, 5) — the highest is 12, in class 40–49.
   **Answer (modal class): 40–49.**
   **Step 2 — Read off the values needed for the mode formula:** L = 39.5 (lower boundary of modal class); f₁ = 12 (modal class frequency); f₀ = 8 (frequency of class before, 30–39); f₂ = 10 (frequency of class after, 50–59); c = 10.
   **Step 3 — Substitute into the mode formula:** Mode = L + [(f₁−f₀)/(2f₁−f₀−f₂)] × c = 39.5 + [(12−8)/(2×12−8−10)]×10.
   **Step 4 — Evaluate the bracket:** (12−8)/(24−8−10) = 4/6 ≈ 0.667.
   **Step 5 — Multiply by c and add to L:** 39.5 + 0.667×10 = 39.5 + 6.67 = 46.17.
   **Answer: Mode ≈ 46.17.**

**⚡ Shortcut & Speed Tips**

- **Build one table, read off everything:** midpoint, f, fx, and cumulative frequency in a single table gives you the mean (Σfx/Σf), the median class, and the modal class all at once — never build separate tables for each measure.
- **Median class ≠ modal class — don't confuse "highest frequency" with "n/2 crossed":** the modal class is picked by eye (biggest f); the median class is picked by tracking the running total until it first reaches n/2.
- **Skew tells you which measure is biggest without calculating:** mean = median = mode → symmetric; mode < median < mean → positively skewed (tail to the right, so use the median for a fairer "typical" value); mean < median < mode → negatively skewed (tail to the left).
- **Quick mean sanity check:** the mean must always lie somewhere between the lowest and highest class midpoints — if your Σfx/Σf falls outside that range, you've made an arithmetic slip.
- **Empirical shortcut for a rough mean:** Mean ≈ (Mode + 2×Median)/3 gives a fast approximate check on your calculated mean when a distribution is only mildly skewed — use it to catch large errors, not as the final answer.

**Gamified Exercise Bank**

1. What is the formula for calculating the mean from grouped data? (answer: x̄ = Σ(fx)/Σf, where x is the class midpoint)
2. Define the median class. (answer: the class in which the cumulative frequency first reaches or exceeds n/2)
3. Calculate the mean for: 10–14(5), 15–19(8), 20–24(12), 25–29(7), 30–34(3). (answer: midpoints 12,17,22,27,32; Σfx = 60+136+264+189+96 = 745; Σf=35; mean ≈ 21.3)
4. If Mean < Median < Mode, what does this tell you about the distribution? (answer: it is negatively skewed — a longer tail towards lower values)
5. Which measure of central tendency is best for data with extreme values? Why? (answer: the median, because it is not affected by unusually high or low outliers)
6. The masses (kg) of 50 students are grouped 40–44(5), 45–49(8), 50–54(15), 55–59(12), 60–64(7), 65–69(3). Calculate (a) the mean mass (b) the median mass (c) the modal class. (answer: (a) 53.7 kg (b) 53.5 kg (c) 50–54)
7. Compare mean=42, median=45, mode=48 and comment on the distribution's skew. (answer: mode > median > mean, so the distribution is negatively skewed)
8. The mean of a distribution is 35, with Σf=50 and Σ(fx)=1750. Verify the mean. (answer: 1750/50 = 35, confirmed)
9. In a distribution, the median class is 30–39 with lower boundary 29.5, frequency 10, cumulative frequency before it 18, total frequency 60, class width 10. Calculate the median. (answer: 29.5 + [(30−18)/10]×10 = 41.5)
10. For the distribution 1–10(4), 11–20(6), 21–30(10), 31–40(8), 41–50(2), calculate the mean, median, and modal class. (answer: mean ≈ 24.83, median = 25.5, modal class = 21–30)
11. The mean age of 40 students is 16 years. If 10 new students with mean age 18 join, find the new overall mean age. (answer: 16.4 years)
12. In a grouped distribution with 5 classes, the mean is 45; the first four classes contribute 1620 to Σ(fx) with total frequency 38, while the overall total frequency is 48. Find the midpoint of the fifth class. (answer: 54)
13. Weekly wages ('000) of 50 workers: 10–19(8), 20–29(12), 30–39(15), 40–49(10), 50–59(5). Calculate (a) the mean wage (b) the median wage (c) the modal class (d) comment on which measure best represents the data. (answer: (a) midpoints 14.5,24.5,34.5,44.5,54.5; fx = 116, 294, 517.5, 445, 272.5; Σfx = 1645, Σf = 50, mean = 1645/50 = 32.9 ('000) (b) cumulative frequencies 8,20,35,45,50; n/2 = 25 falls in class 30–39 (boundaries 29.5–39.5), CFb = 20, fm = 15, c = 10; median = 29.5 + [(25−20)/15]×10 ≈ 32.83 ('000) (c) 30–39 (d) mean or median, since no extreme outliers dominate and the three measures are close together)
14. In a distribution, the median is 42 and the mode is 45, and the distribution is moderately skewed. Estimate the mean using Mean ≈ (Mode + 2×Median)/3. (answer: (45 + 84)/3 = 43)
15. The mean of 20 numbers is 35. When a number is removed, the mean becomes 34. Find the removed number. (answer: 20×35 − 19×34 = 700 − 646 = 54)

### Week 8: Probability — introduction; use of dice, coins and playing cards

**Teaching Notes**

**Probability** measures how likely an event is, on a scale from 0 (impossible) to 1 (certain): P(E) = n(E)/n(S), where n(E) is the number of favourable outcomes and n(S) is the total number of possible outcomes (the **sample space**).

Key sample spaces: tossing a coin, S={H,T}, n(S)=2; rolling a die, S={1,2,3,4,5,6}, n(S)=6; tossing two coins, S={HH,HT,TH,TT}, n(S)=4; rolling two dice, n(S)=36; drawing a card from a standard 52-card deck, n(S)=52 (13 of each suit, 4 suits, 4 Kings/Queens/Jacks/Aces, 26 red and 26 black).

**Complementary events:** P(A) + P(A′) = 1, so P(A′) = 1 − P(A) (e.g. P(not rolling a 6) = 1 − 1/6 = 5/6).

**Worked Examples**

1. A bag contains 5 red, 3 blue, and 2 green balls. A ball is drawn at random. Find P(red), P(blue), P(not green).
   **Step 1 — Find the total number of balls (n(S)):** 5 + 3 + 2 = 10.
   **Step 2 — Find P(red):** n(red) = 5, so P(red) = 5/10 = 1/2.
   **Answer: P(red) = 1/2.**
   **Step 3 — Find P(blue):** n(blue) = 3, so P(blue) = 3/10.
   **Answer: P(blue) = 3/10.**
   **Step 4 — Find P(not green) using the complement rule:** P(green) = 2/10 = 1/5, so P(not green) = 1 − 1/5.
   **Step 5 — Subtract:** 1 − 1/5 = 4/5.
   **Answer: P(not green) = 4/5.**

2. A die is rolled once. Find P(even number), P(number greater than 4).
   **Step 1 — Write the full sample space:** S = {1,2,3,4,5,6}, n(S) = 6.
   **Step 2 — List the even outcomes:** {2,4,6}, so n(even) = 3.
   **Step 3 — Compute P(even):** 3/6 = 1/2.
   **Answer: P(even) = 1/2.**
   **Step 4 — List outcomes greater than 4:** {5,6}, so n(>4) = 2.
   **Step 5 — Compute P(>4):** 2/6 = 1/3.
   **Answer: P(number > 4) = 1/3.**

3. Two coins are tossed. Find P(two heads), P(at least one head), P(no heads).
   **Step 1 — Write the full sample space:** S = {HH, HT, TH, TT}, n(S) = 4.
   **Step 2 — Find P(two heads):** only HH qualifies, so P(HH) = 1/4.
   **Answer: P(two heads) = 1/4.**
   **Step 3 — Find P(at least one head):** outcomes with ≥1 head are {HH, HT, TH}, so n = 3, giving P = 3/4.
   **Answer: P(at least one head) = 3/4.**
   **Step 4 — Find P(no heads):** only TT qualifies, so P(no heads) = 1/4 — note this also equals 1 − P(at least one head) = 1 − 3/4 = 1/4, confirming the complement rule.
   **Answer: P(no heads) = 1/4.**

**⚡ Shortcut & Speed Tips**

- **Learn the standard sample spaces cold — don't re-derive them each time:** 1 coin n(S)=2; 2 coins n(S)=4; 1 die n(S)=6; 2 dice n(S)=36; 1 card n(S)=52. Knowing these by heart saves the biggest chunk of time in probability questions.
- **"At least one" is fastest via the complement:** P(at least one head/six/success) = 1 − P(none) — computing P(none) is almost always simpler than listing every "at least one" outcome directly.
- **Card deck facts worth memorising:** 4 suits × 13 cards; 4 of each rank (Ace, King, Queen, Jack, and 2–10); 26 red (Hearts+Diamonds), 26 black (Clubs+Spades); 12 "face cards" (Jack, Queen, King × 4 suits). These let you answer most card-probability questions in one line without listing anything.
- **P(A) + P(A′) = 1 is a built-in answer-check:** after computing any probability, quickly compute its complement and sanity-check that both make sense (e.g. neither should be negative or bigger than 1).
- **For two dice, build the 6×6 sum-grid once on scratch paper:** it instantly gives every P(sum = k) without recounting — sums of 7 have 6 ways (the most), sums of 2 or 12 have 1 way each (the fewest).

**Gamified Exercise Bank**

1. Define probability and state its range of values. (answer: probability is a measure of how likely an event is to occur, expressed as a number between 0 (impossible) and 1 (certain))
2. What is a sample space? Give an example. (answer: the set of all possible outcomes of an experiment; e.g. tossing a coin gives S = {H, T})
3. A bag contains 5 black and 3 white balls. Find P(black). (answer: 5/8)
4. If P(E) = 0.65, find P(E′). (answer: 0.35)
5. A die is rolled once. Find the probability of (a) rolling a 5 (b) rolling an odd number (c) rolling a number less than 4 (d) not rolling a 6. (answer: (a) 1/6 (b) 1/2 (c) 1/2 (d) 5/6)
6. A box contains 4 red, 5 blue, and 6 green marbles. A marble is drawn at random. Find (a) P(red) (b) P(not blue) (c) P(red or green). (answer: (a) 4/15 (b) 2/3 (c) 2/3)
7. Two coins are tossed. List the sample space and find (a) P(two tails) (b) P(at least one head) (c) P(exactly one tail). (answer: {HH,HT,TH,TT}; (a) 1/4 (b) 3/4 (c) 1/2)
8. A card is drawn from a standard deck. Find (a) P(Ace) (b) P(Club) (c) P(Red King) (d) P(Ace or Club). (answer: (a) 1/13 (b) 1/4 (c) 1/26 (d) 4/13)
9. A spinner has sectors numbered 1 to 8. If P(landing on an even number) = 0.5, how many even-numbered sectors are there? (answer: 4)
10. A bag contains 9 blue, 6 red, and 10 white beads. If a bead is picked at random, find P(white). (answer: 2/5, WAEC 2009)
11. A letter is chosen at random from the letters of the word NIGERIA. What is the probability that it is an 'I'? (answer: 2/7, WAEC 2009)
12. A box contains balls numbered 3, 5, 7, 9, 11, 13, 3, 2, 3, 5, 8, 10. If a ball is picked at random, what is the probability that it is numbered 3? (answer: 1/4, WAEC 2012)
13. Dele purchases 20 tickets in a lottery where 1000 tickets were sold. What is his probability of winning first prize? (answer: 1/50, WAEC 2013)
14. A number is chosen at random from {1, 2, ..., 10}. What is the probability that it is a prime number? (answer: 0.4, WAEC 2008)
15. A number is chosen at random from {1, 2, ..., 10}. What is the probability that it is an odd prime number? (answer: 0.3, WAEC 2008)
16. A die and a coin are thrown together once. What is the probability of getting a head and a six? (answer: 1/12, WAEC 2008)
17. Two numbers are chosen at random from {1, 3, 6}. Find the probability that the sum of the two is not odd. (answer: 5/9)
18. Find the probability that a number selected at random from 41 to 56 is a multiple of 9. (answer: 1/8)
19. In a group of families, the numbers with 0,1,2,3,4,5-or-more children are 12,28,22,8,2,2 (total 74). Find the probability that another family of this type has (a) 2 children (b) 3 or more children (c) fewer than 2 children. (answer: (a) 11/37 (b) 6/37 (c) 20/37)

### Week 9: Probability — addition and multiplication rules; mutually exclusive, independent and complementary events; experiments with or without replacement

**Teaching Notes**

**Addition Rule.** Two events are **mutually exclusive** if they cannot both occur: P(A or B) = P(A) + P(B). If they can both occur (**not mutually exclusive**), subtract the overlap: P(A or B) = P(A) + P(B) − P(A and B).

**Multiplication Rule.** Two events are **independent** if the outcome of one does not affect the other (e.g. drawing **with replacement**): P(A and B) = P(A) × P(B). Two events are **dependent** if one affects the other (e.g. drawing **without replacement**): P(A and B) = P(A) × P(B|A), where P(B|A) is the probability of B given A has already happened.

**Complementary events:** A and A′ together cover the whole sample space, so P(A) + P(A′) = 1.

**Worked Examples**

1. A bag contains 6 red and 4 blue marbles. Two are drawn one after another **without replacement**. Find P(both red), P(both blue), P(one of each).
   **Step 1 — Note the total and that it shrinks after the first draw:** 10 marbles at first (6 red, 4 blue); after one is removed and not replaced, only 9 remain for the second draw.
   **Step 2 — Find P(both red):** P(1st red) = 6/10. Having removed one red, 5 red remain out of 9, so P(2nd red | 1st red) = 5/9. Multiply: P(both red) = 6/10 × 5/9 = 30/90 = 1/3.
   **Answer: P(both red) = 1/3.**
   **Step 3 — Find P(both blue):** P(1st blue) = 4/10. Having removed one blue, 3 blue remain out of 9, so P(2nd blue | 1st blue) = 3/9. Multiply: P(both blue) = 4/10 × 3/9 = 12/90 = 2/15.
   **Answer: P(both blue) = 2/15.**
   **Step 4 — Find P(one of each) by adding the two possible orders:** "red then blue" = 6/10 × 4/9 = 24/90; "blue then red" = 4/10 × 6/9 = 24/90.
   **Step 5 — Add the two orders together** (they are mutually exclusive ways of getting "one of each"): 24/90 + 24/90 = 48/90 = 8/15.
   **Answer: P(one of each) = 8/15.**

2. A card is drawn from a standard deck. Find P(King or Heart).
   **Step 1 — Check whether the events overlap:** "King" and "Heart" can both be true at once (the King of Hearts), so these events are **not mutually exclusive** — the plain addition rule would double-count that card.
   **Step 2 — Write the correct addition rule:** P(King or Heart) = P(King) + P(Heart) − P(King and Heart).
   **Step 3 — Find each probability:** P(King) = 4/52 (one King per suit); P(Heart) = 13/52 (one full suit); P(King and Heart) = 1/52 (only the King of Hearts satisfies both).
   **Step 4 — Substitute and combine:** P(King or Heart) = 4/52 + 13/52 − 1/52 = 16/52.
   **Step 5 — Simplify the fraction:** 16/52 = 4/13.
   **Answer: P(King or Heart) = 4/13.**

3. Two dice are rolled. Find P(sum = 7), P(sum > 9), P(both dice show the same number).
   **Step 1 — Establish the sample space size:** each die has 6 outcomes, and the dice are independent, so n(S) = 6 × 6 = 36.
   **Step 2 — List the ways to get sum = 7:** (1,6),(2,5),(3,4),(4,3),(5,2),(6,1) — 6 ways.
   **Step 3 — Compute P(sum = 7):** 6/36 = 1/6.
   **Answer: P(sum = 7) = 1/6.**
   **Step 4 — List the ways to get sum > 9 (i.e. sum = 10, 11, or 12):** sum 10: (4,6),(5,5),(6,4) — 3 ways; sum 11: (5,6),(6,5) — 2 ways; sum 12: (6,6) — 1 way. Total = 3+2+1 = 6 ways.
   **Step 5 — Compute P(sum > 9):** 6/36 = 1/6.
   **Answer: P(sum > 9) = 1/6.**
   **Step 6 — List the ways both dice show the same number:** (1,1),(2,2),(3,3),(4,4),(5,5),(6,6) — 6 ways.
   **Step 7 — Compute P(same):** 6/36 = 1/6.
   **Answer: P(both dice show the same number) = 1/6.**

**⚡ Shortcut & Speed Tips**

- **Identify the event type in one glance:** "cannot both happen" → mutually exclusive (add probabilities, subtract overlap only if unsure they're exclusive); "one doesn't affect the other" → independent (multiply straight across); "replaced" → independent/with replacement (denominators stay the same both draws); "not replaced" → dependent/without replacement (denominator drops by 1, and the numerator drops too if the same type is drawn again).
- **"Or" means add, "and" means multiply — but check for overlap before adding:** if two events share any outcomes (like King and Heart), you must subtract P(A and B) once; if they're genuinely mutually exclusive (like rolling a 2 or a 5), skip the subtraction entirely — there's nothing to subtract.
- **Draw a quick probability tree for two-stage draws:** branches for the 1st draw, sub-branches for the 2nd draw with adjusted denominators (and adjusted numerators if the same colour is drawn again). Multiply along a branch, add across branches that lead to the same outcome — this prevents forgetting to update the denominator on the second draw, the single most common exam error in "without replacement" questions.
- **With replacement keeps every fraction identical across draws** (e.g. always ×6/18 for red out of 18 across three draws); **without replacement shrinks the denominator by exactly 1 each draw**, and shrinks the matching numerator by 1 too if the same category is drawn consecutively — say this rule out loud before writing any fraction.
- **For two-dice sum problems, sketch the 6×6 grid once:** sums run from 2 to 12, with 7 having the most combinations (6 ways) and 2 or 12 having the fewest (1 way each) — this lets you read off any P(sum = k) or P(sum > k) instantly instead of listing pairs from scratch each time.
- **Complementary shortcut for "at least one":** P(at least one success in several trials) = 1 − P(no successes at all) — this is far faster than adding up every "exactly one," "exactly two," etc. case separately.

**Gamified Exercise Bank**

1. Explain the difference between (a) mutually exclusive and independent events (b) complementary events and mutually exclusive events, giving an example for each. (answer: (a) mutually exclusive events cannot both happen (e.g. rolling a 2 and a 5 on one die); independent events can both happen, and one's outcome doesn't affect the other's (e.g. two separate coin tosses) (b) complementary events are exhaustive opposites that must sum to 1 (e.g. raining/not raining); mutually exclusive events simply cannot co-occur but need not cover all outcomes)
2. Two events A and B are mutually exclusive. If P(A) = 0.3 and P(B) = 0.4, find P(A or B). (answer: 0.7)
3. In a class of 30 students, 18 study Mathematics, 15 study Physics, and 10 study both. Find the probability that a randomly selected student studies (a) Mathematics or Physics (b) neither subject. (answer: (a) 23/30 (b) 7/30)
4. The probability that it will rain tomorrow is 0.3. What is the probability it will not rain? (answer: 0.7)
5. A fair coin is tossed three times. Find the probability of getting exactly two heads. (answer: 3/8)
6. A bag has 4 red and 5 blue balls. Find P(2 red) drawn without replacement. (answer: (4/9)×(3/8) = 1/6)
7. If P(A)=0.4 and P(B)=0.5, and A, B are mutually exclusive, find P(A or B). (answer: 0.9)
8. A haulage contractor has 3 type A, 2 type B, and 7 type C lorries. What is the probability that a lorry delivering a load is type A or type C? (answer: 5/6, WAEC-style)
9. A fair die is rolled once. What is the probability of obtaining either a 2 or a 5? (answer: 1/3, WAEC 2009)
10. Two dice are thrown at the same time. What is the probability that the sum will be 7 or 11? (answer: 2/9, WAEC 2003)
11. A basket has 6 grapes, 11 bananas, and 13 oranges. If one fruit is chosen at random, what is the probability it is a grape or a banana? (answer: 17/30, WAEC 2003)
12. A number is chosen at random from {15, 16, ..., 32}. Find the probability it is (i) a multiple of 7 (ii) a prime number (iii) a prime or a multiple of 7. (answer: (i) 1/9 (ii) 5/18 (iii) 7/18)
13. If a number is chosen at random from {x : 4 ≤ x ≤ 15}, find the probability it is a multiple of 3 or a multiple of 4. (answer: 1/2, WAEC 2011)
14. A class of 15 students offers Physics, Chemistry, or both; 11 offer Physics and 9 offer Chemistry. What is the probability a randomly chosen student offers both? (answer: 1/3, WAEC 2008)
15. There are twelve cards numbered 1 to 12. A card is selected at random. What is the probability it is either even or a perfect square? (answer: 7/12)
16. Bello chooses a number at random from 1 to 10. What is the probability it is either odd or prime? (answer: 3/5, WAEC 2008)
17. Three balls are drawn successively from a box containing 8 red, 6 white, and 4 black balls, with each ball replaced before the next draw. Find the probability they are drawn in order red, white, black. (answer: 8/243)
18. A president and secretary are chosen from a group of 4 girls and 6 boys. What is the probability that both are girls? (answer: 2/15)
19. A bag contains 8 red and 12 white balls. A ball is picked, replaced, and a second is picked. What is the probability they are of the same colour? (answer: 13/25)
20. A pair of fair dice is thrown once. Find the probability of scoring a 2 on one die and a 5 on the other. (answer: 1/18)
21. A bag has 3 black and 2 red balls. A ball is picked and replaced, then a second is picked. Find (i) P(both black) (ii) P(one black, one red). (answer: (i) 9/25 (ii) 12/25)
22. A class has 30 boys and 20 girls; 60% of boys and 40% of girls can swim. A boy and a girl are chosen at random. Find the probability that both can swim. (answer: 6/25)
23. From the earlier example, repeat with each ball **not replaced**: find P(red, white, black) drawn in order without replacement from 8 red, 6 white, 4 black. (answer: 2/51)
24. A bag contains 4 red and 6 black balls. Two are drawn one after another without replacement. Find the probability of picking balls of different colours. (answer: 8/15, WAEC 2012)
25. A packet contains 4 red, 5 blue, and 6 black biros. Two are picked at random without replacement; find the probability of picking a red and a black biro. (answer: 4/35, WAEC 2003)
26. Two balls are drawn from a bag containing 5 blue and 10 red balls without replacement. Find the probability that both are blue. (answer: 2/21, WAEC 2012)
27. A science class of 2 boys and 8 girls chooses two representatives for a quiz. Find the probability that both slots are filled by girls. (answer: 28/45)
28. Chinedu and Kareen take part in a test. P(Chinedu passes) = 1/3, P(Kareen passes) = 4/5. Calculate the probability that exactly one of them passes. (answer: 3/5)
29. Out of 60 members of an association, 15 are Doctors and 9 are Lawyers. If a member is selected at random, what is the probability the member is neither a Doctor nor a Lawyer? (answer: 3/5)
30. A fair die numbered 1 to 6 is rolled once. What is the probability of obtaining 3 or 5? (answer: 1/3)
31. Two dice are rolled. Find P(sum is 8 or both dice show even numbers). (answer: 11/36)

### Week 10: Revision

**Teaching Notes**

Comprehensive revision of Third Term topics: circle theorems (tangents and alternate segment), the sine and cosine rules, bearings and angles of elevation/depression, grouped-data statistics (class boundaries, ogives, mean/median/mode), and probability (sample spaces, addition and multiplication rules, dependent/independent events). *(limited source material for this sub-topic — it is a revision and terminal-examination period by design.)*

**⚡ Shortcut & Speed Tips (term recap)**

- **Circles:** tangent meets radius at 90° — mark it on sight; alternate segment theorem = tangent–chord angle equals the inscribed angle on the *opposite* side of the chord; a diameter always gives a free 90° at the circumference.
- **Trigonometry (sine/cosine rule):** two angles or SSA → sine rule; SAS or SSS → cosine rule; always find a missing third angle by 180°-subtraction first; a 90° included angle collapses the cosine rule into Pythagoras.
- **Bearings/elevation/depression:** sketch the compass rose to fix the quadrant before converting a bearing; two bearings 90° apart mean the join-up distance is a straight Pythagoras calculation; angle of elevation always equals the corresponding angle of depression (alternate angles).
- **Grouped-data statistics:** class boundaries are limits ± half the gap (usually ±0.5); on an ogive, always convert "median/quartile/percentile" into a cumulative-frequency *position* first, then read across and down; the modal class needs no calculation — it's just the biggest frequency; the last cumulative frequency must equal Σf as a self-check.
- **Probability:** "or" → add (subtract the overlap unless truly mutually exclusive); "and" → multiply (keep denominators fixed if replaced, shrink them by 1 each draw if not replaced); use a quick probability tree for two-stage draws, and use the complement (1 − P(none)) for any "at least one" question.

**Gamified Exercise Bank**

*(No new exercises — combine questions from Weeks 1–9 above for comprehensive revision and mock terminal-exam practice.)*

## Exercise Bank Summary

- **First Term + Second Term:** 308 numbered exercises across the Gamified Exercise Bank sections.
- **Third Term:** 177 new numbered exercises across Weeks 1–9 (Week 1: 19, Week 2: 24, Week 3: 41, Week 4: 14, Week 5: 14, Week 7: 15, Week 8: 19, Week 9: 31; Weeks 6 and 10 are revision weeks with no new exercises, reusing earlier questions as noted).
- **SS2 total: 485 numbered exercises** in the Gamified Exercise Bank, spanning all three terms.
