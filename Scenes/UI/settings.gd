extends Control

var button_type = null

func _ready() -> void:
	$Transition/AnimationPlayer.play("fade_out")

func _on_volume_value_changed(value: float) -> void:
	AudioServer.set_bus_volume_db(0,value)


func _on_resolutions_item_selected(index: int) -> void:
	match index:
		0: 
			DisplayServer.window_set_size(Vector2i(1920,1080))
		1:
			DisplayServer.window_set_size(Vector2i(1600,900))
		2:
			DisplayServer.window_set_size(Vector2i(1280,720))


func _on_button_pressed() -> void:
	$Transition.show()
	$Transition/AnimationPlayer.play("fade_in")
	$Transition/Fade_timer.start()


func _on_fade_timer_timeout() -> void:
	get_tree().change_scene_to_file("res://Scenes/UI/MainMenu.tscn")
