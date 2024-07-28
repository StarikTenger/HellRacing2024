extends CharacterBody2D

class_name Skull

signal berserk_on
signal berserk_off

@export var force : float
@export var basic_force : float = 200
@export var turn_speed : float = 5
@export var force_threshold : float = 1000
@export var friction_k : float
@export var basic_friction_k : float = 5
@export var turn_smoothness : float = 0.1
@export var overheat_time : float = 5 # Time in seconds to overheat (when heat = 1)
@export var berserk_threshold : float = 0.5 # Heat value when destruction starts

var target_rotation : float
var heat : float


@onready var level_manager: Node2D = $".."

enum State {
	ALIVE,
	PAUSED,
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
	emit_smoke_particles()
	$SteamSound.play()
	$FireSound.stop()
	
func stop_particles():
	$FireParticles.emitting = false
	$FireParticles2.emitting = false

func start_particles():
	$FireParticles.emitting = true
	$FireParticles2.emitting = true

func emit_smoke_particles():
	$SmokeParticles.emitting = true
	

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
			
			$FireSound.volume_db = min(velocity.length() * (30./1000.) - 30., 0)

			rotation = lerp_angle(rotation, target_rotation, turn_smoothness)

			var collision: KinematicCollision2D = move_and_collide(velocity * delta)

			if collision:
				var collider = collision.get_collider()
				if collider is DestructibleObject:
					if heat > berserk_threshold:
						(collider as DestructibleObject).destroy()	
					else:
						die()
				else:
					velocity -= velocity.project(collision.get_normal())
		State.PAUSED:
			pass
		State.DEAD:
			pass
		_:
			assert(false)

# Called when the node enters the scene tree for the first time.
func _ready():
	get_node("SkullAnimation").play()
	
func get_sector(angle: float) -> int:
	# Normalize the angle to be within [0, 360) degrees
	var normalized_angle = int(angle) % 360
	if normalized_angle < 0:
		normalized_angle += 360

	# Each sector spans 45 degrees
	var sector_size = 45.0

	# Determine the sector by dividing the angle by the sector size
	var sector = int(normalized_angle / sector_size)

	return sector

	
func rotation_animation():
	var rot = get_sector(rotation_degrees + 22.5)
	rot = 8 - rot
	rot += 2
	rot %= 8
	$SkullAnimation.global_rotation = 0
	$SkullAnimation.flip_h = false
	match rot:
		0: 
			$SkullAnimation.play("rot_a")
		1: 
			$SkullAnimation.play("rot_b")
		2: 
			$SkullAnimation.play("rot_c")
		3: 
			$SkullAnimation.play("rot_d")
		4: 
			$SkullAnimation.play("rot_e")
		5: 
			$SkullAnimation.play("rot_d")
			$SkullAnimation.flip_h = true
		6: 
			$SkullAnimation.play("rot_c")
			$SkullAnimation.flip_h = true
		7: 
			$SkullAnimation.play("rot_b")
			$SkullAnimation.flip_h = true

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):		
	
	match state:
		State.PAUSED:
			pass
		State.DEAD:
			pass
		State.ALIVE:
			rotation_animation()
			# Test slowdown, TODO remove
			if Input.is_action_pressed("down"):
				slow_down()
			# Rotation control
			if Input.is_action_pressed("left"):
				target_rotation -= turn_speed * delta
			if Input.is_action_pressed("right"):
				target_rotation += turn_speed * delta
			


func _on_cooldown_timeout():
	acceleration_on = true
	start_particles()
	$SmokeParticles.emitting = false
	$FireSound.play()


func _on_tile_detection_body_shape_entered(body_rid, body, body_shape_index, local_shape_index):
	if body is TileMap:
		die()
		
func pause():
	state = State.PAUSED
	
func resume():
	state = State.ALIVE

func die():
	state = State.DEAD
	$FireSound.stop()
	level_manager.death()
	stop_particles()

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
	$FireSound.play()
	start_particles()

