extends Area2D

@export var exp_amount: int = 15
@export var attraction_radius: float = 50
@export var attraction_speed: float = 200
var attracted = false
@onready var player: CharacterBody2D = get_tree().get_nodes_in_group("character")[0]

func _ready() -> void:
	if exp_amount<50:
		$AnimatedSprite2D.play("blue_drop")
	else:
		$AnimatedSprite2D.play("green_drop")

func _process(delta: float) -> void:
	var dist = position.distance_to(player.position)
	if dist < attraction_radius:
		attracted=true
	if attracted:
		var direction = (player.position-position).normalized()
		position+=direction * attraction_speed * delta

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("character"):
		body.add_exp(exp_amount)
		queue_free()
