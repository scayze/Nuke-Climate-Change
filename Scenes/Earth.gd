extends MeshInstance
tool

func _ready():
	pass

func _process(delta):
	material_override.set_shader_param("water_level",get_node("Sea").scale.x)
	rotation.y += delta / 50.0