extends Node2D

const CODE_TYPES:Array[String] = [
			"res://resources/code_type/JumpscareCode.tres",
			"res://resources/code_type/SelfAwareCode.tres",
			"res://resources/code_type/WeirdAssetCode.tres",
		]

var type:CodeType
var spin_speed:float
var velocity:Vector2

func _ready() -> void:
	# Assign type
	type = load(CODE_TYPES.pick_random()).duplicate()
	$Sprite2D.texture = type.icon
	$Polygon2D.color = type.color
	
	# Assign visual and collision polygons
	var polygon:Array = []
	var points = randi_range(5,9)
	for i in points:
		var circle_pos = float(i) / points * TAU
		polygon.append(Vector2(cos(circle_pos), sin(circle_pos)) * randf_range(28,40))
	$Polygon2D.polygon = polygon
	$Area2D/CollisionPolygon2D.polygon = polygon
	
	# Assign velocity and spin
	spin_speed = randf_range(-4, 4)
	var vel = randf_range(0, 360)
	velocity = Vector2(cos(vel), sin(vel)) * 15
	pass

func _process(delta: float) -> void:
	$Polygon2D.rotate(delta * spin_speed)
	$Area2D.rotate(delta * spin_speed)
	
	position += velocity * delta
