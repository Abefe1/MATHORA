/* ============================================================
   Lesson content, shape deliberately mirrors GeneratedWorkedExample
   in content-worker/app/schema.py (title, problem_statement,
   solution_steps[], exam_shortcut, common_trap_warning,
   real_life_context) so this could eventually be fed straight from
   the generator pipeline. `formula`/`label` per step are display
   extras this player adds on top of a plain solution_steps string.

   SS1 Mathematics, First Term, Week 1, Worked Example 1:
   directed numbers with BODMAS.
   ============================================================ */
const LESSON = {
  kicker: "Worked Example",
  title: "Directed Numbers with BODMAS",
  problem: "Evaluate: negative 18 plus 25 minus, open bracket, negative 7, close bracket, times 2.",
  problemIcons: "🧮 ➕ ➖ ✖️",
  problemFormula: "−18 + 25 − (−7) × 2 = ?",
  steps: [
    { label: "Multiply first", caption: "Apply BODMAS and do the multiplication first. Minus 7 times 2 equals minus 14, because different signs give a negative answer.", formula: "(−7) × 2 = −14" },
    { label: "Rewrite the double negative", caption: "Rewrite subtracting a negative as a plain addition. Minus 18 plus 25 minus minus 14 becomes minus 18 plus 25 plus 14.", formula: "−18 + 25 − (−14) = −18 + 25 + 14" },
    { label: "Work left to right", caption: "Work left to right. Minus 18 plus 25 equals 7.", formula: "−18 + 25 = 7" },
    { label: "Finish the addition", caption: "Finish the addition. 7 plus 14 equals 21.", formula: "7 + 14 = 21" },
  ],
  realLife: "You owe 3 friends 500 naira each. A debt is a negative amount, so 3 times negative 500 naira is negative 1500 naira. Different signs give a negative answer, meaning you're 1500 naira in the hole.",
  shortcut: "Whenever you see minus, open bracket, minus x, close bracket, rewrite it as plus x before doing anything else. It's the single biggest source of sign errors in objective questions.",
  trap: "Don't add before you multiply. BODMAS means every times or divide gets resolved before any plus or minus, scanning the expression once from left to right.",
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
