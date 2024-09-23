extends Node

var rng = RandomNumberGenerator.new()
var score = 0

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

	var despawnables = get_tree().get_nodes_in_group("Despawn")
	for despawnable in despawnables:
		if despawnable.global_position.x < $Player.global_position.x - 720:
			despawnable.destroy()
	
func _on_LicitarSpawnTimer_timeout():
	var licitar
	var probability = rng.randf()
	if probability < 0.6:
		licitar = load("res://Scenes/LicitarA.tscn").instance()
	elif probability < 0.9:
		licitar = load("res://Scenes/LicitarB.tscn").instance()
	elif probability < 0.99:
		licitar = load("res://Scenes/LicitarC.tscn").instance()
	else:
		if score > 100:
			licitar = load("res://Scenes/LicitarStar.tscn").instance()
		else:
			licitar = load("res://Scenes/LicitarC.tscn").instance()
	licitar.position.x = $Player.position.x + 854
	licitar.position.y = rng.randf_range(16, 240 - 16)
	add_child(licitar)

func _on_YugoSpawnTimer_timeout():
	var yugo = load("res://Scenes/Yugo.tscn").instance()
	yugo.position.x = $Player.position.x + rng.randi_range(900, 1000)
	yugo.position.y = 240 - 8 - 15
	yugo.velocity.x = rng.randf_range(-100.0, -200.0)
	add_child(yugo)

func spawn_keys():
	for _i in range(1, 100):
		var key = load("res://Scenes/Key.tscn").instance()
		key.position.x = $Player.position.x + rng.randi_range(0, 2000)
		key.position.y = -16 - + rng.randi_range(0, 64)
		key.velocity.y = rng.randf_range(200.0, 400.0)
		add_child(key)
	
func _on_Player_collect_licitar(points):
	score += points
	$CanvasLayer/MarginContainer/HBoxContainer/LicitarScore.text = str(score)
	$Websocket.send_event("LicitarCollected")

func _on_Player_take_damage():
	score = max(score - 5, 0)
	$CanvasLayer/MarginContainer/HBoxContainer/LicitarScore.text = str(score)

func _on_OpanciSpawnTimer_timeout():
	if !$Player.has_opanci:
		var opanci = load("res://Scenes/Opanci.tscn").instance()
		opanci.position.x = $Player.position.x + 854
		opanci.position.y = rng.randf_range(240 - 32, 240 - 16)
		add_child(opanci)

func _on_FezSpawnTimer_timeout():
	if !$Player.has_fez:
		var fez = load("res://Scenes/Fez.tscn").instance()
		fez.position.x = $Player.position.x + 854
		fez.position.y = rng.randf_range(240 - 120, 240 - 96)
		add_child(fez)

func _on_Websocket_event_received(event):
	print("handling event")
	print(event)
	if event == "KeyCollected":
		spawn_keys()
