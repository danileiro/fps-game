extends Spatial
onready var player = get_tree().get_current_scene().get_node("player")
func _input(event): # this node is in main game tree. It handles mouse mode 
	if event.is_action_pressed("ui_accept") && !player.dead: # do not capture mouse if player is dead
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
		pass
	if event.is_action_pressed("ui_cancel"):
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
