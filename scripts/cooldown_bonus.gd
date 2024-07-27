extends Area2D

@onready var player : Skull = $"../../Skull"

# Called when the node enters the scene tree for the first time.
func _ready():
	$AnimatedSprite2D.play()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_body_entered(body):
	if body == player:
		print("enter")
		player.slow_down()
		queue_free()
	
