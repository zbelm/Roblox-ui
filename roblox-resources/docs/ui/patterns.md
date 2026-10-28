# UI patterns: HUD, menus, shops, inventories, notifications

Last verified: 2026-10-28

Back to [README.md](README.md).

## Structure that scales

- One `ScreenGui` per layer, ordered with `DisplayOrder`: HUD (0), menus (10), modals (20), toasts (30). Set `ResetOnSpawn = false` on all of them so UI is not rebuilt on every respawn.
- Keep UI code client-side under `StarterPlayerScripts`; keep templates (button, slot, toast) in `ReplicatedStorage` and clone them.
- UI never decides outcomes. It sends intent to the server (buy item 12, equip slot 3) and renders state the server replicates (attributes, values, or a replication library).

## HUD

- Currency, health, and objective readouts in the top-left or top-right, inside `CoreUISafeInsets`.
- Animate number changes (count up over 0.3 s) instead of snapping; it makes rewards feel earned.
- Hide non-essential HUD on small screens; use `ProximityPrompt` for world interactions instead of permanent buttons. Docs: https://create.roblox.com/docs/ui/proximity-prompts

## Menus and modals

- Open/close with a short tween (0.15 to 0.3 s): position slide plus `CanvasGroup.GroupTransparency` fade. Snippet: [../../snippets/ui-tween-panel.luau](../../snippets/ui-tween-panel.luau).
- One modal at a time. Track the open one in a single controller so a second open request closes the first.
- Gamepad: when a menu opens, set `GuiService.SelectedObject` to its first button.

## Shops

- Roblox's own Shop surface (in-game and on the game page) lists passes and developer products. Docs: https://create.roblox.com/docs/production/monetization/shop
- Custom shop UI flow: button calls `MarketplaceService:PromptProductPurchase` on the client; the server grants in its receipt handler; the UI updates when the server's replicated balance changes. Do not grant from the client prompt-finished event.
- `MarketplaceService:GetProductInfo` is deprecated in the current API reference; `GetProductInfoAsync` is its replacement for showing price and name.
- Show item previews with a `ViewportFrame` (3D model rendered inside UI). Docs: https://create.roblox.com/docs/ui/viewport-frames
- Use 9-slice images for scalable panels and buttons so corners do not stretch. Docs: https://create.roblox.com/docs/ui/9-slice

## Inventories

- `ScrollingFrame` + `UIGridLayout` (or `UIListLayout` with `Wraps = true`) for slots; `AutomaticCanvasSize` to size the scroll area. Docs: https://create.roblox.com/docs/ui/scrolling-frames
- Slot squares: Scale width plus `UIAspectRatioConstraint`.
- Drag and drop: `UIDragDetector` (replaces deprecated `GuiObject.Draggable`). Docs: https://create.roblox.com/docs/ui/ui-drag-detectors
- Hundreds of items: reuse slot instances (virtualize) instead of creating one per item.

## Notifications

- In-game toasts: your own toast stack (a `UIListLayout` anchored to a corner, each toast tweens in, waits, tweens out). `StarterGui:SetCore("SendNotification", ...)` exists but gives little styling control.
- Off-platform notifications (to players not in the game) use `ExperienceNotificationService`, which players must opt into. Docs: https://create.roblox.com/docs/production/promotion/experience-notifications. See [../events/README.md](../events/README.md).

## Text

- Rich text tags for inline color/bold: https://create.roblox.com/docs/ui/rich-text
- Any player-written text shown to other players must go through text filtering: https://create.roblox.com/docs/ui/text-filtering
- Typewriter effect: animate `MaxVisibleGraphemes`.

## Ready-made Roblox feature packages (include UI)

Season passes, missions, bundles, and engagement rewards ship with default UI you
can restyle: https://create.roblox.com/docs/resources/feature-packages.
Insert only from Roblox's official listing and read the scripts first.

## Visual reference galleries

| Name | URL | Status 2026-10-28 | Verdict |
|---|---|---|---|
| Interface In Game | https://interfaceingame.com | Loads; games added through Oct 2026 | Use it for menu, inventory, store, and HUD reference screenshots. Reference only; screenshots are copyrighted game art. |
| Game UI Database | https://www.gameuidatabase.com | Returned HTTP 403 to this session | Unverified. Widely used reference site; check it in a browser. |
| Figma Community ("roblox gui kit", "game ui kit") | https://www.figma.com/community | Search returned HTTP 403 to this session | Unverified. Check each file's license on its page before reuse; many kits are personal-use only. |
