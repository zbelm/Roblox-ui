---
topic: ui
summary: How to lay out, scale, style, and animate Roblox UI, and which UI library to pick
keywords: ScreenGui, PlayerGui, GuiObject, UDim2, Scale, Offset, AnchorPoint, UIListLayout, UIFlexItem, UIGridLayout, StyleSheet, StyleRule, StyleLink, StyleDerive, TweenService, CanvasGroup, React Luau, Fusion, Flipbook, deprecated
verified: 2026-10-28
---
# UI / GUI
Files: layout-and-scaling.md, libraries.md, patterns.md. Design tokens: ../economy-tokens/design-tokens.md.
## Use this
- Roblox UI docs: containers, position/size, list/flex/grid layouts, styling, animation https://create.roblox.com/docs/ui [S1]
- UI Styling: native CSS-like styling with tokens and themes; out of beta 2026-01-20 https://create.roblox.com/docs/ui/styling [S7][S68]
- React Luau (`roblox/react` 17.3.13, MIT): declarative UI for large stateful screens https://github.com/Roblox/react-luau [S85]
- Fusion 0.3 (MIT): smaller Roblox-native reactive API https://elttob.uk/Fusion/0.3/ [S90]
- Flipbook (MIT): storybook plugin to preview components in isolation https://github.com/flipbook-labs/flipbook [S100]
## Concepts
- Every on-screen element lives under a `ScreenGui` in `PlayerGui` [S1].
- `Position` and `Size` are `UDim2`: Scale (fraction of parent) plus Offset (pixels) per axis [S2].
- Mix them: Scale for where panels sit and how wide they are; Offset or a `UIScale` multiplier for spacing and small elements [S2].
- `AnchorPoint` sets which point the position refers to; `(0.5, 0.5)` centers [S2].
- Layout via child modifiers: `UIListLayout` with flex properties (`Wraps`, `HorizontalFlex`, `VerticalFlex`, `ItemLineAlignment`) plus `UIFlexItem` behaves like flexbox; `UIGridLayout`/`UITableLayout` for grids [S3].
- `UIPadding`, `UICorner`, `UIStroke`, `UIGradient`, `UIAspectRatioConstraint`, `UISizeConstraint` cover padding, rounding, outlines, gradients, min/max sizes [S1].
- Styling: a `StyleSheet` holds `StyleRule`s with selectors (class `TextButton`, tag `.Primary`, name `#Shop`, state `:Hover`, modifier `::UICorner`) [S7].
- Tokens are StyleSheet attributes referenced as `"$Name"`; `StyleLink` attaches a sheet to a `ScreenGui`; `StyleDerive` inherits tokens, which is how themes swap [S7].
- Animation: `TweenService:Create(object, TweenInfo, goals)` on position, size, transparency, color; `CanvasGroup.GroupTransparency` fades a group; style rules can define transitions [S10].
- React Luau and Fusion create the same instances but derive them from state, so UI re-renders when data changes [S85][S90].
- Snippets: `snippets/ui-tween-panel.luau`, `snippets/ui-design-tokens.luau`, `snippets/ui-stylesheet-theme.luau`.
## Gotchas
- Deprecated: `GuiObject:TweenPosition`, `TweenSize`, `TweenSizeAndPosition`, `Draggable`, `DragBegin`, `DragStopped`, `BackgroundColor`, `BorderColor`, `Transparency`; use `TweenService` and `UIDragDetector`.
- Deprecated: `TextLabel.FontSize`, `TextColor`, `TextWrap`; use `TextSize`, `TextColor3`, `TextWrapped`, `FontFace`.
- Roact is deprecated per its README [S88]; jsdotlua/react-lua has had no commits since 2024-12-04; the 2024 DevForum React guide still points at `jsdotlua/react` [S87][S69].
- Knit is archived; do not start new projects on it [S103].
- Mobile reserves the bottom corners; use `ScreenGui.ScreenInsets` (default `CoreUISafeInsets`); `IgnoreGuiInset` is older [S6][S2].
- UI Styling cannot style two pseudo-instances of the same class (two `UIStroke`s) on one object; use unique names or tags [S68].
- Only one StyleSheet applies per tree through a `StyleLink`; compose with `StyleDerive` [S7].
- `PromptProductPurchaseFinished` does not mean a purchase succeeded; wait for the server receipt handler (see economy-tokens).
- Never trust the client for prices or currency; send an item id, look up the price on the server.
- flipbook-labs.com did not resolve (DNS); the repo and docs site load [S100][S101].
## Sources
S1, S2, S3, S6, S7, S10, S68, S69, S85, S87, S88, S90, S100, S101, S103
