extends CharacterBody2D

@export var speed: float = 200.0
@export var max_hp: int = 200
@export var hp: int = 200
@export var regen_amount: int = 5
@export var regen_interval: float = 1.5
@export var regen_delay: float = 3.0
@export var bullet_scene: PackedScene
@export var fire_rate: float = 4.0
@export var bullet_spawn_offset: float = 0.0
@export var shoot_sound: AudioStream
@export var footstep_delay: float = 0.35

var can_shoot: bool = true
var shoot_cooldown: float = 0.0
var can_take_damage: bool = true
var regen_active: bool = false
var footstep_timer: float = 0.0

@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var hp_bar: ProgressBar = $ProgressBar
@onready var regeneration_timer: Timer = $Regeneration_Timer
@onready var hp_label: Label = $ProgressBar/Label
@onready var bullet_spawn: Marker2D = $BulletSpawn
@onready var footstep_player: AudioStreamPlayer2D = $FootstepPlayer

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
	handle_footsteps(delta)

	if not can_shoot:
		shoot_cooldown -= delta
		if shoot_cooldown <= 0.0:
			can_shoot = true

	if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT) and can_shoot:
		shoot()

# zvuky kroku pri pohybu hrace
func handle_footsteps(delta: float) -> void:
	if velocity.length() > 0:
		footstep_timer -= delta

		if footstep_timer <= 0.0:
			play_footstep()
			footstep_timer = footstep_delay
	else:
		footstep_timer = 0.0
		
		if footstep_player.playing:
			footstep_player.stop()
			
# prehrani jednoho kroku
func play_footstep() -> void:
	if footstep_player == null:
		return

	if footstep_player.stream == null:
		return

	footstep_player.pitch_scale = randf_range(0.6, 1)
	footstep_player.play()

# vytvori zvuk vystrelu, spawne kulku a nastavi ji smer podle pozice mysi
func shoot() -> void:
	if bullet_scene == null:
		return

	if bullet_spawn == null:
		return

	can_shoot = false
	shoot_cooldown = 1.0 / fire_rate

	var player = AudioStreamPlayer2D.new()
	player.stream = shoot_sound
	player.global_position = global_position
	get_tree().current_scene.add_child(player)
	player.play()

	player.finished.connect(func(): player.queue_free())

	var bullet = bullet_scene.instantiate()
	var mouse_pos = get_global_mouse_position()
	var shoot_direction = (mouse_pos - bullet_spawn.global_position).normalized()

	get_parent().add_child(bullet)

	bullet.global_position = bullet_spawn.global_position
	bullet.direction = shoot_direction
	bullet.rotation = shoot_direction.angle()

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

# po zasahu se odecte hp, na chvili se zakaze dalsi damage a po delay zacne regenerace
func take_damage(amount: int) -> void:
	if not can_take_damage:
		return

	can_take_damage = false
	regen_active = false
	regeneration_timer.stop()

	hp -= amount
	hp = clamp(hp, 0, max_hp)
	update_hp_bar()

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
	else:
		regen_active = false
		regeneration_timer.stop()
