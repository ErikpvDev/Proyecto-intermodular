extends Control

@onready var character = $"../../Level01/Character"
@onready var grid = $Panel/GridContainer
@onready var spawn = $"../../Level01/Spawn"

func _ready() -> void:
	hide()
	
	
func _input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_cancel"):
		if visible:
			_on_button_pressed() 
		elif not MenuManager.menu_abierto:
			$Panel/TimeLabel.text = "TIME: "+format_time(spawn.total_time)
			display_items()
			toggle_pause()
			MenuManager.abrir_menu()
	

func toggle_pause():
	get_tree().paused = !get_tree().paused
	
	visible = get_tree().paused

func _on_button_pressed() -> void:
	toggle_pause()
	MenuManager.cerrar_menu()

func _on_volver_menu_pressed() -> void:
	MenuManager.cerrar_menu()
	get_tree().change_scene_to_file("res://Scenes/UI/MainMenu.tscn")

func display_items() -> void:
	for item in grid.get_children():
		item.queue_free()
	
	var inventory = character.inventory
	
	for item in inventory:
		var new = preload("res://Scenes/UI/ItemSlot.tscn").instantiate()
		grid.add_child(new)
		
		new.set_item(item, inventory[item])
		
func format_time(time_in_seconds: float) -> String:
	var minutes : int = int(time_in_seconds / 60)
	var seconds : int = int(time_in_seconds) % 60
	return "%02d:%02d" % [minutes, seconds]
