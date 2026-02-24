extends PathFollow2D


@export var speed := 200.0
var direction := 1

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
