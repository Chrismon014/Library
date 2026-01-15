--// GmmUI Mobile Ready
local GmmUI = {}
GmmUI.__index = GmmUI

function GmmUI.new(options)
    local self = setmetatable({}, GmmUI)
    self.Title = options.Title or "GmmUI Mobile"
    self.Menus = {}
    
    -- Crear ScreenGui
    self.Gui = Instance.new("ScreenGui")
    self.Gui.Name = "GmmUIMobile"
    self.Gui.ResetOnSpawn = false
    self.Gui.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")
    
    -- Contenedor principal
    self.MainFrame = Instance.new("Frame")
    self.MainFrame.Size = UDim2.new(0.35,0,0.45,0) -- % pantalla
    self.MainFrame.Position = UDim2.new(0.325,0,0.275,0)
    self.MainFrame.BackgroundColor3 = Color3.fromRGB(25,25,25)
    self.MainFrame.BorderSizePixel = 0
    self.MainFrame.Parent = self.Gui
    self.MainFrame.ClipsDescendants = true
    
    -- Ventana arrastrable con mouse o touch
    local dragging, dragStart, frameStart = false, nil, nil
    self.MainFrame.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            frameStart = self.MainFrame.Position
        end
    end)
    self.MainFrame.InputChanged:Connect(function(input)
        if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            local delta = input.Position - dragStart
            self.MainFrame.Position = frameStart + UDim2.new(0, delta.X, 0, delta.Y)
        end
    end)
    self.MainFrame.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = false
        end
    end)
    
    -- Título
    local titleLabel = Instance.new("TextLabel")
    titleLabel.Size = UDim2.new(1,0,0,35)
    titleLabel.BackgroundColor3 = Color3.fromRGB(15,15,15)
    titleLabel.Text = self.Title
    titleLabel.TextScaled = true
    titleLabel.TextColor3 = Color3.new(1,1,1)
    titleLabel.Font = Enum.Font.SourceSansBold
    titleLabel.Parent = self.MainFrame
    
    self.ContentFrame = Instance.new("ScrollingFrame")
    self.ContentFrame.Size = UDim2.new(1,0,1,-35)
    self.ContentFrame.Position = UDim2.new(0,0,0,35)
    self.ContentFrame.CanvasSize = UDim2.new(0,0,0,0)
    self.ContentFrame.ScrollBarThickness = 8
    self.ContentFrame.BackgroundTransparency = 1
    self.ContentFrame.Parent = self.MainFrame
    
    return self
end

-- Crear menú dentro de la librería
function GmmUI:NewMenu(name)
    local menu = {}
    menu.Name = name
    menu.Items = {}
    
    function menu:Button(text, description, callback)
        local btn = Instance.new("TextButton")
        btn.Size = UDim2.new(1, -10, 0, 40)
        btn.Position = UDim2.new(0,5,0,#self.Items*45)
        btn.BackgroundColor3 = Color3.fromRGB(40,40,40)
        btn.TextColor3 = Color3.new(1,1,1)
        btn.TextScaled = true
        btn.Font = Enum.Font.SourceSans
        btn.Text = text
        btn.Parent = self.ContentFrame
        
        btn.MouseButton1Click:Connect(callback)
        btn.TouchTap:Connect(callback) -- Soporte touch
        
        table.insert(self.Items, btn)
    end
    
    function menu:Toggle(text, callback)
        local frame = Instance.new("Frame")
        frame.Size = UDim2.new(1,-10,0,40)
        frame.Position = UDim2.new(0,5,0,#self.Items*45)
        frame.BackgroundColor3 = Color3.fromRGB(35,35,35)
        frame.Parent = self.ContentFrame
        
        local label = Instance.new("TextLabel")
        label.Size = UDim2.new(0.75,0,1,0)
        label.Text = text
        label.TextScaled = true
        label.Font = Enum.Font.SourceSans
        label.TextColor3 = Color3.new(1,1,1)
        label.BackgroundTransparency = 1
        label.Parent = frame
        
        local toggleBtn = Instance.new("TextButton")
        toggleBtn.Size = UDim2.new(0.2,0,0.6,0)
        toggleBtn.Position = UDim2.new(0.78,0,0.2,0)
        toggleBtn.BackgroundColor3 = Color3.fromRGB(100,100,100)
        toggleBtn.Text = "OFF"
        toggleBtn.TextScaled = true
        toggleBtn.Font = Enum.Font.SourceSans
        toggleBtn.Parent = frame
        
        local state = false
        local function update()
            state = not state
            toggleBtn.Text = state and "ON" or "OFF"
            callback(state)
        end
        toggleBtn.MouseButton1Click:Connect(update)
        toggleBtn.TouchTap:Connect(update)
        
        table.insert(self.Items, frame)
    end
    
    menu.ContentFrame = self.ContentFrame
    return menu
end

function GmmUI:PushMenu(menu)
    -- Ajuste de CanvasSize
    local count = #menu.Items
    self.ContentFrame.CanvasSize = UDim2.new(0,0,0,count*45)
end

return GmmUI
