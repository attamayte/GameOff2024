class_name Character extends CharacterBody2D

# _state (machine?) stuff
enum State { IDLE, WALKING, RUNNING, TAKING_DAMAGE, DEAD }

enum Team { NULL, PLAYER, GUARD, RAIDER, CULTIST }

signal state_entered(new_state: State)
signal changed_facing(left: bool)
signal enemy_detected(enemy: Character)
signal enemy_visible(enemy: Character)
signal enemy_hidden(enemy: Character)
signal enemy_lost(enemy: Character)

@export_category("Social")
@export var team: Team

@export_category("Survival")
@export var max_health: float = 100.0
@export var armor: Item.EquipEffect
@export var backpack: Item.EquipEffect

@export_category("Movement")
@export var walk_speed: float = 32.0 # 3 meters per second? 
@export var run_speed: float = 128.0
@export var aim_speed: float = 16.0
@export var acceleration: float = 1024.0


## DEBUG
@onready var state_label: Label = $StateLabel


@onready var animation_player: AnimationPlayer = $AnimationPlayer

## NAVIGATION AND AI
@onready var navigation_agent: NavigationAgent2D = $NavigationAgent
@onready var perception: Perception2D = $Perception

@onready var hands: CharacterHands = $Hands
@onready var hands_transform: RemoteTransform2D = $Pelvic/Body/HandsTransform

@onready var pelvic: Sprite2D = $Pelvic
## INVENTORY
@onready var inventory: Inventory = $Inventory

## input _state
var last_movement_input: Vector2
var movement_input: Vector2
var run_pressed: bool
var ready_pressed: bool
var hands_pressed: bool
var use_pressed: bool

## state vars
var health: float = 100.0
var moving: bool
var max_speed: float
var facing_left: bool
var _state: State
var prev_body_state: State

func _ready() -> void:
	enter_state(State.IDLE)

func is_friendly(character: Character) -> bool:
	var other_team: Team = character.team
	match team:
		Team.NULL: return false
		Team.PLAYER: return other_team == Team.PLAYER or other_team == Team.GUARD
		Team.RAIDER: return other_team == Team.RAIDER
		Team.CULTIST: return other_team == Team.CULTIST or other_team == Team.GUARD
		_: return false
	
func is_enemy(character: Character) -> bool:
	var other_team: Team = character.team
	match team:
		Team.NULL: return false
		Team.PLAYER: return other_team == Team.RAIDER or other_team == Team.CULTIST
		Team.RAIDER: return other_team != Team.RAIDER
		Team.CULTIST: return other_team != Team.CULTIST or other_team != Team.GUARD
		_: return false

func set_input_state(movement: Vector2, running: bool, readying: bool, actioning: bool, using: bool) -> void:
	movement_input = movement
	run_pressed = running
	ready_pressed = readying
	hands_pressed = actioning
	use_pressed = using

func update_state() -> void:
	var state: State
	
	moving = not velocity.is_zero_approx()

	if health > 0.0:
		if moving:
			if run_pressed and not hands.busy():
				state = State.RUNNING
			else:
				state = State.WALKING
		else:
			state = State.IDLE
	else:
		state = State.DEAD
	
	if state != _state:
		enter_state(state)

func update_hands() -> void:
	hands.update_state(ready_pressed, hands_pressed, false, false)

func update_facing() -> void:
	var global_mouse_position = get_global_mouse_position()
	if hands.busy():
		var cursor_on_the_left: bool = global_mouse_position.x < global_position.x
		if cursor_on_the_left and not facing_left:
			set_facing(true)
		elif not cursor_on_the_left and facing_left:
			set_facing(false)	
	elif _state == State.WALKING or _state == State.RUNNING:
		if facing_left and velocity.x > 0.0:
			set_facing(false)
		elif not facing_left and velocity.x < 0.0:
			set_facing(true)
			
	var aim_direction: Vector2 = Vector2.RIGHT
	if hands.aiming():
		aim_direction = hands.global_position.direction_to(global_mouse_position)
		if facing_left:
			aim_direction.x *= -1.0
	hands_transform.rotation = aim_direction.angle()
		
func update_velocity(delta: float) -> void:
	velocity = velocity.move_toward(movement_input * max_speed, delta * max_speed * TAU)

func enter_state(new_state: State) -> void:
	if new_state == State.RUNNING:
		max_speed = run_speed
	else:
		max_speed = walk_speed

	prev_body_state = _state
	_state = new_state
	state_entered.emit(new_state)
	play_state_animation(new_state)
	state_label.text = State.find_key(_state)

func set_facing(left: bool) -> void:
	if left:
		facing_left = true
		pelvic.scale.x = -1.0
	else:
		facing_left = false
		pelvic.scale.x = 1.0
	changed_facing.emit(facing_left)	

func play_state_animation(state: State) -> void:
	match state:
		State.IDLE:
			animation_player.play("idle")
		State.WALKING:
			animation_player.play("walk")
		State.RUNNING:
			animation_player.play("run")
		_:
			breakpoint

func _process(delta: float) -> void:
	update_velocity(delta)
	update_state()
	update_hands()
	update_facing()
	
	## Clear input
	set_input_state(Vector2.ZERO, false, false, false, false)
			
func _physics_process(_delta: float) -> void:
	move_and_slide()
	

func shoot_bullet() -> void:
	#action_audio_player.play()
	print("poof!")
