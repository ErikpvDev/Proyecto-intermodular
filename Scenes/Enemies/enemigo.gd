extends CharacterBody2D
class_name Enemy

var speed = 80
@onready var target = $"../../Character"
@onready var health: Node = $Health
@onready var spawn = $"../../Spawn"
@onready var exp_drop_scene = preload("res://Scenes/Exp_drop/Exp_drop.tscn")
var exp_value=25
var elite

func _ready() -> void:
	if elite:
		$AnimatedSprite2D.play("elite_walking")
	else:
		$AnimatedSprite2D.play("walking")
	health.max_health = 10
	health.health=health.max_health

func animation():
		
	if velocity.x>0:
		$AnimatedSprite2D.flip_h=false
	else:
		$AnimatedSprite2D.flip_h=true

func drop_exp():
	var exp_drop = exp_drop_scene.instantiate()
	exp_drop.position = position
	exp_drop.exp_amount=exp_value
	get_parent().call_deferred("add_child",exp_drop)
	
func die():
	spawn.enemy_death()
	drop_exp()
	queue_free()

func take_damage(amount:int):
	health.take_damage(amount)
	if health.health<=0:
		die()
	$AnimationPlayer.play("Hit")

func _process(_delta):
	var direction = (target.position-position).normalized()
	velocity = direction * speed
	animation()
	move_and_slide()

func _on_health_health_changed(new_health: Variant) -> void:
	health.health=new_health
