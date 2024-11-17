extends Node2D


signal scared_critters

# Scare Rectangle Script
@onready var scare_rectangle = $ScareRectangle
@onready var scare_particles: GPUParticles2D = $ScareRectangle/ScareParticles
@onready var scare_cooldown: Timer = $ScareTimer

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		$Sprite.offset = Vector2(0, -16) + get_local_mouse_position().normalized()
	
	elif event.is_action_pressed("scare"):
		if scare_cooldown.is_stopped():
			
			scare_rectangle.scare_critter_list()
			
			scare_particles.process_material.angle_min = rad_to_deg(-scare_rectangle.rotation)
			scare_particles.process_material.angle_max = scare_particles.process_material.angle_min
			scare_particles.restart()
			
			var mood_alert: Node2D = preload("res://scenes/mood_alert/mood_alert.tscn").instantiate()
			mood_alert.set_level(2)
			mood_alert.position.y = -40
			add_child(mood_alert)
			
			$Dzuwmp.play()
			
			scared_critters.emit()
			scare_cooldown.start()
			#Code where to spawn / activate Scare Rectangle after conditions are met
		
		
		# We can have cute code here to indicate that the cooldown hasn't finished yet
