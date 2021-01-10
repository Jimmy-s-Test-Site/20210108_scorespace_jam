extends KinematicBody2D

signal moved
signal finished_level
signal dead

var motion = Vector2.ZERO

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
		
		var projectile_collision = collision.collider.name == "Projectile"
		var boss_collision = collision.collider.name == "Boss"
		var minion_collision = collision.collider.name.begins_with("Minion")
		
		if projectile_collision or boss_collision or minion_collision:
			if projectile_collision:
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
