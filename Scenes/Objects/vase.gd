extends Node2D

@onready var interactable: Area2D = $Interactable
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var gold_coin_scene: PackedScene = load("res://Scenes/Objects/gold_coin.tscn")
@onready var heart_scene: PackedScene = load("res://Scenes/Objects/heart.tscn")
@onready var shield_scene: PackedScene = load("res://Scenes/Objects/shield.tscn")
@onready var vase_drops = get_tree().current_scene.find_child("Vase_drops", true, false)

func _ready() -> void:
	interactable.interact = _on_interact

func drop_coins():
	var gold_coin = gold_coin_scene.instantiate()
	gold_coin.global_position = global_position
	vase_drops.call_deferred("add_child", gold_coin)
	
func drop_heart():
	var heart = heart_scene.instantiate()
	heart.global_position = global_position
	vase_drops.call_deferred("add_child", heart)
	
func drop_shield():
	var shield = shield_scene.instantiate()
	shield.global_position = global_position
	vase_drops.call_deferred("add_child", shield)
	
func _on_interact():
	if interactable.is_interactable:
		interactable.is_interactable = false
		if (randf_range(0,100)<90):
			drop_coins()
		else:
			if(randf_range(0,100)<50):
				drop_heart()
			else:
				drop_shield()
		queue_free()
