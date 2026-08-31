/* ============================================================
   Lesson content, shape deliberately mirrors GeneratedWorkedExample
   in content-worker/app/schema.py (title, problem_statement,
   solution_steps[], exam_shortcut, common_trap_warning,
   real_life_context) so this could eventually be fed straight from
   the generator pipeline. `formula`/`label` per step are display
   extras this player adds on top of a plain solution_steps string.

   SS1 Mathematics, First Term, Week 1, Worked Example 4:
   percentage error.
   ============================================================ */
const LESSON = {
  kicker: "Worked Example",
  title: "Percentage Error",
  problem: "A rope of exact length 4.85 metres was measured as 4.95 metres. Find the percentage error.",
  problemIcons: "📏 📐",
  problemFormula: "PE = (error ÷ exact value) × 100%",
  steps: [
    { label: "Find the error", caption: "Find the error. It's always positive, the difference between the measured value and the exact value. 4.95 minus 4.85 equals 0.10 metres.", formula: "error = |4.95 − 4.85| = 0.10 m" },
    { label: "Write the formula", caption: "Write down the percentage error formula. Percentage error equals error divided by the exact value, all times 100 percent.", formula: "PE = (error ÷ exact) × 100%" },
    { label: "Substitute", caption: "Substitute in our numbers. That's 0.10 divided by 4.85, times 100 percent.", formula: "PE = (0.10 ÷ 4.85) × 100%" },
    { label: "Simplify the fraction", caption: "Simplify the fraction first, to keep exact values. 0.10 over 4.85 simplifies to 10 over 485, which simplifies further to 2 over 97.", formula: "0.10/4.85 = 2/97" },
    { label: "Multiply by 100", caption: "Multiply by 100. So the percentage error is 2 over 97 times 100 percent, which is 200 over 97 percent.", formula: "PE = 200/97 %" },
    { label: "Sense check", caption: "As a sense check, let's turn that into a decimal. 200 divided by 97 is approximately 2.06.", formula: "200 ÷ 97 ≈ 2.06%" },
  ],
  realLife: "A tailor measures a customer's waist as 82 centimetres, but the true measurement, double checked with a calibrated tape, is 80 centimetres. Percentage error tells the tailor how far off their usual tape reading habit is.",
  shortcut: "Percentage error always divides by the exact or true value, never the estimate. It's usually the value described as actual, true, or given first in the question.",
  trap: "Don't divide by the measured or estimated value. The exact value always goes on the bottom of the fraction.",
};

const N = LESSON.steps.length;
// step map: 0 title, 1 problem, 2..(1+N) each solution step, then real-life, shortcut, trap, outro
const STEP = {
  TITLE: 0,
  PROBLEM: 1,
  FIRST_SOLVE: 2,
  REAL: 2 + N,
  SHORTCUT: 3 + N,
  TRAP: 4 + N,
  OUTRO: 5 + N,
};

/* ---------------- build static DOM for the step tiles/callouts ---------------- */
(function buildDom() {
  $("problemCard").querySelector(".icons").textContent = LESSON.problemIcons;
  $("problemCard").querySelector(".text").textContent = LESSON.problem;
  $("problemCard").querySelector(".formula").textContent = LESSON.problemFormula;
  $("title").querySelector(".big").textContent = LESSON.title;
  $("title").querySelector(".kicker").textContent = LESSON.kicker;

  const list = $("stepList");
  LESSON.steps.forEach((s, i) => {
    const tile = document.createElement("div");
    tile.className = "step-tile";
    tile.id = "step-" + i;
    tile.innerHTML =
      `<div class="num">${i + 1}</div>` +
      `<div class="body">` +
      `<div class="label">${s.label}</div>` +
      `<div class="caption">${s.caption}</div>` +
      `<div class="formula">${s.formula}</div>` +
      `</div>`;
    list.appendChild(tile);
  });

  const co = $("callouts");
  co.innerHTML =
    `<div class="callout real" id="co-real"><span class="ico">🌍</span><span>${LESSON.realLife}</span></div>` +
    `<div class="callout shortcut" id="co-shortcut"><span class="ico">⚡</span><span>${LESSON.shortcut}</span></div>` +
    `<div class="callout trap" id="co-trap"><span class="ico">⚠️</span><span>${LESSON.trap}</span></div>`;
})();

/* ---------------- rebuild the stage for any step (supports jump/replay) --- */
function resetTo(s) {
  $("title").classList.remove("show");
  $("outro").classList.remove("show");
  $("replay").style.display = "none";
  $("main").classList.toggle("show", s >= STEP.PROBLEM);
  $("problemCard").classList.toggle("show", s >= STEP.PROBLEM);

  LESSON.steps.forEach((_, i) => {
    const tile = $("step-" + i);
    const shown = s > STEP.FIRST_SOLVE + i || s >= STEP.REAL;
    tile.classList.toggle("show", shown);
    tile.classList.toggle("active", false);
    tile.querySelector(".formula").classList.toggle("show", shown);
  });

  $("co-real").classList.toggle("show", s > STEP.REAL || s >= STEP.SHORTCUT);
  $("co-shortcut").classList.toggle("show", s > STEP.SHORTCUT || s >= STEP.TRAP);
  $("co-trap").classList.toggle("show", s > STEP.TRAP || s >= STEP.OUTRO);

  player.sub(null);
}

/* ---------------- timeline ---------------- */
const player = createMotionPlayer({
  clipNames: [
    "intro", "problem",
    ...LESSON.steps.map((_, i) => "step_" + i),
    "real_life", "shortcut", "trap", "outro",
  ],
  maxStep: STEP.OUTRO,
});

async function run(from, my) {
  resetTo(from);
  player.step = from;

  if (from <= STEP.TITLE) {
    player.step = STEP.TITLE;
    $("title").classList.add("show");
    await player.speak("intro", `Let's learn to solve: ${LESSON.problem}`);
    if (my !== player.runToken) return;
    await player.wait(700, my);
    $("title").classList.remove("show");
    await player.wait(450, my);
  }

  if (from <= STEP.PROBLEM) {
    if (my !== player.runToken) return;
    player.step = STEP.PROBLEM;
    $("main").classList.add("show");
    $("problemCard").classList.add("show");
    await player.speak("problem", LESSON.problem);
    if (my !== player.runToken) return;
    await player.wait(1300, my);
  }

  for (let i = 0; i < N; i++) {
    const stepNum = STEP.FIRST_SOLVE + i;
    if (from > stepNum) continue;
    if (my !== player.runToken) return;
    player.step = stepNum;
    $("main").classList.add("show");
    const tile = $("step-" + i);
    tile.classList.add("show", "active");
    await player.speak("step_" + i, LESSON.steps[i].caption);
    if (my !== player.runToken) return;
    const f = tile.querySelector(".formula");
    f.classList.add("show", "pop");
    await player.wait(2100, my);
    if (my !== player.runToken) return;
    tile.classList.remove("active");
  }

  const calloutSteps = [
    { step: STEP.REAL, id: "co-real", clip: "real_life", text: LESSON.realLife },
    { step: STEP.SHORTCUT, id: "co-shortcut", clip: "shortcut", text: LESSON.shortcut },
    { step: STEP.TRAP, id: "co-trap", clip: "trap", text: LESSON.trap },
  ];
  for (const c of calloutSteps) {
    if (from > c.step) continue;
    if (my !== player.runToken) return;
    player.step = c.step;
    $(c.id).classList.add("show");
    await player.speak(c.clip, c.text);
    if (my !== player.runToken) return;
    await player.wait(1200, my);
  }

  if (my !== player.runToken) return;
  player.step = STEP.OUTRO;
  $("outro").classList.add("show");
  await player.speak("outro", "Well done! You've solved it step by step.");
  if (my !== player.runToken) return;
  $("replay").style.display = "inline-block";
}

player.run = run;
player.wireControls();
