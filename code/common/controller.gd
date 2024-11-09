class_name Controller extends Node

enum Behavior { NONE, PASSIVE, ROAMING, COMBAT }

@export var character: Character 
@export var ai_controlled: bool
@export var behavior: Behavior

var behavior_stack: Array[Behavior]
var current_behavior: Behavior

## INPUT
var movement_input: Vector2
var run_input: bool
var ready_input: bool
var attack_input: bool
var use_input: bool

func _ready() -> void:
	#Input.use_accumulated_input = true
	pass

func send_input() -> void:
	character.set_input_state(movement_input, run_input, ready_input, attack_input, use_input)

func poll_input() -> void:
	movement_input= Input.get_vector("move_left", "move_right", "move_up", "move_down")
	run_input = Input.is_action_pressed("run")
	ready_input = Input.is_action_pressed("aim")
	attack_input = Input.is_action_pressed("attack")
	use_input = Input.is_action_pressed("use")
	
func update_behavior() -> void:
	pass
	
func simulate_input() -> void:
	pass		
	
func process_behavior() -> void:
	var behavior: Behavior = behavior_stack.back()
	match behavior:
		Behavior.NONE:
			pass
		Behavior.PASSIVE:
			process_passive()
		Behavior.ROAMING:
			process_roaming()
		Behavior.COMBAT:
			process_combat()
	
func _process(delta: float) -> void:
	if not character:
		return
	
	if ai_controlled:
		update_behavior()
		simulate_input()
	else:
		poll_input()
	send_input()
		

## COMMON		
var waiting: bool
var waited_enough: bool
var target_position: Vector2
var close_enough: bool
var far_enough: bool

func check_surroundings() -> void:
	#character.perception.
	pass

func update_state() -> void:
	check_surroundings()

func move_to(position: Vector2) -> void:
	pass

func retreat_from(position: Vector2) -> void:
	pass

func retreat_from_map() -> void:
	pass

func retreat_move_away_from_map() -> void:
	pass

func wait(seconds: float) -> void:
	if not waiting:
		waited_enough = false
		waiting = true
		await get_tree().create_timer(seconds).timeout
		waited_enough = true
		waiting = false

## PASSIVE
func process_passive() -> void:
	pass

## COMBAT
@export_category("Combat")
var enemy: Node2D
var enemy_position: Vector2
var enemy_nearby: bool	# ai 'knows' enemy is somewhere around
var can_see_enemy: bool # ai successfully traces enemy
var close_enough_to_enemy: bool # can deal damage to enemy
var far_enough_from_enemy: bool # enemy cannot deal damage to ai
var enemy_too_close: bool # ex. enemy using melee and ai using ranged
var last_known_enemy_position: Vector2
var in_bad_shape: bool
var can_heal: bool
@export var fear_for_his_life: bool
	
func start_combat() -> void:
	pass
	
func end_combat() -> void:
	pass	

func heal_self() -> void:
	pass		

func engage(target: Node2D) -> void:
	pass

func search_last_known_position() -> void:
	pass

func process_combat() -> void:
	if in_bad_shape and fear_for_his_life:
		if far_enough_from_enemy:
			if can_heal:
				heal_self()
			else:
				retreat_from_map()
		else:
			if can_see_enemy:
				retreat_from(enemy_position)
			else:
				retreat_from(last_known_enemy_position)
		
	if enemy_nearby:
		if can_see_enemy:
			if enemy_too_close:
				retreat_from(enemy_position)
			if close_enough_to_enemy:
				engage(enemy)
			else:
				move_to(enemy_position)
		else: 
			search_last_known_position()
	else:
		end_combat()

## ROAMING
@export_category("Roaming")
@export var roaming_distance: float = 100.0
@export var roaming_randomness: float = 0.0
@export var roaming_wait_seconds: float = 4.0

var roaming_point: Vector2
var roaming_point_reached: bool

func start_roaming() -> void:
	choose_next_roaming_point()

func end_roaming() -> void:
	pass

func choose_next_roaming_point() -> void:
	var navigation_map: RID = character.get_world_2d().navigation_map
	var closest_point: Vector2 = NavigationServer2D.map_get_closest_point(navigation_map, character.global_position)
	NavigationServer2D

func process_roaming() -> void:
	if enemy_nearby:
		start_combat()
	else:
		if roaming_point_reached:
			if waited_enough:
				choose_next_roaming_point()
			else:
				wait(roaming_wait_seconds)
		else:
			move_to(roaming_point)
