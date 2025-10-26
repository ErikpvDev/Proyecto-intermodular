extends Node

var gold_coins: int = 0
signal gold_changed(value)

func add_gold(amount: int):
	gold_coins += amount
	emit_signal("gold_changed",gold_coins)
