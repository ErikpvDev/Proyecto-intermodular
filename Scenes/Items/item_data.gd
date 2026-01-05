extends Resource
class_name ItemData

# Enums para organizar mejor (aparecerán como listas desplegables)
enum Rarity { COMMON, RARE, LEGENDARY }
enum ItemType { WEAPON, ARMOR, TRINKET, CONSUMABLE }

@export_category("Visual information")
@export var name: String = "Object name"
@export_multiline var description: String = "Description here..."
@export var icon: Texture2D  # Imagen del objeto
@export var rarity: Rarity

@export_category("Statistics")
# Ponemos 0.0 por defecto. Si el objeto no da una estadística, se queda en 0.
@export var damage_bonus: float = 0.0
@export var attack_speed_bonus: float = 0.0 # Porcentaje (0.10 = 10%)
@export var crit_chance_bonus: float = 0.0
@export var move_speed_bonus: float = 0.0
@export var max_hp_bonus: float = 0.0
@export var dodge_chance_bonus: float = 0.0
@export var shield_bonus: float = 0.0

# Para casos especiales como el legendario "3x Damage"
@export_category("Specials")
# El número representa una equivalencia (1 normal, 2 doble, 3 triple,...)
@export var damage_multiplier: float = 1.0
@export var projectile_size_multiplier: float = 1.0
