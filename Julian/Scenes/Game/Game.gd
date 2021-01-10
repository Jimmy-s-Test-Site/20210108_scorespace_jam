extends Node2D

var start_room = null
var end_room = null

func _ready():
	new_level()

func new_level() -> void:
	var rooms = $Level.generate()
	
	randomize()
	var random_room_idx
	
	random_room_idx = randi() % rooms.size()
	self.start_room = rooms[random_room_idx]
	
	random_room_idx = randi() % rooms.size()
	self.end_room = rooms[random_room_idx]
	
	var start_position = start_room.get_node("PlayerSpawnPoint").get_child(0).global_position - \
		Vector2.ONE * $Level.unit_room_size / 4
	
	$Level/Player.position = start_position
	
	yield(self.get_tree().create_timer(3), "timeout")
	$Level/Boss.Player = $Level/Player
	$Level/Boss.position = start_position
	
	var new_path : PoolVector2Array = $Level/Rooms.get_simple_path($Level/Boss.global_position, $Level/Player.global_position)
	$Level/Boss.path = new_path
	
	$Level/Player.connect("moved", self, "on_Player_moved")

func on_Player_finished_level():
	for room in $Level/Rooms.get_children():
		room.queue_free()

func on_Player_moved() -> void:
	var new_path : PoolVector2Array = $Level/Rooms.get_simple_path($Level/Boss.global_position, $Level/Player.global_position)
	$Level/Boss.path = new_path
