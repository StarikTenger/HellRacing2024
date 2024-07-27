extends CharacterBody2D

@export var speed : float = 100
@export var basic_speed : float = 100
@export var turn_speed : float = 5
@export var friction_k : float = 0.5
@export var turn_smoothness : float = 0.1
@export var target_rotation : float = 0.0

var acceleration_on = true

func change_speed(delta):
	speed *= pow(1.2, delta)
	var threshold : float = 1000
	if speed > threshold:
		speed = threshold

func slow_down():
	acceleration_on = false
	speed = basic_speed
	$Cooldown.start()

func _physics_process(delta):
	# Acceleration
	var direction : Vector2 = Vector2(1, 0).rotated(rotation)
	if acceleration_on:
		velocity += direction * speed * delta
		change_speed(delta)

	# Friction
	velocity -= velocity * friction_k * delta;

	# Rotation control
	if Input.is_action_pressed("ui_left"):
		target_rotation -= turn_speed * delta
	if Input.is_action_pressed("ui_right"):
		target_rotation += turn_speed * delta
	
	rotation = lerp_angle(rotation, target_rotation, turn_smoothness)
	
	# Test slowdown
	if Input.is_action_pressed("ui_down"):
		slow_down()
	
	move_and_slide()

# Called when the node enters the scene tree for the first time.
func _ready():
	get_node("SkullAnimation").play()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
		
	print(speed)


func _on_cooldown_timeout():
	acceleration_on = true
