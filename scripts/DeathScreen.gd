extends Control

@onready var level_manager = $"../../.."

# Called when the node enters the scene tree for the first time.
func _ready():
	hide()


func show_death_screen():
	show()


func _on_restart_button_pressed():
	level_manager.restart_level()
