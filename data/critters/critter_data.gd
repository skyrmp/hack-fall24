class_name CritterData
extends Resource

@export var is_good: bool = false

@export var max_hp: float = 1.0

@export var base_speed: float = 100.0
@export var scared_speed: float = 150.0

@export var visit_amount_range: Array[int] = [2, 5]
@export var visit_time_range: Array[float] = [1.0, 3.0]

@export var sprite_frames: SpriteFrames
@export var possible_plants: Array[PlantData]


func get_random_visit_amount() -> int:
	return randi_range(visit_amount_range[0], visit_amount_range[1])


func get_random_visit_time() -> float:
	return randf_range(visit_time_range[0], visit_time_range[1])
