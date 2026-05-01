-- Ascended UI Library (Fixed)
local Ascended = {
    Flags = {},
    Theme = {
        Main = Color3.fromRGB(255, 255, 255),
        Accent = Color3.fromRGB(255, 215, 0),
        Text = Color3.fromRGB(80, 80, 80),
        Glass = 0.15
    },
    Config = {Enabled = false, FileName = "AscendedConfig.json"}
}
Ascended.__index = Ascended

local function gs(n) local s = game:GetService(n) return (cloneref and cloneref(s)) or s end
local UIS, TS, CG, HS = gs("UserInputService"), gs("TweenService"), gs("CoreGui"), gs("HttpService")

local function Tween(o, p, t, s)
    local tw = TS:Create(o, TweenInfo.new(t or 0.3, s or Enum.EasingStyle.Quart, Enum.EasingDirection.Out), p)
    tw:Play()
    return tw
end

local function Drag(obj)
    local d, di, ds, sp
    obj.InputBegan:Connect(function(i)
        if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then
            d = true; ds = i.Position; sp = obj.Position
            i.Changed:Connect(function()
                if i.UserInputState == Enum.UserInputState.End then d = false end
            end)
        end
    end)
    obj.InputChanged:Connect(function(i)
        if i.UserInputType == Enum.UserInputType.MouseMovement or i.UserInputType == Enum.UserInputType.Touch then
            di = i
        end
    end)
    UIS.InputChanged:Connect(function(i)
        if i == di and d then
            local dl = i.Position - ds
            obj.Position = UDim2.new(sp.X.Scale, sp.X.Offset + dl.X, sp.Y.Scale, sp.Y.Offset + dl.Y)
        end
    end)
end

-- FIX 1: Notify — fixed VerticalAlignment enum
function Ascended:Notify(c)
    local nH = self.ScreenGui:FindFirstChild("NH") or Instance.new("Frame", self.ScreenGui)
    nH.Name = "NH"; nH.Size = UDim2.new(0, 250, 1, 0)
    nH.Position = UDim2.new(1, -260, 0, 0); nH.BackgroundTransparency = 1
    local l = nH:FindFirstChild("L") or Instance.new("UIListLayout", nH)
    l.VerticalAlignment = Enum.VerticalAlignment.Bottom  -- FIX: was = 2
    l.Padding = UDim.new(0, 10)
    local n = Instance.new("Frame", nH)
    n.Size = UDim2.new(1, 0, 0, 60); n.BackgroundColor3 = Ascended.Theme.Main
    Instance.new("UICorner", n).CornerRadius = UDim.new(0, 8)
    local s = Instance.new("UIStroke", n)
    s.Color = Ascended.Theme.Accent; s.Thickness = 1.5; s.Transparency = 0.5
    local t = Instance.new("TextLabel", n)
    t.Size = UDim2.new(1, -10, 0, 25); t.Position = UDim2.new(0, 10, 0, 5)
    t.Text = c.Title; t.TextColor3 = Ascended.Theme.Accent
    t.Font = Enum.Font.GothamBold; t.BackgroundTransparency = 1
    t.TextXAlignment = Enum.TextXAlignment.Left; t.TextScaled = true
    Instance.new("UITextSizeConstraint", t).MaxTextSize = 16
    local d = Instance.new("TextLabel", n)
    d.Size = UDim2.new(1, -10, 0, 25); d.Position = UDim2.new(0, 10, 0, 25)
    d.Text = c.Content; d.TextColor3 = Ascended.Theme.Text
    d.Font = Enum.Font.Gotham; d.BackgroundTransparency = 1  -- FIX: Font = 4 -> Enum
    d.TextXAlignment = Enum.TextXAlignment.Left; d.TextScaled = true
    Instance.new("UITextSizeConstraint", d).MaxTextSize = 14
    -- Slide in from right
    n.Position = UDim2.new(1.5, 0, 0, 0)
    Tween(n, {Position = UDim2.new(0, 0, 0, 0)}, 0.4)
    task.delay(c.Duration or 5, function()
        Tween(n, {Position = UDim2.new(1.5, 0, 0, 0)}, 0.4).Completed:Wait()
        n:Destroy()
    end)
end

function Ascended:Save()
    if not self.Config.Enabled then return end
    pcall(function() writefile(self.Config.FileName, HS:JSONEncode(Ascended.Flags)) end)
end

function Ascended:Load()
    if not self.Config.Enabled or not isfile(self.Config.FileName) then return end
    pcall(function()
        local d = HS:JSONDecode(readfile(self.Config.FileName))
        for i, v in pairs(d) do Ascended.Flags[i] = v end
    end)
end

function Ascended.new(cfg)
    local self = setmetatable({}, Ascended)
    self.Name = cfg.Name or "Ascended"
    self.Config = {Enabled = cfg.ConfigurationSaving or false, FileName = (cfg.Name or "Config") .. ".json"}
    self:Load()

    self.ScreenGui = Instance.new("ScreenGui", (gethui and gethui()) or CG)
    self.ScreenGui.Name = "Ascended_" .. math.random(1e5)
    self.ScreenGui.ResetOnSpawn = false  -- FIX: prevents GUI destroying on respawn
    self.ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

    local gW = (cfg.Size and cfg.Size.Width) or 480
    local gH = (cfg.Size and cfg.Size.Height) or 310
    self.GuiW = gW; self.GuiH = gH

    self.Main = Instance.new("Frame", self.ScreenGui)
    self.Main.Size = UDim2.new(0, gW, 0, gH)
    self.Main.Position = UDim2.new(0.5, -gW/2, 0.5, -gH/2)
    self.Main.BackgroundColor3 = Ascended.Theme.Main
    self.Main.BackgroundTransparency = Ascended.Theme.Glass
    self.Main.ClipsDescendants = true
    Instance.new("UICorner", self.Main).CornerRadius = UDim.new(0, 10)
    Drag(self.Main)

    -- Watermark wing background
    local WingBG = Instance.new("ImageLabel", self.Main)
    WingBG.Name = "AngelWings"
    WingBG.Size = UDim2.new(0.9, 0, 0.9, 0)
    WingBG.Position = UDim2.new(0.05, 0, 0.1, 0)
    WingBG.BackgroundTransparency = 1
    WingBG.Image = "rbxassetid://132669375046851"
    WingBG.ImageTransparency = 0.4
    WingBG.ScaleType = Enum.ScaleType.Fit
    WingBG.ZIndex = 0

    local s = Instance.new("UIStroke", self.Main)
    s.Color = Ascended.Theme.Accent; s.Thickness = 1.8; s.Transparency = 0.3

    -- Minimise button (ImageButton shown when GUI is hidden)
    self.OpenBtn = Instance.new("ImageButton", self.ScreenGui)
    self.OpenBtn.Size = UDim2.new(0, 60, 0, 60)
    self.OpenBtn.Position = UDim2.new(0.5, -30, 0, -80)
    self.OpenBtn.BackgroundTransparency = 1
    self.OpenBtn.Image = "rbxassetid://122419622598879"
    self.OpenBtn.ScaleType = Enum.ScaleType.Fit
    self.OpenBtn.Visible = false

    local isM = false
    local function Tgl()
        isM = not isM
        if isM then
            Tween(self.Main, {Size = UDim2.new(0, 0, 0, 0)}, 0.3).Completed:Connect(function()
                self.Main.Visible = false
                self.OpenBtn.Visible = true
                Tween(self.OpenBtn, {Position = UDim2.new(0.5, -30, 0, 20)}, 0.4, Enum.EasingStyle.Back)
            end)
        else
            self.Main.Visible = true
            self.OpenBtn.Visible = false
            self.OpenBtn.Position = UDim2.new(0.5, -30, 0, -80)
            Tween(self.Main, {Size = UDim2.new(0, self.GuiW, 0, self.GuiH)}, 0.4, Enum.EasingStyle.Back)
        end
    end
    self.OpenBtn.MouseButton1Click:Connect(Tgl)

    -- Sidebar (tab buttons)
    self.Sidebar = Instance.new("ScrollingFrame", self.Main)
    self.Sidebar.Size = UDim2.new(0, 120, 1, -60)
    self.Sidebar.Position = UDim2.new(0, 10, 0, 50)
    self.Sidebar.BackgroundTransparency = 1
    self.Sidebar.ScrollBarThickness = 0
    self.Sidebar.CanvasSize = UDim2.new(0, 0, 0, 0)
    self.Sidebar.AutomaticCanvasSize = Enum.AutomaticSize.Y
    local sbl = Instance.new("UIListLayout", self.Sidebar)
    sbl.Padding = UDim.new(0, 5)

    -- Content area
    self.Container = Instance.new("Frame", self.Main)
    self.Container.Size = UDim2.new(1, -145, 1, -60)
    self.Container.Position = UDim2.new(0, 135, 0, 50)
    self.Container.BackgroundTransparency = 1

    -- Title
    local titleLbl = Instance.new("TextLabel", self.Main)
    titleLbl.Size = UDim2.new(1, -50, 0, 45)
    titleLbl.Position = UDim2.new(0, 15, 0, 0)
    titleLbl.BackgroundTransparency = 1
    titleLbl.Text = self.Name:upper()
    titleLbl.TextColor3 = Ascended.Theme.Accent
    titleLbl.Font = Enum.Font.GothamBold
    titleLbl.TextSize = 16
    titleLbl.TextXAlignment = Enum.TextXAlignment.Left

    -- Close/minimise button (×)
    local mb = Instance.new("TextButton", self.Main)
    mb.Size = UDim2.new(0, 30, 0, 30)
    mb.Position = UDim2.new(1, -35, 0, 8)
    mb.Text = "×"; mb.TextSize = 20
    mb.TextColor3 = Ascended.Theme.Accent
    mb.BackgroundTransparency = 1
    mb.MouseButton1Click:Connect(Tgl)

    -- FIX 2: expose self as global so hub script can reference Ascended after loadstring
    _G.Ascended = Ascended

    return self
end

function Ascended:SetSize(w, h)
    self.GuiW = w or self.GuiW
    self.GuiH = h or self.GuiH
    self.Main.Size = UDim2.new(0, self.GuiW, 0, self.GuiH)
    self.Main.Position = UDim2.new(0.5, -(self.GuiW / 2), 0.5, -(self.GuiH / 2))
end

function Ascended:CreateTab(n)
    local b = Instance.new("TextButton", self.Sidebar)
    b.Size = UDim2.new(1, 0, 0, 32)
    b.BackgroundColor3 = Ascended.Theme.Accent
    b.BackgroundTransparency = 1
    b.Text = "  " .. n
    b.TextColor3 = Color3.fromRGB(180, 180, 180)
    b.Font = Enum.Font.Gotham
    b.TextSize = 13
    b.TextXAlignment = Enum.TextXAlignment.Left
    Instance.new("UICorner", b).CornerRadius = UDim.new(0, 6)

    local pg = Instance.new("ScrollingFrame", self.Container)
    pg.Size = UDim2.new(1, 0, 1, 0)
    pg.BackgroundTransparency = 1
    pg.Visible = false
    pg.ScrollBarThickness = 3
    pg.ScrollBarImageColor3 = Ascended.Theme.Accent
    pg.CanvasSize = UDim2.new(0, 0, 0, 0)
    pg.AutomaticCanvasSize = Enum.AutomaticSize.Y  -- FIX: auto-grow so scroll works
    local pgl = Instance.new("UIListLayout", pg)
    pgl.Padding = UDim.new(0, 8)
    local pgp = Instance.new("UIPadding", pg)
    pgp.PaddingBottom = UDim.new(0, 8)

    b.MouseButton1Click:Connect(function()
        for _, v in pairs(self.Container:GetChildren()) do
            if v:IsA("ScrollingFrame") then v.Visible = false end
        end
        for _, v in pairs(self.Sidebar:GetChildren()) do
            if v:IsA("TextButton") then
                Tween(v, {BackgroundTransparency = 1, TextColor3 = Color3.fromRGB(180, 180, 180)}, 0.2)
            end
        end
        pg.Visible = true
        Tween(b, {BackgroundTransparency = 0.9, TextColor3 = Ascended.Theme.Accent}, 0.2)
    end)

    -- Auto-select first tab
    local tabCount = 0
    for _, v in pairs(self.Sidebar:GetChildren()) do
        if v:IsA("TextButton") then tabCount += 1 end
    end
    if tabCount == 1 then
        pg.Visible = true
        Tween(b, {BackgroundTransparency = 0.9, TextColor3 = Ascended.Theme.Accent}, 0.2)
    end

    local f = {Lib = self}

    function f:CreateToggle(c)
        local fl = c.Flag or c.Name
        local s = Ascended.Flags[fl]
        if s == nil then s = c.CurrentValue or false end
        Ascended.Flags[fl] = s

        local fr = Instance.new("TextButton", pg)
        fr.Size = UDim2.new(1, -10, 0, 38)
        fr.BackgroundColor3 = Color3.fromRGB(245, 245, 245)
        fr.Text = "  " .. c.Name
        fr.TextColor3 = Ascended.Theme.Text
        fr.Font = Enum.Font.Gotham  -- FIX: Font = 4 -> Enum
        fr.TextSize = 13
        fr.TextXAlignment = Enum.TextXAlignment.Left
        fr.AutoButtonColor = false
        Instance.new("UICorner", fr).CornerRadius = UDim.new(0, 6)

        local sw = Instance.new("Frame", fr)
        sw.Size = UDim2.new(0, 34, 0, 18)
        sw.Position = UDim2.new(1, -44, 0.5, -9)
        sw.BackgroundColor3 = s and Ascended.Theme.Accent or Color3.fromRGB(220, 220, 220)
        Instance.new("UICorner", sw).CornerRadius = UDim.new(1, 0)

        local dot = Instance.new("Frame", sw)
        dot.Size = UDim2.new(0, 12, 0, 12)
        dot.Position = s and UDim2.new(1, -14, 0.5, -6) or UDim2.new(0, 2, 0.5, -6)
        dot.BackgroundColor3 = Color3.new(1, 1, 1)
        Instance.new("UICorner", dot).CornerRadius = UDim.new(1, 0)

        if s then task.spawn(function() c.Callback(true) end) end

        fr.MouseButton1Click:Connect(function()
            s = not s
            Ascended.Flags[fl] = s
            Tween(sw, {BackgroundColor3 = s and Ascended.Theme.Accent or Color3.fromRGB(220, 220, 220)}, 0.2)
            Tween(dot, {Position = s and UDim2.new(1, -14, 0.5, -6) or UDim2.new(0, 2, 0.5, -6)}, 0.2)
            c.Callback(s)
            self.Lib:Save()
        end)
    end

    function f:CreateSlider(c)
        local fl = c.Flag or c.Name
        local v = Ascended.Flags[fl]
        if v == nil then v = c.CurrentValue or c.Min end
        Ascended.Flags[fl] = v

        local fr = Instance.new("Frame", pg)
        fr.Size = UDim2.new(1, -10, 0, 55)
        fr.BackgroundColor3 = Color3.fromRGB(245, 245, 245)
        Instance.new("UICorner", fr).CornerRadius = UDim.new(0, 6)

        local lbl = Instance.new("TextLabel", fr)
        lbl.Size = UDim2.new(1, -20, 0, 22)
        lbl.Position = UDim2.new(0, 10, 0, 5)
        lbl.BackgroundTransparency = 1
        lbl.Text = c.Name .. " : " .. v
        lbl.TextColor3 = Ascended.Theme.Text
        lbl.Font = Enum.Font.Gotham  -- FIX: Font = 4 -> Enum
        lbl.TextSize = 12
        lbl.TextXAlignment = Enum.TextXAlignment.Left

        -- Invisible hitbox for drag area
        local hitbox = Instance.new("TextButton", fr)
        hitbox.Size = UDim2.new(1, -20, 0, 28)
        hitbox.Position = UDim2.new(0, 10, 0, 24)
        hitbox.BackgroundTransparency = 1
        hitbox.Text = ""
        hitbox.ZIndex = 5

        -- Track background
        local track = Instance.new("Frame", fr)
        track.Size = UDim2.new(1, -30, 0, 5)
        track.Position = UDim2.new(0, 15, 0, 40)
        track.BackgroundColor3 = Color3.fromRGB(220, 220, 220)
        Instance.new("UICorner", track).CornerRadius = UDim.new(1, 0)

        -- Fill
        local fill = Instance.new("Frame", track)
        fill.Size = UDim2.new((v - c.Min) / (c.Max - c.Min), 0, 1, 0)
        fill.BackgroundColor3 = Ascended.Theme.Accent
        Instance.new("UICorner", fill).CornerRadius = UDim.new(1, 0)

        -- Dot handle
        local dot = Instance.new("Frame", fill)
        dot.Size = UDim2.new(0, 14, 0, 14)
        dot.Position = UDim2.new(1, -7, 0.5, -7)
        dot.BackgroundColor3 = Ascended.Theme.Accent
        dot.ZIndex = 3
        Instance.new("UICorner", dot).CornerRadius = UDim.new(1, 0)
        local ds2 = Instance.new("UIStroke", dot)
        ds2.Color = Color3.fromRGB(200, 160, 0); ds2.Thickness = 1.5; ds2.Transparency = 0.5

        if Ascended.Flags[fl] ~= nil then task.spawn(function() c.Callback(v) end) end

        local function updateSlider()
            local m = UIS:GetMouseLocation().X
            local p = math.clamp((m - track.AbsolutePosition.X) / track.AbsoluteSize.X, 0, 1)
            -- FIX: respect Increment if provided, else floor
            local range = c.Max - c.Min
            local inc = c.Increment or 1
            local val = c.Min + math.floor((range * p) / inc + 0.5) * inc
            val = math.clamp(val, c.Min, c.Max)
            v = val; Ascended.Flags[fl] = v
            lbl.Text = c.Name .. " : " .. v
            fill.Size = UDim2.new((v - c.Min) / range, 0, 1, 0)
            c.Callback(v)
            self.Lib:Save()
        end

        local dragging = false
        hitbox.InputBegan:Connect(function(i)
            if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then
                dragging = true
                updateSlider()
            end
        end)
        UIS.InputChanged:Connect(function(i)
            if dragging and (i.UserInputType == Enum.UserInputType.MouseMovement or i.UserInputType == Enum.UserInputType.Touch) then
                updateSlider()
            end
        end)
        UIS.InputEnded:Connect(function(i)
            if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then
                dragging = false
            end
        end)
    end

    -- FIX 3: Dropdown — listFrame now sits inside a wrapper inside pg, not loose after fr
    function f:CreateDropdown(c)
        local fl = c.Flag or c.Name
        local selected = Ascended.Flags[fl]
        if selected == nil then selected = c.CurrentValue or c.Options[1] end
        Ascended.Flags[fl] = selected

        -- Outer wrapper (collapses / expands height)
        local itemH = 30
        local wrapper = Instance.new("Frame", pg)
        wrapper.Size = UDim2.new(1, -10, 0, 38)
        wrapper.BackgroundTransparency = 1
        wrapper.ClipsDescendants = false

        -- Header row
        local fr = Instance.new("Frame", wrapper)
        fr.Size = UDim2.new(1, 0, 0, 38)
        fr.Position = UDim2.new(0, 0, 0, 0)
        fr.BackgroundColor3 = Color3.fromRGB(245, 245, 245)
        Instance.new("UICorner", fr).CornerRadius = UDim.new(0, 6)

        local bt = Instance.new("TextButton", fr)
        bt.Size = UDim2.new(1, 0, 1, 0)
        bt.BackgroundTransparency = 1
        bt.Text = "  " .. c.Name .. " : " .. selected .. " ▾"
        bt.TextColor3 = Ascended.Theme.Text
        bt.Font = Enum.Font.Gotham; bt.TextSize = 13
        bt.TextXAlignment = Enum.TextXAlignment.Left

        -- Options list (positioned below the header, inside wrapper)
        local totalH = #c.Options * (itemH + 4)
        local listFrame = Instance.new("Frame", wrapper)
        listFrame.Size = UDim2.new(1, 0, 0, totalH)
        listFrame.Position = UDim2.new(0, 0, 0, 42)   -- just below the header
        listFrame.BackgroundColor3 = Color3.fromRGB(245, 245, 245)
        listFrame.Visible = false
        listFrame.ZIndex = 10
        Instance.new("UICorner", listFrame).CornerRadius = UDim.new(0, 6)
        local ll = Instance.new("UIListLayout", listFrame)
        ll.Padding = UDim.new(0, 4)
        local lp = Instance.new("UIPadding", listFrame)
        lp.PaddingTop = UDim.new(0, 4); lp.PaddingBottom = UDim.new(0, 4)
        lp.PaddingLeft = UDim.new(0, 4); lp.PaddingRight = UDim.new(0, 4)

        for _, o in pairs(c.Options) do
            local opt = Instance.new("TextButton", listFrame)
            opt.Size = UDim2.new(1, 0, 0, itemH)
            opt.BackgroundColor3 = Color3.fromRGB(238, 238, 238)
            opt.Text = "  " .. o
            opt.TextColor3 = Ascended.Theme.Text
            opt.Font = Enum.Font.Gotham; opt.TextSize = 12
            opt.TextXAlignment = Enum.TextXAlignment.Left
            opt.ZIndex = 11
            Instance.new("UICorner", opt).CornerRadius = UDim.new(0, 5)
            opt.MouseButton1Click:Connect(function()
                selected = o
                Ascended.Flags[fl] = selected
                bt.Text = "  " .. c.Name .. " : " .. o .. " ▾"
                listFrame.Visible = false
                wrapper.Size = UDim2.new(1, -10, 0, 38)
                c.Callback(o); self.Lib:Save()
            end)
        end

        local open = false
        bt.MouseButton1Click:Connect(function()
            open = not open
            listFrame.Visible = open
            -- Expand wrapper so items don't get clipped by the scrollframe layout
            wrapper.Size = open
                and UDim2.new(1, -10, 0, 38 + 6 + totalH)
                or  UDim2.new(1, -10, 0, 38)
        end)
    end

    function f:CreateButton(n, cb)
        local b = Instance.new("TextButton", pg)
        b.Size = UDim2.new(1, -10, 0, 38)
        b.BackgroundColor3 = Color3.fromRGB(245, 245, 245)
        b.Text = "  " .. n
        b.TextColor3 = Ascended.Theme.Text
        b.Font = Enum.Font.Gotham  -- FIX: Font = 4 -> Enum
        b.TextSize = 13
        b.TextXAlignment = Enum.TextXAlignment.Left
        Instance.new("UICorner", b).CornerRadius = UDim.new(0, 6)
        b.MouseButton1Click:Connect(function()
            Tween(b, {BackgroundColor3 = Ascended.Theme.Accent, TextColor3 = Color3.new(1,1,1)}, 0.1).Completed:Wait()
            Tween(b, {BackgroundColor3 = Color3.fromRGB(245,245,245), TextColor3 = Ascended.Theme.Text}, 0.2)
            cb()
        end)
    end

    function f:CreateSection(n)
        local wrap = Instance.new("Frame", pg)
        wrap.Size = UDim2.new(1, -10, 0, 24); wrap.BackgroundTransparency = 1
        local line = Instance.new("Frame", wrap)
        line.Size = UDim2.new(1, 0, 0, 1); line.Position = UDim2.new(0, 0, 0.5, 0)
        line.BackgroundColor3 = Ascended.Theme.Accent; line.BackgroundTransparency = 0.7
        local s = Instance.new("TextLabel", wrap)
        s.Size = UDim2.new(0, 0, 1, 0); s.AutomaticSize = Enum.AutomaticSize.X
        s.Position = UDim2.new(0, 8, 0, 0); s.BackgroundTransparency = 1
        s.Text = "  " .. n:upper() .. "  "
        s.TextColor3 = Ascended.Theme.Accent
        s.Font = Enum.Font.GothamBold; s.TextSize = 11
        s.TextXAlignment = Enum.TextXAlignment.Left
    end

    function f:CreateLabel(text)
        local lbl = Instance.new("TextLabel", pg)
        lbl.Size = UDim2.new(1, -10, 0, 0)
        lbl.AutomaticSize = Enum.AutomaticSize.Y
        lbl.BackgroundTransparency = 1
        lbl.Text = "  " .. text
        lbl.TextColor3 = Ascended.Theme.Text
        lbl.Font = Enum.Font.Gotham
        lbl.TextSize = 12
        lbl.TextXAlignment = Enum.TextXAlignment.Left
        lbl.TextWrapped = true
    end

    function f:CreateInfo(c)
        local fr = Instance.new("Frame", pg)
        fr.Size = UDim2.new(1, -10, 0, 38)
        fr.BackgroundColor3 = Color3.fromRGB(240, 240, 240)
        Instance.new("UICorner", fr).CornerRadius = UDim.new(0, 6)
        local stroke = Instance.new("UIStroke", fr)
        stroke.Color = Ascended.Theme.Accent; stroke.Thickness = 1; stroke.Transparency = 0.6

        local titleLbl = Instance.new("TextLabel", fr)
        titleLbl.Size = UDim2.new(0.55, -10, 1, 0)
        titleLbl.Position = UDim2.new(0, 10, 0, 0)
        titleLbl.BackgroundTransparency = 1
        titleLbl.Text = c.Title or "Info"
        titleLbl.TextColor3 = Ascended.Theme.Text
        titleLbl.Font = Enum.Font.Gotham; titleLbl.TextSize = 12
        titleLbl.TextXAlignment = Enum.TextXAlignment.Left

        local valLbl = Instance.new("TextLabel", fr)
        valLbl.Size = UDim2.new(0.45, -10, 1, 0)
        valLbl.Position = UDim2.new(0.55, 0, 0, 0)
        valLbl.BackgroundTransparency = 1
        valLbl.Text = tostring(c.Value or "—")
        valLbl.TextColor3 = Ascended.Theme.Accent
        valLbl.Font = Enum.Font.GothamBold; valLbl.TextSize = 12
        valLbl.TextXAlignment = Enum.TextXAlignment.Right
        valLbl.TextTruncate = Enum.TextTruncate.AtEnd

        local handle = {}
        function handle:Set(newValue) valLbl.Text = tostring(newValue) end
        function handle:SetTitle(newTitle) titleLbl.Text = tostring(newTitle) end
        return handle
    end

    return f
end

return Ascended
