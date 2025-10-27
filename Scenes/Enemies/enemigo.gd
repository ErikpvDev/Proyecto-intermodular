extends CharacterBody2D
class_name Enemy

var speed = 80
var health_stat = 1
@onready var target = $"../../Character"
@onready var health: Node = $Health

func take_damage(amount:int):
	health.take_damage(amount)
	print(health_stat)
	if health_stat<=0:
		queue_free()

func _physics_process(_delta):
	if target==null:
		print("Error")
	var direction = (target.position-position).normalized()
	velocity = direction * speed
	move_and_slide()

func _on_health_health_changed(new_health: Variant) -> void:
	health_stat=new_health
