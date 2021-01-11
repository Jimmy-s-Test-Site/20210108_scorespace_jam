extends Node2D

export (float) var percent_froot : float = 0.70
export (Array, PackedScene) var fruits

var rng = RandomNumberGenerator.new()

# Called when the node enters the scene tree for the first time.
func _ready():
	froot_spawn()

func froot_spawn():
	for fruit in fruits:
		rng.randomize()
		
		var newRandPos = Vector2(
			clamp(rng.randf()*1000,125,875),
			clamp(rng.randf()*1000,125,875)
			)

		if rng.randf() < percent_froot: #less than this then spawn
			var new_froot = fruit.instance()
			new_froot.position = newRandPos
			new_froot.rotation_degrees = rng.randi() % 360
			add_child(new_froot)

