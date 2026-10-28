--!strict
-- Last verified: 2026-10-28
-- Status: unverified. API names (MessagingService:SubscribeAsync / PublishAsync,
-- message.Data / message.Sent) and limits (1 kB, best-effort delivery) checked against
-- the Roblox/creator-docs engine reference; not run in Studio. Server only.
-- Concept: broadcast "event starting" to every server, validate the payload, and
-- ignore stale or duplicate messages.

local HttpService = game:GetService("HttpService")
local MessagingService = game:GetService("MessagingService")

local TOPIC = "LiveEvent"
local MAX_AGE_SECONDS = 60

export type Announcement = {
	id: string,
	kind: "start" | "stop",
	eventId: string,
}

local Announcer = {}

local seen: { [string]: boolean } = {}

local function decode(data: any): Announcement?
	if typeof(data) ~= "table" then
		return nil
	end
	local id, kind, eventId = data.id, data.kind, data.eventId
	if typeof(id) ~= "string" or typeof(eventId) ~= "string" then
		return nil
	end
	if kind ~= "start" and kind ~= "stop" then
		return nil
	end
	return { id = id, kind = kind, eventId = eventId }
end

function Announcer.listen(onAnnouncement: (Announcement) -> ()): RBXScriptConnection?
	local ok, connection = pcall(function(): RBXScriptConnection
		return MessagingService:SubscribeAsync(TOPIC, function(message: { Data: any, Sent: number })
			if os.time() - message.Sent > MAX_AGE_SECONDS then
				return
			end
			local announcement = decode(message.Data)
			if not announcement or seen[announcement.id] then
				return
			end
			seen[announcement.id] = true
			onAnnouncement(announcement)
		end)
	end)
	if not ok then
		warn("SubscribeAsync failed:", connection)
		return nil
	end
	return connection
end

function Announcer.broadcast(kind: "start" | "stop", eventId: string): boolean
	local payload: Announcement = {
		id = HttpService:GenerateGUID(false),
		kind = kind,
		eventId = eventId,
	}
	local ok, err = pcall(function()
		MessagingService:PublishAsync(TOPIC, payload)
	end)
	if not ok then
		warn("PublishAsync failed:", err)
	end
	return ok
end

return Announcer
