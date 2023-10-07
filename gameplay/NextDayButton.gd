# Button to trigger going to the next in-game day.
extends Button

@onready var database = get_node("/root/Database")

func _on_NextDayButton_pressed() -> void:
	database.increment_day_count()
