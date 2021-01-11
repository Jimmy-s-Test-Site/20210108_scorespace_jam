extends Control

var time : int = 0

func start() -> void:
	time = 0
	$Timer.start(1)

func _on_Timer_timeout():
	time += 1
	var seconds = time % 60
	var minutes = time / 60
	$Label.text = str(minutes, ":", seconds)
	$Timer.start(1)
