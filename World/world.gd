extends Node2D

@export var object_scenes: Array[PackedScene]
@export var object_count: int = 400
@export var spawn_area_position: Vector2 = Vector2(-2000, -2200)
@export var spawn_area_size: Vector2 = Vector2(7200, 4800)
@export var min_distance_between_objects: float = 120.0


func _ready():
	randomize()
	spawn_objects()


func spawn_objects():
	if object_scenes.is_empty():
		print("No object scenes assigned!")
		return

	var objects_node = $Content/Object_Rocks
	var objects_node2 = $Content/Object_Cactuses
	var objects_node3 = $Content/Object_Skulls
	var placed_positions: Array[Vector2] = []

	for i in range(object_count):
		var attempts = 0
		var max_attempts = 100

		while attempts < max_attempts:

			var random_position = Vector2(
				randf_range(
					spawn_area_position.x,
					spawn_area_position.x + spawn_area_size.x
				),
				randf_range(
					spawn_area_position.y,
					spawn_area_position.y + spawn_area_size.y
				)
			)
			
				
			var overlapping = false

			for pos in placed_positions:
				if random_position.distance_to(pos) < min_distance_between_objects:
					overlapping = true
					break

			if not overlapping:
				var random_scene = object_scenes.pick_random()
				var object = random_scene.instantiate()

				object.position = random_position

				objects_node.add_child(object)
				placed_positions.append(random_position)
				break

			attempts += 1
