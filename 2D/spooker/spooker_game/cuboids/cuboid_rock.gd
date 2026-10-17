extends Node2D

const CODE_TYPES:Array[String] = [
			"res://resources/code_type/JumpscareCode.tres",
			"res://resources/code_type/SelfAwareCode.tres",
			"res://resources/code_type/WeirdAssetCode.tres",
		]

var type:CodeType
var spin_speed:float
var velocity:Vector2

signal destroyed

func _ready() -> void:
	# Assign type
	type = load(CODE_TYPES.pick_random()).duplicate()
	$Sprite2D.texture = type.icon
	$Sprite2D.modulate = type.color
	$Line2D.default_color = type.color
	
	# Assign value
	type.amount = randi_range(2,5)
	
	# Assign visual and collision polygons
	var polygon:Array = []
	var points = randi_range(5,9)
	for i in points:
		var circle_pos = float(i) / points * TAU
		polygon.append(Vector2(cos(circle_pos), sin(circle_pos)) * (randf_range(28,40) + (5 * type.amount)))
	$Line2D.points = polygon
	$Area2D/CollisionPolygon2D.set_deferred("polygon", polygon)
	
	# Assign position
	var rads = randf_range(0, 360)
	position = Vector2(576, 324) + Vector2(cos(rads), sin(rads)) * 700
	
	# Assign spin
	spin_speed = randf_range(-3, 3)
	# Set velocity to target somewhere near the middle of the screen
	var target_angle = randf_range(0, 360)
	var target = Vector2(576, 324) + Vector2(cos(target_angle), sin(target_angle)) * 150
	velocity = position.direction_to(target) * randi_range(30,50)
	pass

func _process(delta: float) -> void:
	$Line2D.rotate(delta * spin_speed)
	$Area2D.rotate(delta * spin_speed)
	
	position += velocity * delta
	velocity *= 0.99999999
	# Edge of screen loop-around
	if (position.x < -70):
		position.x = 1212
	elif (position.x > 1222):
		position.x = -60
	if (position.y < -70):
		position.y = 696
	elif (position.y > 706):
		position.y = -60


func _on_area_entered(area: Area2D) -> void:
	printt(area.get_parent().name)
	destroyed.emit(type)
	queue_free()
	pass # Replace with function body.
