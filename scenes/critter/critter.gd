
extends Area2D

class_name Critter

var mental_hp: float
var emo_resist: int

var speed: float
var mhp_speed_ratio: float

#var seed_drop_chance: int
var possible_seeds: Array[int]

func take_damage(damage: float) -> void:
	mental_hp -= damage / emo_resist
	speed = mental_hp * mhp_speed_ratio



# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass