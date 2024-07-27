extends Node2D

@export var levels = ["res://Levels/level_1.tscn", "res://Levels/level_2.tscn"]  # Список сцен уровней

@onready var death_screen: Control = null

var loaded_levels = []
var current_level_index = 0
var current_level: Node2D = null
var player = null

func _ready():
	player = $Skull
	for i in range(len(levels)):
		loaded_levels.append(load(levels[i]))
	load_level(current_level_index)
	death_screen = $"HUD/Screen/DeathScreen"

func restart_level():
	var pos: Node2D = current_level.get_node("StartPosition")
	$"HUD/Screen/DeathScreen".hide()
	player.spawn(pos.position, 0)
	current_level.spawn_bonus()
	
func restart_game():
	load_level(0)

func load_level(level_index):
	current_level_index = level_index
	assert(level_index >= 0 and level_index < loaded_levels.size())
	var level_path: PackedScene = loaded_levels[level_index]
	remove_child(current_level)
	current_level = level_path.instantiate()
	add_child(current_level)
	restart_level()

func goal_reached() -> void:
	next_level()

func victory() -> void:
	pass  # TODO
	
func death() -> void:
	death_screen.show_death_screen()

func next_level():
	current_level_index += 1
	print(current_level_index)
	if current_level_index < levels.size():
		load_level(current_level_index)
	else:
		victory()

