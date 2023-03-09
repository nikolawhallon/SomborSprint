extends Area2D

var velocity = Vector2.ZERO

func _process(delta):
	position += velocity * delta
	
	if velocity.x > 0.0:
		scale.x = -1.0
	else:
		scale.x = 1.0

func _on_Yugo_body_entered(body):
	if body.is_in_group("Player"):
		body.take_damage()
