--!strict
-- Verified in Roblox/creator-docs (2026-10-27): math.isfinite, utf8.len, OnServerEvent, token bucket
-- approach from scripting/security/client-server-boundary. unverified: not run in Studio.
-- Concept: per-player token bucket plus argument checks before any handler runs.

local Players = game:GetService("Players")
export type Check = (value: unknown) -> boolean

local Guard = {}

function Guard.finiteNumber(min: number, max: number): Check
	return function(value)
		return typeof(value) == "number" and math.isfinite(value) and value >= min and value <= max
	end
end

function Guard.boundedString(maxLength: number): Check
	return function(value)
		if typeof(value) ~= "string" or #value > maxLength * 4 then
			return false
		end
		-- utf8.len returns nil for invalid UTF-8, which DataStores reject.
		local length = utf8.len(value)
		return length ~= nil and length <= maxLength
	end
end

function Guard.descendantOf(ancestor: Instance): Check
	return function(value)
		return typeof(value) == "Instance" and value:IsDescendantOf(ancestor)
	end
end

function Guard.connect(remote: RemoteEvent, capacity: number, refillPerSecond: number, checks: { Check }, handler: (Player, ...any) -> ()): RBXScriptConnection
	local buckets: { [Player]: { tokens: number, last: number } } = {}
	Players.PlayerRemoving:Connect(function(player)
		buckets[player] = nil
	end)

	return remote.OnServerEvent:Connect(function(player: Player, ...: any)
		local now = os.clock()
		local bucket = buckets[player] or { tokens = capacity, last = now }
		bucket.tokens = math.min(capacity, bucket.tokens + (now - bucket.last) * refillPerSecond)
		bucket.last = now
		buckets[player] = bucket
		if bucket.tokens < 1 or select("#", ...) ~= #checks then
			return
		end
		bucket.tokens -= 1
		local args = { ... }
		for i, check in checks do
			if not check(args[i]) then
				return
			end
		end
		handler(player, ...)
	end)
end

return Guard
