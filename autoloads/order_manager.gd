extends Node


class Order:
	var game:GameData
	var pay:int


@onready var code_types:Array[CodeType] = [
			load("res://resources/code_type/JumpscareCode.tres"),
			load("res://resources/code_type/SelfAwareCode.tres"),
			load("res://resources/code_type/WeirdAssetCode.tres")
		]

var game_list:Array
var order_queue:Array

signal new_order_received


func _ready() -> void:
	# Build out our list of available games
	var dir := DirAccess.open("res://resources/game_data")
	dir.list_dir_begin()
	for file:String in dir.get_files():
		game_list.append(load("res://resources/game_data/%s" % file))
	
	await get_tree().create_timer(1.0).timeout
	create_new_order()


func create_new_order()->void:
	# Create a new order
	var new_order = Order.new()
	
	# Create game data for the the order
	var order_game_data = game_list.pick_random().duplicate(true)
	
	# Create the desired corruptions for the order
	code_types.shuffle()
	
	var var_data_amount = order_game_data.code["Normal"].amount
	var amounts:Array[float] = [0.15, 0.20, 0.25, 0.30]
	amounts.shuffle()
	var corruption1 = code_types[0].duplicate(true)
	corruption1.amount = amounts[0] * var_data_amount
	order_game_data.add_code(corruption1)
	var corruption2 = code_types[1].duplicate(true)
	corruption2.amount = amounts[1] * var_data_amount
	order_game_data.add_code(corruption2)
	
	# Put that into the order
	new_order.game = order_game_data
	
	# Add a pay amount
	# TODO: A better way of determining pay
	new_order.pay = (amounts[0] + amounts[1]) * 100
	order_queue.append(new_order)
	new_order_received.emit(new_order)
	pass

func ship_order(sent_data:GameData)->int:
	var pay = order_queue[0].pay
	
	# TODO: Calculate corruption accuracy
	
	return pay
