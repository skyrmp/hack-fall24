class_name Plot extends Area2D


static var list: Array[Plot]
static var empty: Array[Plot]

var plant: Plant


func _ready() -> void:
	list.append(self)
	empty.append(self)


func set_plant(data: PlantData) -> void:
	plant = preload("res://scenes/plant/plant.tscn").instantiate()
	plant.data = data
	plant.died.connect(clear_plant)
	add_child(plant)
	empty.erase(self)


func clear_plant() -> void:
	plant = null
	empty.append(self)
