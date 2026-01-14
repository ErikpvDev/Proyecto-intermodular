extends Node2D
class_name State

@onready var debug = owner.find_child("Debug")
@onready var player = $"../../../../Character"
@onready var animation_player = owner.find_child("AnimationPlayer")

func _ready() -> void:
	set_physics_process(false)
	
func enter():
	set_physics_process(true)

func exit():
	set_physics_process(false)

func transition():
	pass
	
func _physics_process(_delta) -> void:
	transition()
	debug.text = name
