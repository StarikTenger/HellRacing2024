extends CharacterBody2D

@export var force : float = 100
@export var basic_speed : float = 200
@export var turn_speed : float = 5
@export var speed_threshold : float = 1000
@export var friction_k : float = 2.5
@export var turn_smoothness : float = 0.1
@export var target_rotation : float = 0.0

@onready var death_screen = get_node("../CanvasLayer/DeathScreen")

var acceleration_on = true

func change_speed(delta):
	force *= pow(1.2, delta)
	if force > speed_threshold:
		force = speed_threshold

func slow_down():
	acceleration_on = false
	force = basic_speed
	$Cooldown.start()

func _physics_process(delta):
	# Acceleration
	var direction : Vector2 = Vector2(1, 0).rotated(rotation)
	if acceleration_on :
		velocity += direction * force * delta
		change_speed(delta)

	# Friction
	var direction_k : float = (1 - abs(velocity.normalized().dot(direction)))
	velocity -= velocity * direction_k * friction_k * delta;

	# Rotation control
	if Input.is_action_pressed("left"):
		target_rotation -= turn_speed * delta
	if Input.is_action_pressed("right"):
		target_rotation += turn_speed * delta
	
	rotation = lerp_angle(rotation, target_rotation, turn_smoothness)
	
	# Test slowdown
	if Input.is_action_pressed("down"):
		slow_down()
	
	move_and_slide()

# Called when the node enters the scene tree for the first time.
func _ready():
	position = $"../StartPosition".position
	print(position)
	get_node("SkullAnimation").play()
	force = basic_speed
	
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_cooldown_timeout():
	acceleration_on = true


func _on_tile_detection_body_shape_entered(body_rid, body, body_shape_index, local_shape_index):
	if body is TileMap:
		die()

func die():
	set_physics_process(false)
	set_process(false)
	death_screen.show_death_screen()
