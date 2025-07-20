-- WARNING: This is NOT for use — it's a developer simulation for anti-exploit analysis only.

local Players = game:GetService("Players")
local player = Players.LocalPlayer
local char = player.Character or player.CharacterAdded:Wait()
local hrp = char:WaitForChild("HumanoidRootPart")
local gui = player:WaitForChild("PlayerGui")

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

-- Loot vases by teleporting above their world pivot and firing proximity prompt
-- Adds a 0.5s wait before prompt and 1.5s after to allow pickup
local function lootVases()
	local teleports = 0
	for _, vase in pairs(workspace:WaitForChild("Vases"):GetChildren()) do
		local prompt = vase:FindFirstChildWhichIsA("ProximityPrompt", true)
		if prompt and prompt.Enabled then
			hrp.CFrame = vase:GetPivot() * CFrame.new(0, 3, 0) -- hover above world pivot
			task.wait(0.5)  -- wait before firing prompt
			fireproximityprompt(prompt)
			task.wait(1.5)  -- wait longer to pick up drops from vase
			teleports += 1
			if teleports >= 8 then break end
		end
	end
end

-- Get all dropped Rocks and Irons in workspace.DroppedMaterials
local function getDroppedItems()
    local droppedFolder = workspace:FindFirstChild("DroppedMaterials")
    if not droppedFolder then return {} end

    local droppedItems = {}
    for _, item in pairs(droppedFolder:GetChildren()) do
        if item.Name == "Rock" or item.Name == "Iron" then
            table.insert(droppedItems, item)
        end
    end
    return droppedItems
end

-- Teleport above dropped Rocks and Irons to loot them with a delay
local function lootDroppedMaterials()
    local droppedItems = getDroppedItems()
    for _, item in pairs(droppedItems) do
        local posCFrame = nil
        if item.PrimaryPart then
            posCFrame = item.PrimaryPart.CFrame
        elseif item:IsA("BasePart") then
            posCFrame = item.CFrame
        end
        if posCFrame then
            hrp.CFrame = posCFrame * CFrame.new(0, 3, 0)
            task.wait(0.8)  -- wait to pick up item
        end
    end
end

-- Drop items from FrameBackpack1 through 5 in GUI
local function dropAll()
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
	lootDroppedMaterials()

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
