extends Node

# Scene paths
const START_MENU_SCENE = "res://Scenes/StartMenu.tscn"
const MAIN_GAME_SCENE = "res://Scenes/Main.tscn"
const VICTORY_MENU_SCENE = "res://Scenes/VictoryMenu.tscn"

# Game state
var current_scene_path = ""
var total_echoes_collected = 0
var levels_completed = 0

func _ready():
	print("MenuManager initialized")
	# Start with the main menu
	show_main_menu()

func show_main_menu():
	print("Showing main menu")
	change_scene_to(START_MENU_SCENE)
	reset_game_stats()

func start_game():
	print("Starting game from menu")
	change_scene_to(MAIN_GAME_SCENE)

func restart_game():
	print("Restarting game")
	reset_game_stats()
	change_scene_to(MAIN_GAME_SCENE)

func show_victory_screen(echoes: int, levels: int):
	print("Showing victory screen - Echoes: ", echoes, " Levels: ", levels)
	total_echoes_collected = echoes
	levels_completed = levels
	
	# Load victory menu scene
	var victory_scene = load(VICTORY_MENU_SCENE)
	var victory_instance = victory_scene.instantiate()
	
	# Add it to the current scene
	get_tree().current_scene.add_child(victory_instance)
	
	# Call the show_victory method with stats
	victory_instance.show_victory(echoes, levels)

func change_scene_to(scene_path: String):
	current_scene_path = scene_path
	
	# Use call_deferred to avoid issues with scene tree changes
	call_deferred("_deferred_scene_change", scene_path)

func _deferred_scene_change(scene_path: String):
	var error = get_tree().change_scene_to_file(scene_path)
	if error != OK:
		print("Error changing to scene: ", scene_path, " Error: ", error)
	else:
		print("Successfully changed to scene: ", scene_path)

func reset_game_stats():
	total_echoes_collected = 0
	levels_completed = 0

func is_game_completed() -> bool:
	# Check if all levels are completed (assuming 3 levels total)
	return levels_completed >= 3

func get_total_echoes() -> int:
	return total_echoes_collected

func get_completed_levels() -> int:
	return levels_completed

# Called by GameManager when game is completed
func on_game_completed(final_echo_count: int):
	print("Game completed! Final echo count: ", final_echo_count)
	levels_completed = 3  # All levels completed
	total_echoes_collected = final_echo_count
	
	# Show victory screen after a brief delay
	await get_tree().create_timer(2.0).timeout
	show_victory_screen(total_echoes_collected, levels_completed)

# Called when player wants to quit to main menu from game
func quit_to_main_menu():
	print("Quitting to main menu")
	show_main_menu() 