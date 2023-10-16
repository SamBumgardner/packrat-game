class_name SelectState

extends GameplayState

func _init():
	pass

func _on_enter(gameplay : Gameplay) -> void:
	Input.set_custom_mouse_cursor(null)
	gameplay.enable_next_day()

func process_input(gameplay : Gameplay, event : InputEvent) -> Gameplay.State:
	var next_state = Gameplay.State.NO_CHANGE

	# UPGRADES
	if event.as_text() == "A" && (event as InputEventKey).is_released():
		gameplay.add_column()
	
	if event.as_text() == "S" && (event as InputEventKey).is_released():
		gameplay.add_backpack()
	
	if event.as_text() == "D" && (event as InputEventKey).is_released():
		gameplay.enter_backpack_capacity_upgrade_mode()
	
	if event.as_text() == "F" && (event as InputEventKey).is_released():
		gameplay.set_column_next_type(gameplay.columns[1], GlobalConstants.ColumnContents.REGION)

	if event.as_text() == "Z" && (event as InputEventKey).is_released():
		gameplay.enter_column_change_mode(GlobalConstants.ColumnContents.REGION)
	
	if event.as_text() == "X" && (event as InputEventKey).is_released():
		gameplay.enter_column_change_mode(GlobalConstants.ColumnContents.CUSTOMER)
	
	# BACKPACK MOVEMENT
	if event.is_action_pressed("gameplay_select"):
		gameplay._handle_backpack_selection()
	
	# TOTALLY TEMP
	if event.is_action_pressed("ui_right"):
		gameplay.shift_backpack_column(gameplay.backpacks.front(), 1)
	
	if event.is_action_pressed("ui_left"):
		gameplay.shift_backpack_column(gameplay.backpacks.front(), -1)
	
	if event.is_action_pressed("ui_up"):
		gameplay._attempt_to_reveal_next_column()

	if event.is_action_pressed("ui_down"):
		gameplay._attempt_to_hide_last_column()
	
	return next_state
