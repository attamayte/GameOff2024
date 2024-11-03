class_name Item extends Resource

enum EquipEffect { 
	NONE, 
	BACKPACK_SMALL, 
	BACKPACK_MEDIUM, 
	BACKPACK_LARGE,
	ARMOR_LIGHT,
	ARMOR_MEDIUM,
	ARMOR_HEAVY,
}

enum UseEffect {
	NONE,
	HEAL_SMALL_SLOW,
	HEAL_SMALL_FAST,
	HEAL_LARGE_SLOW,
	HEAL_LARGE_FAST,
}

# TODO fill in all the amazing types we'll have
enum Type { NONE, EQUIPMENT, CONSUMABLE, VALUABLE, JUNK }

# NOTE mostly for UI 
@export var label: String
@export var description: String
@export var icon: Texture2D
# Gameplay stuff
@export var size: int
@export var stack: int = 1 # if more than one, item is a stack of items
@export var value: int # final value is [value of a single item] * [items in a stack]
@export var equip_effect: EquipEffect = EquipEffect.NONE
@export var use_effect: UseEffect = UseEffect.NONE
# NOTE to filter items by category and maybe for loot tables
@export var type: Type = Type.NONE
