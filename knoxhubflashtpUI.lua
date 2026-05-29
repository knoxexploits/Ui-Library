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
    lbl.Font=Enum.Font.GothamBold;lbl.TextSize=13
    lbl.TextColor3=Color3.fromRGB(255,255,255);lbl.TextXAlignment=Enum.TextXAlignment.Left
    lbl.TextTruncate=Enum.TextTruncate.AtEnd;lbl.ZIndex=11

    -- toggle dot indicator
    local dot=Instance.new("Frame",btn)
    dot.Size=UDim2.new(0,8,0,8);dot.Position=UDim2.new(1,-48,0.5,-4)
    dot.BackgroundColor3=initState and Color3.new(1,1,1) or Color3.fromRGB(60,60,60)
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
        Tween(dot,{BackgroundColor3=s and Color3.new(1,1,1) or Color3.fromRGB(60,60,60)},0.15)
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

function Ascended.new(cfg)
	local self=setmetatable({},Ascended)
	self.Name=cfg.Name or"Ascended"
	self.Config.Enabled=cfg.ConfigurationSaving or false
	self.Config.FileName=(cfg.Name or"Config")..".json"
	self:Load()

	self.ScreenGui=Instance.new("ScreenGui",(gethui and gethui())or CG)
	self.ScreenGui.Name="Ascended_"..math.random(1e5)
	self._UIScale=Instance.new("UIScale",self.ScreenGui)
	self._UIScale.Scale=cfg.Scale or 1

	-- Layout constants
	local W,H    = 340,260
	local TABH   = 32   -- tab bar height (was 26, increased for visible tab names)
	local P      = 5    -- padding

	-- Main window
	self.Main=Instance.new("Frame",self.ScreenGui)
	self.Main.Size=UDim2.new(0,W,0,H)
	self.Main.Position=UDim2.new(0.5,-W/2,0.5,-H/2)
	self.Main.BackgroundColor3=Color3.fromRGB(8,8,8)
	self.Main.BackgroundTransparency=0
	self.Main.ClipsDescendants=false
	Instance.new("UICorner",self.Main).CornerRadius=UDim.new(0,8)
	Drag(self.Main)

	-- Outer stroke
	local stroke=Instance.new("UIStroke",self.Main)
	stroke.Color=Ascended.Theme.Accent;stroke.Thickness=1.2;stroke.Transparency=0.45

	-- Subtle watermark
	local WingBG=Instance.new("ImageLabel",self.Main)
	WingBG.Size=UDim2.new(0.6,0,0.6,0);WingBG.Position=UDim2.new(0.2,0,0.25,0)
	WingBG.BackgroundTransparency=1;WingBG.Image="rbxassetid://132669375046851"
	WingBG.ImageTransparency=0.92;WingBG.ScaleType=Enum.ScaleType.Fit;WingBG.ZIndex=1

	-- ── TITLE BAR ──────────────────────────────────────────────
	local titleBar=Instance.new("Frame",self.Main)
	titleBar.Size=UDim2.new(1,0,0,24)
	titleBar.BackgroundColor3=Color3.fromRGB(5,5,5)
	titleBar.BorderSizePixel=0;titleBar.ZIndex=4
	Instance.new("UICorner",titleBar).CornerRadius=UDim.new(0,8)
	-- patch lower rounded corners
	local tbfix=Instance.new("Frame",titleBar)
	tbfix.Size=UDim2.new(1,0,0,8);tbfix.Position=UDim2.new(0,0,1,-8)
	tbfix.BackgroundColor3=Color3.fromRGB(5,5,5);tbfix.BorderSizePixel=0;tbfix.ZIndex=4

	-- accent pip
	local pip=Instance.new("Frame",titleBar)
	pip.Size=UDim2.new(0,2,0,10);pip.Position=UDim2.new(0,7,0.5,-5)
	pip.BackgroundColor3=Ascended.Theme.Accent;pip.BorderSizePixel=0;pip.ZIndex=5
	Instance.new("UICorner",pip).CornerRadius=UDim.new(1,0)

	-- title text
	local titleLbl=Instance.new("TextLabel",titleBar)
	titleLbl.Size=UDim2.new(1,-36,1,0);titleLbl.Position=UDim2.new(0,14,0,0)
	titleLbl.BackgroundTransparency=1;titleLbl.Text=self.Name:upper()
	titleLbl.TextColor3=Color3.fromRGB(240,240,240);titleLbl.Font=Enum.Font.GothamBold
	titleLbl.TextSize=13;titleLbl.TextXAlignment=Enum.TextXAlignment.Left;titleLbl.ZIndex=5

	-- close button
	local closeBtn=Instance.new("TextButton",titleBar)
	closeBtn.Size=UDim2.new(0,26,0,22);closeBtn.Position=UDim2.new(1,-28,0.5,-11)
	closeBtn.Text="×";closeBtn.TextSize=20;closeBtn.Font=Enum.Font.GothamBold
	closeBtn.TextColor3=Color3.fromRGB(200,200,200);closeBtn.BackgroundTransparency=1;closeBtn.ZIndex=5

	-- ── TAB BAR (horizontal, below title) ──────────────────────
	self.Sidebar=Instance.new("Frame",self.Main)
	self.Sidebar.Size=UDim2.new(1,-P*2,0,TABH)
	self.Sidebar.Position=UDim2.new(0,P,0,24+P)
	self.Sidebar.BackgroundColor3=Color3.fromRGB(14,14,14)
	self.Sidebar.BackgroundTransparency=0
	self.Sidebar.ClipsDescendants=false
	self.Sidebar.BorderSizePixel=0
	Instance.new("UICorner",self.Sidebar).CornerRadius=UDim.new(0,6)
	local tabLayout=Instance.new("UIListLayout",self.Sidebar)
	tabLayout.FillDirection=Enum.FillDirection.Horizontal
	tabLayout.Padding=UDim.new(0,2)
	tabLayout.SortOrder=Enum.SortOrder.LayoutOrder
	tabLayout.VerticalAlignment=Enum.VerticalAlignment.Center

	-- thin separator line under tab bar
	local sep=Instance.new("Frame",self.Main)
	sep.Size=UDim2.new(1,-P*2,0,1);sep.Position=UDim2.new(0,P,0,24+P+TABH+P)
	sep.BackgroundColor3=Color3.fromRGB(28,28,28);sep.BorderSizePixel=0;sep.ZIndex=2

	-- ── CONTENT AREA ───────────────────────────────────────────
	local contentTop = 24+P+TABH+P+1+P  -- titleBar + gap + tabBar + gap + sep + gap
	self.Container=Instance.new("Frame",self.Main)
	self.Container.Size=UDim2.new(1,-P*2,0,H-contentTop-P)
	self.Container.Position=UDim2.new(0,P,0,contentTop)
	self.Container.BackgroundTransparency=1

	-- ── RE-OPEN BUTTON ─────────────────────────────────────────
	self.OpenBtn=Instance.new("ImageButton",self.ScreenGui)
	self.OpenBtn.Size=UDim2.new(0,58,0,58);self.OpenBtn.Position=UDim2.new(0.5,-29,0,-80)
	self.OpenBtn.BackgroundTransparency=1;self.OpenBtn.Image="rbxassetid://77514738042186"
	self.OpenBtn.ScaleType=Enum.ScaleType.Fit;self.OpenBtn.Visible=false

	local isM=false
	local function Tgl()
		isM=not isM
		if isM then
			task.spawn(function()
				Tween(self.Main,{Size=UDim2.new(0,0,0,0)},0.2).Completed:Wait()
				self.Main.Visible=false
				self.OpenBtn.Position=UDim2.new(0.5,-29,0,-80)
				self.OpenBtn.Visible=true
				Tween(self.OpenBtn,{Position=UDim2.new(0.5,-29,0,20)},0.4,Enum.EasingStyle.Back)
			end)
		else
			self.Main.Visible=true
			self.OpenBtn.Visible=false
			self.OpenBtn.Position=UDim2.new(0.5,-29,0,-80)
			Tween(self.Main,{Size=UDim2.new(0,W,0,H)},0.4,Enum.EasingStyle.Back)
		end
	end
	-- ── WATERMARK ──────────────────────────────────────────────────────────────
	local wmGui=Instance.new("ScreenGui",self.ScreenGui.Parent or CG)
	wmGui.Name="KnoxWatermark";wmGui.ResetOnSpawn=false;wmGui.DisplayOrder=5
	local wm=Instance.new("TextLabel",wmGui)
	wm.Size=UDim2.new(0,320,0,40);wm.Position=UDim2.new(0.5,-160,0.5,-20)
	wm.BackgroundTransparency=1;wm.Text="https://knoxhub.cc"
	wm.TextColor3=Color3.fromRGB(0,0,0);wm.Font=Enum.Font.GothamBold
	wm.TextSize=22;wm.TextXAlignment=Enum.TextXAlignment.Center;wm.ZIndex=10

	self.OpenBtn.MouseButton1Click:Connect(Tgl)
	closeBtn.MouseButton1Click:Connect(Tgl)
	return self
end

function Ascended:SetScale(scale)self._UIScale.Scale=math.clamp(scale,0.3,2.5)end
function Ascended:GetScale()return self._UIScale.Scale end

-- ── NOTIFY ─────────────────────────────────────────────────────────────────
function Ascended:Notify(c)local nH=self.ScreenGui:FindFirstChild("NH")or Instance.new("Frame",self.ScreenGui)nH.Name="NH"nH.Size=UDim2.new(0,250,1,0)nH.Position=UDim2.new(1,-260,0,-10)nH.BackgroundTransparency=1;local l=nH:FindFirstChild("L")or Instance.new("UIListLayout",nH)l.VerticalAlignment=2;l.Padding=UDim.new(0,10)local n=Instance.new("Frame",nH)n.Size=UDim2.new(1,0,0,60)n.BackgroundColor3=Ascended.Theme.Main;Instance.new("UICorner",n).CornerRadius=UDim.new(0,8)local s=Instance.new("UIStroke",n)s.Color=Ascended.Theme.Accent;s.Thickness=1.5;s.Transparency=0.5;local t=Instance.new("TextLabel",n)t.Size=UDim2.new(1,-10,0,25)t.Position=UDim2.new(0,10,0,5)t.Text=c.Title;t.TextColor3=Color3.fromRGB(255,255,255);t.Font=Enum.Font.GothamBold;t.BackgroundTransparency=1;t.TextXAlignment=0;t.TextScaled=true;Instance.new("UITextSizeConstraint",t).MaxTextSize=16;local d=Instance.new("TextLabel",n)d.Size=UDim2.new(1,-10,0,25)d.Position=UDim2.new(0,10,0,25)d.Text=c.Content;d.TextColor3=Ascended.Theme.Text;d.Font=4;d.BackgroundTransparency=1;d.TextXAlignment=0;d.TextScaled=true;Instance.new("UITextSizeConstraint",d).MaxTextSize=14;Tween(n,{Position=UDim2.new(0,0,0,0)},0.4)task.delay(c.Duration or 5,function()Tween(n,{Position=UDim2.new(1.5,0,0,0)},0.4).Completed:Wait()n:Destroy()end)end

function Ascended:Save()if not self.Config.Enabled then return end;pcall(function()writefile(self.Config.FileName,HS:JSONEncode(Ascended.Flags))end)end
function Ascended:Load()if not self.Config.Enabled or not isfile(self.Config.FileName)then return end;pcall(function()local d=HS:JSONDecode(readfile(self.Config.FileName))for i,v in pairs(d)do Ascended.Flags[i]=v end end)end

-- ── CREATE TAB (horizontal pill tabs) ──────────────────────────────────────
function Ascended:CreateTab(n)
	-- Tab button (pill in the top bar)
	local b=Instance.new("TextButton",self.Sidebar)
	b.Size=UDim2.new(0,90,1,-6)
	b.AutomaticSize=Enum.AutomaticSize.X
	b.BackgroundColor3=Color3.fromRGB(40,40,40)
	b.BackgroundTransparency=0
	b.Text=n
	b.TextColor3=Color3.fromRGB(255,255,255)
	b.Font=Enum.Font.GothamBold
	b.TextSize=13
	b.AutoButtonColor=false
	b.ClipsDescendants=false
	b.ZIndex=5
	Instance.new("UICorner",b).CornerRadius=UDim.new(0,5)
	local bpad=Instance.new("UIPadding",b)
	bpad.PaddingLeft=UDim.new(0,12);bpad.PaddingRight=UDim.new(0,12)

	-- active indicator line under tab
	local indicator=Instance.new("Frame",b)
	indicator.Size=UDim2.new(1,-8,0,2);indicator.Position=UDim2.new(0,4,1,-3)
	indicator.BackgroundColor3=Ascended.Theme.Accent;indicator.BorderSizePixel=0
	indicator.BackgroundTransparency=1
	Instance.new("UICorner",indicator).CornerRadius=UDim.new(1,0)

	-- Content scroll frame
	local pg=Instance.new("ScrollingFrame",self.Container)
	pg.Size=UDim2.new(1,0,1,0)
	pg.BackgroundTransparency=1;pg.Visible=false
	pg.ScrollBarThickness=2;pg.ScrollBarImageColor3=Ascended.Theme.Accent
	pg.CanvasSize=UDim2.new(0,0,0,0)
	local layout=Instance.new("UIListLayout",pg)
	layout.Padding=UDim.new(0,4);layout.SortOrder=Enum.SortOrder.LayoutOrder
	layout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
		pg.CanvasSize=UDim2.new(0,0,0,layout.AbsoluteContentSize.Y+8)
	end)

	local function activate()
		-- hide all pages, deactivate all tab buttons
		for _,v in pairs(self.Container:GetChildren())do
			if v:IsA("ScrollingFrame")then v.Visible=false end
		end
		for _,v in pairs(self.Sidebar:GetChildren())do
			if v:IsA("TextButton")then
				Tween(v,{TextColor3=Color3.fromRGB(170,170,170),BackgroundColor3=Color3.fromRGB(35,35,35),BackgroundTransparency=0},0.15)
				local ind=v:FindFirstChild("Frame")
				if ind then Tween(ind,{BackgroundTransparency=1},0.15) end
			end
		end
		pg.Visible=true
		Tween(b,{TextColor3=Color3.fromRGB(255,255,255),BackgroundColor3=Color3.fromRGB(55,55,55),BackgroundTransparency=0},0.15)
		Tween(indicator,{BackgroundTransparency=0},0.15)
	end

	b.MouseButton1Click:Connect(activate)

	-- auto-select first tab (defer so UIListLayout is already counted)
	task.defer(function()
		if not pg.Visible then
			local anyVisible=false
			for _,v in pairs(self.Container:GetChildren())do
				if v:IsA("ScrollingFrame")and v.Visible then anyVisible=true;break end
			end
			if not anyVisible then activate() end
		end
	end)

	local f={Lib=self}
	local _order=0
	local function nextOrder()_order+=1;return _order end

	function f:CreateToggle(c)
		local fl=c.Flag or c.Name
		local s=Ascended.Flags[fl];if s==nil then s=c.CurrentValue or false end
		Ascended.Flags[fl]=s
		local fr=Instance.new("TextButton",pg)
		fr.LayoutOrder=nextOrder();fr.Size=UDim2.new(1,-6,0,28)
		fr.BackgroundColor3=Color3.fromRGB(16,16,16);fr.Text=""
		fr.AutoButtonColor=false;Instance.new("UICorner",fr).CornerRadius=UDim.new(0,5)
		-- name label
		local lbl=Instance.new("TextLabel",fr)
		lbl.Size=UDim2.new(1,-48,1,0);lbl.Position=UDim2.new(0,8,0,0)
		lbl.BackgroundTransparency=1;lbl.Text=c.Name
		lbl.TextColor3=Ascended.Theme.Text;lbl.Font=Enum.Font.Gotham
		lbl.TextSize=13;lbl.TextXAlignment=Enum.TextXAlignment.Left
		-- switch track
		local sw=Instance.new("Frame",fr)
		sw.Size=UDim2.new(0,26,0,14);sw.Position=UDim2.new(1,-34,0.5,-7)
		sw.BackgroundColor3=s and Ascended.Theme.Accent or Color3.fromRGB(40,40,40)
		Instance.new("UICorner",sw).CornerRadius=UDim.new(1,0)
		-- switch knob
		local d=Instance.new("Frame",sw);d.Size=UDim2.new(0,10,0,10)
		d.Position=s and UDim2.new(1,-12,0.5,-5) or UDim2.new(0,2,0.5,-5)
		d.BackgroundColor3=Color3.new(1,1,1);Instance.new("UICorner",d).CornerRadius=UDim.new(1,0)

		if c.MiniButton then
			local hub=self.Lib;local miniHandle=nil
			task.defer(function()
				local mbFlag=fl.."__mbstate"
				local mbInit=Ascended.Flags[mbFlag] or false
				miniHandle=createMiniButton(hub,mbFlag,
					c.MiniButton==true and c.Name or tostring(c.MiniButton),
					function(ms)c.Callback(ms);hub:Save()end,mbInit)
				miniHandle.gui.Enabled=s
			end)
			fr.MouseButton1Click:Connect(function()
				s=not s;Ascended.Flags[fl]=s
				Tween(sw,{BackgroundColor3=s and Ascended.Theme.Accent or Color3.fromRGB(40,40,40)},0.18)
				Tween(d,{Position=s and UDim2.new(1,-12,0.5,-5)or UDim2.new(0,2,0.5,-5)},0.18)
				if miniHandle then
					miniHandle.gui.Enabled=s
					if not s and miniHandle.GetState()then miniHandle.SetState(false);c.Callback(false)end
				end
				self.Lib:Save()
			end)
		else
			if s then task.spawn(function()c.Callback(true)end)end
			fr.MouseButton1Click:Connect(function()
				s=not s;Ascended.Flags[fl]=s
				Tween(sw,{BackgroundColor3=s and Ascended.Theme.Accent or Color3.fromRGB(40,40,40)},0.18)
				Tween(d,{Position=s and UDim2.new(1,-12,0.5,-5)or UDim2.new(0,2,0.5,-5)},0.18)
				c.Callback(s);self.Lib:Save()
			end)
		end
	end

	function f:CreateSlider(c)
		local fl=c.Flag or c.Name;local v=Ascended.Flags[fl]or c.CurrentValue or c.Min
		v=math.clamp(v,c.Min,c.Max);Ascended.Flags[fl]=v
		local fr=Instance.new("Frame",pg)
		fr.LayoutOrder=nextOrder();fr.Size=UDim2.new(1,-6,0,40)
		fr.BackgroundColor3=Color3.fromRGB(16,16,16)
		Instance.new("UICorner",fr).CornerRadius=UDim.new(0,5)
		local t=Instance.new("TextLabel",fr)
		t.Size=UDim2.new(1,-12,0,16);t.Position=UDim2.new(0,8,0,4)
		t.BackgroundTransparency=1;t.Text=c.Name.." : "..v
		t.TextColor3=Ascended.Theme.Text;t.Font=Enum.Font.Gotham;t.TextSize=13;t.TextXAlignment=Enum.TextXAlignment.Left
		local hitbox=Instance.new("TextButton",fr)
		hitbox.Size=UDim2.new(1,-16,0,18);hitbox.Position=UDim2.new(0,8,0,18)
		hitbox.BackgroundTransparency=1;hitbox.Text="";hitbox.ZIndex=5
		local track=Instance.new("Frame",fr)
		track.Size=UDim2.new(1,-20,0,3);track.Position=UDim2.new(0,10,0,29)
		track.BackgroundColor3=Color3.fromRGB(40,40,40)
		Instance.new("UICorner",track).CornerRadius=UDim.new(1,0)
		local fill=Instance.new("Frame",track)
		fill.Size=UDim2.new((v-c.Min)/(c.Max-c.Min),0,1,0)
		fill.BackgroundColor3=Ascended.Theme.Accent
		Instance.new("UICorner",fill).CornerRadius=UDim.new(1,0)
		local dot=Instance.new("Frame",fill)
		dot.Size=UDim2.new(0,10,0,10);dot.Position=UDim2.new(1,-5,0.5,-5)
		dot.BackgroundColor3=Color3.new(1,1,1);dot.ZIndex=3
		Instance.new("UICorner",dot).CornerRadius=UDim.new(1,0)
		if Ascended.Flags[fl]then task.spawn(function()c.Callback(v)end)end
		local function up()
			local m=UIS:GetMouseLocation().X
			local p=math.clamp((m-track.AbsolutePosition.X)/track.AbsoluteSize.X,0,1)
			local raw=c.Min+(c.Max-c.Min)*p
			local val=math.floor(raw/0.5+0.5)*0.5
			val=math.clamp(val,c.Min,c.Max)
			v=val;Ascended.Flags[fl]=v
			t.Text=c.Name.." : "..string.format(val==math.floor(val) and "%d" or "%.1f",val)
			fill.Size=UDim2.new((val-c.Min)/(c.Max-c.Min),0,1,0)
			c.Callback(val);self.Lib:Save()
		end
		local dragging=false
		-- only BEGIN drag from clicking the hitbox
		hitbox.InputBegan:Connect(function(i)
			if i.UserInputType==Enum.UserInputType.MouseButton1 or i.UserInputType==Enum.UserInputType.Touch then
				dragging=true;up()
			end
		end)
		-- once dragging, mouse can move anywhere on screen
		UIS.InputChanged:Connect(function(i)
			if dragging and(i.UserInputType==Enum.UserInputType.MouseMovement or i.UserInputType==Enum.UserInputType.Touch)then
				up()
			end
		end)
		-- release anywhere stops dragging (must re-click hitbox to start again)
		UIS.InputEnded:Connect(function(i)
			if i.UserInputType==Enum.UserInputType.MouseButton1 or i.UserInputType==Enum.UserInputType.Touch then
				dragging=false
			end
		end)
	end

	function f:CreateButton(n,cb)
		local b=Instance.new("TextButton",pg)
		b.LayoutOrder=nextOrder();b.Size=UDim2.new(1,-6,0,26)
		b.BackgroundColor3=Color3.fromRGB(16,16,16);b.Text=n
		b.TextColor3=Ascended.Theme.Text;b.Font=Enum.Font.Gotham;b.TextSize=13
		b.AutoButtonColor=false;Instance.new("UICorner",b).CornerRadius=UDim.new(0,5)
		b.MouseButton1Click:Connect(function()
			Tween(b,{BackgroundColor3=Ascended.Theme.Accent,TextColor3=Color3.new(1,1,1)},0.1).Completed:Wait()
			Tween(b,{BackgroundColor3=Color3.fromRGB(16,16,16),TextColor3=Ascended.Theme.Text},0.2);cb()
		end)
	end

	function f:CreateSection(n)
		local s=Instance.new("TextLabel",pg)
		s.LayoutOrder=nextOrder();s.Size=UDim2.new(1,-6,0,18)
		s.BackgroundTransparency=1;s.Text=n:upper()
		s.TextColor3=Ascended.Theme.Accent;s.Font=Enum.Font.GothamBold
		s.TextSize=12;s.TextXAlignment=Enum.TextXAlignment.Left
	end

	function f:CreateInput(c)
		local fl=c.Flag or c.Name;local stored=Ascended.Flags[fl]or c.Default or""
		Ascended.Flags[fl]=stored
		local fr=Instance.new("Frame",pg)
		fr.LayoutOrder=nextOrder();fr.Size=UDim2.new(1,-6,0,48)
		fr.BackgroundColor3=Color3.fromRGB(16,16,16)
		Instance.new("UICorner",fr).CornerRadius=UDim.new(0,5)
		local lbl=Instance.new("TextLabel",fr)
		lbl.Size=UDim2.new(1,-10,0,16);lbl.Position=UDim2.new(0,8,0,4)
		lbl.BackgroundTransparency=1;lbl.Text=c.Name
		lbl.TextColor3=Ascended.Theme.Text;lbl.Font=Enum.Font.Gotham;lbl.TextSize=13
		lbl.TextXAlignment=Enum.TextXAlignment.Left
		local box=Instance.new("TextBox",fr)
		box.Size=UDim2.new(1,-16,0,20);box.Position=UDim2.new(0,8,0,22)
		box.BackgroundColor3=Color3.fromRGB(24,24,24);box.Text=stored
		box.PlaceholderText=c.Placeholder or"..."
		box.PlaceholderColor3=Color3.fromRGB(80,80,80)
		box.TextColor3=Ascended.Theme.Text;box.Font=Enum.Font.Gotham;box.TextSize=12
		box.ClearTextOnFocus=false
		Instance.new("UICorner",box).CornerRadius=UDim.new(0,4)
		local bst=Instance.new("UIStroke",box);bst.Color=Color3.fromRGB(40,40,40);bst.Thickness=1
		Instance.new("UIPadding",box).PaddingLeft=UDim.new(0,5)
		box.Focused:Connect(function()Tween(bst,{Color=Ascended.Theme.Accent,Thickness=1.5},0.15)end)
		box.FocusLost:Connect(function()
			Tween(bst,{Color=Color3.fromRGB(40,40,40),Thickness=1},0.15)
			Ascended.Flags[fl]=box.Text;stored=box.Text
			if c.Callback then c.Callback(box.Text)end;self.Lib:Save()
		end)
	end

	function f:CreateDropdown(c)
		local itemH=24;local maxV=5;local totalH=#c.Options*itemH
		local listH=math.min(totalH,maxV*itemH);local closedH=26;local openH=closedH+4+listH
		local fr=Instance.new("Frame",pg)
		fr.LayoutOrder=nextOrder();fr.Size=UDim2.new(1,-6,0,closedH)
		fr.BackgroundColor3=Color3.fromRGB(16,16,16);fr.ClipsDescendants=true
		Instance.new("UICorner",fr).CornerRadius=UDim.new(0,5)
		local bt=Instance.new("TextButton",fr)
		bt.Size=UDim2.new(1,0,0,closedH);bt.BackgroundTransparency=1
		bt.Text=c.Name.." ▾";bt.TextColor3=Ascended.Theme.Text
		bt.Font=Enum.Font.Gotham;bt.TextSize=13;bt.TextXAlignment=Enum.TextXAlignment.Left
		local bpad2=Instance.new("UIPadding",bt);bpad2.PaddingLeft=UDim.new(0,8)
		local scroll=Instance.new("ScrollingFrame",fr)
		scroll.Size=UDim2.new(1,-8,0,listH);scroll.Position=UDim2.new(0,4,0,closedH+2)
		scroll.BackgroundTransparency=1;scroll.ScrollBarThickness=totalH>listH and 2 or 0
		scroll.ScrollBarImageColor3=Ascended.Theme.Accent
		scroll.CanvasSize=UDim2.new(0,0,0,totalH)
		scroll.TopImage="";scroll.MidImage="";scroll.BottomImage=""
		local ddL=Instance.new("UIListLayout",scroll);ddL.Padding=UDim.new(0,2)
		for _,o in pairs(c.Options)do
			local opt=Instance.new("TextButton",scroll)
			opt.Size=UDim2.new(1,0,0,itemH-2);opt.BackgroundColor3=Color3.fromRGB(22,22,22)
			opt.Text=o;opt.TextColor3=Ascended.Theme.Text;opt.Font=Enum.Font.Gotham;opt.TextSize=13
			opt.TextXAlignment=Enum.TextXAlignment.Left
			Instance.new("UICorner",opt).CornerRadius=UDim.new(0,4)
			Instance.new("UIPadding",opt).PaddingLeft=UDim.new(0,6)
			opt.MouseButton1Click:Connect(function()
				bt.Text=c.Name.." : "..o.." ▾";open=false
				Tween(fr,{Size=UDim2.new(1,-6,0,closedH)},0.2);c.Callback(o)
			end)
		end
		local open=false
		bt.MouseButton1Click:Connect(function()
			open=not open;Tween(fr,{Size=UDim2.new(1,-6,0,open and openH or closedH)},0.25)
		end)
	end

	function f:CreateLabel(text)
		local lbl=Instance.new("TextLabel",pg)
		lbl.LayoutOrder=nextOrder();lbl.Size=UDim2.new(1,-6,0,16)
		lbl.BackgroundTransparency=1;lbl.Text=text
		lbl.TextColor3=Color3.fromRGB(140,140,140);lbl.Font=Enum.Font.Gotham
		lbl.TextSize=10;lbl.TextXAlignment=Enum.TextXAlignment.Left;lbl.TextWrapped=true
	end

	function f:CreateInfo(c)
		local fr=Instance.new("Frame",pg)
		fr.LayoutOrder=nextOrder();fr.Size=UDim2.new(1,-6,0,30)
		fr.BackgroundColor3=Color3.fromRGB(16,16,16)
		Instance.new("UICorner",fr).CornerRadius=UDim.new(0,5)
		local ist=Instance.new("UIStroke",fr);ist.Color=Ascended.Theme.Accent;ist.Thickness=1;ist.Transparency=0.6
		local title=Instance.new("TextLabel",fr)
		title.Size=UDim2.new(0.5,-8,1,0);title.Position=UDim2.new(0,8,0,0)
		title.BackgroundTransparency=1;title.Text=c.Title or"Info"
		title.TextColor3=Ascended.Theme.Text;title.Font=Enum.Font.Gotham;title.TextSize=13
		title.TextXAlignment=Enum.TextXAlignment.Left
		local val=Instance.new("TextLabel",fr)
		val.Size=UDim2.new(0.5,-8,1,0);val.Position=UDim2.new(0.5,0,0,0)
		val.BackgroundTransparency=1;val.Text=tostring(c.Value or"—")
		val.TextColor3=Color3.fromRGB(255,255,255);val.Font=Enum.Font.GothamBold;val.TextSize=13
		val.TextXAlignment=Enum.TextXAlignment.Right;val.TextTruncate=Enum.TextTruncate.AtEnd
		local h={}
		function h:Set(v)val.Text=tostring(v)end
		function h:SetTitle(v)title.Text=tostring(v)end
		return h
	end

	return f
end

function Ascended:CreateMiniButton(c)
	local fl=c.Flag or c.Label or"mini_"..math.random(1e5)
	local savedState=Ascended.Flags[fl];if savedState==nil then savedState=c.CurrentValue or false end
	local handle=createMiniButton(self,fl,c.Label or fl,c.Callback or function()end,savedState)
	if savedState and c.Callback then task.spawn(function()c.Callback(true)end)end
	return handle
end

function Ascended:CreateMiniActionButton(c)
	local fl=c.Flag or c.Label or"miniaction_"..math.random(1e5)
	local pk=MINI_POS_PREFIX.."act__"..fl
	local bk=MINI_FLAG_PREFIX.."bind__act__"..fl
	local savedPos=Ascended.Flags[pk]
	local savedBind=Ascended.Flags[bk]or c.KeyBind or""
	local initX=savedPos and UDim2.new(savedPos.sx,savedPos.ox,savedPos.sy,savedPos.oy)or UDim2.new(0.5,80,0.75,0)
	local gui=Instance.new("ScreenGui")
	gui.Name="AscMiniAct_"..fl;gui.ResetOnSpawn=false;gui.DisplayOrder=200
	pcall(function()gui.Parent=(gethui and gethui())or CG end)
	if not gui.Parent then gui.Parent=game:GetService("Players").LocalPlayer:WaitForChild("PlayerGui")end
	local btn=Instance.new("TextButton",gui)
	btn.Size=UDim2.new(0,130,0,36);btn.Position=initX
	btn.BackgroundColor3=Color3.fromRGB(12,12,12);btn.BackgroundTransparency=0.1
	btn.Text="";btn.AutoButtonColor=false;btn.ZIndex=10
	Instance.new("UICorner",btn).CornerRadius=UDim.new(0,10)
	local btnStroke=Instance.new("UIStroke",btn);btnStroke.Color=Color3.fromRGB(50,50,50);btnStroke.Thickness=1.5
	local accent=Instance.new("Frame",btn)
	accent.Size=UDim2.new(0,3,1,-8);accent.Position=UDim2.new(0,5,0,4)
	accent.BackgroundColor3=Ascended.Theme.Accent;accent.BorderSizePixel=0;accent.ZIndex=11
	Instance.new("UICorner",accent).CornerRadius=UDim.new(1,0)
	local lbl=Instance.new("TextLabel",btn)
	lbl.Size=UDim2.new(1,-60,1,0);lbl.Position=UDim2.new(0,14,0,0)
	lbl.BackgroundTransparency=1;lbl.Text=c.Label or fl
	lbl.Font=Enum.Font.GothamBold;lbl.TextSize=13
	lbl.TextColor3=Color3.fromRGB(255,255,255);lbl.TextXAlignment=Enum.TextXAlignment.Left
	lbl.TextTruncate=Enum.TextTruncate.AtEnd;lbl.ZIndex=11
	local flash=Instance.new("Frame",btn)
	flash.Size=UDim2.new(0,8,0,8);flash.Position=UDim2.new(1,-48,0.5,-4)
	flash.BackgroundColor3=Color3.fromRGB(60,60,60);flash.BorderSizePixel=0;flash.ZIndex=11
	Instance.new("UICorner",flash).CornerRadius=UDim.new(1,0)
	local bindBox=Instance.new("TextBox",btn)
	bindBox.Size=UDim2.new(0,32,0,18);bindBox.Position=UDim2.new(1,-40,1,-22)
	bindBox.BackgroundColor3=Color3.fromRGB(30,30,30);bindBox.Text=savedBind;bindBox.PlaceholderText="key"
	bindBox.PlaceholderColor3=Color3.fromRGB(80,80,80);bindBox.TextColor3=Color3.fromRGB(255,255,255)
	bindBox.Font=Enum.Font.GothamBold;bindBox.TextSize=9;bindBox.ClearTextOnFocus=false;bindBox.ZIndex=12
	Instance.new("UICorner",bindBox).CornerRadius=UDim.new(0,5)
	local currentBind=savedBind
	bindBox.FocusLost:Connect(function()
		local k=bindBox.Text:upper():gsub("%s","")
		currentBind=k;bindBox.Text=k;Ascended.Flags[bk]=k
		if self.Config.Enabled then self:Save()end
	end)
	local function fireAction()
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
		if currentBind~=""and input.KeyCode.Name==currentBind then fireAction()end
	end)
	return{
		gui=gui,
		Destroy=function()gui:Destroy()end,
		SetLabel=function(t)lbl.Text=t end,
		SetBind=function(k)currentBind=k:upper();bindBox.Text=currentBind;Ascended.Flags[bk]=currentBind end,
		ResetPos=function()
			btn.Position=UDim2.new(0.5,80,0.75,0);Ascended.Flags[pk]=nil
			if self.Config.Enabled then self:Save()end
		end,
	}
end


return Ascended
