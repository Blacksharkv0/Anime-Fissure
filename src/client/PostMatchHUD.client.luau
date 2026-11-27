--!strict
-- ANIME FISSURE | Post-match result and safe return v1.0
-- Server announces actual Victory/Defeat/Aborted. No fake rewards,
-- no replay or continuing to unbuilt stages.
local Players=game:GetService("Players")
local ReplicatedStorage=game:GetService("ReplicatedStorage")
local Workspace=game:GetService("Workspace")
local UserInputService=game:GetService("UserInputService")
local player=Players.LocalPlayer
local parent=player:WaitForChild("PlayerGui")
local remote=ReplicatedStorage:WaitForChild("PostMatchRemotes")
local show=remote:WaitForChild("ShowResult") :: RemoteEvent
local returnLobby=remote:WaitForChild("ReturnLobby") :: RemoteEvent

local old=parent:FindFirstChild("AnimeFissurePostMatchHUD")
if old then old:Destroy() end
local gui=Instance.new("ScreenGui")
gui.Name="AnimeFissurePostMatchHUD"
gui.ResetOnSpawn=false
gui.DisplayOrder=280
gui.ZIndexBehavior=Enum.ZIndexBehavior.Sibling
gui.Enabled=false
gui.Parent=parent
local bg=Instance.new("Frame")
bg.Name="Backdrop";bg.Size=UDim2.fromScale(1,1)
bg.BackgroundColor3=Color3.fromRGB(4,8,18)
bg.BackgroundTransparency=.10
bg.BorderSizePixel=0;bg.Active=true;bg.Parent=gui
local card=Instance.new("Frame")
card.Name="ResultCard"
card.AnchorPoint=Vector2.new(.5,.5)
card.Position=UDim2.fromScale(.5,.5)
card.Size=UDim2.fromOffset(650,410)
card.BackgroundColor3=Color3.fromRGB(18,25,51)
card.BorderSizePixel=0;card.Parent=bg
local corner=Instance.new("UICorner")
corner.CornerRadius=UDim.new(0,16);corner.Parent=card
local border=Instance.new("UIStroke")
border.Thickness=2;border.Color=Color3.fromRGB(249,208,127)
border.Parent=card
local scaler=Instance.new("UIScale")
scaler.Parent=card
local function label(name: string,value: string,y: number,h: number,
 fontSize: number,color: Color3,bold: boolean?): TextLabel
    local t=Instance.new("TextLabel")
    t.Name=name;t.Text=value
    t.Size=UDim2.new(1,-44,0,h)
    t.Position=UDim2.fromOffset(22,y)
    t.BackgroundTransparency=1
    t.TextWrapped=true;t.TextScaled=false
    t.TextSize=fontSize
    t.TextColor3=color
    t.Font=if bold then Enum.Font.GothamBold else Enum.Font.Gotham
    t.TextXAlignment=Enum.TextXAlignment.Center
    t.Parent=card;return t
end
local gold=Color3.fromRGB(255,220,149)
local cyan=Color3.fromRGB(126,220,251)
local white=Color3.fromRGB(239,245,255)
local gray=Color3.fromRGB(176,193,216)
local heading=label("Result","RESULTADO DA PARTIDA",22,52,30,gold,true)
local subtitle=label("WaveProgress","",89,45,20,white,true)
local description=label("StatusMessage","",143,83,16,gray)
local timer=label("AutoReturn","",237,39,15,cyan,true)
local btn=Instance.new("TextButton")
btn.Name="ReturnToLobby";btn.Text="VOLTAR AO LOBBY"
btn.Size=UDim2.fromOffset(450,53)
btn.Position=UDim2.new(.5,-225,1,-83)
btn.BackgroundColor3=Color3.fromRGB(57,122,246)
btn.TextColor3=white
btn.TextSize=19;btn.TextWrapped=true
btn.Font=Enum.Font.GothamBold
btn.BorderSizePixel=0
btn.Parent=card
local btnCorner=Instance.new("UICorner")
btnCorner.CornerRadius=UDim.new(0,10);btnCorner.Parent=btn
local visibleToken=0
local sent=false
local cameraResizeConnection: RBXScriptConnection?=nil
local function close()
    visibleToken+=1
    gui.Enabled=false
    sent=false
end
local function request()
    if not gui.Enabled or sent then return end
    sent=true
    btn.Text="RETORNANDO..."
    btn.Active=false
    returnLobby:FireServer()
    -- Allow a manual retry if the server could not complete the return.
    -- The token prevents a delayed callback affecting another result.
    local token=visibleToken
    task.delay(3,function()
        if gui.Enabled and token==visibleToken and player:GetAttribute("InArena")==true then
            sent=false
            btn.Text="TENTAR VOLTAR AO LOBBY"
            btn.Active=true
        end
    end)
end
btn.Activated:Connect(request)
UserInputService.InputBegan:Connect(function(input: InputObject,processed: boolean)
    if processed or not gui.Enabled then return end
    if input.KeyCode==Enum.KeyCode.ButtonB
        or input.KeyCode==Enum.KeyCode.Return then request() end
end)
local function resize()
    local camera=Workspace.CurrentCamera
    if not camera then return end
    local v=camera.ViewportSize
    scaler.Scale=math.clamp(math.min((v.X-26)/680,(v.Y-22)/438,1),.41,1)
end
local function bindCamera()
    if cameraResizeConnection then
        cameraResizeConnection:Disconnect()
        cameraResizeConnection=nil
    end
    local camera=Workspace.CurrentCamera
    if camera then
        cameraResizeConnection=camera:GetPropertyChangedSignal("ViewportSize"):Connect(resize)
    end
    resize()
end
Workspace:GetPropertyChangedSignal("CurrentCamera"):Connect(bindCamera)
bindCamera()
player:GetAttributeChangedSignal("InArena"):Connect(function()
    if player:GetAttribute("InArena")~=true then close() end
end)
show.OnClientEvent:Connect(function(data: any)
    if typeof(data)~="table" or player:GetAttribute("InArena")~=true then return end
    local state=if typeof(data.Status)=="string" then data.Status else "Aborted"
    local wave=if typeof(data.Wave)=="number" then math.floor(data.Wave) else 0
    local maxWaves=if typeof(data.MaxWaves)=="number" then math.floor(data.MaxWaves) else 0
    local seconds=if typeof(data.AutoReturnSeconds)=="number"
        then math.clamp(math.floor(data.AutoReturnSeconds),5,30) else 30
    local victory=state=="Victory"
    heading.Text=if victory then "✦ VITÓRIA! ✦"
        elseif state=="Defeat" then "DERROTA"
        else "PARTIDA ENCERRADA"
    heading.TextColor3=if victory then gold else Color3.fromRGB(251,139,154)
    subtitle.Text=string.format("WAVES %02d / %02d",wave,maxWaves)
    description.Text=if victory
        then "Você completou a fase de demonstração. Parabéns!"
        elseif state=="Defeat"
        then "A base foi derrotada nesta tentativa."
        else "A sessão de combate foi interrompida."
    description.Text=description.Text..
        "\n\nBETA: uma partida por servidor. Reinicie o Play para jogar de novo."
    visibleToken+=1
    local token=visibleToken
    gui.Enabled=true
    sent=false
    btn.Text="VOLTAR AO LOBBY";btn.Active=true
    resize()
    local deadline=os.clock()+seconds
    task.spawn(function()
        while gui.Enabled and token==visibleToken do
            local remaining=math.max(0,math.ceil(deadline-os.clock()))
            timer.Text="Retorno automático ao lobby em "..
                tostring(remaining).." segundos"
            if remaining<=0 then
                request()
                break
            end
            task.wait(.25)
        end
    end)
end)
print("[Anime Fissure] POST MATCH HUD v1: 30-second safe lobby return")
