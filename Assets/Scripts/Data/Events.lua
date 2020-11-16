local Events = {
	PlayerDamaged = "PlayerDamaged",
	PlayerDied = "PlayerDied",
}

CreateEventPlayerDamaged = function(damage)
	local EventPlayerDamaged = {
		Name = Events.PlayerDamaged;
		Damage = damage;
	}

	return EventPlayerDamaged
end

CreateEventPlayerDied = function ()
	local EventPlayerDied = {
		Name = Events.PlayerDied;
	}

	return EventPlayerDied
end

IsEventOfType = function(event, name)
  return event.Name == name
end

return Events