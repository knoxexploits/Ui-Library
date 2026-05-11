-- By Ashcended
local Ascended={Flags={},Theme={Main=Color3.fromRGB(10,10,10),Accent=Color3.fromRGB(160,160,160),Text=Color3.fromRGB(255,255,255),Glass=0.02},Config={Enabled=false,FileName="AscendedConfig.json"}}
Ascended.__index=Ascended
local function gs(n)local s=game:GetService(n)return(cloneref and cloneref(s))or s end
local UIS,TS,CG,HS=gs("UserInputService"),gs("TweenService"),gs("CoreGui"),gs("HttpService")
local function Tween(o,p,t,s)local tw=TS:Create(o,TweenInfo.new(t or 0.3,s or Enum.EasingStyle.Quart,Enum.EasingDirection.Out),p)tw:Play()return tw end
local function Drag(obj)local d,di,ds,sp;obj.InputBegan:Connect(function(i)if i.UserInputType==Enum.UserInputType.MouseButton1 or i.UserInputType==Enum.UserInputType.Touch then d=true;ds=i.Position;sp=obj.Position;i.Changed:Connect(function()if i.UserInputState==Enum.UserInputState.End then d=false end end)end end)obj.InputChanged:Connect(function(i)if i.UserInputType==Enum.UserInputType.MouseMovement or i.UserInputType==Enum.UserInputType.Touch then di=i end end)UIS.InputChanged:Connect(function(i)if i==di and d then local dl=i.Position-ds;obj.Position=UDim2.new(sp.X.Scale,sp.X.Offset+dl.X,sp.Y.Scale,sp.Y.Offset+dl.Y)end end)end

local MiniButtons={}
local MINI_FLAG_PREFIX="__mini__"
local MINI_POS_PREFIX="__minipos__"

local function makeMiniDraggable(btn,hub)
    local d2,di2,ds2,sp2=false,nil,nil,nil
    local wasDragged=false
    btn.InputBegan:Connect(function(i)
        if i.UserInputType==Enum.UserInputType.MouseButton1 or i.UserInputType==Enum.UserInputType.Touch then
            d2=true;wasDragged=false;di2=i;ds2=i.Position;sp2=btn.Position
            i.Changed:Connect(function()if i.UserInputState==Enum.UserInputState.End then d2=false end end)
        end
    end)
    btn.InputChanged:Connect(function(i)
        if i.UserInputType==Enum.UserInputType.MouseMovement or i.UserInputType==Enum.UserInputType.Touch then di2=i end
    end)
    UIS.InputChanged:Connect(function(i)
        if d2 and i==di2 then
            local dl=i.Position-ds2
            if dl.Magnitude>4 then wasDragged=true end
            btn.Position=UDim2.new(sp2.X.Scale,sp2.X.Offset+dl.X,sp2.Y.Scale,sp2.Y.Offset+dl.Y)
        end
    end)
    return function()return wasDragged end
end

local function saveMiniPos(hub,flag,btn)
    if not hub.Config.Enabled then return end
    local pk=MINI_POS_PREFIX..flag
    Ascended.Flags[pk]={sx=btn.Position.X.Scale,ox=math.floor(btn.Position.X.Offset),sy=btn.Position.Y.Scale,oy=math.floor(btn.Position.Y.Offset)}
    hub:Save()
end

local function createMiniButton(hub,flag,labelText,onToggle,initState)
    if MiniButtons[flag] and MiniButtons[flag].gui and MiniButtons[flag].gui.Parent then
        MiniButtons[flag].gui:Destroy()
        MiniButtons[flag]=nil
    end

    -- restore saved position or default
    local pk=MINI_POS_PREFIX..flag
    local savedPos=Ascended.Flags[pk]
    local initX=savedPos and UDim2.new(savedPos.sx,savedPos.ox,savedPos.sy,savedPos.oy) or UDim2.new(0.5,-65,0.75,0)

    -- restore saved bind
    local bk=MINI_FLAG_PREFIX.."bind__"..flag
    local savedBind=Ascended.Flags[bk] or ""

    local gui=Instance.new("ScreenGui")
    gui.Name="AscMini_"..flag;gui.ResetOnSpawn=false;gui.DisplayOrder=200
    pcall(function()gui.Parent=(gethui and gethui())or CG end)
    if not gui.Parent then gui.Parent=game:GetService("Players").LocalPlayer:WaitForChild("PlayerGui")end

    -- main button frame
    local btn=Instance.new("TextButton",gui)
    btn.Size=UDim2.new(0,130,0,36)
    btn.Position=initX
    btn.BackgroundColor3=Color3.fromRGB(12,12,12)
    btn.BackgroundTransparency=0.1
    btn.Text=""
    btn.AutoButtonColor=false
    btn.ZIndex=10
    Instance.new("UICorner",btn).CornerRadius=UDim.new(0,10)
    local btnStroke=Instance.new("UIStroke",btn)
    btnStroke.Color=Color3.fromRGB(50,50,50);btnStroke.Thickness=1.5

    -- accent left bar
    local accent=Instance.new("Frame",btn)
    accent.Size=UDim2.new(0,3,1,-8);accent.Position=UDim2.new(0,5,0,4)
    accent.BackgroundColor3=Ascended.Theme.Accent;accent.BorderSizePixel=0;accent.ZIndex=11
    Instance.new("UICorner",accent).CornerRadius=UDim.new(1,0)

    -- label
    local lbl=Instance.new("TextLabel",btn)
    lbl.Size=UDim2.new(1,-60,1,0);lbl.Position=UDim2.new(0,14,0,0)
    lbl.BackgroundTransparency=1;lbl.Text=labelText
    lbl.Font=Enum.Font.GothamBold;lbl.TextSize=11
    lbl.TextColor3=Color3.fromRGB(255,255,255);lbl.TextXAlignment=Enum.TextXAlignment.Left
    lbl.TextTruncate=Enum.TextTruncate.AtEnd;lbl.ZIndex=11

    -- toggle dot indicator
    local dot=Instance.new("Frame",btn)
    dot.Size=UDim2.new(0,8,0,8);dot.Position=UDim2.new(1,-48,0.5,-4)
    dot.BackgroundColor3=initState and Ascended.Theme.Accent or Color3.fromRGB(60,60,60)
    dot.BorderSizePixel=0;dot.ZIndex=11
    Instance.new("UICorner",dot).CornerRadius=UDim.new(1,0)

    -- keybind textbox
    local bindBox=Instance.new("TextBox",btn)
    bindBox.Size=UDim2.new(0,32,0,18);bindBox.Position=UDim2.new(1,-40,1,-22)
    bindBox.BackgroundColor3=Color3.fromRGB(30,30,30)
    bindBox.Text=savedBind;bindBox.PlaceholderText="key"
    bindBox.PlaceholderColor3=Color3.fromRGB(80,80,80)
    bindBox.TextColor3=Color3.fromRGB(255,255,255);bindBox.Font=Enum.Font.GothamBold
    bindBox.TextSize=9;bindBox.ClearTextOnFocus=false;bindBox.ZIndex=12
    Instance.new("UICorner",bindBox).CornerRadius=UDim.new(0,5)
    local bindStroke=Instance.new("UIStroke",bindBox)
    bindStroke.Color=Color3.fromRGB(60,60,60);bindStroke.Thickness=1

    local currentBind=savedBind
    bindBox.FocusLost:Connect(function()
        local k=bindBox.Text:upper():gsub("%s","")
        currentBind=k;bindBox.Text=k
        Ascended.Flags[bk]=k
        if hub.Config.Enabled then hub:Save()end
    end)

    local state=initState
    local function setVisual(s)
        Tween(dot,{BackgroundColor3=s and Ascended.Theme.Accent or Color3.fromRGB(60,60,60)},0.15)
        Tween(btn,{BackgroundTransparency=s and 0 or 0.1},0.15)
    end
    setVisual(state)

    local wasDraggedFn=makeMiniDraggable(btn,hub)

    -- click to toggle
    btn.MouseButton1Click:Connect(function()
        if wasDraggedFn()then return end
        state=not state
        setVisual(state)
        Ascended.Flags[flag]=state
        onToggle(state)
        if hub.Config.Enabled then hub:Save()end
        -- save position on interact
        saveMiniPos(hub,flag,btn)
    end)

    -- save position when drag ends
    UIS.InputEnded:Connect(function(i)
        if i.UserInputType==Enum.UserInputType.MouseButton1 or i.UserInputType==Enum.UserInputType.Touch then
            if MiniButtons[flag] and MiniButtons[flag].btn==btn then
                saveMiniPos(hub,flag,btn)
            end
        end
    end)

    -- keybind listener
    UIS.InputBegan:Connect(function(input,processed)
        if processed then return end
        if currentBind~="" and input.KeyCode.Name==currentBind then
            state=not state
            setVisual(state)
            Ascended.Flags[flag]=state
            onToggle(state)
            if hub.Config.Enabled then hub:Save()end
        end
    end)

    MiniButtons[flag]={gui=gui,btn=btn,state=state}
    local MINI_DEFAULT_POS=UDim2.new(0.5,-65,0.75,0)
    return {
        gui=gui,
        Destroy=function()
            gui:Destroy()
            MiniButtons[flag]=nil
        end,
        SetState=function(s)
            state=s;setVisual(s)
        end,
        GetState=function()return state end,
        SetLabel=function(t)lbl.Text=t end,
        ResetPos=function()
            btn.Position=MINI_DEFAULT_POS
            Ascended.Flags[pk]=nil
            if hub.Config.Enabled then hub:Save()end
        end,
    }
end

function Ascended:Notify(c)local nH=self.ScreenGui:FindFirstChild("NH")or Instance.new("Frame",self.ScreenGui)nH.Name="NH"nH.Size=UDim2.new(0,250,1,0)nH.Position=UDim2.new(1,-260,0,-10)nH.BackgroundTransparency=1;local l=nH:FindFirstChild("L")or Instance.new("UIListLayout",nH)l.VerticalAlignment=2;l.Padding=UDim.new(0,10)local n=Instance.new("Frame",nH)n.Size=UDim2.new(1,0,0,60)n.BackgroundColor3=Ascended.Theme.Main;Instance.new("UICorner",n).CornerRadius=UDim.new(0,8)local s=Instance.new("UIStroke",n)s.Color=Ascended.Theme.Accent;s.Thickness=1.5;s.Transparency=0.5;local t=Instance.new("TextLabel",n)t.Size=UDim2.new(1,-10,0,25)t.Position=UDim2.new(0,10,0,5)t.Text=c.Title;t.TextColor3=Color3.fromRGB(255,255,255);t.Font=Enum.Font.GothamBold;t.BackgroundTransparency=1;t.TextXAlignment=0;t.TextScaled=true;Instance.new("UITextSizeConstraint",t).MaxTextSize=16;local d=Instance.new("TextLabel",n)d.Size=UDim2.new(1,-10,0,25)d.Position=UDim2.new(0,10,0,25)d.Text=c.Content;d.TextColor3=Ascended.Theme.Text;d.Font=4;d.BackgroundTransparency=1;d.TextXAlignment=0;d.TextScaled=true;Instance.new("UITextSizeConstraint",d).MaxTextSize=14;Tween(n,{Position=UDim2.new(0,0,0,0)},0.4)task.delay(c.Duration or 5,function()Tween(n,{Position=UDim2.new(1.5,0,0,0)},0.4).Completed:Wait()n:Destroy()end)end
function Ascended:Save()if not self.Config.Enabled then return end;pcall(function()writefile(self.Config.FileName,HS:JSONEncode(Ascended.Flags))end)end
function Ascended:Load()if not self.Config.Enabled or not isfile(self.Config.FileName)then return end;pcall(function()local d=HS:JSONDecode(readfile(self.Config.FileName))for i,v in pairs(d)do Ascended.Flags[i]=v end end)end
function Ascended.new(cfg)local self=setmetatable({},Ascended)self.Name=cfg.Name or"Ascended"self.Config.Enabled=cfg.ConfigurationSaving or false;self.Config.FileName=(cfg.Name or"Config")..".json"self:Load()self.ScreenGui=Instance.new("ScreenGui",(gethui and gethui())or CG)self.ScreenGui.Name="Ascended_"..math.random(1e5)self._UIScale=Instance.new("UIScale",self.ScreenGui)self._UIScale.Scale=cfg.Scale or 1;self.Main=Instance.new("Frame",self.ScreenGui)self.Main.Size=UDim2.new(0,480,0,310)self.Main.Position=UDim2.new(0.5,-240,0.5,-155)self.Main.BackgroundColor3=Ascended.Theme.Main;self.Main.BackgroundTransparency=Ascended.Theme.Glass;self.Main.ClipsDescendants=true;Instance.new("UICorner",self.Main).CornerRadius=UDim.new(0,10)Drag(self.Main)local WingBG=Instance.new("ImageLabel",self.Main)WingBG.Name="AngelWings"WingBG.Size=UDim2.new(0.9,0,0.9,0)WingBG.Position=UDim2.new(0.05,0,0.1,0)WingBG.BackgroundTransparency=1;WingBG.Image="rbxassetid://132669375046851"WingBG.ImageTransparency=0.05;WingBG.ImageColor3=Color3.fromRGB(255,255,255);WingBG.ScaleType=Enum.ScaleType.Fit;WingBG.ZIndex=1;local s=Instance.new("UIStroke",self.Main)s.Color=Ascended.Theme.Accent;s.Thickness=1.8;s.Transparency=0.3;self.OpenBtn=Instance.new("ImageButton",self.ScreenGui)self.OpenBtn.Size=UDim2.new(0,60,0,60)self.OpenBtn.Position=UDim2.new(0.5,-30,0,-80)self.OpenBtn.BackgroundTransparency=1;self.OpenBtn.Image="rbxassetid://77514738042186"self.OpenBtn.ScaleType=Enum.ScaleType.Fit;self.OpenBtn.Visible=false;local isM=false;local function Tgl()isM=not isM;if isM then Tween(self.Main,{Size=UDim2.new(0,0,0,0)},0.3).Completed:Connect(function()self.Main.Visible=false;self.OpenBtn.Visible=true;Tween(self.OpenBtn,{Position=UDim2.new(0.5,-30,0,20)},0.4,Enum.EasingStyle.Back)end)else self.Main.Visible=true;self.OpenBtn.Visible=false;self.OpenBtn.Position=UDim2.new(0.5,-30,0,-80)Tween(self.Main,{Size=UDim2.new(0,480,0,310)},0.4,Enum.EasingStyle.Back)end end;self.OpenBtn.MouseButton1Click:Connect(Tgl)self.Sidebar=Instance.new("ScrollingFrame",self.Main)self.Sidebar.Size=UDim2.new(0,120,1,-60)self.Sidebar.Position=UDim2.new(0,10,0,50)self.Sidebar.BackgroundTransparency=1;self.Sidebar.ScrollBarThickness=0;Instance.new("UIListLayout",self.Sidebar).Padding=UDim.new(0,5)self.Container=Instance.new("Frame",self.Main)self.Container.Size=UDim2.new(1,-145,1,-60)self.Container.Position=UDim2.new(0,135,0,50)self.Container.BackgroundTransparency=1;local t=Instance.new("TextLabel",self.Main)t.Size=UDim2.new(1,-20,0,45)t.Position=UDim2.new(0,15,0,0)t.BackgroundTransparency=1;t.Text=self.Name:upper()t.TextColor3=Color3.fromRGB(255,255,255);t.Font=Enum.Font.GothamBold;t.TextSize=16;t.TextXAlignment=0;local mb=Instance.new("TextButton",self.Main)mb.Size=UDim2.new(0,30,0,30)mb.Position=UDim2.new(1,-35,0,8)mb.Text="×"mb.TextSize=20;mb.TextColor3=Color3.fromRGB(255,255,255);mb.BackgroundTransparency=1;mb.MouseButton1Click:Connect(Tgl)return self end
function Ascended:CreateMiniActionButton(c)
    -- c = {Flag, Label, Callback, KeyBind}
    -- Multi-click mini button: fires Callback every press (not a toggle).
    -- Supports keybind. Draggable. Position saved like other mini buttons.
    local fl=c.Flag or c.Label or "miniaction_"..math.random(1e5)
    local pk=MINI_POS_PREFIX.."act__"..fl
    local bk=MINI_FLAG_PREFIX.."bind__act__"..fl
    local savedPos=Ascended.Flags[pk]
    local savedBind=Ascended.Flags[bk] or c.KeyBind or ""
    local initX=savedPos and UDim2.new(savedPos.sx,savedPos.ox,savedPos.sy,savedPos.oy) or UDim2.new(0.5,80,0.75,0)

    local gui=Instance.new("ScreenGui")
    gui.Name="AscMiniAct_"..fl;gui.ResetOnSpawn=false;gui.DisplayOrder=200
    pcall(function()gui.Parent=(gethui and gethui())or CG end)
    if not gui.Parent then gui.Parent=game:GetService("Players").LocalPlayer:WaitForChild("PlayerGui")end

    local btn=Instance.new("TextButton",gui)
    btn.Size=UDim2.new(0,130,0,36)
    btn.Position=initX
    btn.BackgroundColor3=Color3.fromRGB(12,12,12)
    btn.BackgroundTransparency=0.1
    btn.Text=""
    btn.AutoButtonColor=false
    btn.ZIndex=10
    Instance.new("UICorner",btn).CornerRadius=UDim.new(0,10)
    local btnStroke=Instance.new("UIStroke",btn)
    btnStroke.Color=Color3.fromRGB(50,50,50);btnStroke.Thickness=1.5

    -- gold left accent bar
    local accent=Instance.new("Frame",btn)
    accent.Size=UDim2.new(0,3,1,-8);accent.Position=UDim2.new(0,5,0,4)
    accent.BackgroundColor3=Ascended.Theme.Accent;accent.BorderSizePixel=0;accent.ZIndex=11
    Instance.new("UICorner",accent).CornerRadius=UDim.new(1,0)

    -- label
    local lbl=Instance.new("TextLabel",btn)
    lbl.Size=UDim2.new(1,-60,1,0);lbl.Position=UDim2.new(0,14,0,0)
    lbl.BackgroundTransparency=1;lbl.Text=c.Label or fl
    lbl.Font=Enum.Font.GothamBold;lbl.TextSize=11
    lbl.TextColor3=Color3.fromRGB(255,255,255);lbl.TextXAlignment=Enum.TextXAlignment.Left
    lbl.TextTruncate=Enum.TextTruncate.AtEnd;lbl.ZIndex=11

    -- flash indicator (shows briefly on each press instead of toggle dot)
    local flash=Instance.new("Frame",btn)
    flash.Size=UDim2.new(0,8,0,8);flash.Position=UDim2.new(1,-48,0.5,-4)
    flash.BackgroundColor3=Color3.fromRGB(60,60,60)
    flash.BorderSizePixel=0;flash.ZIndex=11
    Instance.new("UICorner",flash).CornerRadius=UDim.new(1,0)

    -- keybind box
    local bindBox=Instance.new("TextBox",btn)
    bindBox.Size=UDim2.new(0,32,0,18);bindBox.Position=UDim2.new(1,-40,1,-22)
    bindBox.BackgroundColor3=Color3.fromRGB(30,30,30)
    bindBox.Text=savedBind;bindBox.PlaceholderText="key"
    bindBox.PlaceholderColor3=Color3.fromRGB(80,80,80)
    bindBox.TextColor3=Color3.fromRGB(255,255,255);bindBox.Font=Enum.Font.GothamBold
    bindBox.TextSize=9;bindBox.ClearTextOnFocus=false;bindBox.ZIndex=12
    Instance.new("UICorner",bindBox).CornerRadius=UDim.new(0,5)
    local bindStroke=Instance.new("UIStroke",bindBox)
    bindStroke.Color=Color3.fromRGB(60,60,60);bindStroke.Thickness=1

    local currentBind=savedBind
    bindBox.FocusLost:Connect(function()
        local k=bindBox.Text:upper():gsub("%s","")
        currentBind=k;bindBox.Text=k
        Ascended.Flags[bk]=k
        if self.Config.Enabled then self:Save()end
    end)

    local function fireAction()
        -- flash the dot gold then back to grey
        Tween(flash,{BackgroundColor3=Ascended.Theme.Accent},0.05)
        Tween(btn,{BackgroundTransparency=0},0.05)
        task.delay(0.15,function()
            Tween(flash,{BackgroundColor3=Color3.fromRGB(60,60,60)},0.15)
            Tween(btn,{BackgroundTransparency=0.1},0.15)
        end)
        if c.Callback then c.Callback()end
    end

    local wasDraggedFn=makeMiniDraggable(btn,self)

    btn.MouseButton1Click:Connect(function()
        if wasDraggedFn()then return end
        fireAction()
        -- save position on interact
        if self.Config.Enabled then
            Ascended.Flags[pk]={sx=btn.Position.X.Scale,ox=math.floor(btn.Position.X.Offset),sy=btn.Position.Y.Scale,oy=math.floor(btn.Position.Y.Offset)}
            self:Save()
        end
    end)

    UIS.InputEnded:Connect(function(i)
        if i.UserInputType==Enum.UserInputType.MouseButton1 or i.UserInputType==Enum.UserInputType.Touch then
            if self.Config.Enabled then
                Ascended.Flags[pk]={sx=btn.Position.X.Scale,ox=math.floor(btn.Position.X.Offset),sy=btn.Position.Y.Scale,oy=math.floor(btn.Position.Y.Offset)}
                self:Save()
            end
        end
    end)

    UIS.InputBegan:Connect(function(input,processed)
        if processed then return end
        if currentBind~="" and input.KeyCode.Name==currentBind then
            fireAction()
        end
    end)

    return {
        gui=gui,
        Destroy=function()gui:Destroy()end,
        SetLabel=function(t)lbl.Text=t end,
        SetBind=function(k)currentBind=k:upper();bindBox.Text=currentBind;Ascended.Flags[bk]=currentBind end,
        ResetPos=function()
            local DEFAULT_ACT_POS=UDim2.new(0.5,80,0.75,0)
            btn.Position=DEFAULT_ACT_POS
            Ascended.Flags[pk]=nil
            if self.Config.Enabled then self:Save()end
        end,
    }
end

function Ascended:SetScale(scale)self._UIScale.Scale=math.clamp(scale,0.3,2.5)end
function Ascended:GetScale()return self._UIScale.Scale end

function Ascended:CreateMiniButton(c)
    -- c = {Flag, Label, CurrentValue, Callback}
    local fl=c.Flag or c.Label or "mini_"..math.random(1e5)
    local savedState=Ascended.Flags[fl]
    if savedState==nil then savedState=c.CurrentValue or false end
    local handle=createMiniButton(self,fl,c.Label or fl,c.Callback or function()end,savedState)
    if savedState and c.Callback then
        task.spawn(function()c.Callback(true)end)
    end
    -- expose ResetPos at top level for convenience
    handle.ResetPos=handle.ResetPos
    return handle
end

function Ascended:CreateTab(n)local b=Instance.new("TextButton",self.Sidebar)b.Size=UDim2.new(1,0,0,32)b.BackgroundColor3=Ascended.Theme.Accent;b.BackgroundTransparency=1;b.Text="  "..n;b.TextColor3=Color3.fromRGB(255,255,255)b.Font=Enum.Font.Gotham;b.TextSize=13;b.TextXAlignment=0;Instance.new("UICorner",b).CornerRadius=UDim.new(0,6)local pg=Instance.new("ScrollingFrame",self.Container)pg.Size=UDim2.new(1,0,1,0)pg.BackgroundTransparency=1;pg.Visible=false;pg.ScrollBarThickness=3;pg.ScrollBarImageColor3=Ascended.Theme.Accent;pg.CanvasSize=UDim2.new(0,0,0,0)local layout=Instance.new("UIListLayout",pg)layout.Padding=UDim.new(0,8)layout.SortOrder=Enum.SortOrder.LayoutOrder;layout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()pg.CanvasSize=UDim2.new(0,0,0,layout.AbsoluteContentSize.Y+16)end)b.MouseButton1Click:Connect(function()for _,v in pairs(self.Container:GetChildren())do if v:IsA("ScrollingFrame")then v.Visible=false end end;for _,v in pairs(self.Sidebar:GetChildren())do if v:IsA("TextButton")then Tween(v,{BackgroundTransparency=1,TextColor3=Color3.fromRGB(160,160,160)},0.2)end end;pg.Visible=true;Tween(b,{BackgroundTransparency=0.9,TextColor3=Color3.fromRGB(255,255,255)},0.2)end)if#self.Sidebar:GetChildren()==2 then pg.Visible=true;Tween(b,{BackgroundTransparency=0.9,TextColor3=Color3.fromRGB(255,255,255)},0.2)end;local f={Lib=self}local _order=0;local function nextOrder()_order+=1;return _order end

function f:CreateToggle(c)
    local fl=c.Flag or c.Name
    local s=Ascended.Flags[fl]
    if s==nil then s=c.CurrentValue or false end
    Ascended.Flags[fl]=s
    local fr=Instance.new("TextButton",pg)
    fr.LayoutOrder=nextOrder();fr.Size=UDim2.new(1,-10,0,38);fr.BackgroundColor3=Color3.fromRGB(22,22,22)
    fr.Text="  "..c.Name;fr.TextColor3=Ascended.Theme.Text;fr.Font=4;fr.TextSize=13;fr.TextXAlignment=0;fr.AutoButtonColor=false
    Instance.new("UICorner",fr).CornerRadius=UDim.new(0,6)
    local sw=Instance.new("Frame",fr);sw.Size=UDim2.new(0,34,0,18);sw.Position=UDim2.new(1,-44,0.5,-9)
    sw.BackgroundColor3=s and Ascended.Theme.Accent or Color3.fromRGB(50,50,50)
    Instance.new("UICorner",sw).CornerRadius=UDim.new(1,0)
    local d=Instance.new("Frame",sw);d.Size=UDim2.new(0,12,0,12)
    d.Position=s and UDim2.new(1,-14,0.5,-6)or UDim2.new(0,2,0.5,-6)
    d.BackgroundColor3=Color3.new(1,1,1);Instance.new("UICorner",d).CornerRadius=UDim.new(1,0)
    if c.MiniButton then
        -- MiniButton mode:
        --   toggle  = show / hide the mini button (does NOT call c.Callback)
        --   mini button = turns the actual logic on / off (calls c.Callback)
        local hub=self.Lib
        local miniHandle=nil
        task.defer(function()
            -- separate flag so mini-button logic state is saved independently
            local mbFlag=fl.."__mbstate"
            local mbInit=Ascended.Flags[mbFlag] or false
            miniHandle=createMiniButton(hub,mbFlag,
                c.MiniButton==true and c.Name or tostring(c.MiniButton),
                function(ms)c.Callback(ms);hub:Save()end,
                mbInit)
            -- respect current toggle state immediately
            miniHandle.gui.Enabled=s
        end)
        fr.MouseButton1Click:Connect(function()
            s=not s;Ascended.Flags[fl]=s
            Tween(sw,{BackgroundColor3=s and Ascended.Theme.Accent or Color3.fromRGB(50,50,50)},0.2)
            Tween(d,{Position=s and UDim2.new(1,-14,0.5,-6)or UDim2.new(0,2,0.5,-6)},0.2)
            if miniHandle then
                miniHandle.gui.Enabled=s
                -- when hiding the mini button, also turn off the logic if it was on
                if not s and miniHandle.GetState() then
                    miniHandle.SetState(false)
                    c.Callback(false)
                end
            end
            self.Lib:Save()
        end)
    else
        -- Normal mode: toggle directly controls the logic
        if s then task.spawn(function()c.Callback(true)end)end
        fr.MouseButton1Click:Connect(function()
            s=not s;Ascended.Flags[fl]=s
            Tween(sw,{BackgroundColor3=s and Ascended.Theme.Accent or Color3.fromRGB(50,50,50)},0.2)
            Tween(d,{Position=s and UDim2.new(1,-14,0.5,-6)or UDim2.new(0,2,0.5,-6)},0.2)
            c.Callback(s);self.Lib:Save()
        end)
    end
end

function f:CreateSlider(c)local fl=c.Flag or c.Name;local v=Ascended.Flags[fl]or c.CurrentValue or c.Min;v=math.clamp(v,c.Min,c.Max);Ascended.Flags[fl]=v;local fr=Instance.new("Frame",pg)fr.LayoutOrder=nextOrder()fr.Size=UDim2.new(1,-10,0,50)fr.BackgroundColor3=Color3.fromRGB(22,22,22)Instance.new("UICorner",fr).CornerRadius=UDim.new(0,6)local t=Instance.new("TextLabel",fr)t.Size=UDim2.new(1,-20,0,20)t.Position=UDim2.new(0,10,0,5)t.BackgroundTransparency=1;t.Text=c.Name.." : "..v;t.TextColor3=Ascended.Theme.Text;t.Font=4;t.TextSize=12;t.TextXAlignment=0;local hitbox=Instance.new("TextButton",fr)hitbox.Size=UDim2.new(1,-20,0,28)hitbox.Position=UDim2.new(0,10,0,22)hitbox.BackgroundTransparency=1;hitbox.Text=""hitbox.ZIndex=5;local b=Instance.new("Frame",fr)b.Size=UDim2.new(1,-30,0,5)b.Position=UDim2.new(0,15,0,35)b.BackgroundColor3=Color3.fromRGB(50,50,50)Instance.new("UICorner",b).CornerRadius=UDim.new(1,0)local fi=Instance.new("Frame",b)fi.Size=UDim2.new((v-c.Min)/(c.Max-c.Min),0,1,0)fi.BackgroundColor3=Ascended.Theme.Accent;Instance.new("UICorner",fi).CornerRadius=UDim.new(1,0)local dot=Instance.new("Frame",fi)dot.Size=UDim2.new(0,14,0,14)dot.Position=UDim2.new(1,-7,0.5,-7)dot.BackgroundColor3=Ascended.Theme.Accent;dot.ZIndex=3;Instance.new("UICorner",dot).CornerRadius=UDim.new(1,0)local ds=Instance.new("UIStroke",dot)ds.Color=Color3.fromRGB(100,100,100)ds.Thickness=1.5;ds.Transparency=0.5;if Ascended.Flags[fl]then task.spawn(function()c.Callback(v)end)end;local function up()local m=UIS:GetMouseLocation().X;local p=math.clamp((m-b.AbsolutePosition.X)/b.AbsoluteSize.X,0,1)local val=math.floor(c.Min+(c.Max-c.Min)*p)v=val;Ascended.Flags[fl]=v;t.Text=c.Name.." : "..v;fi.Size=UDim2.new(p,0,1,0)c.Callback(v)self.Lib:Save()end;local dragging=false;hitbox.InputBegan:Connect(function(i)if i.UserInputType==Enum.UserInputType.MouseButton1 or i.UserInputType==Enum.UserInputType.Touch then dragging=true;up()end end)UIS.InputChanged:Connect(function(i)if dragging and(i.UserInputType==Enum.UserInputType.MouseMovement or i.UserInputType==Enum.UserInputType.Touch)then up()end end)UIS.InputEnded:Connect(function(i)if i.UserInputType==Enum.UserInputType.MouseButton1 or i.UserInputType==Enum.UserInputType.Touch then dragging=false end end)end
function f:CreateInput(c)local fl=c.Flag or c.Name;local stored=Ascended.Flags[fl]or c.Default or""Ascended.Flags[fl]=stored;local fr=Instance.new("Frame",pg)fr.LayoutOrder=nextOrder()fr.Size=UDim2.new(1,-10,0,54)fr.BackgroundColor3=Color3.fromRGB(22,22,22)Instance.new("UICorner",fr).CornerRadius=UDim.new(0,6)local lbl=Instance.new("TextLabel",fr)lbl.Size=UDim2.new(1,-10,0,18)lbl.Position=UDim2.new(0,10,0,4)lbl.BackgroundTransparency=1;lbl.Text=c.Name;lbl.TextColor3=Ascended.Theme.Text;lbl.Font=Enum.Font.Gotham;lbl.TextSize=12;lbl.TextXAlignment=Enum.TextXAlignment.Left;local box=Instance.new("TextBox",fr)box.Size=UDim2.new(1,-20,0,24)box.Position=UDim2.new(0,10,0,24)box.BackgroundColor3=Color3.fromRGB(30,30,30)box.Text=stored;box.PlaceholderText=c.Placeholder or"Enter value..."box.PlaceholderColor3=Color3.fromRGB(90,90,90)box.TextColor3=Ascended.Theme.Text;box.Font=Enum.Font.Gotham;box.TextSize=12;box.TextXAlignment=Enum.TextXAlignment.Left;box.ClearTextOnFocus=false;Instance.new("UICorner",box).CornerRadius=UDim.new(0,5)local stroke=Instance.new("UIStroke",box)stroke.Color=Color3.fromRGB(55,55,55)stroke.Thickness=1;local pad=Instance.new("UIPadding",box)pad.PaddingLeft=UDim.new(0,6)box.Focused:Connect(function()Tween(stroke,{Color=Ascended.Theme.Accent,Thickness=1.5},0.15)end)box.FocusLost:Connect(function()Tween(stroke,{Color=Color3.fromRGB(55,55,55),Thickness=1},0.15)local val=box.Text;Ascended.Flags[fl]=val;stored=val;if c.Callback then c.Callback(val)end;self.Lib:Save()end)end
function f:CreateDropdown(c)local itemH=28;local maxVisible=5;local totalH=#c.Options*itemH;local listH=math.min(totalH,maxVisible*itemH)local closedH=38;local openH=closedH+6+listH;local fr=Instance.new("Frame",pg)fr.LayoutOrder=nextOrder()fr.Size=UDim2.new(1,-10,0,closedH)fr.BackgroundColor3=Color3.fromRGB(22,22,22)fr.ClipsDescendants=true;Instance.new("UICorner",fr).CornerRadius=UDim.new(0,6)local bt=Instance.new("TextButton",fr)bt.Size=UDim2.new(1,0,0,closedH)bt.BackgroundTransparency=1;bt.Text="  "..c.Name.." : Select"bt.TextColor3=Ascended.Theme.Text;bt.Font=Enum.Font.Gotham;bt.TextSize=13;bt.TextXAlignment=Enum.TextXAlignment.Left;local scroll=Instance.new("ScrollingFrame",fr)scroll.Size=UDim2.new(1,-10,0,listH)scroll.Position=UDim2.new(0,5,0,closedH+4)scroll.BackgroundTransparency=1;scroll.ScrollBarThickness=totalH>listH and 3 or 0;scroll.ScrollBarImageColor3=Ascended.Theme.Accent;scroll.CanvasSize=UDim2.new(0,0,0,totalH)scroll.TopImage=""scroll.MidImage=""scroll.BottomImage=""local ddLayout=Instance.new("UIListLayout",scroll)ddLayout.Padding=UDim.new(0,3)for _,o in pairs(c.Options)do local opt=Instance.new("TextButton",scroll)opt.Size=UDim2.new(1,0,0,itemH-3)opt.BackgroundColor3=Color3.fromRGB(30,30,30)opt.Text="  "..o;opt.TextColor3=Ascended.Theme.Text;opt.Font=Enum.Font.Gotham;opt.TextSize=12;opt.TextXAlignment=Enum.TextXAlignment.Left;Instance.new("UICorner",opt).CornerRadius=UDim.new(0,5)opt.MouseButton1Click:Connect(function()bt.Text="  "..c.Name.." : "..o;open=false;Tween(fr,{Size=UDim2.new(1,-10,0,closedH)},0.25)c.Callback(o)end)end;local open=false;bt.MouseButton1Click:Connect(function()open=not open;Tween(fr,{Size=UDim2.new(1,-10,0,open and openH or closedH)},0.3)end)end
function f:CreateButton(n,cb)local b=Instance.new("TextButton",pg)b.LayoutOrder=nextOrder()b.Size=UDim2.new(1,-10,0,38)b.BackgroundColor3=Color3.fromRGB(22,22,22)b.Text="  "..n;b.TextColor3=Ascended.Theme.Text;b.Font=4;b.TextSize=13;b.TextXAlignment=0;Instance.new("UICorner",b).CornerRadius=UDim.new(0,6)b.MouseButton1Click:Connect(function()Tween(b,{BackgroundColor3=Ascended.Theme.Accent,TextColor3=Color3.new(1,1,1)},0.1).Completed:Wait()Tween(b,{BackgroundColor3=Color3.fromRGB(22,22,22),TextColor3=Ascended.Theme.Text},0.2)cb()end)end
function f:CreateSection(n)local s=Instance.new("TextLabel",pg)s.LayoutOrder=nextOrder()s.Size=UDim2.new(1,-10,0,20)s.BackgroundTransparency=1;s.Text=" "..n:upper()s.TextColor3=Color3.fromRGB(255,255,255);s.Font=Enum.Font.GothamBold;s.TextSize=11;s.TextXAlignment=Enum.TextXAlignment.Left end
function f:CreateLabel(text)local lbl=Instance.new("TextLabel",pg)lbl.LayoutOrder=nextOrder()lbl.Size=UDim2.new(1,-10,0,18)lbl.BackgroundTransparency=1;lbl.Text="  "..text;lbl.TextColor3=Ascended.Theme.Text;lbl.Font=Enum.Font.Gotham;lbl.TextSize=12;lbl.TextXAlignment=Enum.TextXAlignment.Left;lbl.TextWrapped=true end
function f:CreateInfo(c)local fr=Instance.new("Frame",pg)fr.LayoutOrder=nextOrder()fr.Size=UDim2.new(1,-10,0,38)fr.BackgroundColor3=Color3.fromRGB(20,20,20)Instance.new("UICorner",fr).CornerRadius=UDim.new(0,6)local stroke=Instance.new("UIStroke",fr)stroke.Color=Ascended.Theme.Accent;stroke.Thickness=1;stroke.Transparency=0.6;local title=Instance.new("TextLabel",fr)title.Size=UDim2.new(0.55,-10,1,0)title.Position=UDim2.new(0,10,0,0)title.BackgroundTransparency=1;title.Text=c.Title or"Info"title.TextColor3=Ascended.Theme.Text;title.Font=Enum.Font.Gotham;title.TextSize=12;title.TextXAlignment=Enum.TextXAlignment.Left;local val=Instance.new("TextLabel",fr)val.Size=UDim2.new(0.45,-10,1,0)val.Position=UDim2.new(0.55,0,0,0)val.BackgroundTransparency=1;val.Text=tostring(c.Value or"—")val.TextColor3=Color3.fromRGB(255,255,255);val.Font=Enum.Font.GothamBold;val.TextSize=12;val.TextXAlignment=Enum.TextXAlignment.Right;val.TextTruncate=Enum.TextTruncate.AtEnd;local handle={}function handle:Set(newValue)val.Text=tostring(newValue)end;function handle:SetTitle(newTitle)title.Text=tostring(newTitle)end;return handle end
return f
end
return Ascended
