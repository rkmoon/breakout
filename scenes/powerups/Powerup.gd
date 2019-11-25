extends KinematicBody2D


var velocity = Vector2(0, 50)
func _ready():
	add_to_group("powerups")


func _process(delta):
	handle_movement(delta)
	
func handle_movement(delta):
	var collisionInfo = move_and_collide(velocity * delta)
	if collisionInfo:
		if collisionInfo.collider == global.paddle:
			give_powerup(collisionInfo.collider)
			
func give_powerup(paddle):
	select_powerup(paddle)
	queue_free()
	
func select_powerup(paddle):
	pass