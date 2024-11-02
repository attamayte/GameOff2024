class_name Road extends Node2D

signal chunk_generated
signal road_generated

@export var chunk_size: float = 320.0
@export var preset: RoadParams

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func generate_chunk(from: Vector2, preset: RoadParams, _right: bool = true) -> void:
	pass

func generate_road(from: Vector2, preset: RoadParams, _right: bool = true) -> void:
	var length: int = preset.get_random_length()
	var offset: Vector2 = Vector2.ZERO
	var indices: Array[int]
	for i in range(length):
		generate_chunk(from + offset, preset, _right)
		offset.x += chunk_size
		chunk_generated.emit()
