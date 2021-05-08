extends RigidBody
var points = 75
var show_points = false
var hit = false
var value = 1
onready var label = preload("res://scenes/Points.tscn")

func _process(delta):
	if show_points:
		render_points()
	pass

func render_points(): # instance a label above the target showing points
	$Spatial.add_child(label.instance())
	$Spatial.get_node("Points/Viewport/Label").text = "+" + str(points)
	show_points = false
	pass
# this script should be unique for all target nodes. Just keep it simple by not mixing connections
