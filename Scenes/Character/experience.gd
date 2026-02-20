extends Node

@export var exp_needed_lvl: int = 150
#@export var exp_needed_lvl: int = 2
@onready var exp_bar: TextureProgressBar = $"../../UI/Exp/TextureProgressBar"
@onready var exp_lvl_text: Label = $"../../UI/Exp/Label"
var experience: float = 0
var lvl: int = 1

signal level_up

func _ready() -> void:
	exp_lvl_text.text="LVL "+str(lvl)
	exp_bar.max_value=exp_needed_lvl

func add_exp(amount: int) -> void:
	var expected_exp=int(amount+experience)
	if expected_exp>=exp_needed_lvl:
		experience=expected_exp-exp_needed_lvl
		exp_bar.max_value = exp_needed_lvl
		exp_bar.value = experience
		lvl+=1
		exp_lvl_text.text="LVL "+str(lvl)
		exp_needed_lvl += (lvl * 250)
		exp_bar.max_value=exp_needed_lvl
		VfxManager.play_sound("level_up")
		emit_signal("level_up")
	else:
		VfxManager.play_sfx_varied("pick_up_XP")
		experience=expected_exp
		exp_bar.value=experience
