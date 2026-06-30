class_name Player extends CharacterBody3D

var moveInput: Vector2
var moveVelocity: Vector3
var moveSpeed: float = 8
var friction: float = 10
var jumpHeight: float = 6
var gravity: float = 12
#This is how much each ray cast in each direction is weighted in to the final gun volume/sound
#Indexes = [0]Ceiling, [1]Left, [2]Right, [3]Front, [4]Back
const weaponSoundWeights: Array[float]  = [.3,.2,.2,.15,.15]
var maxAcousticsDistance: float = 20
@export var mouseSensitivity: float = 0.005
@onready var head: Node3D = $Head
@onready var camera: Camera3D = $Head/RecoilHandler/Camera
@onready var recoilHandler: Node3D = $Head/RecoilHandler
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

func apply_recoil(recoilVert: float, recoilHorz: float, springRecoilVert:float,springRecoilHorz:float) -> void:
	#Apply recoil to player's camera
	rotate_y(deg_to_rad(recoilHorz))
	head.rotation.x += deg_to_rad(recoilVert)
	head.rotation.x = clamp(head.rotation.x,deg_to_rad(-89),deg_to_rad(89))
	#Also Apply recoil to the recoil spring
	recoilHandler.add_recoil(springRecoilVert,springRecoilHorz)

func get_sound_acoustics() -> Dictionary:
	#Grab the space state and get current basis directions
	var space_state = get_world_3d().direct_space_state
	var origin = global_position
	#[0]Front, [1]Left, [2]Right, [3]Front,[4]Back
	var curBasisDirections: Array[Vector3] = [basis.y,-basis.x,basis.x,-basis.z,basis.z]
	#Get the total amount added for the indoor sound, as well as left and right pan
	var indoor_total: float
	var front_influence: float = maxAcousticsDistance
	var left_pan: float = maxAcousticsDistance
	var right_pan: float = maxAcousticsDistance
	#Cycle through rays and get total values
	for rays in curBasisDirections.size():
		var end_point = origin + (curBasisDirections[rays] * maxAcousticsDistance)
		var query = PhysicsRayQueryParameters3D.create(origin,end_point,1)
		var result = space_state.intersect_ray(query)
		
		if result:
			var hit_dist = origin.distance_to(result.position)
			
			if rays == 1: left_pan = hit_dist
			elif rays == 2: right_pan = hit_dist
			elif rays == 3: front_influence = hit_dist
			
			var falloff = clampf(1.0 - (hit_dist / maxAcousticsDistance),0.0, 1.0)
			indoor_total += weaponSoundWeights[rays] * falloff
	
	var pan_dir = clampf((left_pan - right_pan) / maxAcousticsDistance, -1.0, 1.0)
	var pan_front_influence = front_influence / maxAcousticsDistance
	pan_dir *= pan_front_influence
	
	return {"indoor_volume": sqrt(clampf(indoor_total,0.0,1.0)),
			"outdoor_volume": sqrt(clampf(1.0 - indoor_total,0.0,1.0)),
			"pan": pan_dir
			}
