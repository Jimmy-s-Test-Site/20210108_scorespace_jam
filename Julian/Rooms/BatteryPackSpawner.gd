extends Node2D

export (float) var percent_packNRG : float = .75

export (PackedScene) var battery_pack

var rng = RandomNumberGenerator.new()

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func random_spawn_position():
	rng.randomize()
		#will get a random number b/w room width
	var random_x = rng.randi_range(0,$Sprite.texture.get_width())
		#will get a random number b/w room height
	var random_y = rng.randi_range(0,$Sprite.texture.get_height())

func bPack_spawn():
	rng.randomize()
	
	if rng.randf() < percent_packNRG: #less than this then spawn
		add_child(battery_pack)
		battery_pack.position = Vector2(random_spawn_position(),random_spawn_position()) #will spawn fruit at random x&y within room
	
