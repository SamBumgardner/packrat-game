# Shared component to show the current in-game number of days passed.
extends HBoxContainer

@onready var database = get_node("/root/Database")

func _ready():
	_sync_day_count()
	database.connect("updated_day_count", _on_updated_day_count)

func _on_updated_day_count() -> void:
	_sync_day_count()

func _sync_day_count() -> void:
	$NumberOfDays.text = str(database.day_count)
