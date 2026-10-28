---
topic: debugging
summary: How to find bugs: common error messages and real causes, debugger, profilers, replication and timing bugs
keywords: debugging, error, Output, Developer Console, F9, breakpoint, watch, call stack, MicroProfiler, Script Profiler, memory, Infinite yield possible, attempt to index nil, required recursively, Script timeout, Remote event invocation, DataStore request was added to queue, race condition, replication, streaming, deferred, Network Simulator, multi-client, error report
verified: 2026-10-28
---
# Debugging
## Use this
- Breakpoint debugger: pause, step, watch variables, inspect call stack https://create.roblox.com/docs/studio/debugging [S232]
- Developer Console (F9): logs, memory, network, script profiler, works in live servers https://create.roblox.com/docs/studio/developer-console [S233]
- Testing modes: multi-client server tests, device and network simulation https://create.roblox.com/docs/studio/testing-modes [S235]
- Network Simulator: add latency, jitter, packet loss in Studio https://create.roblox.com/docs/studio/network-simulator [S236]
- Error report: live-game errors grouped with stack traces and custom rules https://create.roblox.com/docs/production/analytics/error-report [S240]
## Concepts
- Common errors and usual causes:
  - `Infinite yield possible on ...:WaitForChild(...)`: wrong name or path, the object is created later or never, or it is streamed out on the client [S197].
  - `attempt to index nil with 'X'`: a lookup returned nil (missing child, character not spawned yet, streamed part, failed `require` result); check before indexing [S197].
  - `Requested module was required recursively`: two modules require each other [S206].
  - `Script timeout: exhausted allowed execution time`: only when `ScriptContext:SetTimeout` is enabled; a loop ran without yielding past the limit [S241].
  - `Remote event invocation ...` error: messages queued with no handler connected filled the queue and were discarded [S216].
  - `DataStore request was added to queue`: request budget exceeded; reduce calls or spread them out [S240][S53].
- Debugger: set breakpoints in the script editor, run, then step over/into/out; Watch and Call Stack windows show values. Command Bar runs Luau in the current context [S232].
- Server vs client output: in a Studio play test the Output shows both, labelled; in live games use the Developer Console's server and client log tabs [S233][S234].
- Multi-client test (Test tab, 2+ players) reproduces most replication bugs: one client sees a change, another does not; the server state differs from client state [S235].
- Replication bugs: client-side changes do not replicate (except physics on owned parts and a few character properties); server-created instances arrive later on clients; ServerStorage/ServerScriptService content never reaches clients [S207].
- Timing bugs: `PlayerAdded` connected after players already joined (loop `Players:GetPlayers()` too); `CharacterAdded` vs existing character; deferred signals run handlers later than `Fire` [S209].
- Streaming bugs show up only on clients and only far from spawn; test with streaming on and walk around [S197].
- Profiling: MicroProfiler (Ctrl+Alt+F6) for per-frame time and memory; Script Profiler for per-function CPU; Studio memory tools and Scene Analysis for leaks [S239][S237][S238][S194].
- Leak pattern: connections never disconnected and tables keyed by `Player` never cleared on `PlayerRemoving` keep memory growing [S190].
- Live errors: the Creator Hub error report groups errors, shows stack traces, and lets you write rules to group or ignore noise [S240].
- AI tooling: Studio MCP lets an assistant read the tree, run code, and drive play mode; review every edit it proposes [S242].
## Gotchas
- Studio runs server and client in one process; timing and memory differ from live games. Confirm fixes in a published test place [S195].
- `print` spam in loops slows the game and floods logs; remove or gate behind a debug flag [S202].
- The console Server log and command bar show only for the owner or group members with edit permission; players see client logs only [S233].
- `ScriptContext:SetTimeout` defaults to 0 (disabled); do not expect the watchdog to catch infinite loops by default [S241].
- MicroProfiler explicitly enabled turns on memory tracking for the next session per a 2025 thread (unverified: not rechecked) [S201].
- Assistant-generated profiling reports can be wrong; confirm in the raw dump [S244].
## Sources
S53, S190, S194, S195, S197, S201, S202, S206, S207, S209, S216, S232, S233, S234, S235, S236, S237, S238, S239, S240, S241, S242, S243, S244
