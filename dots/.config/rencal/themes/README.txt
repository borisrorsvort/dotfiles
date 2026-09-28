renCal custom themes
====================

Drop a .css file in this folder and it shows up in Settings > Themes.
The filename becomes the theme name (override with a `@name` comment).

A theme is a bare block of CSS variables — no selector needed:

    /* @name My Theme */
    --background: #0f1115;
    --foreground: #e6e6e6;
    --hover-tint: #ffffff;
    --primary: #7c8cff;
    --highlight: #7c8cff;

Setting --background, --foreground, --hover-tint and --primary gets you most
of a theme; hover/card/divider/etc. are derived automatically. Edits apply
live. See the full variable list in renCal's docs.
