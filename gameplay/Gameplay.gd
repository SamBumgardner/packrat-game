# Scene to render when the game is finished.
extends Control

@onready var database = get_node("/root/Database")

var mock_goal = 4
var mock_victory = false

@onready var columns = $Columns.get_children() as Array[GameplayColumn]
const NO_COLUMN:int = -1
var hovered_column_index:int = NO_COLUMN
var selected_backpack:Backpack = null
var selected_backpack_home_column:GameplayColumn = null

func _ready():
	database.reset_values()
	_set_mock_goal()
	_init_backpack()
	_init_columns()

func _init_columns():
	for column in columns:
		if column.current_backpack != null:
			column.set_backpack(column.current_backpack)
			column.current_backpack.visible = true
		column.connect("column_entered", _on_column_entered)
		column.connect("column_exited", _on_column_exited)

func _init_backpack():
	$Backpack.connect("backpack_selected", _on_backpack_selected)
	$Backpack.connect("backpack_released", _on_backpack_released)

func _increment_number_of_days():
	database.increment_day_count()

	if not mock_victory and database.day_count >= mock_goal:
		get_tree().change_scene_to_file(
			"res://gameplay/game_finished/GameFinished.tscn"
		)

func _on_next_day_button_pressed():
	_increment_number_of_days()

func _on_timer_timeout():
	$MockExplanation/Title.visible = false

func _set_mock_goal():
	$MockExplanation/Explanation.text = (
		"Survive until day " +
		str(mock_goal) +
		" to win!"
	)

# Handle active / inactive columns
func _on_column_entered(column_index):
	if hovered_column_index != column_index && hovered_column_index != NO_COLUMN:
		print("gameplay controller deactivating ", hovered_column_index)
	hovered_column_index = column_index
	print("gameplay controller activating ", hovered_column_index)

func _on_column_exited(column_index):
	if hovered_column_index != column_index:
		print("gameplay controller found column ", column_index, " already inactive")
	else:
		print("gameplay controller deactivating ", column_index)
		hovered_column_index = NO_COLUMN

func _on_backpack_selected(backpack:Backpack):
	selected_backpack = backpack
	backpack.reparent(self)
	for column in columns:
		if column.current_backpack == selected_backpack:
			selected_backpack_home_column = column

func _on_backpack_released():
	if hovered_column_index == NO_COLUMN:
		pass #snap backpack back to home
	else:
		move_backpack_to_column(selected_backpack, selected_backpack_home_column, columns[hovered_column_index])

# Temp Code to let us experiment with adding / hiding columns & moving backpack
func _input(event):
	if event.is_action_pressed("ui_right"):
		shift_backpack_column($Backpack, 1)
	
	if event.is_action_pressed("ui_left"):
		shift_backpack_column($Backpack, -1)
	
	if event.is_action_pressed("ui_up"):
		_attempt_to_reveal_next_column()

	if event.is_action_pressed("ui_down"):
		_attempt_to_hide_last_column()

func shift_backpack_column(backpack:Backpack, shift_by:int):
	var columns = $Columns.get_children() as Array[GameplayColumn]
	var current_backpack_column_index = columns.size()
	var last_visible_column_index = -1
	for i in range(columns.size()):
		if columns[i].current_backpack == backpack:
			current_backpack_column_index = mini(current_backpack_column_index, i)
		
		if columns[i].visible == true:
			last_visible_column_index = i 
		else:
			break;
	
	var visible_column_count = last_visible_column_index + 1
	var target_column_index:int
	if current_backpack_column_index > last_visible_column_index:
		target_column_index = last_visible_column_index
	else:
		target_column_index = current_backpack_column_index + shift_by
		if target_column_index < 0:
			target_column_index += visible_column_count
		target_column_index = target_column_index % visible_column_count
	
	move_backpack_to_column(backpack, columns[current_backpack_column_index], columns[target_column_index])

func move_backpack_to_column(backpack:Backpack, oldColumn:GameplayColumn, 
		newColumn:GameplayColumn):
	oldColumn.set_backpack(null)
	newColumn.set_backpack(backpack)

func _attempt_to_reveal_next_column():
	for column in $Columns.get_children():
		if not column.visible:
			column.visible = true
			return

func _attempt_to_hide_last_column():
	var reversed_columns = $Columns.get_children()
	reversed_columns = reversed_columns.slice(1) #Don't hide the last column if there's just one left.
	reversed_columns.reverse()
	for column in reversed_columns:
		if column.visible:
			column.visible = false
			break
	
