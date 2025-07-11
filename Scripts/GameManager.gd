extends Node

var instance

var collected_echoes: Array = []
var echo_count: int = 0
var player_health: float = 100.0

func _ready():
	instance = self
	print("GameManager initialized - GDScript version")

func add_echo(echo_id: String, value: int, type: String):
	if echo_id not in collected_echoes:
		collected_echoes.append(echo_id)
		echo_count += value
		
		# Update UI
		var ui_manager = get_tree().get_first_node_in_group("ui")
		if ui_manager:
			ui_manager.update_echo_count(echo_count)
		
		print("Echo added: ", echo_id, " (Total: ", echo_count, ")")

func reset_echoes():
	collected_echoes.clear()
	echo_count = 0
	
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