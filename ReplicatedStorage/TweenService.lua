local TweenService = {}

-- Vars
local TS = game:GetService("TweenService")
local TweenRemote = script:WaitForChild("Tween")
local TweenModelRemote = script:WaitForChild("TweenModel")

-- Funcs
local function SerializeTweenInfo(Info)
	return {
		Time = Info.Time,
		EasingStyle = Info.EasingStyle,
		EasingDirection = Info.EasingDirection,
		DelayTime = Info.DelayTime,
		RepeatCount = Info.RepeatCount,
		Reverses = Info.Reverses
	}
end

-- Mod funcs
function TweenService:Tween(Object, TweenOptions, Goals)
	TweenRemote:FireAllClients(Object, SerializeTweenInfo(TweenOptions), Goals)
end

function TweenService:TweenProperty(Object, TweenOptions, Property, Goal)
	self:Tween(Object, SerializeTweenInfo(TweenOptions), { [Property] = Goal })
end

function TweenService:TweenModelCFrame(Model, TweenOptions, GoalCF)
	TweenModelRemote:FireAllClients(Model, SerializeTweenInfo(TweenOptions), GoalCF)
end

return TweenService
