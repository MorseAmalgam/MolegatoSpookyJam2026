extends Node3D

@export var game:GameData


func _ready() -> void:
	$ScreenDisplay.mesh.material.albedo_texture = $SpookerScreenViewport.get_texture()
	$PhoneScreen.mesh.material.albedo_texture = $PhoneScreenViewport.get_texture()


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_down"):
		$SpookerScreenViewport/Screen.plug_in_game(game)
	elif event.is_action_pressed("ui_accept"):
		$SpookerScreenViewport/Screen.start_copy()
