extends KinematicBody2D

signal moved
signal finished_level
signal got_hurt

var motion = Vector2.ZERO

var score : int = 0
export (int) var speed : int = 30000
var axis : Vector2 = Vector2.ZERO

onready var sprite : Sprite = get_node("Place Holder")

func _physics_process(delta):
	get_input_axis()
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

func apply_movement(delta):
	motion = axis * speed * delta
	motion = move_and_slide(motion)
	
	emit_signal("moved")

func animation_manager():
	if motion != Vector2.ZERO:
		$AnimatedSprite.play("RunR")
	else:
		$AnimatedSprite.play("IdleF")
