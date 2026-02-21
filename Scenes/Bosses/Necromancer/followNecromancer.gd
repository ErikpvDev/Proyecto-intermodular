extends State

func transition():
	get_parent().change_state("ShootAttack")
	
func update(_delta):
	pass
