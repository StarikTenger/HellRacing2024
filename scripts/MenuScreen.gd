extends Control

class_name MenuScreen

@onready var level_manager: LevelManager = $"/root/LevelManager"
@onready var info_label = $"LabelsContainer/VBoxContainer/InfoLabel"
@onready var time_label = $"LabelsContainer/VBoxContainer/TimeLabel"
@onready var leaderboard_grid: GridContainer = $"LeaderboardContainer/VBoxContainer/GridContainer"

@export var limit = 10
@export var font_size = 36

# Called when the node enters the scene tree for the first time.
func _ready():
	level_manager.parse_leader_board.connect(_on_leaderpoard_refresh)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if level_manager.is_dead:
		info_label.text = "You DEAD"
	elif level_manager.is_victory:
		info_label.text = "Victory!"
	else:
		info_label.text = "Level %d" % (level_manager.current_level_index + 1)
		
	time_label.text = "%02d:%02d" % [floor(level_manager.current_time / 60), int(level_manager.current_time) % 60]
	

func _on_leaderpoard_refresh():
	clear_leaderboard_grid();
	update_leaderboard_grid(level_manager.current_leader_board);
		
	
func clear_leaderboard_grid():
	for child in leaderboard_grid.get_children():
		leaderboard_grid.remove_child(child)
		child.queue_free()

func update_leaderboard_grid(dict: Dictionary):
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
	score_header.text = "SCORE"
	
	leaderboard_grid.add_child(rank_header)
	leaderboard_grid.add_child(name_header)
	leaderboard_grid.add_child(score_header)
	
	if not dict:
		return
	
	var i = 1
	for row in dict["items"]:
		if i > limit:
			break
			
		i += 1
		
		var rank_label = Label.new()
		rank_label.set("label_settings", label_settings)
		rank_label.text = str(row["rank"])
		
		var name_label = Label.new()
		name_label.set("label_settings", label_settings)
		name_label.text = row["player"]["name"]
		
		var score_label = Label.new()
		score_label.set("label_settings", label_settings)
		score_label.text = str("%02d:%02d" % [floor(row["score"] / 60), int(row["score"]) % 60])
		
		leaderboard_grid.add_child(rank_label)
		leaderboard_grid.add_child(name_label)
		leaderboard_grid.add_child(score_label)
		
		
	
