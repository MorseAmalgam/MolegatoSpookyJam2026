class_name GameData
extends Resource

@export var name:String
@export var code:Dictionary[String,CodeType]

func get_total_data()->int:
	var total = 0
	for i in code:
		total += code[i].amount
	return total

func add_code(new_code:CodeType)->void:
	printt("Adding %dkb of %s code" % [new_code.amount, new_code.name] )
	if code.has(new_code.name):
		printt("Current amount: %skb" % code[new_code.name].amount)
		code[new_code.name].amount = code[new_code.name].amount + new_code.amount
	else:
		printt("Code type doesn't current exist, adding new type to dictionary")
		code[new_code.name] = new_code
	
	printt("%dkb of %s" % [code[new_code.name].amount, code[new_code.name].name])

func replace_code(new_code:CodeType)->bool:
	if (code["Normal"].amount < new_code.amount):
		printt("OUT OF EDITABLE CODE")
		return false
	
	code["Normal"].amount -= new_code.amount
	add_code(new_code)
	return true
