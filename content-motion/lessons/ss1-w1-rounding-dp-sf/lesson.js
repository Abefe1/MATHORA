/* ============================================================
   Lesson content, shape deliberately mirrors GeneratedWorkedExample
   in content-worker/app/schema.py (title, problem_statement,
   solution_steps[], exam_shortcut, common_trap_warning,
   real_life_context) so this could eventually be fed straight from
   the generator pipeline. `formula`/`label` per step are display
   extras this player adds on top of a plain solution_steps string.

   SS1 Mathematics, First Term, Week 1, Worked Example 3:
   decimal places and significant figures.
   ============================================================ */
const LESSON = {
  kicker: "Worked Example",
  title: "Decimal Places and Significant Figures",
  problem: "Express 65009 point 269 correct to: a, 1 decimal place, and b, 1 significant figure.",
  problemIcons: "🔢 🎯",
  problemFormula: "65009.269 → (a) 1 d.p. (b) 1 s.f.",
  steps: [
    { label: "Find the 1st decimal place", caption: "Part a. First find the digit in the 1st decimal place. That's the digit right after the dot. It's 2.", formula: "65009.269 → tenths digit = 2" },
    { label: "Check the next digit", caption: "Now look at the very next digit, the hundredths digit, to decide whether to round up. It's 6, and 6 is 5 or more, so we round up.", formula: "next digit = 6 ≥ 5 → round up" },
    { label: "Round part a", caption: "So we increase that 2 to a 3, and drop everything after it.", formula: "(a) 65009.3" },
    { label: "Find the first significant figure", caption: "Part b. Now find the first significant figure, the very first digit that isn't zero, reading from the left. That's 6, and it sits in the ten-thousands position, worth 60000.", formula: "first s.f. = 6 (ten-thousands)" },
    { label: "Check the next digit", caption: "Look at the very next digit to decide the rounding. That's 5, so we round up.", formula: "next digit = 5 → round up" },
    { label: "Round part b", caption: "Round the 6 up to a 7, and replace every digit after it with zero, to keep the place value correct.", formula: "(b) 70000" },
  ],
  realLife: "A trader's scale shows a bag of rice as 50 point 478 kilograms. Market receipts round weights to 1 decimal place, so it's written as 50 point 5 kilograms.",
  shortcut: "5 and above, give it a shove. 4 and below, let it go. Look only at the one digit right after your cut off point, nothing further along.",
  trap: "Dropped digits in a whole number become zeros, not blanks. 51065 to 3 significant figures is 51100, not 511.",
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
