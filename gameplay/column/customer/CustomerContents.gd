class_name CustomerContents

extends ColumnContents

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

#####################
# NEXT DAY HANDLING #
#####################
func next_day(column_backpack : Backpack) -> void:
	content_actions_complete.emit()
