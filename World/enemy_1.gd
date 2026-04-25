extends CharacterBody2D

@export var speed := 120
@export var attack_range := 40
@export var attack_duration := 0.35
@export var attack_cooldown := 2
@export var max_hp: int = 50
@export var attack_sound: AudioStream

var hp: int = 50
var player: Node2D = null
var is_attacking := false
var can_attack := true
var is_dead := false

@onready var anim: AnimatedSprite2D = $AnimatedSprite2D
@onready var attack_timer: Timer = Timer.new()
@onready var cooldown_timer: Timer = Timer.new()
@onready var health_bar: ProgressBar = $HealthBar

func _ready():
	add_to_group("enemy")
	hp = max_hp
	player = get_tree().get_first_node_in_group("player") as Node2D

	attack_timer.one_shot = true
	attack_timer.wait_time = attack_duration
	add_child(attack_timer)
	attack_timer.timeout.connect(_on_attack_finished)

	cooldown_timer.one_shot = true
	cooldown_timer.wait_time = attack_cooldown
	add_child(cooldown_timer)
	cooldown_timer.timeout.connect(_on_cooldown_finished)
	
	health_bar.max_value = max_hp
	health_bar.value = hp
	health_bar.visible = false

func _physics_process(delta):
	if is_dead:
		return

	if not player:
		return

	var target_pos := player.global_position
	var sprite = player.get_node_or_null("AnimatedSprite2D")
	if sprite:
		target_pos += sprite.position

	if is_attacking:
		velocity = Vector2.ZERO
		move_and_slide()
		return

	var dist := global_position.distance_to(target_pos)
	if can_attack and dist <= attack_range:
		start_attack()
		return

	var direction := target_pos - global_position
	if direction.length() < 1:
		velocity = Vector2.ZERO
		anim.play("Idle")
		return

	velocity = direction.normalized() * speed
	move_and_slide()
	update_animation(direction)

func play_attack_sound() -> void:
	if attack_sound == null:
		return

	var sound_player = AudioStreamPlayer2D.new()
	sound_player.stream = attack_sound
	sound_player.global_position = global_position
	sound_player.pitch_scale = randf_range(0.95, 1.05)

	get_tree().current_scene.add_child(sound_player)
	sound_player.play()
	sound_player.finished.connect(func(): sound_player.queue_free())

func start_attack():
	can_attack = false
	is_attacking = true
	velocity = Vector2.ZERO

	anim.stop()
	anim.play("SkeletonAnimationAttack")
	play_attack_sound()

	await get_tree().create_timer(0.15).timeout

	if is_dead:
		return

	if player and player.has_method("take_damage"):
		player.take_damage(15)

	attack_timer.start()

func _on_attack_finished():
	is_attacking = false
	cooldown_timer.start()

func _on_cooldown_finished():
	can_attack = true

func update_health_bar() -> void:
	health_bar.max_value = max_hp
	health_bar.value = hp

func update_animation(direction: Vector2):
	if abs(direction.x) > abs(direction.y):
		if direction.x > 0:
			anim.play("SkeletonAnimationRight")
		else:
			anim.play("SkeletonAnimationLeft")
	else:
		if direction.y > 0:
			anim.play("SkeletonAnimationDown")
		else:
			anim.play("SkeletonAnimationUp")
			
func take_damage(amount: int) -> void:
	if is_dead:
		return

	hp -= amount
	hp = clamp(hp, 0, max_hp)

	health_bar.visible = true
	update_health_bar()

	print(name, " dostal damage: ", amount, " | hp: ", hp)

	if hp <= 0:
		die()

func die() -> void:
	if is_dead:
		return

	is_dead = true
	is_attacking = false
	can_attack = false
	velocity = Vector2.ZERO

	attack_timer.stop()
	cooldown_timer.stop()

	health_bar.visible = false

	anim.stop()
	anim.play("SkeletonAnimationDeath")
	

	await anim.animation_finished
	queue_free()

func _on_health_bar_value_changed(value: float) -> void:
	pass
