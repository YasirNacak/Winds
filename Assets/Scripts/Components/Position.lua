local Component = {
  Create = function(self)
    local Position = {
      -- Fields
      X = 0;
      Y = 0;

      -- Methods
      Set = function(self, x, y)
        self.X = x
        self.Y = y      
      end;

      Update = function(self)
      end;
    }

    return Position
  end
}

return Component