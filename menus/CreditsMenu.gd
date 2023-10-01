extends Control

func _ready():
	if $BackToStartMenuButton/ExitButton:
		$BackToStartMenuButton/ExitButton.grab_focus()
