--!strict
-- Verified against Roblox/creator-docs reference (2026-10-27): GlobalDataStore:UpdateAsync
-- (transform returning nil cancels), DataStoreService:GetDataStore, DataModel:BindToClose.
-- unverified: not run in Studio.
-- Concept: one save path with exponential backoff and jitter.

local DataStoreService = game:GetService("DataStoreService")

local MAX_ATTEMPTS = 5
local BASE_DELAY = 1

local store = DataStoreService:GetDataStore("PlayerData")
local random = Random.new()

export type SaveResult = { ok: boolean, err: string? }

local function saveWithRetry<T>(key: string, transform: (old: T?) -> T?): SaveResult
	local lastErr: string? = nil
	for attempt = 1, MAX_ATTEMPTS do
		local ok, err = pcall(function()
			store:UpdateAsync(key, transform)
		end)
		if ok then
			return { ok = true }
		end
		lastErr = tostring(err)
		if attempt < MAX_ATTEMPTS then
			-- Jitter keeps many servers from retrying the same key in lockstep after an outage.
			task.wait(BASE_DELAY * 2 ^ (attempt - 1) + random:NextNumber(0, 0.5))
		end
	end
	return { ok = false, err = lastErr }
end

return saveWithRetry
