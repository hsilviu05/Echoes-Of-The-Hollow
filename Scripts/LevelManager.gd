extends Node

var current_level = 1
var level_scenes = {
	1: "res://Scenes/TestLevel.tscn",
	2: "res://Scenes/Level2.tscn",
	3: "res://Scenes/Level3.tscn",
	"TestLevel": "res://Scenes/TestLevel.tscn",
	"Level2": "res://Scenes/Level2.tscn",
	"Level3": "res://Scenes/Level3.tscn"
}

var current_level_node: Node = null
var world_node: Node = null
var player_node: Node = null

func _ready():
	print("LevelManager ready")
	
	# Get references
	world_node = get_node("../World")
	player_node = get_node("../World/Player")
	
	# Set the initial level node (TestLevel is already loaded)
	current_level_node = world_node.get_node("TestLevel")
	
	# Connect to transition areas
	setup_transitions()

func setup_transitions():
	# Wait a frame to ensure everything is loaded
	await get_tree().process_frame
	
	# Find all transition areas and connect them
	var transitions = get_tree().get_nodes_in_group("transitions")
	for transition in transitions:
		if transition.has_signal("body_entered") and not transition.body_entered.is_connected(_on_transition_entered.bind(transition)):
			transition.body_entered.connect(_on_transition_entered.bind(transition))

func _on_transition_entered(transition_area: Area2D, body: Node):
	if body.is_in_group("player"):
		# Check which transition was triggered
		if transition_area.name.begins_with("ToLevel"):
			var level_num = transition_area.name.substr(7).to_int()
			if level_num > 0 and level_num <= 3:
				load_level(level_num)
		elif transition_area.name == "ToRustlineCity":
			load_level(2)  # Go to level 2
		elif transition_area.name == "Victory":
			show_victory_screen()

func load_level(level_identifier):
	# Handle both string and integer level identifiers
	var level_scene_path = ""
	
	if level_identifier is String:
		level_scene_path = level_scenes.get(level_identifier, "")
	elif level_identifier is int:
		level_scene_path = level_scenes.get(level_identifier, "")
	
	if level_scene_path == "":
		print("Invalid level identifier: ", level_identifier)
		return
	
	print("Loading level: ", level_identifier)
	
	# Clear current level echoes in GameManager
	var game_manager = get_node("../GameManager")
	if game_manager:
		game_manager.current_level_echoes.clear()
	
	# Remove current level
	if current_level_node:
		current_level_node.queue_free()
	
	# Wait a frame for cleanup
	await get_tree().process_frame
	
	# Load new level
	var level_scene = load(level_scene_path)
	if level_scene:
		current_level_node = level_scene.instantiate()
		world_node.add_child(current_level_node)
		
		# Update current level number
		if level_identifier is String:
			match level_identifier:
				"TestLevel":
					current_level = 1
				"Level2":
					current_level = 2
				"Level3":
					current_level = 3
		else:
			current_level = level_identifier
		
		# Wait another frame for level to be fully loaded
		await get_tree().process_frame
		
		# Position player at spawn point
		position_player_at_spawn()
		
		# Setup transitions for new level
		setup_transitions()

func position_player_at_spawn():
	# Find spawn point in current level
	var spawn_point = current_level_node.get_node_or_null("SpawnPoints/PlayerSpawn")
	if spawn_point and player_node:
		print("Found spawn point at: ", spawn_point.global_position)
		print("Player current position: ", player_node.global_position)
		print("Setting player position to spawn point...")
		
		# Set player position directly
		player_node.global_position = spawn_point.global_position
		player_node.set_spawn_position(spawn_point.global_position)
		
		# Reset player velocity
		player_node.velocity = Vector2.ZERO
		
		# Force update physics
		await get_tree().process_frame
		
		print("Player position after setting: ", player_node.global_position)
		
		# Update camera to follow player
		var camera = player_node.get_node_or_null("Camera2D")
		if camera:
			camera.force_update_scroll()
	else:
		print("Warning: Could not find spawn point or player node")
		if not spawn_point:
			print("  - Spawn point not found in: ", current_level_node.name)
		if not player_node:
			print("  - Player node not found")

func show_victory_screen():
	print("Victory achieved!")
	# Here you could show a victory screen or credits
	# For now, just go back to level 1
	load_level(1) 