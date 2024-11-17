extends Node2D


signal scared_critters

# Scare Rectangle Script
@onready var scare_rectangle = $ScareRectangle
@onready var scare_particles: GPUParticles2D = $ScareRectangle/ScareParticles
@onready var scare_cooldown: Timer = $ScareTimer

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		$Sprite.offset = Vector2(0, -16) + get_local_mouse_position().normalized()
	
	if event.is_action_pressed("scare"):
		if scare_cooldown.is_stopped():
			
			scare_rectangle.scare_critter_list()
			
			scare_particles.process_material.angle_min = rad_to_deg(-scare_rectangle.rotation)
			scare_particles.process_material.angle_max = scare_particles.process_material.angle_min
			scare_particles.restart()
		
			scared_critters.emit()
			scare_cooldown.start()
			#Code where to spawn / activate Scare Rectangle after conditions are met
		
		
		# We can have cute code here to indicate that the cooldown hasn't finished yet
