extends SpookerGame

@export var cuboid:PackedScene
@export var ship:PackedScene
@export var bullet:PackedScene


func initialize_game()->void:
	for i in randi_range(4,6):
		spawn_cuboid()
	pass


func call_cuboid_destroyed(code:CodeType)->void:
	# Add to code total
	item_collected.emit(code)
	$CuboidDestroyed.pitch_scale = randf_range(0.9, 1.1)
	$CuboidDestroyed.play()
	# Spawn new cuboid
	spawn_cuboid()


func spawn_cuboid()->void:
	var new_cuboid = cuboid.instantiate()
	add_child(new_cuboid)
	new_cuboid.destroyed.connect(call_cuboid_destroyed)
	pass
