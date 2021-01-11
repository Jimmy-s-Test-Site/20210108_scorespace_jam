extends KinematicBody2D

signal moved
signal teleported_to
signal finished_level
signal dead

var motion = Vector2.ZERO

var unit_room_size

export (int) var speed : int = 30000
var axis : Vector2 = Vector2.ZERO

onready var sprite : Sprite = get_node("Place Holder")

func _physics_process(delta):
	get_input_axis()
	get_hurt()
	teleportation_manager()
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

var clicking = false
var holding_click = false

func teleportation_manager() -> void:
	if Input.is_mouse_button_pressed(1):
		clicking = not clicking and not holding_click
	
	holding_click = Input.is_mouse_button_pressed(1)
	
	if clicking:
		var room_id_x = floor(global_position.x / unit_room_size) + 0.5
		var room_id_y = 0.0
		
		if int(room_id_x) % 2 == 0:
			room_id_y = floor(global_position.y / unit_room_size) + 0.5
		else:
			room_id_y = floor(global_position.y / unit_room_size - 0.5) + 1
		
		var room_id = Vector2(room_id_x, room_id_y)
		
		var center_of_curr_room = room_id * unit_room_size
		
		var room_edge = {
			"left" : center_of_curr_room.x - unit_room_size / 2,
			"right": center_of_curr_room.x + unit_room_size / 2,
			"up"   : center_of_curr_room.y - unit_room_size / 2,
			"down" : center_of_curr_room.y + unit_room_size / 2
		}
		
		var mouse_pos = get_global_mouse_position()
		
		var new_position = center_of_curr_room
		
		if mouse_pos.x < room_edge.left: # left
			if mouse_pos.y < center_of_curr_room.y: # top left
				new_position.x -= unit_room_size
				new_position.y -= unit_room_size / 2
			if mouse_pos.y > center_of_curr_room.y: # bottom left
				new_position.x -= unit_room_size
				new_position.y += unit_room_size / 2
		elif mouse_pos.x > room_edge.right: # right
			if mouse_pos.y < center_of_curr_room.y: # top right
				new_position.x += unit_room_size
				new_position.y -= unit_room_size / 2
			if mouse_pos.y > center_of_curr_room.y: # bottom right
				new_position.x += unit_room_size
				new_position.y += unit_room_size / 2
		else: # center
			if mouse_pos.y < room_edge.up: # up
				new_position.y -= unit_room_size
			if mouse_pos.y > room_edge.down: # down
				new_position.y += unit_room_size
		
		if center_of_curr_room != new_position:
			self.position = new_position

func apply_movement(delta):
	motion = axis * speed * delta
	motion = move_and_slide(motion)

func animation_manager():
	if motion != Vector2.ZERO:
		$AnimatedSprite.play("RunR")
	else:
		$AnimatedSprite.play("IdleF")
