local RepStorage = game:GetService("ReplicatedStorage")
local TS = game:GetService("TweenService")

local TweenModule = RepStorage:WaitForChild("TweenService")

local TweenRemote = TweenModule:WaitForChild("Tween")
local TweenModelRemote = TweenModule:WaitForChild("TweenModel")

local ModelTweens = {}

local function DeserializeTweenInfo(Info)
	return TweenInfo.new(
		Info.Time,
		Info.EasingStyle,
		Info.EasingDirection,
		Info.RepeatCount,
		Info.Reverses,
		Info.DelayTime
	)
end

TweenRemote.OnClientEvent:Connect(function(Object, TweenOptions, Goals)
	TS:Create(
		Object,
		DeserializeTweenInfo(TweenOptions),
		Goals
	):Play()
end)

TweenModelRemote.OnClientEvent:Connect(function(Model, TweenOptions, GoalCF)
	-- Stops currently playing tweens on the model
	if ModelTweens[Model] then
		ModelTweens[Model].Stop()
	end
	
	local CFValue = Instance.new("CFrameValue")
	CFValue.Value = Model:GetPivot()
	
	local CFConn = CFValue:GetPropertyChangedSignal("Value"):Connect(function()
		Model:PivotTo(CFValue.Value)
	end)
	
	local TweenAnim = TS:Create(
		CFValue,
		DeserializeTweenInfo(TweenOptions),
		{ Value = GoalCF }
	)
	
	-- Allows animation to be stopped when a new one is played
	ModelTweens[Model] = {
		Stop = function()
			CFConn:Disconnect()
			TweenAnim:Destroy()
			CFValue:Destroy()
		end,
	}
	
	task.spawn(function()
		wait(TweenOptions.Time)
		
		if not CFConn  then return end
		if not CFValue then return end
		
		CFConn:Disconnect()
		CFValue:Destroy()
	end)
	
	TweenAnim:Play()
end)