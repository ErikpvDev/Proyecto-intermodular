extends Node

var sounds = {
	"slash" : preload("res://assets/VFX/sword-slash.mp3"),
	"pick_up_coin" : preload("res://assets/VFX/CoinSound.mp3"),
	"player_hitted" : preload("res://assets/VFX/HitPlayer.mp3"),
	"buy_item" : preload("res://assets/VFX/BuyItem.mp3"),
	"level_up" : preload("res://assets/VFX/LevelUp.mp3"),
	"open_chest" : preload("res://assets/VFX/OpenChest.mp3"),
	"pick_up_XP" : preload("res://assets/VFX/PickUpXP.mp3"),
	"player_death" : preload("res://assets/VFX/Death.mp3"),
	"lose_shield" : preload("res://assets/VFX/LoseShield.mp3"),
	"equip_shield" : preload("res://assets/VFX/EquipShield.mp3"),
	"pick_up_heart" : preload("res://assets/VFX/PickUpHeart.mp3"),
	"victory" : preload("res://assets/VFX/Victory-Sound.mp3")  
}
	
func play_sound(sound_name: String):
	if sounds.has(sound_name):
		var player = AudioStreamPlayer.new()
		player.stream = sounds[sound_name]
		player.bus = "VFX"
		
		add_child(player)
		player.play()
		
		player.finished.connect(player.queue_free)
		

func play_sfx_varied(sound_name: String):
	if sounds.has(sound_name):
		var player = AudioStreamPlayer.new()
		player.stream = sounds[sound_name]
		player.bus = "VFX"
		
		player.pitch_scale = randf_range(0.9, 1.1)
		
		add_child(player)
		player.play()
		player.finished.connect(player.queue_free)
