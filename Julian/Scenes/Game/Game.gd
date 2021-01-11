extends Node2D

var start_room = null
var end_room = null

func _ready():
	$Level.visible = false
	$CanvasLayer/GameOverScreen.visible = false
	$CanvasLayer/SplashScreen.visible = true
	
	self.get_tree().paused = true
	
	$CanvasLayer/GameOverScreen.connect("proceed", self, "on_game_over_screen_proceed")
	$CanvasLayer/SplashScreen.connect("proceed", self, "on_splash_screen_proceed")

func new_level() -> void:
	for room in $Level/Rooms.get_children():
		room.queue_free()
	
	var rooms = $Level.generate()
	
	randomize()
	var random_room_idx
	
	random_room_idx = randi() % $Level/Rooms.get_child_count()
	self.start_room = $Level/Rooms.get_child(random_room_idx)
	
	random_room_idx = randi() % $Level/Rooms.get_child_count()
	self.end_room = $Level/Rooms.get_child(random_room_idx)
	
	var start_position = start_room.get_node("PlayerSpawnPoint").get_child(0).global_position - \
		Vector2.ONE * $Level.unit_room_size / 4
	
	$Level/Player.position = start_position
	
	self.get_tree().paused = false
	
	if not $Level/Player.is_connected("moved", self, "on_Player_moved"):
		$Level/Player.connect("moved", self, "on_Player_moved")
	if not $Level/Player.is_connected("dead", self, "on_Player_dead"):
		$Level/Player.connect("dead", self, "on_Player_dead")
	
	yield(self.get_tree().create_timer(3), "timeout")
	
	$Level/Boss.Player = $Level/Player
	$Level/Boss.position = start_position
	
	var new_path : PoolVector2Array = $Level/Rooms.get_simple_path($Level/Boss.global_position, $Level/Player.global_position)
	$Level/Boss.path = new_path

func on_splash_screen_proceed() -> void:
	$Level.visible = true
	$CanvasLayer/GameOverScreen.visible = false
	$CanvasLayer/SplashScreen.visible = false
	
	new_level()

func on_game_over_screen_proceed() -> void:
	$Level.visible = true
	$CanvasLayer/GameOverScreen.visible = false
	$CanvasLayer/SplashScreen.visible = false
	
	new_level()

func on_Player_finished_level() -> void:
	pass

func on_Player_moved() -> void:
	var new_path : PoolVector2Array = $Level/Rooms.get_simple_path($Level/Boss.global_position, $Level/Player.global_position)
	$Level/Boss.path = new_path

func on_Player_dead() -> void:
	$Level.visible = false
	$CanvasLayer/GameOverScreen.visible = true
	$CanvasLayer/SplashScreen.visible = false
	
	self.get_tree().paused = true
