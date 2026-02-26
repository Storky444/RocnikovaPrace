extends CharacterBody2D
var hp = 100
var speed = 200.0  

@onready var animated_sprite = $AnimatedSprite2D

	

func _physics_process(delta):
	var direction = Input.get_vector("left", "right", "up", "down")
	velocity = direction * speed
	
	move_and_slide()
	update_animation(direction)

func update_animation(direction):
	if direction == Vector2.ZERO:
		animated_sprite.play("Idle")
		return
	
	if abs(direction.x) > abs(direction.y):
		if direction.x > 0:
			animated_sprite.play("Run_Right")
		else:
			animated_sprite.play("Run_Left")
	else:
		if direction.y > 0:
			animated_sprite.play("Run_Down")
		else:
			animated_sprite.play("Run_Up")

func take_damage(amount):
	hp -= amount
	if hp <= 0:
		die()

func die():
	queue_free()
