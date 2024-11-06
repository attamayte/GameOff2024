class_name Equipment extends Item

@export_category("Animation")
@export var idle_animation: StringName
@export var ready_animation: StringName
@export var action_animation: StringName
@export var reload_animation: StringName
@export var use_animation: StringName

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
