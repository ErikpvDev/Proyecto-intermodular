extends State

@onready var progress_bar = owner.find_child("ProgressBar")

func transition():
	get_parent().change_state("Follow")
