class_name Plot extends Area2D


static var list: Array[Plot]
static var empty: Array[Plot]

var plant: Plant: set = set_plant


func _ready() -> void:
	list.append(self)
	empty.append(self)


func set_plant(value: Plant) -> void:
	plant = value
	plant.died.connect(clear_plant)
	add_child(plant)
	empty.erase(self)


func clear_plant() -> void:
	plant = null
	empty.append(self)
