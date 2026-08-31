# content-motion, narrated video-style lessons

A prototype, modeled on the huruf-videos "Nun" lesson style
(`MU'ALLIMUL_HURUUF/noor-al-bayan/LESSONS/huruf-videos/noon/index.html`):
a self-paced, replayable, narrated "video" built from HTML/CSS/JS instead
of an actual video file. Same engine, math content instead of Arabic
letter forms.

Visual language now matches mathora-web's DCOMPANION brand (`globals.css`,
`Primitives.tsx`, `mathora-mobile/src/constants/theme.ts`): Space Grotesk
display type, Plus Jakarta Sans body copy, JetBrains Mono for numbers and
formulas, the amber/emerald/rose/indigo accent roles, and the same graph-paper
surface texture used across the app. This lives in `engine/core.css`, so
every lesson gets it automatically.

## Layout

```
content-motion/
  engine/
    core.css   shared stage/controls/overlay/title/outro/subtitle styles
    core.js    shared timeline + audio engine (createMotionPlayer)
  lessons/
    addition-worked-example/          reference lesson: one problem, fixed STEP map
    ss1-w1-signs-example-1/           SS1 First Term Week 1, one worked example each
    ss1-w1-signs-example-2/
    ss1-w1-rounding-dp-sf/
    ss1-w1-percentage-error/
    ss1-w1-topic-b-adding-bodmas/     a full topic: concept + real-life examples +
                                       speed tips + two worked examples in one lesson
      index.html   DOM skeleton for this one lesson
      lesson.css   this lesson's content layer only
      lesson.js    this lesson's data + timeline (run())
      audio/male/, audio/female/   drop wav files here, named to match clipNames
```

`engine/` is content-agnostic and shouldn't be touched per-lesson, a new
lesson gets its own folder under `lessons/` with its own `.css`/`.js`,
same as the ones above.

## Two lesson shapes

**Single worked example** (`addition-worked-example`, `ss1-w1-signs-example-1`,
`ss1-w1-signs-example-2`, `ss1-w1-rounding-dp-sf`, `ss1-w1-percentage-error`):
one problem, a fixed `STEP` map (`TITLE`, `PROBLEM`, `FIRST_SOLVE..`, `REAL`,
`SHORTCUT`, `TRAP`, `OUTRO`). Good for a single, short walkthrough.

**Full topic** (`ss1-w1-topic-b-adding-bodmas`): a topic usually has a rule
explanation, several real-life examples, more than one speed tip, and more
than one worked example, none of which fit a fixed STEP map cleanly. That
lesson instead builds a flat, numbered "beat" timeline at load time from a
richer `LESSON` object (`rules`, `realLifeExamples`, `speedTips`,
`examples[]`), tags every beat's DOM element with `data-beat="N"`, and
drives `resetTo`/`run` generically off that list instead of named
constants. Copy this shape (not the single-example one) for any lesson
whose content matches a full topic in the curated syllabus notes rather
than one isolated problem.

## Why it's shaped this way

- **Stage + timeline, not a real video.** `#stage` is a fixed 16:9 box;
  `run(from, my)` walks through numbered steps with `await player.speak()`
  and `await player.wait()`. That gives free scrubbing (prev/next),
  pause/resume mid-sentence, and replay, none of which a rendered mp4
  gives you cheaply.
- **`runToken` guard.** Every jump/replay bumps a token; every awaited
  step checks `my !== player.runToken` before continuing. Skip this and
  a stale timeline from before a replay keeps animating over the new one.
- **Audio-first with a graceful fallback.** `player.speak(name, text, my)`
  tries a real wav file (`audio/<gender>/<name>.wav`); on 404/error it instead
  shows `text` as a caption and paces itself by reading time (tuned for a
  full-sentence read, not a skim, see `fallbackMs` in `core.js`). So a
  lesson is watchable today with **zero audio files**, and dropping in
  real narration later doesn't require touching any layout code.
- **Content shape matches the LLM pipeline.** The single-example `LESSON`
  shape deliberately mirrors `GeneratedWorkedExample` in
  `content-worker/app/schema.py` (`title`, `problem_statement` maps to
  `problem`, `solution_steps[]` maps to `steps[].caption`, `exam_shortcut`,
  `common_trap_warning`, `real_life_context`). The extras (`formula`,
  `label`, `problemIcons`) are display sugar this player adds on top; a
  generator could emit plain `solution_steps` strings and a lesson author
  (or a follow-up LLM pass) fills in the formula/label per step. The
  full-topic shape extends this the same way: `realLifeExamples` and
  `speedTips` become arrays instead of single strings, and `examples[]`
  holds one or more problems in the single-example shape.

## Adding a new lesson

1. Decide which shape fits: one problem, or a full topic (see above).
2. Copy the closest existing lesson folder to a new one.
3. Edit the `LESSON` object in `lesson.js`: title, problem(s)/rules,
   real-life examples, speed tips, trap warnings.
4. Adjust `lesson.css`/the content div in `index.html` only if the topic
   needs a different visual (a number line, a shape, a graph) instead of
   the step-tile rail; keep the engine calls (`player.speak`,
   `player.wait`, `resetTo`) and the `.beat`/`data-beat` convention the
   same so scrubbing and replay keep working.
5. Record narration and drop wav files into `audio/male/` and `audio/female/`,
   named exactly like the `clipNames` passed to `createMotionPlayer`.
   Until then, the lesson runs on the caption fallback described above.

## Open it

No build step, open a lesson's `index.html` directly in a browser, or
serve the `content-motion/` folder with any static server.

## Next steps worth discussing

- Real narration audio. No `GEMINI_API_KEY` (or any TTS credential) was
  available in the environment these lessons were built in, so every
  lesson here still runs on the caption fallback. Drop a working key into
  `content-worker/.env` (or hand it to the session directly) and this
  becomes the next thing to wire up: a TTS pass that renders each
  `clipNames` entry to `audio/male/<name>.wav` and `audio/female/<name>.wav`.
- Rebuilding the remaining SS1 Week 1 topics (multiply/divide signs,
  rounding, percentage error) in the full-topic shape, the way
  `ss1-w1-topic-b-adding-bodmas` was, so every topic in the curated notes
  gets the same complete treatment instead of just its worked examples.
- Where this eventually lives relative to `mathora-web` (served from
  `public/`, or generated straight into the Next.js app) and how a
  `worked_examples` row would route to a rendered lesson.
