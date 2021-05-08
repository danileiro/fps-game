extends Panel

# carregar a cena ListItem que contém o esqueleto da lista
const ListItem = preload("res://scenes/start/ListItem.tscn")

# controlar a nossa sequência
var listIndex = 0

# função para adicionar elementos em uma lista de forma dinâmica
func addItem(score, user):
	var item = ListItem.instance() # cria uma instância da lista
	listIndex += 1 # incrementa o valor do item da lista
	
	# adicionar de fato o item na lista (para os dois objetos Label)
	item.get_node("sequencia").text = str(score)
	item.get_node("descricao").text = user
	item.rect_min_size = Vector2(320, 30)
	
	# atribuir a lista o ScrollContainer
	$ScrollContainer/list.add_child(item)
	pass

func ranking_player():
	var data_to_send = {'type': 'ranking_player', 'user_id': str(Global.user_id)}
	var var_post = JSON.print(data_to_send)
	var header = ["Content-Type: application/json"]
	var url = Global.game_link
	var use_ssl = true
	$HTTPRequest.request(url, header, use_ssl, HTTPClient.METHOD_POST, var_post)
	pass

func _ready():
	ranking_player()
	pass

func _on_HTTPRequest_request_completed(result, response_code, headers, body):
	var json = JSON.parse(body.get_string_from_utf8())
#	print(json.result)
	if 'data' in json.result:
		if json.result['data'] == 'err':
			addItem("Err", json.result['value'])
	else:
		for x in json.result:
			for dados in [x]:
				addItem(dados['Score'], dados['User'])
	pass
