---
name: ugc-influencer-video
description: The complete house method for writing AI-influencer video prompts (Seedance 2.5 / Higgsfield) for character-driven fake-UGC content — talking clips with voice lock, off-camera interview clips, silent text-over b-roll, and continue-from-last-frame prompts, plus voice prompts and avatar/location stills. Built on the Sienna/Amos/Vivienne pipeline. Use this WHENEVER the user asks for a video prompt for a character/influencer ("дай промпт на видео", "промпт для ролика", "text-over", "b-roll", "интервью-клип", "продолжи видео"), mentions a character sheet + location + voice reference workflow, RELIGHT, UGC style, or asks to script/prompt content for a fictional social-media persona — even if they don't name a specific tool.
---

# UGC Influencer Video Prompts

House method for prompting character videos that read as REAL social-media content: a fictional influencer filmed on a phone, never a commercial. Refined across three characters (Sienna 22 — relationships; Amos 101 — health; Vivienne 82 — wealth) and ~40 production prompts.

## Reply format

**Write your commentary in whatever language the user's request is in; the prompts you give are ALWAYS in English.** Reply with: a short intro in the user's language (what creative choices you made and why), then ONE complete English prompt per video in a single code block, then up to 3 short follow-up options in the user's language. Deliver prompts in chat; build a .docx master only when asked ("собери в документ"). For batches, one code block per video with a short header line in the user's language.

## Step 1 — Route to the right format

| Situation | Format |
|---|---|
| Character speaks to camera, films themselves | **A. Talking clip** (voice lock) |
| Character answers an off-camera interviewer | **B. Interview clip** |
| No dialogue; script goes ON TOP as overlay added in post | **C. Silent text-over b-roll** |
| Part 2+ of a long script; Part 1 attached as reference | **D. Continuation** |

Durations: the generator caps at **30 seconds**. Estimate speech at ~165 wpm normal, ~200+ wpm brisk. Script + final beat must fit; near the cap, shrink the post-audio beat to 1–2s and note "audio paced to ≤28s". Longer scripts: split into two setups joined by ONE hard cut (voice and ambience explicitly continuous across it), or write Part 2 as a Continuation prompt. Never more than one cut per generation.

## Step 2 — Assemble the prompt from these sections, in this order

```
TOP PRIORITY (read first): numbered list of the 4-6 rules this specific video lives or dies by
=== REFERENCE KEY (attach in this order) ===  @image1 character / @image2 location / @audio1 voice (or @video1 for continuation)
CRITICAL — RELIGHT
IMAGE QUALITY
Style
Camera movement (or CAMERA & EDIT STRUCTURE when there is a cut)
ACTING TASK (talking/interview) or Performance (b-roll)
Physics
Composition
Consistency
Editing
Technical
ON-SCREEN TEXT: none. (Added in post by the team.)
Audio
Mood & tempo
SHOT BREAKDOWN (timed beats)
```

Every section earns its place by preventing a known failure. Details below.

### REFERENCE KEY
- `@image1` = character sheet. Describe identity anchors VERBATIM and identically in every prompt for that character (face shape, hair, eyes, jewellery). Outfit is described per-video. Always append: "identity reference ONLY (face, hair, outfit), NEVER its lighting".
- `@image2` = location still. "Scene reference only, generic, no brands, no readable text." Reuse the same still across videos set in the same place — that is what keeps the character's world consistent.
- `@audio1` = pre-generated voice-over: "this audio file is the ONLY spoken content; use it exactly as recorded" + a one-line description of the delivery register so the face can match it.

### CRITICAL — RELIGHT (mandatory; character sheets are flat white-studio images)
Discard the reference's lighting entirely; relight the subject from scratch to the scene: name the key light and its direction, the fill, at least one COLOR BOUNCE from a named surface, and true contact shadows grounding them. Close with: "must look physically present and photographed in the location — never a cut-out pasted from a white background; never brighter than the environment." Skipping this produces the pasted-sticker look.
If the light must NOT change during the take (e.g. dawn), add a LIGHT STABILITY line: "the lighting state is constant — not a time-lapse." Models love compressing sunrises into 10 seconds.

### IMAGE QUALITY — pick ONE look per character and keep it
- **Clean modern flagship** (luxury/young characters): clean, bright, sharp; no noise, haze, vignette; real skin, no smoothing, no cinematic grade, no film grain.
- **Retro ~2016 old phone** (folksy/nostalgic characters): 720p–1080p softness, narrow dynamic range with blown windows/sky, warm-yellow white balance, faint shadow noise, slight compression, slow auto-exposure — but NEVER film-grain/vignette/aged FILTERS; the degradation is honest, not stylized.
Both looks share: pore-level skin realism, "no waxiness, no plastic, no AI-smooth face".

### Camera — ALIVE, never produced
"Fixed tripod" language kills authenticity. Choose a living setup and write its imperfections in:
- **Propped**: leaned against books / a vase / a teapot / a jar; open with one soft settle-wobble as it finds its lean, then locked with a slight casual tilt, subtle sensor breathing, one autofocus breath.
- **Handheld selfie**: own extended arm, walking bob, mild front-camera wide distortion; angle variety comes from the CHARACTER raising/lowering the phone — never from cuts.
- **Placement open**: recording already running while they set the phone down — face close and distorted, world swings, settle-wobble, frame locks. Optionally never retrieved (ends mid-moment, still rolling).
- **Handheld by companion/assistant**: standing micro-sway, one small human reframe, one step-adjust.
- **Mounted in a vehicle**: locked framing but carrying the ride's true vibration and sway; travelling light across the face.
No spins or turns away from camera unless asked. All angle changes are motivated by the character's own hands or body.

### ACTING TASK (the performance section for anything with a face)
Never direct results ("raise eyebrow", "look sad") as the core. Direct an invested task:
```
ACTING TASK — [NAME] (fully invested; the work reads through the eyes / stillness / brow line):
SCENE DIRECTION (unspoken): one line — what this take is FOR.
MOTIVE (fuel): why THIS person pushes it — rooted in their backstory.
GOAL: their personal fight in this take.
OBSTACLE: what presses against the line; what one crack costs.
TACTIC: what they DO to the viewer/partner, with eye-work as action (checking the lens after each point: did it land?).
Moment to moment: one beat per dialogue phrase — "«words»" — action verb + what the eyes check. Mark where the register breaks (the break IS the delivery).
(Safety: gaze always engaged in the task — never frozen or glassy; natural blink cadence.)
```
Physical business (finger counts, prop handling, a ring adjusted mid-sentence) is welcome as the CHANNEL of the task, keyed to exact words. Emotion adjectives as instruction are banned; the audience gets the feeling because nobody plays it.

### Props & other people
- Any prop that moves must EXIST FROM FRAME ONE (glasses on the head, phone in hands, coin in fingers) with a PROP RULE: "does not appear, disappear or change design; moves only in the scripted beat(s)." Otherwise it materializes from thin air.
- Character signature gestures are RATIONED: one signature move (Vivienne's over-the-rims look, Amos's slow closing nod) used at key beats only, so it stays a trademark.
- Other people: edges of frame, soft-blurred, faces NEVER visible — protects consistency and focus.
- Phone/TV screens in shot: always illegible/generic (no readable AI text artifacts).

### No-IP (hard rule)
No real brands, logos, badges, liveries, tail numbers, plates, readable signage, place names, or copyrighted music. Cars are "generic [style] design, no badges"; bags "no brand charms". Spoken brand names in a supplied script are the client's editorial call — but the VISUALS stay generic. Modest fully-clothed styling throughout.

### Audio
Talking: lip-sync exactly to @audio1, "lips completely still when the audio is silent, no added words, no other voices"; dialogue quoted VERBATIM; interviewers are off-mic, different timbre, never in frame; voice runs seamlessly across any cut. B-roll: "NO dialogue anywhere — ambient SFX only", 3–5 specific diegetic sounds ducked under everything. Music: none. On-screen text: none — added in post.

### SHOT BREAKDOWN
Timed beats (0.0–4.0s — …) keyed to the dialogue phrases or micro-actions; a named centerpiece beat (THE PAUSE / THE FLIP / THE SIGNATURE); a post-audio final beat; loop-friendly ending for b-roll (last pose ≈ first).

## Format D — Continuation (Part 2 fed with Part 1 as reference)
Open with: "CONTINUE THE VIDEO from the last frame of the attached reference clip — seamlessly, with no visual reset of any kind." Then say ALL visuals (woman, room, outfit, light, framing, camera position) come from the last frame — do NOT describe framing, closeness, lighting or location at all; the reference clip IS that information. Keep only: TOP PRIORITY, REFERENCE KEY (@video1 + @audio1), the resume line ("picks up mid-gesture exactly where the last frame leaves them"), ACTING TASK, minimal Physics ("everything continues as in the reference"), Editing, Audio, SHOT BREAKDOWN.

## Text-over b-roll specifics (format C)
The script becomes an overlay the client adds in post, so: TEXT-SAFE FRAME (upper third visually calm, subject in the lower two-thirds), one micro-action with a small arc (not a pose, not chaos), 8–12s loop-friendly, varied worlds across the series (outfit different in EVERY video; hairstyle changes only occasionally as an event).

## Voice prompts
One bracket block: `[voice: age+gender, accent with anti-drift qualifiers ("not posh"/"not frail"), timbre, pacing, signature quirks ("a drawled darling"), energy]` + a seed line from the character's actual scripts containing their signature pauses. One good seed becomes @audio1 for everything; only the recording-space note changes per format (room/handheld/close-mic).

## Companion stills (same relight logic)
Avatars: 1:1, face fills the frame, each character's trademark expression (open smile / warm eyes without smile / smirk behind sunglasses). Locations: empty scenes, no people, "lived-in not staged", light already planned for the future video's key. iPhone-style photos: "authentic candid iPhone photo, casual imperfect framing, mild HDR, true-to-life colors, subtle sensor grain, no retouching, looks like a real photo from her camera roll."

## Known failure → fix table
| Symptom | Fix |
|---|---|
| Pasted-sticker character | RELIGHT block missing/weak — name key direction + color bounce + contact shadows |
| Props appear magically | Prop exists from frame one + PROP RULE |
| Sunrise/sunset time-lapse | LIGHT STABILITY line |
| Too polished, ad-like | Alive camera: settle-wobble, casual tilt, autofocus breath; never "tripod" |
| Dead glassy eyes | ACTING TASK with eye-work as action + safety blink line |
| Face drifts | "face and identity match @image1 100% for the entire take" + identical anchor wording |
| Overacting/puppet | "never staged, never stiff, never puppet-like"; task over choreography |
| Speech in wrong language | "speaks ONLY English throughout, never Chinese or any other language" in TOP PRIORITY and Audio |
| Doesn't fit 30s | brisk pacing note, 1.05x audio speedup, or split with one hard cut / continuation |
