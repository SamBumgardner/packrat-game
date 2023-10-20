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

func process_input(gameplay : Gameplay, event : InputEvent) -> Gameplay.State:
	var next_state = Gameplay.State.NO_CHANGE
	if event.is_action_pressed("gameplay_cancel"):
		next_state = Gameplay.State.SELECT
	
	if event.is_action_pressed("gameplay_select"):
		var succeeded = gameplay.attempt_staged_upgrade()
		if succeeded:
			next_state = Gameplay.State.SELECT
	
	return next_state

func handle_upgrade_selected(gameplay : Gameplay, upgrade_type : UpgradeManager.UpgradeType) -> Gameplay.State:
	match upgrade_type:
		UpgradeManager.UpgradeType.ADD_BACKPACK:
			if gameplay.add_backpack():
				return Gameplay.State.SELECT
		UpgradeManager.UpgradeType.ADD_COLUMN:
			gameplay.add_column()
			return Gameplay.State.SELECT
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
			return Gameplay.State.SELECT
	return Gameplay.State.NO_CHANGE
