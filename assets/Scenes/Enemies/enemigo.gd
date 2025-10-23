extends CharacterBody2D
class_name Enemy

var speed = 80

@onready var target = $"../Character"

func _physics_process(_delta):
	var direction = (target.position-position).normalized()
	velocity = direction * speed
	move_and_slide()
