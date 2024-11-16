extends Area2D


# Called when the node enters the scene tree for the first time.

var critter_list = []
func _ready():
	monitoring = false
	
	#func scare_critter_list
	pass # Replace with function body.

func change_rotation(angle):
	rotation = (angle + PI/2)
	pass

func scare_critter_list():
	monitoring = true
	critter_list = get_overlapping_areas()
	for critter in critter_list:
		critter.take_damage()
	monitoring = false

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass
