extends Area2D

@export var interact_name : String = ""
@export var is_interactable: bool = true

var interact: Callable = func():
	pass

func _ready():
	add_to_group("interactable")
