extends Area2D


signal scared_critters

# Scare Rectangle Script
@onready var scare_rectangle = $ScareRectangle

@onready var scare_cooldown: Timer = $ScareTimer

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		$Sprite.offset = Vector2(0, -16) + event.relative.normalized()
	
	if event.is_action_pressed("scare"):
		if scare_cooldown.is_stopped():
			
			var mouse_to_scarecrow = scare_rectangle.position.angle_to_point(get_global_mouse_position())
			scare_rectangle.change_rotation(mouse_to_scarecrow)
			scare_rectangle.scare_critter_list()
			
			scared_critters.emit()
			scare_cooldown.start()
			#Code where to spawn / activate Scare Rectangle after conditions are met
		
		
		# We can have cute code here to indicate that the cooldown hasn't finished yet
