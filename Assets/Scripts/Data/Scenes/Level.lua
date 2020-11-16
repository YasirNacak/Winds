Events = require "Data.Events"

Text = require "Entities.UI.Text"
Button = require "Entities.UI.Button"
TextBox = require "Entities.UI.TextBox"
SpriteWidget = require "Entities.UI.Sprite"
List = require "Entities.UI.List"
Area = require "Entities.UI.Area"

GameSprite = require "Entities.Game.Sprite"

Alignment = require "Core.Alignment"

local Scene = {
  -- Managers
  EventManager = nil;
  SceneManager = nil;

  -- Handlers
  EventHandlers = nil;

  -- Scene Metadata
  Name = "Level";
  LongName = "";

  -- Fields
  GridWidth = 0;
  GridHeight = 0;
  SelectedEntity = nil;
  WindowWidth = 0;
  WindowHeight = 0;
  MoveAreaSize = 0;
  CameraMovementSpeed = 0;
  MoveOffsetX = 0;
  MoveOffsetY = 0;
  ScrolledX = 0;
  ScrolledY = 0;

  -- Entitites
  GoBackButton = nil;
  GridElements = nil;
  Player = nil;

  -- Entity Array
  Entities = nil;
}

Scene.Initialize = function(self, eventManager, sceneManager)
  self.EventManager = eventManager
  self.SceneManager = sceneManager

  self.WindowWidth = NativeGetWindowWidth()
  self.WindowHeight = NativeGetWindowHeight()
  self.MoveAreaSize = 75
  self.CameraMovementSpeed = 10

  self:InitializeEntities()
  self:InitializeEventHandlers()
end

Scene.SetLevelTitle = function(self, levelTitle)
  self.LongName = levelTitle
  NativeSetWindowTitle(self.LongName)
end

Scene.InitializeEntities = function(self)
  self.Entities = {};


  -- GoBackButton
  self.GoBackButton = Button:Create()
  self.GoBackButton:Initialize(self.EventManager, self.SceneManager, "Sprites/button_default.png", "Sprites/button_hovered.png", self.OnGoBackButtonClicked, "Go Back", "Fonts/Dustismo.ttf", 24, 147, 105, 73)
  alignment = Alignment.BottomCenter
  self.GoBackButton.Position:SetParent(0, 0, self.WindowWidth, self.WindowHeight, Alignment.TopLeft)
  self.GoBackButton.Position:SetAlignment(alignment)
  self.GoBackButton.Position:SetMargin(0, 0, 50, 0)
  self.GoBackButton.Position:Apply()
  self.GoBackButton:InitializeInnerText(Alignment.MiddleCenter)

  self.GridWidth = 64
  self.GridHeight = 64

  self.GridElements = {}
  for i = 0, 40, 1 do
    for j = 0, 22, 1 do
      gridElmt = GameSprite:Create()
      gridElmt:Initialize(self.EventManager, self.SceneManager, "Sprites/64x64_base_grid.png", self.GridWidth, self.GridHeight, 0)
      gridElmt:UpdatePosition(i * self.GridWidth, j * self.GridHeight)
      table.insert(self.Entities, gridElmt)
      table.insert(self.GridElements, gridElmt)
    end
  end

  self.Player = GameSprite:Create()
  self.Player:Initialize(self.EventManager, self.SceneManager, "Sprites/64x64_player.png", self.GridWidth, self.GridHeight, 1)

  -- Insert all entities into table
  table.insert(self.Entities, self.GoBackButton)
  table.insert(self.Entities, self.Player)
end

Scene.InitializeEventHandlers = function(self)
  self.EventHandlers = {}

  -- Example of how to initialize an event handler
  -- self:ListenEvent(Events.PlayerDamaged, self.OnPlayerDamaged)
end

Scene.OnGoBackButtonClicked = function(self)
  self.SceneManager:SetSceneWithName("Menu")
end

Scene.Update = function(self)

  mouseX, mouseY = NativeGetMousePosition()

  self.MoveOffsetX = 0
  self.MoveOffsetY = 0

  if mouseX < self.MoveAreaSize then
    self.MoveOffsetX = self.CameraMovementSpeed
  elseif mouseX > self.WindowWidth - self.MoveAreaSize then
    self.MoveOffsetX = -1 * self.CameraMovementSpeed
  end
  
  self.ScrolledX = self.ScrolledX + self.MoveOffsetX

  if mouseY < self.MoveAreaSize then
    self.MoveOffsetY = self.CameraMovementSpeed
  elseif mouseY > self.WindowHeight - self.MoveAreaSize then
    self.MoveOffsetY = -1 * self.CameraMovementSpeed
  end

  self.ScrolledY = self.ScrolledY + self.MoveOffsetY

  if self.MoveOffsetX ~= 0 or self.MoveOffsetY ~= 0 then
    for i, gElmt in ipairs(self.GridElements) do
      gElmt:UpdatePosition(self.MoveOffsetX, self.MoveOffsetY)
    end

    self.Player:UpdatePosition(self.MoveOffsetX, self.MoveOffsetY)
  end

  IsUpDown = NativeIsKeyDown("UpArrow")
  IsLeftDown = NativeIsKeyDown("LeftArrow")
  IsDownDown = NativeIsKeyDown("DownArrow")
  IsRightDown = NativeIsKeyDown("RightArrow")

  if IsUpDown == true then
    self.Player:UpdatePosition(0, -self.GridHeight)
  elseif IsLeftDown == true then
    self.Player:UpdatePosition(-self.GridWidth, 0)
  elseif IsDownDown == true then
    self.Player:UpdatePosition(0, self.GridHeight)
  elseif IsRightDown == true then
    self.Player:UpdatePosition(self.GridWidth, 0)
  end

  for i, entity in ipairs(self.Entities) do
    entity:Update()
  end
end

Scene.ListenEvent = function(self, event, callback)
  self.EventManager:ListenEvent(self, event)
  handler = {
    Event = event;
    Callback = callback;
  };
  table.insert(self.EventHandlers, handler)
end;

Scene.HandleEvent = function(self, event)
  for i, handler in ipairs(self.EventHandlers) do
    if IsEventOfType(event, handler.Event) then
      handler:Callback(event)
    end
  end
end;

return Scene