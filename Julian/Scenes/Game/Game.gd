extends Node2D

export (PackedScene) var minion_scene

var fruits = 0

var total_time = 30

var start_room = null
var end_room = null

func _ready():
	$Level.visible = false
	$CanvasLayer/HUD.visible = false
	$CanvasLayer/GameOverScreen.visible = false
	$CanvasLayer/SplashScreen.visible = true
	
	self.get_tree().paused = true
	
	$CanvasLayer/GameOverScreen.connect("proceed", self, "on_game_over_screen_proceed")
	$CanvasLayer/SplashScreen.connect("proceed", self, "on_splash_screen_proceed")
	$CanvasLayer/HUD/Timer.connect("time_over", self, "on_timer_time_over")

func new_level() -> void:
	fruits = 0
	$CanvasLayer/HUD/Fruits/Label.text = str(fruits)
	$CanvasLayer/HUD/TeleportationEnergy/Label.text = "3"
	
	$Level/Player.teleportation_energy = $Level/Player.max_teleportation_energy
	$Level/Player.alive = true
	
	for room in $Level/Rooms.get_children():
		room.queue_free()
	
	for minion in $Level/Minions.get_children():
		minion.queue_free()
	
	$Level.generate()
	
	randomize()
	var random_room_idx
	
	random_room_idx = randi() % $Level/Rooms.get_child_count()
	self.start_room = $Level/Rooms.get_child(random_room_idx)
	
	random_room_idx = randi() % $Level/Rooms.get_child_count()
	self.end_room = $Level/Rooms.get_child(random_room_idx)
	
	var start_position = start_room.get_node("PlayerSpawnPoint").get_child(0).global_position - \
		Vector2.ONE * $Level.unit_room_size / 4
	
	$Level/Player.position = start_position
	
	$CanvasLayer/HUD/Timer.time = total_time
	$CanvasLayer/HUD/Timer.start()
	
	self.get_tree().paused = false
	
	if not $Level/Player.is_connected("moved", self, "on_Player_moved"):
		$Level/Player.connect("moved", self, "on_Player_moved")
	if not $Level/Player.is_connected("dead", self, "on_Player_dead"):
		$Level/Player.connect("dead", self, "on_Player_dead")
	if not $Level/Player.is_connected("teleported_to", self, "on_Player_teleported_to"):
		$Level/Player.connect("teleported_to", self, "on_Player_teleported_to")
	if not $Level/Player.is_connected("fruit_gathered", self, "on_Player_fruit_gathered"):
		$Level/Player.connect("fruit_gathered", self, "on_Player_fruit_gathered")
	if not $Level/Player.is_connected("teleportation_energy_changed", self, "on_Player_teleportation_energy_changed"):
		$Level/Player.connect("teleportation_energy_changed", self, "on_Player_teleportation_energy_changed")
		
	$CanvasLayer/HUD/Timer.start()
	
	yield(self.get_tree().create_timer(3), "timeout")
	
	$Level/Boss.Player = $Level/Player
	$Level/Boss.position = start_position
	
	$Level/Boss.set_process(true)

func on_splash_screen_proceed() -> void:
	$Level.visible = true
	$CanvasLayer/HUD.visible = true
	$CanvasLayer/GameOverScreen.visible = false
	$CanvasLayer/SplashScreen.visible = false
	
	new_level()

func on_game_over_screen_proceed() -> void:
	$Level.visible = true
	$CanvasLayer/HUD.visible = true
	$CanvasLayer/GameOverScreen.visible = false
	$CanvasLayer/SplashScreen.visible = false
	
	new_level()

func on_Player_finished_level() -> void:
	pass

func on_Player_moved() -> void:
	pass
	#$Level/Boss.path = $Level/Rooms.get_simple_path($Level/Boss.global_position, $Level/Player.global_position)
	#for minion in $Level/Minions.get_children():
	#	minion.path = $Level/Rooms.get_simple_path($Level/Boss.global_position, minion.global_position)

func on_Player_dead() -> void:
	$Level.visible = false
	$CanvasLayer/HUD.visible = false
	$CanvasLayer/GameOverScreen.visible = true
	$CanvasLayer/GameOverScreen/ColorRect/NotEven.visible = true
	$CanvasLayer/GameOverScreen/ColorRect/Lasted.visible = false
	$CanvasLayer/SplashScreen.visible = false
	
	$Level/Boss.set_process(false)
	
	var fruits = $CanvasLayer/HUD/Fruits/Label.text
	$CanvasLayer/GameOverScreen/ColorRect/NotEven/FruitsCollected/Label.text = fruits
	var time = $CanvasLayer/HUD/Timer.time
	$CanvasLayer/GameOverScreen/ColorRect/NotEven/OnlyLasted/Label.text = str(total_time - time)
	
	self.get_tree().paused = true

func on_Player_teleported_to(new_position : Vector2) -> void:
	
	yield(get_tree().create_timer(1.2), "timeout")
	
	$Level/Boss.global_position = new_position
	
	var start_room = null
	
	for room in $Level/Rooms.get_children():
		if room.global_position == Vector2(
			new_position.x - $Level.unit_room_size / 2,
			new_position.y + $Level.unit_room_size / 2
		):
			start_room = room
			break
	
	if start_room != null:
		for minion_spawn_point in start_room.get_node("EnemySpawnPoints").get_children():
			var minion = self.minion_scene.instance()
			minion.position = new_position - (Vector2.ONE * $Level.unit_room_size) + (minion_spawn_point.position / 2)
			minion.Player = $Level/Player
			$Level/Minions.add_child(minion)

func on_Player_fruit_gathered() -> void:
	fruits += 1
	$CanvasLayer/HUD/Fruits/Label.text = str(fruits)

func on_Player_teleportation_energy_changed(energy : int) -> void:
	$CanvasLayer/HUD/TeleportationEnergy/Label.text = str(energy)

func on_timer_time_over() -> void:
	$Level.visible = false
	$CanvasLayer/HUD.visible = false
	$CanvasLayer/GameOverScreen.visible = true
	$CanvasLayer/GameOverScreen/ColorRect/NotEven.visible = false
	$CanvasLayer/GameOverScreen/ColorRect/Lasted.visible = true
	$CanvasLayer/SplashScreen.visible = false
	
	$Level/Boss.set_process(false)
	
	var fruits = $CanvasLayer/HUD/Fruits/Label.text
	$CanvasLayer/GameOverScreen/ColorRect/Lasted/FruitsCollected/Label.text = fruits
	
	self.get_tree().paused = true
