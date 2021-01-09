extends Node2D

export (int) var size : int = 200 setget set_size

var neighbour_network = [
	[]
]

var id : Vector2 = Vector2.ZERO setget set_id
var neighbours : Array = []
var open_neighbours : Array = []

func set_size(value : int) -> void:
	size = value
	
	$Sprite.scale = self.size * Vector2(
		1.0 / $Sprite.texture.get_width(),
		1.0 / $Sprite.texture.get_height()
	)

func set_id(value : Vector2) -> void:
	id = value
	
	

func _ready() -> void:
	$Sprite.visible = true
