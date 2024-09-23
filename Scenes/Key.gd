extends Area2D

var velocity = Vector2.ZERO

func destroy():
	get_tree().queue_delete(self)

func _process(delta):
	position += velocity * delta
	
	if global_position.y > 480 * 2:
		destroy()


func _on_Key_body_entered(body):
	if body.is_in_group("Player"):
		body.take_damage()
