extends KinematicBody2D

#onready var ball = preload("res://scenes/Ball.tscn")
var ball = load("res://scenes/Ball.tscn")

export var speed = 200
export var randRange = 10
var velocity = Vector2()
var isInPlay = false
var scoreMult = 1.5
var default_score_inc = 100
var score_inc = 100
var level_complete
var rng = RandomNumberGenerator.new()

signal no_bricks_remaining


# Called when the node enters the scene tree for the first time.
func _ready():
	global.ball = self
	rng.randomize()
	level_complete = false
	add_to_group("ball")
	get_parent().get_node("DeathZone").attach_to_signal(self)
	connect("no_bricks_remaining", get_parent().get_node("UI"), "_on_Ball_no_bricks_remaining")
	connect("no_bricks_remaining", get_parent().get_node("Paddle"), "_on_Ball_no_bricks_remaining")

	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	if !isInPlay:
		attach_ball_to_paddle() 
	elif level_complete:
		velocity = Vector2(0,0)
	else:
		handle_collisions(delta)
				
				

func handle_collisions(delta):
	var collisionInfo = move_and_collide(velocity * delta)
	if collisionInfo:
		if collisionInfo.collider == global.paddle:
			velocity = -(global_position.direction_to(global.paddle.get_node("Pivot").global_position) * speed)
			reset_score_inc()
		elif collisionInfo.collider == global.deathZone:
			_on_DeathZone_body_entered(self)
		else:
			velocity = velocity.bounce(collisionInfo.normal)
			if collisionInfo.collider.is_in_group("bricks"):
				hit_brick(collisionInfo)
#			else:
#				get_parent().get_node("Camera").shake(1, 3, 0.5)

func hit_brick(collisionInfo):
	if collisionInfo.collider.is_in_group("powerupbricks"):
		collisionInfo.collider.drop_powerup()
	collisionInfo.collider.queue_free()
	increase_score()
	score_inc *= scoreMult
	#print("Bricks Remaining = " + str(get_parent().get_node("Bricks").get_child_count()))
	if get_parent().get_node("Bricks").get_child_count() <= 1:
		end_level()
	if get_tree().get_nodes_in_group("bricks").size() <= 1:
		end_level()

func launch():
	if !isInPlay:
		isInPlay = true
		rng.randomize()
		velocity = Vector2(rand_range(-randRange, randRange), -speed)

func increase_score():
	global.score += int(score_inc)

func reset_score_inc():
	score_inc = default_score_inc

func _on_DeathZone_body_entered(body):
	if body == self:
		print(get_tree().get_nodes_in_group("ball").size())
		if get_tree().get_nodes_in_group("ball").size() <= 1:
			global.player_lives = global.player_lives - 1
			global.paddle.restore_defaults()
			for powerup in get_tree().get_nodes_in_group("powerups"):
				powerup.queue_free()
			velocity = Vector2(0,0)
			reset_score_inc()
			isInPlay = false
			if global.player_lives <= 0:
				get_tree().change_scene("res://scenes/GameOver.tscn")
		else:
			queue_free()

func attach_ball_to_paddle():
	position.x = global.paddle.get_pos().x
	position.y = global.paddle.get_pos().y - (global.paddle.get_half_height() + 1 + $Sprite.get_rect().size.y/2)

func end_level():
	emit_signal("no_bricks_remaining")
	level_complete = true
	get_tree().paused = true
	
func split():
	var newBall = ball.instance()
	newBall.isInPlay = true
	newBall.velocity.y = rand_range((velocity.y - randRange), (velocity.y + randRange))
	newBall.velocity.x = -velocity.x
	newBall.position = position
	newBall.add_to_group("ball")
	get_parent().add_child(newBall)

func _on_Paddle_powerup_split_ball():
	pass # Replace with function body.
