extends Node

@onready var experience = $Level01/Character/Experience
@onready var level_up_menu = $CanvasLayer/LevelUpMenu
@onready var shop_menu = $CanvasLayer/ShopMenu

func _ready() -> void:
	$Transition/AnimationPlayer.play("fade_in")
	experience.connect("level_up",Callable(self,"_on_level_up"))
	level_up_menu.connect("item_selected",Callable(self,"_on_level_up_item_selected"))
	GlobalSignals.show_shop.connect(show_shop)
	GlobalSignals.leave_shop.connect(_on_leave_shop)
	
func _on_level_up() -> void:
	get_tree().paused = true
	level_up_menu.show_menu()
	
func _on_level_up_item_selected() -> void:
	get_tree().paused = false
	level_up_menu.hide()
	
func show_shop() -> void:
	get_tree().paused = true
	shop_menu.show_menu()
	
func _on_leave_shop() -> void:
	get_tree().paused = false
	shop_menu.hide()
	
