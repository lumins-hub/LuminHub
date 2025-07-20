-- WARNING: This is NOT for use — it's a developer simulation for anti-exploit analysis only.

local Players = game:GetService("Players")
local player = Players.LocalPlayer
local char = player.Character or player.CharacterAdded:Wait()
local hrp = char:WaitForChild("HumanoidRootPart")
local gui = player:WaitForChild("PlayerGui")
local RunService = game:GetService("RunService")

local Drop = gui:WaitForChild("Backpack"):WaitForChild("Frame"):WaitForChild("Frame"):WaitForChild("Frame2"):WaitForChild("Script"):WaitForChild("Drop")

local targetPos = Vector3.new(-35, 140, -397)

-- Damage handling
local damaged = false
char:WaitForChild("Humanoid").HealthChanged:Connect(function(health)
	if health < 100 then
		damaged = true
	end
end)

-- Function to teleport
local function teleport(pos)
	hrp.CFrame = CFrame.new(pos)
end

-- Loop through vases with active prompts
local function lootVases()
	local teleports = 0
	for _, vase in pairs(workspace:WaitForChild("Vases"):GetChildren()) do
		local prompt = vase:FindFirstChildWhichIsA("ProximityPrompt", true)
		if prompt and prompt.Enabled then
			hrp.CFrame = vase.CFrame + Vector3.new(0, 3, 0) -- hover above it
			task.wait(0.4)
			fireproximityprompt(prompt)
			teleports += 1
			if teleports >= 8 then break end
		end
	end
end

-- Grab amount from frames and fire Drop
local function dropAll()
    -- Only drop from FrameBackpack1 through 5
    for i = 1, 5 do
        local path = gui.Backpack.Frame.Frame:FindFirstChild("FrameBackpack"..i)
        if path and path:FindFirstChild("CurrentItem") and path.CurrentItem:FindFirstChild("Amount") then
            local amt = path.CurrentItem.Amount.Value
            Drop:FireServer(amt)
        end
    end
end

-- Main loop
while true do
	lootVases()

	-- If damaged, bail to safe spot
	if damaged then
		teleport(targetPos)
		dropAll()
		player:Kick("Resetting...") -- simulate reset
		break
	else
		teleport(targetPos)
		dropAll()
		task.wait(5) -- wait before looping again
	end
end
