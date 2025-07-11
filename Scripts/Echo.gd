extends Area2D

@export var EchoId: String = "default_echo"
@export var echo_value: int = 1
@export var echo_type: String = "memory"

var collected = false
var time_elapsed = 0.0
var initial_position: Vector2
var is_collected = false

func _ready():
	initial_position = global_position
	collision_layer = 16
	collision_mask = 1
	
	# Connect to body entered signal
	body_entered.connect(_on_body_entered)
	
	# Add to echoes group
	add_to_group("echoes")
	
	print("Echo ready: ", EchoId)

func _process(delta):
	time_elapsed += delta
	
	# Floating animation
	if not is_collected:
		position.y = initial_position.y + sin(time_elapsed * 2.0) * 5.0

func _on_body_entered(body):
	if body.is_in_group("player") and not is_collected:
		collect_echo()

func collect_echo():
	if is_collected:
		return
		
	is_collected = true
	print("Echo collected: ", EchoId)
	
	# Add to GameManager
	var game_manager = get_node("/root/Main/GameManager")
	if game_manager:
		game_manager.add_echo(EchoId, echo_value, echo_type)
	
	# Visual feedback
	var tween = create_tween()
	tween.tween_property(self, "scale", Vector2(1.5, 1.5), 0.2)
	tween.tween_property(self, "modulate:a", 0.0, 0.3)
	tween.tween_callback(func(): visible = false)

func reset_echo():
	"""Reset the echo to be collectable again"""
	is_collected = false
	collected = false
	visible = true
	scale = Vector2(1.0, 1.0)
	modulate.a = 1.0
	global_position = initial_position
	print("Echo reset: ", EchoId) 
