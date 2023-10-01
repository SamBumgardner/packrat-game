# Scene to render for the game credits.
extends Control

func _ready():
	if $BackToStartMenuButton/ExitButton:
		$BackToStartMenuButton/ExitButton.grab_focus()
