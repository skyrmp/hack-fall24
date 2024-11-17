extends Node2D


const FARM_SIZE := Vector2i(33, 17)
const FARM_RECT: Rect2i = Rect2i(-FARM_SIZE/2, FARM_SIZE)


func _ready() -> void:
	for x: int in FARM_SIZE.x: for y: int in FARM_SIZE.y:
		var plot: Node2D = load("res://scenes/plot/plot.tscn").instantiate()
		plot.position = (Vector2i(x, y) + FARM_RECT.position) * 16
		add_child(plot)


func _on_spawn_plant_timeout() -> void:
	Plot.empty.pick_random().set_plant(load("res://resources/plants/flower.tres"))
