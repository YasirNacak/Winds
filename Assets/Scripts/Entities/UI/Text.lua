Events = require "Data.Events"

AlignedPosition = require "Components.AlignedPosition"
TextRenderer = require "Components.TextRenderer"

local Entity = {
  Create = function(self)
    local Text = {
      -- Event
      EventManager = nil;
      
      -- Scene
      SceneManager = nil;

      -- Fields
      IsEnabled = true;
      Position = nil;
      TextRenderer = nil;
      Text = nil;
      Width = 0;
      Height = 0;
      Group = 0;

      -- Components Array
      Components = {};

      -- Methods
      Initialize = function(self, eventManager, sceneManager, text, fontPath, fontSize, colorR, colorG, colorB)
        -- Initialize event manager
        self.EventManager = eventManager

        -- Initialize scene manager
        self.SceneManager = sceneManager

        self:InitializeComponents(text, fontPath, fontSize, colorR, colorG, colorB)
      end;

      InitializeComponents = function(self, text, fontPath, fontSize, colorR, colorG, colorB)
        -- Initialize fields
        self.Text = text

        -- Initialize components
        self.Position = AlignedPosition:Create()
        self.TextRenderer = TextRenderer:Create()
        self.TextRenderer:Load(fontPath, fontSize, text, colorR, colorG, colorB)
        self.Width = self.TextRenderer.Width;
        self.Height = self.TextRenderer.Height;

        -- Insert components into component table
        table.insert(self.Components, self.Position)
        table.insert(self.Components, self.TextRenderer)
      end;

      Update = function(self)
        if self.IsEnabled ~= true then
          return
        end
        
        NativeRenderUIText(self.TextRenderer.FontPath, self.Text, 
          self.Position.X, self.Position.Y, 
          self.TextRenderer.FontSize, 
          self.TextRenderer.ColorR, self.TextRenderer.ColorG, self.TextRenderer.ColorB,
          self.Position.Alignment,
          self.Group)
        
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

    return Text
  end
}

return Entity