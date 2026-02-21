extends Area2D

@export var speed := 300
@export var life_time := 6

var direction :=Vector2.RIGHT
var time := 0

func setup(dir:Vector2):
	direction = dir.normalized()
	rotation = direction.angle()
	
func _physics_process(delta: float) -> void:
	global_position += direction * speed * delta
	
	time += delta
	if time >= life_time:
		print("bala borrada")
		queue_free()
	

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("character"):
		var movement = body.get_node("Movement")
		
		if movement and movement.dashing:
			return
		 
		body.take_damage(1)
		print("bala borrada")
		queue_free()
	


func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	print("bala borrada")
	queue_free()
