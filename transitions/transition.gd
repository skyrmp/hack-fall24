class_name Transition
extends CanvasLayer
## Class for screen transitions with use of SceneManager.transition_to_scene()
##
## Overwrite _transition_in and _transition_out with custom behavior to use. No other changes are necessary.

## Emitted when the screen is hidden during this transition.
signal screen_hidden

## Emitted when the transition is done and perhaps no longer visible
signal ended


## Called by SceneManager to start the transition. (Hint: calls _transition_in)
func transition_in() -> void:
	@warning_ignore("redundant_await")
	await _transition_in()
	screen_hidden.emit()


## Called by SceneManager to end the transition. (Hint: calls _transition_out)
func transition_out() -> void:
	@warning_ignore("redundant_await")
	await _transition_out()
	ended.emit()


## Virtual method, should be overwritten with transition_in behavior
func _transition_in() -> void:
	pass


## Virtual method, should be overwritten with transition_out behavior
func _transition_out() -> void:
	pass
