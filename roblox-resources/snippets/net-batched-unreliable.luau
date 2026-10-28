--!strict
-- Verified in Roblox/creator-docs (2026-10-27): UnreliableRemoteEvent:FireAllClients, 1000-byte payload
-- cap, buffer.create/writeu16/writef32/readu16/readf32/len, RunService.Heartbeat.
-- unverified: not run in Studio; per-message overhead inside the 1000 bytes not measured.
-- Concept: pack per-frame position updates into buffers and send them unreliably.

local RunService = game:GetService("RunService")

local RECORD_BYTES = 14
-- 840 bytes leaves headroom under the 1000-byte cap; encoding overhead was not measured.
local MAX_RECORDS = 60

local Batch = {}

function Batch.startServer(remote: UnreliableRemoteEvent, collect: () -> { [number]: Vector3 }): RBXScriptConnection
	return RunService.Heartbeat:Connect(function()
		local ids: { number } = {}
		local positions = collect()
		for id in positions do
			table.insert(ids, id)
		end
		for first = 1, #ids, MAX_RECORDS do
			local last = math.min(first + MAX_RECORDS - 1, #ids)
			local packet = buffer.create((last - first + 1) * RECORD_BYTES)
			local offset = 0
			for i = first, last do
				local id = ids[i]
				local p = positions[id]
				buffer.writeu16(packet, offset, id)
				buffer.writef32(packet, offset + 2, p.X)
				buffer.writef32(packet, offset + 6, p.Y)
				buffer.writef32(packet, offset + 10, p.Z)
				offset += RECORD_BYTES
			end
			remote:FireAllClients(packet)
		end
	end)
end

function Batch.listenClient(remote: UnreliableRemoteEvent, apply: (id: number, position: Vector3) -> ()): RBXScriptConnection
	return remote.OnClientEvent:Connect(function(packet: unknown)
		if typeof(packet) ~= "buffer" or buffer.len(packet) % RECORD_BYTES ~= 0 then
			return
		end
		for offset = 0, buffer.len(packet) - RECORD_BYTES, RECORD_BYTES do
			local id = buffer.readu16(packet, offset)
			local position = Vector3.new(
				buffer.readf32(packet, offset + 2),
				buffer.readf32(packet, offset + 6),
				buffer.readf32(packet, offset + 10)
			)
			apply(id, position)
		end
	end)
end

return Batch
