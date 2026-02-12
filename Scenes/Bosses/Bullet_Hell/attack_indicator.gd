extends Node2D

@export var radius := 80
@onready var sprite := $AnimatedSprite2D

func _ready() -> void:
	# Usamos call_deferred para asegurar que el nodo esté totalmente listo
	_update_scale.call_deferred()
	
	await get_tree().create_timer(3).timeout
	queue_free()

func _update_scale():
	var frames = sprite.sprite_frames
	
	var anim = sprite.animation
	var texture = frames.get_frame_texture(anim, 0)
	
	if texture:
		var tex_size = texture.get_size()
		var new_scale = float(radius) / tex_size.x
		sprite.scale = Vector2(new_scale, new_scale)
