# Scene to render when the game is finished.
class_name Gameplay

extends Control

const gameplay_column_scene : PackedScene = preload("res://gameplay/column/GameplayColumn.tscn")
const backpack_scene : PackedScene = preload("res://gameplay/backpack/Backpack.tscn")
const NO_COLUMN : int = -1
const starting_state = State.SELECT

enum State {
	NO_CHANGE = -1,
	SELECT,
	CARRY,
	WAIT,
	UPGRADE
}

@export var starting_column_count : int = 2
@export var starting_column_types : Array[GlobalConstants.ColumnContents] = [
	GlobalConstants.ColumnContents.REGION,
	GlobalConstants.ColumnContents.CUSTOMER
]
@export var starting_backpack_count : int = 1

@onready var database = get_node("/root/Database")

@export var current_state : State

var states : Array[GameplayState] = [
	SelectState.new(),
	CarryState.new(),
	WaitState.new(),
	UpgradeState.new()
]

@onready var BGM_default_volume : float = $BGM.volume_db

var staged_upgrade : Callable

var mock_goal : int = 4

var hovered_column_index : int = NO_COLUMN
var hovered_backpack : Backpack = null
var selected_backpack : Backpack = null
var selected_backpack_home_column : GameplayColumn = null

var backpacks : Array[Backpack] = []
var columns : Array[GameplayColumn] = []

var _columns_executing_day : int = 0
var _columns_finished_day : int = 0

var fanfare_tween : Tween

##################
# INITIALIZATION #
##################
func _ready():
	for button in get_tree().get_nodes_in_group("button"):
		button.button_down.connect($ButtonSFX.play)
	
	_fade_in_setup()
	database.reset_values()
	Backpack.used_graphic_indexes = []
	_set_mock_goal()
	for i in range(starting_column_count):
		_init_column(gameplay_column_scene.instantiate(), starting_column_types[i])
	for i in range(starting_backpack_count):
		_init_backpack(backpack_scene.instantiate() as Backpack)
	Database.active_region_columns = get_typed_column_count(GlobalConstants.ColumnContents.REGION)
	Database.active_customer_columns = get_typed_column_count(GlobalConstants.ColumnContents.CUSTOMER)
	Database.set_silver_coin_count(Database.silver_coin_count)
	
	$LevelUpFanfare.finished.connect(trigger_end_game_transition)

func _init_backpack(backpack : Backpack) -> void:
	$OriginOfNewBackpacks.add_child(backpack)
	backpacks.append(backpack)
	backpack.backpack_entered.connect(_on_backpack_entered)
	backpack.backpack_exited.connect(_on_backpack_exited)
	for column in columns:
		if column.current_backpack == null:
			column.set_backpack(backpack)
			break
	
func _init_column(column : GameplayColumn, column_type : GlobalConstants.ColumnContents) -> void:
	column.column_index = columns.size()
	column.start_column_type = column_type
	columns.append(column)
	if column.current_backpack != null:
		column.set_backpack(column.current_backpack)
		column.current_backpack.visible = true
	column.column_entered.connect(_on_column_entered)
	column.column_exited.connect(_on_column_exited)
	column.ready_for_next_day.connect(_on_column_ready_for_next_day)
	$Columns.add_child(column)

# handles backpack positioning after initial load + after new columns added
func _on_columns_sort_children() -> void:
	for column in columns:
		if column.current_backpack != null:
			column.snap_backpack_to_anchor()

func _fade_in_setup():
	$FadeInTimer.start()
	$Columns.hide()

func _on_fade_in_timer_timeout():
	$Columns.modulate = Color.TRANSPARENT
	$Columns.show()
	var fade_in_tween = create_tween().set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_LINEAR)
	fade_in_tween.tween_property($Background, "modulate", Color(0.431, 0.431, 0.431), 2)
	fade_in_tween.parallel().tween_property($Columns, "modulate", Color.WHITE, 1)


##################
# STATE HANDLING #
##################
func _input(event):
	set_current_state(states[current_state].process_input(self, event))

func set_current_state(new_state : State) -> void:
	if new_state != State.NO_CHANGE:
		states[current_state]._on_exit(self)
		current_state = new_state
		states[current_state]._on_enter(self)

func _on_upgrade_selected(upgrade_type : UpgradeManager.UpgradeType):
	set_current_state(states[current_state].handle_upgrade_selected(self, upgrade_type))

#####################
# NEXT DAY HANDLING #
#####################
func enable_next_day() -> void:
	$NextDay/NextDayButton.disabled = false

func disable_next_day() -> void:
	$NextDay/NextDayButton.disabled = true

func _increment_number_of_days() -> void:
	database.increment_day_count()

func _on_next_day_button_pressed() -> void:
	set_current_state(State.WAIT)
	_columns_executing_day = columns.size()
	for column in columns:
		column.next_day()
	_increment_number_of_days()

func _on_column_ready_for_next_day() -> void:
	_columns_finished_day += 1
	if _columns_finished_day == _columns_executing_day:
		set_current_state(State.SELECT)
		_columns_finished_day = 0
		_columns_executing_day = 0

func _on_timer_timeout() -> void:
	$MockExplanation/Title.visible = false

func _set_mock_goal() -> void:
	$MockExplanation/Explanation.text = (
		"Reach Shop Level " +
		str(mock_goal) +
		" to win!"
	)

#############################
# BACKPACK CONTROL HANDLING #
#############################
func _handle_backpack_selection() -> void:
	if selected_backpack == null:
		if hovered_backpack != null:
			set_current_state(State.CARRY)
			_select_backpack(hovered_backpack)
	else:
		set_current_state(State.SELECT)
		_release_backpack()

func _on_column_entered(column_index) -> void:
	hovered_column_index = column_index

func _on_column_exited(column_index) -> void:
	if hovered_column_index == column_index:
		hovered_column_index = NO_COLUMN

func _on_backpack_entered(backpack : Backpack) -> void:
	hovered_backpack = backpack

func _on_backpack_exited(backpack : Backpack) -> void:
	if hovered_backpack == backpack:
		hovered_backpack = null

func _release_backpack() -> void:
	selected_backpack.stop_deselect_shrink_backpack()
	selected_backpack = null
	var target_column : GameplayColumn
	if hovered_column_index != NO_COLUMN:
		target_column = columns[hovered_column_index]
	else:
		target_column = selected_backpack_home_column
	swap_column_backpacks(selected_backpack_home_column, target_column)

func _select_backpack(backpack : Backpack) -> void:
	selected_backpack = backpack
	selected_backpack.select_and_enlarge_backpack()
	for column in columns:
		if column.current_backpack == selected_backpack:
			selected_backpack_home_column = column

func swap_column_backpacks(column1 : GameplayColumn, 
		column2 : GameplayColumn) -> void:
	var swap : Backpack = column1.current_backpack
	column1.set_backpack(column2.current_backpack)
	column2.set_backpack(swap)

############
# UPGRADES #
############
func attempt_staged_upgrade() -> bool:
	var hovered_column : GameplayColumn = null
	if hovered_column_index != NO_COLUMN:
		hovered_column = columns[hovered_column_index] 
	
	var succeeded : bool = staged_upgrade.call(hovered_backpack, hovered_column)
	if succeeded:
		pass # want to trigger some feedback that the upgrade attempt succeeded
	else:
		pass # want to trigger some feedback that upgrade attempt failed.
	
	return succeeded

func add_column() -> void:
	_init_column(gameplay_column_scene.instantiate(), GlobalConstants.ColumnContents.NONE)
	upgrade_completed(UpgradeManager.UpgradeType.ADD_COLUMN)

func add_backpack() -> bool:
	if columns.reduce(func(accum, col): return accum + int(col.current_backpack == null), 0) > 0:
		_init_backpack(backpack_scene.instantiate())
		upgrade_completed(UpgradeManager.UpgradeType.ADD_BACKPACK)
		return true
	return false

func upgrade_increase_backpack_capacity(
		backpack : Backpack, 
		_column : GameplayColumn,
		change_by : int = 2
	) -> bool:
	var succeeded = false
	if backpack != null:
		backpack.change_capacity(backpack.get_max_capacity() + change_by)
		upgrade_completed(UpgradeManager.UpgradeType.INCREASE_CAPACITY)
		succeeded = true
	return succeeded

func upgrade_set_column_next_type(
		_backpack : Backpack, 
		column : GameplayColumn, 
		type : GlobalConstants.ColumnContents
	) -> bool:
	if column != null && column.column_type != type:
		var succeeded : bool = column.attempt_construction(type)
		if succeeded:
			var upgrade_type : UpgradeManager.UpgradeType
			match type:
				GlobalConstants.ColumnContents.CUSTOMER:
					upgrade_type = UpgradeManager.UpgradeType.CHANGE_COLUMN_CUSTOMER
				GlobalConstants.ColumnContents.REGION:
					upgrade_type = UpgradeManager.UpgradeType.CHANGE_COLUMN_REGION
				GlobalConstants.ColumnContents.NONE:
					upgrade_type = UpgradeManager.UpgradeType.EMPTY_COLUMN
			upgrade_completed(upgrade_type)
		return succeeded
	else:
		return false

func enter_backpack_capacity_upgrade_mode() -> void:
	set_current_state(State.UPGRADE)
	staged_upgrade = upgrade_increase_backpack_capacity

func enter_column_change_mode(new_type : GlobalConstants.ColumnContents) -> void:
	set_current_state(State.UPGRADE)
	staged_upgrade = upgrade_set_column_next_type.bind(new_type)

func start_remodel() -> bool:
	$BGM.volume_db = BGM_default_volume - 30
	$LevelUpFanfare.volume_db = -10
	$LevelUpParticles.restart()
	$LevelUpFanfare.play()
	upgrade_completed(UpgradeManager.UpgradeType.REMODEL)
	
	if fanfare_tween != null:
		fanfare_tween.stop()
	fanfare_tween = create_tween()
	fanfare_tween.set_ease(Tween.EASE_IN)
	fanfare_tween.tween_property($LevelUpFanfare, "volume_db", 0, 1)
	fanfare_tween.parallel().tween_property($BGM, "volume_db", BGM_default_volume, 8)
	
	return true

func trigger_end_game_transition() -> void:
	if Database.shop_level >= mock_goal:
		set_current_state(State.SELECT)
		get_tree().change_scene_to_file(
			"res://gameplay/game_finished/GameFinished.tscn"
		)

# Count all active & under-construction columns for the specified Contents Type
func get_typed_column_count(type_to_count : GlobalConstants.ColumnContents) -> int:
	var column_count : int = 0
	for column in columns:
		if column._under_construction and column._constructing_column_type == type_to_count:
				column_count += 1
		elif !column._under_construction and column.column_type == type_to_count:
				column_count += 1
	return column_count

func upgrade_completed(upgrade_type : UpgradeManager.UpgradeType) -> void:
	var cost : int = UpgradeManager.get_cost(upgrade_type)
	match upgrade_type:
		UpgradeManager.UpgradeType.ADD_BACKPACK:
			Database.backpacks_purchased += 1
		UpgradeManager.UpgradeType.ADD_COLUMN:
			Database.columns_purchased += 1
		UpgradeManager.UpgradeType.INCREASE_CAPACITY:
			Database.capacity_increases_purchased += 1
		UpgradeManager.UpgradeType.REMODEL:
			Database.set_shop_level(Database.shop_level + 1)
		UpgradeManager.UpgradeType.EMPTY_COLUMN:
			var remaining_regions = get_typed_column_count(GlobalConstants.ColumnContents.REGION)
			var remaining_customers = get_typed_column_count(GlobalConstants.ColumnContents.CUSTOMER)
			var deleted_last_region = remaining_regions == 0 and Database.active_region_columns != remaining_regions
			var deleted_last_customer = remaining_customers == 0 and Database.active_customer_columns != remaining_customers
			if deleted_last_region or deleted_last_customer:
				cost = 0
			Database.active_region_columns = get_typed_column_count(GlobalConstants.ColumnContents.REGION)
			Database.active_customer_columns = get_typed_column_count(GlobalConstants.ColumnContents.CUSTOMER)
		_:
			Database.active_region_columns = get_typed_column_count(GlobalConstants.ColumnContents.REGION)
			Database.active_customer_columns = get_typed_column_count(GlobalConstants.ColumnContents.CUSTOMER)
	Database.set_silver_coin_count(Database.silver_coin_count - cost)
