extends CanvasLayer

@onready var dmg: Label = $VBoxContainer/Dmg/Label
@onready var dmgMult: Label = $VBoxContainer/DmgMultiplier/Label
@onready var ms: Label = $VBoxContainer/MovementSpeed/Label
@onready var dc: Label = $VBoxContainer/DodgeChance/Label
@onready var cc: Label = $VBoxContainer/CritChance/Label
@onready var aspeed: Label = $VBoxContainer/AttackSpeed/Label
@onready var asize: Label = $VBoxContainer/AttackSize/Label

@onready var movement: Node = $"../../Character/Movement"

func _ready() -> void:
	GlobalSignals.update_stats.connect(update_stats)
	update_stats()

func update_stats():
	var player = get_tree().get_first_node_in_group("character")
	dmg.text = str(player.damage)
	dmgMult.text = str(player.damage_multiplier)
	ms.text = str(movement.move_speed)
	dc.text = str(player.dodge_chance)
	cc.text = str(player.crit_chance)
	aspeed.text = str(player.attack_speed)
	asize.text = str(player.attack_size)
