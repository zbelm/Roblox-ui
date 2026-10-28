---
topic: networking
summary: How to move data between server and clients: remotes vs unreliable remotes, buffers, limits, latency
keywords: RemoteEvent, RemoteFunction, UnreliableRemoteEvent, FireServer, FireClient, FireAllClients, OnServerEvent, throttling, 500 per second, 1000 bytes, buffer, Zap, Blink, ByteNet, Packet, Replica, bandwidth, latency, ping, GetNetworkPing, interpolation, prediction, network ownership, MicroProfiler network
verified: 2026-10-28
---
# Networking
## Use this
- Remote events guide: delivery guarantees, throttling, argument rules https://create.roblox.com/docs/scripting/events/remote [S216]
- `UnreliableRemoteEvent`: unordered, droppable, max 1000-byte payload; for high-frequency cosmetic data https://create.roblox.com/docs/reference/engine/classes/UnreliableRemoteEvent [S218]
- Blink: IDL compiler generating typed buffer networking code https://github.com/1Axen/blink [S224]
- Zap: IDL compiler for typed buffer networking, similar goal to Blink https://github.com/red-blox/Zap [S222]
- MicroProfiler network view: see which remotes cost bandwidth https://create.roblox.com/docs/performance-optimization/microprofiler/network [S221]
## Concepts
- `RemoteEvent`: one-way, reliable, ordered, including ordering across different RemoteEvent instances. Messages fired before a handler connects are queued and delivered in order once one connects [S216].
- `RemoteFunction`: request/response; the caller yields until the other side returns. Use client-to-server only [S216][S188].
- `UnreliableRemoteEvent`: no delivery or order guarantee, no ordering relative to reliable remotes; dropped if payload > 1000 bytes, if over the rate limit, or if no handler is connected [S216][S218].
- Rate limit: about 500 client-to-server requests per second per client, shared across all remotes of the same type; excess reliable events are delayed, excess unreliable events are dropped [S217][S216].
- What crosses the wire: Instances arrive as references only if the receiver can see that instance (otherwise `nil`); functions and metatables are stripped; non-string table keys become strings; do not send mixed numeric/string tables [S216].
- Bandwidth: send deltas and ids, not whole tables; batch per frame instead of one remote per change; replicate shared state through Attributes or a replication module instead of custom remotes [S192][S229].
- Buffers: the `buffer` library writes typed numbers and strings into a compact binary blob; buffer networking libraries pack many messages into one buffer per frame [S219].
- IDL libraries (Blink, Zap): you write a schema file; a compiler emits typed send/receive modules for server and client, so payloads are validated by shape and packed tightly [S224][S222].
- Runtime libraries (ByteNet, Packet): define packets in Luau at runtime; no build step, slightly more overhead [S227][S228].
- Latency: `Player:GetNetworkPing()` reports round trip estimate. Hide latency by predicting locally (play the effect, move the projectile) and reconciling with the server result; interpolate other players' state instead of snapping [S231].
- Physics replication: the network owner of an assembly simulates it and replicates results; players own their characters by default [S220].
- Server authority (opt-in) adds engine-level prediction and rollback for competitive games; see security docs [S180].
- Snippet: `snippets/net-batched-unreliable.luau` (per-frame batching into one unreliable send under 1000 bytes).
## Gotchas
- `FireAllClients` with large tables multiplies bandwidth by player count [S192].
- Reliable remotes fired every frame queue up behind each other when bandwidth is tight; use unreliable for positions, aim, VFX [S216].
- Messages to a client that leaves before delivery are lost [S216].
- Remote payloads are not validated by any library automatically on the server boundary; still check types, ranges, and rate [S173].
- Community benchmarks (Blink, Zap, ByteNet, Packet) use different versions and setups; treat numbers as rough [S230].
- Packet is distributed only through the Creator Store; insert and review a copy rather than requiring by id [S228].
- Blink tags are still `1.0.0-pre`; pin a version [S224].
## Sources
S173, S180, S188, S192, S216, S217, S218, S219, S220, S221, S222, S223, S224, S225, S226, S227, S228, S229, S230, S231
