extends CharacterBody2D
class_name Enemy

@export var speed = 80
@export var damage = 1
@onready var target = $"../../Character"
@onready var health: Node = $Health
@onready var spawn = $"../../Spawn"
@onready var exp_drop_scene = preload("res://Scenes/Exp_drop/Exp_drop.tscn")
var exp_value=25
var elite

@onready var exp_drops: Node2D = $"../../Exp_drops"

@onready var enemy_dict = spawn.enemy_dict
var p_drop
var round_number

@onready var chest = preload("res://Scenes/Objects/chest.tscn")

func _ready() -> void:
	if elite:
		$AnimatedSprite2D.play("elite_walking")
	else:
		$AnimatedSprite2D.play("walking")

func animation():
		
	if velocity.x>0:
		$AnimatedSprite2D.flip_h=false
	else:
		$AnimatedSprite2D.flip_h=true

func drop_exp():
	var exp_drop = exp_drop_scene.instantiate()
	exp_drop.position = position
	exp_drop.exp_amount=exp_value
	exp_drops.call_deferred("add_child",exp_drop)
	
func die():
	spawn.enemy_death()
	drop_exp()
	drop_chest()
	queue_free()

func take_damage(amount:int):
	health.take_damage(amount)
	if health.health<=0:
		die()
	else:
		$AnimationPlayer.play("Hit")

func _process(_delta):
	var direction = (target.position-position).normalized()
	velocity = direction * speed
	animation()
	move_and_slide()

func _on_health_health_changed(new_health: Variant) -> void:
	health.health=new_health
	
func drop_chest():
	round_number = spawn.current_wave
	p_drop = clamp((0.005 + 0.000045 * pow(enemy_dict[round_number][0], 1.12)) * (3.0 if elite else 1.0), 0.0, 0.25)
	if (randf_range(0,1)<p_drop):
		var c = chest.instantiate()
		c.position = position
		var interactables = $"../../Interactables"
		interactables.call_deferred("add_child",c)
		
