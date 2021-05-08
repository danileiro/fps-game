extends KinematicBody
signal energy()

var points = 25
var hit = false
var value = 1
onready var label = preload("res://scenes/Points.tscn")

func _process(delta):
	if hit: 
		emit_signal("energy") # handled in main.gd
		hit = false
	pass

func render_points(): # instance a label above the target showing points
	$Spatial.add_child(label.instance())
	$Spatial.get_node("Points/Viewport/Label").text = "+" + str(points)
	pass
