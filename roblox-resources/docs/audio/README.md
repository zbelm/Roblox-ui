---
topic: audio
summary: How to set up game audio (modular audio API vs legacy Sound), where to get SFX/music, and Roblox audio rules
keywords: audio, AudioPlayer, AudioEmitter, AudioListener, AudioDeviceOutput, Wire, AudioEqualizer, AudioReverb, Sound, SoundGroup, SoundService, RollOffMaxDistance, spatial audio, 3D audio, music, SFX, Creator Store audio, upload limits, audio privacy, APM, Monstercat, DistroKid, Freesound, Sonniss
verified: 2026-10-28
---
# Audio
## Use this
- Audio objects guide: 2D and 3D wiring with `AudioPlayer`, `AudioEmitter`, `AudioListener`, `Wire` https://create.roblox.com/docs/audio/objects [S247]
- Audio assets guide: finding store audio, import formats, upload caps, moderation https://create.roblox.com/docs/audio/assets [S246]
- Audio effects: EQ, reverb, compressor and more on audio streams https://create.roblox.com/docs/audio/effects [S248]
- Sonniss GDC bundles: large royalty-free SFX sets, no attribution https://sonniss.com/gameaudiogdc [S257]
- Creator Store music (APM, Monstercat, DistroKid Hits): licensed for use on Roblox only [S254]
## Concepts
- Two systems exist. The docs now call `Sound`, `SoundGroup`, and Sound effects "legacy"; the modular audio API is the current one [S245][S249][S250].
- Modular API pieces [S245][S247]:
  - `AudioPlayer` loads an asset id and plays it.
  - `AudioEmitter` is a virtual speaker in the world; `AudioListener` is a virtual microphone (usually on the camera or character).
  - `AudioDeviceOutput` is the player's speakers; `AudioDeviceInput` is a real microphone (voice).
  - `Wire` connects `SourceInstance` to `TargetInstance`.
- 2D (music, UI clicks): `AudioPlayer` -> `Wire` -> `AudioDeviceOutput`, all under `SoundService` [S247].
- 3D (footsteps, explosions): `AudioPlayer` -> `Wire` -> `AudioEmitter` on a part; `AudioListener` -> `Wire` -> `AudioDeviceOutput`. Distance attenuation is set on the emitter [S247].
- Effects sit between wires (player -> effect -> emitter/output), so one music bus can be EQ'd or ducked for all tracks [S248].
- `SoundService.AcousticSimulationEnabled` turns on occlusion, diffraction, and reverb for `AudioEmitter`/`AudioListener` globally; per-instance flags also exist [S258].
- Legacy `Sound`: still works; use `RollOffMinDistance`/`RollOffMaxDistance` (not `MinDistance`/`MaxDistance`), `PlaybackSpeed` (not `Pitch`), `IsPlaying` (not `isPlaying`) [S252].
- Imports: `.mp3`, `.ogg`, `.wav`, `.flac`; under 20 MB and 7 minutes; up to 48 kHz; mono, stereo, 3.0, or 5.1 [S246].
- Upload caps: 2,000 free audio imports per 30 days for ID-verified accounts, 100 for unverified [S246].
- Uploaded audio starts private; grant other experiences access through asset privacy settings [S246][S251].
- Store music can show on the game page ("What's Playing") when the track and uploader meet Roblox's requirements [S246].
- SFX sources outside Roblox: Freesound (license per sound), Sonniss GDC bundles, Kenney audio packs (CC0), OpenGameArt (license per asset) [S256][S257][S142][S147].
## Gotchas
- Clicking a store audio in the Toolbox inserts a legacy `Sound`, not an `AudioPlayer`; copy the asset id instead [S246].
- Creator Store music is licensed for Roblox only; using it in YouTube/TikTok videos falls under those platforms' copyright systems [S254].
- Store audio must be in your inventory before use; the permission grant applies to the user who inserted it, not other Team Create collaborators, and groups cannot acquire it [S254].
- Freesound CC-BY-NC sounds cannot be used in a monetized game [S256].
- Sonniss sounds cannot be redistributed as sound packs (including free Creator Store uploads of raw SFX) [S257].
- Upload only audio you own or license; copyright claims lead to asset removal and account action (unverified: penalty specifics; Audio Upload License Agreement page blocked, HTTP 403) [S253].
- A cap of 250 distinct licensed tracks per experience appears only in forum discussion; ambiguous, not in current docs.
- Monstercat partnership details date from 2020; check track availability in the store [S255].
## Sources
S142, S147, S245, S246, S247, S248, S249, S250, S251, S252, S253, S254, S255, S256, S257, S258
