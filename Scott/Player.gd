extends KinematicBody2D

signal moved
signal teleportation_energy_changed
signal fruit_gathered
signal teleported_to
signal finished_level
signal dead

var alive = true

var max_teleportation_energy = 3
var teleportation_energy = max_teleportation_energy

var motion = Vector2.ZERO

var unit_room_size

export (int) var speed : int = 30000
var axis : Vector2 = Vector2.ZERO

onready var sprite : Sprite = get_node("Place Holder")

func _ready() -> void:
	$Teleport.visible = false
	$Teleport/AnimationPlayer.connect("animation_finished", self, "on_AnimationPlayer_animation_finished")

func _physics_process(delta) -> void:
	if alive:
		get_input_axis()
		get_hurt()
		teleportation_manager()
		apply_movement(delta)
		animation_manager()

func get_input_axis():
	axis.x = int(Input.is_action_pressed("right")) - int(Input.is_action_pressed("left"))
	
	if Input.is_action_pressed("left"):
		$AnimatedSprite.flip_h = true
	if Input.is_action_pressed("right"):
		$AnimatedSprite.flip_h = false
	
	axis.y = int(Input.is_action_pressed("down")) - int(Input.is_action_pressed("up"))
	axis = axis.normalized()
	
	if axis.length() > 0.0:
		emit_signal("moved")

func get_hurt() -> void:
	for slide_idx in self.get_slide_count():
		var collision = self.get_slide_collision(slide_idx)
		
		if collision.collider != null:
			var projectile_collision = collision.collider.name.begins_with("@Projectile")
			var boss_collision = collision.collider.name == "Boss"
			var minion_collision = collision.collider.name.begins_with("Minion")
			var battery_pack_collision = collision.collider.name.begins_with("Battery_Pickup")
			var fruit_collision = collision.collider.name.begins_with("Fruit")
			
			if battery_pack_collision:
				if teleportation_energy < max_teleportation_energy:
					teleportation_energy += 1
					emit_signal("teleportation_energy_changed", teleportation_energy)
					collision.collider.queue_free()
				else:
					self.collision_mask = 0b011110
			
			if fruit_collision:
				emit_signal("fruit_gathered")
				collision.collider.queue_free()
			
			if projectile_collision or boss_collision or minion_collision:
				if projectile_collision:
					var scale_of_proj = collision.collider.scale.length()
					
					collision.collider.queue_free()
					
					if scale_of_proj < 2:
						continue
				
				if not $SFX/PlayerHit.playing:
					$SFX/PlayerHit.play()
				
				self.alive = false
				
				self.emit_signal("dead")

var clicking = false
var holding_click = false

func teleportation_manager() -> void:
	if Input.is_mouse_button_pressed(1):
		clicking = not clicking and not holding_click
	
	holding_click = Input.is_mouse_button_pressed(1)
	
	if clicking and teleportation_energy > 0:
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
			new_position.x -= unit_room_size
			if mouse_pos.y < center_of_curr_room.y: # top left
				new_position.y -= unit_room_size / 2
			if mouse_pos.y > center_of_curr_room.y: # bottom left
				new_position.y += unit_room_size / 2
		elif mouse_pos.x > room_edge.right: # right
			new_position.x += unit_room_size
			if mouse_pos.y < center_of_curr_room.y: # top right
				new_position.y -= unit_room_size / 2
			if mouse_pos.y > center_of_curr_room.y: # bottom right
				new_position.y += unit_room_size / 2
		else: # center
			if mouse_pos.y < room_edge.up: # up
				new_position.y -= unit_room_size
			if mouse_pos.y > room_edge.down: # down
				new_position.y += unit_room_size
		
		if center_of_curr_room != new_position:
			self.position = new_position
			teleportation_energy -= 1
			self.collision_mask = 0b111110
			$Teleport.visible = true
			$Teleport/AnimationPlayer.play("out")
			self.emit_signal("teleportation_energy_changed", teleportation_energy)
			self.emit_signal("teleported_to", new_position)

func apply_movement(delta):
	motion = axis * speed * delta
	motion = move_and_slide(motion)

func animation_manager():
	if motion != Vector2.ZERO:
		$AnimatedSprite.play("RunR")
	else:
		$AnimatedSprite.play("IdleF")

func on_AnimationPlayer_animation_finished() -> void:
	$Teleport.visible = false
