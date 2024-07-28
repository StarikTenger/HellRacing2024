extends Node2D

@export var bonus_scene: PackedScene = preload("res://scenes/cooldown_bonus.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func spawn_bonus():
	for spawnpoint in $"CooldownPositions".get_children():
		if spawnpoint is Marker2D:
			var bonus : Area2D = bonus_scene.instantiate()
			bonus.position = spawnpoint.position
			$Bonuses.add_child(bonus)
