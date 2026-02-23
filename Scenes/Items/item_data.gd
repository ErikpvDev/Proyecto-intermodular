extends Resource
class_name ItemData

enum Rarity { COMMON, RARE, LEGENDARY }
enum ItemType { WEAPON, ARMOR, TRINKET, CONSUMABLE }

@export_category("Visual information")
@export var name: String = "Object name"
@export_multiline var description: String = "Description here..."
@export var icon: Texture2D
@export var rarity: Rarity

@export_category("Statistics")
@export var damage_bonus: float = 0.0
@export var attack_speed_bonus: float = 0.0
@export var crit_chance_bonus: float = 0.0
@export var move_speed_bonus: float = 0.0
@export var max_hp_bonus: float = 0.0
@export var dodge_chance_bonus: float = 0.0
@export var shield_bonus: float = 0.0

# Casos especiales
@export_category("Specials")
@export var damage_multiplier: float = 1.0
@export var projectile_size_multiplier: float = 1.0
