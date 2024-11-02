class_name RoadParams extends Resource

enum Biome { FOREST, PLAINS, WASTELAND }

@export_category("Params")
@export var biome: Biome = Biome.FOREST
@export var length_min: int = 1
@export var length_max: int = 1
@export var poi_min: int = 0
@export var poi_max: int = 0
@export var unique_poi_chance: float = 0.0
@export_category("Assets")
@export var chunks: Array[PackedScene]

func get_random_length() -> int:
	var random_length: int = randi_range(length_min, length_max)
	return mini(random_length, chunks.size())
