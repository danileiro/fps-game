extends Node2D
signal change_to(scene) # all signals are connected in prop.gd
func _ready():
	$user_name.set_text(Global.user_name)
	$top_player.hide()
	get_ranking()
	pass

func get_ranking():
	var data_to_send = {"type":"ranking_general"}
	var var_post = JSON.print(data_to_send)
	var header = ["Content-Type: application/json"]
	var url = Global.game_link
	var use_ssl = false
	$top_player/HTTPRequest.request(url, header, use_ssl, HTTPClient.METHOD_POST, var_post)
	pass

func _on_logout_pressed():
	emit_signal("change_to", "login")
#	get_tree().change_scene("res://scenes/start/login.tscn")
	pass # Replace with function body.

func _on_ranking_geral_pressed():
	emit_signal("change_to", "placar")
#	get_tree().change_scene("res://scenes/start/placar.tscn")
	pass # Replace with function body.

func _on_ranking_user_pressed():
	emit_signal("change_to", "placar_player")
#	get_tree().change_scene("res://scenes/start/placar_player.tscn")
	pass # Replace with function body.

func _on_novo_jogo_pressed():
	emit_signal("change_to", "new_game") # new_game scene will get a game id for saving score
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
#	get_tree().change_scene("res://scenes/start/new_game.tscn")
	pass # Replace with function body.

func _on_Controls_pressed():
	emit_signal("change_to", "game_controls")
	pass # Replace with function body.

func _on_HTTPRequest_request_completed(result, response_code, headers, body):
	var json = JSON.parse(body.get_string_from_utf8())
	$top_player/player_name.text = json.result[0]['User']
	$top_player.show()
	pass # Replace with function body.

func _on_Credits_pressed():
	emit_signal("change_to", "credits")
	pass # Replace with function body.
