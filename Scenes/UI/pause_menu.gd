extends Control

func _ready() -> void:
	hide()
	
	
func _input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_cancel"):
		if visible:
			_on_button_pressed() 
		elif not MenuManager.menu_abierto:
			toggle_pause()
			MenuManager.abrir_menu()
	

func toggle_pause():
	get_tree().paused = !get_tree().paused
	
	visible = get_tree().paused

func _on_button_pressed() -> void:
	toggle_pause()
	MenuManager.cerrar_menu()


func _on_volver_menu_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/UI/MainMenu.tscn")
