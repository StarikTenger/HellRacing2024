extends Node2D

@export var bonus_scene: PackedScene

# Called when the node enters the scene tree for the first time.
func _ready():
	spawn_bonus()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	
func spawn_bonus():
	return
	for bonus in $Bonuses.get_children():
		bonus.queue_free()
	for spawnpoint in $"CooldownPositions".get_children():
		if spawnpoint is Marker2D:
			var bonus : Area2D = bonus_scene.instantiate()
			bonus.position = spawnpoint.position
			$Bonuses.add_child(bonus)
