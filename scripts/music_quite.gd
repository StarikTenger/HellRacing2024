extends AudioStreamPlayer

class_name MusicQuite

@onready var level_manager = $"/root/LevelManager"

var volume_modifier = 0
var volume_modifier_2 = -10

func _on_paused():
	#volume_modifier = -20
	volume_modifier = 0
	
func _on_resumed():
	volume_modifier = 0
	

func _ready():
	level_manager.paused.connect(_on_paused)
	level_manager.resumed.connect(_on_resumed)
	volume_modifier = 0


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	volume_db = -10 + volume_modifier + volume_modifier_2
