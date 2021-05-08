extends StaticBody

func _on_Area_body_entered(body):
	if body.get_name() == "player":
		$AudioStreamPlayer.play()
		body.fall.y = 30 # make player jump higher
	pass # Replace with function body.
