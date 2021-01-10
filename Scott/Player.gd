extends KinematicBody2D

signal moved
signal finished_level
signal dead

var motion = Vector2.ZERO

var score : int = 0
export (int) var speed : int = 30000
var axis : Vector2 = Vector2.ZERO

onready var sprite : Sprite = get_node("Place Holder")

func _physics_process(delta):
	get_input_axis()
	get_hurt()
	apply_movement(delta)
	animation_manager()

func get_input_axis():
	axis.x = int(Input.is_action_pressed("ui_right")) - int(Input.is_action_pressed("ui_left"))
	
	if Input.is_action_pressed("ui_left"):
		$AnimatedSprite.flip_h = true
	if Input.is_action_pressed("ui_right"):
		$AnimatedSprite.flip_h = false
	
	axis.y = int(Input.is_action_pressed("ui_down")) - int(Input.is_action_pressed("ui_up"))
	axis = axis.normalized()
	
	if axis.length() > 0.0:
		emit_signal("moved")

func get_hurt() -> void:
	for slide_idx in self.get_slide_count():
		var collision = self.get_slide_collision(slide_idx)
		if collision.collider.name == "Projectile":
			collision.collider.queue_free()
			
			self.emit_signal("dead")

func apply_movement(delta):
	motion = axis * speed * delta
	motion = move_and_slide(motion)

func animation_manager():
	if motion != Vector2.ZERO:
		$AnimatedSprite.play("RunR")
	else:
		$AnimatedSprite.play("IdleF")
