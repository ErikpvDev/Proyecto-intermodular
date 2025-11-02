extends Node

@onready var experience = $Level01/Character/Experience
@onready var level_up_menu = $CanvasLayer/LevelUpMenu

func _ready() -> void:
	experience.connect("level_up",Callable(self,"_on_level_up"))
	level_up_menu.connect("item_selected",Callable(self,"_on_item_selected"))
	
func _on_level_up() -> void:
	get_tree().paused = true
	level_up_menu.show_menu()
	
	
func _on_item_selected() -> void:
	get_tree().paused = false
	level_up_menu.hide()
	
