---
name: cv-tailor
description: Extracts relevant experiences from Master_Career.md to generate a tailored CV in Markdown based on a specific job offer, and compiles a strictly verified 1-page A4 PDF.
---

# CV Tailor Skill

This skill takes a Master Career document and a Job Ad note, and produces a highly targeted, tailored CV in Markdown format as the **Single Source of Truth (SSOT)**, then compiles it deterministically into a 1-page PDF.

## Responsibilities
1. **Analyze the Job Ad**: Extract required skills, expected responsibilities, company culture, and color identity.
2. **Read the Master Career Document**: Use `obsidian read path="3-Resources/Carrière/Master_Career.md"` to retrieve Boris's professional history.
3. **Select & Prune**: Identify the 3-4 roles and projects that best align with the Job Ad. Omit irrelevant details.
4. **Tailor & Refactor**: Echo the Job Ad's keywords without inventing or misrepresenting facts.
5. **Generate Tailored CV (Markdown SSOT)**: Save the file `[Target Folder]/CV_[Company]_[Role].md`.
6. **Compile PDF**: Execute `python3 /home/boris/Projects/cvs/render_pdf.py "[Target Folder]/CV_[Company]_[Role].md" "[Target Folder]/attachments/CV_[Company]_[Role].pdf"`.

---

## Standard Markdown Format (SSOT)

The Markdown file MUST use YAML frontmatter for metadata, followed by standard sections:

```markdown
---
name: "Boris Rorsvort"
role: "[Exact Tailored Job Title]"
color_primary: "#1c1c1c"
color_accent: "#00b894"
color_accent_light: "#00cec9"
---

# Boris Rorsvort - [Exact Tailored Job Title]

## Profile
[Tailored profile text, 60-80 words max. Explains domain alignment, leadership style, and technical impact.]

## Experience

### [Role Title] — [Company]
*[Dates, e.g. Jan 2026 — Present]*
[Concise description paragraph highlighting outcomes, metrics, and architecture. NO bullet points.]

### [Role Title] — [Company]
*[Dates]*
[Description paragraph. NO bullet points.]

### [Role Title] — [Company]
*[Dates]*
[Description paragraph. NO bullet points.]

### Various Previous Roles — [Company 1, Company 2, etc.]
*[Dates]*
[Short merged summary of earlier relevant experience to conserve space.]

## Skills
- [Skill 1]: 95%
- [Skill 2]: 95%
- [Skill 3]: 90%
- [Skill 4]: 90%
- [Skill 5]: 90%
- [Skill 6]: 85%

## Tools
[Tool 1], [Tool 2], [Tool 3], [Tool 4], [Tool 5], [Tool 6], [Tool 7], [Tool 8], [Tool 9], [Tool 10]
```

---

## Critical Rules

### 1. Single Source of Truth
- **NEVER generate raw HTML or manually craft JSON files**. The Python renderer (`render_pdf.py`) automatically parses the Markdown file, generates the synchronized `_data.json`, and compiles the PDF.
- If any wording or experience needs modification, edit ONLY `CV_[Company]_[Role].md` and re-run the renderer.

### 2. Strict 1-Page A4 Guarantee (Automated Overflow Check)
- The PDF renderer runs an automated page check (`qpdf --show-npages`).
- If the content overflows onto page 2, the renderer **fails with an explicit error**:
  `OVERFLOW ERROR: The generated CV spans 2 pages instead of 1 page!`
- **What to do on overflow:**
  1. Open `CV_[Company]_[Role].md`.
  2. Shorten the Profile paragraph or trim 1-2 lines from the experience descriptions.
  3. Ensure there are no more than 4 experience blocks total (merge older roles into a single block).
  4. Re-run `python3 /home/boris/Projects/cvs/render_pdf.py ...`.

### 3. Experience Formatting
- **NO bullet points** inside the experience descriptions. Write fluent, concise paragraphs.
- Keep the header line format exact: `### [Role Title] — [Company]` (using `—`, `–`, or `-`).
- Next line must contain the dates in italics: `*[Dates]*`.

### 4. Color Palette Guidelines (Industry Theming)
Set `color_primary`, `color_accent`, and `color_accent_light` in the frontmatter:
- **Tech / AI / Modern**:
  - `color_primary`: Dark Charcoal (`#1c1c1c`) or Jet Black (`#0a0a0a`)
  - `color_accent`: Vibrant Mint (`#00b894`) or Electric Indigo (`#6c5ce7`)
  - `color_accent_light`: Bright Cyan (`#00cec9`) or Neon Pink (`#fd79a8`)
- **Corporate / Finance / Legal**:
  - `color_primary`: Midnight Blue (`#0c2461`) or Deep Forest (`#004225`)
  - `color_accent`: Warm Gold (`#f39c12`) or Crisp Teal (`#1abc9c`)
  - `color_accent_light`: Bright Amber (`#f1c40f`) or Soft Turquoise (`#48dbfb`)
- **Culture / Arts / Creative**:
  - `color_primary`: Elegant Slate (`#2C3E50`) or Warm Graphite (`#302b27`)
  - `color_accent`: Classic Ochre (`#b8860b`) or Terracotta (`#d35400`)
  - `color_accent_light`: Muted Gold (`#cda434`) or Soft Sand (`#e5d6aa`)
- **Social / Education / NGO**:
  - `color_primary`: Deep Emerald (`#006266`) or Warm Terracotta (`#8d4004`)
  - `color_accent`: Sun Yellow (`#fbc531`) or Soft Orange (`#e15f41`)
  - `color_accent_light`: Light Sand (`#f5cd79`) or Bright Orange (`#ff9f43`)
- **Default / Balanced**:
  - `color_primary`: Dark Graphite (`#2d3436`)
  - `color_accent`: Crimson (`#d63031`)
  - `color_accent_light`: Bright Coral (`#ff7675`)
