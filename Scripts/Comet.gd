extends KinematicBody

var speed = 1
var hit = false

onready var particles = get_node("Particles")
onready var mesh = get_node("Icosphere")
onready var anim = get_node("AnimationPlayer")

func _ready():
	mesh.material_override = mesh.material_override.duplicate()
	anim.play("Spawn")

func _process(delta):
	speed += delta * 3
	if get_tree().root.get_node("Main").state != get_tree().root.get_node("Main").GameState.GAME: queue_free()
	pass

func hit_earth():
	print("comet hit earth")
	hit = true
	particles.speed_scale = 0.1
	get_tree().root.get_node("Main").n_cam.screen_shake(10)

func _physics_process(delta):
	if hit: return
	
	if move_and_collide((-global_transform.origin).normalized() * speed * delta):
		hit_earth()
