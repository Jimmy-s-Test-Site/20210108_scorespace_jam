extends KinematicBody2D

var velocity = Vector2()
export (int) var bulletVelocity := 100

func _ready():
	velocity.x = bulletVelocity

func _physics_process(delta):
	move_and_collide(velocity)

