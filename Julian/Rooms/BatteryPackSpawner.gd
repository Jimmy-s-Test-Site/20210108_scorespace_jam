extends Node2D

export (float) var percent_packNRG : float = .40
export (PackedScene) var battery_pack

var rng = RandomNumberGenerator.new()

# Called when the node enters the scene tree for the first time.
func _ready():
	bPack_spawn()

func bPack_spawn():
	rng.randomize()
	
	var newRandPos = Vector2(
		clamp(rng.randf()*1000,125,875),
		clamp(rng.randf()*1000,125,875)
		)

	if rng.randf() < percent_packNRG: #less than this then spawn
		var new_battery_pack = battery_pack.instance()
		new_battery_pack.position = newRandPos
		add_child(new_battery_pack)

