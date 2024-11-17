class_name WaveData
extends Resource

## Total amount of good critters to spawn
@export var good_critter_amount: int
@export var bad_critter_amount: int

@export var good_critters: Array[CritterData]
@export var bad_critters: Array[CritterData]

@export var spawn_time_range: Array[float] = [0.5, 2.5]
