extends CanvasLayer

@onready var time_label: Label = $CenterContainer/VBoxContainer/TimeLabel

func show_death_screen(survival_time: float) -> void:
	visible = true

	var total_seconds = int(survival_time)
	var minutes = int(total_seconds / 60)
	var seconds = int(total_seconds % 60)

	time_label.text = "You survived: %02d:%02d" % [minutes, seconds]

func _on_main_menu_button_pressed() -> void:
	get_tree().paused = false
	get_tree().change_scene_to_file("res://main_menu.tscn")

func _on_exit_button_pressed() -> void:
	print("EXIT BUTTON CLICKED")
	get_tree().paused = false
	get_tree().quit()
