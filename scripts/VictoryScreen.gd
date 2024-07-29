extends Control

@onready var level_manager: LevelManager = $"/root/LevelManager"
@onready var line_edit: LineEdit = $"MenuScreen/LineEdit"
@onready var menu_screen: Control = $MenuScreen


func _ready():
	level_manager.victory_happend.connect(_on_victory)
	level_manager.resumed.connect(_on_resumed)
	hide()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	# print(menu_screen.current_leaderboard)
	pass

func _on_victory():
	show()
	$MenuScreen/SubmitButton.show()
	$MenuScreen/LineEdit.show()
	
func _on_resumed():
	hide()


func _on_submit_button_pressed():
	var name = line_edit.text
	#level_manager.submit_score_leader_board(name)
	if name in menu_screen.current_leaderboard:
		if menu_screen.current_leaderboard[name] > level_manager.current_time:
			menu_screen.current_leaderboard[name] = level_manager.current_time
	else:
		menu_screen.current_leaderboard[name] = level_manager.current_time
	
	level_manager.parse_leader_board.emit()
	$MenuScreen/SubmitButton.hide()
	$MenuScreen/LineEdit.hide()


func _on_restart_game_button_pressed():
	level_manager.restart_game()
