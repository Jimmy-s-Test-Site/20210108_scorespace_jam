extends KinematicBody2D

export (int) var MoveSpeed := 500
export (int) var bulletVaporizeDistX := -5000
export (int) var bulletDelay := 2
export (NodePath) var projectileNodePath := "res://Justin/Enemies/Boss/projectile.tscn"

var path := PoolVector2Array() setget set_path

#create timer
var timer = null
var can_shoot = true

func _ready() -> void:
	self.set_process(false)
	#set up timer
	timer=Timer.new()
	timer.set_one_shot(true)
	timer.set_wait_time(bulletDelay)
	timer.connect("timeout",self,"on_timeout_complete")
	add_child(timer)

#if timer finishs...can shoot again
func on_timeout_complete():
	can_shoot=true

func _process(delta : float) -> void:
	var move_distance : = self.MoveSpeed * delta
	#if boss y-pos is same as hero y-pos and delay is 0 then shoot
	if (self.Player.position == self.Boss.position) && can_shoot:
		shoot()
	self.move_along_path(move_distance)

func move_along_path(distance : float) -> void:
	var start_point := self.position
	
	for i in range(self.path.size()):
		var distance_to_next_point := start_point.distance_to(self.path[0])
		
		if distance <= distance_to_next_point and distance >= 0:
			self.position = start_point.linear_interpolate(self.path[0], distance / distance_to_next_point)
			break
		elif distance < 0.0:
			self.position = self.path[0]
			self.set_process(false)
			break
		
		distance -= distance_to_next_point
		start_point = path[0]
		self.path.remove(0)

func set_path(value : PoolVector2Array) -> void:
	path = value
	
	if value.size() == 0:
		return
	
	self.set_process(true)

#call function to shoot
func shoot():
	#projectile node path  EX:load("res://Justin/Enemies/Boss/projectile.tscn")
	var projectile = load(projectileNodePath)
	var bullet = projectile.instance()
	#may need to change Test to Game!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
	add_child_below_node(get_tree().get_root().get_node("Test"),bullet)
	
	#start timer and disable shooting
	can_shoot=false
	timer.start()
	
	#if bullet goes past variable it disappears
	if position.x<bulletVaporizeDistX:
		queue_free()
	




##TO DELAY BOSS FROM ENTERING####
#var t = Timer.new()
#t.set_wait_time(3)
#t.set_one_shot(true)
#self.add_child(t)
#t.start()
#yield(t, "timeout")

#t.queue_free()   #TO RELEASE THE TIMER from memory & counting

