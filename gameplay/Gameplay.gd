extends Control

var day_count = 0
var mock_goal = 4
var mock_victory = false


# Called when the node enters the scene tree for the first time.
func _ready():
	_reset_number_of_days()
	_set_mock_goal()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _increment_number_of_days():
	day_count += 1
	$NextDay/DaysPassedTracker/NumberOfDays.text = str(day_count)
	
	if not mock_victory and day_count >= mock_goal:
		_show_mock_victory()

func _reset_number_of_days():
	day_count = 0
	_increment_number_of_days()

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

func _show_mock_victory():
	mock_victory = true
	$MockExplanation/Title.visible = false
	$MockExplanation/Explanation.visible = false
	$MockExplanation/Victory.visible = true
