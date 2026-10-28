---
topic: economy-tokens
summary: Suggested UI design token scales and two ways to apply them in Luau (StyleSheets or a typed module), plus a Figma/DTCG pipeline
keywords: design tokens, spacing, radius, text size, color, font, motion, StyleSheet, StyleDerive, StyleRule, StyleLink, SetAttribute, SetProperties, Style Editor, theme, typed Luau module, DTCG, Style Dictionary, registerFormat, rbx-css, Figma
verified: 2026-10-28
---
# UI design tokens in Luau
## Use this
- Style Editor: edit token sheets, themes, rules visually https://create.roblox.com/docs/ui/styling/editor [S8]
- Styling CSS comparisons: selectors, queries, transitions mapped from CSS https://create.roblox.com/docs/ui/styling/css-comparisons [S9]
- Style Dictionary formats: `registerFormat` for a custom Luau output https://styledictionary.com/reference/hooks/formats/ [S136]
- Style Dictionary repo (Apache-2.0, active) https://github.com/amzn/style-dictionary [S137]
- Snippets: `snippets/ui-stylesheet-theme.luau`, `snippets/ui-design-tokens.luau`
## Concepts
- Suggested starting scales (not a standard; keep steps few):
  - Spacing (Offset px, 4 px grid): xs 4, sm 8, md 12, lg 16, xl 24.
  - Radius (`UDim`): sm 4 px, md 8 px, lg 16 px, pill Scale 0.5.
  - Text size: caption 14, body 18, title 24, display 36.
  - Color (semantic, one value per theme): surface, surfaceRaised, textPrimary, textMuted, accent, danger, success.
  - Font: body and heading = Builder Sans regular and bold via `Font.fromEnum`.
  - Motion: fast 0.12 s, normal 0.2 s, slow 0.35 s; Quad/Quint Out.
- Pixel tokens pair with one root `UIScale` (see ui/layout-and-scaling.md) so they stay in design pixels.
- Option A, native StyleSheets (recommended for most UI) [S7][S8]:
  - Token sheet: `StyleSheet` whose attributes are primitives (`tokens:SetAttribute("Amber", Color3.fromHex("FFB547"))`).
  - Theme sheet: derives tokens via `StyleDerive`, defines semantic names with `$` (`theme:SetAttribute("Accent", "$Amber")`).
  - Design sheet: derives the active theme, holds `StyleRule`s; `StyleLink` attaches it to the `ScreenGui`.
  - Rules: `rule:SetProperties({ BackgroundColor3 = "$Accent" })`.
  - Switch theme by repointing the design sheet's `StyleDerive.StyleSheet`.
  - Studio's Style Editor (UI tab) edits the same objects.
- Option B, typed Luau module:
  - Frozen table per group (`color`, `space`, `radius`, `textSize`, `font`) with string-literal key types so typos fail `--!strict`.
  - Helpers (`pad`, `round`, `text`) apply tokens; works in React Luau, Fusion, or plain instances.
  - Theme switching needs your own state (Fusion `Value`, React context).
- Figma or design-tool pipeline:
  - Export DTCG format (first stable version 2025.10, announced 2025-10-28) [S134].
  - Transform with Style Dictionary; it has no built-in Lua/Luau format, so register one with `StyleDictionary.registerFormat({ name, format })` emitting a Luau module or a script that sets StyleSheet attributes [S135][S136][S137].
  - Commit the generated Luau and source JSON; regenerate in CI.
- Community: rbx-css (MIT) compiles CSS custom properties into StyleSheets; small project, caution [S99].
## Gotchas
- Themes must define the same token names [S7].
- Do not tokenize one-off layout numbers.
- Name tokens by purpose (`danger`), not appearance (`red`).
- UI Styling cannot target two pseudo-instances of the same class on one object (two `UIStroke`s) without unique names or tags [S68].
- Check text tokens against surfaces for contrast on bright phone screens.
## Sources
S7, S8, S9, S68, S99, S134, S135, S136, S137
