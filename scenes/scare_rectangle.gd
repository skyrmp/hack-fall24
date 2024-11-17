extends Area2D


# Called when the node enters the scene tree for the first time.

var critter_list = []
var can_rotate:bool = true
@onready var timer = $Timer
func _ready():
	
	#func scare_critter_list
	pass # Replace with function body.

func _physics_process(_delta: float) -> void:
	if timer.is_stopped():
		can_rotate = true
	if can_rotate:
		var mouse_to_scarecrow = position.angle_to_point(get_global_mouse_position())
		change_rotation(mouse_to_scarecrow)


func change_rotation(angle):
	rotation = (angle + PI/2)
	pass

func scare_critter_list():
	can_rotate = false
	timer.start()
	critter_list = get_overlapping_areas()
	for critter in critter_list:
		critter.take_damage()
		

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass
