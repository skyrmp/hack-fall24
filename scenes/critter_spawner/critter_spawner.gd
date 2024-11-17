extends Node2D

signal wave_finished


@export var CritterScene: PackedScene
@export var wave_data: WaveData

@onready var spawn_radius = 30.0 + (get_viewport_rect().size.x * (sqrt(2)/2.0))
@onready var timer = $Timer

@onready var total_critter_amount: int = wave_data.good_critter_amount + wave_data.bad_critter_amount
@onready var critters_despawned: int = 0
## Spawn queue with good or bad stored as bools (true or false)
@onready var spawn_queue: Array[bool]


func _ready() -> void:
	spawn_queue.resize(total_critter_amount)
	for i in wave_data.good_critter_amount:
		spawn_queue[i] = true
	for i in wave_data.bad_critter_amount:
		spawn_queue[i + wave_data.good_critter_amount] = false
	spawn_queue.shuffle()
	
	
	timer.timeout.connect(try_spawn_critter)
	timer.start(wave_data.get_random_spawn_time())


func try_spawn_critter() -> void:
	spawn_critter(spawn_queue.pop_back())
	
	if not spawn_queue.is_empty():
		timer.start(wave_data.get_random_spawn_time())


func spawn_critter(is_good: bool) -> void:
	var critter = CritterScene.instantiate()
	
	# Assign stuff to critter
	critter.global_position = (Vector2.from_angle(randf_range(0.0, TAU)) * spawn_radius)
	critter.despawned.connect(increment_critters_despawned)
	
	if is_good:
		critter.critter_data = wave_data.good_critters.pick_random()
	else:
		critter.critter_data = wave_data.bad_critters.pick_random()
	
	add_child(critter)


func increment_critters_despawned(_critter: Critter) -> void:
	
	critters_despawned += 1
	if critters_despawned >= total_critter_amount:
		wave_finished.emit()
		print("DONEEEE")
		queue_free()
