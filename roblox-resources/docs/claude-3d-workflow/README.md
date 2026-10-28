---
topic: claude-3d-workflow
summary: How Claude Code can drive a Blender-to-Roblox 3D pipeline - headless bpy scripts, Blender MCP, the Studio MCP server, verification loops, and the safety limits for each
keywords: Claude Code, MCP, Studio MCP server, Enable Studio as MCP server, stdio, execute_luau, inspect_instance, search_game_tree, screen_capture, generate_mesh, generate_procedural_model, search_asset, insert_asset, blender-mcp, mcp-for-blender, execute_blender_code, bpy, headless Blender, --background, --python-exit-code, verification
verified: 2026-10-28
---
# Claude 3D workflow
## Use this
- Studio MCP server docs: enable in Studio, connect Claude Code, tool list [S242]
- blender-mcp (MIT, last commit 2026-10-24): lets an MCP client drive Blender https://github.com/ahujasid/blender-mcp [S467]
- Headless Blender: `blender -b file.blend -P script.py --python-exit-code 1` [S407]
- Snippets: `snippets/blender-check-scale-tris.py`, `snippets/blender-apply-export.py`, `snippets/mesh-verify-meshpart.luau` (Python run with bpy 5.2.3; Luau not run)
- Assistant updates thread for current generation and MCP tool changes [S465]
## Concepts
- Three ways Claude can touch the pipeline, cheapest first:
  - Scripts only: Claude writes bpy and Luau files; you or CI run them. No live connection, easiest to review.
  - Headless Blender: Claude runs `blender -b -P` itself to check or export files and reads the printed report [S407].
  - Live MCP: Claude calls tools in a running Blender or Studio session (blender-mcp, Studio MCP) [S467][S242].
- Headless loop:
  - Inspect: a script prints per-object dimensions and evaluated triangle counts (`evaluated_get(depsgraph).to_mesh()`) [S410].
  - Fix: apply transforms, decimate, rename meshes [S405][S460].
  - Export: `bpy.ops.export_scene.fbx(...)` with Roblox's settings (see mesh-import-export) [S409][S416].
  - `--python-exit-code` turns a failed check into a non-zero exit for CI [S407].
- Studio MCP server [S242]:
  - Enable: open `Assistant`, click `...` > `Manage MCP Servers`, turn on `Enable Studio as MCP server`.
  - Runs locally over `stdio`; the settings panel shows quick connect, JSON config, and CLI setup, with Claude Code listed.
  - Inspect: `search_game_tree`, `inspect_instance`; run code: `execute_luau` in Edit, Client, or Server.
  - Check visually: `screen_capture`; playtest with `start_stop_play` and `get_console_output`.
  - Create: `generate_mesh` (text prompt), `generate_material`, `generate_procedural_model` (parts as a ProceduralModel), `wait_job_finished`.
  - Assets: `search_asset` (Creator Store and your inventory), `insert_asset` by ID, `upload_image`.
- Community Studio MCP server (Roblox/studio-rust-mcp-server, MIT) predates the built-in one; prefer the built-in server [S119][S242].
- blender-mcp [S467]:
  - Blender add-on runs a socket server; the MCP server relays tool calls from Claude.
  - Tools include `get_scene_info`, `execute_blender_code`, viewport screenshots, and asset search/import (Poly Haven, Sketchfab, Poly Pizza).
  - Setup: `uvx mcp-for-blender setup` or `claude mcp add blender uvx mcp-for-blender`, then `uvx mcp-for-blender install-addon`; check the `MCP for Blender` tab in the `N` sidebar.
  - The PyPI package was renamed from `blender-mcp` to `mcp-for-blender`; the old command still works.
  - Telemetry is opt-in; content collection is off by default.
- Verification loop after import, in Studio:
  - `execute_luau` runs a check like `snippets/mesh-verify-meshpart.luau`: size in studs, anchored, collision fidelity, triangle-heavy parts.
  - `screen_capture` confirms orientation and textures; Claude cannot judge art quality reliably, so keep a human look.
- Division of labor: Claude handles naming, settings, checks, export scripts, and Luau placement code; modeling, UVs, and weight painting stay manual.
## Gotchas
- `execute_blender_code` runs arbitrary Python in Blender; save first and review what runs [S467].
- `execute_luau` and `insert_asset` change the open place; work on a copy and commit place files or use Rojo first [S242].
- Assets found by `search_asset` or blender-mcp asset search carry their own licenses and, on the Creator Store, possible hidden scripts; check license and contents (see 3d-asset-sources-licensing) [S34][S177].
- MCP tool results have size caps; a reply in the Assistant thread reports screenshots hit a 1 MB limit before JPEG encoding shipped [S465].
- Third-party Studio plugins that generate meshes (for example Pic2Mesh) are unvetted; skip unless you audit them [S468][S383].
- Never put Open Cloud keys or tokens in prompts, scripts, MCP configs committed to the repo, or `.blend` files [S399].
- AI-generated content follows Roblox's generative AI terms [S288].
## Sources
S34, S119, S177, S242, S288, S383, S399, S405, S407, S409, S410, S416, S460, S465, S467, S468
