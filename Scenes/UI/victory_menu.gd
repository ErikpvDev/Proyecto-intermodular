extends Control

var button_type
func _ready():
	GlobalSignals.victory_menu.connect(victory_menu)
	hide() 

func victory_menu(total_time):
	$Panel/VBoxContainer/VBoxContainer/Time.text = "TIME: "+format_time(total_time)
	MenuManager.abrir_menu()
	toggle_pause()

func _on_restart_button_pressed():
	MenuManager.cerrar_menu()
	button_type = "play"
	$Transition.show()
	$Transition/AnimationPlayer.play("fade_in")
	$Transition/Fade_timer.start()

func _on_menu_button_pressed():
	MenuManager.cerrar_menu()
	button_type = "menu"
	$Transition.show()
	$Transition/AnimationPlayer.play("fade_in")
	$Transition/Fade_timer.start()


func _on_fade_timer_timeout() -> void:
	if button_type == "play":
		toggle_pause()
		get_tree().change_scene_to_file("res://Scenes/Game/game.tscn")
	elif button_type == "menu":
		get_tree().change_scene_to_file("res://Scenes/UI/MainMenu.tscn")

func toggle_pause():
	get_tree().paused = !get_tree().paused
	visible = get_tree().paused
	
func format_time(time_in_seconds: float) -> String:
	var minutes : int = int(time_in_seconds / 60)
	var seconds : int = int(time_in_seconds) % 60
	# El %02d asegura que siempre haya 2 dígitos (ej: 05 en vez de 5)
	return "%02d:%02d" % [minutes, seconds]
