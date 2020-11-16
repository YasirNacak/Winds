Scenes = require "Data.Scenes"

local SceneManager = {
  EventManager = nil;

  Scenes = nil;
  CurrentScene = nil;
}

SceneManager.Initialize = function(self, eventManager)
  self.EventManager = eventManager
  self:InitializeScenes()

  -- Load first scene in the scenes list
  self:SetScene(self.Scenes[1])
end

SceneManager.InitializeScenes = function(self)
  self.Scenes = {}

  for i, scene in ipairs(Scenes) do
    self:AddScene(scene)
  end
end

SceneManager.AddScene = function(self, scene)
  table.insert(self.Scenes, scene)
end

SceneManager.Update = function(self)
  self.CurrentScene:Update()
end

SceneManager.SetScene = function(self, scene)
  NativePrint("Switching to scene: " .. scene.Name)

  self.EventManager:Initialize()

  self.CurrentScene = scene
  self.CurrentScene:Initialize(self.EventManager, self)
end

SceneManager.SetSceneWithName = function(self, sceneName)
  sceneFound = false
  for i, scene in ipairs(self.Scenes) do
    if scene.Name == sceneName then
      sceneFound = true
      self:SetScene(scene)
    end
  end

  if sceneFound ~= true then
    NativePrint("Scene could not be found: " .. sceneName)
  end

end

return SceneManager