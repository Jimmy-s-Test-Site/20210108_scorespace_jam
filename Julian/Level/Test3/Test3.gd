extends Node2D


export (int) var unit_room_size : int = 20

export (Array, PackedScene) var rooms : Array

onready var Rooms : Node2D = $Rooms

func get_room_total(length : int, maj_height : int) -> int:
	return length * maj_height - length / 2

func get_room_positions(length : int, maj_height : int) -> Array:
	# given
	# ..
	# ..??
	# ,,??
	# ,,
	# unit_room_size = 2, length = 2, maj_height = 2
	return []

func get_room_connections(length : int, maj_height : int) -> Array:
	#return {
	#	[0,0] : [[0,1],[1,1]],
	#	[0,1] : [[0,0]],
	#	[1,1] : [[0,0]]
	#}
	return []

func get_open_walls(length : int, maj_height : int) -> Array:
	# returns {
	#     [0,0] : ["TopLeft", "Down"]
	# }
	# returns the walls that should be open
	return []

func instantiate_rooms(positions : Array, open_walls : Array) -> void:
	pass

func _ready() -> void:
	print(get_room_total(12, 13))
