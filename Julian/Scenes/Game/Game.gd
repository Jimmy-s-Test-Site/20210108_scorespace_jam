extends Node2D

var start_room = null
var end_room = null

func _ready():
	$Level.visible = false
	$CanvasLayer/SplashScreen.visible = true
	
	$Level.set_process(false)
	$Level/Player.set_physics_process(false)
	$Level/Boss.set_process(false)
	
	$CanvasLayer/SplashScreen.connect("proceed", self, "on_splash_screen_proceed")

func _process(delta : float) -> void:
	pass

func teleport() -> void:
	pass

func new_level() -> void:
	for room in $Level/Rooms.get_children():
		room.queue_free()
	
	var rooms = $Level.generate()
	
	randomize()
	var random_room_idx
	
	random_room_idx = randi() % rooms.size()
	self.start_room = rooms[random_room_idx]
	
	random_room_idx = randi() % rooms.size()
	self.end_room   = rooms[random_room_idx]
	
	var start_position = start_room.get_node("PlayerSpawnPoint").get_child(0).global_position - \
		Vector2.ONE * $Level.unit_room_size / 4
	
	$Level/Player.position = start_position
	
	yield(self.get_tree().create_timer(3), "timeout")
	$Level/Boss.Player = $Level/Player
	$Level/Boss.position = start_position
	
	var new_path : PoolVector2Array = $Level/Rooms.get_simple_path($Level/Boss.global_position, $Level/Player.global_position)
	$Level/Boss.path = new_path
	
	$Level/Player.connect("moved", self, "on_Player_moved")
	$Level/Player.connect("dead", self, "on_Player_dead")

func on_splash_screen_proceed() -> void:
	$Level.visible = true
	$CanvasLayer/SplashScreen.visible = false
	
	$Level.set_process(true)
	$Level/Player.set_physics_process(true)
	$Level/Boss.set_process(true)
	
	new_level()

func on_Player_finished_level() -> void:
	for room in $Level/Rooms.get_children():
		room.queue_free()

func on_Player_moved() -> void:
	var new_path : PoolVector2Array = $Level/Rooms.get_simple_path($Level/Boss.global_position, $Level/Player.global_position)
	$Level/Boss.path = new_path

func on_Player_dead() -> void:
	$Level.visible = false
	$CanvasLayer/SplashScreen.visible = true
	
	$Level.set_process(false)
	$Level/Player.set_physics_process(false)
	$Level/Boss.set_process(false)
	
	$Level/Player.global_position = Vector2(-100, 0)
	$Level/Boss.global_position = Vector2(0, -100)
