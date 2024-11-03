class_name RoadParams extends Resource

@export var biome: Biome
@export var length_min: int = 1
@export var length_max: int = 1
@export var poi_min: int = 0
@export var poi_max: int = 0
@export var unique_poi_chance: float = 0.0

func get_repeated_size() -> int: 
	return biome.repeated_chunks.size()

func get_repeated_chunks() -> Array[PackedScene]:
	return biome.repeated_chunks

func get_repeated_chunk_at(index: int) -> PackedScene:
	return biome.repeated_chunks[index]

func get_random_length() -> int:
	var random_length: int = randi_range(length_min, length_max)
	return mini(random_length, get_repeated_size())
