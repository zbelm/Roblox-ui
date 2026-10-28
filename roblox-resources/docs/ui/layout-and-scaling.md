---
topic: ui
summary: Scale vs Offset, safe areas, flex/grid layout modifiers, and a responsive checklist
keywords: UDim2, fromScale, fromOffset, AnchorPoint, AutomaticSize, UIScale, UIAspectRatioConstraint, UITextSizeConstraint, ScreenInsets, CoreUISafeInsets, IgnoreGuiInset, UIListLayout, UIFlexItem, UIGridLayout, UITableLayout, UIPageLayout, LayoutOrder, responsive
verified: 2026-10-28
---
# Layout and scaling
## Use this
- Position and size: Scale, Offset, AnchorPoint, mobile reserved zones https://create.roblox.com/docs/ui/position-and-size [S2]
- Size modifiers: `UIScale`, automatic sizing, constraints https://create.roblox.com/docs/ui/size-modifiers [S5]
- List/flex layouts: `UIListLayout` flex properties and `UIFlexItem` https://create.roblox.com/docs/ui/list-flex-layouts [S3]
- On-screen containers: `ScreenInsets` safe-area modes https://create.roblox.com/docs/ui/on-screen-containers [S6]
- UI/UX design guide: prioritization, visual language, conventions, flows https://create.roblox.com/docs/production/game-design/ui-ux-design [S18]
## Concepts
- `UDim2.new(xScale, xOffset, yScale, yOffset)`; `UDim2.fromScale`/`fromOffset` are shortcuts [S2].
- Rule of thumb across phone, tablet, desktop, console [S2][S5]:
  - Containers: Scale for position and width.
  - Content (icons, buttons, padding): Offset multiplied by one root `UIScale` set from viewport size.
  - Squares (slots, avatars): Scale plus `UIAspectRatioConstraint`.
- Text: use `TextScaled` only with `UITextSizeConstraint`, or set `TextSize` from tokens and let `UIScale` scale it [S5].
- `AnchorPoint` changes the origin for position and size; center a modal with `AnchorPoint = (0.5, 0.5)` and `Position = UDim2.fromScale(0.5, 0.5)` [S2].
- `AutomaticSize` fits a frame to children or text (tooltips, notifications, rows) [S5].
- `ScreenInsets` modes: `CoreUISafeInsets` (default, clear of top bar and notches), `DeviceSafeInsets` (cutouts only), `TopbarSafeInsets` (strip beside top bar), `None` (full-bleed backgrounds only) [S6].
- Mobile: bottom-left (thumbstick) and bottom-right (jump) are taken; place custom action buttons relative to the jump button [S2].
- Layout modifiers [S3][S4][S5]:
  - `UIListLayout`: rows/columns; `Wraps`, `HorizontalFlex`, `VerticalFlex`, `ItemLineAlignment`.
  - `UIFlexItem`: `FlexMode` (Fill, Grow, Shrink, Custom), `GrowRatio`, `ShrinkRatio`, `ItemLineAlignment`.
  - `UIGridLayout`: inventory grids, shops. `UITableLayout`: stat tables, leaderboards. `UIPageLayout`: swipeable or tabbed pages.
  - `UIPadding`: inner spacing. `UIScale`: subtree scale multiplier.
  - `UISizeConstraint`, `UITextSizeConstraint`, `UIAspectRatioConstraint`: min/max size, min/max text size, fixed ratio.
- `LayoutOrder` sorts list/grid children; leave gaps (10, 20, 30) for later inserts [S3].
- Responsive checklist:
  - Emulate a small phone, a tablet, 1080p, and a 4K TV.
  - One root `UIScale` driven by `workspace.CurrentCamera.ViewportSize`, clamped.
  - Nothing interactive outside the safe area or under thumb zones.
  - Gamepad: set `Selectable` and selection order.
  - Prefer context-based UI (proximity prompts) over permanent buttons on small screens.
- UI design curriculum covers art style, wireframes, and implementing in Studio [S19].
## Gotchas
- Pure-Scale text gets huge on TVs and tiny on phones [S5].
- `ScreenGui.IgnoreGuiInset` still exists but `ScreenInsets` is the newer, more precise control [S6].
## Sources
S2, S3, S4, S5, S6, S18, S19
