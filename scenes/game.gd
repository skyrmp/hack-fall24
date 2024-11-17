extends Node2D

const CritterSpawnerScene = preload("res://scenes/critter_spawner/critter_spawner.tscn")
const ContinueText = preload("res://title.tscn")

@export var waves: Array[WaveData]
@export var months: Array[String]

@export var current_wave: int = -1

@export var fun_multiplier: int = 50

@onready var month_display = %MonthDisplay
@onready var ui = %UI
@onready var intro_animator = %Animator
@onready var score = %Score
@onready var score_animator = %ScoreAnimator
@onready var big_score = %BigScore

@onready var points: int = 0:
	set(value):
		points = value
		score.text = str(points)



# At beginning of the game, wait until click, then start by instantiating CritterSpawnerScene
#	oh another thing, we need a tutorial

# await wave_finished (get points for scaring baddies away)
# get points awarded for crops
# auto grow crops
# await click to continue

func _ready() -> void:
	GameEvents.continue_clicked.connect(_on_continue_clicked)
	GameEvents.critter_scared.connect(_on_critter_scared)


func _on_wave_finished() -> void:
	await get_tree().create_timer(1.5).timeout
	
	var accum: int = 0
	
	for plant in Plant.list:
		accum += plant.growth
		plant.grow_fully()
	
	var score_tween = create_tween()
	score_tween.set_ease(Tween.EASE_OUT)
	score_tween.set_trans(Tween.TRANS_QUART)
	score_tween.tween_method(_big_score, 0, accum * fun_multiplier, 0.8)
	
	score_animator.play("big_score")
	await score_animator.animation_finished
	
	points += accum * fun_multiplier
	
	var continue_text = ContinueText.instantiate()
	continue_text.text = " "
	ui.add_child(continue_text)


func _big_score(value: int) -> void:
	big_score.text = str(value)


func _on_continue_clicked() -> void:
	if current_wave == 12:
		return
	
	current_wave += 1
	
	if current_wave == 3 or current_wave == 6 or current_wave == 9 or current_wave == 12:
		intro_animator.play_backwards("intro")
		await intro_animator.animation_finished
		await get_tree().create_timer(0.8).timeout
		match current_wave:
			3:
				pass
			6:
				pass
			9:
				pass
			12:
				%Player.hide()
				var continue_text = ContinueText.instantiate()
				continue_text.text = "Total: " + str(points)
				continue_text.subtext = "Click to play again!"
				ui.add_child(continue_text)
		intro_animator.play("intro")
		await intro_animator.animation_finished
	
	if current_wave == 12:
		await GameEvents.continue_clicked
		intro_animator.play_backwards("intro")
		await intro_animator.animation_finished
		await get_tree().create_timer(0.8).timeout
		
		Plot.empty.clear()
		Plot.full.clear()
		Plot.list.clear()
		Plant.list.clear()
		get_tree().reload_current_scene()
		return
	
	await month_display.display(months[current_wave])
	
	var critter_spawner = CritterSpawnerScene.instantiate()
	critter_spawner.wave_data = waves[current_wave]
	critter_spawner.wave_finished.connect(_on_wave_finished)
	add_child(critter_spawner)


func _on_critter_scared(critter: Critter) -> void:
	if not critter.is_good():
		var accum: int = 2
		points += accum * fun_multiplier
		score_animator.play("small_score")
