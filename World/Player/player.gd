extends CharacterBody2D

var speed = 150.0  

@onready var animated_sprite = $AnimatedSprite2D

func _physics_process(delta):
	var direction = Input.get_vector("left", "right", "up", "down")
	velocity = direction * speed
			
	if not Input.is_anything_pressed():
		animated_sprite.play("Iddle")
	else:
		animated_sprite.stop()
	

	move_and_slide()
	
	
