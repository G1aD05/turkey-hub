-- Libraries
local Rayfield = loadstring(game:HttpGet("https://sirius.menu/gen2"))()

-- Services
local Players = game:GetService("Players")

-- Functions
local function getHRP(player)
    player = player or game:GetService("Players").LocalPlayer

    local character = player.Character
    if not character then
        return nil
    end

    return character:FindFirstChild("HumanoidRootPart")
end

local function getHum(player)
    player = player or game:GetService("Players").LocalPlayer

    local character = player.Character
    if not character then
        return nil
    end

    return character:FindFirstChildOfClass("Humanoid")
end

-- Rayfield
local Window = Rayfield:CreateWindow({
    name = "MM2 GUI",
    subtitle = "Made by Turkey",
    showName = "Turkey Hub"
})

local player = Players.LocalPlayer

local Home = Window:CreateTab({ name = "Home", icon = 93364949241311 })

-- Data
local Data = nil

local StartRound = game:GetService("ReplicatedStorage").Remotes.Gameplay.RoundStart
StartRound.OnClientEvent:Connect(function(_, players)
    Data = players

    for _, player in players do
        if player["Role"] == "Murderer" then
            Window:Toast({
                title = Players:GetPlayerByUserId(player["UserId"]).Name,
                subtitle = "is the murderer",
                avatar = player["UserId"]
            })
        end
    end
end)

Home:CreateSection({ name = "Combat" })

local AutoWinEnabled = false
Home:CreateToggle({
    name = "Kill Others",
    description = "This only works when you are a murderer.",
    callback = function(v)
        AutoWinEnabled = v

        if v then
            task.spawn(function()
                while AutoWinEnabled do
                    local character = player.Character

                    if not character or not character.Parent then
                        task.wait(0.1)
                        continue
                    end

                    if player.Backpack:FindFirstChild("Knife") then
                        getHum():EquipTool(player.Backpack.Knife)
                    end

                    task.wait(0.1)

                    character = player.Character

                    if not character or not character.Parent then
                        continue
                    end

                    local knife = character:FindFirstChild("Knife")

                    if knife then
                        print("[Turkey Hub] Found Knife")

                        task.wait(0.5)

                        character = player.Character

                        if not character or not character.Parent then
                            continue
                        end

                        knife = character:FindFirstChild("Knife")

                        if not knife then
                            continue
                        end

                        local events = knife:FindFirstChild("Events")

                        if not events then
                            continue
                        end

                        local HandleEvent = events:FindFirstChild("HandleTouched")
                        local StabEvent = events:FindFirstChild("KnifeStabbed")

                        if not HandleEvent or not StabEvent then
                            continue
                        end

                        for _, plr in Players:GetPlayers() do
                            local targetCharacter = plr.Character
                            local hrp = targetCharacter and targetCharacter:FindFirstChild("HumanoidRootPart")

                            if hrp then
                                HandleEvent:FireServer(hrp)
                                StabEvent:FireServer()
                                print("[Turkey Hub] Killed " .. plr.Name)
                            end
                        end
                    end

                    task.wait(0.01)
                end
            end)
        end
    end
})

Home:CreateSection({ name = "Visuals" })
local ESPEnabled = false
Home:CreateToggle({
    name = "ESP",
    callback = function(v)
        ESPEnabled = v

        if v then
            task.spawn(function()
                while ESPEnabled do
                    for _, player in Data do
                        local role = player["Role"]
                        local plr = Players:GetPlayerByUserId(player["UserId"])

                        if plr and plr.Character then
                            local highlight = Instance.new("Highlight")

                            if role == "Murderer" then
                                highlight.FillColor = Color3.fromRGB(255, 0, 0)
                            elseif role == "Innocent" then
                                highlight.FillColor = Color3.fromRGB(0, 255, 0)
                            else
                                highlight.FillColor = Color3.fromRGB(0, 0, 255)
                            end

                            highlight.OutlineColor = Color3.fromRGB(255, 255, 255)
                            highlight.FillTransparency = 0.5
                            
                            highlight.Parent = plr.Character
                        end
                    end
                    task.wait(0.01)
                end
            end)
        end
    end
})

Home:CreateSection({ name = "Unload" })
Home:CreateButton({
    name = "Unload",
    callback = function()
        Window:Popup({
            title = "Unload UI?",
            content = "If you unload the UI you will have to rerun the script to use it again.",
            options = {
                { text = "Cancel" },
                { text = "Unload", style = "danger", callback = function() Window:Unload() end }
            }
        })
    end,
})
