class_name CharacterHands extends Node2D

enum State { IDLE, READY, ACTION, RELOADING }

signal state_entered(state: State)
signal started_being_busy
signal stopped_being_busy

@export var carrying: Equipment

@onready var hands_player: AnimationPlayer = $HandsPlayer

var current: State
var performing_action: bool

func _ready() -> void:
	enter_state(State.IDLE)

func busy() -> bool:
	return current != State.IDLE

func aiming() -> bool:
	return current == State.READY or current == State.ACTION

func update_state(ready: bool, action: bool, reload: bool, use: bool) -> void:
	var updated: State = State.IDLE
	if ready:
		updated = State.READY
		if action:
			updated = State.ACTION
		if reload:
			updated = State.RELOADING
		
	if current != updated:
		if not performing_action:
			enter_state(updated)
				

func start_transition(to: State) -> bool:
	return false

func enter_state(state: State) -> void:
	current = state
	play_state_animation(state)
	state_entered.emit(state)

func play_state_animation(state: State) -> void:
	if carrying:
		match state:
			State.IDLE:
				hands_player.play(carrying.idle_animation)
			State.READY:
				hands_player.play(carrying.ready_animation)
			State.ACTION:
				hands_player.play(carrying.action_animation)
				performing_action = true
				print("started shooting")
				await hands_player.animation_finished
				performing_action = false
				print("stopped shooting")
			State.RELOADING:
				hands_player.play(carrying.reload_animation)

func equip(equipment: Equipment) -> void:
	pass
	
func empty() -> void:
	pass
	
func is_handling_weapon() -> bool:
	return false
	
func is_shooting() -> bool:
	return false
	
func is_handling_melee() -> bool:
	#return current is MeleeWeapon
	return false
	
func is_handling_ranged() -> bool:
	#return current is RangedWeapon
	return false
