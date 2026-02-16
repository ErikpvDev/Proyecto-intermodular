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
	# Primero limpiamos estados anteriores para evitar conflictos
	DisplayServer.window_set_flag(DisplayServer.WINDOW_FLAG_BORDERLESS, false)
	
	match index:
		0: # Ventana Normal
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
			# Definir un tamaño por defecto si quieres que no sea minúscula
			DisplayServer.window_set_size(Vector2i(1280, 720)) 
		1: # Pantalla Completa Real
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_EXCLUSIVE_FULLSCREEN)
		2: # Ventana sin Bordes (Borderless)
			# En Godot 4, el modo "FULLSCREEN" (a secas) suele actuar como Borderless Window
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
			DisplayServer.window_set_flag(DisplayServer.WINDOW_FLAG_BORDERLESS, true)

	# Forzamos a Godot a re-calcular el área de click
	call_deferred("fix_mouse_sync")

func fix_mouse_sync():
	# Centramos si es modo ventana, si es borderless aseguramos posición 0,0
	var mode = DisplayServer.window_get_mode()
	if mode == DisplayServer.WINDOW_MODE_WINDOWED:
		center_window()
	else:
		DisplayServer.window_set_position(Vector2i(0, 0))
	
	# Este comando "despierta" al input del ratón
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)

func center_window():
	# Verificamos que existan pantallas detectadas
	if DisplayServer.get_screen_count() > 0:
		var screen = DisplayServer.window_get_current_screen()
		var screen_rect = DisplayServer.screen_get_usable_rect(screen)
		var window_size = DisplayServer.window_get_size()
		
		# Calculamos el centro
		var center_pos = screen_rect.position + (screen_rect.size / 2.0) - (window_size / 2.0)
		DisplayServer.window_set_position(center_pos)
