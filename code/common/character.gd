class_name Character extends CharacterBody2D

# current_state (machine?) stuff
enum State { IDLE, WALKING, RUNNING, READY, USING_HANDS, TAKING_DAMAGE, DEAD }

signal entered_state(new_state: State)
signal changed_facing(left: bool)

@export_category("Survival")
@export var max_health: float = 100.0
@export var armor: Item.EquipEffect
@export var backpack: Item.EquipEffect

@export_category("Movement")
@export var walk_speed: float = 32.0 # 3 meters per second? 
@export var run_speed: float = 64.0
@export var aim_speed: float = 16.0
@export var acceleration: float = 256.0

## DEBUG
@onready var state_label: Label = $StateLabel

@onready var animation_player: AnimationPlayer = $AnimationPlayer

@onready var pelvic: Sprite2D = $Pelvic


## input current_state
var last_movement_input: Vector2
var movement_input: Vector2
var run_pressed: bool
var ready_pressed: bool
var hands_pressed: bool
var use_pressed: bool

## current_state vars
var health: float = 100.0
var moving: bool
var max_speed: float
var facing_left: bool
var current_state: State
var prev_state: State

func _ready() -> void:
	enter_new_state(State.IDLE)

func set_input_state(movement: Vector2, run: bool, ready: bool, attack: bool, use: bool) -> void:
	movement_input = movement
	run_pressed = run
	ready_pressed = ready
	hands_pressed = attack
	use_pressed = use

func update_state() -> void:
	var updated_state: State
	
	moving = not velocity.is_zero_approx()
	
	if health > 0.0:
		if moving:
			if run_pressed:
				updated_state = State.RUNNING
			else:
				updated_state = State.WALKING
		else:
			updated_state = State.IDLE
		
		if ready_pressed: #and can_ready():
			updated_state = State.READY
			if hands_pressed:
				updated_state = State.USING_HANDS
	else:
		updated_state = State.DEAD
	
	if updated_state != current_state:
		enter_new_state(updated_state)
	
	set_input_state(Vector2.ZERO, false, false, false, false)

func update_facing() -> void:
	if current_state == State.READY or current_state == State.USING_HANDS:
		var global_mouse_position = get_global_mouse_position()
		var cursor_on_the_left: bool = global_mouse_position.x < global_position.x
		if cursor_on_the_left and not facing_left:
			set_facing(true)
		elif not cursor_on_the_left and facing_left:
			set_facing(false)	
	elif moving:
		if facing_left and velocity.x > 0.0:
			set_facing(false)
		elif not facing_left and velocity.x < 0.0:
			set_facing(true)

func update_velocity(delta: float) -> void:
	velocity = velocity.move_toward(movement_input * max_speed, delta * acceleration)

func enter_new_state(new_state: State) -> void:
	
	if new_state == State.RUNNING:
		max_speed = run_speed
	else:
		max_speed = walk_speed

	prev_state = current_state
	current_state = new_state
	entered_state.emit(new_state)
	state_label.text = State.find_key(current_state)

func set_facing(left: bool) -> void:
	if left:
		facing_left = true
		pelvic.scale.x = -1.0
		changed_facing.emit(facing_left)
	else:
		facing_left = false
		pelvic.scale.x = 1.0
		changed_facing.emit(facing_left)

func _process(delta: float) -> void:
	update_velocity(delta)
	update_state()
	update_facing()
			
func _physics_process(delta: float) -> void:
	move_and_slide()
	
	
