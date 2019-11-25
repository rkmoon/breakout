extends Node2D

onready var brick = preload("res://scenes/Brick.tscn")
onready var powerupBrick = preload("res://scenes/PowerupBrick.tscn")

#export var Xstarting = 40
#export var Xending = 280
#export var Xinterval = 40
#
#export var Ystarting = 20
#export var Yending = 180
#export var Yinterval = 20

var xInterval = 100
var yInterval = 8

var count = 0
var rng = RandomNumberGenerator.new()
var randomPowerupBlocks
var verticalColor = Color()

var colors = [Color.blue, Color.red, Color.green, Color.aquamarine,
			Color.cyan, Color.firebrick, Color.tomato, Color.greenyellow,
			Color.dodgerblue, Color.yellow, Color.limegreen]
# Called when the node enters the scene tree for the first time.
func _ready():
	global.brickholder = self
	xInterval = 32
	yInterval = 8
	rng = RandomNumberGenerator.new()
	rng.randomize()
	randomPowerupBlocks = rng.randi_range(4,7)
	create_level()
	


func create_level():
	var extents = $BrickZone/CollisionShape2D.shape.extents
	var origin = $BrickZone.global_position
	for i in range(origin.x - extents.x, origin.x + extents.x + 1, xInterval):
		randomize()
		verticalColor = colors[randi() % colors.size()]
		for j in range(origin.y - extents.y, origin.y + extents.y, yInterval):
			count += 1
			var newBrick
			if (count % randomPowerupBlocks == 0):
				newBrick = powerupBrick.instance()
			else:
				newBrick = brick.instance()
			newBrick.get_node("Sprite").modulate = verticalColor
			newBrick.position = Vector2(i, j)
			add_child(newBrick)
#	var removeBricks = $NoBrickZone.get_overlapping_areas()
#	print(removeBricks)
#	for brick in removeBricks:
#		brick.queue_free()

#func create_level():
#	for i in range(Xstarting, Xending, Xinterval):
#		randomize()
#		verticalColor = colors[randi() % colors.size()]
#		for j in range(Ystarting, Yending, Yinterval):
#			var newBrick = brick.instance()
#			newBrick.position = Vector2(i, j)
#			newBrick.get_node("Sprite").modulate = verticalColor
#			add_child(newBrick)

func _on_NoBrickZone_area_entered(area):
	pass


func _on_NoBrickZone_area_shape_entered(area_id, area, area_shape, self_shape):
	var removeBricks = $NoBrickZone.get_overlapping_areas()
#	print(removeBricks)
##	for brick in removeBricks:
#		if brick.get_parent().is_in_group("bricks"):
#			brick.get_parent().queue_free()
	print(area)
	if area.get_parent().is_in_group("bricks"):
		area.get_parent().queue_free()
	for brick in removeBricks:
		if brick.get_parent().is_in_group("bricks"):
			brick.get_parent().queue_free()

func _on_Timer_timeout():
	pass
#	for noBrickZone find_in_group("nobricks"):
#		var removeBricks = noBrickZone.get_overlapping_areas()
#		for brick in removeBricks:
#			if brick.get_parent().is_in_group("bricks"):
#				brick.get_parent().queue_free()
