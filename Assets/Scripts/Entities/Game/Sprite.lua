Events = require "Data.Events"

Position = require "Components.Position"
SpriteRenderer = require "Components.SpriteRenderer"

local Entity = {
  Create = function(self)
    local Sprite = {
      -- Event
      EventManager = nil;
      
      -- Scene
      SceneManager = nil;

      -- Fields
      IsEnabled = true;
      Width = 0;
      Height = 0;
      Layer = 0;

      -- Components
      Position = nil;
      SpriteRenderer = nil;

      -- Components Array
      Components = {};

      -- Methods
      Initialize = function(self, eventManager, sceneManager, spritePath, width, height, layer)
        -- Initialize event manager
        self.EventManager = eventManager

        -- Initialize scene manager
        self.SceneManager = sceneManager

        self:InitializeComponents(spritePath, width, height, layer)
      end;

      InitializeComponents = function(self, spritePath, width, height, layer)
        -- Initialize components
        self.Position = Position:Create()
        self.SpriteRenderer = SpriteRenderer:Create()
        self.SpriteRenderer:LoadWithSize(spritePath, width, height)
        
        -- Initialize fields
        self.Layer = layer
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

        for i, component in ipairs(self.Components) do
          component:Update()
        end

        NativeRenderSprite(self.SpriteRenderer.SpritePath, self.Position.X, self.Position.Y, self.Layer)
      end;

      SetLayer = function(self, layer)
        self.Layer = layer
      end;

      UpdatePosition = function(self, deltaX, deltaY)
        self.Position.X = self.Position.X + deltaX
        self.Position.Y = self.Position.Y + deltaY
      end;
    }

    return Sprite
  end
}

return Entity