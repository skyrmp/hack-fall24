extends Area2D

# Scare Rectangle Script
@onready var scare_rectangle = $ScareRectangle

const SCARE_COOLDOWN = 120
var scare_cooldown_timer = 0

func _input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		$Sprite.offset = Vector2(0, -16) + event.relative.normalized()
	
	if event.is_action_pressed("scare"):
		if scare_cooldown_timer <= 0:
			var mouse_to_scarecrow = scare_rectangle.position.angle_to_point(get_global_mouse_position())
			
			scare_rectangle.change_rotation(mouse_to_scarecrow)
			scare_rectangle.scare_critter_list()
			
			scare_cooldown_timer = SCARE_COOLDOWN
			#Code where to spawn / activate Scare Rectangle after conditions are met
			
			
		# We can have cute code here to indicate that the cooldown hasn't finished yet
		
func _process(_delta):
	#Cooldown Timer
	if scare_cooldown_timer != 0:
		scare_cooldown_timer -= 1
	
	
