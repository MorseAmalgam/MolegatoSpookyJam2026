extends Node2D

func _process(delta: float) -> void:
	position += Vector2.UP.rotated(rotation) * 300 * delta


func _on_area_entered(_area: Area2D) -> void:
	queue_free()
	pass # Replace with function body.
