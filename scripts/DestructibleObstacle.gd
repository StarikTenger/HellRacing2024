extends Node
class_name DestructibleObject

@export var durability: float = 100.0

enum State {
	ACTIVE,
	INACTIVE
}

var state: State
var health: float
var death_sound: AudioStreamPlayer2D
var collider_shape: CollisionShape2D
var sprite: Sprite2D

@onready var player : Skull = $"/root/LevelManager/Skull"

func is_active():
	return state == State.ACTIVE

func destroy():
	$ColliderShape.disabled = true
	state = State.INACTIVE
	$Animation.play("death")
	await $Animation.animation_finished
	queue_free()

# Called when the node enters the scene tree for the first time.
func _ready():
	state = State.ACTIVE
	health = durability
	death_sound = $DestroySound
	collider_shape = $ColliderShape
	sprite = $Sprite
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta : float):
	
	match state:
		State.ACTIVE:
			if player.heat > player.berserk_threshold:
				$Animation.play("weak")
			else:
				$Animation.play("strong")
		State.INACTIVE:
			if not death_sound.is_playing():
				# queue_free()
				pass
