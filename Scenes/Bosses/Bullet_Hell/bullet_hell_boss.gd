extends CharacterBody2D

var health: int = 100
@onready var state_machine = $StateMachine 
@onready var health_bar = $UI/TextureProgressBar

func take_damage(amount: int):
	health -= amount
	health_bar.value-= amount
	if health <= 0:
		die()

func die():
	if state_machine.current_state.name != "Death":
		state_machine.change_state("Death")
