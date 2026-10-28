--!strict
-- Last verified: 2026-10-28
-- Status: unverified. Pure Luau plus DateTime.fromUniversalTime / UnixTimestamp,
-- checked against the Roblox/creator-docs reference; not run in Studio.
-- Concept: one-off and recurring event windows in UTC that every server evaluates
-- identically without shared state.

export type Window = {
	id: string,
	startsAt: number,
	endsAt: number,
}

export type Recurring = {
	id: string,
	anchor: number,
	period: number,
	duration: number,
}

local Schedule = {}

function Schedule.utc(year: number, month: number, day: number, hour: number?, minute: number?): number
	return DateTime.fromUniversalTime(year, month, day, hour or 0, minute or 0, 0).UnixTimestamp
end

function Schedule.isActive(window: Window, now: number): boolean
	return now >= window.startsAt and now < window.endsAt
end

function Schedule.secondsUntilStart(window: Window, now: number): number
	return math.max(0, window.startsAt - now)
end

function Schedule.secondsLeft(window: Window, now: number): number
	return math.max(0, window.endsAt - now)
end

-- Returns the occurrence that is running now, or the next one if none is running.
function Schedule.occurrence(rule: Recurring, now: number): Window
	assert(rule.period > 0 and rule.duration > 0 and rule.duration <= rule.period, "invalid recurring rule")
	local index = math.floor((now - rule.anchor) / rule.period)
	local startsAt = rule.anchor + index * rule.period
	if now >= startsAt + rule.duration then
		startsAt += rule.period
	end
	return {
		id = `{rule.id}:{startsAt}`,
		startsAt = startsAt,
		endsAt = startsAt + rule.duration,
	}
end

function Schedule.formatCountdown(seconds: number): string
	local s = math.max(0, math.floor(seconds))
	local days = s // 86400
	local hours = (s % 86400) // 3600
	local minutes = (s % 3600) // 60
	local secs = s % 60
	if days > 0 then
		return string.format("%dd %02dh %02dm", days, hours, minutes)
	end
	return string.format("%02d:%02d:%02d", hours, minutes, secs)
end

return Schedule

--[[ Example
local HALLOWEEN: Schedule.Window = {
	id = "halloween-2026",
	startsAt = Schedule.utc(2026, 10, 30, 17),
	endsAt = Schedule.utc(2026, 11, 6, 17),
}
local WEEKEND_BOSS: Schedule.Recurring = {
	id = "weekend-boss",
	anchor = Schedule.utc(2026, 1, 3, 18), -- a Saturday
	period = 7 * 86400,
	duration = 2 * 3600,
}
]]
