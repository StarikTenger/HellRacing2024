extends Control

@onready var level_manager = $"/root/LevelManager"

func _ready():
	level_manager.paused.connect(_on_paused)
	level_manager.resumed.connect(_on_resumed)
	hide()

func _process(delta):
	pass

func _on_paused():
	show()
	
func _on_resumed():
	hide()


func _on_resume_game_button_pressed():
	level_manager.resume_game()

func _on_restart_level_button_pressed():
	level_manager.restart_level()
	
func _on_restart_game_button_pressed():
	level_manager.restart_game()

