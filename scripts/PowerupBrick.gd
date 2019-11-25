extends "res://scripts/Brick.gd"

var powerup = preload("res://scenes/powerups/Powerup.tscn")

var rng = RandomNumberGenerator.new()
var randomPowerup



func _ready():
	pass # Replace with function body.

func drop_powerup():
	randomize()
	randomPowerup = global.powerups[randi() % global.powerups.size()]
	var newPowerup = randomPowerup.instance()
	get_parent().add_child(newPowerup)
	newPowerup.position = position
