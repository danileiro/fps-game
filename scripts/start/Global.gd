extends Node2D

# definição das variáveis globais
var login_links = [	"https://cors-anywhere.herokuapp.com/http://apistayhome.atwebpages.com/api/user.php",
					"http://apistayhome.atwebpages.com/api/user.php"]
var game_links = ["https://cors-anywhere.herokuapp.com/http://apistayhome.atwebpages.com/api/game.php",
				"http://apistayhome.atwebpages.com/api/game.php"]

var user_id # id do usuário 
var user_name # guarda o nome
var user_user # guarda o user
var score = 0# guarda o score
var game_id

var login_link = login_links[1] # trocar para 0 ao exportar HTML
var game_link = game_links[1]
