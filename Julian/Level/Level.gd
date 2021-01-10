extends Node2D

export (int) var unit_room_size : int = 20

export (float) var open_wall_percentage : float = 0.4

export (float) var battery_chances : float = 0.3
export (float) var fruit_chances : float = 0.4

export (Array, PackedScene) var rooms : Array

onready var Rooms : Node2D = $Rooms

func is_even(n : int) -> bool:
	return n % 2 == 0

func get_room_positions(length : int, maj_height : int) -> Array:
	var room_positions := []
	
	for column in range(length):
		for row in range(maj_height):
			# if on last row but is odd, then skip
			if row + 1 == maj_height and not is_even(column): break
			
			var x : float = column
			var y : float = row if is_even(column) else (float(row) + 0.5)
			
			room_positions.append([
				x * unit_room_size,
				y * unit_room_size
			])
	
	return room_positions

func instantiate_rooms(positions : Array) -> Array:
	var room_instances := []
	
	for room_pos in positions:
		var rand_room_idx = randi() % self.rooms.size()
		var new_room = self.rooms[rand_room_idx].instance()
		
		new_room.position = Vector2(room_pos[0], room_pos[1])
		new_room.size = unit_room_size
		
		for wall in new_room.get_node("Walls").get_children():
			for wall_sprite in wall.get_children():
				wall_sprite.z_index = 2
			if randf() <= open_wall_percentage:
				wall.disabled = true
				wall.visible = false
			else:
				wall.disabled = false
				wall.visible = true
		
		if room_pos[0] == 0:
			new_room.get_node("Walls/LeftUp").disabled = false
			new_room.get_node("Walls/LeftDown").disabled = false
			new_room.get_node("Walls/RightUp").disabled = false
			new_room.get_node("Walls/RightDown").disabled = false
			new_room.get_node("Walls/LeftUp").visible = true
			new_room.get_node("Walls/LeftDown").visible = true
			new_room.get_node("Walls/RightUp").visible = true
			new_room.get_node("Walls/RightDown").visible = true
		
		if room_pos[1] == 0:
			new_room.get_node("Walls/Up").disabled = false
			new_room.get_node("Walls/Up").visible = true
		
		if is_even(room_pos[0]) and room_pos[1] == 17 * unit_room_size:
			new_room.get_node("Walls/Down").disabled = false
			new_room.get_node("Walls/Down").visible = true
		elif not is_even(room_pos[0]) and room_pos[1] == 16 * unit_room_size:
			new_room.get_node("Walls/Down").disabled = false
			new_room.get_node("Walls/Down").visible = true
		
		self.Rooms.add_child(new_room)
		room_instances.append(new_room)
	
	return room_instances

func generate() -> Array:
	var positions = self.get_room_positions(26, 18)
	return self.instantiate_rooms(positions)

func _ready() -> void:
	pass
