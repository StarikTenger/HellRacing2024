extends Area2D

@onready var player : Skull = $"../../../Skull"

enum State {
	ACTIVE,
	INACTIVE,
	PICKED
}

var state : State 
var animation : AnimatedSprite2D = null

var ticks_to_activate : int

# Called when the node enters the scene tree for the first time.
func _ready():
	print("_ready")
	animation = $AnimatedSprite2D
	animation.play("default")
	state = State.INACTIVE
	ticks_to_activate = 2


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	match state:
		State.INACTIVE:
			if ticks_to_activate == 0:
				print("activate ", player.position)
				state = State.ACTIVE
				$CollisionShape2D.disabled = false
			else:
				ticks_to_activate -= 1
		State.PICKED:
			if not animation.is_playing():
				queue_free()


func _on_body_entered(body):
	if body == player:
		player.slow_down()
		animation.play("splash")
		state = State.PICKED
	
