extends Control

onready var start_screen = get_node("StartScreen")
onready var congratz = get_node("Congratz")
onready var game_over = get_node("GameOver")
onready var timer = get_node("Timer")

func _ready():
	# Called when the node is added to the scene for the first time.
	# Initialization here
	pass

func _on_Mute_toggled(button_pressed):
	if button_pressed:
		AudioServer.set_bus_volume_db(0,-10000)
	else:
		AudioServer.set_bus_volume_db(0,-24)

func set_timer(t):
	timer.text = str(t).pad_decimals(2)

func finish():
	start_screen.visible = true
	congratz.visible = true
	timer.visible = false

func game_over():
	start_screen.visible = true
	game_over.visible = true
	timer.visible = false

func _on_Start_pressed():
	get_parent().start()
	start_screen.visible = false
	congratz.visible = false
	game_over.visible = false
	timer.visible = true


func _on_Quit_pressed():
	get_parent().quit()
