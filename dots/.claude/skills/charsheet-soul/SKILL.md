---
name: charsheet-soul
description: The house method for generating character sheet prompts for Higgsfield (Soul 2.0 + Soul Cinema) — 3-panel character cards, face anchors, paired cards, face-fix edits, masked characters. Use this WHENEVER the user asks for a character prompt, character card, character sheet, "сделай персонажа по фотке/описанию", paired cards, a face anchor (Soul Cinema close-up), face-fix, or sends a character profile (name/backstory/appearance) or an appearance reference — even if the words "character sheet" are never said. Also for edits to existing cards (change outfit/hairstyle/age/face paint).
---

# CHARSHEET-SOUL — character cards per the user's house system

The user is a Higgsfield prompt engineer. **Write your commentary in whatever language the user's request is in; all generation prompts are ALWAYS in English, in code blocks.** Keep replies short, no preamble. Deliver edits as a FULL rewritten prompt, never a diff. Batches of 5+ prompts — assemble into a docx. Aspect ratio is set in the platform UI, but the "16:9 aspect ratio" line stays in the card text (canon). Honestly name production risks (what Soul may fail to hold and why).

## Two-pass character pipeline

1. **Soul Cinema — the face.** A separate prompt: a TIGHT portrait (head & shoulders), maximum identity detail. This close-up is the anchor; it is never regenerated again.
2. **Soul 2.0 — the looks.** 3-panel cards and full-figure outfits fitted to the locked face (same anchors, verbatim).
3. **Assembly** — in Seedream / Nano Banana / ChatGPT around the untouched portrait; changes (scar, haircut, item, dirt) — surgically with masks. Edits on finished cards — via the face-fix edit (below), not regeneration.

If the user asks for "a character" with no detail — default to a 3-panel sheet. The Soul Cinema face prompt — when they ask for a face/anchor or "what he looks like without the costume".

## 3-panel sheet format

Panel 1 — full body / Panel 2 — side profile MEDIUM bust (strict 90°) / Panel 3 — frontal MEDIUM bust. Block order in the prompt:

```
[Opener: background + photo block + no-IP + face consistency + CRITICAL IDENTITY + "FULLY CLOTHED in the same outfit in all three panels"]
Panel 1 (left third) — Full body shot: [pose + expression]
Panel 2 (center third) — Side profile MEDIUM bust portrait: [canonical framing + what is visible]
Panel 3 (right third) — Frontal MEDIUM bust portrait: [canonical framing + expression]
Important framing rule for panels 2 and 3: face occupies upper-middle third of the panel, shoulders and upper chest fully showing, NO tight extreme face crops.
Character — strict facial consistency: [ethnicity, age, skin, face, hair, (anchors), makeup/grooming line, build]. Realistic human anatomy, five fingers per hand.
Outfit (identical in all three panels, [aesthetic]): [items with no-IP qualifiers] + Modest block.
Lighting & rendering: [light] + Face must remain identical across all three panels — same bone structure, same signature anchors, same person photographed three times. Panels 2 and 3 strictly medium bust framing, never tight face crops. [palette] palette, [quality line].
```

### Backgrounds (choose one)
- **Default (flat grey):** `smooth solid plain mid-grey seamless studio background, one perfectly even flat grey tone with no texture, no mottling, no gradient, no vignette, the floor blending into the same flat grey`
- **"Alive" (recommended when the user complains "looks AI / pasted to the background"):** `neutral mid-grey seamless studio backdrop with a soft mottled painterly texture and a gentle natural vignette toward the frame edges, the floor fading into the same grey` + mandatory: `The subject stands well in front of the backdrop with a soft natural shadow falling behind him/her — real photographic depth and separation from the wall.`
- White: `clean pure white seamless background`

### Photo block (stitched into the opener)
Editorial/beauty characters: `Editorial fashion photography, shot on Hasselblad, 85mm f1.4, shallow depth of field, hyperrealistic, ultra detailed skin texture, 8k`. Dark/cinematic ones: `Photorealistic cinematic character photography, shot on a cinema camera, 85mm, hyperrealistic, ultra detailed material textures, 8k`. Always follow with the anti-plastic block: `photorealistic with completely matte unretouched natural skin showing authentic visible pores, fine peach fuzz, natural skin imperfections, real human texture, no plastic skin, no doll-like overdone features, no airbrushing, no skin smoothing, no porcelain finish, no CGI rendering`. NEVER write "porcelain skin" as a positive — it produces plastic.

### Light
- Alive lifestyle: `Professional studio beauty lighting — large soft flattering light sources with gentle wrap-around falloff, soft natural shadows behind the subject on the backdrop, delicate natural sheen on the skin, no harsh speculars, no over-glamour` OR `Soft directional studio daylight from one side like a large window — gentle natural falloff, soft real shadows behind the subject, real lookbook photography depth`.
- Dark characters: `Low-key moody directional studio lighting from a high frontal-side angle` + mandatory `both sides of the figure still clearly readable for reference`.
- "Perfectly even flat lighting + no specular highlights" dries the image into CGI — do not use for alive characters.

### Poses
Lookbook vibe, not a passport: full body — weight on one leg, hand in a pocket / on a bag strap; frontal — `calm soft editorial gaze, relaxed alive eyes, the faintest hint of warmth at the corners of her lips`. A hard "passport-photo, NO smile" gives a dead/creepy stare — use only if the user explicitly asks for "like an ID photo". Body symmetry: if the pose is symmetrical — spell out `BOTH arms hanging identically, shoulders perfectly LEVEL` + in anatomy `PERFECTLY SYMMETRICAL PHYSIQUE — both shoulders same height and width`; different hand positions in the description = tilted shoulders in the generation.

## Mandatory rules

- **Anchors: 2–3 per character** (moles, scars, freckles, heterochromia, an accessory). Write as `(signature anchor — X; second anchor — Y; third anchor — Z)`. Do not repeat anchors between characters of a batch. **Paired cards / look change: anchors are copied VERBATIM** — only hairstyle/makeup/expression/outfit change.
- **Men:** grooming line (`Soft natural masculine grooming with no visible makeup... matte-natural skin finish` + facial hair: either specific stubble or `completely clean-shaven smooth face without facial hair`) + **LEAN block always** (Soul fattens men): `LEAN ANGULAR face — NOT round, NOT chubby, NO double chin, NO neck fullness, sharp defined jawline with visible bone structure` and in the body `LEAN ATHLETIC build — NOT heavyset, NOT bulky-fat`.
- **Women:** makeup line is mandatory — either `COMPLETELY BARE NO-MAKEUP FACE — absolutely no makeup...`, or a specific makeup as an anchor (e.g. `GLOWING MINIMAL NATURAL MAKEUP — fresh dewy-but-matte skin finish, groomed natural brows, a hint of mascara, soft natural rosy lip tone`).
- **Modest block is mandatory:** `Modest fully-clothed editorial styling, no sexualized framing, no revealing styling, opaque thick fabric only, no see-through fabric, no body emphasis, conservative natural styling, fully covering torso.` Fixes: straps→a solid top; off-shoulder→bateau; sheer→opaque; mini→thick tights; crop top→hem meeting a high waist, "only a narrow sliver of midriff".
- **No-IP:** `No real brand logos, no commercial branding, no copyrighted graphics or text, no monogram patterns, no designer brand prints, no copyrighted accessories. No celebrity likeness, no real-person likeness, no movie character references — character is an original generic {archetype} archetype only with his/her own original face. ALL graphics and patterns must be original generic abstract designs.` Celebrities/movie characters in refs → take only the archetype/styling/build, face and design are original (bat gear: no bat ears, no chest emblem; sneakers: `strictly not a three-stripe layout`). EXCEPTION: the user's own product — branding verbatim + `The [product] worn is the model's own branded product — keep all branding details exactly as specified.`
- **No weapons shown on cards**: `His hands are EMPTY in every panel — no weapons anywhere on the sheet` + empty holsters/mounts (`EMPTY holster`, `twin EMPTY scabbard mounts`). In video the weapon returns via the line `Action-critical prop for this shot only: ...`.
- **Critical props/styling** (glasses, face paint, jewellery, wet hair, paint) → always `identical in all three panels`.

## Proven Soul 2.0 fixes (violating one = failed generation)

1. **Tail truncation:** keep the prompt ≤ ~3500 characters. Everything critical (age, ethnicity, gender, baldness/beard/face paint, FULLY CLOTHED) — in the FIRST paragraph; Outfit — before / right after the Character block. Soul silently cuts the tail of a long prompt (a naked old man, a 40-year-old instead of an 82-year-old — real cases).
2. **Negations don't work:** "sunglasses OFF" is ignored. Write positively: `completely bare face with her eyes fully visible, no eyewear of any kind`, and do NOT mention the word "sunglasses" in the clean panels. An accessory from panel 1 still bleeds into panel 2 (~50%) — warn honestly, cured by rerolling.
3. **Covered top on women:** "high neckline" is ignored, `TURTLENECK` works.
4. **Ethnicity:** "Caucasian" is ignored on glam archetypes. Write `EUROPEAN woman/man with FAIR LIGHT PALE skin`.
5. **Age:** old age — `genuinely elderly, visibly aged wrinkled face, NOT young, NOT middle-aged`; softening — `exceptionally well-preserved X-year-old who looks like ... in her late 60s` + `NO deep heavy furrows, NO leathery texture`. Youth — `clearly reads EARLY TWENTIES — NOT thirty, NOT mature: soft youthful cheeks, smooth unlined forehead`.
6. **Strong features** (baldness, a long beard, face paint, oversized glasses) — stitch in three times: opener + each panel + Character. Otherwise Soul drops them.
7. **Jewellery — by count:** `exactly TWO slim gold bangles on one wrist and none on the other`, otherwise mountains of bracelets. Small pieces under a beard/collar — spell out visibility (`visible at the sides of the neck where the beard narrows`).
8. **Outfit drifts between panels** → lock three times: opener `She wears ONE SINGLE OUTFIT across the entire sheet`, panels 2/3 `wearing the SAME [coat] over the SAME [top] as in the full body shot`, heading `Outfit (identical in all three panels...)`.
9. **Eyes without the "contact-lens" look:** `natural soft green eyes — muted sage-green with warm hazel flecks, NOT saturated emerald, NO colored-contact-lens look`.
10. **Aliveness instead of AI sterility:** textured grey backdrop + shadow behind + directional light + lookbook poses (see above). A flat even background + a passport face = a "sticker".

## Masked characters / face paint

Face covered → anchors move to visible skin (stubble, scars on the chin/lip) and to fixed costume details (a specific groove on the helmet, rows of buckles, a belt buckle). Face paint is `REAL greasepaint sitting on real human skin: visible pores and stubble showing through the paint, cracked and faded in places` + the pattern = an anchor `identical in all three panels`. Mask/helmet: describe geometry (dome, slits, rim) and wear concretely; a "half-helmet with an open mouth" — `ends in a clean ANGULAR LOWER EDGE just above the mouth — mouth, jaw and chin fully EXPOSED`. If the character has a "civilian" card — the visible anchors must match verbatim.

## Soul Cinema face prompt (the anchor)

`Cinematic close-up portrait photograph of a real man/woman — head and shoulders framing, face filling the frame at maximum identity detail.` + photo block + anti-plastic + no-celebrity + a Character block with maximum facial detail and the anchors + a neutral clothing base (plain black tee) + light with the note "every pore and scar clearly readable". No costume, no poses, no panels.

## Face-fix edit (stage 2)

Left full-body panel is mushy / a different face → an edit, redraw ONLY the head:
```
Edit the existing image. Keep the three-panel layout, {bg} background, outfits, poses and both right portrait panels completely unchanged.

LEFT PANEL FACE FIX: In the left full-body panel, redraw ONLY the head and face of the {woman/man in outfit} so it becomes the same identical face as in the frontal portrait panel on the right — identical facial structure, identical features, {anchors verbatim}. Make the face sharp, crisp, photorealistic, with natural matte skin texture and correct proportions at full-body scale — no blurry, no mushy, no simplified face. Do not change the pose, body, {outfit} or framing of the left panel.

Photorealistic result, no plastic skin, no smoothing, preserve the original lighting and colors.
```
Glasses/head tilt/raised hands — lock explicitly so the editor doesn't "remove" them. Element replacement: `Replace ... in every panel where visible. Match fabric texture, stitching and lighting exactly. No other changes.`

## What NOT to do

- Do not test by generating unless asked — the user asked for "the prompt right away, no test" (test only on an explicit "чекни" / "check it").
- Do not deliver diffs instead of the full prompt.
- Do not ask more than one clarifying question — at a fork (background, couple's state, glasses on face vs in hand) pick a sensible default and say in one line how to change it.
- Do not write aspect ratio beyond the canonical line, do not add NEGATIVE CONSTRAINTS sections.
