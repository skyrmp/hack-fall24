extends Node2D

signal wave_finished


@export var Critter: PackedScene
@export var wave_data: WaveData

var good_critters_left: int = wave_data.good_critter_amount
var bad_critters_left: int = wave_data.bad_critter_amount

var total_critters: int = good_critters_left + bad_critters_left
var critters_despawned: int = 0

@onready var spawn_radius = 30.0 + get_viewport_rect().size.x * (sqrt(2)/2)
@onready var timer = $Timer


func _ready() -> void:
	timer.timeout.connect(spawn_critter)
	timer.start(randf_range(wave_data.spawn_time_range[0], wave_data.spawn_time_range[1]))


func spawn_critter() -> void:
	var critter = Critter.instantiate()
	
	# Assign stuff to critter
	critter.global_position = (Vector2.from_angle(randf_range(0.0, TAU)) * spawn_radius) + (get_viewport_rect().size/2)
	critter.despawned.connect(increment_critters_despawned)
	
	
	if Plot.list.size() == Plot.empty.size():
		if good_critters_left > 0:
			critter.critter_data = wave_data.good_critters.pick_random()
		else:
			# End wave if plots empty and no good critters
			# NOTE the timer will not be restarted
			total_critters -= bad_critters_left
			bad_critters_left = 0
	else:
		# Set to good or bad critter proportionally
		if good_critters_left <= randi_range(1, good_critters_left + bad_critters_left):
			critter.critter_data = wave_data.good_critters.pick_random()
		else:
			critter.critter_data = wave_data.bad_critters.pick_random()
	
	add_child(critter)
	
	if good_critters_left + bad_critters_left > 0:
		timer.start(randf_range(wave_data.spawn_time_range[0], wave_data.spawn_time_range[1]))


func increment_critters_despawned() -> void:
	critters_despawned += 1
	if critters_despawned >= total_critters:
		wave_finished.emit()
