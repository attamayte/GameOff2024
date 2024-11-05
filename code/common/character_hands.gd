class_name CharacterHands extends Node2D

@export var current: Equipment

func equip(equipment: Equipment) -> void:
	pass
	
func empty() -> void:
	pass
	
func is_handling_weapon() -> bool:
	return false
	
func is_shooting() -> bool:
	return false
	
func is_handling_melee() -> bool:
	#return current is MeleeWeapon
	return false
	
func is_handling_ranged() -> bool:
	#return current is RangedWeapon
	return false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
