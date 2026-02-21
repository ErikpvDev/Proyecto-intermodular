extends State # Asumo que tu clase base se llama State

@export var teleport_distance: float = 100.0  # Distancia detrás del jugador
@export var fade_duration: float = 0.3       # Tiempo de desaparición

func enter():
	start_teleport()

func start_teleport():
	var tween = create_tween()
	tween.tween_property(owner, "modulate:a", 0.0, fade_duration)
	
	await tween.finished
	
	var direction = Vector2.RIGHT
	if player.velocity.x != 0:
		direction = player.velocity.normalized()
	elif player.get_node("AnimatedSprite2D").flip_h: 
		direction = Vector2.LEFT
	
	var target_pos = player.global_position - (direction * teleport_distance)
	
	owner.global_position = target_pos
	
	var tween_in = create_tween()
	tween_in.tween_property(owner, "modulate:a", 1.0, fade_duration)
	
	await tween_in.finished
	
	var chance = randi_range(1,2);
	if chance == 1:
		get_parent().change_state("AreaAttack")
	else:
		get_parent().change_state("ShootAttack")
	

func exit():
	pass
	
func update(_delta):
	pass
