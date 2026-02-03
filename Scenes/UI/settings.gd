extends Control

@onready var volume_slider = $VBoxContainer/Volume
@onready var window_option = $VBoxContainer/WindowOption

func _ready() -> void:
	$Transition/AnimationPlayer.play("fade_out")
	
	var db_volume = AudioServer.get_bus_volume_db(0)
	volume_slider.value = db_to_linear(db_volume)
	
	_update_window_option_button()

func _update_window_option_button() -> void:
	var mode = DisplayServer.window_get_mode()
	var is_borderless = DisplayServer.window_get_flag(DisplayServer.WINDOW_FLAG_BORDERLESS)
	
	if mode == DisplayServer.WINDOW_MODE_FULLSCREEN:
		window_option.selected = 1
	elif is_borderless:
		window_option.selected = 2
	else:
		window_option.selected = 0

func _on_volume_value_changed(value: float) -> void:
	# Convertimos el valor de 0.0-1.0 a decibelios (-80dB a 0dB)
	var db_value = linear_to_db(value)
	
	# Aplicamos el volumen al bus 0 (Master)
	AudioServer.set_bus_volume_db(0, db_value)
	
	# Opcional: Si el valor es el mínimo, silenciamos por completo (Mute)
	AudioServer.set_bus_mute(0, value < 0.01)



func _on_button_pressed() -> void:
	$Transition.show()
	$Transition/AnimationPlayer.play("fade_in")
	$Transition/Fade_timer.start()


func _on_fade_timer_timeout() -> void:
	get_tree().change_scene_to_file("res://Scenes/UI/MainMenu.tscn")


func _on_windowed_item_selected(index: int) -> void:
	match index:
		0: # Ventana Normal
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
			DisplayServer.window_set_flag(DisplayServer.WINDOW_FLAG_BORDERLESS, false)
		1: # Pantalla Completa Real
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
		2: # Ventana sin Bordes (Borderless)
			# Es mejor usar WINDOWED + BORDERLESS que MAXIMIZED
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
			DisplayServer.window_set_flag(DisplayServer.WINDOW_FLAG_BORDERLESS, true)
			# Opcional: Hacer que ocupe toda la pantalla
			DisplayServer.window_set_size(DisplayServer.screen_get_size())

	# El truco para evitar el error: esperar a que el OS procese el cambio
	call_deferred("center_window")

func center_window():
	# Verificamos que existan pantallas detectadas
	if DisplayServer.get_screen_count() > 0:
		var screen = DisplayServer.window_get_current_screen()
		var screen_rect = DisplayServer.screen_get_usable_rect(screen)
		var window_size = DisplayServer.window_get_size()
		
		# Calculamos el centro
		var center_pos = screen_rect.position + (screen_rect.size / 2) - (window_size / 2)
		DisplayServer.window_set_position(center_pos)
