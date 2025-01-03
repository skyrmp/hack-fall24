extends CenterContainer

@onready var title = $VBox/Title
@onready var subtitle = $VBox/Subtitle
var text = "Scare the Crow!"
var subtext = "Click to continue!"


func _ready() -> void:
	title.text = text
	subtitle.text = subtext
	position.y = 100


func _process(delta: float) -> void:
	position = position.lerp(Vector2.ZERO, 1.0 - 0.85 ** (delta * 30.0))


func _gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.pressed:
		GameEvents.continue_clicked.emit()
		queue_free()
