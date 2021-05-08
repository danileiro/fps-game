extends Node2D
signal change_to(scene)
func _on_Voltar_pressed():
	emit_signal("change_to", "painel_jogo")
	pass # Replace with function body.
# this script is attached to root node for each ranking scene to connect signals to prop.gd
