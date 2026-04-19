extends CharacterBody2D

@export var speed: float = 200.0
@export var max_hp: int = 200
@export var hp: int = 200
@export var regen_amount: int = 5
@export var regen_interval: float = 1.5
@export var regen_delay: float = 3.0

var can_take_damage: bool = true
var regen_active: bool = false

@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var hp_bar: ProgressBar = $ProgressBar
@onready var regeneration_timer: Timer = $Regeneration_Timer
@onready var hp_label: Label = $ProgressBar/Label

func _ready():
	add_to_group("player")

	hp = max_hp

	hp_bar.min_value = 0
	hp_bar.max_value = max_hp
	hp_bar.value = hp

	update_hp_bar()

	regeneration_timer.wait_time = regen_interval
	regeneration_timer.timeout.connect(_on_regeneration_timer_timeout)

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
	if not can_take_damage:
		return

	can_take_damage = false
	regen_active = false
	regeneration_timer.stop()

	hp -= amount
	hp = clamp(hp, 0, max_hp)
	update_hp_bar()

	print("damage took", amount, "hp =", hp)

	if hp <= 0:
		die()
		return

	await get_tree().create_timer(1.0).timeout
	can_take_damage = true

	await get_tree().create_timer(regen_delay).timeout

	if hp > 0 and hp < max_hp:
		regen_active = true
		regeneration_timer.start()

func update_hp_bar() -> void:
	hp_bar.max_value = max_hp
	hp_bar.value = hp
	hp_label.text = str(hp) + " / " + str(max_hp) + " HP"

func _on_regeneration_timer_timeout() -> void:
	if not regen_active:
		return

	if hp < max_hp:
		hp += regen_amount
		hp = clamp(hp, 0, max_hp)
		update_hp_bar()
		print("healing... hp =", hp)
	else:
		regen_active = false
		regeneration_timer.stop()

func die():
	print("GAME OVER")
	get_tree().paused = true
