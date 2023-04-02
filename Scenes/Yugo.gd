extends Area2D

var velocity = Vector2.ZERO

func destroy():
	get_tree().queue_delete(self)

func _process(delta):
	position += velocity * delta

func _on_Yugo_body_entered(body):
	if body.is_in_group("Player"):
		if body.has_opanci:
			rotation = 45
			var speed = velocity.length() + body.velocity.length()
			velocity.x = speed
			velocity.y = -speed
			#destroy()
		else:
			body.take_damage()
