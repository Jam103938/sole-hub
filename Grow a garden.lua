local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
   Name = "Grow a Garden script",
   Icon = 0,
   LoadingTitle = "Sole hub - open source",
   LoadingSubtitle = "by jaimz",
   Theme = "Default",
   ToggleUIKeybind = "K",
   ConfigurationSaving = {
      Enabled = true,
      FolderName = nil,
      FileName = "Big Hub"
   },
   Discord = {
      Enabled = true,
      Invite = "https://discord.gg/KpWYxEPPkv",
      RememberJoins = true
   },
   KeySystem = false,
   KeySettings = {
      Title = "Untitled",
      Subtitle = "Key System",
      Note = "No method of obtaining the key is provided",
      FileName = "Key",
      SaveKey = true,
      GrabKeyFromSite = false,
      Key = {"Hello"}
   }
})

local Tab = Window:CreateTab("Main Tab", 4483362458)
local Misc = Window:CreateTab("Misc tab", 4483362458)
local Button = Tab:CreateButton({
   Name = "Our discord(thanks for joining)",
   Callback = function()
   setclipboard("https://discord.gg/KpWYxEPPkv")
      game:GetService("StarterGui"):SetCore("SendNotification", {
         Title = "Copied to clipboard",
         Text = "Thanks for joining our discord server",
         Duration = 3
      })
   end,
})
local selectedSeeds = {}

local Dropdown = Tab:CreateDropdown({
   Name = "Seed Selection",
   Options = { 
     "Carrot", "Strawberry", "Blueberry", "Orange Tulip", "Tomato", "Corn", "Daffodil", "Watermelon",
     "Pumpkin", "Apple", "Bamboo", "Coconut", "Cactus", "Dragon Fruit", "Mango", "Grape", "Mushroom",
     "Pepper", "Cacao", "Beanstalk"
   },
   CurrentOption = {"Carrot"},
   MultipleOptions = true,
   Flag = "Dropdown1",
   Callback = function(Options)
      selectedSeeds = Options
   end,
})

local autoBuyEnabled = false

local Toggle = Tab:CreateToggle({
   Name = "Auto Buy Selected Seeds",
   CurrentValue = false,
   Flag = "AutoBuyToggle",
   Callback = function(Value)
      autoBuyEnabled = Value
      if autoBuyEnabled then
         task.spawn(function()
            while autoBuyEnabled do
               for _, seed in pairs(selectedSeeds) do
                  game:GetService("ReplicatedStorage"):WaitForChild("GameEvents"):WaitForChild("BuySeedStock"):FireServer(seed)
               end
               task.wait(.1)
            end
         end)
      end
   end,
})

local selectedGears = {}

local Dropdown = Tab:CreateDropdown({
   Name = "Seed Selection",
   Options = { 
     "Watering Can", "Trowel", "Recall Wrench", "Basic Sprinkler", "Advanced Sprinkler", "Godly Sprinkler", "Lightning Rod", "Master Sprinkler", "Favorite Tool", "Harvest Tool"
   },
   CurrentOption = {"Watering Can"},
   MultipleOptions = true,
   Flag = "Dropdown1",
   Callback = function(Options)
      selectedGears = Options
   end,
})

local autoBuyEnabled = false

local Toggle = Tab:CreateToggle({
   Name = "Auto Buy Selected Gears",
   CurrentValue = false,
   Flag = "AutoBuyToggle",
   Callback = function(Value)
      autoBuyEnabled = Value
      if autoBuyEnabled then
         task.spawn(function()
            while autoBuyEnabled do
               for _, seed in pairs(selectedGears) do
game:GetService("ReplicatedStorage"):WaitForChild("GameEvents"):WaitForChild("BuyGearStock"):FireServer(unpack(args))
               end
               task.wait(.1)
            end
         end)
      end
   end,
})

local selectedEggs = {}

local EggDropdown = Tab:CreateDropdown({
   Name = "Egg Selection",
   Options = {
     "Common Egg", "Uncommon Egg", "Rare Egg", "Legendary Egg",
     "Mythical Egg", "Bug Egg", "Exotic Bug Egg"
   },
   CurrentOption = {},
   MultipleOptions = true,
   Flag = "EggDropdown",
   Callback = function(Options)
      selectedEggs = Options
   end,
})
-- this are the index of every pets
local orderedEggs = {
   "Uncommon Egg",
   "Rare Egg",
   "Common Egg",
   "Legendary Egg",
   "Mythical Egg",
   "Bug Egg",       
   "Exotic Bug Egg" 
}
local autoBuyEggs = false

local EggToggle = Tab:CreateToggle({
   Name = "Auto Buy Selected Eggs",
   CurrentValue = false,
   Flag = "EggAutoBuyToggle",
   Callback = function(Value)
      autoBuyEggs = Value
      if autoBuyEggs then
         task.spawn(function()
            while autoBuyEggs do
               for _, eggName in pairs(selectedEggs) do
                   for index, name in ipairs(orderedEggs) do
                       if eggName == name then
                           game:GetService("ReplicatedStorage")
                               :WaitForChild("GameEvents")
                               :WaitForChild("BuyPetEgg")
                               :FireServer(index)
                           break
                       end
                   end
               end
               task.wait(0.1)
            end
         end)
      end
   end,
})
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ToggleActive = false

local Toggle = Tab:CreateToggle({
	Name = "Auto Honey Machine",
	CurrentValue = false,
	Flag = "Toggle1",
	Callback = function(Value)
		ToggleActive = Value
		if ToggleActive then
			task.spawn(function()
				local LocalPlayer = Players.LocalPlayer
				local Backpack = LocalPlayer:WaitForChild("Backpack")
				local Character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
				local HumanoidRootPart = Character:WaitForChild("HumanoidRootPart")
				local arrowTarget = workspace.Interaction.UpdateItems.HoneyEvent:FindFirstChild("Arrow")
				if not arrowTarget then return end

				local targetPart = arrowTarget:GetChildren()[2]
				if not targetPart then return end

				local lockPosition = targetPart.Position + Vector3.new(2, 0, 0)
				HumanoidRootPart.Anchored = true
				HumanoidRootPart.CFrame = CFrame.new(lockPosition)

				while ToggleActive do
					local equipped = false
					for _, item in ipairs(Backpack:GetChildren()) do
						if item:IsA("Tool") and item:FindFirstChild("Weight") then
							local name = item.Name
							if string.find(name, "Pollinated") and tonumber(item.Weight.Value) >= 10 then
								item.Parent = Character
								equipped = true
								break
							end
						end
					end

					if not equipped then
						for i = 1, 5 do
							if not ToggleActive then break end
							task.wait(1)
						end
						continue
					end

					task.wait(3)

					local args = { "MachineInteract" }
					ReplicatedStorage:WaitForChild("GameEvents"):WaitForChild("HoneyMachineService_RE"):FireServer(unpack(args))

					for i = 1, 182 do
						if not ToggleActive then break end
						task.wait(1)
					end

					if ToggleActive then
						ReplicatedStorage:WaitForChild("GameEvents"):WaitForChild("HoneyMachineService_RE"):FireServer(unpack(args))
					end
				end

				HumanoidRootPart.Anchored = false
			end)
		end
	end,
})
