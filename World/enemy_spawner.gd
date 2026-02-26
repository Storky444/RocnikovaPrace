extends Node2D

@export var enemy_scene : PackedScene
@export var spawn_radius = 500

func _ready():
	await get_tree().process_frame  
	
	var player = get_tree().get_first_node_in_group("player")
	
	if not player:
		print("PLAYER NOT FOUND")
		return
	
	spawn_enemy(player)

func spawn_enemy(player):
	var angle = randf() * TAU
	var offset = Vector2(cos(angle), sin(angle)) * spawn_radius
	
	var enemy = enemy_scene.instantiate()
	enemy.global_position = player.global_position
	
	get_parent().add_child(enemy)
	
	print("ENEMY SPAWNED")
	print(enemy.global_position)
