class_name Plant extends Node2D


signal growth_changed
signal died

@export var data := PlantData.new()

static var list: Array[Plant]

var growth: int = 0:
	set(value):
		growth = clamp(value, -1, data.growth_max - 1)
		growth_changed.emit()

@onready var sprite: Sprite2D = $Sprite
@onready var growth_timer: Timer = $GrowthTimer


func grow() -> void:
	growth += 1
	$GrowParticles.restart()


func take_damage(amount: int) -> void:
	growth -= amount



# internal

func _ready() -> void:
	sprite.texture = data.sprite_sheet
	sprite.hframes = data.growth_max
	sprite.offset += Vector2(randf_range(-2, 2), randf_range(-2, 2))
	sprite.flip_h = randi() % 2
	
	growth_timer.start(randfn(data.growth_time, 0.5))
	growth_changed.emit()
	$GrowParticles.restart()
	
	list.append(self)


func _on_growth_changed() -> void:
	sprite.frame = maxi(growth, 0)
	
	if growth == -1:
		died.emit()
		queue_free()
	
	if growth == data.growth_max - 1:
		growth_timer.stop()
	else:
		growth_timer.start(randfn(data.growth_time, 0.5))
