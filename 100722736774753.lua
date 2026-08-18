-- Guess My Football Country

-- Libraries
local Rayfield = loadstring(game:HttpGet("https://sirius.menu/gen2"))()

-- Services
local ReplicatedStorage = game:GetService("ReplicatedStorage")

-- Game
local Characters = require(ReplicatedStorage:WaitForChild("GameModeModule")).Characters

-- Events
local StartGuess = ReplicatedStorage.Remotes.PlayerGuessStart
local PlayerGuess = ReplicatedStorage.Remotes.PlayerGuessed
local CharacterSelectEvent = ReplicatedStorage.Remotes.CharacterSelectResult
local RequestOpponent = ReplicatedStorage.Remotes.RequestAIOpponent
local SelectCharacter = ReplicatedStorage.Remotes.CharacterSelected

-- Rayfield
local Window = Rayfield:CreateWindow({
    name = "Guess My Football Country GUI",
    subtitle = "Made by Turkey"
})

local Home = Window:CreateTab({
    name = "Home",
    icon = 93364949241311
})

local OpponentId = nil

CharacterSelectEvent.OnClientEvent:Connect(function(logos)
    local logo_id = logos["opponentCharacter"]

    for i, character in Characters do
        if i == logo_id then
            print("[Turkey Hub] Opponent's country is "..character.name.." ("..tostring(i)..")")
            local asset = character.imageId
            local id = asset:gsub("rbxassetid://", "")
            OpponentId = i
            print(id)

            Window:Notify({
                title = character.name,
                content = "is the opponent's country.",
                duration = 10,
                icon = tonumber(id)
            })

            break
        end
    end
end)

Home:CreateSection({ name = "Auto" })

local AutoplayEnabled = false
Home:CreateToggle({
    name = "Autoplay",
    callback = function(v)
        AutoplayEnabled = v

        if v then
            task.spawn(function()
                while AutoplayEnabled do
                    local prompt = workspace.DuelTables.Table_12.Seat1:FindFirstChild("SitPrompt")
                    if prompt then
                        fireproximityprompt(prompt)
                        task.wait(0.5)
                        RequestOpponent:FireServer(12)
                        task.wait(0.5)
                        SelectCharacter:FireServer(1)
                    end
                    
                    if OpponentId then
                        StartGuess:FireServer()
                        task.wait(1)
                        PlayerGuess:FireServer(OpponentId)
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
                { text = "Unload", style = "danger", callback = function() Window:Unload() end}
            }
        })
    end
})
