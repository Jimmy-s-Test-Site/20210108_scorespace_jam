extends Control

signal time_over

var time : int = 0

func start() -> void:
	$Label.text = str(time)
	$Timer.start(1)

func _on_Timer_timeout():
	time -= 1
	
	if time < 0:
		time = 0
		emit_signal("time_over")
	
	$Label.text = str(time)
