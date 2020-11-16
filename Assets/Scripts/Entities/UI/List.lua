Events = require "Data.Events"

AlignedPosition = require "Components.AlignedPosition"

ListLayout = require "Core.ListLayout"

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
      CurrentArea = 0;
      CurrentScrolled = 0;
      Layout = nil;
      ChildrenAlignment = nil;
      Group = 0;

      -- Components
      Position = nil;

      -- Components Array
      Components = nil;

      -- Elements
      Children = nil;

      -- Methods
      Initialize = function(self, eventManager, sceneManager, width, height, layout, childrenAlignment)
        -- Initialize event manager
        self.EventManager = eventManager

        -- Initialize scene manager
        self.SceneManager = sceneManager

        self.Children = {};

        self:InitializeComponents(width, height, layout, childrenAlignment)
      end;

      InitializeComponents = function(self, width, height, layout, childrenAlignment)
        self.Components = {};

        -- Initialize fields
        self.Width = width
        self.Height = height
        self.Layout = layout
        self.ChildrenAlignment = childrenAlignment

        -- Initialize components
        self.Position = AlignedPosition:Create()

        -- Insert components into component table
        table.insert(self.Components, self.Position)
      end;

      AddElement = function(self, element, margin)
        element.Position:SetParent(self.Position.X, self.Position.Y, self.Width, self.Height, self.Position.Alignment)

        if self.Layout == ListLayout.Vertical then
          element.Position:SetMargin(self.CurrentArea + margin, 0, 0, 0)
          self.CurrentArea = self.CurrentArea + element.Height + margin
        elseif self.Layout == ListLayout.Horizontal then
          element.Position:SetMargin(0, 0, 0, self.CurrentArea + margin)
          self.CurrentArea = self.CurrentArea + element.Width + margin
        end

        element.Position:SetAlignment(self.ChildrenAlignment)
        element.Position:Apply()

        table.insert(self.Children, element)
      end;

      Update = function(self)
        if self.IsEnabled ~= true then
          return
        end
      
        IsScrolling = NativeIsScrollingPosition(self.Width, self.Height, self.Position.X, self.Position.Y, self.Alignment)

        if IsScrolling == true then
          ScrollAmount = NativeGetScrollDirection()

          lastElement = self.Children[#self.Children]

          if (ScrollAmount > 0 and self.CurrentScrolled < 0) or (ScrollAmount < 0 and lastElement.Position.Y - self.Height + lastElement.Height > self.Position.Y) then
            for i, child in ipairs(self.Children) do
              child:UpdatePosition(0, ScrollAmount * 20)
              self.CurrentScrolled = self.CurrentScrolled + ScrollAmount
            end
          end
        end

        for i, child in ipairs(self.Children) do
          child:Update()
        end

        for i, component in ipairs(self.Components) do
          component:Update()
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