class_name Controller extends Node

@export var character: Character 

func _ready() -> void:
	#Input.use_accumulated_input = true
	pass

func _process(delta: float) -> void:
	if character:
		var movement_input: Vector2 = Input.get_vector("move_left", "move_right", "move_up", "move_down")
		var run_input: bool = Input.is_action_pressed("run")
		var ready_input: bool = Input.is_action_pressed("aim")
		var attack_input: bool = Input.is_action_pressed("attack")
		var use_input: bool = Input.is_action_pressed("use")
		character.set_input_state(movement_input, run_input, ready_input, attack_input, use_input)
