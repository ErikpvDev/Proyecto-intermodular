extends State

@export var dash_speed := 5000
@export var dash_duration := 2

var dash_direction: Vector2
var dash_timer := 0.0

func enter():
	super.enter()

	dash_timer = dash_duration
	dash_direction = (player.global_position - owner.global_position).normalized()

	owner.velocity = dash_direction * dash_speed
	animation_player.play("glowing")

func _physics_process(delta):
	if dash_timer > 0.0:
		dash_timer -= delta
		owner.move_and_slide()
	else:
		owner.velocity = Vector2.ZERO
		get_parent().change_state("Follow")
