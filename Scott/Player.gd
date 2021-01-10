extends KinematicBody2D

var motion = Vector2.ZERO

var score : int = 0
var speed : int = 17000
var axis : Vector2 = Vector2.ZERO

onready var sprite : Sprite = get_node("Place Holder")

func _physics_process(delta):
	get_input_axis()
	apply_movement(delta)
	animation_manager()
	
func get_input_axis():
	axis.x = int(Input.is_action_pressed("move_right")) - int(Input.is_action_pressed("move_left"))
	if Input.is_action_pressed("move_left"):
		$AnimatedSprite.flip_h = true
	if Input.is_action_pressed("move_right"):
		$AnimatedSprite.flip_h = false
	axis.y = int(Input.is_action_pressed("move_down")) - int(Input.is_action_pressed("move_up"))
	axis = axis.normalized()
	
func apply_movement(delta):
	motion = axis * speed * delta
	motion = move_and_slide(motion)

func animation_manager():
	print(motion)
	if motion != Vector2.ZERO:
		$AnimatedSprite.play("RunR")
	else:
		$AnimatedSprite.play("IdleF")
