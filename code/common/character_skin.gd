class_name CharacterSkin extends Node2D

@export var idle_animation_name: StringName = "idle"
@export var walk_animation_name: StringName = "walk"
@export var run_animation_name: StringName = "run"
@export var melee_animation_name: StringName = "melee"
@export var ranged_animation_name: StringName = "ranged"
@export var aiming_animation_name: StringName = "aiming"
@export var hurt_animation_name: StringName = "hurt"
@export var dead_animation_name: StringName = "dead"

@onready var animation_player: AnimationPlayer = $AnimationPlayer

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

func do_reload() -> void:
	pass

func update_facing(left: bool) -> void:
	scale.x *= -1.0

func update_animation_state(state: Character.State) -> void:
	match state:
		Character.State.IDLE:
			animation_player.play(idle_animation_name)
		Character.State.AIMING:
			animation_player.play(aiming_animation_name)
		Character.State.WALK:
			animation_player.play(walk_animation_name)
		Character.State.RUN:
			animation_player.play(run_animation_name)
		Character.State.MELEE:
			animation_player.play(melee_animation_name)
		Character.State.RANGED:
			animation_player.play(ranged_animation_name)
		Character.State.HURT:
			animation_player.play(hurt_animation_name)
		Character.State.DEAD:
			animation_player.play(dead_animation_name)
		_:
			breakpoint
		
