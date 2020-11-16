Events = require "Data.Events"

Text = require "Entities.UI.Text"
Button = require "Entities.UI.Button"
TextBox = require "Entities.UI.TextBox"
Sprite = require "Entities.UI.Sprite"
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
  Name = "Scene_3";
  LongName = "Area System Test";

  -- Entitites
  Background = nil;
  TitleText = nil;
  MainArea = nil;
  MainAreaList = nil;
  ButtonContainerArea = nil;

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

  -- Background
  self.Background = Sprite:Create()
  self.Background:Initialize(self.EventManager, self.SceneManager, "Sprites/background.png")
  self.Background.Position:SetParent(0, 0, windowWidth, windowHeight)
  self.Background.Position:SetAlignment(Alignment.MiddleCenter)
  self.Background.Position:Apply()

  -- TitleText
  self.TitleText = Text:Create()
  self.TitleText:Initialize(self.EventManager, self.SceneManager, "Area Test", "Fonts/Dustismo.ttf", 72, 236, 218, 206)
  self.TitleText.Position:SetParent(0, 0, windowWidth, windowHeight, Alignment.TopLeft)
  self.TitleText.Position:SetMargin(100, 0, 0, 0)
  self.TitleText.Position:SetAlignment(Alignment.TopCenter)
  self.TitleText.Position:Apply()

  self.ButtonContainerArea = Area:Create()
  buttonContainerWidth = NativeGetSpriteWidth("Sprites/button_default.png") * 2 + 100
  buttonContainerHeight = NativeGetSpriteHeight("Sprites/button_default.png")
  self.ButtonContainerArea:Initialize(self.EventManager, self.SceneManager, buttonContainerWidth, buttonContainerHeight)
  self.ButtonContainerArea.Position:SetParent(0, 0, windowWidth, windowHeight, Alignment.TopLeft)
  self.ButtonContainerArea.Position:SetMargin(0, 0, 50, 0)
  self.ButtonContainerArea.Position:SetAlignment(Alignment.BottomCenter)
  self.ButtonContainerArea.Position:Apply()

  -- Button Container Button Elmt
  testButton = Button:Create()
  testButton:Initialize(self.EventManager, self.SceneManager, "Sprites/button_default.png", "Sprites/button_hovered.png", self.DisableList, "Disable List", "Fonts/Dustismo.ttf", 24, 147, 105, 73)
  testButton.Position:SetAlignment(Alignment.MiddleLeft)
  testButton.Position:SetMargin(0, 75, 0, 0)
  self.ButtonContainerArea:AddChildElement(testButton)
  testButton:InitializeInnerText(Alignment.MiddleCenter)

  -- Button Container Button Elmt
  testButton = Button:Create()
  testButton:Initialize(self.EventManager, self.SceneManager, "Sprites/button_default.png", "Sprites/button_hovered.png", self.EnableList, "Enable List", "Fonts/Dustismo.ttf", 24, 147, 105, 73)
  testButton.Position:SetAlignment(Alignment.MiddleRight)
  testButton.Position:SetMargin(0, 0, 0, 75)
  self.ButtonContainerArea:AddChildElement(testButton)
  testButton:InitializeInnerText(Alignment.MiddleCenter)

  -- Button Container Button Elmt
  testButton = Button:Create()
  testButton:Initialize(self.EventManager, self.SceneManager, "Sprites/button_default.png", "Sprites/button_hovered.png", self.OnGoBackButtonClicked, "Go Back", "Fonts/Dustismo.ttf", 24, 147, 105, 73)
  testButton.Position:SetAlignment(Alignment.MiddleCenter)
  self.ButtonContainerArea:AddChildElement(testButton)
  testButton:InitializeInnerText(Alignment.MiddleCenter)

  -- Insert all entities into table
  table.insert(self.Entities, self.Background)
  table.insert(self.Entities, self.TitleText)
  table.insert(self.Entities, self.ButtonContainerArea)
  
  self:InitializeMainArea()
end

Scene.InitializeMainArea = function(self)
  -- MainArea
  self.MainArea = Area:Create()
  mainAreaWidth = NativeGetSpriteWidth("Sprites/frame.png")
  mainAreaHeight = NativeGetSpriteHeight("Sprites/frame.png")
  self.MainArea:Initialize(self.EventManager, self.SceneManager, mainAreaWidth, mainAreaHeight)
  self.MainArea.Position:SetParent(0, 0, windowWidth, windowHeight, Alignment.TopLeft)
  self.MainArea.Position:SetMargin(180, 0, 0, 0)
  self.MainArea.Position:SetAlignment(Alignment.TopCenter)
  self.MainArea.Position:Apply()

  -- Main Area Inner Sprite
  mainAreaSprite = Sprite:Create()
  mainAreaSprite:Initialize(self.EventManager, self.SceneManager, "Sprites/frame.png")
  mainAreaSprite.Position:SetAlignment(Alignment.MiddleCenter)
  self.MainArea:AddChildElement(mainAreaSprite)

  -- Main Area Title Text
  mainAreaTitleText = Text:Create()
  mainAreaTitleText:Initialize(self.EventManager, self.SceneManager, "Area Title", "Fonts/Dustismo.ttf", 36, 160, 118, 90)
  mainAreaTitleText.Position:SetAlignment(Alignment.TopCenter)
  mainAreaTitleText.Position:SetMargin(15, 0, 0, 0)
  self.MainArea:AddChildElement(mainAreaTitleText)

  -- Main Area List
  mainAreaList = List:Create()
  mainAreaList:Initialize(self.EventManager, self.SceneManager, mainAreaWidth, mainAreaHeight - 65, ListLayout.Vertical, Alignment.TopCenter)
  mainAreaList.Position:SetAlignment(Alignment.TopCenter)
  mainAreaList.Position:SetMargin(65, 0, 5, 0)
  self.MainArea:AddChildElement(mainAreaList)
  self.MainAreaList = mainAreaList

  -- Main Area List Button Elmt
  testButton = Button:Create()
  testButton:Initialize(self.EventManager, self.SceneManager, "Sprites/button_default.png", "Sprites/button_hovered.png", nil, "Button 1", "Fonts/Dustismo.ttf", 24, 147, 105, 73)
  mainAreaList:AddElement(testButton, 0)
  testButton:InitializeInnerText(Alignment.MiddleCenter)

  -- Main Area List Button Elmt
  testButton = Button:Create()
  testButton:Initialize(self.EventManager, self.SceneManager, "Sprites/button_default.png", "Sprites/button_hovered.png", nil, "Button 2", "Fonts/Dustismo.ttf", 24, 147, 105, 73)
  mainAreaList:AddElement(testButton, 20)
  testButton:InitializeInnerText(Alignment.MiddleCenter)

  -- Main Area List Button Elmt
  testButton = Button:Create()
  testButton:Initialize(self.EventManager, self.SceneManager, "Sprites/button_default.png", "Sprites/button_hovered.png", nil, "Button 3", "Fonts/Dustismo.ttf", 24, 147, 105, 73)
  mainAreaList:AddElement(testButton, 20)
  testButton:InitializeInnerText(Alignment.MiddleCenter)

  -- Main Area List Button Elmt
  testButton = Button:Create()
  testButton:Initialize(self.EventManager, self.SceneManager, "Sprites/button_default.png", "Sprites/button_hovered.png", nil, "Button 4", "Fonts/Dustismo.ttf", 24, 147, 105, 73)
  mainAreaList:AddElement(testButton, 20)
  testButton:InitializeInnerText(Alignment.MiddleCenter)

  -- Main Area List Text Elmt
  mainAreaListTextElmt = Text:Create()
  mainAreaListTextElmt:Initialize(self.EventManager, self.SceneManager, "Area Item 1", "Fonts/Dustismo.ttf", 24, 170, 128, 100)
  mainAreaList:AddElement(mainAreaListTextElmt, 20)

  -- Main Area List Sprite Elmt
  mainAreaListSpriteElmt = Sprite:Create()
  mainAreaListSpriteElmt:Initialize(self.EventManager, self.SceneManager, "Sprites/button_default.png")
  mainAreaList:AddElement(mainAreaListSpriteElmt, 0)

  -- Main Area List Text Elmt
  mainAreaListTextElmt = Text:Create()
  mainAreaListTextElmt:Initialize(self.EventManager, self.SceneManager, "Area Item 2", "Fonts/Dustismo.ttf", 24, 170, 128, 100)
  mainAreaList:AddElement(mainAreaListTextElmt, 15)

  -- Main Area List Sprite Elmt
  mainAreaListSpriteElmt = Sprite:Create()
  mainAreaListSpriteElmt:Initialize(self.EventManager, self.SceneManager, "Sprites/button_default.png")
  mainAreaList:AddElement(mainAreaListSpriteElmt, 0)

  -- Main Area List Text Elmt
  mainAreaListTextElmt = Text:Create()
  mainAreaListTextElmt:Initialize(self.EventManager, self.SceneManager, "Area Item 3", "Fonts/Dustismo.ttf", 24, 170, 128, 100)
  mainAreaList:AddElement(mainAreaListTextElmt, 15)

  -- Main Area List Sprite Elmt
  mainAreaListSpriteElmt = Sprite:Create()
  mainAreaListSpriteElmt:Initialize(self.EventManager, self.SceneManager, "Sprites/button_default.png")
  mainAreaList:AddElement(mainAreaListSpriteElmt, 0)

  -- Main Area List Text Elmt
  mainAreaListTextElmt = Text:Create()
  mainAreaListTextElmt:Initialize(self.EventManager, self.SceneManager, "Area Item 4", "Fonts/Dustismo.ttf", 24, 170, 128, 100)
  mainAreaList:AddElement(mainAreaListTextElmt, 15)

  -- Main Area List Sprite Elmt
  mainAreaListSpriteElmt = Sprite:Create()
  mainAreaListSpriteElmt:Initialize(self.EventManager, self.SceneManager, "Sprites/button_default.png")
  mainAreaList:AddElement(mainAreaListSpriteElmt, 0)

  -- Main Area List Text Elmt
  mainAreaListTextElmt = Text:Create()
  mainAreaListTextElmt:Initialize(self.EventManager, self.SceneManager, "Area Item 5", "Fonts/Dustismo.ttf", 24, 170, 128, 100)
  mainAreaList:AddElement(mainAreaListTextElmt, 15)

  -- Main Area List Sprite Elmt
  mainAreaListSpriteElmt = Sprite:Create()
  mainAreaListSpriteElmt:Initialize(self.EventManager, self.SceneManager, "Sprites/button_default.png")
  mainAreaList:AddElement(mainAreaListSpriteElmt, 0)

  -- Main Area List Text Elmt
  mainAreaListTextElmt = Text:Create()
  mainAreaListTextElmt:Initialize(self.EventManager, self.SceneManager, "Area Item 6", "Fonts/Dustismo.ttf", 24, 170, 128, 100)
  mainAreaList:AddElement(mainAreaListTextElmt, 15)

  -- Main Area List Sprite Elmt
  mainAreaListSpriteElmt = Sprite:Create()
  mainAreaListSpriteElmt:Initialize(self.EventManager, self.SceneManager, "Sprites/button_default.png")
  mainAreaList:AddElement(mainAreaListSpriteElmt, 0)

    -- Main Area List Text Elmt
  mainAreaListTextElmt = Text:Create()
  mainAreaListTextElmt:Initialize(self.EventManager, self.SceneManager, "Area Item 7", "Fonts/Dustismo.ttf", 24, 170, 128, 100)
  mainAreaList:AddElement(mainAreaListTextElmt, 15)

  -- Main Area List Sprite Elmt
  mainAreaListSpriteElmt = Sprite:Create()
  mainAreaListSpriteElmt:Initialize(self.EventManager, self.SceneManager, "Sprites/button_default.png")
  mainAreaList:AddElement(mainAreaListSpriteElmt, 0)

  -- Main Area List Text Elmt
  mainAreaListTextElmt = Text:Create()
  mainAreaListTextElmt:Initialize(self.EventManager, self.SceneManager, "Area Item 8", "Fonts/Dustismo.ttf", 24, 170, 128, 100)
  mainAreaList:AddElement(mainAreaListTextElmt, 15)

  -- Main Area List Sprite Elmt
  mainAreaListSpriteElmt = Sprite:Create()
  mainAreaListSpriteElmt:Initialize(self.EventManager, self.SceneManager, "Sprites/button_default.png")
  mainAreaList:AddElement(mainAreaListSpriteElmt, 0)

  -- Main Area List Text Elmt
  mainAreaListTextElmt = Text:Create()
  mainAreaListTextElmt:Initialize(self.EventManager, self.SceneManager, "Area Item 9", "Fonts/Dustismo.ttf", 24, 170, 128, 100)
  mainAreaList:AddElement(mainAreaListTextElmt, 15)

  -- Main Area List Sprite Elmt
  mainAreaListSpriteElmt = Sprite:Create()
  mainAreaListSpriteElmt:Initialize(self.EventManager, self.SceneManager, "Sprites/button_default.png")
  mainAreaList:AddElement(mainAreaListSpriteElmt, 0)

  -- Main Area List Text Elmt
  mainAreaListTextElmt = Text:Create()
  mainAreaListTextElmt:Initialize(self.EventManager, self.SceneManager, "Area Item 10", "Fonts/Dustismo.ttf", 24, 170, 128, 100)
  mainAreaList:AddElement(mainAreaListTextElmt, 15)

  -- Main Area List Sprite Elmt
  mainAreaListSpriteElmt = Sprite:Create()
  mainAreaListSpriteElmt:Initialize(self.EventManager, self.SceneManager, "Sprites/button_default.png")
  mainAreaList:AddElement(mainAreaListSpriteElmt, 0)

  mainAreaList.Position:Apply()
  mainAreaListGroup = NativeCreateRenderGroup(mainAreaList.Width, mainAreaList.Height, mainAreaList.Position.X, mainAreaList.Position.Y)
  mainAreaList:SetGroup(mainAreaListGroup)

  table.insert(self.Entities, self.MainArea)
end

Scene.InitializeEventHandlers = function(self)
  self.EventHandlers = {}

  -- Example of how to initialize an event handler
  -- self:ListenEvent(Events.PlayerDamaged, self.OnPlayerDamaged)
end

Scene.OnGoBackButtonClicked = function(self)
  self.SceneManager:SetSceneWithName("Menu")
end

Scene.EnableList = function(self)
  self.MainAreaList.IsEnabled = true
end

Scene.DisableList = function(self)
  self.MainAreaList.IsEnabled = false
end

Scene.Update = function(self)
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