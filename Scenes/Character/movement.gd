extends Node

@export var move_speed : float = 100
@export var dash_speed : float = 300

@onready var entity = get_parent()
var dashing = false
var dash_available = true

func _ready() -> void:
	GlobalSignals.update_move_speed.connect(update_move_speed)

func dash() -> void:
	dashing=true
	dash_available=false
	$dash_timer.start()
	$dash_cooldown_timer.start()


func movement(_delta):
	var input_direction = Vector2(
		Input.get_action_strength("right") - Input.get_action_strength("left"),
		Input.get_action_strength("down") - Input.get_action_strength("up"),
	)
	
	if Input.is_action_just_pressed("dash") && dash_available:
		dash()
		
	var speed=move_speed
	if dashing:
		speed=dash_speed
	
	if input_direction.x!=0 && input_direction.y!=0:
		entity.velocity = input_direction.normalized() * speed
	else:
		entity.velocity = input_direction * speed
	
	entity.move_and_slide()
		

func _on_dash_timer_timeout() -> void:
	dashing=false


func _on_dash_cooldown_timer_timeout() -> void:
	dash_available=true
	
func update_move_speed(amount: float):
	move_speed = move_speed + (amount * 100)
	if (move_speed > 150):
		move_speed = 150
