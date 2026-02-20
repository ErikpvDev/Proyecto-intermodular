extends Control

var button_type = null

func _ready() -> void:
	GlobalSignals.die.connect(die)
	hide()
	
func die():
	toggle_pause()

func _on_volver_menu_pressed() -> void:
	button_type = "menu"
	$Transition.show()
	$Transition/AnimationPlayer.play("fade_in")
	$Transition/Fade_timer.start()

func _on_volver_a_jugar_pressed() -> void:
	button_type = "play"
	$Transition.show()
	$Transition/AnimationPlayer.play("fade_in")
	$Transition/Fade_timer.start()

func _on_fade_timer_timeout() -> void:
	if button_type == "play":
		get_tree().change_scene_to_file("res://Scenes/Game/game.tscn")
	elif button_type == "menu":
		get_tree().change_scene_to_file("res://Scenes/UI/MainMenu.tscn")

func toggle_pause():
	get_tree().paused = !get_tree().paused
	
	visible = get_tree().paused
