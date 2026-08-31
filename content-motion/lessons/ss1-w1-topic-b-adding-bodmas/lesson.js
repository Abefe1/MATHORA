/* ============================================================
   Lesson content. Unlike lessons/addition-worked-example (one problem,
   fixed STEP map), this lesson narrates a whole topic: concept, several
   real-life examples, speed tips, then two worked examples. The engine
   itself (engine/core.js) is untouched; everything below is a generic
   "beat" timeline built on top of it, so any future topic lesson with a
   variable number of examples/tips can reuse this same pattern instead
   of hand-writing a new STEP map each time.

   `rules`/`realLifeExamples`/`speedTips`/`examples[].steps` mirror the
   corresponding sections of the "Balancing the Signs" artifact and the
   GeneratedWorkedExample shape in content-worker/app/schema.py, so this
   could eventually be assembled straight from the generator pipeline.

   SS1 Mathematics, First Term, Week 1, Topic B:
   adding directed numbers and order of operations (BODMAS).
   ============================================================ */
const LESSON = {
  kicker: "Topic B",
  title: "Adding Directed Numbers and BODMAS",
  conceptIntro: "Two rules for adding directed numbers, plus the order you must do things in.",
  rules: [
    { k: "Adding, same signs", t: "Add the magnitudes together, and keep that shared sign." },
    { k: "Adding, different signs", t: "Find the difference between the two magnitudes. The answer takes the sign of whichever number has the bigger magnitude." },
    { k: "Order of operations, BODMAS", t: "Brackets, Of, Division, Multiplication, Addition, Subtraction. Do brackets first, then any of, then every times or divide, then every plus or minus." },
  ],
  realLifeExamples: [
    { icon: "📱", label: "Airtime", text: "You have 2000 naira airtime credit and buy a 2600 naira data bundle. An expense is negative, so that's 2000 plus negative 2600. Different signs: the difference of the magnitudes is 600, and the sign follows 2600, the bigger magnitude, which was negative. You're now 600 naira short." },
    { icon: "🏦", label: "Bank account", text: "Your account has 5000 naira. You withdraw 3000 naira, a change of negative 3000, then a friend pays you back 1200 naira, a change of positive 1200. Working left to right, that leaves 3200 naira in the account." },
    { icon: "🍪", label: "Shopping bill", text: "3 packs of biscuits at 150 naira each, plus a 50 naira delivery fee, is 3 times 150 plus 50, which is 500 naira. BODMAS says you multiply before you add, or you'd overcharge yourself." },
  ],
  speedTips: [
    "Whenever you see minus, open bracket, minus x, close bracket, rewrite it as plus x before doing anything else. It's the single biggest source of sign errors in objective questions.",
    "Scan an expression once, left to right, resolving every times or divide the moment you meet it, instead of doing a separate pass for multiplication and another for addition.",
  ],
  examples: [
    {
      tag: "Worked Example 1",
      problem: "Evaluate: negative 18 plus 25 minus, open bracket, negative 7, close bracket, times 2.",
      problemFormula: "−18 + 25 − (−7) × 2 = ?",
      steps: [
        { label: "Multiply first", caption: "Apply BODMAS and do the multiplication first. Minus 7 times 2 equals minus 14, because different signs give a negative answer.", formula: "(−7) × 2 = −14" },
        { label: "Rewrite the double negative", caption: "Rewrite subtracting a negative as a plain addition. Minus 18 plus 25 minus minus 14 becomes minus 18 plus 25 plus 14.", formula: "−18 + 25 − (−14) = −18 + 25 + 14" },
        { label: "Work left to right", caption: "Work left to right. Minus 18 plus 25 equals 7.", formula: "−18 + 25 = 7" },
        { label: "Finish the addition", caption: "Finish the addition. 7 plus 14 equals 21.", formula: "7 + 14 = 21" },
      ],
      answer: "21",
    },
    {
      tag: "Worked Example 2",
      problem: "Evaluate: negative 36 divided by negative 4, plus, negative 3 times 5.",
      problemFormula: "(−36) ÷ (−4) + (−3) × 5 = ?",
      steps: [
        { label: "Divide first", caption: "Divide first, since it's the same sign both times. Minus 36 divided by minus 4 equals 9, because same signs give a positive answer.", formula: "(−36) ÷ (−4) = 9" },
        { label: "Multiply next", caption: "Now multiply. Minus 3 times 5 equals minus 15, because different signs give a negative answer.", formula: "(−3) × 5 = −15" },
        { label: "Add the results", caption: "Add the two results together. 9 plus minus 15 is the same as 9 minus 15.", formula: "9 + (−15) = 9 − 15" },
        { label: "Subtract magnitudes", caption: "Subtract the magnitudes and keep the sign of the bigger one. 15 minus 9 is 6. Since 15, the negative one, has the bigger magnitude, the answer is negative.", formula: "15 − 9 = 6, answer −6" },
      ],
      answer: "−6",
    },
  ],
};

/* ---------------- build the beat timeline + matching DOM in one pass ---------------- */
let step = 0;
const timeline = []; // {clip, text} in beat order, index 0 == beat 1

function nextBeat() { return ++step; }

(function buildDom() {
  $("title").querySelector(".big").textContent = LESSON.title;
  $("title").querySelector(".kicker").textContent = LESSON.kicker;

  // concept
  {
    const s = nextBeat();
    timeline.push({ clip: "concept", text: LESSON.conceptIntro + " " + LESSON.rules.map((r) => r.t).join(" ") });
    const card = document.createElement("div");
    card.className = "concept-card beat";
    card.dataset.beat = s;
    card.innerHTML =
      `<div class="intro">${LESSON.conceptIntro}</div>` +
      LESSON.rules.map((r) => `<div class="rule"><div class="rule-k">${r.k}</div><div class="rule-t">${r.t}</div></div>`).join("");
    $("conceptArea").appendChild(card);
  }

  // real-life examples
  LESSON.realLifeExamples.forEach((r) => {
    const s = nextBeat();
    timeline.push({ clip: "real_" + s, text: r.text });
    const card = document.createElement("div");
    card.className = "real-card beat";
    card.dataset.beat = s;
    card.innerHTML = `<span class="icon">${r.icon}</span><div><span class="rl-k">${r.label}</span>${r.text}</div>`;
    $("realLifeList").appendChild(card);
  });

  // speed tips
  LESSON.speedTips.forEach((t) => {
    const s = nextBeat();
    timeline.push({ clip: "tip_" + s, text: t });
    const li = document.createElement("li");
    li.className = "beat";
    li.dataset.beat = s;
    li.textContent = t;
    $("tipsList").appendChild(li);
  });

  // worked examples
  LESSON.examples.forEach((ex) => {
    const wrap = document.createElement("div");
    wrap.className = "example";
    const ps = nextBeat();
    timeline.push({ clip: "ex_problem_" + ps, text: ex.problem });
    wrap.innerHTML =
      `<div class="example-head beat" data-beat="${ps}"><div class="tag">${ex.tag}</div><div class="prompt">${ex.problemFormula}</div></div>` +
      `<div class="example-body"><div class="ex-steps"></div><div class="ex-answer beat"></div></div>`;
    $("examplesArea").appendChild(wrap);

    const stepsWrap = wrap.querySelector(".ex-steps");
    ex.steps.forEach((st, si) => {
      const ss = nextBeat();
      timeline.push({ clip: "ex_step_" + ss, text: st.caption });
      const tile = document.createElement("div");
      tile.className = "step-tile beat";
      tile.dataset.beat = ss;
      tile.innerHTML =
        `<div class="num">${si + 1}</div><div class="body"><div class="label">${st.label}</div>` +
        `<div class="caption">${st.caption}</div><div class="formula">${st.formula}</div></div>`;
      stepsWrap.appendChild(tile);
    });

    const as = nextBeat();
    timeline.push({ clip: "ex_answer_" + as, text: "The answer is " + ex.answer });
    const aEl = wrap.querySelector(".ex-answer");
    aEl.dataset.beat = as;
    aEl.innerHTML = `✓ Answer: ${ex.answer}`;
  });
})();

const LAST = step;
const STEP = { TITLE: 0, OUTRO: LAST + 1 };

/* ---------------- rebuild the stage for any step (supports jump/replay) --- */
function resetTo(s) {
  $("title").classList.remove("show");
  $("outro").classList.remove("show");
  $("replay").style.display = "none";
  $("main").classList.toggle("show", s >= 1);
  document.querySelectorAll(".beat").forEach((el) => {
    const b = parseInt(el.dataset.beat, 10);
    el.classList.toggle("show", s > b);
    el.classList.remove("active");
  });
  player.sub(null);
}

/* ---------------- timeline ---------------- */
const player = createMotionPlayer({
  clipNames: ["intro", ...timeline.map((t) => t.clip), "outro"],
  maxStep: STEP.OUTRO,
});

async function run(from, my) {
  resetTo(from);
  player.step = from;

  if (from <= STEP.TITLE) {
    player.step = STEP.TITLE;
    $("title").classList.add("show");
    await player.speak("intro", `Let's explore: ${LESSON.title}`);
    if (my !== player.runToken) return;
    await player.wait(700, my);
    $("title").classList.remove("show");
    await player.wait(450, my);
  }

  $("main").classList.add("show");

  for (let s = 1; s <= LAST; s++) {
    if (from > s) continue;
    if (my !== player.runToken) return;
    player.step = s;
    const el = document.querySelector('.beat[data-beat="' + s + '"]');
    if (el) {
      el.classList.add("show", "active");
      el.scrollIntoView({ behavior: "smooth", block: "center" });
    }
    const t = timeline[s - 1];
    await player.speak(t.clip, t.text);
    if (my !== player.runToken) return;
    const f = el && el.querySelector(".formula");
    if (f) f.classList.add("show", "pop");
    if (el && el.classList.contains("ex-answer")) el.classList.add("pop");
    await player.wait(f ? 2200 : 1900, my);
    if (my !== player.runToken) return;
    if (el) el.classList.remove("active");
  }

  if (my !== player.runToken) return;
  player.step = STEP.OUTRO;
  $("outro").classList.add("show");
  await player.speak("outro", "Well done! You've explored this topic step by step.");
  if (my !== player.runToken) return;
  $("replay").style.display = "inline-block";
}

player.run = run;
player.wireControls();
