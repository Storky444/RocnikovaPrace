extends PathFollow2D



var direction := 1
var speed : float

func _ready():
	z_index = 5
	speed = randf_range(100,200)

func _process(delta):
	progress += speed * direction * delta

	if progress_ratio >= 1.0:
		direction = -1
		flip()

	if progress_ratio <= 0.0:
		direction = 1
		flip()

func flip():
	$AnimatedSprite2D.flip_h = !$AnimatedSprite2D.flip_h
	
