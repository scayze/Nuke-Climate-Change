extends Node

onready var n_cam = get_node("Camera")
onready var n_ui = get_node("UI")
onready var n_earth= get_node("Spatial/Earth")

var timer = 10

enum GameState {
	START
	GAME
	PAUSE
}

var state = START

func _ready():
	#n_anim_ui.play("Appear")
	pass

func _process(delta):
	if state != GameState.GAME: return
	timer -= delta
	n_ui.set_timer(timer)
	if timer < 0:
		timer = 10
		game_over()

func finish():
	n_ui.finish()
	state = GameState.START

func game_over():
	n_ui.game_over()
	state = GameState.START


func quit():
	get_tree().quit()


func start():
	state = GameState.GAME
	n_earth.spawn()
