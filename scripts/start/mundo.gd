extends Spatial


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var score = 0
var ponto = 50
onready var bola = $RigidBody
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_Area_body_entered(body):
	if body == bola:
		score += ponto
		print(score)
		_update()
	pass # Replace with function body.

func _update():
	# criar o json para enviar para a api
	var data_to_send = {
		"type":"save",
		"game_id": Global.game_id,
		"score":score
	}
	# prepara o json para ser enviado
	var var_post = JSON.print(data_to_send)
	var headers = ["Content-Type: application/json"]
	#var url = "http://apijogo.mygamesonline.org/api/user.php"
	var url = "https://cors-anywhere.herokuapp.com/http://apistayhome.atwebpages.com/api/game.php"
	var use_ssl = true
	$HTTPRequest.request(url, headers, use_ssl, HTTPClient.METHOD_POST, var_post)
	pass
	

func _on_gameoverArea_body_entered(body):
	_update()
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	get_tree().change_scene("res://scenes/Panels/painel_jogo.tscn")
	pass

func _on_HTTPRequest_request_completed(result, response_code, headers, body):
	var json = JSON.parse(body.get_string_from_utf8())
	print(json.result)
	pass # Replace with function body.
