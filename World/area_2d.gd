extends Area2D

func _ready():
	connect("body_entered", _on_body_entered)

func _on_body_entered(body):
	if body is CharacterBody2D:
		var dir = global_position.direction_to(body.global_position)
		body.velocity += dir * 800
