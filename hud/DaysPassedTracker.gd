extends HBoxContainer

@onready var database = get_node("/root/Database")

func _ready():
	$NumberOfDays.text = str(database.day_count)

func _process(delta):
	$NumberOfDays.text = str(database.day_count)
