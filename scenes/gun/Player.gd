extends CharacterBody3D

#constants
const GRAVITY = 9.8

#mouse sensitivity
@export var sensitivity_x = 0.5 # (float,0.1,1.0)
@export var sensitivity_y = 0.4 # (float,0.1,1.0)

#physics
@export var speed = 15.0 # (float,10.0, 30.0)
@export var jump_height = 25 # (float,10.0, 50.0)
@export var mass = 8.0 # (float,1.0, 10.0)
@export var gravity_scl = 1.0 # (float,0.1, 3.0, 0.1)

#instances ref
@onready var player_hand = $Pivot
@onready var ground_ray = $GroundRay

#variables
var mouse_motion = Vector2()
var gravity_speed = 0


func _physics_process(delta):
	
	#camera and body rotation
	rotate_y(deg_to_rad(20)* - mouse_motion.x * sensitivity_x * delta)
	player_hand.rotate_x(deg_to_rad(20) * - mouse_motion.y * sensitivity_y * delta)
	player_hand.rotation.x = clamp(player_hand.rotation.x, deg_to_rad(-15), deg_to_rad(47))
	# player_hand.rotation.x = player_hand.rotation.x
	mouse_motion = Vector2()
	
	#gravity
	gravity_speed -= GRAVITY * gravity_scl * mass * delta
	
	#character moviment
	var velocity = Vector3()
	velocity = _axis() * speed
	velocity.y = gravity_speed
	
	#jump
	if Input.is_action_just_pressed("space") and ground_ray.is_colliding():
		velocity.y = jump_height
	
	set_velocity(velocity)
	move_and_slide()
	gravity_speed = velocity.y
	
	pass


func _input(event):
	
	if event is InputEventMouseMotion:
		mouse_motion = event.relative


func _axis():
	var direction = Vector3()
	
	if Input.is_key_pressed(KEY_W):
		direction -= get_global_transform().basis.z.normalized()
		
	if Input.is_key_pressed(KEY_S):
		direction += get_global_transform().basis.z.normalized()
		
	if Input.is_key_pressed(KEY_A):
		direction -= get_global_transform().basis.x.normalized()
		
	if Input.is_key_pressed(KEY_D):
		direction += get_global_transform().basis.x.normalized()
		
	return direction.normalized()
