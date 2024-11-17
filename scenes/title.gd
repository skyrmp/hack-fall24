extends CenterContainer


func _gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.pressed:
		queue_free()
