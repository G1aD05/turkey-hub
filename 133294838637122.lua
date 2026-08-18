-- Jump to Steal Soccer Players

-- Libraries
local Rayfield = loadstring(game:HttpGet("https://sirius.menu/gen2"))()

-- Services
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

-- Events
local PlaceEvent = ReplicatedStorage.SharedModules.Network.Remotes["Place Slime"]
local OpenLuckyBlockEvent = ReplicatedStorage.SharedModules.Network.Remotes["Open Lucky Block"]
local UpgradeEvent = ReplicatedStorage.SharedModules.Network.Remotes["Upgrade Slime"]
local CollectEvent = ReplicatedStorage.SharedModules.Network.Remotes["Collect Earnings"]
local PickupEvent = ReplicatedStorage.SharedModules.Network.Remotes["Pickup Slime"]
local SellEvent = ReplicatedStorage.SharedModules.Network.Remotes["Sell All Slimes"]

-- Helper Functions
local function contains(table, value)
    for _, item in ipairs(table) do
        if item == value then
            return true
        end
    end

    return false
end

local function getHRP(player)
    if player then
        local character = player.Character

        if character then
            local hrp = character:FindFirstChild("HumanoidRootPart")

            if hrp then
                return hrp
            end
        end
    else
        local character = game:GetService("Players").LocalPlayer.Character

        if character then
            local hrp = character:FindFirstChild("HumanoidRootPart")

            if hrp then
                return hrp
            end
        end
    end
end

local function getBase()
    local player = game:GetService("Players").LocalPlayer
    local plots = workspace.Plots:GetChildren()

    for _, plot in plots do
        if plot.owner.value == player.Name then
            return plot
        end
    end

    return nil
end

-- Rayfield
local window = Rayfield:CreateWindow({
    name = "Jump to Steal Soccer Players GUI",
    subtitle = "Made by Turkey",
    showName = "Turkey Hub"
})

local slimes = workspace.Live.Slimes
local selectedRarity = "Common"

local tab = window:CreateTab({ name = "Home", icon = 93364949241311 })

tab:CreateSection({ name = "Auto Farm" })

local AutoFarmRarityDropdown = tab:CreateDropdown({
    name = "Target Rarity",
    multiSelect = true,
    options = {"Common", "Water", "Rare", "Epic", "Ghost", "Legendary", "67", "Mythic", "Poison", "Secret", "Soccer God", "Exclusive", "OG", "Champions", "Spain"},
    callback = function(selected)
        print("[Turkey Hub] User selected:", table.concat(selected))
        selectedRarity = selected
    end
})


local AutoFarmEnabled = false
local AutoFarmToggle = tab:CreateToggle({
    name = "Auto Farm",
    value = false,
    callback = function(value)
        AutoFarmEnabled = value

        if value then
            print("[Turkey Hub] Auto Farm has started")
            task.spawn(function()
                while AutoFarmEnabled do
                    slimes = workspace.Live.Slimes

                    for _, slime in slimes:GetChildren() do
                        local rarity = slime.Name:gsub(" Lucky Block", "")

                        if not AutoFarmEnabled then break end

                        if contains(selectedRarity, rarity) then
                            print("[Turkey Hub] Found lucky block with a selected rarity:", rarity)
                            local root = slime:FindFirstChild("RootPart")
                            local children = slime:GetChildren()

                            for _, child in children do
                                print(child.Name)
                            end

                            print(root)
                            if root then
                                getHRP().CFrame = slime.RootPart.CFrame
                                task.wait(0.2)
                                fireproximityprompt(slime.RootPart.StealPrompt)
                                task.wait(0.2)
                                getHRP().CFrame = getBase().BasePlayerStats.CFrame * CFrame.new(0, 3, 0)
                                task.wait(0.2)
                            else
                                print("[Turkey Hub] Could not find root part")
                            end
                        end
                    end
                    task.wait(0.01)
                end
                print("[Turkey Hub] Auto Farm has stopped")
            end)
        end
    end,
})

local AutoUpgradeEnabled = false
local AutoUpgradeToggle = tab:CreateToggle({
    name = "Auto Upgrade",
    value = false,
    callback = function(value)
        AutoUpgradeEnabled = value

        if value then
            print("[Turkey Hub] Auto Upgrade has started")
            local stands = getBase().Stands
            task.spawn(function()
                while AutoUpgradeEnabled do
                    for _, stand in stands:GetChildren() do
                        if not AutoUpgradeEnabled then break end

                        UpgradeEvent:FireServer(stand.Name)
                        task.wait(0.01)
                    end
                    task.wait(0.01)
                end
                print("[Turkey Hub] Auto Upgrade has stopped")
            end)
        end
    end,
})

local AutoCollectEnabled = false
local AutoCollectToggle = tab:CreateToggle({
    name = "Auto Collect",
    value = false,
    callback = function(value)
        AutoCollectEnabled = value

        if value then
            print("[Turkey Hub] Auto Collect has started")
            local stands = getBase().Stands
            task.spawn(function()
                while AutoCollectEnabled do
                    for _, stand in stands:GetChildren() do
                        if not AutoCollectEnabled then break end

                        CollectEvent:FireServer(stand.Name)
                        task.wait(0.01)
                    end
                    task.wait(0.01)
                end
                print("[Turkey Hub] Auto Collect has stopped")
            end)
        end
    end,
})

local AutoSellEnabled = false
local AutoSellToggle = tab:CreateToggle({
    name = "Auto Sell",
    value = false,
    callback = function(value)
        AutoSellEnabled = value

        if value then
            print("[Turkey Hub] Auto Sell has started")
            local stands = getBase().Stands
            task.spawn(function()
                while AutoSellEnabled do
                    SellEvent:FireServer()
                    task.wait(1)
                end
                print("[Turkey Hub] Auto Sell has stopped")
            end)
        end
    end,
})

tab:CreateSection({ name = "Auto" })
tab:CreateButton({
    name = "Auto Place Characters",
    callback = function()
        local backpack = Players.LocalPlayer.Backpack
        local stands = getBase().Stands

        for _, item in backpack:GetChildren() do
            if item.Name ~= "Bat" then
                print("[Turkey Hub] Found item:", item.Name)
                for _, stand in stands:GetChildren() do
                    if stand:GetAttribute("level") == nil then
                        PlaceEvent:FireServer(
                            stand.Name,
                            item:GetAttribute("slimeUID")
                        )
                        print("[Turkey Hub] Placed item:", item.Name)
                    end
                end
            end
        end
    end
})

tab:CreateButton({
    name = "Auto Lucky Block Open",
    callback = function()
        local stands = getBase().Stands

        for _, stand in stands:GetChildren() do
            OpenLuckyBlockEvent:FireServer(stand.Name)
        end
    end
})

tab:CreateButton({
    name = "Pickup Characters",
    callback = function()
        local stands = getBase().Stands

        for _, stand in stands:GetChildren() do
            PickupEvent:FireServer(stand.Name)
        end
    end
})

tab:CreateSection({ name = "Discord" })
tab:CreateButton({
    name = "Copy Discord Invite",
    callback = function()
        setclipboard("https://discord.gg/tPHx7fzYB5")
    end
})

tab:CreateSection({ name = "Unload" })
tab:CreateButton({
    name = "Unload",
    callback = function()
        window:Popup({
            title = "Unload UI?",
            content = "If you unload the UI you will have to rerun the script to use it again.",
            options = {
                { text = "Cancel" },
                { text = "Unload", style = "danger", callback = function() window:Unload() end }
            }
        })
    end,
})
