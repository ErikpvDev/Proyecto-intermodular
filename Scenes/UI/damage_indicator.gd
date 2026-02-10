extends Node2D

@export var SPEED: int = 30
@export var FRICTION: int = 15
var SHIFT_DIRECTION: Vector2 = Vector2.ZERO

@onready var label = $Label

func _ready():
	SHIFT_DIRECTION = Vector2(randf_range(-1,1), randf_range(-1,1))

func _process(delta):
	global_position += SPEED * SHIFT_DIRECTION * delta
	SPEED = max(SPEED - FRICTION * delta, 0)

func display_damage(amount: int, is_critical: bool = false):
	label.text = str(amount)
	
	if is_critical:
		label.modulate = Color.RED
		label.scale = Vector2(1.3, 1.3)
	else:
		label.modulate = Color.WHITE
		
	$AnimationPlayer.play("ShowDamage")
