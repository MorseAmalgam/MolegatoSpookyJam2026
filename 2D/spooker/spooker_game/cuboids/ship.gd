extends Node2D

@export var bullet:PackedScene

var velocity:float
var max_velocity:float = 20
var rotation_speed:float = 0.1

func _ready() -> void:
	var target_angle = randf_range(0, 360)
	position = Vector2(576, 324) + Vector2(cos(target_angle), sin(target_angle)) * 150
	
	rotate(randf_range(0, TAU))
	#velocity = max_velocity


func _process(delta: float) -> void:
	if Input.is_action_pressed("ui_up"):
		velocity = max(velocity + 1, max_velocity)
		pass
	elif Input.is_action_pressed("ui_left"):
		rotate(-rotation_speed)
		pass
	elif Input.is_action_pressed("ui_right"):
		rotate(rotation_speed)
		pass
	elif Input.is_action_just_pressed("ui_down"):
		$LaserSound.play()
		var new_bullet = bullet.instantiate()
		get_parent().add_child(new_bullet)
		new_bullet.position = position
		new_bullet.rotation = rotation
		pass
	
	
	position += Vector2.UP.rotated(rotation) * velocity * delta
	velocity -= delta
