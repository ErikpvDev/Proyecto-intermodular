extends Area2D

@onready var animated_sprite = $AnimatedSprite2D
@onready var player = get_parent().find_child("Character")
@onready var player_center = player.get_node("Center")

var acceleration: Vector2 = Vector2.ZERO
var velocity: Vector2 = Vector2.ZERO

var speed := 150
var turn_speed := 6.0

func _physics_process(delta: float) -> void:
	var direction = (player_center.position - position).normalized()
	velocity = direction * 150
	rotation = velocity.angle()
	position += velocity * delta


func _on_body_entered(_body: Node2D) -> void:
	queue_free()
