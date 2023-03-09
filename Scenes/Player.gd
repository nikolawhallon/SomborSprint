extends KinematicBody2D

signal collect_licitar
signal take_damage

export var gravity = 10
export var run_speed = 200
export var run_speed_delta = 100
export var jump_speed = 300
var velocity = Vector2(run_speed, 0)
var direction = Vector2(1, 0)
var just_jumped = false
			
func _physics_process(_delta):
	if !is_on_floor():
		velocity.y += gravity

	if Input.is_key_pressed(KEY_SPACE):
		if is_on_floor():
			velocity.y -= jump_speed
			$AnimatedSprite.animation = "jump"
			
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
		if velocity.x > 0:
			$AnimatedSprite.animation = "run"
		if velocity.x == 0:
			$AnimatedSprite.animation = "idle"
		if velocity.x < 0:
			$AnimatedSprite.animation = "run"

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
