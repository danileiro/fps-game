extends Spatial

onready var player = $player
var state
var game_over
var energy = 2
var difficulty = 0.00001
onready var mouseAlarm = $player/head/Camera/Checkmouse1
onready var hud = $player/head/Camera/Control
onready var score = $player/head/Camera/Score
onready var player_health = $player/head/Camera/health
onready var healthbar = $player/head/Camera/healthBar
onready var enemies = get_tree().get_nodes_in_group("enemy")
onready var game_over_scene = preload("res://scenes/start/game_over.tscn")
onready var new_game_scene = preload("res://scenes/start/new_game.tscn")

func _ready(): # connect all needed signals and hide mouse label
	player_health.connect("changed", healthbar, "set_value")
	player_health.connect("max_changed", healthbar, "set_max")
	for enemie in enemies:
		enemie.connect("energy", self, "add_energy")
	player_health.initialize()
	mouseAlarm.hide()
	player.moving.show()
	pass # Replace with function body.

func checkMouseState(): # Show warning on the screen if mouse is visible
	if Input.get_mouse_mode() == Input.MOUSE_MODE_VISIBLE && !player.dead:
		mouseAlarm.show()
	elif Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
		mouseAlarm.hide()
	pass # mouse state is setted in another script to avoid bugs in web export

func set_state(): # detect player movements
	if player.direction.length():
		return "moving"
	else:
		return "idle"
	pass

func add_energy():
	player_health.current += energy
	energy = energy * 0.99 # decrease energy value
	energy = clamp(energy, 0.3, 2.0)
	pass

func new_game():
	game_over.disconnect("replay", self, "new_game")
	game_over.queue_free()
	var replay = new_game_scene.instance()
	hud.add_child(replay)
	pass

func game_over():
	player.dead = true # freeze all player movement
	game_over = game_over_scene.instance()
	hud.add_child(game_over)
	game_over.connect("replay", self, "new_game")
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	$Background_music.stop()
	pass
func _process(delta):
	if player.is_active: # reduce background music during slow motion effect
		$Background_music.set_volume_db(-8.0)
	else:
		$Background_music.set_volume_db(-2.0)
	state = set_state() # always check player state
	if state == "idle": # change life based on movement
		player_health.current -= Global.score * difficulty # decrease energy by score
	elif state == "moving":
		player_health.current += 0.001 * player.speed
		
	if player.can_auto && !player.auto_enabled:
		player.auto_enabled = true
		player.moving.text = "your gun can be automatic now"
		player.moving.show()
		$start_warning.start()
	
	# instance game over scene in HUD when player dies
	if player_health.current < 1:
		if !player.dead:
			game_over()
	if player.player_fall: # this is true when player fall off the world
		if !player.dead:
			game_over()
	checkMouseState() # check mouse state every frame
	score.text = str(Global.score) # set score in HUD
	pass

func _on_start_warning_timeout():
	player.moving.hide()
	pass # Replace with function body.
