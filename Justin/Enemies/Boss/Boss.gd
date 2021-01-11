extends KinematicBody2D

export (int) var speed := 500
export (int) var bulletVaporizeDistX := -5000
export (int) var bulletDelay := 2
export (NodePath) var projectileNodePath := "res://Justin/Enemies/Boss/Projectile.tscn"

var Player = null

var facedirection : int = 1

#create timer
var timer = null
var can_shoot = true

func _ready() -> void:
	self.z_index = 3
	self.set_process(false)
	#set up timer
	#timer=Timer.new()
	#timer.set_one_shot(true)
	#timer.set_wait_time(bulletDelay)
	#timer.connect("timeout", self, "on_timeout_complete")
	#add_child(timer)

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
		
		move_and_slide(-self_position_to_player * self.speed * delta)

#call function to shoot
func shoot():
	#projectile node path  EX:load("res://Justin/Enemies/Boss/projectile.tscn")
	var projectile = load(str(projectileNodePath))
	var bullet = projectile.instance()
	
	if facedirection == -1 && sign(bullet.velocity.x) == 1:
		#facing right
		bullet.velocity.x *= -1
	elif facedirection == 1 && sign(bullet.velocity.x) == -1:
		bullet.velocity.x *= -1
	
	#may need to change Test to Game!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
	add_child_below_node(get_tree().get_root().get_node("Test"),bullet)
	
	#start timer and disable shooting
	can_shoot=false
	timer.start()
	
	#if bullet goes past variable it disappears
	if position.x < bulletVaporizeDistX:
		queue_free()

#func get_input_axis():
#	axis.x = int(Input.is_action_pressed("move_right")) - int(Input.is_action_pressed("move_left"))
#	if Input.is_action_pressed("move_left"):
#		$AnimatedSprite.flip_h = true
#	if Input.is_action_pressed("move_right"):
#		$AnimatedSprite.flip_h = false
#	axis.y = int(Input.is_action_pressed("move_down")) - int(Input.is_action_pressed("move_up"))
#	axis = axis.normalized()


##TO DELAY BOSS FROM ENTERING####
#var t = Timer.new()
#t.set_wait_time(3)
#t.set_one_shot(true)
#self.add_child(t)
#t.start()
#yield(t, "timeout")

#t.queue_free()   #TO RELEASE THE TIMER from memory & counting

