extends Node2D
signal replay()

func _ready():
	$AudioStreamPlayer.play()
	# criar o json para enviar para a api
	var data_to_send = {
		"type":"save",
		"game_id": Global.game_id, 
		"score": Global.score
	}
	# prepara o json para ser enviado
	var var_post = JSON.print(data_to_send)
	var headers = ["Content-Type: application/json"]
	var url = Global.game_link
	var use_ssl = true
	print("dados pra salvar: ", data_to_send)
	$HTTPRequest.request(url, headers, use_ssl, HTTPClient.METHOD_POST, var_post)
	pass # Replace with function body.

func _on_HTTPRequest_request_completed(result, response_code, headers, body):
	var json = JSON.parse(body.get_string_from_utf8())
	print(json.result)
	pass # Replace with function body.

func _on_Replay_pressed(): # reset score and emit signal to restart game
	print("repley pressed")
	Global.score = 0
	emit_signal("replay") # handled in main.gd
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	pass # Replace with function body.
	
func _on_Voltar_pressed():
	Global.score = 0
	get_tree().change_scene("res://prop.tscn")
	pass # Replace with function body.
