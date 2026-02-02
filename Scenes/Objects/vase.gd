extends Node2D

@onready var interactable: Area2D = $Interactable
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var gold_coin_scene: PackedScene = load("res://Scenes/Objects/gold_coin.tscn")
@onready var gold_drops = get_tree().current_scene.find_child("Gold_drops", true, false)

func _ready() -> void:
	interactable.interact = _on_interact

func drop_coins():
	var gold_coin = gold_coin_scene.instantiate()
	gold_coin.global_position = global_position 
	gold_coin.gold_amount = 1
	
	gold_drops.call_deferred("add_child", gold_coin)

func _on_interact():
	if interactable.is_interactable:
		interactable.is_interactable = false
		#animated_sprite_2d.play("break")
		#await animated_sprite_2d.animation_finished
		drop_coins()
		queue_free()
