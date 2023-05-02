extends Node2D

func _unhandled_input(event):
	if Input.is_action_just_pressed("start"):
		get_tree().change_scene("res://Scenes/Game.tscn")

func _process(delta):
	$Logo.position.x += 100.0 * delta
