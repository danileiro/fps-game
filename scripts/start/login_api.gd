extends Node2D

signal change_to(scene)
func _on_bt_entrar_pressed():
	# criar o json para enviar para a api
	var data_to_send = {
		"type":"login",
		"user":$user.text,
		"password":$password.text
	}
	# prepara o json para ser enviado
	var var_post = JSON.print(data_to_send)
	var headers = ["Content-Type: application/json"]
	var url = Global.login_link
	var use_ssl = false
	$HTTPRequest.request(url, headers, use_ssl, HTTPClient.METHOD_POST, var_post)

func _on_HTTPRequest_request_completed(result, response_code, headers, body):
	var json = JSON.parse(body.get_string_from_utf8())
	print(json.result)
	# usuário não digitou nada
	if (json.result["data"] == "err"):
		$erro.set_text("incorrect user/password")
		return
	# usuário não localizado
#	print(json.result)
	
	if(json.result['data'] == 'err'):
		if(json.result['value'] == "invalid data"):
			$erro.set_text(json.result['value'])
			return
		
		if(json.result['value'] == "user not found"):
			$erro.set_text(json.result['value'])
			return	
		
	# se ocorreu tudo bem, então grava os dados na variável global
	Global.user_name = json.result['name']
	Global.user_user = json.result['user']
	Global.user_id = json.result['id']
	
	# grava os dados de login no arquivo local que vai ser usado quando
	# carregar o jogo
	Login.save_login(json.result['id'], json.result['name'], json.result['user'])
	
	# carrega o menu do jogo
	emit_signal("change_to", "painel_jogo") # handled in prop.gd
#	get_tree().change_scene("res://scenes/start/painel_jogo.tscn")
	pass

func _on_new_btn_pressed():
	emit_signal("change_to", "new_user")
#	get_tree().change_scene("res://scenes/start/novo_user.tscn")
	pass # Replace with function body.
