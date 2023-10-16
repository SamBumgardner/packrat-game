# Scene to render when the game is finished.
extends Control

const gameplay_column_scene : PackedScene = preload("res://gameplay/column/GameplayColumn.tscn")
const backpack_scene : PackedScene = preload("res://gameplay/backpack/Backpack.tscn")
const busy_mouse_icon : Texture = preload("res://art/hourglass_icon.png")
const NO_COLUMN : int = -1

@export var starting_column_count : int = 3
@export var starting_column_types : Array[GlobalConstants.ColumnContents] = [
	GlobalConstants.ColumnContents.REGION,
	GlobalConstants.ColumnContents.NONE,
	GlobalConstants.ColumnContents.CUSTOMER
]
@export var starting_backpack_count : int = 2

@onready var database = get_node("/root/Database")

var mock_goal : int = 12
var mock_victory : bool = false

var hovered_column_index : int = NO_COLUMN
var hovered_backpack : Backpack = null
var selected_backpack : Backpack = null
var selected_backpack_home_column : GameplayColumn = null

var backpacks : Array[Backpack] = []
var columns : Array[GameplayColumn] = []

var _columns_executing_day : int = 0
var _columns_finished_day : int = 0
var _input_enabled : bool = true

##################
# INITIALIZATION #
##################
func _ready():
	database.reset_values()
	_set_mock_goal()
	for i in range(starting_column_count):
		_init_column(gameplay_column_scene.instantiate(), starting_column_types[i])
	for i in range(starting_backpack_count):
		_init_backpack(backpack_scene.instantiate() as Backpack)

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
	column.column_type = column_type
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

#####################
# NEXT DAY HANDLING #
#####################
func disable_cursor() -> void:
	Input.set_custom_mouse_cursor(busy_mouse_icon)
	_input_enabled = false
	$NextDay/NextDayButton.disabled = true

func enable_cursor() -> void:
	Input.set_custom_mouse_cursor(null)
	_input_enabled = true
	$NextDay/NextDayButton.disabled = false

func _increment_number_of_days() -> void:
	database.increment_day_count()

	if not mock_victory and database.day_count >= mock_goal:
		enable_cursor()
		get_tree().change_scene_to_file(
			"res://gameplay/game_finished/GameFinished.tscn"
		)

func _on_next_day_button_pressed() -> void:
	disable_cursor()
	_columns_executing_day = columns.size()
	for column in columns:
		column.next_day()
	_increment_number_of_days()

func _on_column_ready_for_next_day() -> void:
	_columns_finished_day += 1
	if _columns_finished_day == _columns_executing_day:
		enable_cursor()
		_columns_finished_day = 0
		_columns_executing_day = 0

func _on_timer_timeout() -> void:
	$MockExplanation/Title.visible = false

func _set_mock_goal() -> void:
	$MockExplanation/Explanation.text = (
		"Survive until day " +
		str(mock_goal) +
		" to win!"
	)

#############################
# BACKPACK CONTROL HANDLING #
#############################
func _handle_backpack_selection() -> void:
	if selected_backpack == null:
		if hovered_backpack != null:
			_select_backpack(hovered_backpack)
	else:
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

############
# UPGRADES #
############

func add_column() -> void:
	_init_column(gameplay_column_scene.instantiate(), GlobalConstants.ColumnContents.NONE)

func add_backpack() -> void:
	_init_backpack(backpack_scene.instantiate())

func modify_backpack_capacity(backpack : Backpack, change_by : int) -> void:
	backpack.change_capacity(backpack.get_max_capacity() + change_by)

func set_column_next_type(column : GameplayColumn, type : GlobalConstants.ColumnContents) -> void:
	print("set column ", column, " to change to contents type ", type, " (stubbed)")

func enter_column_change_mode(new_type : GlobalConstants.ColumnContents) -> void:
	print("entered column change mode for new_type ", new_type, " (stubbed)")

func start_remodel() -> void:
	print("started remodel, closing all columns (stubbed)")

#############
# TEMP CODE #
#############
func shift_backpack_column(backpack : Backpack, shift_by : int) -> void:
	var current_backpack_column_index = columns.size()
	var last_visible_column_index : int = -1
	for i in range(columns.size()):
		if columns[i].current_backpack == backpack:
			current_backpack_column_index = mini(
				current_backpack_column_index,
				i
			)

		if columns[i].visible:
			last_visible_column_index = i 
		else:
			break;
	
	var visible_column_count : int = last_visible_column_index + 1
	var target_column_index : int
	if current_backpack_column_index > last_visible_column_index:
		target_column_index = last_visible_column_index
	else:
		target_column_index = current_backpack_column_index + shift_by
		if target_column_index < 0:
			target_column_index += visible_column_count
		target_column_index = target_column_index % visible_column_count
	
	swap_column_backpacks(
		columns[current_backpack_column_index],
		columns[target_column_index]
	)

func swap_column_backpacks(column1 : GameplayColumn, 
		column2 : GameplayColumn) -> void:
	var swap : Backpack = column1.current_backpack
	column1.set_backpack(column2.current_backpack)
	column2.set_backpack(swap)

func _attempt_to_hide_last_column() -> void:
	var reversed_columns = $Columns.get_children()
	# Do not hide the last column if there is just one left.
	reversed_columns = reversed_columns.slice(1)
	reversed_columns.reverse()
	for column in reversed_columns:
		if column.visible:
			column.visible = false
			return

func _attempt_to_reveal_next_column() -> void:
	for column in $Columns.get_children():
		if not column.visible:
			column.visible = true
			return

func _input(event):
	if _input_enabled:
		# UPGRADES
		if event.as_text() == "A" && (event as InputEventKey).is_released():
			add_column()
		
		if event.as_text() == "S" && (event as InputEventKey).is_released():
			add_backpack()
		
		if event.as_text() == "D" && (event as InputEventKey).is_released():
			modify_backpack_capacity(backpacks[0], 1)
		
		if event.as_text() == "F" && (event as InputEventKey).is_released():
			set_column_next_type(columns[1], GlobalConstants.ColumnContents.REGION)
	
		# BACKPACK MOVEMENT
		if event.is_action_pressed("gameplay_select"):
			_handle_backpack_selection()
		
		# TOTALLY TEMP
		if event.is_action_pressed("ui_right"):
			shift_backpack_column(backpacks.front(), 1)
		
		if event.is_action_pressed("ui_left"):
			shift_backpack_column(backpacks.front(), -1)
		
		if event.is_action_pressed("ui_up"):
			_attempt_to_reveal_next_column()

		if event.is_action_pressed("ui_down"):
			_attempt_to_hide_last_column()
