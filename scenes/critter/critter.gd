class_name Critter
extends Area2D

var max_hp: int
var current_hp: float = max_hp

var speed: float
var hp_speed_ratio: float

#var seed_drop_chance: int
var possible_seeds: Array[int]

func take_damage(damage: float) -> void:
	current_hp -= damage
	speed = current_hp * hp_speed_ratio



# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
