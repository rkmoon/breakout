extends "res://scenes/powerups/Powerup.gd"

func _ready():
	pass

func select_powerup(paddle):
	paddle.collect_extend_paddle()