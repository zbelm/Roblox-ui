--!strict
-- Last verified: 2026-10-28
-- Status: unverified. API names (ConfigService:GetConfigAsync, ConfigSnapshot:GetValue,
-- ConfigSnapshot.UpdateAvailable, ConfigSnapshot:Refresh,
-- ConfigSnapshot:GetValueChangedSignal) taken from https://create.roblox.com/docs/production/configs;
-- not run in Studio. Server Script only: ConfigService errors on the client.
-- Concept: read an event flag and window from live configs, fall back to code
-- defaults, and mirror the result to a replicated attribute for clients.

local ConfigService = game:GetService("ConfigService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local ENABLED_KEY = "halloween_enabled"
local STARTS_KEY = "halloween_starts_at"
local ENDS_KEY = "halloween_ends_at"

type EventState = { enabled: boolean, startsAt: number, endsAt: number }

local DEFAULTS: EventState = { enabled = false, startsAt = 0, endsAt = 0 }

local function readBoolean(snapshot: ConfigSnapshot, key: string, fallback: boolean): boolean
	local value = snapshot:GetValue(key)
	return if typeof(value) == "boolean" then value else fallback
end

local function readNumber(snapshot: ConfigSnapshot, key: string, fallback: number): number
	local value = snapshot:GetValue(key)
	return if typeof(value) == "number" then value else fallback
end

local function read(snapshot: ConfigSnapshot): EventState
	return {
		enabled = readBoolean(snapshot, ENABLED_KEY, DEFAULTS.enabled),
		startsAt = readNumber(snapshot, STARTS_KEY, DEFAULTS.startsAt),
		endsAt = readNumber(snapshot, ENDS_KEY, DEFAULTS.endsAt),
	}
end

local function publish(state: EventState)
	ReplicatedStorage:SetAttribute("HalloweenEnabled", state.enabled)
	ReplicatedStorage:SetAttribute("HalloweenStartsAt", state.startsAt)
	ReplicatedStorage:SetAttribute("HalloweenEndsAt", state.endsAt)
end

-- GetConfigAsync throws only if configs have never loaded on this server.
local ok, result = pcall(function(): ConfigSnapshot
	return ConfigService:GetConfigAsync()
end)

if not ok then
	warn("Configs unavailable, using defaults:", result)
	publish(DEFAULTS)
	return
end

local snapshot: ConfigSnapshot = result
publish(read(snapshot))

-- Snapshots are frozen until refreshed; refreshing as soon as an update lands is fine
-- for an event flag but not for values that must stay fixed mid-round.
snapshot.UpdateAvailable:Connect(function()
	snapshot:Refresh()
end)

for _, key in { ENABLED_KEY, STARTS_KEY, ENDS_KEY } do
	snapshot:GetValueChangedSignal(key):Connect(function()
		publish(read(snapshot))
	end)
end
