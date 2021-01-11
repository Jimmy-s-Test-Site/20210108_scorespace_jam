extends Node2D

export (int) var size : int = 200 setget set_size
export (int) var percent_froot : int = 100
export (int) var percent_minion : int = 100

export (NodePath) var HairFrootNodePath := "res://Justin/Items/Hair_Froot.tscn"
export (NodePath) var BlavocadoFrootNodePath := "res://Justin/Items/Blavocado_Froot.tscn"
export (NodePath) var IdekFrootNodePath := "res://Justin/Items/Idek_Froot.tscn"
export (NodePath) var SchmorFrootNodePath := "res://Justin/Items/Schmor_Froot.tscn"

var id : Array = [0, 0] setget set_id
var rng = RandomNumberGenerator.new()

func set_size(value : int) -> void:
	size = value
	
	var new_scale = self.size * Vector2(
		1.0 / $Sprite.texture.get_width(),
		1.0 / $Sprite.texture.get_height()
	)
	
	$Sprite.scale = new_scale
	
	for wall in $Walls.get_children():
		wall.position *= new_scale
		wall.scale = new_scale

func set_id(value : Array) -> void:
	id = value

func _ready() -> void:
	$Sprite.visible = true

func random_spawn_position():
	rng.randomize()
		#will get a random number b/w room width
	var random_x = rng.randi_range(0,$Sprite.texture.get_width())
		#will get a random number b/w room height
	var random_y = rng.randi_range(0,$Sprite.texture.get_height())

func froot_spawn():
	rng.randomize()
	
	var chanceSpawn = rng.randi_range(0,100) # get a percent chance of spawn
	
	if chanceSpawn>=percent_froot:
		var frootchoice = rng.randi_range(1,4)
		var frootpath = SchmorFrootNodePath #default is SChmorfFroot
		
		if frootchoice == 1: #HairFroot will be spawned
			frootpath = HairFrootNodePath
		elif frootchoice == 2: #BlavocadoFroot will be spawned
			frootpath = BlavocadoFrootNodePath
		elif frootchoice == 3: #IdekFroot will be spawned
			frootpath = IdekFrootNodePath
		elif frootchoice == 4: #SchmorFroot will be spawned (DEFAULT)
			frootpath = SchmorFrootNodePath 

		var froot = frootpath.instance()
		froot.position = Vector2(random_spawn_position(),random_spawn_position()) #will spawn fruit at random x&y within room
	
	#func shoot():
	#projectile node path  EX:load("res://Justin/Enemies/Boss/projectile.tscn")
	#var projectile = load(str(projectileNodePath))
	#var bullet = projectile.instance()
	
