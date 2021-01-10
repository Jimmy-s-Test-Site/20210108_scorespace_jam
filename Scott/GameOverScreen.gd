extends Control

signal proceed

signal fruit_score_updated
signal time_score_updated

func _ready():
	pass

func _on_Restart_pressed():
	emit_signal("proceed")

var fruit_score: = 0 setget set_fruit_score
var time_score: = 0 setget set_time_score

func set_time_score(value: int) -> void:
	time_score = value
	#emit_signal("time_score_updated")

func set_fruit_score(value: int) -> void:
	fruit_score = value
	#emit_signal("fruit_score_updated")
