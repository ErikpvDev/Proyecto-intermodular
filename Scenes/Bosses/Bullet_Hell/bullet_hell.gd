extends State

@export_group("Dependencies")
@export var bullet_scene: PackedScene
@onready var spiral_timer = $SpiralTimer

@export_group("Spiral Settings")
# How many bullets total in one complete spiral attack pattern
@export var total_bullets_to_fire := 30

# Time between individual shots. Smaller = tighter spiral arm visually.
@export var time_between_shots := 0.1

# How many degrees the aim rotates between each shot.
# Higher = wider spiral gap. Lower = very tight spiral.
@export var angle_increment_degrees := 15.0

# Optional: Number of spiral arms (e.g., 2 for a double helix)
@export_range(1, 4) var spiral_arms := 3

# Internal tracking variables
var bullets_fired_count := 0
var current_aim_angle: float = 0.0

func enter():
	super.enter()
	owner.velocity = Vector2.ZERO
	
	# Reset tracking variables
	bullets_fired_count = 0
	# Start aiming straight right (or use owner.rotation to start where facing)
	current_aim_angle = 0.0 

	# Start the firing cycle
	spiral_timer.start(time_between_shots)

func exit():
	super.exit()
	spiral_timer.stop()

func spawn_bullet(angle: float):
	var bullet = bullet_scene.instantiate()

	# Start at the enemy's center
	bullet.global_position = owner.global_position

	# Optional: Rotate sprite to face travel direction
	bullet.rotation = angle

	# Calculate direction vector from the angle
	var direction = Vector2.RIGHT.rotated(angle)
	
	# Assuming your bullet script has a 'setup' function that takes direction
	bullet.setup(direction)

	get_tree().current_scene.add_child(bullet)


func _on_spiral_timer_timeout() -> void:
	# Check exit condition
	if bullets_fired_count >= total_bullets_to_fire:
		spiral_timer.stop()
		# Pattern finished, return to chasing/idling
		get_parent().change_state("Dash")
		return

	# Fire the bullet(s)
	if spiral_arms == 1:
		# Single spiral arm
		spawn_bullet(current_aim_angle)
	else:
		# Multiple arms (e.g., double helix)
		var arm_separation = TAU / spiral_arms
		for i in spiral_arms:
			spawn_bullet(current_aim_angle + (arm_separation * i))

	bullets_fired_count += 1

	# Rotate aim for the next shot
	current_aim_angle += deg_to_rad(angle_increment_degrees)
