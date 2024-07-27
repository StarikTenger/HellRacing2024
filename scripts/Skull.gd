extends CharacterBody2D

class_name Skull

@export var force : float
@export var basic_force : float = 200
@export var turn_speed : float = 5
@export var force_threshold : float = 1000
@export var friction_k : float
@export var basic_friction_k : float = 5
@export var turn_smoothness : float = 0.1
@export var overheat_time : float = 5 # Time in seconds to overheat (when heat = 1)

var target_rotation : float
var heat : float


@onready var level_manager: Node2D = $".."

enum State {
	ALIVE,
	DEAD
}

var state: State

var acceleration_on = true

func change_speed(delta):
	heat += delta / overheat_time
	if heat > 1:
		heat = 1

func slow_down():
	acceleration_on = false
	heat = 0
	stop_particles();
	$Cooldown.start()
	

func stop_particles():
	$FireParticles.emitting = false
	$FireParticles2.emitting = false

func start_particles():
	$FireParticles.emitting = true
	$FireParticles2.emitting = true

func _physics_process(delta):
	match state:
		State.ALIVE:
			force = basic_force * pow(10, heat)
			friction_k = basic_friction_k * pow(0.1, heat)

			# Acceleration
			var direction : Vector2 = Vector2(1, 0).rotated(rotation)
			if acceleration_on :
				velocity += direction * force * delta
				change_speed(delta)

			# Friction
			var direction_k : float = (1 - abs(velocity.normalized().dot(direction)))
			velocity -= velocity * direction_k * friction_k * delta;
			velocity += direction * direction_k * delta * basic_force

			rotation = lerp_angle(rotation, target_rotation, turn_smoothness)

			move_and_slide()
		State.DEAD:
			pass
		_:
			assert(false)

# Called when the node enters the scene tree for the first time.
func _ready():
	get_node("SkullAnimation").play()
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	match state:
		State.DEAD:
			pass
		State.ALIVE:
			# Test slowdown, TODO remove
			if Input.is_action_pressed("down"):
				slow_down()
			# Rotation control
			if Input.is_action_pressed("left"):
				target_rotation -= turn_speed * delta
			if Input.is_action_pressed("right"):
				target_rotation += turn_speed * delta
			if Input.is_action_just_pressed("restart"):
				call_restart()


func _on_cooldown_timeout():
	acceleration_on = true
	start_particles()


func _on_tile_detection_body_shape_entered(body_rid, body, body_shape_index, local_shape_index):
	if body is TileMap:
		die()

func die():
	stop_particles()
	set_physics_process(false)
	set_process(false)

func call_restart():
	# Вызвать следующий уровень из менеджера уровней
	level_manager.restart_level()

func goal_reached():
	# Вызвать следующий уровень из менеджера уровней
	level_manager.goal_reached()

func spawn(pos: Vector2, rot: float) -> void:
	state = State.ALIVE
	position = pos
	velocity = Vector2(0, 0)
	rotation = rot
	target_rotation = rot
	heat = 0
