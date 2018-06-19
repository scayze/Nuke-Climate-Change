extends MeshInstance

var cloud_level_speed = 0.002

func reset(s):
	scale = Vector3(1.05,1.05,1.05)
	material_override.set_shader_param("seed",s)

func _process(delta):
	scale.x += cloud_level_speed*delta
	scale.y += cloud_level_speed*delta
	scale.z += cloud_level_speed*delta