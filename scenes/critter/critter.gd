class_name Critter
extends Area2D

signal despawned

enum {MOVING, VISITING, LEAVING, SCARED}

const MoodAlert = preload("res://scenes/mood_alert/mood_alert.tscn")

@export var critter_data: CritterData

@export var hp: float
@export var speed: float
@export var current_plant: PlantData

var state: int:
	set(value):
		if value == LEAVING or value == SCARED:
			_pick_target_edge_point()
		if value == SCARED and critter_data.is_good:
			_drop_seed()
		if value == VISITING:
			_visit_ratio = 0.0
			_visit_duration = randf_range(critter_data.visit_wait_range[0], critter_data.visit_wait_range[1])
		
		state = value

var target_plot: Node2D

var _target_edge_point: Vector2
var _visit_ratio: float = 0.0:
	set(value):
		_visit_ratio = clampf(value, 0.0, 1.0)

var _visit_duration: float
var _plots_to_visit: int
var _plots_visited: int = 0


func _ready() -> void:
	$VisibleOnScreenNotifier2D.screen_exited.connect(despawn)
	_setup_critter_data()
	_pick_target_plot()


func _physics_process(delta: float) -> void:
	match state:
		MOVING:
			_move_towards_plot(delta)
		VISITING:
			_visit_plot(delta)
		LEAVING:
			_leave(delta)
		SCARED:
			_run_away(delta)


func take_damage(damage: float = 1.0) -> void:
	hp -= damage
	speed = critter_data.base_speed * (hp / critter_data.max_hp)
	if hp <= 0.0:
		hp = 0.0
		target_plot = null
		state = SCARED
	
	var mood_alert = MoodAlert.instantiate()
	mood_alert.set_ratio(hp/critter_data.max_hp)
	add_child(mood_alert)


func get_eat_ratio() -> float:
	return _visit_ratio


func _move_towards_plot(delta: float) -> void:
	global_position = global_position.move_toward(target_plot.global_position, delta * speed)
	if target_plot.global_position - global_position == Vector2.ZERO:
		state = VISITING


func _visit_plot(delta: float) -> void:
	if critter_data.is_good:
		_visit_ratio += (delta / _visit_duration)
		
		if _visit_ratio == 1.0:
			_plots_visited += 1
			if _plots_visited >= _plots_to_visit:
				state = LEAVING
			else:
				_pick_target_plot()
	
	# Case for bad critter
	else:
		# If plant is dead or nonexistent, reselect
		if target_plot.plant == null:
			_pick_target_plot()
			return
		
		_visit_ratio += (delta / critter_data.eat_speed) * (hp/critter_data.max_hp)
		
		if _visit_ratio == 1.0:
			target_plot.plant.take_damage(1)


func _leave(delta: float) -> void:
	global_position = global_position.move_toward(target_plot.global_position, delta * critter_data.base_speed)


func _run_away(delta: float) -> void:
	global_position = global_position.move_toward(target_plot.global_position, delta * critter_data.scared_speed)


func _setup_critter_data() -> void:
	hp = critter_data.max_hp
	speed = critter_data.base_speed
	$AnimatedSprite2D.sprite_frames = critter_data.sprite_frames
	if not critter_data.possible_plants.is_empty():
		current_plant = critter_data.possible_plants.pick_random()
	_plots_to_visit = randi_range(critter_data.visit_amount_range[0], critter_data.visit_amount_range[1])


func _drop_seed() -> void:
	var plots = get_overlapping_areas()
	
	for i in range(plots.size() - 1, -1, -1):
			if plots[i].plant:
				plots.remove_at(i)
	
	if plots.is_empty():
		return
	
	var plot: Plot = plots.pick_random()
	plot.set_plant(current_plant)


## Picks a plot to go to. Also sets state
func _pick_target_plot() -> void:
	var plots: Array = get_tree().get_nodes_in_group(&"plot")
	
	# Remove empty plots if critter is bad
	if not critter_data.is_good:
		for i in range(plots.size() - 1, -1, -1):
			if plots[i].plant == null:
				plots.remove_at(i)
	
	if plots.is_empty():
		state = LEAVING
	else:
		target_plot = plots.pick_random()
		state = MOVING


func _pick_target_edge_point() -> void:
	var screen_center: Vector2 = get_viewport_rect().size / 2.0
	_target_edge_point = Vector2(global_position - screen_center).normalized() * (get_viewport_rect().size.x * 2.0)


func despawn() -> void:
	despawned.emit()
	queue_free()
