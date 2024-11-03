class_name Draisine extends CharacterBody2D

var operational: bool = true
@export var acceleration: float = 40.0
@export var speed: float = 80.0

@onready var camera: Camera2D = $Camera

func _ready() -> void:
	camera.make_current()

func _physics_process(delta: float) -> void:
	var move_input: float = 0.0
	if operational:
		move_input = Input.get_axis("move_left", "move_right")
	
	var move_force: Vector2 = Vector2(move_input * speed, 0.0)
	velocity = velocity.move_toward(move_force, delta * acceleration)
	move_and_slide()
