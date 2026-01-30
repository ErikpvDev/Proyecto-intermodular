extends Node2D

var current_state: State
var previous_state: State
@export var start_time := 3

func _ready() -> void:
	current_state = get_child(0) as State
	previous_state = current_state
	await get_tree().create_timer(start_time).timeout
	current_state.enter()

func change_state(state):
	current_state = find_child(state) as State
	current_state.enter()
	
	previous_state.exit()
	previous_state = current_state
