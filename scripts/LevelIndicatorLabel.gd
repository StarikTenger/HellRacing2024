extends Label

@onready var level_manager: LevelManager = $"/root/LevelManager"

func _process(delta):
	text = "Level %d" % (level_manager.current_level_index + 1)

