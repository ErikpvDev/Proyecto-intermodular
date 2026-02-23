extends State

@export_group("Dependencies")
@export var bullet_scene: PackedScene
@onready var spiral_timer = $SpiralTimer

@export_group("Spiral Settings")
@export var total_bullets_to_fire := 30

@export var time_between_shots := 0.2

@export var angle_increment_degrees := 15.0

@export_range(1, 4) var spiral_arms := 3

var bullets_fired_count := 0
var current_aim_angle: float = 0.0

@export var time_after_dash := 2

@onready var sprite = $"../../AnimatedSprite2D"

func enter():
	super.enter()
	
	await get_tree().create_timer(time_after_dash).timeout
	
	owner.velocity = Vector2.ZERO
	
	bullets_fired_count = 0
	current_aim_angle = 0.0 

	flash_warning()
	await get_tree().create_timer(1,false).timeout
	spiral_timer.start(time_between_shots)

func exit():
	super.exit()
	spiral_timer.stop()

func spawn_bullet(angle: float):
	var bullet = bullet_scene.instantiate()

	bullet.global_position = owner.global_position

	bullet.rotation = angle

	var direction = Vector2.RIGHT.rotated(angle)

	bullet.setup(direction)

	get_tree().current_scene.add_child(bullet)

func update(_delta):
	pass

func _on_spiral_timer_timeout() -> void:
	if bullets_fired_count >= total_bullets_to_fire:
		spiral_timer.stop()
		get_parent().change_state("Dash")
		return

	if spiral_arms == 1:
		spawn_bullet(current_aim_angle)
	else:
		var arm_separation = TAU / spiral_arms
		for i in spiral_arms:
			spawn_bullet(current_aim_angle + (arm_separation * i))

	bullets_fired_count += 1

	current_aim_angle += deg_to_rad(angle_increment_degrees)
	
func flash_warning():
	var tween = create_tween()
	tween.tween_property(sprite, "modulate", Color.RED, 0.1)
	
	tween.tween_property(sprite, "modulate", Color.WHITE, 0.1)
	
	tween.tween_property(sprite, "modulate", Color.RED, 0.1)
	tween.tween_property(sprite, "modulate", Color.WHITE, 0.1)
