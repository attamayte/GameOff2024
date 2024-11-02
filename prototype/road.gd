class_name Road extends Node2D

signal chunk_generated
signal road_generated
signal road_destroyed

@export_category("Route")
@export var from: Station
@export var to: Station
@export_category("Params")
@export var chunk_size: float = 320.0
@export var preset: RoadParams
@export var generate: bool:
	set(value):
		generate_road(global_position, preset)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func generate_chunk(origin: Vector2, scene: PackedScene) -> void:
	var chunk: Node2D = scene.instantiate() as Node2D
	chunk.global_position = origin
	add_child(chunk)
	chunk_generated.emit()

func generate_road(from: Vector2, preset: RoadParams, _right: bool = true) -> void:
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
	
	var length: int = preset.get_random_length()
	var offset: Vector2 = Vector2.ZERO
	var scenes: Array[PackedScene] = preset.get_repeated_chunks()
	scenes.shuffle()
	
	for i in range(length):
		var scene: PackedScene = scenes.pop_back()
		generate_chunk(from + offset, scene)
		offset.x += chunk_size
		
