/* ============================================================
   MATHORA content-motion, shared timeline/audio engine.
   Content-agnostic. A lesson file creates one player, gives it
   an async `run(from)` timeline function (own beats + visuals),
   and wires the standard transport controls. See
   lessons/addition-worked-example/lesson.js for the reference
   usage.
   ============================================================ */
const $ = (id) => document.getElementById(id);

/**
 * @param {object} opts
 * @param {string[]} opts.clipNames   every narration clip key used by the lesson
 * @param {string} [opts.audioBase]   folder holding male/ and female/ wav subfolders (default "audio")
 * @param {number} opts.maxStep       highest step index the lesson's run() understands
 * @param {(from:number)=>Promise<void>} opts.run  the lesson's timeline, must respect player.runToken
 */
function createMotionPlayer(opts) {
  const { clipNames, audioBase = "audio", maxStep } = opts;

  const CLIPS = { male: {}, female: {} };
  for (const g of ["male", "female"]) {
    clipNames.forEach((n) => (CLIPS[g][n] = new Audio(`${audioBase}/${g}/${n}.wav`)));
  }

  const player = {
    runToken: 0,
    paused: false,
    current: null,
    runStartedAt: 0,
    gender: null,
    speed: 1,
    step: 0,
    started: false,
    subOn: localStorage.getItem("motion_sub") !== "off",
    run: null, // set below once lesson supplies it
  };

  /** Roughly how long a caption takes to read, used only when a clip is missing/errors.
      Paced for a first-time SS1 learner reading full sentences, not a skimmer: a comfortable
      words-per-minute rate plus a floor so even short lines don't flash by. */
  function fallbackMs(text) {
    if (!text) return 1000;
    return Math.min(11000, Math.max(2200, 1200 + text.length * 65));
  }

  /**
   * Play a narration clip and resolve once it ends (or errors / is missing).
   * `text` is shown as the caption and also drives the no-audio fallback pause,
   * so the lesson paces sensibly with or without real wav files.
   */
  player.speak = function speak(name, text, my) {
    player.sub(text);
    return new Promise((resolve) => {
      if (my !== player.runToken) return resolve();
      const a = CLIPS[player.gender] && CLIPS[player.gender][name];
      if (!a) return player.wait(fallbackMs(text), my).then(resolve);
      player.current = a;
      a.currentTime = 0;
      a.playbackRate = player.speed;
      let settled = false;
      const done = (playedOk) => {
        if (settled) return;
        settled = true;
        player.current = null;
        if (playedOk) return resolve();
        player.wait(fallbackMs(text), my).then(resolve);
      };
      a.onended = () => done(true);
      a.onerror = () => done(false);
      if (!player.paused) a.play().catch(() => done(false));
    });
  };

  player.wait = function wait(ms, my) {
    return new Promise((res) => {
      let left = ms;
      (function tick() {
        if (my !== player.runToken) return res();
        if (player.paused) return setTimeout(tick, 100);
        if (left <= 0) return res();
        left -= 100 * player.speed;
        setTimeout(tick, 100);
      })();
    });
  };

  player.sub = function sub(text) {
    const s = $("subtitle");
    if (!text || !player.subOn) {
      s.classList.remove("show");
      return;
    }
    s.textContent = text;
    s.classList.add("show");
  };

  /* ---------------- transport ---------------- */
  function updatePP() {
    $("btnPP").textContent = player.paused ? "▶" : "⏸";
    $("status").style.display = player.paused ? "inline-block" : "none";
  }
  function togglePause() {
    if (!player.started) return;
    player.paused = !player.paused;
    if (player.current) {
      player.paused ? player.current.pause() : player.current.play().catch(() => {});
    }
    updatePP();
  }
  function start(from) {
    const my = ++player.runToken;
    player.paused = false;
    updatePP();
    if (player.current) {
      player.current.pause();
      player.current = null;
    }
    player.runStartedAt = Date.now();
    player.run(from, my);
  }
  function jump(s) {
    if (!player.started) return;
    start(Math.max(0, Math.min(maxStep, s)));
  }
  function setGender(g) {
    player.gender = g;
    $("pickBoy").classList.toggle("sel", g === "male");
    $("pickGirl").classList.toggle("sel", g === "female");
    $("btnGender").textContent = g === "male" ? "👦" : "👧";
    $("playBtn").style.display = "block";
    $("startHint").textContent = "Tap to start 🔊";
  }

  player.wireControls = function wireControls() {
    $("pickBoy").addEventListener("click", (e) => { e.stopPropagation(); setGender("male"); });
    $("pickGirl").addEventListener("click", (e) => { e.stopPropagation(); setGender("female"); });
    $("playBtn").addEventListener("click", (e) => {
      e.stopPropagation();
      $("overlay").classList.add("hide");
      player.started = true;
      start(0);
    });
    $("replay").addEventListener("click", (e) => { e.stopPropagation(); start(0); });
    $("btnPrev").addEventListener("click", (e) => { e.stopPropagation(); jump(player.step - 1); });
    $("btnNext").addEventListener("click", (e) => { e.stopPropagation(); jump(player.step + 1); });
    $("btnPP").addEventListener("click", (e) => { e.stopPropagation(); togglePause(); });
    $("selSpeed").addEventListener("change", (e) => {
      player.speed = parseFloat(e.target.value);
      if (player.current) player.current.playbackRate = player.speed;
    });
    $("selSpeed").addEventListener("click", (e) => e.stopPropagation());
    $("btnGender").addEventListener("click", (e) => {
      e.stopPropagation();
      if (!player.gender) return;
      setGender(player.gender === "male" ? "female" : "male");
    });
    $("btnSub").addEventListener("click", (e) => {
      e.stopPropagation();
      player.subOn = !player.subOn;
      localStorage.setItem("motion_sub", player.subOn ? "on" : "off");
      $("btnSub").classList.toggle("off", !player.subOn);
      if (!player.subOn) $("subtitle").classList.remove("show");
    });
    $("btnSub").classList.toggle("off", !player.subOn);

    $("stage").addEventListener("click", (e) => {
      if (e.target.closest("#overlay") || e.target.closest("#replay") || e.target.closest("#ctlbar")) return;
      if (!$("overlay").classList.contains("hide")) return;
      if (Date.now() - player.runStartedAt < 500) return;
      togglePause();
    });
  };

  return player;
}
