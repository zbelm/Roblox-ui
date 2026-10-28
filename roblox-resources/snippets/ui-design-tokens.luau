--!strict
-- Last verified: 2026-10-28
-- Status: unverified. Plain Luau plus Color3.fromHex, Font.fromEnum, UDim, UIPadding,
-- UICorner, checked against the Roblox/creator-docs engine reference; not run in Studio.
-- Concept: a typed design-token module for code-built UI. For Studio-authored UI,
-- prefer StyleSheet tokens (see ui-stylesheet-theme.luau).

export type ColorTokens = {
	surface: Color3,
	surfaceRaised: Color3,
	textPrimary: Color3,
	textMuted: Color3,
	accent: Color3,
	danger: Color3,
	success: Color3,
}

export type SpaceToken = "xs" | "sm" | "md" | "lg" | "xl"
export type RadiusToken = "sm" | "md" | "lg" | "pill"
export type TextToken = "caption" | "body" | "title" | "display"

local color: ColorTokens = table.freeze({
	surface = Color3.fromHex("1B1D24"),
	surfaceRaised = Color3.fromHex("262A35"),
	textPrimary = Color3.fromHex("F2F3F5"),
	textMuted = Color3.fromHex("A3A8B5"),
	accent = Color3.fromHex("FFB547"),
	danger = Color3.fromHex("FF5C5C"),
	success = Color3.fromHex("4CD38A"),
})

-- 4px base grid; values are Offset pixels and get multiplied by the root UIScale.
local space: { [SpaceToken]: number } = table.freeze({
	xs = 4,
	sm = 8,
	md = 12,
	lg = 16,
	xl = 24,
})

local radius: { [RadiusToken]: UDim } = table.freeze({
	sm = UDim.new(0, 4),
	md = UDim.new(0, 8),
	lg = UDim.new(0, 16),
	pill = UDim.new(0.5, 0),
})

local textSize: { [TextToken]: number } = table.freeze({
	caption = 14,
	body = 18,
	title = 24,
	display = 36,
})

local font = table.freeze({
	body = Font.fromEnum(Enum.Font.BuilderSans),
	heading = Font.fromEnum(Enum.Font.BuilderSansBold),
})

local function pad(target: GuiObject, token: SpaceToken): UIPadding
	local amount = UDim.new(0, space[token])
	local padding = Instance.new("UIPadding")
	padding.PaddingTop = amount
	padding.PaddingBottom = amount
	padding.PaddingLeft = amount
	padding.PaddingRight = amount
	padding.Parent = target
	return padding
end

local function round(target: GuiObject, token: RadiusToken): UICorner
	local corner = Instance.new("UICorner")
	corner.CornerRadius = radius[token]
	corner.Parent = target
	return corner
end

local function text(label: TextLabel | TextButton, token: TextToken, muted: boolean?)
	label.TextSize = textSize[token]
	label.FontFace = if token == "title" or token == "display" then font.heading else font.body
	label.TextColor3 = if muted then color.textMuted else color.textPrimary
end

return table.freeze({
	color = color,
	space = space,
	radius = radius,
	textSize = textSize,
	font = font,
	pad = pad,
	round = round,
	text = text,
})
