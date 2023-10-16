class_name UpgradeState

extends GameplayState

const HAMMER_MOUSE_ICON : Texture = preload("res://art/hammer_icon.png")

func _init():
	pass

func _on_enter(gameplay : Gameplay) -> void:
	Input.set_custom_mouse_cursor(HAMMER_MOUSE_ICON)
	gameplay.disable_next_day()

func _on_exit(gameplay : Gameplay) -> void:
	gameplay.enable_next_day()

func process_input(_gameplay : Gameplay, event : InputEvent) -> Gameplay.State:
	var next_state = Gameplay.State.NO_CHANGE
	if event.is_action_pressed("gameplay_cancel"):
		next_state = Gameplay.State.SELECT
	
	return next_state
