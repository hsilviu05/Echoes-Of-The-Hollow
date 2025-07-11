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
		# Update level button position when screen is resized
		if level_button:
			level_button.position = Vector2(get_viewport().size.x - 100, 20) 