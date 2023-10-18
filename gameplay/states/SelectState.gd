class_name SelectState

extends GameplayState

func _init():
	pass

func _on_enter(gameplay : Gameplay) -> void:
	Input.set_custom_mouse_cursor(null)
	gameplay.enable_next_day()

func process_input(gameplay : Gameplay, event : InputEvent) -> Gameplay.State:
	var next_state = Gameplay.State.NO_CHANGE
	# BACKPACK MOVEMENT
	if event.is_action_pressed("gameplay_select"):
		gameplay._handle_backpack_selection()
	
	return next_state

func handle_upgrade_selected(gameplay : Gameplay, upgrade_type : UpgradeManager.UpgradeType) -> Gameplay.State:
	match upgrade_type:
		UpgradeManager.UpgradeType.ADD_BACKPACK:
			gameplay.add_backpack()
		UpgradeManager.UpgradeType.ADD_COLUMN:
			gameplay.add_column()
		UpgradeManager.UpgradeType.INCREASE_CAPACITY:
			gameplay.enter_backpack_capacity_upgrade_mode()
		UpgradeManager.UpgradeType.CHANGE_COLUMN_REGION:
			gameplay.enter_column_change_mode(GlobalConstants.ColumnContents.REGION)
		UpgradeManager.UpgradeType.CHANGE_COLUMN_CUSTOMER:
			gameplay.enter_column_change_mode(GlobalConstants.ColumnContents.CUSTOMER)
		UpgradeManager.UpgradeType.EMPTY_COLUMN:
			gameplay.enter_column_change_mode(GlobalConstants.ColumnContents.NONE)
		UpgradeManager.UpgradeType.REMODEL:
			gameplay.start_remodel()
	return Gameplay.State.NO_CHANGE
