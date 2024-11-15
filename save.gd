extends Node


var file: ConfigFile = ConfigFile.new()


func read() -> void:
	file.load("user://save.cfg")

	# file.get_value(section, key, default)


func write() -> void:
	file.save("user://save.cfg")



# internal

func _ready() -> void:
	read()