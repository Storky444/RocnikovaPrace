extends CharacterBody2D

@export var speed = 120   # rychlost enemy

var player = null          # reference na hráče

@onready var anim = $AnimatedSprite2D  # odkaz na animace enemy

func _ready():
	# Najde hráče ve skupině "player"
	player = get_tree().get_first_node_in_group("player")
	if not player:
		print("Player ve skupině 'player' nenalezen!")

func _physics_process(delta):
	if not player:
		return

	# Cíl: střed hráče (bere v úvahu offset sprite, pokud existuje)
	var target_pos = player.global_position
	var sprite = player.get_node_or_null("AnimatedSprite2D")
	if sprite:
		target_pos += sprite.position

	# Směr a pohyb
	var direction = target_pos - global_position

	if direction.length() < 1:
		velocity = Vector2.ZERO
		anim.play("Idle")
		return

	velocity = direction.normalized() * speed
	move_and_slide()

	# Animace podle směru pohybu
	update_animation(direction)

func update_animation(direction):
	if abs(direction.x) > abs(direction.y):
		if direction.x > 0:
			anim.play("BigScorpionAnimationRight")
		else:
			anim.play("BigScorpionAnimationLeft")
	else:
		if direction.y > 0:
			anim.play("Walk_Down")
		else:
			anim.play("Walk_Up")
