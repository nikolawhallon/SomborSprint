extends KinematicBody2D

signal collect_licitar
signal take_damage

export var gravity = 10
export var run_speed = 200
export var run_speed_delta = 100
export var jump_speed = 325
var velocity = Vector2(run_speed, 0)
var direction = Vector2(1, 0)
var just_jumped = false
var double_jumping = false

var has_fez = false
var double_jumps_jumped = 0
var has_opanci = false
var yugos_destroyed = 0

func set_animation(action):
	if action == "jump":
		if has_fez and has_opanci:
			$AnimatedSprite.animation = "jump_fez_opanci"
		elif has_fez:
			$AnimatedSprite.animation = "jump_fez"
		elif has_opanci:
			$AnimatedSprite.animation = "jump_opanci"
		else:
			$AnimatedSprite.animation = "jump"
	if action == "run":
		if has_fez and has_opanci:
			$AnimatedSprite.animation = "run_fez_opanci"
		elif has_fez:
			$AnimatedSprite.animation = "run_fez"
		elif has_opanci:
			$AnimatedSprite.animation = "run_opanci"
		else:
			$AnimatedSprite.animation = "run"
	if action == "idle":
		if has_fez and has_opanci:
			$AnimatedSprite.animation = "idle_fez_opanci"
		elif has_fez:
			$AnimatedSprite.animation = "idle_fez"
		elif has_opanci:
			$AnimatedSprite.animation = "idle_opanci"
		else:
			$AnimatedSprite.animation = "idle"

# this is a total hack for updating the animation when you collect a fez in the air
func reset_jump_animation():
	if $AnimatedSprite.animation == "jump_fez_opanci" or $AnimatedSprite.animation == "jump_fez" or $AnimatedSprite.animation == "jump_opanci" or $AnimatedSprite.animation == "jump":
		set_animation("jump")

func _physics_process(_delta):
	if double_jumps_jumped == 5:
		has_fez = false
		double_jumps_jumped = 0

	if yugos_destroyed == 5:
		has_opanci = false
		yugos_destroyed = 0

	reset_jump_animation()

	velocity.y += gravity

	if Input.is_action_just_pressed("jump"):
		if is_on_floor():
			velocity.y -= jump_speed
			set_animation("jump")
			$JumpAudio.play()
		elif has_fez and !double_jumping:
			velocity.y = -jump_speed
			# technically I shouldn't need to set the animation to jump here
			# that should already be the current animation given the state of the player
			double_jumping = true
			double_jumps_jumped += 1
			$AirAudio.play()

	if Input.is_key_pressed(KEY_A):
		velocity.x = run_speed - run_speed_delta
		$AnimatedSprite.speed_scale = (run_speed as float - run_speed_delta as float) / run_speed as float
	elif Input.is_key_pressed(KEY_D):
		velocity.x = run_speed + run_speed_delta
		$AnimatedSprite.speed_scale = (run_speed as float + run_speed_delta as float) / run_speed as float
	else:
		velocity.x = run_speed
		$AnimatedSprite.speed_scale = run_speed / run_speed

	if velocity != Vector2.ZERO:
		direction = velocity.normalized()

	velocity = move_and_slide(velocity, Vector2.UP)
	
	if is_on_floor():
		double_jumping = false
		if velocity.x > 0:
			set_animation("run")
		if velocity.x == 0:
			set_animation("idle")
		if velocity.x < 0:
			set_animation("run")

	if velocity.x >= 0:
		scale.x = 1
	else:
		scale.x = -1

func collect_licitar(points):
	emit_signal("collect_licitar", points)

func take_damage():
	damage_iteration = 0
	$DamageTimer.stop()
	$DamageTimer.start()
	emit_signal("take_damage")
	$DamageAudio.play()

var damage_iteration = 0
func _on_DamageTimer_timeout():
	if $AnimatedSprite.modulate.a == 0.0:
		$AnimatedSprite.modulate.a = 1.0
	else:
		$AnimatedSprite.modulate.a = 0.0
	damage_iteration += 1
	if damage_iteration > 20:
		damage_iteration = 0
		$DamageTimer.stop()
		$AnimatedSprite.modulate.a = 1.0
