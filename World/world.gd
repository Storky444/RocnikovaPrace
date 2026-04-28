extends Node2D

@export var object_scenes: Array[PackedScene]
@export var object_count: int = 500
@export var spawn_area_position: Vector2 = Vector2(-2000, -2200)
@export var spawn_area_size: Vector2 = Vector2(7200, 4800)
@export var min_distance_between_objects: float = 80.0
@export var min_distance_per_scene: Array[float] = []

@export var enemy_scenes: Array[PackedScene]
@export var enemy_spawn_radius_min: float = 100.0
@export var enemy_spawn_radius_max: float = 300.0
@export var max_enemies: int = 300

# cas preziti hrace
var elapsed_time: float = 0.0
var spawn_timer: float = 0.0

# reference na UI cas
var time_label: Label = null
var player: Node2D = null

# death screen
var death_screen: CanvasLayer = null
var is_game_over := false

func _ready():
	randomize()
	spawn_objects() 

	# najde hrace podle group
	player = get_tree().get_first_node_in_group("player") as Node2D
	time_label = get_tree().get_first_node_in_group("timer_label") as Label
	death_screen = $DeathScreen
	
func _process(delta):
	if not player:
		return

	if time_label == null:
		return

	# ziskani hp hrace
	var hp_val = player.get("hp")
	if hp_val == null:
		return

	# kontrola smrti hrace
	if int(hp_val) <= 0 and not is_game_over:
		game_over()
		return

	# pricita cas
	elapsed_time += delta
	spawn_timer += delta

	update_timer_label()

	# kontrola jestli je cas spawnout nepratele
	if spawn_timer >= get_spawn_interval():
		spawn_timer = 0.0
		spawn_enemies_by_time()

func update_timer_label():
	if time_label == null:
		return

	var total_seconds = int(elapsed_time)
	var minutes = int(total_seconds / 60)
	var seconds = int(total_seconds % 60)
	time_label.text = "%02d:%02d" % [minutes, seconds]

func get_spawn_interval() -> float:
	# cim dele hra trva, tim casteji spawn
	return max(1.0, 3.0 - elapsed_time / 45.0)

func get_spawn_count() -> int:
	return 1 + int(elapsed_time / 30.0)

func spawn_enemies_by_time():
	if not player:
		return
		
	var current_enemy_count = get_tree().get_nodes_in_group("enemy").size()
	if current_enemy_count >= max_enemies:
		return

	var count_to_spawn = get_spawn_count()

	for i in range(count_to_spawn):
		# kontrola max limitu
		if get_tree().get_nodes_in_group("enemy").size() >= max_enemies:
			break
		spawn_one_enemy()

func spawn_one_enemy():
	if enemy_scenes.is_empty():
		return

	# nahodny vyber nepratele
	var enemy_scene = enemy_scenes.pick_random()

	var enemy = enemy_scene.instantiate()

	# nahodna pozice kolem hrace
	var angle = randf() * TAU
	var distance = randf_range(enemy_spawn_radius_min, enemy_spawn_radius_max)
	var offset = Vector2(cos(angle), sin(angle)) * distance

	# nastaveni pozice nepratele
	enemy.global_position = player.global_position + offset
	$Content.add_child(enemy)

func game_over() -> void:
	is_game_over = true

	if death_screen:
		death_screen.show_death_screen(elapsed_time)

	get_tree().paused = true

func spawn_objects():
	if object_scenes.is_empty():
		return

	var objects_node = $Content/Object_Rocks
	var placed_positions: Array[Vector2] = []

	for i in range(object_count):
		var attempts = 0
		var max_attempts = 100

		while attempts < max_attempts:
			var random_position = Vector2(
				randf_range(spawn_area_position.x, spawn_area_position.x + spawn_area_size.x),
				randf_range(spawn_area_position.y, spawn_area_position.y + spawn_area_size.y)
			)

			# nahodny typ objektu
			var random_scene = object_scenes.pick_random()
			var scene_index = object_scenes.find(random_scene)

			var min_distance = min_distance_between_objects
			if scene_index != -1 and scene_index < min_distance_per_scene.size():
				min_distance = min_distance_per_scene[scene_index]

			var overlapping = false
			for pos in placed_positions:
				if random_position.distance_to(pos) < min_distance:
					overlapping = true
					break

			if not overlapping:
				var object = random_scene.instantiate()
				object.position = random_position
				objects_node.add_child(object)
				placed_positions.append(random_position)
				break

			attempts += 1
