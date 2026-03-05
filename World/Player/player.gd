extends CharacterBody2D
var can_take_damage = true
var speed = 200.0  

@onready var animated_sprite = $AnimatedSprite2D
@export var hp: int = 100

	

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

func take_damage(amount: int) -> void:
	hp = max(hp, 0)
	hp -= amount
	print("damage took", amount, "hp =", hp)

	if hp <= 0:
		die()

func die():
	print("GAME OVER")
	get_tree().paused = true


func _on_hurtbox_area_entered(area):

	if area.is_in_group("enemy_attack") and can_take_damage:
		
		can_take_damage = false
		
		hp -= 20
		print("HP:", hp)
		
		await get_tree().create_timer(1).timeout
		
		can_take_damage = true
