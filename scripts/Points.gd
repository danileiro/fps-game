extends Spatial

var value = 1
onready var sprite = $Sprite3D

func _process(delta):
	sprite.opacity = value
	value = lerp(value, 0, 0.05)
	sprite.transform.origin = lerp(sprite.transform.origin, sprite.transform.origin + Vector3(0, 1, 0), 0.1)
	if sprite.opacity < 0.6:
		queue_free()
	pass
# this scene will go up and fade out when added to the tree
