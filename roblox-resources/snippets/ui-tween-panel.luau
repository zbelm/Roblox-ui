--!strict
-- Last verified: 2026-10-28
-- Status: unverified. API names (TweenService:Create, CanvasGroup.GroupTransparency,
-- Tween.Completed, RBXScriptSignal:Once) checked against the Roblox/creator-docs
-- engine reference; not run or type-checked in Studio.
-- Concept: open/close a menu panel with a slide plus fade, safe to spam-click.

local TweenService = game:GetService("TweenService")

export type Panel = {
	open: () -> (),
	close: () -> (),
	isOpen: () -> boolean,
	destroy: () -> (),
}

local OPEN_INFO = TweenInfo.new(0.25, Enum.EasingStyle.Quint, Enum.EasingDirection.Out)
local CLOSE_INFO = TweenInfo.new(0.18, Enum.EasingStyle.Quad, Enum.EasingDirection.In)

local PanelTween = {}

function PanelTween.new(group: CanvasGroup, shownPosition: UDim2, hiddenPosition: UDim2): Panel
	local current: Tween? = nil
	local opened = false

	local function play(info: TweenInfo, position: UDim2, transparency: number): Tween
		if current then
			current:Cancel()
		end
		local tween = TweenService:Create(group, info, {
			Position = position,
			GroupTransparency = transparency,
		})
		current = tween
		tween:Play()
		return tween
	end

	group.Position = hiddenPosition
	group.GroupTransparency = 1
	group.Visible = false

	local function open()
		opened = true
		group.Visible = true
		play(OPEN_INFO, shownPosition, 0)
	end

	local function close()
		opened = false
		local tween = play(CLOSE_INFO, hiddenPosition, 1)
		tween.Completed:Once(function(state: Enum.PlaybackState)
			-- Completed also fires when an open() cancels this tween; only hide on a finished close.
			if state == Enum.PlaybackState.Completed and not opened then
				group.Visible = false
			end
		end)
	end

	local function destroy()
		if current then
			current:Cancel()
			current = nil
		end
	end

	return {
		open = open,
		close = close,
		isOpen = function(): boolean
			return opened
		end,
		destroy = destroy,
	}
end

return PanelTween
