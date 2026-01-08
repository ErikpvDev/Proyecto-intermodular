extends Area2D

@export var damage: int = 10

var enemies_hit_this_attack=[]

func _ready() -> void:
	$Sprite2D.visible=false
	$CollisionShape2D.disabled=true
	$attack_cooldown.start()

func attack():
	enemies_hit_this_attack.clear()
	
	$Sprite2D.visible=true
	$CollisionShape2D.disabled=false
	
	$AttackTimer.start()
	
func _on_attack_timer_timeout() -> void:
	$Sprite2D.visible=false
	$CollisionShape2D.disabled=true

func _on_attack_cooldown_timeout() -> void:
	attack()
	$attack_cooldown.start()
	
func _on_attack_area_area_entered(area: Area2D) -> void:
	if area in enemies_hit_this_attack:
		return
	enemies_hit_this_attack.append(area)
	
	var parent = area.get_parent()
	
	if parent.has_method("take_damage"):
		parent.take_damage(damage)
