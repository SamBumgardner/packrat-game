# Scene to render menu options when the game is started.
class_name StartMenu

extends Control

@onready var quit_button = (
	$TitleContentMarginContainer/Padding8px/TitleContentRows/ButtonRows/QuitButton
	as Button
)
@onready var start_button = (
	$TitleContentMarginContainer/Padding8px/TitleContentRows/ButtonRows/StartButton
	as Button
)

static var first_load = true
var visibility_tween : Tween

func _ready():
	if !first_load:
		force_title_appear()
	else:
		_initial_scroll_background()
	first_load = false
	if OS.get_name() == "HTML5":
		quit_button.visible = false

func _on_CreditsButton_pressed() -> void:
	get_tree().change_scene_to_file("res://menus/CreditsMenu.tscn")

func _on_StartButton_pressed() -> void:
	get_tree().change_scene_to_file("res://gameplay/Gameplay.tscn")

func _on_QuitButton_pressed() -> void:
	get_tree().quit()

func _input(event):
	if event.is_action_pressed("gameplay_select"):
		skip_fade_in()

func _initial_scroll_background():
	$Background.position = $Background.position + Vector2(0, -200)
	var background_tween = $Background.create_tween().set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_CUBIC)
	background_tween.tween_property($Background, "position", $Background.position + Vector2(0, 200), 4)

func _on_title_fade_in_delay_timeout():
	$TitleContentMarginContainer.modulate = Color.TRANSPARENT
	$TitleContentMarginContainer.position = $TitleContentMarginContainer.position + Vector2(0, 20)
	$TitleContentMarginContainer.show()
	visibility_tween = $TitleContentMarginContainer.create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_CUBIC)
	visibility_tween.tween_property($TitleContentMarginContainer, "modulate", Color.WHITE, 2)
	visibility_tween.parallel().tween_property($TitleContentMarginContainer, "position", $TitleContentMarginContainer.position - Vector2(0, 20), 2)
	visibility_tween.finished.connect(start_button.grab_focus)

func skip_fade_in():
	if visibility_tween != null and visibility_tween.is_running():
		visibility_tween.custom_step(2)
	elif !$TitleFadeInDelay.is_stopped():
		force_title_appear()

func force_title_appear():
	$TitleFadeInDelay.stop()
	$TitleContentMarginContainer.show()
	start_button.grab_focus()
