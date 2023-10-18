# Scene to render menu options when the game is started.
extends Control

@onready var quit_button = (
	$TitleContentMarginContainer/Padding8px/TitleContentRows/ButtonRows/QuitButton
	as Button
)
@onready var start_button = (
	$TitleContentMarginContainer/Padding8px/TitleContentRows/ButtonRows/StartButton
	as Button
)

func _ready():
	start_button.grab_focus()
	if OS.get_name() == "HTML5":
		quit_button.visible = false

func _on_CreditsButton_pressed() -> void:
	get_tree().change_scene_to_file("res://menus/CreditsMenu.tscn")

func _on_StartButton_pressed() -> void:
	get_tree().change_scene_to_file("res://gameplay/Gameplay.tscn")

func _on_QuitButton_pressed() -> void:
	get_tree().quit()


func _on_title_fade_in_delay_timeout():
	$TitleContentMarginContainer.modulate = Color.TRANSPARENT
	$TitleContentMarginContainer.position = $TitleContentMarginContainer.position + Vector2(0, 20)
	$TitleContentMarginContainer.show()
	var visibility_tween = $TitleContentMarginContainer.create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_CUBIC)
	visibility_tween.tween_property($TitleContentMarginContainer, "modulate", Color.WHITE, 2)
	visibility_tween.parallel().tween_property($TitleContentMarginContainer, "position", $TitleContentMarginContainer.position - Vector2(0, 20), 2)

