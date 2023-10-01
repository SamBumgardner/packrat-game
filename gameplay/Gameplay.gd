extends Control

var day_count = 0


# Called when the node enters the scene tree for the first time.
func _ready():
	day_count = 0
	_increment_number_of_days()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _increment_number_of_days():
	day_count += 1
	$NextDay/DaysPassedTracker/NumberOfDays.text = str(day_count)

func _on_next_day_button_pressed():
	_increment_number_of_days()
