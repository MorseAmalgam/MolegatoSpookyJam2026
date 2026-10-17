extends Node

@onready var order_scene:PackedScene = load("res://control/game_order.tscn")

func _ready() -> void:
	OrderManager.new_order_received.connect(add_order)
	

func add_order(new_order:OrderManager.Order)->void:
	var new_order_scene = order_scene.instantiate()
	new_order_scene.get_node("JumpscareIcon/PercentLabel").text = "%02d%%" % (new_order.game.code.get("Jumpscare", CodeType.new()).amount / float(new_order.game.get_total_data()) * 100)
	new_order_scene.get_node("SelfAwareIcon/PercentLabel").text = "%02d%%" % (new_order.game.code.get("Self-Aware", CodeType.new()).amount / float(new_order.game.get_total_data()) * 100)
	new_order_scene.get_node("WeirdAssetsIcon/PercentLabel").text = "%02d%%" % (new_order.game.code.get("Weird Assets", CodeType.new()).amount / float(new_order.game.get_total_data()) * 100)
	new_order_scene.get_node("GameNameLabel").text = new_order.game.name
	new_order_scene.get_node("PayLabel").text = "$%02d" % new_order.pay
	if $ColorRect/OrderContainer.get_child_count() % 2 == 0:
		new_order_scene.get_node("BGRect").color.a = 0.3
	else:
		new_order_scene.get_node("BGRect").color.a = 0.1
	$ColorRect/OrderContainer.add_child(new_order_scene)
	$AudioStreamPlayer.play()
	pass
