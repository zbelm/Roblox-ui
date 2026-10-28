--!strict
-- Last verified: 2026-10-28
-- Status: unverified. Property names (Atmosphere.Density/Offset/Haze/Glare/Color/Decay,
-- Clouds.Cover/Density/Color, ParticleEmitter.Rate, Workspace.GlobalWind) checked
-- against the Roblox/creator-docs engine reference; preset values are untuned and the
-- code was not run in Studio.
-- Concept: the server picks a weather state and writes it to an attribute; each client
-- tweens Atmosphere, Clouds, wind, and a rain emitter toward that preset.

local Lighting = game:GetService("Lighting")
local TweenService = game:GetService("TweenService")
local Workspace = game:GetService("Workspace")

export type WeatherName = "Clear" | "Overcast" | "Rain" | "Storm" | "Fog"

export type Preset = {
	atmosphere: { Density: number, Offset: number, Haze: number, Glare: number, Color: Color3, Decay: Color3 },
	clouds: { Cover: number, Density: number, Color: Color3 },
	wind: Vector3,
	rainRate: number,
}

local PRESETS: { [WeatherName]: Preset } = {
	Clear = {
		atmosphere = { Density = 0.3, Offset = 0.25, Haze = 0, Glare = 0, Color = Color3.fromRGB(199, 199, 199), Decay = Color3.fromRGB(106, 112, 125) },
		clouds = { Cover = 0.4, Density = 0.4, Color = Color3.fromRGB(255, 255, 255) },
		wind = Vector3.new(4, 0, 2),
		rainRate = 0,
	},
	Overcast = {
		atmosphere = { Density = 0.4, Offset = 0.2, Haze = 1.5, Glare = 0, Color = Color3.fromRGB(180, 185, 190), Decay = Color3.fromRGB(110, 115, 120) },
		clouds = { Cover = 0.8, Density = 0.6, Color = Color3.fromRGB(200, 200, 205) },
		wind = Vector3.new(8, 0, 4),
		rainRate = 0,
	},
	Rain = {
		atmosphere = { Density = 0.45, Offset = 0.1, Haze = 2.5, Glare = 0, Color = Color3.fromRGB(150, 158, 165), Decay = Color3.fromRGB(90, 95, 105) },
		clouds = { Cover = 0.9, Density = 0.8, Color = Color3.fromRGB(150, 150, 160) },
		wind = Vector3.new(12, 0, 6),
		rainRate = 300,
	},
	Storm = {
		atmosphere = { Density = 0.55, Offset = 0, Haze = 3, Glare = 0, Color = Color3.fromRGB(110, 115, 125), Decay = Color3.fromRGB(60, 65, 75) },
		clouds = { Cover = 1, Density = 1, Color = Color3.fromRGB(90, 90, 100) },
		wind = Vector3.new(25, 0, 12),
		rainRate = 600,
	},
	Fog = {
		atmosphere = { Density = 0.75, Offset = 0.05, Haze = 4, Glare = 0, Color = Color3.fromRGB(205, 210, 215), Decay = Color3.fromRGB(180, 185, 190) },
		clouds = { Cover = 0.7, Density = 0.3, Color = Color3.fromRGB(230, 230, 235) },
		wind = Vector3.new(1, 0, 1),
		rainRate = 0,
	},
}

local ATTRIBUTE = "Weather"

local Weather = {}

function Weather.set(name: WeatherName)
	Workspace:SetAttribute(ATTRIBUTE, name)
end

local function ensure<T>(parent: Instance, className: string): T
	local existing = parent:FindFirstChildOfClass(className)
	if existing then
		return (existing :: any) :: T
	end
	local created = Instance.new(className)
	created.Parent = parent
	return (created :: any) :: T
end

function Weather.runClient(rainEmitter: ParticleEmitter?, blendSeconds: number?): RBXScriptConnection
	local atmosphere: Atmosphere = ensure(Lighting, "Atmosphere")
	-- Clouds only render when parented to Terrain.
	local clouds: Clouds = ensure(Workspace.Terrain, "Clouds")
	local info = TweenInfo.new(blendSeconds or 20, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut)

	local function apply()
		local name = Workspace:GetAttribute(ATTRIBUTE)
		local preset = if typeof(name) == "string" then PRESETS[name :: WeatherName] else nil
		if not preset then
			return
		end
		TweenService:Create(atmosphere, info, preset.atmosphere):Play()
		TweenService:Create(clouds, info, preset.clouds):Play()
		-- GlobalWind is a plain Vector3 property; tweening it on Workspace is untested.
		TweenService:Create(Workspace, info, { GlobalWind = preset.wind }):Play()
		if rainEmitter then
			TweenService:Create(rainEmitter, info, { Rate = preset.rainRate }):Play()
		end
	end

	apply()
	return Workspace:GetAttributeChangedSignal(ATTRIBUTE):Connect(apply)
end

return Weather
