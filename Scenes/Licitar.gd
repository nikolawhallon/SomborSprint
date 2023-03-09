extends Area2D

func destroy():
	get_tree().queue_delete(self)
	
func _on_Licitar_body_entered(body):
	if body.is_in_group("Player"):
		if self.is_in_group("LicitarA"):
			body.collect_licitar(1)
		if self.is_in_group("LicitarB"):
			body.collect_licitar(3)
		destroy()
