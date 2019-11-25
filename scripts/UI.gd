extends Control

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

# Called when the node enters the scene tree for the first time.
func _ready():
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	$VBoxContainer/HBoxContainer/Score.text = "Score = " + str(global.score)
	$VBoxContainer/HBoxContainer/Lives.text = "Lives = " + str(global.player_lives)


func _on_Ball_no_bricks_remaining():
	$VBoxContainer/EndText.show()
	#set_as_toplevel(true)


func _on_Continue_button_down():
	global.curLevel = global.curLevel + 1
	get_tree().paused = false
#	print("Loading " + global.levels[global.curLevel])
	if global.curLevel >= 4:
		get_tree().change_scene("res://scenes/GameOver.tscn")
	else:
		get_tree().change_scene("res://scenes/" + global.levels[global.curLevel] + ".tscn")
