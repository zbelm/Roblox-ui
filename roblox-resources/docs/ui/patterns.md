---
topic: ui
summary: HUD, menu, shop, inventory, notification, and text patterns, plus visual reference galleries
keywords: HUD, DisplayOrder, ResetOnSpawn, modal, CanvasGroup, GuiService.SelectedObject, shop, PromptProductPurchase, GetProductInfoAsync, ViewportFrame, 9-slice, inventory, ScrollingFrame, AutomaticCanvasSize, UIDragDetector, toast, ExperienceNotificationService, rich text, text filtering, MaxVisibleGraphemes, feature packages
verified: 2026-10-28
---
# UI patterns
## Use this
- Viewport frames: 3D item previews inside UI https://create.roblox.com/docs/ui/viewport-frames [S12]
- UI drag detectors: drag and drop, replaces `GuiObject.Draggable` https://create.roblox.com/docs/ui/ui-drag-detectors [S15]
- 9-slice: scalable panels and buttons without stretched corners https://create.roblox.com/docs/ui/9-slice [S13]
- Interface In Game: menu, inventory, store, HUD reference screenshots https://interfaceingame.com [S158]
- Scrolling frames: inventory lists and grids https://create.roblox.com/docs/ui/scrolling-frames [S14]
## Concepts
- Structure:
  - One `ScreenGui` per layer ordered by `DisplayOrder`: HUD 0, menus 10, modals 20, toasts 30; `ResetOnSpawn = false`.
  - UI code in `StarterPlayerScripts`; templates (button, slot, toast) in `ReplicatedStorage`, cloned.
  - UI sends intent and renders server-replicated state; it never decides outcomes.
- HUD: readouts top-left/top-right inside `CoreUISafeInsets`; count numbers up over ~0.3 s; use `ProximityPrompt` for world interactions [S11].
- Menus: 0.15-0.3 s slide plus `CanvasGroup.GroupTransparency` fade (`snippets/ui-tween-panel.luau`); one modal at a time via a single controller; set `GuiService.SelectedObject` on open for gamepads.
- Shops [S20]:
  - Roblox's Shop surface lists passes and developer products in-game and on the game page.
  - Flow: client calls `MarketplaceService:PromptProductPurchase`; server grants in the receipt handler; UI updates from replicated balance.
  - Show name and price with `GetProductInfoAsync`.
  - Previews via `ViewportFrame` [S12]; 9-slice panels [S13].
- Inventories: `ScrollingFrame` plus `UIGridLayout` (or `UIListLayout` with `Wraps`), `AutomaticCanvasSize`; slots use Scale width plus `UIAspectRatioConstraint`; `UIDragDetector` for drag; reuse slot instances for hundreds of items [S14][S15].
- Notifications: build a toast stack (`UIListLayout` in a corner, tween in/out); `StarterGui:SetCore("SendNotification")` offers little styling. Off-platform, opt-in notifications use `ExperienceNotificationService` [S45].
- Text: rich text tags for inline styling [S16]; filter any player-written text shown to others [S17]; typewriter effect via `MaxVisibleGraphemes`.
- Feature packages (season passes, missions, bundles, engagement rewards) ship default UI you can restyle [S47].
## Gotchas
- Do not grant purchases from the client prompt-finished event [S20].
- `MarketplaceService:GetProductInfo` is deprecated; use `GetProductInfoAsync`.
- Insert feature packages only from Roblox's official listing and read the scripts [S47].
- Interface In Game screenshots are copyrighted game art; reference only [S158].
- Game UI Database returned HTTP 403; unverified [S159].
- Figma Community search returned HTTP 403; unverified; many kits are personal-use only, check each license [S160].
## Sources
S11, S12, S13, S14, S15, S16, S17, S20, S45, S47, S158, S159, S160
