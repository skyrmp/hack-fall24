extends Button


func _pressed() -> void:
	if AudioServer.is_bus_mute(1):
		AudioServer.set_bus_mute(1, false)
		icon.region.position.x = 0
	else:
		AudioServer.set_bus_mute(1, true)
		icon.region.position.x = 12
	
	accept_event()
