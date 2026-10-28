# Layout and scaling

Last verified: 2026-10-28

Back to [README.md](README.md).

## Scale vs Offset

- `UDim2.new(xScale, xOffset, yScale, yOffset)`. Scale is a fraction (0 to 1) of the parent's size; Offset is pixels added after scaling.
- `UDim2.fromScale(x, y)` and `UDim2.fromOffset(x, y)` are the readable shortcuts.
- Rule of thumb that holds up across phone, tablet, desktop, and console:
  - Containers (panels, bars): Scale for position and width, so they adapt to aspect ratio.
  - Content inside them (icons, buttons, padding): Offset, multiplied by a single `UIScale` on the `ScreenGui` root that you set from viewport size. One knob instead of hundreds.
  - Squares that must stay square (item slots, avatars): Scale plus `UIAspectRatioConstraint`.
- Pure-Scale text gets huge on TVs and tiny on phones. Use `TextScaled` only with a `UITextSizeConstraint`, or set `TextSize` from tokens and let `UIScale` handle it.
- `AnchorPoint` changes the origin for both position and size. Center a modal with `AnchorPoint = Vector2.new(0.5, 0.5)` and `Position = UDim2.fromScale(0.5, 0.5)`.
- `AutomaticSize` grows a frame to fit its children or text. Good for tooltips, notifications, and list rows of unknown length.

Source: https://create.roblox.com/docs/ui/position-and-size, https://create.roblox.com/docs/ui/size-modifiers

## Safe areas

- `ScreenGui.ScreenInsets` controls insets. `CoreUISafeInsets` (default) keeps content clear of the top bar and notches; `DeviceSafeInsets` only avoids hardware cutouts; `TopbarSafeInsets` places content in the strip beside the top bar buttons; `None` is for full-bleed backgrounds only.
- `ScreenGui.IgnoreGuiInset` still exists, but `ScreenInsets` is the newer and more precise control.
- On mobile the bottom-left (thumbstick) and bottom-right (jump) are taken. The docs suggest positioning custom action buttons relative to the jump button.

Sources: https://create.roblox.com/docs/ui/on-screen-containers (insets), https://create.roblox.com/docs/ui/position-and-size (mobile zones)

## Layout modifiers

| Modifier | Use it for |
|---|---|
| `UIListLayout` | Rows and columns. Flex properties: `Wraps`, `HorizontalFlex`, `VerticalFlex`, `ItemLineAlignment`. |
| `UIFlexItem` | Per-child flex: `FlexMode` (Fill, Grow, Shrink, Custom), `GrowRatio`, `ShrinkRatio`, `ItemLineAlignment`. |
| `UIGridLayout` | Inventory grids, item shops. |
| `UITableLayout` | Stat tables, leaderboards. |
| `UIPageLayout` | Swipeable pages, tabbed shops. |
| `UIPadding` | Inner spacing (feed it spacing tokens). |
| `UIScale` | Global scale multiplier for a subtree. |
| `UISizeConstraint`, `UITextSizeConstraint`, `UIAspectRatioConstraint` | Min/max sizes, min/max text size, fixed ratios. |

`LayoutOrder` sorts children in list and grid layouts. Leave gaps (10, 20, 30) so you can insert later.

Sources: https://create.roblox.com/docs/ui/list-flex-layouts, https://create.roblox.com/docs/ui/grid-table-layouts

## Responsive checklist

1. Test with the Studio device emulator at a small phone, a tablet, 1080p, and a 4K TV.
2. One root `UIScale` driven by `workspace.CurrentCamera.ViewportSize` (clamp it).
3. Nothing interactive outside the safe area; nothing important under the mobile thumb zones.
4. Gamepad: set `Selectable` and selection order on buttons so console players can navigate.
5. Show context-based UI (proximity prompts, contextual buttons) instead of permanent buttons on small screens.

## Design guidance from Roblox

- UI/UX design guide (prioritization, visual language, conventions, flows): https://create.roblox.com/docs/production/game-design/ui-ux-design
- UI design curriculum (art style, wireframes, implementing in Studio): https://create.roblox.com/docs/tutorials/curriculums/user-interface-design
