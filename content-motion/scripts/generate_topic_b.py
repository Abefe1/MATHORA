#!/usr/bin/env python3
"""Generate all narration clips for lessons/ss1-w1-topic-b-adding-bodmas.

Clip names/texts here must exactly match what lesson.js's timeline builds
(the nextBeat() counter in buildDom()), so the browser Audio() lookups
(audio/<gender>/<clip_name>.wav) actually resolve.
"""
import os
import sys

sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
from generate_tts import generate_lesson

ROOT = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
LESSON_DIR = os.path.join(ROOT, "lessons", "ss1-w1-topic-b-adding-bodmas")

TITLE = "Adding Directed Numbers and BODMAS"

CONCEPT_INTRO = "Two rules for adding directed numbers, plus the order you must do things in."
RULES = [
    "Add the magnitudes together, and keep that shared sign.",
    "Find the difference between the two magnitudes. The answer takes the sign of whichever number has the bigger magnitude.",
    "Brackets, Of, Division, Multiplication, Addition, Subtraction. Do brackets first, then any of, then every times or divide, then every plus or minus.",
]

REAL_LIFE = [
    "You have 2000 naira airtime credit and buy a 2600 naira data bundle. An expense is negative, so that's 2000 plus negative 2600. Different signs: the difference of the magnitudes is 600, and the sign follows 2600, the bigger magnitude, which was negative. You're now 600 naira short.",
    "Your account has 5000 naira. You withdraw 3000 naira, a change of negative 3000, then a friend pays you back 1200 naira, a change of positive 1200. Working left to right, that leaves 3200 naira in the account.",
    "3 packs of biscuits at 150 naira each, plus a 50 naira delivery fee, is 3 times 150 plus 50, which is 500 naira. BODMAS says you multiply before you add, or you'd overcharge yourself.",
]

TIPS = [
    "Whenever you see minus, open bracket, minus x, close bracket, rewrite it as plus x before doing anything else. It's the single biggest source of sign errors in objective questions.",
    "Scan an expression once, left to right, resolving every times or divide the moment you meet it, instead of doing a separate pass for multiplication and another for addition.",
]

EX1_PROBLEM = "Evaluate: negative 18 plus 25 minus, open bracket, negative 7, close bracket, times 2."
EX1_STEPS = [
    "Apply BODMAS and do the multiplication first. Minus 7 times 2 equals minus 14, because different signs give a negative answer.",
    "Rewrite subtracting a negative as a plain addition. Minus 18 plus 25 minus minus 14 becomes minus 18 plus 25 plus 14.",
    "Work left to right. Minus 18 plus 25 equals 7.",
    "Finish the addition. 7 plus 14 equals 21.",
]
EX1_ANSWER = "The answer is 21"

EX2_PROBLEM = "Evaluate: negative 36 divided by negative 4, plus, negative 3 times 5."
EX2_STEPS = [
    "Divide first, since it's the same sign both times. Minus 36 divided by minus 4 equals 9, because same signs give a positive answer.",
    "Now multiply. Minus 3 times 5 equals minus 15, because different signs give a negative answer.",
    "Add the two results together. 9 plus minus 15 is the same as 9 minus 15.",
    "Subtract the magnitudes and keep the sign of the bigger one. 15 minus 9 is 6. Since 15, the negative one, has the bigger magnitude, the answer is negative.",
]
EX2_ANSWER = "The answer is negative 6"

OUTRO = "Well done! You've explored this topic step by step."

# beat numbering must match lesson.js's nextBeat() call order exactly
clips = [("intro", f"Let's explore: {TITLE}")]
clips.append(("concept", CONCEPT_INTRO + " " + " ".join(RULES)))
for i, t in enumerate(REAL_LIFE):
    clips.append((f"real_{2+i}", t))
for i, t in enumerate(TIPS):
    clips.append((f"tip_{5+i}", t))
clips.append(("ex_problem_7", EX1_PROBLEM))
for i, t in enumerate(EX1_STEPS):
    clips.append((f"ex_step_{8+i}", t))
clips.append(("ex_answer_12", EX1_ANSWER))
clips.append(("ex_problem_13", EX2_PROBLEM))
for i, t in enumerate(EX2_STEPS):
    clips.append((f"ex_step_{14+i}", t))
clips.append(("ex_answer_18", EX2_ANSWER))
clips.append(("outro", OUTRO))

if __name__ == "__main__":
    print(f"Generating {len(clips)} clips x 2 voices for ss1-w1-topic-b-adding-bodmas...")
    generate_lesson(LESSON_DIR, clips, force="--force" in sys.argv)
    print("Done.")
