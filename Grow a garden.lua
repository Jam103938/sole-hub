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
local LocalPlayer = Players.LocalPlayer

local function findEggOnMyFarm()
	local farmFolder = workspace:FindFirstChild("Farm")
	if not farmFolder then return end

	for _, farm in ipairs(farmFolder:GetChildren()) do
		local important = farm:FindFirstChild("Important")
		local data = important and important:FindFirstChild("Data")
		if not data then continue end

		local owner = data:FindFirstChild("Owner")
		local farmNumber = tonumber((data:FindFirstChild("Farm_Number") or {}).Value or 0)

		if owner and owner.Value == LocalPlayer.Name and farmNumber >= 1 and farmNumber <= 6 then
			local objects = important:FindFirstChild("Objects_Physical")
			if objects then
				for _, obj in ipairs(objects:GetChildren()) do
					if obj:IsA("Model") then
						return obj
					end
				end
			end
		end
	end
end

local Toggle = Tab:CreateToggle({ 
	Name = "Hatch Egg on Head",
	CurrentValue = false,
	Flag = "HatchOnHead",
	Callback = function(Value)
		if Value then
			local eggModel = findEggOnMyFarm()
			if eggModel then
				for _, part in ipairs(eggModel:GetDescendants()) do
					if part:IsA("BasePart") then
						part.CanCollide = false
					end
				end

				local head = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Head")
				if head then
					if not eggModel.PrimaryPart then
						eggModel.PrimaryPart = eggModel:FindFirstChildWhichIsA("BasePart")
					end
					if eggModel.PrimaryPart then
						eggModel:SetPrimaryPartCFrame(head.CFrame)
					end
				end

				local args = {
					"HatchPet",
					eggModel
				}
				ReplicatedStorage:WaitForChild("GameEvents"):WaitForChild("PetEggService"):FireServer(unpack(args))
			end
		end
	end
})



local Button = Misc:CreateButton({
	Name = "Toggle Seed Shop(press again to close)",
	Callback = function()
		local seedgui = game:GetService("Players").LocalPlayer:WaitForChild("PlayerGui"):FindFirstChild("Seed_Shop")
		if seedgui then
			seedgui.Enabled = not seedgui.Enabled
		end
	end,
})

local Button = Misc:CreateButton({
	Name = "Toggle Gear Shop(press again to close)",
	Callback = function()
		local geargui = game:GetService("Players").LocalPlayer:WaitForChild("PlayerGui"):FindFirstChild("Gear_Shop").Enabled
		if geargui then
			geargui.Enabled = not geargui.Enabled
		end
	end,
})
