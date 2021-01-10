extends Camera2D

var speed = 1000

func _ready():
	pass # Replace with function body.

func _process(delta : float) -> void:
	position.x += delta * speed
