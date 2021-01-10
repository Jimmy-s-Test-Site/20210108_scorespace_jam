extends Node2D

func _ready():
	new_level()

func new_level() -> void:
	var rooms = $Level.generate()
	
	var random_room_idx = randi() % rooms.size()
	var random_room = rooms[random_room_idx]
	
	$Level/Player.position = random_room.get_node("PlayerSpawnPoint").get_child(0).position
