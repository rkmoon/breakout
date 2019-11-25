extends MarginContainer

export var player_lives = 3
var score = 0
var save_file = File.new()
var high_score
# Called when the node enters the scene tree for the first time.
func _ready():
	check_high_score()
	$VBoxContainer/HighScore.text = "High Score: " + high_score

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func check_high_score():
	save_file.open(global.save_game, File.READ)
	high_score = save_file.get_as_text()
	save_file.close()
	

func _on_StartGame_button_down():
	global.player_lives = player_lives
	global.score = score
	get_tree().change_scene("res://scenes/level1.tscn")



func _on_Quit_button_down():
	get_tree().quit()
