class_name Inventory extends Node

signal inventory_filled
signal inventory_cleared

@export var items: Array[Item]

var _max_size: int = 999
var _size: int = 0

func has(item: Item) -> bool:
	return items.has(item)
	
func has_size_for(item: Item) -> bool:
	return has_size(item.size) 

func has_size(size: int) -> bool:
	return _max_size > (_size + size)

func add(item: Item) -> void:
	var added: Item = item.duplicate()
	items.append(added)

	_size += added.size
	if _size > _max_size:
		inventory_filled.emit()
	
func remove(item: Item) -> void:
	items.erase(item)
	
func transfer(to: Inventory) -> void:
	items.append_array(to.items)
	_size += to.get_size()
	if _size > _max_size:
		inventory_filled.emit()

func clear() -> void:
	items.clear()
	
func get_items(type: Item.Type = Item.Type.NONE) -> Array[Item]:
	if type != Item.Type.NONE:
		return items
	return items.filter(func(item: Item): return item.type == type)

func total_size() -> int:
	return calc_size(items)

static func calc_size(some_items: Array[Item]) -> int:
	return some_items.reduce(func(accum: int, item: Item): return accum + item.size)
