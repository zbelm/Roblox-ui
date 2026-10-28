# UI / GUI

Last verified: 2026-10-28

## Purpose

Answers: how to lay out, scale, style, and animate Roblox UI (HUD, menus, shops,
inventories, notifications), and which UI library to pick. Deeper notes:

- [layout-and-scaling.md](layout-and-scaling.md): Scale vs Offset, safe areas, flex layouts, responsive rules
- [libraries.md](libraries.md): React Luau, Fusion, Vide, Iris, Flipbook, and what is deprecated
- [patterns.md](patterns.md): HUD, menus, shops, inventories, notifications, tweens, and reference galleries
- Design tokens live with the rest of the token material: [../economy-tokens/design-tokens.md](../economy-tokens/design-tokens.md)

## Top 5 picks

1. **Roblox UI docs** (https://create.roblox.com/docs/ui). Official guide set covering containers, position and size, list/flex and grid layouts, styling, and animation. Use it.
2. **UI Styling (StyleSheet / StyleRule / StyleLink / StyleDerive)** (https://create.roblox.com/docs/ui/styling). Native CSS-like styling with tokens and themes. Left beta on 2026-01-20 ([announcement](https://devforum.roblox.com/t/full-release-ui-styling-is-officially-released/4275082)). Use it for theming instead of hand-rolled "set every property" code.
3. **React Luau, official Roblox package** (https://github.com/Roblox/react-luau, Wally `roblox/react` 17.3.13). Declarative UI, MIT. Use it for large, stateful UI (shops, inventories).
4. **Fusion 0.3** (https://elttob.uk/Fusion/0.3/). Reactive state plus instance creation, MIT. Use it if you prefer a smaller, Roblox-native API to React.
5. **Flipbook** (https://github.com/flipbook-labs/flipbook). Storybook plugin to preview UI components in isolation, MIT. Use it once you have more than a handful of components.

## How it works

Every on-screen element lives under a `ScreenGui` in `PlayerGui`. Each `GuiObject`
has a `Position` and `Size` stored as `UDim2`: four numbers, a Scale and an Offset
for each axis. Scale is a fraction of the parent's size; Offset is a fixed pixel
amount added on top. Scale makes UI stretch with the screen; Offset keeps things
like icon sizes and padding crisp. Most good layouts mix them: Scale for where a
panel sits and how wide it is, Offset (or a `UIScale` multiplier) for spacing and
small elements. `AnchorPoint` decides which point of the element the position
refers to; `(0.5, 0.5)` centers it.

Layouts are done by child modifier objects instead of manual math. `UIListLayout`
stacks children and, with its flex properties (`Wraps`, `HorizontalFlex`,
`VerticalFlex`, `ItemLineAlignment`) plus a `UIFlexItem` on a child, behaves like
CSS flexbox. `UIGridLayout` and `UITableLayout` handle grids such as inventory
slots. `UIPadding`, `UICorner`, `UIStroke`, `UIGradient`, `UIAspectRatioConstraint`,
and `UISizeConstraint` cover padding, rounding, outlines, gradients, and min/max
sizes.

Styling is now a first-class engine feature. A `StyleSheet` holds `StyleRule`s,
each with a CSS-like `Selector` (class `TextButton`, tag `.Primary`, name `#Shop`,
state `:Hover`, modifier `::UICorner`). Tokens are attributes on a StyleSheet,
referenced as `"$Name"`. A `StyleLink` attaches a sheet to a `ScreenGui`, and a
`StyleDerive` lets one sheet inherit tokens from another, which is how light/dark
themes swap. See [../economy-tokens/design-tokens.md](../economy-tokens/design-tokens.md).

Animation uses `TweenService:Create(object, TweenInfo, goals)`. Tween `Position`,
`Size`, transparency, and color properties. Put a group of elements in a
`CanvasGroup` to fade or tint them together with `GroupTransparency`. Style rules
can also define property transitions, configured in the Style Editor.

Libraries sit on top of all this. React Luau and Fusion create the same instances
for you but derive them from state, so a shop UI re-renders when the player's
coins change instead of you wiring every label by hand.

## Gotchas

- `GuiObject:TweenPosition`, `TweenSize`, `TweenSizeAndPosition`, `GuiObject.Draggable`, `DragBegin`, `DragStopped`, `BackgroundColor`, `BorderColor`, and `Transparency` are deprecated in the current API reference. Use `TweenService` and `UIDragDetector`.
- `TextLabel.FontSize`, `TextColor`, and `TextWrap` are deprecated. Use `TextSize`, `TextColor3`, `TextWrapped`, and `FontFace`.
- **Roact (Roblox/roact) is deprecated**; its README says so. The jsdotlua/react-lua community fork has had no commits since 2024-12-04. New projects should use the official `roblox/react` package. Older tutorials (including the 2024 DevForum "How To: React + Roblox") still point at `jsdotlua/react`.
- Knit is archived (README: "No Longer Maintained"). Do not start new projects on it.
- Mobile reserves the bottom corners for the thumbstick and jump button. Use `ScreenGui.ScreenInsets` (default `CoreUISafeInsets`) instead of guessing top-bar height; `IgnoreGuiInset` is the older approach.
- UI Styling cannot yet style multiple pseudo-instances of the same type (for example two `UIStroke`s) on one object; the release post's workaround is unique names or tags.
- Only one StyleSheet applies to a given tree through a `StyleLink`; compose with `StyleDerive`, not by linking twice.
- `PromptProductPurchaseFinished` does not mean a purchase succeeded. Shop UI must wait for the server's receipt handler. See [../economy-tokens/README.md](../economy-tokens/README.md).
- Never trust the client for prices or currency. The UI sends an item id; the server looks up the price.
- `flipbook-labs.com` did not resolve from this session (DNS blocked). The GitHub repo and https://flipbook-labs.github.io/flipbook/ do load.

## Sources

- https://create.roblox.com/docs/ui
- https://create.roblox.com/docs/ui/position-and-size
- https://create.roblox.com/docs/ui/list-flex-layouts
- https://create.roblox.com/docs/ui/styling
- https://create.roblox.com/docs/ui/animation
- https://devforum.roblox.com/t/full-release-ui-styling-is-officially-released/4275082
- https://github.com/Roblox/react-luau
- https://elttob.uk/Fusion/0.3/
- https://github.com/flipbook-labs/flipbook
- https://flipbook-labs.github.io/flipbook/
- https://github.com/Roblox/roact
- https://github.com/Sleitnick/Knit
- Snippets: [../../snippets/ui-tween-panel.luau](../../snippets/ui-tween-panel.luau), [../../snippets/ui-design-tokens.luau](../../snippets/ui-design-tokens.luau), [../../snippets/ui-stylesheet-theme.luau](../../snippets/ui-stylesheet-theme.luau)
