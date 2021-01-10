extends Node2D

onready var boss : KinematicBody2D = $Boss
onready var player : KinematicBody2D = $Player
onready var nav_2d : Navigation2D = $Navigation2D

func _ready() -> void:
	var new_path := self.nav_2d.get_simple_path(self.boss.global_position, self.player.global_position)
	self.boss.path = new_path
	self.boss.Player = player
	
	player.connect("moved", self, "on_Player_moved")

func on_Player_moved() -> void:
	var new_path := self.nav_2d.get_simple_path(self.boss.global_position, self.player.global_position)
	self.boss.path = new_path
