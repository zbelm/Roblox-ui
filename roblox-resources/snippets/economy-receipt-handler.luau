--!strict
-- Last verified: 2026-10-28
-- Status: unverified. API names (MarketplaceService:BindReceiptHandler,
-- Enum.ReceiptType.DeveloperProduct, Enum.ReceiptDecision, receipt fields PurchaseId /
-- PlayerId / ProductId) checked against the Roblox/creator-docs engine reference; not
-- run in Studio. The PlayerData interface stands in for your session-locked data layer
-- (for example ProfileStore) and must save before saveAsync returns true.
-- Concept: idempotent developer-product grants keyed by PurchaseId.

local MarketplaceService = game:GetService("MarketplaceService")
local Players = game:GetService("Players")

export type Profile = {
	coins: number,
	purchaseIds: { string },
}

export type PlayerData = {
	get: (player: Player) -> Profile?,
	saveAsync: (player: Player) -> boolean,
}

type Grant = (profile: Profile) -> ()

local MAX_REMEMBERED_PURCHASES = 100

local Receipts = {}

local function alreadyGranted(profile: Profile, purchaseId: string): boolean
	return table.find(profile.purchaseIds, purchaseId) ~= nil
end

local function remember(profile: Profile, purchaseId: string)
	table.insert(profile.purchaseIds, purchaseId)
	while #profile.purchaseIds > MAX_REMEMBERED_PURCHASES do
		table.remove(profile.purchaseIds, 1)
	end
end

function Receipts.coinPack(amount: number): Grant
	return function(profile: Profile)
		profile.coins += amount
	end
end

function Receipts.bind(data: PlayerData, products: { [number]: Grant }): { RBXScriptConnection }
	local productIds: { number } = {}
	for productId in products do
		table.insert(productIds, productId)
	end

	local function handle(receipt: { [string]: any }): Enum.ReceiptDecision
		local player = Players:GetPlayerByUserId(receipt.PlayerId)
		local purchaseId = receipt.PurchaseId
		local grant = products[receipt.ProductId]
		if not player or typeof(purchaseId) ~= "string" or not grant then
			return Enum.ReceiptDecision.NotProcessedYet
		end

		-- No profile means the session lock is held elsewhere or still loading; Roblox redelivers later.
		local profile = data.get(player)
		if not profile then
			return Enum.ReceiptDecision.NotProcessedYet
		end

		if not alreadyGranted(profile, purchaseId) then
			grant(profile)
			remember(profile, purchaseId)
		end

		-- Acknowledge only after the grant and its PurchaseId are durably saved.
		if data.saveAsync(player) then
			return Enum.ReceiptDecision.Processed
		end
		return Enum.ReceiptDecision.NotProcessedYet
	end

	local connection = MarketplaceService:BindReceiptHandler(Enum.ReceiptType.DeveloperProduct, handle, productIds)
	return { connection }
end

return Receipts

--[[ Example (server Script)
local Receipts = require(path.to.Receipts)
Receipts.bind(PlayerData, {
	[123456789] = Receipts.coinPack(500),
	[987654321] = Receipts.coinPack(1200),
})
]]
