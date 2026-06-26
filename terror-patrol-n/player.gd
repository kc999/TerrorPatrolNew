class_name Player extends CharacterBody3D

var moveInput: Vector2
var moveVelocity: Vector3
var moveSpeed: float = 8
var friction: float = 10
var jumpHeight: float = 6
var gravity: float = 12
@export var mouseSensitivity: float = 0.005
@onready var head: Node3D = $Head
@onready var camera: Camera3D = $Head/Camera

func mouse_input(_input:InputEvent):
	#Check if mouse is captured before rotating player
	if _input is InputEventMouseMotion && Input.mouse_mode == Input.MOUSE_MODE_CAPTURED:
		rotate_y(-_input.relative.x * mouseSensitivity)
		head.rotate_x(-_input.relative.y * mouseSensitivity)
		head.rotation.x = clamp(head.rotation.x,deg_to_rad(-90),deg_to_rad(90))
	#Capture mouse if window is clicked and not currently captured
	if Input.is_action_just_pressed("primary_fire") && Input.mouse_mode == Input.MOUSE_MODE_VISIBLE:
		Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	#Let mouse escape if "Escape" is pressed
	if Input.is_action_just_pressed("ui_cancel") && Input.mouse_mode == Input.MOUSE_MODE_CAPTURED:
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE

func move_player(delta):
	#Get move input
	moveInput = Input.get_vector("left","right","forward","backwards")
	var moveDirection = head.global_transform.basis *  Vector3(moveInput.x,0,moveInput.y) 
	if is_on_floor():
		moveVelocity = moveVelocity.lerp(Vector3(moveDirection.x * moveSpeed,0,moveDirection.z * moveSpeed),delta * friction)
		velocity = moveVelocity
		if Input.is_action_just_pressed("jump"):
			velocity.y += jumpHeight
	if !is_on_floor():
		velocity.y -= gravity * delta
		velocity.x += moveDirection.x * moveSpeed * delta
		velocity.z += moveDirection.z * moveSpeed * delta
	move_and_slide()
