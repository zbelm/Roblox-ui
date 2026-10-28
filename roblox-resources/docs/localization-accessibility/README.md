---
topic: localization-accessibility
summary: How to translate a game and make it accessible: localization tools, colorblind-safe design, input across touch/keyboard/gamepad, text size
keywords: localization, translation, automatic translation, LocalizationTable, LocalizationService, Translator, FormatByKey, GetTranslatorForPlayerAsync, accessibility, colorblind, contrast, WCAG, PreferredTextSize, PreferredTransparency, ReducedMotionEnabled, input, Input Action System, InputContext, InputAction, InputBinding, gamepad, touch, keyboard, console, 10-foot UI
verified: 2026-10-28
---
# Localization and accessibility
## Use this
- Automatic translations: capture in-game text and translate it with no code https://create.roblox.com/docs/production/localization/automatic-translations [S349]
- Accessibility guidelines: text size, contrast, color and sound non-reliance, player preferences https://create.roblox.com/docs/production/publishing/accessibility [S354]
- Input Action System: bind actions across keyboard, gamepad, touch with contexts https://create.roblox.com/docs/input/input-action-system [S358]
- Adaptive design: build one UI that adapts to device and input type https://create.roblox.com/docs/production/publishing/adaptive-design [S355]
- WebAIM contrast checker: test text/background color pairs https://webaim.org/resources/contrastchecker/ [S363]
## Concepts
- Localization layers [S348]:
  - Automatic text capture collects UI strings into the game's localization table; automatic translation fills supported languages [S349].
  - Manual translations override or add strings in Creator Hub or by CSV [S350].
  - Scripted text: get a `Translator` from `LocalizationService:GetTranslatorForPlayerAsync(player)` and use `translator:FormatByKey(key, args)` or `Translate` [S351][S353].
  - Dynamic content (generated names, server strings) has its own translation path [S352].
- Leave room for text growth (translated strings often run longer); use `AutomaticSize` and `TextWrapped`, not fixed tight boxes [S354].
- Text size: `GuiService.PreferredTextSize` (default `Medium`) reflects the player's text size setting; respect it in custom UI [S354][S361].
- Preferred transparency: multiply backgrounds by `GuiService.PreferredTransparency` so players who want opaque backgrounds get them [S354].
- Reduced motion: check `GuiService.ReducedMotionEnabled` and shorten or skip camera shakes and large tweens [S361].
- Color: about 5% of people have some color blindness; never use color alone for meaning; add icons, shapes, or labels; preview screenshots in a simulator [S354][S364].
- Contrast: WCAG's minimum for normal text is 4.5:1 [S362].
- Sound: do not rely on audio alone for critical cues; pair with visual indicators; provide volume controls per category [S354].
- Input: detect the player's primary input and swap button prompts and on-screen controls when they change (touch to gamepad, for example) [S357].
- Input Action System: define `InputAction`s grouped in `InputContext`s with `InputBinding`s per device; enable or disable contexts per game state (combat vs menu) [S358].
- Gamepad and console: every interactive UI element must be selectable; design for a TV at distance with larger text; controllers have haptics [S359][S356].
- Touch: keep controls out of the default thumbstick and jump zones; make targets large enough to tap [S360][S2].
## Gotchas
- `LocalizationService:GetTranslatorForPlayer` (non-Async) is deprecated [S353].
- Parts of the Input Action System are still beta: `InputActionLabel` and the Input Action Manager tool require enabling the beta [S358].
- Server authority requires `PlayerScriptsUseInputActionSystem`, so competitive games will use input actions anyway [S180].
- Automatic translation quality varies; review key strings (tutorial, shop, prompts) in top languages manually [S350].
- Images with baked-in text are not translated; keep text in TextLabels or localize image ids with `FormatByKey` [S351].
## Sources
S2, S180, S348, S349, S350, S351, S352, S353, S354, S355, S356, S357, S358, S359, S360, S361, S362, S363, S364
