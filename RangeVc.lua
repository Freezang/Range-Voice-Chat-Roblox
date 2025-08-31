local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

local CLOSE = 5
local FAR = 100
local UPDATE_RATE = 0.1

local function getMicInput(player)
	if player and player:FindFirstChild("MicInput") then
		return player.MicInput
	end
	return nil
end

local function updateMicVolume(player, distance)
	local micInput = getMicInput(player)
	if not micInput then return end

	local volume
	if distance <= CLOSE then
		volume = 1
	elseif distance >= FAR then
		volume = 0
	else
		volume = math.clamp(1 - (distance - CLOSE) / (FAR - CLOSE), 0, 1)
	end

	pcall(function()
		micInput.Volume = volume
	end)
end

while task.wait(UPDATE_RATE) do
	if not LocalPlayer or not LocalPlayer.Character or not LocalPlayer.Character.PrimaryPart then
		continue
	end

	local myPos = LocalPlayer.Character.PrimaryPart.Position

	for _, player in ipairs(Players:GetPlayers()) do
		if player ~= LocalPlayer and player.Character and player.Character.PrimaryPart then
			local distance = (player.Character.PrimaryPart.Position - myPos).Magnitude
			updateMicVolume(player, distance)
		end
	end
end
