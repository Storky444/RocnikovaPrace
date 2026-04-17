extends Control


func _on_start_game_button_pressed() -> void:
	get_tree().change_scene_to_file("res://World/world.tscn")


func _on_tutorial_button_pressed() -> void:
	$TutorialPopup.visible = true


func _on_settings_button_pressed() -> void:
	pass # Replace with function body.


func _on_exit_button_pressed() -> void:
	get_tree().quit()


func _on_close_button_pressed() -> void:
	$TutorialPopup.visible = false
