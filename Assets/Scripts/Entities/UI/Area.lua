Events = require "Data.Events"

AlignedPosition = require "Components.AlignedPosition"

local Entity = {
  Create = function(self)
    local Area = {
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

      -- Components Array
      Components = nil;

      -- Child Entities
      Children = nil;

      -- Methods
      Initialize = function(self, eventManager, sceneManager, width, height)
        -- Initialize event manager
        self.EventManager = eventManager

        -- Initialize scene manager
        self.SceneManager = sceneManager

        self.Children = {}

        self:InitializeComponents(width, height)
      end;

      InitializeComponents = function(self, width, height)
        self.Components = {}

        -- Initialize fields
        self.Width = width
        self.Height = height

        -- Initialize components
        self.Position = AlignedPosition:Create()

        -- Insert components into component table
        table.insert(self.Components, self.Position)
      end;

      AddChildElement = function(self, element)
        element.Position:SetParent(self.Position.X, self.Position.Y, self.Width, self.Height, self.Position.Alignment)
        element.Position:Apply()

        table.insert(self.Children, element)
      end;

      Update = function(self)
        if self.IsEnabled ~= true then
          return
        end

        for i, component in ipairs(self.Components) do
          component:Update()
        end

        for i, child in ipairs(self.Children) do
          child:Update()
        end
      end;

      SetGroup = function(self, group)
        self.Group = group
        for i, child in ipairs(self.Children) do
          child:SetGroup(group)
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

    return Area
  end
}

return Entity