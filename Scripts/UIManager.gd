extends Control

var echo_count_label: Label
var health_bar: ProgressBar
var death_screen: Control
var play_again_button: Button
var level_button: Button
var level_popup: PopupMenu

func _ready():
	# Set to process even when paused
	process_mode = Node.PROCESS_MODE_ALWAYS
	
	print("UIManager ready - GDScript version")
	
	# Add to ui group
	add_to_group("ui")
	
	# Create main UI elements
	create_hud()
	create_death_screen()
	create_level_selector()
	
	# Connect to player signals
	var player = get_tree().get_first_node_in_group("player")
	if player:
		player.player_died.connect(show_death_screen)
		player.health_changed.connect(update_health)

func create_hud():
	# Echo count label
	echo_count_label = Label.new()
	echo_count_label.text = "Echoes: 0"
	echo_count_label.position = Vector2(20, 20)
	echo_count_label.size_flags_horizontal = Control.SIZE_SHRINK_CENTER
	echo_count_label.add_theme_color_override("font_color", Color.WHITE)
	add_child(echo_count_label)
	
	# Health bar
	health_bar = ProgressBar.new()
	health_bar.max_value = 100
	health_bar.value = 100
	health_bar.position = Vector2(20, 60)
	health_bar.size = Vector2(200, 20)
	health_bar.add_theme_color_override("font_color", Color.WHITE)
	add_child(health_bar)
	
	# Health label
	var health_label = Label.new()
	health_label.text = "Health"
	health_label.position = Vector2(20, 40)
	health_label.add_theme_color_override("font_color", Color.WHITE)
	add_child(health_label)

func create_level_selector():
	# Level selector button (top right)
	level_button = Button.new()
	level_button.text = "Levels"
	level_button.position = Vector2(get_viewport().size.x - 100, 20)
	level_button.size = Vector2(80, 30)
	level_button.add_theme_color_override("font_color", Color.WHITE)
	level_button.pressed.connect(show_level_menu)
	add_child(level_button)
	
	# Main menu button (top right, below levels)
	var main_menu_button = Button.new()
	main_menu_button.text = "Main Menu"
	main_menu_button.position = Vector2(get_viewport().size.x - 100, 60)
	main_menu_button.size = Vector2(80, 30)
	main_menu_button.add_theme_color_override("font_color", Color.WHITE)
	main_menu_button.pressed.connect(_on_main_menu_pressed)
	add_child(main_menu_button)
	
	# Level popup menu
	level_popup = PopupMenu.new()
	level_popup.add_item("Level 1 - TestLevel")
	level_popup.add_item("Level 2 - DarkerLevel")
	level_popup.add_item("Level 3 - DarkestLevel")
	level_popup.id_pressed.connect(on_level_selected)
	add_child(level_popup)

func show_level_menu():
	# Position popup below the button
	level_popup.position = level_button.global_position + Vector2(0, level_button.size.y)
	level_popup.popup()

func on_level_selected(id: int):
	var level_manager = get_node("/root/Main/LevelManager")
	if level_manager:
		match id:
			0:
				level_manager.load_level("TestLevel")
			1:
				level_manager.load_level("Level2")
			2:
				level_manager.load_level("Level3")

func create_death_screen():
	# Death screen container
	death_screen = Control.new()
	death_screen.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	death_screen.visible = false
	add_child(death_screen)
	
	# Semi-transparent background
	var bg = ColorRect.new()
	bg.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	bg.color = Color(0, 0, 0, 0.7)
	death_screen.add_child(bg)
	
	# Death message
	var death_label = Label.new()
	death_label.text = "You Died!"
	death_label.set_anchors_and_offsets_preset(Control.PRESET_CENTER)
	death_label.position = Vector2(-50, -80)
	death_label.size = Vector2(100, 40)
	death_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	death_label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	death_label.add_theme_color_override("font_color", Color.RED)
	death_label.add_theme_font_size_override("font_size", 32)
	death_screen.add_child(death_label)
	
	# Play again button
	play_again_button = Button.new()
	play_again_button.text = "Play Again"
	play_again_button.set_anchors_and_offsets_preset(Control.PRESET_CENTER)
	play_again_button.position = Vector2(-60, -20)
	play_again_button.size = Vector2(120, 40)
	play_again_button.pressed.connect(restart_game)
	death_screen.add_child(play_again_button)

func show_death_screen():
	death_screen.visible = true
	get_tree().paused = true

func hide_death_screen():
	death_screen.visible = false
	get_tree().paused = false

func restart_game():
	hide_death_screen()
	
	# Reset player
	var player = get_tree().get_first_node_in_group("player")
	if player:
		player.respawn()
	
	# Reset echoes via GameManager
	var game_manager = get_node("/root/Main/GameManager")
	if game_manager:
		game_manager.reset_echoes()
	
	# Reset echoes in the scene
	var echoes = get_tree().get_nodes_in_group("echoes")
	for echo in echoes:
		echo.reset_echo()
	
	# Reset health
	var game_manager2 = get_node("/root/Main/GameManager")
	if game_manager2:
		game_manager2.set_player_health(100)

func update_echo_count(count: int):
	if echo_count_label:
		echo_count_label.text = "Echoes: " + str(count)

func update_health(value: float):
	if health_bar:
		health_bar.value = value

func _notification(what):
	if what == NOTIFICATION_RESIZED:
		# Update button positions when screen is resized
		if level_button:
			level_button.position = Vector2(get_viewport().size.x - 100, 20)
		
		# Update main menu button position
		var main_menu_button = get_node_or_null("MainMenuButton") 
		if main_menu_button:
			main_menu_button.position = Vector2(get_viewport().size.x - 100, 60)

func show_completion_screen():
	# Create completion screen
	var completion_screen = Control.new()
	completion_screen.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	add_child(completion_screen)
	
	# Semi-transparent background
	var bg = ColorRect.new()
	bg.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	bg.color = Color(0, 0, 0, 0.8)
	completion_screen.add_child(bg)
	
	# Completion message
	var completion_label = Label.new()
	completion_label.text = "🏆 GAME COMPLETED! 🏆\nYou collected all echoes!"
	completion_label.set_anchors_and_offsets_preset(Control.PRESET_CENTER)
	completion_label.position = Vector2(-150, -80)
	completion_label.size = Vector2(300, 80)
	completion_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	completion_label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	completion_label.add_theme_color_override("font_color", Color.GOLD)
	completion_label.add_theme_font_size_override("font_size", 24)
	completion_screen.add_child(completion_label)
	
	# Restart button
	var restart_button = Button.new()
	restart_button.text = "Play Again"
	restart_button.set_anchors_and_offsets_preset(Control.PRESET_CENTER)
	restart_button.position = Vector2(-60, 20)
	restart_button.size = Vector2(120, 40)
	restart_button.pressed.connect(func(): 
		completion_screen.queue_free()
		restart_from_beginning()
	)
	completion_screen.add_child(restart_button)

func restart_from_beginning():
	# Reset game to first level
	var level_manager = get_node("/root/Main/LevelManager")
	if level_manager:
		level_manager.load_level("TestLevel")
	
	# Reset game state
	restart_game()

func _on_main_menu_pressed():
	print("Returning to main menu")
	var menu_manager = get_node("/root/MenuManager")
	if menu_manager:
		menu_manager.quit_to_main_menu()
	else:
		# Fallback - directly change scene
		get_tree().change_scene_to_file("res://Scenes/StartMenu.tscn")

func show_level_completion_message(level_name: String):
	# Create temporary celebration overlay
	var celebration_overlay = Control.new()
	celebration_overlay.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	add_child(celebration_overlay)
	
	# Semi-transparent background
	var bg = ColorRect.new()
	bg.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	bg.color = Color(0, 0, 0, 0.6)
	celebration_overlay.add_child(bg)
	
	# Celebration message
	var celebration_label = Label.new()
	var next_level_text = ""
	match level_name:
		"TestLevel":
			next_level_text = "Moving to Level 2..."
		"Level2":
			next_level_text = "Moving to Level 3..."
		"Level3":
			next_level_text = "Game Completed!"
	
	celebration_label.text = "🎉 LEVEL COMPLETED! 🎉\nAll echoes collected!\n" + next_level_text
	celebration_label.set_anchors_and_offsets_preset(Control.PRESET_CENTER)
	celebration_label.position = Vector2(-150, -60)
	celebration_label.size = Vector2(300, 120)
	celebration_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	celebration_label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	celebration_label.add_theme_color_override("font_color", Color.CYAN)
	celebration_label.add_theme_font_size_override("font_size", 20)
	celebration_overlay.add_child(celebration_label)
	
	# Auto-remove after 3 seconds
	await get_tree().create_timer(3.0).timeout
	if is_instance_valid(celebration_overlay):
		celebration_overlay.queue_free() 