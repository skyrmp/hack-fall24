extends Area2D


func _input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		$Sprite.offset = event.relative.normalized()
