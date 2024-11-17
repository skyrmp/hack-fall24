extends Node2D


func _on_spawn_plant_timeout() -> void:
	Plot.empty.pick_random().set_plant(load("res://resources/plants/flower.tres"))
