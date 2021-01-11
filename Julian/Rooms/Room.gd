extends Node2D

export (int) var size : int = 200 setget set_size
export (int) var percent_froot : int = 100
export (int) var percent_minion : int = 100

var id : Array = [0, 0] setget set_id
var rng = RandomNumberGenerator.new()

func set_size(value : int) -> void:
	size = value
	
	var new_scale = self.size * Vector2(
		1.0 / $Sprite.texture.get_width(),
		1.0 / $Sprite.texture.get_height()
	)
	
	$Sprite.scale = new_scale
	
	for wall in $Walls.get_children():
		wall.position *= new_scale
		wall.scale = new_scale

func set_id(value : Array) -> void:
	id = value

func _ready() -> void:
	$Sprite.visible = true
