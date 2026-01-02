extends Node2D

@onready var interactable: Area2D = $Interactable
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D

func _ready() -> void:
	interactable.interact = _on_interact
	
	
func _on_interact():
	if animated_sprite_2d.animation == "default":
		animated_sprite_2d.play("Open")
		interactable.is_interactable = false
		print("Cofre abierto")
		
		
		
