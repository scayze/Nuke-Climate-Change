extends Camera

var s_comet = preload("res://Scenes/Comet.tscn")

onready var n_earth = get_node("../Spatial/Earth")

const comet_spawn_dist = 2.5
var rot_speed = Vector2()

#Screen shake stuff
var start_pos
var screen_shake_amount = 0.0
var max_screen_shake = 3
var timer = 0.0
const screen_shake_decrease = 8

func _ready():
	start_pos = translation

func _physics_process(delta):
	if get_parent().state == get_parent().GameState.START: return
	if Input.is_action_just_pressed("click"):
		var from = project_ray_origin(get_viewport().get_mouse_position())
		var to = from + project_ray_normal(get_viewport().get_mouse_position()) * 1000
		var space_state = get_world().direct_space_state
		var result = space_state.intersect_ray(from,to)
		if result.size():
			var c = s_comet.instance()
			n_earth.add_child(c)
			c.global_transform.origin = result["position"].normalized() * comet_spawn_dist
			c.look_at(Vector3(0,0,0),Vector3(0,1,0))
			
			
			print(result["position"])

func screen_shake(strength):
	screen_shake_amount += strength

func _process(delta):
	#Screen Shake
	screen_shake_amount -= screen_shake_decrease * delta
	screen_shake_amount = clamp(screen_shake_amount,0,max_screen_shake)
	timer += delta * 35
	fov = 70 - sin(timer) * screen_shake_amount * 0.5
	
	#Rotate earth TODO: Move this in earthes script
	var earth = get_parent().get_node("Spatial")
	earth.rotate_x(rot_speed.y) 
	earth.rotate_y(rot_speed.x)
	rot_speed /= 1 + delta * 15


func _input(event):
	if event is InputEventMouseMotion:
		if Input.is_mouse_button_pressed(BUTTON_RIGHT):
			rot_speed += event.relative * 0.001
	
	if Input.is_action_just_pressed("wheel_up"):
		translation -= translation / 20.0
	if Input.is_action_just_pressed("wheel_down"):
		translation += translation / 20.0
