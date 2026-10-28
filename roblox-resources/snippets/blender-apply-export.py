# Verified against docs.blender.org API (current) bpy.ops.export_scene.fbx and object.transform_apply,
# and Roblox art/modeling/export-requirements + art/blender (2026-10-27) for the option values.
# unverified: axis_forward. Roblox docs say "Z Forward"; the Blender manual says Y-up targets
# commonly use "-Z Forward". Import a test asset and flip FORWARD if it faces backwards.
# Tested 2026-10-28 with the bpy 5.2.3 PyPI module (FBX files written); not imported into Studio.
# Run: blender -b file.blend -P blender-apply-export.py --python-exit-code 1 -- out_dir
# Concept: apply rotation and scale on selected meshes (all if none selected), export each as its own FBX.
import os
import sys

import bpy

FORWARD = "Z"
argv = sys.argv[sys.argv.index("--") + 1:] if "--" in sys.argv else []
out_dir = os.path.abspath(argv[0] if argv else "export")
os.makedirs(out_dir, exist_ok=True)

meshes = [o for o in bpy.context.scene.objects if o.type == "MESH" and o.select_get()]
if not meshes:
    meshes = [o for o in bpy.context.scene.objects if o.type == "MESH"]

for obj in meshes:
    if obj.data.users > 1:
        obj.data = obj.data.copy()  # transform_apply fails on shared mesh data

bpy.ops.object.select_all(action="DESELECT")
for obj in meshes:
    obj.select_set(True)
bpy.context.view_layer.objects.active = meshes[0]
bpy.ops.object.transform_apply(location=False, rotation=True, scale=True)

for obj in meshes:
    bpy.ops.object.select_all(action="DESELECT")
    obj.select_set(True)
    path = os.path.join(out_dir, f"{obj.name}.fbx")
    bpy.ops.export_scene.fbx(
        filepath=path,
        use_selection=True,
        apply_scale_options="FBX_SCALE_UNITS",
        axis_forward=FORWARD,
        axis_up="Y",
        use_mesh_modifiers=True,
        add_leaf_bones=False,
        bake_anim=False,
        path_mode="COPY",
        embed_textures=True,
    )
    print("exported", path)
