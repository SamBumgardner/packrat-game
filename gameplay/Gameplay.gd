# Scene to render when the game is finished.
extends Control

@onready var database = get_node("/root/Database")

var mock_goal = 4
var mock_victory = false

func _ready():
	database.reset_values()
	_set_mock_goal()

func _on_columns_sort_children():
	$Backpack.snap_position_to_column($Columns/GameplayColumn)
	$Backpack.visible = true

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

# Temp Code to let us experiment with adding / hiding columns
func _input(event):
	if event.is_action_pressed("ui_up"):
		for column in $Columns.get_children():
			if column.visible == false:
				column.visible = true
				return
	
	if event.is_action_pressed("ui_down"):
		var reversed_column = $Columns.get_children()
		reversed_column.reverse()
		for column in reversed_column:
			if column.visible == true:
				column.visible = false
				return

