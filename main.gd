extends Node2D

@export var bonus_scene: PackedScene

# Called when the node enters the scene tree for the first time.
func _ready():
	for spawnpoint in $"CooldownPositions".get_children():
		if spawnpoint is Marker2D:
			var bonus : Area2D = bonus_scene.instantiate()
			bonus.position = spawnpoint.position
			add_child(bonus)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
