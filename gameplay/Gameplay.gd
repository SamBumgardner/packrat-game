# Scene to render when the game is finished.
extends Control

@onready var database = get_node("/root/Database")

var mock_goal = 4
var mock_victory = false

var _backpack_initialized = false
var _columns_ready_count = 0
var _expected_columns_initialized_count = 3

func _ready():
	database.reset_values()
	_set_mock_goal()

func _process(delta):
	if (_are_columns_rendered()):
		_backpack_initialized = true
		$Backpack.snap_position_to_column($Columns/GameplayColumn)
		$Backpack.visible = true
		
func _are_columns_rendered():
	return (
		not _backpack_initialized
		and _columns_ready_count == _expected_columns_initialized_count
	)

func _increment_columns_ready_count():
	_columns_ready_count += 1

func _increment_number_of_days():
	database.increment_day_count()

	if not mock_victory and database.day_count >= mock_goal:
		get_tree().change_scene_to_file(
			"res://gameplay/game_finished/GameFinished.tscn"
		)

func _on_gameplay_column_ready():
	_increment_columns_ready_count()

func _on_gameplay_column_2_ready():
	_increment_columns_ready_count()

func _on_gameplay_column_3_ready():
	_increment_columns_ready_count()

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
