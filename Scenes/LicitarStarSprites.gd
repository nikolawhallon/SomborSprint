extends Node2D

var rng = RandomNumberGenerator.new()

func _ready():
	rng.randomize()

	var probability = rng.randf()
	if probability < 1.0:
		$StarA.visible = false
		$StarB.visible = false
		$StarC.visible = true
		$StarD.visible = false
	# we could use the other star variants if desired as well
