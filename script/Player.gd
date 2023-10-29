extends CharacterBody3D

# Player nodes
@onready var standingCollisionShape = $StandingCollisionShape
@onready var crouching_collision_shape = $CrouchingCollisionShape
@onready var height_check_ray = $HeightCheckRay
@onready var head = $Head
@onready var neck = $Head/neck
@onready var eyes = $Head/neck/eyes
@onready var camera_3d = $Head/neck/eyes/Camera3D

# Speed variables
var currentSpeed : float = 5.0
@export var walkingSpeed : float = 5.0
@export var sprintingSpeed : float = 8.0
@export var crouchingSpeed : float = 3.0
@export var jumpVelocity : float = 4.5

var crouchHeight = 1.0;
var standingHeight = 1.8;
var freeLookTiltAmount: float = 4.5;

# Sensitivity variables
@export var mouseSensitivity: float = 0.5

# Input variables
var lerpSpeed: float = 10.0
var direction: Vector3 = Vector3.ZERO;

# States
var walking: bool = false;
var sprinting: bool = false;
var crouching: bool = false;
var freeLooking: bool = false;
var sliding: bool = false;

# Slidevars
var slideTimer: float = 0.0;
var slideTimerMax: float = 1.1;
var slideSpeed: float = 6;
var slideVector: Vector2 = Vector2.ZERO

# Headbobing vars
const headbobingSprintSpeed = 22.0
const headBobingWalkSpeed = 14.0
const headBobingCrouchSpeed: float = 10.0
const headBobingCrouchIntensity: float = 0.05;
const headBobingSprintingIntensity: float = 0.2;
const headBobingWalkIntensity: float = 0.1;

var headBobingCurrentIntensity: float = 0.0;
var headBobingVector: Vector2 = Vector2.ZERO;
var headBobingIndex: float = 0.0;

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

func _ready():
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED # Hides the mouse pointer

func _input(event):
	if event is InputEventMouseMotion:
		if freeLooking:
			head.rotate_y(deg_to_rad(-event.relative.x * mouseSensitivity));
			head.rotation.y = clamp(head.rotation.y, deg_to_rad(-120), deg_to_rad(120))
		else:
			rotate_y(deg_to_rad(-event.relative.x * mouseSensitivity));
		
		neck.rotate_x(deg_to_rad(-event.relative.y * mouseSensitivity))
		neck.rotation.x = clamp(neck.rotation.x, deg_to_rad(-89), deg_to_rad(89))

func _physics_process(delta):
	# handle movement states
	var input_dir: Vector2 = Input.get_vector("Left", "Right", "Forward", "Backward")
	
	# Add the gravity.
	if not is_on_floor():
		velocity.y -= gravity * delta
	
	# Crouching, stading, and running.
	if Input.is_action_pressed("Crouch"):
		currentSpeed = crouchingSpeed;
		head.position.y = lerp(head.position.y, crouchHeight, delta * lerpSpeed);
		
		standingCollisionShape.disabled = true;
		crouching_collision_shape.disabled = false;
		
		# Slide begin logic
		if sprinting && input_dir != Vector2.ZERO: 
			sliding = true; 
			slideVector = input_dir;
			slideTimer = slideTimerMax;
		
		walking = false;
		sprinting = false;
		crouching = true;
	
	elif !height_check_ray.is_colliding():
		#Standing
		head.position.y = lerp(head.position.y, standingHeight, delta * lerpSpeed)
		standingCollisionShape.disabled = false;
		crouching_collision_shape.disabled = true;
		sliding = false;
		
		#Running
		if Input.is_action_pressed("Sprint"):
			currentSpeed = sprintingSpeed;
			walking = false;
			sprinting = true;
		else:
			currentSpeed = walkingSpeed;
			walking = true; 
			sprinting = false;
			crouching = false;
	
	# Handle freelooking
	if Input.is_action_pressed("freeLook") || sliding:
		freeLooking = true;
		if sliding: 
			camera_3d.rotation.z = lerp(camera_3d.rotation.z, -deg_to_rad(6.0), delta * lerpSpeed);
		else:
			camera_3d.rotation.z = -deg_to_rad(head.rotation.y * freeLookTiltAmount)
	else: 
		freeLooking = false;
		camera_3d.rotation.z = lerp(camera_3d.rotation.z, 0.0, delta * lerpSpeed);
		head.rotation.y = lerp(head.rotation.y, 0.0, delta*lerpSpeed);
	
	# Handle Sliding
	if sliding: 
		freeLooking = true;
		slideTimer -= delta;
		if slideTimer <= 0:
			sliding = false;
			freeLooking = false;
	
	# Headbobing
	if sprinting:
		headBobingCurrentIntensity = headBobingSprintingIntensity;
		headBobingIndex += headbobingSprintSpeed * delta; 
	elif crouching:
		headBobingCurrentIntensity = headBobingCrouchIntensity;
		headBobingIndex += headBobingCrouchSpeed * delta; 
	else: 
		headBobingCurrentIntensity = headBobingWalkIntensity;
		headBobingIndex += headBobingWalkSpeed * delta; 
	
	if is_on_floor() && !sliding && input_dir != Vector2.ZERO:
		headBobingVector.y = sin(headBobingIndex);
		headBobingVector.x = sin(headBobingIndex/2)+0.5;
		
		eyes.position.y = lerp(eyes.position.y, headBobingVector.y * (headBobingCurrentIntensity/2), delta*lerpSpeed);
		eyes.position.x = lerp(eyes.position.x, headBobingVector.x * headBobingCurrentIntensity, delta*lerpSpeed);
	else: 
		eyes.position.y = lerp(eyes.position.y, 0.0, delta * lerpSpeed);
		eyes.position.x = lerp(eyes.position.x, 0.0, delta * lerpSpeed);
	
	# Handle Jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = jumpVelocity
	
	# Get the input direction and handle the movement/deceleratd ion.
	# As good practice, you should replace UI actions with custom gameplay actions.
	
	direction = lerp(direction, (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized(), delta*lerpSpeed)
	
	if sliding: 
		direction = transform.basis * Vector3(slideVector.x, 0, slideVector.y ).normalized();
		currentSpeed = ((slideSpeed + 0.1 ) * slideTimer);

	if direction:
		velocity.x = direction.x * currentSpeed
		velocity.z = direction.z * currentSpeed
	else:
		velocity.x = move_toward(velocity.x, 0, currentSpeed)
		velocity.z = move_toward(velocity.z, 0, currentSpeed)
	
	move_and_slide()
