extends KinematicBody2D

var ball = preload("res://scenes/Ball.tscn")

var velocity = Vector2()
var startPos = Vector2()
export var paddle_height = 30
export var speed = 10
var balls = []
var level_complete




# Called when the node enters the scene tree for the first time.
func _ready():
	set_start_pos()
	global.paddle = self
	level_complete = false

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	handle_movement(delta)
	if Input.is_action_just_pressed("ui_accept"):
		collect_split_ball()
		
	
func get_pos():
	return position

func get_half_height():
	return $Sprite.get_rect().size.y/2

func handle_movement(delta):
	handle_input()
	var colliderInfo = move_and_collide(velocity * delta)
	if colliderInfo:
		if colliderInfo.collider.is_in_group("powerups"):
			colliderInfo.collider.give_powerup(self)
#		elif colliderInfo.collider.is_in_group("ball"):
#			colliderInfo.collider.velocity = -(colliderInfo.collider.global_position.direction_to($Pivot.global_position) * speed)
#			colliderInfo.collider.reset_score_inc()
	
func handle_input():
	if (level_complete == true):
		velocity = Vector2(0,0)
	elif (Input.is_action_pressed("paddle_left") and Input.is_action_pressed("paddle_right")):
		velocity.x = 0
	elif Input.is_action_pressed("paddle_left"):
		if position.x > (0 + ($Sprite.get_rect().size.x/2)):
			velocity.x = -speed
		else:
			velocity.x = 0
	elif Input.is_action_pressed("paddle_right"):
		if position.x < (get_viewport_rect().size.x - ($Sprite.get_rect().size.x/2)):
#			print(String(get_viewport_rect().size.x) + " Pos: " + String(position.x))
			velocity.x = speed
		else:
			velocity.x = 0
	else:
		velocity.x = 0
	
	if (Input.is_action_just_pressed("launch_ball")):
		var balls = get_tree().get_nodes_in_group("ball")
		balls[0].launch()
	
func set_start_pos():
	startPos.x = get_viewport_rect().size.x/2
	startPos.y = get_viewport_rect().size.y - paddle_height
	position = startPos

func _on_Ball_no_bricks_remaining():
	level_complete = true


func collect_split_ball():
	balls = get_tree().get_nodes_in_group("ball")
	for ball in balls:
		ball.split()
		ball.isInPlay = true
	
	
func collect_extend_paddle():
	scale.x *= 1.5

func collect_extra_life():
	global.player_lives += 1
	
	
func _on_Timer_timeout():
	balls = get_tree().get_nodes_in_group("ball")
	if balls.size() <= 0:
		var newBall = ball.instance()
		get_parent().add_child(newBall)
		newBall._on_DeathZone_body_entered(newBall)
		
func restore_defaults():
	scale.x = 1.0
