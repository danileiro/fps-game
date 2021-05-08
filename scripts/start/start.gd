extends Node2D
# THIS SCENE IS NOT USED
signal change_to(scene)
func _ready():
	# verificar se um usuário já existe localmente
	if Login.load_login() != null:
		# carrega os dados
		var user_data = Login.load_login()
		
		# atribuir os dados para as variáveis globais
		Global.user_id = user_data['id']
		Global.user_name = user_data['name']
		Global.user_user = user_data['user']
		
		# chamar o menu do jogo
		print("mudando para painel")
#		emit_signal("change_to", "painel_jogo")
#		get_tree().change_scene("res://scenes/start/painel_jogo.tscn")
	else:
		print("mudando para login")
		emit_signal("change_to", "login")
#		get_tree().change_scene("res://scenes/start/login.tscn")
	pass
