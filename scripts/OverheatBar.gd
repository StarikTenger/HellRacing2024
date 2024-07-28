extends TextureProgressBar

@export var skull: CharacterBody2D

func _ready():
	skull = $"/root/LevelManager/Skull"

# Called when the node enters the scene tree for the first time.
func _process(_delta: float):
	update()

func update():
	value = skull.heat * 100
