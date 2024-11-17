extends Node2D

signal wave_finished


@export var CritterScene: PackedScene
@export var wave_data: WaveData

@onready var spawn_radius = 30.0 + (get_viewport_rect().size.x * (sqrt(2)/2.0))
@onready var timer = $Timer

@onready var good_critters_left: int = wave_data.good_critter_amount
@onready var bad_critters_left: int = wave_data.bad_critter_amount

@onready var total_critters: int = good_critters_left + bad_critters_left
@onready var critters_despawned: int = 0


func _ready() -> void:
	timer.timeout.connect(spawn_critter)
	timer.start(randf_range(wave_data.spawn_time_range[0], wave_data.spawn_time_range[1]))


func spawn_critter() -> void:
	var critter = CritterScene.instantiate()

	# Assign stuff to critter
	critter.global_position = (Vector2.from_angle(randf_range(0.0, TAU)) * spawn_radius)
	critter.despawned.connect(increment_critters_despawned)
	
	
	if Plot.list.size() == Plot.empty.size():
		if good_critters_left > 0:
			print(good_critters_left)
			critter.critter_data = wave_data.good_critters.pick_random()
			good_critters_left -= 1
			
			if good_critters_left == 0:
				total_critters -= bad_critters_left
				bad_critters_left = 0
		else:
			# End wave if plots empty and no good critters
			# NOTE the timer will not be restarted
			total_critters -= bad_critters_left
			bad_critters_left = 0
	else:
		# Set to good or bad critter proportionally
		if good_critters_left <= randi_range(1, good_critters_left + bad_critters_left):
			critter.critter_data = wave_data.good_critters.pick_random()
			good_critters_left -= 1
		else:
			critter.critter_data = wave_data.bad_critters.pick_random()
			bad_critters_left -= 1
	
	add_child(critter)
	
	if good_critters_left + bad_critters_left > 0:
		timer.start(randf_range(wave_data.spawn_time_range[0], wave_data.spawn_time_range[1]))


func increment_critters_despawned() -> void:
	critters_despawned += 1
	if critters_despawned >= total_critters:
		wave_finished.emit()
		print("DONEEEE")
