extends CharacterBody2D

@export var speed = 75.0
@export var patrol_distance = 100.0

var direction = 1
var start_position: Vector2
var animated_sprite: AnimatedSprite2D
var ground_check: RayCast2D
var wall_check: RayCast2D

func _ready():
	start_position = global_position
	animated_sprite = $AnimatedSprite2D
	ground_check = $GroundCheck
	wall_check = $WallCheck
	
	# Randomize starting direction
	direction = 1 if randf() > 0.5 else -1
	
	# Add to enemies group
	add_to_group("enemies")
	
	print("CorruptedBot ready at position: ", start_position, " moving ", "right" if direction > 0 else "left")

func _physics_process(delta):
	# Check for edges and walls before moving
	var should_turn = false
	
	# Update raycast direction based on movement
	wall_check.target_position.x = 20 * direction
	ground_check.position.x = 15 * direction
	
	# Check if we're about to fall off platform
	if not ground_check.is_colliding():
		should_turn = true
		
	# Check if we hit a wall
	if wall_check.is_colliding():
		should_turn = true
		
	# Check if we've reached patrol limits
	if abs(global_position.x - start_position.x) > patrol_distance:
		should_turn = true
	
	# Turn around if needed
	if should_turn:
		direction *= -1
		if animated_sprite:
			animated_sprite.flip_h = direction < 0
	
	# Set velocity
	velocity.x = direction * speed
	
	# Apply gravity with better floor snapping
	if not is_on_floor():
		velocity.y += get_physics_gravity() * delta
	else:
		# Snap to floor when on ground to prevent floating
		velocity.y = 0
	
	move_and_slide()
	
	# Additional floor snapping for better platform adherence
	if is_on_floor() and velocity.y >= 0:
		velocity.y = 0
	
	# Animation
	if animated_sprite:
		if abs(velocity.x) > 5:
			animated_sprite.play("walk")
		else:
			animated_sprite.play("idle")

func get_physics_gravity():
	return ProjectSettings.get_setting("physics/2d/default_gravity") 