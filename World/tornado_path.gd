extends PathFollow2D
var speed : float
func _ready():
	speed = randf_range(100,200)
	
func _process(delta):
	progress += speed * delta
