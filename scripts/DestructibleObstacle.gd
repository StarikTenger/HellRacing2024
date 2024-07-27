extends Node
class_name DestructibleObject

@export var durability: float = 100.0

enum State {
	ALIVE,
	DYING
}

var state: State
var health: float
var death_sound: AudioStreamPlayer2D
var collider_shape: CollisionShape2D
var sprite: Sprite2D

# Called when the node enters the scene tree for the first time.
func _ready():
	state = State.ALIVE
	health = durability
	death_sound = $DestroySound
	collider_shape = $ColliderShape
	sprite = $Sprite
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	match state:
		State.ALIVE:
			pass
		State.DYING:
			if not death_sound.is_playing():
				queue_free()

func hit(impulse: Vector2) -> float:
	if state == State.ALIVE:
		var damage = impulse.length()
		if damage >= health:
			death_sound.play()
			state = State.DYING
			collider_shape.disabled = true
			sprite.visible = false
			return health / damage
		else:
			health -= damage
			return 1
		return 1
	else:
		return 0
