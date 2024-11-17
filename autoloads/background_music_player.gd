extends AudioStreamPlayer

var fade_in_time: float = 1.0
var fade_out_time: float = 0.5
var fade_wait_time: float = 0.5

var _fade_tween: Tween = null


func _ready() -> void:
	bus = &"Music"


func play_bgm(p_stream: AudioStream, restart_if_same: bool = false) -> void:
	if p_stream == stream and not restart_if_same:
		return
	
	if _fade_tween:
		_fade_tween.kill()
	
	_fade_tween = _create_fade_tween(p_stream, fade_out_time, fade_wait_time, fade_in_time)


func _create_fade_tween(p_stream: AudioStream, out_time: float, wait_time: float, in_time: float) -> Tween:
	var tween = create_tween()
	tween.tween_method(_set_volume_linear, db_to_linear(volume_db), 0.0, out_time)
	tween.tween_interval(wait_time)
	tween.tween_callback(func(): stream = p_stream)
	tween.tween_method(_set_volume_linear, 0.0, 1.0, in_time)
	
	return tween


func _set_volume_linear(volume_linear: float) -> void:
	volume_db = linear_to_db(volume_linear)
