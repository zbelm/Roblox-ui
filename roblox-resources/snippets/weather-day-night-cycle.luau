--!strict
-- Last verified: 2026-10-28
-- Status: unverified. API names (Workspace:GetServerTimeNow, Lighting.ClockTime,
-- RunService.RenderStepped) checked against the Roblox/creator-docs engine reference;
-- not run in Studio.
-- Concept: a day/night cycle every client computes from synced server time, so no
-- server loop has to replicate ClockTime. Put the module in ReplicatedStorage and
-- call DayNight.runClient() from one LocalScript.

local Lighting = game:GetService("Lighting")
local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")

local DAY_LENGTH_SECONDS = 20 * 60
local DAWN_HOUR = 6
local DUSK_HOUR = 18

local DayNight = {}

function DayNight.clockAt(unixSeconds: number): number
	return (unixSeconds % DAY_LENGTH_SECONDS) / DAY_LENGTH_SECONDS * 24
end

function DayNight.now(): number
	return DayNight.clockAt(Workspace:GetServerTimeNow())
end

function DayNight.isNight(clock: number?): boolean
	local hour = clock or DayNight.now()
	return hour < DAWN_HOUR or hour >= DUSK_HOUR
end

function DayNight.secondsUntilHour(targetHour: number): number
	local hoursAhead = (targetHour - DayNight.now()) % 24
	return hoursAhead / 24 * DAY_LENGTH_SECONDS
end

function DayNight.runClient(): RBXScriptConnection
	assert(RunService:IsClient(), "DayNight.runClient must run on the client")
	return RunService.RenderStepped:Connect(function()
		Lighting.ClockTime = DayNight.now()
	end)
end

return DayNight
