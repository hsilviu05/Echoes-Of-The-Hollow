extends Control

@onready var play_again_button = $VBoxContainer/ButtonContainer/PlayAgainButton
@onready var main_menu_button = $VBoxContainer/ButtonContainer/MainMenuButton
@onready var echoes_label = $VBoxContainer/StatsContainer/EchoesCollected
@onready var levels_label = $VBoxContainer/StatsContainer/LevelsCompleted

var total_echoes_collected = 0
var total_levels_completed = 0

func _ready():
	# Connect buttons
	play_again_button.pressed.connect(_on_play_again_pressed)
	main_menu_button.pressed.connect(_on_main_menu_pressed)
	
	# Add entrance animation
	modulate.a = 0.0
	scale = Vector2(0.8, 0.8)
	var tween = create_tween()
	tween.parallel().tween_property(self, "modulate:a", 1.0, 1.0)
	tween.parallel().tween_property(self, "scale", Vector2(1.0, 1.0), 1.0)
	
	# Update stats if data is available
	update_stats()

func show_victory(echoes_collected: int, levels_completed: int):
	total_echoes_collected = echoes_collected
	total_levels_completed = levels_completed
	update_stats()
	
	# Show victory screen with celebration effect
	visible = true
	
	# Add some particle effects or screen flash here if desired
	print("🎉 Victory! Game completed with ", echoes_collected, " echoes collected!")

func update_stats():
	# Update the labels with current stats
	var total_possible_echoes = 16  # 4 + 5 + 7
	echoes_label.text = "Echoes Collected: " + str(total_echoes_collected) + "/" + str(total_possible_echoes)
	levels_label.text = "Levels Completed: " + str(total_levels_completed) + "/3"

func _on_play_again_pressed():
	print("Play again pressed")
	
	# Fade out animation
	var tween = create_tween()
	tween.tween_property(self, "modulate:a", 0.0, 0.5)
	await tween.finished
	
	# Get the MenuManager and restart the game
	var menu_manager = get_node("/root/MenuManager")
	if menu_manager:
		menu_manager.restart_game()
	else:
		# Fallback - directly change scene
		get_tree().change_scene_to_file("res://Scenes/Main.tscn")

func _on_main_menu_pressed():
	print("Main menu pressed")
	
	# Fade out animation
	var tween = create_tween()
	tween.tween_property(self, "modulate:a", 0.0, 0.5)
	await tween.finished
	
	# Get the MenuManager and return to main menu
	var menu_manager = get_node("/root/MenuManager")
	if menu_manager:
		menu_manager.show_main_menu()
	else:
		# Fallback - directly change scene
		get_tree().change_scene_to_file("res://Scenes/StartMenu.tscn")

func _input(event):
	# Allow Enter to play again, Escape for main menu
	if event.is_action_pressed("ui_accept"):
		_on_play_again_pressed()
	elif event.is_action_pressed("ui_cancel"):
		_on_main_menu_pressed() 