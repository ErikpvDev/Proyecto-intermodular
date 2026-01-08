extends Node2D

@onready var attack_cooldown = $attack_cooldown
@onready var attack_area_collision = $CollisionShape2D
@onready var attack_area_sprite = $AnimatedSprite2D

func _ready() -> void:
	GlobalSignals.update_attack_speed.connect(update_attack_speed)
	GlobalSignals.update_attack_size.connect(update_attack_size)
	
func update_attack_speed(amount: float):
	attack_cooldown.wait_time /= 1 + amount

func update_attack_size(amount: float):
	attack_area_collision.scale *= amount
	attack_area_sprite.scale *= amount
