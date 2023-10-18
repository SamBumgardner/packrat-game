class_name CarryState

extends GameplayState

func _init():
	pass

func _on_enter(gameplay : Gameplay) -> void:
	Input.set_custom_mouse_cursor(null)
	gameplay.disable_next_day()

func _on_exit(gameplay : Gameplay) -> void:
	gameplay.enable_next_day()

func process_input(gameplay : Gameplay, event : InputEvent) -> Gameplay.State:
	var next_state = Gameplay.State.NO_CHANGE

	# BACKPACK MOVEMENT
	if event.is_action_pressed("gameplay_select"):
		gameplay._handle_backpack_selection()
	
	return next_state
