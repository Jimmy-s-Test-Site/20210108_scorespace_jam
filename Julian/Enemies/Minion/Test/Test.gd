extends Node2D

onready var minion : Node2D = $Minion
onready var player : StaticBody2D = $Player
onready var nav_2d : Navigation2D = $Navigation2D

func _ready() -> void:
	var new_path := self.nav_2d.get_simple_path(self.minion.global_position, self.player.global_position)
	self.minion.path = new_path
