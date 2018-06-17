extends MeshInstance

var cloud_level_speed = 0.002

func _process(delta):
	scale.x += cloud_level_speed*delta
	scale.y += cloud_level_speed*delta
	scale.z += cloud_level_speed*delta