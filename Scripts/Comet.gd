extends KinematicBody

var speed = 1.5

func _ready():
	# Called when the node is added to the scene for the first time.
	# Initialization here
	pass

func _physics_process(delta):
	move_and_collide((-global_transform.origin).normalized() * speed * delta)
