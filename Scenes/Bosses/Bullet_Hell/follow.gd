extends State

func transition():
	get_parent().change_state("BulletHell")

func update(_delta):
	pass
