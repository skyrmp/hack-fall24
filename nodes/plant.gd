class_name Plant extends Node2D


signal growth_changed

@export var data := PlantData.new()

static var list: Array[Plant]

var growth: int = 0:
	set(value):
		growth = clamp(value, 0, data.growth_max - 1)
		growth_changed.emit()

@onready var sprite: Sprite2D = $Sprite
@onready var growth_timer: Timer = $GrowthTimer


func grow() -> void:
	growth += 1


func take_damage(amount: int) -> void:
	growth -= amount


func is_dead() -> bool:
	return growth <= 0



# internal

func _ready() -> void:
	sprite.texture = data.sprite_sheet
	sprite.hframes = data.growth_max
	growth_timer.start(data.growth_time)
	growth_changed.emit()
	
	list.append(self)


func _on_growth_changed() -> void:
	sprite.frame = growth
