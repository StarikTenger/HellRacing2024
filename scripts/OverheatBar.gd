extends TextureProgressBar

@export var skull: Skull

func _ready():
	skull = $"../../Skull"

# Called when the node enters the scene tree for the first time.
func _process(delta):
	update()

func update():
	value = skull.heat * 100
