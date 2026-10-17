extends Node

@onready var order_scene:PackedScene = load("res://control/game_order.tscn")

func _ready() -> void:
	OrderManager.new_order_received.connect(add_order)
	

func add_order(new_order:OrderManager.Order)->void:
	printt("Bep")
	var new_order_scene = order_scene.instantiate()
	new_order_scene.get_node("JumpscareIcon/PercentLabel").text = "%02d%%" % new_order.game.code.get("Jumpscare", CodeType.new()).amount
	new_order_scene.get_node("SelfAwareIcon/PercentLabel").text = "%02d%%" % new_order.game.code.get("Self-Aware", CodeType.new()).amount
	new_order_scene.get_node("WeirdAssetsIcon/PercentLabel").text = "%02d%%" % new_order.game.code.get("Weird Assets", CodeType.new()).amount
	$ColorRect/OrderContainer.add_child(new_order_scene)
	$AudioStreamPlayer.play()
	pass
