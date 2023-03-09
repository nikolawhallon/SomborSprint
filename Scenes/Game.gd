extends Node

var rng = RandomNumberGenerator.new()
var score = 0
var started = false

func _input(event):
	if event is InputEventKey:
		if event.pressed and !started:
			started = true
			$Player.visible = true
			$CanvasLayer/Splash.visible = false
			$CanvasLayer/PlayTextContainer.visible = false
			
func _ready():
	rng.randomize()
	$CanvasLayer/MarginContainer/HBoxContainer.add_constant_override("separation", 2)
	$CanvasLayer/MarginContainer/HBoxContainer/LicitarScore.text = str(score)
	
func _process(_delta):
	var player_ground_index = $Player.global_position.x / 720

	var grounds = get_tree().get_nodes_in_group("Ground")

	for ground in grounds:
		var ground_index = ground.global_position.x / 720
		if ground_index < player_ground_index - 1:
			ground.global_position.x += 720 * 2
		if ground_index > player_ground_index + 1:
			ground.global_position.x -= 720 * 2

func _on_LicitarSpawnTimer_timeout():
	var licitar
	if rng.randf() < 0.7:
		licitar = load("res://Scenes/LicitarA.tscn").instance()
	else:
		licitar = load("res://Scenes/LicitarB.tscn").instance()
	licitar.position.x = $Player.position.x + 854
	licitar.position.y = rng.randf_range(16, 240 - 16)
	add_child(licitar)

func _on_YugoSpawnTimer_timeout():
	var yugo = load("res://Scenes/Yugo.tscn").instance()
	yugo.position.x = $Player.position.x + rng.randi_range(900, 1000)
	yugo.position.y = 240 - 8 - 15
	yugo.velocity.x = rng.randf_range(-100.0, -200.0)
	add_child(yugo)

func _on_Player_collect_licitar(points):
	if !started:
		return
	score += points
	$CanvasLayer/MarginContainer/HBoxContainer/LicitarScore.text = str(score)

func _on_Player_take_damage():
	if !started:
		return
	score = max(score - 5, 0)
	$CanvasLayer/MarginContainer/HBoxContainer/LicitarScore.text = str(score)
