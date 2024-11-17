extends Node2D


@onready var scare_cooldown: TextureProgressBar = $ScareCooldown


func animate_cooldown() -> void:
	scare_cooldown.show()
	scare_cooldown.value = 0
	await get_tree().create_tween().tween_property(scare_cooldown, "value", 1, %Player.scare_cooldown.wait_time).finished
	scare_cooldown.hide()


func _input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		position = get_global_mouse_position()
