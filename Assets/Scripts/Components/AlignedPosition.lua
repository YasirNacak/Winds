Alignment = require "Core.Alignment"

local Component = {
  Create = function(self)
    local AlignedPosition = {
      -- Fields
      X = 0;
      Y = 0;
      Alignment = 0;
      MarginTop = 0;
      MarginRight = 0;
      MarginBottom = 0;
      MarginLeft = 0;

      -- Parent
      ParentPosX = 0;
      ParentPoxY = 0;
      ParentWidth = 0;
      ParentHeight = 0;
      ParentAlignment = 0;

      -- Methods
      SetAlignment = function(self, alignment)
        self.Alignment = alignment
      end;

      SetMargin = function(self, marginTop, marginRight, marginBottom, marginLeft)
        self.MarginTop = marginTop
        self.MarginRight = marginRight
        self.MarginBottom = marginBottom
        self.MarginLeft = marginLeft
      end;

      SetParent = function(self, parentPosX, parentPosY, parentWidth, parentHeight, parentAlignment)
        self.ParentPosX = parentPosX
        self.ParentPosY = parentPosY
        self.ParentWidth = parentWidth
        self.ParentHeight = parentHeight
        self.ParentAlignment = parentAlignment
      end;

      Apply = function(self)
        pAlign = self.ParentAlignment
        if pAlign == Alignment.TopLeft or pAlign == Alignment.MiddleLeft or pAlign == Alignment.BottomLeft then
          self.ParentPosX = self.ParentPosX 
        end

        if pAlign == Alignment.TopCenter or pAlign == Alignment.MiddleCenter or pAlign == Alignment.BottomCenter then
          self.ParentPosX = self.ParentPosX - self.ParentWidth / 2
        end

        if pAlign == Alignment.TopRight or pAlign == Alignment.MiddleRight or pAlign == Alignment.BottomRight then
          self.ParentPosX = self.ParentPosX - self.ParentWidth
        end

        if pAlign == Alignment.TopLeft or pAlign == Alignment.TopCenter or pAlign == Alignment.TopRight then
          self.ParentPosY = self.ParentPosY
        end

        if pAlign == Alignment.MiddleLeft or pAlign == Alignment.MiddleCenter or pAlign == Alignment.MiddleRight then
          self.ParentPosY = self.ParentPosY - self.ParentHeight / 2
        end

        if pAlign == Alignment.BottomLeft or pAlign == Alignment.BottomCenter or pAlign == Alignment.BottomRight then
          self.ParentPosY = self.ParentPosY - self.ParentHeight
        end

        alignment = self.Alignment 

        if alignment == Alignment.TopLeft then
          self.X = self.ParentPosX
          self.Y = self.ParentPosY
        elseif alignment == Alignment.TopCenter then
          self.X = self.ParentPosX + self.ParentWidth / 2
          self.Y = self.ParentPosY
        elseif alignment == Alignment.TopRight then
          self.X = self.ParentPosX + self.ParentWidth
          self.Y = self.ParentPosY
        elseif alignment == Alignment.MiddleLeft then
          self.X = self.ParentPosX
          self.Y = self.ParentPosY + self.ParentHeight / 2
        elseif alignment == Alignment.MiddleCenter then
          self.X = self.ParentPosX + self.ParentWidth / 2
          self.Y = self.ParentPosY + self.ParentHeight / 2
        elseif alignment == Alignment.MiddleRight then
          self.X = self.ParentPosX + self.ParentWidth
          self.Y = self.ParentPosY + self.ParentHeight / 2
        elseif alignment == Alignment.BottomLeft then
          self.X = self.ParentPosX
          self.Y = self.ParentPosY + self.ParentHeight
        elseif alignment == Alignment.BottomCenter then
          self.X = self.ParentPosX + self.ParentWidth / 2
          self.Y = self.ParentPosY + self.ParentHeight
        elseif alignment == Alignment.BottomRight then
          self.X = self.ParentPosX + self.ParentWidth
          self.Y = self.ParentPosY + self.ParentHeight
        end

        -- Reposition based on margins
        self.X = self.X + self.MarginLeft
        self.X = self.X - self.MarginRight
        self.Y = self.Y + self.MarginTop
        self.Y = self.Y - self.MarginBottom

      end;

      Update = function(self)
      end;

      DebugPrint = function(self)
        if alignment == Alignment.TopLeft then
          NativePrint("Alignment.TopLeft")
        elseif alignment == Alignment.TopCenter then
          NativePrint("Alignment.TopCenter")
        elseif alignment == Alignment.TopRight then
          NativePrint("Alignment.TopRight")
        elseif alignment == Alignment.MiddleLeft then
          NativePrint("Alignment.MiddleLeft")
        elseif alignment == Alignment.MiddleCenter then
          NativePrint("Alignment.MiddleCenter")
        elseif alignment == Alignment.MiddleRight then
          NativePrint("Alignment.MiddleRight")
        elseif alignment == Alignment.BottomLeft then
          NativePrint("Alignment.BottomLeft")
        elseif alignment == Alignment.BottomCenter then
          NativePrint("Alignment.BottomCenter")
        elseif alignment == Alignment.BottomRight then
          NativePrint("Alignment.BottomRight")
        end
      end;
    }

    return AlignedPosition
  end
}

return Component