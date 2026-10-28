--!strict
-- Last verified: 2026-10-28
-- Status: unverified. Follows the pattern in https://create.roblox.com/docs/ui/styling
-- (StyleSheet token attributes, StyleDerive, StyleLink, StyleRule:SetProperties,
-- selectors ".Tag", ":Hover", "::UICorner"); not run in Studio.
-- Concept: global tokens -> light/dark themes -> one design sheet linked to a ScreenGui,
-- with runtime theme switching by repointing a single StyleDerive.

export type ThemeName = "Light" | "Dark"

local Theming = {}

local function sheet(name: string, parent: Instance): StyleSheet
	local s = Instance.new("StyleSheet")
	s.Name = name
	s.Parent = parent
	return s
end

local function derive(child: StyleSheet, from: StyleSheet): StyleDerive
	local d = Instance.new("StyleDerive")
	d.StyleSheet = from
	d.Parent = child
	return d
end

local function rule(parent: StyleSheet, selector: string, properties: { [string]: any }): StyleRule
	local r = Instance.new("StyleRule")
	r.Selector = selector
	r:SetProperties(properties)
	r.Parent = parent
	return r
end

function Theming.mount(screenGui: ScreenGui, container: Instance): (ThemeName) -> ()
	local tokens = sheet("Tokens", container)
	tokens:SetAttribute("Gray50", Color3.fromHex("F5F6F8"))
	tokens:SetAttribute("Gray900", Color3.fromHex("1B1D24"))
	tokens:SetAttribute("Gray800", Color3.fromHex("262A35"))
	tokens:SetAttribute("Amber", Color3.fromHex("FFB547"))
	tokens:SetAttribute("AmberDark", Color3.fromHex("E09A2E"))
	tokens:SetAttribute("RadiusMd", UDim.new(0, 8))
	tokens:SetAttribute("TextBody", 18)

	-- Themes must define the same token names, or swapping leaves properties unset.
	local light = sheet("ThemeLight", container)
	derive(light, tokens)
	light:SetAttribute("Surface", "$Gray50")
	light:SetAttribute("OnSurface", "$Gray900")
	light:SetAttribute("Accent", "$AmberDark")

	local dark = sheet("ThemeDark", container)
	derive(dark, tokens)
	dark:SetAttribute("Surface", "$Gray900")
	dark:SetAttribute("OnSurface", "$Gray50")
	dark:SetAttribute("Accent", "$Amber")

	local design = sheet("Design", container)
	local themeDerive = derive(design, dark)

	rule(design, "Frame.Panel", {
		BackgroundColor3 = "$Surface",
		BorderSizePixel = 0,
	})
	rule(design, "Frame.Panel::UICorner", {
		CornerRadius = "$RadiusMd",
	})
	rule(design, "TextButton.Primary", {
		BackgroundColor3 = "$Accent",
		TextColor3 = "$Gray900",
		TextSize = "$TextBody",
		AutoButtonColor = false,
	})
	rule(design, "TextButton.Primary:Hover", {
		BackgroundTransparency = 0.15,
	})

	local link = Instance.new("StyleLink")
	link.StyleSheet = design
	link.Parent = screenGui

	local themes: { [ThemeName]: StyleSheet } = { Light = light, Dark = dark }
	return function(name: ThemeName)
		themeDerive.StyleSheet = themes[name]
	end
end

return Theming
