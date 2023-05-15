extends Area2D

func destroy():
	get_tree().queue_delete(self)
	
func _on_Licitar_body_entered(body):
	if body.is_in_group("Player"):
		if self.is_in_group("LicitarA"):
			body.collect_licitar(1)
		if self.is_in_group("LicitarB"):
			body.collect_licitar(3)
		if self.is_in_group("LicitarC"):
			body.collect_licitar(5)
		if self.is_in_group("LicitarStar"):
			body.collect_licitar(10)
		visible = false
		set_collision_layer_bit(0, false)
		set_collision_mask_bit(0, false)
		$AudioStreamPlayer2D.play()

func _on_AudioStreamPlayer2D_finished():
	destroy()
