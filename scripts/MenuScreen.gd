extends Control

class_name MenuScreen

@onready var level_manager: LevelManager = $"/root/LevelManager"
@onready var info_label = $"LabelsContainer/VBoxContainer/InfoLabel"
@onready var time_label = $"LabelsContainer/VBoxContainer/TimeLabel"
@onready var leaderboard_grid: GridContainer = $"LeaderboardContainer/VBoxContainer/GridContainer"

@export var limit = 7
@export var font_size = 36

@export var dead_color: Color
@export var win_color: Color
@export var level_color: Color

var current_leaderboard = {}

var font = load("res://fonts/ChangaOne-Regular.ttf")
var label_settings = LabelSettings.new()

var info_label_settings = LabelSettings.new()

func _init():
	label_settings.font = font
	label_settings.font_size = font_size
	
	info_label_settings.font = font
	info_label_settings.font_size = 64

# Called when the node enters the scene tree for the first time.
func _ready():
	level_manager.parse_leader_board.connect(_on_leaderpoard_refresh)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if level_manager.is_dead:
		info_label.text = "You dead"
		info_label_settings.font_color = dead_color
	elif level_manager.is_victory:
		info_label.text = "You won!"
		info_label_settings.font_color = win_color
	else:
		info_label.text = "Level %d" % (level_manager.current_level_index + 1)
		info_label_settings.font_color = level_color
		
	info_label.set("label_settings", info_label_settings)
		
	time_label.text = "%02d:%02d" % [floor(level_manager.current_time / 60), int(level_manager.current_time) % 60]
	

func _on_leaderpoard_refresh():
	clear_leaderboard_grid();
	update_leaderboard_grid();
		
	
func clear_leaderboard_grid():
	for child in leaderboard_grid.get_children():
		leaderboard_grid.remove_child(child)
		child.queue_free()

func sort_ascending(a, b) -> bool:
	if a[1] < b[1]:
		return true
	return false


func update_leaderboard_grid():
	if not current_leaderboard:
		return
	var arr = []
	for key in current_leaderboard:
		var temp = []
		temp.append(key)
		temp.append(current_leaderboard[key])
		arr.append(temp)
	
	arr.sort_custom(sort_ascending)
	
	var font = load("res://fonts/ChangaOne-Regular.ttf")
	var label_settings = LabelSettings.new()
	label_settings.font = font
	label_settings.font_size = font_size
	
	var rank_header = Label.new()
	rank_header.set("label_settings", label_settings)
	rank_header.text = "RANK"
		
	var name_header = Label.new()
	name_header.set("label_settings", label_settings)
	name_header.text = "NAME"
		
	var score_header = Label.new()
	score_header.set("label_settings", label_settings)
	score_header.text = "TIME"
	
	leaderboard_grid.add_child(rank_header)
	leaderboard_grid.add_child(name_header)
	leaderboard_grid.add_child(score_header)
	
	
	var i = 1
	for row in arr:
		if i > limit:
			break
			
		i += 1
		
		var rank_label = Label.new()
		rank_label.set("label_settings", label_settings)
		rank_label.text = str(i - 1)
		
		var name_label = Label.new()
		name_label.set("label_settings", label_settings)
		name_label.text = row[0]
		
		var score_label = Label.new()
		score_label.set("label_settings", label_settings)
		score_label.text = str("%02d:%02d" % [floor(row[1] / 60), int(row[1]) % 60])
		
		leaderboard_grid.add_child(rank_label)
		leaderboard_grid.add_child(name_label)
		leaderboard_grid.add_child(score_label)
		


func _on_volume_slider_value_changed(value):
	var norm_value = -20 + value*0.2
	if value == 0:
		norm_value = -10000000
	level_manager.music_quite.volume_modifier_2 = norm_value
	level_manager.music_loud.volume_modifier_2 = norm_value
