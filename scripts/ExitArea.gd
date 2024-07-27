extends Area2D

@onready var player: Skull = $"../../Skull"

func _on_body_entered(body):
	if body == player:
		player.goal_reached()
