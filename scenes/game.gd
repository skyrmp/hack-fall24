extends Node2D

const CritterSpawnerScene = preload("res://scenes/critter_spawner/critter_spawner.tscn")
const ContinueText = preload("res://title.tscn")

enum Month {
	START = -1,
	MARCH,
	APRIL,
	MAY,
	JUNE,
	JULY,
	AUGUST,
	SEPTEMBER,
	OCTOBER,
	NOVEMBER,
	DECEMBER,
	JANUARY,
	FEBRUARY,
	END,
}

const SPRING_PALETTE: PackedColorArray = [Color("#ecc581"), Color("#b17057"), Color("#53b067"), Color("#2e8263")]
const SUMMER_PALETTE: PackedColorArray = [Color("#e8d2ab"), Color("#d59d74"), Color("#8cbe75"), Color("#6695b0")]
const FALL_PALETTE: PackedColorArray = [Color("#ecc581"), Color("#b17057"), Color("#ff9243"), Color("#da4c4c")]
const WINTER_PALETTE: PackedColorArray = [Color("#a1b5c7"), Color("#859fc3"), Color("#bbd5d4"), Color("#859fc3")]

@export var waves: Array[WaveData]

@export var current_wave: Month = Month.START

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
	#GameEvents.plant_grew.connect(func(): %sfx.play())


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
	
	
	%sfx2.play()
	points += accum * fun_multiplier
	
	var continue_text = ContinueText.instantiate()
	continue_text.text = " "
	ui.add_child(continue_text)


func _big_score(value: int) -> void:
	big_score.text = str(value)


func _on_continue_clicked() -> void:
	if current_wave == Month.END: return
	current_wave += 1
	
	match current_wave:
		Month.MARCH:
			set_palette(SPRING_PALETTE)
		Month.JUNE:
			set_palette(SUMMER_PALETTE)
		Month.SEPTEMBER:
			set_palette(FALL_PALETTE)
		Month.DECEMBER:
			set_palette(WINTER_PALETTE)
	
	if current_wave % 3 == 0 and current_wave:
		intro_animator.play_backwards("intro")
		await intro_animator.animation_finished
		await get_tree().create_timer(0.8).timeout
		
		if current_wave == Month.END:
			%Player.hide()
			var continue_text = ContinueText.instantiate()
			continue_text.text = "Total: " + str(points)
			continue_text.subtext = "Click to play again!"
			ui.add_child(continue_text)
		
		intro_animator.play("intro")
		await intro_animator.animation_finished
	
	if current_wave == Month.END:
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
	
	await month_display.display(Month.keys()[current_wave + 1].capitalize())
	
	var critter_spawner = CritterSpawnerScene.instantiate()
	critter_spawner.wave_data = waves[current_wave]
	critter_spawner.wave_finished.connect(_on_wave_finished)
	add_child(critter_spawner)


func _on_critter_scared(critter: Critter) -> void:
	if not critter.is_good():
		var accum: int = 2
		points += accum * fun_multiplier
		score_animator.play("small_score")


func set_palette(palette: PackedColorArray) -> void:
	RenderingServer.global_shader_parameter_set("replace_dirt", palette[0])
	RenderingServer.global_shader_parameter_set("replace_dirt_detail", palette[1])
	RenderingServer.global_shader_parameter_set("replace_grass_inner", palette[2])
	RenderingServer.global_shader_parameter_set("replace_grass_outer", palette[3])
