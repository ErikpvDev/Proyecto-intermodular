extends State

@onready var Spawn = $"../../../../Spawn"
@onready var attacksScene = $"../../../../Enemies" 
@onready var spawn = $"../../../../Spawn"

func enter():
	super.enter()
	
	$"../../AnimatedSprite2D".play("death") 
	
	var collision = owner.find_child("CollisionShape2D")
	if collision:
		collision.set_deferred("disabled", true)
	
	Engine.time_scale = 0.5

func transition():
	pass

func _physics_process(_delta):
	pass

func update(_delta):
	pass

func _on_animated_sprite_2d_animation_finished() -> void:
		Engine.time_scale = 1.0 
		var ataques = attacksScene.get_children()
		if !ataques.is_empty():
			for ataque in ataques:
				ataque.queue_free()
		if spawn.current_wave != 25:
			GlobalSignals.emit_signal("add_gold", 25)
			GlobalSignals.emit_signal("show_shop")
		else:
			spawn.enemy_death()
		owner.queue_free()
