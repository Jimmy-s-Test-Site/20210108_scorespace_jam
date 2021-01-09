extends Node2D


export (int) var unit_room_size : int = 20

export (Array, PackedScene) var rooms : Array

onready var Rooms : Node2D = $Rooms

var position_array = [
	{"size": 13, "area": 2, "y_offset": 0},
	{"size": 12, "area": 2, "y_offset": 1}
]

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

func _ready():
	self.level_layout(
		[self.Rooms, self.rooms, self.unit_room_size],
		self.position_array,
		0,
		[0, 16, 1]
	)
	
