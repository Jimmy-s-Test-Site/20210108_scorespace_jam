extends Node2D

export (int) var speed := 500
var path := PoolVector2Array() setget set_path

func _ready() -> void:
	self.set_process(false)

func _process(delta : float) -> void:
	var move_distance : = self.speed * delta
	
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
