class_name Plot extends Area2D


static var list: Array[Plot]
static var empty: Array[Plot]
static var full: Array[Plot]

var plant: Plant


func _ready() -> void:
	$Sprite.frame = randi_range(0, $Sprite.hframes - 1)
	$Sprite.flip_h = randi() % 2
	$Sprite.flip_v = randi() % 2
	
	list.append(self)
	empty.append(self)


func set_plant(data: PlantData) -> void:
	plant = preload("res://scenes/plant/plant.tscn").instantiate()
	plant.data = data
	plant.died.connect(clear_plant)
	add_child(plant)
	empty.erase(self)
	full.append(self)


func clear_plant() -> void:
	plant = null
	empty.append(self)
	full.erase(self)
