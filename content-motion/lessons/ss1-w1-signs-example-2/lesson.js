/* ============================================================
   Lesson content, shape deliberately mirrors GeneratedWorkedExample
   in content-worker/app/schema.py (title, problem_statement,
   solution_steps[], exam_shortcut, common_trap_warning,
   real_life_context) so this could eventually be fed straight from
   the generator pipeline. `formula`/`label` per step are display
   extras this player adds on top of a plain solution_steps string.

   SS1 Mathematics, First Term, Week 1, Worked Example 2:
   dividing and multiplying directed numbers.
   ============================================================ */
const LESSON = {
  kicker: "Worked Example",
  title: "Dividing and Multiplying Directed Numbers",
  problem: "Evaluate: negative 36 divided by negative 4, plus, negative 3 times 5.",
  problemIcons: "🧮 ➗ ✖️",
  problemFormula: "(−36) ÷ (−4) + (−3) × 5 = ?",
  steps: [
    { label: "Divide first", caption: "Divide first, since it's the same sign both times. Minus 36 divided by minus 4 equals 9, because same signs give a positive answer.", formula: "(−36) ÷ (−4) = 9" },
    { label: "Multiply next", caption: "Now multiply. Minus 3 times 5 equals minus 15, because different signs give a negative answer.", formula: "(−3) × 5 = −15" },
    { label: "Add the results", caption: "Add the two results together. 9 plus minus 15 is the same as 9 minus 15.", formula: "9 + (−15) = 9 − 15" },
    { label: "Subtract magnitudes", caption: "Subtract the magnitudes and keep the sign of the bigger one. 15 minus 9 is 6. Since 15, the negative one, has the bigger magnitude, the answer is negative.", formula: "15 − 9 = 6, answer −6" },
  ],
  realLife: "A submarine dives 3 times, and each dive takes it 40 metres deeper, a change of negative 40 metres. After the 3 dives, 3 times negative 40 equals negative 120 metres, so it's 120 metres below the surface.",
  shortcut: "Scan an expression once, left to right, resolving every times or divide the moment you meet it, instead of doing a separate pass for multiplication and another for addition.",
  trap: "Don't divide and multiply out of order. Work strictly left to right through the times and divide signs before touching any plus or minus.",
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
