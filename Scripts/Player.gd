extends CharacterBody2D

@export var speed = 300.0
@export var jump_velocity = -450.0
@export var max_health = 100.0

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var animated_sprite: AnimatedSprite2D
var spawn_position = Vector2(300, 380)
var is_dead = false
var current_health = 100.0
var damage_cooldown = 0.0
var damage_cooldown_time = 1.0
var spawn_protection = 0.0
var spawn_protection_time = 2.0
var is_invincible = false

signal player_died
signal health_changed(new_health)

func _ready():
	animated_sprite = $AnimatedSprite2D
	spawn_position = global_position
	current_health = max_health
	spawn_protection = spawn_protection_time
	print("Player ready at position: ", global_position)

func _physics_process(delta):
	if is_dead:
		return
		
	# Update timers
	if damage_cooldown > 0:
		damage_cooldown -= delta
		
	if spawn_protection > 0:
		spawn_protection -= delta
		# Keep player fully visible during spawn protection
		if animated_sprite:
			animated_sprite.modulate.a = 1.0
	else:
		if animated_sprite:
			animated_sprite.modulate.a = 1.0
		
	# Check if player fell too far (death zone)
	if global_position.y > 550:
		die()
		return
	
	# Check for enemy collisions (only if not in spawn protection and not invincible)
	if spawn_protection <= 0 and not is_invincible:
		for i in get_slide_collision_count():
			var collision = get_slide_collision(i)
			var collider = collision.get_collider()
			if collider and collider.is_in_group("enemies") and damage_cooldown <= 0:
				print("Hit by enemy: ", collider.name)
				take_damage(50.0)
				return
	
	# Add gravity
	if not is_on_floor():
		velocity.y += gravity * delta

	# Handle jump
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = jump_velocity

	# Get input direction
	var direction = Input.get_vector("move_left", "move_right", "move_up", "move_down")
	if direction != Vector2.ZERO:
		velocity.x = direction.x * speed
		
		# Flip sprite based on movement direction
		if animated_sprite:
			animated_sprite.flip_h = direction.x < 0
	else:
		velocity.x = move_toward(velocity.x, 0, speed)

	move_and_slide()
	
	# Simple animation logic
	if animated_sprite:
		if not is_on_floor():
			animated_sprite.play("jump")
		elif abs(velocity.x) > 5:
			animated_sprite.play("run")
		else:
			animated_sprite.play("idle")

func take_damage(damage: float):
	if is_dead or damage_cooldown > 0 or spawn_protection > 0 or is_invincible:
		return
	
	current_health -= damage
	damage_cooldown = damage_cooldown_time
	
	print("Player took ", damage, " damage. Health: ", current_health)
	
	# Update UI
	health_changed.emit(current_health)
	var game_manager = get_node("/root/Main/GameManager")
	if game_manager:
		game_manager.set_player_health(current_health)
	
	# Visual feedback - flash red
	if animated_sprite:
		var tween = create_tween()
		tween.tween_property(animated_sprite, "modulate", Color.RED, 0.1)
		tween.tween_property(animated_sprite, "modulate", Color.WHITE, 0.1)
	
	if current_health <= 0:
		print("Player health depleted!")
		die()

func die():
	if is_dead:
		return
	
	is_dead = true
	velocity = Vector2.ZERO
	print("Player died!")
	
	# Emit death signal
	player_died.emit()
	
	# Start respawn timer
	await get_tree().create_timer(1.0).timeout
	respawn()

func respawn():
	is_dead = false
	global_position = spawn_position
	velocity = Vector2.ZERO
	current_health = max_health
	damage_cooldown = 0.0
	spawn_protection = spawn_protection_time
	
	# Update UI
	health_changed.emit(current_health)
	var game_manager = get_node("/root/Main/GameManager")
	if game_manager:
		game_manager.set_player_health(current_health)
	
	print("Player respawned at: ", global_position)

func set_spawn_position(pos: Vector2):
	print("Setting spawn position to: ", pos)
	print("Player position before: ", global_position)
	spawn_position = pos
	global_position = pos  # Actually move the player to the new position
	velocity = Vector2.ZERO  # Reset velocity
	spawn_protection = spawn_protection_time  # Reset spawn protection when setting new spawn
	
	# Ensure player is fully visible when changing levels
	if animated_sprite:
		animated_sprite.modulate.a = 1.0
	
	print("Player position after: ", global_position) 

func enable_invincibility():
	is_invincible = true
	print("🛡️ Player is now invincible!")
	
	# Visual feedback - golden glow
	if animated_sprite:
		var tween = create_tween()
		tween.set_loops()
		tween.tween_property(animated_sprite, "modulate", Color.GOLD, 0.5)
		tween.tween_property(animated_sprite, "modulate", Color.WHITE, 0.5)
