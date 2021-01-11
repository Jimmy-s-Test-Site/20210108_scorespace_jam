extends Node2D

export (float) var percent_froot : float = .75
export (float) var percent_minion : float = .30

export (PackedScene) var battery_pack
export (Array, PackedScene) var fruits

#export (NodePath) var HairFrootNodePath := "res://Justin/Items/Hair_Froot.tscn"
#export (NodePath) var BlavocadoFrootNodePath := "res://Justin/Items/Blavocado_Froot.tscn"
#export (NodePath) var IdekFrootNodePath := "res://Justin/Items/Idek_Froot.tscn"
#export (NodePath) var SchmorFrootNodePath := "res://Justin/Items/Schmor_Froot.tscn"

var rng = RandomNumberGenerator.new()

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func random_spawn_position():
	rng.randomize()
		#will get a random number b/w room width
	var random_x = rng.randi_range(0,$Sprite.texture.get_width())
		#will get a random number b/w room height
	var random_y = rng.randi_range(0,$Sprite.texture.get_height())

func froot_spawn():
	rng.randomize()
	
	#var chanceSpawn = rng.randi_range(0,100) # get a percent chance of spawn
	
	if rng.randf() < percent_froot #less than this then spawn
		for #through array
	
#	for i in range(0, arr.size():
#    print("Accessing item at index " + str(i))
#    arr[i].my_func()
	
	if chanceSpawn<=percent_froot:
		var frootchoice = rng.randi_range(1,4)
	#	var frootpath = SchmorFrootNodePath #default is SChmorfFroot
		
		if frootchoice == 1: #HairFroot will be spawned
#			frootpath = HairFrootNodePath
		elif frootchoice == 2: #BlavocadoFroot will be spawned
	#		frootpath = BlavocadoFrootNodePath
		elif frootchoice == 3: #IdekFroot will be spawned
	#		frootpath = IdekFrootNodePath
		elif frootchoice == 4: #SchmorFroot will be spawned (DEFAULT)
	#		frootpath = SchmorFrootNodePath 

		var froot = frootpath.instance()
		add_child(froot)
		froot.position = Vector2(random_spawn_position(),random_spawn_position()) #will spawn fruit at random x&y within room
	
	#func shoot():
	#projectile node path  EX:load("res://Justin/Enemies/Boss/projectile.tscn")
	#var projectile = load(str(projectileNodePath))
	#var bullet = projectile.instance()
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
