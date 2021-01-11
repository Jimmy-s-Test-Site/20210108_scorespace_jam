extends AudioStreamPlayer

var muted = false

func _process(delta : float) -> void:
	if Input.is_action_just_pressed("mute"):
		toggle_mute_all()

func toggle_mute_all():
	if muted:
		muted = false
		AudioServer.set_bus_mute(AudioServer.get_bus_index("Master"), false)
	else:
		muted = true
		AudioServer.set_bus_mute(AudioServer.get_bus_index("Master"), true)
