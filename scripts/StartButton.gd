extends TextureButton

@onready var level_manager: LevelManager = $"/root/LevelManager"

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_pressed():
	level_manager.start_game()
