@tool
class_name Road extends Node2D

signal chunk_generated
signal road_generated
signal road_destroyed

@export_category("Route")
@export var from: Station
@export var to: Station
@export_category("Params")
@export var chunk_size: float = 640.0
@export var road_params: RoadParams
@export var generate: bool:
	set(value):
		generate_road(global_position)
		generate = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass
	
func _input(event: InputEvent) -> void:
	if event is InputEventKey:
		if (event as InputEventKey).physical_keycode == KEY_0:
			if (event as InputEventKey).pressed:
				generate_road(global_position)

func generate_chunk(origin: Vector2, scene: PackedScene) -> void:
	var chunk: Node2D = scene.instantiate() as Node2D
	chunk.global_position = origin
	add_child(chunk)
	chunk_generated.emit()

func generate_road(from: Vector2) -> void:
	# NOTE destroy old road before making a new one
	var removed_road: bool = false
	
	for child in get_children():
		# TODO move from Node2D to RoadChunk type for road chunks
		if child is Node2D:
			remove_child(child)
			child.queue_free()
			removed_road = true
			
	if removed_road:
		road_destroyed.emit()
	
	#var length: int = road_params.get_random_length()
	var road_length: int = randi_range(road_params.length_min, road_params.length_max)
	var repeat_length: int = road_params.biome.repeated_chunks.size()
	var repeat_index: int = 0
	
	var offset: Vector2 = Vector2.ZERO
	var last_repeat_index: int = 0
	
	var indices: Array[int]
	indices.resize(repeat_length)
	for i in range(repeat_length):
		indices[i] = i
	indices.shuffle()
	
	for i in range(road_length):
		if repeat_index >= repeat_length:
			last_repeat_index = indices.back()
			repeat_index = 0
			indices.shuffle()
		
		var scene_index: int = indices[repeat_index]
		var scene: PackedScene = road_params.get_repeated_chunk_at(scene_index)
		generate_chunk(from + offset, scene)
		offset.x += chunk_size
		repeat_index += 1
		
