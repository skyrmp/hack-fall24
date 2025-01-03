class_name Critter
extends Area2D

signal despawned(critter: Critter)

enum {MOVING, VISITING, LEAVING, SCARED}

const MoodAlert = preload("res://scenes/mood_alert/mood_alert.tscn")
const Seed = preload("res://scenes/seed/seed.tscn")

@export var critter_data: CritterData

@export var hp: float
@export var speed: float
@export var current_plant: PlantData

@onready var visible_notifier = $VisibleOnScreenNotifier2D

var state: int:
	set(value):
		_start_state(value)
		state = value

var target_plot: Plot
var target_edge_direction: Vector2

var visit_duration: float
var visit_ratio: float = 0.0:
	set(value):
		visit_ratio = clampf(value, 0.0, 1.0)

var plots_to_visit: int
var plots_visited: int = 0

@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D


func _ready() -> void:
	$VisibleOnScreenNotifier2D.screen_exited.connect(despawn)
	_setup_critter_data()
	pick_target_plot()


func _setup_critter_data() -> void:
	hp = critter_data.max_hp
	speed = critter_data.base_speed
	sprite.sprite_frames = critter_data.sprite_frames
	
	plots_to_visit = critter_data.get_random_visit_amount()
	
	if not current_plant: current_plant = critter_data.possible_plants.pick_random()


## Picks a plot to go to. Also sets state
func pick_target_plot() -> void:
	if not is_good() and not Plot.full.is_empty():
		target_plot = Plot.full.pick_random()
	else:
		target_plot = Plot.list.pick_random()
		
	sprite.play("Move")
	state = MOVING


func pick_target_edge_point() -> void:
	# For bugfix: kill immediately if trying to leave and already not onscreen
	if not visible_notifier.is_on_screen():
		despawn()
		return
	
	if global_position.length_squared() < 4.0:
		target_edge_direction = Vector2.from_angle(randf_range(0.0, TAU))
	target_edge_direction = global_position.normalized()
	
	if target_edge_direction == Vector2.ZERO:
		target_edge_direction = Vector2.from_angle(randf_range(0.0, TAU))


func _start_state(p_state: int) -> void:
	match p_state:
		MOVING:
			pass
			
		VISITING:
			visit_ratio = 0.0
			visit_duration = critter_data.get_random_visit_time()
			
		LEAVING:
			speed = critter_data.base_speed
			pick_target_edge_point()
			
		SCARED:
			speed = critter_data.scared_speed
			pick_target_edge_point()
			if is_good():
				drop_seed()
			
			GameEvents.critter_scared.emit(self)


func _physics_process(delta: float) -> void:
	match state:
		MOVING:
			_move_towards_plot(delta)
		VISITING:
			_visit_plot(delta)
		LEAVING:
			_leave(delta)
		SCARED:
			_leave(delta)


func _move_towards_plot(delta: float) -> void:
	global_position = global_position.move_toward(target_plot.global_position, delta * speed)
	
	if target_plot.global_position.x > global_position.x:
		sprite.flip_h = true
	elif target_plot.global_position.x < global_position.x:
		sprite.flip_h = false
		
	if target_plot.global_position - global_position == Vector2.ZERO:
		sprite.play("Idle")
		state = VISITING


func _visit_plot(delta: float) -> void:
	
	visit_ratio += (delta / visit_duration) * (hp / critter_data.max_hp)
	if not is_good() and target_plot.plant and sprite.animation != "Eat":
		sprite.play("Eat")
	
	if visit_ratio == 1.0:
		# Kill plant if bad critter
		if not is_good() and target_plot.plant:
			target_plot.plant.kill()
		
		plots_visited += 1
		if plots_visited >= plots_to_visit:
			sprite.play("Move")
			state = LEAVING
		else:
			pick_target_plot()


func _leave(delta: float) -> void:
	if target_edge_direction == Vector2.ZERO:
		target_edge_direction = Vector2.from_angle(randf_range(0.0, TAU))
	
	if target_edge_direction.x >= 0:
		sprite.flip_h = true
	else:
		sprite.flip_h = false
	global_position += target_edge_direction * delta * speed


func take_damage(damage: float = 1.0) -> void:
	hp -= damage
	speed = critter_data.base_speed * (hp / critter_data.max_hp)
	if hp <= 0.0:
		hp = 0.0
		target_plot = null
		sprite.play("Move" , 9)
		state = SCARED
	
	var mood_alert = MoodAlert.instantiate()
	mood_alert.set_ratio(hp/critter_data.max_hp)
	mood_alert.position.y -= 8
	add_child(mood_alert)
	
	if not is_good():
		$AckEvil.play()


func get_eat_ratio() -> float:
	return visit_ratio


func is_good() -> bool:
	return critter_data.is_good


func drop_seed() -> void:
	var plots = get_overlapping_areas()
	
	for i in range(plots.size() - 1, -1, -1):
			if (not plots[i] is Plot) or plots[i].plant:
				plots.remove_at(i)
	
	if plots.is_empty():
		return
	
	var plot: Plot = plots.pick_random()
	plot.set_plant(current_plant)
	
	var _seed = Seed.instantiate()
	_seed.global_position = global_position
	get_tree().current_scene.add_child(_seed)
	_seed.global_position = plot.global_position
	
	GameEvents.plant_spawned.emit(plot)


func despawn() -> void:
	despawned.emit(self)
	queue_free()
