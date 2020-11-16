Events = require "Data.Events"

AlignedPosition = require "Components.AlignedPosition"
SpriteRenderer = require "Components.SpriteRenderer"
TextRenderer = require "Components.TextRenderer"

Text = require "Entities.UI.Text"

local Entity = {
  Create = function(self)
    local TextBox = {
      -- Event
      EventManager = nil;
      
      -- Scene
      SceneManager = nil;

      --Fields
      IsEnabled = true;

      MainSpritePath = "";
      HoveredSpritePath = "";
      
      MainTextColorR = 0;
      MainTextColorG = 0;
      MainTextColorB = 0;
      
      HoveredTextColorR = 0;
      HoveredTextColorG = 0;
      HoveredTextColorB = 0;

      ShowCaret = false;
      CaretDisplayCounter = 0;
      TextContent = "";

      Width = 0;
      Height = 0;
      Group = 0;

      -- Components
      Position = nil;
      SpriteRenderer = nil;

      -- Components Array
      Components = {};

      -- Child Entities
      InnerText = nil;

      -- Child Entities Array
      Children = {};

      -- Methods
      Initialize = function(self, eventManager, sceneManager, spritePath, hoveredSpritePath, fontPath, fontSize, colorR, colorG, colorB)
        -- Initialize event manager
        self.EventManager = eventManager

        -- Initialize scene manager
        self.SceneManager = sceneManager

        self:InitializeChildren(fontPath, fontSize, colorR, colorG, colorB)
        self:InitializeComponents(spritePath, hoveredSpritePath)
      end;

      InitializeChildren = function(self, fontPath, fontSize, colorR, colorG, colorB)
        self.MainTextColorR = colorR;
        self.MainTextColorG = colorG;
        self.MainTextColorB = colorB;

        self.HoveredTextColorR = colorR + 25;
        self.HoveredTextColorG = colorG + 25;
        self.HoveredTextColorB = colorB + 25;

        self.InnerText = Text:Create()
        self.InnerText:Initialize(self.EventManager, self.SceneManager, "", fontPath, fontSize, colorR, colorG, colorB)

        table.insert(self.Children, self.InnerText)
      end;

      InitializeComponents = function(self, spritePath, hoveredSpritePath)
        -- Initialize components
        self.Position = AlignedPosition:Create()
        self.SpriteRenderer = SpriteRenderer:Create()
        self.SpriteRenderer:Load(spritePath)

        -- Initialize fields
        self.MainSpritePath = spritePath
        self.HoveredSpritePath = hoveredSpritePath
        self.Width = self.SpriteRenderer.Width
        self.Height = self.SpriteRenderer.Height

        -- Insert components into component table
        table.insert(self.Components, self.Position)
        table.insert(self.Components, self.SpriteRenderer)
      end;

      Update = function(self)
        if self.IsEnabled ~= true then
          return
        end

        NativeRenderUISprite(self.SpriteRenderer.SpritePath, self.Position.X, self.Position.Y, self.Position.Alignment, self.Group)

        IsHovering = NativeIsHoveringPosition(self.SpriteRenderer.SpritePath, self.Position.X, self.Position.Y, self.Position.Alignment)

        if IsHovering == true then
          self.SpriteRenderer:Load(self.HoveredSpritePath)
          self.InnerText.TextRenderer.ColorR = self.HoveredTextColorR
          self.InnerText.TextRenderer.ColorG = self.HoveredTextColorG
          self.InnerText.TextRenderer.ColorB = self.HoveredTextColorB
        else
          self.SpriteRenderer:Load(self.MainSpritePath)
          self.InnerText.TextRenderer.ColorR = self.MainTextColorR
          self.InnerText.TextRenderer.ColorG = self.MainTextColorG
          self.InnerText.TextRenderer.ColorB = self.MainTextColorB
        end

        InputCharacter = NativeGetCurrentInputCharacter()
        self.TextContent = self.TextContent .. InputCharacter
        self.InnerText.Text = self.TextContent

        IsBackspaceInputGiven = NativeIsBackspaceInputGiven()

        if IsBackspaceInputGiven == true  and string.len(self.TextContent) > 0 then
          self.TextContent = string.sub(self.TextContent, 0, string.len(self.TextContent) - 1)
        end

        if self.ShowCaret then
          self.InnerText.Text = self.InnerText.Text .. "|"
        end

        if self.CaretDisplayCounter == 30 then
          self.CaretDisplayCounter = 0
          if self.ShowCaret == true then
            self.ShowCaret = false
          elseif self.ShowCaret == false then
            self.ShowCaret = true
          end
        end

        self.CaretDisplayCounter = self.CaretDisplayCounter + 1

        for i, component in ipairs(self.Components) do
          component:Update()
        end

        for i, entity in ipairs(self.Children) do
          entity:Update()
        end
      end;

      SetGroup = function(self, group)
        self.Group = group
        for i, entity in ipairs(self.Children) do
          entity:SetGroup(group)
        end
      end;

      UpdatePosition = function(self, deltaX, deltaY)
        self.Position.X = self.Position.X + deltaX
        self.Position.Y = self.Position.Y + deltaY

        for i, child in ipairs(self.Children) do
          child:UpdatePosition(deltaX, deltaY)
        end
      end;
    }

    return TextBox
  end
}

return Entity