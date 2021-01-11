extends KinematicBody2D

export (int) var speed := 500
export (int) var bulletVaporizeDistX := -5000
export (int) var bulletDelay := 0.7
export (PackedScene) var projectile

var Player = null

var facedirection : int = 1

#create timer
var can_shoot = true

func _ready() -> void:
	$Teleport.visible = false
	self.z_index = 3
	
	$Gun/Timer.start(bulletDelay)

#if timer finishs...can shoot again
func on_timeout_complete():
	can_shoot=true

func _process(delta : float) -> void:
	#if boss y-pos is same as hero y-pos and delay is 0 then shoot
	
	#if Player != null:
	#	if (self.Player.position.y == self.position.y) && can_shoot:
	#		shoot()
	
	movement(delta)

func movement(delta) -> void:
	if self.Player != null:
		var self_position_to_player = self.global_position - self.Player.global_position
		
		if self_position_to_player.x > 0:
			$Boss_Animated_Sprite.flip_h = true
		else:
			$Boss_Animated_Sprite.flip_h = false
		
		var distance_to_player = self_position_to_player.length()
		if distance_to_player == 0:
			distance_to_player = 0.001
		
		var speed_correction = -1.0 / distance_to_player + 1
		
		move_and_slide(-self_position_to_player * self.speed * speed_correction * delta)

#call function to shoot
func shoot():
	var bullet_directions = [
		Vector2( 0,-1), Vector2( 1,-1), Vector2( 1, 0), Vector2( 1, 1),
		Vector2( 0, 1), Vector2(-1, 1), Vector2(-1, 0), Vector2(-1,-1)
	]
	
	for bullet_direction in bullet_directions:
		var new_bullet = projectile.instance()
		new_bullet.global_position = self.global_position
		new_bullet.name = "Projectile"
		new_bullet.direction = bullet_direction.normalized()
		get_tree().get_root().get_node("Game").add_child(new_bullet)

func _on_Gun_Timer_timeout():
	shoot()
	$Gun/Timer.start(bulletDelay)
