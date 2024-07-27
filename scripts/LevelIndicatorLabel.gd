extends Label

@onready var level_manager = $"/root/LevelManager"

func _process(delta):
	text = "Уровень %d" % (level_manager.current_level_index + 1)

