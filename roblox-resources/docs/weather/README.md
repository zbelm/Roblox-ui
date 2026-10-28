---
topic: weather
summary: How Lighting, Atmosphere, Clouds, Sky, global wind, and particles combine into day/night cycles and weather, and which community modules are safe
keywords: Lighting, ClockTime, TimeOfDay, GeographicLatitude, LightingStyle, PrioritizeLightingQuality, Atmosphere, Density, Haze, Glare, Clouds, Cover, Sky, GlobalWind, WindAffectsDrag, ParticleEmitter, rain, snow, fog, storm, day/night, GetServerTimeNow, post-processing, weather preset
verified: 2026-10-28
---
# Weather and atmosphere
## Use this
- Environment docs: Lighting, Atmosphere, Clouds, Skybox, Global wind, Post-processing https://create.roblox.com/docs/environment [S35]
- Global wind: one `Workspace.GlobalWind` vector moves grass, clouds, and particles https://create.roblox.com/docs/environment/global-wind [S40]
- buildthomas/Rain (Apache-2.0, 2026-09-19): rain with roof occlusion and sounds https://github.com/buildthomas/Rain [S129][S74]
- Lighting docs: `ClockTime`, `GeographicLatitude`, `LightingStyle`, exposure, ambient https://create.roblox.com/docs/environment/lighting [S36]
- Snippets: `snippets/weather-day-night-cycle.luau`, `snippets/weather-preset-blend.luau` (unverified, not run in Studio)
## Concepts
- Lighting: `ClockTime` (0-24) moves sun and moon; `TimeOfDay` is the same value as a string; nothing advances it unless a script does. `GeographicLatitude` tilts the sun path (seasons). `Brightness`, `Ambient`, `OutdoorAmbient`, `ExposureCompensation`, `EnvironmentDiffuseScale`/`EnvironmentSpecularScale` set mood. `LightingStyle` (Realistic or Soft) and `PrioritizeLightingQuality` replaced `Technology` [S36].
- Atmosphere (child of `Lighting`): `Density` = light scattering (fog thickness), `Offset` moves haze toward/away from camera, `Haze`/`Glare` shape horizon and sun glow, `Color`/`Decay` tint near and far haze [S37].
- Fog is mostly Atmosphere `Density` plus `Haze`; classic `Lighting.FogStart`/`FogEnd` are hidden when an Atmosphere exists, so pick one approach [S37].
- Clouds must be parented to `Workspace.Terrain`: `Cover` (0-1), `Density`, `Color`; global wind moves them [S38][S40].
- Sky: skybox images, sun/moon textures and sizes, star count, `SkyboxOrientation` [S39].
- Precipitation: a `ParticleEmitter` on an invisible anchored part following the camera; `Rate` = intensity, `Speed`/`Acceleration` = fall, `WindAffectsDrag` plus `Drag` let wind push it [S40].
- Rain needs occlusion (raycast up, stop emitting under roofs) or it falls through ceilings; the Rain module handles this. Snow needs slower speed, longer lifetime, some spread [S129].
- Weather system: presets (Clear, Overcast, Rain, Storm, Snow, Fog) store targets for Atmosphere, Clouds, Lighting, wind, particle rate, sound; tween to the next preset over 10-60 s. Server picks the state and replicates it (for example an attribute); clients apply visuals.
- Day/night across servers: derive `ClockTime` from `workspace:GetServerTimeNow()` so every client computes the same hour; server logic uses the same function.
- Post-processing (`BloomEffect`, `ColorCorrectionEffect`, `DepthOfFieldEffect`, `SunRaysEffect`, `BlurEffect`, `ColorGradingEffect`) lives in `Lighting` or the camera and is tweenable [S41].
- Community modules:
  - buildthomas/Rain: Apache-2.0, 2026-09-19; use [S129].
  - 1ForeverHD/Rain: Apache-2.0, 2018-08-03, stale fork; skip [S130].
  - Realistic Rain: author says "license-free" (no formal license), v1.1.2 2021-04-16, no further releases planned; raycast occlusion, a 2024 reply reports rain through roofs; caution [S75].
  - SimpleWeather V2.0: no license stated, 2025-04-25 (fix 2025-06-03), Creator Store model with attribute-driven presets; vet scripts; caution [S76].
  - HYPER Weather: no license stated, 2024-09-15, Creator Store model, price unclear; caution [S77].
  - How To: Custom Day-Night System: no license stated, older; reading on lighting design; caution [S78].
## Gotchas
- Deprecated: `Lighting.Technology`, `Outlines`, `ShadowColor`, `getMinutesAfterMidnight`/`setMinutesAfterMidnight` [S36].
- Setting `ClockTime` every frame from the server replicates constantly; compute on clients from synced time.
- `Clouds` outside Terrain do nothing [S38].
- Particle-heavy rain hurts low-end phones; cap `Rate`, use few large flipbook textures, scale by graphics quality.
- Lighting changes from client scripts do not replicate (intended for per-client visuals).
- DevForum "open source" is not a license; with none stated, reuse is permission-uncertain.
- Paid weather engines (BuiltByBit listings, the 2026 "Advanced Atmospheric Engine" thread) are closed or unreleased; skip unless you buy and review the code.
## Sources
S35, S36, S37, S38, S39, S40, S41, S74, S75, S76, S77, S78, S129, S130
