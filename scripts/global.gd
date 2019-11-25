extends Node


var player_lives = 3
var score = 0
var paddle
var ball
var brickholder
var deathZone
var levels = ["level1", "level2", "level3", "level4"]
var curLevel = 0
var save_game = "user://save_game.txt"

var powerups = [ 
	preload("res://scenes/powerups/SplitBall.tscn"),
	preload("res://scenes/powerups/ExtendPaddle.tscn"),
	preload("res://scenes/powerups/ExtraLife.tscn")
	]

func _ready():
	add_to_group("persist", true)