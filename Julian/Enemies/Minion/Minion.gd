extends KinematicBody2D

export (int) var speed := 500

var Player = null

func _ready() -> void:
	self.z_index = 2

func _process(delta : float) -> void:
	movement(delta)

func movement(delta) -> void:
	if self.Player != null:
		var self_position_to_player = self.global_position - self.Player.global_position
		
		if self_position_to_player.x > 0:
			$AnimatedSprite.flip_h = true
		else:
			$AnimatedSprite.flip_h = false
		
		var speed_correction = -1.0 / self_position_to_player.length() + 1
		
		move_and_slide(-self_position_to_player * self.speed * speed_correction * delta)
