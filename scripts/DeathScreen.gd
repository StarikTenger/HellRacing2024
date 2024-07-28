extends Control

@onready var level_manager = $"/root/LevelManager"

# Called when the node enters the scene tree for the first time.
func _ready():
	level_manager.dead.connect(_on_dead)
	level_manager.respawned.connect(_on_respawned)
	hide()

func _process(delta):
	pass
		

func _on_dead():
	show()
	
func _on_respawned():
	hide()

func _on_restart_level_button_pressed():
	level_manager.restart_level()
	
func _on_restart_game_button_pressed():
	level_manager.restart_game()



