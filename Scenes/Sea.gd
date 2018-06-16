extends MeshInstance
tool

# class member variables go here, for example:
# var a = 2
# var b = "textvar"

func _ready():
	# Called when the node is added to the scene for the first time.
	# Initialization here
	pass

func _process(delta):
	if Input.is_key_pressed(KEY_U):
		mesh.radius -= 0.1*delta
		print("highen")
	if Input.is_key_pressed(KEY_I):
		mesh.radius += 0.1*delta
	mesh.height = mesh.radius * 2
	
	pass
