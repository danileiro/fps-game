extends RigidBody

const SPEED = 200
var shoot = false
var score = 0

func _ready():
	set_as_toplevel(true)
	pass # Replace with function body.

func _process(delta):
	if shoot: # apply movement when triggered
		apply_impulse(transform.basis.z, -transform.basis.z * SPEED)

func _on_Area_body_entered(body):
	set_process(false)
	queue_free()
