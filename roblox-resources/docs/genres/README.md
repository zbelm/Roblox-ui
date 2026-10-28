---
topic: genres
summary: Defining mechanics, design reasons, and open-source examples for tycoon, obby, simulator, horror, tower defense, roleplay
keywords: genre, tycoon, dropper, conveyor, obby, obstacle course, checkpoint, stage, simulator, clicker, rebirth, pets, horror, jumpscare, chase, tower defense, waves, placement, roleplay, RP, Brookhaven, social, core loop
verified: 2026-10-28
---
# Genres
## Use this
- Design for Roblox: official genre table with definitions and example games https://create.roblox.com/docs/production/game-design/design-for-roblox [S295]
- Core loops guide: identify the repeated action each genre is built on [S271]
- Platformer template: official starting place for obbies [S32]
- Contextual purchases: where each genre naturally offers purchases https://create.roblox.com/docs/production/game-design/contextual-purchases [S297]
- Horror experiences guide (community): pacing, sound, scares https://devforum.roblox.com/t/guide-to-making-better-horror-experiences/2212571 [S298]
## Concepts
- Genre definitions below come from Roblox's genre table; "why it works" bullets are design analysis, not measured data (unverified: no cited retention study) [S295].
- Roblox's docs advise following genre norms so players understand the game immediately, and building in social play for retention [S295].
- Tycoon [S295]:
  - Mechanics: claim a plot; droppers produce currency over time onto a conveyor; buy buttons build the next part, which unlocks more droppers and buttons; often a rebirth reset.
  - Why it works: constant visible growth, short wait-buy loops, idle income gives a reason to return.
  - Build notes: template the plot and clone per player; server owns the money and unlock state; save unlocked button ids, not parts [S56].
- Obby [S295][S32]:
  - Mechanics: linear or branching stages of jumps and hazards; checkpoints (`SpawnLocation` per stage); stage counter; skips and difficulty tiers.
  - Why it works: zero learning curve, clear goal, fast retry.
  - Build notes: save stage number; validate stage progress on the server by order and timing to stop teleport skips [S174].
- Simulator [S295]:
  - Mechanics: click or swing to gather, fill a capacity limit, sell for currency, upgrade tools/backpacks/pets, unlock zones, rebirth for multipliers.
  - Why it works: numbers go up fast, each upgrade is a visible step, pets and zones add collection goals.
  - Build notes: currency values grow huge; plan number formatting and economy sinks early [S64].
- Horror (Roblox lists Hide and Seek and Survival as related genres; Doors is cited as a procedural survival horror example) [S295]:
  - Mechanics: atmosphere, threat AI that hunts or chases, limited resources, objectives (keys, escapes), often co-op in small servers.
  - Why it works: shared fear is social; procedural rooms keep runs fresh.
  - Build notes: sound and lighting carry most of the effect; avoid repeating the same scare; community critique warns against pure "key-hunt" loops [S298][S299].
- Tower defense:
  - Mechanics: enemies follow a path in waves; players place and upgrade towers with in-match currency; unit collection and loadouts outside matches.
  - Why it works: clear strategy layer, co-op with friends, collection meta.
  - Build notes: simulate enemies as data (position along path) and render on clients; hundreds of humanoid enemies are too expensive [S192][S212].
  - Not in Roblox's genre table; definitions here are unverified design analysis.
- Roleplay [S295]:
  - Mechanics: social sandbox; houses, vehicles, jobs, props; avatar and name customization; light rules.
  - Why it works: players make their own stories with friends; low skill floor.
  - Build notes: heavy on text chat and moderation duties; filter all player text; maturity label matters [S296].
## Gotchas
- No maintained open-source tower defense game was found; the 2024 "Open Source Tower Defense" post is copylocked with no shared source [S300].
- Eternal Empire is open but CC BY-NC 4.0 (non-commercial) and written in roblox-ts; read for structure only [S301].
- Old free tycoon and obby kits in the Creator Store often contain hidden scripts; vet them [S177].
- Genre trends shift; check current charts before choosing a genre (unverified: charts pages not fetched this pass).
## Sources
S32, S56, S64, S174, S177, S192, S212, S271, S295, S296, S297, S298, S299, S300, S301
