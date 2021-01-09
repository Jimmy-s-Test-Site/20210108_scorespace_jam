extends Node2D

export (int) var room_unit_size : int = 20

export (Array, PackedScene) var rooms : Array

onready var Rooms : Node2D = $Rooms

var column_pattern_start_idx : int = 2
var column_pattern_curr_idx := column_pattern_start_idx
var position_array = [
	{"size":  7, "area": 3, "y_offset": 5},
	{"size": 12, "area": 2, "y_offset": 4},
	{"size":  9, "area": 3, "y_offset": 2},
	{"size":  8, "area": 4, "y_offset": 0},
	{"size":  9, "area": 3, "y_offset": 2},
	{"size":  8, "area": 4, "y_offset": 0},
	{"size":  9, "area": 3, "y_offset": 2},
	{"size": 12, "area": 2, "y_offset": 4}
]

func level_layout_cycle(x_offset : int, start : int = 0, end : int = 8) -> int:
	for column_idx in range(self.position_array.size()):
		if start > column_idx: continue
		if end <= column_idx: break
		
		self.column_pattern_start_idx = posmod(self.column_pattern_curr_idx + 1, self.position_array.size())
		
		var column = self.position_array[column_idx]
		var room_scale = column.area * self.room_unit_size
		var y_offset = self.room_unit_size * column.y_offset
		
		for room_idx in range(column.size):
			var grid_position = Vector2(column_idx, room_idx)
			var rand_room_idx = randi() % self.rooms.size()
			var new_room = self.rooms[rand_room_idx].instance()
			
			new_room.id = [grid_position.x, grid_position.y]
			new_room.size = room_scale
			new_room.position = Vector2(
				x_offset,
				y_offset + (room_scale * grid_position).y
			)
			
			self.Rooms.add_child(new_room)
		
		x_offset += self.room_unit_size * column.area
	
	return x_offset

func level_layout(start_x, cycle_start, n_loops, cycle_end):
	var x_acc = self.level_layout_cycle(start_x, cycle_start)
	for n in range(n_loops):
		x_acc = self.level_layout_cycle(x_acc)
	self.level_layout_cycle(x_acc, 0, cycle_end)

func _ready():
	self.level_layout(0, 2, 2, 4)
