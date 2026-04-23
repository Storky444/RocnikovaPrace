extends Control


func _on_start_game_button_pressed() -> void:
	get_tree().change_scene_to_file("res://World/world.tscn")


func _on_tutorial_button_pressed() -> void:
	$TutorialPopup.visible = true


func _on_settings_button_pressed() -> void:
	$SettingsPopup.visible = true
	


func _on_exit_button_pressed() -> void:
	get_tree().quit()


func _on_close_button_pressed() -> void:
	$TutorialPopup.visible = false
	$SettingsPopup.visible = false
	



func _on_volume_slider_value_changed(value: float) -> void:
	$SettingsPopup/VolumePercent.text = str(int(value)) + "%"

	if value <= 0:
		AudioServer.set_bus_mute(0, true)
	else:
		AudioServer.set_bus_mute(0, false)
		AudioServer.set_bus_volume_db(0, linear_to_db(value / 100.0))
