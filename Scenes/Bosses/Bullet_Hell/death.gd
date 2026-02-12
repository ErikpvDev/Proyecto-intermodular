extends State

@onready var Spawn = $"../../../../Spawn"
@onready var attacksScene = $"../../../../Enemies" 

func enter():
	super.enter()
	
	$"../../AnimatedSprite2D".play("death") 
	
	# 2. Desactivar colisiones para evitar que el jefe reciba daño o golpee al jugador
	# Ajusta el nombre "CollisionShape2D" al que uses en tu Boss
	var collision = owner.find_child("CollisionShape2D")
	if collision:
		collision.set_deferred("disabled", true)

	# 3. Efecto visual opcional: Cámara lenta al morir
	Engine.time_scale = 0.5

func transition():
	pass

func _physics_process(_delta):
	pass

func _on_animated_sprite_2d_animation_finished() -> void:
		Engine.time_scale = 1.0 
		var ataques = attacksScene.get_children()
		if !ataques.is_empty():
			for ataque in ataques:
				ataque.queue_free()
		GlobalSignals.emit_signal("show_shop")
		owner.queue_free() 
