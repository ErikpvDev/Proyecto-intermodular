extends State

@onready var Spawn = $"../../../../Spawn"

func enter():
	super.enter()
	
	animation_player.play("death") 
	
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

# Conecta la señal animation_finished de tu AnimationPlayer a esta función
func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if anim_name == "death":
		Engine.time_scale = 1.0 
		owner.queue_free() 
		Spawn.enemy_death()
