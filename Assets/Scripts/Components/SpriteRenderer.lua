local Component = {
  Create = function(self)
    local SpriteRenderer = {
      -- Fields
      SpritePath = "";
      Width = 0;
      Height = 0;

      -- Methods
      Load = function(self, spritePath)
        self.SpritePath = spritePath
        self.Width = NativeGetSpriteWidth(self.SpritePath)
        self.Height = NativeGetSpriteHeight(self.SpritePath)
      end;

      LoadWithSize = function(self, spritePath, width, height)
        self.SpritePath = spritePath
        self.Width = width
        self.Height = height
      end;

      Update = function(self)
      end;
    }

    return SpriteRenderer
  end
}

return Component