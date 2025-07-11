extends Control

@onready var play_button = $VBoxContainer/PlayButton

func _ready():
	# Connect the play button
	play_button.pressed.connect(_on_play_button_pressed)
	
	# Add some nice entrance animation
	modulate.a = 0.0
	var tween = create_tween()
	tween.tween_property(self, "modulate:a", 1.0, 1.0)

func _on_play_button_pressed():
	print("Starting game...")
	
	# Fade out animation
	var tween = create_tween()
	tween.tween_property(self, "modulate:a", 0.0, 0.5)
	await tween.finished
	
	# Get the MenuManager and start the game
	var menu_manager = get_node("/root/MenuManager")
	if menu_manager:
		menu_manager.start_game()
	else:
		# Fallback - directly change scene
		get_tree().change_scene_to_file("res://Scenes/Main.tscn")

func _input(event):
	# Allow Enter or Space to start the game
	if event.is_action_pressed("ui_accept") or event.is_action_pressed("jump"):
		_on_play_button_pressed() 