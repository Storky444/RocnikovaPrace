extends CharacterBody2D


@export var speed = 80
@export var damage = 10

var player = null
var attacking = false

@onready var anim = $AnimatedSprite2D
@onready var attack_range = $AttackRange

func _ready():
	player = get_tree().get_first_node_in_group("player")

func _physics_process(delta):
	if not player or attacking:
		return
	
	var direction = (player.global_position - global_position).normalized()
	velocity = direction * speed
	move_and_slide()
	
	update_animation(direction)

func update_animation(direction):
	if abs(direction.x) > abs(direction.y):
		if direction.x > 0:
			anim.play("Walk_Right")
		else:
			anim.play("Walk_Left")
	else:
		if direction.y > 0:
			anim.play("Walk_Down")
		else:
			anim.play("Walk_Up")


func _on_attack_range_body_entered(body):
	if body.is_in_group("player") and not attacking:
		start_attack(body)

func start_attack(target):
	attacking = true
	velocity = Vector2.ZERO
	
	anim.play("Attack")
	await anim.animation_finished
	
	if target:
		target.take_damage(damage)
	
	attacking = false
