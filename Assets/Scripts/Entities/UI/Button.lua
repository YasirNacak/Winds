Events = require "Data.Events"

AlignedPosition = require "Components.AlignedPosition"
SpriteRenderer = require "Components.SpriteRenderer"
TextRenderer = require "Components.TextRenderer"

Text = require "Entities.UI.Text"

local Entity = {
  Create = function(self)
    local Button = {
      -- Event
      EventManager = nil;
      
      -- Scene
      SceneManager = nil;

      --Fields
      IsEnabled = true;
      MainSpritePath = "";
      HoveredSpritePath = "";
      OnClickCallback = nil;
      MainTextColorR = 0;
      MainTextColorG = 0;
      MainTextColorB = 0;
      HoveredTextColorR = 0;
      HoveredTextColorG = 0;
      HoveredTextColorB = 0;

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
      Initialize = function(self, eventManager, sceneManager, spritePath, hoveredSpritePath, onClickCallback, text, fontPath, fontSize, colorR, colorG, colorB)
        -- Initialize event manager
        self.EventManager = eventManager

        -- Initialize scene manager
        self.SceneManager = sceneManager

        self:InitializeChildren(text, fontPath, fontSize, colorR, colorG, colorB)
        self:InitializeComponents(spritePath, hoveredSpritePath, onClickCallback)
      end;

      InitializeChildren = function(self, text, fontPath, fontSize, colorR, colorG, colorB)
        self.MainTextColorR = colorR;
        self.MainTextColorG = colorG;
        self.MainTextColorB = colorB;

        self.HoveredTextColorR = colorR + 25;
        self.HoveredTextColorG = colorG + 25;
        self.HoveredTextColorB = colorB + 25;

        self.InnerText = Text:Create()
        self.InnerText:Initialize(self.EventManager, self.SceneManager, text, fontPath, fontSize, colorR, colorG, colorB)

        table.insert(self.Children, self.InnerText)
      end;

      InitializeComponents = function(self, spritePath, hoveredSpritePath, onClickCallback)
        -- Initialize components
        self.Position = AlignedPosition:Create()
        self.SpriteRenderer = SpriteRenderer:Create()
        self.SpriteRenderer:Load(spritePath)

        -- Initialize fields
        self.OnClickCallback = onClickCallback
        self.MainSpritePath = spritePath
        self.HoveredSpritePath = hoveredSpritePath
        self.Width = self.SpriteRenderer.Width
        self.Height = self.SpriteRenderer.Height

        -- Insert components into component table
        table.insert(self.Components, self.Position)
        table.insert(self.Components, self.SpriteRenderer)
      end;

      InitializeInnerText = function(self, alignment)
        parentPosX = self.Position.X
        parentPosY = self.Position.Y
        parentWidth = self.Width
        parentHeight = self.Height
        self.InnerText.Position:SetParent(parentPosX, parentPosY, parentWidth, parentHeight, self.Position.Alignment)
        self.InnerText.Position:SetAlignment(alignment)
        self.InnerText.Position:Apply()
      end;

      Update = function(self)
        if self.IsEnabled ~= true then
          return
        end

        NativeRenderUISprite(self.SpriteRenderer.SpritePath, self.Position.X, self.Position.Y, self.Position.Alignment, self.Group)

        IsClicking = NativeIsClickingPosition(self.SpriteRenderer.SpritePath, self.Position.X, self.Position.Y, self.Position.Alignment)

        if IsClicking == true then
          if self.OnClickCallback ~= nil then
            self.OnClickCallback(self.SceneManager.CurrentScene)
          end
        end

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

    return Button
  end
}

return Entity