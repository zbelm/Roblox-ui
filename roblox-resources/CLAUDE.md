# Roblox resource library

Purpose: verified links, licenses, and short concept notes for building a Roblox game.

## Start
- Start at docs/INDEX.md; grep sources/sources.csv for S<id>.
- Do not read whole folders. Read INDEX.md, then open one file.
- Citations like [S123] map to the `id` column in sources/sources.csv (url, license, verdict, checked date).

## Conventions
- Luau: `--!strict`, fully typed.
- Comments only for a non-obvious why or an engine quirk; never restate code.
- Check the license (sources.csv `license`, `commercial`, `verdict`) before using any asset or code.
- Never commit secrets: no Open Cloud keys, API tokens, or cookies anywhere in the repo.
- Security material is defensive only: validation, rate limiting, detection. No exploit tooling.
- Snippets in snippets/ are marked "unverified" where not run in Studio; treat them as patterns, not drop-in code.
