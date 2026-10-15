extends SpookerGame


func _on_timer_timeout() -> void:
	var code_types:Array[CodeType] = [
			load("res://resources/code_type/JumpscareCode.tres"),
			load("res://resources/code_type/SelfAwareCode.tres"),
			load("res://resources/code_type/WeirdAssetCode.tres"),
		]
	var new_code = code_types.pick_random().duplicate()
	new_code.amount = randi_range(1,10)
	item_collected.emit(new_code)
