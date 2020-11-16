Events = require "Data.Events"

Text = require "Entities.UI.Text"
Button = require "Entities.UI.Button"
TextBox = require "Entities.UI.TextBox"
SpriteWidget = require "Entities.UI.Sprite"
List = require "Entities.UI.List"
Area = require "Entities.UI.Area"

Alignment = require "Core.Alignment"
ListLayout = require "Core.ListLayout"

local Scene = {
  -- Managers
  EventManager = nil;
  SceneManager = nil;

  -- Handlers
  EventHandlers = nil;

  -- Scene Metadata
  Name = "Menu";
  LongName = "Boulder Dash!";

  -- Entities
  Background = nil;
  TitleText = nil;
  PlayButton = nil;
  EnterAreaTestButton = nil;
  ExitButton = nil;
  InputLabelText = nil;
  InputTextBox = nil;

  -- Entity Array
  Entities = nil;
}

Scene.Initialize = function(self, eventManager, sceneManager)
  self.EventManager = eventManager
  self.SceneManager = sceneManager

  NativeSetWindowTitle(self.LongName)

  self:InitializeEntities()
  self:InitializeEventHandlers()
end

Scene.InitializeEntities = function(self)
  self.Entities = {};

  windowWidth = NativeGetWindowWidth()
  windowHeight = NativeGetWindowHeight()

  self:InitializeBackground()
  self:InitializeTitleText()
  self:InitializePlayButton()
  self:InitializeEnterAreaTestButton()
  self:InitializeExitButton()
  self:InitializeInputLabelText()
  self:InitializeInputTextBox()
end

Scene.InitializeBackground = function(self)
  -- Background
  self.Background = SpriteWidget:Create()
  self.Background:Initialize(self.EventManager, self.SceneManager, "Sprites/background.png")
  self.Background.Position:SetParent(0, 0, windowWidth, windowHeight, Alignment.TopLeft)
  self.Background.Position:SetAlignment(Alignment.MiddleCenter)
  self.Background.Position:Apply()

  table.insert(self.Entities, self.Background)
end

Scene.InitializeTitleText = function(self)
  -- TitleText
  self.TitleText = Text:Create()
  self.TitleText:Initialize(self.EventManager, self.SceneManager, "Boulder Dash", "Fonts/Dustismo.ttf", 72, 236, 218, 206)
  self.TitleText.Position:SetParent(0, 0, windowWidth, windowHeight, Alignment.TopLeft)
  self.TitleText.Position:SetMargin(100, 0, 0, 0)
  self.TitleText.Position:SetAlignment(Alignment.TopCenter)
  self.TitleText.Position:Apply()

  table.insert(self.Entities, self.TitleText)
end

Scene.InitializePlayButton = function(self)
  -- PlayButton
  self.PlayButton = Button:Create()
  self.PlayButton:Initialize(self.EventManager, self.SceneManager, "Sprites/button_default.png", "Sprites/button_hovered.png", self.OnPlayButtonClicked, "Play", "Fonts/Dustismo.ttf", 24, 147, 105, 73)
  alignment = Alignment.TopCenter
  self.PlayButton.Position:SetParent(0, 0, windowWidth, windowHeight, Alignment.TopLeft)
  self.PlayButton.Position:SetMargin(200, 0, 0, 0)
  self.PlayButton.Position:SetAlignment(alignment)
  self.PlayButton.Position:Apply()
  self.PlayButton:InitializeInnerText(Alignment.MiddleCenter)

  table.insert(self.Entities, self.PlayButton)
end

Scene.InitializeEnterAreaTestButton = function(self)
  -- EnterAreaTestButton
  self.EnterAreaTestButton = Button:Create()
  self.EnterAreaTestButton:Initialize(self.EventManager, self.SceneManager, "Sprites/button_default.png", "Sprites/button_hovered.png", self.OnEnterAreaTestButtonClicked, "Area Test", "Fonts/Dustismo.ttf", 24, 147, 105, 73)
  alignment = Alignment.TopCenter
  self.EnterAreaTestButton.Position:SetParent(0, 0, windowWidth, windowHeight, Alignment.TopLeft)
  self.EnterAreaTestButton.Position:SetMargin(275, 0, 0, 0)
  self.EnterAreaTestButton.Position:SetAlignment(alignment)
  self.EnterAreaTestButton.Position:Apply()
  self.EnterAreaTestButton:InitializeInnerText(Alignment.MiddleCenter)

  table.insert(self.Entities, self.EnterAreaTestButton)
end

Scene.InitializeExitButton = function(self)
  -- ExitButton
  self.ExitButton = Button:Create()
  self.ExitButton:Initialize(self.EventManager, self.SceneManager, "Sprites/button_default.png", "Sprites/button_hovered.png", self.OnExitButtonClicked, "Exit", "Fonts/Dustismo.ttf", 24, 147, 105, 73)
  alignment = Alignment.TopCenter
  self.ExitButton.Position:SetParent(0, 0, windowWidth, windowHeight, Alignment.TopLeft)
  self.ExitButton.Position:SetMargin(350, 0, 0, 0)
  self.ExitButton.Position:SetAlignment(alignment)
  self.ExitButton.Position:Apply()
  self.ExitButton:InitializeInnerText(Alignment.MiddleCenter)

  table.insert(self.Entities, self.ExitButton)
end

Scene.InitializeInputLabelText = function(self)
  -- InputLabelText
  self.InputLabelText = Text:Create()
  self.InputLabelText:Initialize(self.EventManager, self.SceneManager, "Your Name Is:", "Fonts/Dustismo.ttf", 24, 236, 218, 206)
  self.InputLabelText.Position:SetParent(0, 0, windowWidth, windowHeight)
  self.InputLabelText.Position:SetMargin(0, 0, 120, 0)
  self.InputLabelText.Position:SetAlignment(Alignment.BottomCenter)
  self.InputLabelText.Position:Apply()

  table.insert(self.Entities, self.InputLabelText)
end

Scene.InitializeInputTextBox = function(self)
  -- InputTextBox
  self.InputTextBox = TextBox:Create()
  self.InputTextBox:Initialize(self.EventManager, self.SceneManager, "Sprites/button_default.png", "Sprites/button_hovered.png", "Fonts/Dustismo.ttf", 24, 147, 105, 73)
  alignment = Alignment.BottomCenter
  self.InputTextBox.Position:SetParent(0, 0, windowWidth, windowHeight, Alignment.TopLeft)
  self.InputTextBox.Position:SetMargin(0, 0, 50, 0)
  self.InputTextBox.Position:SetAlignment(Alignment.BottomCenter)
  self.InputTextBox.Position:Apply()
  parentPosX = self.InputTextBox.Position.X
  parentPosY = self.InputTextBox.Position.Y
  parentWidth = self.InputTextBox.SpriteRenderer.Width
  parentHeight = self.InputTextBox.SpriteRenderer.Height
  self.InputTextBox.InnerText.Position:SetParent(parentPosX, parentPosY, parentWidth, parentHeight, alignment)
  self.InputTextBox.InnerText.Position:SetMargin(0, 0, 0, 25)
  self.InputTextBox.InnerText.Position:SetAlignment(Alignment.MiddleLeft)
  self.InputTextBox.InnerText.Position:Apply()

  table.insert(self.Entities, self.InputTextBox)
end

Scene.InitializeEventHandlers = function(self)
  self.EventHandlers = {}

  -- Example of how to initialize an event handler
  -- self:ListenEvent(Events.PlayerDamaged, self.OnPlayerDamaged)
end

Scene.Update = function(self)
  for i, entity in ipairs(self.Entities) do
    entity:Update()
  end
end

Scene.OnPlayButtonClicked = function(self)
  self.SceneManager:SetSceneWithName("Level")
end

Scene.OnEnterAreaTestButtonClicked = function(self)
  self.SceneManager:SetSceneWithName("Scene_3")
end

Scene.OnExitButtonClicked = function(self)
  NativeExit()
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