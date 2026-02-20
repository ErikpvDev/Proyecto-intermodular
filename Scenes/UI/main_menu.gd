extends Control

var button_type = null

func _ready() -> void:
	MusicManager.play()

func _on_play_pressed() -> void:
	button_type="play"
	$Transition.show()
	$Transition/AnimationPlayer.play("fade_in")
	$Transition/Fade_timer.start()


func _on_options_pressed() -> void:
	button_type="settings"
	$Transition.show()
	$Transition/Fade_timer.start()
	$Transition/AnimationPlayer.play("fade_in")
	
	
func _on_quit_pressed() -> void:
	get_tree().quit()


func _on_fade_timer_timeout() -> void:
	if button_type == "play":
		get_tree().change_scene_to_file("res://Scenes/Game/game.tscn")
	elif button_type == "settings":
		get_tree().change_scene_to_file("res://Scenes/UI/settings.tscn")
