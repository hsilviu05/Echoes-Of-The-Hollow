extends Node

var instance

var collected_echoes: Array = []
var echo_count: int = 0
var player_health: float = 100.0

# Define how many echoes each level has
var level_echo_counts = {
	"TestLevel": 4,
	"Level2": 5,
	"Level3": 7
}

# Define level progression order
var level_progression = ["TestLevel", "Level2", "Level3"]

# Track echoes per level
var level_echoes = {
	"TestLevel": ["memory_strength", "memory_agility", "memory_focus", "memory_essence"],
	"Level2": ["crystal_shard", "void_essence", "shadow_fragment", "whisper_core", "hollow_memory"],
	"Level3": ["apex_crystal", "void_nexus", "shadow_vortex", "twilight_core", "hollow_heart", "final_echo", "master_fragment"]
}

var current_level_echoes: Array = []

func _ready():
	instance = self
	print("GameManager initialized - GDScript version")

func add_echo(echo_id: String, value: int, type: String):
	if echo_id not in collected_echoes:
		collected_echoes.append(echo_id)
		echo_count += value
		current_level_echoes.append(echo_id)
		
		# Update UI
		var ui_manager = get_tree().get_first_node_in_group("ui")
		if ui_manager:
			ui_manager.update_echo_count(echo_count)
		
		print("Echo added: ", echo_id, " (Total: ", echo_count, ")")
		
		# Check if all echoes in current level are collected
		check_level_completion()

func check_level_completion():
	# Get current level from LevelManager
	var level_manager = get_node("../LevelManager")
	if not level_manager:
		return
	
	var current_level_name = get_current_level_name(level_manager.current_level)
	if not current_level_name:
		return
	
	# Check if we've collected all echoes for this level
	var required_echoes = level_echoes.get(current_level_name, [])
	var collected_count = 0
	
	for echo_id in required_echoes:
		if echo_id in current_level_echoes:
			collected_count += 1
	
	print("Level progress: ", collected_count, "/", required_echoes.size(), " echoes collected in ", current_level_name)
	
	# If all echoes collected, advance to next level
	if collected_count >= required_echoes.size():
		advance_to_next_level(current_level_name)

func get_current_level_name(level_number: int) -> String:
	match level_number:
		1:
			return "TestLevel"
		2:
			return "Level2"
		3:
			return "Level3"
		_:
			return ""

func advance_to_next_level(current_level_name: String):
	print("🎉 All echoes collected in ", current_level_name, "! Advancing to next level...")
	
	# Show celebration message
	show_level_completion_message(current_level_name)
	
	# Find current level index
	var current_index = level_progression.find(current_level_name)
	if current_index == -1:
		return
	
	# Check if there's a next level
	if current_index + 1 >= level_progression.size():
		print("🏆 Game completed! You've finished all levels!")
		
		# Make player invincible
		var player = get_node("/root/Main/Player")
		if player:
			player.enable_invincibility()
		
		await get_tree().create_timer(3.0).timeout  # Show completion message longer
		show_completion_message()
		return
	
	# Get next level
	var next_level = level_progression[current_index + 1]
	
	# Clear current level echoes
	current_level_echoes.clear()
	
	# Wait a moment for celebration, then transition
	await get_tree().create_timer(3.0).timeout
	
	# Load next level
	var level_manager = get_node("../LevelManager")
	if level_manager:
		level_manager.load_level(next_level)

func show_level_completion_message(level_name: String):
	# Show temporary celebration message
	var ui_manager = get_tree().get_first_node_in_group("ui")
	if ui_manager:
		ui_manager.show_level_completion_message(level_name)

func show_completion_message():
	# Show game completion UI
	var ui_manager = get_tree().get_first_node_in_group("ui")
	if ui_manager:
		ui_manager.show_completion_screen()

func reset_echoes():
	collected_echoes.clear()
	echo_count = 0
	current_level_echoes.clear()
	
	# Reset UI
	var ui_manager = get_tree().get_first_node_in_group("ui")
	if ui_manager:
		ui_manager.update_echo_count(0)
	
	print("All echoes reset")

func get_echo_count() -> int:
	return echo_count

func has_echo(echo_id: String) -> bool:
	return echo_id in collected_echoes

func set_player_health(health: float):
	player_health = health
	
	# Update UI
	var ui_manager = get_tree().get_first_node_in_group("ui")
	if ui_manager:
		ui_manager.update_health(health)

func get_player_health() -> float:
	return player_health 