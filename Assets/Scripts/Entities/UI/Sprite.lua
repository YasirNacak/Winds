Events = require "Data.Events"

AlignedPosition = require "Components.AlignedPosition"
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
      Group = 0;

      -- Components
      Position = nil;
      SpriteRenderer = nil;

      -- Components Array
      Components = {};

      -- Methods
      Initialize = function(self, eventManager, sceneManager, spritePath)
        -- Initialize event manager
        self.EventManager = eventManager

        -- Initialize scene manager
        self.SceneManager = sceneManager

        self:InitializeComponents(spritePath)
      end;

      InitializeComponents = function(self, spritePath)
        -- Initialize components
        self.Position = AlignedPosition:Create()
        self.SpriteRenderer = SpriteRenderer:Create()
        self.SpriteRenderer:Load(spritePath)
        
        -- Initialize fields
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

        for i, component in ipairs(self.Components) do
          component:Update()
        end
      end;

      SetGroup = function(self, group)
        self.Group = group
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