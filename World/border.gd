extends Node2D

func _ready():
	for side in $Visual.get_children():
		side.play("BorderAnimation")
		$Visual.modulate.a = 0.5
		
