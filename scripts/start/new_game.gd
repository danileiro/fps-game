extends Node2D
func _ready():
	# criar o json para enviar para a api
	var data_to_send = {
		"type":"new",
		"user_id": Global.user_id
	}
	# prepara o json para ser enviado
	var var_post = JSON.print(data_to_send)
	var headers = ["Content-Type: application/json"]
	var url = Global.game_link
	var use_ssl = true
	$HTTPRequest.request(url, headers, use_ssl, HTTPClient.METHOD_POST, var_post)
	pass # Replace with function body.

func _on_HTTPRequest_request_completed(result, response_code, headers, body):
	var json = JSON.parse(body.get_string_from_utf8())
#	print(json.result)
	Global.game_id = json.result['ID Game Created']
	get_tree().change_scene("res://scenes/main.tscn") # change to game scene when loaded with a new game id
	pass # Replace with function body.
