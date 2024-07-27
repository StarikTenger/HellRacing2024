extends Label

@onready var level_manager: LevelManager = $"/root/LevelManager"

func _process(delta):
	text = "Время: %d:%02d" % [floor(level_manager.current_time / 60), int(level_manager.current_time) % 60]
