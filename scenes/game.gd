extends Node2D

const CritterSpawnerScene = preload("res://scenes/critter_spawner/critter_spawner.tscn")

@export var waves: Array[WaveData]
@export var months: Array[String]

@export var current_wave: int = 0

@export var fun_multiplier: int = 50

var points: int = 0


# At beginning of the game, wait until click, then start by instantiating CritterSpawnerScene
#	oh another thing, we need a tutorial

# await wave_finished (get points for scaring baddies away)
# get points awarded for crops
# auto grow crops
# await click to continue

func _ready() -> void:
	GameEvents.critter_scared.connect(_on_critter_scared)


func start_wave() -> void:
	pass


func finish_wave() -> void:
	var accum: int = 0
	
	for plant in Plant.list:
		accum += plant.growth
		plant.grow_fully()


func _on_critter_scared(critter: Critter) -> void:
	if not critter.is_good():
		var accum: int = 2
