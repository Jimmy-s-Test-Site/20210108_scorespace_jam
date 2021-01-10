extends Node2D


export (int) var unit_room_size : int = 20

export (float) var open_wall_percentage : float = 0.4

export (Array, PackedScene) var rooms : Array

onready var Rooms : Node2D = $Rooms

var neighbour_network := {
	"odd_column" : {
		"first": [[-1, 0], [ 0, 1], [ 1, 0]],
		"last" : [[-1,-1], [ 0,-1], [ 1,-1]],
		"else" : [[-1,-1], [-1, 0], [ 0,-1], [ 0, 1], [ 1,-1], [ 1, 0]]
	},
	"even_column" : {
		"first": [[-1, 0], [-1, 1], [ 0, 1], [ 1, 0], [ 1, 1]],
		"last" : [[-1, 0], [-1, 1], [ 0,-1], [ 1, 0], [ 1, 1]],
		"else" : [[-1, 0], [-1, 1], [ 0,-1], [ 0, 1], [ 1, 0], [ 1, 1]]
	}
}

func is_even(n : int) -> bool:
	return n % 2 == 0

func get_room_total(length : int, maj_height : int) -> int:
	var r = maj_height
	var c = length
	return 2*(r-1)*(c-1) + (r-1)*ceil(c/2) + (r-2)*floor(c/2)

func get_room_connection_total(length : int, maj_height : int) -> int:
	var lateral_connections = 2 * maj_height - 2
	var vertical_connections = 2 * length - 2
	return lateral_connections * vertical_connections

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

func get_random_room_connections(length : int, maj_height : int) -> Array:
	#return {
	#	[0,0] : [[0,1],[1,1]],
	#	[0,1] : [[0,0]],
	#	[1,1] : [[0,0]]
	#}
	
	var connections := []
	
	#for connection in range(get_room_connection_total(length, maj_height)):
	#	if randf() >= open_wall_percentage:
	#		pass
	
	return []

func get_open_walls(length : int, maj_height : int) -> Array:
	# returns {
	#     [0,0] : ["TopLeft", "Down"]
	# }
	# returns the walls that should be open
	return []

func instantiate_rooms(positions : Array, open_walls : Array) -> void:
	for room_pos in positions:
		var rand_room_idx = randi() % self.rooms.size()
		var new_room = self.rooms[rand_room_idx].instance()
		
		new_room.position = Vector2(room_pos[0], room_pos[1])
		new_room.size = unit_room_size
		
		for wall in new_room.get_node("Walls").get_children():
			if randf() <= open_wall_percentage:
				wall.disabled = true
			else:
				wall.disabled = false
			
		if room_pos[0] == 0:
			new_room.get_node("Walls/LeftUp").disabled = false
			new_room.get_node("Walls/RightUp").disabled = false
		
		if room_pos[1] == 0:
			new_room.get_node("Walls/Up").disabled = false
		
		if is_even(room_pos[0]) and room_pos[1] == 17:
			new_room.get_node("Walls/Down").disabled = false
		elif not is_even(room_pos[0]) and room_pos[1] == 16:
			new_room.get_node("Walls/Down").disabled = false
		
		self.Rooms.add_child(new_room)

func _ready() -> void:
	self.instantiate_rooms(self.get_room_positions(26, 18), [])
