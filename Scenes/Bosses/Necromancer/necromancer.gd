extends CharacterBody2D

var health: int = 1
@onready var state_machine = $StateMachine 
@onready var health_bar = $UI/TextureProgressBar

@export var damage_indicator_scene: PackedScene = preload("res://Scenes/UI/DamageIndicator.tscn")

func setup_health(amount: int):
	health = amount
	health_bar.max_value = amount
	health_bar.value = amount

func take_damage(amount:int, is_critical):
	health=health-amount
	health_bar.value=health
	if health<=0:
		die()
	else:
		$AnimationPlayer.play("Hit")
		spawn_damage_indicator(amount, is_critical)

func die():
	if state_machine.current_state.name != "Death":
		state_machine.change_state("Death")

func spawn_damage_indicator(amount: int, is_critical):
	var indicator = damage_indicator_scene.instantiate()
	indicator.global_position = global_position
	
	get_tree().current_scene.add_child(indicator)
	
	indicator.display_damage(amount, is_critical)
