#!/usr/bin/env python3
"""Generate real narration audio for a content-motion lesson via Gemini TTS.

Reads GEMINI_API_KEY from content-worker/.env (never hardcoded, never
committed), calls the gemini-2.5-flash-preview-tts model once per clip per
voice, wraps the raw 16-bit/24kHz PCM response in a WAV header, and writes
audio/<male|female>/<clip_name>.wav for each lesson folder. Safe to re-run:
skips a file that already exists unless --force is passed.

Usage: python3 scripts/generate_tts.py
"""
import base64
import json
import os
import struct
import sys
import time
import urllib.error
import urllib.request

HERE = os.path.dirname(os.path.abspath(__file__))
ROOT = os.path.dirname(HERE)  # content-motion/
ENV_PATH = os.path.join(os.path.dirname(ROOT), "content-worker", ".env")

MODEL = "gemini-2.5-flash-preview-tts"
VOICES = {"male": "Puck", "female": "Kore"}


def load_key():
    with open(ENV_PATH, encoding="utf-8") as f:
        for line in f:
            if line.startswith("GEMINI_API_KEY="):
                v = line.strip().split("=", 1)[1]
                if v and "your-gemini" not in v:
                    return v
    raise SystemExit(f"No usable GEMINI_API_KEY found in {ENV_PATH}")


def pcm_to_wav(pcm_bytes, sample_rate=24000, channels=1, bits=16):
    byte_rate = sample_rate * channels * bits // 8
    block_align = channels * bits // 8
    data_len = len(pcm_bytes)
    header = b"RIFF" + struct.pack("<I", 36 + data_len) + b"WAVEfmt "
    header += struct.pack("<IHHIIHH", 16, 1, channels, sample_rate, byte_rate, block_align, bits)
    header += b"data" + struct.pack("<I", data_len)
    return header + pcm_bytes


def synthesize(key, text, voice_name, style_hint):
    url = f"https://generativelanguage.googleapis.com/v1beta/models/{MODEL}:generateContent?key={key}"
    prompt = f"{style_hint}: {text}"
    payload = {
        "contents": [{"parts": [{"text": prompt}]}],
        "generationConfig": {
            "responseModalities": ["AUDIO"],
            "speechConfig": {"voiceConfig": {"prebuiltVoiceConfig": {"voiceName": voice_name}}},
        },
    }
    req = urllib.request.Request(
        url, data=json.dumps(payload).encode(), headers={"Content-Type": "application/json"}
    )
    last_err = None
    for attempt in range(3):
        try:
            with urllib.request.urlopen(req, timeout=60) as resp:
                data = json.loads(resp.read())
            part = data["candidates"][0]["content"]["parts"][0]["inlineData"]
            return base64.b64decode(part["data"])
        except urllib.error.HTTPError as e:
            body = e.read().decode(errors="replace")[:500]
            last_err = f"HTTP {e.code}: {body}"
            if e.code == 429:
                time.sleep(8 * (attempt + 1))
                continue
            break
        except Exception as e:  # noqa: BLE001
            last_err = f"{type(e).__name__}: {e}"
            time.sleep(3)
    raise RuntimeError(last_err)


def generate_lesson(lesson_dir, clips, force=False):
    """clips: list of (clip_name, text) tuples, in the exact order/spelling
    used by that lesson's clipNames / player.speak() calls."""
    key = load_key()
    name = os.path.basename(lesson_dir.rstrip("/\\"))
    for gender, voice in VOICES.items():
        out_dir = os.path.join(lesson_dir, "audio", gender)
        os.makedirs(out_dir, exist_ok=True)
        style = (
            "Say in a warm, encouraging voice for a Nigerian SS1 maths student, clear and unhurried"
            if gender == "female"
            else "Say in a friendly, confident voice for a Nigerian SS1 maths student, clear and unhurried"
        )
        for clip_name, text in clips:
            out_path = os.path.join(out_dir, clip_name + ".wav")
            if os.path.exists(out_path) and not force:
                print(f"  [skip] {name}/{gender}/{clip_name}.wav (exists)")
                continue
            try:
                pcm = synthesize(key, text, voice, style)
                wav = pcm_to_wav(pcm)
                with open(out_path, "wb") as f:
                    f.write(wav)
                print(f"  [ok]   {name}/{gender}/{clip_name}.wav ({len(wav)} bytes)")
            except Exception as e:  # noqa: BLE001
                print(f"  [FAIL] {name}/{gender}/{clip_name}.wav: {e}")
            time.sleep(1.2)  # be gentle with the free-tier rate limit


if __name__ == "__main__":
    print("Run this via generate_topic_b.py / generate_<lesson>.py, it only defines the helpers.")
