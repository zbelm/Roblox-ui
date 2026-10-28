--!strict
-- Pure Luau, no engine APIs. unverified: not run in Studio. Concept: ordered schema migrations + defaults.

export type DataV3 = {
	version: number,
	coins: number,
	inventory: { [string]: number },
	settings: { music: boolean },
}

local CURRENT_VERSION = 3

local TEMPLATE: DataV3 = {
	version = CURRENT_VERSION,
	coins = 0,
	inventory = {},
	settings = { music = true },
}

local migrations: { [number]: (data: { [string]: any }) -> () } = {
	[1] = function(data)
		data.coins = data.gold or 0
		data.gold = nil
	end,
	[2] = function(data)
		local inventory: { [string]: number } = {}
		for _, itemId in data.items or {} do
			inventory[itemId] = (inventory[itemId] or 0) + 1
		end
		data.inventory = inventory
		data.items = nil
	end,
}

local function fillDefaults(data: { [string]: any }, template: { [string]: any })
	for key, value in template do
		if data[key] == nil then
			data[key] = if type(value) == "table" then table.clone(value) else value
		elseif type(value) == "table" and type(data[key]) == "table" then
			fillDefaults(data[key], value)
		end
	end
end

local function migrate(raw: { [string]: any }?): (DataV3?, string?)
	local data: { [string]: any } = raw or { version = CURRENT_VERSION }
	local version = data.version or 1
	if version > CURRENT_VERSION then
		return nil, "data is newer than this server; refusing to load"
	end
	while version < CURRENT_VERSION do
		migrations[version](data)
		version += 1
	end
	data.version = CURRENT_VERSION
	fillDefaults(data, TEMPLATE)
	return data :: any, nil
end

return migrate
