Events = require "Data.Events"

local EventManager = {
  Events = nil;
}

EventManager.Initialize = function(self)
  self.Events = {};

  for eventKey, eventName in pairs(Events) do
    self:AddEvent(eventName)
  end
end

EventManager.AddEvent = function(self, eventName)
  canCreate = true

  for i, event in ipairs(self.Events) do
    if event.EventName == eventName then
      NativePrint("Event Already Exists: " .. eventName)
      canCreate = false
    end
  end

  if canCreate == true then
    event = {
      EventName = eventName;
      Listeners = {};
    }

    self.Events[#self.Events + 1] = event
    NativePrint("New Event Added: " .. eventName)
  end
end;

EventManager.ListenEvent = function(self, listener, eventName)
  canListen = false

  for i, event in ipairs(self.Events) do
    if event.EventName == eventName then
      canListen = true
      table.insert(event.Listeners, listener)
      NativePrint("New Event Listener Added For: " .. eventName)
    end
  end

  if canListen == false then
    NativePrint("Can Not Listen Event Because It Is Not Added Yet: " .. eventName)
  end
end

EventManager.TriggerEvent = function(self, triggeredEvent)
  NativePrint("Event Triggered: " .. triggeredEvent.Name)

  for i, event in ipairs(self.Events) do
    if event.EventName == triggeredEvent.Name then
      for j, listener in ipairs(event.Listeners) do
        listener:HandleEvent(triggeredEvent)
      end
    end
  end
end

return EventManager