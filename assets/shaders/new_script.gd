extends Node

@export var palettes: Array[Texture2D]
var current_palette = 0


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_accept"):
		current_palette = wrapi(current_palette + 1, 0, 4)
		
		$ColorRect.material.set_shader_parameter("lut", palettes[current_palette])
