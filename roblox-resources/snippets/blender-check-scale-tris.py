# Verified against docs.blender.org API (current) and Roblox art/modeling/specifications (2026-10-27):
# Context.evaluated_depsgraph_get, Object.evaluated_get, Object.to_mesh/to_mesh_clear,
# Mesh.calc_loop_triangles, Mesh.loop_triangles, Object.dimensions, 20,000 triangle limit.
# Tested 2026-10-28 with the bpy 5.2.3 PyPI module on a synthetic scene; not tested in the Blender app.
# Run: blender -b file.blend -P blender-check-scale-tris.py --python-exit-code 1
# Concept: report evaluated triangle count, size, and unapplied transforms per mesh; fail on problems.
import sys

import bpy

TRI_LIMIT = 20_000  # Roblox per-mesh limit
MAX_STUDS = 2048.0  # unverified: sanity bound only, not a Roblox limit


def check() -> list[str]:
    problems: list[str] = []
    depsgraph = bpy.context.evaluated_depsgraph_get()
    for obj in bpy.context.scene.objects:
        if obj.type != "MESH":
            continue
        evaluated = obj.evaluated_get(depsgraph)
        mesh = evaluated.to_mesh()
        mesh.calc_loop_triangles()
        tris = len(mesh.loop_triangles)
        evaluated.to_mesh_clear()

        x, y, z = obj.dimensions
        print(f"{obj.name}: {tris} tris, {x:.2f} x {y:.2f} x {z:.2f}")
        if tris > TRI_LIMIT:
            problems.append(f"{obj.name}: {tris} triangles > {TRI_LIMIT}")
        if any(abs(s - 1.0) > 1e-4 for s in obj.scale):
            problems.append(f"{obj.name}: scale not applied {tuple(obj.scale)}")
        if any(abs(r) > 1e-4 for r in obj.rotation_euler):
            problems.append(f"{obj.name}: rotation not applied")
        if max(x, y, z) > MAX_STUDS or min(x, y, z) <= 0.0:
            problems.append(f"{obj.name}: suspicious size, check scene units")
    return problems


issues = check()
for line in issues:
    print("PROBLEM", line)
if issues:
    sys.exit(1)
