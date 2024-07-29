extends Area2D

class_name CooldownBonus

@onready var player : Skull = $"/root/LevelManager/Skull"

# Called when the node enters the scene tree for the first time.
func _ready():
	$AnimatedSprite2D.play("default")


# Called every frame. 'delta' is the elapsed time since the previous frame.
var time : float = 0
func _process(delta):
	time += delta
	$AnimatedSprite2D.position.y = 10 * sin(time)
	var scale : float = 0.215 + 0.03 * sin(time)
	$Shadow.scale = Vector2(scale, scale)
	print(player)


func _on_body_entered(body):
	if body == player:
		print("enter")
		player.slow_down()
		$AnimatedSprite2D.play("splash")
		$SplashParticles.restart()
		await $AnimatedSprite2D.animation_finished
		queue_free()
	
