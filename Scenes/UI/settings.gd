extends Control

@onready var music_slider = $VBoxContainer/VBoxContainer/Music
@onready var vfx_slider = $VBoxContainer/VBoxContainer/VFX
@onready var window_option = $VBoxContainer/WindowOption

func _ready() -> void:
	$Transition/AnimationPlayer.play("fade_out")
	
	var bus_index_music = AudioServer.get_bus_index("Music")
	
	var db_volume_music = AudioServer.get_bus_volume_db(bus_index_music)
	
	music_slider.value = db_to_linear(db_volume_music)
	
	var bus_index_VFX = AudioServer.get_bus_index("VFX")
	
	var db_volume_VFX = AudioServer.get_bus_volume_db(bus_index_VFX)
	
	vfx_slider.value = db_to_linear(db_volume_VFX)
	
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
	# Obtenemos el índice del bus llamado "Music"
	var bus_index = AudioServer.get_bus_index("Music")
	
	# Convertimos el valor lineal (0-1) a decibelios
	var db_value = linear_to_db(value)
	
	# Aplicamos el volumen solo a ese bus
	AudioServer.set_bus_volume_db(bus_index, db_value)
	
	# Silenciamos solo la música si el slider está al mínimo
	AudioServer.set_bus_mute(bus_index, value < 0.01)



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
		var center_pos = screen_rect.position + (screen_rect.size / 2) - (window_size / 2)
		DisplayServer.window_set_position(center_pos)


func _on_vfx_value_changed(value: float) -> void:
	var bus_index = AudioServer.get_bus_index("VFX")
	
	var db_value = linear_to_db(value)
	
	AudioServer.set_bus_volume_db(bus_index, db_value)

	AudioServer.set_bus_mute(bus_index, value < 0.01)
