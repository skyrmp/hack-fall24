class_name CritterData
extends Resource

@export var is_good: bool = false

@export var max_hp: float = 1.0
@export var base_speed: float = 100.0

@export var scared_speed: float = 150.0

@export var eat_speed: float = 1.0

@export var visit_amount_range: Array[int] = [2, 5]
@export var visit_wait_range: Array[float] = [0.5, 3.0]

@export var sprite_frames: SpriteFrames
@export var possible_plants: Array[PlantData]
