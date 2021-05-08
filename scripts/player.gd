extends KinematicBody

# movement variables
var speed = 20
var running = false
var press_count = 0
var acceleration = 20
var gravity = 9.8 * 2
var jump = 8
var jump_num = 0

var auto_enabled = false
var can_shoot = true
var can_auto = false
var gun_state = "single"
var dead = false
var player_fall = false

# special variables
# wall run
var wall_normal
# slow motion 
var duration = 2
var strength = 0.9
const END_VALUE = 1
var is_active = false
var time_start
var duration_ms
var start_value
var slow_motion_cooldown
# grappling hook
var grappling = false
var hookpoint = Vector3()
var hookpoint_get = false
var grappling_cooldown = false
var grappling_timer = 0

var mouse_sensitivity = 0.05

# physics variables
var direction = Vector3()
var velocity = Vector3()
var fall = Vector3()

# instance nodes
onready var head = $head
onready var aimcast = $head/Camera/RayCast
onready var gun = $head/Camera/gun
onready var muzzle = $head/Camera/gun/muzzle
onready var grapplecast = $head/Camera/Grappling
onready var headLimit = $headLimit
onready var slow_icon = $head/Camera/icons/slow_icon
onready var grappling_icon = $head/Camera/icons/grappling_icon
onready var moving = $head/Camera/moving
onready var gun_control = $head/Camera/icons/gun_control
onready var bullet = preload("res://scenes/bullet.tscn") # not used

func _ready():
	Engine.time_scale = 1 # reset time scale to avoid bugs
	gun_control.hide()
	$head/Camera/pause_label.hide()
	pass # Replace with function body.

func _input(event): # Controla o mouse
	if event is InputEventMouseMotion && !dead:
		rotate_y(deg2rad(-event.relative.x * mouse_sensitivity))
		head.rotate_x(deg2rad(-event.relative.y * mouse_sensitivity))
		head.rotation.x = clamp(head.rotation.x, deg2rad(-90), deg2rad(90))
	pass

func wall_run(delta):
	if is_on_wall():
		wall_normal = get_slide_collision(0)
		jump_num = 1
		direction = -wall_normal.normal * speed * 20 # apply force negative to wall normal
	pass

# Slow motion proccess
func slow_motion():
	if is_active: # only proccess when active
		var current_time = OS.get_ticks_msec() - time_start
		var value = circ_ease_in(current_time, start_value, END_VALUE, duration_ms)
		if current_time >= duration_ms:
			is_active = false
			$Shoot_effect.set_pitch_scale(1)
			$Grappling_trigger.set_pitch_scale(1)
			$gun_tic.set_pitch_scale(1)
			value = END_VALUE # normalize time when motion ends
		Engine.time_scale = value # set time scale to a value that changes over time
		yield(get_tree().create_timer(5), "timeout")# set timer to trigger this function again
		slow_icon.modulate = Color(1, 1, 1, 1)
		slow_motion_cooldown = false # reset cooldown so player can trigger this function again
	if Input.is_action_just_pressed("ability") && !slow_motion_cooldown:
		slow_motion_cooldown = true
		slow_icon.modulate = Color(1, 1, 1, 0.2)
		slow_start(duration, strength)
	pass

func slow_start(duration, strength):
	$Slow_motion_effect.play()
	$Shoot_effect.set_pitch_scale(0.4)
	$Grappling_trigger.set_pitch_scale(0.4)
	$gun_tic.set_pitch_scale(0.4)
	time_start = OS.get_ticks_msec()
	duration_ms = duration * 1000
	start_value = 1 - strength
	Engine.time_scale = start_value # set time scale to default value minus strength (begin slow motion)
	is_active = true # this will trigger proccess to end slow motion
	pass

func circ_ease_in(t, b, c, d): # from http://gizma.com/easing/#l
	t /= d/2;
	if (t < 1): return -c/2 * (sqrt(1 - t*t) - 1) + b
	t -= 2;
	return c/2 * (sqrt(1 - t*t) + 1) + b

# grappling hook
func grapple(delta):
	if grappling_cooldown: # start timer
		grappling_timer += delta * 2
		if grappling_timer > 5:
			grappling_icon.modulate = Color(1, 1, 1, 1)
			grappling_cooldown = false  
			grappling_timer = 0 # reset timer
	if Input.is_action_just_pressed("grapple") && !grappling_cooldown:
		if grapplecast.is_colliding(): # check raycast collision
			if not grappling:
				$Grappling_trigger.play()
				grappling_cooldown = true
				grappling = true
				grappling_icon.modulate = Color(1, 1, 1, 0.2)
	if grappling:
		fall.y = 0
		if not hookpoint_get:
			hookpoint = grapplecast.get_collision_point() + Vector3(0, 2, 0)
			hookpoint_get = true
		if hookpoint.distance_to(transform.origin) > 1:
			if hookpoint_get:
				transform.origin = lerp(transform.origin, hookpoint, 0.008)
				jump_num = 1
		else:
			grappling = false
			hookpoint_get = false
	if headLimit.is_colliding():
		grappling = false
		hookpoint = null
		hookpoint_get = false
		global_translate(Vector3(0, -1, 0))
	pass

func move(delta):
	direction = Vector3()
	if Input.is_action_pressed("move_forward"):
		direction -= transform.basis.z
	elif Input.is_action_pressed("move_backward"):
		direction += transform.basis.z
	if Input.is_action_pressed("move_left"):
		direction -= transform.basis.x
	elif Input.is_action_pressed("move_right"):
		direction += transform.basis.x
	# normalize direction to avoid increase speed while moving diagonals
	direction = direction.normalized()
	# interpolate velocity for gradual acceleration
	velocity = velocity.linear_interpolate(direction * speed, acceleration * delta)
	# apply velocity
	velocity = move_and_slide(velocity, Vector3.UP)
	# apply gravity
	move_and_slide(fall, Vector3.UP)
	pass

func jump(delta):
	# applying gravity only if not on floor
	if not is_on_floor():
		fall.y -= gravity * delta
	# Double jump settings
	# set jump count to zero if is on floor
	if is_on_floor():
		jump_num = 0
	# only jumps if jump count is zero and is on floor
	if Input.is_action_pressed("jump") and is_on_floor():
		if jump_num == 0:
			fall.y = jump
			jump_num = 1 # increase jump count
	# only do a second jump if is not on floor and jump count is 1
	if Input.is_action_just_pressed("jump") and not is_on_floor():
		if jump_num == 1:
			fall.y = jump
			jump_num = 2 # increase jump count
	pass

func set_gun_state():
	if can_auto:
		if Input.is_action_just_pressed("gun_state"):
			$gun_tic.play()
			if gun_state == "single":
				gun_state = "auto"
			elif gun_state == "auto":
				gun_state = "single"
			gun_control.get_child(0).text = gun_state
	pass

func shoot():
	match gun_state:
		"auto":
			if Input.is_action_pressed("shoot"):
				if can_shoot:
					if aimcast.is_colliding():# instance a bullet in gun muzzle and point it to aim raycast
						can_shoot = false
						$Shoot_effect.play()
						var body = aimcast.get_collider()
						if body is RigidBody:
							body.apply_impulse(aimcast.get_collision_point(), -aimcast.get_collision_normal() * 0.3)
						if body.is_in_group("enemy"): # group to handle life bonus
							Global.score += body.points
							body.hit = true # body will emit a signal to increase player life
							body.render_points()
						elif body.is_in_group("targets"): # handle other targets
							Global.score += body.points
							body.show_points = true
			#			var b = bullet.instance() # bullet was removed due to performance issues
			#			muzzle.add_child(b) 
			#			b.look_at(aimcast.get_collision_point(), Vector3.UP)
			#			b.shoot = true # this will trigger bullet movement
					if !is_active: # do not rotate gun if in slowmotion
						gun.rotate(Vector3(1, 0, 0), 0.5)
						yield(get_tree().create_timer(0.1), "timeout")
						gun.rotate(Vector3(1, 0, 0), -0.5)
						yield(get_tree().create_timer(0.15), "timeout")
						can_shoot = true
					else:
						yield(get_tree().create_timer(0.03), "timeout")
						can_shoot = true
		"single":
			if Input.is_action_just_pressed("shoot"):
				if can_shoot:
					if aimcast.is_colliding():# instance a bullet in gun muzzle and point it to aim raycast
						can_shoot = false
						$Shoot_effect.play()
						var body = aimcast.get_collider()
						if body is RigidBody:
							body.apply_impulse(aimcast.get_collision_point(), -aimcast.get_collision_normal() * 0.3)
						if body.is_in_group("enemy"): # group to handle life bonus
							Global.score += body.points
							body.hit = true # body will emit a signal to increase player life
							body.render_points()
						elif body.is_in_group("targets"): # handle other targets
							Global.score += body.points
							body.show_points = true
			#			var b = bullet.instance() # bullet was removed due to performance issues
			#			muzzle.add_child(b) 
			#			b.look_at(aimcast.get_collision_point(), Vector3.UP)
			#			b.shoot = true # this will trigger bullet movement
					if !is_active: # do not rotate gun if in slowmotion
						gun.rotate(Vector3(1, 0, 0), 0.5)
						yield(get_tree().create_timer(0.1), "timeout")
						gun.rotate(Vector3(1, 0, 0), -0.5)
						yield(get_tree().create_timer(0.15), "timeout")
						can_shoot = true
					else:
						can_shoot = true
	pass

func _physics_process(delta):
	if !dead:
		if Global.score > 30000:
			if !can_auto:
				can_auto = true
				gun_control.show()
		set_gun_state()
		shoot()
	
		# ability proccess
		wall_run(delta)
		slow_motion()
		grapple(delta) 
		
		if not grappling: # dont move while grappling to avoid bugs
			move(delta)
			jump(delta)
	pass

# kill player when fall
func _on_Area_body_entered(body):
	if body == self:
		player_fall = true # player dead state is handle in main.gd
	pass # Replace with function body
