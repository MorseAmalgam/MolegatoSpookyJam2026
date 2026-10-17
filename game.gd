extends Node3D

@export var game:GameData


func _ready() -> void:
	$ScreenDisplay.mesh.material.albedo_texture = $SpookerScreenViewport.get_texture()
	var phone_material = $FlipPhone.get_surface_override_material(1)
	phone_material.albedo_texture = $PhoneScreenViewport.get_texture()
	$FlipPhone.set_surface_override_material(1, phone_material)


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_end"):
		$SpookerScreenViewport/Screen.plug_in_game(game)
	elif event.is_action_pressed("ui_home"):
		$SpookerScreenViewport/Screen.start_copy()
