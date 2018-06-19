extends MeshInstance
tool

onready var tween = get_node("Tween")
onready var clouds = get_node("Clouds")
onready var sea = get_node("Sea")
var s_factory = preload("res://Scenes/Factory.tscn")

var factories = []

var dist_from_earth = 1.05

func _ready():
	spawn()

func _process(delta):
	material_override.set_shader_param("water_level",get_node("Sea").scale.x)
	rotation.y += delta / 50.0

func factory_destroyed(f):
	factories.erase(f)
	if factories.empty():
		get_parent().get_parent().finish()

func spawn():
	for f in factories:
		f.queue_free()
	
	factories.clear()
	
	randomize()
	var r = rand_range(1,100)
	material_override.set_shader_param("seed",r)
	tween.interpolate_property(self,"scale",Vector3(0,0,0),Vector3(1,1,1),0.75,Tween.TRANS_BOUNCE,Tween.EASE_OUT)
	tween.start()
	clouds.reset(r)
	sea.scale = Vector3(1.01,1.01,1.01)
	print(r)
	
	
	for i in range(0,13):
		var rv = Vector3()
		randomize()
		rv.x = rand_range(-1,1)
		randomize()
		rv.y = rand_range(-1,1)
		randomize()
		rv.z = rand_range(-1,1)
		rv = rv.normalized()
		
		var f = s_factory.instance()
		add_child(f)
		f.global_transform.origin = rv * dist_from_earth
		f.look_at(Vector3(0,0,0),Vector3(0,1,0))
		factories.append(f)

