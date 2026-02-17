extends Timer

var medium_rock = preload("res://textures/Medium_Rock1.png")
var big_rock = preload("res://textures/Big_Rock.png")
var small_rock = preload("res://textures/Small_Rock.png")

func _on_timeout() -> void:
	randomize()
	var rocks = [small_rock, medium_rock, big_rock]
	var kinds = rocks[randi()% rocks.size()]
	var rock = kinds.instance()
	rock.position = Vector2(rand_range(10, 990), rand_range(10, 590))
	add_child(rock)
	wait_time = rand_range(1, 0)
	
	
