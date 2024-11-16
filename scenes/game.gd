extends Node2D


func add_plant(plant_name: String, pos: Vector2):
	var plant: Plant = preload("res://scenes/plant.tscn").instantiate()
	plant.data = load("res://resources/plants/%s.tres" % plant_name)
	plant.position = pos
