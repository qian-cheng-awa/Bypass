local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()
local Window = Rayfield:CreateWindow({
    Name = "死轨道",
    Icon = 0, -- Icon in Topbar. Can use Lucide Icons (string) or Roblox Image (number). 0 to use no icon (default).
    LoadingTitle = "测试脚本",
    LoadingSubtitle = "by 牢大",
    Theme = "Default", -- Check https://docs.sirius.menu/rayfield/configuration/themes

    DisableRayfieldPrompts = false,
    DisableBuildWarnings = false, -- Prevents Rayfield from warning when the script has a version mismatch with the interface
})

local Tab = Window:CreateTab("主要功能", 4483362458)

local item = nil
local items = {}
local function updataitem()
    local tb = {}
    items = {}
    for i,v in ipairs(workspace:GetDescendants()) do
        if v:FindFirstChild("ObjectInfo") then
            tb[#tb + 1] = tostring(i).." "..tostring(v.Name)
            items[tostring(i).." "..tostring(v.Name)] = v
        end
    end
    return tb
end

local Dropdown = Tab:CreateDropdown({
    Name = "选择物品",
    Options = updataitem(),
    CurrentOption = {""},
    MultipleOptions = false,
    Flag = "",
    Callback = function(Options)
        -- The function that takes place when the selected option is changed
        -- The variable (Options) is a table of strings for the current selected options
        item = items[unpack(Options)]
    end,
})

workspace:WaitForChild("RuntimeItems").ChildAdded:Connect(function()
    Dropdown:Refresh(updataitem())
end)
workspace:WaitForChild("RuntimeItems").ChildRemoved:Connect(function()
    Dropdown:Refresh(updataitem())
end)

local Button = Tab:CreateButton({
    Name = "传送物品到玩家位置",
    Callback = function()
        item:PivotTo(game:GetService("Players").LocalPlayer.Character.HumanoidRootPart.CFrame)
        game:GetService("ReplicatedStorage"):WaitForChild("Shared"):WaitForChild("Remotes"):WaitForChild("Drag"):WaitForChild("RequestStartDrag"):FireServer(item)
    end,
})

local Button = Tab:CreateButton({
    Name = "存物品到袋子里",
    Callback = function()
        game:GetService("ReplicatedStorage"):WaitForChild("Remotes"):WaitForChild("StoreItem"):FireServer(item)
    end,
})

local Button = Tab:CreateButton({
    Name = "固定物品到火车上（任意位置）",
    Callback = function()
        game:GetService("ReplicatedStorage"):WaitForChild("Shared"):WaitForChild("Remotes"):WaitForChild("Weld"):WaitForChild("RequestWeld"):FireServer(item,workspace:WaitForChild("Train"):WaitForChild("Platform"):WaitForChild("Part"))
    end,
})


local v = false

local Toggle = Tab:CreateToggle({
    Name = "物品透视",
    CurrentValue = false,
    Flag = "Toggle1", -- A flag is the identifier for the configuration file, make sure every element has a different flag if you're using configuration saving to ensure no overlaps
    Callback = function(Value)
        v = Value
    end,
})

game:GetService("RunService").RenderStepped:Connect(function()
    for i,itemi in ipairs(workspace:WaitForChild("RuntimeItems"):GetChildren()) do
        if v then
            if not itemi:GetAttribute("ESP") then
                itemi:SetAttribute("ESP",true)
                local bill = Instance.new("BillboardGui")
                bill.Name = "Espui"
                bill.Parent = itemi
                bill.Adornee = itemi
                bill.Size = UDim2.new(10,0,5,0)
                bill.AlwaysOnTop = true
                local textlabel = Instance.new("TextLabel")
                textlabel.Parent = bill
                textlabel.Size = UDim2.new(1,0,1,0)
                textlabel.BackgroundTransparency = 1
                textlabel.Text = itemi.Name
                textlabel.TextColor3 = Color3.new(1,1,1)
                textlabel.TextScaled = true
                local stk = Instance.new("UIStroke")
                stk.Parent = textlabel
                stk.Thickness = 2
                stk.LineJoinMode = Enum.LineJoinMode.Miter
            end
        else
            if itemi:GetAttribute("ESP") then
                itemi:SetAttribute("ESP",false)
                itemi:FindFirstChild("Espui"):Destroy()
            end
        end
    end
end)
