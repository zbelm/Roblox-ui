--!strict
-- Verified in Roblox/creator-docs (2026-10-27): TriangleMeshPart.MeshSize (read-only source size),
-- MeshPart.MeshId, CollisionFidelity enum, PVInstance:PivotTo, small anchored props
-- on Box (performance-optimization/improve). unverified: not run in Studio.
-- Concept: place an imported MeshPart at a target pivot and report scale, collision, and anchoring issues.
-- Run in Edit mode (command bar or the Studio MCP execute_luau tool).

export type Expect = {
	sizeStuds: Vector3?, -- intended size from Blender; nil skips the size check
	tolerance: number?, -- studs
	smallPropStuds: number?, -- unverified: default 4 is a judgment call, not a Roblox number
}

local MeshVerify = {}

function MeshVerify.place(part: MeshPart, pivot: CFrame)
	part:PivotTo(pivot)
	part.Anchored = true
end

function MeshVerify.check(part: MeshPart, expect: Expect): { string }
	local issues: { string } = {}
	local tolerance = expect.tolerance or 0.05

	if part.MeshId == "" then
		table.insert(issues, "no mesh asset")
	end

	local meshSize = part.MeshSize
	local scale = part.Size / meshSize
	if math.abs(scale.X - 1) > 0.01 or math.abs(scale.Y - 1) > 0.01 or math.abs(scale.Z - 1) > 0.01 then
		table.insert(issues, `resized in Studio by {scale}; fix scale in Blender instead`)
	end

	if expect.sizeStuds then
		local diff = part.Size - expect.sizeStuds
		if diff.Magnitude > tolerance then
			table.insert(issues, `size {part.Size} differs from expected {expect.sizeStuds}; check units and FBX Unit Scale`)
		end
	end

	local largest = math.max(part.Size.X, part.Size.Y, part.Size.Z)
	local smallProp = expect.smallPropStuds or 4
	if largest < smallProp and part.Anchored and part.CollisionFidelity ~= Enum.CollisionFidelity.Box then
		table.insert(issues, "small anchored prop: consider CollisionFidelity Box")
	end
	if part.CollisionFidelity == Enum.CollisionFidelity.PreciseConvexDecomposition then
		table.insert(issues, "PreciseConvexDecomposition is the most expensive collision option")
	end

	if not part.Anchored then
		table.insert(issues, "not anchored")
	end
	return issues
end

return MeshVerify
