class_name Perception2D extends Area2D

signal character_entered(character: Character)
signal character_exited(character: Character)
#signal loot_entered(loot: Loot)
#signal loot_exited(loot: Loot)
#signal interactable_entered()
#signal body_hidden(body: Node2D)

@export var check_for_visibility: bool = true

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	body_entered.connect(on_body_entered)
	body_exited.connect(on_body_exited)
	
func on_body_entered(body: Node2D) -> void:
	if body is Character:
		character_entered.emit(body as Character)

func on_body_exited(body: Node2D) -> void:
	if body is Character:
		character_exited.emit(body as Character)

func _physics_process(delta: float) -> void:
	var space_state = get_world_2d().direct_space_state
	# use global coordinates, not local to node
	var from: Vector2 = global_position
	for body in get_overlapping_bodies():
		if body is Character:
			var to: Vector2 = body.global_position
			var query: PhysicsRayQueryParameters2D = PhysicsRayQueryParameters2D.create(from, to)
			var result: Dictionary = space_state.intersect_ray(query)
			#if result.collider:
			#	var shape: CollisionShape2D = result.collider as CollisionShape2D
			#	print("I can see ", shape.name)
