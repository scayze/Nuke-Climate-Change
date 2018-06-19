extends MeshInstance

var sea_level_speed = 0.002

func _ready():
	# Called when the node is added to the scene for the first time.
	# Initialization here
	pass

func _process(delta):
	scale.x += sea_level_speed*delta
	scale.y += sea_level_speed*delta
	scale.z += sea_level_speed*delta
	
#	if scale.x > 1.1:
#		get_parent().get_parent().get_parent().game_over()
#	if Input.is_key_pressed(KEY_U):
#		scale.x -= sea_level_speed*delta * 5
#		scale.y -= sea_level_speed*delta * 5
#		scale.z -= sea_level_speed*delta * 5
#	if Input.is_key_pressed(KEY_I):
#		scale.x += sea_level_speed*delta * 5
#		scale.y += sea_level_speed*delta * 5
#		scale.z += sea_level_speed*delta * 5
