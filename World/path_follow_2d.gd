extends PathFollow2D
var speed = 200
func _ready():
	pass
	
func _process(delta):
	progress += speed * delta
