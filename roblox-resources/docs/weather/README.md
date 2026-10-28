# Weather and atmosphere

Last verified: 2026-10-28

## Purpose

Answers: how `Lighting`, `Atmosphere`, `Clouds`, `Sky`, global wind, and particles
combine into day/night cycles and weather (rain, snow, fog, storms), and which
community modules are safe to use.

## Top 5 picks

1. **Environment docs** (https://create.roblox.com/docs/environment). Lighting, Atmosphere, Clouds, Skybox, Global wind, Post-processing. Use it.
2. **Global wind** (https://create.roblox.com/docs/environment/global-wind). One vector (`Workspace.GlobalWind`) that moves terrain grass, dynamic clouds, and particles with `WindAffectsDrag`. Use it; it ties a weather system together for free.
3. **buildthomas/Rain** (https://github.com/buildthomas/Rain). Rain module with roof occlusion, custom collision filters, royalty-free sounds. Apache-2.0, last commit 2026-09-19. DevForum thread: https://devforum.roblox.com/t/rain-module-plugin/157190. Use it.
4. **Lighting docs** (https://create.roblox.com/docs/environment/lighting). `ClockTime`, `GeographicLatitude`, `LightingStyle`, `PrioritizeLightingQuality`, exposure and ambient. Use it.
5. **Snippets in this repo**: [../../snippets/weather-day-night-cycle.luau](../../snippets/weather-day-night-cycle.luau) and [../../snippets/weather-preset-blend.luau](../../snippets/weather-preset-blend.luau). Unverified (not run in Studio); API names checked against the engine reference.

## How it works

**Lighting** is the global light. `ClockTime` (0 to 24) moves the sun and moon;
`TimeOfDay` is the same value as a string. Nothing advances it automatically; a
script has to. `GeographicLatitude` tilts the sun's path (useful for seasons).
`Brightness`, `Ambient`, `OutdoorAmbient`, `ExposureCompensation`, and
`EnvironmentDiffuseScale`/`EnvironmentSpecularScale` set mood. `LightingStyle`
(Realistic or Soft) and `PrioritizeLightingQuality` replaced the deprecated
`Technology` property.

**Atmosphere** (a child of `Lighting`) simulates air: `Density` is how much light it
scatters (fog thickness), `Offset` pushes haze toward or away from the camera,
`Haze` and `Glare` shape the horizon and sun glow, `Color` and `Decay` tint near and
far haze. Fog is mostly Atmosphere Density plus Haze; the reference notes that
the classic `Lighting.FogStart`/`FogEnd` properties are hidden when `Lighting`
contains an Atmosphere, so pick one fog approach.

**Clouds** (must be parented to `Workspace.Terrain` to render) are volumetric:
`Cover` (0 to 1, how much sky), `Density` (how thick and dark), `Color`. Global wind
moves them.

**Sky** sets the skybox images, sun/moon textures and sizes, star count, and
`SkyboxOrientation`. Swap or tint for storms and night.

**Particles** do precipitation. A `ParticleEmitter` on an invisible, anchored part
that follows the camera above the player emits rain streaks or snowflakes; `Rate`
is intensity, `Speed` and `Acceleration` set fall, `WindAffectsDrag` with `Drag`
lets global wind push them. Rain needs occlusion (raycast up from the camera and
stop emitting under roofs) or it falls through ceilings; that is what the Rain
module handles. Snow needs slower speed, longer lifetime, and some spread.

**A weather system** is a state machine of presets (Clear, Overcast, Rain, Storm,
Snow, Fog). Each preset stores target values for Atmosphere, Clouds, Lighting
tweaks, wind, particle rate, and ambient sound. Changing weather tweens current
values toward the next preset over 10 to 60 seconds. The server picks the state
(so all players agree) and replicates it, for example as an attribute; each
client applies visuals locally.

**Day/night across servers.** Derive `ClockTime` from shared time
(`workspace:GetServerTimeNow()`) instead of counting frames. Every client computes
the same hour without the server sending updates, and server logic (night
spawns, shop hours) uses the same function.

Post-processing (`BloomEffect`, `ColorCorrectionEffect`, `DepthOfFieldEffect`,
`SunRaysEffect`, `BlurEffect`, and color grading via `ColorGradingEffect`) sits in
`Lighting` or the camera and is tweenable; a slight desaturation during storms
reads well.

## Gotchas

- `Lighting.Technology`, `Lighting.Outlines`, `Lighting.ShadowColor`, and `getMinutesAfterMidnight`/`setMinutesAfterMidnight` are deprecated. Use `LightingStyle`, `PrioritizeLightingQuality`, and `ClockTime`.
- Setting `ClockTime` from a server loop every frame replicates a property change constantly. Compute it on clients from synced time instead.
- `Clouds` placed anywhere other than under Terrain does nothing.
- Particle-heavy rain kills low-end phones. Cap `Rate`, use few large textures with flipbooks, and scale intensity by a graphics-quality setting.
- Studio's Lighting changes made in a client script during play do not replicate (intended for per-client visuals).
- Community weather modules on DevForum rarely state a license. "Open source" in a post is not a license; when none is given, treat reuse as permission-uncertain and ask the author or write your own.
- Paid "weather engines" (BuiltByBit listings, the 2026 "Advanced Atmospheric Engine" thread) are closed or not yet released. Skip unless you buy and review the code.

## Community resources

| Name | URL | License | Updated | Verdict |
|---|---|---|---|---|
| buildthomas/Rain | https://github.com/buildthomas/Rain | Apache-2.0 | 2026-09-19 | Use it. |
| 1ForeverHD/Rain (fork) | https://github.com/1ForeverHD/Rain | Apache-2.0 | 2018-08-03 | Skip; stale fork of the module above. |
| Realistic Rain (DevForum) | https://devforum.roblox.com/t/feedback-open-source-realistic-rain-v112/1078997 | Author: "license-free" (no formal license) | v1.1.2, 2021-04-16; no further releases planned | Use with caution. Raycast occlusion; a 2024 reply reports rain still passing through roofs in some cases. |
| SimpleWeather V2.0 (DevForum) | https://devforum.roblox.com/t/simpleweather-v20-a-easy-to-use-weather-module/3626171 | Not stated | 2025-04-25, fix 2025-06-03 | Use with caution. Creator Store model; client-side presets (rain, snow, storm, fog) driven by attributes. Vet the model's scripts. |
| HYPER Weather (DevForum) | https://devforum.roblox.com/t/hyper-realistic-weather-for-roblox-rain-snow-storms-and-more/3158864 | Not stated | 2024-09-15 | Use with caution. Creator Store model; license and price unclear. |
| How To: Custom Day-Night System (DevForum) | https://devforum.roblox.com/t/how-to-custom-day-night-system/712476 | Not stated | Older thread (date not checked) | Use with caution as reading on lighting design. |

## Sources

- https://create.roblox.com/docs/environment
- https://create.roblox.com/docs/environment/lighting
- https://create.roblox.com/docs/environment/atmosphere
- https://create.roblox.com/docs/environment/clouds
- https://create.roblox.com/docs/environment/skybox
- https://create.roblox.com/docs/environment/global-wind
- https://create.roblox.com/docs/environment/post-processing-effects
- Community table URLs above
