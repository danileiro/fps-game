extends Node2D
signal change_to(scene)
func _on_new_btn_pressed():
	# criar o json para enviar para a api
	var data_to_send = {
		"type":"new",
		"name": $name.text,
		"user":$user.text,
		"password":$password.text
	}
	# prepara o json para ser enviado
	var var_post = JSON.print(data_to_send)
	var headers = ["Content-Type: application/json"]
	var url = Global.login_link
	var use_ssl = true
	$HTTPRequest.request(url, headers, use_ssl, HTTPClient.METHOD_POST, var_post)
	pass # Replace with function body.

func _on_HTTPRequest_request_completed(result, response_code, headers, body):
	var json = JSON.parse(body.get_string_from_utf8())
	print(json.result)
	# usuário não digitou nada
	if (json.result["data"] == "err"):
		$erro.set_text(json.result["value"])
		return
	# usuário não localizado
	print(json.result)
	
	# se ocorreu tudo bem, então grava os dados na variável global
	Global.user_name = $name.text #json.result['name']
	Global.user_user = $user.text #json.result['user']
	Global.user_id = json.result['value']
	print(Global.user_name)
	print(Global.user_user)
	print(Global.user_id)
	
	# carrega o menu do jogo
	emit_signal("change_to", "painel_jogo") # handled in prop.gd
	pass
