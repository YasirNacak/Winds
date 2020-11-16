Sprites = require "Data.Sprites"
Fonts = require "Data.Fonts"

local AssetManager = {
}

AssetManager.Initialize = function(self)
  self:InitializeSprites()
  self:InitializeFonts()
  self:InitializeSounds()
end

AssetManager.InitializeSprites = function(self)
  for i, sprite in ipairs(Sprites) do
    NativeLoadSprite(sprite)
  end
end

AssetManager.InitializeFonts = function(self)
	for i, font in ipairs(Fonts) do
		font_path = font.Path
		font_size = font.Size;
		NativeLoadFont(font_path, font_size)
	end
end

AssetManager.InitializeSounds = function(self)
end

return AssetManager