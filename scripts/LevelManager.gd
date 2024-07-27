extends Node2D

class_name LevelManager

@export var levels = ["res://Levels/level_1.tscn", "res://Levels/level_2.tscn"]  # Список сцен уровней

@onready var death_screen: Control = null

var loaded_levels = []
var current_level_index: int = 0
var current_level: Node2D = null
var player: Skull = null

var is_game_active: bool = true;
var current_time: float = 0 # В секундах

func _ready():
	player = $Skull
	for i in range(len(levels)):
		loaded_levels.append(load(levels[i]))
	load_level(current_level_index)
	death_screen = $"HUD/Screen/DeathScreen"
	
func _process(delta):
	if is_game_active:
		current_time += delta

func restart_level():
	load_level(current_level_index)
	
func restart_game():
	load_level(0)
	current_time = 0
	

func load_level(level_index):
	player.state = Skull.State.DEAD
	current_level_index = level_index
	assert(level_index >= 0 and level_index < loaded_levels.size())
	var level_path: PackedScene = loaded_levels[level_index]
	remove_child(current_level)
	if current_level:
		current_level.queue_free()
	current_level = level_path.instantiate()
	add_child(current_level)
	var pos: Node2D = current_level.get_node("StartPosition")
	$"HUD/Screen/DeathScreen".hide()
	current_level.spawn_bonus()
	is_game_active = true
	player.spawn(pos.position, 0)

func goal_reached() -> void:
	next_level()

func victory() -> void:
	is_game_active = false
	
func death() -> void:
	is_game_active = false
	death_screen.show_death_screen()

func next_level():
	if current_level_index + 1 < levels.size():
		current_level_index += 1

	if current_level_index < levels.size():
		load_level(current_level_index)
	else:
		victory()

