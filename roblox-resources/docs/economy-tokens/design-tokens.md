# UI design tokens in Luau

Last verified: 2026-10-28

Back to [README.md](README.md). Linked from [../ui/README.md](../ui/README.md).

## Suggested scales

These are starting values, not a standard. Keep the number of steps small.

| Group | Tokens | Values |
|---|---|---|
| Spacing (Offset px, 4 px grid) | xs, sm, md, lg, xl | 4, 8, 12, 16, 24 |
| Radius (`UDim`) | sm, md, lg, pill | 4 px, 8 px, 16 px, Scale 0.5 |
| Text size | caption, body, title, display | 14, 18, 24, 36 |
| Color (semantic) | surface, surfaceRaised, textPrimary, textMuted, accent, danger, success | one value per theme |
| Font | body, heading | Builder Sans regular and bold (`Font.fromEnum`) |
| Motion | fast, normal, slow | 0.12 s, 0.2 s, 0.35 s; Quad/Quint Out |

Pixel values pair with a single root `UIScale` (see [../ui/layout-and-scaling.md](../ui/layout-and-scaling.md)), so tokens stay in "design pixels".

## Option A: native StyleSheets (recommended for most UI)

- A **token sheet** is a `StyleSheet` whose attributes are the primitives (`tokens:SetAttribute("Amber", Color3.fromHex("FFB547"))`).
- A **theme sheet** derives the token sheet with a `StyleDerive` and defines semantic names that point at primitives with `$` (`theme:SetAttribute("Accent", "$Amber")`).
- A **design sheet** derives the active theme and holds `StyleRule`s; a `StyleLink` attaches it to the `ScreenGui`.
- Rules reference tokens as strings: `rule:SetProperties({ BackgroundColor3 = "$Accent" })`.
- Switching theme = pointing the design sheet's `StyleDerive.StyleSheet` at another theme.
- Themes must define the same token names (the docs call this out explicitly).
- Studio's Style Editor (UI tab) edits the same objects visually.

Snippet: [../../snippets/ui-stylesheet-theme.luau](../../snippets/ui-stylesheet-theme.luau).
Docs: https://create.roblox.com/docs/ui/styling, https://create.roblox.com/docs/ui/styling/editor, https://create.roblox.com/docs/ui/styling/css-comparisons

## Option B: typed Luau module

- A frozen table per group (`color`, `space`, `radius`, `textSize`, `font`) with string-literal key types so typos fail type checking under `--!strict`.
- Small helpers (`pad`, `round`, `text`) apply tokens so components never hard-code values.
- Works the same in React Luau, Fusion, or plain instance code.
- Theme switching needs your own state (a Fusion `Value`, a React context), unlike Option A.

Snippet: [../../snippets/ui-design-tokens.luau](../../snippets/ui-design-tokens.luau).

## Getting tokens out of Figma or a design tool

1. Export tokens in the DTCG format (https://www.designtokens.org; first stable version 2025.10 announced 2025-10-28).
2. Transform with Style Dictionary (https://styledictionary.com, repo https://github.com/amzn/style-dictionary, Apache-2.0, active). It has no built-in Lua/Luau format; register one with `StyleDictionary.registerFormat({ name, format })` (https://styledictionary.com/reference/hooks/formats/) that emits either a Luau module (Option B) or a script that sets StyleSheet attributes (Option A).
3. Commit the generated Luau file and the source JSON; regenerate in CI.

Community option: rbx-css (https://github.com/AlroviOfficial/rbx-css, MIT) compiles CSS custom properties into Roblox StyleSheets. Small project; use with caution.

## Gotchas

- Do not tokenize everything. One-off layout numbers can stay local.
- Token names describe purpose (`danger`), not appearance (`red`), so themes can change them.
- UI Styling cannot yet target two pseudo-instances of the same class on one object (for example two `UIStroke`s) without unique names or tags.
- Color contrast: check text tokens against surfaces for readability on bright phone screens.

## Sources

- https://create.roblox.com/docs/ui/styling
- https://create.roblox.com/docs/ui/styling/editor
- https://create.roblox.com/docs/ui/styling/css-comparisons
- https://devforum.roblox.com/t/full-release-ui-styling-is-officially-released/4275082
- https://www.designtokens.org
- https://styledictionary.com
- https://github.com/amzn/style-dictionary
- https://github.com/AlroviOfficial/rbx-css
