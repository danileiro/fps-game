extends Node2D

# arquivo com os dados locais
const USER_DATA = "user_data.json"

static func load_login():
	# cria um obj para manipular arquivos
	var file = File.new()
	# verifica se existe o arquivo
	if not file.file_exists(USER_DATA):
		print("Arquivo não existe")
		return
	
	# tentar abrir o arquivo
	if file.open(USER_DATA, file.READ) != 0:
		print("Erro ao abrir o arquivo")
		return
	
	# carregar os dados
	var data = parse_json(file.get_line())
	
	return data
	
static func save_login(var_id, var_name, var_user):
	var file = File.new()
	if file.open(USER_DATA, File.WRITE) != 0:
		print("Erro ao abrir o arquivo")
		return
		
	# monta o json para salvar no arquivo
	var data = {
		id = var_id,
		name = var_name,
		user = var_user
	}
	
	# grava os dados
	file.store_line(to_json(data))
	
	# fecha o arquivo
	file.close()
		
