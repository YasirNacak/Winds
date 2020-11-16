local Component = {
  Create = function(self)
    local Object = {
      -- Fields
      FontPath = "";
      FontSize = 0;
      ColorR = 0;
      ColorG = 0;
      ColorB = 0;
      Text = "";
      Width = 0;
      Height = 0;

      -- Methods
      Load = function(self, fontPath, fontSize, text, colorR, colorG, colorB)
        self.FontPath = fontPath
        self.FontSize = fontSize
        self.Text = text;
        self.ColorR = colorR
        self.ColorG = colorG
        self.ColorB = colorB

        self.Width = NativeGetTextWidth(fontPath, fontSize, text)
        self.Height = NativeGetTextHeight(fontPath, fontSize, text)
      end;

      RefreshSize = function(self)
        self.Width = NativeGetTextWidth(fontPath, fontSize, text)
        self.Height = NativeGetTextHeight(fontPath, fontSize, text)
      end;

      Update = function(self)
      end;
    }

    return Object
  end
}

return Component