extends Spatial



func _process(delta):
	if Input.is_action_just_pressed("pause"):
		var pause_state = not get_tree().paused
		get_tree().paused = pause_state
	pass
