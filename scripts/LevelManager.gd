extends Node2D

class_name LevelManager

@export var levels = ["res://Levels/level_1.tscn", "res://Levels/level_2.tscn"]  # Список сцен уровней

var loaded_levels = []
var current_level_index: int = 0
var current_level: Node2D = null
var player: Skull = null

var is_game_active: bool = true;
var is_dead: bool = false;
var current_time: float = 0 # В секундах

signal dead;
signal respawned;
signal paused;
signal resumed;

func _ready():
	player = $Skull
	for i in range(len(levels)):
		loaded_levels.append(load(levels[i]))
	load_level(current_level_index)
	
func _process(delta):
	if is_game_active:
		current_time += delta

func _input(event):
	if event.is_action_pressed("restart"):
		restart_level()
	if event.is_action_pressed("pause"):
		change_game_state()

func change_game_state():
	if is_dead:
		return
	
	if is_game_active:
		pause_game()
	else:
		resume_game()

func pause_game():
	player.pause()
	is_game_active = false
	paused.emit()
	
func resume_game():
	player.resume()
	is_game_active = true
	resumed.emit()

func restart_level():
	load_level(current_level_index)
	resumed.emit()
	
func restart_game():
	load_level(0)
	current_time = 0
	resumed.emit()
	

func load_level(level_index):
	current_level_index = level_index
	assert(level_index >= 0 and level_index < loaded_levels.size())
	var level_path: PackedScene = loaded_levels[level_index]
	remove_child(current_level)
	if current_level:
		current_level.queue_free()
	current_level = level_path.instantiate()
	add_child(current_level)
	var pos: Node2D = current_level.get_node("StartPosition")
	player.spawn(pos.position, 0)
	current_level.spawn_bonus()
	is_game_active = true
	is_dead = false;
	respawned.emit()

func goal_reached() -> void:
	next_level()

func victory() -> void:
	is_game_active = false
	
func death() -> void:
	is_dead = true;
	dead.emit();
	is_game_active = false

func next_level():
	if current_level_index + 1 < levels.size():
		current_level_index += 1

	if current_level_index < levels.size():
		load_level(current_level_index)
	else:
		victory()

