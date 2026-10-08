---
name: cv-tailor
description: Extracts relevant experiences from Master_Career.md to generate a tailored CV in Markdown based on a specific job offer.
---

# CV Tailor Skill

This skill is designed to take a Master Career document and a Job Ad note, and produce a highly targeted, tailored CV in Markdown format.

## Responsibilities
1. **Analyze the Job Ad**: Extract the required skills, expected responsibilities, and company terminology from the provided Job Ad notes.
2. **Read the Master Career Document**: Use `obsidian read path="3-Resources/Carrière/Master_Career.md"` to retrieve your complete professional history.
3. **Select & Prune**: Identify the specific bullet points, projects, and roles from the Master file that best align with the Job Ad. Omit irrelevant details to keep the CV concise and impactful.
4. **Tailor & Refactor**: Adjust the phrasing of the selected bullet points to echo the Job Ad's keywords without inventing or misrepresenting facts.
5. **Generate Tailored CV**: Create a new Markdown file (e.g. `CV_[Company]_[Role].md`) in the target Job Ad folder using `obsidian create`.

## Usage
When invoked, you will be provided with:
- The path to the Job Ad note.
- The path to the target folder where the tailored CV should be saved.

**Workflow inside the agent**:
1. Run `obsidian read path="[Job Ad Note Path]"`
2. Run `obsidian read path="3-Resources/Carrière/Master_Career.md"`
3. Determine the best match and prune irrelevant experiences.
4. Output the exact Markdown content for the tailored CV.
5. Save the file using `obsidian create path="[Target Folder]/CV_[Company]_[Role].md" content="..."`
6. ALSO generate a JSON representation of this CV (with fields like `role`, `summary`, and pre-formatted HTML for `experiences`).
7. Save the JSON file using `obsidian create path="[Target Folder]/CV_[Company]_[Role]_data.json" content="..."`
8. Execute the PDF renderer: `python3 /home/boris/Projects/cvs/render_pdf.py "[Target Folder]/CV_[Company]_[Role]_data.json" "[Target Folder]/CV_[Company]_[Role].pdf"`

**CRITICAL HTML GENERATION RULE:**
When generating `experiences_html`, `skills_html`, or `tools_html`, ensure all HTML tags are strictly balanced. Do NOT close a `<div>` with a `</span>` or vice versa. Ensure every single `<div class="experience-item">`, `<div class="exp-company">`, etc. is properly closed with `</div>`.
**IMPORTANT EXPERIENCES FORMATTING**:
1. Inside `experiences_html`, DO NOT use `<ul>`, `<ol>`, or `<li>` tags, and DO NOT use bullet characters (`•`, `-`) for the descriptions! Bullet points break the visual layout. Format the text as paragraphs `<p class="exp-description">...</p>` or `<div class="exp-description">...</div>`.
2. For the header of each experience, you MUST use the following exact structure so dates don't wrap and the company name falls below the title:
```html
<div class="experience-item">
  <div class="exp-header">
    <div class="exp-title-group">
      <div class="exp-title">Role Title</div>
      <div class="exp-company">Company Name</div>
    </div>
    <div class="exp-period">Dates</div>
  </div>
  <p class="exp-description">Description paragraph 1...</p>
</div>
```

**CRITICAL COLOR MAPPING RULE:**
You must infer the industry of the Job Ad (e.g., Tech, Social Work, Education).
Based on the inferred industry, you must output a suitable color scheme directly in your JSON output.
The sidebar background is now dynamic. You must provide `color_primary` (the dark background), AND two contrasting secondary colors: `color_accent` (must have high contrast on a WHITE background) and `color_accent_light` (must have high contrast on the DARK sidebar).
Include the following keys in your JSON:
- `color_primary`: The dark base color for the sidebar (e.g., `#2C3E50`)
- `color_accent`: The accent color for text on the WHITE main page (e.g., `#008080`)
- `color_accent_light`: The bright accent color for text on the DARK sidebar (e.g., `#00d2d3`)

Recommended Combinations (choose creatively based on company identity or industry, AVOID always using blue):
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

**CRITICAL 1-PAGE LIMIT & MERGING RULE:**
The CV must fit on a single A4 page. However, you should try to include as much relevant information as possible within that constraint.
To achieve this:
1. **Prioritize:** Place the most relevant and impressive experiences for the specific job ad at the top.
2. **Merge Remaining Experiences:** If you run out of space or have several older/less critical roles of the same type, you must merge them into a single summary block. For example, instead of listing three separate teaching or older tech roles, create one `<div class="experience-item">` called "Various Previous Roles" or "Other Relevant Experience" that briefly summarizes them in a few lines.

**CRITICAL JSON FIELDS RULE:**
The target template expects the following fields to be populated in the `_data.json` file. If any of these are missing, the PDF generation will strictly fail due to a QA check:
- `name`
- `role`
- `summary_html`
- `experiences_html`
- `skills_html` (MUST use exactly the following structure for EVERY SINGLE skill: `<div class="skill-item"><div class="skill-name">Skill Name</div><div class="skill-bar"><div class="skill-fill" style="width: 90%"></div></div></div>`. DO NOT use bullet points, `<ul>` tags, `<div class="skill-category">`, or plain text here. Only progress bars!)
- `tools_html` (Ensure this is provided to populate the Tools section, e.g., `<span class="tool-tag">Python</span>...`)
- `color_accent`
- `color_accent_light`
Do NOT omit `tools_html` or any other field.

**CRITICAL LAYOUT & OVERFLOW RULE**:
The HTML template has a hardcoded "Leadership & Community" section at the very bottom. If your `experiences_html` is too long, it will push this section down, causing the PDF to cut off and leaving an orphaned `<h2>Leadership & Community</h2>` title at the bottom of the page with no content.
To prevent this:
1. STRICTLY limit the length of `experiences_html`.
2. Keep descriptions concise.
3. It is absolutely unacceptable to have a section title alone at the bottom of the page. If the QA PDF check shows an orphaned title, you MUST reduce the text and regenerate.
