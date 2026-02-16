extends State

@export var attack_radius: float = 120.0
@export var startup_time: float = 1.0    # Tiempo de carga
@export var active_time: float = 0.5     # Cuánto dura el daño
@export var cooldown_time: float = 0.8   # Post-ataque

@onready var sprite = get_parent().get_node("AnimatedSprite2D")

func enter():
	await get_tree().create_timer(startup_time).timeout
	execute_attack()

func execute_attack():
	# 1. Reproducir la animación de ataque
	owner.get_node("AnimatedSprite2D").play("aoe_attack")
	
	var targets = owner.get_node("AttackArea").get_overlapping_bodies()
	
	for body in targets:
		if body.has_method("take_damage"):
			body.take_damage(10)

	finish_attack()

func finish_attack():
	await get_tree().create_timer(cooldown_time).timeout
	get_parent().change_state("Teleport")

func exit():
	pass
