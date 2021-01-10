extends Node2D


export (int) var unit_room_size : int = 20

export (Array, PackedScene) var rooms : Array

onready var Rooms : Node2D = $Rooms

func is_even(n : int) -> bool:
	return n % 2 == 0

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

var naighbour_to_wall := {
	"odd_column": {
		[-1,-1]: "LeftUp",  [-1, 0]: "LeftDown",
		[ 0,-1]: "Up",      [ 0, 1]: "Down",
		[ 1,-1]: "RightUp", [ 1, 0]: "RightDown"
	},
	"even_column": {
		[-1, 0]: "LeftUp",  [-1, 1]: "LeftDown",
		[ 0,-1]: "Up",      [ 0, 1]: "Down",
		[ 1, 0]: "RightUp", [ 1, 1]: "RightDown"
	}
}

var position_array = [
	{"size": 13, "area": 2, "y_offset": 0},
	{"size": 12, "area": 2, "y_offset": 1}
]

var room_instances := {}

var walls_to_delete := []

func select_walls_to_delete(room):
	var number_of_walls_to_remove = randi() % 3
	
	var walls_to_remove_from_this_room := []
	
	var pool := []
	if is_even(room.x):
		match room.y:
			0  : pool = self.neighbour_network.even_column["first"]
			12 : pool = self.neighbour_network.even_column["last"]
			_  : pool = self.neighbour_network.even_column["else"]
	else:
		match room.y:
			0  : pool = self.neighbour_network.odd_column["first"]
			11 : pool = self.neighbour_network.odd_column["last"]
			_  : pool = self.neighbour_network.odd_column["else"]
	pool.shuffle()
	pool = pool.slice(0, number_of_walls_to_remove)
	
	var pool_in_terms_of_self := []
	
	for wall in pool:
		var wall_id = ""
		
		if is_even(room.x):
			wall_id = self.naighbour_to_wall.even_column[wall]
		else:
			wall_id = self.naighbour_to_wall.odd_column[wall]
			
		pool_in_terms_of_self.append({
			"room": room,
			"wall": wall
		})
	
	var pool_in_terms_of_other_room := []
	for wall in pool:
		var other_room_id = [
			room.x + wall[0],
			room.y + wall[1]
		]
		
		if other_room_id[0] < 0 or other_room_id[1] < 0: continue
		
		if is_even(other_room_id[0]):
			if other_room_id[1] >= 11: continue
		else:
			if other_room_id[1] >= 12: continue
		
		var other_wall_id := ""
		if is_even(room.x):
			match wall:
				[-1, 0]: other_wall_id = self.naighbour_to_wall.odd_column[[-1,-1]]
				[-1, 1]: other_wall_id = self.naighbour_to_wall.odd_column[[-1, 0]]
				[ 0,-1]: other_wall_id = self.naighbour_to_wall.odd_column[[ 0,-1]]
				[ 0, 1]: other_wall_id = self.naighbour_to_wall.odd_column[[ 0, 1]]
				[ 1, 0]: other_wall_id = self.naighbour_to_wall.odd_column[[ 1,-1]]
				[ 1, 1]: other_wall_id = self.naighbour_to_wall.odd_column[[ 1, 0]]
		else:
			match wall:
				[-1,-1]: other_wall_id = self.naighbour_to_wall.even_column[[-1, 0]]
				[-1, 0]: other_wall_id = self.naighbour_to_wall.even_column[[-1, 1]]
				[ 0,-1]: other_wall_id = self.naighbour_to_wall.even_column[[ 0,-1]]
				[ 0, 1]: other_wall_id = self.naighbour_to_wall.even_column[[ 0, 1]]
				[ 1,-1]: other_wall_id = self.naighbour_to_wall.even_column[[ 1, 0]]
				[ 1, 0]: other_wall_id = self.naighbour_to_wall.even_column[[ 1, 1]]
		
		pool_in_terms_of_other_room.append({
			"room": other_room_id,
			"wall": other_wall_id
		})
	self.walls_to_delete += pool_in_terms_of_other_room

func level_layout_cycle(
	room_settings : Array,
	position_array : Array,
	x_offset : int,
	start : int = 0,
	end : int = -1
) -> int:
	var rooms_node = room_settings[0]
	var rooms_scenes = room_settings[1]
	var unit_room_size = room_settings[2]
	
	if end == -1: end = position_array.size()
	
	for column_idx in range(position_array.size()):
		if start > column_idx: continue
		if end <= column_idx: break
		
		var column : Dictionary = position_array[column_idx]
		var room_scale : int = column.area * unit_room_size
		
		for room_idx in range(column.size):
			var grid_position = Vector2(column_idx, room_idx)
			var rand_room_idx = randi() % rooms_scenes.size()
			var new_room = rooms_scenes[rand_room_idx].instance()
			
			new_room.id = [grid_position.x, grid_position.y]
			
			self.select_walls_to_delete(grid_position)
			
			self.room_instances[new_room.id] = new_room
			
			if grid_position == Vector2(0, 0):
				print("aloha")
			
			new_room.size = room_scale
			new_room.position = Vector2(
				x_offset,
				unit_room_size * column.y_offset + room_scale * room_idx
			)
			
			rooms_node.add_child(new_room)
		
		x_offset += unit_room_size * column.area
	
	return x_offset

func level_layout(
	room_settings : Array,
	position_array : Array,
	start_x : int,
	cycle_settings : Array
) -> void:
	var cycle_start : int = cycle_settings[0]
	var n_loops : int = cycle_settings[1]
	var cycle_end : int = cycle_settings[2]
	
	var x_acc = self.level_layout_cycle(room_settings, position_array, start_x, cycle_start)
	for n in range(n_loops):
		x_acc = self.level_layout_cycle(room_settings, position_array, x_acc)
	self.level_layout_cycle(room_settings, position_array, x_acc, 0, cycle_end)

func remove_walls():
	for wall in walls_to_delete:
		print(wall.room)
		self.room_instances[wall.room].get_node("Walls").get_node(wall.wall).disabled = true

func _ready():
	self.level_layout(
		[self.Rooms, self.rooms, self.unit_room_size],
		self.position_array,
		0,
		[0, 16, 1]
	)
	self.remove_walls()
