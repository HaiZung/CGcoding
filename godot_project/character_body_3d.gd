extends CharacterBody3D


@export var speed = 5.0
@export var JUMP_VELOCITY = 4.5
@export var camera_pan_speed = 1
const Pan_Speed_Factor = 0.0001

func _ready():
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var input_dir := Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	var direction := (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		velocity.x = direction.x * speed
		velocity.z = direction.z * speed
	else:
		velocity.x = move_toward(velocity.x, 0, speed)
		velocity.z = move_toward(velocity.z, 0, speed)
	
	if Input.mouse_mode == Input.MOUSE_MODE_CAPTURED:
		var mouse_vel = Input.get_last_mouse_velocity()
		rotation.y -= mouse_vel.x * camera_pan_speed * Pan_Speed_Factor
		var cam_rig_rot = $CameraRig.rotation.x + mouse_vel.y * camera_pan_speed * Pan_Speed_Factor
		cam_rig_rot = clamp(cam_rig_rot, -PI/2, PI/8)
		$CameraRig.rotation.x = cam_rig_rot
		
		if Input.is_action_just_pressed("ui_cancel"):
			Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	else:
		if Input.is_action_just_pressed("ui_cancel"):
			Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	move_and_slide()
