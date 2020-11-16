package.path = "..\\..\\Scripts\\?.lua;" .. package.path

-- Load managers
EventManager = require "Core.EventManager"
AssetManager = require "Core.AssetManager"
SceneManager = require "Core.SceneManager"

-- Initialize managers
AssetManager:Initialize()
SceneManager:Initialize(EventManager)

-- Engine interface
Update = function()
  SceneManager:Update()
end

GetCurrentSceneName = function()
	return SceneManager.CurrentScene.Name
end

SetScene = function(sceneName)
	SceneManager:SetSceneWithName(sceneName)
end