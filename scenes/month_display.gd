extends Control

@onready var animator = $Animator
@onready var label = $Control/Label


func display(month: String) -> void:
	label.text = month + " " + str(Time.get_datetime_dict_from_system().year)
	
	animator.play("open")
	await animator.animation_finished
	animator.play("close")
	await animator.animation_finished
