--!strict
-- RASGANDO A REALIDADE | first join screen, before StarterPlayerScripts.
-- Progress is completed readiness checks, not downloaded asset percentage.
local ReplicatedFirst=game:GetService("ReplicatedFirst")
local RS=game:GetService("ReplicatedStorage")
local Players=game:GetService("Players")
local Workspace=game:GetService("Workspace")
local TweenService=game:GetService("TweenService")
local UIS=game:GetService("UserInputService")
local CAS=game:GetService("ContextActionService")
local player=Players.LocalPlayer
local pg=player:WaitForChild("PlayerGui")
local gui=Instance.new("ScreenGui")
gui.Name="FissureArrivalLoading";gui.IgnoreGuiInset=true;gui.ResetOnSpawn=false
gui.DisplayOrder=10000;gui.ZIndexBehavior=Enum.ZIndexBehavior.Sibling
local bg=Instance.new("Frame")
bg.Name="Reality";bg.Size=UDim2.fromScale(1,1);bg.BackgroundColor3=Color3.fromRGB(5,9,20)
bg.BorderSizePixel=0;bg.Parent=gui
local grad=Instance.new("UIGradient")
grad.Color=ColorSequence.new(Color3.fromRGB(19,33,61),Color3.fromRGB(4,7,15));grad.Rotation=90;grad.Parent=bg
local function frame(parent: Instance,n: string,pos: UDim2,size: UDim2,c: Color3): Frame
    local f=Instance.new("Frame");f.Name=n;f.Position=pos;f.Size=size
    f.BackgroundColor3=c;f.BorderSizePixel=0;f.Parent=parent;return f
end
local function label(n: string,txt: string,y: number,h: number,c: Color3,font: Enum.Font): TextLabel
    local t=Instance.new("TextLabel");t.Name=n;t.Text=txt;t.Position=UDim2.fromScale(.07,y)
    t.Size=UDim2.fromScale(.86,h);t.BackgroundTransparency=1;t.TextColor3=c
    t.Font=font;t.TextScaled=true;t.Parent=bg
    local limit=Instance.new("UITextSizeConstraint");limit.MaxTextSize=if n=="Brand" then 54 else 21;limit.MinTextSize=9;limit.Parent=t
    return t
end
local blue=Color3.fromRGB(56,123,255)
local cyan=Color3.fromRGB(117,225,255)
local white=Color3.fromRGB(229,240,255)
local logo=frame(bg,"FixedCrest",UDim2.fromScale(.5,.24),UDim2.fromOffset(84,84),Color3.fromRGB(11,20,39))
logo.AnchorPoint=Vector2.new(.5,.5)
local corner=Instance.new("UICorner");corner.CornerRadius=UDim.new(1,0);corner.Parent=logo
local stroke=Instance.new("UIStroke");stroke.Color=blue;stroke.Thickness=2;stroke.Parent=logo
local glyph=Instance.new("TextLabel");glyph.Text="F";glyph.Font=Enum.Font.GothamBlack;glyph.TextColor3=white
glyph.TextScaled=true;glyph.BackgroundTransparency=1;glyph.Size=UDim2.fromScale(.72,.72)
glyph.Position=UDim2.fromScale(.14,.14);glyph.Rotation=12;glyph.Parent=logo
label("Brand","ANIME FISSURE",.32,.105,white,Enum.Font.GothamBlack)
label("Subtitle","RASGANDO A REALIDADE",.435,.048,cyan,Enum.Font.GothamBold)
local stage=label("Stage","Inicializando sistemas...",.70,.050,white,Enum.Font.GothamMedium)
local percent=label("Percent","0%",.625,.057,cyan,Enum.Font.GothamBold)
label("Footer","ASCENSION  /  FISSURE CITY",.89,.035,Color3.fromRGB(115,142,180),Enum.Font.GothamMedium)
local cut=frame(bg,"DimensionalCut",UDim2.fromScale(.16,.575),UDim2.fromScale(.68,.006),Color3.fromRGB(34,48,78))
cut.ClipsDescendants=false
local fill=frame(cut,"RiftCore",UDim2.fromScale(0,0),UDim2.fromScale(0,1),cyan)
local bloom=frame(fill,"RiftAura",UDim2.new(0,0,.5,-5),UDim2.new(1,0,0,10),blue)
bloom.BackgroundTransparency=.68;bloom.ZIndex=1;fill.ZIndex=2
local cracks: {Frame}={}
local sparks: {Frame}={}
for i=1,12 do
    local x=i/13
    local crack=frame(cut,"Crack_"..i,UDim2.fromScale(x,.5),UDim2.new(.05,0,0,2),cyan)
    crack.AnchorPoint=Vector2.new(0,.5);crack.Rotation=if i%2==0 then -40 else 42
    crack.Visible=false;table.insert(cracks,crack)
    local spark=frame(cut,"Spark_"..i,UDim2.new(x,0,.5,if i%2==0 then -20 else 19),UDim2.fromOffset(3,3),white)
    spark.Rotation=45;spark.Visible=false;table.insert(sparks,spark)
end
local shield=Instance.new("TextButton");shield.Name="InputShield";shield.Text=""
shield.AutoButtonColor=false;shield.BackgroundTransparency=1;shield.Size=UDim2.fromScale(1,1)
shield.ZIndex=20;shield.Modal=true;shield.Parent=gui
gui.Parent=pg
ReplicatedFirst:RemoveDefaultLoadingScreen()
CAS:BindActionAtPriority("FissureLoadingMovement",function() return Enum.ContextActionResult.Sink end,
    false,Enum.ContextActionPriority.High.Value+20,Enum.PlayerActions.CharacterForward,
    Enum.PlayerActions.CharacterBackward,Enum.PlayerActions.CharacterLeft,
    Enum.PlayerActions.CharacterRight,Enum.PlayerActions.CharacterJump)
player:SetAttribute("FissureLoading",true)
local function child(o: Instance?,n: string): Instance? return if o then o:FindFirstChild(n) else nil end
local function readyFlag(o: Instance?,n: string): boolean return o~=nil and o:GetAttribute(n)==true end
local function check()
    local lobby=Workspace:FindFirstChild("FissureLobby")
    local summon=child(child(lobby,"VirgilSummonStand"),"VirgilNPC")
    local edward=child(child(lobby,"AlchemyWorkshop"),"AlchemistNPC")
    local city=child(lobby,"FissureCity")
    local world=child(lobby,"GroundedWorld")
    local services=child(lobby,"LobbyServiceStations")
    local hall=child(lobby,"BabylonHall")
    local char=player.Character
    local root=child(char,"HumanoidRootPart")
    local checks={
        {game:IsLoaded(),"Carregando recursos iniciais..."},
        {child(lobby,"LobbyFloor")~=nil and child(lobby,"LobbySpawn")~=nil and child(child(lobby,"ArenaPortal"),"MissionBoardPrompt")~=nil,"Construindo a entrada..."},
        {readyFlag(city,"Ready") and readyFlag(world,"Ready"),"Materializando Fissure City..."},
        {readyFlag(summon,"InteractionReady") and readyFlag(edward,"InteractionReady"),"Preparando os mercadores..."},
        {readyFlag(services,"Ready") and Workspace:GetAttribute("FoundationMentors")=="Ready","Conectando os mentores..."},
        {readyFlag(hall,"Ready") and Workspace:GetAttribute("FoundationBabylon")=="Ready","Abrindo a Babilônia..."},
        {child(child(RS,"LobbyRemotes"),"EnterArena")~=nil and child(child(RS,"NPCDialogueRemotes"),"OpenDialogue")~=nil,"Sincronizando interfaces..."},
        {root~=nil and root:IsA("BasePart") and (root.Position-Vector3.new(260,5,25)).Magnitude<30,"Preparando sua chegada..."},
    }
    local n=0
    local pending="Fissura estabilizada"
    for _,item in ipairs(checks) do
        if item[1] then n+=1 elseif pending=="Fissura estabilizada" then pending=item[2] :: string end
    end
    return n,#checks,pending
end
local begun=os.clock()
local last=-1
local currentTween: Tween?=nil
while gui.Parent do
    local n,total,pending=check()
    if n~=last then
        last=n
        local ratio=n/total
        percent.Text=tostring(math.floor(ratio*100)).."%"
        if currentTween then currentTween:Cancel() end
        currentTween=TweenService:Create(fill,TweenInfo.new(.22,Enum.EasingStyle.Quad),{Size=UDim2.fromScale(ratio,1)})
        currentTween:Play()
        for i,crack in ipairs(cracks) do crack.Visible=ratio>=.4 and i/13<=ratio end
        for i,spark in ipairs(sparks) do spark.Visible=not UIS.TouchEnabled and ratio>=.4 and i/13<=ratio end
        bloom.BackgroundTransparency=if ratio>=.8 then .38 else .68
    end
    stage.Text=pending
    if n==total then
        stage.Text="FISSURA ESTABILIZADA";break
    end
    if os.clock()-begun>40 then
        stage.Text="Aguardando: "..pending.."  •  Ainda não pronto"
        if Workspace:GetAttribute("FoundationMentors")=="Error" or Workspace:GetAttribute("FoundationBabylon")=="Error"
            or (Workspace:FindFirstChild("FissureLobby") and Workspace.FissureLobby:GetAttribute("CityReady")==false) then
            stage.Text="Falha ao preparar a cidade. Reconecte ou verifique o Output no Studio."
        end
    end
    task.wait(.18)
end
-- No forced 100% or timer bypass. Fade the screen only when checks pass.
if gui.Parent then
    if currentTween then currentTween.Completed:Wait() end
    local flash=frame(gui,"RiftReveal",UDim2.fromScale(0,.5),UDim2.fromScale(1,0),cyan)
    flash.AnchorPoint=Vector2.new(0,.5);flash.ZIndex=50
    local reveal=TweenService:Create(flash,TweenInfo.new(.30,Enum.EasingStyle.Quart),{Size=UDim2.fromScale(1,1)})
    reveal:Play();reveal.Completed:Wait()
    bg:Destroy()
    local fade=TweenService:Create(flash,TweenInfo.new(.45),{BackgroundTransparency=1})
    fade:Play();fade.Completed:Wait()
end
CAS:UnbindAction("FissureLoadingMovement")
player:SetAttribute("FissureLoading",false)
gui:Destroy()
print("[Anime Fissure] RASGANDO A REALIDADE | readiness checks complete")
