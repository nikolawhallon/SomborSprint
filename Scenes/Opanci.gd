extends Area2D

func destroy():
	get_tree().queue_delete(self)
	
func _on_Opanci_body_entered(body):
	if body.is_in_group("Player"):
		body.has_opanci = true
		visible = false
		set_collision_layer_bit(0, false)
		set_collision_mask_bit(0, false)
		$AudioStreamPlayer2D.play()

func _on_AudioStreamPlayer2D_finished():
	destroy()
