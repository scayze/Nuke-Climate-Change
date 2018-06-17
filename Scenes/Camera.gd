extends Camera


var rot_speed = Vector2()

func _input(event):
	if event is InputEventMouseMotion:
		if Input.is_mouse_button_pressed(BUTTON_LEFT):
			print("drag")
			rot_speed += event.relative * 0.001
			
	
	if Input.is_action_just_pressed("wheel_up"):
		translation -= translation / 20.0
	if Input.is_action_just_pressed("wheel_down"):
		translation += translation / 20.0


func _process(delta):
	var earth = get_parent().get_node("Spatial")
	
	earth.rotate_x(rot_speed.y) 
	earth.rotate_y(rot_speed.x)
	
	rot_speed /= 1 + delta * 15
	
	if Input.is_key_pressed(KEY_S):# and translation.y > -0.9:
		translation = translation.rotated(Vector3(1,0,0),delta)
	if Input.is_key_pressed(KEY_W):# and translation.y < 1.2:
		translation = translation.rotated(Vector3(1,0,0),-delta)
	if Input.is_key_pressed(KEY_D):
		translation = translation.rotated(Vector3(0,1,0),delta)
	if Input.is_key_pressed(KEY_A):
		translation = translation.rotated(Vector3(0,1,0),-delta)
	
	look_at(Vector3(0,0,0),Vector3(0,1,0))
