extends Node2D

enum LoaderState {
	Idle,
	Waiting,
	Transferring,
	Complete
}

@export var code_integrity_bar:Control
@export var progress_bar:ProgressBar
@export var status_text:Label


var data_current:float = 0
var game_in_loader:GameData
var game_being_copied:GameData
var loader_state:LoaderState = LoaderState.Idle
var minigame:SpookerGame
var transfer_rate:float = 8.5

signal copy_completed

func _process(delta: float) -> void:
	if loader_state != LoaderState.Transferring:
		return
		
	data_current += transfer_rate * delta
	if (data_current < game_being_copied.get_total_data()):
		progress_bar.value = data_current
		status_text.text = "Transferring... %d/%dkb" % [data_current, game_being_copied.get_total_data()]
	else:
		loader_state = LoaderState.Complete
		progress_bar.value = game_being_copied.get_total_data()
		status_text.text = "DATA TRANSFERRED"
		progress_bar.visible = false
		$GameHolder.remove_child(minigame)
		copy_completed.emit(game_being_copied)


func add_code(new_code:CodeType)->void:
	game_being_copied.replace_code(new_code)
	update_code_integrity_bar()
	progress_bar.max_value = game_being_copied.get_total_data()



func plug_in_game(game:GameData)->void:
	#if (!ResourceLoader.exists("res://2D/spooker/spooker_game/%s.tscn" % game.name.to_lower())):
	#	status_text.text = "ERROR LOADING GAME ROM"
	#	return
	
	game_in_loader = game
	data_current = 0
	progress_bar.max_value = game_in_loader.get_total_data()
	if (ResourceLoader.exists("res://2D/spooker/spooker_game/%s.tscn" % game.name.to_lower())):
		minigame = load("res://2D/spooker/spooker_game/%s.tscn" % game.name.to_lower()).instantiate()
	else:
		minigame = load("res://2D/spooker/spooker_game/cuboids.tscn").instantiate()
	loader_state = LoaderState.Waiting
	status_text.text = "LOADED: %s" % game_in_loader.name


func remove_game()->void:
	game_in_loader = null
	data_current = 0
	loader_state = LoaderState.Idle
	status_text.text = "AWAITING GAME CARTRIDGE"


func start_copy()->void:
	game_being_copied = game_in_loader.duplicate(true)
	loader_state = LoaderState.Transferring
	progress_bar.visible = true
	# Load game to screen
	$GameHolder.add_child(minigame)
	minigame.initialize_game()
	if !minigame.item_collected.is_connected(add_code):
		minigame.item_collected.connect(add_code)


func update_code_integrity_bar()->void:
	var bar_width = code_integrity_bar.size.x - 16
	var x_offset = 8
	for node in code_integrity_bar.get_children():
		node.queue_free()
	for codetype in game_being_copied.code:
		# Code percentage breakdown
		var code_percent = game_being_copied.code[codetype].amount / float(game_being_copied.get_total_data())
		# Percentage Bar
		var code_width = bar_width * code_percent
		var color_rect = ColorRect.new()
		color_rect.color = game_being_copied.code[codetype].color
		code_integrity_bar.add_child(color_rect)
		color_rect.position = Vector2(x_offset, 8)
		color_rect.size = Vector2(code_width, 32)
		# Percentage label
		var code_percentage_label = $CodePercentageTemplate.duplicate()
		code_percentage_label.modulate = game_being_copied.code[codetype].color
		code_percentage_label.text = "%d%%" % (code_percent * 100.0)
		code_percentage_label.visible = true
		code_percentage_label.position.x = x_offset - 20 + (code_width / 2)
		code_percentage_label.position.y = 57
		code_integrity_bar.add_child(code_percentage_label)
		x_offset += code_width
	pass
