extends CharacterBody2D

var speed = 2000.0  
@onready var Object_Cactus = $"../Content/Object_Cactuses"
@onready var animated_sprite = $AnimatedSprite2D

func _ready():
	position = Vector2(1200, 900)

func _physics_process(delta):
	var direction = Input.get_vector("left", "right", "up", "down")
	velocity = direction * speed
 
			
	if Input.is_key_pressed(KEY_W):
		animated_sprite.play("Run_Up")
		
	elif Input.is_key_pressed(KEY_S):
		animated_sprite.play("Run_Down")
		
	elif Input.is_key_pressed(KEY_D):
		animated_sprite.play("Run_Right")
		
	elif Input.is_key_pressed(KEY_A):
		animated_sprite.play("Run_Left")
		
	else:
		animated_sprite.play("Idle")
		
	
	move_and_slide()
	
	
