extends KinematicBody2D

var direction = Vector2.ZERO
export (int) var speed := 50

func _ready():
	z_index = 2
	
	self.scale /= 20
	
	yield(get_tree().create_timer(10), "timeout")
	
	self.queue_free()

func _physics_process(delta):
	move_and_collide(direction * speed * delta)
	self.scale += delta * Vector2.ONE
	
	self.rotate(deg2rad(2))
	
	if self.scale.length() > 5.0:
		self.scale = Vector2.ONE * 5
