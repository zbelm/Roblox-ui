--!strict
-- Last verified: 2026-10-28
-- Status: unverified. Pure Luau plus RemoteFunction.OnServerInvoke and os.clock; not run
-- in Studio. Profile extends the shape used in economy-receipt-handler.luau.
-- Concept: one server module owns every currency change; the shop remote accepts only
-- an item id, prices live on the server, and requests are rate-limited per player.

local Players = game:GetService("Players")

export type Profile = {
	coins: number,
	purchaseIds: { string },
	owned: { [string]: boolean },
}

export type PlayerData = {
	get: (player: Player) -> Profile?,
}

export type ShopItem = { price: number, unique: boolean? }

local MAX_COINS = 1e12
local REQUESTS_PER_WINDOW = 5
local WINDOW_SECONDS = 2
local AUDIT_THRESHOLD = 100_000

local Ledger = {}

local function isWholeAmount(n: number): boolean
	return n > 0 and n <= MAX_COINS and math.floor(n) == n
end

local function audit(player: Player, reason: string, delta: number, balance: number)
	if math.abs(delta) >= AUDIT_THRESHOLD then
		print(`[ledger] {player.UserId} {reason} {delta} -> {balance}`)
	end
end

function Ledger.award(player: Player, profile: Profile, amount: number, reason: string): boolean
	if not isWholeAmount(amount) then
		return false
	end
	profile.coins = math.min(profile.coins + amount, MAX_COINS)
	player:SetAttribute("Coins", profile.coins)
	audit(player, reason, amount, profile.coins)
	return true
end

function Ledger.spend(player: Player, profile: Profile, amount: number, reason: string): boolean
	if not isWholeAmount(amount) or profile.coins < amount then
		return false
	end
	profile.coins -= amount
	player:SetAttribute("Coins", profile.coins)
	audit(player, reason, -amount, profile.coins)
	return true
end

local function rateLimiter(): (Player) -> boolean
	local hits: { [Player]: { count: number, windowStart: number } } = {}
	Players.PlayerRemoving:Connect(function(player: Player)
		hits[player] = nil
	end)
	return function(player: Player): boolean
		local now = os.clock()
		local entry = hits[player]
		if not entry or now - entry.windowStart >= WINDOW_SECONDS then
			hits[player] = { count = 1, windowStart = now }
			return true
		end
		entry.count += 1
		return entry.count <= REQUESTS_PER_WINDOW
	end
end

function Ledger.bindShop(remote: RemoteFunction, data: PlayerData, catalog: { [string]: ShopItem })
	local allow = rateLimiter()

	remote.OnServerInvoke = function(player: Player, itemId: unknown): boolean
		if not allow(player) or typeof(itemId) ~= "string" or #itemId > 64 then
			return false
		end
		local item = catalog[itemId]
		local profile = data.get(player)
		if not item or not profile then
			return false
		end
		if item.unique and profile.owned[itemId] then
			return false
		end
		if not Ledger.spend(player, profile, item.price, `buy:{itemId}`) then
			return false
		end
		profile.owned[itemId] = true
		return true
	end
end

return Ledger
