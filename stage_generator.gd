@tool
class_name StageGenerator extends Node

@export var ground: MeshInstance3D
@export var scene: PackedScene
@export var forest_place_distance: float = 5.0
@export var noise_generator: FastNoiseLite

@export var generate: bool:
	set(value):
		generate = false
		
		generate_forset()
@onready var playable_region: NavigationRegion3D = $".."

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	assert(noise_generator)
	assert(scene)
	randomize()
	generate_forset()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func generate_stage(params: StageParams) -> Stage:
	return null

func _unhandled_input(event: InputEvent) -> void:
	if Input.is_key_pressed(KEY_R):
		generate_forset()

func generate_forset() -> void: 
	for ground_child in ground.get_children():
		ground.remove_child(ground_child)
		ground_child.queue_free()
	
	noise_generator.seed = randi()
	var bounds: AABB = ground.get_aabb()
	var offset: Vector3 = Vector3.ZERO
	var max_scale: Vector3 = Vector3(2.0, 2.0, 2.0)
	var min_scale: Vector3 = Vector3(0.5, 0.5, 0.5)
	var edge: float = 0.333
	var trees_generated: int = 0
	while offset.z < bounds.size.z:
		while offset.x < bounds.size.x:
			var noise: float = noise_generator.get_noise_2d(offset.x, offset.z)
			noise = remap(noise, -1.0, 1.0, 0.0, 1.0)
			if noise > edge:
				var tree: Node3D = scene.instantiate() as Node3D
				noise = remap(noise, edge, 1.0, 0.0, 1.0)
				var random_offset: Vector3 = Vector3.FORWARD.rotated(Vector3.UP, randf() * TAU)
				random_offset *= forest_place_distance * 0.25
				tree.scale = lerp(min_scale, max_scale, noise)
				tree.rotation.y = randf() * TAU
				tree.position = bounds.position + offset + random_offset
				ground.add_child(tree)
				tree.owner = get_tree().edited_scene_root
				trees_generated += 1
			offset.x += forest_place_distance
		offset.x = 0.0
		offset.z += forest_place_distance
	print("generated ", trees_generated, " trees")
			
