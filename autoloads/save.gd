extends Node


var file: ConfigFile = ConfigFile.new()


func read(file_name = "save.cfg") -> void:
	file.load("user://" + file_name)

	# file.get_value(section, key, default)


func write(file_name = "save.cfg") -> void:
	file.save("user://" + file_name)
	
	# file.get_value(section, key, value)



# internal

func _ready() -> void:
	read()
