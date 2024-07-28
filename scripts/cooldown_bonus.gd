extends Area2D

@onready var player : Skull = $"../../../Skull"

# Called when the node enters the scene tree for the first time.
func _ready():
	$AnimatedSprite2D.play("default")


# Called every frame. 'delta' is the elapsed time since the previous frame.
var time : float = 0
func _process(delta):
	time += delta
	$AnimatedSprite2D.position.y = 10 * sin(time)


func _on_body_entered(body):
	if body == player:
		print("enter")
		player.slow_down()
		$AnimatedSprite2D.play("splash")
		$SplashParticles.restart()
		await $AnimatedSprite2D.animation_finished
		queue_free()
	
