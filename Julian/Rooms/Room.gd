extends Node2D

export (int) var size : int = 200 setget set_size

var neighbour_network := {
	"odd_column" : {
		"first": [[-1, 0], [ 0, 1], [ 1, 0]],
		"last" : [[-1,-1], [ 0,-1], [ 1,-1]],
		"else" : [[-1,-1], [-1, 0], [ 0,-1], [ 0, 1], [ 1,-1], [ 1, 0]]
	},
	"even_column" : {
		"first": [[-1, 0], [-1, 1], [ 0, 1], [ 1, 0], [ 1, 1]],
		"last" : [[-1, 0], [-1, 1], [ 0,-1], [ 1, 0], [ 1, 1]],
		"else" : [[-1, 0], [-1, 1], [ 0,-1], [ 0, 1], [ 1, 0], [ 1, 1]]
	}
}

var naighbour_to_wall := {
	"odd_column": {
		[-1,-1]: "LeftUp",  [-1, 0]: "LeftDown",
		[ 0,-1]: "Up",      [ 0, 1]: "Down",
		[ 1,-1]: "RightUp", [ 1, 0]: "RightDown"
	},
	"even_column": {
		[-1, 0]: "LeftUp",  [-1, 1]: "LeftDown",
		[ 0,-1]: "Up",      [ 0, 1]: "Down",
		[ 1, 0]: "RightUp", [ 1, 1]: "RightDown"
	}
}

var open_neighbour_network := {} # self.neighbour_network only [1,x]

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
