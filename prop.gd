extends Spatial

onready var divCam = $DivCamera
onready var hud = $DivCamera/Camera/Container
var cam_rotation = 0.2
onready var start = preload("res://scenes/start/start.tscn") # not used
onready var new_user = preload("res://scenes/start/novo_user.tscn")
onready var new_game = preload("res://scenes/start/new_game.tscn")
onready var login = preload("res://scenes/start/login.tscn")
onready var menu = preload("res://scenes/start/painel_jogo.tscn")
onready var placar_player = preload("res://scenes/start/placar_player.tscn")
onready var placar = preload("res://scenes/start/placar.tscn")
onready var controls = preload("res://scenes/start/Game_controls.tscn")
onready var credits = preload("res://scenes/start/Credits.tscn")
var currentScene

func _ready(): # check if player already logged in
	if Global.user_id == null:
		currentScene = login.instance()
	else:
		currentScene = menu.instance()
	hud.add_child(currentScene)
	currentScene.connect("change_to", self, "loadScene")
	pass # Replace with function body.

func add_in_tree(scene):
	currentScene.disconnect("change_to", self, "loadScene") # always disconnect last signal to avoid bugs
	currentScene.queue_free() # delete last scene
	currentScene = scene.instance() # load new scene
	hud.add_child(currentScene) # add to HUD
	currentScene.connect("change_to", self, "loadScene") # connect new scene signals
	pass
func loadScene(scene): # listen to every signal and load scenes 
	match scene:
		"login":
			add_in_tree(login)
		"painel_jogo":
			add_in_tree(menu)
		"placar_player":
			add_in_tree(placar_player)
		"placar":
			add_in_tree(placar)
		"new_user":
			add_in_tree(new_user)
		"game_controls":
			add_in_tree(controls)
		"credits":
			add_in_tree(credits)
	if scene == "new_game":# this scene dont have any signals. Will load a new game id and change to game
		currentScene.disconnect("change_to", self, "loadScene")
		currentScene.queue_free()
		currentScene = new_game.instance()
		hud.add_child(currentScene)
	pass

func _process(_delta): # rotate camera as menu background
	divCam.rotate_y(deg2rad(cam_rotation))
	pass
