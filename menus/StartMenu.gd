extends Control

@onready var start_button = $TitleContentContainer/ButtonsContainer/StartButton as Button

func _ready():
	start_button.grab_focus()
	if OS.get_name() == "HTML5":
		$TitleContentContainer/ButtonsContainer/QuitButton.visible = false

func _on_CreditsButton_pressed():
	get_tree().change_scene_to_file("res://menus/CreditsMenu.tscn")

func _on_StartButton_pressed():
	get_tree().change_scene_to_file("res://gameplay/Gameplay.tscn")

func _on_QuitButton_pressed():
	get_tree().quit()
