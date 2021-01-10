extends Node2D

onready var boss : Node2D = $Boss
onready var player : StaticBody2D = $Player
onready var nav_2d : Navigation2D = $Navigation2D

func _ready() -> void:
	var new_path := self.nav_2d.get_simple_path(self.boss.global_position, self.player.global_position)
	self.boss.path = new_path
