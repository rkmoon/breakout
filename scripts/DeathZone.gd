extends Area2D

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

# Called when the node enters the scene tree for the first time.
func _ready():
	global.deathZone = self

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
func attach_to_signal(object):
	connect("body_entered", object, "_on_DeathZone_body_entered")
