extends Node2D

class_name LevelManager

# @export var levels = ["res://Levels/level_1.tscn","res://Levels/level_2.tscn", "res://Levels/level_andrei.tscn", "res://Levels/level_4.tscn"]  # Список сцен уровней
@export var levels = ["res://Levels/level_1.tscn"]

var response_session: GuestSession = null
var response_player_set_name : PlayerName = null
var player_response_data: Variant = null

var leaderboard_key = "lead_board_key"

var loaded_levels = []
var current_level_index: int = 0
var current_level: Node2D = null
var player: Skull = null
var player_name = "Dodik"
var player_id: int

var music_quite: MusicQuite = null
var music_loud: MusicLoud = null

var is_game_active: bool = true;
var is_dead: bool = false;
var is_victory: bool = false;
var is_not_started: bool = true;
var current_time: float = 0 # В секундах

var current_leader_board: Dictionary;

signal dead;
signal respawned;
signal paused;
signal resumed;
signal parse_leader_board;
signal victory_happend;

func _ready():
	for i in range(len(levels)):
		loaded_levels.append(load(levels[i]))
	start_game()
	# await auth()
	# player_response_data = JSON.parse_string(response_session.ToJson())

func load_materials():
	player = load("res://scenes/Skull.tscn").instantiate()
	add_child(player)
	add_child(load("res://scenes/HUD.tscn").instantiate())
	add_child(load("res://scenes/camera_2d.tscn").instantiate())
	player.add_child(load("res://scenes/remote_transform_2d.tscn").instantiate())
	
	music_quite = load("res://scenes/music_quite.tscn").instantiate()
	add_child(music_quite)
	music_loud = load("res://scenes/music_loud.tscn").instantiate()
	add_child(music_loud)

func start_game():
	print(loaded_levels)
	load_materials()
	var st_scene = $StartScene
	remove_child(st_scene)
	st_scene.queue_free()
	load_level(0)
	is_not_started = false

func _process(delta):
	if is_game_active:
		current_time += delta

func _input(event):
	if event.is_action_pressed("pause"):
		change_game_state()

func change_game_state():
	if is_dead or is_victory or is_not_started:
		return
	
	if is_game_active:
		pause_game()
	else:
		resume_game()

func pause_game():
	player.pause()
	is_game_active = false
	paused.emit()
	# current_leader_board = await refresh_leader_board()
	parse_leader_board.emit()
	
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
	if not (level_index >= 0 and level_index < loaded_levels.size()):
		return
		
	var level_path: PackedScene = loaded_levels[level_index]
	if current_level:
		remove_child(current_level)
		current_level.queue_free()
	current_level = level_path.instantiate()
	add_child(current_level)
	var pos: Node2D = current_level.get_node("StartPosition")
	player.spawn(pos.position, 0)
	current_level.spawn_bonus()
	is_game_active = true
	is_dead = false;
	is_victory = false;
	respawned.emit()

func goal_reached() -> void:
	next_level()

func victory() -> void:
	is_victory = true;
	player.pause()
	is_game_active = false
	victory_happend.emit()
	# current_leader_board = await refresh_leader_board()
	parse_leader_board.emit()
	
func death() -> void:
	is_dead = true;
	dead.emit();
	is_game_active = false
	# current_leader_board = await refresh_leader_board()
	parse_leader_board.emit()

func refresh_leader_board() -> Dictionary:
	return {}
	var getLeaderboard : LootLockerGetLeaderboard = await LootLockerApi._ListLeaderboard(leaderboard_key)
	if not getLeaderboard:
		return current_leader_board
	return JSON.parse_string(getLeaderboard.ToJson())


func auth(name=null) -> bool:
	response_session = null
	response_session = await LootLockerApi._guestLogin()
	if name:
		player_name = name
		var response_player_set_name : PlayerName = await LootLockerApi._setPlayerName(player_name)
	while true:
		if response_session:
			return true
	return false


func submit_score_leader_board(name = null) -> void:
	# await auth(name)
	if name:
		player_name = name
		var response : PlayerName = await LootLockerApi._setPlayerName(name)
	var leaderboardResponse : LootLockerLeaderboardSubmit = null
	if await is_best_result():
		leaderboardResponse = await LootLockerApi._SubmitScore(leaderboard_key, "", current_time, "Some interesting metadata")


func is_best_result() -> bool:
	return false
	if response_session:
		player_id = player_response_data["player_id"]
		if player_response_data["seen_before"]:
			var getLeaderboard : LootLockerGetLeaderboard = await LootLockerApi._ListLeaderboard(leaderboard_key)
			if getLeaderboard:
				var list_of_lb = JSON.parse_string(getLeaderboard.ToJson())
				# print(list_of_lb)
				if list_of_lb["items"]:
					var flag : bool = false
					for pl in list_of_lb["items"]:
						if pl["player"]["id"] == player_id:
							flag = true
							#print(pl["score"])
							if pl["score"] > current_time:
								return true
					if !flag:
						return true
		else:
			return true
	return false

func next_level():
	current_level_index += 1
	if current_level_index < levels.size():
		load_level(current_level_index)
	else:
		victory()

