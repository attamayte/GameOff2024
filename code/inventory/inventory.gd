class_name Inventory extends Node

@export var items: Array[Item]

func has(item: Item) -> bool:
	return items.has(item)

func add(item: Item) -> void:
	pass
	
func remove(item: Item) -> void:
	pass
	
func move(item: Item, to: Inventory) -> void:
	pass
	
func copy(item: Item, to: Inventory) -> void:
	pass

func transfer(to: Inventory) -> void:
	items.append_array(to.items)
