extends Area2D

func destroy():
	get_tree().queue_delete(self)
	
func _on_Fez_body_entered(body):
	if body.is_in_group("Player"):
		body.has_fez = true
		destroy()
