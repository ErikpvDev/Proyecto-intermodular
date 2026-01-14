extends Node2D

@export var radius := 80
@onready var sprite := $"Sprite2D"

func _ready() -> void:
	sprite.scale = Vector2.ONE * radius / sprite.texture.get_size().x
