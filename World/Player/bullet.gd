extends Area2D

@export var speed: float = 500.0
@export var damage: int = 20
@export var life_time: float = 2.0

var direction: Vector2 = Vector2.RIGHT
var has_hit: bool = false

func _ready() -> void:
	body_entered.connect(_on_body_entered)
	area_entered.connect(_on_area_entered)

	await get_tree().create_timer(life_time).timeout
	if is_instance_valid(self):
		queue_free()

func _physics_process(delta: float) -> void:
	global_position += direction * speed * delta

func _on_body_entered(body: Node) -> void:
	if has_hit:
		return

	var enemy = find_enemy_owner(body)
	if enemy != null and enemy.has_method("take_damage"):
		has_hit = true
		enemy.take_damage(damage)
		queue_free()

func _on_area_entered(area: Area2D) -> void:
	if has_hit:
		return

	var enemy = find_enemy_owner(area)
	if enemy != null and enemy.has_method("take_damage"):
		has_hit = true
		enemy.take_damage(damage)
		queue_free()

func find_enemy_owner(node: Node) -> Node:
	var current = node

	while current != null:
		if current.is_in_group("enemy"):
			return current
		current = current.get_parent()

	return null
