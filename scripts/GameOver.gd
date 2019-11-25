extends MarginContainer

var save_game = global.save_game
var save_file = File.new()
var is_new_high_score = false
var old_high_score

# Called when the node enters the scene tree for the first time.
func _ready():
	check_cur_high_score()
	if(is_new_high_score):
		save_score()
	set_player_score_text()

func set_player_score_text():
	$VBoxContainer/VBoxContainer/YourScore.text = "Your Score: " + str(global.score)

func _on_TryAgain_button_down():
	global.score = 0
	global.player_lives = 3
	global.curLevel = 0
	get_tree().change_scene("res://scenes/level1.tscn")

func check_cur_high_score():
	if !(save_file.file_exists(save_game)):
		is_new_high_score = true
	else:
		save_file.open(save_game, File.READ)
		old_high_score = save_file.get_as_text()
		if (int(old_high_score) > global.score):
			$VBoxContainer/VBoxContainer/HighScore.text = "High Score: " + old_high_score
		else:
			is_new_high_score = true
		save_file.close()



func _on_Quit_button_down():
	get_tree().quit()

func save_score():
	save_file.open(save_game, File.WRITE)
	save_file.store_string(str(global.score))
	save_file.close()
	$VBoxContainer/VBoxContainer/NewHighScore.text  = "New High Score!"
	$VBoxContainer/VBoxContainer/HighScore.text = "High Score: " + str(global.score)
