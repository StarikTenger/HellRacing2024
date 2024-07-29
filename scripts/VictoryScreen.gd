extends Control

@onready var level_manager: LevelManager = $"/root/LevelManager"
@onready var line_edit: LineEdit = $"MenuScreen/LineEdit"

func _ready():
	level_manager.victory_happend.connect(_on_victory)
	level_manager.resumed.connect(_on_resumed)
	hide()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _on_victory():
	show()
	
func _on_resumed():
	hide()


func _on_submit_button_pressed():
	var name = line_edit.text
	level_manager.submit_score_leader_board(name)


func _on_restart_game_button_pressed():
	level_manager.restart_game()
